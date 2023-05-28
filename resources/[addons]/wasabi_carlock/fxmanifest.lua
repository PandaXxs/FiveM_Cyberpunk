-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'Wasabi ESX/QBCore Car Lock'
author 'wasabirobby#5110'
version '2.0.4'

shared_scripts { '@ox_lib/init.lua', 'configuration/*.lua' }

client_scripts { 'bridge/**/client.lua', 'client/*.lua' }

server_scripts { '@mysql-async/lib/MySQL.lua', 'bridge/**/server.lua', 'server/*.lua' }

dependencies { 'mysql-async', 'ox_lib' }

escrow_ignore {
  'bridge/**/*.lua',
  'configuration/*.lua',
  'client/*.lua',
  'server/*.lua'
}

dependency '/assetpacks'