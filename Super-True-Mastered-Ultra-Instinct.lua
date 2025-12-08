-- ⚡ ULTRA INSTINCT OMEGA EVOLUTION ⚡
-- GOD-TIER EVOLUTIONARY MODE SYSTEM
-- Place in StarterPlayer → StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- EVOLUTIONARY MODE SYSTEM
local MODES = {
	["MASTERED"] = {
		color = Color3.fromRGB(100, 200, 255),
		speed = 2.5,
		dodgeDist = 25,
		cooldown = 0.3,
		auraSize = 6
	},
	["PERFECTION"] = {
		color = Color3.fromRGB(200, 100, 255),
		speed = 3.0, -- Increased from 2.5
		dodgeDist = 35,
		cooldown = 0.2,
		auraSize = 8,
		timeSlow = 0.8 -- Time dilation factor
	},
	["SUPERSKKSKSJSJSJ"] = {
		color = Color3.fromRGB(255, 50, 150),
		speed = 4.0, -- Drastically increased
		dodgeDist = 50,
		cooldown = 0.05, -- Near instant
		auraSize = 12,
		timeSlow = 0.5,
		phasing = true -- Walk through walls
	},
	["OMEGA EVOLUTION"] = { -- NEW GOD-TIER MODE
		color = Color3.fromRGB(255, 255, 0),
		speed = 5.0,
		dodgeDist = 75,
		cooldown = 0,
		auraSize = 15,
		timeSlow = 0.3,
		phasing = true,
		teleportDodge = true,
		realityBend = true
	}
}

-- EVOLUTIONARY STATS
local UI_ENABLED = false
local CURRENT_MODE = "MASTERED"
local EVOLUTION_CHARGE = 0
local MAX_EVOLUTION = 1000
local COMBO_COUNT = 0
local LAST_COMBO_TIME = 0
local COMBO_TIMEOUT = 3

-- ADVANCED DETECTION SYSTEMS
local VELOCITY_THRESHOLD = {MASTERED = 250, PERFECTION = 300, SUPERSKKSKSJSJSJ = 150, ["OMEGA EVOLUTION"] = 75}
local ACCELERATION_THRESHOLD = {MASTERED = 500, PERFECTION = 700, SUPERSKKSKSJSJSJ = 300, ["OMEGA EVOLUTION"] = 150}
local ANTI_FLING_FORCE = {MASTERED = 1000, PERFECTION = 2000, SUPERSKKSKSJSJSJ = 10000, ["OMEGA EVOLUTION"] = 50000}

-- PREDICTION SYSTEM
local PREDICTION_TIME = 0.2 -- Predict attacks 0.2s ahead
local attackPrediction = {}
local predictedAttacks = {}

-- Connections
local connections = {}
local Character, Humanoid, RootPart

-- Effects
local FXFolder = Instance.new("Folder", workspace)
FXFolder.Name = "OmegaUI_FX"

-- Initialize Character
local function waitForCharacter()
	Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	Humanoid = Character:WaitForChild("Humanoid")
	RootPart = Character:WaitForChild("HumanoidRootPart")
end

-- GOD-TIER GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OmegaUIGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame with gradient
local Frame = Instance.new("Frame")
Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Frame.BackgroundTransparency = 0.1
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.35, 0, 0.2, 0)
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Gradient
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 30)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 0, 60))
}
UIGradient.Parent = Frame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 20)
UICorner.Parent = Frame

-- Header with particle effect
local Header = Instance.new("Frame")
Header.BackgroundTransparency = 1
Header.Size = UDim2.new(1, 0, 0, 50)
Header.Parent = Frame

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Font = Enum.Font.GothamBlack
Title.Text = "⚡ OMEGA EVOLUTION ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextStrokeColor3 = Color3.fromRGB(0, 150, 255)
Title.TextStrokeTransparency = 0
Title.Parent = Header

-- Evolution Charge Bar
local EvolutionBarBack = Instance.new("Frame")
EvolutionBarBack.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
EvolutionBarBack.Position = UDim2.new(0.05, 0, 0.15, 0)
EvolutionBarBack.Size = UDim2.new(0.9, 0, 0, 20)
EvolutionBarBack.Parent = Frame

local EvolutionBar = Instance.new("Frame")
EvolutionBar.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
EvolutionBar.Size = UDim2.new(0, 0, 1, 0)
EvolutionBar.Parent = EvolutionBarBack

local EvolutionLabel = Instance.new("TextLabel")
EvolutionLabel.BackgroundTransparency = 1
EvolutionLabel.Size = UDim2.new(1, 0, 1, 0)
EvolutionLabel.Font = Enum.Font.GothamBold
EvolutionLabel.Text = "EVOLUTION: 0%"
EvolutionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
EvolutionLabel.TextSize = 12
EvolutionLabel.Parent = EvolutionBarBack

-- Mode Selection Grid
local ModeGrid = Instance.new("UIGridLayout")
ModeGrid.CellPadding = UDim2.new(0, 5, 0, 5)
ModeGrid.CellSize = UDim2.new(0.48, 0, 0, 40)
ModeGrid.Parent = Instance.new("Frame", Frame)
ModeGrid.Parent.Position = UDim2.new(0.05, 0, 0.22, 0)
ModeGrid.Parent.Size = UDim2.new(0.9, 0, 0, 180)

for modeName, modeData in pairs(MODES) do
	local ModeBtn = Instance.new("TextButton")
	ModeBtn.BackgroundColor3 = modeData.color
	ModeBtn.Font = Enum.Font.GothamBold
	ModeBtn.Text = "🌟 " .. modeName
	ModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	ModeBtn.TextSize = 12
	ModeBtn.Parent = ModeGrid.Parent
	
	ModeBtn.MouseButton1Click:Connect(function()
		CURRENT_MODE = modeName
		updateGUI()
		if UI_ENABLED then
			stopUI()
			task.wait(0.1)
			startUI()
		end
	end)
end

-- Combo Display
local ComboFrame = Instance.new("Frame")
ComboFrame.BackgroundTransparency = 1
ComboFrame.Position = UDim2.new(0.1, 0, 0.7, 0)
ComboFrame.Size = UDim2.new(0.8, 0, 0, 50)
ComboFrame.Parent = Frame

local ComboLabel = Instance.new("TextLabel")
ComboLabel.BackgroundTransparency = 1
ComboLabel.Size = UDim2.new(1, 0, 1, 0)
ComboLabel.Font = Enum.Font.GothamBlack
ComboLabel.Text = "COMBO: 0x"
ComboLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ComboLabel.TextSize = 24
ComboLabel.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
ComboLabel.Visible = false
ComboLabel.Parent = ComboFrame

-- Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ToggleButton.Position = UDim2.new(0.1, 0, 0.85, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0, 50)
ToggleButton.Font = Enum.Font.GothamBlack
ToggleButton.Text = "⚡ AWAKEN ⚡"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 20
ToggleButton.Parent = Frame

-- PREDICTION VISUALIZER
local PredictionGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
PredictionGui.Name = "PredictionOverlay"
PredictionGui.ResetOnSpawn = false

-- REALITY BENDING EFFECTS
local function bendReality()
	if CURRENT_MODE ~= "OMEGA EVOLUTION" then return end
	
	-- Screen distortion
	local blur = Instance.new("BlurEffect")
	blur.Size = 10
	blur.Parent = Lighting
	
	-- Color correction
	local colorCorrection = Instance.new("ColorCorrectionEffect")
	colorCorrection.TintColor = Color3.fromRGB(255, 255, 200)
	colorCorrection.Brightness = 0.1
	colorCorrection.Contrast = 0.2
	colorCorrection.Parent = Lighting
	
	-- Gravity distortion
	workspace.Gravity = workspace.Gravity * 0.7
	
	task.delay(1, function()
		if blur then blur:Destroy() end
		if colorCorrection then colorCorrection:Destroy() end
		workspace.Gravity = 196.2
	end)
end

-- TIME DILATION
local function slowTime(factor)
	local originalTimescale = 1
	if factor < 1 then
		originalTimescale = RunService:GetTimeScale()
		RunService:SetTimeScale(factor)
		
		-- Visual time slow effect
		for _, part in pairs(workspace:GetDescendants()) do
			if part:IsA("BasePart") and part:FindFirstChild("TimeTrail") == nil then
				local trail = Instance.new("Trail")
				trail.Color = ColorSequence.new(Color3.fromRGB(0, 200, 255))
				trail.Lifetime = 0.5
				trail.Parent = part
				trail.Name = "TimeTrail"
				Debris:AddItem(trail, 2)
			end
		end
		
		task.delay(1, function()
			RunService:SetTimeScale(originalTimescale)
		end)
	end
end

-- QUANTUM DODGE (Teleports through space)
local function quantumDodge(position)
	local originalCFrame = RootPart.CFrame
	local targetPosition = position + Vector3.new(
		math.random(-20, 20),
		0,
		math.random(-20, 20)
	)
	
	-- Create quantum tunnel
	for i = 1, 10 do
		local ring = Instance.new("Part")
		ring.Size = Vector3.new(5, 0.2, 5)
		ring.CFrame = originalCFrame * CFrame.new(0, 0, -i*3)
		ring.Anchored = true
		ring.CanCollide = false
		ring.Material = Enum.Material.Neon
		ring.Color = Color3.fromHSV(tick() % 1, 1, 1)
		ring.Parent = FXFolder
		
		TweenService:Create(ring, TweenInfo.new(0.1), {Transparency = 1}):Play()
		Debris:AddItem(ring, 0.5)
	end
	
	RootPart.CFrame = CFrame.new(targetPosition)
end

-- COSMIC AURA
local function createCosmicAura()
	local aura = Instance.new("Part")
	aura.Size = Vector3.new(MODES[CURRENT_MODE].auraSize, MODES[CURRENT_MODE].auraSize, MODES[CURRENT_MODE].auraSize)
	aura.Position = RootPart.Position
	aura.Anchored = true
	aura.CanCollide = false
	aura.Material = Enum.Material.Neon
	aura.Shape = Enum.PartType.Ball
	aura.Parent = FXFolder
	
	if CURRENT_MODE == "OMEGA EVOLUTION" then
		-- Cosmic effects
		local particles = Instance.new("ParticleEmitter")
		particles.Texture = "rbxassetid://242719275"
		particles.Rate = 100
		particles.Lifetime = NumberRange.new(0.5, 1)
		particles.Speed = NumberRange.new(10, 20)
		particles.Size = NumberSequence.new(0.2, 0.5)
		particles.Transparency = NumberSequence.new(0.3, 1)
		particles.Parent = aura
		
		local light = Instance.new("PointLight")
		light.Brightness = 10
		light.Range = 25
		light.Color = Color3.fromHSV(tick() % 1, 1, 1)
		light.Parent = aura
		
		-- Gravitational field
		local bodyForce = Instance.new("BodyForce")
		bodyForce.Force = Vector3.new(0, 50, 0)
		bodyForce.Parent = aura
	end
	
	return aura
end

-- PREDICTIVE DODGE SYSTEM
local function predictAttacks()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local hrp = player.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				local velocity = hrp.Velocity
				local distance = (hrp.Position - RootPart.Position).Magnitude
				
				if velocity.Magnitude > 50 and distance < 30 then
					local predictedPosition = hrp.Position + (velocity.Unit * distance * PREDICTION_TIME)
					
					-- Visual prediction indicator
					local indicator = Instance.new("Part")
					indicator.Size = Vector3.new(2, 2, 2)
					indicator.Position = predictedPosition
					indicator.Anchored = true
					indicator.CanCollide = false
					indicator.Material = Enum.Material.Neon
					indicator.Color = Color3.fromRGB(255, 0, 0)
					indicator.Transparency = 0.5
					indicator.Parent = FXFolder
					Debris:AddItem(indicator, 0.2)
				end
			end
		end
	end
end

-- COMBO SYSTEM
local function addCombo()
	local currentTime = tick()
	if currentTime - LAST_COMBO_TIME > COMBO_TIMEOUT then
		COMBO_COUNT = 0
	end
	
	COMBO_COUNT += 1
	LAST_COMBO_TIME = currentTime
	EVOLUTION_CHARGE = math.min(MAX_EVOLUTION, EVOLUTION_CHARGE + 10 * COMBO_COUNT)
	
	-- Combo effects
	ComboLabel.Visible = true
	ComboLabel.Text = "COMBO: " .. COMBO_COUNT .. "x"
	
	if COMBO_COUNT >= 10 then
		ComboLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
		ComboLabel.TextStrokeColor3 = Color3.fromRGB(255, 100, 0)
	elseif COMBO_COUNT >= 5 then
		ComboLabel.TextColor3 = Color3.fromRGB(255, 100, 255)
		ComboLabel.TextStrokeColor3 = Color3.fromRGB(150, 0, 255)
	end
	
	-- Auto-evolve at max combo
	if COMBO_COUNT >= 20 and CURRENT_MODE ~= "OMEGA EVOLUTION" then
		CURRENT_MODE = "OMEGA EVOLUTION"
		bendReality()
	end
	
	task.delay(COMBO_TIMEOUT, function()
		if tick() - LAST_COMBO_TIME >= COMBO_TIMEOUT then
			ComboLabel.Visible = false
			COMBO_COUNT = 0
		end
	end)
end

-- UPDATE GUI
local function updateGUI()
	EvolutionBar.Size = UDim2.new(EVOLUTION_CHARGE / MAX_EVOLUTION, 0, 1, 0)
	EvolutionLabel.Text = "EVOLUTION: " .. math.floor((EVOLUTION_CHARGE / MAX_EVOLUTION) * 100) .. "%"
	
	local color = MODES[CURRENT_MODE].color
	Frame.UIGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(color.R * 50, color.G * 50, color.B * 50)),
		ColorSequenceKeypoint.new(1, color)
	}
	
	ToggleButton.BackgroundColor3 = color
	Title.TextColor3 = color
end

-- MAIN UI FUNCTION
local function startUI()
	-- Clear old connections
	for _, conn in pairs(connections) do
		conn:Disconnect()
	end
	connections = {}
	
	local modeData = MODES[CURRENT_MODE]
	
	-- Speed boost
	Humanoid.WalkSpeed = 16 * modeData.speed
	
	-- Phasing ability
	if modeData.phasing then
		for _, part in pairs(Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
	
	-- Cosmic Aura
	local aura = createCosmicAura()
	connections.aura = RunService.Heartbeat:Connect(function()
		if not aura or not aura.Parent then return end
		aura.Position = RootPart.Position
		
		if CURRENT_MODE == "OMEGA EVOLUTION" then
			aura.Color = Color3.fromHSV(tick() % 1, 1, 1)
			aura.Size = Vector3.new(15 + math.sin(tick() * 5) * 3, 15 + math.cos(tick() * 5) * 3, 15)
		end
	end)
	
	-- Predictive dodging
	connections.prediction = RunService.Heartbeat:Connect(function()
		predictAttacks()
	end)
	
	-- Time dilation
	if modeData.timeSlow then
		connections.time = RunService.Heartbeat:Connect(function()
			if math.random(1, 100) <= 20 then -- 20% chance per frame
				slowTime(modeData.timeSlow)
			end
		end)
	end
	
	-- Enhanced dodge system
	connections.dodge = RunService.Heartbeat:Connect(function()
		local currentVelocity = RootPart.Velocity
		local velocityMagnitude = currentVelocity.Magnitude
		
		if velocityMagnitude > VELOCITY_THRESHOLD[CURRENT_MODE] then
			addCombo()
			
			if modeData.teleportDodge then
				quantumDodge(RootPart.Position)
			else
				-- Regular enhanced dodge
				local dodgeDirection = -currentVelocity.Unit
				local dodgeDistance = modeData.dodgeDist * (1 + COMBO_COUNT * 0.1)
				local newPosition = RootPart.Position + (dodgeDirection * dodgeDistance)
				
				RootPart.CFrame = CFrame.new(newPosition)
				RootPart.Velocity = Vector3.new(0, 0, 0)
			end
			
			-- Anti-fling
			if currentVelocity.Magnitude > 200 then
				local counterForce = -currentVelocity.Unit * ANTI_FLING_FORCE[CURRENT_MODE]
				RootPart:ApplyImpulse(counterForce)
			end
			
			-- Evolution gain
			EVOLUTION_CHARGE = math.min(MAX_EVOLUTION, EVOLUTION_CHARGE + 5)
			updateGUI()
		end
	end)
	
	-- Evolution auto-charge
	connections.evolution = RunService.Heartbeat:Connect(function(dt)
		EVOLUTION_CHARGE = math.min(MAX_EVOLUTION, EVOLUTION_CHARGE + dt * 10)
		updateGUI()
		
		-- Auto-evolve at max charge
		if EVOLUTION_CHARGE >= MAX_EVOLUTION and CURRENT_MODE ~= "OMEGA EVOLUTION" then
			CURRENT_MODE = "OMEGA EVOLUTION"
			bendReality()
			stopUI()
			task.wait(0.5)
			startUI()
		end
	end)
	
	-- Afterimage trail
	connections.afterimage = RunService.Heartbeat:Connect(function()
		if Humanoid.MoveDirection.Magnitude > 0 then
			for _, part in pairs(Character:GetDescendants()) do
				if part:IsA("BasePart") and part.Transparency < 1 then
					local clone = part:Clone()
					clone.Anchored = true
					clone.CanCollide = false
					clone.Material = Enum.Material.Neon
					clone.Color = Color3.fromHSV(tick() % 1, 1, 1)
					clone.Transparency = 0.3
					clone.CFrame = part.CFrame
					clone.Parent = FXFolder
					
					TweenService:Create(clone, TweenInfo.new(0.5), {
						Transparency = 1,
						Size = part.Size * 1.5
					}):Play()
					
					Debris:AddItem(clone, 0.5)
				end
			end
		end
	end)
end

local function stopUI()
	for _, conn in pairs(connections) do
		conn:Disconnect()
	end
	connections = {}
	
	Humanoid.WalkSpeed = 16
	
	-- Reset phasing
	for _, part in pairs(Character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = true
		end
	end
	
	-- Clear effects
	for _, v in pairs(FXFolder:GetChildren()) do
		v:Destroy()
	end
	
	-- Reset time
	RunService:SetTimeScale(1)
end

-- TOGGLE SYSTEM
ToggleButton.MouseButton1Click:Connect(function()
	UI_ENABLED = not UI_ENABLED
	
	if UI_ENABLED then
		ToggleButton.Text = "⚡ OMEGA ACTIVE ⚡"
		startUI()
		
		-- Initial evolution burst
		EVOLUTION_CHARGE = 100
		updateGUI()
	else
		ToggleButton.Text = "⚡ AWAKEN ⚡"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
		stopUI()
	end
end)

-- KEYBIND SUPPORT
UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.U then
		UI_ENABLED = not UI_ENABLED
		if UI_ENABLED then
			startUI()
		else
			stopUI()
		end
	end
	
	if input.KeyCode == Enum.KeyCode.F then
		if CURRENT_MODE == "OMEGA EVOLUTION" then
			bendReality()
		end
	end
end)

-- Character handling
LocalPlayer.CharacterAdded:Connect(function(char)
	waitForCharacter()
	if UI_ENABLED then
		task.wait(1)
		startUI()
	end
end)

-- Initialize
waitForCharacter()

print("⚡ OMEGA EVOLUTION LOADED ⚡")
print("🌟 MODES: MASTERED | PERFECTION | SUPERSKKSKSJSJSJ | OMEGA EVOLUTION")
print("⚡ FEATURES: Time Dilation | Quantum Dodge | Reality Bending | Predictive Dodging")
print("🎮 CONTROLS: U = Toggle | F = Reality Bend (Omega Mode)")
print("💥 COMBO SYSTEM: Chain dodges for evolution!")
