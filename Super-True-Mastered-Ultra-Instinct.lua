-- ADVANCED MASTERED ULTRA INSTINCT - Precision Dodging System
-- Enhanced threat detection, predictive dodging, and authentic UI mechanics

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- 🎯 ADVANCED UI SETTINGS
local UI_ENABLED = false
local VELOCITY_THRESHOLD = 70 -- Only dodge actual attacks
local DODGE_DISTANCE = 12 -- Precise, short dodges like Goku
local SPEED_BOOST = 3.5 -- Enhanced but balanced speed
local AFTERIMAGE_INTERVAL = 0.05 -- Smooth afterimages
local THREAT_DETECTION_RANGE = 30
local PREDICTION_TIME = 0.3 -- Predict attacks 0.3 seconds ahead
local ENERGY_DODGE_COST = 5
local ENERGY_REGEN_RATE = 2

-- Advanced tracking
local Connections = {}
local ThreatHistory = {}
local dodgeCount = 0
local lastAfterimage = 0
local uiEnergy = 100
local lastDodgeTime = 0
local dodgeCooldown = 0.15

-- Effects Folder
local FXFolder = Instance.new("Folder", workspace)
FXFolder.Name = "AdvancedUIFX"

-- 🎯 ADVANCED UI GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdvancedUIGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
Frame.BorderColor3 = Color3.fromRGB(180, 200, 255)
Frame.BorderSizePixel = 3
Frame.Position = UDim2.new(0.32, 0, 0.22, 0)
Frame.Size = UDim2.new(0, 320, 0, 220)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 55))
})
UIGradient.Rotation = 45
UIGradient.Parent = Frame

local Header = Instance.new("Frame")
Header.BackgroundColor3 = Color3.fromRGB(180, 200, 255)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 40)
Header.Parent = Frame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ ADVANCED ULTRA INSTINCT ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Parent = Header

local StatusLabel = Instance.new("TextLabel")
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.08, 0, 0.22, 0)
StatusLabel.Size = UDim2.new(0.84, 0, 0, 25)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Text = "🔴 DORMANT"
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.TextSize = 16
StatusLabel.Parent = Frame

local StatsFrame = Instance.new("Frame")
StatsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
StatsFrame.BorderSizePixel = 0
StatsFrame.Position = UDim2.new(0.08, 0, 0.38, 0)
StatsFrame.Size = UDim2.new(0.84, 0, 0, 70)
StatsFrame.Parent = Frame

local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 8)
StatsCorner.Parent = StatsFrame

local DodgeLabel = Instance.new("TextLabel")
DodgeLabel.BackgroundTransparency = 1
DodgeLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
DodgeLabel.Size = UDim2.new(0.9, 0, 0, 20)
DodgeLabel.Font = Enum.Font.Gotham
DodgeLabel.Text = "⚡ Dodges: 0"
DodgeLabel.TextColor3 = Color3.fromRGB(180, 200, 255)
DodgeLabel.TextSize = 12
DodgeLabel.TextXAlignment = Enum.TextXAlignment.Left
DodgeLabel.Parent = StatsFrame

local EnergyLabel = Instance.new("TextLabel")
EnergyLabel.BackgroundTransparency = 1
EnergyLabel.Position = UDim2.new(0.05, 0, 0.4, 0)
EnergyLabel.Size = UDim2.new(0.9, 0, 0, 20)
EnergyLabel.Font = Enum.Font.Gotham
EnergyLabel.Text = "💠 Energy: 100%"
EnergyLabel.TextColor3 = Color3.fromRGB(150, 220, 255)
EnergyLabel.TextSize = 12
EnergyLabel.TextXAlignment = Enum.TextXAlignment.Left
EnergyLabel.Parent = StatsFrame

local ThreatLabel = Instance.new("TextLabel")
ThreatLabel.BackgroundTransparency = 1
ThreatLabel.Position = UDim2.new(0.05, 0, 0.7, 0)
ThreatLabel.Size = UDim2.new(0.9, 0, 0, 20)
ThreatLabel.Font = Enum.Font.Gotham
ThreatLabel.Text = "🎯 Threats: 0"
ThreatLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
ThreatLabel.TextSize = 12
ThreatLabel.TextXAlignment = Enum.TextXAlignment.Left
ThreatLabel.Parent = StatsFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
ToggleButton.Position = UDim2.new(0.08, 0, 0.78, 0)
ToggleButton.Size = UDim2.new(0.84, 0, 0, 35)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "AWAKEN INSTINCT"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 16
ToggleButton.Parent = Frame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = ToggleButton

-- 🎯 ADVANCED AURA SYSTEM
local auraParts = {}
local auraPulse = 0

local function destroyAura()
	for _, obj in pairs(auraParts) do
		if obj and obj.Parent then
			obj:Destroy()
		end
	end
	auraParts = {}
end

local function createAdvancedAura()
	destroyAura()
	
	-- Main aura sphere
	local aura = Instance.new("Part")
	aura.Name = "UI_Aura"
	aura.Size = Vector3.new(8, 8, 8)
	aura.Anchored = true
	aura.CanCollide = false
	aura.Material = Enum.Material.Neon
	aura.Color = Color3.fromRGB(200, 220, 255)
	aura.Transparency = 0.7
	aura.Shape = Enum.PartType.Ball
	aura.CFrame = RootPart.CFrame
	aura.Parent = FXFolder
	table.insert(auraParts, aura)
	
	-- Rotating energy rings
	for i = 1, 3 do
		local ring = Instance.new("Part")
		ring.Size = Vector3.new(0.2, 5 + (i * 1.5), 5 + (i * 1.5))
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
		table.insert(auraParts, ring)
	end
	
	-- Floating energy particles
	for i = 1, 6 do
		local particle = Instance.new("Part")
		particle.Size = Vector3.new(0.8, 0.8, 0.8)
		particle.Anchored = true
		particle.CanCollide = false
		particle.Material = Enum.Material.Neon
		particle.Color = Color3.fromRGB(160, 200, 255)
		particle.Transparency = 0.6
		particle.Shape = Enum.PartType.Ball
		particle.Parent = FXFolder
		table.insert(auraParts, particle)
	end
	
	return aura
end

-- 🎯 PRECISION AFTERIMAGE SYSTEM
local function createPrecisionAfterimage()
	if tick() - lastAfterimage < AFTERIMAGE_INTERVAL then return end
	lastAfterimage = tick()
	
	-- Only create afterimages during significant movement
	if Humanoid.MoveDirection.Magnitude > 0.3 then
		for _, part in pairs(Character:GetDescendants()) do
			if part:IsA("BasePart") and part.Transparency < 1 and part.Name ~= "HumanoidRootPart" then
				local clone = part:Clone()
				clone.Anchored = true
				clone.CanCollide = false
				clone.Material = Enum.Material.Neon
				clone.Color = Color3.fromRGB(180, 210, 255)
				clone.Transparency = 0.65
				clone.CFrame = part.CFrame
				clone.Parent = FXFolder
				
				-- Clean up unnecessary children
				for _, child in pairs(clone:GetChildren()) do
					if not child:IsA("SpecialMesh") and not child:IsA("Motor6D") then
						child:Destroy()
					end
				end
				
				-- Smooth fade out
				TweenService:Create(clone, TweenInfo.new(0.35), {
					Transparency = 1,
					Color = Color3.fromRGB(220, 230, 255)
				}):Play()
				Debris:AddItem(clone, 0.35)
			end
		end
	end
end

-- 🎯 ADVANCED THREAT DETECTION SYSTEM
local function analyzeThreats()
	local activeThreats = 0
	local highestThreat = nil
	local highestThreatLevel = 0
	
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
			local humanoid = player.Character:FindFirstChild("Humanoid")
			
			if humanoidRootPart and humanoid and humanoid.Health > 0 then
				local distance = (humanoidRootPart.Position - RootPart.Position).Magnitude
				
				if distance < THREAT_DETECTION_RANGE then
					-- Calculate threat level based on multiple factors
					local threatLevel = 0
					
					-- Factor 1: Distance (closer = higher threat)
					threatLevel = threatLevel + ((THREAT_DETECTION_RANGE - distance) / THREAT_DETECTION_RANGE) * 40
					
					-- Factor 2: Velocity (faster movement toward player = higher threat)
					local directionToPlayer = (RootPart.Position - humanoidRootPart.Position).Unit
					local playerVelocity = humanoidRootPart.Velocity
					local velocityTowardPlayer = playerVelocity:Dot(directionToPlayer)
					
					if velocityTowardPlayer > 0 then
						threatLevel = threatLevel + (velocityTowardPlayer / 50) * 30
					end
					
					-- Factor 3: Facing direction (if facing player = higher threat)
					local playerFacing = humanoidRootPart.CFrame.LookVector
					local dotProduct = directionToPlayer:Dot(playerFacing)
					
					if dotProduct > 0.7 then -- Facing toward player
						threatLevel = threatLevel + 20
					end
					
					-- Factor 4: Recent attack history
					local playerId = tostring(player.UserId)
					if ThreatHistory[playerId] then
						threatLevel = threatLevel + ThreatHistory[playerId].threat * 10
					end
					
					if threatLevel > 25 then -- Minimum threat level to be considered
						activeThreats = activeThreats + 1
						
						if threatLevel > highestThreatLevel then
							highestThreatLevel = threatLevel
							highestThreat = {
								player = player,
								position = humanoidRootPart.Position,
								velocity = humanoidRootPart.Velocity,
								threatLevel = threatLevel,
								distance = distance
							}
						end
					end
				end
			end
		end
	end
	
	ThreatLabel.Text = "🎯 Threats: " .. activeThreats
	return highestThreat
end

-- 🎯 PREDICTIVE DODGE CALCULATION
local function calculateOptimalDodge(threatData)
	if not threatData then return nil end
	
	local threatPos = threatData.position
	local threatVel = threatData.velocity
	local threatDistance = threatData.distance
	
	-- Predict future position
	local predictedPos = threatPos + threatVel * PREDICTION_TIME
	
	-- Calculate dodge direction (perpendicular to threat trajectory)
	local threatTrajectory = (predictedPos - threatPos).Unit
	local dodgeDirection
	
	if threatTrajectory.Magnitude > 0 then
		-- Dodge perpendicular to threat path
		local randomSide = math.random(0, 1) * 2 - 1 -- -1 or 1
		dodgeDirection = threatTrajectory:Cross(Vector3.new(0, randomSide, 0)).Unit
		
		-- Ensure we're dodging away from threat
		local toThreat = (threatPos - RootPart.Position).Unit
		if dodgeDirection:Dot(toThreat) < 0 then
			dodgeDirection = -dodgeDirection
		end
	else
		-- Fallback: dodge away from threat
		dodgeDirection = (RootPart.Position - threatPos).Unit
	end
	
	-- Calculate dodge position
	local dodgePos = RootPart.Position + dodgeDirection * DODGE_DISTANCE
	
	-- Raycast to ensure dodge position is safe
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	raycastParams.FilterDescendantsInstances = {Character, FXFolder}
	
	local raycastResult = Workspace:Raycast(RootPart.Position, dodgeDirection * DODGE_DISTANCE, raycastParams)
	
	if raycastResult then
		-- Adjust dodge position if obstacle detected
		dodgePos = raycastResult.Position - dodgeDirection * 3
	end
	
	-- Keep same Y level (prevent falling off map)
	dodgePos = Vector3.new(dodgePos.X, RootPart.Position.Y, dodgePos.Z)
	
	return dodgePos, dodgeDirection
end

-- 🎯 PRECISION DODGE EFFECT
local function createPrecisionDodgeEffect(position, direction)
	-- Main energy flash
	local flash = Instance.new("Part")
	flash.Size = Vector3.new(5, 5, 5)
	flash.Position = position
	flash.Anchored = true
	flash.CanCollide = false
	flash.Material = Enum.Material.Neon
	flash.Color = Color3.fromRGB(220, 230, 255)
	flash.Transparency = 0.4
	flash.Shape = Enum.PartType.Ball
	flash.Parent = FXFolder
	
	-- Directional energy trail
	for i = 1, 3 do
		local trail = Instance.new("Part")
		trail.Size = Vector3.new(0.3, 0.3, 2)
		trail.Position = position - direction * (i * 1.5)
		trail.Anchored = true
		trail.CanCollide = false
		trail.Material = Enum.Material.Neon
		trail.Color = Color3.fromRGB(200, 220, 255)
		trail.Transparency = 0.5
		trail.CFrame = CFrame.lookAt(trail.Position, trail.Position + direction)
		trail.Parent = FXFolder
		
		TweenService:Create(trail, TweenInfo.new(0.2), {
			Transparency = 1,
			Size = Vector3.new(0.1, 0.1, 4)
		}):Play()
		Debris:AddItem(trail, 0.2)
	end
	
	-- Quick expanding ring
	local ring = Instance.new("Part")
	ring.Size = Vector3.new(0.1, 4, 4)
	ring.Position = position
	ring.Anchored = true
	ring.CanCollide = false
	ring.Material = Enum.Material.Neon
	ring.Color = Color3.fromRGB(180, 210, 255)
	ring.Transparency = 0.6
	ring.Parent = FXFolder
	
	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.Cylinder
	mesh.Parent = ring
	
	TweenService:Create(ring, TweenInfo.new(0.25), {
		Transparency = 1,
		Size = Vector3.new(0.05, 8, 8)
	}):Play()
	Debris:AddItem(ring, 0.25)
	
	TweenService:Create(flash, TweenInfo.new(0.3), {
		Size = Vector3.new(8, 8, 8),
		Transparency = 1
	}):Play()
	Debris:AddItem(flash, 0.3)
end

-- 🎯 INSTANT MOVEMENT EFFECT
local function createMovementEffect(fromPos, toPos)
	-- Teleportation particles
	for i = 1, 4 do
		local particle = Instance.new("Part")
		particle.Size = Vector3.new(0.5, 0.5, 0.5)
		particle.Position = fromPos
		particle.Anchored = true
		particle.CanCollide = false
		particle.Material = Enum.Material.Neon
		particle.Color = Color3.fromRGB(255, 255, 200)
		particle.Transparency = 0.5
		particle.Shape = Enum.PartType.Ball
		particle.Parent = FXFolder
		
		local progress = i / 4
		local targetPos = fromPos:Lerp(toPos, progress)
		
		TweenService:Create(particle, TweenInfo.new(0.1), {
			Position = targetPos,
			Size = Vector3.new(0.1, 0.1, 0.1),
			Transparency = 1
		}):Play()
		Debris:AddItem(particle, 0.1)
	end
end

-- 🎯 EXECUTE PRECISION DODGE
local function executePrecisionDodge()
	local currentTime = tick()
	
	-- Check cooldown and energy
	if currentTime - lastDodgeTime < dodgeCooldown then return false end
	if uiEnergy < ENERGY_DODGE_COST then return false end
	
	-- Analyze threats
	local primaryThreat = analyzeThreats()
	if not primaryThreat then return false end
	
	-- Calculate optimal dodge
	local dodgePos, dodgeDirection = calculateOptimalDodge(primaryThreat)
	if not dodgePos then return false end
	
	-- Update threat history
	local playerId = tostring(primaryThreat.player.UserId)
	ThreatHistory[playerId] = {
		threat = primaryThreat.threatLevel / 100,
		lastSeen = tick()
	}
	
	-- Execute dodge
	local originalPos = RootPart.Position
	
	-- Visual effects
	createMovementEffect(originalPos, dodgePos)
	
	-- Perform teleport
	RootPart.CFrame = CFrame.new(dodgePos)
	
	-- Reset velocities for clean movement
	RootPart.Velocity = Vector3.new(0, 0, 0)
	RootPart.RotVelocity = Vector3.new(0, 0, 0)
	
	-- Create dodge effects
	createPrecisionDodgeEffect(originalPos, dodgeDirection)
	createPrecisionDodgeEffect(dodgePos, dodgeDirection)
	
	-- Update stats
	dodgeCount = dodgeCount + 1
	uiEnergy = uiEnergy - ENERGY_DODGE_COST
	lastDodgeTime = currentTime
	
	DodgeLabel.Text = "⚡ Dodges: " .. dodgeCount
	EnergyLabel.Text = "💠 Energy: " .. math.floor(uiEnergy) .. "%"
	
	-- UI feedback
	Title.TextColor3 = Color3.fromRGB(255, 255, 150)
	wait(0.03)
	Title.TextColor3 = Color3.fromRGB(180, 200, 255)
	
	return true
end

-- 🎯 VELOCITY-BASED DODGE (for fling attacks)
local function executeVelocityDodge()
	local currentTime = tick()
	
	if currentTime - lastDodgeTime < dodgeCooldown then return false end
	if uiEnergy < ENERGY_DODGE_COST then return false end
	
	local currentVelocity = RootPart.Velocity
	local velocityMagnitude = currentVelocity.Magnitude
	
	-- Only dodge significant velocity changes (actual attacks)
	if velocityMagnitude > VELOCITY_THRESHOLD then
		local dodgeDirection = -currentVelocity.Unit
		local dodgePos = RootPart.Position + dodgeDirection * DODGE_DISTANCE
		
		-- Ensure safe position
		dodgePos = Vector3.new(
			dodgePos.X,
			RootPart.Position.Y,
			dodgePos.Z
		)
		
		local originalPos = RootPart.Position
		
		-- Visual effects
		createMovementEffect(originalPos, dodgePos)
		
		-- Perform teleport
		RootPart.CFrame = CFrame.new(dodgePos)
		RootPart.Velocity = Vector3.new(0, 0, 0)
		RootPart.RotVelocity = Vector3.new(0, 0, 0)
		
		-- Create effects
		createPrecisionDodgeEffect(originalPos, dodgeDirection)
		createPrecisionDodgeEffect(dodgePos, dodgeDirection)
		
		-- Update stats
		dodgeCount = dodgeCount + 1
		uiEnergy = uiEnergy - ENERGY_DODGE_COST
		lastDodgeTime = currentTime
		
		DodgeLabel.Text = "⚡ Dodges: " .. dodgeCount
		EnergyLabel.Text = "💠 Energy: " .. math.floor(uiEnergy) .. "%"
		
		return true
	end
	
	return false
end

-- 🎯 ENERGY MANAGEMENT SYSTEM
local function updateEnergySystem()
	if not UI_ENABLED then return end
	
	-- Energy regeneration
	if uiEnergy < 100 then
		uiEnergy = math.min(100, uiEnergy + ENERGY_REGEN_RATE * 0.1)
		EnergyLabel.Text = "💠 Energy: " .. math.floor(uiEnergy) .. "%"
	end
	
	-- Clean old threat history
	local currentTime = tick()
	for playerId, data in pairs(ThreatHistory) do
		if currentTime - data.lastSeen > 10 then -- Forget threats after 10 seconds
			ThreatHistory[playerId] = nil
		end
	end
end

-- 🎯 ADVANCED AURA ANIMATION
local function updateAuraAnimation()
	if not UI_ENABLED then return end
	
	auraPulse = auraPulse + 0.1
	
	for i, part in pairs(auraParts) do
		if part and part.Parent then
			if part.Name == "UI_Aura" then
				-- Main aura follows player with gentle pulse
				part.CFrame = RootPart.CFrame
				local pulse = 1 + math.sin(auraPulse * 3) * 0.08
				part.Size = Vector3.new(8 * pulse, 8 * pulse, 8 * pulse)
			elseif part.Size.Y > 5 then -- Energy rings
				-- Rotating rings
				part.CFrame = RootPart.CFrame * CFrame.Angles(math.rad(90), 0, math.rad((i * 120) + (auraPulse * 100)))
			else -- Energy particles
				-- Orbiting particles
				local orbitRadius = 6
				local orbitSpeed = 2
				local angle = auraPulse * orbitSpeed + (i * 1.2)
				part.CFrame = RootPart.CFrame * CFrame.new(
					math.cos(angle) * orbitRadius,
					math.sin(angle * 0.8) * 3,
					math.sin(angle) * orbitRadius
				)
			end
		end
	end
end

-- 🎯 MAIN ADVANCED UI SYSTEM
local function startAdvancedUltraInstinct()
	-- Disconnect previous connections
	for _, connection in pairs(Connections) do
		connection:Disconnect()
	end
	Connections = {}
	
	-- Apply speed boost
	Humanoid.WalkSpeed = 16 * SPEED_BOOST
	
	-- Create advanced aura
	createAdvancedAura()
	
	-- 🎯 AURA ANIMATION SYSTEM
	table.insert(Connections, RunService.Heartbeat:Connect(updateAuraAnimation))
	
	-- 🎯 AFTERIMAGE SYSTEM
	table.insert(Connections, RunService.Heartbeat:Connect(function()
		if not UI_ENABLED then return end
		createPrecisionAfterimage()
	end))
	
	-- 🎯 ENERGY MANAGEMENT SYSTEM
	table.insert(Connections, RunService.Heartbeat:Connect(updateEnergySystem))
	
	-- 🎯 ADVANCED DODGE SYSTEM
	table.insert(Connections, RunService.Heartbeat:Connect(function()
		if not UI_ENABLED then return end
		
		-- Priority 1: Predictive threat dodging
		if executePrecisionDodge() then return end
		
		-- Priority 2: Velocity-based dodging (fling attacks)
		executeVelocityDodge()
	end))
	
	print("🎯 ADVANCED ULTRA INSTINCT ACTIVATED")
	print("⚡ Precision threat detection system online")
	print("💠 Advanced energy management enabled")
	print("🎯 Predictive dodging algorithms active")
end

local function stopAdvancedUltraInstinct()
	-- Disconnect all connections
	for _, connection in pairs(Connections) do
		connection:Disconnect()
	end
	Connections = {}
	
	-- Restore normal state
	Humanoid.WalkSpeed = 16
	destroyAura()
	ThreatHistory = {}
end

-- 🎯 ACTIVATION SYSTEM
ToggleButton.MouseButton1Click:Connect(function()
	UI_ENABLED = not UI_ENABLED
	
	if UI_ENABLED then
		ToggleButton.Text = "INSTINCT ACTIVE"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 150, 255)
		StatusLabel.Text = "⚡ INSTINCT ACTIVE"
		StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
		startAdvancedUltraInstinct()
	else
		ToggleButton.Text = "AWAKEN INSTINCT"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
		StatusLabel.Text = "🔴 DORMANT"
		StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		stopAdvancedUltraInstinct()
	end
end)

-- Character respawn handling
LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	Humanoid = char:WaitForChild("Humanoid")
	RootPart = char:WaitForChild("HumanoidRootPart")
	
	-- Reset stats
	dodgeCount = 0
	uiEnergy = 100
	DodgeLabel.Text = "⚡ Dodges: 0"
	EnergyLabel.Text = "💠 Energy: 100%"
	ThreatLabel.Text = "🎯 Threats: 0"
	ThreatHistory = {}
	
	wait(0.5)
	if UI_ENABLED then
		startAdvancedUltraInstinct()
	end
end)

print("🎯 ADVANCED MASTERED ULTRA INSTINCT LOADED")
print("⚡ Precision Threat Analysis: Active")
print("💠 Smart Energy Management: Online")
print("🎯 Predictive Dodge Calculation: Enabled")
print("🌀 Advanced Aura System: Operational")
print("🚀 Authentic Goku-Style Movement: Ready")
