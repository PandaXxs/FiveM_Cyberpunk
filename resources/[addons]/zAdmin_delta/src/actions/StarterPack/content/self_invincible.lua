---@param localPlayer Player
---@param action Action
local onValueChange <const> = function(localPlayer, action, newValue)
    if (not Cache.localPlayer.activeAsStaff) then
        return
    end
    Invincible.toggle(newValue)
end

local isActive <const> = function()
    return (Invincible.state)
end

Action.new()
      :setId("self_invincible")
      :setLabel("Invincible")
      :setPermission("self.invincible")
      :setRetention(ActionRetention.SELF)
      :setType(ActionType.TOGGLE)
      :setFlag(ActionFlag.MENU_ELEMENT_POSITION, 2)
      :setHandlerTable(onValueChange, isActive)
      :build()