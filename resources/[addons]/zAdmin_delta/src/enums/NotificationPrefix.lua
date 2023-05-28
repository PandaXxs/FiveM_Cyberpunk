---@class NotificationPrefix
NotificationPrefix = {}

setmetatable(NotificationPrefix, {
    __call = function(_, key)
        return (Localization[key]):format(key)
    end
})