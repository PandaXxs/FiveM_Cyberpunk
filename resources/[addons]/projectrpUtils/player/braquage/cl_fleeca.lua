Fleeca = {
    Notif = false,
    InHoldUP = false,
    Number = 0,
}

Citizen.CreateThread(function()
	while true do
		local OthersWait = 500
		for i = 1,#Config.Locations.ProjectRP.Braquage do
			for _,v in pairs(Config.Locations.ProjectRP.Braquage[i].Pos) do
				local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.pos, true)
				if dist < 10 then 
					OthersWait = 1
					if not Fleeca.Notif then
						DrawMarker(22, v.pos.x, v.pos.y, v.pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
						if dist < 1.5 then
							ShowTextUI("Appuyez sur [E] pour commencer le braquage")
							textUI = true
							if IsControlJustPressed(1, 51) then 
								if not v.AlReady then
									StartHoldUPBank(i, v.pos)
								else
									TriggerEvent("projectrpUtils:notify", "BRAQUAGE", "Cette banque a déjà été braquer !", "error")
								end
							end
						elseif dist < 1.7 and textUI then
							textUI = nil
							HideTextUI()
						end
					end
				end
			end
		end
		Citizen.Wait(OthersWait) 
	end
end)

function StartHackingHD()
	HackingActive = true
	while HackingActive do
		Citizen.Wait(0)
		if HackingTimer > GetGameTimer() then
			HelpNotif("Naviguez avec ~y~Z,Q,S,D~s~ et confirmez avec ~y~ESPACE~s~ pour le bloc de code de gauche")
		elseif HackingTimer > GetGameTimer()-HackingCycle then
			HelpNotif("Utilisez les fléches  ~s~et~y~ ENTRER~s~ pour le bloc de code de droite")
		else
			HackingTimer = GetGameTimer()+HackingCycle
		end
		if IsEntityDead(PlayerPedId()) then
			NUIHackinMessage = {}
			NUIHackinMessage.fail = true
			SendNUIMessage(NUIHackinMessage)
		end
	end
end

function InHoldUP(HUP)
	Fleeca.InHoldUP = true
	while Fleeca.InHoldUP do
		Citizen.Wait(0)
		for _,v in pairs(Config.Locations.ProjectRP.Braquage[HUP].MarkerInHUP) do
			local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.pos, true)
			if dist < 10.0 then
				if not v.AlReady then
					DrawMarker(22, v.pos.x, v.pos.y, v.pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
					if dist < 1.0 then
						ShowTextUI("Appuyez sur [E] pour percer et récupérer l'argent")
						textUI = true
						if IsControlJustPressed(0, 38) then
							Citizen.CreateThread(function()
								if lib.progressCircle({
									duration = v.timeToRob,
									position = 'bottom',
									label = 'Ouverture du casier',
									useWhileDead = false,
									canCancel = true,
									disable = {
										car = true,
										move = true,
									},
									anim = {
										dict = 'anim@heists@fleeca_bank@drilling',
										clip = 'drill_straight_idle',
									},
									prop = {
										model = 'hei_prop_heist_drill',
										bone = 28422,
										pos = vec3(0.03, 0.03, 0.02),
										rot = vec3(0.0, 0.0, -1.5)
									},
								}) then
									Fleeca.Number = Fleeca.Number+1
									TriggerEvent("projectrpUtils:notify", "BRAQUAGE", "Vous avez reçu "..v.action.."$\nCasiers traités : "..Fleeca.Number.."/"..#Config.Locations.ProjectRP.Braquage[HUP].MarkerInHUP, 'success')
									TriggerServerEvent("projectrpUtils:HoldUPGiveMoney", v.action)
									v.AlReady = true
								end
							end) 
						end
					elseif dist < 1.2 and textUI then
						textUI = nil
						HideTextUI()
					end
				end
			end
		end
		if Fleeca.Number == #Config.Locations.ProjectRP.Braquage[HUP].MarkerInHUP then
			TriggerEvent("projectrpUtils:notify", "BRAQUAGE", "Braquage terminé ! vous avez récupéré tous les butins ($) !", 'success')
			Fleeca.InHoldUP = false
			Fleeca.Notif = false
			Fleeca.Number = 0
		end
	end
end

function StartHoldUPBank(HoldUP, Coords)
    ESX.TriggerServerCallback("projectrpUtils:CheckJobOnline", function(countcops)
        if countcops >= 0 then
            ESX.TriggerServerCallback("projectrpUtils:GetItemInventoryCount", function(count)
                if count > 0 then
                    UpdateHoldUP = HoldUP
                    TriggerEvent("projectrpUtils.Hacking:show")
                    TriggerEvent("projectrpUtils.Hacking:start", 4, 50, hidehack)
                    TriggerServerEvent("projectrpUtils:AlReadyHoldUP", HoldUP)
                    TriggerServerEvent("projectrpUtils:HoldUPSendAlerte", Coords)
					-- Log
                    Fleeca.Notif = true
					TriggerEvent("projectrpUtils:notify", "BRAQUAGE", "Vous avez commencé le braquage\nLa police a été alerté !", 'inform')
                else
					TriggerEvent("projectrpUtils:notify", "BRAQUAGE", "Vous n'avez pas de perceuse sur vous !", 'error')
                end
            end, "drill")
        else
			TriggerEvent("projectrpUtils:notify", "BRAQUAGE", "Il n'y a pas assez de policiers en ville !", 'inform')
        end
    end, "police")
end
