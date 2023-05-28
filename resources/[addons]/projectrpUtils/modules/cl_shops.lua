CreateThread(function()
    for k,v in pairs(Config.Locations) do
        CreateThread(function() 
            local ped, pedSpawned = nil, {}
            while true do
                local sleep = 1500
                local playerPed = cache.ped
                local coords = GetEntityCoords(playerPed)
                for j, l in pairs(v.Shops) do
                    local dist = #(vector3(coords.x, coords.y, coords.z) - vector3(l.pedPos.x, l.pedPos.y, l.pedPos.z))
                    if dist <= 30 and not pedSpawned[j] then
                        lib.requestAnimDict('mini@strip_club@idles@bouncer@base', 100)
                        lib.requestModel(l.ped, 100)
                        ped = CreatePed(28, l.ped, l.pedPos.x, l.pedPos.y, l.pedPos.z-1.0, l.pedHeading, false, false)
                        FreezeEntityPosition(ped, true)
                        SetEntityInvincible(ped, true)
                        SetBlockingOfNonTemporaryEvents(ped, true)
                        TaskPlayAnim(ped, 'mini@strip_club@idles@bouncer@base', 'base', 8.0, 0.0, -1, 1, 0, 0, 0, 0)
                        pedSpawned[j] = true
                    elseif dist <= 2.5 then
                        sleep = 0
                        floatTxt(l.uiMessage, vector3(l.pedPos.x, l.pedPos.y, l.pedPos.z+1.0))
                        if IsControlJustReleased(0, 38) then
                            if l.job then 
                                if not HasGroup(l.job) then 
                                    TriggerEvent("projectrpUtils:notify", "Magasin", "Vous n\'avez pas le métier requis pour accéder à ce magasin !", "error")
                                else             
                                    shopMenu(j)
                                    sleep = 1500
                                end
                            else
                                shopMenu(j)
                                sleep = 1500
                            end
                        end
                    elseif dist >= 31 and pedSpawned[j] then
                        local model = GetEntityModel(ped)
                        SetModelAsNoLongerNeeded(model)
                        DeletePed(ped)
                        SetPedAsNoLongerNeeded(ped)
                        RemoveAnimDict('mini@strip_club@idles@bouncer@base')
                        pedSpawned[j] = nil
                    end
                    if dist <= 8 then
                        sleep = 0
                        Draw3DText(l.pedPos.x, l.pedPos.y, l.pedPos.z+1.0, 0.4, l.pedLabel)
                    end
                end
                Wait(sleep)
            end
        end)
    end
end)

CreateThread(function() 
    for k, v in pairs(Config.Locations) do
        for j, l in pairs(v.Shops) do
            if l.blip then
                if l.job then 
                    if HasGroup(l.job) then 
                        CreateBlip(l.pedPos, l.blip.sprite, l.blip.color, l.blip.label, l.blip.scale)
                    end
                else
                    CreateBlip(l.pedPos, l.blip.sprite, l.blip.color, l.blip.label, l.blip.scale)
                end
            end
        end
    end
end)

shopMenu = function(station)

    local data = Config.Locations.ProjectRP.Shops[station].items

    local Options = {}
    for k,v in pairs(data) do

        local price = v.price and v.price..'$' or 'Gratuit'

        Options[#Options + 1] = {
            title = v.label,
            description = price,
            icon = 'box',
            arrow = true,
            event = 'projectrpUtils:buyItem',
            args = { station = station, price = v.price, item = v.name, label = v.label, multiple = v.multiple }
        }
    end
    lib.registerContext({
        id = 'shop_menu',
        title = 'Magasin',
        onExit = function()
            inMenu = false
        end,
        options = Options
    })
    lib.showContext('shop_menu')
end

AddEventHandler('projectrpUtils:buyItem', function(data)
    inMenu = false

    if data.multiple then
        local amount = lib.inputDialog("Quantité", {"Combien d\'item voulez-vous acheter ?"})
        if not amount then return end

        if amount then
            TriggerServerEvent('projectrpUtils:giveItem', data.item, data.label, amount[1], math.floor(tonumber(data.price * amount[1])))
            TriggerServerEvent('projectrpUtils:pay', math.floor(tonumber(data.price * amount[1])))
        end
        return
    end

    TriggerServerEvent('projectrpUtils:giveItem', data.item, data.label, 1, math.floor(tonumber(data.price))) 
    TriggerServerEvent('projectrpUtils:pay', math.floor(tonumber(data.price)))

end)