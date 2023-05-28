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

Config.customCarlock = false -- If you use wasabi_carlock(Or want to add your own key system to client/cl_customize.lua)
Config.AdvancedParking = true -- If you use AdvancedParking (Deletes vehicles with their exports)

Config.jobMenu = 'F6' -- Default job menu key
Config.billingSystem = 'esx' -- Current options: 'esx' (For esx_billing) / 'okok' (For okokBilling) / 'pefcl' (For NPWD billing system) (Easy to add more in editable client - SET TO false IF UNDESIRED) or of course false to disable
Config.skinScript = 'appearance' -- Current options: 'esx' (For esx_skin) / 'appearance' (For wasabi-fivem-appearance) or of course false to disable
Config.targetSystem = true -- Target system for targetting players, toolboxs, and stretcher(If disabled with replace with menus/3D text)

Config.Inventory = 'ox' -- THIS ONLY MATTERS FOR REMOVE ITEM ON DEATH - 
                        --Options include: 'ox' - (ox_inventory) / 'mf' - (mf-inventory) / 'qs' (qs-inventory) / 'other' (whatever else can customize in client/cl_customize.lua)


Config.Locations = {
    unipunk = {
        Blip = {
            Enabled = true,
            Coords = vec3(128.03, -1296.75, 29.26),
            Sprite = 121,
            Color = 7,
            Scale = 0.9,
            String = 'Unipunk'
        },

        BossMenu = {
            Enabled = true, -- Enabled boss menu?
            Coords = vec3(113.43, -1314.01, 20.06), -- Location of boss menu (If not using target)
            Label = '[E] - Gestion de l\'entreprise', -- Text UI label string (If not using target)
            Distance = 2.5, -- Distance to allow access/prompt with text UI (If not using target)
            Target = {
                enabled = true, -- Enable Target? (Can be customized in cl_customize.lua the target system)
                label = 'Gestion de l\'entreprise',
                coords = vec3(113.43, -1314.01, 20.06),
                heading = 14.8,
                width = 2.0,
                length = 1.0,
                minZ = 43.21-0.9,
                maxZ = 43.21+0.9
            }
        },

        Coffre = {
            Enabled = true,
            Coords = vec3(104.17, -1310.08, 20.3), -- Location of boss menu (If not using target)
            Label = '[E] - Coffre', -- Text UI label string (If not using target)
            Distance = 2.5, -- Distance to allow access/prompt with text UI (If not using target)
        },

        Cloakroom = {
            Enabled = false, -- Set to false if you don't want to use (Compatible with esx_skin & wasabi fivem-appearance fork)
            Coords = vec3(93.22, -1354.41, 20.32), -- Coords of cloakroom
            Label = '[E] - Vestiaire', -- String of text ui of cloakroom
            Range = 1.5, -- Range away from coords you can use.
            Uniforms = { -- Uniform choices
                [1] = { -- Order it will display
                    label = 'Unipunk', -- Name of outfit that will display in menu
                    male = { -- Male variation
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 5,   ['torso_2'] = 2,
                        ['arms'] = 5,
                        ['pants_1'] = 6,   ['pants_2'] = 1,
                        ['shoes_1'] = 16,   ['shoes_2'] = 7,
                        ['helmet_1'] = 44,  ['helmet_2'] = 7,
                    },
                    female = {
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 4,   ['torso_2'] = 14,
                        ['arms'] = 4,
                        ['pants_1'] = 25,   ['pants_2'] = 1,
                        ['shoes_1'] = 16,   ['shoes_2'] = 4,
                    }
                },
                [2] = {
                    label = 'Boss',
                    male = {
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 5,   ['torso_2'] = 2,
                        ['arms'] = 5,
                        ['pants_1'] = 6,   ['pants_2'] = 1,
                        ['shoes_1'] = 16,   ['shoes_2'] = 7,
                        ['helmet_1'] = 44,  ['helmet_2'] = 7,
                    },
                    female = {
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 4,   ['torso_2'] = 14,
                        ['arms'] = 4,
                        ['pants_1'] = 25,   ['pants_2'] = 1,
                        ['shoes_1'] = 16,   ['shoes_2'] = 4,
                    }
                },
            }
        },

        unipunkSupplies = { -- unicorn Shop for supplies
            Enabled = true, -- If set to false, rest of this table do not matter
            Ped = 's_m_y_barman_01', -- Ped to target
            Coords = vec3(90.09, -1328.78, 19.3), -- Coords of ped/target
            Heading = 318.39, -- Heading of ped
            Supplies = { -- Supplies
                { item = 'bolnoixcajou', label = 'Bol de noix de cajou', price = 3 }, -- Pretty self explanatory, price may be set to 'false' to make free
                { item = 'saucisson', label = 'Saucisson', price = 3 }, -- Pretty self explanatory, price may be set to 'false' to make free
                { item = 'grapperaisin', label = 'Grappe de raisin', price = 3 }, -- Pretty self explanatory, price may be set to 'false' to make free
                { item = 'cyberade', label = 'Cyberade', price = 3 }, -- Pretty self explanatory, price may be set to 'false' to make free
                { item = 'datadrop', label = 'Data Drop', price = 3 }, -- Pretty self explanatory, price may be set to 'false' to make free
                { item = 'sprayprote', label = 'Spray de Protéines', price = 3 }, -- Pretty self explanatory, price may be set to 'false' to make free
            }
        },

        Vehicles = { -- Vehicle Garage
            Enabled = false, -- Enable? False if you have you're own way for medics to obtain vehicles.
            Zone = {
                coords = vec3(166.36, -1298.64, 29.34), -- Area to prompt vehicle garage
                range = 5.5, -- Range it will prompt from coords above
                label = '[E] - Accéder au garage',
                return_label = '[E] - Ranger le véhicule',
            },
            Spawn = {
                land = {
                    coords = vec3(163.95, -1305.03, 29.35),
                    heading = 68.01
                },
                air = {
                    coords = vec3(0, 0, 0),
                    heading =  0
                }
            },
            Options = {
                ['sultan'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                    label = 'Sultan',
                    category = 'land', -- Options are 'land' and 'air'
                },
            }
        },
    }
}

