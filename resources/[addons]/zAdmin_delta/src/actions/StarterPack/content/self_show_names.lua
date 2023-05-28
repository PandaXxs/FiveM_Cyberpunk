---@param localPlayer Player
---@param action Action
local onValueChange <const> = function(localPlayer, action, newValue)
    if (not Cache.localPlayer.activeAsStaff) then
        return
    end
    GamerTags.toggle(newValue)
end

local isActive <const> = function()
    return (GamerTags.active)
end

Action.new()
      :setId("self_show_names")
      :setLabel(Localization.actions_starterPack_self_showNames)
      :setPermission("self.names")
      :setRetention(ActionRetention.SELF)
      :setType(ActionType.TOGGLE)
      :setFlag(ActionFlag.MENU_ELEMENT_POSITION, 1)
      :setFlag(ActionFlag.ADD_KEY, "f2")
      :setHandlerTable(onValueChange, isActive)
      :build()