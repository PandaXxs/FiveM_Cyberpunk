fx_version 'cerulean'
game 'gta5'

author 'IF Developments'

lua54 'yes'

shared_script 'config.lua'
client_scripts {
    'client/*.lua',
    'client/List/*.lua'
}
server_scripts {
    '@mysql-async/lib/MySQL.lua', -- mysql-async or oxmysql
    'server/*.lua'
}

ui_page 'nui/index.html'
files {
    'nui/*',
    'nui/**/*',
    'nui/**/**/*'
}

escrow_ignore {
    'config.lua',
    'client/List/*.lua'
}
dependency '/assetpacks'