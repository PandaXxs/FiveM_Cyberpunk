Config = {}
Translation = {}

Config.Shopkeeper = 416176080 -- hash of the shopkeeper ped
Config.Locale = 'custom' -- 'en', 'sv' or 'custom'

Config.Shops = {
    {coords = vector3(24.03, -1345.63, 29.5-0.98), heading = 266.0, money = {1000, 1500}, cops = 2, blip = false, name = 'Braquage Superette', cooldown = {hour = 0, minute = 15, second = 0}, robbed = false},
    {coords = vector3(-1221.75, -908.82, 12.32), heading = 34.39, money = {1000, 1500}, cops = 2, blip = false, name = 'Braquage Superette', cooldown = {hour = 0, minute = 15, second = 0}, robbed = false},
    {coords = vector3(1958.93, 3742.06, 32.34), heading = 297.17, money = {1000, 1500}, cops = 2, blip = false, name = 'Braquage Superette', cooldown = {hour = 0, minute = 15, second = 0}, robbed = false},
}

Translation = {
    ['en'] = {
        ['shopkeeper'] = 'shopkeeper',
        ['robbed'] = "I was just robbed and ~r~don't ~w~have any money left!",
        ['cashrecieved'] = 'You got:',
        ['currency'] = '$',
        ['scared'] = 'Scared:',
        ['no_cops'] = 'There are ~r~not~w~ enough cops online!',
        ['cop_msg'] = 'We have sent a photo of the robber taken by the CCTV camera!',
        ['set_waypoint'] = 'Set waypoint to the store',
        ['hide_box'] = 'Close this box',
        ['robbery'] = 'Robbery in progress',
        ['walked_too_far'] = 'You walked too far away!'
    },
    ['sv'] = {
        ['shopkeeper'] = 'butiksbiträde',
        ['robbed'] = 'Jag blev precis rånad och har inga pengar kvar!',
        ['cashrecieved'] = 'Du fick:',
        ['currency'] = 'SEK',
        ['scared'] = 'Rädd:',
        ['no_cops'] = 'Det är inte tillräckligt med poliser online!',
        ['cop_msg'] = 'Vi har skickat en bild på rånaren från övervakningskamerorna!',
        ['set_waypoint'] = 'Sätt GPS punkt på butiken',
        ['hide_box'] = 'Stäng denna rutan',
        ['robbery'] = 'Pågående butiksrån',
        ['walked_too_far'] = 'Du gick för långt bort!'
    },
    ['custom'] = { -- edit this to your language
        ['shopkeeper'] = 'Commerçant',
        ['robbed'] = 'On vient de me voler et je ~r~n\'ai plus ~w~d\'argent !',
        ['cashrecieved'] = 'Vous avez :',
        ['currency'] = '$',
        ['scared'] = 'Effrayé :',
        ['no_cops'] = 'Il n\'y a ~r~pas~w~ assez de flics en ligne !',
        ['cop_msg'] = 'Nous avons envoyé une photo du voleur prise par la caméra de vidéosurveillance !',
        ['set_waypoint'] = 'Définir le waypoint jusqu\'au magasin',
        ['hide_box'] = 'Fermer cette boîte',
        ['robbery'] = 'Braquage en cours',
        ['walked_too_far'] = 'Tu es parti trop loin !'
    }
}