fx_version 'bodacious'
games { 'gta5' }

this_is_a_map "yes"

lua54 'yes'

escrow_asset{
    "shared/config.lua"
}


files {
  "interiorproxies.meta"
}

data_file 'INTERIOR_PROXY_ORDER_FILE' 'interiorproxies.meta'

fx_version 'bodacious'
games { 'gta5' }

client_scripts{
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",
    "client/cl_ascenceur.lua"
}

server_scripts{
    "server/sv_ascenceur.lua"
}

shared_scripts{
    "shared/config.lua"
}

dependency '/assetpacks'