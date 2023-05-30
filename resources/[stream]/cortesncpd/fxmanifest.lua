fx_version 'bodacious'
games { 'rdr3', 'gta5' }
lua54 'yes'
files {
	'handling.meta',
    'vehicles.meta',
	'carvariations.meta',
	'carcols.meta'
}

client_scripts {
    'carname.lua',
	'side_leds_cortes.lua',
}

data_file 'HANDLING_FILE' 'handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'vehicles.meta'
data_file 'CARCOLS_FILE' 'carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'carvariations.meta'

dependency '/assetpacks'