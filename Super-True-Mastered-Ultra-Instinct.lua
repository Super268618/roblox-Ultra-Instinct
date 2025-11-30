-- PERFECTION ULTRA INSTINCT - REALITY TRANSCENDENCE
-- Sign, Mastered, Omen, and PERFECTION modes
-- Beyond all comprehension
-- Place in StarterPlayer → StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- PERFECTION SETTINGS
local UI_ENABLED = false
local UI_MODE = "MASTERED" -- SIGN, MASTERED, OMEN, PERFECTION
local VELOCITY_THRESHOLD = 40
local DODGE_DISTANCE = 60
local SPEED_BOOST_SIGN = 7.0
local SPEED_BOOST_MASTERED = 12.0
local SPEED_BOOST_OMEN = 18.0
local SPEED_BOOST_PERFECTION = 25.0 -- TRANSCENDENT
local PROXIMITY_RANGE = 35
local AFTERIMAGE_INTERVAL = 0.01
local PREDICTION_RANGE = 25
local SHOCKWAVE_ENABLED = true
local INSTANT_TRANSMISSION = true
local AUTO_COUNTER_ENABLED = true
local INVINCIBILITY_FRAMES = true
local TIME_DILATION = true -- NEW: Slow enemies
local REALITY_WARP = true -- NEW: Teleport enemies away
local DIVINE_BARRIER = true -- NEW: Force field

-- Connections
local DodgeConnection, AuraConnection, ProximityConnection, AfterimageConnection, PredictionConnection
local TimeDilationConnection, BarrierConnection
local dodgeCount = 0
local lastAfterimage = 0
local uiEnergy = 0
local isInvincible = false
local counterAttacks = 0
local realityWarps = 0

-- Effects Folder
local FXFolder = Instance.new("Folder", workspace)
FXFolder.Name = "PerfectionUI_FX"

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PerfectionUIGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
Frame.BorderColor3 = Color3.fromRGB(200, 150, 255)
Frame.BorderSizePixel = 5
Frame.Position = UDim2.new(0.3, 0, 0.2, 0)
Frame.Size = UDim2.new(0, 360, 0, 420)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 20)
UICorner.Parent = Frame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new(
	Color3.fromRGB(5, 5, 15),
	Color3.fromRGB(20, 15, 30),
	Color3.fromRGB(5, 5, 15)
)
UIGradient.Rotation = 45
UIGradient.Parent = Frame

local Header = Instance.new("Frame")
Header.BackgroundColor3 = Color3.fromRGB(200, 150, 255)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 50)
Header.Parent = Frame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 20)
HeaderCorner.Parent = Header

local HeaderCover = Instance.new("Frame")
HeaderCover.BackgroundColor3 = Color3.fromRGB(200, 150, 255)
HeaderCover.BorderSizePixel = 0
HeaderCover.Position = UDim2.new(0, 0, 0.5, 0)
HeaderCover.Size = UDim2.new(1, 0, 0.5, 0)
HeaderCover.Parent = Header

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "💫 PERFECTION UI 💫"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.TextScaled = true
Title.Parent = Header

local StatusLabel = Instance.new("TextLabel")
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.06, 0, 0.135, 0)
StatusLabel.Size = UDim2.new(0.88, 0, 0, 32)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Text = "🔴 DORMANT 🔴"
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.TextSize = 18
StatusLabel.Parent = Frame

local ModeFrame = Instance.new("Frame")
ModeFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
ModeFrame.BorderSizePixel = 0
ModeFrame.Position = UDim2.new(0.06, 0, 0.215, 0)
ModeFrame.Size = UDim2.new(0.88, 0, 0, 60)
ModeFrame.Parent = Frame

local ModeCorner = Instance.new("UICorner")
ModeCorner.CornerRadius = UDim.new(0, 12)
ModeCorner.Parent = ModeFrame

local ModeLabel = Instance.new("TextLabel")
ModeLabel.BackgroundTransparency = 1
ModeLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
ModeLabel.Size = UDim2.new(0.9, 0, 0, 24)
ModeLabel.Font = Enum.Font.GothamBold
ModeLabel.Text = "🌟 MODE: MASTERED 🌟"
ModeLabel.TextColor3 = Color3.fromRGB(150, 220, 255)
ModeLabel.TextSize = 15
ModeLabel.Parent = ModeFrame

local ModeToggle = Instance.new("TextButton")
ModeToggle.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
ModeToggle.Position = UDim2.new(0.1, 0, 0.55, 0)
ModeToggle.Size = UDim2.new(0.8, 0, 0, 24)
ModeToggle.Font = Enum.Font.Gotham
ModeToggle.Text = "Switch Mode"
ModeToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ModeToggle.TextSize = 13
local ModeToggleCorner = Instance.new("UICorner")
ModeToggleCorner.CornerRadius = UDim.new(0, 8)
ModeToggleCorner.Parent = ModeToggle
ModeToggle.Parent = ModeFrame

local StatsFrame = Instance.new("Frame")
StatsFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
StatsFrame.BorderSizePixel = 0
StatsFrame.Position = UDim2.new(0.06, 0, 0.385, 0)
StatsFrame.Size = UDim2.new(0.88, 0, 0, 140)
StatsFrame.Parent = Frame

local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 12)
StatsCorner.Parent = StatsFrame

local DodgeLabel = Instance.new("TextLabel")
DodgeLabel.BackgroundTransparency = 1
DodgeLabel.Position = UDim2.new(0.05, 0, 0.06, 0)
DodgeLabel.Size = UDim2.new(0.9, 0, 0, 20)
DodgeLabel.Font = Enum.Font.Gotham
DodgeLabel.Text = "⚡ Dodges: 0"
DodgeLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
DodgeLabel.TextSize = 14
DodgeLabel.TextXAlignment = Enum.TextXAlignment.Left
DodgeLabel.Parent = StatsFrame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Position = UDim2.new(0.05, 0, 0.22, 0)
SpeedLabel.Size = UDim2.new(0.9, 0, 0, 20)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Text = "💨 Speed: 12.0x"
SpeedLabel.TextColor3 = Color3.fromRGB(150, 255, 200)
SpeedLabel.TextSize = 14
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = StatsFrame

local CounterLabel = Instance.new("TextLabel")
CounterLabel.BackgroundTransparency = 1
CounterLabel.Position = UDim2.new(0.05, 0, 0.38, 0)
CounterLabel.Size = UDim2.new(0.9, 0, 0, 20)
CounterLabel.Font = Enum.Font.Gotham
CounterLabel.Text = "💥 Counters: 0"
CounterLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
CounterLabel.TextSize = 14
CounterLabel.TextXAlignment = Enum.TextXAlignment.Left
CounterLabel.Parent = StatsFrame

local WarpLabel = Instance.new("TextLabel")
WarpLabel.BackgroundTransparency = 1
WarpLabel.Position = UDim2.new(0.05, 0, 0.54, 0)
WarpLabel.Size = UDim2.new(0.9, 0, 0, 20)
WarpLabel.Font = Enum.Font.Gotham
WarpLabel.Text = "🌀 Warps: 0"
WarpLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
WarpLabel.TextSize = 14
WarpLabel.TextXAlignment = Enum.TextXAlignment.Left
WarpLabel.Parent = StatsFrame

local EnergyLabel = Instance.new("TextLabel")
EnergyLabel.BackgroundTransparency = 1
EnergyLabel.Position = UDim2.new(0.05, 0, 0.70, 0)
EnergyLabel.Size = UDim2.new(0.9, 0, 0, 20)
EnergyLabel.Font = Enum.Font.Gotham
EnergyLabel.Text = "🔋 Energy: 0%"
EnergyLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
EnergyLabel.TextSize = 14
EnergyLabel.TextXAlignment = Enum.TextXAlignment.Left
EnergyLabel.Parent = StatsFrame

local FeatureLabel = Instance.new("TextLabel")
FeatureLabel.BackgroundTransparency = 1
FeatureLabel.Position = UDim2.new(0.05, 0, 0.86, 0)
FeatureLabel.Size = UDim2.new(0.9, 0, 0, 20)
FeatureLabel.Font = Enum.Font.Gotham
FeatureLabel.Text = "💫 TRANSCENDENCE MODE"
FeatureLabel.TextColor3 = Color3.fromRGB(255, 200, 255)
FeatureLabel.TextSize = 12
FeatureLabel.TextXAlignment = Enum.TextXAlignment.Left
FeatureLabel.Parent = StatsFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
ToggleButton.Position = UDim2.new(0.06, 0, 0.72, 0)
ToggleButton.Size = UDim2.new(0.88, 0, 0, 90)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "AWAKEN"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 32
ToggleButton.Parent = Frame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 16)
ButtonCorner.Parent = ToggleButton

local ButtonGradient = Instance.new("UIGradient")
ButtonGradient.Color = ColorSequence.new(Color3.fromRGB(150, 50, 50), Color3.fromRGB(100, 30, 30))
ButtonGradient.Rotation = 90
ButtonGradient.Parent = ToggleButton

-- WARNING SYSTEM (ENHANCED)
local WarningFrame = Instance.new("Frame")
WarningFrame.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
WarningFrame.BackgroundTransparency = 0.2
WarningFrame.BorderSizePixel = 0
WarningFrame.Position = UDim2.new(0.25, 0, 0.88, 0)
WarningFrame.Size = UDim2.new(0.5, 0, 0, 70)
WarningFrame.Visible = false
WarningFrame.Parent = ScreenGui

local WarningCorner = Instance.new("UICorner")
WarningCorner.CornerRadius = UDim.new(0, 14)
WarningCorner.Parent = WarningFrame

local WarningLabel = Instance.new("TextLabel")
WarningLabel.BackgroundTransparency = 1
WarningLabel.Size = UDim2.new(1, 0, 1, 0)
WarningLabel.Font = Enum.Font.GothamBold
WarningLabel.Text = "⚠️ THREAT DETECTED ⚠️"
WarningLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WarningLabel.TextSize = 18
WarningLabel.TextScaled = true
WarningLabel.Parent = WarningFrame

-- PERFECTION AURA
local auraObjects = {}

local function destroyAura()
	for _, obj in pairs(auraObjects) do
		if obj and obj.Parent then
			obj:Destroy()
		end
	end
	auraObjects = {}
end

local function createAura()
	destroyAura()
	
	local auraColor, ringColor, auraSize, ringCount
	
	if UI_MODE == "PERFECTION" then
		auraColor = Color3.fromRGB(255, 240, 255)
		ringColor = Color3.fromRGB(255, 200, 255)
		auraSize = 30
		ringCount = 12
	elseif UI_MODE == "OMEN" then
		auraColor = Color3.fromRGB(255, 255, 255)
		ringColor = Color3.fromRGB(240, 240, 255)
		auraSize = 25
		ringCount = 8
	elseif UI_MODE == "MASTERED" then
		auraColor = Color3.fromRGB(220, 240, 255)
		ringColor = Color3.fromRGB(180, 220, 255)
		auraSize = 18
		ringCount = 5
	else -- SIGN
		auraColor = Color3.fromRGB(120, 170, 220)
		ringColor = Color3.fromRGB(100, 140, 200)
		auraSize = 15
		ringCount = 5
	end
	
	-- Main aura
	local aura = Instance.new("Part")
	aura.Name = "PerfectionAura"
	aura.Size = Vector3.new(auraSize, auraSize, auraSize)
	aura.Anchored = true
	aura.CanCollide = false
	aura.Material = Enum.Material.Neon
	aura.Color = auraColor
	aura.Transparency = UI_MODE == "PERFECTION" and 0.4 or 0.55
	aura.Shape = Enum.PartType.Ball
	aura.CFrame = RootPart.CFrame
	aura.Parent = FXFolder
	table.insert(auraObjects, aura)
	
	-- Energy rings
	for i = 1, ringCount do
		local ring = Instance.new("Part")
		ring.Size = Vector3.new(0.8, 8 + (i * 6), 8 + (i * 6))
		ring.Anchored = true
		ring.CanCollide = false
		ring.Material = Enum.Material.Neon
		ring.Color = ringColor
		ring.Transparency = 0.5
		ring.CFrame = RootPart.CFrame
		ring.Parent = FXFolder
		
		local mesh = Instance.new("SpecialMesh")
		mesh.MeshType = Enum.MeshType.Cylinder
		mesh.Parent = ring
		
		table.insert(auraObjects, ring)
	end
	
	-- PERFECTION MODE: Divine particles
	if UI_MODE == "PERFECTION" then
		for i = 1, 20 do
			local particle = Instance.new("Part")
			particle.Size = Vector3.new(0.8, 0.8, 0.8)
			particle.Anchored = true
			particle.CanCollide = false
			particle.Material = Enum.Material.Neon
			particle.Color = Color3.fromRGB(255, 240, 255)
			particle.Transparency = 0.3
			particle.Shape = Enum.PartType.Ball
			particle.CFrame = RootPart.CFrame
			particle.Parent = FXFolder
			
			table.insert(auraObjects, particle)
		end
	end
	
	return aura
end

-- AFTERIMAGE EFFECT (PERFECTION)
local function createAfterimage()
	if tick() - lastAfterimage < AFTERIMAGE_INTERVAL then return end
	lastAfterimage = tick()
	
	local color
	if UI_MODE == "PERFECTION" then
		color = Color3.fromRGB(255, 240, 255)
	elseif UI_MODE == "OMEN" then
		color = Color3.fromRGB(255, 255, 255)
	elseif UI_MODE == "MASTERED" then
		color = Color3.fromRGB(200, 220, 255)
	else
		color = Color3.fromRGB(100, 150, 200)
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
			
			TweenService:Create(clone, TweenInfo.new(0.5), {Transparency = 1}):Play()
			Debris:AddItem(clone, 0.5)
		end
	end
end

-- SHOCKWAVE EFFECT (PERFECTION)
local function createShockwave(position)
	if not SHOCKWAVE_ENABLED then return end
	
	local power, size
	if UI_MODE == "PERFECTION" then
		power = 1000
		size = 60
	elseif UI_MODE == "OMEN" then
		power = 600
		size = 45
	else
		power = 400
		size = 35
	end
	
	local shockwave = Instance.new("Part")
	shockwave.Size = Vector3.new(1, 1, 1)
	shockwave.Position = position
	shockwave.Anchored = true
	shockwave.CanCollide = false
	shockwave.Material = Enum.Material.Neon
	shockwave.Color = UI_MODE == "PERFECTION" and Color3.fromRGB(255, 240, 255) or (UI_MODE == "OMEN" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 230, 255))
	shockwave.Transparency = 0.1
	shockwave.Shape = Enum.PartType.Ball
	shockwave.Parent = FXFolder
	
	TweenService:Create(shockwave, TweenInfo.new(0.8), {
		Size = Vector3.new(size, size, size),
		Transparency = 1
	}):Play()
	
	-- Push enemies
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local theirRoot = player.Character:FindFirstChild("HumanoidRootPart")
			if theirRoot then
				local distance = (theirRoot.Position - position).Magnitude
				if distance < 30 then
					local pushDirection = (theirRoot.Position - position).Unit
					theirRoot.Velocity = pushDirection * power + Vector3.new(0, 250, 0)
					
					-- Counter in OMEN+
					if AUTO_COUNTER_ENABLED and (UI_MODE == "OMEN" or UI_MODE == "PERFECTION") then
						wait(0.1)
						local multiplier = UI_MODE == "PERFECTION" and 3 or 2
						theirRoot.Velocity = theirRoot.Velocity * multiplier
						counterAttacks = counterAttacks + 1
						CounterLabel.Text = "💥 Counters: " .. counterAttacks
					end
					
					-- Reality warp in PERFECTION
					if REALITY_WARP and UI_MODE == "PERFECTION" and distance < 20 then
						wait(0.2)
						theirRoot.CFrame = theirRoot.CFrame + Vector3.new(math.random(-100, 100), 200, math.random(-100, 100))
						realityWarps = realityWarps + 1
						WarpLabel.Text = "🌀 Warps: " .. realityWarps
					end
				end
			end
		end
	end
	
	Debris:AddItem(shockwave, 0.8)
end

-- DODGE EFFECT (PERFECTION)
local function createDodgeEffect(position)
	local boltCount, sphereSize, particleCount
	
	if UI_MODE == "PERFECTION" then
		boltCount = 40
		sphereSize = 18
		particleCount = 24
	elseif UI_MODE == "OMEN" then
		boltCount = 30
		sphereSize = 15
		particleCount = 16
	else
		boltCount = 20
		sphereSize = 12
		particleCount = 12
	end
	
	-- Main sphere
	local part = Instance.new("Part")
	part.Size = Vector3.new(sphereSize, sphereSize, sphereSize)
	part.Position = position
	part.Anchored = true
	part.CanCollide = false
	part.Material = Enum.Material.Neon
	part.Color = UI_MODE == "PERFECTION" and Color3.fromRGB(255, 240, 255) or (UI_MODE == "OMEN" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 230, 255))
	part.Transparency = 0.1
	part.Shape = Enum.PartType.Ball
	part.Parent = FXFolder
	
	-- Lightning bolts
	for i = 1, boltCount do
		local lightning = Instance.new("Part")
		lightning.Size = Vector3.new(0.7, 11, 0.7)
		lightning.Position = position
		lightning.Anchored = true
		lightning.CanCollide = false
		lightning.Material = Enum.Material.Neon
		lightning.Color = Color3.fromRGB(255, 255, 255)
		lightning.Parent = FXFolder
		
		local angle = (i / boltCount) * math.pi * 2
		lightning.CFrame = CFrame.new(position) * CFrame.Angles(0, angle, math.rad(45)) * CFrame.new(0, 0, 7)
		
		TweenService:Create(lightning, TweenInfo.new(0.4), {
			Transparency = 1,
			Size = Vector3.new(0.4, 18, 0.4)
		}):Play()
		Debris:AddItem(lightning, 0.4)
	end
	
	-- Energy particles
	for i = 1, particleCount do
		local particle = Instance.new("Part")
		particle.Size = Vector3.new(2.5, 2.5, 2.5)
		particle.Position = position
		particle.Anchored = true
		particle.CanCollide = false
		particle.Material = Enum.Material.Neon
		particle.Color = UI_MODE == "PERFECTION" and Color3.fromRGB(255, 220, 255) or (UI_MODE == "OMEN" and Color3.fromRGB(255, 255, 200) or Color3.fromRGB(180, 220, 255))
		particle.Transparency = 0.2
		particle.Shape = Enum.PartType.Ball
		particle.Parent = FXFolder
		
		local angle = (i / particleCount) * math.pi * 2
		local targetPos = position + Vector3.new(math.cos(angle) * 12, math.random(-5, 5), math.sin(angle) * 12)
		
		TweenService:Create(particle, TweenInfo.new(0.6), {
			Position = targetPos,
			Size = Vector3.new(0.2, 0.2, 0.2),
			Transparency = 1
		}):Play()
		Debris:AddItem(particle, 0.6)
	end
	
	TweenService:Create(part, TweenInfo.new(0.8), {
		Size = Vector3.new(sphereSize * 3, sphereSize * 3, sphereSize * 3),
		Transparency = 1
	}):Play()
	Debris:AddItem(part, 0.8)
	
	createShockwave(position)
end

-- INSTANT TRANSMISSION EFFECT
local function createTransmissionEffect(position)
	local count = UI_MODE == "PERFECTION" and 16 or 8
	for i = 1, count do
		local particle = Instance.new("Part")
		particle.Size = Vector3.new(1.2, 1.2, 1.2)
		particle.Position = position
		particle.Anchored = true
		particle.CanCollide = false
		particle.Material = Enum.Material.Neon
		particle.Color = UI_MODE == "PERFECTION" and Color3.fromRGB(255, 240, 255) or Color3.fromRGB(255, 255, 200)
		particle.Transparency = 0.2
		particle.Shape = Enum.PartType.Ball
		particle.Parent = FXFolder
		
		local angle = (i / count) * math.pi * 2
		local targetPos = position + Vector3.new(math.cos(angle) * 6, math.random(-3, 3), math.sin(angle) * 6)
		
		TweenService:Create(particle, TweenInfo.new(0.4), {
			Position = targetPos,
			Size = Vector3.new(0.1, 0.1, 0.1),
			Transparency = 1
		}):Play()
		Debris:AddItem(particle, 0.4)
	end
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
		TweenService:Create(WarningFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.05}):Play()
		wait(0.2)
		TweenService:Create(WarningFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
	end
end

-- PREDICTION DODGE
local function checkPrediction()
	if not UI_ENABLED then return end
	
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local theirRoot = player.Character:FindFirstChild("HumanoidRootPart")
			local theirHumanoid = player.Character:FindFirstChild("Humanoid")
			if theirRoot and theirHumanoid then
				local distance = (theirRoot.Position - RootPart.Position).Magnitude
				local theirVelocity = theirRoot.Velocity.Magnitude
				
				if distance < PREDICTION_RANGE and theirVelocity > 500 then
					local direction = (RootPart.Position - theirRoot.Position).Unit
					local theirDirection = theirRoot.Velocity.Unit
					
					local dotProduct = direction.X * theirDirection.X + direction.Z * theirDirection.Z
					
					if dotProduct > 0.5 then
						local dodgeDirection = (RootPart.Position - theirRoot.Position).Unit
						local dodgePosition = RootPart.Position + (dodgeDirection * 20)
						
						if INSTANT_TRANSMISSION then
							createTransmissionEffect(RootPart.Position)
						end
						
						RootPart.CFrame = CFrame.new(dodgePosition)
						createDodgeEffect(dodgePosition)
						
						dodgeCount = dodgeCount + 1
						DodgeLabel.Text = "⚡ Dodges: " .. dodgeCount
						uiEnergy = math.min(100, uiEnergy + 5)
						
						break
					end
				end
			end
		end
	end
end

-- TIME DILATION (PERFECTION MODE)
local function applyTimeDilation()
	if not TIME_DILATION or UI_MODE ~= "PERFECTION" then return end
	
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local theirHumanoid = player.Character:FindFirstChild("Humanoid")
			local theirRoot = player.Character:FindFirstChild("HumanoidRootPart")
			if theirHumanoid and theirRoot then
				local distance = (theirRoot.Position - RootPart.Position).Magnitude
				if distance < 40 then
					-- Slow them down
					theirHumanoid.WalkSpeed = math.max(theirHumanoid.WalkSpeed * 0.5, 4)
				end
			end
		end
	end
end

-- DIVINE BARRIER (PERFECTION MODE)
local barrierParts = {}
local function createDivineBarrier()
	if not DIVINE_BARRIER or UI_MODE ~= "PERFECTION" then return end
	
	for _, part in pairs(barrierParts) do
		if part and part.Parent then
			part:Destroy()
		end
	end
	barrierParts = {}
	
	for i = 1, 12 do
		local barrier = Instance.new("Part")
		barrier.Size = Vector3.new(2, 10, 0.5)
		barrier.Anchored = true
		barrier.CanCollide = false
		barrier.Material = Enum.Material.Neon
		barrier.Color = Color3.fromRGB(255, 240, 255)
		barrier.Transparency = 0.7
		barrier.Parent = FXFolder
		
		table.insert(barrierParts, barrier)
	end
end

-- MAIN PERFECTION SYSTEM
local function startPerfectionUI()
	if DodgeConnection then DodgeConnection:Disconnect() end
	if AuraConnection then AuraConnection:Disconnect() end
	if ProximityConnection then ProximityConnection:Disconnect() end
	if AfterimageConnection then AfterimageConnection:Disconnect() end
	if PredictionConnection then PredictionConnection:Disconnect() end
	if TimeDilationConnection then TimeDilationConnection:Disconnect() end
	if BarrierConnection then BarrierConnection:Disconnect() end
	
	-- Speed boost
	local speedMultiplier
	if UI_MODE == "PERFECTION" then
		speedMultiplier = SPEED_BOOST_PERFECTION
	elseif UI_MODE == "OMEN" then
		speedMultiplier = SPEED_BOOST_OMEN
	elseif UI_MODE == "MASTERED" then
		speedMultiplier = SPEED_BOOST_MASTERED
	else
		speedMultiplier = SPEED_BOOST_SIGN
	end
	
	Humanoid.WalkSpeed = 16 * speedMultiplier
	SpeedLabel.Text = "💨 Speed: " .. speedMultiplier .. "x"
	
	-- Create aura
	local aura = createAura()
	local rotSpeed = UI_MODE == "PERFECTION" and 180 or (UI_MODE == "OMEN" and 120 or 80)
	local particleIndex = 1
	
	AuraConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED or not aura or not aura.Parent then return end
		
		aura.CFrame = RootPart.CFrame * CFrame.Angles(0, math.rad(tick() * rotSpeed), 0)
		local scale = 1 + math.sin(tick() * 7) * 0.3
		local baseSize = UI_MODE == "PERFECTION" and 30 or (UI_MODE == "OMEN" and 25 or (UI_MODE == "MASTERED" and 18 or 15))
		aura.Size = Vector3.new(baseSize * scale, baseSize * scale, baseSize * scale)
		
		-- Animate rings
		for i, obj in pairs(auraObjects) do
			if obj ~= aura and obj.Parent and obj:IsA("Part") and obj.Shape ~= Enum.PartType.Ball then
				obj.CFrame = RootPart.CFrame * CFrame.Angles(math.rad(90), 0, math.rad((i * 30) + (tick() * rotSpeed * 2)))
			end
		end
		
		-- Animate floating particles (PERFECTION)
		if UI_MODE == "PERFECTION" then
			particleIndex = particleIndex + 1
			for i, obj in pairs(auraObjects) do
				if obj.Shape == Enum.PartType.Ball and obj ~= aura then
					local angle = ((i + particleIndex) / 20) * math.pi * 2
					local radius = 20 + math.sin(tick() * 2 + i) * 5
					local height = math.sin(tick() * 3 + i) * 8
					obj.CFrame = RootPart.CFrame * CFrame.new(
						math.cos(angle) * radius,
						height,
						math.sin(angle) * radius
					)
				end
			end
		end
	end)
	
	-- Proximity detection
	ProximityConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED then return end
		checkProximity()
	end)
	
	-- Prediction
	local predictionTick = 0
	PredictionConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED then return end
		predictionTick = predictionTick + 1
		if predictionTick >= 10 then
			checkPrediction()
			predictionTick = 0
		end
	end)
	
	-- Afterimages
	AfterimageConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED then return end
		if Humanoid.MoveDirection.Magnitude > 0 then
			createAfterimage()
		end
		
		uiEnergy = math.max(0, uiEnergy - 0.1)
		EnergyLabel.Text = "🔋 Energy: " .. math.floor(uiEnergy) .. "%"
	end)
	
	-- Time dilation (PERFECTION)
	if UI_MODE == "PERFECTION" then
		TimeDilationConnection = RunService.Heartbeat:Connect(function()
			if not UI_ENABLED then return end
			applyTimeDilation()
		end)
		
		createDivineBarrier()
		BarrierConnection = RunService.Heartbeat:Connect(function()
			if not UI_ENABLED then return end
			for i, barrier in pairs(barrierParts) do
				if barrier and barrier.Parent then
					local angle = ((i - 1) / 12) * math.pi * 2 + tick() * 2
					barrier.CFrame = RootPart.CFrame * CFrame.new(
						math.cos(angle) * 15,
						0,
						math.sin(angle) * 15
					) * CFrame.Angles(0, angle + math.rad(90), 0)
				end
			end
		end)
	end
	
	-- Main dodge system
	local lastPosition = RootPart.Position
	
	DodgeConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED then return end
		
		local currentVelocity = RootPart.Velocity
		local velocityMagnitude = currentVelocity.Magnitude
		
		if velocityMagnitude > VELOCITY_THRESHOLD then
			dodgeCount = dodgeCount + 1
			DodgeLabel.Text = "⚡ Dodges: " .. dodgeCount
			uiEnergy = math.min(100, uiEnergy + 20)
			
			-- Invincibility
			isInvincible = true
			spawn(function()
				wait(0.5)
				isInvincible = false
			end)
			
			local dodgeFrom = RootPart.Position
			local dodgeDirection = -currentVelocity.Unit
			local dodgePosition = lastPosition + (dodgeDirection * DODGE_DISTANCE)
			
			dodgePosition = Vector3.new(
				dodgePosition.X,
				math.clamp(dodgePosition.Y, lastPosition.Y - 5, lastPosition.Y + 5),
				dodgePosition.Z
			)
			
			if INSTANT_TRANSMISSION then
				createTransmissionEffect(dodgeFrom)
			end
			
			-- INSTANT DODGE
			RootPart.CFrame = CFrame.new(dodgePosition)
			RootPart.Velocity = Vector3.new(0, 0, 0)
			RootPart.RotVelocity = Vector3.new(0, 0, 0)
			
			for _, part in pairs(Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Velocity = Vector3.new(0, 0, 0)
					part.RotVelocity = Vector3.new(0, 0, 0)
				end
			end
			
			createDodgeEffect(dodgeFrom)
			createDodgeEffect(dodgePosition)
			
			if INSTANT_TRANSMISSION then
				createTransmissionEffect(dodgePosition)
			end
			
			-- Flash GUI
			Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			HeaderCover.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			wait(0.05)
			local headerColor
			if UI_MODE == "PERFECTION" then
				headerColor = Color3.fromRGB(255, 200, 255)
			elseif UI_MODE == "OMEN" then
				headerColor = Color3.fromRGB(255, 255, 255)
			elseif UI_MODE == "MASTERED" then
				headerColor = Color3.fromRGB(150, 200, 255)
			else
				headerColor = Color3.fromRGB(100, 150, 200)
			end
			Header.BackgroundColor3 = headerColor
			HeaderCover.BackgroundColor3 = headerColor
		end
		
		if velocityMagnitude < 50 then
			lastPosition = RootPart.Position
		end
	end)
end

local function stopPerfectionUI()
	if DodgeConnection then DodgeConnection:Disconnect() end
	if AuraConnection then AuraConnection:Disconnect() end
	if ProximityConnection then ProximityConnection:Disconnect() end
	if AfterimageConnection then AfterimageConnection:Disconnect() end
	if PredictionConnection then PredictionConnection:Disconnect() end
	if TimeDilationConnection then TimeDilationConnection:Disconnect() end
	if BarrierConnection then BarrierConnection:Disconnect() end
	
	Humanoid.WalkSpeed = 16
	WarningFrame.Visible = false
	destroyAura()
	
	for _, part in pairs(barrierParts) do
		if part and part.Parent then
			part:Destroy()
		end
	end
	barrierParts = {}
end

-- MODE TOGGLE (4 MODES)
ModeToggle.MouseButton1Click:Connect(function()
	if UI_MODE == "MASTERED" then
		UI_MODE = "SIGN"
	elseif UI_MODE == "SIGN" then
		UI_MODE = "OMEN"
	elseif UI_MODE == "OMEN" then
		UI_MODE = "PERFECTION"
	else
		UI_MODE = "MASTERED"
	end
	
	if UI_MODE == "PERFECTION" then
		ModeLabel.Text = "💫 MODE: PERFECTION 💫"
		ModeLabel.TextColor3 = Color3.fromRGB(255, 200, 255)
		ModeToggle.BackgroundColor3 = Color3.fromRGB(255, 150, 255)
		Frame.BorderColor3 = Color3.fromRGB(255, 200, 255)
	elseif UI_MODE == "OMEN" then
		ModeLabel.Text = "💎 MODE: OMEN 💎"
		ModeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		ModeToggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
	elseif UI_MODE == "MASTERED" then
		ModeLabel.Text = "🌟 MODE: MASTERED 🌟"
		ModeLabel.TextColor3 = Color3.fromRGB(150, 220, 255)
		ModeToggle.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
		Frame.BorderColor3 = Color3.fromRGB(150, 200, 255)
	else
		ModeLabel.Text = "⚡ MODE: SIGN ⚡"
		ModeLabel.TextColor3 = Color3.fromRGB(100, 150, 200)
		ModeToggle.BackgroundColor3 = Color3.fromRGB(80, 120, 180)
		Frame.BorderColor3 = Color3.fromRGB(100, 150, 200)
	end
	
	if UI_ENABLED then
		stopPerfectionUI()
		wait(0.1)
		startPerfectionUI()
	end
end)

-- TOGGLE BUTTON
ToggleButton.MouseButton1Click:Connect(function()
	UI_ENABLED = not UI_ENABLED
	
	if UI_ENABLED then
		ToggleButton.Text = UI_MODE
		ButtonGradient.Color = ColorSequence.new(Color3.fromRGB(150, 100, 255), Color3.fromRGB(200, 150, 255))
		local headerColor
		if UI_MODE == "PERFECTION" then
			headerColor = Color3.fromRGB(255, 200, 255)
		elseif UI_MODE == "OMEN" then
			headerColor = Color3.fromRGB(255, 255, 255)
		elseif UI_MODE == "MASTERED" then
			headerColor = Color3.fromRGB(150, 200, 255)
		else
			headerColor = Color3.fromRGB(100, 150, 200)
		end
		Header.BackgroundColor3 = headerColor
		HeaderCover.BackgroundColor3 = headerColor
		StatusLabel.Text = "⚡ TRANSCENDENT ⚡"
		StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 255)
		startPerfectionUI()
	else
		ToggleButton.Text = "AWAKEN"
		ButtonGradient.Color = ColorSequence.new(Color3.fromRGB(150, 50, 50), Color3.fromRGB(100, 30, 30))
		Header.BackgroundColor3 = Color3.fromRGB(200, 150, 255)
		HeaderCover.BackgroundColor3 = Color3.fromRGB(200, 150, 255)
		StatusLabel.Text = "🔴 DORMANT 🔴"
		StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		stopPerfectionUI()
	end
end)

-- Character respawn
LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	Humanoid = char:WaitForChild("Humanoid")
	RootPart = char:WaitForChild("HumanoidRootPart")
	dodgeCount = 0
	counterAttacks = 0
	realityWarps = 0
	uiEnergy = 0
	DodgeLabel.Text = "⚡ Dodges: 0"
	CounterLabel.Text = "💥 Counters: 0"
	WarpLabel.Text = "🌀 Warps: 0"
	EnergyLabel.Text = "🔋 Energy: 0%"
	wait(0.5)
	if UI_ENABLED then
		startPerfectionUI()
	end
end)

print("💫🌌⚡ PERFECTION ULTRA INSTINCT LOADED ⚡🌌💫")
print("🌟 4 MODES: SIGN (7x), MASTERED (12x), OMEN (18x), PERFECTION (25x!)")
print("💫 PERFECTION: Time dilation, reality warps, divine barrier")
print("✨ Up to 40 lightning bolts, 24 particles, 12 rings")
print("💥 1000 knockback force, 3x counter damage")
print("🌀 Teleport enemies away, slow them down")
print("🛡️ Floating divine barrier + invincibility")
print("👑 ABSOLUTE TRANSCENDENT PERFECTION!")
