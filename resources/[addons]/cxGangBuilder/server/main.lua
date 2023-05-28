ESX = exports["es_extended"]:getSharedObject()
Gangs, securedEvents = {}, false 

MySQL.ready(function()
	SetTimeout(220, function()
		reloadGangs()
		MySQL.Async.execute("UPDATE gangs_vehicles SET stored = @stored", {
			["stored"] = 1
		})
	end)
end)

RegisterServerEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source, xPlayer)
	SetTimeout(220, function()
		reloadGangs(source)
	end)
end)

function reloadGangs(playerId)
	Gangs = {}
	MySQL.Async.fetchAll("SELECT * FROM gangs", {}, function(gangsResult)
		for _, value in pairs(gangsResult) do 
			Gangs[value.gangId] = value 
			Gangs[value.gangId].positions = json.decode(Gangs[value.gangId].positions)
			Gangs[value.gangId].blips = json.decode(Gangs[value.gangId].blips)
			Gangs[value.gangId].perms = json.decode(Gangs[value.gangId].perms)
		end
	end)
	Wait(220)
	if playerId ~= nil then 
		TriggerClientEvent("cxGangBuilder:refresh", playerId, Gangs)
	else
		TriggerClientEvent("cxGangBuilder:refresh", -1, Gangs)
	end
end

function checkValidation(playerId)
	local player = ESX.GetPlayerFromId(playerId)
	for gangId, value in pairs(Gangs) do 
		if player.job2.name == value.name then 
			return true 
		end
	end
	return false 
end

function getLastGrade(gangId)
	local grades = {}
	MySQL.Async.fetchAll("SELECT * FROM job_grades WHERE job_name = @job_name", {
		["job_name"] = Gangs[gangId].name
	}, function(gangsResult)
		for k,v in pairs(gangsResult) do 
			grades[#grades + 1] = v.grade 
		end
	end)
	Wait(120)
	table.sort(grades)
	return (grades[#grades])
end

function refreshStorage(gangId, playerId)
	MySQL.Async.fetchAll("SELECT * FROM gangs WHERE gangId = @gangId", {
		["gangId"] = gangId
	}, function(gangsResult)
		if GangBuilder.UseWeaponItem then 
			SetTimeout(120, function() TriggerClientEvent("cxGangBuilder:refreshStorage", playerId, json.decode(gangsResult[1].storage), nil, json.decode(gangsResult[1].money)) end)
		else
			SetTimeout(120, function() TriggerClientEvent("cxGangBuilder:refreshStorage", playerId, json.decode(gangsResult[1].storage), json.decode(gangsResult[1].weapons), json.decode(gangsResult[1].money)) end)
		end
	end)
end

function refreshGestion(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local allPlayers, gangsPlayers = ESX.GetPlayers(), {}
	for _, playerId in pairs(allPlayers) do 
		local players = ESX.GetPlayerFromId(playerId)
		if players.job2.name == xPlayer.job2.name then 
			gangsPlayers[#gangsPlayers + 1] = {
				playerId = players.source,
				name = ("%s"):format(players.getName()),
				grade = players.job2.grade,
				grade_name = players.job2.grade_name,
				grade_label = players.job2.grade_label
			}
		end
	end
	TriggerClientEvent("cxGangBuilder:refreshGestion", playerId, gangsPlayers)
end

function checkGroup(currentGroup)
	for _, group in pairs(GangBuilder.Groups) do 
		if currentGroup == group then 
			return true 
		end
	end
	return false 
end

function resetPlayerJob(currentJob)
	local allPlayers = ESX.GetPlayers()
	for _, playerId in pairs(allPlayers) do 
		local player = ESX.GetPlayerFromId(playerId)
		if player.job2.name == currentJob then 
			player.setJob2("unemployed", 0)
		end
	end
end

RegisterCommand("gangbuilder", function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not checkGroup(xPlayer.getGroup()) then 
		return xPlayer.showNotification("~r~Vous n'avez pas la permission d'utiliser cette commande.")
	end
	local gangs = {}
	MySQL.Async.fetchAll("SELECT * FROM gangs", {}, function(gangsResult)
		for _, value in pairs(gangsResult) do 
			gangs[value.gangId] = value 
			gangs[value.gangId].positions = json.decode(value.positions)
			gangs[value.gangId].blips = json.decode(value.blips)
		end
		TriggerClientEvent("cxGangBuilder:openMenu", source, gangs)
	end)
end)

RegisterServerEvent("cxGangBuilder:getMenu")
AddEventHandler("cxGangBuilder:getMenu", function(gangId, positionId)
	local source = source 
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer.job2.name == Gangs[gangId].name then 
		return 
	end 
	if not Gangs[gangId].perms[xPlayer.job2.grade][positionId] then 
		return xPlayer.showNotification("~r~Vous n'avez pas la permission.")
	end
	if positionId == "garage" then 
		MySQL.Async.fetchAll("SELECT * FROM gangs_vehicles WHERE gang_name = @gang_name", {
			["gang_name"] = Gangs[gangId].name
		}, function(gangsResult)
			for k,v in pairs(gangsResult) do 
				v.vehicle = json.decode(v.vehicle)
			end
			TriggerClientEvent("cxGangBuilder:openGarage", source, gangId, gangsResult)
		end)
	elseif positionId == "storage" then 
		MySQL.Async.fetchAll("SELECT * FROM gangs WHERE gangId = @gangId", {
			["gangId"] = gangId
		}, function(gangsResult)
			Wait(120)
			if GangBuilder.UseWeaponItem then 
				TriggerClientEvent("cxGangBuilder:openStorage", source, gangId, json.decode(gangsResult[1].storage), nil, json.decode(gangsResult[1].money))
			else
				TriggerClientEvent("cxGangBuilder:openStorage", source, gangId, json.decode(gangsResult[1].storage), json.decode(gangsResult[1].weapons), json.decode(gangsResult[1].money))
			end
		end)
	elseif positionId == "gestion" then 
		local allPlayers, gangsPlayers = ESX.GetPlayers(), {}
		for _, playerId in pairs(allPlayers) do 
			local players = ESX.GetPlayerFromId(playerId)
			if players.job2.name == xPlayer.job2.name then 
				gangsPlayers[#gangsPlayers + 1] = {
					playerId = players.source,
					name = ("%s"):format(players.getName()),
					grade = players.job2.grade,
					grade_name = players.job2.grade_name,
					grade_label = players.job2.grade_label
				}
			end
		end
		MySQL.Async.fetchAll("SELECT * FROM job_grades WHERE job_name = @job_name", {
			["job_name"] = Gangs[gangId].name
		}, function(gangsResult)
			TriggerClientEvent("cxGangBuilder:openGestion", source, gangId, gangsResult, gangsPlayers)
		end)
	end	
end)

RegisterServerEvent("cxGangBuilder:store")
AddEventHandler("cxGangBuilder:store", function(type, vehicleProps, gangId)
    local source = source 
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer.job2.name == Gangs[gangId].name then 
        return 
    end
    if type == "exit" then 
        MySQL.Async.fetchAll("SELECT * FROM gangs_vehicles WHERE gang_name = @gang_name", {
            ["gang_name"] = Gangs[gangId].name
        }, function(gangsResult)
            for k,v in pairs(gangsResult) do 
                if vehicleProps.plate == v.plate then 
                    MySQL.Async.execute("UPDATE gangs_vehicles SET stored = @stored WHERE plate = @plate", {
                        ["stored"] = 0,
                        ["plate"] = vehicleProps.plate
                    })
                end
            end
        end)
    elseif type == "store" then 
        MySQL.Async.fetchAll("SELECT * FROM gangs_vehicles WHERE gang_name = @gang_name", {
            ["gang_name"] = Gangs[gangId].name
        }, function(gangsResult)
            for k,v in pairs(gangsResult) do 
                if vehicleProps.plate == v.plate then 
                    MySQL.Async.execute("UPDATE gangs_vehicles SET stored = @stored, vehicle = @vehicle WHERE plate = @plate", {
                        ["stored"] = 1,
                        ["vehicle"] = json.encode(vehicleProps),
                        ["plate"] = vehicleProps.plate
                    })
                    TriggerClientEvent("cxGangBuilder:deleteVeh", source)
                end
            end
        end)
    end
end) 

--[[RegisterServerEvent("cxGangBuilder:store")
AddEventHandler("cxGangBuilder:store", function(type, vehicleProps, gangId)
	local source = source 
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer.job2.name == Gangs[gangId].name then 
		return 
	end
	if type == "exit" then 
		MySQL.Async.fetchAll("SELECT * FROM gangs_vehicles WHERE gang_name = @gang_name", {
			["gang_name"] = Gangs[gangId].name
		}, function(gangsResult)
			for k,v in pairs(gangsResult) do 
				if vehicleProps.plate == v.plate then 
					MySQL.Async.execute("UPDATE gangs_vehicles SET stored = @stored WHERE plate = @plate", {
						["stored"] = 0,
						["plate"] = vehicleProps.plate
					})
				end
			end
		end)
	elseif type == "store" then 
		MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @owner", {
			["owner"] = xPlayer.getIdentifier()
		}, function(ownedResult)
			for k,v in pairs(ownedResult) do 
				if vehicleProps.plate == v.plate then 
					MySQL.Async.execute('INSERT INTO gangs_vehicles (gang_name, vehicle, plate, stored) VALUES (@gang_name, @vehicle, @plate, @stored)', {
						["gang_name"] = Gangs[gangId].name,
						["vehicle"] = json.encode(vehicleProps),
						["plate"] = vehicleProps.plate,
						["stored"] = 1
					})
					MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
						['@plate'] = vehicleProps.plate
					})
					TriggerClientEvent("cxGangBuilder:deleteVeh", source)
				else
					MySQL.Async.fetchAll("SELECT * FROM gangs_vehicles WHERE gang_name = @gang_name", {
						["gang_name"] = Gangs[gangId].name
					}, function(gangsResult)
						for k,v in pairs(gangsResult) do 
							if vehicleProps.plate == v.plate then 
								MySQL.Async.execute("UPDATE gangs_vehicles SET stored = @stored, vehicle = @vehicle WHERE plate = @plate", {
									["stored"] = 1,
									["vehicle"] = json.encode(vehicleProps),
									["plate"] = vehicleProps.plate
								})
								TriggerClientEvent("cxGangBuilder:deleteVeh", source)
							end
						end
					end)
				end
			end
		end)
	end
end) ]]

RegisterServerEvent("cxGangBuilder:create")
AddEventHandler("cxGangBuilder:create", function(gangs)
	local source = source 
	local xPlayer = ESX.GetPlayerFromId(source)
	if not checkGroup(xPlayer.getGroup()) then 
		return xPlayer.showNotification("~r~Vous n'avez pas la permission d'utiliser cette commande.")
	end
	local perms = {}
	print(json.encode(gangs))
	for k,v in pairs(gangs.grades) do 
		perms[k] = {
			["storage"] = true,
			["takeWeapon"] = true, 
			["takeItem"] = true,
			["gestion"] = true, 
        	["garage"] = true,
			["withdrawMoney"] = true
		}
	end
    MySQL.Async.execute('INSERT INTO jobs (name, label) VALUES (@name, @label)', {
        ["name"] = gangs.name,
        ["label"] = gangs.label
    })
	for gradeId, grade in pairs(gangs.grades) do 
		MySQL.Async.execute('INSERT INTO job_grades (job_name, grade, name, label, salary, skin_male, skin_female) VALUES (@job_name, @grade, @name, @label, @salary, @skin_male, @skin_female)', {
			["job_name"] = gangs.name,
			["grade"] = gradeId,
			["name"] = grade.name,
			["label"] = grade.label,
			["salary"] = GangBuilder.Salary,
			["skin_male"] = "{}",
			["skin_female"] = "{}"
		})
	end
	print("gangs.name : "..gangs.name, "gangs.label : "..gangs.label, "gangs.grades : "..json.encode(gangs.grades))
	ESX.AddOrg(gangs.name, gangs.label, gangs.grades)
	MySQL.Async.execute('INSERT INTO gangs (name, label, positions, blips, perms) VALUES (@name, @label, @positions, @blips, @perms)', {
        ["name"] = gangs.name,
        ["label"] = gangs.label,
		["positions"] = json.encode(gangs.positions),
		["blips"] = json.encode(gangs.blips),
		["perms"] = json.encode(perms)
    })
	Wait(120)
	for k,v in pairs(gangs.vehicles) do 
		MySQL.Async.execute('INSERT INTO gangs_vehicles (gang_name, vehicle, plate, stored) VALUES (@gang_name, @vehicle, @plate, @stored)', {
			["gang_name"] = gangs.name,
			["vehicle"] = json.encode(v.props),
			["plate"] = v.props.plate,
			["stored"] = v.stored
		})
	end
	reloadGangs()
	SetTimeout(220, function() TriggerClientEvent("cxGangBuilder:refreshList", source, Gangs) end)
end)

RegisterServerEvent("cxGangBuilder:depositItem")
AddEventHandler("cxGangBuilder:depositItem", function(count, itemName, gangId, data)
	if securedEvents then return end 
	local source = source 
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer.job2.name == Gangs[gangId].name then 
		return 
	end 
	local storage = data 
	if not storage then storage = {} end 
	if xPlayer.getInventoryItem(itemName).count < count then 
		return xPlayer.showNotification("~r~Vous n'avez pas autant sur vous..~s~")
	end
	securedEvents = true 
	if storage[itemName] then 
		storage[itemName].count = storage[itemName].count + count 
	else
		storage[itemName] = {count = count, name = itemName, label = ESX.GetItemLabel(itemName)}
	end
	MySQL.Async.execute("UPDATE gangs SET storage = @storage WHERE gangId = @gangId", {
		["storage"] = json.encode(storage),
		["gangId"] = gangId
	})
	xPlayer.showNotification(("Vous avez déposé ~b~x%s %s~s~."):format(count, ESX.GetItemLabel(itemName)))
	xPlayer.removeInventoryItem(itemName, count)
	SetTimeout(120, function() refreshStorage(gangId, source) Wait(220) securedEvents = false end)
end)

RegisterServerEvent("cxGangBuilder:withdrawItem")
AddEventHandler("cxGangBuilder:withdrawItem", function(count, itemName, gangId, data)
	if securedEvents then return end 
	local source = source 
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer.job2.name == Gangs[gangId].name then 
		return 
	end 
	local storage = data 
	if not storage[itemName] then return end 
	if not Gangs[gangId].perms[xPlayer.job2.grade]["takeItem"] then 
		return xPlayer.showNotification("~r~Vous n'avez pas la permission.")
	end
	if not xPlayer.canCarryItem(itemName, count) then 
		return xPlayer.showNotification("~r~Vous ne pouvez pas en porter autant sur vous..~s~")
	end
	securedEvents = true 
	if (storage[itemName].count - count) == 0 then 
		storage[itemName] = nil 
	else
		storage[itemName].count = storage[itemName].count - count 
	end
	MySQL.Async.execute("UPDATE gangs SET storage = @storage WHERE gangId = @gangId", {
		["storage"] = json.encode(storage),
		["gangId"] = gangId
	})
	xPlayer.showNotification(("Vous avez retiré ~b~x%s %s~s~."):format(count, ESX.GetItemLabel(itemName)))
	xPlayer.addInventoryItem(itemName, count)
	SetTimeout(120, function() refreshStorage(gangId, source) Wait(220) securedEvents = false end)
end)

RegisterServerEvent("cxGangBuilder:depositWeapon")
AddEventHandler("cxGangBuilder:depositWeapon", function(ammo, weaponHash, weaponName, gangId, data)
	if securedEvents then return end 
	local source = source 
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer.job2.name == Gangs[gangId].name then 
		return 
	end 
	local storage = data 
	if not storage then storage = {} end 
	if not xPlayer.getWeapon(weaponName) then 
		return xPlayer.showNotification("~r~Vous ne possédez pas cette arme..~s~")
	end
	securedEvents = true 
	storage[#storage + 1] = {hash = weaponHash, ammo = ammo, name = weaponName}
	MySQL.Async.execute("UPDATE gangs SET weapons = @weapons WHERE gangId = @gangId", {
		["weapons"] = json.encode(storage),
		["gangId"] = gangId
	})
	xPlayer.removeWeapon(weaponName)
	xPlayer.showNotification(("Vous avez déposé ~b~x1 %s~s~."):format(ESX.GetWeaponLabel(weaponName)))
	SetTimeout(120, function() refreshStorage(gangId, source) Wait(220) securedEvents = false end)
end)

RegisterServerEvent("cxGangBuilder:depositMoney")
AddEventHandler("cxGangBuilder:depositMoney", function(gangId, data, type, amount)
    if securedEvents then return end 
    local source = source 
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer.job2.name == Gangs[gangId].name then 
        return 
    end 
    if type == "money" then 
        if xPlayer.getMoney() < amount then 
            return xPlayer.showNotification("~r~Vous n'avez pas autant d'argent sur vous.")
        end
        data[type] = data[type] + amount
        MySQL.Async.execute("UPDATE gangs SET money = @money WHERE gangId = @gangId", {
            ["money"] = json.encode(data),
            ["gangId"] = gangId
        })
        xPlayer.removeMoney(amount)
        xPlayer.showNotification(("Vous avez déposé ~g~%s $~s~."):format(amount))
    elseif type == "black_money" then 
        if xPlayer.getAccount('black_money').money < amount then 
            return xPlayer.showNotification("~r~Vous n'avez pas autant d'argent sur vous.")
        end
        data[type] = data[type] + amount
        MySQL.Async.execute("UPDATE gangs SET money = @money WHERE gangId = @gangId", {
            ["money"] = json.encode(data),
            ["gangId"] = gangId
        })
        xPlayer.removeAccountMoney('black_money', amount)
        xPlayer.showNotification(("Vous avez déposé ~r~%s $~s~."):format(amount))
    end
    SetTimeout(120, function() refreshStorage(gangId, source) Wait(220) securedEvents = false end)
end)

--[[RegisterServerEvent("cxGangBuilder:depositMoney")
AddEventHandler("cxGangBuilder:depositMoney", function(gangId, data, type, amount)
	if securedEvents then return end 
	local source = source 
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer.job2.name == Gangs[gangId].name then 
		return 
	end 
	data[type] = data[type] + amount
	MySQL.Async.execute("UPDATE gangs SET money = @money WHERE gangId = @gangId", {
		["money"] = json.encode(data),
		["gangId"] = gangId
	})
	if type == "money" then 
		if xPlayer.getMoney() < amount then 
			return xPlayer.showNotification("~r~Vous n'avez pas autant d'argent sur vous.")
		end
		xPlayer.removeMoney(amount)
		xPlayer.showNotification(("Vous avez déposé ~g~%s $~s~."):format(amount))
	elseif type == "black_money" then 
		if xPlayer.getAccount('black_money').money < amount then 
			return xPlayer.showNotification("~r~Vous n'avez pas autant d'argent sur vous.")
		end
		xPlayer.removeAccountMoney('black_money', amount)
		xPlayer.showNotification(("Vous avez déposé ~r~%s $~s~."):format(amount))
	end
	SetTimeout(120, function() refreshStorage(gangId, source) Wait(220) securedEvents = false end)
end) ]]

RegisterServerEvent("cxGangBuilder:withdrawMoney")
AddEventHandler("cxGangBuilder:withdrawMoney", function(gangId, data, type, amount)
	if securedEvents then return end 
	local source = source 
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer.job2.name == Gangs[gangId].name then 
		return 
	end 
	if not Gangs[gangId].perms[xPlayer.job2.grade]["withdrawMoney"] then 
		return xPlayer.showNotification("~r~Vous n'avez pas la permission.")
	end
	if data[type] < amount then 
		return xPlayer.showNotification("~r~Vous n'avez pas autant d'argent dans le stockage.")
	end
	data[type] = data[type] - amount
	MySQL.Async.execute("UPDATE gangs SET money = @money WHERE gangId = @gangId", {
		["money"] = json.encode(data),
		["gangId"] = gangId
	})
	if type == "money" then 
		xPlayer.addMoney(amount)
		xPlayer.showNotification(("Vous avez retiré ~g~%s $~s~."):format(amount))
	elseif type == "black_money" then 
		xPlayer.addAccountMoney('black_money', amount)
		xPlayer.showNotification(("Vous avez retiré ~r~%s $~s~."):format(amount))
	end
	SetTimeout(120, function() refreshStorage(gangId, source) Wait(220) securedEvents = false end)
end)

RegisterServerEvent("cxGangBuilder:withdrawWeapon")
AddEventHandler("cxGangBuilder:withdrawWeapon", function(weaponId, ammo, weaponName, gangId, data)
	if securedEvents then return end 
	local source = source 
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer.job2.name == Gangs[gangId].name then 
		return 
	end 
	if not Gangs[gangId].perms[xPlayer.job2.grade]["takeWeapon"] then 
		return xPlayer.showNotification("~r~Vous n'avez pas la permission.")
	end
	local storage = data 
	if xPlayer.getWeapon(weaponName) then 
		return xPlayer.showNotification("~r~Vous possédez déjà cette arme..~s~")
	end
	securedEvents = true 
	storage[weaponId] = nil
	MySQL.Async.execute("UPDATE gangs SET weapons = @weapons WHERE gangId = @gangId", {
		["weapons"] = json.encode(storage),
		["gangId"] = gangId
	})
	xPlayer.addWeapon(weaponName, ammo)
	xPlayer.showNotification(("Vous avez retiré ~b~x1 %s~s~."):format(ESX.GetWeaponLabel(weaponName)))
	SetTimeout(120, function() refreshStorage(gangId, source) Wait(220) securedEvents = false end)
end)

RegisterServerEvent("cxGangBuilder:perms")
AddEventHandler("cxGangBuilder:perms", function(gangId, gradeId, dataValue, dataType)
	if securedEvents then return end 
	local source = source 
	local xPlayer = ESX.GetPlayerFromId(source) 
	if not xPlayer.job2.name == Gangs[gangId].name then 
		return 
	end 
	if not xPlayer.job2.grade_name == "boss" then 
		return 
	end 
	if gangId == nil then return end 
	Gangs[gangId].perms[gradeId][dataType] = dataValue
	MySQL.Async.execute("UPDATE gangs SET perms = @perms WHERE gangId = @gangId", {
		["perms"] = json.encode(Gangs[gangId].perms),
		["gangId"] = gangId
	})
	SetTimeout(120, function() reloadGangs() Wait(220) securedEvents = false end)
end)

RegisterServerEvent("cxGangBuilder:deleteGang")
AddEventHandler("cxGangBuilder:deleteGang", function(gangId)
	if securedEvents then return end 
	local source = source 
	local xPlayer = ESX.GetPlayerFromId(source) 
	if not checkGroup(xPlayer.getGroup()) then 
		return xPlayer.showNotification("~r~Vous n'avez pas la permission d'utiliser cet event.")
	end
	if gangId == nil then return end 
	MySQL.Async.execute('DELETE FROM gangs WHERE gangId = @gangId', {
		['@gangId'] = gangId
	})
	MySQL.Async.execute('DELETE FROM jobs WHERE name = @name', {
		['@name'] = Gangs[gangId].name
	})
	MySQL.Async.execute('DELETE FROM job_grades WHERE job_name = @job_name', {
		['@job_name'] = Gangs[gangId].name
	})

	MySQL.Async.execute('DELETE FROM gangs_vehicles WHERE gang_name = @gang_name', {
		['@gang_name'] = Gangs[gangId].name
	})
	resetPlayerJob(Gangs[gangId].name)
	xPlayer.showNotification(("~g~Suppression du gang %s avec succès."):format(Gangs[gangId].name))
	SetTimeout(120, function() reloadGangs() Wait(220) securedEvents = false TriggerClientEvent("cxGangBuilder:refreshList", source, Gangs) end)
end)

RegisterServerEvent("cxGangBuilder:updatePosition")
AddEventHandler("cxGangBuilder:updatePosition", function(gangId, data)
	if securedEvents then return end 
	local source = source 
	local xPlayer = ESX.GetPlayerFromId(source) 
	if not checkGroup(xPlayer.getGroup()) then 
		return xPlayer.showNotification("~r~Vous n'avez pas la permission d'utiliser cet event.")
	end
	if gangId == nil then return end 
	for positionId, value in pairs(data) do 
		if Gangs[gangId].positions[positionId] then 
			Gangs[gangId].positions[positionId] = data[positionId]
		end
	end
	MySQL.Async.execute("UPDATE gangs SET positions = @positions WHERE gangId = @gangId", {
		["gangId"] = gangId,
		["positions"] = json.encode(Gangs[gangId].positions)
	})
	SetTimeout(120, function() reloadGangs() Wait(220) securedEvents = false end)
end)

RegisterServerEvent("cxGangBuilder:updateBlips")
AddEventHandler("cxGangBuilder:updateBlips", function(gangId, data)
	if securedEvents then return end 
	local source = source 
	local xPlayer = ESX.GetPlayerFromId(source) 
	if not checkGroup(xPlayer.getGroup()) then 
		return xPlayer.showNotification("~r~Vous n'avez pas la permission d'utiliser cet event.")
	end
	if gangId == nil then return end 
	for index, value in pairs(data) do 
		if Gangs[gangId].blips[index] ~= nil then 
			Gangs[gangId].blips[index] = data[index]
		end
	end
	MySQL.Async.execute("UPDATE gangs SET blips = @blips WHERE gangId = @gangId", {
		["gangId"] = gangId,
		["blips"] = json.encode(Gangs[gangId].blips)
	})
	SetTimeout(120, function() reloadGangs() Wait(220) securedEvents = false end)
end)

RegisterServerEvent("cxGangBuilder:upgradeJob")
AddEventHandler("cxGangBuilder:upgradeJob", function(type, gangId, playerId, newGrade)
	if securedEvents then return end 
	local source = source 
	local xPlayer = ESX.GetPlayerFromId(source) 
	if not xPlayer.job2.name == Gangs[gangId].name then 
		return 
	end 
	local xTarget = ESX.GetPlayerFromId(playerId)
	if type == "promote" then 
		xTarget.setJob2(Gangs[gangId].name, newGrade)
		xPlayer.showNotification(("Vous avez promu : ~b~%s~s~."):format(xTarget.getName()))
		xTarget.showNotification(("Vous avez été promu par ~b~%s~s~."):format(xPlayer.getName()))
	elseif type == "demote" then 
			xTarget.setJob2(Gangs[gangId].name, newGrade)
			xPlayer.showNotification(("Vous avez rétrogradé : ~b~%s~s~."):format(xTarget.getName()))
			xTarget.showNotification(("Vous avez été rétrogradé par ~b~%s~s~."):format(xPlayer.getName()))
	elseif type == "exiting" then 
		xTarget.setJob2("unemployed", 0)
		xPlayer.showNotification(("Vous avez expulsé du gang : ~b~%s~s~."):format(xTarget.getName()))
		xTarget.showNotification(("Vous avez été expulsé du gang : ~b~%s~s~."):format(Gangs[gangId].label))
	elseif type == "recrutment" then 
		if xTarget.job2.name == Gangs[gangId].name then 
			return xPlayer.showNotification(("~b~%s~s~ est déjà membre du gang : ~b~%s~s~."):format(xTarget.getName(), Gangs[gangId].label))
		end
		xTarget.setJob2(Gangs[gangId].name, getLastGrade(gangId))
		xPlayer.showNotification(("Vous avez recruté : ~b~%s~s~."):format(xTarget.getName()))
		xTarget.showNotification(("Vous avez été récruté par le gang : ~b~%s~s~."):format(Gangs[gangId].label))
	end
	SetTimeout(220, function() refreshGestion(source) securedEvents = false end)
end)

RegisterServerEvent("cxGangBuilder:checkInteract")
AddEventHandler("cxGangBuilder:checkInteract", function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	local validGang = checkValidation(source)
	if not validGang then 
		return xPlayer.showNotification("~r~Vous ne faites partit d'aucun gang.~s~")
	end
	TriggerClientEvent("cxGangBuilder:interactMenu", source)
end)

RegisterServerEvent("cxGangBuilder:handCuff")
AddEventHandler("cxGangBuilder:handCuff", function(type, playerId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	local validGang = checkValidation(source)
	if not validGang then 
		return xPlayer.showNotification("~r~Vous ne faites partit d'aucun gang.~s~")
	end
	if type == "handcuff" then 
		TriggerClientEvent("cxGangBuilder:handCuffPlayer", playerId)
	elseif type == "drag" then 
		TriggerClientEvent("cxGangBuilder:dragPlayer", playerId, source)
	end
end)

ESX.RegisterServerCallback('cxGangBuilder:getPlayerData', function(source, cb, playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local playerData = {
		inventory = xPlayer.inventory,
		weapons = xPlayer.loadout,
		accounts = xPlayer.getAccounts()
	}
	cb(playerData)
end)