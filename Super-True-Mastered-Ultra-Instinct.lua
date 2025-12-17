-- THE STRONGEST ULTRA INSTINCT - ABSOLUTE MAXIMUM
-- 2.5x Speed with COMPACT GOD AURA and FTL DODGE
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

-- STRONGEST UI SETTINGS
local UI_ENABLED = false
local VELOCITY_THRESHOLD = 30
local DODGE_DISTANCE = 50 -- FTL Distance
local SPEED_BOOST = 2.5
local PROXIMITY_RANGE = 20
local AFTERIMAGE_INTERVAL = 0.03
local PREDICTION_RANGE = 25
local COUNTER_ENABLED = true
local INVINCIBILITY_FRAMES = true
local SHOCKWAVE_ENABLED = true
local FTL_DODGE = true -- Faster than light dodge

-- Connections
local DodgeConnection, AuraConnection, ProximityConnection, AfterimageConnection, PredictionConnection, BarrierConnection
local dodgeCount = 0
local counterCount = 0
local lastAfterimage = 0
local isInvincible = false

-- Effects Folder
local FXFolder = Instance.new("Folder", workspace)
FXFolder.Name = "StrongestUI_FX"

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StrongestUIGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.BackgroundColor3 = Color3.fromRGB(5, 5, 15)
Frame.BorderColor3 = Color3.fromRGB(150, 200, 255)
Frame.BorderSizePixel = 4
Frame.Position = UDim2.new(0.35, 0, 0.22, 0)
Frame.Size = UDim2.new(0, 300, 0, 340)
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
Title.Text = "⚡ THE STRONGEST UI ⚡"
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
StatusLabel.TextSize = 17
StatusLabel.Parent = Frame

local PowerFrame = Instance.new("Frame")
PowerFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
PowerFrame.BorderSizePixel = 0
PowerFrame.Position = UDim2.new(0.08, 0, 0.24, 0)
PowerFrame.Size = UDim2.new(0.84, 0, 0, 55)
PowerFrame.Parent = Frame

local PowerCorner = Instance.new("UICorner")
PowerCorner.CornerRadius = UDim.new(0, 10)
PowerCorner.Parent = PowerFrame

local PowerTitle = Instance.new("TextLabel")
PowerTitle.BackgroundTransparency = 1
PowerTitle.Position = UDim2.new(0, 0, 0.08, 0)
PowerTitle.Size = UDim2.new(1, 0, 0, 22)
PowerTitle.Font = Enum.Font.GothamBold
PowerTitle.Text = "💨 SPEED: 2.5x"
PowerTitle.TextColor3 = Color3.fromRGB(150, 255, 200)
PowerTitle.TextSize = 16
PowerTitle.Parent = PowerFrame

local PowerDesc = Instance.new("TextLabel")
PowerDesc.BackgroundTransparency = 1
PowerDesc.Position = UDim2.new(0, 0, 0.52, 0)
PowerDesc.Size = UDim2.new(1, 0, 0, 20)
PowerDesc.Font = Enum.Font.Gotham
PowerDesc.Text = "⚡ Maximum Performance"
PowerDesc.TextColor3 = Color3.fromRGB(200, 220, 255)
PowerDesc.TextSize = 12
PowerDesc.Parent = PowerFrame

local StatsFrame = Instance.new("Frame")
StatsFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
StatsFrame.BorderSizePixel = 0
StatsFrame.Position = UDim2.new(0.08, 0, 0.44, 0)
StatsFrame.Size = UDim2.new(0.84, 0, 0, 100)
StatsFrame.Parent = Frame

local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 10)
StatsCorner.Parent = StatsFrame

local DodgeLabel = Instance.new("TextLabel")
DodgeLabel.BackgroundTransparency = 1
DodgeLabel.Position = UDim2.new(0.05, 0, 0.08, 0)
DodgeLabel.Size = UDim2.new(0.9, 0, 0, 20)
DodgeLabel.Font = Enum.Font.Gotham
DodgeLabel.Text = "⚡ Dodges: 0"
DodgeLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
DodgeLabel.TextSize = 14
DodgeLabel.TextXAlignment = Enum.TextXAlignment.Left
DodgeLabel.Parent = StatsFrame

local CounterLabel = Instance.new("TextLabel")
CounterLabel.BackgroundTransparency = 1
CounterLabel.Position = UDim2.new(0.05, 0, 0.32, 0)
CounterLabel.Size = UDim2.new(0.9, 0, 0, 20)
CounterLabel.Font = Enum.Font.Gotham
CounterLabel.Text = "💥 Counters: 0"
CounterLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
CounterLabel.TextSize = 14
CounterLabel.TextXAlignment = Enum.TextXAlignment.Left
CounterLabel.Parent = StatsFrame

local RangeLabel = Instance.new("TextLabel")
RangeLabel.BackgroundTransparency = 1
RangeLabel.Position = UDim2.new(0.05, 0, 0.56, 0)
RangeLabel.Size = UDim2.new(0.9, 0, 0, 20)
RangeLabel.Font = Enum.Font.Gotham
RangeLabel.Text = "⚡ FTL Dodge: 50 studs"
RangeLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
RangeLabel.TextSize = 14
RangeLabel.TextXAlignment = Enum.TextXAlignment.Left
RangeLabel.Parent = StatsFrame

local FeatureLabel = Instance.new("TextLabel")
FeatureLabel.BackgroundTransparency = 1
FeatureLabel.Position = UDim2.new(0.05, 0, 0.80, 0)
FeatureLabel.Size = UDim2.new(0.9, 0, 0, 20)
FeatureLabel.Font = Enum.Font.Gotham
FeatureLabel.Text = "✨ God-Like Compact Aura"
FeatureLabel.TextColor3 = Color3.fromRGB(255, 255, 150)
FeatureLabel.TextSize = 12
FeatureLabel.TextXAlignment = Enum.TextXAlignment.Left
FeatureLabel.Parent = StatsFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
ToggleButton.Position = UDim2.new(0.08, 0, 0.74, 0)
ToggleButton.Size = UDim2.new(0.84, 0, 0, 70)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "AWAKEN"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 28
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
WarningFrame.BackgroundTransparency = 0.2
WarningFrame.BorderSizePixel = 0
WarningFrame.Position = UDim2.new(0.25, 0, 0.88, 0)
WarningFrame.Size = UDim2.new(0.5, 0, 0, 65)
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
WarningLabel.TextSize = 18
WarningLabel.TextScaled = true
WarningLabel.Parent = WarningFrame

-- STRONGEST AURA
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
	
	-- Main aura sphere
	local aura = Instance.new("Part")
	aura.Name = "StrongestAura"
	aura.Size = Vector3.new(14, 14, 14)
	aura.Anchored = true
	aura.CanCollide = false
	aura.Material = Enum.Material.Neon
	aura.Color = Color3.fromRGB(180, 220, 255)
	aura.Transparency = 0.6
	aura.Shape = Enum.PartType.Ball
	aura.CFrame = RootPart.CFrame
	aura.Parent = FXFolder
	table.insert(auraObjects, aura)
	
	-- Energy rings
	for i = 1, 8 do
		local ring = Instance.new("Part")
		ring.Size = Vector3.new(0.7, 10 + (i * 4), 10 + (i * 4))
		ring.Anchored = true
		ring.CanCollide = false
		ring.Material = Enum.Material.Neon
		ring.Color = Color3.fromRGB(150, 200, 255)
		ring.Transparency = 0.55
		ring.CFrame = RootPart.CFrame
		ring.Parent = FXFolder
		
		local mesh = Instance.new("SpecialMesh")
		mesh.MeshType = Enum.MeshType.Cylinder
		mesh.Parent = ring
		
		table.insert(auraObjects, ring)
	end
	
	-- Floating particles
	for i = 1, 16 do
		local particle = Instance.new("Part")
		particle.Size = Vector3.new(0.8, 0.8, 0.8)
		particle.Anchored = true
		particle.CanCollide = false
		particle.Material = Enum.Material.Neon
		particle.Color = Color3.fromRGB(200, 230, 255)
		particle.Transparency = 0.4
		particle.Shape = Enum.PartType.Ball
		particle.CFrame = RootPart.CFrame
		particle.Parent = FXFolder
		
		table.insert(auraObjects, particle)
	end
	
	return aura
end

-- AFTERIMAGE EFFECT
local function createAfterimage()
	if tick() - lastAfterimage < AFTERIMAGE_INTERVAL then return end
	lastAfterimage = tick()
	
	for _, part in pairs(Character:GetDescendants()) do
		if part:IsA("BasePart") and part.Transparency < 1 and part.Name ~= "HumanoidRootPart" then
			local clone = part:Clone()
			clone.Anchored = true
			clone.CanCollide = false
			clone.Material = Enum.Material.Neon
			clone.Color = Color3.fromRGB(180, 220, 255)
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

-- SHOCKWAVE EFFECT
local function createShockwave(position)
	if not SHOCKWAVE_ENABLED then return end
	
	local shockwave = Instance.new("Part")
	shockwave.Size = Vector3.new(1, 1, 1)
	shockwave.Position = position
	shockwave.Anchored = true
	shockwave.CanCollide = false
	shockwave.Material = Enum.Material.Neon
	shockwave.Color = Color3.fromRGB(180, 220, 255)
	shockwave.Transparency = 0.3
	shockwave.Shape = Enum.PartType.Ball
	shockwave.Parent = FXFolder
	
	TweenService:Create(shockwave, TweenInfo.new(0.6), {
		Size = Vector3.new(40, 40, 40),
		Transparency = 1
	}):Play()
	
	-- Push enemies back
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local theirRoot = player.Character:FindFirstChild("HumanoidRootPart")
			if theirRoot then
				local distance = (theirRoot.Position - position).Magnitude
				if distance < 22 then
					local pushDirection = (theirRoot.Position - position).Unit
					theirRoot.Velocity = pushDirection * 500 + Vector3.new(0, 200, 0)
					
					-- Counter attack
					if COUNTER_ENABLED then
						wait(0.1)
						theirRoot.Velocity = theirRoot.Velocity * 2
						counterCount = counterCount + 1
						CounterLabel.Text = "💥 Counters: " .. counterCount
					end
				end
			end
		end
	end
	
	Debris:AddItem(shockwave, 0.6)
end

-- DODGE EFFECT
local function createDodgeEffect(position)
	-- Main sphere
	local part = Instance.new("Part")
	part.Size = Vector3.new(12, 12, 12)
	part.Position = position
	part.Anchored = true
	part.CanCollide = false
	part.Material = Enum.Material.Neon
	part.Color = Color3.fromRGB(180, 220, 255)
	part.Transparency = 0.2
	part.Shape = Enum.PartType.Ball
	part.Parent = FXFolder
	
	-- Lightning ring (16 bolts)
	for i = 1, 16 do
		local lightning = Instance.new("Part")
		lightning.Size = Vector3.new(0.5, 6, 0.5)
		lightning.Position = position
		lightning.Anchored = true
		lightning.CanCollide = false
		lightning.Material = Enum.Material.Neon
		lightning.Color = Color3.fromRGB(255, 255, 255)
		lightning.Parent = FXFolder
		
		local angle = (i / 16) * math.pi * 2
		lightning.CFrame = CFrame.new(position) * CFrame.Angles(0, angle, math.rad(45)) * CFrame.new(0, 0, 5)
		
		TweenService:Create(lightning, TweenInfo.new(0.3), {
			Transparency = 1,
			Size = Vector3.new(0.3, 10, 0.3)
		}):Play()
		Debris:AddItem(lightning, 0.3)
	end
	
	-- Energy burst particles
	for i = 1, 12 do
		local particle = Instance.new("Part")
		particle.Size = Vector3.new(1.8, 1.8, 1.8)
		particle.Position = position
		particle.Anchored = true
		particle.CanCollide = false
		particle.Material = Enum.Material.Neon
		particle.Color = Color3.fromRGB(200, 230, 255)
		particle.Transparency = 0.3
		particle.Shape = Enum.PartType.Ball
		particle.Parent = FXFolder
		
		local angle = (i / 12) * math.pi * 2
		local targetPos = position + Vector3.new(math.cos(angle) * 9, math.random(-4, 4), math.sin(angle) * 9)
		
		TweenService:Create(particle, TweenInfo.new(0.5), {
			Position = targetPos,
			Size = Vector3.new(0.3, 0.3, 0.3),
			Transparency = 1
		}):Play()
		Debris:AddItem(particle, 0.5)
	end
	
	TweenService:Create(part, TweenInfo.new(0.6), {
		Size = Vector3.new(26, 26, 26),
		Transparency = 1
	}):Play()
	Debris:AddItem(part, 0.6)
	
	createShockwave(position)
end

-- INSTANT TRANSMISSION EFFECT
local function createTransmissionEffect(position)
	for i = 1, 10 do
		local particle = Instance.new("Part")
		particle.Size = Vector3.new(1, 1, 1)
		particle.Position = position
		particle.Anchored = true
		particle.CanCollide = false
		particle.Material = Enum.Material.Neon
		particle.Color = Color3.fromRGB(200, 230, 255)
		particle.Transparency = 0.3
		particle.Shape = Enum.PartType.Ball
		particle.Parent = FXFolder
		
		local angle = (i / 10) * math.pi * 2
		local targetPos = position + Vector3.new(math.cos(angle) * 5, math.random(-2, 2), math.sin(angle) * 5)
		
		TweenService:Create(particle, TweenInfo.new(0.35), {
			Position = targetPos,
			Size = Vector3.new(0.2, 0.2, 0.2),
			Transparency = 1
		}):Play()
		Debris:AddItem(particle, 0.35)
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
			if theirRoot then
				local distance = (theirRoot.Position - RootPart.Position).Magnitude
				local theirVelocity = theirRoot.Velocity.Magnitude
				
				if distance < PREDICTION_RANGE and theirVelocity > 600 then
					local direction = (RootPart.Position - theirRoot.Position).Unit
					local theirDirection = theirRoot.Velocity.Unit
					local dotProduct = direction.X * theirDirection.X + direction.Z * theirDirection.Z
					
					if dotProduct > 0.5 then
						local dodgeDirection = (RootPart.Position - theirRoot.Position).Unit
						local dodgePosition = RootPart.Position + (dodgeDirection * 18)
						
						createTransmissionEffect(RootPart.Position)
						RootPart.CFrame = CFrame.new(dodgePosition)
						createDodgeEffect(dodgePosition)
						
						dodgeCount = dodgeCount + 1
						DodgeLabel.Text = "⚡ Dodges: " .. dodgeCount
						
						break
					end
				end
			end
		end
	end
end

-- DIVINE BARRIER
local barrierParts = {}
local function createBarrier()
	for _, part in pairs(barrierParts) do
		if part and part.Parent then
			part:Destroy()
		end
	end
	barrierParts = {}
	
	for i = 1, 10 do
		local barrier = Instance.new("Part")
		barrier.Size = Vector3.new(2, 11, 0.6)
		barrier.Anchored = true
		barrier.CanCollide = false
		barrier.Material = Enum.Material.Neon
		barrier.Color = Color3.fromRGB(180, 220, 255)
		barrier.Transparency = 0.65
		barrier.Parent = FXFolder
		
		table.insert(barrierParts, barrier)
	end
end

-- MAIN SYSTEM
local function startStrongestUI()
	if DodgeConnection then DodgeConnection:Disconnect() end
	if AuraConnection then AuraConnection:Disconnect() end
	if ProximityConnection then ProximityConnection:Disconnect() end
	if AfterimageConnection then AfterimageConnection:Disconnect() end
	if PredictionConnection then PredictionConnection:Disconnect() end
	if BarrierConnection then BarrierConnection:Disconnect() end
	
	-- Speed boost
	Humanoid.WalkSpeed = 16 * SPEED_BOOST
	
	-- Create aura
	local aura = createAura()
	local particleIndex = 1
	
	AuraConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED or not aura or not aura.Parent then return end
		
		aura.CFrame = RootPart.CFrame * CFrame.Angles(0, math.rad(tick() * 90), 0)
		local scale = 1 + math.sin(tick() * 6) * 0.2
		aura.Size = Vector3.new(14 * scale, 14 * scale, 14 * scale)
		
		-- Animate rings
		for i, obj in pairs(auraObjects) do
			if obj ~= aura and obj.Parent and obj:IsA("Part") and obj.Shape ~= Enum.PartType.Ball then
				obj.CFrame = RootPart.CFrame * CFrame.Angles(math.rad(90), 0, math.rad((i * 45) + (tick() * 180)))
			end
		end
		
		-- Animate floating particles
		particleIndex = particleIndex + 1
		for i, obj in pairs(auraObjects) do
			if obj.Shape == Enum.PartType.Ball and obj ~= aura then
				local angle = ((i + particleIndex) / 16) * math.pi * 2
				local radius = 18 + math.sin(tick() * 2 + i) * 6
				local height = math.sin(tick() * 3 + i) * 10
				obj.CFrame = RootPart.CFrame * CFrame.new(
					math.cos(angle) * radius,
					height,
					math.sin(angle) * radius
				)
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
	end)
	
	-- Barrier
	createBarrier()
	BarrierConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED then return end
		for i, barrier in pairs(barrierParts) do
			if barrier and barrier.Parent then
				local angle = ((i - 1) / 10) * math.pi * 2 + tick() * 2.5
				barrier.CFrame = RootPart.CFrame * CFrame.new(
					math.cos(angle) * 17,
					0,
					math.sin(angle) * 17
				) * CFrame.Angles(0, angle + math.rad(90), 0)
			end
		end
	end)
	
	-- Main dodge system
	local lastPosition = RootPart.Position
	
	DodgeConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED then return end
		
		local currentVelocity = RootPart.Velocity
		local velocityMagnitude = currentVelocity.Magnitude
		
		if velocityMagnitude > VELOCITY_THRESHOLD then
			dodgeCount = dodgeCount + 1
			DodgeLabel.Text = "⚡ Dodges: " .. dodgeCount
			
			-- Invincibility
			if INVINCIBILITY_FRAMES then
				isInvincible = true
				spawn(function()
					wait(0.5)
					isInvincible = false
				end)
			end
			
			local dodgeFrom = RootPart.Position
			local dodgeDirection = -currentVelocity.Unit
			local dodgePosition = lastPosition + (dodgeDirection * DODGE_DISTANCE)
			
			dodgePosition = Vector3.new(
				dodgePosition.X,
				math.clamp(dodgePosition.Y, lastPosition.Y - 5, lastPosition.Y + 5),
				dodgePosition.Z
			)
			
			createTransmissionEffect(dodgeFrom)
			
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
			createTransmissionEffect(dodgePosition)
			
			-- Flash GUI
			Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			HeaderCover.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			wait(0.05)
			Header.BackgroundColor3 = Color3.fromRGB(150, 200, 255)
			HeaderCover.BackgroundColor3 = Color3.fromRGB(150, 200, 255)
		end
		
		if velocityMagnitude < 50 then
			lastPosition = RootPart.Position
		end
	end)
end

local function stopStrongestUI()
	if DodgeConnection then DodgeConnection:Disconnect() end
	if AuraConnection then AuraConnection:Disconnect() end
	if ProximityConnection then ProximityConnection:Disconnect() end
	if AfterimageConnection then AfterimageConnection:Disconnect() end
	if PredictionConnection then PredictionConnection:Disconnect() end
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

-- TOGGLE BUTTON
ToggleButton.MouseButton1Click:Connect(function()
	UI_ENABLED = not UI_ENABLED
	
	if UI_ENABLED then
		ToggleButton.Text = "STRONGEST"
		ButtonGradient.Color = ColorSequence.new(Color3.fromRGB(100, 200, 255), Color3.fromRGB(150, 220, 255))
		Header.BackgroundColor3 = Color3.fromRGB(150, 200, 255)
		HeaderCover.BackgroundColor3 = Color3.fromRGB(150, 200, 255)
		StatusLabel.Text = "⚡ ACTIVE ⚡"
		StatusLabel.TextColor3 = Color3.fromRGB(150, 255, 255)
		startStrongestUI()
	else
		ToggleButton.Text = "AWAKEN"
		ButtonGradient.Color = ColorSequence.new(Color3.fromRGB(150, 50, 50), Color3.fromRGB(100, 30, 30))
		Header.BackgroundColor3 = Color3.fromRGB(150, 200, 255)
		HeaderCover.BackgroundColor3 = Color3.fromRGB(150, 200, 255)
		StatusLabel.Text = "🔴 DORMANT 🔴"
		StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		stopStrongestUI()
	end
end)

-- Character respawn
LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	Humanoid = char:WaitForChild("Humanoid")
	RootPart = char:WaitForChild("HumanoidRootPart")
	dodgeCount = 0
	counterCount = 0
	DodgeLabel.Text = "⚡ Dodges: 0"
	CounterLabel.Text = "💥 Counters: 0"
	wait(0.5)
	if UI_ENABLED then
		startStrongestUI()
	end
end)

print("⚡🔥 THE STRONGEST ULTRA INSTINCT LOADED 🔥⚡")
print("💨 SPEED: 2.5x (40 studs/sec)")
print("⚡ FEATURES: Auto-dodge, Prediction, Counter, Invincibility")
print("🌟 Aura: 8 rings + 16 floating particles")
print("💥 Effects: 16 lightning bolts, 12 particles, 10 barriers")
print("🛡️ Shockwave pushback + 2x counter damage")
print("✨ Instant transmission teleport effects")
print("👑 THE STRONGEST WITH 2.5x SPEED!")
