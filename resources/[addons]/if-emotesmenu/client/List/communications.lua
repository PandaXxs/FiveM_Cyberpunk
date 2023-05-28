Communication = { --[emoteId] = {animDict, animName, label, labelTarget, AnimationOptions}
    ["handshake"] = { "mp_ped_interaction", "handshake_guy_a", "Handshake", "handshake2", AnimationOptions =
    {
        EmoteMoving = true,
        EmoteDuration = 3000,
        SyncOffsetFront = 0.9
    } },
    ["handshake2"] = { "mp_ped_interaction", "handshake_guy_b", "Handshake 2", "handshake", AnimationOptions =
    {
        EmoteMoving = true,
        EmoteDuration = 3000
    } },
    ["hug"] = { "mp_ped_interaction", "kisses_guy_a", "Hug", "hug2", AnimationOptions =
    {
        EmoteMoving = false,
        EmoteDuration = 5000,
        SyncOffsetFront = 1.05,
    } },
    ["hug2"] = { "mp_ped_interaction", "kisses_guy_b", "Hug 2", "hug", AnimationOptions =
    {
        EmoteMoving = false,
        EmoteDuration = 5000,
        SyncOffsetFront = 1.13
    } },
    ["hug3"] = {"misscarsteal2chad_goodbye", "chad_armsaround_chad", "Hug 3", "hug4", AnimationOptions =
    {
      EmoteMoving = false,
      EmoteLoop = true,
      SyncOffsetFront = 0.05,
    } },
    ["hug4"] = {"misscarsteal2chad_goodbye", "chad_armsaround_girl", "Hug 4", "hug3", AnimationOptions =
    {
      EmoteMoving = false,
      EmoteLoop = true,
      SyncOffsetFront = 0.13
    } },
    ["beso"] = {"hs3_ext-20", "cs_lestercrest_3_dual-20", "Kiss", "beso2", AnimationOptions =
    {
        EmoteMoving = false,
        EmoteDuration = 4000,
        SyncOffsetFront = 0.40,
    } },
    ["beso2"] = {"hs3_ext-20", "csb_georginacheng_dual-20", "Kiss 2", "beso", AnimationOptions =
    {
        EmoteMoving = false,
        EmoteDuration = 4000,
        SyncOffsetFront = 0.40,
    } },
    ["bro"] = { "mp_ped_interaction", "hugs_guy_a", "Bro", "bro2", AnimationOptions =
    {
        SyncOffsetFront = 1.14
    } },
    ["bro2"] = { "mp_ped_interaction", "hugs_guy_b", "Bro 2", "bro", AnimationOptions =
    {
        SyncOffsetFront = 1.14
    } },
    ["give"] = { "mp_common", "givetake1_a", "Give", "give2", AnimationOptions =
    {
        EmoteMoving = true,
        EmoteDuration = 2000
    } },
    ["give2"] = { "mp_common", "givetake1_b", "Give 2", "give", AnimationOptions =
    {
        EmoteMoving = true,
        EmoteDuration = 2000
    } },
    ["baseball"] = { "anim@arena@celeb@flat@paired@no_props@", "baseball_a_player_a", "Baseball", "baseballthrow" },
    ["baseballthrow"] = { "anim@arena@celeb@flat@paired@no_props@", "baseball_a_player_b", "Baseball Throw", "baseball" },
    ["stickup"] = { "random@countryside_gang_fight", "biker_02_stickup_loop", "Stick Up", "stickupscared",
        AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = true,
        } },
    ["stickupscared"] = { "missminuteman_1ig_2", "handsup_base", "Stickup Scared", "stickup", AnimationOptions =
    {
        EmoteMoving = true,
        EmoteLoop = true,
    } },
    ["punch"] = { "melee@unarmed@streamed_variations", "plyr_takedown_rear_lefthook", "Punch", "punched" },
    ["punched"] = { "melee@unarmed@streamed_variations", "victim_takedown_front_cross_r", "Punched", "punch" },
    ["headbutt"] = { "melee@unarmed@streamed_variations", "plyr_takedown_front_headbutt", "Headbutt", "headbutted" },
    ["headbutted"] = { "melee@unarmed@streamed_variations", "victim_takedown_front_headbutt", "Headbutted", "headbutt" },
    ["slap2"] = { "melee@unarmed@streamed_variations", "plyr_takedown_front_backslap", "Slap 2", "slapped2",
        AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = true,
            EmoteDuration = 2000,
        } },
    ["slap"] = { "melee@unarmed@streamed_variations", "plyr_takedown_front_slap", "Slap", "slapped",
        AnimationOptions =
        {
            EmoteLoop = true,
            EmoteMoving = true,
            EmoteDuration = 2000,
        } },
    ["slapped"] = { "melee@unarmed@streamed_variations", "victim_takedown_front_slap", "Slapped", "slap" },
    ["slapped2"] = { "melee@unarmed@streamed_variations", "victim_takedown_front_backslap", "Slapped 2", "slap2" },
}
