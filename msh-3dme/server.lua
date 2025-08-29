local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('msh-3dme:shareDisplay')
AddEventHandler('msh-3dme:shareDisplay', function(text, name)
    TriggerClientEvent('msh3dme:shareDisplay', -1, text, source, name)
end)

