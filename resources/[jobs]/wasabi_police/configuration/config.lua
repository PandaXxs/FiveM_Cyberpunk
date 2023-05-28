-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
local seconds, minutes = 1000, 60000
Config = {}

Config.jobMenu = 'F6' -- Default job menu key
Config.useTarget = true -- Enable target for police functions (Supports qtarget, qb-target, and ox_target)
Config.MobileMenu = {-- THIS WILL USE A OX_LIB MENU RATHER THAN OX_LIB CONTEXT MENU!
    enabled = false, -- Use a mobile menu from ox_lib rather than context? (Use arrow keys to navigate menu rather than mouse)
    position = 'bottom-right'-- Choose where menu is positioned. Options : 'top-left' or 'top-right' or 'bottom-left' or 'bottom-right'
}
Config.UseRadialMenu = true -- Enable use of radial menu built in to ox_lib? (REQUIRES OX_LIB 3.0 OR HIGHER - Editable in client/radial.lua)

Config.customCarlock = true -- If you use wasabi_carlock OR qb-carlock set to true(Add your own carlock system in client/cl_customize.lua)
Config.billingSystem = 'esx' -- Current options: 'esx' (For esx_billing) / 'qb' (QBCore) / 'okok' (For okokBilling) (Easy to add more/fully customize in client/cl_customize.lua)
Config.skinScript = 'appearance' -- Current options: 'esx' (For esx_skin) / 'appearance' (For wasabi-fivem-appearance) / 'qb' for qb-clothing / 'custom' for custom (Custom can be added in client/cl_customize.lua) / false for disabled
Config.customJail = false -- Set to true if you want to add jail option to menu(Requires you to edit wasabi_police:sendToJail event in client/cl_customize.lua)

Config.inventory = 'ox' -- NEEDED FOR SEARCHING PLAYERS - Current options: 'ox' (For ox_inventory) / 'qb' (For QbCore Inventory) / 'mf' (For mf inventory) / 'qs' (For qs_inventory) / 'cheeza' (For cheeza_inventory) / 'custom' (Custom can be added in client/cl_customize.lua)
Config.searchPlayers = true -- Allow police jobs to search players (Must set correct inventory above)
Config.weaponsAsItems = true -- (If you're unsure leave as true!)This is typically for older ESX and inventories that still use weapons as weapons and not items

Config.spikeStripsEnabled = true -- Enable functionality of spike strips (Disable if you use difference script for spike strips)

Config.GSR = { -- Gunshot residue settings
    enabled = true, -- Enabled?
    cleanInWater = true, -- Can clean GSR while in water?
    timeToClean = 5 * seconds, -- How long to clean GSR in water if enabled
    autoClean = 600, -- (IN SECONDS)How long before residue clears itself? Set to false if undesired to auto clean GSR
    command = 'gsr' -- Command for testing for GSR? Set to false if undesired
}

Config.tackle = {
    enabled = true, -- Enable tackle?
    policeOnly = true, -- Police jobs only use tackle?
    hotkey = 'G' -- What key to press while sprinting to start tackle of target
}

Config.handcuff = { -- Config in regards to cuffing
    timer = 20 * minutes, -- Time before player is automatically unrestrained(Set to false if not desired)
    hotkey = 'J', -- What key to press to handcuff people(Set to false for no hotkey)
    freezePlayer = false, -- Disable movement of player
    skilledEscape = {
        enabled = true, -- Allow criminal to simulate resisting by giving them a chance to break free from cuffs via skill check
        difficulty = {'hard'} -- Options: 'easy' / 'medium' / 'hard' (Can be stringed along as they are in config)
    }
}

Config.policeJobs = { -- Police jobs
    'police',
}

Config.Props = { -- What props are avaliable in the "Place Objects" section of the job menu

    {
        title = 'Barrier', -- Label
        description = '', -- Description (optional)
        model = `prop_barrier_work05`, -- Prop name within `
        groups = { -- ['job_name'] = min_rank
            ['police'] = 0,
--            ['sheriff'] = 0,
        }
    },
    {
        title = 'Barricade',
        description = '',
        model = `prop_mp_barrier_01`,
        groups = {
            ['police'] = 0,
--            ['sheriff'] = 0,
        }
    },
    {
        title = 'Traffic Cones',
        description = '',
        model = `prop_roadcone02a`,
        groups = {
            ['police'] = 0,
--            ['sheriff'] = 0,
        }
    },
    {
        title = 'Spike Strip',
        description = '',
        model = `p_ld_stinger_s`,
        groups = {
            ['police'] = 0,
--            ['sheriff'] = 0,
        }
    },

}

Config.Locations = {
    LSPD = {
        blip = {
            enabled = true,
            coords = vec3(464.57, -992.0, 30.69),
            sprite = 60,
            color = 29,
            scale = 1.0,
            string = 'NCPD'
        },

        clockInAndOut = {
            enabled = true, -- Enable clocking in and out at a set location? (If using ESX you must have a off duty job for each e.x. offpolice for police offsheriff for sheriff AND have grades for each pd grade - QBCORE REQUIRES NOTHING)
            jobLock = 'police', -- This must be set to which job will be utilizing (ESX MUST HAVE OFF DUTY JOB / GRADES FOR THIS - ex. offpolice or offsheriff)
            coords = vec3(458.27, -992.48, 31.74), -- Location of where to go on and off duty(If not using target)
            label = '[E] - En service/Fin de service', -- Text to display(If not using target)
            distance = 3.0, -- Distance to display text UI(If not using target)
            target = {
                enabled = false, -- If enabled, the location and distance above will be obsolete
                label = 'En service/Fin de service',
                coords = vec3(458.27, -992.48, 31.74),
                heading = 91.06,
                width = 2.0,
                length = 1.0,
                minZ = 30.69-0.9,
                maxZ = 30.69+0.9
            }
        },

        bossMenu = {
            enabled = true, -- Enable boss menu?
            jobLock = 'police', -- Lock to specific police job? Set to false if not desired
            coords = vec3(468.29, -975.69, 35.89), -- Location of boss menu (If not using target)
            label = '[E] - Gestion Entreprise', -- Text UI label string (If not using target)
            distance = 3.0, -- Distance to allow access/prompt with text UI (If not using target)
            target = {
                enabled = false, -- If enabled, the location and distance above will be obsolete
                label = 'Gestion Entreprise',
                coords = vec3(468.29, -975.69, 35.89),
                heading = 189.39,
                width = 2.0,
                length = 1.0,
                minZ = 30.73-0.9,
                maxZ = 30.73+0.9
            }
        },

        armoury = {
            enabled = true, -- Set to false if you don't want to use
            coords = vec3(463.19, -999.25, 31.74-0.9), -- Coords of armoury
            heading = 4.16, -- Heading of armoury NPC
            ped = 's_f_y_cop_01',
            label = '[E] - Accéder à l\'Armurerie', -- String of text ui
            jobLock = 'police', -- Allow only one of Config.policeJob listings / Set to false if allow all Config.policeJobs
            weapons = {
                [0] = { -- Cadet
                    ['WEAPON_NIGHTSTICK'] = { label = 'Tonfa', multiple = false, price = false },
                    ['WEAPON_STUNGUN'] = { label = 'Tazer', multiple = false, price = false },
                    ['WEAPON_FLASHLIGHT'] = { label = 'Flashlight', multiple = false, price = false },
                },
                [1] = { -- Officier
                    ['WEAPON_NIGHTSTICK'] = { label = 'Tonfa', multiple = false, price = false },
                    ['WEAPON_STUNGUN'] = { label = 'Tazer', multiple = false, price = false },
                    ['WEAPON_FLASHLIGHT'] = { label = 'Flashlight', multiple = false, price = false },
                    ['WEAPON_PISTOL_MK2'] = { label = 'Pistolet', multiple = false, price = false },
                    ['WEAPON_FLARE'] = { label = 'Fusée de détresse', multiple = false, price = false },
                    ['ammo'] = { label = 'Munition', multiple = true, price = 10 }, 
                },
                [2] = { -- Sergent
                    ['WEAPON_NIGHTSTICK'] = { label = 'Tonfa', multiple = false, price = false },
                    ['WEAPON_STUNGUN'] = { label = 'Tazer', multiple = false, price = false },
                    ['WEAPON_FLASHLIGHT'] = { label = 'Flashlight', multiple = false, price = false },
                    ['WEAPON_PISTOL_MK2'] = { label = 'Pistolet', multiple = false, price = false },
                    ['WEAPON_PUMPSHOTGUN'] = { label = 'Shotgun', multiple = false, price = false },
                    ['WEAPON_FLARE'] = { label = 'Fusée de détresse', multiple = false, price = false },
                    ['ammo'] = { label = 'Munition', multiple = true, price = 10 }, 
                },
                [3] = { -- Lieutenant
                    ['WEAPON_NIGHTSTICK'] = { label = 'Tonfa', multiple = false, price = false },
                    ['WEAPON_STUNGUN'] = { label = 'Tazer', multiple = false, price = false },
                    ['WEAPON_FLASHLIGHT'] = { label = 'Flashlight', multiple = false, price = false },
                    ['WEAPON_PISTOL_MK2'] = { label = 'Pistolet', multiple = false, price = false },
                    ['WEAPON_PUMPSHOTGUN'] = { label = 'Shotgun', multiple = false, price = false },
                    ['WEAPON_ASSAULTSMG'] = { label = 'P90', multiple = false, price = false },
                    ['WEAPON_FLARE'] = { label = 'Fusée de détresse', multiple = false, price = false },
                    ['ammo'] = { label = 'Munition', multiple = true, price = 10 }, 
                },
                [4] = { -- LE PACHA
                    ['WEAPON_NIGHTSTICK'] = { label = 'Tonfa', multiple = false, price = false },
                    ['WEAPON_STUNGUN'] = { label = 'Tazer', multiple = false, price = false },
                    ['WEAPON_FLASHLIGHT'] = { label = 'Flashlight', multiple = false, price = false },
                    ['WEAPON_PISTOL_MK2'] = { label = 'Pistolet', multiple = false, price = false },
                    ['WEAPON_PUMPSHOTGUN'] = { label = 'Shotgun', multiple = false, price = false },
                    ['WEAPON_ASSAULTSMG'] = { label = 'P90', multiple = false, price = false },
                    ['WEAPON_DOUBLEACTION'] = { label = 'Revolver', multiple = false, price = false },
                    ['WEAPON_FLARE'] = { label = 'Fusée de détresse', multiple = false, price = false },
                    ['WEAPON_COMBATSHOTGUN'] = { label = 'Shotgun du pacha', multiple = false, price = false },
                    ['ammo'] = { label = 'Munition', multiple = true, price = 10 }, 
              --    ['armour'] = { label = 'Bulletproof Vest', multiple = false, price = 100 }, -- Example
                },
            }
        },

        cloakroom = {
            enabled = true, -- WILL NOT SHOW IN QBCORE INSTEAD USE QB-CLOTHING CONFIG! Set to false if you don't want to use (Compatible with esx_skin & wasabi fivem-appearance fork)
            jobLock = 'police', -- Allow only one of Config.policeJob listings / Set to false if allow all Config.policeJobs
            coords = vec3(452.28, -998.5, 31.71), -- Coords of cloakroom
            label = '[E] - Changer de vêtements', -- String of text ui of cloakroom
            range = 2.5, -- Range away from coords you can use.
            uniforms = { -- Uniform choices

                [1] = { -- Name of outfit that will display in menu
                    label = 'Civil',
                    minGrade = false, -- minimum grade level to access? Set to false or 0 for all grades
                    maxGrade = false,
                    male = { -- Male variation
                        ['chain_1'] = 125,
                    },
                    female = { -- Female variation : #ici je laisse par defaut
                        ['chain_1'] = 95,
                    }
                },

                [2] = { -- Name of outfit that will display in menu
                    label = 'Le Pacha',
                    minGrade = 4, -- minimum grade level to access? Set to false or 0 for all grades
                    maxGrade = 4,
                    male = { -- Male variation
                        ['tshirt_1'] = 193,  ['tshirt_2'] = 0,
                        ['torso_1'] = 444,   ['torso_2'] = 0,
                        ['arms'] = 6,
                        ['pants_1'] = 162,   ['pants_2'] = 0,
                        ['shoes_1'] = 127,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,  ['helmet_2'] = 0,
                        ['bproof_1'] = 0,
                        ['chain_1'] = 0,
                    },
                    female = { -- Female variation : #ici je laisse par defaut
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 4,   ['torso_2'] = 14,
                        ['arms'] = 4,
                        ['pants_1'] = 25,   ['pants_2'] = 1,
                        ['shoes_1'] = 16,   ['shoes_2'] = 4,
                        ['bproof_1'] = 0,
                        ['chain_1'] = 0,
                    }
                },
                [3] = { -- Name of outfit that will display in menu
                    label = 'Le Pacha - Gilet pare-balles',
                    minGrade = 4, -- minimum grade level to access? Set to false or 0 for all grades
                    maxGrade = 4,
                    male = { -- Male variation
                        ['tshirt_1'] = 193,  ['tshirt_2'] = 0,
                        ['torso_1'] = 444,   ['torso_2'] = 0,
                        ['arms'] = 6,
                        ['pants_1'] = 162,   ['pants_2'] = 0,
                        ['shoes_1'] = 127,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,  ['helmet_2'] = 0,
                        ['bproof_1'] = 59,
                        ['chain_1'] = 0,
                    },
                    female = { -- Female variation
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 4,   ['torso_2'] = 14,
                        ['arms'] = 4,
                        ['pants_1'] = 25,   ['pants_2'] = 1,
                        ['shoes_1'] = 16,   ['shoes_2'] = 4,
                        ['bproof_1'] = 0,
                        ['chain_1'] = 0,
                    }
                },
                [4] = { -- Name of outfit that will display in menu
                    label = 'Le Pacha - Tenue Lourde',
                    minGrade = 4, -- minimum grade level to access? Set to false or 0 for all grades
                    maxGrade = 4,
                    male = { -- Male variation
                        ['tshirt_1'] = 193,  ['tshirt_2'] = 0,
                        ['torso_1'] = 444,   ['torso_2'] = 0,
                        ['arms'] = 6,
                        ['pants_1'] = 162,   ['pants_2'] = 0,
                        ['shoes_1'] = 127,   ['shoes_2'] = 0,
                        ['helmet_1'] = 189,  ['helmet_2'] = 0,
                        ['bproof_1'] = 59,
                        ['chain_1'] = 0,
                    },
                    female = { -- Female variation
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 4,   ['torso_2'] = 14,
                        ['arms'] = 4,
                        ['pants_1'] = 25,   ['pants_2'] = 1,
                        ['shoes_1'] = 16,   ['shoes_2'] = 4,
                        ['bproof_1'] = 0,
                        ['chain_1'] = 0,
                    }
                },
                [5] = { -- Name of outfit that will display in menu
                    label = 'Lieutenant',
                    minGrade = 3, -- minimum grade level to access? Set to false or 0 for all grades
                    maxGrade = 3,
                    male = { -- Male variation
                        ['tshirt_1'] = 193,  ['tshirt_2'] = 0,
                        ['torso_1'] = 444,   ['torso_2'] = 0,
                        ['arms'] = 6,
                        ['pants_1'] = 162,   ['pants_2'] = 0,
                        ['shoes_1'] = 127,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,  ['helmet_2'] = 0,
                        ['bproof_1'] = 0,
                        ['chain_1'] = 0,
                    },
                    female = { -- Female variation
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 4,   ['torso_2'] = 14,
                        ['arms'] = 4,
                        ['pants_1'] = 25,   ['pants_2'] = 1,
                        ['shoes_1'] = 16,   ['shoes_2'] = 4,
                        ['bproof_1'] = 0,
                        ['chain_1'] = 0,
                    }
                },
                [6] = { -- Name of outfit that will display in menu
                    label = 'Lieutenant - Gilet pare-balles',
                    minGrade = 3, -- minimum grade level to access? Set to false or 0 for all grades
                    maxGrade = 3,
                    male = { -- Male variation
                        ['tshirt_1'] = 193,  ['tshirt_2'] = 0,
                        ['torso_1'] = 444,   ['torso_2'] = 0,
                        ['arms'] = 6,
                        ['pants_1'] = 162,   ['pants_2'] = 0,
                        ['shoes_1'] = 127,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,  ['helmet_2'] = 0,
                        ['bproof_1'] = 58,
                        ['chain_1'] = 0,
                    },
                    female = { -- Female variation
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 4,   ['torso_2'] = 14,
                        ['arms'] = 4,
                        ['pants_1'] = 25,   ['pants_2'] = 1,
                        ['shoes_1'] = 16,   ['shoes_2'] = 4,
                        ['bproof_1'] = 0,
                        ['chain_1'] = 0,
                    }
                },
                [7] = { -- Name of outfit that will display in menu
                    label = 'Lieutenant - Tenue lourde',
                    minGrade = 3, -- minimum grade level to access? Set to false or 0 for all grades
                    maxGrade = 3,
                    male = { -- Male variation
                        ['tshirt_1'] = 193,  ['tshirt_2'] = 0,
                        ['torso_1'] = 444,   ['torso_2'] = 0,
                        ['arms'] = 6,
                        ['pants_1'] = 162,   ['pants_2'] = 0,
                        ['shoes_1'] = 127,   ['shoes_2'] = 0,
                        ['helmet_1'] = 189,  ['helmet_2'] = 0,
                        ['bproof_1'] = 58,
                        ['chain_1'] = 0,
                    },
                    female = { -- Female variation
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 4,   ['torso_2'] = 14,
                        ['arms'] = 4,
                        ['pants_1'] = 25,   ['pants_2'] = 1,
                        ['shoes_1'] = 16,   ['shoes_2'] = 4,
                        ['bproof_1'] = 0,
                        ['chain_1'] = 0,
                    }
                },
                [8] = { -- Name of outfit that will display in menu
                    label = 'Sergent',
                    minGrade = 2, -- minimum grade level to access? Set to false or 0 for all grades
                    maxGrade = 2,
                    male = { -- Male variation
                        ['tshirt_1'] = 194,  ['tshirt_2'] = 0,
                        ['torso_1'] = 442,   ['torso_2'] = 0,
                        ['arms'] = 8,
                        ['pants_1'] = 161,   ['pants_2'] = 0,
                        ['shoes_1'] = 127,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,  ['helmet_2'] = 0,
                        ['bproof_1'] = 0,
                        ['chain_1'] = 0,
                    },
                    female = { -- Female variation
                        ['tshirt_1'] = 239,  ['tshirt_2'] = 0,
                        ['torso_1'] = 475,   ['torso_2'] = 0,
                        ['arms'] = 1,
                        ['pants_1'] = 172,   ['pants_2'] = 0,
                        ['shoes_1'] = 130,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,  ['helmet_2'] = 0,
                        ['bproof_1'] = 0,
                        ['chain_1'] = 0,
                    }
                },
                [9] = { -- Name of outfit that will display in menu
                    label = 'Sergent - Gilet pare-balles',
                    minGrade = 2, -- minimum grade level to access? Set to false or 0 for all grades
                    maxGrade = 2,
                    male = { -- Male variation
                        ['tshirt_1'] = 193,  ['tshirt_2'] = 0,
                        ['torso_1'] = 442,   ['torso_2'] = 0,
                        ['arms'] = 8,
                        ['pants_1'] = 161,   ['pants_2'] = 0,
                        ['shoes_1'] = 126,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,  ['helmet_2'] = 0,
                        ['bproof_1'] = 57,
                        ['chain_1'] = 0,
                    },
                    female = { -- Female variation
                        ['tshirt_1'] = 240,  ['tshirt_2'] = 0,
                        ['torso_1'] = 475,   ['torso_2'] = 0,
                        ['arms'] = 1,
                        ['pants_1'] = 172,   ['pants_2'] = 0,
                        ['shoes_1'] = 131,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,  ['helmet_2'] = 0,
                        ['bproof_1'] = 59,
                        ['chain_1'] = 0,
                    }
                },
                [10] = { -- Name of outfit that will display in menu
                    label = 'Sergent - Tenue lourde',
                    minGrade = 2, -- minimum grade level to access? Set to false or 0 for all grades
                    maxGrade = 2,
                    male = { -- Male variation
                        ['tshirt_1'] = 193,  ['tshirt_2'] = 0,
                        ['torso_1'] = 442,   ['torso_2'] = 0,
                        ['arms'] = 8,
                        ['pants_1'] = 161,   ['pants_2'] = 0,
                        ['shoes_1'] = 126,   ['shoes_2'] = 0,
                        ['helmet_1'] = 189,  ['helmet_2'] = 0,
                        ['bproof_1'] = 57,
                        ['chain_1'] = 0,
                    },
                    female = { -- Female variation
                        ['tshirt_1'] = 240,  ['tshirt_2'] = 0,
                        ['torso_1'] = 475,   ['torso_2'] = 0,
                        ['arms'] = 1,
                        ['pants_1'] = 172,   ['pants_2'] = 0,
                        ['shoes_1'] = 131,   ['shoes_2'] = 0,
                        ['helmet_1'] = 190,  ['helmet_2'] = 0,
                        ['bproof_1'] = 59,
                        ['chain_1'] = 0,
                    }
                },
                [11] = { -- Name of outfit that will display in menu
                    label = 'Officier',
                    minGrade = 1, -- minimum grade level to access? Set to false or 0 for all grades
                    maxGrade = 1,
                    male = { -- Male variation
                        ['tshirt_1'] = 58,  ['tshirt_2'] = 0,
                        ['torso_1'] = 442,   ['torso_2'] = 0,
                        ['arms'] = 8,
                        ['pants_1'] = 161,   ['pants_2'] = 0,
                        ['shoes_1'] = 126,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,  ['helmet_2'] = 0,
                        ['bproof_1'] = 0,
                        ['chain_1'] = 0,
                    },
                    female = { -- Female variation
                        ['tshirt_1'] = 35,  ['tshirt_2'] = 0,
                        ['torso_1'] = 475,   ['torso_2'] = 0,
                        ['arms'] = 1,
                        ['pants_1'] = 172,   ['pants_2'] = 0,
                        ['shoes_1'] = 131,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,  ['helmet_2'] = 0,
                        ['bproof_1'] = 0,
                        ['chain_1'] = 0,
                    }
                },
                [12] = { -- Name of outfit that will display in menu
                    label = 'Officier - Gilet pare-balles',
                    minGrade = 1, -- minimum grade level to access? Set to false or 0 for all grades
                    maxGrade = 1,
                    male = { -- Male variation
                        ['tshirt_1'] = 193,  ['tshirt_2'] = 0,
                        ['torso_1'] = 442,   ['torso_2'] = 0,
                        ['arms'] = 8,
                        ['pants_1'] = 161,   ['pants_2'] = 0,
                        ['shoes_1'] = 126,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,  ['helmet_2'] = 0,
                        ['bproof_1'] = 57,
                        ['chain_1'] = 0,
                    },
                    female = { -- Female variation
                        ['tshirt_1'] = 240,  ['tshirt_2'] = 0,
                        ['torso_1'] = 475,   ['torso_2'] = 0,
                        ['arms'] = 1,
                        ['pants_1'] = 172,   ['pants_2'] = 0,
                        ['shoes_1'] = 131,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,  ['helmet_2'] = 0,
                        ['bproof_1'] = 59,
                        ['chain_1'] = 0,
                    }
                },
                [13] = { -- Name of outfit that will display in menu
                    label = 'Officier - Tenue lourde',
                    minGrade = 1, -- minimum grade level to access? Set to false or 0 for all grades
                    maxGrade = 1,
                    male = { -- Male variation
                        ['tshirt_1'] = 193,  ['tshirt_2'] = 0,
                        ['torso_1'] = 442,   ['torso_2'] = 0,
                        ['arms'] = 8,
                        ['pants_1'] = 161,   ['pants_2'] = 0,
                        ['shoes_1'] = 126,   ['shoes_2'] = 0,
                        ['helmet_1'] = 189,  ['helmet_2'] = 0,
                        ['bproof_1'] = 57,
                        ['chain_1'] = 0,
                    },
                    female = { -- Female variation
                        ['tshirt_1'] = 240,  ['tshirt_2'] = 0,
                        ['torso_1'] = 475,   ['torso_2'] = 0,
                        ['arms'] = 1,
                        ['pants_1'] = 172,   ['pants_2'] = 0,
                        ['shoes_1'] = 131,   ['shoes_2'] = 0,
                        ['helmet_1'] = 190,  ['helmet_2'] = 0,
                        ['bproof_1'] = 59,
                        ['chain_1'] = 0,
                    }
                },
                [14] = { -- Name of outfit that will display in menu
                    label = 'Cadet',
                    minGrade = 0, -- minimum grade level to access? Set to false or 0 for all grades
                    maxGrade = 0,
                    male = { -- Male variation
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 442,   ['torso_2'] = 0,
                        ['arms'] = 8,
                        ['pants_1'] = 161,   ['pants_2'] = 0,
                        ['shoes_1'] = 126,   ['shoes_2'] = 0,
                        ['helmet_1'] = 191,  ['helmet_2'] = 0,
                        ['bproof_1'] = 0,
                        ['chain_1'] = 0,
                    },
                    female = { -- Female variation
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 475,   ['torso_2'] = 0,
                        ['arms'] = 1,
                        ['pants_1'] = 172,   ['pants_2'] = 0,
                        ['shoes_1'] = 131,   ['shoes_2'] = 0,
                        ['helmet_1'] = 187,  ['helmet_2'] = 0,
                        ['bproof_1'] = 0,
                        ['chain_1'] = 0,
                    },
                },
            },
        },

        vehicles = { -- Vehicle Garage
            enabled = true, -- Enable? False if you have you're own way for medics to obtain vehicles.
            jobLock = 'police', -- Job lock? or access to all police jobs by using false
            zone = {
                coords = vec3(443.32, -986.39, 23.94), -- Area to prompt vehicle garage
                range = 3.5, -- Range it will prompt from coords above
                label = '[E] - Accès Garage',
                return_label = '[E] - Rentrer le véhicule'
            },
            spawn = {
                land = {
                    coords = vec3(450.08, -984.85, 23.94), -- Coords of where land vehicle spawn/return
                    heading = 0.82
                },
                land2 = {
                    coords = vec3(449.84, 0017.57, 28.53), -- Coords of where land vehicle spawn/return
                    heading = 89.08
                },
                air = {
                    coords = vec3(449.29, -981.76, 43.69), -- Coords of where air vehicles spawn/return
                    heading =  0.01
                }
            },
            options = {

                [0] = { -- Cadet
                    ['scorcher'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Cyber VTT',
                        category = 'land', -- Options are 'land' and 'air'
                        engine = 0,
                        brakes = 0,
                        transmission = 0,
                        suspension = 0,
                        turbo = false,
                    },
                    ['cortesncpd'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Cyber Cruiser',
                        category = 'land', -- Options are 'land' and 'air'
                        engine = 0,
                        brakes = 0,
                        transmission = 0,
                        suspension = 0,
                        turbo = true,
                    },
                },

                [1] = { -- Officier
                    ['scorcher'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Cyber VTT',
                        category = 'land', -- Options are 'land' and 'air'
                        engine = 0,
                        brakes = 0,
                        transmission = 0,
                        suspension = 0,
                        turbo = false,
                    },
                    ['cortesncpd'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Cyber Cruiser',
                        category = 'land', -- Options are 'land' and 'air'
                        engine = 0,
                        brakes = 0,
                        transmission = 0,
                        suspension = 0,
                        turbo = true,
                    },
                },

                [2] = { -- Sergent
                    ['scorcher'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Cyber VTT',
                        category = 'land', -- Options are 'land' and 'air'
                        engine = 0,
                        brakes = 0,
                        transmission = 0,
                        suspension = 0,
                        turbo = false,
                    },
                    ['cortesncpd'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Cyber Cruiser',
                        category = 'land', -- Options are 'land' and 'air'
                        engine = 0,
                        brakes = 0,
                        transmission = 0,
                        suspension = 0,
                        turbo = true,
                    },
                    ['emperorncpd'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Cyber 4X4',
                        category = 'land', -- Options are 'land' and 'air'
                        engine = 0,
                        brakes = 0,
                        transmission = 0,
                        suspension = 0,
                        turbo = true,
                    },
                    ['police4'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Cyber Banaliser',
                        category = 'land', -- Options are 'land' and 'air'
                        engine = 3,
                        brakes = 2,
                        transmission = 2,
                        suspension = 3,
                        windowTint = 1,
                        turbo = true,
                    },
                },

                [3] = { -- Lieutenant
                    ['scorcher'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Cyber VTT',
                        category = 'land', -- Options are 'land' and 'air'
                        engine = 0,
                        brakes = 0,
                        transmission = 0,
                        suspension = 0,
                        turbo = false,
                    },
                    ['cortesncpd'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Cyber Cruiser',
                        category = 'land', -- Options are 'land' and 'air'
                        engine = 0,
                        brakes = 0,
                        transmission = 0,
                        suspension = 0,
                        turbo = true,
                    },
                    ['emperorncpd'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Cyber 4X4',
                        category = 'land', -- Options are 'land' and 'air'
                        engine = 0,
                        brakes = 0,
                        transmission = 0,
                        suspension = 0,
                        turbo = true,
                    },
                    ['police4'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Cyber Banaliser',
                        category = 'land', -- Options are 'land' and 'air'
                        engine = 3,
                        brakes = 2,
                        transmission = 2,
                        suspension = 3,
                        windowTint = 1,
                        turbo = true,
                    },
                    ['fbi'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Cyber Banaliser FBI',
                        category = 'land', -- Options are 'land' and 'air'
                        engine = 3,
                        brakes = 2,
                        transmission = 2,
                        suspension = 3,
                        windowTint = 1,
                        turbo = true,
                    },
                    ['riot2'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Anti-émeute',
                        category = 'land2', -- Options are 'land' and 'air'
                        engine = 0,
                        brakes = 0,
                        transmission = 0,
                        suspension = 0,
                        turbo = true,
                    },
                },

                [4] = { -- Le PACHA
                    ['scorcher'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Cyber VTT',
                        category = 'land', -- Options are 'land' and 'air'
                        engine = 0,
                        brakes = 0,
                        transmission = 0,
                        suspension = 0,
                        turbo = false,
                    },
                    ['cortesncpd'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Cyber Cruiser',
                        category = 'land', -- Options are 'land' and 'air'
                        engine = 0,
                        brakes = 0,
                        transmission = 0,
                        suspension = 0,
                        turbo = true,
                    },
                    ['emperorncpd'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Cyber 4X4',
                        category = 'land', -- Options are 'land' and 'air'
                        engine = 0,
                        brakes = 0,
                        transmission = 0,
                        suspension = 0,
                        turbo = true,
                    },
                    ['police4'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Cyber Banaliser',
                        category = 'land', -- Options are 'land' and 'air'
                        engine = 3,
                        brakes = 2,
                        transmission = 2,
                        suspension = 3,
                        windowTint = 1,
                        turbo = true,
                    },
                    ['fbi'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Cyber Banaliser FBI',
                        category = 'land', -- Options are 'land' and 'air'
                        engine = 3,
                        brakes = 2,
                        transmission = 2,
                        suspension = 3,
                        windowTint = 1,
                        turbo = true,
                    },
                    ['riot2'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Anti-émeute',
                        category = 'land2', -- Options are 'land' and 'air'
                        engine = 0,
                        brakes = 0,
                        transmission = 0,
                        suspension = 0,
                        turbo = true,
                    },
                },

            }
        }

    },

}
