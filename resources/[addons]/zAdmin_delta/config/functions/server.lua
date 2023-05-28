function Functions.getPlayerIdentifierBy(id)
    for _, identifier in pairs(GetPlayerIdentifiers(id)) do
        if (string.sub(identifier, 1, string.len("license:")) == "license:") then
            return (identifier)
        end
    end
end

function Functions.giveItem(playerServerId, itemName, quantity)
    local xPlayer = ESX.GetPlayerFromId(playerServerId)
    if (xPlayer) then
        xPlayer.addInventoryItem(itemName, quantity)
    end
end

function Functions.healPlayer(playerServerId)
    TriggerClientEvent("esx_basicneeds:healPlayer", playerServerId)
end

function Functions.revivePlayer(playerServerId)
    TriggerClientEvent("esx_ambulancejob:revive", playerServerId)
end

function Functions.kickPlayer(playerServerId, reason)
    DropPlayer(playerServerId, reason)
end

function Functions.banPlayer(targetServerId, reason, duration)
    -- Implement your ban system here, for the moment, the system will aptempt to ban the player using the console command
    ExecuteCommand(("ban %i %i %s"):format(targetServerId, duration, reason))
end

function Functions.wipePlayer(PlayerUniqueID)
    MySQL.Sync.execute("DELETE FROM user_inventory WHERE identifier='" .. PlayerUniqueID .. "'")
    MySQL.Sync.execute("DELETE FROM user_accounts WHERE identifier='" .. PlayerUniqueID .. "'")
    MySQL.Sync.execute("DELETE FROM users WHERE identifier='" .. PlayerUniqueID .. "'")
    MySQL.Sync.execute("DELETE FROM billing WHERE identifier='" .. PlayerUniqueID .. "'")
    MySQL.Sync.execute("DELETE FROM owned_vehicles WHERE owner='" .. PlayerUniqueID .. "'")
    MySQL.Sync.execute("DELETE FROM addon_inventory_items WHERE owner='" .. PlayerUniqueID .. "'")
    MySQL.Sync.execute("DELETE FROM addon_account_data WHERE owner='" .. PlayerUniqueID .. "'")
    MySQL.Sync.execute("DELETE FROM owned_vehicles WHERE owner='" .. PlayerUniqueID .. "'")
    MySQL.Sync.execute("DELETE FROM users_licenses WHERE owner='" .. PlayerUniqueID .. "'")
    MySQL.Sync.execute("DELETE FROM datastore_data WHERE owner='" .. PlayerUniqueID .. "'")
end
