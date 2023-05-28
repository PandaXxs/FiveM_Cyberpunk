---wip types

---@class OxShop
---@field name string
---@field label? string
---@field blip? { id: number, colour: number, scale: number }
---@field inventory { name: string, price: number, count?: number, currency?: string }
---@field locations? vector3[]
---@field targets? { loc: vector3, length: number, width: number, heading: number, minZ: number, maxZ: number, distance: number, debug?: boolean, drawSprite?: boolean }[]
---@field groups? string | string[] | { [string]: number }
---@field model? number[]

return {
	General = {
		name = 'Magasin',
		blip = {
			id = 59, colour = 69, scale = 0.8
		}, inventory = {
			{ name = 'insectsecher', price = 10 },
			{ name = 'batonviande', price = 10 },
			{ name = 'barre_energie', price = 10 },
			{ name = 'tofu', price = 10 },
			{ name = 'water', price = 10 },
			{ name = 'smoothiesenergy', price = 10 },
			{ name = 'phone', price = 10 },
			{ name = 'fertilizer', price = 10},
		}, locations = {
			vec3(25.7, -1347.3, 29.49), --1
			vec3(1961.48, 3739.96, 32.34), --6
			vec3(-1222.915, -906.983, 12.326), --12

		}, targets = {
			{ loc = vec3(25.06, -1347.32, 29.5), length = 0.7, width = 0.5, heading = 0.0, minZ = 29.5, maxZ = 29.9, distance = 1.5 },
			{ loc = vec3(1960.54, 3740.28, 32.34), length = 0.6, width = 0.5, heading = 120.0, minZ = 32.34, maxZ = 32.74, distance = 1.5 },
			{ loc = vec3(-1222.33, -907.82, 12.43), length = 0.6, width = 0.5, heading = 32.7, minZ = 12.3, maxZ = 12.7, distance = 1.5 }
		}
	},

	Ammunation = {
		name = 'Ammunation',
		blip = {
			id = 110, colour = 69, scale = 0.6
		}, inventory = {
			{ name = 'WEAPON_GOLFCLUB', price = 1000 },
			{ name = 'WEAPON_CROWBAR', price = 1000 },
			{ name = 'WEAPON_HAMMER', price = 1000 },
			{ name = 'WEAPON_BAT', price = 1000 },
		}, locations = {
			vec3(16.4, -1104.65, 29.78),
		}, targets = {
			{ loc = vec3(16.4, -1104.65, 29.78), length = 0.6, width = 0.5, heading = 180.0, minZ = 21.8, maxZ = 22.2, distance = 2.0 },
		}
	},

	-- PoliceArmoury = {
	-- 	name = 'Police Armoury',
	-- 	groups = shared.police,
	-- 	blip = {
	-- 		id = 110, colour = 84, scale = 0.8
	-- 	}, inventory = {
	-- 		{ name = 'ammo', price = 5, },
	-- 		{ name = 'WEAPON_FLASHLIGHT', price = 200 },
	-- 		{ name = 'WEAPON_NIGHTSTICK', price = 100 },
	-- 		{ name = 'WEAPON_PISTOL', price = 500, metadata = { registered = true, serial = 'POL' }, license = 'weapon' },
	-- 		{ name = 'WEAPON_CARBINERIFLE', price = 1000, metadata = { registered = true, serial = 'POL' }, license = 'weapon', grade = 3 },
	-- 		{ name = 'WEAPON_STUNGUN', price = 500, metadata = { registered = true, serial = 'POL'} }
	-- 	}, locations = {
	-- 		vec3(451.51, -979.44, 30.68)
	-- 	}, targets = {
	-- 		{ loc = vec3(453.21, -980.03, 30.68), length = 0.5, width = 3.0, heading = 270.0, minZ = 30.5, maxZ = 32.0, distance = 6 }
	-- 	}
	-- },

	-- Medicine = {
	-- 	name = 'Medicine Cabinet',
	-- 	groups = {
	-- 		['ambulance'] = 0
	-- 	},
	-- 	blip = {
	-- 		id = 403, colour = 69, scale = 0.8
	-- 	}, inventory = {
	-- 		{ name = 'medikit', price = 26 },
	-- 		{ name = 'bandage', price = 5 }
	-- 	}, locations = {
	-- 		vec3(306.3687, -601.5139, 43.28406)
	-- 	}, targets = {

	-- 	}
	-- },

	-- BlackMarketArms = {
	-- 	name = 'Black Market (Arms)',
	-- 	inventory = {
	-- 		{ name = 'WEAPON_DAGGER', price = 5000, metadata = { registered = false	}, currency = 'crypto' },
	-- 		{ name = 'WEAPON_CERAMICPISTOL', price = 50000, metadata = { registered = false }, currency = 'crypto' },
	-- 		{ name = 'at_suppressor_light', price = 50000, currency = 'crypto' },
	-- 		{ name = 'ammo', price = 1000, currency = 'crypto' },
	-- 	}, locations = {
	-- 		vec3(309.09, -913.75, 56.46)
	-- 	}, targets = {

	-- 	}
	-- },

	VendingMachineDrinks = {
		name = 'Distributeur automatique',
		inventory = {
			{ name = 'water', price = 10 },
			{ name = 'cola', price = 10 },
		},
		model = {
			`prop_vend_soda_02`, `prop_vend_fridge01`, `prop_vend_water_01`, `prop_vend_soda_01`
		}
	}
}
