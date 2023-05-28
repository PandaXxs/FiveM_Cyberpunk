--- @param localPlayer Player
--- @param action Action
local onAction <const> = function(localPlayer, action)
    local closestVeh = Utils:getClosestVehicle()
    if (closestVeh == nil) then
        return false
    end
    Utils.requestNetControl(closestVeh)
    Functions.upgradeVehicle(closestVeh)
    return true
end

Action.new()
      :setId("vehicle_upgrade")
      :setLabel(Localization.actions_starterPack_vehicle_upgrade)
      :setPermission("vehicles.upgrade")
      :setRetention(ActionRetention.VEHICLE)
      :setType(ActionType.SIMPLE)
      :setFlag(ActionFlag.MENU_ELEMENT_POSITION, 4)
      :setHandlerTable(onAction)
      :build()
