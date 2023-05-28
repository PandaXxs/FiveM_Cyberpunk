ESX = exports.es_extended:getSharedObject()

Harvesting = {}

CreateThread(
    function()
        updatePlants()
    end
)

function GetPlayer(source)
    return ESX.GetPlayerFromId(source)
end

function GetPlayers()
    return ESX.GetPlayers()
end

function HasItem(source, item)
    local player = GetPlayer(source)
    local item = player.getInventoryItem(item)
    if item ~= nil then
        return item.count
    else
        return 0
    end
end

ESX.RegisterServerCallback(
    "core_drugs:getInventoryItems",
    function(source, cb)
        local Player = GetPlayer(source)
        local items = Player.inventory
        local items2 = {}
        for k, v in pairs(items) do
            if v.count > 0 then
                table.insert(items2, {name = v.name, label = v.label, count = v.count})
            end
        end

        cb(items2)
    end
)

function updatePlants()
    Citizen.SetTimeout(
        Config.GlobalGrowthRate * 1000,
        function()
            updatePlants()
        end
    )

    --DEAD PLANTS
    MySQL.Async.fetchAll(
        "SELECT id FROM plants WHERE (water < 2 OR food < 2) AND rate > 0",
        {},
        function(info)
            for _, v in ipairs(info) do
                MySQL.Async.execute(
                    "UPDATE `plants` SET `rate` = @rate, `food` = @food, `water` = @water WHERE id = @id",
                    {["@id"] = v.id, ["@rate"] = 0, ["@food"] = 0, ["@water"] = 0},
                    function()
                    end
                )
            end
        end
    )

    -- ALIVE PLANT REDUCTION
    MySQL.Async.execute(
        "UPDATE `plants` SET `growth`=`growth` + (0.01 * `rate`) , `food` = `food` - (0.02 * `rate`), `water` = `water` -  (0.02 * `rate`) WHERE (water >= 2 OR food >= 2) AND (growth <= 100 - (0.01 * `rate`) )",
        {},
        function()
            TriggerClientEvent("core_drugs:growthUpdate", -1)
        end
    )

    -- GROW PLANTS
    MySQL.Async.fetchAll(
        "SELECT id, growth FROM plants WHERE (growth >= 30 AND growth <= 31) OR (growth >= 80 AND growth <= 81)",
        {},
        function(info)
            for _, v in ipairs(info) do
                TriggerClientEvent("core_drugs:growPlant", -1, v.id, v.growth)
            end
        end
    )
end

function proccesing(player, type)
    TriggerClientEvent("core_drugs:process", player, type)
end

function plant(player, type)
    TriggerClientEvent("core_drugs:plant", player, type)
end

function drug(player, type)
    TriggerClientEvent("core_drugs:drug", player, type)
end

function addProcess(type, coords, rot)
    MySQL.Async.insert(
        "INSERT INTO processing (type, item, time, coords, rot) VALUES (@type, @item, @time, @coords, @rot)",
        {
            ["@coords"] = json.encode({x = coords[1], y = coords[2], z = coords[3]}),
            ["@type"] = type,
            ["@item"] = "{}",
            ["@time"] = 0,
            ["@rot"] = rot
        },
        function(id)
            
 MySQL.Async.fetchScalar(
        "SELECT id FROM processing WHERE coords = @coords",
        {["@coords"] = json.encode({x = coords[1], y = coords[2], z = coords[3]})},
        function(retid)
         TriggerClientEvent("core_drugs:addProcess", -1, type, coords, id, retid)
              
        end
    )

           
        end
    )
end

function addPlant(type, coords, id)
    local rate = Config.DefaultRate
    local zone = nil

    for _, v in ipairs(Config.Zones) do
        if #(v.Coords - coords) < v.Radius then
            local contains = false
            for _, g in ipairs(v.Exclusive) do
                if g == type then
                    contains = true
                end
            end

            if contains then
                rate = v.GrowthRate
                zone = v
            end
        end
    end

    if Config.OnlyZones then
        if zone == nil then
            TriggerClientEvent("core_drugs:sendMessage", id, Config.Text["cant_plant"])
            return
        end
    end

    MySQL.Async.insert(
        "INSERT INTO plants (coords, type, growth, rate,water,food) VALUES (@coords, @type, @growth, @rate, @water, @food)",
        {
            ["@coords"] = json.encode({x = coords[1], y = coords[2], z = coords[3]}),
            ["@type"] = type,
            ["@growth"] = 0,
            ["@rate"] = rate,
            ["@food"] = 10,
            ["@water"] = 10
        },
        function(id)

             MySQL.Async.fetchScalar(
        "SELECT id FROM plants WHERE coords = @coords",
        {["@coords"] = json.encode({x = coords[1], y = coords[2], z = coords[3]})},
        function(retid)
        TriggerClientEvent("core_drugs:addPlant", -1, type, coords, retid)
              
        end
    )

            
        end
    )
end

RegisterServerEvent("core_drugs:addPlant")
AddEventHandler(
    "core_drugs:addPlant",
    function(type, coords)
        local Player = ESX.GetPlayerFromId(source)
        addPlant(type, coords, source)

        Player.removeInventoryItem(type, 1)
    end
)

RegisterServerEvent("core_drugs:processed")
AddEventHandler(
    "core_drugs:processed",
    function(type, amount)
        local Player = GetPlayer(source)
        local table = Config.ProcessingTables[type]

        if Config.WeightSystem then
            if Player.canCarryItem(table.Item, amount) then
                for k, v in pairs(table.Ingrediants) do
                    if HasItem(source, k) < math.floor(tonumber(v * amount)) then
                        TriggerClientEvent("core_drugs:sendMessage", source, Config.Text["missing_ingrediants"])
                        return
                    else
                        Player.removeInventoryItem(k, v * amount)
                    end
                end

                Player.addInventoryItem(table.Item, amount)
            else
                TriggerClientEvent("core_drugs:sendMessage", source, Config.Text["cant_hold"])
            end
        else
            if Player.getInventoryItem(table.Item).limit >= (Player.getInventoryItem(table.Item).count + 1) then
                for k, v in pairs(table.Ingrediants) do
                    if Player.getInventoryItem(k).count < v then
                        TriggerClientEvent("core_drugs:sendMessage", source, Config.Text["missing_ingrediants"])
                        return
                    else
                        Player.removeInventoryItem(k, v * amount)
                    end
                end

                Player.addInventoryItem(table.Item, amount)
            else
                TriggerClientEvent("core_drugs:sendMessage", source, Config.Text["cant_hold"])
            end
        end
    end
)

RegisterServerEvent("core_drugs:addProcess")
AddEventHandler(
    "core_drugs:addProcess",
    function(type, coords, rot)
        local Player = ESX.GetPlayerFromId(source)
        addProcess(type, coords, rot)

        Player.removeInventoryItem(type, 1)
    end
)

RegisterServerEvent("core_drugs:tableStatus")
AddEventHandler(
    "core_drugs:tableStatus",
    function(id, status)
        TriggerClientEvent("core_drugs:changeTableStatus", -1, id, status)
    end
)

RegisterServerEvent("core_drugs:removeItem")
AddEventHandler(
    "core_drugs:removeItem",
    function(item, count)
        local Player = ESX.GetPlayerFromId(source)

        Player.removeInventoryItem(item, count)
    end
)

RegisterServerEvent("core_drugs:sellDrugs")
AddEventHandler(
    "core_drugs:sellDrugs",
    function(prices)
        local Player = ESX.GetPlayerFromId(source)

        local inventory = Player.getInventory(true)
        local pay = 0

        for k, v in pairs(prices) do
            if inventory[k] then
                pay = pay + (v * inventory[k])
                Player.removeInventoryItem(k, inventory[k])
            end
        end

        if pay > 0 then
            Player.addMoney(pay)
            TriggerClientEvent("core_drugs:sendMessage", source, Config.Text["sold_dealer"] .. pay)
        else
            TriggerClientEvent("core_drugs:sendMessage", source, Config.Text["no_drugs"])
        end
    end
)

RegisterServerEvent("core_drugs:deletePlant")
AddEventHandler(
    "core_drugs:deletePlant",
    function(id)
        MySQL.Async.execute(
            "DELETE FROM plants WHERE id = @id",
            {["@id"] = id},
            function()
            end
        )
        TriggerClientEvent('core_drugs:deletePlant', -1, id)
    end
)


RegisterServerEvent("core_drugs:deleteTable")
AddEventHandler(
    "core_drugs:deleteTable",
    function(id, type)
        local Player = ESX.GetPlayerFromId(source)

        MySQL.Async.execute(
            "DELETE FROM processing WHERE id = @id",
            {["@id"] = id},
            function()
            end
        )

        Player.addInventoryItem(type, 1)
         TriggerClientEvent('core_drugs:deleteProcessing', -1, id)
    end
)

RegisterServerEvent("core_drugs:updatePlant")
AddEventHandler(
    "core_drugs:updatePlant",
    function(id, info)
        MySQL.Async.execute(
            "UPDATE `plants` SET `growth`=@growth, `rate` = @rate, `food` = @food, `water` = @water WHERE id = @id",
            {
                ["@id"] = id,
                ["@growth"] = info.growth,
                ["@rate"] = info.rate,
                ["@food"] = info.food,
                ["@water"] = info.water
            },
            function()
            end
        )
    end
)

RegisterServerEvent("core_drugs:harvest")
AddEventHandler(
    "core_drugs:harvest",
    function(type, info)
        local src = source
        local typeInfo = Config.Plants[type]
        local Player = ESX.GetPlayerFromId(src)

        local val = typeInfo.Amount * tonumber(info.growth) / 100
        val = math.floor(val + 0.5)

        if info.growth < 20 then
            val = 0
        end

        if (typeInfo.SeedChance >= math.random(1, 100)) then
            Player.addInventoryItem(type, 1)
        end

        

        Player.addInventoryItem(typeInfo.Produce, val)

        
    end
)

RegisterServerEvent("core_drugs:harvested")
AddEventHandler(
    "core_drugs:harvested",
    function(id)
        Harvesting[id] = nil
    end
)

ESX.RegisterServerCallback(
    "core_drugs:canHarvest",
    function(source, cb, id)

        if not Harvesting[id] then
        Harvesting[id] = true
        cb(true)

        else
        cb(false)
        end

    end)

ESX.RegisterServerCallback(
    "core_drugs:getInfo",
    function(source, cb)
        MySQL.Async.fetchAll(
            "SELECT * FROM plants WHERE 1",
            {},
            function(infoPlants)
                MySQL.Async.fetchAll(
                    "SELECT * FROM processing WHERE 1",
                    {},
                    function(infoProcess)
                        local plants = {}
                        local process = {}

                        for _, v in ipairs(infoPlants) do
                            local coords = json.decode(v.coords) or {x = 0, y = 0, z = 0}
                            local data = {growth = v.growth, rate = v.rate, water = v.water, food = v.food}
                            coords = vector3(coords.x, coords.y, coords.z)

                            plants[v.id] = {type = v.type, coords = coords, info = data}
                        end

                        for _, g in ipairs(infoProcess) do
                            local coords = json.decode(g.coords) or {x = 0, y = 0, z = 0}
                            local data = json.decode(g.item) or {}
                            coords = vector3(coords.x, coords.y, coords.z)

                            process[g.id] = {
                                type = g.type,
                                coords = coords,
                                item = data,
                                time = g.time,
                                rot = g.rot,
                                usable = true
                            }
                        end

                        cb(plants, process)
                    end
                )
            end
        )
    end
)

ESX.RegisterServerCallback(
    "core_drugs:getPlant",
    function(source, cb, id)
        MySQL.Async.fetchAll(
            "SELECT growth,rate,food,water FROM plants WHERE id = @id LIMIT 1",
            {["@id"] = id},
            function(info)
                local data = {growth = info[1].growth, rate = info[1].rate, water = info[1].water, food = info[1].food}

                cb(data)
            end
        )
    end
)
