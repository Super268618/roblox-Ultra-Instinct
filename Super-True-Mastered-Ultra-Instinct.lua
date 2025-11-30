-- PURE MASTERED ULTRA INSTINCT - True Goku Style
-- Focused on perfect dodging, smooth movements, and authentic UI visuals

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- 🎯 PURE UI SETTINGS
local UI_ENABLED = false
local VELOCITY_THRESHOLD = 60 -- Dodge actual attacks, not normal movement
local DODGE_DISTANCE = 15 -- Short, precise dodges
local SPEED_BOOST = 3.0 -- Enhanced but reasonable speed
local AFTERIMAGE_INTERVAL = 0.06 -- Smooth afterimages
local SHOCKWAVE_ENABLED = true
local INSTANT_TRANSMISSION = true

-- Connections
local DodgeConnection, AuraConnection, AfterimageConnection
local dodgeCount = 0
local lastAfterimage = 0
local uiEnergy = 0

-- Effects Folder
local FXFolder = Instance.new("Folder", workspace)
FXFolder.Name = "PureUIFX"

-- 🎯 CLEAN UI GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PureUIGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
Frame.BorderColor3 = Color3.fromRGB(200, 220, 255)
Frame.BorderSizePixel = 2
Frame.Position = UDim2.new(0.35, 0, 0.25, 0)
Frame.Size = UDim2.new(0, 300, 0, 180)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 5)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ MASTERED ULTRA INSTINCT ⚡"
Title.TextColor3 = Color3.fromRGB(200, 220, 255)
Title.TextSize = 14
Title.Parent = Frame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.1, 0, 0.2, 0)
StatusLabel.Size = UDim2.new(0.8, 0, 0, 25)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Text = "🔴 DORMANT"
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.TextSize = 16
StatusLabel.Parent = Frame

local DodgeLabel = Instance.new("TextLabel")
DodgeLabel.BackgroundTransparency = 1
DodgeLabel.Position = UDim2.new(0.1, 0, 0.4, 0)
DodgeLabel.Size = UDim2.new(0.8, 0, 0, 20)
DodgeLabel.Font = Enum.Font.Gotham
DodgeLabel.Text = "⚡ Dodges: 0"
DodgeLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
DodgeLabel.TextSize = 13
DodgeLabel.TextXAlignment = Enum.TextXAlignment.Left
DodgeLabel.Parent = Frame

local EnergyLabel = Instance.new("TextLabel")
EnergyLabel.BackgroundTransparency = 1
EnergyLabel.Position = UDim2.new(0.1, 0, 0.55, 0)
EnergyLabel.Size = UDim2.new(0.8, 0, 0, 20)
EnergyLabel.Font = Enum.Font.Gotham
EnergyLabel.Text = "💠 Energy: 0%"
EnergyLabel.TextColor3 = Color3.fromRGB(180, 200, 255)
EnergyLabel.TextSize = 13
EnergyLabel.TextXAlignment = Enum.TextXAlignment.Left
EnergyLabel.Parent = Frame

local ToggleButton = Instance.new("TextButton")
ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
ToggleButton.Position = UDim2.new(0.1, 0, 0.75, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0, 35)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "AWAKEN"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 16
ToggleButton.Parent = Frame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = ToggleButton

-- 🎯 PURE UI AURA SYSTEM
local auraObjects = {}

local function destroyAura()
	for _, obj in pairs(auraObjects) do
		if obj and obj.Parent then
			obj:Destroy()
		end
	end
	auraObjects = {}
end

local function createPureUIAura()
	destroyAura()
	
	-- Main UI Aura (Authentic silver-blue)
	local aura = Instance.new("Part")
	aura.Name = "PureUIAura"
	aura.Size = Vector3.new(10, 10, 10) -- Perfect Goku-style size
	aura.Anchored = true
	aura.CanCollide = false
	aura.Material = Enum.Material.Neon
	aura.Color = Color3.fromRGB(200, 220, 255) -- Silver-blue UI color
	aura.Transparency = 0.6
	aura.Shape = Enum.PartType.Ball
	aura.CFrame = RootPart.CFrame
	aura.Parent = FXFolder
	table.insert(auraObjects, aura)
	
	-- Energy rings (like in the anime)
	for i = 1, 2 do
		local ring = Instance.new("Part")
		ring.Size = Vector3.new(0.3, 6 + (i * 2), 6 + (i * 2))
		ring.Anchored = true
		ring.CanCollide = false
		ring.Material = Enum.Material.Neon
		ring.Color = Color3.fromRGB(180, 210, 255)
		ring.Transparency = 0.7
		ring.CFrame = RootPart.CFrame
		ring.Parent = FXFolder
		
		local mesh = Instance.new("SpecialMesh")
		mesh.MeshType = Enum.MeshType.Cylinder
		mesh.Parent = ring
		
		table.insert(auraObjects, ring)
	end
	
	return aura
end

-- 🎯 SMOOTH AFTERIMAGE EFFECT
local function createAfterimage()
	if tick() - lastAfterimage < AFTERIMAGE_INTERVAL then return end
	lastAfterimage = tick()
	
	-- Only create afterimages during fast movement
	if Humanoid.MoveDirection.Magnitude > 0.5 then
		for _, part in pairs(Character:GetDescendants()) do
			if part:IsA("BasePart") and part.Transparency < 1 and part.Name ~= "HumanoidRootPart" then
				local clone = part:Clone()
				clone.Anchored = true
				clone.CanCollide = false
				clone.Material = Enum.Material.Neon
				clone.Color = Color3.fromRGB(180, 210, 255) -- UI silver-blue
				clone.Transparency = 0.6
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
end

-- 🎯 PURE DODGE EFFECT (Anime-accurate)
local function createDodgeEffect(position)
	-- Quick energy flash (like in the anime)
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
	
	-- Quick expanding rings
	for i = 1, 8 do
		local ring = Instance.new("Part")
		ring.Size = Vector3.new(0.2, 4, 4)
		ring.Position = position
		ring.Anchored = true
		ring.CanCollide = false
		ring.Material = Enum.Material.Neon
		ring.Color = Color3.fromRGB(200, 220, 255)
		ring.Parent = FXFolder
		
		local angle = (i / 8) * math.pi * 2
		ring.CFrame = CFrame.new(position) * CFrame.Angles(0, angle, 0) * CFrame.new(0, 0, 3)
		
		TweenService:Create(ring, TweenInfo.new(0.2), {
			Transparency = 1,
			Size = Vector3.new(0.1, 8, 8)
		}):Play()
		Debris:AddItem(ring, 0.2)
	end
	
	TweenService:Create(flash, TweenInfo.new(0.3), {
		Size = Vector3.new(12, 12, 12),
		Transparency = 1
	}):Play()
	Debris:AddItem(flash, 0.3)
end

-- 🎯 INSTANT TRANSMISSION EFFECT
local function createTransmissionEffect(position)
	for i = 1, 4 do
		local particle = Instance.new("Part")
		particle.Size = Vector3.new(0.6, 0.6, 0.6)
		particle.Position = position
		particle.Anchored = true
		particle.CanCollide = false
		particle.Material = Enum.Material.Neon
		particle.Color = Color3.fromRGB(255, 255, 200)
		particle.Transparency = 0.4
		particle.Shape = Enum.PartType.Ball
		particle.Parent = FXFolder
		
		local angle = (i / 4) * math.pi * 2
		local targetPos = position + Vector3.new(math.cos(angle) * 3, 0, math.sin(angle) * 3)
		
		TweenService:Create(particle, TweenInfo.new(0.15), {
			Position = targetPos,
			Size = Vector3.new(0.1, 0.1, 0.1),
			Transparency = 1
		}):Play()
		Debris:AddItem(particle, 0.15)
	end
end

-- 🎯 PURE DODGE SYSTEM - Goku Style
local function executePerfectDodge(attackPosition)
	dodgeCount = dodgeCount + 1
	DodgeLabel.Text = "⚡ Dodges: " .. dodgeCount
	uiEnergy = math.min(100, uiEnergy + 8)
	EnergyLabel.Text = "💠 Energy: " .. math.floor(uiEnergy) .. "%"
	
	local currentPosition = RootPart.Position
	
	-- Calculate dodge direction (away from attack)
	local dodgeDirection = (currentPosition - attackPosition).Unit
	if dodgeDirection.Magnitude == 0 then
		dodgeDirection = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit
	end
	
	local dodgePosition = currentPosition + (dodgeDirection * DODGE_DISTANCE)
	
	-- Ensure dodge position is safe
	dodgePosition = Vector3.new(
		dodgePosition.X,
		currentPosition.Y, -- Keep same height
		dodgePosition.Z
	)
	
	-- Visual effects
	if INSTANT_TRANSMISSION then
		createTransmissionEffect(currentPosition)
	end
	
	-- Smooth teleport to dodge position
	RootPart.CFrame = CFrame.new(dodgePosition)
	
	-- Reset velocities for clean movement
	RootPart.Velocity = Vector3.new(0, 0, 0)
	RootPart.RotVelocity = Vector3.new(0, 0, 0)
	
	-- Create dodge effects
	createDodgeEffect(currentPosition)
	createDodgeEffect(dodgePosition)
	
	if INSTANT_TRANSMISSION then
		createTransmissionEffect(dodgePosition)
	end
	
	-- UI feedback
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	wait(0.02)
	Title.TextColor3 = Color3.fromRGB(200, 220, 255)
end

-- 🎯 THREAT DETECTION SYSTEM
local function detectThreats()
	if not UI_ENABLED then return false, Vector3.new() end
	
	local closestThreat = nil
	local closestDistance = 50 -- Detection range
	local threatPosition = Vector3.new()
	
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local theirRoot = player.Character:FindFirstChild("HumanoidRootPart")
			if theirRoot then
				local distance = (theirRoot.Position - RootPart.Position).Magnitude
				local theirVelocity = theirRoot.Velocity.Magnitude
				
				-- Check if they're moving fast toward player (likely attacking)
				if distance < closestDistance and theirVelocity > 40 then
					local directionToPlayer = (RootPart.Position - theirRoot.Position).Unit
					local theirDirection = theirRoot.Velocity.Unit
					
					local dotProduct = directionToPlayer.X * theirDirection.X + directionToPlayer.Z * theirDirection.Z
					
					-- If moving toward player and close enough
					if dotProduct > 0.3 then
						closestThreat = player
						closestDistance = distance
						threatPosition = theirRoot.Position
					end
				end
			end
		end
	end
	
	return closestThreat ~= nil, threatPosition
end

-- 🎯 PURE ULTRA INSTINCT SYSTEM
local function startPureUltraInstinct()
	if DodgeConnection then DodgeConnection:Disconnect() end
	if AuraConnection then AuraConnection:Disconnect() end
	if AfterimageConnection then AfterimageConnection:Disconnect() end
	
	-- Enhanced speed but not ridiculous
	Humanoid.WalkSpeed = 16 * SPEED_BOOST
	
	-- Create authentic UI aura
	local aura = createPureUIAura()
	
	-- 🎯 AURA ANIMATION
	AuraConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED or not aura or not aura.Parent then return end
		
		-- Smooth aura following
		aura.CFrame = RootPart.CFrame
		
		-- Gentle pulsing
		local pulse = 1 + math.sin(tick() * 3) * 0.1
		aura.Size = Vector3.new(10 * pulse, 10 * pulse, 10 * pulse)
		
		-- Rotate energy rings
		for i, obj in pairs(auraObjects) do
			if obj ~= aura and obj.Parent then
				obj.CFrame = RootPart.CFrame * CFrame.Angles(math.rad(90), 0, math.rad((i * 180) + (tick() * 120)))
			end
		end
	end)
	
	-- 🎯 AFTERIMAGE SYSTEM
	AfterimageConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED then return end
		
		createAfterimage()
		
		-- Energy management
		uiEnergy = math.max(0, uiEnergy - 0.05)
		EnergyLabel.Text = "💠 Energy: " .. math.floor(uiEnergy) .. "%"
	end)
	
	-- 🎯 PURE DODGE SYSTEM
	local lastDodgeTime = 0
	local dodgeCooldown = 0.2
	
	DodgeConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED then return end
		
		local currentTime = tick()
		
		-- Method 1: Detect high-velocity attacks (flings)
		local currentVelocity = RootPart.Velocity.Magnitude
		if currentVelocity > VELOCITY_THRESHOLD and (currentTime - lastDodgeTime) > dodgeCooldown then
			executePerfectDodge(RootPart.Position + RootPart.Velocity.Unit * 10)
			lastDodgeTime = currentTime
			return
		end
		
		-- Method 2: Detect approaching threats
		local threatDetected, threatPos = detectThreats()
		if threatDetected and (currentTime - lastDodgeTime) > dodgeCooldown then
			executePerfectDodge(threatPos)
			lastDodgeTime = currentTime
			return
		end
	end)
end

local function stopPureUltraInstinct()
	if DodgeConnection then DodgeConnection:Disconnect() end
	if AuraConnection then AuraConnection:Disconnect() end
	if AfterimageConnection then AfterimageConnection:Disconnect() end
	
	Humanoid.WalkSpeed = 16
	destroyAura()
end

-- 🎯 ACTIVATION SYSTEM
ToggleButton.MouseButton1Click:Connect(function()
	UI_ENABLED = not UI_ENABLED
	
	if UI_ENABLED then
		ToggleButton.Text = "ACTIVE"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 150, 255)
		StatusLabel.Text = "⚡ ACTIVE"
		StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
		startPureUltraInstinct()
	else
		ToggleButton.Text = "AWAKEN"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
		StatusLabel.Text = "🔴 DORMANT"
		StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		stopPureUltraInstinct()
	end
end)

-- Character respawn handling
LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	Humanoid = char:WaitForChild("Humanoid")
	RootPart = char:WaitForChild("HumanoidRootPart")
	dodgeCount = 0
	uiEnergy = 0
	DodgeLabel.Text = "⚡ Dodges: 0"
	EnergyLabel.Text = "💠 Energy: 0%"
	wait(0.5)
	if UI_ENABLED then
		startPureUltraInstinct()
	end
end)

print("🎯 PURE MASTERED ULTRA INSTINCT LOADED")
print("⚡ Authentic Goku-style dodging system")
print("💨 3x speed boost - Fast but balanced")
print("🌀 Silver-blue aura and afterimages")
print("🎯 Smart threat detection and perfect dodges")
print("✨ Pure Ultra Instinct - No unnecessary effects")
