-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
local timeouts = {}

function SetTimeout(msec, cb)
    timeouts[#timeouts + 1] = {
        time = GetGameTimer() + msec,
        cb = cb
    }
    return #timeouts
end

function ClearTimeout(i)
    timeouts[i] = nil
end

function GetIdentifier(target)
    return lib.callback.await('wasabi_carlock:getIdentifier', 100)
end

Trim = function(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end