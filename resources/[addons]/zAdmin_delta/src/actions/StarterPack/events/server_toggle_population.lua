---@param player Player
---@param action Action
handleActionListener("server_toggle_population", 0, function(player, action)
    Session.populationEnabled = not Session.populationEnabled
    SetRoutingBucketPopulationEnabled(0, Session.populationEnabled)
    player:notifySuccess((Localization.actions_starterPack_server_toggle_population_cb):format(Utils.getStateByValue(Session.populationEnabled)))
end)