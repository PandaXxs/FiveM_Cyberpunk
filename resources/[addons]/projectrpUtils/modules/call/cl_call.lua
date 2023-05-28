local callActive = false
local work = {}
local target = {}
local soundid = GetSoundId() 


Citizen.CreateThread(function()
    while true do
		local time = 1000
		if callActive then
			time = 1
		end
		if callActive and IsControlJustPressed(1, 246) then
			RemoveBlip(target.blip)
			target.blip = AddBlipForCoord(target.pos.x, target.pos.y, target.pos.z)
			SetBlipRoute(target.blip, true)
			if soundid ~= nil then
				StopSound(soundid)
			end
			TriggerServerEvent('projectrpUtils:sendAnnounce', 'Centrale - Appel d\'urgence', 'Une équipe est en route ! Ne bougez pas !', 'center-left', '#001A52', '#909296', target.icon, '#909296', 6000, target.id)
			TriggerServerEvent("call:AccepteCall", ESX.PlayerData.job.name)
			callActive = false
		end
		if callActive and IsControlJustPressed(1, 75) then
			if soundid ~= nil then
				StopSound(soundid)
			end
			TriggerServerEvent('projectrpUtils:sendAnnounce', 'Centrale - Appel d\'urgence', 'Vous avez ignoré l\'appel', 'center-left', '#001A52', '#909296', target.icon, '#909296', 6000, GetPlayerServerId(PlayerId()))
			callActive = false
		end
		local playerPos = GetEntityCoords(PlayerPedId(), true)
		if target.pos ~= nil then
			coords = vector3(target.pos.x, target.pos.y, target.pos.z)
		end
		if target.pos ~= nil and GetDistanceBetweenCoords(playerPos, coords, false) < 5 then
			RemoveBlip(target.blip)
		end
		Wait(time)
	end
end)

RegisterNetEvent("call:callIncoming")
AddEventHandler("call:callIncoming", function(job, pos, msg, targetid, icon)
	print("call:callIncoming")
    work = job
	target.id = targetid
    target.pos = pos
	target.icon = icon
	print(target.icon)
	coords = GetEntityCoords(GetPlayerPed(-1))
	dist = CalculateTravelDistanceBetweenPoints(coords.x, coords.y, coords.z, target.pos.x, target.pos.y, target.pos.z)
	if dist >= 10000.0 then
		dist = 'Plus de 10 KM'
		streetname = GetStreetNameFromHashKey(GetStreetNameAtCoord(target.pos.x, target.pos.y, target.pos.z)).. " ("..dist..")"
	else
		streetname = GetStreetNameFromHashKey(GetStreetNameAtCoord(target.pos.x, target.pos.y, target.pos.z)).. " ("..math.ceil(dist).."m)"
	end
	
	callActive = true
	TriggerServerEvent('projectrpUtils:sendAnnounce', 'Centrale - Appel d\'urgence', 'Localisation: '..streetname..'\n\r\n\r\n\rInfos: '..msg, 'center-left', '#001A52', '#909296', target.icon, '#909296', 6000, GetPlayerServerId(PlayerId()))
	TriggerServerEvent('projectrpUtils:sendAnnounce', 'Centrale - Appel d\'urgence', 'Appuyez sur Y (Prendre l\'alerte) ou F (Refuser l\'alerte)', 'center-left', '#001A52', '#909296', target.icon, '#909296', 6000, GetPlayerServerId(PlayerId()))

	PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 0)	
	
end)

AddEventHandler('playerDropped', function()
	TriggerServerEvent("player:serviceOff", nil)
end)

RegisterCommand("annulerappel", function()
	if DoesBlipExist(target.blip) then
		RemoveBlip(target.blip)
	end	
end)