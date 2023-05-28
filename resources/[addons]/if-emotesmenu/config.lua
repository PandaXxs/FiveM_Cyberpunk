Config = {
    Locale = 'en',

    SaveThingsInDB = true, -- Save the players (keybinds+favorites) in the database (requires a database configured!)
    PlayerIdentifier = 'license',

    MenuKey = 'f3', -- The key to open the menu (leave blank to diable). https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/

    CancelAnimKey = 'DELETE', -- The key to cancel the anim. https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/

    AcceptSharedAnimKey = 246, -- Key to accept a shared anim. (https://docs.fivem.net/docs/game-references/controls/#controls)
    RefuseSharedAnimKey = 250, -- Key to refuse a shared anim. (https://docs.fivem.net/docs/game-references/controls/#controls)

    PlayClosesTheUI = false, -- If true, when any emote get played with the ui, it closes

    DefaultKeybinds = { -- https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
        [1] = 'NUMPAD1',
        [2] = 'NUMPAD2',
        [3] = 'NUMPAD3',
        [4] = 'NUMPAD4',
        [5] = 'NUMPAD5',
        [6] = 'NUMPAD6'
    }
}

Translations = {
    ['en'] = {
        ['noneToCancel'] = "No emote to cancel",
        ['notValidEmote'] = "'%s' is not a valid emote",
        ['maleSexOnly'] = "Sorry, but this emote is only available for Male",
        ['sentRequestTo'] = "Sent request to ~y~%s~s~ (~g~%s~s~)",
        ['emoteRequest'] = "[~y~Y~s~] to accept, [~r~R~s~] to refuse (~g~%s~s~)",
        ['notValidCommunicationEmote'] = "'%s' is not a valid shared emote",
        ['noPlayersNearby'] = "There's nobody close enough!",
        ['refusedRequest'] = "Request refused",
    }
}

ShowNotification = function(message, type)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(false, true)

    -- TriggerEvent('esx:showNotification', message, type)
end

-- Available exports:
--[[
    openEmotesMenu - exports['if-emotesmenu']:openEmotesMenu() -- Opens the emotes menu
    setDied - exports['if-emotesmenu']:setDied(true) -- Changed the died player status (makes the emotes menu unable when died)
]]--