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
Config.AdvancedParking = false -- If you use AdvancedParking (Deletes vehicles with their exports)

Config.jobMenu = 'F6' -- Default job menu key
Config.billingSystem = 'esx' -- Current options: 'esx' (For esx_billing) / 'okok' (For okokBilling) / 'pefcl' (For NPWD billing system) (Easy to add more in editable client - SET TO false IF UNDESIRED) or of course false to disable
Config.skinScript = 'appearance' -- Current options: 'esx' (For esx_skin) / 'appearance' (For wasabi-fivem-appearance) or of course false to disable
Config.targetSystem = true -- Target system for targetting players, toolboxs, and stretcher(If disabled with replace with menus/3D text)

Config.Inventory = 'ox' -- THIS ONLY MATTERS FOR REMOVE ITEM ON DEATH - 
                        --Options include: 'ox' - (ox_inventory) / 'mf' - (mf-inventory) / 'qs' (qs-inventory) / 'other' (whatever else can customize in client/cl_customize.lua)


Config.BurgershotItems = {
    -- sedate = {
    --     item = 'sedative', -- Item used to sedate players temporarily
    --     duration = 8 * seconds, -- Time sedative effects last
    --     remove = true -- Remove item when using?
    -- },
}

Config.SellItems = {
    { item = 'menuburgershot', label = 'Menu Whiteburger', price = {20, 30}},
    { item = 'menuburgershotluxe', label = 'Menu prestige', price = {30, 50}},
}

Config.Locations = {
    Bennys = {

        Blip = {
            Enabled = true,
            Coords = vec3(134.57, -1540.02, 29.91),
            Sprite = 106,
            Color = 63,
            Scale = 0.6,
            String = '[ENTREPRISE] BurgerShot'
        },

        RecolteViande = {
            Enabled = false,
            Coords = vec3(372.2458, 341.3462, 102.2132), -- Location of boss menu (If not using target)
            Label = '[E] - Recolter la viande', -- Text UI label string (If not using target)
            Distance = 2.5, -- Distance to allow access/prompt with text UI (If not using target)
        },

        RecoltePain = {
            Enabled = false, 
            Coords = vec3(31.5922, -1315.9544, 28.5229), -- Location of boss menu (If not using target)
            Label = '[E] - Recolter le pain', -- Text UI label string (If not using target)
            Distance = 2.5, -- Distance to allow access/prompt with text UI (If not using target)
        },

        RecolteFrites = {
            Enabled = false, 
            Coords = vec3(1119.7532, -983.8389, 45.2997), -- Location of boss menu (If not using target)
            Label = '[E] - Recolter des frites', -- Text UI label string (If not using target)
            Distance = 2.5, -- Distance to allow access/prompt with text UI (If not using target)
        },

        FabMenu = {
            Enabled = false, 
            Coords = vec3(135.75, -1522.14, 30.03), -- Location of boss menu (If not using target)
            Label = '[E] - Menu', -- Text UI label string (If not using target)
            Distance = 2.5, -- Distance to allow access/prompt with text UI (If not using target)
        },

        BoissonMenu = {
            Enabled = false, 
            Coords = vec3(139.33, -1521.22, 29.91), -- Location of boss menu (If not using target)
            Label = '[E] - Boisson', -- Text UI label string (If not using target)
            Distance = 1.0, -- Distance to allow access/prompt with text UI (If not using target)
        },

        DessertMenu = {
            Enabled = false, 
            Coords = vec3(135.6, -1530.65, 30.03), -- Location of boss menu (If not using target)
            Label = '[E] - Dessert', -- Text UI label string (If not using target)
            Distance = 1.0, -- Distance to allow access/prompt with text UI (If not using target)
        },

        Vente = {
            Enabled = false, 
            Coords = vec3(959.03344726563, -1998.5632324219, 30.237998962402), -- Location of boss menu (If not using target)
            Label = '[E] - Vente', -- Text UI label string (If not using target)
            Distance = 2.5, -- Distance to allow access/prompt with text UI (If not using target)
        },

        Coffre = {
            Enabled = true,
            Coords = vec3(132.81, -1524.22, 30.03), -- Location of boss menu (If not using target)
            Label = '[E] - Coffre', -- Text UI label string (If not using target)
            Distance = 2.5, -- Distance to allow access/prompt with text UI (If not using target)
        },

        BossMenu = {
            Enabled = true, -- Enabled boss menu?
            Coords = vec3(131.63, -1521.7, 30.03), -- Location of boss menu (If not using target)
            Label = '[E] - Gestion entreprise', -- Text UI label string (If not using target)
            Distance = 2.5, -- Distance to allow access/prompt with text UI (If not using target)
            Target = {
                enabled = true, -- Enable Target? (Can be customized in cl_customize.lua the target system)
                label = 'Gestion entreprise',
                coords = vec3(131.63, -1521.7, 30.03),
                heading = 47.4,
                width = 1.0,
                length = 0.5,
                minZ = 43.21,
                maxZ = 43.21+0.9
            }
        },

        Cloakroom = {
            Enabled = false, -- Set to false if you don't want to use (Compatible with esx_skin & wasabi fivem-appearance fork)
            Coords = vec3(-1181.1202,-900.9341,12.9741), -- Coords of cloakroom
            Label = '[E] - Changer de vêtements', -- String of text ui of cloakroom
            Range = 1.5, -- Range away from coords you can use.
            Uniforms = { -- Uniform choices
                [1] = { -- Order it will display
                    label = 'Burgershot', -- Name of outfit that will display in menu
                    male = { 
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 511,   ['torso_2'] = 0,
                        ['arms'] = 85,
                        ['pants_1'] = 96,   ['pants_2'] = 0,
                        ['shoes_1'] = 7,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,  ['helmet_2'] = 0,
                        ['chain_1'] = 0,    ['chain_2'] = 0,
                        ['ears_1'] = -1,     ['ears_2'] = 0
                    },
                    female = {
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 249,   ['torso_2'] = 0, 
                        ['arms'] = 31,
                        ['pants_1'] = 101,   ['pants_2'] = 0,
                        ['shoes_1'] = 6,   ['shoes_2'] = 0,  
                        ['helmet_1'] = -1,  ['helmet_2'] = 0,
                        ['chain_1'] = 0,    ['chain_2'] = 0,
                        ['ears_1'] = -1,     ['ears_2'] = 0
                   }
                },
            }
        },

        BurgershotSupplies = { -- Burgershot Shop for supplies
            Enabled = true, -- If set to false, rest of this table do not matter
            Ped = 's_m_y_chef_01', -- Ped to target
            Coords = vec3(139.49, -1525.4, 29.03), -- Coords of ped/target
            Heading = 100.06, -- Heading of ped
            Supplies = { -- Supplies
                { item = 'burger', label = 'Hamburger', price = 3 }, -- Pretty self explanatory, price may be set to 'false' to make free
            }
        },

        Vehicles = { -- Vehicle Garage
            Enabled = false, -- Enable? False if you have you're own way for medics to obtain vehicles.
            Zone = {
                coords = vec3(-1173.2780,-899.9992,12.7540), -- Area to prompt vehicle garage
                range = 5.5, -- Range it will prompt from coords above
                label = '[E] - Accès Garage',
                return_label = '[E] - Ranger un véhicule de service'
            },
            Spawn = {
                land = {
                    coords = vec3(-1172.044921875,-892.29913330078,13.902005195618),
                    heading = 31.93
                },
                air = {
                    coords = vec3(0, 0, 0),
                    heading =  0
                }
            },
            Options = {
                ['nspeedo'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                    label = 'Speedo',
                    category = 'land', -- Options are 'land' and 'air'
                },
                ['burrito4'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                    label = 'Burrito',
                    category = 'land', -- Options are 'land' and 'air'
                },
            }
        },
    }
}