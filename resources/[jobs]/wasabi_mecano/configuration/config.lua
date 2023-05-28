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

Config.NPCSpawnDistance           = 500.0
Config.NPCNextToDistance          = 25.0
Config.NPCJobEarnings             = { min = 500, max = 1000 }

Config.Vehicles = {
	'adder',
	'asea',
	'asterope',
	'banshee',
	'buffalo',
	'sultan',
	'baller3'
}

Config.BENNYSItems = {
    -- sedate = {
    --     item = 'sedative', -- Item used to sedate players temporarily
    --     duration = 8 * seconds, -- Time sedative effects last
    --     remove = true -- Remove item when using?
    -- },
    toolbox = 'toolbox', -- toolbox item name used for getting supplies
}

Config.TreatmentItems = {
    repairkit = 'fixkit', -- Repairkit item name used for getting supplies
    cleankit = 'nettoyagekit', -- Cleankit item name used for getting supplies
    key = 'weapon_wrench', -- Key item name used for getting supplies
}

Config.Locations = {
    Bennys = {

        Blip = {
            Enabled = true,
            Coords = vec3(-11.1, -1661.82, 29.44),
            Sprite = 446,
            Color = 5,
            Scale = 0.6,
            String = 'Benny\'s Motorworks'
        },

        BossMenu = {
            Enabled = true, -- Enabled boss menu?
            Coords = vec3(-2.33, -1657.87, 29.26), -- Location of boss menu (If not using target)
            Label = '[E] - Gestion Entreprise', -- Text UI label string (If not using target)
            Distance = 2.5, -- Distance to allow access/prompt with text UI (If not using target)
            Target = {
                enabled = true, -- Enable Target? (Can be customized in cl_customize.lua the target system)
                label = 'Gestion Entreprise',
                coords = vec3(-2.33, -1657.87, 29.26),
                heading = 340.85,
                width = 1.0,
                length = 0.5,
                minZ = 43.21,
                maxZ = 43.21+0.9
            }
        },

        Cloakroom = {
            Enabled = false, -- Set to false if you don't want to use (Compatible with esx_skin & wasabi fivem-appearance fork)
            Coords = vec3(-193.69, -1335.99, 31.3), -- Coords of cloakroom
            Label = '[E] - Changer de vêtements', -- String of text ui of cloakroom
            Range = 1.5, -- Range away from coords you can use.
            Uniforms = { -- Uniform choices
                [1] = { -- Order it will display
                    label = 'Mécanicien', -- Name of outfit that will display in menu
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

        MechanicSupplies = { -- Mechanic Shop for supplies
            Enabled = true, -- If set to false, rest of this table do not matter
            Ped = 's_m_m_autoshop_02', -- Ped to target
            Coords = vec3(-11.1, -1661.82, 29.44-0.95), -- Coords of ped/target
            Heading = 166.92, -- Heading of ped
            Supplies = { -- Supplies
                { item = 'toolbox', label = 'Boîte à outils', price = 100 }, -- Pretty self explanatory, price may be set to 'false' to make free
            }
        },

        Vehicles = { -- Vehicle Garage
            Enabled = true, -- Enable? False if you have you're own way for medics to obtain vehicles.
            Zone = {
                coords = vec3(-22.57, -1678.15, 29.47), -- Area to prompt vehicle garage
                range = 5.5, -- Range it will prompt from coords above
                label = '[E] - Accès Garage',
                return_label = '[E] - Ranger un véhicule de service'
            },
            Spawn = {
                land = {
                    coords = vec3(-27.52, -1680.57, 29.45),
                    heading = 111.43
                },
                air = {
                    coords = vec3(0, 0, 0),
                    heading =  0
                }
            },
            Options = {
                ['flatbed'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                    label = 'Flatbed',
                    category = 'land', -- Options are 'land' and 'air'
                },
                ['towtruck'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                    label = 'Towtruck',
                    category = 'land', -- Options are 'land' and 'air'
                },
            }
        },
    }
}

Config.Zones = {
	VehicleDelivery = {
		Pos   = vector3(-166.19, -1308.58, 31.31),
		Size  = { x = 20.0, y = 20.0, z = 3.0 },
		Color = { r = 204, g = 204, b = 0 },
		Type  = -1
	}
}

Config.Towables = {
	vector3(-2480.9, -212.0, 17.4),
	vector3(-2723.4, 13.2, 15.1),
	vector3(-3169.6, 976.2, 15.0),
	vector3(-3139.8, 1078.7, 20.2),
	vector3(-1656.9, -246.2, 54.5),
	vector3(-1586.7, -647.6, 29.4),
	vector3(-1036.1, -491.1, 36.2),
	vector3(-1029.2, -475.5, 36.4),
	vector3(75.2, 164.9, 104.7),
	vector3(-534.6, -756.7, 31.6),
	vector3(487.2, -30.8, 88.9),
	vector3(-772.2, -1281.8, 4.6),
	vector3(-663.8, -1207.0, 10.2),
	vector3(719.1, -767.8, 24.9),
	vector3(-971.0, -2410.4, 13.3),
	vector3(-1067.5, -2571.4, 13.2),
	vector3(-619.2, -2207.3, 5.6),
	vector3(1192.1, -1336.9, 35.1),
	vector3(-432.8, -2166.1, 9.9),
	vector3(-451.8, -2269.3, 7.2),
	vector3(939.3, -2197.5, 30.5),
	vector3(-556.1, -1794.7, 22.0),
	vector3(591.7, -2628.2, 5.6),
	vector3(1654.5, -2535.8, 74.5),
	vector3(1642.6, -2413.3, 93.1),
	vector3(1371.3, -2549.5, 47.6),
	vector3(383.8, -1652.9, 37.3),
	vector3(27.2, -1030.9, 29.4),
	vector3(229.3, -365.9, 43.8),
	vector3(-85.8, -51.7, 61.1),
	vector3(-4.6, -670.3, 31.9),
	vector3(-111.9, 92.0, 71.1),
	vector3(-314.3, -698.2, 32.5),
	vector3(-366.9, 115.5, 65.6),
	vector3(-592.1, 138.2, 60.1),
	vector3(-1613.9, 18.8, 61.8),
	vector3(-1709.8, 55.1, 65.7),
	vector3(-521.9, -266.8, 34.9),
	vector3(-451.1, -333.5, 34.0),
	vector3(322.4, -1900.5, 25.8)
}

for k,v in ipairs(Config.Towables) do
	Config.Zones['Towable' .. k] = {
		Pos   = v,
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Color = { r = 204, g = 204, b = 0 },
		Type  = -1
	}
end