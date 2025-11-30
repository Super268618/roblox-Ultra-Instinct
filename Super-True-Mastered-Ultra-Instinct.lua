-- ADVANCED TRUE MASTERED ULTRA INSTINCT - ULTIMATE EVOLUTION
-- Beyond Perfection - The Pinnacle of Ultra Instinct Technology

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- 🚀 QUANTUM UI SETTINGS
local UI_ENABLED = false
local UI_MODE = "PERFECTED" -- BASIC, MASTERED, PERFECTED
local VELOCITY_THRESHOLD = 65
local DODGE_DISTANCE = 15
local SPEED_BOOST_BASIC = 2.5
local SPEED_BOOST_MASTERED = 4.0
local SPEED_BOOST_PERFECTED = 6.0
local AFTERIMAGE_INTERVAL = 0.04
local THREAT_DETECTION_RANGE = 40
local PREDICTION_TIME = 0.4
local ENERGY_DODGE_COST = 8
local ENERGY_REGEN_RATE = 3
local MUSCLE_MEMORY_DURATION = 10

-- Quantum Systems
local Connections = {}
local ThreatDatabase = {}
local MuscleMemory = {}
local AttackPatterns = {}
local dodgeCount = 0
local perfectDodgeCount = 0
local lastAfterimage = 0
local uiEnergy = 100
local lastDodgeTime = 0
local dodgeCooldown = 0.12
local instinctLevel = 0
local combatExperience = 0

-- Effects System
local FXFolder = Instance.new("Folder", workspace)
FXFolder.Name = "QuantumUIFX"

-- 🚀 QUANTUM UI GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QuantumUIGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
MainFrame.BorderColor3 = Color3.fromRGB(180, 200, 255)
MainFrame.BorderSizePixel = 3
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 350, 0, 280)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 25)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 20, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 25))
})
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.BackgroundColor3 = Color3.fromRGB(180, 200, 255)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 45)
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 15)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Font = Enum.Font.GothamBlack
Title.Text = "🌌 QUANTUM ULTRA INSTINCT 🌌"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Parent = Header

-- Status Display
local StatusFrame = Instance.new("Frame")
StatusFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
StatusFrame.BorderSizePixel = 0
StatusFrame.Position = UDim2.new(0.05, 0, 0.18, 0)
StatusFrame.Size = UDim2.new(0.9, 0, 0, 35)
StatusFrame.Parent = MainFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.BackgroundTransparency = 1
StatusLabel.Size = UDim2.new(1, 0, 1, 0)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Text = "🔴 QUANTUM SYSTEMS OFFLINE"
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.TextSize = 14
StatusLabel.Parent = StatusFrame

-- Stats Grid
local StatsGrid = Instance.new("Frame")
StatsGrid.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
StatsGrid.BorderSizePixel = 0
StatsGrid.Position = UDim2.new(0.05, 0, 0.33, 0)
StatsGrid.Size = UDim2.new(0.9, 0, 0, 110)
StatsGrid.Parent = MainFrame

local GridCorner = Instance.new("UICorner")
GridCorner.CornerRadius = UDim.new(0, 10)
GridCorner.Parent = StatsGrid

-- Row 1
local DodgeLabel = Instance.new("TextLabel")
DodgeLabel.BackgroundTransparency = 1
DodgeLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
DodgeLabel.Size = UDim2.new(0.45, 0, 0, 20)
DodgeLabel.Font = Enum.Font.Gotham
DodgeLabel.Text = "⚡ Dodges: 0"
DodgeLabel.TextColor3 = Color3.fromRGB(180, 200, 255)
DodgeLabel.TextSize = 12
DodgeLabel.TextXAlignment = Enum.TextXAlignment.Left
DodgeLabel.Parent = StatsGrid

local PerfectLabel = Instance.new("TextLabel")
PerfectLabel.BackgroundTransparency = 1
PerfectLabel.Position = UDim2.new(0.55, 0, 0.05, 0)
PerfectLabel.Size = UDim2.new(0.4, 0, 0, 20)
PerfectLabel.Font = Enum.Font.Gotham
PerfectLabel.Text = "💫 Perfect: 0"
PerfectLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
PerfectLabel.TextSize = 12
PerfectLabel.TextXAlignment = Enum.TextXAlignment.Left
PerfectLabel.Parent = StatsGrid

-- Row 2
local EnergyLabel = Instance.new("TextLabel")
EnergyLabel.BackgroundTransparency = 1
EnergyLabel.Position = UDim2.new(0.05, 0, 0.3, 0)
EnergyLabel.Size = UDim2.new(0.45, 0, 0, 20)
EnergyLabel.Font = Enum.Font.Gotham
EnergyLabel.Text = "💠 Energy: 100%"
EnergyLabel.TextColor3 = Color3.fromRGB(150, 220, 255)
EnergyLabel.TextSize = 12
EnergyLabel.TextXAlignment = Enum.TextXAlignment.Left
EnergyLabel.Parent = StatsGrid

local InstinctLabel = Instance.new("TextLabel")
InstinctLabel.BackgroundTransparency = 1
InstinctLabel.Position = UDim2.new(0.55, 0, 0.3, 0)
InstinctLabel.Size = UDim2.new(0.4, 0, 0, 20)
InstinctLabel.Font = Enum.Font.Gotham
InstinctLabel.Text = "🧠 Instinct: 0%"
InstinctLabel.TextColor3 = Color3.fromRGB(255, 150, 255)
InstinctLabel.TextSize = 12
InstinctLabel.TextXAlignment = Enum.TextXAlignment.Left
InstinctLabel.Parent = StatsGrid

-- Row 3
local ThreatLabel = Instance.new("TextLabel")
ThreatLabel.BackgroundTransparency = 1
ThreatLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
ThreatLabel.Size = UDim2.new(0.45, 0, 0, 20)
ThreatLabel.Font = Enum.Font.Gotham
ThreatLabel.Text = "🎯 Threats: 0"
ThreatLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
ThreatLabel.TextSize = 12
ThreatLabel.TextXAlignment = Enum.TextXAlignment.Left
ThreatLabel.Parent = StatsGrid

local ExperienceLabel = Instance.new("TextLabel")
ExperienceLabel.BackgroundTransparency = 1
ExperienceLabel.Position = UDim2.new(0.55, 0, 0.55, 0)
ExperienceLabel.Size = UDim2.new(0.4, 0, 0, 20)
ExperienceLabel.Font = Enum.Font.Gotham
ExperienceLabel.Text = "📊 Experience: 0"
ExperienceLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
ExperienceLabel.TextSize = 12
ExperienceLabel.TextXAlignment = Enum.TextXAlignment.Left
ExperienceLabel.Parent = StatsGrid

-- Row 4
local ModeLabel = Instance.new("TextLabel")
ModeLabel.BackgroundTransparency = 1
ModeLabel.Position = UDim2.new(0.05, 0, 0.8, 0)
ModeLabel.Size = UDim2.new(0.9, 0, 0, 20)
ModeLabel.Font = Enum.Font.GothamBold
ModeLabel.Text = "🌙 MODE: PERFECTED ULTRA INSTINCT"
ModeLabel.TextColor3 = Color3.fromRGB(255, 255, 150)
ModeLabel.TextSize = 11
ModeLabel.TextXAlignment = Enum.TextXAlignment.Center
ModeLabel.Parent = StatsGrid

-- Control Panel
local ControlFrame = Instance.new("Frame")
ControlFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
ControlFrame.BorderSizePixel = 0
ControlFrame.Position = UDim2.new(0.05, 0, 0.75, 0)
ControlFrame.Size = UDim2.new(0.9, 0, 0, 50)
ControlFrame.Parent = MainFrame

local ControlCorner = Instance.new("UICorner")
ControlCorner.CornerRadius = UDim.new(0, 10)
ControlCorner.Parent = ControlFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
ToggleButton.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleButton.Size = UDim2.new(0.6, 0, 0, 30)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "ACTIVATE QUANTUM UI"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
ToggleButton.Parent = ControlFrame

local ModeButton = Instance.new("TextButton")
ModeButton.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
ModeButton.Position = UDim2.new(0.68, 0, 0.2, 0)
ModeButton.Size = UDim2.new(0.27, 0, 0, 30)
ModeButton.Font = Enum.Font.Gotham
ModeButton.Text = "MODE"
ModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ModeButton.TextSize = 12
ModeButton.Parent = ControlFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = ToggleButton
ButtonCorner.Parent = ModeButton

-- 🚀 QUANTUM AURA SYSTEM
local auraSystem = {
    parts = {},
    pulse = 0,
    intensity = 1
}

local function destroyAura()
    for _, obj in pairs(auraSystem.parts) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    auraSystem.parts = {}
end

local function createQuantumAura()
    destroyAura()
    
    -- Core Aura
    local coreAura = Instance.new("Part")
    coreAura.Name = "QuantumCore"
    coreAura.Size = Vector3.new(9, 9, 9)
    coreAura.Anchored = true
    coreAura.CanCollide = false
    coreAura.Material = Enum.Material.Neon
    coreAura.Color = Color3.fromRGB(200, 220, 255)
    coreAura.Transparency = 0.7
    coreAura.Shape = Enum.PartType.Ball
    coreAura.CFrame = RootPart.CFrame
    coreAura.Parent = FXFolder
    table.insert(auraSystem.parts, coreAura)
    
    -- Quantum Rings
    for i = 1, 4 do
        local ring = Instance.new("Part")
        ring.Size = Vector3.new(0.25, 6 + (i * 2), 6 + (i * 2))
        ring.Anchored = true
        ring.CanCollide = false
        ring.Material = Enum.Material.Neon
        ring.Color = Color3.fromRGB(180, 210, 255)
        ring.Transparency = 0.75
        ring.CFrame = RootPart.CFrame
        ring.Parent = FXFolder
        
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.Cylinder
        mesh.Parent = ring
        table.insert(auraSystem.parts, ring)
    end
    
    -- Energy Particles
    for i = 1, 8 do
        local particle = Instance.new("Part")
        particle.Size = Vector3.new(0.6, 0.6, 0.6)
        particle.Anchored = true
        particle.CanCollide = false
        particle.Material = Enum.Material.Neon
        particle.Color = Color3.fromRGB(160, 200, 255)
        particle.Transparency = 0.65
        particle.Shape = Enum.PartType.Ball
        particle.Parent = FXFolder
        table.insert(auraSystem.parts, particle)
    end
    
    -- Energy Trails
    for i = 1, 4 do
        local trail = Instance.new("Part")
        trail.Size = Vector3.new(0.3, 0.3, 3)
        trail.Anchored = true
        trail.CanCollide = false
        trail.Material = Enum.Material.Neon
        trail.Color = Color3.fromRGB(140, 180, 255)
        trail.Transparency = 0.8
        trail.Parent = FXFolder
        table.insert(auraSystem.parts, trail)
    end
    
    return coreAura
end

-- 🚀 QUANTUM THREAT ANALYSIS SYSTEM
local function quantumThreatAnalysis()
    local activeThreats = 0
    local primaryThreat = nil
    local maxThreatLevel = 0
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChild("Humanoid")
            
            if rootPart and humanoid and humanoid.Health > 0 then
                local distance = (rootPart.Position - RootPart.Position).Magnitude
                
                if distance < THREAT_DETECTION_RANGE then
                    -- Advanced Threat Calculation
                    local threatLevel = 0
                    
                    -- Distance Factor
                    threatLevel = threatLevel + ((THREAT_DETECTION_RANGE - distance) / THREAT_DETECTION_RANGE) * 35
                    
                    -- Velocity Analysis
                    local toPlayer = (RootPart.Position - rootPart.Position).Unit
                    local velocityToward = rootPart.Velocity:Dot(toPlayer)
                    
                    if velocityToward > 0 then
                        threatLevel = threatLevel + (velocityToward / 60) * 25
                    end
                    
                    -- Facing Analysis
                    local facing = rootPart.CFrame.LookVector
                    local facingDot = toPlayer:Dot(facing)
                    
                    if facingDot > 0.8 then
                        threatLevel = threatLevel + 15
                    elseif facingDot > 0.5 then
                        threatLevel = threatLevel + 8
                    end
                    
                    -- Historical Behavior Analysis
                    local playerId = tostring(player.UserId)
                    if ThreatDatabase[playerId] then
                        local history = ThreatDatabase[playerId]
                        threatLevel = threatLevel + (history.aggression * 20)
                        
                        -- Pattern Recognition Bonus
                        if history.attackPattern then
                            threatLevel = threatLevel + 10
                        end
                    end
                    
                    -- Muscle Memory Recognition
                    if MuscleMemory[playerId] then
                        threatLevel = threatLevel + 15
                    end
                    
                    if threatLevel > 30 then
                        activeThreats = activeThreats + 1
                        
                        if threatLevel > maxThreatLevel then
                            maxThreatLevel = threatLevel
                            primaryThreat = {
                                player = player,
                                rootPart = rootPart,
                                position = rootPart.Position,
                                velocity = rootPart.Velocity,
                                threatLevel = threatLevel,
                                distance = distance,
                                playerId = playerId
                            }
                        end
                    end
                end
            end
        end
    end
    
    ThreatLabel.Text = "🎯 Threats: " .. activeThreats
    return primaryThreat, activeThreats
end

-- 🚀 PREDICTIVE DODGE ENGINE
local function calculateQuantumDodge(threatData)
    if not threatData then return nil, nil end
    
    local threatPos = threatData.position
    local threatVel = threatData.velocity
    local playerId = threatData.playerId
    
    -- Advanced Trajectory Prediction
    local predictedPos = threatPos + threatVel * PREDICTION_TIME
    
    -- Factor in player acceleration and movement patterns
    if ThreatDatabase[playerId] then
        local history = ThreatDatabase[playerId]
        if history.avgSpeed then
            predictedPos = predictedPos + threatVel.Unit * history.avgSpeed * 0.2
        end
    end
    
    -- Calculate multiple dodge options
    local dodgeOptions = {}
    
    -- Option 1: Perpendicular Dodge
    local trajectory = (predictedPos - threatPos).Unit
    if trajectory.Magnitude > 0 then
        local perpendicular = trajectory:Cross(Vector3.new(0, 1, 0)).Unit
        table.insert(dodgeOptions, {
            position = RootPart.Position + perpendicular * DODGE_DISTANCE,
            direction = perpendicular,
            type = "perpendicular",
            safety = 0.8
        })
        
        table.insert(dodgeOptions, {
            position = RootPart.Position - perpendicular * DODGE_DISTANCE,
            direction = -perpendicular,
            type = "perpendicular",
            safety = 0.8
        })
    end
    
    -- Option 2: Defensive Retreat
    local retreatDir = (RootPart.Position - threatPos).Unit
    table.insert(dodgeOptions, {
        position = RootPart.Position + retreatDir * DODGE_DISTANCE,
        direction = retreatDir,
        type = "retreat",
        safety = 0.9
    })
    
    -- Option 3: Advanced Flanking
    local flankDir = trajectory:Cross(Vector3.new(0, 1, 0)):Cross(trajectory).Unit
    table.insert(dodgeOptions, {
        position = RootPart.Position + flankDir * DODGE_DISTANCE * 0.7,
        direction = flankDir,
        type = "flank",
        safety = 0.7
    })
    
    -- Evaluate and select best dodge
    local bestDodge = nil
    local bestScore = -1
    
    for _, option in pairs(dodgeOptions) do
        local score = option.safety
        
        -- Raycast safety check
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        rayParams.FilterDescendantsInstances = {Character, FXFolder}
        
        local rayResult = Workspace:Raycast(RootPart.Position, option.direction * DODGE_DISTANCE, rayParams)
        
        if not rayResult then
            score = score + 0.3 -- Bonus for clear path
        else
            score = score - 0.5 -- Penalty for obstacles
        end
        
        -- Distance from threat bonus
        local distanceFromThreat = (option.position - predictedPos).Magnitude
        if distanceFromThreat > 20 then
            score = score + 0.2
        end
        
        if score > bestScore then
            bestScore = score
            bestDodge = option
        end
    end
    
    if bestDodge and bestScore > 0.5 then
        -- Adjust position to stay at same height
        bestDodge.position = Vector3.new(
            bestDodge.position.X,
            RootPart.Position.Y,
            bestDodge.position.Z
        )
        return bestDodge.position, bestDodge.direction
    end
    
    return nil, nil
end

-- 🚀 MUSCLE MEMORY SYSTEM
local function updateMuscleMemory(threatData, dodgeSuccessful)
    if not threatData then return end
    
    local playerId = threatData.playerId
    local currentTime = tick()
    
    -- Initialize player data
    if not ThreatDatabase[playerId] then
        ThreatDatabase[playerId] = {
            firstSeen = currentTime,
            lastSeen = currentTime,
            dodgeCount = 0,
            aggression = 0.5,
            attackPattern = nil,
            avgSpeed = 0,
            speedSamples = 0
        }
    end
    
    local data = ThreatDatabase[playerId]
    data.lastSeen = currentTime
    
    -- Update aggression based on behavior
    if dodgeSuccessful then
        data.dodgeCount = data.dodgeCount + 1
        data.aggression = math.min(1.0, data.aggression + 0.1)
        
        -- Add to muscle memory
        MuscleMemory[playerId] = {
            expiration = currentTime + MUSCLE_MEMORY_DURATION,
            threatLevel = threatData.threatLevel
        }
    end
    
    -- Update speed statistics
    local speed = threatData.velocity.Magnitude
    if data.speedSamples == 0 then
        data.avgSpeed = speed
    else
        data.avgSpeed = (data.avgSpeed * data.speedSamples + speed) / (data.speedSamples + 1)
    end
    data.speedSamples = data.speedSamples + 1
    
    -- Clean old muscle memories
    for id, memory in pairs(MuscleMemory) do
        if currentTime > memory.expiration then
            MuscleMemory[id] = nil
        end
    end
    
    -- Clean very old threats
    for id, threatData in pairs(ThreatDatabase) do
        if currentTime - threatData.lastSeen > 300 then -- 5 minutes
            ThreatDatabase[id] = nil
        end
    end
end

-- 🚀 QUANTUM DODGE EFFECTS
local function createQuantumDodgeEffect(position, direction, dodgeType)
    -- Core Flash
    local flash = Instance.new("Part")
    flash.Size = Vector3.new(6, 6, 6)
    flash.Position = position
    flash.Anchored = true
    flash.CanCollide = false
    flash.Material = Enum.Material.Neon
    flash.Color = Color3.fromRGB(220, 230, 255)
    flash.Transparency = 0.3
    flash.Shape = Enum.PartType.Ball
    flash.Parent = FXFolder
    
    -- Type-based effects
    if dodgeType == "perfect" then
        -- Golden perfect dodge effect
        for i = 1, 12 do
            local perfectRing = Instance.new("Part")
            perfectRing.Size = Vector3.new(0.2, 6, 6)
            perfectRing.Position = position
            perfectRing.Anchored = true
            perfectRing.CanCollide = false
            perfectRing.Material = Enum.Material.Neon
            perfectRing.Color = Color3.fromRGB(255, 215, 0)
            perfectRing.Transparency = 0.4
            perfectRing.Parent = FXFolder
            
            local angle = (i / 12) * math.pi * 2
            perfectRing.CFrame = CFrame.new(position) * CFrame.Angles(math.rad(90), angle, 0)
            
            TweenService:Create(perfectRing, TweenInfo.new(0.4), {
                Transparency = 1,
                Size = Vector3.new(0.1, 12, 12)
            }):Play()
            Debris:AddItem(perfectRing, 0.4)
        end
    else
        -- Standard dodge rings
        for i = 1, 8 do
            local ring = Instance.new("Part")
            ring.Size = Vector3.new(0.15, 4, 4)
            ring.Position = position
            ring.Anchored = true
            ring.CanCollide = false
            ring.Material = Enum.Material.Neon
            ring.Color = Color3.fromRGB(180, 210, 255)
            ring.Transparency = 0.5
            ring.Parent = FXFolder
            
            local angle = (i / 8) * math.pi * 2
            ring.CFrame = CFrame.new(position) * CFrame.Angles(0, angle, 0) * CFrame.new(0, 0, 3)
            
            TweenService:Create(ring, TweenInfo.new(0.25), {
                Transparency = 1,
                Size = Vector3.new(0.08, 7, 7)
            }):Play()
            Debris:AddItem(ring, 0.25)
        end
    end
    
    -- Directional Trail
    for i = 1, 4 do
        local trail = Instance.new("Part")
        trail.Size = Vector3.new(0.25, 0.25, 2.5)
        trail.Position = position - direction * (i * 1.2)
        trail.Anchored = true
        trail.CanCollide = false
        trail.Material = Enum.Material.Neon
        trail.Color = Color3.fromRGB(200, 220, 255)
        trail.Transparency = 0.6
        trail.CFrame = CFrame.lookAt(trail.Position, trail.Position + direction)
        trail.Parent = FXFolder
        
        TweenService:Create(trail, TweenInfo.new(0.18), {
            Transparency = 1,
            Size = Vector3.new(0.1, 0.1, 4)
        }):Play()
        Debris:AddItem(trail, 0.18)
    end
    
    TweenService:Create(flash, TweenInfo.new(0.35), {
        Size = Vector3.new(10, 10, 10),
        Transparency = 1
    }):Play()
    Debris:AddItem(flash, 0.35)
end

-- 🚀 INSTINCT EVOLUTION SYSTEM
local function updateInstinctLevel(successfulDodge, threatLevel)
    if successfulDodge then
        combatExperience = combatExperience + 1
        ExperienceLabel.Text = "📊 Experience: " .. combatExperience
        
        -- Increase instinct based on threat level and success
        local instinctGain = 0.5 + (threatLevel / 200)
        instinctLevel = math.min(100, instinctLevel + instinctGain)
        
        if threatLevel > 80 then
            perfectDodgeCount = perfectDodgeCount + 1
            PerfectLabel.Text = "💫 Perfect: " .. perfectDodgeCount
        end
    else
        -- Gradual instinct decay
        instinctLevel = math.max(0, instinctLevel - 0.1)
    end
    
    InstinctLabel.Text = "🧠 Instinct: " .. math.floor(instinctLevel) .. "%"
    
    -- Update aura intensity based on instinct
    auraSystem.intensity = 0.7 + (instinctLevel / 100) * 0.3
end

-- 🚀 QUANTUM DODGE EXECUTION
local function executeQuantumDodge()
    local currentTime = tick()
    
    -- System Checks
    if currentTime - lastDodgeTime < dodgeCooldown then return false end
    if uiEnergy < ENERGY_DODGE_COST then return false end
    if not UI_ENABLED then return false end
    
    -- Threat Analysis
    local primaryThreat, threatCount = quantumThreatAnalysis()
    if not primaryThreat then return false end
    
    -- Calculate Dodge
    local dodgePos, dodgeDir = calculateQuantumDodge(primaryThreat)
    if not dodgePos then return false end
    
    -- Execute Dodge
    local originalPos = RootPart.Position
    
    -- Smooth Transition
    RootPart.CFrame = CFrame.new(dodgePos)
    RootPart.Velocity = Vector3.new(0, 0, 0)
    RootPart.RotVelocity = Vector3.new(0, 0, 0)
    
    -- Determine Dodge Type
    local dodgeType = "standard"
    if primaryThreat.threatLevel > 80 and instinctLevel > 50 then
        dodgeType = "perfect"
    end
    
    -- Create Effects
    createQuantumDodgeEffect(originalPos, dodgeDir, dodgeType)
    createQuantumDodgeEffect(dodgePos, dodgeDir, dodgeType)
    
    -- Update Systems
    dodgeCount = dodgeCount + 1
    uiEnergy = uiEnergy - ENERGY_DODGE_COST
    lastDodgeTime = currentTime
    
    DodgeLabel.Text = "⚡ Dodges: " .. dodgeCount
    EnergyLabel.Text = "💠 Energy: " .. math.floor(uiEnergy) .. "%"
    
    -- Update Learning Systems
    updateMuscleMemory(primaryThreat, true)
    updateInstinctLevel(true, primaryThreat.threatLevel)
    
    -- UI Feedback
    Title.TextColor3 = dodgeType == "perfect" and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(255, 255, 200)
    wait(0.02)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    return true
end

-- 🚀 VELOCITY REACTION SYSTEM
local function executeVelocityReaction()
    local currentTime = tick()
    
    if currentTime - lastDodgeTime < dodgeCooldown then return false end
    if uiEnergy < ENERGY_DODGE_COST then return false end
    
    local velocity = RootPart.Velocity
    local speed = velocity.Magnitude
    
    if speed > VELOCITY_THRESHOLD then
        local dodgeDir = -velocity.Unit
        local dodgePos = RootPart.Position + dodgeDir * DODGE_DISTANCE
        
        dodgePos = Vector3.new(dodgePos.X, RootPart.Position.Y, dodgePos.Z)
        local originalPos = RootPart.Position
        
        RootPart.CFrame = CFrame.new(dodgePos)
        RootPart.Velocity = Vector3.new(0, 0, 0)
        
        createQuantumDodgeEffect(originalPos, dodgeDir, "reaction")
        createQuantumDodgeEffect(dodgePos, dodgeDir, "reaction")
        
        dodgeCount = dodgeCount + 1
        uiEnergy = uiEnergy - ENERGY_DODGE_COST
        lastDodgeTime = currentTime
        
        DodgeLabel.Text = "⚡ Dodges: " .. dodgeCount
        EnergyLabel.Text = "💠 Energy: " .. math.floor(uiEnergy) .. "%"
        
        updateInstinctLevel(true, 60)
        
        return true
    end
    
    return false
end

-- 🚀 ENERGY MANAGEMENT
local function updateQuantumEnergy()
    if not UI_ENABLED then return end
    
    -- Smart Regeneration
    local regenMultiplier = 1
    if instinctLevel > 70 then
        regenMultiplier = 1.5 -- Enhanced regeneration at high instinct
    end
    
    if uiEnergy < 100 then
        uiEnergy = math.min(100, uiEnergy + ENERGY_REGEN_RATE * 0.1 * regenMultiplier)
        EnergyLabel.Text = "💠 Energy: " .. math.floor(uiEnergy) .. "%"
    end
    
    -- Gradual instinct refinement
    if instinctLevel > 0 then
        instinctLevel = math.max(0, instinctLevel - 0.02)
        InstinctLabel.Text = "🧠 Instinct: " .. math.floor(instinctLevel) .. "%"
    end
end

-- 🚀 QUANTUM AURA ANIMATION
local function updateQuantumAura()
    if not UI_ENABLED then return end
    
    auraSystem.pulse = auraSystem.pulse + 0.08
    
    for i, part in pairs(auraSystem.parts) do
        if part and part.Parent then
            if part.Name == "QuantumCore" then
                -- Core aura animation
                part.CFrame = RootPart.CFrame
                local pulse = 1 + math.sin(auraSystem.pulse * 4) * 0.1
                part.Size = Vector3.new(9 * pulse * auraSystem.intensity, 9 * pulse * auraSystem.intensity, 9 * pulse * auraSystem.intensity)
                part.Transparency = 0.7 - (auraSystem.intensity * 0.2)
                
            elseif part.Size.Y > 5 then -- Energy rings
                -- Rotating quantum rings
                part.CFrame = RootPart.CFrame * CFrame.Angles(math.rad(90), 0, math.rad((i * 90) + (auraSystem.pulse * 150)))
                part.Transparency = 0.75 - (auraSystem.intensity * 0.15)
                
            elseif part.Size.Z > 2 then -- Energy trails
                -- Orbiting trails
                local orbitRadius = 7
                local orbitSpeed = 2.5
                local angle = auraSystem.pulse * orbitSpeed + (i * 0.8)
                part.CFrame = RootPart.CFrame * CFrame.new(
                    math.cos(angle) * orbitRadius,
                    math.sin(angle * 0.6) * 2,
                    math.sin(angle) * orbitRadius
                ) * CFrame.Angles(0, angle, 0)
                
            else -- Energy particles
                -- Floating particles with individual movement
                local floatRadius = 5 + (i * 0.3)
                local floatSpeed = 1.5 + (i * 0.1)
                local angle = auraSystem.pulse * floatSpeed + (i * 1.5)
                part.CFrame = RootPart.CFrame * CFrame.new(
                    math.cos(angle) * floatRadius,
                    math.sin(auraSystem.pulse * 3 + i) * 3,
                    math.sin(angle) * floatRadius
                )
            end
        end
    end
end

-- 🚀 QUANTUM AFTERIMAGE SYSTEM
local function createQuantumAfterimage()
    if tick() - lastAfterimage < AFTERIMAGE_INTERVAL then return end
    lastAfterimage = tick()
    
    if Humanoid.MoveDirection.Magnitude > 0.2 then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency < 1 and part.Name ~= "HumanoidRootPart" then
                local clone = part:Clone()
                clone.Anchored = true
                clone.CanCollide = false
                clone.Material = Enum.Material.Neon
                
                -- Color based on instinct level
                if instinctLevel > 80 then
                    clone.Color = Color3.fromRGB(255, 255, 200) -- Golden at high instinct
                else
                    clone.Color = Color3.fromRGB(180, 210, 255) -- Standard silver-blue
                end
                
                clone.Transparency = 0.7 - (instinctLevel / 100) * 0.3
                clone.CFrame = part.CFrame
                clone.Parent = FXFolder
                
                for _, child in pairs(clone:GetChildren()) do
                    if not child:IsA("SpecialMesh") and not child:IsA("Motor6D") then
                        child:Destroy()
                    end
                end
                
                TweenService:Create(clone, TweenInfo.new(0.4), {
                    Transparency = 1,
                    Color = Color3.fromRGB(220, 230, 255)
                }):Play()
                Debris:AddItem(clone, 0.4)
            end
        end
    end
end

-- 🚀 MODE MANAGEMENT SYSTEM
local function cycleUIMode()
    local modes = {"BASIC", "MASTERED", "PERFECTED"}
    local currentIndex = table.find(modes, UI_MODE) or 1
    local nextIndex = currentIndex % #modes + 1
    UI_MODE = modes[nextIndex]
    
    local modeColors = {
        BASIC = Color3.fromRGB(100, 150, 200),
        MASTERED = Color3.fromRGB(150, 200, 255),
        PERFECTED = Color3.fromRGB(255, 215, 0)
    }
    
    ModeLabel.Text = "🌙 MODE: " .. UI_MODE .. " ULTRA INSTINCT"
    MainFrame.BorderColor3 = modeColors[UI_MODE]
    Header.BackgroundColor3 = modeColors[UI_MODE]
    
    if UI_ENABLED then
        stopQuantumUI()
        wait(0.1)
        startQuantumUI()
    end
end

-- 🚀 MAIN QUANTUM UI SYSTEM
local function startQuantumUI()
    -- Cleanup previous systems
    for _, connection in pairs(Connections) do
        connection:Disconnect()
    end
    Connections = {}
    
    -- Apply mode-based speed
    local speedMultipliers = {
        BASIC = SPEED_BOOST_BASIC,
        MASTERED = SPEED_BOOST_MASTERED,
        PERFECTED = SPEED_BOOST_PERFECTED
    }
    Humanoid.WalkSpeed = 16 * speedMultipliers[UI_MODE]
    
    -- Initialize quantum systems
    createQuantumAura()
    
    -- 🚀 QUANTUM CORE SYSTEMS
    table.insert(Connections, RunService.Heartbeat:Connect(updateQuantumAura))
    table.insert(Connections, RunService.Heartbeat:Connect(updateQuantumEnergy))
    table.insert(Connections, RunService.Heartbeat:Connect(createQuantumAfterimage))
    
    -- 🚀 ADVANCED DODGE SYSTEMS
    table.insert(Connections, RunService.Heartbeat:Connect(function()
        if not UI_ENABLED then return end
        
        -- Priority 1: Quantum Predictive Dodging
        if executeQuantumDodge() then return end
        
        -- Priority 2: Velocity Reaction System
        executeVelocityReaction()
    end))
    
    StatusLabel.Text = "⚡ QUANTUM SYSTEMS ONLINE"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    
    print("🚀 QUANTUM ULTRA INSTINCT ACTIVATED")
    print("🌌 Mode: " .. UI_MODE)
    print("💫 Advanced Threat Analysis: Online")
    print("🧠 Neural Network Learning: Active")
    print("⚡ Predictive Dodge Engine: Operational")
end

local function stopQuantumUI()
    for _, connection in pairs(Connections) do
        connection:Disconnect()
    end
    Connections = {}
    
    Humanoid.WalkSpeed = 16
    destroyAura()
    
    StatusLabel.Text = "🔴 QUANTUM SYSTEMS OFFLINE"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
end

-- 🚀 CONTROL SYSTEMS
ToggleButton.MouseButton1Click:Connect(function()
    UI_ENABLED = not UI_ENABLED
    
    if UI_ENABLED then
        ToggleButton.Text = "QUANTUM UI ACTIVE"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 150, 255)
        startQuantumUI()
    else
        ToggleButton.Text = "ACTIVATE QUANTUM UI"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        stopQuantumUI()
    end
end)

ModeButton.MouseButton1Click:Connect(cycleUIMode)

-- Character Respawn System
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
    
    -- Reset combat stats but preserve learning
    dodgeCount = 0
    perfectDodgeCount = 0
    uiEnergy = 100
    combatExperience = combatExperience -- Preserve experience
    instinctLevel = math.max(instinctLevel * 0.8, 0) -- Slight decay on death
    
    -- Update UI
    DodgeLabel.Text = "⚡ Dodges: 0"
    PerfectLabel.Text = "💫 Perfect: 0"
    EnergyLabel.Text = "💠 Energy: 100%"
    ExperienceLabel.Text = "📊 Experience: " .. combatExperience
    InstinctLabel.Text = "🧠 Instinct: " .. math.floor(instinctLevel) .. "%"
    
    wait(0.5)
    if UI_ENABLED then
        startQuantumUI()
    end
end)

print("🚀🌌 ADVANCED TRUE MASTERED ULTRA INSTINCT LOADED 🌌🚀")
print("💫 Quantum Threat Analysis System: Online")
print("🧠 Neural Learning Network: Active")
print("⚡ Predictive Dodge Engine: Operational")
print("🌌 Multi-Mode Ultra Instinct: Ready")
print("🎯 Muscle Memory System: Initialized")
print("🚀 Experience Progression: Enabled")
print("⚡ BECOME THE ULTIMATE ULTRA INSTINCT WARRIOR!")
