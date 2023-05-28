return {
	['bandage'] = {
		label = 'Bandage',
		weight = 115,
		client = {
			anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a', flag = 49 },
			prop = { model = `prop_rolled_sock_02`, pos = vec3(-0.14, -0.14, -0.08), rot = vec3(-50.0, -50.0, 0.0) },
			disable = { move = true, car = true, combat = true },
			usetime = 2500,
		}
	},
	
	-- BOUFF

	['insectsecher'] = {
		label = 'Insectes séché',
		weight = 110,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = '',
			usetime = 2500,
			notification = 'Vous avez mangé de délicieux insectes.'
		},
	},

	['batonviande'] = {
		label = 'Bâtonnet de viande',
		weight = 220,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = '',
			usetime = 2500,
			notification = 'Vous avez mangé de délicieux bâtonnet de viande.'
		},
	},

	['barre_energie'] = {
		label = 'Barre énergétique',
		weight = 220,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = '',
			usetime = 2500,
			notification = 'Vous avez mangé une délicieuse barre cyber-énergétique.'
		},
	},

	['tofu'] = {
		label = 'Barre au tofu',
		weight = 220,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = '',
			usetime = 2500,
			notification = 'Vous avez mangé une barre au tofu.'
		},
	},

	-- Unicorn BOUFF
	['bolnoixcajou'] = {
		label = 'Bol de noix de cajou',
		weight = 110,
		client = {
			status = { hunger = 220000 },
			anim = 'eating',
			prop = '',
			usetime = 2500,
			notification = 'Vous avez mangé des noix de cajou.'
		},
	},

	['saucisson'] = {
		label = 'Saucisson',
		weight = 220,
		client = {
			status = { hunger = 220000 },
			anim = 'eating',
			prop = '',
			usetime = 2500,
			notification = 'Vous avez mangé du saucisson.'
		},
	},

	['grapperaisin'] = {
		label = 'Grappe de raisin',
		weight = 220,
		client = {
			status = { hunger = 150000, thirst = 150000 },
			anim = 'eating',
			prop = '',
			usetime = 2500,
			notification = 'Vous avez mangé du raisin.'
		},
	},

	-- Boisson

	['smoothiesenergy'] = {
		label = 'Smoothie énergétique',
		weight = 350,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `v_ret_fh_bscup`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500,
			notification = 'Tu as étanché ta soif avec un smoothie.'
		}
	},

	------- DROGUE
	-- Weed
	['weed_lemonhaze'] = {
		label = 'Lemon Weed',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['weed_lemonhaze_seed'] = {
		label = 'Graine de lemon weed',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['fertilizer'] = {
		label = 'Engrais',
		weight = 25,
		stack = true,
		close = true,
		description =  'Engrais pour un projet de culture'
	},
	-- Synthécoke
	['kerosene'] = {
		label = 'Kérosène',
		weight = 65,
		stack = true,
		close = false,
	},

	['patecoca'] = {
		label = 'Pate de coca',
		weight = 65,
		stack = true,
		close = false,
	},

	['synthecoke'] = {
		label = 'Synthécoke',
		weight = 10,
		stack = true,
		close = false,
	},

	['table_synthecoke'] = {
		label = 'Craft synthécoke',
		weight = 65,
		stack = true,
		close = false,
	},

	-- Ampoule de smash
	['neuralite'] = {
		label = 'Neuralite',
		weight = 65,
		stack = true,
		close = false,
	},

	['lupuline'] = {
		label = 'Lupuline',
		weight = 65,
		stack = true,
		close = false,
	},

	['ampoulesmash'] = {
		label = 'Ampoule de smash',
		weight = 10,
		stack = true,
		close = false,
	},

	['table_smash'] = {
		label = 'Craft smash',
		weight = 65,
		stack = true,
		close = false,
	},


	-- Dorph
	['steroide'] = {
		label = 'Stéroide',
		weight = 65,
		stack = true,
		close = false,
	},

	['acide'] = {
		label = 'Acide',
		weight = 65,
		stack = true,
		close = false,
	},

	['pilluledorph'] = {
		label = 'Pillule de dorph',
		weight = 10,
		stack = true,
		close = false,
	},

	['table_dorph'] = {
		label = 'Craft dorph',
		weight = 65,
		stack = true,
		close = false,
	},

	-- Mining
	['copper'] = {
		label = 'Copper',
		weight = 750,
		stack = true,
		close = false,
	},

	['diamond'] = {
		label = 'Diamond',
		weight = 105,
		stack = true,
		close = false,
	},

	['gold'] = {
		label = 'Gold Bar',
		weight = 950,
		stack = false,
		close = false,
	},

	['iron'] = {
		label = 'Iron',
		weight = 750,
		stack = true,
		close = false,
	},

	['steel'] = {
		label = 'Steel',
		weight = 610,
		stack = true,
		close = false,
	},

	['emerald'] = {
		label = 'Emerald',
		weight = 105,
		stack = true,
		close = false,
	},

	['pickaxe'] = {
		label = 'Pickaxe',
		weight = 450,
		stack = false,
		close = false,
	},

	-- Pêche
	
	['tuna'] = {
		label = 'Tuna',
		weight = 650,
		stack = true,
		close = false,
	},
	
	['salmon'] = {
		label = 'Salmon',
		weight = 350,
		stack = true,
		close = false,
	},

	['trout'] = {
		label = 'Trout',
		weight = 250,
		stack = true,
		close = false,
	},

	['anchovy'] = {
		label = 'Anchovy',
		weight = 50,
		stack = true,
		close = false,
	},

	['fishbait'] = {
		label = 'Fish Bait',
		weight = 50,
		stack = true,
		close = false,
	},

	['fishingrod'] = {
		label = 'Fishing Rod',
		weight = 800,
		stack = true,
		close = true,
	},

	-- Auto-Tamponneuse
	['bumpton'] = {
		label = 'Jeton Auto-Tamponneuse',
		weight = 10,
		stack = true,
		close = true,
	},

	-- Crutch
	['crutch'] = {
		label = 'Béquille',
		weight = 165,
		stack = false,
		close = true,
	},
	['wheelchair'] = {
		label = 'Fauteuil roulant',
		weight = 540,
		stack = false,
		close = true,
	},

	-- Mécanicien
	['toolbox'] = {
		label = 'Caisse à outils',
		weight = 1000,
		stack = true,
		close = true,
	},

	['fixkit'] = {
		label = 'Kit de réparation',
		weight = 400,
		stack = true,
		close = true,
	},

	['nettoyagekit'] = {
		label = 'Kit de nettoyage',
		weight = 400,
		stack = true,
		close = true,
	},


	-- Unicorn BOISSON
	['cyberade'] = {
		label = 'Cyberade',
		weight = 350,
		client = {
			status = { thirst = 220000, drunk = 15000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `v_ret_fh_bscup`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500,
			notification = 'Tu as étanché ta soif avec un verre de Cyberade.'
		}
	},
	['datadrop'] = {
		label = 'Data Drop',
		weight = 350,
		client = {
			status = { thirst = 220000, drunk = 15000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `v_ret_fh_bscup`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500,
			notification = 'Tu as étanché ta soif avec un shot de Data Drop.'
		}
	},
	['sprayprote'] = {
		label = 'Spray de Protéines',
		weight = 350,
		client = {
			status = { thirst = 200000, drunk = 15000, addiction = 10000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `v_ret_fh_bscup`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500,
			notification = 'Tu as étanché ta soif avec un verre de Spray de Protéines.'
		}
	},

	['parachute'] = {
		label = 'Parachute',
		weight = 8000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		}
	},

	['garbage'] = {
		label = 'Ordures',
	},

	['paperbag'] = {
		label = 'Sac en papier',
		weight = 1,
		stack = false,
		close = false,
		consume = 0
	},

	['panties'] = {
		label = 'Culotte',
		weight = 10,
		consume = 0,
		client = {
			status = { thirst = -100000, stress = -25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_cs_panties_02`, pos = vec3(0.03, 0.0, 0.02), rot = vec3(0.0, -13.5, -1.5) },
			usetime = 2500,
		}
	},

	["phone"] = {
		label = "Téléphone",
		weight = 190,
		stack = false,
		consume = 0,
		client = {
			export = "lb-phone.UsePhoneItem",
			remove = function()
				TriggerEvent("lb-phone:itemRemoved")
			end,
			add = function()
				TriggerEvent("lb-phone:itemAdded")
			end
		}
	},

	['money'] = {
		label = 'Cash',
	},

	['mustard'] = {
		label = 'Moutarde',
		weight = 500,
		client = {
			status = { hunger = 25000, thirst = 25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_food_mustard`, pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
			usetime = 2500,
			notification = 'Tu... as bu de la moutarde'
		}
	},

	['water'] = {
		label = 'Eau',
		weight = 500,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 2500,
			cancel = true,
			notification = 'Tu as bu de l\'eau rafraîchissante'
		}
	},

	['radio'] = {
		label = 'Radio',
		weight = 1000,
		stack = false,
		allowArmed = true
	},

	['armour'] = {
		label = 'Gilet pare-balles',
		weight = 3000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 3500
		}
	},

	['clothing'] = {
		label = 'Vêtements',
		consume = 0,
	},


	['scrapmetal'] = {
		label = 'Ferraille',
		weight = 80,
	},

	-- EMS 
	['medikit'] = { -- Make sure not already a medikit
		label = 'Kit de soin',
		weight = 165,
		stack = true,
		close = true,
	},
	['medbag'] = {
		label = 'Sac médical',
		weight = 165,
		stack = false,
		close = true,
	},

	['tweezers'] = {
		label = 'Pince à épiler',
		weight = 2,
		stack = true,
		close = true,
	},

	['suturekit'] = {
		label = 'Trousse de sutures',
		weight = 15,
		stack = true,
		close = true,
	},

	['icepack'] = {
		label = 'Pack de glace',
		weight = 29,
		stack = true,
		close = true,
	},

	['burncream'] = {
		label = 'Crème contre les Brûlure',
		weight = 19,
		stack = true,
		close = true,
	},

	['defib'] = {
		label = 'Défibrillateur',
		weight = 225,
		stack = false,
		close = true,
	},

	['sedative'] = {
		label = 'Sédatif',
		weight = 15,
		stack = true,
		close = true,
	},

	['stretcher'] = {
		label = 'Brancard',
		weight = 650,
		stack = false,
		close = true,
	},

	['wheelchair'] = {
		label = 'Fauteuil roulant',
		weight = 650,
		stack = false,
		close = true,
	},

	['recoveredbullet'] = {
		label = 'Balle récupérée',
		weight = 1,
		stack = true,
		close = false,
	},

	['contrat'] = {
		label = 'Contrat de session',
		weight = 1,
		stack = true,
		close = false,
	},

	['drill'] = {
		label = 'Perceuse Cybernétique',
		weight = 1,
		stack = false,
		close = false,
	},
}
