local QBCore = exports['qb-core']:GetCoreObject()

local mshlog = "" -- Discord log için webhook url buraya.


RegisterCommand("pm", function(source, args, rawCommand)
    local src = source                  
    local targetId = tonumber(args[1])   
    local msg = table.concat(args, " ", 2) 
    if not targetId or not msg or msg == "" then
        TriggerClientEvent('QBCore:Notify', src, "Kullanım : /pm (id) (mesaj)", "error")
        return
    end
  
    local targetPlayer = QBCore.Functions.GetPlayer(targetId)
   local player = QBCore.Functions.GetPlayer(src)
  
    if targetPlayer then
        local senderName =player.PlayerData.charinfo.firstname.. ' '.. player.PlayerData.charinfo.lastname
        
        local receiverName = targetPlayer.PlayerData.charinfo.firstname ..' '..targetPlayer.PlayerData.charinfo.lastname

        TriggerClientEvent('chat:addMessage', src, {
            color = { 255, 204, 0, 0 },
           template = '<div class="chat-message staff"><b><span style="color: #1ebc62">{0}</span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;">{1}</span></b><div style="margin-top: 5px; font-weight: 300;"></div></div>',
            multiline = true,
            args = { "[Mesaj Gönderdiniz]", receiverName.." ".."("..targetId..")".. ": " .. msg }
        })

        TriggerClientEvent('chat:addMessage', targetId, {
            color = {255, 204, 0, 0 },
            template = '<div class="chat-message staff"><b><span style="color: #1ebc62" >{0}</span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;">{1}</span></b><div style="margin-top: 5px; font-weight: 300;"></div></div>',
            multiline = true,
            args = { "[Mesaj]", senderName.." ".."(".. src.. ")"  .. ": " .. msg }
        })  

        TriggerClientEvent('QBCore:Notify', src, "Mesaj gönderildi!", "success")
        TriggerClientEvent('QBCore:Notify', targetId, "Yeni bir özel mesajın var!", "primary")

        -- print("[PM] " .. senderName .. " (" .. src .. ") → " .. receiverName .. " (" .. targetId .. "): " .. msg) -- Console test print

        sendToDiscord("MSHDEV!!", 
            "**Gönderici :** " .. senderName .. " (" .. src .. ")\n" ..
            "**Teslim Alan :** " .. receiverName .. " (" .. targetId .. ")\n" ..
            "**Mesaj İçeriği :** " .. msg, 8388736) 
    else
        TriggerClientEvent('QBCore:Notify', src, "Oyuncu bulunamadı!", "error")
    end
end, false)

function sendToDiscord(title, message, color)
    local embedData = {
        {
            ["title"] = title,
            ["description"] = message,
            ["color"] = color, 
            ["footer"] = {
                ["text"] = os.date("%Y-%m-%d %H:%M:%S"),
            }
        }
    }
    
    PerformHttpRequest(mshlog, function(err, text, headers) end, 'POST', json.encode({username = "MSHDEV!!", embeds = embedData}), { ['Content-Type'] = 'application/json' })
end
