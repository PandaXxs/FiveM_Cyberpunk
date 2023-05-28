function GetAllPlayers()
	local players = {}

	for _,player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)

		if DoesEntityExist(ped) then
			table.insert(players, player)
		end
	end

	return players
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
	AddTextEntry("FMMC_KEY_TIP1", TextEntry)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end


function GetNearbyPlayers(distance)
	local ped = GetPlayerPed(-1)
	local playerPos = GetEntityCoords(ped)
	local nearbyPlayers = {}

	for _,v in pairs(GetAllPlayers()) do
		local otherPed = GetPlayerPed(v)
		local otherPedPos = otherPed ~= ped and IsEntityVisible(otherPed) and GetEntityCoords(otherPed)

		if otherPedPos and GetDistanceBetweenCoords(otherPedPos, playerPos) <= (distance or max) then
			nearbyPlayers[#nearbyPlayers + 1] = v
		end
	end
	return nearbyPlayers
end

function GetNearbyPlayer(distance)
    local Timer = GetGameTimer() + 10000
    local oPlayer = GetNearbyPlayers(distance)

    if #oPlayer == 0 then
        ESX.ShowNotification("~r~Il n'y a aucune personne aux alentours de vous.")
        return false
    end

    if #oPlayer == 1 then
        return oPlayer[1]
    end

    ESX.ShowNotification("Appuyer sur ~g~E~s~ pour valider~n~Appuyer sur ~b~A~s~ pour changer de cible~n~Appuyer sur ~r~X~s~ pour annuler")
    Citizen.Wait(100)
    local aBase = 1
    while GetGameTimer() <= Timer do
        Citizen.Wait(0)
        DisableControlAction(0, 38, true)
        DisableControlAction(0, 73, true)
        DisableControlAction(0, 44, true)
        if IsDisabledControlJustPressed(0, 38) then
            return oPlayer[aBase]
        elseif IsDisabledControlJustPressed(0, 73) then
            ESX.ShowNotification("Vous avez ~r~annulé~s~ cette ~r~action~s~")
            break
        elseif IsDisabledControlJustPressed(0, 44) then
            aBase = (aBase == #oPlayer) and 1 or (aBase + 1)
        end
        local cPed = GetPlayerPed(oPlayer[aBase])
        local cCoords = GetEntityCoords(cPed)
        DrawMarker(0, cCoords.x, cCoords.y, cCoords.z + 1.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.1, 0.1, 0.1, 0, 180, 10, 30, 1, 1, 0, 0, 0, 0, 0)
    end
    return false
end

function DisplayNotification(text, init)
	SetTextComponentFormat("jamyfafi")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, init, -1)
end


--- ProgressBar ---

function LookProgressBar()
    return ActiveProgressBar
end

function DrawTextProgress(Text, Text3, Taille, Text2, Font, Justi, havetext)
    SetTextFont(Font)
    SetTextScale(Taille, Taille)
    SetTextColour(255, 255, 255, 255)
    SetTextJustification(Justi or 1)
    SetTextEntry("STRING")
    if havetext then SetTextWrap(Text, Text + .1) end
    AddTextComponentString(Text2)
    DrawText(Text, Text3)
end

local LoadPoint = {".", "..", "...", ""}

function AddProgressBar(Text, r, g, b, a, Timing)
    if Timing then
        DeleteProgressBar()
        ActiveProgressBar = true
        Citizen.CreateThread(function()
            local Timing1, Timing2 = 0.0, GetGameTimer() + Timing
            local Point, AddLoadPoint = ""
            while ActiveProgressBar and (Timing1 < 1) do
                Citizen.Wait(0)
                if Timing1 < 1 then
                    Timing1 = 1 - ((Timing2 - GetGameTimer()) / Timing)
                end
                if not AddLoadPoint or GetGameTimer() >= AddLoadPoint then
                    AddLoadPoint = GetGameTimer() + 500
                    Point = LoadPoint[string.len(Point) + 1] or ""
                end
                DrawRect(0.5, 0.940, 0.15, 0.03, 0, 0, 0, 100)
                local y, endroit = 0.15 - 0.0025, 0.03 - 0.005
                local chance = math.max(0, math.min(y, y * Timing1))
                DrawRect((0.5 - y / 2) + chance / 2, 0.940, chance, endroit, r, g, b, a) -- 0,155,255,125
                DrawTextProgress(0.5, 0.940 - 0.0125, 0.3, (Text or "Action en cours") .. Point, 0, 0, false)
            end
            DeleteProgressBar()
        end)
    end
end

--- Timer Bar ---

function DeleteProgressBar() 
    ActiveProgressBar = nil
end

local BarsActivate = {}

function AddTimerBar(title, data)
	if data then
        RequestStreamedTextureDict("timerbars", true)

        local BarInfo = #BarsActivate + 1
        BarsActivate[BarInfo] = {
            title = title,
            text = data.text,
            textColor = data.color or { 255, 255, 255, 255 },
            percentage = data.percentage,
            endTime = data.endTime,
            pbarBgColor = data.bg or { 155, 155, 155, 255 },
            pbarFgColor = data.fg or { 255, 255, 255, 255 }
        }
        return BarInfo
    end
end

function RemoveTimerBar()
	BarsActivate = {}
	SetStreamedTextureDictAsNoLongerNeeded("timerbars")
end

function UpdateTimerBar(BarInfo, data)
    if BarsActivate[BarInfo] or data then
        for k,v in pairs(data) do
            BarsActivate[BarInfo][k] = v
        end
    end
end

local textColor = { 200, 100, 100 }

function MinuteurAuto(second)
	second = tonumber(second)

	if second <= 0 then
		return "00:00"
	else
		min = string.format("%02.f", math.floor(second / 60))
		sec = string.format("%02.f", math.floor(second - min * 60))
		return string.format("%s:%s", min, sec)
	end
end

function ButtonMessageFishing(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function HelpNotif(msg)
    AddTextEntry('CoreHelpNotif', msg)
	BeginTextCommandDisplayHelp('CoreHelpNotif')
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function AdvancedNotif(title, subject, msg, icon, iconType)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName(msg)
	SetNotificationMessage(icon, icon, false, iconType, title, subject)
	DrawNotification(false, false)
end

function floatTxt(message, coords)
	AddTextEntry('vehicleNotification', message)
	SetFloatingHelpTextWorldPosition(1, coords)
	SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
	BeginTextCommandDisplayHelp('vehicleNotification')
	EndTextCommandDisplayHelp(2, false, false, -1)
end

CreateBlip = function(coords, sprite, colour, text, scale)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, scale)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandSetBlipName(blip)
    return blip
end