---wip types

---@class OxStash
---@field name string
---@field label string
---@field owner? boolean | string | number
---@field slots number
---@field weight number
---@field groups? string | string[] | { [string]: number }
---@field blip? { id: number, colour: number, scale: number }
---@field coords? vector3
---@field target? { loc: vector3, length: number, width: number, heading: number, minZ: number, maxZ: number, distance: number, debug?: boolean, drawSprite?: boolean }

return {
	{
		coords = vec3(452.1, -992.14, 31.72),
		target = {
			loc = vec3(452.1, -992.14, 31.72),
			length = 1.2,
			width = 5.6,
			heading = 0,
			minZ = 29.49,
			maxZ = 32.09,
			label = 'Ouvrir le casier personnel'
		},
		name = 'policelocker',
		label = 'Casier personnel',
		owner = true,
		slots = 70,
		weight = 70000,
		groups = shared.police
	},

	{
		coords = vec3(301.3, -600.23, 43.28),
		target = {
			loc = vec3(301.82, -600.99, 43.29),
			length = 0.6,
			width = 1.8,
			heading = 340,
			minZ = 43.34,
			maxZ = 44.74,
			label = 'Ouvrir le casier personnel'
		},
		name = 'emslocker',
		label = 'Casier personnel',
		owner = true,
		slots = 70,
		weight = 70000,
		groups = {['ambulance'] = 0}
	},
}
