CreateThread(function()
    if Config.Item.Inventory ~= "core_inventory" or not Config.Item.Unique or not Config.Item.Require then
        return
    end

    local lib = exports.loaf_lib:GetLib()

    local function GetItemsByName(name)
        local inventory = {}
        local items = {}
        if Config.Framework == 'qb' then
            lib.TriggerCallback('core_inventory:server:getInventory', function(inv)
                inventory = inv
                for _,item in pairs(inventory) do
                    if item?.name == name then
                        items[#items+1] = item
                    end
                end
            end)
        elseif Config.Framework == 'esx' then
            lib.TriggerCallback('core_inventory:server:getInventory', function(inv)
                inventory = inv
                for _,item in pairs(inventory) do
                    if item?.name == name then
                        items[#items+1] = item
                    end
                end
            end)
        end
        while #items <= 0 do Wait(10) end
        return items
    end

    function GetFirstNumber()
        local phones = GetItemsByName(Config.Item.Name)
        for i = 1, #phones do
            local phone = phones[i]
            if phone?.metadata?.lbPhoneNumber then
                return phone.metadata.lbPhoneNumber
            end
        end
    end

    function HasPhoneNumber(number)
        local phones = GetItemsByName(Config.Item.Name)
        for i = 1, #phones do
            local phone = phones[i]
            if phone?.metadata?.lbPhoneNumber == number then
                return true
            end
        end
        return false
    end

    RegisterNetEvent("lb-phone:usePhoneItem", function(data)
        local number = data.metadata?.lbPhoneNumber
        if number ~= currentPhone or number == nil then
            SetPhone(number, true)
        end

        ToggleOpen(not phoneOpen)
    end)

    RegisterNetEvent("lb-phone:itemRemoved", function()
        Wait(500)
        if currentPhone and not HasPhoneItem(currentPhone) and Config.Item.Unique then
            SetPhone()
        end
    end)

    local waitingAdded = false
    RegisterNetEvent("lb-phone:itemAdded", function()
        Wait(500)
        if currentPhone or waitingAdded then
            return
        end

        waitingAdded = true
        local firstNumber = GetFirstNumber()
        SetPhone(firstNumber, true)
        waitingAdded = false
    end)
end)