-- GOD'S ULTRA INSTINCT - PURE DEFENSE EDITION (FIXED VERSION)
-- Ultra Instinct focused purely on dodging and defense

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Wait for player to fully load
local Character = LocalPlayer.CharacterAdded:Wait()
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

local AFTERIMAGE_INTERVAL = {
    MASTERED = 0.06,
    PERFECTION = 0.04,
    SUPERSKKSKSJSJSJ = 0.005,
    ULTRA_GOD = 0.001
}

-- TRACKING
local dodgeCount = 0
local dodgeChain = 0
local lastAfterimage = 0
local shieldHealth = 100
local shieldActive = true
local iframeActive = false
local lastPerfectDodge = 0
local perfectDodgeStreak = 0

-- Connections
local DodgeConnection, AuraConnection, AfterimageConnection
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

local ModeLabel = Instance.new("TextLabel")
ModeLabel.BackgroundTransparency = 1
ModeLabel.Position = UDim2.new(0.05, 0, 0.85, 0)
ModeLabel.Size = UDim2.new(0.9, 0, 0, 20)
ModeLabel.Font = Enum.Font.Gotham
ModeLabel.Text = "🌟 Mode: MASTERED"
ModeLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
ModeLabel.TextSize = 13
ModeLabel.TextXAlignment = Enum.TextXAlignment.Left
ModeLabel.Parent = StatsFrame

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

-- Fix: Add UIStroke for better visibility
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Thickness = 2
UIStroke.Parent = Frame

-- FIXED: Clear existing connections properly
local function clearConnections()
    if DodgeConnection then DodgeConnection:Disconnect() DodgeConnection = nil end
    if AuraConnection then AuraConnection:Disconnect() AuraConnection = nil end
    if AfterimageConnection then AfterimageConnection:Disconnect() AfterimageConnection = nil end
    if PredictionConnection then PredictionConnection:Disconnect() PredictionConnection = nil end
    if ShieldConnection then ShieldConnection:Disconnect() ShieldConnection = nil end
    if ThreatAnalysisConnection then ThreatAnalysisConnection:Disconnect() ThreatAnalysisConnection = nil end
end

-- SIMPLIFIED AURA
local auraPart = nil
local function createAura()
    if auraPart then auraPart:Destroy() auraPart = nil end
    
    local auraSize = CURRENT_MODE == "ULTRA_GOD" and 15 or
                     CURRENT_MODE == "SUPERSKKSKSJSJSJ" and 12 or
                     CURRENT_MODE == "PERFECTION" and 10 or 8
    
    auraPart = Instance.new("Part")
    auraPart.Name = "DivineAura"
    auraPart.Size = Vector3.new(auraSize, auraSize, auraSize)
    auraPart.Position = RootPart.Position
    auraPart.Anchored = true
    auraPart.CanCollide = false
    auraPart.Material = Enum.Material.Neon
    auraPart.Transparency = 0.3
    auraPart.Shape = Enum.PartType.Ball
    auraPart.Parent = FXFolder
    
    local light = Instance.new("PointLight")
    light.Brightness = 5
    light.Range = 20
    light.Parent = auraPart
    
    return auraPart
end

-- FIXED: AFTERIMAGE EFFECT
local function createAfterimage()
    if tick() - lastAfterimage < AFTERIMAGE_INTERVAL[CURRENT_MODE] then
        return
    end
    
    lastAfterimage = tick()
    
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            local clone = part:Clone()
            clone.Anchored = true
            clone.CanCollide = false
            clone.Material = Enum.Material.Neon
            clone.Transparency = 0.5
            clone.CFrame = part.CFrame
            clone.Parent = FXFolder
            
            TweenService:Create(clone, TweenInfo.new(0.3), {Transparency = 1}):Play()
            Debris:AddItem(clone, 0.3)
        end
    end
end

-- FIXED: DODGE EFFECT
local function createDodgeEffect(position)
    local effectSize = CURRENT_MODE == "ULTRA_GOD" and 8 or
                       CURRENT_MODE == "SUPERSKKSKSJSJSJ" and 6 or
                       CURRENT_MODE == "PERFECTION" and 4 or 3
    
    local burst = Instance.new("Part")
    burst.Size = Vector3.new(effectSize, effectSize, effectSize)
    burst.Position = position
    burst.Anchored = true
    burst.CanCollide = false
    burst.Material = Enum.Material.Neon
    burst.Color = Color3.fromRGB(255, 255, 255)
    burst.Transparency = 0.3
    burst.Shape = Enum.PartType.Ball
    burst.Parent = FXFolder
    
    TweenService:Create(burst, TweenInfo.new(0.3), {
        Size = Vector3.new(effectSize * 2, effectSize * 2, effectSize * 2),
        Transparency = 1
    }):Play()
    Debris:AddItem(burst, 0.3)
end

-- FIXED: SIMPLIFIED DODGE SYSTEM
local lastVelocity = Vector3.new(0, 0, 0)
local lastCheckTime = tick()
local lastDodgeTime = 0

local function checkForDodge()
    local currentTime = tick()
    local deltaTime = currentTime - lastCheckTime
    local currentVelocity = RootPart.Velocity
    local velocityMagnitude = currentVelocity.Magnitude
    
    -- Check if we should dodge
    if velocityMagnitude > VELOCITY_THRESHOLD[CURRENT_MODE] and 
       (currentTime - lastDodgeTime) > 0.2 then
        
        dodgeCount = dodgeCount + 1
        DodgeLabel.Text = string.format("⚡ Dodges: %d", dodgeCount)
        lastDodgeTime = currentTime
        
        -- Calculate dodge position
        local dodgeFrom = RootPart.Position
        local dodgeDirection = -currentVelocity.Unit
        local dodgeDistance = DODGE_DISTANCE[CURRENT_MODE]
        local dodgePosition = RootPart.Position + (dodgeDirection * dodgeDistance)
        
        -- Keep same Y position
        dodgePosition = Vector3.new(
            dodgePosition.X,
            RootPart.Position.Y,
            dodgePosition.Z
        )
        
        -- Perform dodge
        RootPart.CFrame = CFrame.new(dodgePosition)
        RootPart.Velocity = Vector3.new(0, 0, 0)
        
        -- Create effects
        createDodgeEffect(dodgeFrom)
        createDodgeEffect(dodgePosition)
        
        -- Update UI
        Header.BackgroundColor3 = Color3.fromRGB(255, 255, 100)
        task.wait(0.1)
        
        -- Restore color
        if CURRENT_MODE == "ULTRA_GOD" then
            Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        elseif CURRENT_MODE == "SUPERSKKSKSJSJSJ" then
            Header.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
        elseif CURRENT_MODE == "PERFECTION" then
            Header.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
        else
            Header.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        end
    end
    
    lastVelocity = currentVelocity
    lastCheckTime = currentTime
end

-- FIXED: START UI FUNCTION
local function startUI()
    clearConnections()
    
    -- Apply speed boost
    Humanoid.WalkSpeed = 16 * SPEED_BOOST[CURRENT_MODE]
    SpeedLabel.Text = string.format("💨 Speed: %.1fx", SPEED_BOOST[CURRENT_MODE])
    
    -- Create aura
    createAura()
    
    -- Aura update connection
    AuraConnection = RunService.Heartbeat:Connect(function()
        if not UI_ENABLED or not auraPart then return end
        
        auraPart.Position = RootPart.Position
        auraPart.CFrame = auraPart.CFrame * CFrame.Angles(0, math.rad(2), 0)
        
        -- Color cycling for special modes
        if CURRENT_MODE == "SUPERSKKSKSJSJSJ" then
            auraPart.Color = Color3.fromHSV((tick() % 2) * 0.5, 1, 1)
        elseif CURRENT_MODE == "ULTRA_GOD" then
            auraPart.Color = Color3.fromRGB(255, 255, 255)
        else
            auraPart.Color = Color3.fromRGB(100, 150, 255)
        end
    end)
    
    -- Afterimage connection
    AfterimageConnection = RunService.Heartbeat:Connect(function()
        if not UI_ENABLED then return end
        if Humanoid.MoveDirection.Magnitude > 0 then
            createAfterimage()
        end
    end)
    
    -- Main dodge connection - SIMPLIFIED
    DodgeConnection = RunService.Heartbeat:Connect(function()
        if not UI_ENABLED then return end
        checkForDodge()
    end)
    
    print("✅ Ultra Instinct Activated - Mode:", CURRENT_MODE)
end

-- FIXED: STOP UI FUNCTION
local function stopUI()
    clearConnections()
    
    -- Reset speed
    Humanoid.WalkSpeed = 16
    
    -- Clear effects
    if auraPart then
        auraPart:Destroy()
        auraPart = nil
    end
    
    for _, v in pairs(FXFolder:GetChildren()) do
        v:Destroy()
    end
    
    print("❌ Ultra Instinct Deactivated")
end

-- FIXED: MODE SELECTION
MasteredBtn.MouseButton1Click:Connect(function()
    CURRENT_MODE = "MASTERED"
    ModeLabel.Text = "🌟 Mode: MASTERED"
    Frame.BorderColor3 = Color3.fromRGB(100, 150, 255)
    print("Mode changed to: MASTERED")
end)

PerfectionBtn.MouseButton1Click:Connect(function()
    CURRENT_MODE = "PERFECTION"
    ModeLabel.Text = "💫 Mode: PERFECTION"
    Frame.BorderColor3 = Color3.fromRGB(150, 100, 255)
    print("Mode changed to: PERFECTION")
end)

SuperBtn.MouseButton1Click:Connect(function()
    CURRENT_MODE = "SUPERSKKSKSJSJSJ"
    ModeLabel.Text = "💥 Mode: SUPERSKKSKSJSJSJ"
    Frame.BorderColor3 = Color3.fromRGB(255, 50, 150)
    print("Mode changed to: SUPERSKKSKSJSJSJ")
end)

UltraBtn.MouseButton1Click:Connect(function()
    CURRENT_MODE = "ULTRA_GOD"
    ModeLabel.Text = "🌟 Mode: ULTRA GOD"
    Frame.BorderColor3 = Color3.fromRGB(255, 255, 50)
    print("Mode changed to: ULTRA GOD")
end)

-- FIXED: TOGGLE BUTTON
ToggleButton.MouseButton1Click:Connect(function()
    UI_ENABLED = not UI_ENABLED
    
    if UI_ENABLED then
        ToggleButton.Text = "DEACTIVATE"
        StatusLabel.Text = "⚡ ACTIVE ⚡"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        -- Update button color based on mode
        if CURRENT_MODE == "ULTRA_GOD" then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 50)
            Header.BackgroundColor3 = Color3.fromRGB(255, 255, 50)
        elseif CURRENT_MODE == "SUPERSKKSKSJSJSJ" then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
            Header.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
        elseif CURRENT_MODE == "PERFECTION" then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
            Header.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
        else
            ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
            Header.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        end
        
        startUI()
    else
        ToggleButton.Text = "ACTIVATE DEFENSE"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        Header.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
        StatusLabel.Text = "🔴 DORMANT 🔴"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        stopUI()
    end
end)

-- FIXED: CHARACTER RESPAWN HANDLING
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
    
    -- Reset stats
    dodgeCount = 0
    dodgeChain = 0
    DodgeLabel.Text = "⚡ Dodges: 0"
    ChainLabel.Text = "🔗 Chain: 0"
    
    -- Clear existing effects
    clearConnections()
    if auraPart then auraPart:Destroy() auraPart = nil end
    
    -- Restart UI if it was active
    if UI_ENABLED then
        task.wait(0.5) -- Wait for character to fully load
        startUI()
    end
end)

-- Initial setup
print("=" .. string.rep("=", 50))
print("⚡ GOD'S ULTRA INSTINCT LOADED SUCCESSFULLY! ⚡")
print("🌟 MODES: MASTERED | PERFECTION | SUPERSKKSKSJSJSJ | ULTRA GOD")
print("⚡ PURE DEFENSE SYSTEM - AUTO-DODGE ONLY")
print("🎮 SELECT A MODE THEN CLICK 'ACTIVATE DEFENSE'")
print("=" .. string.rep("=", 50))
