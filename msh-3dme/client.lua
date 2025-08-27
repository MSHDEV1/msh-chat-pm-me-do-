local QBCore = exports['qb-core']:GetCoreObject()

local pedDisplaying = {}
local sayi = 0.3
function DrawText3D(coords, text)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)
    
    -- Experimental math to scale the text down
    local scale = 250 / (GetGameplayCamFov() * dist)

    -- Format the text rgba()
    SetTextColour(74, 128, 77, 0.8)
    SetTextScale(0.0, 0.5 * scale)
    SetTextFont(0)
    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextDropShadow()
    SetTextCentre(true)

    -- Diplay the text
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()

end

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict( dict )
        Wait(5)
    end
end

RegisterCommand('me', function(source, args, raw)
     sayi = 0.1+ sayi
    local text = string.sub(raw, 4)
    
    QBCore.Functions.TriggerCallback('3dme:sex', function(firstname, lastname)
        local name = firstname ..' '..  lastname

        local mask = GetPedDrawableVariation(PlayerPedId(), 1)
        if mask > 0 then
            name = "Maskeli"
        end
        
        local name = firstname ..' '..  lastname..':'
       
          TriggerServerEvent('3dme:shareDisplay', text, name)
    end)
end)
function Display(ped, text, name)

    local playerPed = PlayerPedId()
    local serverid = GetPlayerServerId(playerPed)
    local playerCoords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(ped)
    local dist = #(playerCoords - pedCoords)

    if dist <= 250 then
        if dist <= 10 then
              
            TriggerEvent('chat:addMessage', {
                type = "Me",
                color = {74 ,128 ,77, 0.8},
                template = '<div class="chat-message twitch"><b><span style="color: #9c70de">{0}</span>&nbsp;<span style="font-size: 15px; color: #caffb6ff; ">{1}</span></b><div style="margin-top: 5px; font-weight: 300;"></div></div>',
                multiline = true,
                args = {name, text}
            })
        end

        pedDisplaying[ped] = (pedDisplaying[ped] or 1) + 1

        -- Timer
        local display = true

        CreateThread(function()
         
            Wait(7000)
            display = false
        end)

        -- Display
        
        local offset = sayi
        while display do
            if HasEntityClearLosToEntity(playerPed, ped, 17) then
                local x, y, z = table.unpack(GetEntityCoords(ped))
                z = z + offset
                DrawText3D(vector3(x, y, z), ''..text..'')

            end
            Wait(0)
        end
       sayi = 0.3
        pedDisplaying[ped] = pedDisplaying[ped] - 1

    end
end

RegisterNetEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(text, serverId, name)
    local player = GetPlayerFromServerId(serverId)
    if player ~= -1 then
        local ped = GetPlayerPed(player)
        Display(ped, text, name)
    end
end)