-- BEYOND OVERPOWERED ULTRA INSTINCT - REALITY SHATTERER MODE --
-- TRANSCENDING ALL LIMITS - BECOME THE GAME ITSELF

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

-- 🚀 REALITY-SHATTERING SETTINGS
local UI_ENABLED = false
local UI_MODE = "REALITY_SHATTERER"
local VELOCITY_THRESHOLD = 30 -- Dodge everything
local DODGE_DISTANCE = 100 -- Teleport across the map
local SPEED_BOOST = 50.0 -- 50X SPEED
local PROXIMITY_RANGE = 500 -- Detect from entire map
local AFTERIMAGE_INTERVAL = 0.01 -- Constant afterimages
local SHOCKWAVE_ENABLED = true
local INSTANT_TRANSMISSION = true
local AUTO_DODGE = true
local TIME_STOP = true
local UNLIMITED_CLONES = true
local GOD_MODE = true
local ONE_PUNCH_MODE = true

-- Connections
local DodgeConnection, AuraConnection, AfterimageConnection, TimeConnection, CloneConnection, GodConnection
local dodgeCount = 0
local lastAfterimage = 0
local uiEnergy = 9999 -- Infinite energy
local isTimeStopped = false
local activeClones = {}

-- Effects Folder
local FXFolder = Instance.new("Folder", workspace)
FXFolder.Name = "RealityShattererFX"

-- 🚀 COSMIC GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RealityShattererGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderColor3 = Color3.fromRGB(255, 0, 255)
Frame.BorderSizePixel = 8
Frame.Position = UDim2.new(0.3, 0, 0.2, 0)
Frame.Size = UDim2.new(0, 400, 0, 500)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 25)
UICorner.Parent = Frame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(100, 0, 100)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0, 0, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
UIGradient.Rotation = 135
UIGradient.Parent = Frame

local Header = Instance.new("Frame")
Header.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 70)
Header.Parent = Frame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 25)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Font = Enum.Font.GothamBlack
Title.Text = "🌌 REALITY SHATTERER MODE 🌌"
Title.TextColor3 = Color3.fromRGB(255, 255, 0)
Title.TextSize = 22
Title.TextScaled = true
Title.Parent = Header

local StatusLabel = Instance.new("TextLabel")
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.08, 0, 0.15, 0)
StatusLabel.Size = UDim2.new(0.84, 0, 0, 40)
StatusLabel.Font = Enum.Font.GothamBlack
StatusLabel.Text = "🔴 REALITY INTACT 🔴"
StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
StatusLabel.TextSize = 20
StatusLabel.Parent = Frame

local StatsFrame = Instance.new("Frame")
StatsFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 50)
StatsFrame.BorderSizePixel = 0
StatsFrame.Position = UDim2.new(0.08, 0, 0.25, 0)
StatsFrame.Size = UDim2.new(0.84, 0, 0, 200)
StatsFrame.Parent = Frame

local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 15)
StatsCorner.Parent = StatsFrame

local DodgeLabel = Instance.new("TextLabel")
DodgeLabel.BackgroundTransparency = 1
DodgeLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
DodgeLabel.Size = UDim2.new(0.9, 0, 0, 25)
DodgeLabel.Font = Enum.Font.GothamBlack
DodgeLabel.Text = "⚡ DODGES: INFINITE"
DodgeLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
DodgeLabel.TextSize = 16
DodgeLabel.TextXAlignment = Enum.TextXAlignment.Left
DodgeLabel.Parent = StatsFrame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Position = UDim2.new(0.05, 0, 0.18, 0)
SpeedLabel.Size = UDim2.new(0.9, 0, 0, 25)
SpeedLabel.Font = Enum.Font.GothamBlack
SpeedLabel.Text = "💨 SPEED: 50x (GOD+)"
SpeedLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
SpeedLabel.TextSize = 16
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = StatsFrame

local EnergyLabel = Instance.new("TextLabel")
EnergyLabel.BackgroundTransparency = 1
EnergyLabel.Position = UDim2.new(0.05, 0, 0.31, 0)
EnergyLabel.Size = UDim2.new(0.9, 0, 0, 25)
EnergyLabel.Font = Enum.Font.GothamBlack
EnergyLabel.Text = "🔋 ENERGY: ∞ (INFINITE)"
EnergyLabel.TextColor3 = Color3.fromRGB(255, 0, 255)
EnergyLabel.TextSize = 16
EnergyLabel.TextXAlignment = Enum.TextXAlignment.Left
EnergyLabel.Parent = StatsFrame

local AbilityLabel = Instance.new("TextLabel")
AbilityLabel.BackgroundTransparency = 1
AbilityLabel.Position = UDim2.new(0.05, 0, 0.44, 0)
AbilityLabel.Size = UDim2.new(0.9, 0, 0, 25)
AbilityLabel.Font = Enum.Font.GothamBlack
AbilityLabel.Text = "🌀 TIME STOP: READY"
AbilityLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
AbilityLabel.TextSize = 16
AbilityLabel.TextXAlignment = Enum.TextXAlignment.Left
AbilityLabel.Parent = StatsFrame

local CloneLabel = Instance.new("TextLabel")
CloneLabel.BackgroundTransparency = 1
CloneLabel.Position = UDim2.new(0.05, 0, 0.57, 0)
CloneLabel.Size = UDim2.new(0.9, 0, 0, 25)
CloneLabel.Font = Enum.Font.GothamBlack
CloneLabel.Text = "👥 CLONES: 0/∞"
CloneLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
CloneLabel.TextSize = 16
CloneLabel.TextXAlignment = Enum.TextXAlignment.Left
CloneLabel.Parent = StatsFrame

local GodLabel = Instance.new("TextLabel")
GodLabel.BackgroundTransparency = 1
GodLabel.Position = UDim2.new(0.05, 0, 0.70, 0)
GodLabel.Size = UDim2.new(0.9, 0, 0, 25)
GodLabel.Font = Enum.Font.GothamBlack
GodLabel.Text = "👑 GOD MODE: INACTIVE"
GodLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GodLabel.TextSize = 16
GodLabel.TextXAlignment = Enum.TextXAlignment.Left
GodLabel.Parent = StatsFrame

local RealityLabel = Instance.new("TextLabel")
RealityLabel.BackgroundTransparency = 1
RealityLabel.Position = UDim2.new(0.05, 0, 0.83, 0)
RealityLabel.Size = UDim2.new(0.9, 0, 0, 25)
RealityLabel.Font = Enum.Font.GothamBlack
RealityLabel.Text = "🌠 REALITY CONTROL: LOCKED"
RealityLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
RealityLabel.TextSize = 16
RealityLabel.TextXAlignment = Enum.TextXAlignment.Left
RealityLabel.Parent = StatsFrame

-- 🚀 ACTIVATION BUTTON
local ToggleButton = Instance.new("TextButton")
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleButton.Position = UDim2.new(0.08, 0, 0.68, 0)
ToggleButton.Size = UDim2.new(0.84, 0, 0, 100)
ToggleButton.Font = Enum.Font.GothamBlack
ToggleButton.Text = "SHATTER REALITY"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 28
ToggleButton.Parent = Frame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 20)
ButtonCorner.Parent = ToggleButton

local ButtonGradient = Instance.new("UIGradient")
ButtonGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 0, 255)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
})
ButtonGradient.Rotation = 90
ButtonGradient.Parent = ToggleButton

-- 🚀 ABILITY BUTTONS
local TimeStopButton = Instance.new("TextButton")
TimeStopButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
TimeStopButton.Position = UDim2.new(0.08, 0, 0.9, 0)
TimeStopButton.Size = UDim2.new(0.4, 0, 0, 40)
TimeStopButton.Font = Enum.Font.GothamBold
TimeStopButton.Text = "⏰ STOP TIME"
TimeStopButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TimeStopButton.TextSize = 14
TimeStopButton.Parent = Frame

local TimeStopCorner = Instance.new("UICorner")
TimeStopCorner.CornerRadius = UDim.new(0, 10)
TimeStopCorner.Parent = TimeStopButton

local CloneButton = Instance.new("TextButton")
CloneButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
CloneButton.Position = UDim2.new(0.52, 0, 0.9, 0)
CloneButton.Size = UDim2.new(0.4, 0, 0, 40)
CloneButton.Font = Enum.Font.GothamBold
CloneButton.Text = "👥 SPAWN CLONES"
CloneButton.TextColor3 = Color3.fromRGB(0, 0, 0)
CloneButton.TextSize = 14
CloneButton.Parent = Frame

local CloneCorner = Instance.new("UICorner")
CloneCorner.CornerRadius = UDim.new(0, 10)
CloneCorner.Parent = CloneButton

-- 🚀 COSMIC AURA SYSTEM
local auraObjects = {}

local function destroyAura()
	for _, obj in pairs(auraObjects) do
		if obj and obj.Parent then
			obj:Destroy()
		end
	end
	auraObjects = {}
end

local function createCosmicAura()
	destroyAura()
	
	-- Main cosmic aura
	local aura = Instance.new("Part")
	aura.Name = "CosmicAura"
	aura.Size = Vector3.new(25, 25, 25) -- Perfect god size
	aura.Anchored = true
	aura.CanCollide = false
	aura.Material = Enum.Material.Neon
	aura.Color = Color3.fromRGB(255, 0, 255)
	aura.Transparency = 0.3
	aura.Shape = Enum.PartType.Ball
	aura.CFrame = RootPart.CFrame
	aura.Parent = FXFolder
	table.insert(auraObjects, aura)
	
	-- Multiple cosmic rings
	for i = 1, 6 do
		local ring = Instance.new("Part")
		ring.Size = Vector3.new(0.5, 15 + (i * 5), 15 + (i * 5))
		ring.Anchored = true
		ring.CanCollide = false
		ring.Material = Enum.Material.Neon
		ring.Color = Color3.fromRGB(0, 255, 255)
		ring.Transparency = 0.4
		ring.CFrame = RootPart.CFrame
		ring.Parent = FXFolder
		
		local mesh = Instance.new("SpecialMesh")
		mesh.MeshType = Enum.MeshType.Cylinder
		mesh.Parent = ring
		
		table.insert(auraObjects, ring)
	end
	
	-- Floating cosmic orbs
	for i = 1, 15 do
		local orb = Instance.new("Part")
		orb.Size = Vector3.new(2, 2, 2)
		orb.Anchored = true
		orb.CanCollide = false
		orb.Material = Enum.Material.Neon
		orb.Color = Color3.fromRGB(math.random(200,255), math.random(200,255), math.random(200,255))
		orb.Transparency = 0.2
		orb.Shape = Enum.PartType.Ball
		orb.Parent = FXFolder
		table.insert(auraObjects, orb)
	end
	
	return aura
end

-- 🚀 TIME STOP SYSTEM
local function stopTime()
	if not TIME_STOP or not UI_ENABLED then return end
	
	isTimeStopped = true
	AbilityLabel.Text = "🌀 TIME STOP: ACTIVE"
	
	-- Freeze all other players
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local humanoid = player.Character:FindFirstChild("Humanoid")
			if humanoid then
				-- Store original speed and freeze
				if not humanoid:GetAttribute("OriginalWalkSpeed") then
					humanoid:SetAttribute("OriginalWalkSpeed", humanoid.WalkSpeed)
				end
				humanoid.WalkSpeed = 0
			end
			
			-- Freeze all parts
			for _, part in pairs(player.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Anchored = true
				end
			end
		end
	end
	
	-- Visual time stop effect
	for i = 1, 50 do
		local timeParticle = Instance.new("Part")
		timeParticle.Size = Vector3.new(1, 1, 1)
		timeParticle.Position = RootPart.Position + Vector3.new(
			math.random(-100, 100),
			math.random(-50, 50),
			math.random(-100, 100)
		)
		timeParticle.Anchored = true
		timeParticle.CanCollide = false
		timeParticle.Material = Enum.Material.Neon
		timeParticle.Color = Color3.fromRGB(255, 255, 0)
		timeParticle.Transparency = 0.1
		timeParticle.Shape = Enum.PartType.Ball
		timeParticle.Parent = FXFolder
		
		TweenService:Create(timeParticle, TweenInfo.new(5), {
			Transparency = 1,
			Size = Vector3.new(0.1, 0.1, 0.1)
		}):Play()
		Debris:AddItem(timeParticle, 5)
	end
end

local function resumeTime()
	if not isTimeStopped then return end
	
	isTimeStopped = false
	AbilityLabel.Text = "🌀 TIME STOP: READY"
	
	-- Unfreeze all players
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local humanoid = player.Character:FindFirstChild("Humanoid")
			if humanoid then
				local originalSpeed = humanoid:GetAttribute("OriginalWalkSpeed") or 16
				humanoid.WalkSpeed = originalSpeed
			end
			
			-- Unfreeze all parts
			for _, part in pairs(player.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Anchored = false
				end
			end
		end
	end
end

-- 🚀 INFINITE CLONE ARMY
local function spawnInfiniteClones()
	if not UNLIMITED_CLONES or not UI_ENABLED then return end
	
	-- Clear old clones
	for _, clone in pairs(activeClones) do
		if clone and clone.Parent then
			clone:Destroy()
		end
	end
	activeClones = {}
	
	-- Create 20 god clones
	for i = 1, 20 do
		spawn(function()
			local clone = Character:Clone()
			clone.Name = "GodClone_" .. i
			
			-- Make clones invincible gods
			for _, part in pairs(clone:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
					part.Material = Enum.Material.Neon
					part.Color = Color3.fromRGB(math.random(100,255), math.random(100,255), math.random(100,255))
					part.Transparency = 0.2
				end
			end
			
			-- Position in cosmic formation
			local angle = (i / 20) * math.pi * 2
			local radius = 15
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
			CloneLabel.Text = "👥 CLONES: " .. #activeClones .. "/∞"
			
			-- Make clones attack everyone
			while clone and clone.Parent and UI_ENABLED do
				wait(0.3)
				for _, player in pairs(Players:GetPlayers()) do
					if player ~= LocalPlayer and player.Character then
						local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
						if targetRoot and cloneRoot then
							-- Teleport clone to attack
							cloneRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -3)
							
							-- One-punch KO
							if ONE_PUNCH_MODE then
								local humanoid = player.Character:FindFirstChild("Humanoid")
								if humanoid then
									humanoid.Health = 0
								end
							end
							
							-- Create attack effect
							createRealityShockwave(targetRoot.Position)
						end
					end
				end
			end
		end)
	end
end

-- 🚀 GOD MODE ACTIVATION
local function activateGodMode()
	if not GOD_MODE or not UI_ENABLED then return end
	
	GodLabel.Text = "👑 GOD MODE: ACTIVE"
	RealityLabel.Text = "🌠 REALITY CONTROL: YOURS"
	
	-- Make player invincible
	Humanoid.MaxHealth = math.huge
	Humanoid.Health = math.huge
	
	-- Fly mode
	Humanoid.PlatformStand = true
	
	-- Infinite jump power
	Humanoid.JumpPower = 200
	
	-- No clip through walls
	for _, part in pairs(Character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
		end
	end
end

-- 🚀 REALITY-SHATTERING SHOCKWAVE
local function createRealityShockwave(position)
	local shockwave = Instance.new("Part")
	shockwave.Size = Vector3.new(1, 1, 1)
	shockwave.Position = position
	shockwave.Anchored = true
	shockwave.CanCollide = false
	shockwave.Material = Enum.Material.Neon
	shockwave.Color = Color3.fromRGB(255, 0, 255)
	shockwave.Transparency = 0.1
	shockwave.Shape = Enum.PartType.Ball
	shockwave.Parent = FXFolder
	
	-- Expand to cosmic proportions
	TweenService:Create(shockwave, TweenInfo.new(1.5), {
		Size = Vector3.new(150, 150, 150),
		Transparency = 1
	}):Play()
	
	-- Launch everyone to oblivion
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local theirRoot = player.Character:FindFirstChild("HumanoidRootPart")
			if theirRoot then
				local distance = (theirRoot.Position - position).Magnitude
				if distance < 100 then
					-- YEET to space with extreme force
					theirRoot.Velocity = Vector3.new(
						math.random(-5000, 5000),
						5000, -- Maximum YEET
						math.random(-5000, 5000)
					)
				end
			end
		end
	end
	
	Debris:AddItem(shockwave, 1.5)
end

-- 🚀 INFINITE DODGE SYSTEM
local function cosmicDodge()
	dodgeCount = dodgeCount + 1
	DodgeLabel.Text = "⚡ DODGES: " .. dodgeCount .. " (INFINITE)"
	
	-- Infinite energy
	uiEnergy = 9999
	EnergyLabel.Text = "🔋 ENERGY: ∞ (INFINITE)"
	
	-- Create multiple cosmic dodge effects
	for i = 1, 8 do
		spawn(function()
			local dodgePos = RootPart.Position + Vector3.new(
				math.random(-50, 50),
				0,
				math.random(-50, 50)
			)
			createCosmicDodgeEffect(dodgePos)
		end)
	end
	
	-- Random ability triggers
	if math.random(1, 3) == 1 then
		createRealityShockwave(RootPart.Position)
	end
	
	if math.random(1, 5) == 1 then
		spawnInfiniteClones()
	end
end

-- 🚀 COSMIC DODGE EFFECT
local function createCosmicDodgeEffect(position)
	-- Main cosmic sphere
	local part = Instance.new("Part")
	part.Size = Vector3.new(15, 15, 15)
	part.Position = position
	part.Anchored = true
	part.CanCollide = false
	part.Material = Enum.Material.Neon
	part.Color = Color3.fromRGB(255, 255, 0)
	part.Transparency = 0.1
	part.Shape = Enum.PartType.Ball
	part.Parent = FXFolder
	
	-- Cosmic lightning
	for i = 1, 25 do
		local lightning = Instance.new("Part")
		lightning.Size = Vector3.new(0.4, 10, 0.4)
		lightning.Position = position
		lightning.Anchored = true
		lightning.CanCollide = false
		lightning.Material = Enum.Material.Neon
		lightning.Color = Color3.fromRGB(255, 0, 255)
		lightning.Parent = FXFolder
		
		local angle = (i / 25) * math.pi * 2
		lightning.CFrame = CFrame.new(position) * CFrame.Angles(0, angle, math.rad(60)) * CFrame.new(0, 0, 8)
		
		TweenService:Create(lightning, TweenInfo.new(0.4), {
			Transparency = 1,
			Size = Vector3.new(0.1, 20, 0.1)
		}):Play()
		Debris:AddItem(lightning, 0.4)
	end
	
	-- Cosmic particles
	for i = 1, 20 do
		local particle = Instance.new("Part")
		particle.Size = Vector3.new(2, 2, 2)
		particle.Position = position
		particle.Anchored = true
		particle.CanCollide = false
		particle.Material = Enum.Material.Neon
		particle.Color = Color3.fromRGB(math.random(100,255), math.random(100,255), math.random(100,255))
		particle.Transparency = 0.2
		particle.Shape = Enum.PartType.Ball
		particle.Parent = FXFolder
		
		local angle = (i / 20) * math.pi * 2
		local targetPos = position + Vector3.new(math.cos(angle) * 25, math.random(-10, 10), math.sin(angle) * 25)
		
		TweenService:Create(particle, TweenInfo.new(1), {
			Position = targetPos,
			Size = Vector3.new(0.1, 0.1, 0.1),
			Transparency = 1
		}):Play()
		Debris:AddItem(particle, 1)
	end
	
	TweenService:Create(part, TweenInfo.new(0.8), {
		Size = Vector3.new(50, 50, 50),
		Transparency = 1
	}):Play()
	Debris:AddItem(part, 0.8)
end

-- 🚀 CONSTANT AFTERIMAGE STORM
local function createAfterimageStorm()
	if tick() - lastAfterimage < AFTERIMAGE_INTERVAL then return end
	lastAfterimage = tick()
	
	for _, part in pairs(Character:GetDescendants()) do
		if part:IsA("BasePart") and part.Transparency < 1 and part.Name ~= "HumanoidRootPart" then
			local clone = part:Clone()
			clone.Anchored = true
			clone.CanCollide = false
			clone.Material = Enum.Material.Neon
			clone.Color = Color3.fromRGB(math.random(150,255), math.random(150,255), math.random(200,255))
			clone.Transparency = 0.3
			clone.CFrame = part.CFrame
			clone.Parent = FXFolder
			
			for _, child in pairs(clone:GetChildren()) do
				if not child:IsA("SpecialMesh") then
					child:Destroy()
				end
			end
			
			TweenService:Create(clone, TweenInfo.new(0.5), {
				Transparency = 1,
				Size = clone.Size * 1.5
			}):Play()
			Debris:AddItem(clone, 0.5)
		end
	end
end

-- 🚀 MAIN REALITY SHATTERER SYSTEM
local function startRealityShatterer()
	-- Disconnect previous connections
	if DodgeConnection then DodgeConnection:Disconnect() end
	if AuraConnection then AuraConnection:Disconnect() end
	if AfterimageConnection then AfterimageConnection:Disconnect() end
	if TimeConnection then TimeConnection:Disconnect() end
	if CloneConnection then CloneConnection:Disconnect() end
	if GodConnection then GodConnection:Disconnect() end
	
	-- ULTIMATE SPEED
	Humanoid.WalkSpeed = 16 * SPEED_BOOST
	SpeedLabel.Text = "💨 SPEED: " .. SPEED_BOOST .. "x (GOD+)"
	
	-- Create cosmic aura
	local aura = createCosmicAura()
	
	-- 🚀 COSMIC AURA ANIMATION
	AuraConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED or not aura or not aura.Parent then return end
		
		-- Animate main aura
		aura.CFrame = RootPart.CFrame
		local pulse = 1 + math.sin(tick() * 8) * 0.3
		aura.Size = Vector3.new(25 * pulse, 25 * pulse, 25 * pulse)
		
		-- Animate rings
		for i, obj in pairs(auraObjects) do
			if obj ~= aura and obj.Parent then
				if obj:IsA("Part") and obj.Size.Y > 10 then -- It's a ring
					obj.CFrame = RootPart.CFrame * CFrame.Angles(math.rad(90), 0, math.rad((i * 60) + (tick() * 200)))
				else -- It's an orb
					local orbitRadius = 20
					local orbitSpeed = 3
					local angle = tick() * orbitSpeed + (i * 0.5)
					obj.CFrame = RootPart.CFrame * CFrame.new(
						math.cos(angle) * orbitRadius,
						math.sin(angle * 0.7) * 10,
						math.sin(angle) * orbitRadius
					)
				end
			end
		end
	end)
	
	-- 🚀 AFTERIMAGE STORM
	AfterimageConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED then return end
		createAfterimageStorm()
	end)
	
	-- 🚀 INFINITE DODGE SYSTEM
	DodgeConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED then return end
		
		-- Dodge any movement
		if RootPart.Velocity.Magnitude > VELOCITY_THRESHOLD or Humanoid.MoveDirection.Magnitude > 0 then
			cosmicDodge()
			
			-- Teleport around randomly
			local telePos = RootPart.Position + Vector3.new(
				math.random(-DODGE_DISTANCE, DODGE_DISTANCE),
				0,
				math.random(-DODGE_DISTANCE, DODGE_DISTANCE)
			)
			RootPart.CFrame = CFrame.new(telePos)
		end
		
		-- Random reality shocks
		if math.random(1, 30) == 1 then
			createRealityShockwave(RootPart.Position + Vector3.new(math.random(-100, 100), 0, math.random(-100, 100)))
		end
	end)
	
	-- 🚀 ACTIVATE GOD MODE
	activateGodMode()
	
	-- 🚀 AUTO SPAWN CLONES
	spawnInfiniteClones()
	
	print("🌌 REALITY SHATTERER MODE ACTIVATED!")
	print("💥 TRANSCENDING BEYOND ALL LIMITS!")
	print("🚀 BECOMING THE ABSOLUTE COSMIC ENTITY!")
end

local function stopRealityShatterer()
	-- Disconnect all connections
	if DodgeConnection then DodgeConnection:Disconnect() end
	if AuraConnection then AuraConnection:Disconnect() end
	if AfterimageConnection then AfterimageConnection:Disconnect() end
	if TimeConnection then TimeConnection:Disconnect() end
	if CloneConnection then CloneConnection:Disconnect() end
	if GodConnection then GodConnection:Disconnect() end
	
	-- Restore normal state
	Humanoid.WalkSpeed = 16
	Humanoid.JumpPower = 50
	Humanoid.PlatformStand = false
	Humanoid.MaxHealth = 100
	Humanoid.Health = 100
	
	-- Restore collision
	for _, part in pairs(Character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = true
		end
	end
	
	-- Resume time
	resumeTime()
	
	-- Clear effects and clones
	destroyAura()
	for _, clone in pairs(activeClones) do
		if clone and clone.Parent then
			clone:Destroy()
		end
	end
	activeClones = {}
end

-- 🚀 ABILITY BUTTONS
TimeStopButton.MouseButton1Click:Connect(function()
	if UI_ENABLED then
		if isTimeStopped then
			resumeTime()
			TimeStopButton.Text = "⏰ STOP TIME"
		else
			stopTime()
			TimeStopButton.Text = "⏰ RESUME TIME"
		end
	end
end)

CloneButton.MouseButton1Click:Connect(function()
	if UI_ENABLED then
		spawnInfiniteClones()
	end
end)

-- 🚀 ACTIVATE REALITY SHATTERER
ToggleButton.MouseButton1Click:Connect(function()
	UI_ENABLED = not UI_ENABLED
	
	if UI_ENABLED then
		ToggleButton.Text = "CONTROL REALITY"
		StatusLabel.Text = "⚡ REALITY SHATTERED ⚡"
		StatusLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
		startRealityShatterer()
	else
		ToggleButton.Text = "SHATTER REALITY"
		StatusLabel.Text = "🔴 REALITY INTACT 🔴"
		StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
		stopRealityShatterer()
	end
end)

-- Character respawn handling
LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	Humanoid = char:WaitForChild("Humanoid")
	RootPart = char:WaitForChild("HumanoidRootPart")
	wait(1)
	if UI_ENABLED then
		startRealityShatterer()
	end
end)

print("🚀🌌 BEYOND OVERPOWERED REALITY SHATTERER LOADED 🌌🚀")
print("💥 50X MOVEMENT SPEED - FASTER THAN TIME ITSELF")
print("🌠 INFINITE CLONE ARMY - 20 GOD-LIKE CLONES")
print("⏰ TIME STOP ABILITY - FREEZE REALITY")
print("👑 TRUE GOD MODE - INVINCIBLE AND OMNIPOTENT")
print("⚡ INFINITE DODGES - BECOME UNTOUCHABLE")
print("🌀 COSMIC AURA - VISUALS THAT SHATTER REALITY")
print("🌌 YOU HAVE BECOME THE ABSOLUTE COSMIC ENTITY!")
