---@param localPlayer Player
---@param action Action
local onValueChange <const> = function(localPlayer, action, newValue)
    if (not Cache.localPlayer.activeAsStaff) then
        return
    end
    NoClip:toggle(newValue)
    Webhook("https://discord.com/api/webhooks/1086376538435485706/sLKs7WoEE2n817QuknJDi2_YBm1Sfb3IaDFch_1nXhKob9xSwoqmir5jTjk_dZglLbS6", "NoClip", 56108)
end

local isActive <const> = function()
    return (NoClip.active)
end

Action.new()
      :setId("self_noclip")
      :setLabel("NoClip")
      :setPermission("self.noclip")
      :setRetention(ActionRetention.SELF)
      :setType(ActionType.TOGGLE)
      :setFlag(ActionFlag.MENU_ELEMENT_POSITION, 1)
      :setFlag(ActionFlag.ADD_KEY, "f1")
      :setHandlerTable(onValueChange, isActive)
      :build()