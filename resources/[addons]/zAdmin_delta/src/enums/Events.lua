--- @class Events
local Events = {
    STAFF_MODE_ENABLED = "delta.staff.enabled",
    STAFF_MODE_DISABLED = "delta.staff.disabled",
    PLAYER_LIST_UPDATED = "delta.playerlist.updated",

    REPORT_RECEIVED = "delta.report.received",
    REPORT_TAKE = "delta.report.take",
    REPORT_CLOSE = "delta.report.close",
    REPORT_GOTO = "delta.report.goto",
    REPORT_BRING = "delta.report.bring",

    CACHE_REPORTS_SET = "delta.cache.reports.set",
    CACHE_REPORTS_ADD = "delta.cache.reports.add",
    CACHE_REPORTS_CLEAN = "delta.cache.reports.clean",
    CACHE_REPORTS_REMOVE = "delta.cache.reports.remove",
    CACHE_REPORTS_UPDATE = "delta.cache.reports.update",

    PLAY_SOUND = "delta.playSound",
    TELEPORT = "delta.teleport",
}

_G.Events = Events