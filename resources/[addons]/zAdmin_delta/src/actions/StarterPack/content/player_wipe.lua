--- @param localPlayer Player
--- @param action Action
local onAction <const> = function(localPlayer, action, targetServerId)
    local staffPlayer = localPlayer.serverId
    local wipeConfirm = Utils:showKeyboard(Localization.generic_wipe_confirm, "", 3, false)
    if (not wipeConfirm or wipeConfirm == "") then
        return false
    end
    action:triggerListener(0, targetServerId, staffPlayer, wipeConfirm)
    return true
end

Action.new()
      :setId("player_wipe")
      :setLabel(("~r~%s"):format(Localization.actions_starterPack_player_wipe))
      :setPermission("player.wipe")
      :setRetention(ActionRetention.PLAYER)
      :setType(ActionType.SIMPLE)
      :setFlag(ActionFlag.MENU_ELEMENT_POSITION, 9)
      :setFlag(ActionFlag.NET_ACTION)
      :setFlag(ActionFlag.NET_NEED_RESPONSE)
      :setHandlerTable(onAction)
      :build()