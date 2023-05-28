---@param player Player
---@param action Action
handleActionListener("player_wipe", 0, function(player, action, targetServerId, staffPlayer, wipeConfirm)
    local Player = ESX.GetPlayerFromId(targetServerId)
    if not Player then return false end

    if wipeConfirm == "oui" then
        if staffPlayer == targetServerId then
            TriggerClientEvent("esx:showNotification", staffPlayer, "~r~Vous ne pouvez pas vous wipez vous même !")
        else
            local PlayerUniqueID = Player.getIdentifier()
            Functions.kickPlayer(targetServerId, "Wipe en cours, merci de vous reconnecter dans quelques minutes..")
            Functions.wipePlayer(PlayerUniqueID)
        end
    end
end)