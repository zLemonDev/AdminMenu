-- Check if player has admin permissions
function HasPermission(source, permission)
    local identifier = GetPlayerIdentifier(source)
    -- This is a basic implementation - you should integrate with your permission system
    -- For example: ESX, QB-Core, or your custom system
    
    -- Basic group check (you can modify this)
    local playerGroup = GetPlayerGroup(source) -- Implement this function based on your framework
    
    if playerGroup and Config.Permissions[playerGroup] then
        return Config.Permissions[playerGroup][permission] or false
    end
    
    return false
end

-- Get player group (implement based on your framework)
function GetPlayerGroup(source)
    -- Example for ESX:
    -- local xPlayer = ESX.GetPlayerFromId(source)
    -- return xPlayer.getGroup()
    
    -- Example for QB-Core:
    -- local Player = QBCore.Functions.GetPlayer(source)
    -- return Player.PlayerData.job.grade.level >= 3 and 'admin' or nil
    
    -- Basic implementation - you should replace this
    local identifier = GetPlayerIdentifier(source)
    -- Check your database or permission system here
    return 'admin' -- Default for testing - CHANGE THIS
end

-- Permission Check Event
RegisterNetEvent('adminmenu:checkPermissions')
AddEventHandler('adminmenu:checkPermissions', function()
    local source = source
    local playerGroup = GetPlayerGroup(source)
    local permissions = {}
    
    if playerGroup and Config.Permissions[playerGroup] then
        permissions = Config.Permissions[playerGroup]
    end
    
    TriggerClientEvent('adminmenu:permissionsResult', source, playerGroup, permissions)
end)

-- Get Online Players
RegisterNetEvent('adminmenu:getOnlinePlayers')
AddEventHandler('adminmenu:getOnlinePlayers', function()
    local source = source
    
    if not HasPermission(source, 'player_management') then
        return
    end
    
    local players = {}
    for _, playerId in ipairs(GetPlayers()) do
        table.insert(players, {
            id = playerId,
            name = GetPlayerName(playerId),
            ping = GetPlayerPing(playerId),
            identifier = GetPlayerIdentifier(playerId)
        })
    end
    
    TriggerClientEvent('adminmenu:playersResult', source, players)
end)

-- Kick Player
RegisterNetEvent('adminmenu:kickPlayer')
AddEventHandler('adminmenu:kickPlayer', function(targetId, reason)
    local source = source
    
    if not HasPermission(source, 'player_management') then
        return
    end
    
    reason = reason or "No reason provided"
    DropPlayer(targetId, "Kicked by admin: " .. reason)
    
    TriggerClientEvent('adminmenu:notification', source, "Player " .. GetPlayerName(targetId) .. " has been kicked.", 'success')
    
    -- Log the action
    print("[ADMIN LOG] " .. GetPlayerName(source) .. " kicked " .. GetPlayerName(targetId) .. " for: " .. reason)
end)

-- Ban Player (Basic implementation - you should integrate with your ban system)
RegisterNetEvent('adminmenu:banPlayer')
AddEventHandler('adminmenu:banPlayer', function(targetId, reason, duration)
    local source = source
    
    if not HasPermission(source, 'ban_system') then
        return
    end
    
    reason = reason or "No reason provided"
    duration = duration or 0 -- 0 = permanent
    
    local targetIdentifier = GetPlayerIdentifier(targetId)
    local targetName = GetPlayerName(targetId)
    
    -- Add to ban list (implement your ban system here)
    -- Example: AddToBanList(targetIdentifier, reason, duration)
    
    DropPlayer(targetId, "Banned by admin: " .. reason)
    
    TriggerClientEvent('adminmenu:notification', source, "Player " .. targetName .. " has been banned.", 'success')
    
    -- Log the action
    print("[ADMIN LOG] " .. GetPlayerName(source) .. " banned " .. targetName .. " for: " .. reason)
end)

-- Goto Player
RegisterNetEvent('adminmenu:gotoPlayer')
AddEventHandler('adminmenu:gotoPlayer', function(targetId)
    local source = source
    
    if not HasPermission(source, 'teleport') then
        return
    end
    
    local targetPed = GetPlayerPed(targetId)
    if targetPed then
        local coords = GetEntityCoords(targetPed)
        TriggerClientEvent('adminmenu:teleportToCoords', source, coords.x, coords.y, coords.z)
        TriggerClientEvent('adminmenu:notification', source, "Teleported to " .. GetPlayerName(targetId), 'success')
    end
end)

-- Bring Player
RegisterNetEvent('adminmenu:bringPlayer')
AddEventHandler('adminmenu:bringPlayer', function(targetId)
    local source = source
    
    if not HasPermission(source, 'teleport') then
        return
    end
    
    local adminPed = GetPlayerPed(source)
    if adminPed then
        local coords = GetEntityCoords(adminPed)
        TriggerClientEvent('adminmenu:teleportToCoords', targetId, coords.x, coords.y, coords.z)
        TriggerClientEvent('adminmenu:notification', source, "Brought " .. GetPlayerName(targetId) .. " to you", 'success')
        TriggerClientEvent('adminmenu:notification', targetId, "You have been teleported by an admin", 'info')
    end
end)

-- Spectate Player
RegisterNetEvent('adminmenu:spectatePlayer')
AddEventHandler('adminmenu:spectatePlayer', function(targetId)
    local source = source
    
    if not HasPermission(source, 'spectate') then
        return
    end
    
    TriggerClientEvent('adminmenu:startSpectating', source, targetId)
    TriggerClientEvent('adminmenu:notification', source, "Started spectating " .. GetPlayerName(targetId), 'success')
end)

-- Freeze Player
RegisterNetEvent('adminmenu:freezePlayer')
AddEventHandler('adminmenu:freezePlayer', function(targetId, freeze)
    local source = source
    
    if not HasPermission(source, 'player_management') then
        return
    end
    
    TriggerClientEvent('adminmenu:freezePlayer', targetId, freeze)
    
    local action = freeze and "frozen" or "unfrozen"
    TriggerClientEvent('adminmenu:notification', source, "Player " .. GetPlayerName(targetId) .. " has been " .. action, 'success')
    TriggerClientEvent('adminmenu:notification', targetId, "You have been " .. action .. " by an admin", 'info')
end)

-- Spawn Vehicle
RegisterNetEvent('adminmenu:spawnVehicle')
AddEventHandler('adminmenu:spawnVehicle', function(model)
    local source = source
    
    if not HasPermission(source, 'vehicle_management') then
        return
    end
    
    TriggerClientEvent('adminmenu:spawnVehicle', source, model)
    TriggerClientEvent('adminmenu:notification', source, "Vehicle " .. model .. " spawned", 'success')
end)

-- Set Weather
RegisterNetEvent('adminmenu:setWeather')
AddEventHandler('adminmenu:setWeather', function(weather)
    local source = source
    
    if not HasPermission(source, 'weather') then
        return
    end
    
    TriggerClientEvent('adminmenu:setWeather', -1, weather)
    TriggerClientEvent('chat:addMessage', -1, {
        color = {0, 255, 255},
        multiline = true,
        args = {"Server", "Weather changed to " .. weather .. " by admin"}
    })
    
    -- Log the action
    print("[ADMIN LOG] " .. GetPlayerName(source) .. " changed weather to " .. weather)
end)

-- Set Time
RegisterNetEvent('adminmenu:setTime')
AddEventHandler('adminmenu:setTime', function(hour, minute)
    local source = source
    
    if not HasPermission(source, 'time') then
        return
    end
    
    TriggerClientEvent('adminmenu:setTime', -1, hour, minute)
    TriggerClientEvent('chat:addMessage', -1, {
        color = {0, 255, 255},
        multiline = true,
        args = {"Server", "Time changed to " .. hour .. ":" .. string.format("%02d", minute) .. " by admin"}
    })
    
    -- Log the action
    print("[ADMIN LOG] " .. GetPlayerName(source) .. " changed time to " .. hour .. ":" .. minute)
end)

-- Announce Message
RegisterNetEvent('adminmenu:announceMessage')
AddEventHandler('adminmenu:announceMessage', function(message)
    local source = source
    
    if not HasPermission(source, 'server_management') then
        return
    end
    
    TriggerClientEvent('chat:addMessage', -1, {
        color = {255, 0, 0},
        multiline = true,
        args = {"ANNOUNCEMENT", message}
    })
    
    -- Log the action
    print("[ADMIN LOG] " .. GetPlayerName(source) .. " made announcement: " .. message)
end)

-- Clear Chat
RegisterNetEvent('adminmenu:clearChat')
AddEventHandler('adminmenu:clearChat', function()
    local source = source
    
    if not HasPermission(source, 'server_management') then
        return
    end
    
    TriggerClientEvent('chat:clear', -1)
    TriggerClientEvent('chat:addMessage', -1, {
        color = {0, 255, 255},
        multiline = true,
        args = {"Server", "Chat cleared by admin"}
    })
    
    -- Log the action
    print("[ADMIN LOG] " .. GetPlayerName(source) .. " cleared chat")
end)

-- Client Events for Weather and Time
RegisterNetEvent('adminmenu:setWeather')
AddEventHandler('adminmenu:setWeather', function(weather)
    SetWeatherTypeNowPersist(weather)
    SetWeatherTypeNow(weather)
    SetWeatherTypePersist(weather)
end)

RegisterNetEvent('adminmenu:setTime')
AddEventHandler('adminmenu:setTime', function(hour, minute)
    NetworkOverrideClockTime(hour, minute, 0)
end)

-- Vehicle Spawn (Client Event)
RegisterNetEvent('adminmenu:spawnVehicle')
AddEventHandler('adminmenu:spawnVehicle', function(model)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(1)
    end
    
    local vehicle = CreateVehicle(model, coords.x + 2, coords.y, coords.z, heading, true, false)
    SetPedIntoVehicle(playerPed, vehicle, -1)
    SetModelAsNoLongerNeeded(model)
end)

-- Freeze Player (Client Event)
RegisterNetEvent('adminmenu:freezePlayer')
AddEventHandler('adminmenu:freezePlayer', function(freeze)
    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, freeze)
    
    if freeze then
        SetPlayerControl(PlayerId(), false, 0)
    else
        SetPlayerControl(PlayerId(), true, 0)
    end
end)

-- Teleport to Coords (Client Event)
RegisterNetEvent('adminmenu:teleportToCoords')
AddEventHandler('adminmenu:teleportToCoords', function(x, y, z)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, x, y, z, false, false, false, true)
end)

-- Start Spectating (Client Event)
RegisterNetEvent('adminmenu:startSpectating')
AddEventHandler('adminmenu:startSpectating', function(targetId)
    StartSpectating(targetId)
end)