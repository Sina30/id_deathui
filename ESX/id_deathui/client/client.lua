ESX = nil
local IsDead = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function SetDisplay(bool)
    SendNUIMessage({
        type = "show",
        status = bool,
        time = GlobalState.Timer,
    })

    SendNUIMessage({action = 'starttimer', value = GlobalState.Timer})

    SendNUIMessage({action = 'showbutton'})

	SetNuiFocus(bool, bool)
end

AddEventHandler('esx:onPlayerDeath', function(data)
    SetDisplay(true, true)
    IsDead = true

    -- Respawn Player after timer is done
    Citizen.Wait(GlobalState.Timer * 60 * 1000)
    respawn()
end)

AddEventHandler('playerSpawned', function(spawn)
    SetDisplay(false, false)
    IsDead = false
end)

RegisterNUICallback("button", function(data)
    SendNUIMessage({action = 'hidebutton'})

    -- You should place TriggerEvent here for sending message to all ambulance employees :)
 
    SetNuiFocus(false, false)
end)

function respawn()
    SetDisplay(false, false)
	SetEntityCoordsNoOffset(PlayerPedId(), GlobalState.RespawnCoords, false, false, false, true)
    NetworkResurrectLocalPlayer(GlobalState.RespawnCoords, GlobalState.RespawnHeading, true, false)
	SetPlayerInvincible(PlayerPedId(), false)
	ClearPedBloodDamage(PlayerPedId())
end