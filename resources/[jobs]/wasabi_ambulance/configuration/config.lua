-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
local seconds, minutes = 1000, 60000
Config = {}
--------------------------------------------------------------
-- TO MODIFY NOTIFICATIONS TO YOUR OWN CUSTOM NOTIFICATIONS:--
------------ Navigate to client/cl_customize.lua -------------
--------------------------------------------------------------
Config.ambulanceJob = 'ambulance' -- If you need rename your ambulancejob to something else? Likely will stay as is
Config.MuteDeadPlayers = true -- If a player is dead, should he be muted?
Config.Anticheat = true -- DOES NOT APPLY TO QBCORE -- Should the player be punished if he triggers 'esx_ambulancejob:revive'? / Edit it in server/sv_customize.lua
Config.DeathLogs = true -- Enable death logs via Discord webhook?(Set up in configuration/deathlogs.lua)
Config.LogIPs = true -- If Config.DeathLogs enabled, do you want to logs IP addresses as well?
Config.MobileMenu = { -- Enabling this will use ox_lib menu rather than ox_lib context menu!
    enabled = false, -- Use a mobile menu from ox_lib rather than context? (Use arrow keys to navigate menu rather than mouse)
    position = 'bottom-right'-- Choose where menu is positioned. Options : 'top-left' or 'top-right' or 'bottom-left' or 'bottom-right'
}
Config.UseRadialMenu = true -- Enable use of radial menu built in to ox_lib? (REQUIRES OX_LIB 3.0 OR HIGHER - Editable in client/radial.lua)
Config.policeCanTreat = {
    enabled = false, -- Police can treat patients?
    jobs = { -- Police / other jobs
        'police',
    }
}

-- 3rd party scripts
Config.wasabi_crutch = { -- If you use wasabi_crutch: https://store.wasabiscripts.com/category/2080869
    -- Crutch Settings
    crutchInMedbag = { enabled = true, item = 'crutch' }, -- Enabled? Item name? REQUIRES WASABI_CRUTCH
    crutchInJobMenu = false, -- Crutch menu accessible from job menu if true. REQUIRES WASABI_CRUTCH
    crutchOnBleedout = { -- Place crutch for certain amount of time if they fully bleedout to hospital
        enabled = true, -- Requires wasabi_crutch
        duration = 3 -- How long stuck with crutch after respawn(In minutes)
    },
    -- Chair settings
    chairInMedbag = { enabled = true, item = 'wheelchair' },  -- Enabled? Item name? REQUIRES WASABI_CRUTCH
    chairInJobMenu = false -- Chair menu accessible from job menu if true. REQUIRES WASABI_CRUTCH
}

Config.phoneDistress = false -- Options: 'gks' (GKS Phone - ESX ONLY) / 'qs' (qs-smartphone) / 'd-p' (d-phone) WILL REPLACE BUILT IN DISPATCH WITH PHONE DISPATCH / Add additonal dispatch in client/cl_customize.lua
Config.customCarlock = true -- If you use wasabi_carlock OR qb-carlock(Or want to add your own key system to client/cl_customize.lua)
Config.MythicHospital = false -- If you use that old injury script by mythic. (Added per request to reset injuries on respawn)
Config.AdvancedParking = false -- If you use AdvancedParking (Deletes vehicles with their exports)

Config.jobMenu = 'F6' -- Default job menu key
Config.billingSystem = 'esx' -- Current options: 'esx' (For esx_billing) / 'qb' (For qbcore users) 'okok' (For okokBilling) / 'pefcl' (For NPWD billing system) (Easy to add more in editable client - SET TO false IF UNDESIRED) or of course false to disable
Config.skinScript = 'appearance' -- Current options: 'esx' (For esx_skin) / 'appearance' (For wasabi-fivem-appearance) / 'qb' (For qb-clothing) / 'Custom' for any clothing script (editable in cl_customize.lua)
Config.targetSystem = true -- Target system for targetting players, medbags, and stretcher(If disabled with replace with menus/3D text) (Compatible out of the box with qTarget, qb-target, and ox_target)
Config.weaponsAsItems = true -- (If you're unsure leave as true!)This is typically for older ESX and inventories that still use weapons as weapons and not items

Config.RespawnTimer = 8 * minutes -- Time before optional respawn
Config.BleedoutTimer = 20 * minutes -- Time before it forces respawn

Config.removeItemsOnDeath = true -- Remove items on death?
Config.removeMoneyOnDeath = false -- Remove money on death?
Config.NotRemoveItemsList = { -- Items that will not be removed on death
    'water',
    'phone',
    'money',
}

Config.Inventory = 'ox' -- THIS ONLY MATTERS FOR REMOVE ITEM ON DEATH - 
                        --Options include: 'ox' - (ox_inventory) / 'qb' - (QBCore qb-inventory) 'mf' - (mf-inventory) / 'qs' (qs-inventory) / 'other' (whatever else can customize in client/cl_customize.lua)

Config.AntiCombatLog = { --  When enabled will kill player who logged out while dead
    enabled = true, --  enabled?
    notification = {
        enabled = true, -- enabled notify of wrong-doings??
        title = 'Logged While Dead',
        desc = 'You last left dead and now have returned dead'
    }
}

Config.CompleteDeath = { --DOES NOT APPLY TO QBCORE --  When enabled players can no longer use their character after x deaths
                         --DOES NOT APPLY TO QBCORE --  ONLY SUPPORTS esx_multicharacter / You can edit it in server/sv_customize.lua
    enabled = false, -- enabled?
    maxDeaths = 100, -- Max 255
}

Config.Bandages = {
    enabled = false, -- Useable bandages? (Leave false if ox_inventory because they're built in)
    item = 'bandage', -- YOU MUST ADD THIS ITEM TO YOUR ITEMS, IT DOES NOT COME IN INSTALLATION(COMES WITH QBCORE BY DEFAULT AS ITEM)
    hpRegen = 30, -- Percentage of health it replenishes (30% by default)
    duration = 7 * seconds -- Time to use
}

Config.EMSItems = {
    revive = {
        item = 'defib', -- Item used for reviving
        remove = false -- Remove item when using?
    },
    heal = {
        item = 'medikit', -- Item used for healing
        duration = 5 * seconds, -- Time to use
        remove = true -- Remove item when using?
    },
    sedate = {
        item = 'sedative', -- Item used to sedate players temporarily
        duration = 8 * seconds, -- Time sedative effects last
        remove = true -- Remove item when using?
    },
    medbag = 'medbag', -- Medbag item name used for getting supplies to treat patient
    stretcher = 'stretcher' -- Item used for stretcher
}

Config.ReviveRewards = {
    enabled = true, -- Enable cash rewards for reviving
    paymentAcoount = 'money', -- If you have old ESX 1.1 you may need to switch to 'cash'
    no_injury = 4000, -- If above enabled, how much reward for fully treated patient with no injury in diagnosis
    burned = 3000,  -- How much if player is burned and revived without being treated
    beat = 2500, -- So on, so forth
    stabbed = 2000,
    shot = 1500,
}

Config.ReviveHealth = { -- How much health to deduct for those revived without proper treatment
    shot = 60, -- Ex. If player is shot and revived without having the gunshots treated; they will respond with 60 health removed
    stabbed = 50,
    beat = 40,
    burned = 20
}

Config.TreatmentTime = 9 * seconds -- Time to perform treatment

Config.TreatmentItems = {
    shot = 'tweezers',
    stabbed = 'suturekit',
    beat = 'icepack',
    burned = 'burncream'
}

Config.lowHealthAlert = {
    enabled = false,
    health = 140, -- Notify when at HP (200 full health / 100 is death)
    notification = {
        title = 'ATTENTION',
        description = 'You are in bad health. You should see a doctor soon!'
    }
}

Config.Locations = {
    Pillbox = {

        RespawnPoint = { -- When player dies and bleeds out; they will revive at nearest hospital; Define the coords of this hospital here.
            coords = vec3(324.15, -583.14, 44.20),
            heading = 332.22
        },

        Blip = {
            Enabled = true,
            Coords = vec3(324.15, -583.14, 44.20),
            Sprite = 61,
            Color = 2,
            Scale = 1.0,
            String = 'Hopital'
        },


        clockInAndOut = {
            enabled = false, -- Enable clocking in and out at a set location? (If using ESX you must have a off duty job for Config.ambulanceJob with same grades - example in main _install_first directory)
            coords = vec3(334.75, -580.24, 43.28), -- Location of where to go on and off duty(If not using target)
            label = '[E] - Go On/Off Duty', -- Text to display(If not using target)
            distance = 3.0, -- Distance to display text UI(If not using target)
            target = {
                enabled = false, -- If enabled, the location and distance above will be obsolete
                label = 'Go On/Off Duty',
                coords = vec3(334.75, -580.24, 43.28),
                heading = 337.07,
                width = 2.0,
                length = 1.0,
                minZ = 43.28-0.9,
                maxZ = 43.28+0.9
            }
        },

        BossMenu = {
            Enabled = true, -- Enabled boss menu?
            Coords = vec3(328.17, -602.47, 43.19), -- Location of boss menu (If not using target)
            Label = '[E] - Gestion Entreprise', -- Text UI label string (If not using target)
            Distance = 2.5, -- Distance to allow access/prompt with text UI (If not using target)
            Target = {
                enabled = false, -- Enable Target? (Can be customized in cl_customize.lua the target system)
                label = 'Gestion Entreprise',
                coords = vec3(328.17, -602.47, 43.19),
                heading = 348.65,
                width = 2.0,
                length = 1.0,
                minZ = 43.21-0.9,
                maxZ = 43.21+0.9
            }
        },

        CheckIn = { -- Hospital check-in
            Enabled = true, -- Enabled?
            Ped = 's_m_m_scientist_01', -- Check in ped
            Coords = vec3(308.3, -588.31, 43.19-1.01), -- Coords of ped
            Heading = 66.26, -- Heading of ped
            Cost = 1000, -- Cost of using hospital check-in. Set to false for free
            MaxOnDuty = 1, -- If this amount or less you can use, otherwise it will tell you that EMS is avaliable(Set to false to always enable check-in)
            PayAccount = 'bank', -- Account dead player pays from to check-in
            Label = '[E] - Se faire soigner', -- label
            HotKey = 38, -- Default: 38 (E)
        },

        Cloakroom = {
            Enabled = true, --DOES NOT APPLY TO QBCORE --  Set to false if you don't want to use (Compatible with esx_skin & wasabi fivem-appearance fork)
            Coords = vec3(359.29, -580.59, 43.19), -- Coords of cloakroom
            Label = '[E] - Changer de vêtements', -- String of text ui of cloakroom
            HotKey = 38, -- Default: 38 (E)
            Range = 1.5, -- Range away from coords you can use.
            Uniforms = { -- Uniform choices
                [1] = { -- Order it will display
                    label = 'Directeur', -- Name of outfit that will display in menu
                    minGrade = 3, -- Min grade level that can access? Set to 0 or false for everyone to use
                    maxGrade = 3,
                    male = { -- Male variation
                        ['tshirt_1'] = 193,  ['tshirt_2'] = 0,
                        ['torso_1'] = 446,   ['torso_2'] = 0,
                        ['arms'] = 211,
                        ['pants_1'] = 164,   ['pants_2'] = 0,
                        ['shoes_1'] = 129,   ['shoes_2'] = 0,
                        ['helmet_1'] = 195,  ['helmet_2'] = 0,
                        ['bproof_1'] = 60,
                        ['chain_1'] = 166,
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
                    label = 'Medecin',
                    minGrade = 1, -- Min grade level that can access? Set to 0 or false for everyone to use
                    maxGrade = 3,
                    male = {
                        ['tshirt_1'] = 122,  ['tshirt_2'] = 0,
                        ['torso_1'] = 250,   ['torso_2'] = 1,
                        ['arms'] = 85,
                        ['pants_1'] = 20,   ['pants_2'] = 0,
                        ['shoes_1'] = 112,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,  ['helmet_2'] = 0,
                        ['bproof_1'] = 0,
                        ['chain_1'] = 126,
                        ['decals_1'] = 58,
                    },
                    female = {
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 4,   ['torso_2'] = 14,
                        ['arms'] = 4,
                        ['pants_1'] = 25,   ['pants_2'] = 1,
                        ['shoes_1'] = 16,   ['shoes_2'] = 4,
                    }
                },
                [3] = {
                    label = 'Protecteur',
                    minGrade = 2, -- Min grade level that can access? Set to 0 or false for everyone to use
                    maxGrade = 2,
                    male = {
                        ['tshirt_1'] = 193,  ['tshirt_2'] = 0,
                        ['torso_1'] = 445,   ['torso_2'] = 0,
                        ['arms'] = 212,
                        ['pants_1'] = 164,   ['pants_2'] = 0,
                        ['shoes_1'] = 129,   ['shoes_2'] = 0,
                        ['helmet_1'] = 195,  ['helmet_2'] = 0,
                        ['bproof_1'] = 60,
                        ['chain_1'] = 166,
                        ['decals_1'] = 0,
                    },
                    female = {
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 4,   ['torso_2'] = 14,
                        ['arms'] = 4,
                        ['pants_1'] = 25,   ['pants_2'] = 1,
                        ['shoes_1'] = 16,   ['shoes_2'] = 4,
                    }
                },
                [4] = {
                    label = 'Sauveteur',
                    minGrade = 1, -- Min grade level that can access? Set to 0 or false for everyone to use
                    maxGrade = 1,
                    male = {
                        ['tshirt_1'] = 0,  ['tshirt_2'] = 0,
                        ['torso_1'] = 445,   ['torso_2'] = 0,
                        ['arms'] = 211,
                        ['pants_1'] = 164,   ['pants_2'] = 0,
                        ['shoes_1'] = 129,   ['shoes_2'] = 0,
                        ['helmet_1'] = 194,  ['helmet_2'] = 0,
                        ['bproof_1'] = 60,
                        ['chain_1'] = 0,
                        ['decals_1'] = 0,
                    },
                    female = {
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 4,   ['torso_2'] = 14,
                        ['arms'] = 4,
                        ['pants_1'] = 25,   ['pants_2'] = 1,
                        ['shoes_1'] = 16,   ['shoes_2'] = 4,
                    }
                },
                [5] = {
                    label = 'Recrue',
                    minGrade = 0, -- Min grade level that can access? Set to 0 or false for everyone to use
                    maxGrade = 0,
                    male = {
                        ['tshirt_1'] = 0,  ['tshirt_2'] = 0,
                        ['torso_1'] = 445,   ['torso_2'] = 0,
                        ['arms'] = 211,
                        ['pants_1'] = 163,   ['pants_2'] = 0,
                        ['shoes_1'] = 129,   ['shoes_2'] = 0,
                        ['helmet_1'] = 193,  ['helmet_2'] = 0,
                        ['bproof_1'] = 60,
                        ['chain_1'] = 0,
                        ['decals_1'] = 0,
                    },
                    female = {
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 4,   ['torso_2'] = 14,
                        ['arms'] = 4,
                        ['pants_1'] = 25,   ['pants_2'] = 1,
                        ['shoes_1'] = 16,   ['shoes_2'] = 4,
                    }
                },
                [6] = {
                    label = 'Hopital',
                    minGrade = 0, -- Min grade level that can access? Set to 0 or false for everyone to use
                    maxGrade = 0,
                    male = {
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 250,   ['torso_2'] = 1,
                        ['arms'] = 85,
                        ['pants_1'] = 20,   ['pants_2'] = 0,
                        ['shoes_1'] = 112,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,  ['helmet_2'] = 0,
                        ['bproof_1'] = 0,
                        ['chain_1'] = 126,
                        ['decals_1'] = 58,
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

        MedicalSupplies = { -- EMS Shop for supplies
            Enabled = true, -- If set to false, rest of this table do not matter
            Ped = 's_m_m_doctor_01', -- Ped to target
            Coords = vec3(354.77, -581.36, 43.19-0.95), -- Coords of ped/target
            Heading = 253.45, -- Heading of ped
            Supplies = { -- Supplies
                { item = 'medbag', label = 'Sac médical', price = false }, -- Pretty self explanatory, price may be set to 'false' to make free
                { item = 'medikit', label = 'Trousse de premiers secours', price = false },
            }
        },

        MedicalWeapons = { -- EMS Shop for supplies
            Enabled = true, -- Set to false if you don't want to use
            Coords = vec3(358.28, -582.83, 43.19), -- Coords of armoury
            jobLock = 'ambulance', -- Allow only one of these jobs to use this
            weapons = {
                [0] = { -- Recrue
                    ['WEAPON_BALL'] = { label = 'Balle', multiple = false, price = 10000 },
                },
                [1] = { -- Sauveteur
                    ['WEAPON_STUNGUN'] = { label = 'Tazer', multiple = false, price = false },
                    ['WEAPON_FLASHLIGHT'] = { label = 'Flashlight', multiple = false, price = false },
                    ['WEAPON_PISTOL_MK2'] = { label = 'Pistolet', multiple = false, price = false },
                    ['WEAPON_FLARE'] = { label = 'Fusée de détresse', multiple = false, price = false },
                    ['ammo'] = { label = 'Munition', multiple = true, price = 20 }, 
                },
                [2] = { -- Protecteur
                    ['WEAPON_STUNGUN'] = { label = 'Tazer', multiple = false, price = false },
                    ['WEAPON_FLASHLIGHT'] = { label = 'Flashlight', multiple = false, price = false },
                    ['WEAPON_PISTOL_MK2'] = { label = 'Pistolet', multiple = false, price = false },
                    ['WEAPON_ASSAULTSMG'] = { label = 'P90', multiple = false, price = false },
                    ['WEAPON_FLARE'] = { label = 'Fusée de détresse', multiple = false, price = false },
                    ['ammo'] = { label = 'Munition', multiple = true, price = 20 }, 
                },
                [3] = { -- Directeur
                    ['WEAPON_STUNGUN'] = { label = 'Tazer', multiple = false, price = false },
                    ['WEAPON_FLASHLIGHT'] = { label = 'Flashlight', multiple = false, price = false },
                    ['WEAPON_PISTOL_MK2'] = { label = 'Pistolet', multiple = false, price = false },
                    ['WEAPON_ASSAULTSMG'] = { label = 'P90', multiple = false, price = false },
                    ['WEAPON_FLARE'] = { label = 'Fusée de détresse', multiple = false, price = false },
                    ['ammo'] = { label = 'Munition', multiple = true, price = 20 }, 
                },
            }
        },

        Vehicles = { -- Vehicle Garage
            Enabled = true, -- Enable? False if you have you're own way for medics to obtain vehicles.
            Zone = {
                coords = vec3(298.54, -606.79, 43.27), -- Area to prompt vehicle garage
                range = 5.5, -- Range it will prompt from coords above
                label = '[E] - Accès Garage',
                return_label = '[E] - Rentrer le véhicule',
            },
            Spawn = {
                land = {
                    coords = vec3(296.16, -607.67, 43.25),
                    heading = 68.43
                },
                air = {
                    coords = vec3(351.24, -587.67, 74.55),
                    heading =  289.29
                }
            },
            Options = {
                ['atlus'] = { -- Car/Helicopter/Vehicle Spawn Code/Model Name
                    label = 'Traumacar',
                    category = 'land', -- Options are 'land' and 'air'
                },
            }
        },
    }
}

--[[ IMPORTANT THIS COULD BREAK SOMETHING ]]--
Config.DisableDeathAnimation = false -- Really, really, REALLY do not recommend setting this to true and it was added per request
