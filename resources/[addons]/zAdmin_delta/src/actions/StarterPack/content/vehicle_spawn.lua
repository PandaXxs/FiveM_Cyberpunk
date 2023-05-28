--- @param localPlayer Player
--- @param action Action
local onAction <const> = function(localPlayer, action)
    local model = Utils:showKeyboard(Localization.generic_model, "", 20, false)
    if (model ~= nil and model ~= "" and IsModelValid(GetHashKey(model))) then
        action:triggerListener(0, model)
        return true
    end
    return false
end

Action.new()
      :setId("vehicle_spawn")
      :setLabel(Localization.actions_starterPack_vehicle_spawn)
      :setPermission("vehicles.spawn")
      :setRetention(ActionRetention.VEHICLE)
      :setType(ActionType.SIMPLE)
      :setFlag(ActionFlag.MENU_ELEMENT_POSITION, 1)
      :setFlag(ActionFlag.NET_ACTION)
      :setFlag(ActionFlag.NET_NEED_RESPONSE)
      :setHandlerTable(onAction)
      :build()
