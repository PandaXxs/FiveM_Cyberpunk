-------------------------------------------------------------
-- Calm-AI V3- A Simple FiveM Script, Made By Jordan.#2139 --
-------------------------------------------------------------

fx_version 'bodacious'
games { 'gta5' }

-- Define the resource metadata
name 'Calm-AI'
description 'calm ai'
author 'Jordan.#2139'
version 'v1'


-- Client Scripts
client_script "client.lua"

-- Server Scripts
server_script "server.lua"

-- Calling Files For The Script
files {
	'events.meta',
	'relationships.dat'
}

-- Defining the data file
data_file 'FIVEM_LOVES_YOU_4B38E96CC036038F' 'events.meta'