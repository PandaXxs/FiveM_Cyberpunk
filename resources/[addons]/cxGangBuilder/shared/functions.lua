function input(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, "", inputText, "", "", "", maxLength)
	blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
		blockinput = false
        return result
    else
        Citizen.Wait(500)
		blockinput = false
        return nil
    end
end

function coloredValue(args)
    if args == nil then return end 
    return ("~%s~%s~s~"):format("b", args)
end

function checkGrades()
    if #gangs.grades == GangBuilder.GradeLimit then 
        return false 
    end
    return true 
end

function valid(name, label)
    if name ~= "A définir" and label ~= "A définir" then 
        return true 
    end
    return false 
end

function checkComplete()
    if gangs.name ~= nil and gangs.label ~= nil and #gangs.grades >= 1 and #gangs.vehicles >= 1 then 
        return true 
    end
    return false 
end

function checkVehicles()
    if #gangs.vehicles == GangBuilder.VehicleLimit then 
        return false 
    end
    return true 
end

function getLabelId(positionId)
    if positionId == "stored" then 
        return "Rangement véhicule"
    elseif positionId == "garage" then 
        return "Garage"
    elseif positionId == "storage" then 
        return "Stockage"
    elseif positionId == "gestion" then 
        return "Gestion Gang"
    end
end

function showPoints(bool)
    if not bool then return end 
    if gangs.positions["storage"] then 
        DrawMarker(22, gangs.positions["storage"], 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, 44, 233, 65, 255, 1, 0, 0, 1, 0, 0, 0)
    end
    if gangs.positions["gestion"] then 
        DrawMarker(22, gangs.positions["gestion"], 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, 93, 220, 254, 255, 1, 0, 0, 1, 0, 0, 0)
    end
    if gangs.positions["garage"] then 
        DrawMarker(22, gangs.positions["garage"], 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, 169, 93, 254, 255, 1, 0, 0, 1, 0, 0, 0)
    end
    if gangs.positions["stored"] then 
        DrawMarker(22, gangs.positions["stored"], 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, 254, 218, 93, 255, 1, 0, 0, 1, 0, 0, 0)
    end
    if gangs.positions["spawn"] then 
        DrawMarker(22, vector3(gangs.positions["spawn"].x, gangs.positions["spawn"].y, gangs.positions["spawn"].z), 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, 254, 122, 93, 255, 1, 0, 0, 1, 0, 0, 0)
    end
end

function checkInput(value)
    value = string.lower(value)
    for _, vehicleModel in pairs(GangBuilder.BlackListVehicles) do 
        if value == vehicleModel then 
            return true 
        end
    end
    return false 
end

function checkLabel(vehicleModel)
    return GetLabelText(GetDisplayNameFromVehicleModel(vehicleModel))
end

function vehicleCheck(model)
    local props = nil 
    ESX.Game.SpawnVehicle(model, vector3(GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y,  GetEntityCoords(PlayerPedId()).z-50.0), 0.0, function(vehicle) 
        props = ESX.Game.GetVehicleProperties(vehicle)
        DeleteVehicle(vehicle)
    end)
    while props == nil do 
        Wait(100)
    end
    return props
end

function spawnVehicle(vehicleProps, gangId)
    local pos = Gangs[gangId].positions["spawn"]
    ESX.Game.SpawnVehicle(vehicleProps.model, vector3(pos.x, pos.y, pos.z), pos.h, function(vehicle) 
        ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
        SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
        TriggerServerEvent("cxGangBuilder:store", "exit", vehicleProps, gangId)
        ESX.ShowNotification(("Vous avez sortie votre\n~b~%s~s~."):format(checkLabel(vehicleProps.model)))
    end)
    garageMenu.Closed()
end

gangsBlips = {}

function gangBlips()
    for blipId, blip in pairs(gangsBlips) do 
        RemoveBlip(gangsBlips[blipId])
    end 
    Wait(120)
    for _,v in pairs(Gangs) do 
        if v.blips.show == true then 
            v.blip = AddBlipForCoord(v.blips.position.x, v.blips.position.y, v.blips.position.z)
            SetBlipSprite(v.blip, tonumber(v.blips.sprite))
            SetBlipDisplay(v.blip, 4)
            SetBlipScale(v.blip, tonumber(v.blips.scale))
            SetBlipColour(v.blip, tonumber(v.blips.color))
            SetBlipAsShortRange(v.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.blips.name)
            EndTextCommandSetBlipName(v.blip)
            gangsBlips[#gangsBlips + 1] = v.blip 
        elseif v.blips.show == false then 
            if playerData.job2.name == v.name then 
                v.blip = AddBlipForCoord(v.blips.position.x, v.blips.position.y, v.blips.position.z)
                SetBlipSprite(v.blip, tonumber(v.blips.sprite))
                SetBlipDisplay(v.blip, 4)
                SetBlipScale(v.blip, tonumber(v.blips.scale))
                SetBlipColour(v.blip, tonumber(v.blips.color))
                SetBlipAsShortRange(v.blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(v.blips.name)
                EndTextCommandSetBlipName(v.blip)
                gangsBlips[#gangsBlips + 1] = v.blip 
            end
        end
    end
end

function checkInventory()
    local counter = 0 
    for _, item in pairs(ESX.GetPlayerData().inventory) do 
        if item.count >= 1 then 
            counter = counter + 1 
        end
    end
    return counter 
end

function getDataGrade(data)
    local newData = {}
    for k,v in pairs(data) do 
        newData[v.grade] = v 
    end
    return newData 
end 

function getPermGrade(gangId, gradeId)
    for k,v in pairs(Gangs[gangId].perms) do 
        if gradeId == k then 
            return v 
        end
    end
end

function getMoneyValue(type, value)
    local colors = {
        ["black_money"] = "r",
        ["money"] = "g"
    }
    return ("~%s~%s $"):format(colors[type], value)
end

function getGradeListing(data, gradeId, type)
    local value = {}
    for k,v in pairs(data) do 
        if type == 1 then 
            if v.grade < gradeId then 
                value[k] = v 
            end
        elseif type == 2 then 
            if v.grade > gradeId then 
                value[k] = v 
            end
        end
    end
    return value 
end

function getAccountLabel(account)
    if account == "money" then 
        return "Argent liquide"
    elseif account == "black_money" then 
        return "Argent sale"
    end
end

function createMarker(playerId)
    local playerCoords = GetEntityCoords(GetPlayerPed(playerId))
    DrawMarker(22, playerCoords.x, playerCoords.y, playerCoords.z+1.1, 0, 0, 0, 0, 0, 0, 0.25,0.25, 0.25, 169, 23, 23, 255, 1, 0, 0, 2)
end

RegisterNetEvent("cxGangBuilder:deleteVeh")
AddEventHandler("cxGangBuilder:deleteVeh", function()
    local currentVeh, currentEntity = ESX.Game.GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId(), false)), GetVehiclePedIsIn(PlayerPedId(), false)
    if DoesEntityExist(currentEntity) then 
        ESX.ShowNotification(("Vous avez rangé votre\n~b~%s~s~."):format(checkLabel(currentVeh.model)))
        DeleteEntity(currentEntity)
    end
end)

isHandcuffed, isDragged = false, false 

RegisterNetEvent("cxGangBuilder:handCuffPlayer")
AddEventHandler("cxGangBuilder:handCuffPlayer", function()
    isHandcuffed = not isHandcuffed
    CreateThread(function()
        if isHandcuffed then
            RequestAnimDict('mp_arresting')
            while not HasAnimDictLoaded('mp_arresting') do
                Wait(100)
            end
            TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
            DisableControlAction(2, 37, true)
            SetEnableHandcuffs(PlayerPedId(), true)
            SetPedCanPlayGestureAnims(PlayerPedId(), false)
            FreezeEntityPosition(PlayerPedId(),  true)
            DisableControlAction(0, 24, true) 
            DisableControlAction(0, 257, true) 
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 263, true) 
            DisableControlAction(0, 37, true) 
            DisableControlAction(0, 47, true)  
            DisplayRadar(false)
        else
            ClearPedSecondaryTask(PlayerPedId())
            SetEnableHandcuffs(PlayerPedId(), false)
            SetPedCanPlayGestureAnims(PlayerPedId(),  true)
            FreezeEntityPosition(PlayerPedId(), false)
            DisplayRadar(true)
        end
    end)
end)

RegisterNetEvent("cxGangBuilder:dragPlayer")
AddEventHandler("cxGangBuilder:dragPlayer", function(otherPlayer)
    isDragged = not isDragged
    CreateThread(function()
        while true do
            if isHandcuffed then
                if isDragged then
                    AttachEntityToEntity(PlayerPedId(), GetPlayerPed(GetPlayerFromServerId(otherPlayer)), 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                else
                    DetachEntity(PlayerPedId(), true, false)
                    break
                end
            end
            Wait(1)
        end
    end)
end)