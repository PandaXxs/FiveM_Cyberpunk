fx_version "bodacious"
games {"gta5"}
lua54 'yes'

escrow_ignore {
    'config.lua',
}

shared_scripts { '@ox_lib/init.lua', 'configuration/*.lua' }

client_scripts {
    "esx/cl_esx.lua",
    "events.lua",
    "functions.lua",
    "player/braquage/cl_fleeca.lua",
    "player/braquage/fc_fleeca.lua",
    "player/braquage/hacking/cl_hacking.lua",
    "player/braquage/hacking/fc_hacking.lua",
    "player/distributeur/cl_distributeur.lua",
    "player/radialmenu/cl_radialmenu.lua",
    'modules/cl_density.lua',
    'modules/cl_utils.lua',
    'modules/cl_location.lua',
    'modules/cl_shops.lua',
    'modules/cl_news.lua',
    'modules/cl_blips.lua',
    'modules/cl_pointhandup.lua',
    'modules/call/cl_call.lua',
}

shared_scripts {
	"config.lua",
    '@es_extended/imports.lua',
    '@es_extended/locale.lua',
}


server_scripts {
    "@es_extended/locale.lua",
    "@oxmysql/lib/MySQL.lua",
    "events_sv.lua",
    'locales/*.lua',
    "esx/sv_esx.lua",
    "player/braquage/sv_fleeca.lua",
    "player/distributeur/sv_distributeur.lua",
    'modules/call/sv_call.lua',
}

    ui_page {
        "player/braquage/hacking/global.html",
    }
  
    files {
        "player/braquage/hacking/global.html",
        "player/braquage/hacking/phone.png",
        "player/braquage/hacking/snd/beep.ogg",
        "player/braquage/hacking/snd/correct.ogg",
        "player/braquage/hacking/snd/fail.ogg", 
        "player/braquage/hacking/snd/start.ogg",
        "player/braquage/hacking/snd/finish.ogg",
        "player/braquage/hacking/snd/wrong.ogg",
    }