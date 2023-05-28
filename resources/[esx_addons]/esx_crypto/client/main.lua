local ActivateBlips = {}
local PlayerLoaded = true
local isInMarker, isInAtmMarker, isInMenu, isMarkerShowed = false, false, false, false
local _GetEntityCoords, _PlayerPedId

-- Functions

-- Listen for keypress while player inside the marker
local function Listen4Key()
    CreateThread(function()
        while (isInMarker or isInAtmMarker) and not isInMenu do
            if IsControlJustReleased(0, 38) then
                OpenUi(isInAtmMarker)
            end
            Wait(0)
        end
    end)
end

-- Create Blips
local function CreateBlips()
    local tmpActiveBlips = {}
    for i = 1, #Config.Cryptos do
        if type(Config.Cryptos[i].Blip) == 'table' and Config.Cryptos[i].Blip.Enabled then
            local blip = AddBlipForCoord(Config.Cryptos[i].Position.xy)
            SetBlipSprite(blip, Config.Cryptos[i].Blip.Sprite)
            SetBlipScale(blip, Config.Cryptos[i].Blip.Scale)
            SetBlipColour(blip, Config.Cryptos[i].Blip.Color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(Config.Cryptos[i].Blip.Label)
            EndTextCommandSetBlipName(blip)
            tmpActiveBlips[#tmpActiveBlips + 1] = blip
        end
    end

    ActivateBlips = tmpActiveBlips
end

-- Remove blips
local function RemoveBlips()
    for i = 1, #ActivateBlips do
        if DoesBlipExist(ActivateBlips[i]) then
            RemoveBlip(ActivateBlips[i])
        end
    end
    ActivateBlips = {}
end

function OpenUi(atm)
    atm = atm or false
    isInMenu = true
    ESX.HideUI()
    ESX.TriggerServerCallback('esx_crypto:getPlayerData', function(data)
        SendNUIMessage({
            showMenu = true,
            openATM = atm,
            datas = {
                your_money_panel = {
                    accountsData = {{
                        name = "cash",
                        amount = data.money
                    }, {
                        name = "crypto",
                        amount = data.crypto
                    }}
                },
                cryptoCardData = {
                    cryptoName = TranslateCap('crypto_name'),
                    cardNumber = "2232 2222 2222 2222",
                    createdDate = "08/08",
                    name = data.playerName
                },
                transactionsData = data.transactionHistory
            }
        })
    end)
    SetNuiFocus(true, true)
end

local function CloseUi()
    SetNuiFocus(false, false)
    isInMenu = false
    SendNUIMessage({
        showMenu = false
    })

    if (isInMarker or isInAtmMarker) then
        ESX.TextUI(TranslateCap('press_e_cryptoing'))
        Listen4Key()
    end
end

local function ShowMarker(coord)
    CreateThread(function()
        while isMarkerShowed do
            DrawMarker(20, coord.x, coord.y, coord.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.2, 187, 255, 0, 255, false, true, 2, false, nil, nil, false)
            Wait(0)
        end
    end)
end

local function StartThread()
    CreateThread(function()
        CreateBlips()

        while PlayerLoaded do
            _PlayerPedId = PlayerPedId()
            _GetEntityCoords = GetEntityCoords(_PlayerPedId)

            if IsPedOnFoot(PlayerPedId()) then
                local closestcrypto = {}

                for i = 1, #Config.AtmModels do
                    local atm = GetClosestObjectOfType(_GetEntityCoords, 8.0, Config.AtmModels[i], false)
                    if atm ~= 0 then
                        local atmOffset = GetOffsetFromEntityInWorldCoords(atm, 0.0, -0.7, 0.0)
                        local atmHeading = GetEntityHeading(atm)
                        local atmDistance = #(_GetEntityCoords - atmOffset)
                        if not isInAtmMarker and atmDistance <= 1.5 then
                            isInAtmMarker = true
                            ESX.TextUI(TranslateCap('press_e_cryptoing'))
                            Listen4Key()
                        elseif isInAtmMarker and atmDistance > 1.5 then
                            isInAtmMarker = false
                            ESX.HideUI()
                        end
                    end
                end

                for i = 1, #Config.Cryptos do
                    local cryptoDistance = #(_GetEntityCoords - Config.Cryptos[i].Position.xyz)

                    if cryptoDistance <= Config.DrawMarker then
                        closestcrypto = {Config.Cryptos[i].Position, cryptoDistance}
                    end
                end

                if not isMarkerShowed and next(closestcrypto) then
                    isMarkerShowed = true
                    ShowMarker(closestcrypto[1].xyz)
                elseif isMarkerShowed and not next(closestcrypto) then
                    isMarkerShowed = false
                end

                if next(closestcrypto) then
                    if not isInMarker and closestcrypto[2] <= 1.0 then
                        isInMarker = true
                        ESX.TextUI(TranslateCap('press_e_cryptoing'))
                        Listen4Key()
                    elseif isInMarker and closestcrypto[2] > 1.0 then
                        isInMarker = false
                        ESX.HideUI()
                    end
                end

            end
            Wait(1000)
        end
    end)
end

-- NuiCallbacks
RegisterNUICallback('close', function(data, cb)
    CloseUi()
    cb('ok')
end)

RegisterNUICallback('clickButton', function(data, cb)
    if data ~= nil and isInMenu then
        TriggerServerEvent("esx_crypto:doingType", data)
    end
    cb('ok')
end)

-- Events
RegisterNetEvent('esx_crypto:closecryptoing', function()
    CloseUi()
end)

RegisterNetEvent('esx_crypto:PedHandler', function(netIdTable)
    local npc
    for i = 1, #netIdTable do
        npc = NetworkGetEntityFromNetworkId(netIdTable[i])
        TaskStartScenarioInPlace(npc, Config.Peds[i].Scenario, 0, true)
        SetEntityProofs(npc, true, true, true, true, true, true, true, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        FreezeEntityPosition(npc, true)
        SetPedCanRagdollFromPlayerImpact(npc, false)
        SetPedCanRagdoll(npc, false)
        SetEntityAsMissionEntity(npc, true, true)
        SetEntityDynamic(npc, false)
    end
end)

RegisterNetEvent('esx_crypto:updateMoneyInUI')
AddEventHandler('esx_crypto:updateMoneyInUI', function(doingType, crypto, money)
    SendNUIMessage({
        updateData = true,
        data = {
            type = doingType,
            crypto = crypto,
            money = money
        }
    })
end)

-- Resource starting
AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    StartThread()
end)

-- Enables it on player loaded 
RegisterNetEvent('esx:playerLoaded', function()
    StartThread()
end)

-- Resource stopping
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    RemoveBlips()
    if isInMenu then
        CloseUi()
    end
end)