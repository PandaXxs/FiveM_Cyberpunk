
fx_version 'adamant'
game 'gta5'

author 'c8re'
description 'Create your own Drugs and asign effects'
version '1.2.0'

ui_page 'html/form.html'

lua54 'yes'

shared_scripts { '@ox_lib/init.lua', 'configuration/*.lua' }

files {
	'html/form.html',
	'html/css.css',
	'html/script.js',
	'html/jquery-3.4.1.min.js',
	'html/img/*.png',
}

client_scripts{
    'config.lua',
    'client/main.lua',
}

server_scripts{
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server/main.lua',
    'UsableItems.lua'
}

escrow_ignore {
  'client/main.lua',
  'server/main.lua',
  'config.lua',
  'UsableItems.lua'
}

