playerData = {}
Gangs = {}

CreateThread(function()
    ESX = exports["es_extended"]:getSharedObject()
    Wait(10)
    while ESX.GetPlayerData().job2 == nil do
        Wait(10)
    end
    playerData = ESX.GetPlayerData()
    menuIsOpen, showCheck, gangs, blipCheck = false, false, {grades = {}, positions = {}, vehicles = {}, blips = {position = nil, name = nil, sprite = nil, color = nil, scale = nil, show = true}}, true 
end) 

RegisterNetEvent("cxGangBuilder:refresh")
AddEventHandler("cxGangBuilder:refresh", function(gangsData)
    Gangs = gangsData
    gangBlips()
end)

RegisterNetEvent("esx:setJob2")
AddEventHandler("esx:setJob2", function(job)
    playerData.job2 = job 
    gangBlips()
end)

CreateThread(function()
    while true do 
        local onMarker = false 
        local pCoords = GetEntityCoords(PlayerPedId())
        for gangId, gang in pairs(Gangs) do 
            for positionId, b in pairs(gang.positions) do 
                if playerData.job2 ~= nil then 
                    if (playerData.job2.name == gang.name) then 
                        local markers = GangBuilder.Markers[positionId]
                        if positionId ~= "spawn" then
                            if not IsPedSittingInAnyVehicle(PlayerPedId()) then 
                                if #(pCoords - vector3(b.x, b.y, b.z)) < 15.0 then
                                    onMarker = true 
                                    DrawMarker(markers.type, vector3(b.x, b.y, b.z), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, markers.size, markers.size, markers.size, markers.colour[1], markers.colour[2], markers.colour[3], markers.opacity, 1, 0, 0, 1, 0, 0, 0)
                                end 
                                if #(pCoords - vector3(b.x, b.y, b.z)) < 1.8 then
                                    ESX.ShowHelpNotification(("Appuyez sur ~INPUT_CONTEXT~ pour intéragir avec le : ~b~%s~s~."):format(getLabelId(positionId)))
                                    if IsControlJustPressed(1, 51) then 
                                        TriggerServerEvent("cxGangBuilder:getMenu", gangId, positionId)
                                    end
                                end 
                            elseif positionId == "stored" then 
                                if #(pCoords - vector3(b.x, b.y, b.z)) < 15.0 then
                                    onMarker = true 
                                    DrawMarker(markers.type, vector3(b.x, b.y, b.z), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, markers.size, markers.size, markers.size, markers.colour[1], markers.colour[2], markers.colour[3], markers.opacity, 1, 0, 0, 1, 0, 0, 0)
                                end 
                                if #(pCoords - vector3(b.x, b.y, b.z)) < 1.8 then
                                    ESX.ShowHelpNotification(("Appuyez sur ~INPUT_CONTEXT~ pour intéragir avec le : ~b~%s~s~."):format(getLabelId(positionId)))
                                    if IsControlJustPressed(1, 51) then 
                                        if not IsPedSittingInAnyVehicle(PlayerPedId()) then 
                                            ESX.ShowNotification("~r~Vous n'êtes pas dans un véhicule.") 
                                        else
                                            local vehicleProps = ESX.Game.GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId(), false))
                                            TriggerServerEvent("cxGangBuilder:store", "store", vehicleProps, gangId)
                                        end
                                    end
                                end 
                            end
                        end
                    end
                end
                
            end
        end
        if onMarker then 
            Wait(1)
        else
            Wait(500)
        end
    end
end)

builderMenu = RageUI.CreateMenu("GangBuilder", "Intéractions disponibles")
builderCreateMenu = RageUI.CreateSubMenu(builderMenu, "GangBuilder", "Champs à remplir")
builderEditingMenu = RageUI.CreateSubMenu(builderMenu, "GangBuilder", "Liste des gangs")
builderEditingSubMenu = RageUI.CreateSubMenu(builderEditingMenu, "GangBuilder", "Intéractions disponibles")
builderUpdateBlipsMenu = RageUI.CreateSubMenu(builderEditingSubMenu, "GangBuilder", "Intéractions disponibles")
builderUpdatePositionMenu = RageUI.CreateSubMenu(builderEditingSubMenu, "GangBuilder", "Intéractions disponibles")
builderBlipsMenu = RageUI.CreateSubMenu(builderCreateMenu, "GangBuilder", "Configuration du blips")
builderGradesMenu = RageUI.CreateSubMenu(builderCreateMenu, "GangBuilder", "Liste des grades")
builderGradesSubMenu = RageUI.CreateSubMenu(builderGradesMenu, "GangBuilder", "Champs à remplir")
builderPositionMenu = RageUI.CreateSubMenu(builderCreateMenu, "GangBuilder", "Liste des positions")
builderVehiclesMenu = RageUI.CreateSubMenu(builderCreateMenu, "GangBuilder", "Liste des véhicules")
builderGradesSubMenu.Closable = false 
dataGangs = {}
builderMenu.Closed = function()
    menuIsOpen = false 
    RageUI.CloseAll()
end

RegisterNetEvent("cxGangBuilder:refreshList")
AddEventHandler("cxGangBuilder:refreshList", function(gangsData)
    dataGangs = gangsData
end)

RegisterNetEvent("cxGangBuilder:openMenu")
AddEventHandler("cxGangBuilder:openMenu", function(gangsData)
    dataGangs = gangsData
    local vehiclesIndex, testList, waitingFor, gang, positions, blips = 1, {"Modifier","Supprimer", Index = 1}, false, {}, {}, {}
    if menuIsOpen then 
        menuIsOpen = false 
        RageUI.CloseAll()
    else
        menuIsOpen = true 
        RageUI.Visible(builderMenu, true)
        CreateThread(function()
            while menuIsOpen do 
                RageUI.IsVisible(builderMenu, function()
                    RageUI.Button("Créer un gang", false, {RightLabel = "→"}, true, {
                        onSelected = function()
                            gangs = {grades = {}, positions = {}, vehicles = {}, blips = {position = nil, name = nil, sprite = nil, color = nil, scale = nil, show = true}}
                        end
                    }, builderCreateMenu)      
                    RageUI.Button("Liste des gangs existants", false, {RightLabel = "→"}, true, {}, builderEditingMenu)     
                end)
                RageUI.IsVisible(builderEditingMenu, function()
                    if json.encode(dataGangs) == json.encode({}) then 
                        return RageUI.Separator("~r~Aucun gang(s)")
                    end
                    for _, value in pairs(dataGangs) do 
                        RageUI.Button(value.label, false, {RightLabel = "~b~Éditer~s~ →"}, true, {
                            onSelected = function()
                                gang, positions, blips = value, {}, {}
                            end
                        }, builderEditingSubMenu)
                    end
                end)
                RageUI.IsVisible(builderEditingSubMenu, function()
                    RageUI.Button("Éditer le blips", false, {RightLabel = "→"}, true, {}, builderUpdateBlipsMenu)
                    RageUI.Button("Éditer les positions", false, {RightLabel = "→"}, true, {}, builderUpdatePositionMenu)
                    RageUI.Button("Supprimer le gang", "~r~Une fois lancé, la suppression est inévitable.", {RightBadge = RageUI.BadgeStyle.Alert}, true, {
                        onSelected = function()
                            TriggerServerEvent("cxGangBuilder:deleteGang", gang.gangId)
                            RageUI.GoBack()
                        end
                    })
                end)
                RageUI.IsVisible(builderUpdateBlipsMenu, function()
                    RageUI.Checkbox('Afficher le blips pour tous', false, blipCheck, {}, {
                        onSelected = function(Index)
                            blipCheck = Index
                            blips.show = Index
                        end
                    })
                    RageUI.Button("Position du blips", false, {}, true, {
                        onSelected = function()
                            blips.position = GetEntityCoords(PlayerPedId())
                        end
                    })
                    RageUI.Button("Nom du blips", false, {RightLabel = coloredValue(blips.name)}, true, {
                        onSelected = function()
                            blips.name = input("blipName", "Nom du blips", "", 15)
                        end
                    })
                    RageUI.Button("Sprite du blips", false, {RightLabel = coloredValue(blips.sprite)}, true, {
                        onSelected = function()
                            blips.sprite = input("blipSprite", "Sprite du blips", "", 15)
                        end
                    })
                    RageUI.Button("Couleur du blips", false, {RightLabel = coloredValue(blips.color)}, true, {
                        onSelected = function()
                            blips.color = input("blipColour", "Couleur du blips", "", 15)
                        end
                    })
                    RageUI.Button("Taille du blips", false, {RightLabel = coloredValue(blips.scale)}, true, {
                        onSelected = function()
                            blips.scale = input("blipScale", "Taille du blips", "", 5)
                        end
                    })
                    RageUI.Button("Confirmer la modification", false, {RightLabel = "→"}, true, {
                        onSelected = function()
                            TriggerServerEvent("cxGangBuilder:updateBlips", gang.gangId, blips)
                            blips = {}
                            RageUI.GoBack()
                        end
                    })
                end)
                RageUI.IsVisible(builderUpdatePositionMenu, function()
                    RageUI.Separator("← ~b~Liste des positions~s~ →")
                    RageUI.Button("Position du stockage", false, {}, true, {
                        onSelected = function()
                            positions["storage"] = GetEntityCoords(PlayerPedId())
                        end
                    })
                    RageUI.Button("Position de la gestion", false, {}, true, {
                        onSelected = function()
                            positions["gestion"] = GetEntityCoords(PlayerPedId())
                        end
                    })
                    RageUI.Button("Position du garage", false, {}, true, {
                        onSelected = function()
                            positions["garage"] = GetEntityCoords(PlayerPedId())
                        end
                    })
                    RageUI.Button("Position de rangement", false, {}, true, {
                        onSelected = function()
                            positions["stored"] = GetEntityCoords(PlayerPedId())
                        end
                    })
                    RageUI.Button("Position de spawn", false, {}, true, {
                        onSelected = function()
                            local rent = GetEntityCoords(PlayerPedId())
                            positions["spawn"] = {x = rent.x, y = rent.y, z = rent.z, h = GetEntityHeading(PlayerPedId())}
                        end
                    })
                    RageUI.Button("Confirmer la modification", false, {RightLabel = "→"}, true, {
                        onSelected = function()
                            TriggerServerEvent("cxGangBuilder:updatePosition", gang.gangId, positions)
                            positions = {}
                            RageUI.GoBack()
                        end
                    })
                end)
                RageUI.IsVisible(builderCreateMenu, function()
                    RageUI.Button("Nom du gang : ", false, {RightLabel = coloredValue(gangs.name)}, true, {
                        onSelected = function()
                            gangs.name = input("gangName", "Nom du gang", "", 15)
                        end
                    })
                    RageUI.Button("Label du gang : ", false, {RightLabel = coloredValue(gangs.label)}, true, {
                        onSelected = function()
                            gangs.label = input("gangLabel", "Label du gang", "", 15)
                        end
                    })
                    RageUI.Button("Configurer les grades", false, {RightLabel = "→"}, true, {}, builderGradesMenu)
                    RageUI.Button("Configurer les positions", false, {RightLabel = "→"}, true, {}, builderPositionMenu)
                    RageUI.Button("Configurer les véhicules", false, {RightLabel = "→"}, true, {}, builderVehiclesMenu)
                    RageUI.Button("Configurer le blips", false, {RightLabel = "→"}, true, {}, builderBlipsMenu)
                    RageUI.Button("Confirmer la création du gang", false, {RightLabel = "→→", Color = {HightLightColor = {0, 155, 0, 150}, BackgroundColor = {38,85,150,160}}}, checkComplete(), {
                        onSelected = function()
                            TriggerServerEvent("cxGangBuilder:create", gangs)
                            RageUI.GoBack()
                        end
                    })
                end)
                RageUI.IsVisible(builderBlipsMenu, function()
                    RageUI.Checkbox('Afficher le blips pour tous', false, blipCheck, {}, {
                        onSelected = function(Index)
                            blipCheck = Index
                            gangs.blips.show = Index
                        end
                    })
                    RageUI.Button("Position du blips", false, {}, true, {
                        onSelected = function()
                            gangs.blips.position = GetEntityCoords(PlayerPedId())
                        end
                    })
                    RageUI.Button("Nom du blips", false, {RightLabel = coloredValue(gangs.blips.name)}, true, {
                        onSelected = function()
                            gangs.blips.name = input("blipName", "Nom du blips", "", 15)
                        end
                    })
                    RageUI.Button("Sprite du blips", false, {RightLabel = coloredValue(gangs.blips.sprite)}, true, {
                        onSelected = function()
                            gangs.blips.sprite = input("blipSprite", "Sprite du blips", "", 15)
                        end
                    })
                    RageUI.Button("Couleur du blips", false, {RightLabel = coloredValue(gangs.blips.color)}, true, {
                        onSelected = function()
                            gangs.blips.color = input("blipColour", "Couleur du blips", "", 15)
                        end
                    })
                    RageUI.Button("Taille du blips", false, {RightLabel = coloredValue(gangs.blips.scale)}, true, {
                        onSelected = function()
                            gangs.blips.scale = input("blipScale", "Taille du blips", "", 5)
                        end
                    })
                end)
                RageUI.IsVisible(builderGradesMenu, function()
                    RageUI.Button("Ajouter un grade", false, {RightLabel = "→"}, checkGrades(), {
                        onSelected = function()
                            gangs.grades[#gangs.grades + 1] = {name = "A définir", label = "A définir", salary = 1200}
                            SetTimeout(120, function() waitingFor = true end)
                        end
                    }, builderGradesSubMenu)
                    RageUI.Separator("← ~b~Liste des grades~s~ →")
                    if #gangs.grades < 1 then 
                        return RageUI.Separator("~r~Aucun grade(s)")
                    end
                    for gradeId, grade in pairs(gangs.grades) do 
                        RageUI.List(("~b~%s~s~"):format(gangs.grades[gradeId].label), testList, testList.Index, false, {}, true, {
                            onListChange = function(Index)
                                testList.Index = Index 
                            end,
                            onSelected = function()
                                if testList.Index == 1 then 
                                    gangs.grades[gradeId].name = input("gradeName", "Nom du grade", "", 15)
                                    gangs.grades[gradeId].label = input("gradeLabel", "Label du grade", "", 15)
                                else
                                    gangs.grades[gradeId] = nil 
                                end
                            end
                        })
                    end
                end)
                RageUI.IsVisible(builderGradesSubMenu, function()
                    if waitingFor then 
                        local grade = gangs.grades[#gangs.grades]
                        RageUI.Button("Annuler", false, {RightLabel = "→"}, true, {
                            onSelected = function()
                                RageUI.GoBack()
                                SetTimeout(50, function() gangs.grades[#gangs.grades] = nil end)
                            end
                        })
                        RageUI.Button("Nom du grade :", false, {RightLabel = coloredValue(grade.name)}, true, {
                            onSelected = function()
                                grade.name = input("gradeName", "Nom du grade", "", 15)
                            end
                        })
                        RageUI.Button("Label du grade :", false, {RightLabel = coloredValue(grade.label)}, true, {
                            onSelected = function()
                                grade.label = input("gradeLabel", "Label du grade", "", 15)
                            end
                        })
                        RageUI.Button("Confirmer", false, {RightLabel = "→"}, valid(grade.name, grade.label), {
                            onSelected = function()
                                RageUI.GoBack()
                            end
                        })
                    end
                end)
                RageUI.IsVisible(builderPositionMenu, function()
                    showPoints(showCheck)
                    RageUI.Checkbox('Activer la prévisualisation', false, showCheck, {}, {
                        onSelected = function(Index)
                            showCheck = Index
                        end
                    })
                    RageUI.Separator("← ~b~Liste des positions~s~ →")
                    RageUI.Button("Position du stockage", false, {}, true, {
                        onSelected = function()
                            gangs.positions["storage"] = GetEntityCoords(PlayerPedId())
                        end
                    })
                    RageUI.Button("Position de la gestion", false, {}, true, {
                        onSelected = function()
                            gangs.positions["gestion"] = GetEntityCoords(PlayerPedId())
                        end
                    })
                    RageUI.Button("Position du garage", false, {}, true, {
                        onSelected = function()
                            gangs.positions["garage"] = GetEntityCoords(PlayerPedId())
                        end
                    })
                    RageUI.Button("Position de rangement", false, {}, true, {
                        onSelected = function()
                            gangs.positions["stored"] = GetEntityCoords(PlayerPedId())
                        end
                    })
                    RageUI.Button("Position de spawn", false, {}, true, {
                        onSelected = function()
                            local rent = GetEntityCoords(PlayerPedId())
                            gangs.positions["spawn"] = {x = rent.x, y = rent.y, z = rent.z, h = GetEntityHeading(PlayerPedId())}
                        end
                    })
                end)
                RageUI.IsVisible(builderVehiclesMenu, function()
                    RageUI.Button("Ajouter un véhicule", false, {RightLabel = "→"}, checkVehicles(), {
                        onSelected = function()
                            local name = input("vehicleName", "Nom du véhicule", "", 15)
                            if not IsModelValid(GetHashKey(name)) then 
                                return ESX.ShowNotification("~r~Ce véhicule n'existe pas.")
                            end
                            if checkInput(name) then 
                                return ESX.ShowNotification("~r~Ce véhicule est blacklist.")
                            end 
                            gangs.vehicles[#gangs.vehicles+1] = {stored = 1, props = vehicleCheck(name) }
                        end
                    })
                    RageUI.Separator("← ~b~Liste des véhicules~s~ →")
                    if #gangs.vehicles < 1 then 
                        return RageUI.Separator("~r~Aucun véhicule(s)")
                    end
					
					for vehicleId, vehicle in pairs(gangs.vehicles) do 
                        if vehicle.props ~= nil then 
                            RageUI.List(("~b~%s~s~"):format(checkLabel(vehicle.props.model)), testList, testList.Index, false, {}, true, {
                                onListChange = function(Index)
                                    testList.Index = Index 
                                end,
                                onSelected = function()
                                    if testList.Index == 1 then 
                                        local name = input("vehicleName", "Nom du véhicule", "", 15)
                                        if not IsModelValid(GetHashKey(name)) then 
                                            return ESX.ShowNotification("~r~Ce véhicule n'existe pas.")
                                        end
                                        if checkInput(name) then 
                                            return ESX.ShowNotification("~r~Ce véhicule est blacklist.")
                                        end  
                                        gangs.vehicles[vehicleId] = {}
                                        gangs.vehicles[vehicleId].stored = 1 
                                        gangs.vehicles[vehicleId].props = vehicleCheck(name) 
                                    else
                                        gangs.vehicles[vehicleId] = nil 
                                    end
                                end 
                            })
                        end
                    end
               --[[     for vehicleId, vehicle in pairs(gangs.vehicles) do 
                        RageUI.List(("~b~%s~s~"):format(checkLabel(vehicle.props.model)), testList, testList.Index, false, {}, true, {
                            onListChange = function(Index)
                                testList.Index = Index 
                            end,
                            onSelected = function()
                                if testList.Index == 1 then 
                                    local name = input("vehicleName", "Nom du véhicule", "", 15)
                                    if not IsModelValid(GetHashKey(name)) then 
                                        return ESX.ShowNotification("~r~Ce véhicule n'existe pas.")
                                    end
                                    if checkInput(name) then 
                                        return ESX.ShowNotification("~r~Ce véhicule est blacklist.")
                                    end  
                                    gangs.vehicles[vehicleId] = {}
                                    gangs.vehicles[vehicleId].stored = 1 
                                    gangs.vehicles[vehicleId].props = vehicleCheck(name) 
                                else
                                    gangs.vehicles[vehicleId] = nil 
                                end
                            end 
                        })
                    end ]]
                end)
                Wait(1)
            end
        end)
    end
end)

garageMenu = RageUI.CreateMenu("Garage", "Véhicules disponibles")
garageMenu.Closed = function()
    menuIsOpen = false 
    RageUI.CloseAll()
    FreezeEntityPosition(PlayerPedId(), false)
end

RegisterNetEvent("cxGangBuilder:openGarage")
AddEventHandler("cxGangBuilder:openGarage", function(gangId, vehicleData)
    if menuIsOpen then 
        menuIsOpen = false 
        RageUI.CloseAll()
    else
        menuIsOpen = true 
        RageUI.Visible(garageMenu, true)
        CreateThread(function()
            while menuIsOpen do 
                FreezeEntityPosition(PlayerPedId(), true)
                RageUI.IsVisible(garageMenu, function()
                    for vehicleId, value in pairs(vehicleData) do 
                        RageUI.Button(("[~b~%s~s~] - ~b~%s~s~"):format(value.vehicle.plate, checkLabel(value.vehicle.model)), false, {RightLabel = "→"}, value.stored, {
                            onSelected = function()
                                spawnVehicle(value.vehicle, gangId)
                            end
                        })
                    end
                end)
                Wait(1)
            end
        end)
    end
end)

moneyList = {Index = 1, "Déposer", "Retirer"}
black_moneyList = {Index = 1, "Déposer", "Retirer"}
storageMenu = RageUI.CreateMenu("Stockage", "Intéractions disponibles")
storageSubMenu = RageUI.CreateSubMenu(storageMenu, "Stockage", "Intéractions disponibles")
storageItemMenu = RageUI.CreateSubMenu(storageSubMenu, "Inventaire", "Vos objets")
storageWeaponMenu = RageUI.CreateSubMenu(storageMenu, "Stockage", "Intéractions disponibles")
storageWeaponListMenu = RageUI.CreateSubMenu(storageWeaponMenu, "Inventaire", "Vos armes")
storageData, weaponData, moneyData = {}, {}, {}
storageMenu.Closed = function()
    menuIsOpen = false 
    RageUI.CloseAll()
    FreezeEntityPosition(PlayerPedId(), false)
end

RegisterNetEvent("cxGangBuilder:refreshStorage")
AddEventHandler("cxGangBuilder:refreshStorage", function(data, weapons, money)
    storageData, moneyData = data, money 
    if not GangBuilder.UseWeaponItem then 
        weaponData = weapons 
    end
end)

RegisterNetEvent("cxGangBuilder:openStorage")
AddEventHandler("cxGangBuilder:openStorage", function(gangId, data, weapons, money)
    storageData, moneyData = data, money
    if not GangBuilder.UseWeaponItem then 
        weaponData = weapons 
    end
    if menuIsOpen then 
        menuIsOpen = false 
        RageUI.CloseAll()
    else
        menuIsOpen = true 
        RageUI.Visible(storageMenu, true)
        CreateThread(function()
            while menuIsOpen do 
                FreezeEntityPosition(PlayerPedId(), true)
                RageUI.IsVisible(storageMenu, function()
                    RageUI.List(("Argent liquide : %s"):format(getMoneyValue("money", moneyData["money"])), moneyList, moneyList.Index, false, {}, true, {
                        onListChange = function(Index)
                            moneyList.Index = Index 
                        end,
                        onSelected = function()
                            if moneyList.Index == 1 then 
                                local count = input("moneyCount", "Combien souhaitez-vous déposer ?", "", 6)
                                count = tonumber(count)
                                if count ~= nil and count ~= "" and tonumber(count) > 0 then 
                                    TriggerServerEvent("cxGangBuilder:depositMoney", gangId, moneyData, "money", count)
                                end
                            elseif moneyList.Index == 2 then 
                                if not Gangs[gangId].perms[playerData.job2.grade]["withdrawMoney"] then 
                                    return ESX.ShowNotification("~r~Vous n'avez pas la permission.")
                                end
                                local count = input("moneyCount", "Combien souhaitez-vous retirer ?", "", 6)
                                count = tonumber(count)
                                if count ~= nil and count ~= "" and tonumber(count) > 0 then 
                                    TriggerServerEvent("cxGangBuilder:withdrawMoney", gangId, moneyData, "money", count)
                                end
                            end
                        end
                    })
                    RageUI.List(("Argent sale : %s"):format(getMoneyValue("black_money", moneyData["black_money"])), black_moneyList, black_moneyList.Index, false, {}, true, {
                        onListChange = function(Index)
                            black_moneyList.Index = Index 
                        end,
                        onSelected = function()
                            if black_moneyList.Index == 1 then 
                                local count = input("moneyCount", "Combien souhaitez-vous déposer ?", "", 6)
                                count = tonumber(count)
                                if count ~= nil and count ~= "" and tonumber(count) > 0 then 
                                    TriggerServerEvent("cxGangBuilder:depositMoney", gangId, moneyData, "black_money", count)
                                end
                            elseif black_moneyList.Index == 2 then 
                                if not Gangs[gangId].perms[playerData.job2.grade]["withdrawMoney"] then 
                                    return ESX.ShowNotification("~r~Vous n'avez pas la permission.")
                                end
                                local count = input("moneyCount", "Combien souhaitez-vous retirer ?", "", 6)
                                count = tonumber(count)
                                if count ~= nil and count ~= "" and tonumber(count) > 0 then 
                                    TriggerServerEvent("cxGangBuilder:withdrawMoney", gangId, moneyData, "black_money", count)
                                end
                            end
                        end
                    })
                    RageUI.Button("Gérer le stock d'objet(s)", false, {RightLabel = "→"}, true, {}, storageSubMenu)
                    if not GangBuilder.UseWeaponItem then 
                        RageUI.Button("Gérer le stock d'arme(s)", false, {RightLabel = "→"}, true, {}, storageWeaponMenu)
                    end
                end)
                RageUI.IsVisible(storageSubMenu, function()
                    RageUI.Button("Déposer un objet", false, {RightLabel = "→"}, true, {
                        onSelected = function()
                            ESX.GetPlayerData() 
                        end
                    }, storageItemMenu)
                    if storageData == nil or json.encode(storageData) == json.encode({}) then 
                        RageUI.Separator("")
                        RageUI.Separator("~r~Stockage vide~s~")
                        return RageUI.Separator("")  
                    end
                    for _, value in pairs(storageData) do 
                        if value.count >= 1 then 
                            if Gangs[gangId].perms[playerData.job2.grade]["takeItem"] then
                                RageUI.Button(("[~r~x%s~s~] - %s"):format(value.count, value.label), false, {RightLabel = "~b~Retirer~s~ →"}, true, {
                                    onSelected = function()
                                        local count = input("itemCount", "Combien souhaitez-vous retirer ?", "", 3)
                                        count = tonumber(count)
                                        if count ~= nil and count ~= "" and tonumber(count) > 0 then 
                                            if value.count < count then 
                                                return ESX.ShowNotification("~r~Vous en avez pas autant dans le stockage.~s~")
                                            end
                                            TriggerServerEvent("cxGangBuilder:withdrawItem", count, value.name, gangId, storageData)
                                        end
                                    end
                                })
                            else
                                RageUI.Button(("[~r~x%s~s~] - %s"):format(value.count, value.label), false, {RightLabel = "~b~Retirer~s~ →"}, false, {})
                            end
                        end
                    end
                end)
                RageUI.IsVisible(storageItemMenu, function()
                    if checkInventory() < 1 then RageUI.Separator("") RageUI.Separator("~r~Inventaire vide~s~") return RageUI.Separator("") end 
                    for _, item in pairs(ESX.GetPlayerData().inventory) do 
                        if item.count >= 1 then 
                            RageUI.Button(("[~r~x%s~s~] - %s"):format(item.count, item.label), false, {RightLabel = "~b~Déposer~s~ →"}, true, {
                                onSelected = function()
                                    local count = input("itemCount", "Combien souhaitez-vous déposer ?", "", 3)
                                    count = tonumber(count)
                                    if count ~= nil and count ~= "" and tonumber(count) > 0 then 
                                        if item.count < count then 
                                            return ESX.ShowNotification("~r~Vous en avez pas autant dans votre inventaire.~s~")
                                        end
                                        TriggerServerEvent("cxGangBuilder:depositItem", count, item.name, gangId, storageData)
                                        RageUI.GoBack()
                                    end
                                end
                            })
                        end
                    end
                end)
                RageUI.IsVisible(storageWeaponMenu, function()
                    RageUI.Button("Déposer une arme", false, {RightLabel = "→"}, true, {}, storageWeaponListMenu)
                    if weaponData == nil or json.encode(weaponData) == json.encode({}) then 
                        RageUI.Separator("")
                        RageUI.Separator("~r~Stockage vide~s~")
                        return RageUI.Separator("")  
                    end
                    for weaponId, weapon in pairs(weaponData) do 
                        if Gangs[gangId].perms[playerData.job2.grade]["takeWeapon"] then
                            RageUI.Button(("[~r~%s~s~] - %s"):format(weapon.ammo, ESX.GetWeaponLabel(weapon.name)), false, {RightLabel = "~b~Retirer~s~ →"}, true, {
                                onSelected = function()
                                    TriggerServerEvent("cxGangBuilder:withdrawWeapon", weaponId, weapon.ammo, weapon.name, gangId, weaponData)
                                end
                            })
                        else
                            RageUI.Button(("[~r~%s~s~] - %s"):format(weapon.ammo, ESX.GetWeaponLabel(weapon.name)), false, {RightLabel = "~b~Retirer~s~ →"}, false, {})
                        end
                    end
                end)
                RageUI.IsVisible(storageWeaponListMenu, function()
                    for _, weapon in pairs(ESX.GetWeaponList()) do 
                        local weaponHash = GetHashKey(weapon.name)
                        if HasPedGotWeapon(PlayerPedId(), weaponHash, false) and weapon.name ~= 'WEAPON_UNARMED' then
                            RageUI.Button(("[~r~%s~s~] - %s"):format(GetAmmoInPedWeapon(PlayerPedId(), weaponHash), ESX.GetWeaponLabel(weapon.name)), false, {RightLabel = "~b~Déposer~s~ →"}, true, {
                                onSelected = function()
                                    TriggerServerEvent("cxGangBuilder:depositWeapon", GetAmmoInPedWeapon(PlayerPedId(), weaponHash), weaponHash, weapon.name, gangId, weaponData)
                                    RageUI.GoBack()
                                end
                            })
                        end
                    end
                end)
                Wait(1)
            end
        end)
    end
end)

gestionMenu = RageUI.CreateMenu("Gestion Gang", "Actions disponibles")
gestionMemberMenu = RageUI.CreateSubMenu(gestionMenu, "Gestion Gang", "Liste des membres")
gestionMemberSubMenu = RageUI.CreateSubMenu(gestionMemberMenu, "Gestion Gang", "Actions disponibles")
gestionMemberPromoteMenu = RageUI.CreateSubMenu(gestionMemberSubMenu, "Gestion Gang", "Actions disponibles")
gestionMemberDemoteMenu = RageUI.CreateSubMenu(gestionMemberSubMenu, "Gestion Gang", "Actions disponibles")
gestionSubMenu = RageUI.CreateSubMenu(gestionMenu, "Gestion Gang", "Liste des grades")
gestionPermMenu = RageUI.CreateSubMenu(gestionSubMenu, "Permissions", "Liste des permissions")
gangsMembers, upgradeList = {}, {Index = 1}
gestionMenu.Closed = function()
    menuIsOpen = false 
    RageUI.CloseAll()
    FreezeEntityPosition(PlayerPedId(), false)
end 

RegisterNetEvent("cxGangBuilder:refreshGestion")
AddEventHandler("cxGangBuilder:refreshGestion", function(gangsPlayers)
    gangsMembers = gangsPlayers
end)

RegisterNetEvent("cxGangBuilder:openGestion")
AddEventHandler("cxGangBuilder:openGestion", function(gangId, gradesData, gangsPlayers)
    gangsMembers = gangsPlayers
    local grades, gradeData, gradeId, members, waitingFor = getDataGrade(gradesData), {}, nil, nil, false 
    if menuIsOpen then 
        menuIsOpen = false 
        RageUI.CloseAll()
    else
        RageUI.Visible(gestionMenu, true)
        menuIsOpen = true 
        CreateThread(function()
            while menuIsOpen do 
                FreezeEntityPosition(PlayerPedId(), true)
                RageUI.IsVisible(gestionMenu, function()
                    local player, distance = ESX.Game.GetClosestPlayer()
                    if playerData.job2.grade_name == "boss" then 
                        RageUI.Button("Gérer les permissions", false, {RightLabel = "→"}, true, {}, gestionSubMenu)
                    else
                        RageUI.Button("Gérer les permissions", false, {RightLabel = "→"}, false, {})
                    end
                    RageUI.Button("Liste des membres", false, {RightLabel = "→"}, true, {}, gestionMemberMenu)
                    if player ~= -1 and distance <= 3.5 then
                        RageUI.Button("Recruter le joueur proche", false, {RightLabel = "→"}, true, {
                            onActive = function()
                                createMarker(player)
                            end,
                            onSelected = function()
                                TriggerServerEvent("cxGangBuilder:upgradeJob", "recrutment", gangId, GetPlayerServerId(player))
                            end
                        })
                    else
                        RageUI.Button("Recruter le joueur proche", false, {}, false, {})
                    end

                end)
                RageUI.IsVisible(gestionMemberMenu, function()
                    for _, member in pairs(gangsMembers) do 
                        if member.playerId ~= GetPlayerServerId(PlayerId()) then 
                            if playerData.job2.grade < member.grade then 
                                RageUI.Button(("[~r~%s~s~] - ~b~%s~s~"):format(member.grade_label, member.name), false, {RightLabel = ""}, true, {
                                    onSelected = function()
                                        members = member
                                        Wait(120)
                                        waitingFor = true 
                                    end
                                },gestionMemberSubMenu)
                            else
                                RageUI.Button(("[~r~%s~s~] - ~b~%s~s~"):format(member.grade_label, member.name), false, {RightLabel = ""}, false, {})
                            end
                        else
                            RageUI.Button(("[~r~%s~s~] - ~b~%s~s~"):format(member.grade_label, member.name), false, {}, false, {})
                        end
                    end
                end)
                RageUI.IsVisible(gestionMemberSubMenu, function()
                    if waitingFor then 
                        RageUI.Button(("Promouvoir ~b~%s~s~"):format(members.name), false, {RightLabel = "→"}, true, {}, gestionMemberPromoteMenu)
                        RageUI.Button(("Rétrograder ~b~%s~s~"):format(members.name), false, {RightLabel = "→"}, true, {}, gestionMemberDemoteMenu)
                        RageUI.Button(("Expulser ~b~%s~s~"):format(members.name), false, {RightLabel = "→"}, true, {
                            onSelected = function()
                                TriggerServerEvent("cxGangBuilder:upgradeJob", "exiting", gangId, members.playerId)
                                RageUI.GoBack()
                            end
                        })
                    end
                end)
                RageUI.IsVisible(gestionMemberPromoteMenu, function()
                    for k,v in pairs(getGradeListing(gradesData, members.grade, 1)) do 
                        if v.name ~= "boss" then 
                            RageUI.Button(("%s - %s"):format(v.grade, v.label), false, {}, true, {
                                onSelected = function()
                                    TriggerServerEvent("cxGangBuilder:upgradeJob", "promote", gangId, members.playerId, v.grade)
                                    RageUI.Visible(gestionMemberPromoteMenu, false)
                                    RageUI.Visible(gestionMemberMenu, true)
                                end
                            })
                        end
                    end
                end)
                RageUI.IsVisible(gestionMemberDemoteMenu, function()
                    for k,v in pairs(getGradeListing(gradesData, members.grade, 2)) do 
                        RageUI.Button(("%s - %s"):format(v.grade, v.label), false, {}, true, {
                            onSelected = function()
                                TriggerServerEvent("cxGangBuilder:upgradeJob", "demote", gangId, members.playerId, v.grade)
                                RageUI.Visible(gestionMemberDemoteMenu, false)
                                RageUI.Visible(gestionMemberMenu, true)
                            end
                        })
                    end
                end)
                RageUI.IsVisible(gestionSubMenu, function()
                    for k,v in pairs(grades) do 
                        if v.name ~= "boss" then 
                            RageUI.Button(("[~b~%s~s~] - %s"):format(k, v.label), false, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    gradeData, gradeId = getPermGrade(gangId, k), k 
                                end
                            }, gestionPermMenu)
                        else
                            RageUI.Button(("[~b~%s~s~] - %s"):format(k, v.label), false, {RightLabel = "→"}, false, {})
                        end
                    end
                end)
                RageUI.IsVisible(gestionPermMenu, function()
                    RageUI.Checkbox("Accès à la gestion", false, gradeData["gestion"], {}, {
                        onChecked = function()
                            TriggerServerEvent("cxGangBuilder:perms", gangId, gradeId, true, "gestion")
                        end,
                        onUnChecked = function()
                            TriggerServerEvent("cxGangBuilder:perms", gangId, gradeId, false, "gestion")
                        end,
                        onSelected = function(Index)
                            gradeData["gestion"] = Index
                        end
                    })
                    RageUI.Checkbox("Accès au stockage", false, gradeData["storage"], {}, {
                        onChecked = function()
                            TriggerServerEvent("cxGangBuilder:perms", gangId, gradeId, true, "storage")
                        end,
                        onUnChecked = function()
                            TriggerServerEvent("cxGangBuilder:perms", gangId, gradeId, false, "storage")
                        end,
                        onSelected = function(Index)
                            gradeData["storage"] = Index
                        end
                    })
                    RageUI.Checkbox("Accès au garage", false, gradeData["garage"], {}, {
                        onChecked = function()
                            TriggerServerEvent("cxGangBuilder:perms", gangId, gradeId, true, "garage")
                        end,
                        onUnChecked = function()
                            TriggerServerEvent("cxGangBuilder:perms", gangId, gradeId, false, "garage")
                        end,
                        onSelected = function(Index)
                            gradeData["garage"] = Index
                        end
                    })
                    RageUI.Checkbox("Retrait d'armes", false, gradeData["takeWeapon"], {}, {
                        onChecked = function()
                            TriggerServerEvent("cxGangBuilder:perms", gangId, gradeId, true, "takeWeapon")
                        end,
                        onUnChecked = function()
                            TriggerServerEvent("cxGangBuilder:perms", gangId, gradeId, false, "takeWeapon")
                        end,
                        onSelected = function(Index)
                            gradeData["takeWeapon"] = Index
                        end
                    })
                    RageUI.Checkbox("Retrait d'objets", false, gradeData["takeItem"], {}, {
                        onChecked = function()
                            TriggerServerEvent("cxGangBuilder:perms", gangId, gradeId, true, "takeItem")
                        end,
                        onUnChecked = function()
                            TriggerServerEvent("cxGangBuilder:perms", gangId, gradeId, false, "takeItem")
                        end,
                        onSelected = function(Index)
                            gradeData["takeItem"] = Index
                        end
                    })
                    RageUI.Checkbox("Retrait d'argent", false, gradeData["withdrawMoney"], {}, {
                        onChecked = function()
                            TriggerServerEvent("cxGangBuilder:perms", gangId, gradeId, true, "withdrawMoney")
                        end,
                        onUnChecked = function()
                            TriggerServerEvent("cxGangBuilder:perms", gangId, gradeId, false, "withdrawMoney")
                        end,
                        onSelected = function(Index)
                            gradeData["withdrawMoney"] = Index
                        end
                    })
                end)
                Wait(1)
            end
        end)
    end
end)

interactMenu = RageUI.CreateMenu("Menu Intéractions", "Actions disponibles")
interactSubMenu = RageUI.CreateSubMenu(interactMenu, "Menu Intéractions", "Actions disponibles")
playerInfos, waitPlayer = {}, false 
interactMenu.Closed = function()
    menuIsOpen = false 
    RageUI.CloseAll()
end
interactSubMenu.Closed = function()
    waitPlayer = false 
end

function getPlayerData(playerId)
    ESX.TriggerServerCallback('cxGangBuilder:getPlayerData', function(data) 
        playerInfos.inventory = data.inventory
        playerInfos.accounts = data.accounts 
        if not GangBuilder.UseWeaponItem then 
            playerInfos.weapon = data.weapons
        end
    end, GetPlayerServerId(playerId))
end

RegisterNetEvent("cxGangBuilder:interactMenu")
AddEventHandler("cxGangBuilder:interactMenu", function()
    local playerData = {}
    if menuIsOpen then 
        menuIsOpen = false 
        RageUI.CloseAll()
    else
        menuIsOpen = true 
        RageUI.Visible(interactMenu, true)
        CreateThread(function()
            while menuIsOpen do
                RageUI.IsVisible(interactMenu, function()
                    local player, distance = ESX.Game.GetClosestPlayer()
                    if player ~= -1 and distance <= 1.5 then
                        RageUI.Button("Fouiller le joueur proche", false, {RightLabel = "→"}, true, {
                            onSelected = function()
                                getPlayerData(player)
                                Wait(120)
                                waitPlayer = true 
                            end
                        }, interactSubMenu)
                        RageUI.Button("Menotter / Démenotter le joueur proche", false, {RightLabel = "→"}, true, {
                            onSelected = function()
                                TriggerServerEvent("cxGangBuilder:handCuff", "handcuff", GetPlayerServerId(player))
                            end
                        })
                        RageUI.Button("Escorter le joueur proche", false, {RightLabel = "→"}, true, {
                            onSelected = function()
                                TriggerServerEvent("cxGangBuilder:handCuff", "drag", GetPlayerServerId(player))
                            end
                        })
                    else
                        RageUI.Button("Fouiller le joueur proche", false, {RightLabel = "→"}, false, {})
                        RageUI.Button("Menotter / Démenotter le joueur proche", false, {RightLabel = "→"}, false, {})
                        RageUI.Button("Escorter le joueur proche", false, {RightLabel = "→"}, false, {})
                    end
                end) 
                RageUI.IsVisible(interactSubMenu, function()
                    local player, distance = ESX.Game.GetClosestPlayer()
                    if distance > 1.5 then
                        RageUI.GoBack()
                    end
                    if waitPlayer then 
                        RageUI.Separator("↓ ~b~Inventaire~s~ ↓")
                        for _, accounts in pairs(playerInfos.accounts) do 
                            if accounts.name ~= "bank" then 
                                RageUI.Button(("%s : %s"):format(getAccountLabel(accounts.name), getMoneyValue(accounts.name, accounts.money)), false, {}, true, {})
                            end
                        end
                        for _, item in pairs(playerInfos.inventory) do 
                            if item.count >= 1 then 
                                RageUI.Button(("[~r~x%s~s~] - ~b~%s~s~"):format(item.count, item.label), false, {}, true, {})
                            end
                        end 
                        if not GangBuilder.UseWeaponItem then 
                            RageUI.Separator("↓ ~r~Armes~s~ ↓")
                            for _, weapon in pairs(playerInfos.weapon) do 
                                RageUI.Button(("[~r~%s~s~] - ~b~%s~s~"):format(weapon.ammo, weapon.label), false, {}, true, {})
                            end
                        end
                    end
                end)
                Wait(1)
            end
        end)
    end
end)

Keys.Register("F7", "F7", "Menu intéractions", function()
    TriggerServerEvent("cxGangBuilder:checkInteract")
end)