--- @param localPlayer Player
--- @param action Action
local onAction <const> = function(localPlayer, action, targetServerId)
    local reason = Utils:showKeyboard(Localization.generic_reason, "", 1000, false)
    if (not reason or reason == "") then
        return false
    end
    local duration = tonumber(Utils:showKeyboard(Localization.generic_duration, "", 20, false))
    if (not duration) then
        return false
    end
    action:triggerListener(0, targetServerId, reason, duration)
    return true
end

Action.new()
      :setId("player_ban")
      :setLabel(("~r~%s"):format(Localization.actions_starterPack_player_ban))
      :setPermission("player.ban")
      :setRetention(ActionRetention.PLAYER)
      :setType(ActionType.SIMPLE)
      :setFlag(ActionFlag.MENU_ELEMENT_POSITION, 6)
      :setFlag(ActionFlag.NET_ACTION)
      :setFlag(ActionFlag.NET_NEED_RESPONSE)
      :setHandlerTable(onAction)
      :build()