if GetResourceState('es_extended') ~= 'started' then return end
ESX = exports['es_extended']:getSharedObject()
Framework, PlayerLoaded, PlayerData = 'esx', nil, {}

inMenu = nil

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = job
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName or not ESX.PlayerLoaded then return end
    PlayerData = ESX.GetPlayerData()
    PlayerLoaded = true
end)

function ShowTextUI(msg)
    lib.showTextUI(msg) -- Replace this with your custom text UI function/event?
end

function HideTextUI()
    lib.hideTextUI() -- Replace this with your custom text UI function/event?
end

function AddF5ComponentRadialItems()
	print('AddF5ComponentRadialItems')
	lib.addRadialItem({
		{
			id = 'menu_general',
			label = 'Menu Personnel',
			icon = 'user',
			menu = 'personal_menu'
		},
	})
end

function Draw3DText(x, y, z, scl_factor, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov * scl_factor
    if onScreen then
        SetTextScale(0.0, scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(232, 0, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function HasGroup(filter)
    local type = type(filter)

    if type == 'string' then
        if PlayerData.job.name == filter then
            return PlayerData.job.name, PlayerData.job.grade
        end
    else
        local tabletype = table.type(filter)

        if tabletype == 'hash' then
            local grade = filter[PlayerData.job.name]

            print(json.encode(filter))
            print(grade, PlayerData.job.grade)

            if grade and grade <= PlayerData.job.grade then
                return PlayerData.job.name, PlayerData.job.grade
            end
        elseif tabletype == 'array' then
            for i = 1, #filter do
                if PlayerData.job.name == filter[i] then
                    return PlayerData.job.name, PlayerData.job.grade
                end
            end
        end
    end
end

addCarKeys = function(plate, model)
    exports.wasabi_carlock:GiveKeys(plate)
end

RegisterNetEvent('projectrpUtils:notify', function(title, desc, style)
    lib.notify({
        title = title,
        description = desc,
        duration = 3500,
        type = style
    })
end)

RegisterNetEvent('projectrpUtils:customNotify', function(title, desc, position, styleBG, styleColor, icon, iconColor, duration)
    lib.notify({
        id = 'customNotify'..desc,
        title = title,
        description = desc,
        position = position,
        style = {
            backgroundColor = styleBG,
            color = styleColor
        },
        icon = icon,
        iconColor = iconColor,
        duration = duration,
    })
end)

AddEventHandler('projectrpUtils:addTarget', function(d)
    if d.targetType == 'AddBoxZone' then
        exports.qtarget:AddBoxZone(d.identifier, d.coords, d.width, d.length, {
            name=d.identifier,
            heading=d.heading,
            debugPoly=false,
            minZ=d.minZ,
            maxZ=d.maxZ,
            useZ = true,
        }, {
            options = d.options,
            job = (d.job or false),
            distance = d.distance,
        })
    elseif d.targetType == 'Player' then
        print('target player')
        exports.qtarget:Player({
            options = d.options,
            job = (d.job or false),
            distance = d.distance,
        })
    elseif d.targetType == 'Vehicle' then
        exports.qtarget:Vehicle({
            options = d.options,
            job = (d.job or false),
            distance = d.distance
        })
    elseif d.targetType == 'Model' then
        exports.qtarget:AddTargetModel(d.models, {
            options = d.options,
            job = (d.job or false),
            distance = d.distance,
        })
    end
end)

