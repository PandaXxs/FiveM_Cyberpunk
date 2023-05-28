-----------------For support, scripts, and more----------------
----------------- https://discord.gg/mAWTDPsA  --------------
---------------------------------------------------------------

local seconds = 1000
Config = {}

Config.checkForUpdates = true -- Check for updates?

Config.DiscordInfo = {
    botToken = 'NzE4NTc3MTk3NDgwMTQ5MDIy.GgcZgO.YPHPRsTTOhOIIyyX6W7MXlmpv-DQEBSh_YnGRc', -- Your Discord bot token here
    guildID = '595931709695066132', -- Your Discord's server ID here(Aka Guild ID)
}

Config.DiscordWhitelist = { -- Restrict if someone can fly in if they lack specific Discord role(s)
    enabled = true, -- Enable?
    deniedMessage = 'https://discord.gg/mAWTDPsA : Rejoignez notre serveur Discord et prener votre rôle pour jouer!', -- Message for those who lack whitelisted role(s)
    whitelistedRoles = {
        '1072137510320341013', -- Maybe like a civilian role or whitelisted role(can add multiple to table)
    }
}

Config.DiscordQueue = {
    enabled = true, -- Enable? Requires
    refreshTime = 2.5 * seconds, -- How long between queue refreshes(Default: 2.5 * seconds)
    maxConnections = GetConvar("sv_maxclients", 64), -- How many slots do you have avaliable in total for server
    title = 'ProjectRP', -- Maybe server name here?

    image = { -- Image shown on adaptive card
        link = '', -- Link to image, maybe like a server logo?
        width = '0px', -- Width of image(would not go much higher than this)
        height = '0px' -- Height
    },

    -- Trad FR
    currentQueueText = 'En file d\'attente',

    currentSpotText = 'File d\'attente: %s | Total en ligne: %s/%s',

    footerText = 'Visitez notre boutique pour réserver une file d\'attente prioritaire!',

    overflowQueueText = 'Et %s plus de joueurs!\n',
    

    buttons = { -- The little buttons at the bottom of the screen
        button1 = { -- Webstore button config
            title = 'Boutique',
            iconUrl = 'https://i.imgur.com/8msLEGN.png', -- Little button icon image link
            url = 'https://ProjectRP.tebex.io/' -- Link button goes to
        },
        button2 = {
            title = 'Discord',
            iconUrl = 'https://i.imgur.com/4a1Rdgf.png',
            url = 'https://discord.gg/mAWTDPsA'
        }
    },
    roles = {

        { -- This ones provided by default are purely for example
            name = 'Citoyen', -- Name you want displayed as role on queue card
            roleId = '1072137510320341013', -- Role ID of role
            points = 0 -- Points to add to queue(Higher the number, higher the queue)
        },
        {
            name = 'Staff',
            roleId = '596399217904189478', -- Staff
            points = 60
        },
    }
}

strings = {
    verifyConnection = 'ProjectRP - Vérification de la connexion',
    verifyLauncher = 'ProjectRP - Vérification du Launcher...',
    verifyDiscord = 'ProjectRP - Vérification du Discord...',
    verifyQueue = 'ProjectRP - Ajout à la file d\'attente...',
    notInDiscord = 'ProjectRP - Vous devez rejoindre le discord: https://discord.gg/mAWTDPsA pour rejoindre le serveur!',
    noDiscord = 'ProjectRP - Vous devez avoir Discord téléchargé, installé et en cours d\'exécution pour vous connecter!',
    error = 'ProjectRP - Une erreur s\'est produite, veuillez réessayer!'
}
