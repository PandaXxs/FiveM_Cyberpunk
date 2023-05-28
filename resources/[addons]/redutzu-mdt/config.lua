Config = Config or {}

-- Misc

Config.UseDiscordImages = true -- Only set this to false if you are using a different image hosting service

-- Mugshot

Config.Mugshot = {
    Enabled = true,
    Name = 'police_mugshot',
    Title = 'ARRESTED',
    Label = 'Los Santos Police Department',
    Level = 1
}

-- Notifications Messages

Config.Messages = {
    ['player:fine'] = 'You got a ${{amount}} fine!',
    ['not_allowed'] = 'You are not allowed to open the MDT!'
}