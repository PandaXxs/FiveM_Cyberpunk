ESX = exports.es_extended:getSharedObject()

local deadPeds = {}

RegisterServerEvent('loffe_robbery:pedDead')
AddEventHandler('loffe_robbery:pedDead', function(store)
    if not deadPeds[store] then
        deadPeds[store] = 'deadlol'
        TriggerClientEvent('loffe_robbery:onPedDeath', -1, store)
        local second = 1000
        local minute = 60 * second
        local hour = 60 * minute
        local cooldown = Config.Shops[store].cooldown
        local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second
        Wait(wait)
        if not Config.Shops[store].robbed then
            for k, v in pairs(deadPeds) do if k == store then table.remove(deadPeds, k) end end
            TriggerClientEvent('loffe_robbery:resetStore', -1, store)
        end
    end
end)

RegisterServerEvent('loffe_robbery:handsUp')
AddEventHandler('loffe_robbery:handsUp', function(store)
    TriggerClientEvent('loffe_robbery:handsUp', -1, store)
end)

RegisterServerEvent('loffe_robbery:pickUp')
AddEventHandler('loffe_robbery:pickUp', function(store, playerId, bag)
    print(playerId, source)
    if playerId == source then
        -- DeleteEntity(bag)
        local xPlayer = ESX.GetPlayerFromId(source)
        local randomAmount = math.random(Config.Shops[store].money[1], Config.Shops[store].money[2])
        xPlayer.addMoney(randomAmount)
        TriggerClientEvent('esx:showNotification', source, Translation[Config.Locale]['cashrecieved'] .. ' ~g~' .. randomAmount .. ' ' .. Translation[Config.Locale]['currency'])
    end
end)

ESX.RegisterServerCallback('loffe_robbery:canRob', function(source, cb, store)
    local cops = 0
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            cops = cops + 1
        end
    end
    if cops >= Config.Shops[store].cops then
        if not Config.Shops[store].robbed and not deadPeds[store] then
            cb(true)
        else
            cb(false)
        end
    else
        cb('no_cops')
    end
end)

RegisterServerEvent('loffe_robbery:kodaaa')
AddEventHandler('loffe_robbery:kodaaa', function(store)
    local src = source
    Config.Shops[store].robbed = true
    local xPlayers = ESX.GetPlayers()
    local xBraqueur = ESX.GetPlayerFromId(src)
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            TriggerClientEvent('loffe_robbery:msgPolice', xPlayer.source, store, src)
        end
    end
    sendToDiscord("Braquage", xBraqueur.name.." ["..src.."] a commencé un braquage de superette " ..store.."", 16711680)
end)
RegisterServerEvent('loffe_robbery:rob')
AddEventHandler('loffe_robbery:rob', function(store, playerId)
    local src = source
    Config.Shops[store].robbed = true
    local xPlayers = ESX.GetPlayers()
    local xBraqueur = ESX.GetPlayerFromId(src)
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            TriggerClientEvent('loffe_robbery:msgPolice', xPlayer.source, store, src)
        end
    end
    TriggerClientEvent('loffe_robbery:rob', source, store, playerId)
    --sendToDiscord("Braquage", xBraqueur.name.." ["..src.."] a commencé un braquage de superette" ..store.."", 16711680)
    Wait(30000)
    TriggerClientEvent('loffe_robbery:robberyOver', playerId)
    --sendToDiscord("Braquage", xBraqueur.name.." ["..src.."] a annulé son braquage de superette" ..store.."", 16711680)

    local second = 1000
    local minute = 60 * second
    local hour = 60 * minute
    local cooldown = Config.Shops[store].cooldown
    local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second
    Wait(wait)
    Config.Shops[store].robbed = false
    for k, v in pairs(deadPeds) do if k == store then table.remove(deadPeds, k) end end
    TriggerClientEvent('loffe_robbery:resetStore', -1, store)
    
end)

Citizen.CreateThread(function()
    while true do
        for i = 1, #deadPeds do TriggerClientEvent('loffe_robbery:pedDead', -1, i) end -- update dead peds
        Citizen.Wait(500)
    end
end)

function sendToDiscord (name,message,color)
	date_local1 = os.date('%H:%M:%S', os.time())
	local date_local = date_local1
	local DiscordWebHook = "https://discordapp.com/api/webhooks/725803059476955156/Mr2gjR2dOKK8CCG56Tim9pFnqglFJJopYVWz5jooScQXmkCbq2BfaGcIL5mHkeiM0dxQ"
	-- Modify here your discordWebHook username = name, content = message,embeds = embeds
  
  local embeds = {
	  {
		  ["title"]=message,
		  ["type"]="rich",
		  ["color"] =color,
		  ["footer"]=  {
			  ["text"]= "Heure: " ..date_local.. "",
		 },
	  }
  }
  
	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
  end
