---@class BasePermission
local BasePermission = {
    OPEN_MENU = "menu.open", -- Open the menu

    -- Categories access
    CAT_SELF = "self",
    CAT_PLAYERS = "players",
    CAT_VEHICLES = "vehicles",
    CAT_REPORTS = "reports",
    CAT_GROUPS = "groups",
    CAT_SERVER = "server",

    -- Reports
    REPORTS_TAKE = "reports.take",
    REPORTS_CLOSE = "reports.close",
    REPORTS_GOTO = "reports.goto",
    REPORTS_BRING = "reports.bring",

    -- The Ultimate permission
    SUPER = "*",
}

_G.BasePermission = BasePermission