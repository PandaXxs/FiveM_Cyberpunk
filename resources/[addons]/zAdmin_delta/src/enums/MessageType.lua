MessageType = {
    SUCCESS = 1,
    WARNING = 2,
    ERROR = 3,
    DEBUG = 4,
    INFO = 5
}

local colorTable <const> = {
    [MessageType.SUCCESS] = "^2",
    [MessageType.WARNING] = "^3",
    [MessageType.ERROR] = "^1",
    [MessageType.DEBUG] = "^7",
    [MessageType.INFO] = "^4"
}

---getColor
---@param messageType number
---@return string
---@public
function MessageType:getColor(messageType)
    return (colorTable[messageType])
end