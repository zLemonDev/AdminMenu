local menuOpen = false
local playerGroup = nil
local permissions = {}

-- Register Key Mapping
RegisterCommand('adminmenu', function()
    if playerGroup and permissions then
        ToggleMenu()
    else
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"Admin Menu", "You don't have permission to use this command."}
        })
    end
end, false)

RegisterKeyMapping('adminmenu', 'Open Admin Menu', 'keyboard', Config.MenuKey)

-- Initialize
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        TriggerServerEvent('adminmenu:checkPermissions')
    end
end)

-- Toggle Menu
function ToggleMenu()
    menuOpen = not menuOpen
    SetNuiFocus(menuOpen, menuOpen)
    SendNUIMessage({
        action = 'toggle',
        show = menuOpen,
        permissions = permissions
    })
end

-- NUI Callbacks
RegisterNUICallback('close', function(data, cb)
    ToggleMenu()
    cb('ok')
end)

RegisterNUICallback('getOnlinePlayers', function(data, cb)
    TriggerServerEvent('adminmenu:getOnlinePlayers')
    cb('ok')
end)

RegisterNUICallback('kickPlayer', function(data, cb)
    TriggerServerEvent('adminmenu:kickPlayer', data.playerId, data.reason)
    cb('ok')
end)

RegisterNUICallback('banPlayer', function(data, cb)
    TriggerServerEvent('adminmenu:banPlayer', data.playerId, data.reason, data.duration)
    cb('ok')
end)

RegisterNUICallback('gotoPlayer', function(data, cb)
    TriggerServerEvent('adminmenu:gotoPlayer', data.playerId)
    cb('ok')
end)

RegisterNUICallback('bringPlayer', function(data, cb)
    TriggerServerEvent('adminmenu:bringPlayer', data.playerId)
    cb('ok')
end)

RegisterNUICallback('spectatePlayer', function(data, cb)
    TriggerServerEvent('adminmenu:spectatePlayer', data.playerId)
    cb('ok')
end)

RegisterNUICallback('freezePlayer', function(data, cb)
    TriggerServerEvent('adminmenu:freezePlayer', data.playerId, data.freeze)
    cb('ok')
end)

RegisterNUICallback('spawnVehicle', function(data, cb)
    TriggerServerEvent('adminmenu:spawnVehicle', data.model)
    cb('ok')
end)

RegisterNUICallback('deleteVehicle', function(data, cb)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle ~= 0 then
        DeleteVehicle(vehicle)
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            multiline = true,
            args = {"Admin Menu", "Vehicle deleted successfully."}
        })
    end
    cb('ok')
end)

RegisterNUICallback('repairVehicle', function(data, cb)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle ~= 0 then
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        SetVehicleEngineOn(vehicle, true, true)
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            multiline = true,
            args = {"Admin Menu", "Vehicle repaired successfully."}
        })
    end
    cb('ok')
end)

RegisterNUICallback('teleportToCoords', function(data, cb)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, data.x, data.y, data.z, false, false, false, true)
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        multiline = true,
        args = {"Admin Menu", "Teleported to coordinates."}
    })
    cb('ok')
end)

RegisterNUICallback('teleportToLocation', function(data, cb)
    local location = Config.TeleportLocations[data.location]
    if location then
        local playerPed = PlayerPedId()
        SetEntityCoords(playerPed, location.x, location.y, location.z, false, false, false, true)
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            multiline = true,
            args = {"Admin Menu", "Teleported to " .. data.location .. "."}
        })
    end
    cb('ok')
end)

RegisterNUICallback('setWeather', function(data, cb)
    TriggerServerEvent('adminmenu:setWeather', data.weather)
    cb('ok')
end)

RegisterNUICallback('setTime', function(data, cb)
    TriggerServerEvent('adminmenu:setTime', data.hour, data.minute)
    cb('ok')
end)

RegisterNUICallback('toggleNoclip', function(data, cb)
    ToggleNoclip()
    cb('ok')
end)

RegisterNUICallback('toggleGodmode', function(data, cb)
    ToggleGodmode()
    cb('ok')
end)

RegisterNUICallback('toggleInvisible', function(data, cb)
    ToggleInvisible()
    cb('ok')
end)

RegisterNUICallback('healPlayer', function(data, cb)
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, 200)
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        multiline = true,
        args = {"Admin Menu", "Player healed."}
    })
    cb('ok')
end)

RegisterNUICallback('giveWeapon', function(data, cb)
    local playerPed = PlayerPedId()
    GiveWeaponToPed(playerPed, GetHashKey(data.weapon), 250, false, true)
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        multiline = true,
        args = {"Admin Menu", "Weapon given: " .. data.weapon}
    })
    cb('ok')
end)

RegisterNUICallback('removeAllWeapons', function(data, cb)
    local playerPed = PlayerPedId()
    RemoveAllPedWeapons(playerPed, true)
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        multiline = true,
        args = {"Admin Menu", "All weapons removed."}
    })
    cb('ok')
end)

RegisterNUICallback('announceMessage', function(data, cb)
    TriggerServerEvent('adminmenu:announceMessage', data.message)
    cb('ok')
end)

RegisterNUICallback('clearChat', function(data, cb)
    TriggerServerEvent('adminmenu:clearChat')
    cb('ok')
end)

-- Server Events
RegisterNetEvent('adminmenu:permissionsResult')
AddEventHandler('adminmenu:permissionsResult', function(group, perms)
    playerGroup = group
    permissions = perms
end)

RegisterNetEvent('adminmenu:playersResult')
AddEventHandler('adminmenu:playersResult', function(players)
    SendNUIMessage({
        action = 'updatePlayers',
        players = players
    })
end)

RegisterNetEvent('adminmenu:notification')
AddEventHandler('adminmenu:notification', function(message, type)
    TriggerEvent('chat:addMessage', {
        color = type == 'success' and {0, 255, 0} or {255, 0, 0},
        multiline = true,
        args = {"Admin Menu", message}
    })
end)