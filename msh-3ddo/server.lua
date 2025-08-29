local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('msh-3ddo:shareDisplay')
AddEventHandler('msh-3ddo:shareDisplay', function(text, name)
    TriggerClientEvent('msh-3ddo:shareDisplay', -1, text, source, name)
end)
