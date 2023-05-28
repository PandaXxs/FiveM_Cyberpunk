--[[
    zAdmin Delta by PabloCoding

    Issue ? Contact me on Discord : https://discord.gg/MXZj6bwS3P
--]]

lua54 "yes"
fx_version "adamant"
game "gta5"

files {
    "config/outfits/*.json",
    "locales/*.json",
}

escrow_ignore {
    "config/**/*",
    "src/enums/*.lua",
    "src/actions/**/*",
    "locales/*.json",
}

-- MySQL (Chose the righth one corresponding to your MySQL library)
server_script "@mysql-async/lib/MySQL.lua"

--[[
    Configuration
--]]

-- Main
shared_script "config/shared.lua"
server_script "config/server.lua"

-- Context
shared_script "config/context/shared.lua"
server_script "config/context/server.lua"
client_script "config/context/client.lua"

-- Functions
shared_script "config/functions/shared.lua"
server_script "config/functions/server.lua"
client_script "config/functions/client.lua"

--[[
    Vendors
--]]

-- RageUI
client_scripts {
    "src/vendors/RageUI/RMenu.lua",
    "src/vendors/RageUI/menu/RageUI.lua",
    "src/vendors/RageUI/menu/Menu.lua",
    "src/vendors/RageUI/menu/MenuController.lua",
    "src/vendors/RageUI/components/*.lua",
    "src/vendors/RageUI/menu/elements/*.lua",
    "src/vendors/RageUI/menu/items/*.lua",
    "src/vendors/RageUI/menu/panels/*.lua",
    "src/vendors/RageUI/menu/windows/*.lua",
}

--[[
    zAdmin
--]]

-- Utils
shared_script "src/utils/shared/*.lua"
server_script "src/utils/server/*.lua"
client_script "src/utils/client/*.lua"

-- Constant
shared_script "src/constant/shared/*.lua"
server_script "src/constant/server/*.lua"
client_script "src/constant/client/*.lua"

-- Enum
shared_script "src/enums/*.lua"

-- Classes
shared_script "src/classes/*.lua"

-- Localization
shared_script "src/localization/main.lua"

-- Modules
shared_script "src/modules/**/shared/*.lua"
server_script "src/modules/**/server/*.lua"
client_script "src/modules/**/client/*.lua"

-- Server Commands
server_script "src/commands/server/*.lua"

-- Core
shared_script "src/core/shared.lua"
server_script "src/core/server.lua"
client_script "src/core/client.lua"

-- Actions
shared_script "src/actions/**/content/*.lua"
server_script "src/actions/**/events/*.lua"

-- Menus
client_scripts {
    "src/menus/**/main.lua",
    "src/menus/**/components/*.lua"
}

--[[
    Export
--]]
exports {
    "selfHasPermission"
}

server_exports {
    "playerHasPermission"
}
dependency '/assetpacks'