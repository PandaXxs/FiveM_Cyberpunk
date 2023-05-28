ESX = exports['es_extended']:getSharedObject()
Config = Config or {}

-- If you want other jobs to be able to access the MDT, add it to the list below;
-- Example: { 'ambulance', 'doctor' }
Config.WhitelistedJobs = { 'ambulance' }

-- If you are not using one of the following scripts, you can leave the default value: default
Config.PhoneScript = 'high-phone' -- default, quasar-phone, high-phone, road-phone, lb-phone, gksphone

-- If you don't find your dispatch script above, set the value to none
Config.DispatchSystem = 'none' -- none, quasar-phone, linden_outlawalert, cd_dispatch

-- Enable this if you want to open the MDT using a command
Config.Command = {
    Enabled = true,
    Name = 'ems',
    Description = 'Opens the EMS MDT'
}

-- Enable this if you want to open the MDT using an item
Config.Item = {
    Enabled = false,
    Name = 'ambulance_mdt'
    -- If you are using ox_inventory, go to ox_inventory/data/items.lua and add the item there
    -- If you are using the default esx inventory, go to the database and add the item to the items table
}

-- Enable this if you want to open the MDT using a keybind
Config.Keybind = {
    Enabled = false,
    Key = 'G'
}

-- Invoices settings
Config.Invoices = {
    Enabled = false, -- If you want to use the invoice system, set this to true
    Society = 'society_ambulance', -- The society that will receive the invoices
    Percent = 70, -- Percentage of the invoice that goes to the society
    UseCustomFunction = false, -- If you want to use a custom function to pay the invoice, set this to true
    -- ! This is an example of a custom function, you can use it as a reference ! --
    CustomFunction = function(online, identifier, amount, data) -- Custom function to handle the invoice 
        if online then -- If the player is online, you can use ESX functions
            local player = ESX.GetPlayerFromIdentifier(identifier)

            if player then
                player.removeMoney(amount)
            end
        else
            -- Database updates
        end
    end
}

-- I highly recommend not modifying if you don't know what you're doing
Config.Tables = {
    -- Players
    ['players'] = 'users',
    ['doctors'] = 'users',
    ['citizen'] = 'users',
    ['job'] = 'jobs',
    ['grade'] = 'job_grades',

    -- Incidents / Invoices / Codes
    ['incidents'] = 'ems_incidents',
    ['incident'] = 'ems_incidents',
    ['invoices'] = 'ems_invoices',
    ['invoice'] = 'ems_invoices',
    ['codes'] = 'ems_codes',
    ['code'] = 'ems_codes'
}

-- Should not be modified!
Config.Queries = {
    -- Players
    ['search:players'] = 'CONCAT(firstname, \' \', lastname) LIKE :query OR phone_number LIKE :query',
    ['search:citizen'] = 'identifier = :query',
    ['search:doctors'] = '(CONCAT(firstname, \' \', lastname) LIKE :query OR phone_number LIKE :query)',
   
    -- Incidents
    ['search:incidents'] = 'name LIKE :query',
    ['search:incident'] = 'id = :query',

    -- Invoice
    ['search:invoices'] = 'name LIKE :query',
    ['search:invoice'] = 'id = :query',

    -- Codes
    ['search:codes'] = 'name LIKE :query OR code LIKE :query',
    ['search:code'] = 'id = :query',

    -- Citizen
    ['search:citizen:incidents'] = 'players LIKE :query'
}

Config.Columns = {
    ['players'] = nil,
    ['incidents'] = 'id, name, createdAt',
    ['invoices'] = nil,
    ['codes'] = 'id, name, createdAt'
}

if Config.PhoneScript == 'quasar-phone' then
    Config.Queries['search:players'] = 'CONCAT(firstname, \' \', lastname) LIKE :query OR charinfo LIKE :query'
    Config.Queries['search:cops'] = '(CONCAT(firstname, \' \', lastname) LIKE :query OR charinfo LIKE :query)'
elseif Config.PhoneScript == 'high-phone' then
    Config.Queries['search:players'] = 'CONCAT(firstname, \' \', lastname) LIKE :query OR phone LIKE :query'
    Config.Queries['search:cops'] = '(CONCAT(firstname, \' \', lastname) LIKE :query OR phone LIKE :query)'
elseif Config.PhoneScript == 'lb-phone' then
    Config.Queries['search:players'] = 'CONCAT(firstname, \' \', lastname) LIKE :query'
    Config.Queries['search:cops'] = '(CONCAT(firstname, \' \', lastname) LIKE :query)'
end

-- Custom Functions
Config.Notify = function(source, message, type)
    TriggerClientEvent('esx:showNotification', source, message, type)
end

-- Commands
Config.UseESXCommands = true -- If you want to use ESX commands, set this to true
Config.RegisterCommand = function(name, description, callback)
    if Config.UseESXCommands then
        ESX.RegisterCommand(name, 'user', function(player, args, error)
            callback(player)
        end, false, { help = description })    
    else
        RegisterCommand(name, function(source, args, raw)
            local player = ESX.GetPlayerFromId(source)
            callback(player)
        end, false)
    end
end

-- Items
Config.RegisterItem = function(name, callback)
    ESX.RegisterUsableItem(name, function(source)
        local player = ESX.GetPlayerFromId(source)
        callback(player)
    end)
end

-- ESX Functions

-- This works for ESX Legacy, If you are using an older version of ESX, you will need to change this
Config.GetPlayerName = function(player) -- player = ESX.GetPlayerFromId(source)
    return {
        firstname = player.variables.firstName,
        lastname = player.variables.lastName
    }
end

-- Discord Webhooks
Config.Webhooks = {
    ['incidents'] = false, -- Leave this false if you don't want to send incident data anywhere
    ['invoices'] = false, -- Leave this false if you don't want to send invoice data anywhere
    ['codes'] = false, -- Leave this false if you don't want to send code data anywhere
    ['images'] = false, -- SET THE WEBHOOK, OTHERWISE YOU WON'T BE ABLE TO TAKE PICTURES
    ['chat'] = false -- Leave this false if you don't want to send the messages anywhere
}
