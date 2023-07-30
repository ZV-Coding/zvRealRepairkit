ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
	ESX = obj 
end)

ESX.RegisterUsableItem('repairkit', function(playerId)
	TriggerClientEvent('zvRealRepairkit:useRepKit', playerId)
end)

RegisterNetEvent('zvRealRepairkit:removeItem')
AddEventHandler('zvRealRepairkit:removeItem', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('repairkit', 1)
end)