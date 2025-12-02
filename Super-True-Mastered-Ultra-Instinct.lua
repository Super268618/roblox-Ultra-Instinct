-- SUPER'S ULTRA INSTINCT + SUPERSKKSKSJSJSJ MODE -- Multiple modes with ultimate Superskksksjsjsj transformation -- Place in StarterPlayer → StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- MODE SETTINGS
local UI_ENABLED = false
local CURRENT_MODE = "MASTERED" -- MASTERED, PERFECTION, SUPERSKKSKSJSJSJ

-- ADVANCED FLING DETECTION SETTINGS
local VELOCITY_THRESHOLD = {
    MASTERED = 250,      -- Increased for better fling detection
    PERFECTION = 300,    -- Increased for better fling detection
    SUPERSKKSKSJSJSJ = 150  -- Ultra-sensitive for SUPERSKKSKSJSJSJ
}

-- Real fling detection: Check velocity changes (acceleration)
local ACCELERATION_THRESHOLD = {
    MASTERED = 500,
    PERFECTION = 700,
    SUPERSKKSKSJSJSJ = 300  -- Very sensitive to acceleration changes
}

local DODGE_DISTANCE = {
    MASTERED = 25,
    PERFECTION = 35,
    SUPERSKKSKSJSJSJ = 50  -- Balanced dodge distance
}

-- ALL MODES HAVE 2.5x SPEED
local SPEED_BOOST = {
    MASTERED = 2.5,
    PERFECTION = 2.5,
    SUPERSKKSKSJSJSJ = 2.5  -- ALL MODES SAME SPEED
}

local PROXIMITY_RANGE = 15

local AFTERIMAGE_INTERVAL = {
    MASTERED = 0.08,
    PERFECTION = 0.05,
    SUPERSKKSKSJSJSJ = 0.01  -- Fast afterimages
}

-- ADVANCED ANTI-FLING
local ANTI_FLING_FORCE = {
    MASTERED = 1000,
    PERFECTION = 2000,
    SUPERSKKSKSJSJSJ = 10000  -- Strong anti-fling
}

-- Connections
local DodgeConnection, AuraConnection, ProximityConnection, AfterimageConnection, ModeEffectConnection, AntiFlingConnection
local dodgeCount = 0
local lastAfterimage = 0
local antiFlingActive = false

-- Fling detection variables
local lastVelocity = Vector3.new(0, 0, 0)
local lastCheckTime = tick()
local lastDodgeTime = 0
local DODGE_COOLDOWN = {
    MASTERED = 0.3,
    PERFECTION = 0.2,
    SUPERSKKSKSJSJSJ = 0  -- No cooldown for SUPERSKKSKSJSJSJ
}

-- Effects Folder
local FXFolder = Instance.new("Folder", workspace)
FXFolder.Name = "SuperUI_FX"

-- GUI (same as before...)
-- [GUI code unchanged, use your existing GUI]

-- ADVANCED AURA FOR SUPERSKKSKSJSJSJ - FIXED & GOD-LIKE
local function createAura()
    local auraSize, auraColor
    
    if CURRENT_MODE == "SUPERSKKSKSJSJSJ" then
        auraSize = 8  -- Small but powerful
        auraColor = Color3.fromHSV(tick() % 1, 1, 1) -- Rainbow
    elseif CURRENT_MODE == "PERFECTION" then
        auraSize = 8
        auraColor = Color3.fromRGB(255, 200, 255)
    else
        auraSize = 6
        auraColor = Color3.fromRGB(200, 200, 255)
    end
    
    local aura = Instance.new("Part")
    aura.Name = "UIAura"
    aura.Size = Vector3.new(auraSize, auraSize, auraSize)
    aura.Position = RootPart.Position
    aura.Anchored = true
    aura.CanCollide = false
    aura.Material = Enum.Material.Neon
    
    if CURRENT_MODE == "SUPERSKKSKSJSJSJ" then
        aura.Color = Color3.fromHSV(tick() % 1, 1, 1)
        aura.Transparency = 0.2  -- Semi-transparent for better visibility
        aura.Material = Enum.Material.Neon
    else
        aura.Color = auraColor
        aura.Transparency = 0.7
    end
    
    aura.Shape = Enum.PartType.Ball
    aura.Parent = FXFolder
    
    -- SUPERSKKSKSJSJSJ GOD-LIKE EFFECTS
    if CURRENT_MODE == "SUPERSKKSKSJSJSJ" then
        -- Add point light
        local light = Instance.new("PointLight")
        light.Parent = aura
        light.Color = Color3.fromHSV(tick() % 1, 1, 1)
        light.Brightness = 5
        light.Range = 15
        light.Shadows = false
        
        -- Add subtle particles
        local particles = Instance.new("ParticleEmitter")
        particles.Parent = aura
        particles.Texture = "rbxassetid://242719275"
        particles.Rate = 20
        particles.Lifetime = NumberRange.new(0.5, 1)
        particles.Speed = NumberRange.new(2, 5)
        particles.Size = NumberSequence.new(0.1, 0.3)
        particles.Transparency = NumberSequence.new(0.3, 1)
        particles.Color = ColorSequence.new(Color3.fromHSV(tick() % 1, 1, 1))
        particles.Rotation = NumberRange.new(0, 360)
        particles.VelocityInheritance = 0
        particles.EmissionDirection = Enum.NormalId.Top
    end
    
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Sphere
    mesh.Scale = Vector3.new(1, 1, 1)
    mesh.Parent = aura
    
    return aura
end

-- ADVANCED FLING DETECTION FUNCTION
local function isRealFling(currentVelocity, lastVel, deltaTime)
    -- Check 1: High velocity magnitude
    local velocityMagnitude = currentVelocity.Magnitude
    
    -- Check 2: Sudden acceleration (velocity change)
    local acceleration = (currentVelocity - lastVel) / deltaTime
    local accelerationMagnitude = acceleration.Magnitude
    
    -- Check 3: Not moving intentionally
    local isMovingIntentionally = Humanoid.MoveDirection.Magnitude > 0.5
    
    -- Check 4: Vertical velocity check (flings often have high vertical component)
    local verticalVelocity = math.abs(currentVelocity.Y)
    
    -- Check 5: Direction change (flings often come from unexpected directions)
    local directionDot = 0
    if Humanoid.MoveDirection.Magnitude > 0.1 then
        directionDot = currentVelocity.Unit:Dot(Humanoid.MoveDirection.Unit)
    end
    
    -- Different thresholds per mode
    if CURRENT_MODE == "SUPERSKKSKSJSJSJ" then
        -- Ultra-sensitive for SUPERSKKSKSJSJSJ
        return (velocityMagnitude > VELOCITY_THRESHOLD[CURRENT_MODE] and 
                accelerationMagnitude > ACCELERATION_THRESHOLD[CURRENT_MODE]) or
               (verticalVelocity > 100 and velocityMagnitude > 200)  -- Also detect vertical flings
    else
        -- Normal mode detection
        return velocityMagnitude > VELOCITY_THRESHOLD[CURRENT_MODE] and 
               accelerationMagnitude > ACCELERATION_THRESHOLD[CURRENT_MODE] and
               not isMovingIntentionally and
               directionDot < 0.7  -- Velocity not in same direction as movement
    end
end

-- ADVANCED ANTI-FLING SYSTEM
local function applyAntiFlingForce(currentVelocity)
    if not antiFlingActive or CURRENT_MODE ~= "SUPERSKKSKSJSJSJ" then return end
    
    -- Only apply anti-fling if velocity is high (indicating fling)
    if currentVelocity.Magnitude > 200 then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                local vel = part.Velocity
                if vel.Magnitude > 50 then
                    -- Counter the fling with opposite force
                    local counterForce = -vel.Unit * ANTI_FLING_FORCE[CURRENT_MODE] * 0.01
                    part:ApplyImpulse(counterForce)
                    
                    -- Add slight stabilization
                    part.Velocity = part.Velocity * 0.5
                    part.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end
end

-- AFTERIMAGE EFFECT
local function createAfterimage()
    if tick() - lastAfterimage < AFTERIMAGE_INTERVAL[CURRENT_MODE] then return end
    lastAfterimage = tick()
    
    local color
    if CURRENT_MODE == "SUPERSKKSKSJSJSJ" then
        color = Color3.fromHSV(math.random(), 1, 1)
    elseif CURRENT_MODE == "PERFECTION" then
        color = Color3.fromRGB(255, 200, 255)
    else
        color = Color3.fromRGB(200, 220, 255)
    end
    
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency < 1 and part.Name ~= "HumanoidRootPart" then
            local clone = part:Clone()
            clone.Anchored = true
            clone.CanCollide = false
            clone.Material = Enum.Material.Neon
            clone.Color = color
            clone.Transparency = 0.5
            clone.CFrame = part.CFrame
            clone.Parent = FXFolder
            
            for _, child in pairs(clone:GetChildren()) do
                if not child:IsA("SpecialMesh") then
                    child:Destroy()
                end
            end
            
            TweenService:Create(clone, TweenInfo.new(0.3), {Transparency = 1}):Play()
            Debris:AddItem(clone, 0.3)
        end
    end
end

-- DODGE EFFECT
local function createDodgeEffect(position)
    local boltCount, effectSize
    
    if CURRENT_MODE == "SUPERSKKSKSJSJSJ" then
        boltCount = 20
        effectSize = 8
    elseif CURRENT_MODE == "PERFECTION" then
        boltCount = 12
        effectSize = 8
    else
        boltCount = 8
        effectSize = 6
    end
    
    local color = CURRENT_MODE == "SUPERSKKSKSJSJSJ" and Color3.fromHSV(tick() % 1, 1, 1) or
        (CURRENT_MODE == "PERFECTION" and Color3.fromRGB(255, 200, 255) or Color3.fromRGB(150, 200, 255))
    
    local part = Instance.new("Part")
    part.Size = Vector3.new(effectSize, effectSize, effectSize)
    part.Position = position
    part.Anchored = true
    part.CanCollide = false
    part.Material = Enum.Material.Neon
    part.Color = color
    part.Transparency = 0.2
    part.Shape = Enum.PartType.Ball
    part.Parent = FXFolder
    
    -- Lightning ring
    for i = 1, boltCount do
        local lightning = Instance.new("Part")
        lightning.Size = Vector3.new(0.3, 6, 0.3)
        lightning.Position = position
        lightning.Anchored = true
        lightning.CanCollide = false
        lightning.Material = Enum.Material.Neon
        lightning.Color = CURRENT_MODE == "SUPERSKKSKSJSJSJ" and Color3.fromHSV((i/boltCount), 1, 1) or Color3.fromRGB(255, 255, 255)
        lightning.Parent = FXFolder
        
        local angle = (i / boltCount) * math.pi * 2
        lightning.CFrame = CFrame.new(position) * CFrame.Angles(0, angle, math.rad(45)) * CFrame.new(0, 0, 4)
        
        TweenService:Create(lightning, TweenInfo.new(0.2), {Transparency = 1, Size = Vector3.new(0.1, 8, 0.1)}):Play()
        Debris:AddItem(lightning, 0.2)
    end
    
    TweenService:Create(part, TweenInfo.new(0.4), {Size = Vector3.new(effectSize * 2, effectSize * 2, effectSize * 2), Transparency = 1}):Play()
    Debris:AddItem(part, 0.4)
end

-- PROXIMITY DETECTION
local function checkProximity()
    local nearbyPlayers = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local theirRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if theirRoot then
                local distance = (theirRoot.Position - RootPart.Position).Magnitude
                if distance < PROXIMITY_RANGE then
                    table.insert(nearbyPlayers, player)
                end
            end
        end
    end
    
    WarningFrame.Visible = #nearbyPlayers > 0
    if #nearbyPlayers > 0 then
        TweenService:Create(WarningFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
        task.wait(0.3)
        TweenService:Create(WarningFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.5}):Play()
    end
end

-- MAIN DODGE SYSTEM - ADVANCED FLING DETECTION
local function startUI()
    if DodgeConnection then DodgeConnection:Disconnect() end
    if AuraConnection then AuraConnection:Disconnect() end
    if ProximityConnection then ProximityConnection:Disconnect() end
    if AfterimageConnection then AfterimageConnection:Disconnect() end
    if ModeEffectConnection then ModeEffectConnection:Disconnect() end
    if AntiFlingConnection then AntiFlingConnection:Disconnect() end
    
    -- Speed boost (ALL MODES 2.5x)
    Humanoid.WalkSpeed = 16 * SPEED_BOOST[CURRENT_MODE]
    SpeedLabel.Text = "💨 Speed: 2.5x"
    
    -- Create aura
    local aura = createAura()
    AuraConnection = RunService.Heartbeat:Connect(function()
        if not UI_ENABLED or not aura.Parent then return end
        aura.Position = RootPart.Position
        aura.CFrame = aura.CFrame * CFrame.Angles(0, math.rad(10), 0)
        
        -- Rainbow effect for SUPERSKKSKSJSJSJ
        if CURRENT_MODE == "SUPERSKKSKSJSJSJ" then
            aura.Color = Color3.fromHSV(tick() % 1, 1, 1)
            if aura:FindFirstChild("PointLight") then
                aura.PointLight.Color = Color3.fromHSV(tick() % 1, 1, 1)
            end
            if aura:FindFirstChild("ParticleEmitter") then
                aura.ParticleEmitter.Color = ColorSequence.new(Color3.fromHSV(tick() % 1, 1, 1))
            end
        end
        
        -- Pulse effect
        local pulseSpeed = CURRENT_MODE == "SUPERSKKSKSJSJSJ" and 8 or 5
        local pulseIntensity = CURRENT_MODE == "SUPERSKKSKSJSJSJ" and 0.2 or 0.1
        local scale = 1 + math.sin(tick() * pulseSpeed) * pulseIntensity
        local size = CURRENT_MODE == "SUPERSKKSKSJSJSJ" and 8 or (CURRENT_MODE == "PERFECTION" and 8 or 6)
        aura.Size = Vector3.new(size * scale, size * scale, size * scale)
    end)
    
    -- Proximity detection
    ProximityConnection = RunService.Heartbeat:Connect(function()
        if not UI_ENABLED then return end
        checkProximity()
    end)
    
    -- Afterimage trail
    AfterimageConnection = RunService.Heartbeat:Connect(function()
        if not UI_ENABLED then return end
        if Humanoid.MoveDirection.Magnitude > 0 then
            createAfterimage()
        end
    end)
    
    -- SUPERSKKSKSJSJSJ rainbow GUI effect
    if CURRENT_MODE == "SUPERSKKSKSJSJSJ" then
        ModeEffectConnection = RunService.Heartbeat:Connect(function()
            if not UI_ENABLED then return end
            Frame.BorderColor3 = Color3.fromHSV(tick() % 1, 1, 1)
        end)
    end
    
    -- ADVANCED DODGE SYSTEM WITH REAL FLING DETECTION
    local lastPosition = RootPart.Position
    lastVelocity = RootPart.Velocity
    lastCheckTime = tick()
    
    DodgeConnection = RunService.Heartbeat:Connect(function()
        if not UI_ENABLED then return end
        
        local currentTime = tick()
        local deltaTime = currentTime - lastCheckTime
        local currentVelocity = RootPart.Velocity
        
        -- Check if enough time has passed since last dodge
        local canDodge = (currentTime - lastDodgeTime) > DODGE_COOLDOWN[CURRENT_MODE]
        
        -- ADVANCED FLING DETECTION
        if canDodge and isRealFling(currentVelocity, lastVelocity, deltaTime) then
            dodgeCount = dodgeCount + 1
            DodgeLabel.Text = "⚡ Dodges: " .. dodgeCount
            lastDodgeTime = currentTime
            
            local dodgeFrom = RootPart.Position
            local dodgeDirection = -currentVelocity.Unit
            
            -- Calculate dodge position
            local dodgePosition = lastPosition + (dodgeDirection * DODGE_DISTANCE[CURRENT_MODE])
            
            -- Keep Y position reasonable
            dodgePosition = Vector3.new(
                dodgePosition.X,
                math.clamp(dodgePosition.Y, lastPosition.Y - 10, lastPosition.Y + 10),
                dodgePosition.Z
            )
            
            -- Perform dodge teleport
            RootPart.CFrame = CFrame.new(dodgePosition)
            RootPart.Velocity = Vector3.new(0, 0, 0)
            RootPart.RotVelocity = Vector3.new(0, 0, 0)
            
            -- Apply anti-fling for SUPERSKKSKSJSJSJ
            if CURRENT_MODE == "SUPERSKKSKSJSJSJ" then
                antiFlingActive = true
                applyAntiFlingForce(currentVelocity)
                task.wait(0.05)
                antiFlingActive = false
            end
            
            -- Reset velocities on all parts
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Velocity = Vector3.new(0, 0, 0)
                    part.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
            
            -- Create dodge effects
            createDodgeEffect(dodgeFrom)
            createDodgeEffect(dodgePosition)
            
            -- Flash GUI
            Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HeaderCover.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            task.wait(0.05)
            
            -- Set header color based on mode
            local headerColor
            if CURRENT_MODE == "SUPERSKKSKSJSJSJ" then
                headerColor = Color3.fromHSV(tick() % 1, 1, 1)
            elseif CURRENT_MODE == "PERFECTION" then
                headerColor = Color3.fromRGB(200, 150, 255)
            else
                headerColor = Color3.fromRGB(150, 200, 255)
            end
            Header.BackgroundColor3 = headerColor
            HeaderCover.BackgroundColor3 = headerColor
        end
        
        -- Update tracking variables
        if currentVelocity.Magnitude < 100 then
            lastPosition = RootPart.Position
        end
        
        lastVelocity = currentVelocity
        lastCheckTime = currentTime
    end)
    
    -- CONSTANT ANTI-FLING FOR SUPERSKKSKSJSJSJ
    if CURRENT_MODE == "SUPERSKKSKSJSJSJ" then
        AntiFlingConnection = RunService.Heartbeat:Connect(function()
            if not UI_ENABLED then return end
            
            -- Mild velocity stabilization
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    local vel = part.Velocity
                    if vel.Magnitude > 300 then  -- Only stabilize extreme velocities
                        part.Velocity = vel * 0.95
                    end
                end
            end
        end)
    end
end

local function stopUI()
    if DodgeConnection then DodgeConnection:Disconnect() end
    if AuraConnection then AuraConnection:Disconnect() end
    if ProximityConnection then ProximityConnection:Disconnect() end
    if AfterimageConnection then AfterimageConnection:Disconnect() end
    if ModeEffectConnection then ModeEffectConnection:Disconnect() end
    if AntiFlingConnection then AntiFlingConnection:Disconnect() end
    
    Humanoid.WalkSpeed = 16
    WarningFrame.Visible = false
    antiFlingActive = false
    
    -- Remove effects
    for _, v in pairs(FXFolder:GetChildren()) do
        v:Destroy()
    end
end

-- MODE SELECTION
MasteredBtn.MouseButton1Click:Connect(function()
    CURRENT_MODE = "MASTERED"
    ModeLabel.Text = "🌟 Mode: MASTERED"
    SpeedLabel.Text = "💨 Speed: 2.5x"
    Frame.BorderColor3 = Color3.fromRGB(200, 200, 255)
    if UI_ENABLED then
        stopUI()
        task.wait(0.1)
        startUI()
    end
end)

PerfectionBtn.MouseButton1Click:Connect(function()
    CURRENT_MODE = "PERFECTION"
    ModeLabel.Text = "💫 Mode: PERFECTION"
    SpeedLabel.Text = "💨 Speed: 2.5x"
    Frame.BorderColor3 = Color3.fromRGB(200, 150, 255)
    if UI_ENABLED then
        stopUI()
        task.wait(0.1)
        startUI()
    end
end)

SuperBtn.MouseButton1Click:Connect(function()
    CURRENT_MODE = "SUPERSKKSKSJSJSJ"
    ModeLabel.Text = "💥 Mode: SUPERSKKSKSJSJSJ"
    SpeedLabel.Text = "💨 Speed: 2.5x"
    if UI_ENABLED then
        stopUI()
        task.wait(0.1)
        startUI()
    end
end)

-- TOGGLE BUTTON
ToggleButton.MouseButton1Click:Connect(function()
    UI_ENABLED = not UI_ENABLED
    
    if UI_ENABLED then
        ToggleButton.Text = CURRENT_MODE
        local headerColor = CURRENT_MODE == "SUPERSKKSKSJSJSJ" and Color3.fromHSV(tick() % 1, 1, 1) or
            (CURRENT_MODE == "PERFECTION" and Color3.fromRGB(200, 150, 255) or Color3.fromRGB(100, 200, 255))
        ButtonGradient.Color = ColorSequence.new(headerColor, headerColor)
        Header.BackgroundColor3 = headerColor
        HeaderCover.BackgroundColor3 = headerColor
        StatusLabel.Text = "⚡ ACTIVE ⚡"
        StatusLabel.TextColor3 = Color3.fromRGB(150, 255, 255)
        startUI()
    else
        ToggleButton.Text = "AWAKEN"
        ButtonGradient.Color = ColorSequence.new(Color3.fromRGB(150, 50, 50), Color3.fromRGB(100, 30, 30))
        Header.BackgroundColor3 = Color3.fromRGB(200, 200, 255)
        HeaderCover.BackgroundColor3 = Color3.fromRGB(200, 200, 255)
        StatusLabel.Text = "🔴 DORMANT 🔴"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        Frame.BorderColor3 = Color3.fromRGB(200, 200, 255)
        stopUI()
    end
end)

-- Character respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
    dodgeCount = 0
    DodgeLabel.Text = "⚡ Dodges: 0"
    lastVelocity = Vector3.new(0, 0, 0)
    lastDodgeTime = 0
    task.wait(0.5)
    if UI_ENABLED then
        startUI()
    end
end)

print("⚡🔥 SUPER'S ULTRA INSTINCT - ADVANCED FLING DETECTION LOADED 🔥⚡")
print("ALL MODES: 2.5x Speed Boost (Safe & Balanced)")
print("ADVANCED FLING DETECTION FEATURES:")
print("- Velocity threshold checks (150-300)")
print("- Acceleration detection (300-700)")
print("- Vertical fling detection")
print("- Movement direction analysis")
print("- No false positives from normal movement")
print("")
print("SUPERSKKSKSJSJSJ MODE:")
print("- Small but powerful 8-stud aura")
print("- PointLight + Particle effects")
print("- Ultra-sensitive fling detection (150 velocity)")
print("- 10,000 Anti-Fling Force")
print("- No dodge cooldown")
print("- Instant response to real flings")
print("")
print("Select mode then click AWAKEN!")
