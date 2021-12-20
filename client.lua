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
		
            if GetPedInVehicleSeat(veh, -1) == ped then
                for i=1, #Config.cars, 1 do
                    local checkingCar = GetHashKey(Config.cars[i].spawnCode)

                    if CarHash == checkingCar then
                        TriggerServerEvent("checkAllowed", i, steamID, discordID)
                        Citizen.Wait(1000)
                        if not allowed then
                            if Config.cars[i].whatToDo == "delete" then
                                DeleteVehicle(veh)
                            elseif Config.cars[i].whatToDo == "killengine" then
                                SetVehicleEngineOn(veh, false, true, true)
                            else
                                ClearPedTasksImmediately(ped)
                                SetEntityAsMissionEntity(veh, true, true)   
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
