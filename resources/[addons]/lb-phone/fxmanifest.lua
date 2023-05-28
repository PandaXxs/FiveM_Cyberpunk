fx_version "cerulean"
game "gta5"
lua54 "yes"

version "1.2.6"

shared_script {
    "config/*.lua",
    "shared/**/*.lua"
}

shared_scripts { '@ox_lib/init.lua', 'configuration/*.lua' }

client_script "client/**/*.lua"

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "server/**/*.lua",
    "config/server.lua"
}

files {
    "ui/dist/**/*",

    "ui/components.js",
    "config/**/*"
}

ui_page "ui/dist/index.html"

dependencies {
    "loaf_lib",
    "mysql-async"
}

escrow_ignore {
    "config/**/*",

    "client/apps/framework/*.lua",
    "server/apps/framework/*.lua",
    "shared/*.lua",

    "client/custom/**/*.lua",
    "server/custom/**/*.lua",

    "server/apiKeys.lua",
}

dependency '/assetpacks'