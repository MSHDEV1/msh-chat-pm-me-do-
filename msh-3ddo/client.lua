local QBCore = exports['qb-core']:GetCoreObject()

local pedDisplaying = {}

function DrawText3D(coords, text)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)
    
    -- Experimental math to scale the text down
    local scale = 250 / (GetGameplayCamFov() * dist)

    -- Format the text rgba()
    SetTextColour(255, 0, 191, 0.8)
    SetTextScale(0.0, 0.5 * scale)
    SetTextFont(0)
    SetTextDropshadow(255, 0, 191, 105)
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

RegisterCommand('zar', function(source, args)
    local maxSayi = 1
    local randomSayi = 1

    if args[1] ~= nil then
        maxSayi = tonumber(args[1])

        if maxSayi > 90000000 then
            maxSayi = 10000000
        end
        
        randomSayi = math.random(1, maxSayi)
    else
        maxSayi = 6
        randomSayi = math.random(1, maxSayi)
    end

    local text = "Zar "..randomSayi.."/"..maxSayi

    loadAnimDict("anim@mp_player_intcelebrationmale@wank")
    TaskPlayAnim(PlayerPedId(), "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    Wait(1500)
    ClearPedTasks(PlayerPedId())

    QBCore.Functions.TriggerCallback('3ddo:sex', function(name)
        local name =  name.first ..' '..  name.last ..':'
        TriggerServerEvent('msh-3ddo:shareDisplay', text, name)
    end)
end)

RegisterCommand('do', function(source, args, raw)
    local text = string.sub(raw, 4)
    
    QBCore.Functions.TriggerCallback('3ddo:sex', function(name)
        local name = name.first ..' '..  name.last ..':'
       
        TriggerServerEvent('msh-3ddo:shareDisplay', text, name)
    end)
end)
RegisterCommand("meslek",function (source)
	local players = QBCore.Functions.GetPlayerData()
    local isim = players.charinfo.firstname .. " " .. players.charinfo.lastname .. ":"
	local meslek = players.job.label .." ".. "-->".. " ".. players.job.grade.name
 TriggerEvent('chat:addMessage',{
                color = {255, 255, 255, 0.8},
                type =  "system",
                template = '<div class="chat-message staff" style="background-color: #2d3b69ff "> <b><span style="color: #1ebc62;">{0}</span>&nbsp;<span style="font-size: 16px; color: #e1e1e1;">{1}</span></b><div style="margin-top: 5px; font-weight: 200;"></div></div>',
                multiline = true,
                args = {isim,meslek}
            })

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
                color = {255, 0, 191, 0.8},
                 type = "Do",
                 template = '<div class="chat-message advertisement"><b><span style="color: #81db44">{0}</span>&nbsp;<span style="font-size: 15px; color: #cdaff6ff;">{1}</span></b><div style="margin-top: 5px; font-weight: 300;"></div></div>',
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
        local offset = pedDisplaying[ped] * 0.1
        while display do
            if HasEntityClearLosToEntity(playerPed, ped, 17) then
                local x, y, z = table.unpack(GetEntityCoords(ped))
                z = z + offset
                DrawText3D(vector3(x, y, z), ' '..text..' ')

            end
            Wait(0)
        end

        pedDisplaying[ped] = pedDisplaying[ped] - 1

    end
end

RegisterNetEvent('msh-3ddo:shareDisplay')
AddEventHandler('msh-3ddo:shareDisplay', function(text, serverId, name)
    local player = GetPlayerFromServerId(serverId)
    if player ~= -1 then
        local ped = GetPlayerPed(player)
        print(name)
        Display(ped, text, name)
    end
end)