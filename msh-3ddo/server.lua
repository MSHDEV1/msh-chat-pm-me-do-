local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('msh-3ddo:shareDisplay')
AddEventHandler('msh-3ddo:shareDisplay', function(text, name)
    TriggerClientEvent('msh-3ddo:shareDisplay', -1, text, source, name)
end)

QBCore.Functions.CreateCallback('3ddo:sex', function(playerId, data) -- super
    local Player = QBCore.Functions.GetPlayer(playerId)
    
    data({
        first = Player.PlayerData.charinfo.firstname,
        last = Player.PlayerData.charinfo.lastname
    })
end)