function Functions.notify(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(0, 1)
end

function Functions.applyOutfit(outfits)
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerEvent('skinchanger:loadClothes', skin, outfits[skin.sex == 0 and "MALE" or "FEMALE"])
    end)
end

function Functions.restoreOutfit()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end, true)
end

function Functions.upgradeVehicle(vehicle)
    local props = {
        modEngine = 2,
        modBrakes = 2,
        modTransmission = 2,
        modSuspension = 3,
        modTurbo = true,
        wheels= 4,
        modFrontWheels = 5
    }
    ESX.Game.SetVehicleProperties(vehicle, props)
end