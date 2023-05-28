Config = {}

Config.PriceDistrib = 1

Config.Machines = {
	{
		model = "prop_vend_soda_01",
		item = "ecola", 
		name = "E-Cola", 
		prop = "prop_ecola_can", 
		price = 1
	},
	{
		model = "prop_vend_soda_02", 
		item = "sprunk",
		name = "Sprunk",
		prop = "prop_ld_can_01",
		price = 1
	},
	{
		model = "prop_vend_snak_01",
		item = "p&qs",
		name = "Ps & Qs",
		prop = "prop_candy_pqs",
		price = 1
	}
}

Config.LsCustomspos = {
    {pos = vector3(-1423.359253, -449.600006, 35.909710), job = "hayes", notif = "Appuyez sur ~INPUT_CONTEXT~ pour accéder au ~b~Hayes Auto Body Shop~s~.", size = 10.0},
}

Config.Locations = {
    ProjectRP = {
        LocationVehicule = {
            {
                blip = false,
                job = false,
                ped = "ig_andreas",
                pedPos = vector3(-260.52, -967.21, 31.22),
                pedHeading = 65.32,
                pedLabel = "Location de véhicule",
                uiMessage = "Appuyez sur ~y~E~s~ pour louer un véhicule",
                vehicule = {
                    [0] = {
                        model = "scorcher",
                        label = "VTT",
                        price = false,
                    },
                    [1] = {
                        model = "blista",
                        label = "Blista",
                        price = 1000,
                    },
                    [2] = {
                        model = "asea",
                        label = "Asea",
                        price = 1500,
                    },
                },
                vehiculeSpawn = vector3(-237.34, -987.0, 29.29),
                vehiculeHeading = 159.34,
            },
        },
        Shops = {
            {
                blip = false,
                job = false,
                ped = "ig_andreas",
                pedPos = vector3(435.53, -978.36, 30.69),
                pedHeading = 177.67,
                pedLabel = "Session de véhicule",
                uiMessage = "Appuyez sur ~y~E~s~ pour acheter un contrat de session",
                items = {
                    [0] = {
                        name = "contrat",
                        label = "Contrat de vente",
                        price = 1500,
                        multiple = false
                    },
                },
            },
            {
                blip = {
                    sprite = 68,
                    color = 5,
                    label = "Magasins de pêche",
                    scale = 0.7,
                },
                job = false,
                ped = "cs_old_man2",
                pedPos = vector3(-1841.22, -1235.54, 13.63-0.5),
                pedHeading = 323.36,
                pedLabel = "Accessoires de pêche",
                uiMessage = "Appuyez sur ~y~E~s~ pour faire vos achats",
                items = {
                    [0] = {
                        name = "fishingrod",
                        label = "Canne à pêche",
                        price = 150,
                        multiple = false
                    },
                    [1] = {
                        name = "fishbait",
                        label = "Appât de pêche",
                        price = 15,
                        multiple = true
                    },
                },
            },
            {
                blip = {
                    sprite = 85,
                    color = 5,
                    label = "Vendeur de d'outils",
                    scale = 0.7,
                },
                job = false,
                ped = "a_m_o_soucent_02",
                pedPos = vector3(2832.43, 2798.14, 57.45),
                pedHeading = 102.44,
                pedLabel = "Mineur",
                uiMessage = "Appuyez sur ~y~E~s~ pour faire vos achats",
                items = {
                    [0] = {
                        name = "pickaxe",
                        label = "Pioche",
                        price = 1500,
                        multiple = false
                    },
                },
            },
            {
                blip = {
                    sprite = 616,
                    color = 60,
                    label = "Grossiste",
                    scale = 0.7,
                },
                job = false,
                -- job = {
                --     ["police"] = 4,
                -- },
                ped = "s_m_m_dockwork_01",
                pedPos = vector3(1191.28, -3108.86, 5.53),
                pedHeading = 4.53,
                pedLabel = "Grossiste",
                uiMessage = "Appuyez sur ~y~E~s~ pour faire vos achats",
                items = {
                    [0] = {
                        name = "fishingrod",
                        label = "Canne à pêche",
                        price = 100,
                        multiple = false
                    },
                    [1] = {
                        name = "fishbait",
                        label = "Appât de pêche",
                        price = 10,
                        multiple = true
                    },
                    [2] = {
                        name = "pickaxe",
                        label = "Pioche",
                        price = 1500,
                        multiple = false
                    },
                    [3] = {
                        name = "insectsecher",
                        label = "Insect Séché",
                        price = 5,
                        multiple = true
                    },
                    [4] = {
                        name = "batonviande",
                        label = "Bâton de viande",
                        price = 5,
                        multiple = true
                    },
                    [5] = {
                        name = "barre_energie",
                        label = "Barre Energétique",
                        price = 5,
                        multiple = true
                    },
                    [6] = {
                        name = "tofu",
                        label = "Tofu",
                        price = 5,
                        multiple = true
                    },
                    [7] = {
                        name = "water",
                        label = "Eau",
                        price = 5,
                        multiple = true
                    },
                    [8] = {
                        name = "smoothiesenergy",
                        label = "Smoothie Energétique",
                        price = 5,
                        multiple = true
                    },
                    [9] = {
                        name = "phone",
                        label = "Téléphone",
                        price = 5,
                        multiple = false
                    },
                },
            },
        },
        News = {
            {
                blip = {
                    sprite = 590,
                    color = 3,
                    label = "NC News",
                    scale = 0.6,
                },
                job = false,
                ped = "ig_andreas",
                pedPos = vector3(-1081.92, -247.77, 37.76),
                pedHeading = 208.6,
                pedLabel = "Passer une annonce",
                uiMessage = "Appuyez sur ~y~E~s~ pour passer votre annonce",
                price = 100,
            },
        },
        Blips = {
            {
                sprite = 776,
                color = 7,
                label = "NFT Galery",
                scale = 0.7,
                pos = vector3(-555.55, -618.37, 34.68),
            },
            {
                sprite = 767,
                color = 21,
                label = "Observatoire",
                scale = 0.7,
                pos = vector3(-429.75, 1109.3, 327.68),
            },
        },
        Braquage = {
            [1] = {
                Pos = {
                    {pos = vector3(147.04908752441, -1044.9448242188, 29.36802482605), AlReady = false, type = "V_ILEV_GB_VAULDR"}, 
                },
                MarkerInHUP = {
                    {pos = vector3(149.7427, -1044.95, 29.34629), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
                    {pos = vector3(151.1857, -1046.652, 29.34632), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
                    {pos = vector3(146.8222, -1048.481, 29.34629), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
                    {pos = vector3(148.0368, -1050.697, 29.34637), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
                    {pos = vector3(150.2164, -1049.937, 29.3464), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
                }
            },
            -- [2] = {
            --     Pos = {
            --         {pos = vector3(-2957.6674804688, 481.45776367188, 15.697026252747), AlReady = false, type = "hei_prop_heist_sec_door"}, 
            --     },
            --     MarkerInHUP = {
            --         {pos = vector3(-2958.463, 484.3734, 15.67529), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
            --         {pos = vector3(-2957.541, 485.8652, 15.67533), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
            --         {pos = vector3(-2954.178, 482.4733, 15.67531), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
            --         {pos = vector3(-2952.586, 484.1317, 15.67539), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
            --         {pos = vector3(-2953.984, 486.2795, 15.67542), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
            --     }
            -- },
            -- [3] = {
            --     Pos = {
            --         {pos = vector3(-107.06505584717, 6474.8012695313, 31.62670135498), AlReady = false, type = "V_ILEV_GB_VAULDR"}, 
            --     },
            --     MarkerInHUP = {
            --         {pos = vector3(-107.7005, 6475.642, 31.62671), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
            --         {pos = vector3(-107.1449, 6473.512, 31.62671), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
            --         {pos = vector3(-102.949, 6475.497, 31.62671), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
            --         {pos = vector3(-103.1978, 6478.169, 31.62673), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
            --         {pos = vector3(-105.9089, 6478.667, 31.62673), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
            --     }
            -- },
            [2] = {
                Pos = {
                    {pos = vector3(311.1028, -283.142, 54.17453), AlReady = false, type = "V_ILEV_GB_VAULDR"}, 
                },
                MarkerInHUP = {
                    {pos = vector3(314.2084, -283.2863, 54.14297), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
                    {pos = vector3(315.5706, -284.8874, 54.14301), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
                    {pos = vector3(311.225, -286.8789, 54.14302), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
                    {pos = vector3(312.3723, -289.0089, 54.14307), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
                    {pos = vector3(314.7957, -288.3649, 54.1431), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
                }
            },
            [3] = {
                Pos = {
                    {pos = vector3(-1211.79, -335.7816, 37.79078), AlReady = false, type = "V_ILEV_GB_VAULDR"}, 
                },
                MarkerInHUP = {
                    {pos = vector3(-1209.598, -333.6717, 37.75921), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
                    {pos = vector3(-1207.424, -333.8167, 37.75925), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
                    {pos = vector3(-1208.958, -338.303, 37.75926), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
                    {pos = vector3(-1206.722, -338.8639, 37.75931), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
                    {pos = vector3(-1205.549, -336.4772, 37.75933), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
                }
            },
            [4] = {
                Pos = {
                    {pos = vector3(-353.96, -54.12, 49.04), AlReady = false, type = "V_ILEV_GB_VAULDR"}, 
                },
                MarkerInHUP = {
                    {pos = vector3(-350.96, -54.04, 49.0), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
                    {pos = vector3(-349.48, -55.64, 49.0), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
                    {pos = vector3(-353.88, -57.72, 49.0), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
                    {pos = vector3(-352.44, -59.92, 49.0), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
                    {pos = vector3(-350.12, -59.0, 49.0), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
                }
            },
            -- [7] = {
            --     Pos = {
            --         {pos = vector3(1176.72, 2711.72, 38.08), AlReady = false, type = "V_ILEV_GB_VAULDR"}, 
            --     },
            --     MarkerInHUP = {
            --         {pos = vector3(1173.72, 2710.76, 38.08), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
            --         {pos = vector3(1171.8, 2711.84, 38.08), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
            --         {pos = vector3(1175.16, 2715.12, 38.08), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
            --         {pos = vector3(1173.28, 2716.76, 38.08), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
            --         {pos = vector3(1171.32, 2715.2, 38.08), action = math.random(8000, 10000), AlReady = false, timeToRob = 240000},
            --     }
            -- },
        },
    }
}

