--- @param localPlayer Player
--- @param action Action
local onAction <const> = function(localPlayer, action)
    local radius = tonumber(Utils:showKeyboard(Localization.generic_radius, "", 20, true))
    if (radius ~= nil) then
        local vehicles = ActionsInternal.getVehiclesInRange(radius)
        if (not vehicles) then
            return false
        end
        action:triggerListener(0, vehicles)
        return true
    end
    return false
end

Action.new()
      :setId("vehicle_clear_radius")
      :setLabel(Localization.actions_starterPack_vehicle_clear_radius)
      :setPermission("vehicles.clear")
      :setRetention(ActionRetention.VEHICLE)
      :setType(ActionType.SIMPLE)
      :setFlag(ActionFlag.MENU_ELEMENT_POSITION, 2)
      :setFlag(ActionFlag.NET_ACTION)
      :setFlag(ActionFlag.NET_NEED_RESPONSE)
      :setHandlerTable(onAction)
      :build()
