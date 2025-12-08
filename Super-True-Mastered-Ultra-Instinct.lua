-- GOD'S ULTRA INSTINCT - PURE DEFENSE EDITION
-- Ultra Instinct focused purely on dodging and defense

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

-- MODE SETTINGS
local UI_ENABLED = false
local CURRENT_MODE = "MASTERED"

-- ENHANCED DEFENSE STATS
local VELOCITY_THRESHOLD = {
    MASTERED = 200,
    PERFECTION = 150,
    SUPERSKKSKSJSJSJ = 50,
    ULTRA_GOD = 10
}

local DODGE_DISTANCE = {
    MASTERED = 30,
    PERFECTION = 45,
    SUPERSKKSKSJSJSJ = 75,
    ULTRA_GOD = 120
}

local SPEED_BOOST = {
    MASTERED = 3.0,
    PERFECTION = 4.5,
    SUPERSKKSKSJSJSJ = 7.0,
    ULTRA_GOD = 12.0
}

local PROXIMITY_RANGE = 20
local AFTERIMAGE_INTERVAL = {
    MASTERED = 0.06,
    PERFECTION = 0.04,
    SUPERSKKSKSJSJSJ = 0.005,
    ULTRA_GOD = 0.001
}

-- NEW: PREDICTIVE DODGE SYSTEM
local PREDICTION_TIME = {
    MASTERED = 0.1,
    PERFECTION = 0.2,
    SUPERSKKSKSJSJSJ = 0.5,
    ULTRA_GOD = 1.0
}

local DODGE_CHAIN_BONUS = {
    MASTERED = 1.0,
    PERFECTION = 1.2,
    SUPERSKKSKSJSJSJ = 1.5,
    ULTRA_GOD = 2.0
}

-- NEW: INVINCIBILITY FRAMES
local IFRAME_DURATION = {
    MASTERED = 0.2,
    PERFECTION = 0.3,
    SUPERSKKSKSJSJSJ = 0.5,
    ULTRA_GOD = 1.0
}

-- NEW: ENERGY SHIELD SYSTEM
local SHIELD_HEALTH = {
    MASTERED = 100,
    PERFECTION = 250,
    SUPERSKKSKSJSJSJ = 1000,
    ULTRA_GOD = 5000
}

-- NEW: MULTI-DODGE CAPABILITY
local MAX_CHAIN_DODGES = {
    MASTERED = 2,
    PERFECTION = 3,
    SUPERSKKSKSJSJSJ = 5,
    ULTRA_GOD = 10
}

-- DEFENSE VARIABLES
local dodgeCount = 0
local dodgeChain = 0
local lastAfterimage = 0
local shieldHealth = 0
local shieldActive = false
local iframeActive = false
local predictiveDodgeActive = false
local lastPerfectDodge = 0
local perfectDodgeStreak = 0

-- TRACKING
local incomingAttacks = {}
local threatLevel = 0
local threatDirection = Vector3.new()

-- Connections
local DodgeConnection, AuraConnection, ProximityConnection, AfterimageConnection
local PredictionConnection, ShieldConnection, ThreatAnalysisConnection

-- Effects Folder
local FXFolder = Instance.new("Folder", workspace)
FXFolder.Name = "GodUI_FX"

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GodUIGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Create GUI Frame
local Frame = Instance.new("Frame")
Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Frame.BorderColor3 = Color3.fromRGB(100, 200, 255)
Frame.BorderSizePixel = 3
Frame.Position = UDim2.new(0.35, 0, 0.25, 0)
Frame.Size = UDim2.new(0, 320, 0, 380)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = Frame

local Header = Instance.new("Frame")
Header.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 45)
Header.Parent = Frame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 15)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ GOD'S ULTRA INSTINCT ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextScaled = true
Title.Parent = Header

local StatusLabel = Instance.new("TextLabel")
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.1, 0, 0.13, 0)
StatusLabel.Size = UDim2.new(0.8, 0, 0, 25)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Text = "🔴 DORMANT 🔴"
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.TextSize = 16
StatusLabel.Parent = Frame

-- Mode Selection
local ModeSelectFrame = Instance.new("Frame")
ModeSelectFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ModeSelectFrame.BorderSizePixel = 0
ModeSelectFrame.Position = UDim2.new(0.1, 0, 0.22, 0)
ModeSelectFrame.Size = UDim2.new(0.8, 0, 0, 110)
ModeSelectFrame.Parent = Frame

local ModeTitle = Instance.new("TextLabel")
ModeTitle.BackgroundTransparency = 1
ModeTitle.Position = UDim2.new(0, 0, 0, 5)
ModeTitle.Size = UDim2.new(1, 0, 0, 20)
ModeTitle.Font = Enum.Font.GothamBold
ModeTitle.Text = "⚡ SELECT DEFENSE MODE ⚡"
ModeTitle.TextColor3 = Color3.fromRGB(200, 220, 255)
ModeTitle.TextSize = 12
ModeTitle.Parent = ModeSelectFrame

local MasteredBtn = Instance.new("TextButton")
MasteredBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
MasteredBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
MasteredBtn.Size = UDim2.new(0.9, 0, 0, 20)
MasteredBtn.Font = Enum.Font.Gotham
MasteredBtn.Text = "🛡️ MASTERED"
MasteredBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MasteredBtn.TextSize = 11
MasteredBtn.Parent = ModeSelectFrame

local PerfectionBtn = Instance.new("TextButton")
PerfectionBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
PerfectionBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
PerfectionBtn.Size = UDim2.new(0.9, 0, 0, 20)
PerfectionBtn.Font = Enum.Font.Gotham
PerfectionBtn.Text = "💫 PERFECTION"
PerfectionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PerfectionBtn.TextSize = 11
PerfectionBtn.Parent = ModeSelectFrame

local SuperBtn = Instance.new("TextButton")
SuperBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
SuperBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
SuperBtn.Size = UDim2.new(0.9, 0, 0, 20)
SuperBtn.Font = Enum.Font.GothamBold
SuperBtn.Text = "💥 SUPERSKKSKSJSJSJ"
SuperBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SuperBtn.TextSize = 10
SuperBtn.Parent = ModeSelectFrame

local UltraBtn = Instance.new("TextButton")
UltraBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 50)
UltraBtn.Position = UDim2.new(0.05, 0, 0.85, 0)
UltraBtn.Size = UDim2.new(0.9, 0, 0, 20)
UltraBtn.Font = Enum.Font.GothamBold
UltraBtn.Text = "🌟 ULTRA GOD"
UltraBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
UltraBtn.TextSize = 10
UltraBtn.Parent = ModeSelectFrame

-- Stats Frame
local StatsFrame = Instance.new("Frame")
StatsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
StatsFrame.BorderSizePixel = 0
StatsFrame.Position = UDim2.new(0.1, 0, 0.52, 0)
StatsFrame.Size = UDim2.new(0.8, 0, 0, 120)
StatsFrame.Parent = Frame

local DodgeLabel = Instance.new("TextLabel")
DodgeLabel.BackgroundTransparency = 1
DodgeLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
DodgeLabel.Size = UDim2.new(0.9, 0, 0, 20)
DodgeLabel.Font = Enum.Font.Gotham
DodgeLabel.Text = "⚡ Dodges: 0"
DodgeLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
DodgeLabel.TextSize = 13
DodgeLabel.TextXAlignment = Enum.TextXAlignment.Left
DodgeLabel.Parent = StatsFrame

local ChainLabel = Instance.new("TextLabel")
ChainLabel.BackgroundTransparency = 1
ChainLabel.Position = UDim2.new(0.05, 0, 0.25, 0)
ChainLabel.Size = UDim2.new(0.9, 0, 0, 20)
ChainLabel.Font = Enum.Font.Gotham
ChainLabel.Text = "🔗 Chain: 0"
ChainLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
ChainLabel.TextSize = 13
ChainLabel.TextXAlignment = Enum.TextXAlignment.Left
ChainLabel.Parent = StatsFrame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Position = UDim2.new(0.05, 0, 0.45, 0)
SpeedLabel.Size = UDim2.new(0.9, 0, 0, 20)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Text = "💨 Speed: 3.0x"
SpeedLabel.TextColor3 = Color3.fromRGB(150, 255, 200)
SpeedLabel.TextSize = 13
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = StatsFrame

local ShieldLabel = Instance.new("TextLabel")
ShieldLabel.BackgroundTransparency = 1
ShieldLabel.Position = UDim2.new(0.05, 0, 0.65, 0)
ShieldLabel.Size = UDim2.new(0.9, 0, 0, 20)
ShieldLabel.Font = Enum.Font.Gotham
ShieldLabel.Text = "🛡️ Shield: 100%"
ShieldLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
ShieldLabel.TextSize = 13
ShieldLabel.TextXAlignment = Enum.TextXAlignment.Left
ShieldLabel.Parent = StatsFrame

local ThreatLabel = Instance.new("TextLabel")
ThreatLabel.BackgroundTransparency = 1
ThreatLabel.Position = UDim2.new(0.05, 0, 0.85, 0)
ThreatLabel.Size = UDim2.new(0.9, 0, 0, 20)
ThreatLabel.Font = Enum.Font.Gotham
ThreatLabel.Text = "⚠️ Threat: 0%"
ThreatLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
ThreatLabel.TextSize = 13
ThreatLabel.TextXAlignment = Enum.TextXAlignment.Left
ThreatLabel.Parent = StatsFrame

-- Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
ToggleButton.Position = UDim2.new(0.1, 0, 0.82, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0, 50)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "ACTIVATE DEFENSE"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 22
ToggleButton.Parent = Frame

-- NEW: PREDICTIVE DODGE VISUAL
local PredictionIndicator = Instance.new("Frame")
PredictionIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
PredictionIndicator.BackgroundTransparency = 0.7
PredictionIndicator.BorderSizePixel = 0
PredictionIndicator.Size = UDim2.new(0, 10, 0, 10)
PredictionIndicator.AnchorPoint = Vector2.new(0.5, 0.5)
PredictionIndicator.Position = UDim2.new(0.5, 0, 0.5, 0)
PredictionIndicator.Visible = false
PredictionIndicator.Parent = ScreenGui

-- NEW: SHIELD VISUAL
local ShieldVisual = Instance.new("Part")
ShieldVisual.Name = "EnergyShield"
ShieldVisual.Shape = Enum.PartType.Ball
ShieldVisual.Material = Enum.Material.Neon
ShieldVisual.Transparency = 0.7
ShieldVisual.Anchored = true
ShieldVisual.CanCollide = false
ShieldVisual.Visible = false
ShieldVisual.Parent = FXFolder

-- NEW: GODLY AURA SYSTEM
local function createDivineAura()
    local auraSize, auraColor
    
    if CURRENT_MODE == "ULTRA_GOD" then
        auraSize = 15
        auraColor = Color3.fromRGB(255, 255, 255)
    elseif CURRENT_MODE == "SUPERSKKSKSJSJSJ" then
        auraSize = 12
        auraColor = Color3.fromHSV(tick() % 1, 1, 1)
    elseif CURRENT_MODE == "PERFECTION" then
        auraSize = 10
        auraColor = Color3.fromRGB(200, 150, 255)
    else
        auraSize = 8
        auraColor = Color3.fromRGB(100, 150, 255)
    end
    
    local aura = Instance.new("Part")
    aura.Name = "DivineAura"
    aura.Size = Vector3.new(auraSize, auraSize, auraSize)
    aura.Position = RootPart.Position
    aura.Anchored = true
    aura.CanCollide = false
    aura.Material = Enum.Material.Neon
    aura.Color = auraColor
    aura.Transparency = 0.3
    aura.Shape = Enum.PartType.Ball
    aura.Parent = FXFolder
    
    -- Divine effects
    local light = Instance.new("PointLight")
    light.Parent = aura
    light.Color = auraColor
    light.Brightness = 10
    light.Range = 25
    
    -- Energy particles
    local particles = Instance.new("ParticleEmitter")
    particles.Parent = aura
    particles.Texture = "rbxassetid://242719275"
    particles.Rate = 50
    particles.Lifetime = NumberRange.new(0.5, 1.5)
    particles.Speed = NumberRange.new(5, 15)
    particles.Size = NumberSequence.new(0.2, 0.5)
    particles.Transparency = NumberSequence.new(0.3, 1)
    particles.Color = ColorSequence.new(auraColor)
    particles.Rotation = NumberRange.new(0, 360)
    
    if CURRENT_MODE == "ULTRA_GOD" then
        -- Divine light beams
        for i = 1, 8 do
            local beam = Instance.new("Part")
            beam.Size = Vector3.new(0.5, 20, 0.5)
            beam.Color = Color3.fromRGB(255, 255, 255)
            beam.Material = Enum.Material.Neon
            beam.Transparency = 0.4
            beam.Anchored = true
            beam.CanCollide = false
            beam.Parent = aura
            
            local angle = (i / 8) * math.pi * 2
            beam.CFrame = aura.CFrame * CFrame.new(0, 10, 0) * CFrame.Angles(0, angle, 0)
            
            TweenService:Create(beam, TweenInfo.new(0.5), {Transparency = 1}):Play()
            Debris:AddItem(beam, 0.5)
        end
    end
    
    return aura
end

-- NEW: PREDICTIVE DODGE SYSTEM
local function predictThreats()
    if not UI_ENABLED then return end
    
    local threats = {}
    local maxThreat = 0
    threatDirection = Vector3.new()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local target = player.Character:FindFirstChild("HumanoidRootPart")
            if target then
                local direction = (target.Position - RootPart.Position)
                local distance = direction.Magnitude
                
                if distance < 50 then
                    local velocity = target.Velocity
                    local predictedPosition = target.Position + velocity * PREDICTION_TIME[CURRENT_MODE]
                    local predictedDirection = (predictedPosition - RootPart.Position)
                    local speed = velocity.Magnitude
                    
                    local threat = math.min(100, (100 / distance) * speed)
                    if threat > maxThreat then
                        maxThreat = threat
                        threatDirection = predictedDirection.Unit
                    end
                    
                    table.insert(threats, {
                        position = target.Position,
                        velocity = velocity,
                        threat = threat
                    })
                end
            end
        end
    end
    
    threatLevel = maxThreat
    ThreatLabel.Text = string.format("⚠️ Threat: %d%%", math.floor(threatLevel))
    
    -- Update prediction indicator
    if threatLevel > 30 and threatDirection.Magnitude > 0 then
        local screenPoint = Workspace.CurrentCamera:WorldToViewportPoint(
            RootPart.Position + threatDirection * 10
        )
        PredictionIndicator.Position = UDim2.new(0, screenPoint.X, 0, screenPoint.Y)
        PredictionIndicator.Visible = true
        
        local color = Color3.fromRGB(
            math.clamp(threatLevel * 2.55, 0, 255),
            math.clamp(255 - threatLevel * 2.55, 0, 255),
            0
        )
        PredictionIndicator.BackgroundColor3 = color
    else
        PredictionIndicator.Visible = false
    end
    
    incomingAttacks = threats
end

-- NEW: PERFECT DODGE DETECTION
local function isPerfectDodge(threatLevel, distance)
    if threatLevel > 80 then
        return "PERFECT"
    elseif threatLevel > 50 then
        return "GOOD"
    else
        return "NORMAL"
    end
end

-- NEW: MULTI-DODGE CAPABILITY
local function performChainDodge(basePosition)
    if dodgeChain >= MAX_CHAIN_DODGES[CURRENT_MODE] then
        dodgeChain = 0
        return
    end
    
    local chainMultiplier = 1 + (dodgeChain * DODGE_CHAIN_BONUS[CURRENT_MODE])
    local chainDistance = DODGE_DISTANCE[CURRENT_MODE] * chainMultiplier
    
    -- Find safest direction for chain dodge
    local safeDirection = Vector3.new()
    local maxSafety = 0
    
    for angle = 0, 360, 45 do
        local rad = math.rad(angle)
        local testDir = Vector3.new(math.cos(rad), 0, math.sin(rad))
        local safety = 0
        
        for _, threat in pairs(incomingAttacks) do
            local dot = testDir:Dot((threat.position - RootPart.Position).Unit)
            if dot < 0 then
                safety = safety + 10
            end
        end
        
        if safety > maxSafety then
            maxSafety = safety
            safeDirection = testDir
        end
    end
    
    if safeDirection.Magnitude == 0 then
        safeDirection = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit
    end
    
    local dodgePos = RootPart.Position + (safeDirection * chainDistance)
    dodgePos = Vector3.new(
        dodgePos.X,
        RootPart.Position.Y,
        dodgePos.Z
    )
    
    RootPart.CFrame = CFrame.new(dodgePos)
    createDodgeEffect(RootPart.Position)
    dodgeChain = dodgeChain + 1
    ChainLabel.Text = string.format("🔗 Chain: %d", dodgeChain)
end

-- ENHANCED AFTERIMAGE EFFECT
local function createAfterimage()
    if tick() - lastAfterimage < AFTERIMAGE_INTERVAL[CURRENT_MODE] then
        return
    end
    
    lastAfterimage = tick()
    local color
    
    if CURRENT_MODE == "ULTRA_GOD" then
        color = Color3.fromRGB(255, 255, 255)
    elseif CURRENT_MODE == "SUPERSKKSKSJSJSJ" then
        color = Color3.fromHSV(math.random(), 1, 1)
    elseif CURRENT_MODE == "PERFECTION" then
        color = Color3.fromRGB(200, 150, 255)
    else
        color = Color3.fromRGB(100, 150, 255)
    end
    
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency < 1 and part.Name ~= "HumanoidRootPart" then
            local clone = part:Clone()
            clone.Anchored = true
            clone.CanCollide = false
            clone.Material = Enum.Material.Neon
            clone.Color = color
            clone.Transparency = 0.3
            clone.CFrame = part.CFrame
            clone.Parent = FXFolder
            
            for _, child in pairs(clone:GetChildren()) do
                if not child:IsA("SpecialMesh") then
                    child:Destroy()
                end
            end
            
            TweenService:Create(clone, TweenInfo.new(0.4), {Transparency = 1}):Play()
            Debris:AddItem(clone, 0.4)
        end
    end
end

-- GODLY DODGE EFFECT
local function createDodgeEffect(position)
    local particleCount, effectSize
    
    if CURRENT_MODE == "ULTRA_GOD" then
        particleCount = 50
        effectSize = 15
    elseif CURRENT_MODE == "SUPERSKKSKSJSJSJ" then
        particleCount = 30
        effectSize = 12
    elseif CURRENT_MODE == "PERFECTION" then
        particleCount = 20
        effectSize = 10
    else
        particleCount = 15
        effectSize = 8
    end
    
    local color = CURRENT_MODE == "ULTRA_GOD" and Color3.fromRGB(255, 255, 255) or
                  CURRENT_MODE == "SUPERSKKSKSJSJSJ" and Color3.fromHSV(tick() % 1, 1, 1) or
                  CURRENT_MODE == "PERFECTION" and Color3.fromRGB(200, 150, 255) or
                  Color3.fromRGB(100, 150, 255)
    
    -- Main burst
    local burst = Instance.new("Part")
    burst.Size = Vector3.new(effectSize, effectSize, effectSize)
    burst.Position = position
    burst.Anchored = true
    burst.CanCollide = false
    burst.Material = Enum.Material.Neon
    burst.Color = color
    burst.Transparency = 0.1
    burst.Shape = Enum.PartType.Ball
    burst.Parent = FXFolder
    
    -- Energy particles
    for i = 1, particleCount do
        local particle = Instance.new("Part")
        particle.Size = Vector3.new(0.5, 0.5, 0.5)
        particle.Position = position
        particle.Anchored = true
        particle.CanCollide = false
        particle.Material = Enum.Material.Neon
        particle.Color = color
        particle.Transparency = 0.2
        particle.Parent = FXFolder
        
        local angle = math.rad((i / particleCount) * 360)
        local distance = effectSize * 0.5
        local targetPos = position + Vector3.new(
            math.cos(angle) * distance,
            math.sin(angle * 2) * distance * 0.5,
            math.sin(angle) * distance
        )
        
        TweenService:Create(particle, TweenInfo.new(0.3), {
            Position = targetPos,
            Transparency = 1,
            Size = Vector3.new(0.1, 0.1, 0.1)
        }):Play()
        Debris:AddItem(particle, 0.3)
    end
    
    TweenService:Create(burst, TweenInfo.new(0.5), {
        Size = Vector3.new(effectSize * 3, effectSize * 3, effectSize * 3),
        Transparency = 1
    }):Play()
    Debris:AddItem(burst, 0.5)
    
    -- Sound effect
    if CURRENT_MODE == "ULTRA_GOD" then
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://9125323595" -- Divine sound
        sound.Volume = 1
        sound.Parent = workspace
        sound:Play()
        Debris:AddItem(sound, 3)
    end
end

-- NEW: ACTIVATE INVINCIBILITY FRAMES
local function activateIFrames()
    iframeActive = true
    
    -- Make character semi-transparent
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.LocalTransparencyModifier = 0.5
        end
    end
    
    -- Invincibility effect
    local iframeGlow = Instance.new("Part")
    iframeGlow.Size = Vector3.new(10, 10, 10)
    iframeGlow.Position = RootPart.Position
    iframeGlow.Anchored = true
    iframeGlow.CanCollide = false
    iframeGlow.Material = Enum.Material.Neon
    iframeGlow.Color = Color3.fromRGB(255, 255, 0)
    iframeGlow.Transparency = 0.7
    iframeGlow.Shape = Enum.PartType.Ball
    iframeGlow.Parent = FXFolder
    
    TweenService:Create(iframeGlow, TweenInfo.new(IFRAME_DURATION[CURRENT_MODE]), {
        Size = Vector3.new(20, 20, 20),
        Transparency = 1
    }):Play()
    Debris:AddItem(iframeGlow, IFRAME_DURATION[CURRENT_MODE])
    
    task.wait(IFRAME_DURATION[CURRENT_MODE])
    
    iframeActive = false
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.LocalTransparencyModifier = 0
        end
    end
end

-- ENHANCED DODGE SYSTEM
local function startUI()
    if DodgeConnection then DodgeConnection:Disconnect() end
    if AuraConnection then AuraConnection:Disconnect() end
    if ProximityConnection then ProximityConnection:Disconnect() end
    if AfterimageConnection then AfterimageConnection:Disconnect() end
    if PredictionConnection then PredictionConnection:Disconnect() end
    if ShieldConnection then ShieldConnection:Disconnect() end
    if ThreatAnalysisConnection then ThreatAnalysisConnection:Disconnect() end
    
    -- Speed boost
    Humanoid.WalkSpeed = 16 * SPEED_BOOST[CURRENT_MODE]
    SpeedLabel.Text = string.format("💨 Speed: %.1fx", SPEED_BOOST[CURRENT_MODE])
    
    -- Initialize shield
    shieldHealth = SHIELD_HEALTH[CURRENT_MODE]
    shieldActive = true
    ShieldLabel.Text = string.format("🛡️ Shield: 100%%")
    
    -- Create aura
    local aura = createDivineAura()
    
    -- Aura pulse effect
    AuraConnection = RunService.Heartbeat:Connect(function()
        if not UI_ENABLED or not aura.Parent then return end
        
        aura.Position = RootPart.Position
        aura.CFrame = aura.CFrame * CFrame.Angles(0, math.rad(15), 0)
        
        if CURRENT_MODE == "ULTRA_GOD" then
            aura.Color = Color3.fromRGB(255, 255, 255)
        elseif CURRENT_MODE == "SUPERSKKSKSJSJSJ" then
            aura.Color = Color3.fromHSV(tick() % 1, 1, 1)
        end
        
        local pulseSpeed = CURRENT_MODE == "ULTRA_GOD" and 10 or
                           CURRENT_MODE == "SUPERSKKSKSJSJSJ" and 8 or 5
        local pulseIntensity = CURRENT_MODE == "ULTRA_GOD" and 0.3 or 0.2
        local scale = 1 + math.sin(tick() * pulseSpeed) * pulseIntensity
        
        local baseSize = CURRENT_MODE == "ULTRA_GOD" and 15 or
                         CURRENT_MODE == "SUPERSKKSKSJSJSJ" and 12 or
                         CURRENT_MODE == "PERFECTION" and 10 or 8
        
        aura.Size = Vector3.new(baseSize * scale, baseSize * scale, baseSize * scale)
    end)
    
    -- Threat prediction
    PredictionConnection = RunService.Heartbeat:Connect(function()
        if not UI_ENABLED then return end
        predictThreats()
    end)
    
    -- Afterimage trail
    AfterimageConnection = RunService.Heartbeat:Connect(function()
        if not UI_ENABLED then return end
        if Humanoid.MoveDirection.Magnitude > 0 then
            createAfterimage()
        end
    end)
    
    -- ULTRA GOD effects
    if CURRENT_MODE == "ULTRA_GOD" then
        ThreatAnalysisConnection = RunService.Heartbeat:Connect(function()
            if not UI_ENABLED then return end
            
            -- Create divine trail
            if tick() % 0.1 < 0.05 then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        local spark = Instance.new("Part")
                        spark.Size = Vector3.new(0.2, 0.2, 0.2)
                        spark.Position = part.Position
                        spark.Anchored = true
                        spark.CanCollide = false
                        spark.Material = Enum.Material.Neon
                        spark.Color = Color3.fromRGB(255, 255, 255)
                        spark.Transparency = 0.3
                        spark.Parent = FXFolder
                        
                        TweenService:Create(spark, TweenInfo.new(0.5), {
                            Transparency = 1,
                            Size = Vector3.new(0, 0, 0)
                        }):Play()
                        Debris:AddItem(spark, 0.5)
                    end
                end
            end
        end)
    end
    
    -- MAIN DODGE LOGIC
    local lastPosition = RootPart.Position
    lastVelocity = RootPart.Velocity
    lastCheckTime = tick()
    
    DodgeConnection = RunService.Heartbeat:Connect(function()
        if not UI_ENABLED then return end
        
        local currentTime = tick()
        local deltaTime = currentTime - lastCheckTime
        local currentVelocity = RootPart.Velocity
        local velocityMagnitude = currentVelocity.Magnitude
        
        -- Check for threats that require dodging
        local shouldDodge = false
        local dodgeReason = ""
        
        -- Check velocity-based threats
        if velocityMagnitude > VELOCITY_THRESHOLD[CURRENT_MODE] and not Humanoid.MoveDirection.Magnitude > 0.5 then
            shouldDodge = true
            dodgeReason = "VELOCITY"
        end
        
        -- Check predicted threats
        if threatLevel > 70 then
            shouldDodge = true
            dodgeReason = "PREDICTION"
        end
        
        -- Check proximity to other players
        for _, threat in pairs(incomingAttacks) do
            local distance = (threat.position - RootPart.Position).Magnitude
            if distance < 10 then
                shouldDodge = true
                dodgeReason = "PROXIMITY"
                break
            end
        end
        
        if shouldDodge then
            dodgeCount = dodgeCount + 1
            DodgeLabel.Text = string.format("⚡ Dodges: %d", dodgeCount)
            
            -- Determine dodge quality
            local dodgeQuality = isPerfectDodge(threatLevel, velocityMagnitude)
            
            if dodgeQuality == "PERFECT" then
                perfectDodgeStreak = perfectDodgeStreak + 1
                lastPerfectDodge = currentTime
                
                -- Activate invincibility frames for perfect dodges
                if not iframeActive then
                    activateIFrames()
                end
                
                -- Chain dodge if available
                if dodgeChain < MAX_CHAIN_DODGES[CURRENT_MODE] then
                    performChainDodge(RootPart.Position)
                end
            else
                perfectDodgeStreak = 0
            end
            
            -- Calculate dodge position
            local dodgeFrom = RootPart.Position
            local dodgeDirection
            
            if dodgeReason == "PREDICTION" and threatDirection.Magnitude > 0 then
                -- Dodge away from predicted threat
                dodgeDirection = -threatDirection
            else
                -- Random safe direction
                dodgeDirection = Vector3.new(
                    math.random(-100, 100),
                    0,
                    math.random(-100, 100)
                ).Unit
            end
            
            local dodgeDistance = DODGE_DISTANCE[CURRENT_MODE] * (1 + (dodgeChain * 0.2))
            local dodgePosition = RootPart.Position + (dodgeDirection * dodgeDistance)
            
            dodgePosition = Vector3.new(
                dodgePosition.X,
                RootPart.Position.Y,
                dodgePosition.Z
            )
            
            -- Perform the dodge
            RootPart.CFrame = CFrame.new(dodgePosition)
            RootPart.Velocity = Vector3.new(0, 0, 0)
            RootPart.RotVelocity = Vector3.new(0, 0, 0)
            
            -- Create effects
            createDodgeEffect(dodgeFrom)
            createDodgeEffect(dodgePosition)
            
            -- Shield absorbs impact if active
            if shieldActive then
                local damage = math.min(velocityMagnitude * 0.1, 50)
                shieldHealth = math.max(0, shieldHealth - damage)
                local shieldPercent = math.floor((shieldHealth / SHIELD_HEALTH[CURRENT_MODE]) * 100)
                ShieldLabel.Text = string.format("🛡️ Shield: %d%%", shieldPercent)
                
                if shieldHealth <= 0 then
                    shieldActive = false
                    ShieldLabel.Text = "🛡️ Shield: BROKEN"
                end
            end
            
            -- Visual feedback
            Header.BackgroundColor3 = dodgeQuality == "PERFECT" and Color3.fromRGB(255, 255, 0) or
                                      dodgeQuality == "GOOD" and Color3.fromRGB(100, 255, 100) or
                                      Color3.fromRGB(100, 200, 255)
            
            task.wait(0.1)
            
            -- Restore header color
            if CURRENT_MODE == "ULTRA_GOD" then
                Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            elseif CURRENT_MODE == "SUPERSKKSKSJSJSJ" then
                Header.BackgroundColor3 = Color3.fromHSV(tick() % 1, 1, 1)
            else
                Header.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
            end
        end
        
        -- Reset dodge chain if too much time passes
        if currentTime - lastPerfectDodge > 2 then
            dodgeChain = 0
            ChainLabel.Text = "🔗 Chain: 0"
        end
        
        lastVelocity = currentVelocity
        lastCheckTime = currentTime
    end)
    
    -- SHIELD REGENERATION
    ShieldConnection = RunService.Heartbeat:Connect(function()
        if not UI_ENABLED then return end
        
        if shieldHealth < SHIELD_HEALTH[CURRENT_MODE] then
            local regenRate = CURRENT_MODE == "ULTRA_GOD" and 20 or
                              CURRENT_MODE == "SUPERSKKSKSJSJSJ" and 10 or 5
            shieldHealth = math.min(SHIELD_HEALTH[CURRENT_MODE], shieldHealth + regenRate * 0.016)
            
            if not shieldActive then
                shieldActive = true
            end
            
            local shieldPercent = math.floor((shieldHealth / SHIELD_HEALTH[CURRENT_MODE]) * 100)
            ShieldLabel.Text = string.format("🛡️ Shield: %d%%", shieldPercent)
        end
    end)
end

local function stopUI()
    if DodgeConnection then DodgeConnection:Disconnect() end
    if AuraConnection then AuraConnection:Disconnect() end
    if ProximityConnection then ProximityConnection:Disconnect() end
    if AfterimageConnection then AfterimageConnection:Disconnect() end
    if PredictionConnection then PredictionConnection:Disconnect() end
    if ShieldConnection then ShieldConnection:Disconnect() end
    if ThreatAnalysisConnection then ThreatAnalysisConnection:Disconnect() end
    
    Humanoid.WalkSpeed = 16
    PredictionIndicator.Visible = false
    ShieldVisual.Visible = false
    shieldActive = false
    iframeActive = false
    dodgeChain = 0
    
    for _, v in pairs(FXFolder:GetChildren()) do
        v:Destroy()
    end
end

-- MODE SELECTION
MasteredBtn.MouseButton1Click:Connect(function()
    CURRENT_MODE = "MASTERED"
    ChainLabel.Text = "🔗 Chain: 0"
    SpeedLabel.Text = "💨 Speed: 3.0x"
    Frame.BorderColor3 = Color3.fromRGB(100, 200, 255)
    if UI_ENABLED then
        stopUI()
        task.wait(0.1)
        startUI()
    end
end)

PerfectionBtn.MouseButton1Click:Connect(function()
    CURRENT_MODE = "PERFECTION"
    ChainLabel.Text = "🔗 Chain: 0"
    SpeedLabel.Text = "💨 Speed: 4.5x"
    Frame.BorderColor3 = Color3.fromRGB(200, 150, 255)
    if UI_ENABLED then
        stopUI()
        task.wait(0.1)
        startUI()
    end
end)

SuperBtn.MouseButton1Click:Connect(function()
    CURRENT_MODE = "SUPERSKKSKSJSJSJ"
    ChainLabel.Text = "🔗 Chain: 0"
    SpeedLabel.Text = "💨 Speed: 7.0x"
    if UI_ENABLED then
        stopUI()
        task.wait(0.1)
        startUI()
    end
end)

UltraBtn.MouseButton1Click:Connect(function()
    CURRENT_MODE = "ULTRA_GOD"
    ChainLabel.Text = "🔗 Chain: 0"
    SpeedLabel.Text = "💨 Speed: 12.0x"
    Frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
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
        ToggleButton.Text = "ACTIVE"
        
        local headerColor = CURRENT_MODE == "ULTRA_GOD" and Color3.fromRGB(255, 255, 255) or
                            CURRENT_MODE == "SUPERSKKSKSJSJSJ" and Color3.fromHSV(tick() % 1, 1, 1) or
                            CURRENT_MODE == "PERFECTION" and Color3.fromRGB(200, 150, 255) or
                            Color3.fromRGB(100, 200, 255)
        
        ToggleButton.BackgroundColor3 = headerColor
        Header.BackgroundColor3 = headerColor
        StatusLabel.Text = "⚡ GOD MODE ACTIVE ⚡"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        startUI()
    else
        ToggleButton.Text = "ACTIVATE DEFENSE"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        Header.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
        StatusLabel.Text = "🔴 DORMANT 🔴"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        Frame.BorderColor3 = Color3.fromRGB(100, 200, 255)
        stopUI()
    end
end)

-- Character respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
    dodgeCount = 0
    dodgeChain = 0
    DodgeLabel.Text = "⚡ Dodges: 0"
    ChainLabel.Text = "🔗 Chain: 0"
    lastVelocity = Vector3.new(0, 0, 0)
    shieldHealth = SHIELD_HEALTH[CURRENT_MODE]
    shieldActive = false
    task.wait(0.5)
    if UI_ENABLED then
        startUI()
    end
end)

print("✅ GOD'S ULTRA INSTINCT LOADED SUCCESSFULLY!")
print("⚡ PURE DEFENSE MODE - NO ATTACKS")
print("🌟 4 DEFENSE MODES AVAILABLE")
print("🛡️ Energy Shield System Active")
print("⚡ Predictive Dodge System Enabled")
print("💫 Chain Dodging Available")
print("🌟 ULTRA GOD: Maximum defense capabilities")
print("🎮 GUI: Click 'ACTIVATE DEFENSE' to begin!")
