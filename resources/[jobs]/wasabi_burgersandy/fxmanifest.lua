-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
game 'gta5'
lua54 'yes'

description 'Wasabi ESX BurgerSandy Job Replacement'
author 'wasabirobby#5110'
version '1.2.8'

shared_scripts {
  '@ox_lib/init.lua',
  'configuration/config.lua',
  'configuration/strings.lua'
}

client_scripts {
  'death_reasons.lua',
  'client/*.lua'
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'configuration/deathlogs.lua',
  'server/*.lua'
}

dependencies {
  'es_extended',
  'ox_lib'
}

provides {
  'esx_BurgerSandyjob'
}

escrow_ignore {
  'configuration/**/*.lua',
  'death_reasons.lua',
  'client/*.lua',
  'server/*.lua'
}

dependency '/assetpacks'