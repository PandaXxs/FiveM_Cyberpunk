local HackingSwitcher = nil
local HackingTiming = 300

function mhackingSeqCallback(success, remainingtime)
	HackingSwitcher = success
	HackingTiming = math.floor(remainingtime/1000.0 + 0.5)
end

AddEventHandler('projectrpUtils.Hacking:seqstart', function(solutionlength, duration, callback)
	if type(solutionlength) ~= 'table' and type(duration) ~= 'table' then
		TriggerEvent('projectrpUtils.Hacking:show')
		TriggerEvent('projectrpUtils.Hacking:start', solutionlength, duration, mhackingSeqCallback)
		while HackingSwitcher == nil do
			Citizen.Wait(5)
		end
		TriggerEvent('projectrpUtils.Hacking:hide')
		callback(HackingSwitcher, HackingTiming, true)
		HackingTiming = 0
		HackingSwitcher = nil
	elseif type(solutionlength) == 'table' and type(duration) ~= 'table' then
		TriggerEvent('projectrpUtils.Hacking:show')
		HackingTiming = duration
		for _, sollen in pairs(solutionlength) do
			TriggerEvent('projectrpUtils.Hacking:start', sollen, HackingTiming, mhackingSeqCallback)	
			while HackingSwitcher == nil do
				Citizen.Wait(5)
			end
			
			if next(solutionlength,_) == nil or HackingTiming == 0 then
				callback(HackingSwitcher, HackingTiming, true)
			else
				callback(HackingSwitcher, HackingTiming, false)
			end
			HackingSwitcher = nil
		end
		HackingTiming = 0
		TriggerEvent('projectrpUtils.Hacking:hide')
	elseif type(solutionlength) ~= 'table' and type(duration) == 'table' then
		TriggerEvent('projectrpUtils.Hacking:show')
		for _, dur in pairs(duration) do
			TriggerEvent('projectrpUtils.Hacking:start', solutionlength, dur, mhackingSeqCallback)	
			while HackingSwitcher == nil do
				Citizen.Wait(5)
			end
			if next(duration,_) == nil then
				callback(HackingSwitcher, HackingTiming, true)
			else
				callback(HackingSwitcher, HackingTiming, false)
			end
			HackingSwitcher = nil
		end
		HackingTiming = 0
		TriggerEvent('projectrpUtils.Hacking:hide')
	elseif type(solutionlength) == 'table' and type(duration) == 'table' then
		local itrTbl = {}
		local solTblLen = 0
		local durTblLen = 0
		for _ in ipairs(solutionlength) do solTblLen = solTblLen + 1 end
		for _ in ipairs(duration) do durTblLen = durTblLen + 1 end
		itrTbl = duration
		if solTblLen > durTblLen then itrTbl = solutionlength end	
		TriggerEvent('projectrpUtils.Hacking:show')
		for idx in ipairs(itrTbl) do
			TriggerEvent('projectrpUtils.Hacking:start', solutionlength[idx], duration[idx], mhackingSeqCallback)	
			while HackingSwitcher == nil do
				Citizen.Wait(5)
			end
			if next(itrTbl,idx) == nil then
				callback(HackingSwitcher, HackingTiming, true)
			else
				callback(HackingSwitcher, HackingTiming, false)
			end
			HackingSwitcher = nil
		end
		HackingTiming = 0
		TriggerEvent('projectrpUtils.Hacking:hide')
	end
end)