-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
local seconds, minutes = 1000, 60000
Config = {}
--------------------------------------------------------------
-- TO MODIFY NOTIFICATIONS TO YOUR OWN CUSTOM NOTIFICATIONS:--
------------ Navigate to client/cl_customize.lua -------------
--------------------------------------------------------------
Config.ESXName = 'es_extended' -- Probably don't need this but it's present for those who like to rename all their resources from the original names.

Config.customCarlock = true -- If you use wasabi_carlock(Or want to add your own key system to client/cl_customize.lua)
Config.AdvancedParking = false -- If you use AdvancedParking (Deletes vehicles with their exports)

Config.jobMenu = 'F6' -- Default job menu key
Config.billingSystem = 'esx' -- Current options: 'esx' (For esx_billing) / 'okok' (For okokBilling) / 'pefcl' (For NPWD billing system) (Easy to add more in editable client - SET TO false IF UNDESIRED) or of course false to disable
Config.skinScript = 'appearance' -- Current options: 'esx' (For esx_skin) / 'appearance' (For wasabi-fivem-appearance) or of course false to disable
Config.targetSystem = true -- Target system for targetting players (If disabled with replace with menus/3D text)

Config.Inventory = 'ox' -- THIS ONLY MATTERS FOR REMOVE ITEM ON DEATH - 
                        --Options include: 'ox' - (ox_inventory) / 'mf' - (mf-inventory) / 'qs' (qs-inventory) / 'other' (whatever else can customize in client/cl_customize.lua)

Config.taxiItems = {
    -- sedate = {
    --     item = 'sedative', -- Item used to sedate players temporarily
    --     duration = 8 * seconds, -- Time sedative effects last
    --     remove = true -- Remove item when using?
    -- },
    -- toolbox = 'toolbox', -- toolbox item name used for getting supplies
}

Config.Locations = {
    taxi = {

        Blip = {
            Enabled = true,
            Coords = vec3(894.77, -180.03, 74.7),
            Sprite = 79,
            Color = 5,
            Scale = 0.6,
            String = 'Delamain Taxi'
        },

        BossMenu = {
            Enabled = true, -- Enabled boss menu?
            Coords = vec3(907.59, -153.42, 74.75), -- Location of boss menu (If not using target)
            Label = '[E] - Gestion Entreprise', -- Text UI label string (If not using target)
            Distance = 2.5, -- Distance to allow access/prompt with text UI (If not using target)
            Target = {
                enabled = true, -- Enable Target? (Can be customized in cl_customize.lua the target system)
                label = 'Gestion Entreprise',
                coords = vec3(907.59, -153.42, 74.75),
                heading = 340.85,
                width = 1.0,
                length = 0.5,
                minZ = 43.21,
                maxZ = 43.21+0.9
            }
        },

        Coffre = {
            Enabled = true,
            Coords = vec3(895.34, -172.63, 73.8), -- Location of boss menu (If not using target)
            Label = '[E] - Coffre', -- Text UI label string (If not using target)
            Distance = 2.5, -- Distance to allow access/prompt with text UI (If not using target)
        },

        Cloakroom = {
            Enabled = false, -- Set to false if you don't want to use (Compatible with esx_skin & wasabi fivem-appearance fork)
            Coords = vec3(-193.69, -1335.99, 31.3), -- Coords of cloakroom
            Label = '[E] - Changer de vêtements', -- String of text ui of cloakroom
            Range = 1.5, -- Range away from coords you can use.
            Uniforms = { -- Uniform choices
                [1] = { -- Order it will display
                    label = 'Taxi', -- Name of outfit that will display in menu
                    male = { 
                        ['tshirt_1'] = 106,  ['tshirt_2'] = 0,
                        ['torso_1'] = 302,   ['torso_2'] = 2,
                        ['decals_1'] = 0,   ['decals_2'] = 0,
                        ['arms'] = 30,
                        ['pants_1'] = 173,   ['pants_2'] = 2,
                        ['shoes_1'] = 123,   ['shoes_2'] = 0,
                    },
                    female = {
                        ['tshirt_1'] = 103,  ['tshirt_2'] = 0,
                        ['torso_1'] = 230,   ['torso_2'] = 0,
                        ['decals_1'] = 0,   ['decals_2'] = 0,
                        ['arms'] = 215,
                        ['pants_1'] = 30,   ['pants_2'] = 0,
                        ['shoes_1'] = 25,   ['shoes_2'] = 0,
                        ['helmet_1'] = 149,  ['helmet_2'] = 0,
                        ['chain_1'] = 0,    ['chain_2'] = 0,
                        ['mask_1'] = 185,  ['mask_2'] = 0,
                        ['bproof_1'] = 0,  ['bproof_2'] = 0,
                        ['ears_1'] = -1,     ['ears_2'] = 0,
                        ['bproof_1'] = 27,  ['bproof_2'] = 0,
                        ['glasses_1'] = 22
                   }
                },
            }
        },

        TaxiSupplies = { -- taxi Shop for supplies
            Enabled = false, -- If set to false, rest of this table do not matter
            Ped = 's_m_m_autoshop_02', -- Ped to target
            Coords = vec3(-11.1, -1661.82, 29.44-0.95), -- Coords of ped/target
            Heading = 166.92, -- Heading of ped
            Supplies = { -- Supplies
                { item = 'item', label = 'Item', price = 100 }, -- Pretty self explanatory, price may be set to 'false' to make free
            }
        },

        Vehicles = { -- Vehicle Garage
            Enabled = true, -- Enable? False if you have you're own way for medics to obtain vehicles.
            Zone = {
                coords = vec3(918.47, -159.29, 74.98), -- Area to prompt vehicle garage
                range = 5.5, -- Range it will prompt from coords above
                label = '[E] - Accès Garage',
                return_label = '[E] - Ranger un véhicule de service'
            },
            Spawn = {
                land = {
                    coords = vec3(917.9, -167.31, 74.6),
                    heading = 93.4
                },
                air = {
                    coords = vec3(0, 0, 0),
                    heading =  0
                }
            },
            Options = {
                ['delamaintaxi'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                    label = 'Taxi',
                    category = 'land', -- Options are 'land' and 'air'
                },
            }
        },
    }
}
