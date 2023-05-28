NSFW_Anims = { -- [animId] = {animDict, animName, label, targetAnim, AnimationOptions} (set to false do disable this category)
    ["streetsexmale"] = {"misscarsteal2pimpsex", "shagloop_pimp", "Street Sex (Fuck)", "streetsexfemale", AnimationOptions =
    {
        EmoteLoop = true,
        SyncOffsetFront = 0.50,
    }},
    ["streetsexfemale"] = {"misscarsteal2pimpsex", "shagloop_hooker", "Street Sex (Get fucked)", "streetsexmale", AnimationOptions =
    {
        EmoteLoop = true,
        SyncOffsetFront = 0.04,
    }},

    ["receiveblowjob"] = {"misscarsteal2pimpsex", "pimpsex_punter", "Receive Blowjob", "giveblowjob", AnimationOptions =
    {
        EmoteLoop = true,
        EmoteDuration = 30000,
        SyncOffsetFront = 0.63,
    }},
    ["giveblowjob"] = {"misscarsteal2pimpsex", "pimpsex_hooker", "Give Blowjob", "receiveblowjob", AnimationOptions =
    {
        EmoteLoop = true,
        EmoteDuration = 30000,
        SyncOffsetFront = 0.63,
    }},
}