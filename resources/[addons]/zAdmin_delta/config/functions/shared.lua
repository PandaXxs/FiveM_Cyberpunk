---@class Functions
Functions = {}
ESX = exports.es_extended:getSharedObject()

-- Config des logs discord
Config = {}

-- Webhook URL
Config.Webhook = {
    openMenuLogs = 'https://discord.com/api/webhooks/1086376538435485706/sLKs7WoEE2n817QuknJDi2_YBm1Sfb3IaDFch_1nXhKob9xSwoqmir5jTjk_dZglLbS6',
    selfLogs = 'https://discord.com/api/webhooks/1086376538435485706/sLKs7WoEE2n817QuknJDi2_YBm1Sfb3IaDFch_1nXhKob9xSwoqmir5jTjk_dZglLbS6',
    playerLogs = 'https://discord.com/api/webhooks/1086376538435485706/sLKs7WoEE2n817QuknJDi2_YBm1Sfb3IaDFch_1nXhKob9xSwoqmir5jTjk_dZglLbS6',
    vehicleLogs = 'https://discord.com/api/webhooks/1086376538435485706/sLKs7WoEE2n817QuknJDi2_YBm1Sfb3IaDFch_1nXhKob9xSwoqmir5jTjk_dZglLbS6',
    reportLogs = 'https://discord.com/api/webhooks/1086376538435485706/sLKs7WoEE2n817QuknJDi2_YBm1Sfb3IaDFch_1nXhKob9xSwoqmir5jTjk_dZglLbS6',
    groupsLogs = 'https://discord.com/api/webhooks/1086376538435485706/sLKs7WoEE2n817QuknJDi2_YBm1Sfb3IaDFch_1nXhKob9xSwoqmir5jTjk_dZglLbS6',
    serverLogs = 'https://discord.com/api/webhooks/1086376538435485706/sLKs7WoEE2n817QuknJDi2_YBm1Sfb3IaDFch_1nXhKob9xSwoqmir5jTjk_dZglLbS6'
}


function Functions.formatDate(time)
    local date = os.date("*t", time)
    return ("%sh%s"):format(date.hour, date.min)
end

-- fonction permettant d'envoyer des logs discord
function Webhook(webhookUrl, message, color)
    print(webhookUrl, message, color)

    local connect = {}
    connect = {
        {
            ["color"] = 16711680,
            ["title"] = message,
            ["description"] = "```" .. message .. "```",
            ["footer"] = {
                ["text"] = "Night City RP - Logs",
            },
        }
    }
    PerformHttpRequest(webhookUrl, function() end, 'POST', json.encode({username = "Admin Logs", embeds = connect, avatarrl = "https://i.imgur.com/HMP7cbj.png"}), { ['Content-Type'] = 'application/json' })
end

