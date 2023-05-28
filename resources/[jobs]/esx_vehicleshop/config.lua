Config                            = {}
Config.DrawDistance               = 10
Config.MarkerColor                = {r = 180, g = 79, b = 254}
Config.EnablePlayerManagement     = false -- enables the actual car dealer job. You'll need esx_addonaccount, esx_billing and esx_society
Config.ResellPercentage           = 50

Config.Locale                     = 'fr'

Config.LicenseEnable = false -- require people to own drivers license when buying vehicles? Only applies if EnablePlayerManagement is disabled. Requires esx_license

-- looks like this: 'LLL NNN'
-- The maximum plate length is 8 chars (including spaces & symbols), don't go past it!
Config.PlateLetters  = 3
Config.PlateNumbers  = 3
Config.PlateUseSpace = true

Config.OxInventory = ESX.GetConfig().OxInventory

Config.Blip = {
	show = true,
	Sprite = 326,
	Display = 4,
	Scale = 0.8
}

Config.Zones = {

	ShopEntering = {
		Pos   = vector3(-518.83, 54.47, 44.92),
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Type  = 22
	},

	ShopInside = {
		Pos     = vector3(-530.61, 49.28, 44.96),
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Heading = 180.52,
		Type    = -1
	},

	ShopOutside = {
		Pos     = vector3(-497.92, 59.45, 56.5),
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Heading = 165.78,
		Type    = -1
	},

	BossActions = {
		Pos   = vector3(-32.0, -1114.2, 25.4),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = -1
	},

	GiveBackVehicle = {
		Pos   = vector3(-18.2, -1078.5, 25.6),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Type  = (Config.EnablePlayerManagement and 1 or -1)
	},

}
