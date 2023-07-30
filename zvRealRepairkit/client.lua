ESX	= nil
local CurrentAction	= nil

TriggerEvent('esx:getSharedObject', function(obj) 
	ESX = obj 
end)

RegisterNetEvent('zvRealRepairkit:useRepKit')
AddEventHandler('zvRealRepairkit:useRepKit', function()
	local playerPed = GetPlayerPed(-1)
	local coords = GetEntityCoords(playerPed)

	if not IsPedInAnyVehicle(playerPed, false) then
		if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
			local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)

			if DoesEntityExist(vehicle) then
				local vehicleModel = GetEntityModel(vehicle)
                local vehicleName = GetDisplayNameFromVehicleModel(vehicleModel)

				TriggerServerEvent('zvRealRepairkit:removeItem')
				if Config.Notify == "esx" then
					ESX.ShowNotification(Config.PlsWait)
				elseif Config.Notify == "okok" then
					exports['okokNotify']:Alert(Config.NotifyTitle, Config.PlsWait, Config.NotifyTimeout * 1000, "info")
				elseif Config.Notify == "pnotify" then
					TriggerEvent("pNotify:SendNotification", {
						text = Config.PlsWait,
						layout = "topright",
						timeout = Config.NotifyTimeout * 1000,
						type = "success"
					})
				end
				TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)

				Citizen.CreateThread(function()
					ThreadID = GetIdOfThisThread()
					CurrentAction = 'repair'

					SetVehicleDoorOpen(vehicle, 4, false, true)
					Citizen.Wait(Config.RepairTime * 1000)

					if CurrentAction ~= nil then
						SetVehicleEngineHealth(vehicle, 1000.0)
						ClearPedTasksImmediately(playerPed)
						SetVehicleDoorShut(vehicle, 4, false)

						if Config.Notify == "esx" then
							ESX.ShowNotification(Config.Successfull)
						elseif Config.Notify == "okok" then
							exports['okokNotify']:Alert(Config.NotifyTitle, Config.Successfull, Config.NotifyTimeout * 1000, "info")
						elseif Config.Notify == "pnotify" then
							TriggerEvent("pNotify:SendNotification", {
								text = Config.Successfull,
								layout = "topright",
								timeout = Config.NotifyTimeout * 1000,
								type = "success"
							})
						end
					end

					CurrentAction = nil
					TerminateThisThread()
				end)
			end
		end
	else
		if Config.Notify == "esx" then
			ESX.ShowNotification(Config.OnlyOutside)
		elseif Config.Notify == "okok" then
			exports['okokNotify']:Alert(Config.NotifyTitle, Config.OnlyOutside, Config.NotifyTimeout * 1000, "info")
		elseif Config.Notify == "pnotify" then
			TriggerEvent("pNotify:SendNotification", {
				text = Config.OnlyOutside,
				layout = "topright",
				timeout = Config.NotifyTimeout * 1000,
				type = "success"
			})
		end
	end
end)
