GangBuilder = {
    UseWeaponItem = false, -- A activer si vous utiliser les armes en item 
    Groups = {"admin","superadmin","dev","owner"}, -- Groups pouvant utiliser le /gangbuilder 
    GradeLimit = 10,-- Limite de grade que le créateur peut ajouter au gang
    VehicleLimit = 4, -- Limite de véhicule que le créateur peut ajouter au gang
    Salary = 0, -- Salaire de chaque grade pour les membres d'un gang 
    BlackListVehicles = { -- Liste des véhicules blacklist lors de la création d'un gang 
        "adder","t20","zentorno"
    },
    Markers = { -- Configuration des markers (type, taille, couleurs, opacité)
        ["storage"] = {type = 22, size = 0.85, colour = {11, 192, 229}, opacity = 255},
        ["gestion"] = {type = 22, size = 0.85, colour = {138, 35, 235}, opacity = 255},
        ["garage"] = {type = 22, size = 0.85, colour = {35, 235, 65}, opacity = 255},
        ["stored"] = {type = 22, size = 0.85, colour = {255, 0, 0}, opacity = 255}
    }
}   