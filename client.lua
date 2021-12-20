local allowed = false
local steamID
local discordID

RegisterNetEvent("allowCurrentVehicle")
AddEventHandler("allowCurrentVehicle", function ()
    allowed = true
end)

RegisterNetEvent("relayIdentifiers")
AddEventHandler("relayIdentifiers", function (steamid, discord)
    steamID = string.sub(steamid, 7, i)
    discordID = string.sub(discord, 9, i)   
end)

TriggerServerEvent("getIdentifiers")

Citizen.CreateThread(function()
	while true do
		local veh = nil
		local ped = GetPlayerPed(-1)
        
		if IsPedInAnyVehicle(ped, false) then
			veh = GetVehiclePedIsUsing(ped)
			CarHash = GetEntityModel(veh)
		end
		
		if DoesEntityExist(veh) then
            if GetPedInVehicleSeat(veh, -1) == ped then
                for i=1, #Config.cars, 1 do
                    local checkingCar = GetHashKey(Config.cars[i].spawnCode)

                    if CarHash == checkingCar then
                        TriggerServerEvent("checkAllowed", i, steamID, discordID)
                        Citizen.Wait(1000)
                        if not allowed then
                            ClearPedTasksImmediately(ped)
                            SetEntityAsMissionEntity(veh, true, true)
                            if Config.cars[i].deleteOrKick == "delete" then
                                DeleteVehicle(veh)
                            end
                        end
                        allowed = false
                    end
                end
            end
		end
    Citizen.Wait(100)
	end
end)
