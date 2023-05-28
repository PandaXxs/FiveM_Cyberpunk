projectrpUtilsCallback = {}
HackingActive = false
HackingTimer = 0
HackingCycle = 4000

function hidehack(success, timeremaining)
	if success then
		TriggerEvent('projectrpUtils.Hacking:hide')
		TriggerEvent("projectrpUtils:notify", "BRAQUAGE", "Vous avez réussi le piratage !", 'success')
		TriggerServerEvent("projectrpUtils:OpenDoorHoldUP", UpdateHoldUP)
		InHoldUP(UpdateHoldUP)
	else
		TriggerEvent('projectrpUtils.Hacking:hide')
		Fleeca.Notif  = false
		Fleeca.InHoldUP = false
		TriggerEvent("projectrpUtils:notify", "BRAQUAGE", "Vous avez échoué le piratage !", 'error')
	end
end

AddEventHandler('projectrpUtils.Hacking:show', function()
    NUIHackinMessage = {}
	NUIHackinMessage.show = true
	SendNUIMessage(NUIHackinMessage)
	SetNuiFocus(true, false)
end)

AddEventHandler('projectrpUtils.Hacking:hide', function()
    NUIHackinMessage = {}
	NUIHackinMessage.show = false
	SendNUIMessage(NUIHackinMessage)
	SetNuiFocus(false, false)
	HackingActive = false
end)

AddEventHandler('projectrpUtils.Hacking:start', function(solutionlength, duration, callback)
    projectrpUtilsCallback = callback
	NUIHackinMessage = {}
	NUIHackinMessage.s = solutionlength
	NUIHackinMessage.d = duration
	NUIHackinMessage.start = true
	SendNUIMessage(NUIHackinMessage)
	StartHackingHD()
end)

AddEventHandler('projectrpUtils.Hacking:setmessage', function(msg)
    NUIHackinMessage = {}
	NUIHackinMessage.displayMsg = msg
	SendNUIMessage(NUIHackinMessage)
end)

RegisterNUICallback('callback', function(data, cb)
	projectrpUtilsCallback(data.success, data.remainingtime)
    cb('ok')
end)