local noclip = false
local godmode = false
local invisible = false
local spectating = false
local spectateTarget = nil

-- Noclip Function
function ToggleNoclip()
    noclip = not noclip
    local playerPed = PlayerPedId()
    
    if noclip then
        SetEntityInvincible(playerPed, true)
        SetEntityVisible(playerPed, false, false)
        SetEntityCollision(playerPed, false, false)
        FreezeEntityPosition(playerPed, true)
        SetPlayerInvincible(PlayerId(), true)
        
        Citizen.CreateThread(function()
            while noclip do
                Citizen.Wait(0)
                
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local dx, dy, dz = GetCamDirection()
                local speed = 2.0
                
                if IsControlPressed(0, 21) then -- Left Shift
                    speed = 10.0
                end
                
                if IsControlPressed(0, 32) then -- W
                    x = x + dx * speed
                    y = y + dy * speed
                    z = z + dz * speed
                end
                
                if IsControlPressed(0, 33) then -- S
                    x = x - dx * speed
                    y = y - dy * speed
                    z = z - dz * speed
                end
                
                if IsControlPressed(0, 34) then -- A
                    x = x + dy * speed
                    y = y - dx * speed
                end
                
                if IsControlPressed(0, 35) then -- D
                    x = x - dy * speed
                    y = y + dx * speed
                end
                
                if IsControlPressed(0, 44) then -- Q
                    z = z - speed
                end
                
                if IsControlPressed(0, 38) then -- E
                    z = z + speed
                end
                
                SetEntityCoords(playerPed, x, y, z, false, false, false, true)
            end
        end)
        
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            multiline = true,
            args = {"Admin Menu", "Noclip enabled."}
        })
    else
        SetEntityInvincible(playerPed, false)
        SetEntityVisible(playerPed, true, false)
        SetEntityCollision(playerPed, true, true)
        FreezeEntityPosition(playerPed, false)
        SetPlayerInvincible(PlayerId(), false)
        
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"Admin Menu", "Noclip disabled."}
        })
    end
end

-- Godmode Function
function ToggleGodmode()
    godmode = not godmode
    local playerPed = PlayerPedId()
    
    if godmode then
        SetPlayerInvincible(PlayerId(), true)
        SetPedCanRagdoll(playerPed, false)
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            multiline = true,
            args = {"Admin Menu", "Godmode enabled."}
        })
        
        Citizen.CreateThread(function()
            while godmode do
                Citizen.Wait(0)
                SetEntityHealth(playerPed, 200)
                SetPedArmour(playerPed, 100)
            end
        end)
    else
        SetPlayerInvincible(PlayerId(), false)
        SetPedCanRagdoll(playerPed, true)
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"Admin Menu", "Godmode disabled."}
        })
    end
end

-- Invisible Function
function ToggleInvisible()
    invisible = not invisible
    local playerPed = PlayerPedId()
    
    if invisible then
        SetEntityVisible(playerPed, false, false)
        SetEntityAlpha(playerPed, 0, false)
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            multiline = true,
            args = {"Admin Menu", "Invisibility enabled."}
        })
    else
        SetEntityVisible(playerPed, true, false)
        SetEntityAlpha(playerPed, 255, false)
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"Admin Menu", "Invisibility disabled."}
        })
    end
end

-- Spectate Function
function StartSpectating(targetPlayerId)
    if spectating then
        StopSpectating()
    end
    
    spectating = true
    spectateTarget = targetPlayerId
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetPlayerId))
    
    if targetPed and targetPed ~= 0 then
        local playerPed = PlayerPedId()
        SetEntityVisible(playerPed, false, false)
        SetEntityCollision(playerPed, false, false)
        NetworkSetInSpectatorMode(true, targetPed)
        
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            multiline = true,
            args = {"Admin Menu", "Started spectating player " .. targetPlayerId}
        })
    end
end

function StopSpectating()
    if spectating then
        spectating = false
        spectateTarget = nil
        
        local playerPed = PlayerPedId()
        SetEntityVisible(playerPed, true, false)
        SetEntityCollision(playerPed, true, true)
        NetworkSetInSpectatorMode(false, playerPed)
        
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"Admin Menu", "Stopped spectating"}
        })
    end
end

-- Get Camera Direction
function GetCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local pitch = GetGameplayCamRelativePitch()
    
    local x = -math.sin(heading * math.pi / 180.0)
    local y = math.cos(heading * math.pi / 180.0)
    local z = math.sin(pitch * math.pi / 180.0)
    
    local len = math.sqrt(x * x + y * y + z * z)
    if len ~= 0 then
        x = x / len
        y = y / len
        z = z / len
    end
    
    return x, y, z
end

-- Utility Functions
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

-- Key Controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        -- Toggle spectate with X key
        if spectating and IsControlJustPressed(0, 73) then
            StopSpectating()
        end
        
        -- Show spectate instructions
        if spectating then
            DrawText3D(0.5, 0.05, 0.0, "Press ~r~X~w~ to stop spectating")
        end
    end
end)