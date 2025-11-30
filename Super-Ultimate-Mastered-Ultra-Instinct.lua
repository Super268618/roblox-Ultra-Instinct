-- LIMIT BREAKER ULTRA INSTINCT - BEYOND MAXIMUM POWER --
-- ABSOLUTE REALITY BREAKER MODE - TRANSCENDING ALL LIMITS!

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- 🚀 REALITY-BREAKING SETTINGS
local UI_ENABLED = false
local UI_MODE = "REALITY_BREAKER" -- SIGN, MASTERED, or REALITY_BREAKER
local VELOCITY_THRESHOLD = 50 -- Lower threshold for more dodges
local DODGE_DISTANCE = 50 -- Increased dodge distance
local SPEED_BOOST_SIGN = 8.0 -- 8x speed
local SPEED_BOOST_MASTERED = 15.0 -- 15x speed  
local SPEED_BOOST_REALITY = 25.0 -- 25x SPEED - MOVING FASTER THAN EYES CAN SEE
local PROXIMITY_RANGE = 100 -- Detect threats from further away
local AFTERIMAGE_INTERVAL = 0.02 -- Faster afterimages
local PREDICTION_RANGE = 30 -- Predict attacks from further away
local SHOCKWAVE_ENABLED = true
local INSTANT_TRANSMISSION = true
local AUTO_DODGE = true -- Automatically dodge everything
local TIME_CONTROL = true -- Slow down time around you
local CLONE_ARMY = true -- Create attacking clones
local REALITY_DISTORTION = true -- Warp space around you

-- Connections
local DodgeConnection, AuraConnection, ProximityConnection, AfterimageConnection, PredictionConnection
local TimeControlConnection, CloneConnection, RealityConnection
local dodgeCount = 0
local lastAfterimage = 0
local uiEnergy = 100 -- Start with full energy
local isTimeSlowed = false
local activeClones = {}

-- Effects Folder
local FXFolder = Instance.new("Folder", workspace)
FXFolder.Name = "GodModeUI_FX"

-- 🚀 ENHANCED GUI WITH GOD MODE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GodModeUIGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderColor3 = Color3.fromRGB(255, 255, 0)
Frame.BorderSizePixel = 6
Frame.Position = UDim2.new(0.32, 0, 0.22, 0)
Frame.Size = UDim2.new(0, 350, 0, 400)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 20)
UICorner.Parent = Frame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 0, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 100))
})
UIGradient.Rotation = 45
UIGradient.Parent = Frame

local Header = Instance.new("Frame")
Header.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 60)
Header.Parent = Frame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 20)
HeaderCorner.Parent = Header

local HeaderCover = Instance.new("Frame")
HeaderCover.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
HeaderCover.BorderSizePixel = 0
HeaderCover.Position = UDim2.new(0, 0, 0.5, 0)
HeaderCover.Size = UDim2.new(1, 0, 0.5, 0)
HeaderCover.Parent = Header

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Font = Enum.Font.GothamBlack
Title.Text = "⚡ REALITY BREAKER MODE ⚡"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.TextSize = 20
Title.TextScaled = true
Title.Parent = Header

local StatusLabel = Instance.new("TextLabel")
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.08, 0, 0.15, 0)
StatusLabel.Size = UDim2.new(0.84, 0, 0, 35)
StatusLabel.Font = Enum.Font.GothamBlack
StatusLabel.Text = "🔴 REALITY LOCKED 🔴"
StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
StatusLabel.TextSize = 18
StatusLabel.Parent = Frame

-- 🚀 ENHANCED MODE SYSTEM
local ModeFrame = Instance.new("Frame")
ModeFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
ModeFrame.BorderSizePixel = 0
ModeFrame.Position = UDim2.new(0.08, 0, 0.24, 0)
ModeFrame.Size = UDim2.new(0.84, 0, 0, 70)
ModeFrame.Parent = Frame

local ModeCorner = Instance.new("UICorner")
ModeCorner.CornerRadius = UDim.new(0, 12)
ModeCorner.Parent = ModeFrame

local ModeLabel = Instance.new("TextLabel")
ModeLabel.BackgroundTransparency = 1
ModeLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
ModeLabel.Size = UDim2.new(0.9, 0, 0, 25)
ModeLabel.Font = Enum.Font.GothamBlack
ModeLabel.Text = "🌌 MODE: REALITY BREAKER 🌌"
ModeLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
ModeLabel.TextSize = 16
ModeLabel.Parent = ModeFrame

local ModeToggle = Instance.new("TextButton")
ModeToggle.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
ModeToggle.Position = UDim2.new(0.1, 0, 0.5, 0)
ModeToggle.Size = UDim2.new(0.8, 0, 0, 25)
ModeToggle.Font = Enum.Font.GothamBold
ModeToggle.Text = "CYCLE MODE ⬇️"
ModeToggle.TextColor3 = Color3.fromRGB(0, 0, 0)
ModeToggle.TextSize = 12
ModeToggle.Parent = ModeFrame

local ModeToggleCorner = Instance.new("UICorner")
ModeToggleCorner.CornerRadius = UDim.new(0, 8)
ModeToggleCorner.Parent = ModeToggle

-- 🚀 ENHANCED STATS FRAME
local StatsFrame = Instance.new("Frame")
StatsFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
StatsFrame.BorderSizePixel = 0
StatsFrame.Position = UDim2.new(0.08, 0, 0.42, 0)
StatsFrame.Size = UDim2.new(0.84, 0, 0, 120)
StatsFrame.Parent = Frame

local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 12)
StatsCorner.Parent = StatsFrame

local DodgeLabel = Instance.new("TextLabel")
DodgeLabel.BackgroundTransparency = 1
DodgeLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
DodgeLabel.Size = UDim2.new(0.9, 0, 0, 20)
DodgeLabel.Font = Enum.Font.GothamBold
DodgeLabel.Text = "⚡ DODGES: INFINITE"
DodgeLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
DodgeLabel.TextSize = 14
DodgeLabel.TextXAlignment = Enum.TextXAlignment.Left
DodgeLabel.Parent = StatsFrame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Position = UDim2.new(0.05, 0, 0.25, 0)
SpeedLabel.Size = UDim2.new(0.9, 0, 0, 20)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.Text = "💨 SPEED: 25.0x (GOD)"
SpeedLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
SpeedLabel.TextSize = 14
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = StatsFrame

local EnergyLabel = Instance.new("TextLabel")
EnergyLabel.BackgroundTransparency = 1
EnergyLabel.Position = UDim2.new(0.05, 0, 0.45, 0)
EnergyLabel.Size = UDim2.new(0.9, 0, 0, 20)
EnergyLabel.Font = Enum.Font.GothamBold
EnergyLabel.Text = "🔋 ENERGY: INFINITE%"
EnergyLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
EnergyLabel.TextSize = 14
EnergyLabel.TextXAlignment = Enum.TextXAlignment.Left
EnergyLabel.Parent = StatsFrame

local FeatureLabel = Instance.new("TextLabel")
FeatureLabel.BackgroundTransparency = 1
FeatureLabel.Position = UDim2.new(0.05, 0, 0.65, 0)
FeatureLabel.Size = UDim2.new(0.9, 0, 0, 20)
FeatureLabel.Font = Enum.Font.GothamBold
FeatureLabel.Text = "✨ REALITY MANIPULATION ACTIVE"
FeatureLabel.TextColor3 = Color3.fromRGB(255, 50, 255)
FeatureLabel.TextSize = 12
FeatureLabel.TextXAlignment = Enum.TextXAlignment.Left
FeatureLabel.Parent = StatsFrame

local AbilityLabel = Instance.new("TextLabel")
AbilityLabel.BackgroundTransparency = 1
AbilityLabel.Position = UDim2.new(0.05, 0, 0.85, 0)
AbilityLabel.Size = UDim2.new(0.9, 0, 0, 20)
AbilityLabel.Font = Enum.Font.GothamBold
AbilityLabel.Text = "🌀 TIME CONTROL + CLONE ARMY"
AbilityLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
AbilityLabel.TextSize = 11
AbilityLabel.TextXAlignment = Enum.TextXAlignment.Left
AbilityLabel.Parent = StatsFrame

-- 🚀 GOD MODE ACTIVATION BUTTON
local ToggleButton = Instance.new("TextButton")
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleButton.Position = UDim2.new(0.08, 0, 0.75, 0)
ToggleButton.Size = UDim2.new(0.84, 0, 0, 80)
ToggleButton.Font = Enum.Font.GothamBlack
ToggleButton.Text = "BREAK REALITY"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 24
ToggleButton.Parent = Frame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 16)
ButtonCorner.Parent = ToggleButton

local ButtonGradient = Instance.new("UIGradient")
ButtonGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 215, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
})
ButtonGradient.Rotation = 90
ButtonGradient.Parent = ToggleButton

-- 🚀 REALITY DISTORTION EFFECTS
local function createRealityDistortion()
    -- Warp lighting
    local bloom = Instance.new("BloomEffect")
    bloom.Intensity = 2
    bloom.Size = 24
    bloom.Threshold = 0.8
    bloom.Parent = Lighting
    
    local blur = Instance.new("BlurEffect")
    blur.Size = 8
    blur.Parent = Lighting
    
    -- Create reality warp particles
    for i = 1, 20 do
        local particle = Instance.new("Part")
        particle.Size = Vector3.new(2, 2, 2)
        particle.Position = RootPart.Position + Vector3.new(
            math.random(-50, 50),
            math.random(-10, 10),
            math.random(-50, 50)
        )
        particle.Anchored = true
        particle.CanCollide = false
        particle.Material = Enum.Material.Neon
        particle.Color = Color3.fromRGB(math.random(200, 255), math.random(200, 255), 255)
        particle.Transparency = 0.3
        particle.Shape = Enum.PartType.Ball
        particle.Parent = FXFolder
        
        TweenService:Create(particle, TweenInfo.new(3), {
            Position = particle.Position + Vector3.new(math.random(-20, 20), math.random(-20, 20), math.random(-20, 20)),
            Transparency = 1
        }):Play()
        Debris:AddItem(particle, 3)
    end
end

-- 🚀 TIME CONTROL SYSTEM
local function slowTime()
    if not TIME_CONTROL or not UI_ENABLED then return end
    
    isTimeSlowed = true
    Lighting.ClockTime = 0.1 -- Make it dark
    Lighting.Brightness = 0.2
    
    -- Slow down other players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = humanoid.WalkSpeed * 0.1 -- 90% slower
            end
        end
    end
    
    -- Visual time distortion
    createRealityDistortion()
end

local function restoreTime()
    if not isTimeSlowed then return end
    
    isTimeSlowed = false
    Lighting.ClockTime = 14 -- Back to normal
    Lighting.Brightness = 1
    
    -- Restore other players' speed
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16 -- Normal speed
            end
        end
    end
end

-- 🚀 CLONE ARMY SYSTEM
local function createCloneArmy()
    if not CLONE_ARMY or not UI_ENABLED then return end
    
    -- Clear old clones
    for _, clone in pairs(activeClones) do
        if clone and clone.Parent then
            clone:Destroy()
        end
    end
    activeClones = {}
    
    -- Create 8 god clones
    for i = 1, 8 do
        local clone = Character:Clone()
        clone.Name = "GodClone_" .. i
        
        -- Make clones invincible and powerful
        for _, part in pairs(clone:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Material = Enum.Material.Neon
                part.Color = Color3.fromRGB(255, 215, 0)
                part.Transparency = 0.3
            end
        end
        
        -- Position clones in a circle around player
        local angle = (i / 8) * math.pi * 2
        local radius = 10
        local clonePos = RootPart.Position + Vector3.new(
            math.cos(angle) * radius,
            0,
            math.sin(angle) * radius
        )
        
        local cloneRoot = clone:FindFirstChild("HumanoidRootPart")
        if cloneRoot then
            cloneRoot.CFrame = CFrame.new(clonePos)
        end
        
        clone.Parent = workspace
        table.insert(activeClones, clone)
        
        -- Make clones attack nearby players
        spawn(function()
            while clone and clone.Parent and UI_ENABLED do
                wait(0.5)
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                        if targetRoot and cloneRoot then
                            local distance = (targetRoot.Position - cloneRoot.Position).Magnitude
                            if distance < 30 then
                                -- Teleport clone to attack
                                cloneRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -5)
                                createShockwave(cloneRoot.Position)
                            end
                        end
                    end
                end
            end
        end)
    end
end

-- 🚀 ENHANCED AURA SYSTEM
local auraObjects = {}

local function destroyAura()
    for _, obj in pairs(auraObjects) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    auraObjects = {}
end

local function createGodAura()
    destroyAura()
    
    -- Main god aura (MASSIVE)
    local aura = Instance.new("Part")
    aura.Name = "GodAura"
    aura.Size = Vector3.new(30, 30, 30)
    aura.Anchored = true
    aura.CanCollide = false
    aura.Material = Enum.Material.Neon
    aura.Color = Color3.fromRGB(255, 215, 0)
    aura.Transparency = 0.4
    aura.Shape = Enum.PartType.Ball
    aura.CFrame = RootPart.CFrame
    aura.Parent = FXFolder
    table.insert(auraObjects, aura)
    
    -- Multiple rotating god rings
    for i = 1, 8 do
        local ring = Instance.new("Part")
        ring.Size = Vector3.new(1, 20 + (i * 8), 20 + (i * 8))
        ring.Anchored = true
        ring.CanCollide = false
        ring.Material = Enum.Material.Neon
        ring.Color = Color3.fromRGB(255, 50, 255)
        ring.Transparency = 0.5
        ring.CFrame = RootPart.CFrame
        ring.Parent = FXFolder
        
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.Cylinder
        mesh.Parent = ring
        
        table.insert(auraObjects, ring)
    end
    
    -- Floating energy orbs
    for i = 1, 12 do
        local orb = Instance.new("Part")
        orb.Size = Vector3.new(3, 3, 3)
        orb.Anchored = true
        orb.CanCollide = false
        orb.Material = Enum.Material.Neon
        orb.Color = Color3.fromRGB(0, 255, 255)
        orb.Transparency = 0.3
        orb.Shape = Enum.PartType.Ball
        orb.Parent = FXFolder
        table.insert(auraObjects, orb)
    end
    
    return aura
end

-- 🚀 ENHANCED SHOCKWAVE (REALITY-SHATTERING)
local function createShockwave(position)
    if not SHOCKWAVE_ENABLED then return end
    
    -- Main shockwave
    local shockwave = Instance.new("Part")
    shockwave.Size = Vector3.new(1, 1, 1)
    shockwave.Position = position
    shockwave.Anchored = true
    shockwave.CanCollide = false
    shockwave.Material = Enum.Material.Neon
    shockwave.Color = Color3.fromRGB(255, 215, 0)
    shockwave.Transparency = 0.1
    shockwave.Shape = Enum.PartType.Ball
    shockwave.Parent = FXFolder
    
    -- Expand to MASSIVE size
    TweenService:Create(shockwave, TweenInfo.new(1), {
        Size = Vector3.new(100, 100, 100),
        Transparency = 1
    }):Play()
    
    -- Launch EVERYONE to space
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local theirRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if theirRoot then
                local distance = (theirRoot.Position - position).Magnitude
                if distance < 50 then -- Larger radius
                    -- Launch to space with extreme force
                    theirRoot.Velocity = Vector3.new(0, 2000, 0) -- YEET TO SPACE
                end
            end
        end
    end
    
    Debris:AddItem(shockwave, 1)
end

-- 🚀 INFINITE DODGE SYSTEM
local function godDodge()
    if not UI_ENABLED then return end
    
    dodgeCount = dodgeCount + 1
    DodgeLabel.Text = "⚡ DODGES: " .. dodgeCount .. " (INFINITE)"
    
    -- Always have max energy
    uiEnergy = 100
    EnergyLabel.Text = "🔋 ENERGY: INFINITE%"
    
    -- Create multiple dodge effects
    for i = 1, 5 do
        local dodgePos = RootPart.Position + Vector3.new(
            math.random(-10, 10),
            0,
            math.random(-10, 10)
        )
        createDodgeEffect(dodgePos)
    end
    
    -- 50% chance to trigger time slow on dodge
    if math.random(1, 2) == 1 then
        slowTime()
    end
end

-- 🚀 MAIN GOD MODE SYSTEM
local function startGodMode()
    -- Disconnect previous connections
    if DodgeConnection then DodgeConnection:Disconnect() end
    if AuraConnection then AuraConnection:Disconnect() end
    if ProximityConnection then ProximityConnection:Disconnect() end
    if AfterimageConnection then AfterimageConnection:Disconnect() end
    if PredictionConnection then PredictionConnection:Disconnect() end
    if TimeControlConnection then TimeControlConnection:Disconnect() end
    if CloneConnection then CloneConnection:Disconnect() end
    if RealityConnection then RealityConnection:Disconnect() end
    
    -- ULTIMATE SPEED BOOST
    local speedMultiplier = UI_MODE == "REALITY_BREAKER" and SPEED_BOOST_REALITY or 
                           UI_MODE == "MASTERED" and SPEED_BOOST_MASTERED or SPEED_BOOST_SIGN
    Humanoid.WalkSpeed = 16 * speedMultiplier
    SpeedLabel.Text = "💨 SPEED: " .. speedMultiplier .. "x (GOD)"
    
    -- Create god aura
    local aura = createGodAura()
    
    -- 🚀 REALITY MANIPULATION CONNECTION
    RealityConnection = RunService.Heartbeat:Connect(function()
        if not UI_ENABLED then return end
        
        -- Warp reality visuals
        if math.random(1, 30) == 1 then
            createRealityDistortion()
        end
        
        -- Infinite energy
        uiEnergy = 100
    end)
    
    -- 🚀 AUTO-DODGE EVERYTHING
    DodgeConnection = RunService.Heartbeat:Connect(function()
        if not UI_ENABLED then return end
        
        -- Dodge any velocity above threshold
        if RootPart.Velocity.Magnitude > VELOCITY_THRESHOLD then
            godDodge()
            
            -- Teleport to safe position
            local safePos = RootPart.Position + Vector3.new(
                math.random(-DODGE_DISTANCE, DODGE_DISTANCE),
                0,
                math.random(-DODGE_DISTANCE, DODGE_DISTANCE)
            )
            RootPart.CFrame = CFrame.new(safePos)
        end
        
        -- Randomly create shockwaves
        if math.random(1, 60) == 1 then
            createShockwave(RootPart.Position + Vector3.new(math.random(-20, 20), 0, math.random(-20, 20)))
        end
    end)
    
    -- 🚀 ACTIVATE CLONE ARMY
    if CLONE_ARMY then
        createCloneArmy()
    end
    
    -- 🚀 SLOW TIME INITIALLY
    if TIME_CONTROL then
        slowTime()
    end
    
    print("🚀 REALITY BREAKER MODE ACTIVATED!")
    print("💥 TRANSCENDING ALL LIMITS!")
    print("🌌 BECOMING ABSOLUTE GOD!")
end

local function stopGodMode()
    -- Disconnect all connections
    if DodgeConnection then DodgeConnection:Disconnect() end
    if AuraConnection then AuraConnection:Disconnect() end
    if ProximityConnection then ProximityConnection:Disconnect() end
    if AfterimageConnection then AfterimageConnection:Disconnect() end
    if PredictionConnection then PredictionConnection:Disconnect() end
    if TimeControlConnection then TimeControlConnection:Disconnect() end
    if CloneConnection then CloneConnection:Disconnect() end
    if RealityConnection then RealityConnection:Disconnect() end
    
    -- Restore normal state
    Humanoid.WalkSpeed = 16
    restoreTime()
    destroyAura()
    
    -- Clear clones
    for _, clone in pairs(activeClones) do
        if clone and clone.Parent then
            clone:Destroy()
        end
    end
    activeClones = {}
end

-- 🚀 MODE CYCLING SYSTEM
local modes = {"SIGN", "MASTERED", "REALITY_BREAKER"}
local currentModeIndex = 3 -- Start with REALITY_BREAKER

ModeToggle.MouseButton1Click:Connect(function()
    currentModeIndex = currentModeIndex % #modes + 1
    UI_MODE = modes[currentModeIndex]
    
    if UI_MODE == "REALITY_BREAKER" then
        ModeLabel.Text = "🌌 MODE: REALITY BREAKER 🌌"
        ModeLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
        Frame.BorderColor3 = Color3.fromRGB(255, 255, 0)
    elseif UI_MODE == "MASTERED" then
        ModeLabel.Text = "🌟 MODE: ULTRA MASTERED 🌟"
        ModeLabel.TextColor3 = Color3.fromRGB(150, 220, 255)
        Frame.BorderColor3 = Color3.fromRGB(150, 200, 255)
    else
        ModeLabel.Text = "⚡ MODE: SIGN OMEN ⚡"
        ModeLabel.TextColor3 = Color3.fromRGB(100, 150, 200)
        Frame.BorderColor3 = Color3.fromRGB(100, 150, 200)
    end
    
    if UI_ENABLED then
        stopGodMode()
        wait(0.1)
        startGodMode()
    end
end)

-- 🚀 ACTIVATE GOD MODE
ToggleButton.MouseButton1Click:Connect(function()
    UI_ENABLED = not UI_ENABLED
    
    if UI_ENABLED then
        ToggleButton.Text = "CONTROL REALITY"
        StatusLabel.Text = "⚡ REALITY SHATTERED ⚡"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
        startGodMode()
    else
        ToggleButton.Text = "BREAK REALITY"
        StatusLabel.Text = "🔴 REALITY LOCKED 🔴"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        stopGodMode()
    end
end)

-- Character respawn handling
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
    wait(0.5)
    if UI_ENABLED then
        startGodMode()
    end
end)

print("🚀🌌 REALITY BREAKER ULTRA INSTINCT LOADED 🌌🚀")
print("💥 TRANSCENDING BEYOND MAXIMUM POWER!")
print("🌠 TIME MANIPULATION: ACTIVE")
print("👥 CLONE ARMY: DEPLOYED") 
print("🌀 REALITY DISTORTION: ENGAGED")
print("⚡ INFINITE DODGES: ENABLED")
print("💨 GOD-LIKE SPEED: 25x MOVEMENT")
print("🚀 BECOME THE ABSOLUTE GOD OF THIS REALITY!")
