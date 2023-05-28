Config = {}
Config.Locale = "fr"

Config.DrawDistance = 10.0

Config.Markers = {
	EntryPoint = {
		Type = 21,
		Size = {
			x = 1.0,
			y = 1.0,
			z = 0.5,
		},
		Color = {
			r = 50,
			g = 200,
			b = 50,
		},
	},
	GetOutPoint = {
		Type = 21,
		Size = {
			x = 1.0,
			y = 1.0,
			z = 0.5,
		},
		Color = {
			r = 200,
			g = 51,
			b = 51,
		},
	},
}

Config.Garages = {
	VespucciBoulevard = {
		EntryPoint = {
			x = -285.2,
			y = -886.5,
			z = 31.0,
		},
		SpawnPoint = {
			x = -309.3,
			y = -897.0,
			z = 31.0,
			heading = 351.8,
		},
		Sprite = 357,
		Scale = 0.7,
		Colour = 3,
		ImpoundedName = "LosSantos",
	},
	SanAndreasAvenue = {
		EntryPoint = {
			x = 216.4,
			y = -786.6,
			z = 30.8,
		},
		SpawnPoint = {
			x = 218.9,
			y = -779.7,
			z = 30.8,
			heading = 338.8,
		},
		Sprite = 357,
		Scale = 0.7,
		Colour = 3,
		ImpoundedName = "LosSantos",
	},
	Davis = {
		EntryPoint = {
			x = 163.0,
			y = -1537.27,
			z = 29.14,
		},
		SpawnPoint = {
			x = 162.94,
			y = -1529.81,
			z = 29.14,
			heading = 43.97,
		},
		Sprite = 357,
		Scale = 0.7,
		Colour = 3,
		ImpoundedName = "LosSantos",
	},

	Unipunk = {
		EntryPoint = {
			x = 166.38,
			y = -1284.01,
			z = 29.3,
		},
		SpawnPoint = {
			x = 163.05,
			y = -1281.9,
			z = 29.11,
			heading = 148.95,
		},
		Sprite = 357,
		Scale = 0.7,
		Colour = 3,
		ImpoundedName = "LosSantos",
	},

	Circlebar = {
		EntryPoint = {
			x = 333.35,
			y = -995.83,
			z = 29.26,
		},
		SpawnPoint = {
			x = 333.35,
			y = -1000.6,
			z = 29.31,
			heading = 179.78,
		},
		Sprite = 357,
		Scale = 0.7,
		Colour = 3,
		ImpoundedName = "LosSantos",
	},

	Mosleys = {
		EntryPoint = {
			x = -17.99,
			y = -1739.33,
			z = 29.3,
		},
		SpawnPoint = {
			x = -7.95,
			y = -1743.85,
			z = 29.3,
			heading = 50.98,
		},
		Sprite = 357,
		Scale = 0.7,
		Colour = 3,
		ImpoundedName = "LosSantos",
	},

	Concess = {
		EntryPoint = {
			x = -530.34,
			y = 49.84,
			z = 52.58,
		},
		SpawnPoint = {
			x = -521.73,
			y = 49.16,
			z = 52.58,
			heading = 80.38,
		},
		Sprite = 357,
		Scale = 0.7,
		Colour = 3,
		ImpoundedName = "LosSantos",
	},

	MecanoNord = {
		EntryPoint = {
			x = 1119.79,
			y = 2658.38,
			z = 38.0,
		},
		SpawnPoint = {
			x = 1120.42,
			y = 2648.52,
			z = 38.0,
			heading = 0.26,
		},
		Sprite = 357,
		Scale = 0.7,
		Colour = 3,
		ImpoundedName = "SandyShores",
	},

}

Config.Impounds = {
	LosSantos = {
		GetOutPoint = {
			x = 400.7,
			y = -1630.5,
			z = 29.3,
		},
		SpawnPoint = {
			x = 401.9,
			y = -1647.4,
			z = 29.2,
			heading = 323.3,
		},
		Sprite = 524,
		Scale = 0.7,
		Colour = 1,
		Cost = 3000,
	},
	PaletoBay = {
		GetOutPoint = {
			x = -211.4,
			y = 6206.5,
			z = 31.4,
		},
		SpawnPoint = {
			x = -204.6,
			y = 6221.6,
			z = 30.5,
			heading = 227.2,
		},
		Sprite = 524,
		Scale = 0.7,
		Colour = 1,
		Cost = 3000,
	},
	SandyShores = {
		GetOutPoint = {
			x = 1728.2,
			y = 3709.3,
			z = 33.2,
		},
		SpawnPoint = {
			x = 1722.7,
			y = 3713.6,
			z = 33.2,
			heading = 19.9,
		},
		Sprite = 524,
		Scale = 0.7,
		Colour = 1,
		Cost = 3000,
	},
}

exports("getGarages", function()
	return Config.Garages
end)
exports("getImpounds", function()
	return Config.Impounds
end)
