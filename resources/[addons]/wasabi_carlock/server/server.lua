-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
VehicleKeys, SearchedVehicles, FailedHotwire, HotwiredVehicles = {}, {}, {}, {}

RegisterServerEvent('wasabi_carlock:updateVehicle')
AddEventHandler('wasabi_carlock:updateVehicle', function(_plate, update, target)
    local plate = Trim(_plate)
    if update == 'hotwired' then
        HotwiredVehicles[plate] = true
    elseif update == 'failed' then
        if not FailedHotwire[plate] then
            FailedHotwire[plate] = 1
        else
            FailedHotwire[plate] = FailedHotwire[plate] + 1
        end
    elseif update == 'searched' then
        SearchedVehicles[plate] = true
    else
        local identifier
        if target then
            identifier = GetIdentifier(target)
        else
            identifier = GetIdentifier(source)
        end
        while not identifier do Wait() end
        if update == 'add' then
            if not VehicleKeys[identifier] then VehicleKeys[identifier] = {} end
            VehicleKeys[identifier][plate] = true
            TriggerClientEvent('wasabi_carlock:notify', (target or source), Strings.keys_received, (Strings.keys_received_desc):format(plate), 'success', 'key')
        elseif update == 'remove' then
            if not VehicleKeys[identifier] then return end
            TriggerClientEvent('wasabi_carlock:notify', (target or source), Strings.keys_removed, (Strings.keys_removed_desc):format(plate), 'error', 'key')
            VehicleKeys[identifier][plate] = nil
        end
    end
end)

RegisterServerEvent('wasabi_carlock:updateVehicleOwner')
AddEventHandler('wasabi_carlock:updateVehicleOwner', function(_plate, update, target)
    local plate = Trim(_plate)
    if update == 'hotwired' then
        HotwiredVehicles[plate] = true
    elseif update == 'failed' then
        if not FailedHotwire[plate] then
            FailedHotwire[plate] = 1
        else
            FailedHotwire[plate] = FailedHotwire[plate] + 1
        end
    elseif update == 'searched' then
        SearchedVehicles[plate] = true
    else
        local identifier
        if target then
            identifier = GetIdentifier(target)
        else
            identifier = GetIdentifier(source)
        end
        while not identifier do 
            Wait() 
        end
        if update == 'add' then
            if not VehicleKeys[identifier] then VehicleKeys[identifier] = {} end
            VehicleKeys[identifier][plate] = true
            TriggerClientEvent('wasabi_carlock:notify', (target or source), Strings.keys_received, (Strings.keys_received_desc):format(plate), 'success', 'key')

            -- update the owner of the vehicle in the database
            MySQL.Async.execute('UPDATE owned_vehicles SET owner = @owner WHERE plate = @plate', {
                ['@owner'] = identifier,
                ['@plate'] = plate
            }, function(rowsChanged)
                print(('wasabi_carlock: %s updated the owner of the vehicle with plate %s to %s'):format(GetName(source), plate, owner))
            end)
        elseif update == 'remove' then
            if not VehicleKeys[identifier] then return end
            TriggerClientEvent('wasabi_carlock:notify', (target or source), Strings.keys_removed, (Strings.keys_removed_desc):format(plate), 'error', 'key')
            VehicleKeys[identifier][plate] = nil
            RemoveItem(source, 'contrat', 1)
        end
    end
end)

RegisterServerEvent('wasabi_lockpick:breakLockpick')
AddEventHandler('wasabi_lockpick:breakLockpick', function()
    RemoveItem(source, Config.lockpick.item, 1)
end)

-- Export functions
function HasKey(plate, target)
    local identifier = GetIdentifier(source)
    if not identifier then return false end
    if VehicleKeys?[identifier]?[plate] then
        return true
    else
        return false
    end
end

exports('HasKey', HasKey)

function GiveKeys(plate, target)
    if not plate or not target then return end
    TriggerEvent('wasabi_carlock:updateVehicle', plate, 'add', target)
end

exports('GiveKeys', GiveKeys)

function RemoveKeys(plate, target)
    if not plate or not target then return end
    TriggerEvent('wasabi_carlock:updateVehicle', plate, 'remove', target)
end

exports('RemoveKeys', RemoveKeys)

-- Callbacks
lib.callback.register('wasabi_carlock:searchVehicle', function(source, plate)
    local reward = Config.searchingVehicle.rewards[math.random(#Config.searchingVehicle.rewards)]
    if reward.chance >= math.random(1,100) then
        if reward.type == 'key' then
            GiveKeys(plate, source)
        elseif reward.type == 'account'then
            AddMoney(source, reward.name, reward.quantity)
        elseif reward.type == 'item' then
            AddItem(source, reward.name, reward.quantity)
        end
        return reward
    else
        return false
    end
end)

lib.callback.register('wasabi_carlock:useLockpick', function(source)
    if HasItem(source, Config.lockpick.item) < 1 then return false end
    local randomInt = math.random(0,100)
    if Config.lockpick.chanceOfLoss >= randomInt then
        RemoveItem(source, Config.lockpick.item, 1)
        return 'removed'
    else
        return true
    end
end)

lib.callback.register('wasabi_carlock:getPlayerData', function(source, data)
    local newData
    for i=1, #data do
        if not newData then newData = {} end
        local player = GetPlayer(data[i].id)
        if player then
            newData[#newData + 1] = {
                id = data[i].id,
                name = GetName(data[i].id),
            }
        end
    end
    while not #newData == #data do Wait() end
    return newData
end)

lib.callback.register('wasabi_carlock:hasKey', function(source, plate, target)
    local identifier = GetIdentifier(target or source)
    if not identifier then return end
    if VehicleKeys?[identifier]?[plate] then
        return true
    end
end)

lib.callback.register('wasabi_carlock:getVehInfo', function(source, plate)
    local data = {
        searched = (SearchedVehicles[plate] or false),
        failedHotwire = (FailedHotwire[plate] or false),
        hotwired = (HotwiredVehicles[plate] or false)
    }
    return data
end)

-- Usable items
if Config.lockpick.enabled then
    CreateThread(function()
        while not Framework do Wait() end
        RegisterUsableItem(Config.lockpick.item, function(source)
            TriggerClientEvent('wasabi_carlock:lockpickVehicle', source)
        end)
    end)
end


CreateThread(function()
    while not Framework do Wait() end
    RegisterUsableItem('contrat', function(source)
        local vehicleList = {}
        -- Ont récupère les véhicule de la personne dans la table owned_vehicles
        MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {
            ['@owner'] = GetIdentifier(source)
        }, function(result)
            -- On envoie les véhicules à la personne
            for i=1, #result do
                vehicleList[#vehicleList + 1] = {
                    plate = result[i].plate,
                }
            end
            
            TriggerClientEvent('wasabi_carlock:giveCarVehicle', source, vehicleList)
        end)

    end)
end)
