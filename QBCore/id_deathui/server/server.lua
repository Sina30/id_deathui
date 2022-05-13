local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('id_deathui:server:SetDeathStatus', function(isDead)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player then
		Player.Functions.SetMetaData("isdead", isDead)
	end
end)