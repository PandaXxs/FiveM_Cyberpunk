CreateThread(function()
    for k,v in pairs(Config.Locations) do
        CreateThread(function() 
            local ped, pedSpawned = nil, {}
            while true do
                local sleep = 1500
                local playerPed = cache.ped
                local coords = GetEntityCoords(playerPed)
                for j, l in pairs(v.News) do
                    local dist = #(vector3(coords.x, coords.y, coords.z) - vector3(l.pedPos.x, l.pedPos.y, l.pedPos.z))
                    -- si la dist est de 30 et que le ped n'est pas spawn
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
                            newsMenu(j)
                            sleep = 1500
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
        for j, l in pairs(v.News) do
            if l.blip then
                CreateBlip(l.pedPos, l.blip.sprite, l.blip.color, l.blip.label, l.blip.scale)
            end
        end
    end
end)

newsMenu = function(station)

    local data = Config.Locations.ProjectRP.News[station]

    local Options = {}


    local price = data.price and data.price..'$' or 'Gratuit'

    Options[#Options + 1] = {
        title = 'Passer une annonce',
        description = price..' $',
        icon = 'fas fa-newspaper',
        arrow = true,
        event = 'projectrpUtils:Announce',
        args = { station = station, price = data.price }
    }
    
    lib.registerContext({
        id = 'news_menu',
        title = 'Annonce',
        onExit = function()
            inMenu = false
        end,
        options = Options
    })
    lib.showContext('news_menu')
end

AddEventHandler('projectrpUtils:Announce', function(data)
    inMenu = false

    local input = lib.inputDialog("Annonce", {"Votre annonce"})
    if not input then return end

    TriggerServerEvent('projectrpUtils:pay', data.price)
    TriggerServerEvent('projectrpUtils:sendAnnounce', 'Annonce', input[1], 'center-left', '#DFC7FF', '#FEFEFE', 'fas fa-newspaper', '#FEFEFE', 10000, -1)
end)