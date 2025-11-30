-- LIMIT BREAKER ULTRA INSTINCT - ABSOLUTE MAXIMUM POWER
-- Sign Omen + Mastered UI modes, Instant Transmission, Shockwaves, Clone Spam, and MORE!
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

-- LIMIT BREAKER SETTINGS
local UI_ENABLED = false
local UI_MODE = "MASTERED" -- SIGN or MASTERED
local VELOCITY_THRESHOLD = 80
local DODGE_DISTANCE = 30
local SPEED_BOOST_SIGN = 3.5
local SPEED_BOOST_MASTERED = 5.0
local PROXIMITY_RANGE = 20
local AFTERIMAGE_INTERVAL = 0.05
local PREDICTION_RANGE = 12 -- Dodge before they touch you
local SHOCKWAVE_ENABLED = true
local INSTANT_TRANSMISSION = true

-- Connections
local DodgeConnection, AuraConnection, ProximityConnection, AfterimageConnection, PredictionConnection
local dodgeCount = 0
local lastAfterimage = 0
local uiEnergy = 0

-- Effects Folder
local FXFolder = Instance.new("Folder", workspace)
FXFolder.Name = "LimitBreakerUI_FX"

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LimitBreakerUIGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.BackgroundColor3 = Color3.fromRGB(5, 5, 15)
Frame.BorderColor3 = Color3.fromRGB(150, 200, 255)
Frame.BorderSizePixel = 4
Frame.Position = UDim2.new(0.32, 0, 0.22, 0)
Frame.Size = UDim2.new(0, 320, 0, 340)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 18)
UICorner.Parent = Frame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new(Color3.fromRGB(10, 10, 25), Color3.fromRGB(25, 25, 50))
UIGradient.Rotation = 45
UIGradient.Parent = Frame

local Header = Instance.new("Frame")
Header.BackgroundColor3 = Color3.fromRGB(150, 200, 255)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 45)
Header.Parent = Frame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 18)
HeaderCorner.Parent = Header

local HeaderCover = Instance.new("Frame")
HeaderCover.BackgroundColor3 = Color3.fromRGB(150, 200, 255)
HeaderCover.BorderSizePixel = 0
HeaderCover.Position = UDim2.new(0, 0, 0.5, 0)
HeaderCover.Size = UDim2.new(1, 0, 0.5, 0)
HeaderCover.Parent = Header

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ LIMIT BREAKER UI ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextScaled = true
Title.Parent = Header

local StatusLabel = Instance.new("TextLabel")
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.08, 0, 0.15, 0)
StatusLabel.Size = UDim2.new(0.84, 0, 0, 28)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Text = "🔴 DORMANT 🔴"
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.TextSize = 16
StatusLabel.Parent = Frame

local ModeFrame = Instance.new("Frame")
ModeFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
ModeFrame.BorderSizePixel = 0
ModeFrame.Position = UDim2.new(0.08, 0, 0.24, 0)
ModeFrame.Size = UDim2.new(0.84, 0, 0, 50)
ModeFrame.Parent = Frame

local ModeCorner = Instance.new("UICorner")
ModeCorner.CornerRadius = UDim.new(0, 10)
ModeCorner.Parent = ModeFrame

local ModeLabel = Instance.new("TextLabel")
ModeLabel.BackgroundTransparency = 1
ModeLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
ModeLabel.Size = UDim2.new(0.9, 0, 0, 20)
ModeLabel.Font = Enum.Font.GothamBold
ModeLabel.Text = "🌟 MODE: MASTERED 🌟"
ModeLabel.TextColor3 = Color3.fromRGB(150, 220, 255)
ModeLabel.TextSize = 14
ModeLabel.Parent = ModeFrame

local ModeToggle = Instance.new("TextButton")
ModeToggle.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
ModeToggle.Position = UDim2.new(0.1, 0, 0.5, 0)
ModeToggle.Size = UDim2.new(0.8, 0, 0, 20)
ModeToggle.Font = Enum.Font.Gotham
ModeToggle.Text = "Switch to SIGN OMEN"
ModeToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ModeToggle.TextSize = 12
local ModeToggleCorner = Instance.new("UICorner")
ModeToggleCorner.CornerRadius = UDim.new(0, 6)
ModeToggleCorner.Parent = ModeToggle
ModeToggle.Parent = ModeFrame

local StatsFrame = Instance.new("Frame")
StatsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
StatsFrame.BorderSizePixel = 0
StatsFrame.Position = UDim2.new(0.08, 0, 0.42, 0)
StatsFrame.Size = UDim2.new(0.84, 0, 0, 90)
StatsFrame.Parent = Frame

local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 10)
StatsCorner.Parent = StatsFrame

local DodgeLabel = Instance.new("TextLabel")
DodgeLabel.BackgroundTransparency = 1
DodgeLabel.Position = UDim2.new(0.05, 0, 0.08, 0)
DodgeLabel.Size = UDim2.new(0.9, 0, 0, 18)
DodgeLabel.Font = Enum.Font.Gotham
DodgeLabel.Text = "⚡ Dodges: 0"
DodgeLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
DodgeLabel.TextSize = 13
DodgeLabel.TextXAlignment = Enum.TextXAlignment.Left
DodgeLabel.Parent = StatsFrame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Position = UDim2.new(0.05, 0, 0.32, 0)
SpeedLabel.Size = UDim2.new(0.9, 0, 0, 18)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Text = "💨 Speed: 8.0x"
SpeedLabel.TextColor3 = Color3.fromRGB(150, 255, 200)
SpeedLabel.TextSize = 13
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = StatsFrame

local EnergyLabel = Instance.new("TextLabel")
EnergyLabel.BackgroundTransparency = 1
EnergyLabel.Position = UDim2.new(0.05, 0, 0.56, 0)
EnergyLabel.Size = UDim2.new(0.9, 0, 0, 18)
EnergyLabel.Font = Enum.Font.Gotham
EnergyLabel.Text = "🔋 Energy: 0%"
EnergyLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
EnergyLabel.TextSize = 13
EnergyLabel.TextXAlignment = Enum.TextXAlignment.Left
EnergyLabel.Parent = StatsFrame

local FeatureLabel = Instance.new("TextLabel")
FeatureLabel.BackgroundTransparency = 1
FeatureLabel.Position = UDim2.new(0.05, 0, 0.8, 0)
FeatureLabel.Size = UDim2.new(0.9, 0, 0, 18)
FeatureLabel.Font = Enum.Font.Gotham
FeatureLabel.Text = "✨ MAXIMUM POWER MODE"
FeatureLabel.TextColor3 = Color3.fromRGB(255, 255, 150)
FeatureLabel.TextSize = 11
FeatureLabel.TextXAlignment = Enum.TextXAlignment.Left
FeatureLabel.Parent = StatsFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
ToggleButton.Position = UDim2.new(0.08, 0, 0.72, 0)
ToggleButton.Size = UDim2.new(0.84, 0, 0, 70)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "AWAKEN"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 26
ToggleButton.Parent = Frame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 14)
ButtonCorner.Parent = ToggleButton

local ButtonGradient = Instance.new("UIGradient")
ButtonGradient.Color = ColorSequence.new(Color3.fromRGB(150, 50, 50), Color3.fromRGB(100, 30, 30))
ButtonGradient.Rotation = 90
ButtonGradient.Parent = ToggleButton

-- WARNING SYSTEM
local WarningFrame = Instance.new("Frame")
WarningFrame.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
WarningFrame.BackgroundTransparency = 0.3
WarningFrame.BorderSizePixel = 0
WarningFrame.Position = UDim2.new(0.3, 0, 0.88, 0)
WarningFrame.Size = UDim2.new(0.4, 0, 0, 60)
WarningFrame.Visible = false
WarningFrame.Parent = ScreenGui

local WarningCorner = Instance.new("UICorner")
WarningCorner.CornerRadius = UDim.new(0, 12)
WarningCorner.Parent = WarningFrame

local WarningLabel = Instance.new("TextLabel")
WarningLabel.BackgroundTransparency = 1
WarningLabel.Size = UDim2.new(1, 0, 1, 0)
WarningLabel.Font = Enum.Font.GothamBold
WarningLabel.Text = "⚠️ THREAT DETECTED ⚠️"
WarningLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WarningLabel.TextSize = 16
WarningLabel.TextScaled = true
WarningLabel.Parent = WarningFrame

-- LIMIT BREAKER AURA (ENHANCED)
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
	
	local isMastered = UI_MODE == "MASTERED"
	local auraColor = isMastered and Color3.fromRGB(220, 240, 255) or Color3.fromRGB(120, 170, 220)
	local ringColor = isMastered and Color3.fromRGB(180, 220, 255) or Color3.fromRGB(100, 140, 200)
	
	-- Main aura (bigger)
	local aura = Instance.new("Part")
	aura.Name = "LimitBreakerAura"
	aura.Size = Vector3.new(18, 18, 18)
	aura.Anchored = true
	aura.CanCollide = false
	aura.Material = Enum.Material.Neon
	aura.Color = auraColor
	aura.Transparency = isMastered and 0.6 or 0.7
	aura.Shape = Enum.PartType.Ball
	aura.CFrame = RootPart.CFrame
	aura.Parent = FXFolder
	table.insert(auraObjects, aura)
	
	-- Multiple energy rings
	for i = 1, 5 do
		local ring = Instance.new("Part")
		ring.Size = Vector3.new(0.6, 12 + (i * 4), 12 + (i * 4))
		ring.Anchored = true
		ring.CanCollide = false
		ring.Material = Enum.Material.Neon
		ring.Color = ringColor
		ring.Transparency = 0.65
		ring.CFrame = RootPart.CFrame
		ring.Parent = FXFolder
		
		local mesh = Instance.new("SpecialMesh")
		mesh.MeshType = Enum.MeshType.Cylinder
		mesh.Parent = ring
		
		table.insert(auraObjects, ring)
	end
	
	return aura
end

-- AFTERIMAGE EFFECT (ENHANCED)
local function createAfterimage()
	if tick() - lastAfterimage < AFTERIMAGE_INTERVAL then return end
	lastAfterimage = tick()
	
	for _, part in pairs(Character:GetDescendants()) do
		if part:IsA("BasePart") and part.Transparency < 1 and part.Name ~= "HumanoidRootPart" then
			local clone = part:Clone()
			clone.Anchored = true
			clone.CanCollide = false
			clone.Material = Enum.Material.Neon
			clone.Color = UI_MODE == "MASTERED" and Color3.fromRGB(200, 220, 255) or Color3.fromRGB(100, 150, 200)
			clone.Transparency = 0.4
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

-- SHOCKWAVE EFFECT (ENHANCED)
local function createShockwave(position)
	if not SHOCKWAVE_ENABLED then return end
	
	local shockwave = Instance.new("Part")
	shockwave.Size = Vector3.new(1, 1, 1)
	shockwave.Position = position
	shockwave.Anchored = true
	shockwave.CanCollide = false
	shockwave.Material = Enum.Material.Neon
	shockwave.Color = Color3.fromRGB(200, 230, 255)
	shockwave.Transparency = 0.2
	shockwave.Shape = Enum.PartType.Ball
	shockwave.Parent = FXFolder
	
	-- Expand shockwave (BIGGER)
	TweenService:Create(shockwave, TweenInfo.new(0.6), {
		Size = Vector3.new(35, 35, 35),
		Transparency = 1
	}):Play()
	
	-- Push nearby players (STRONGER)
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local theirRoot = player.Character:FindFirstChild("HumanoidRootPart")
			if theirRoot then
				local distance = (theirRoot.Position - position).Magnitude
				if distance < 20 then
					local pushDirection = (theirRoot.Position - position).Unit
					theirRoot.Velocity = pushDirection * 400 + Vector3.new(0, 150, 0)
				end
			end
		end
	end
	
	Debris:AddItem(shockwave, 0.6)
end

-- DODGE EFFECT (MAXIMUM POWER)
local function createDodgeEffect(position)
	-- Main sphere (BIGGER)
	local part = Instance.new("Part")
	part.Size = Vector3.new(12, 12, 12)
	part.Position = position
	part.Anchored = true
	part.CanCollide = false
	part.Material = Enum.Material.Neon
	part.Color = Color3.fromRGB(200, 230, 255)
	part.Transparency = 0.15
	part.Shape = Enum.PartType.Ball
	part.Parent = FXFolder
	
	-- Lightning ring (MORE BOLTS)
	for i = 1, 20 do
		local lightning = Instance.new("Part")
		lightning.Size = Vector3.new(0.5, 7, 0.5)
		lightning.Position = position
		lightning.Anchored = true
		lightning.CanCollide = false
		lightning.Material = Enum.Material.Neon
		lightning.Color = Color3.fromRGB(255, 255, 255)
		lightning.Parent = FXFolder
		
		local angle = (i / 20) * math.pi * 2
		lightning.CFrame = CFrame.new(position) * CFrame.Angles(0, angle, math.rad(45)) * CFrame.new(0, 0, 5)
		
		TweenService:Create(lightning, TweenInfo.new(0.3), {
			Transparency = 1,
			Size = Vector3.new(0.3, 12, 0.3)
		}):Play()
		Debris:AddItem(lightning, 0.3)
	end
	
	-- Energy burst particles
	for i = 1, 12 do
		local particle = Instance.new("Part")
		particle.Size = Vector3.new(1.5, 1.5, 1.5)
		particle.Position = position
		particle.Anchored = true
		particle.CanCollide = false
		particle.Material = Enum.Material.Neon
		particle.Color = Color3.fromRGB(180, 220, 255)
		particle.Transparency = 0.3
		particle.Shape = Enum.PartType.Ball
		particle.Parent = FXFolder
		
		local angle = (i / 12) * math.pi * 2
		local targetPos = position + Vector3.new(math.cos(angle) * 8, math.random(-3, 3), math.sin(angle) * 8)
		
		TweenService:Create(particle, TweenInfo.new(0.4), {
			Position = targetPos,
			Size = Vector3.new(0.3, 0.3, 0.3),
			Transparency = 1
		}):Play()
		Debris:AddItem(particle, 0.4)
	end
	
	TweenService:Create(part, TweenInfo.new(0.6), {
		Size = Vector3.new(24, 24, 24),
		Transparency = 1
	}):Play()
	Debris:AddItem(part, 0.6)
	
	createShockwave(position)
end

-- INSTANT TRANSMISSION EFFECT
local function createTransmissionEffect(position)
	for i = 1, 8 do
		local particle = Instance.new("Part")
		particle.Size = Vector3.new(1, 1, 1)
		particle.Position = position
		particle.Anchored = true
		particle.CanCollide = false
		particle.Material = Enum.Material.Neon
		particle.Color = Color3.fromRGB(255, 255, 200)
		particle.Transparency = 0.3
		particle.Shape = Enum.PartType.Ball
		particle.Parent = FXFolder
		
		local angle = (i / 8) * math.pi * 2
		local targetPos = position + Vector3.new(math.cos(angle) * 5, math.random(-2, 2), math.sin(angle) * 5)
		
		TweenService:Create(particle, TweenInfo.new(0.3), {
			Position = targetPos,
			Size = Vector3.new(0.2, 0.2, 0.2),
			Transparency = 1
		}):Play()
		Debris:AddItem(particle, 0.3)
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
		TweenService:Create(WarningFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
		wait(0.2)
		TweenService:Create(WarningFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play()
	end
end

-- PREDICTION DODGE (Dodge before contact)
local function checkPrediction()
	if not UI_ENABLED then return end
	
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local theirRoot = player.Character:FindFirstChild("HumanoidRootPart")
			local theirHumanoid = player.Character:FindFirstChild("Humanoid")
			if theirRoot and theirHumanoid then
				local distance = (theirRoot.Position - RootPart.Position).Magnitude
				local theirVelocity = theirRoot.Velocity.Magnitude
				
				-- Only trigger if they have EXTREME velocity (likely fling attack)
				-- AND they're moving toward you
				if distance < PREDICTION_RANGE and theirVelocity > 500 then
					local direction = (RootPart.Position - theirRoot.Position).Unit
					local theirDirection = theirRoot.Velocity.Unit
					
					-- Check if they're actually moving toward you
					local dotProduct = direction.X * theirDirection.X + direction.Z * theirDirection.Z
					
					if dotProduct > 0.5 then -- Moving toward you
						-- Predict dodge
						local dodgeDirection = (RootPart.Position - theirRoot.Position).Unit
						local dodgePosition = RootPart.Position + (dodgeDirection * 15)
						
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

-- MAIN LIMIT BREAKER SYSTEM
local function startLimitBreakerUI()
	if DodgeConnection then DodgeConnection:Disconnect() end
	if AuraConnection then AuraConnection:Disconnect() end
	if ProximityConnection then ProximityConnection:Disconnect() end
	if AfterimageConnection then AfterimageConnection:Disconnect() end
	if PredictionConnection then PredictionConnection:Disconnect() end
	
	-- Speed boost
	local speedMultiplier = UI_MODE == "MASTERED" and SPEED_BOOST_MASTERED or SPEED_BOOST_SIGN
	Humanoid.WalkSpeed = 16 * speedMultiplier
	SpeedLabel.Text = "💨 Speed: " .. speedMultiplier .. "x"
	
	-- Create aura with multiple rings
	local aura = createAura()
	local ringIndex = 0
	AuraConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED or not aura or not aura.Parent then return end
		
		aura.CFrame = RootPart.CFrame * CFrame.Angles(0, math.rad(tick() * 80), 0)
		local scale = 1 + math.sin(tick() * 5) * 0.2
		aura.Size = Vector3.new(18 * scale, 18 * scale, 18 * scale)
		
		-- Animate all rings
		ringIndex = ringIndex + 1
		for i, obj in pairs(auraObjects) do
			if obj ~= aura and obj.Parent then
				obj.CFrame = RootPart.CFrame * CFrame.Angles(math.rad(90), 0, math.rad((i * 72) + (tick() * 150)))
			end
		end
	end)
	
	-- Proximity detection
	ProximityConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED then return end
		checkProximity()
	end)
	
	-- Prediction system (check less frequently to avoid false triggers)
	local predictionTick = 0
	PredictionConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED then return end
		predictionTick = predictionTick + 1
		if predictionTick >= 10 then -- Only check every 10 frames
			checkPrediction()
			predictionTick = 0
		end
	end)
	
	-- Afterimage trail
	AfterimageConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED then return end
		if Humanoid.MoveDirection.Magnitude > 0 then
			createAfterimage()
		end
		
		-- Energy decay
		uiEnergy = math.max(0, uiEnergy - 0.1)
		EnergyLabel.Text = "🔋 Energy: " .. math.floor(uiEnergy) .. "%"
	end)
	
	-- Dodge system
	local lastPosition = RootPart.Position
	
	DodgeConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED then return end
		
		local currentVelocity = RootPart.Velocity
		local velocityMagnitude = currentVelocity.Magnitude
		
		-- DETECT FLING ATTACK
		if velocityMagnitude > VELOCITY_THRESHOLD then
			dodgeCount = dodgeCount + 1
			DodgeLabel.Text = "⚡ Dodges: " .. dodgeCount
			uiEnergy = math.min(100, uiEnergy + 10)
			
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
			local headerColor = UI_MODE == "MASTERED" and Color3.fromRGB(150, 200, 255) or Color3.fromRGB(100, 150, 200)
			Header.BackgroundColor3 = headerColor
			HeaderCover.BackgroundColor3 = headerColor
		end
		
		if velocityMagnitude < 50 then
			lastPosition = RootPart.Position
		end
	end)
end

local function stopLimitBreakerUI()
	if DodgeConnection then DodgeConnection:Disconnect() end
	if AuraConnection then AuraConnection:Disconnect() end
	if ProximityConnection then ProximityConnection:Disconnect() end
	if AfterimageConnection then AfterimageConnection:Disconnect() end
	if PredictionConnection then PredictionConnection:Disconnect() end
	
	Humanoid.WalkSpeed = 16
	WarningFrame.Visible = false
	destroyAura()
end

-- MODE TOGGLE
ModeToggle.MouseButton1Click:Connect(function()
	UI_MODE = UI_MODE == "MASTERED" and "SIGN" or "MASTERED"
	
	if UI_MODE == "MASTERED" then
		ModeLabel.Text = "🌟 MODE: MASTERED 🌟"
		ModeLabel.TextColor3 = Color3.fromRGB(150, 220, 255)
		ModeToggle.Text = "Switch to SIGN OMEN"
		ModeToggle.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
		Frame.BorderColor3 = Color3.fromRGB(150, 200, 255)
	else
		ModeLabel.Text = "⚡ MODE: SIGN OMEN ⚡"
		ModeLabel.TextColor3 = Color3.fromRGB(100, 150, 200)
		ModeToggle.Text = "Switch to MASTERED"
		ModeToggle.BackgroundColor3 = Color3.fromRGB(80, 120, 180)
		Frame.BorderColor3 = Color3.fromRGB(100, 150, 200)
	end
	
	if UI_ENABLED then
		stopLimitBreakerUI()
		wait(0.1)
		startLimitBreakerUI()
	end
end)

-- TOGGLE BUTTON
ToggleButton.MouseButton1Click:Connect(function()
	UI_ENABLED = not UI_ENABLED
	
	if UI_ENABLED then
		ToggleButton.Text = UI_MODE == "MASTERED" and "MASTERED" or "SIGN ACTIVE"
		ButtonGradient.Color = ColorSequence.new(Color3.fromRGB(100, 200, 255), Color3.fromRGB(150, 220, 255))
		local headerColor = UI_MODE == "MASTERED" and Color3.fromRGB(150, 200, 255) or Color3.fromRGB(100, 150, 200)
		Header.BackgroundColor3 = headerColor
		HeaderCover.BackgroundColor3 = headerColor
		StatusLabel.Text = "⚡ ACTIVE ⚡"
		StatusLabel.TextColor3 = Color3.fromRGB(150, 255, 255)
		startLimitBreakerUI()
	else
		ToggleButton.Text = "AWAKEN"
		ButtonGradient.Color = ColorSequence.new(Color3.fromRGB(150, 50, 50), Color3.fromRGB(100, 30, 30))
		Header.BackgroundColor3 = Color3.fromRGB(150, 200, 255)
		HeaderCover.BackgroundColor3 = Color3.fromRGB(150, 200, 255)
		StatusLabel.Text = "🔴 DORMANT 🔴"
		StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		stopLimitBreakerUI()
	end
end)

-- Character respawn
LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	Humanoid = char:WaitForChild("Humanoid")
	RootPart = char:WaitForChild("HumanoidRootPart")
	dodgeCount = 0
	uiEnergy = 0
	DodgeLabel.Text = "⚡ Dodges: 0"
	EnergyLabel.Text = "🔋 Energy: 0%"
	wait(0.5)
	if UI_ENABLED then
		startLimitBreakerUI()
	end
end)

print("⚡🔥 LIMIT BREAKER ULTRA INSTINCT LOADED 🔥⚡")
print("🌟 MAXIMUM POWER MODE ACTIVATED!")
print("💨 MASTERED: 8x speed | SIGN: 5x speed")
print("💥 Enhanced shockwaves (400 knockback)")
print("✨ 20 lightning bolts per dodge")
print("🌀 5 spinning energy rings")
print("⚡ Bigger aura, faster afterimages")
print("👑 THE ABSOLUTE ULTIMATE ULTRA INSTINCT!")
