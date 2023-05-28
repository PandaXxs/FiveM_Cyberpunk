local animPlaying = false
local usingMachine = false
local VendingObject = nil
local itemItem = nil
local itemCost = nil
local itemName = nil
local itemProp = nil

function ouverture()
	local wait = 750
	while true do
        if nearVendingMachine() and not usingMachine and not IsPedInAnyVehicle(PlayerPedId(), 1) then
            wait = 5
			DrawTopNotification("Appuyez sur ~INPUT_PICKUP~ pour acheter ~g~" .. itemName .. "~s~ pour ~g~$" .. itemCost)
			if IsControlJustPressed(1, 38) then
				ESX.TriggerServerCallback('esx_vending:checkMoneyandInvent', function(response)
					if response == "cash" then
						ESX.ShowNotification("~r~Vous n'avez pas assez d'argent")
					elseif response == "inventory" then
						ESX.ShowNotification("Tu n'a plus assez de place pour ~y~" .. itemName)
					else
						usingMachine = true
						local ped = PlayerPedId()
						local position = GetOffsetFromEntityInWorldCoords(VendingObject, 0.0, -0.97, 0.05)
						TaskTurnPedToFaceEntity(ped, VendingObject, -1)
						ReqAnimDict("mini@sprunk")
						RequestAmbientAudioBank("VENDING_MACHINE")
						HintAmbientAudioBank("VENDING_MACHINE", 0, -1)
						SetPedCurrentWeaponVisible(ped, false, true, 1, 0)
						ReqTheModel("prop_ecola_can")
						SetPedResetFlag(ped, 322, true)
						if not IsEntityAtCoord(ped, position, 0.1, 0.1, 0.1, false, true, 0) then
							TaskGoStraightToCoord(ped, position, 1.0, 20000, GetEntityHeading(VendingObject), 0.1)
							while not IsEntityAtCoord(ped, position, 0.1, 0.1, 0.1, false, true, 0) do
								Citizen.Wait(2000)
							end
						end
						TaskTurnPedToFaceEntity(ped, VendingObject, -1)
						Citizen.Wait(1000)
						TaskPlayAnim(ped, "mini@sprunk", "plyr_buy_drink_pt1", 8.0, 5.0, -1, true, 1, 0, 0, 0)
						Citizen.Wait(2500)
						local canModel = CreateObjectNoOffset("prop_ecola_can", position, true, false, false)
						SetEntityAsMissionEntity(canModel, true, true)
						SetEntityProofs(canModel, false, true, false, false, false, false, 0, false)
						AttachEntityToEntity(canModel, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
						Citizen.Wait(1700)
						ReqAnimDict("mp_common_miss")
						TaskPlayAnim(ped, "mp_common_miss", "put_away_coke", 8.0, 5.0, -1, true, 1, 0, 0, 0)
						Citizen.Wait(1000)
						ClearPedTasks(ped)
						ReleaseAmbientAudioBank()
						RemoveAnimDict("mini@sprunk")
						RemoveAnimDict("mp_common_miss")
						if DoesEntityExist(canModel) then
							DetachEntity(canModel, true, true)
							DeleteEntity(canModel)
						end
						SetModelAsNoLongerNeeded("prop_ecola_can")
						usingMachine = false
					end
				end, itemItem)
            end
        else
            wait = 750
		end
		Citizen.Wait(wait)
	end
end

Machines = {
	{
		model = `prop_vend_soda_01`, -- Model name
		item = "ecola", -- Database item name
		name = "E-Cola", -- Friendly display name
		prop = "prop_ecola_can", -- Prop to spawn falling in machine
		price = 4 -- Purchase price
	},
	{
		model = `prop_vend_soda_02`, 
		item = "sprunk",
		name = "Sprunk",
		prop = "prop_ld_can_01",
		price = 4
	},
	{
		model = `prop_vend_snak_01`,
		item = "p&qs",
		name = "Ps & Qs",
		prop = "prop_candy_pqs",
		price = 6
	}
}

function sellsodaDistribSprunk()
	if nearVendingMachine() and not usingMachine and not IsPedInAnyVehicle(PlayerPedId(), 1) then
		ESX.TriggerServerCallback('IfHasMoneyDistrib', function(cb)
			if cb then
				usingMachine = true
				local ped = PlayerPedId()
				local position = GetOffsetFromEntityInWorldCoords(VendingObject, 0.0, -0.97, 0.05)
				TaskTurnPedToFaceEntity(ped, VendingObject, -1)
				ReqAnimDict("mini@sprunk")
				RequestAmbientAudioBank("VENDING_MACHINE")
				HintAmbientAudioBank("VENDING_MACHINE", 0, -1)
				SetPedCurrentWeaponVisible(ped, false, true, 1, 0)
				ReqTheModel("prop_ecola_can")
				SetPedResetFlag(ped, 322, true)
				if not IsEntityAtCoord(ped, position, 0.1, 0.1, 0.1, false, true, 0) then
					TaskGoStraightToCoord(ped, position, 1.0, 20000, GetEntityHeading(VendingObject), 0.1)
					while not IsEntityAtCoord(ped, position, 0.1, 0.1, 0.1, false, true, 0) do
						Citizen.Wait(2000)
					end
				end
				TaskTurnPedToFaceEntity(ped, VendingObject, -1)
				Citizen.Wait(1000)
				TaskPlayAnim(ped, "mini@sprunk", "plyr_buy_drink_pt1", 8.0, 5.0, -1, true, 1, 0, 0, 0)
				Citizen.Wait(2500)
				local canModel = CreateObjectNoOffset("prop_ecola_can", position, true, false, false)
				SetEntityAsMissionEntity(canModel, true, true)
				SetEntityProofs(canModel, false, true, false, false, false, false, 0, false)
				AttachEntityToEntity(canModel, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
				Citizen.Wait(1700)
				ReqAnimDict("mp_common_miss")
				TaskPlayAnim(ped, "mp_common_miss", "put_away_coke", 8.0, 5.0, -1, true, 1, 0, 0, 0)
				Citizen.Wait(1000)
				ClearPedTasks(ped)
				ReleaseAmbientAudioBank()
				RemoveAnimDict("mini@sprunk")
				RemoveAnimDict("mp_common_miss")
				if DoesEntityExist(canModel) then
					DetachEntity(canModel, true, true)
					DeleteEntity(canModel)
				end
				SetModelAsNoLongerNeeded("prop_ecola_can")
				usingMachine = false
			else
				ESX.ShowNotification("~r~Vous n\'avez pas assez d\'argent.")
			end
		end, Config.PriceDistrib, "sprunk")
	end
end

function sellsodaDistrib()
	if nearVendingMachine() and not usingMachine and not IsPedInAnyVehicle(PlayerPedId(), 1) then
		ESX.TriggerServerCallback('IfHasMoneyDistrib', function(cb)
			if cb then
				usingMachine = true
				local ped = PlayerPedId()
				local position = GetOffsetFromEntityInWorldCoords(VendingObject, 0.0, -0.97, 0.05)
				TaskTurnPedToFaceEntity(ped, VendingObject, -1)
				ReqAnimDict("mini@sprunk")
				RequestAmbientAudioBank("VENDING_MACHINE")
				HintAmbientAudioBank("VENDING_MACHINE", 0, -1)
				SetPedCurrentWeaponVisible(ped, false, true, 1, 0)
				ReqTheModel("prop_ecola_can")
				SetPedResetFlag(ped, 322, true)
				if not IsEntityAtCoord(ped, position, 0.1, 0.1, 0.1, false, true, 0) then
					TaskGoStraightToCoord(ped, position, 1.0, 20000, GetEntityHeading(VendingObject), 0.1)
					while not IsEntityAtCoord(ped, position, 0.1, 0.1, 0.1, false, true, 0) do
						Citizen.Wait(2000)
					end
				end
				TaskTurnPedToFaceEntity(ped, VendingObject, -1)
				Citizen.Wait(1000)
				TaskPlayAnim(ped, "mini@sprunk", "plyr_buy_drink_pt1", 8.0, 5.0, -1, true, 1, 0, 0, 0)
				Citizen.Wait(2500)
				local canModel = CreateObjectNoOffset("prop_ecola_can", position, true, false, false)
				SetEntityAsMissionEntity(canModel, true, true)
				SetEntityProofs(canModel, false, true, false, false, false, false, 0, false)
				AttachEntityToEntity(canModel, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
				Citizen.Wait(1700)
				ReqAnimDict("mp_common_miss")
				TaskPlayAnim(ped, "mp_common_miss", "put_away_coke", 8.0, 5.0, -1, true, 1, 0, 0, 0)
				Citizen.Wait(1000)
				ClearPedTasks(ped)
				ReleaseAmbientAudioBank()
				RemoveAnimDict("mini@sprunk")
				RemoveAnimDict("mp_common_miss")
				if DoesEntityExist(canModel) then
					DetachEntity(canModel, true, true)
					DeleteEntity(canModel)
				end
				SetModelAsNoLongerNeeded("prop_ecola_can")
				usingMachine = false
			else
				ESX.ShowNotification("~r~Vous n\'avez pas assez d\'argent.")
			end
		end, Config.PriceDistrib, "ecola")
	end
end

function nearVendingMachine()
	local player = PlayerPedId()
	local playerLoc = GetEntityCoords(player, 0)
	local wait = 750

	for _, machine in ipairs(Machines) do
		VendingObject = GetClosestObjectOfType(playerLoc, 0.6, machine.model, false)
		if DoesEntityExist(VendingObject) then
			itemItem = machine.item
			itemCost = machine.price
			itemName = machine.name
			itemProp = machine.prop
            return true
		end
		wait = 5
	end
	Citizen.Wait(wait)
	return false
end

function ReqTheModel(model)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(0)
	end
end

function ReqAnimDict(animDict)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(0)
	end
end


local distribinteract = {
    {
      name = 'soda',
      icon = 'fa-solid fa-glass-water"',
      label = 'Acheter du E-Cola',
      canInteract = function(entity, distance, coords, name, bone)
          return true
      end,
      onSelect = function()
        sellsodaDistrib()
      end,
  },
  {
      name = 'soda2',
      icon = 'fa-solid fa-glass-water"',
      label = "Acheter du Sprunk",
      canInteract = function(entity, distance, coords, name, bone)
          return true
      end,
      onSelect = function()
        sellsodaDistribSprunk()
      end,
  },
  }
  
  local modelsdistrib = { `prop_vend_soda_01`, `prop_vend_soda_02`}
  
  exports.ox_target:addModel(modelsdistrib, distribinteract)
  
  