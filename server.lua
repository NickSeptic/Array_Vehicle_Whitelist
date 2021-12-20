local steamid  = false
local discord  = false

RegisterServerEvent("getIdentifiers")
AddEventHandler("getIdentifiers", function()
    for k,v in pairs(GetPlayerIdentifiers(source))do   
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
        end
    end
    TriggerClientEvent("relayIdentifiers", source, steamid, discord)
end)

RegisterServerEvent("checkAllowed")
AddEventHandler("checkAllowed", function(i, steamID, discordID)
    src = source
    for e=1, #Config.cars[i].steamID, 1 do
        if Config.cars[i].steamID[e] == steamID then
            TriggerClientEvent("allowCurrentVehicle", source)
        end
    end
    for e=1, #Config.cars[i].DiscordID, 1 do
        if Config.cars[i].DiscordID[e] == discordID then
            TriggerClientEvent("allowCurrentVehicle", source)
        end
    end
    for e=1, #Config.cars[i].acePerm, 1 do
        if Config.cars[i].acePerm[e] ~= "" then
            if IsPlayerAceAllowed(source, Config.cars[i].acePerm[e]) then
                TriggerClientEvent("allowCurrentVehicle", source)
            end
        end
    end
    for e=1, #Config.cars[i].DiscordRole, 1 do
        local roleToCheckAgainst = Config.cars[i].DiscordRole[e]
        if discordID then
            local roleIDs = exports.Badger_Discord_API:GetDiscordRoles(src)
            if roleIDs then
                if Config.cars[i].DiscordRole[e] ~= "" then
                    for j=1, #roleIDs, 1 do
                        if exports.Badger_Discord_API:CheckEqual(Config.cars[i].DiscordRole[e], roleIDs[j]) then
                            TriggerClientEvent("allowCurrentVehicle", src)
                        end
                    end
                end
            end
        end
    end
end)