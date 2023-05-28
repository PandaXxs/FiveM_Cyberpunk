
-- SEED USABLE ITEM REGISTER
-- Register every seed only changing the name of it between ''

ESX.RegisterUsableItem('weed_lemonhaze_seed', function(playerId)
	plant(playerId, 'weed_lemonhaze_seed')
end)

-- DRUGS USABLE ITEM REGISTER
-- Register every drug only changing the name of it between ''

ESX.RegisterUsableItem('weed_lemonhaze', function(playerId)
	drug(playerId, 'weed_lemonhaze')
end)

ESX.RegisterUsableItem('synthecoke', function(playerId)
	drug(playerId, 'synthecoke')
end)

ESX.RegisterUsableItem('ampoulesmash', function(playerId)
	drug(playerId, 'ampoulesmash')
end)

ESX.RegisterUsableItem('pilluledorph', function(playerId)
	drug(playerId, 'pilluledorph')
end)

-- PROCCESING TABLE ITEM REGISTER
-- Register every proccesing table only changing the name of it between ''

ESX.RegisterUsableItem('table_synthecoke', function(playerId)
		proccesing(playerId, 'table_synthecoke')
end)

ESX.RegisterUsableItem('table_smash', function(playerId)
	proccesing(playerId, 'table_smash')
end)

ESX.RegisterUsableItem('table_dorph', function(playerId)
	proccesing(playerId, 'table_dorph')
end)
