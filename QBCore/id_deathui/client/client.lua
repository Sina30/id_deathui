local QBCore = exports['qb-core']:GetCoreObject()
local IsDead = false
local deadAnimDict = "dead"
local deadAnim = "dead_a"

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

function OnDeath()
    if not isDead then
        SetDisplay(true, true)
        isDead = true
    
        -- Respawn Player after timer is done
        Citizen.Wait(GlobalState.Timer * 60 * 1000)
        TriggerEvent("hospital:client:Revive")

        TriggerServerEvent("id_deathui:server:SetDeathStatus", true)
        local player = PlayerPedId()

        while GetEntitySpeed(player) > 0.5 or IsPedRagdoll(player) do
            Wait(10)
        end

        if isDead then
            local pos = GetEntityCoords(player)
            local heading = GetEntityHeading(player)

            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped) then
                local veh = GetVehiclePedIsIn(ped)
                local vehseats = GetVehicleModelNumberOfSeats(GetHashKey(GetEntityModel(veh)))
                for i = -1, vehseats do
                    local occupant = GetPedInVehicleSeat(veh, i)
                    if occupant == ped then
                        NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z + 0.5, heading, true, false)
                        SetPedIntoVehicle(ped, veh, i)
                    end
                end
            else
                NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z + 0.5, heading, true, false)
            end
			
            SetEntityInvincible(player, true)
            SetEntityHealth(player, GetEntityMaxHealth(player))
            if IsPedInAnyVehicle(player, false) then
                loadAnimDict("veh@low@front_ps@idle_duck")
                TaskPlayAnim(player, "veh@low@front_ps@idle_duck", "sit", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
            else
                loadAnimDict(deadAnimDict)
                TaskPlayAnim(player, deadAnimDict, deadAnim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
            end
        end
    end
end