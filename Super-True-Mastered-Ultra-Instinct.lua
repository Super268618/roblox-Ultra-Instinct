-- THE STRONGEST ULTRA INSTINCT - PURE DEFENSE EDITION
-- ABSOLUTE MAXIMUM DODGE & DEFENSE - NO COUNTERS
-- Place in StarterPlayer → StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- PURE DEFENSE SETTINGS
local UI_ENABLED = false
local VELOCITY_THRESHOLD = 25
local DODGE_DISTANCE = 60 -- Increased for better evasion
local SPEED_BOOST = 2.8 -- Increased for better mobility
local PROXIMITY_RANGE = 25
local AFTERIMAGE_INTERVAL = 0.02 -- Faster afterimages
local PREDICTION_RANGE = 30
local INVINCIBILITY_FRAMES = true
local SHOCKWAVE_ENABLED = true
local FTL_DODGE = true
local PERFECT_DODGE_WINDOW = 0.15 -- Seconds for perfect dodge

-- Connections
local DodgeConnection, AuraConnection, ProximityConnection, AfterimageConnection, PredictionConnection, BarrierConnection, AutoDodgeConnection
local dodgeCount = 0
local perfectDodgeCount = 0
local lastAfterimage = 0
local isInvincible = false
local lastDodgeTime = 0

-- Effects Folder
local FXFolder = Instance.new("Folder", workspace)
FXFolder.Name = "PureUI_FX"

-- ENVIRONMENT EFFECTS
local originalLighting = {
	Brightness = Lighting.Brightness,
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient,
	ColorShift_Top = Lighting.ColorShift_Top,
	ColorShift_Bottom = Lighting.ColorShift_Bottom
}

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PureUIGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.BackgroundColor3 = Color3.fromRGB(8, 8, 20)
Frame.BorderColor3 = Color3.fromRGB(100, 150, 255)
Frame.BorderSizePixel = 4
Frame.Position = UDim2.new(0.35, 0, 0.22, 0)
Frame.Size = UDim2.new(0, 320, 0, 360)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 20)
UICorner.Parent = Frame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new(
	Color3.fromRGB(10, 15, 30),
	Color3.fromRGB(20, 25, 60)
)
UIGradient.Rotation = 45
UIGradient.Parent = Frame

local Header = Instance.new("Frame")
Header.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 50)
Header.Parent = Frame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 20)
HeaderCorner.Parent = Header

local HeaderCover = Instance.new("Frame")
HeaderCover.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
HeaderCover.BorderSizePixel = 0
HeaderCover.Position = UDim2.new(0, 0, 0.5, 0)
HeaderCover.Size = UDim2.new(1, 0, 0.5, 0)
HeaderCover.Parent = Header

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Font = Enum.Font.GothamBlack
Title.Text = "⚡ PURE ULTRA INSTINCT ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.TextScaled = true
Title.Parent = Header

local StatusLabel = Instance.new("TextLabel")
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.08, 0, 0.16, 0)
StatusLabel.Size = UDim2.new(0.84, 0, 0, 30)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Text = "🔴 DORMANT 🔴"
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.TextSize = 18
StatusLabel.Parent = Frame

-- POWER FRAME
local PowerFrame = Instance.new("Frame")
PowerFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
PowerFrame.BorderSizePixel = 0
PowerFrame.Position = UDim2.new(0.08, 0, 0.26, 0)
PowerFrame.Size = UDim2.new(0.84, 0, 0, 60)
PowerFrame.Parent = Frame

local PowerCorner = Instance.new("UICorner")
PowerCorner.CornerRadius = UDim.new(0, 12)
PowerCorner.Parent = PowerFrame

local PowerTitle = Instance.new("TextLabel")
PowerTitle.BackgroundTransparency = 1
PowerTitle.Position = UDim2.new(0, 0, 0.1, 0)
PowerTitle.Size = UDim2.new(1, 0, 0, 25)
PowerTitle.Font = Enum.Font.GothamBold
PowerTitle.Text = "💨 SPEED: 2.8x"
PowerTitle.TextColor3 = Color3.fromRGB(150, 255, 200)
PowerTitle.TextSize = 17
PowerTitle.Parent = PowerFrame

local PowerDesc = Instance.new("TextLabel")
PowerDesc.BackgroundTransparency = 1
PowerDesc.Position = UDim2.new(0, 0, 0.55, 0)
PowerDesc.Size = UDim2.new(1, 0, 0, 22)
PowerDesc.Font = Enum.Font.Gotham
PowerDesc.Text = "✨ Pure Defense & Evasion"
PowerDesc.TextColor3 = Color3.fromRGB(200, 220, 255)
PowerDesc.TextSize = 13
PowerDesc.Parent = PowerFrame

-- STATS FRAME
local StatsFrame = Instance.new("Frame")
StatsFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
StatsFrame.BorderSizePixel = 0
StatsFrame.Position = UDim2.new(0.08, 0, 0.46, 0)
StatsFrame.Size = UDim2.new(0.84, 0, 0, 110)
StatsFrame.Parent = Frame

local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 12)
StatsCorner.Parent = StatsFrame

local DodgeLabel = Instance.new("TextLabel")
DodgeLabel.BackgroundTransparency = 1
DodgeLabel.Position = UDim2.new(0.05, 0, 0.08, 0)
DodgeLabel.Size = UDim2.new(0.9, 0, 0, 22)
DodgeLabel.Font = Enum.Font.Gotham
DodgeLabel.Text = "⚡ Dodges: 0"
DodgeLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
DodgeLabel.TextSize = 15
DodgeLabel.TextXAlignment = Enum.TextXAlignment.Left
DodgeLabel.Parent = StatsFrame

local PerfectDodgeLabel = Instance.new("TextLabel")
PerfectDodgeLabel.BackgroundTransparency = 1
PerfectDodgeLabel.Position = UDim2.new(0.05, 0, 0.32, 0)
PerfectDodgeLabel.Size = UDim2.new(0.9, 0, 0, 22)
PerfectDodgeLabel.Font = Enum.Font.Gotham
PerfectDodgeLabel.Text = "🌟 Perfect Dodges: 0"
PerfectDodgeLabel.TextColor3 = Color3.fromRGB(255, 255, 150)
PerfectDodgeLabel.TextSize = 15
PerfectDodgeLabel.TextXAlignment = Enum.TextXAlignment.Left
PerfectDodgeLabel.Parent = StatsFrame

local RangeLabel = Instance.new("TextLabel")
RangeLabel.BackgroundTransparency = 1
RangeLabel.Position = UDim2.new(0.05, 0, 0.56, 0)
RangeLabel.Size = UDim2.new(0.9, 0, 0, 22)
RangeLabel.Font = Enum.Font.Gotham
RangeLabel.Text = "⚡ FTL Dodge: 60 studs"
RangeLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
RangeLabel.TextSize = 15
RangeLabel.TextXAlignment = Enum.TextXAlignment.Left
RangeLabel.Parent = StatsFrame

local DefenseLabel = Instance.new("TextLabel")
DefenseLabel.BackgroundTransparency = 1
DefenseLabel.Position = UDim2.new(0.05, 0, 0.80, 0)
DefenseLabel.Size = UDim2.new(0.9, 0, 0, 22)
DefenseLabel.Font = Enum.Font.Gotham
DefenseLabel.Text = "🛡️ Supreme Defense Mode"
DefenseLabel.TextColor3 = Color3.fromRGB(100, 255, 200)
DefenseLabel.TextSize = 13
DefenseLabel.TextXAlignment = Enum.TextXAlignment.Left
DefenseLabel.Parent = StatsFrame

-- TOGGLE BUTTON
local ToggleButton = Instance.new("TextButton")
ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
ToggleButton.Position = UDim2.new(0.08, 0, 0.78, 0)
ToggleButton.Size = UDim2.new(0.84, 0, 0, 70)
ToggleButton.Font = Enum.Font.GothamBlack
ToggleButton.Text = "AWAKEN"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 30
ToggleButton.Parent = Frame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 16)
ButtonCorner.Parent = ToggleButton

local ButtonGradient = Instance.new("UIGradient")
ButtonGradient.Color = ColorSequence.new(
	Color3.fromRGB(150, 50, 50),
	Color3.fromRGB(100, 30, 30)
)
ButtonGradient.Rotation = 90
ButtonGradient.Parent = ToggleButton

-- WARNING SYSTEM
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
WarningLabel.Font = Enum.Font.GothamBlack
WarningLabel.Text = "⚠️ THREAT DETECTED ⚠️"
WarningLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WarningLabel.TextSize = 20
WarningLabel.TextScaled = true
WarningLabel.Parent = WarningFrame

-- ENVIRONMENT CHANGES
local function applyUILighting()
	if not UI_ENABLED then return end
	
	Lighting.Brightness = 0.8
	Lighting.Ambient = Color3.fromRGB(40, 60, 120)
	Lighting.OutdoorAmbient = Color3.fromRGB(30, 50, 100)
	Lighting.ColorShift_Top = Color3.fromRGB(100, 150, 255)
	Lighting.ColorShift_Bottom = Color3.fromRGB(80, 120, 220)
	
	-- Add slight blur
	local blur = Instance.new("BlurEffect")
	blur.Size = 3
	blur.Name = "UIBlur"
	blur.Parent = Lighting
end

local function restoreLighting()
	Lighting.Brightness = originalLighting.Brightness
	Lighting.Ambient = originalLighting.Ambient
	Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
	Lighting.ColorShift_Top = originalLighting.ColorShift_Top
	Lighting.ColorShift_Bottom = originalLighting.ColorShift_Bottom
	
	-- Remove blur
	local blur = Lighting:FindFirstChild("UIBlur")
	if blur then blur:Destroy() end
end

-- SUPREME AURA
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
	aura.Name = "SupremeAura"
	aura.Size = Vector3.new(16, 16, 16)
	aura.Anchored = true
	aura.CanCollide = false
	aura.Material = Enum.Material.Neon
	aura.Color = Color3.fromRGB(100, 150, 255)
	aura.Transparency = 0.5
	aura.Shape = Enum.PartType.Ball
	aura.CFrame = RootPart.CFrame
	aura.Parent = FXFolder
	table.insert(auraObjects, aura)
	
	-- Multiple rotating rings
	for i = 1, 12 do
		local ring = Instance.new("Part")
		ring.Size = Vector3.new(0.6, 8 + (i * 3), 8 + (i * 3))
		ring.Anchored = true
		ring.CanCollide = false
		ring.Material = Enum.Material.Neon
		ring.Color = Color3.fromRGB(80, 130, 240)
		ring.Transparency = 0.5
		ring.CFrame = RootPart.CFrame
		ring.Parent = FXFolder
		
		local mesh = Instance.new("SpecialMesh")
		mesh.MeshType = Enum.MeshType.Cylinder
		mesh.Parent = ring
		
		table.insert(auraObjects, ring)
	end
	
	-- Flowing energy particles
	for i = 1, 24 do
		local particle = Instance.new("Part")
		particle.Size = Vector3.new(0.6, 0.6, 0.6)
		particle.Anchored = true
		particle.CanCollide = false
		particle.Material = Enum.Material.Neon
		particle.Color = Color3.fromRGB(120, 180, 255)
		particle.Transparency = 0.3
		particle.Shape = Enum.PartType.Ball
		particle.CFrame = RootPart.CFrame
		particle.Parent = FXFolder
		
		table.insert(auraObjects, particle)
	end
	
	-- Static energy orbs (8 directional)
	for i = 1, 8 do
		local orb = Instance.new("Part")
		orb.Size = Vector3.new(2, 2, 2)
		orb.Anchored = true
		orb.CanCollide = false
		orb.Material = Enum.Material.Neon
		orb.Color = Color3.fromRGB(255, 255, 255)
		orb.Transparency = 0.2
		orb.Shape = Enum.PartType.Ball
		orb.CFrame = RootPart.CFrame
		orb.Parent = FXFolder
		
		table.insert(auraObjects, orb)
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
			clone.Color = Color3.fromRGB(120, 180, 255)
			clone.Transparency = 0.3
			clone.CFrame = part.CFrame
			clone.Parent = FXFolder
			
			for _, child in pairs(clone:GetChildren()) do
				if not child:IsA("SpecialMesh") then
					child:Destroy()
				end
			end
			
			TweenService:Create(clone, TweenInfo.new(0.35), {
				Transparency = 1,
				Size = clone.Size * 1.2
			}):Play()
			Debris:AddItem(clone, 0.35)
		end
	end
end

-- DEFENSIVE SHOCKWAVE (NO COUNTER)
local function createShockwave(position)
	if not SHOCKWAVE_ENABLED then return end
	
	-- Main shockwave
	local shockwave = Instance.new("Part")
	shockwave.Size = Vector3.new(1, 1, 1)
	shockwave.Position = position
	shockwave.Anchored = true
	shockwave.CanCollide = false
	shockwave.Material = Enum.Material.Neon
	shockwave.Color = Color3.fromRGB(100, 150, 255)
	shockwave.Transparency = 0.2
	shockwave.Shape = Enum.PartType.Ball
	shockwave.Parent = FXFolder
	
	TweenService:Create(shockwave, TweenInfo.new(0.5), {
		Size = Vector3.new(45, 45, 45),
		Transparency = 1
	}):Play()
	
	-- Energy ripples
	for i = 1, 4 do
		local ripple = Instance.new("Part")
		ripple.Size = Vector3.new(0.5, 0.5, 0.5)
		ripple.Position = position
		ripple.Anchored = true
		ripple.CanCollide = false
		ripple.Material = Enum.Material.Neon
		ripple.Color = Color3.fromRGB(255, 255, 255)
		ripple.Transparency = 0.4
		ripple.Shape = Enum.PartType.Ball
		ripple.Parent = FXFolder
		
		TweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = Vector3.new(35 - i * 5, 35 - i * 5, 35 - i * 5),
			Transparency = 1
		}):Play()
		
		Debris:AddItem(ripple, 0.5)
	end
	
	Debris:AddItem(shockwave, 0.5)
end

-- PERFECT DODGE EFFECT
local function createPerfectDodgeEffect(position)
	-- Golden flash for perfect dodge
	local flash = Instance.new("Part")
	flash.Size = Vector3.new(20, 20, 20)
	flash.Position = position
	flash.Anchored = true
	flash.CanCollide = false
	flash.Material = Enum.Material.Neon
	flash.Color = Color3.fromRGB(255, 215, 0)
	flash.Transparency = 0.1
	flash.Shape = Enum.PartType.Ball
	flash.Parent = FXFolder
	
	-- Star particles
	for i = 1, 8 do
		local star = Instance.new("Part")
		star.Size = Vector3.new(1.5, 1.5, 1.5)
		star.Position = position
		star.Anchored = true
		star.CanCollide = false
		star.Material = Enum.Material.Neon
		star.Color = Color3.fromRGB(255, 255, 200)
		star.Transparency = 0.2
		star.Shape = Enum.PartType.Ball
		star.Parent = FXFolder
		
		local angle = (i / 8) * math.pi * 2
		local targetPos = position + Vector3.new(
			math.cos(angle) * 12,
			math.random(-2, 2),
			math.sin(angle) * 12
		)
		
		TweenService:Create(star, TweenInfo.new(0.4), {
			Position = targetPos,
			Size = Vector3.new(0.2, 0.2, 0.2),
			Transparency = 1
		}):Play()
		Debris:AddItem(star, 0.4)
	end
	
	TweenService:Create(flash, TweenInfo.new(0.4), {
		Size = Vector3.new(35, 35, 35),
		Transparency = 1
	}):Play()
	Debris:AddItem(flash, 0.4)
	
	-- Update GUI with golden flash
	PerfectDodgeLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
	PerfectDodgeLabel.TextSize = 17
	wait(0.1)
	PerfectDodgeLabel.TextColor3 = Color3.fromRGB(255, 255, 150)
	PerfectDodgeLabel.TextSize = 15
end

-- DODGE EFFECT
local function createDodgeEffect(position, isPerfect)
	-- Main dodge sphere
	local part = Instance.new("Part")
	part.Size = Vector3.new(14, 14, 14)
	part.Position = position
	part.Anchored = true
	part.CanCollide = false
	part.Material = Enum.Material.Neon
	part.Color = isPerfect and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(100, 150, 255)
	part.Transparency = 0.15
	part.Shape = Enum.PartType.Ball
	part.Parent = FXFolder
	
	-- Energy trails
	for i = 1, 20 do
		local trail = Instance.new("Part")
		trail.Size = Vector3.new(0.4, 8, 0.4)
		trail.Position = position
		trail.Anchored = true
		trail.CanCollide = false
		trail.Material = Enum.Material.Neon
		trail.Color = isPerfect and Color3.fromRGB(255, 255, 150) or Color3.fromRGB(150, 200, 255)
		trail.Parent = FXFolder
		
		local angle = (i / 20) * math.pi * 2
		trail.CFrame = CFrame.new(position) * CFrame.Angles(0, angle, math.rad(60)) * CFrame.new(0, 0, 7)
		
		TweenService:Create(trail, TweenInfo.new(0.35), {
			Transparency = 1,
			Size = Vector3.new(0.2, 12, 0.2)
		}):Play()
		Debris:AddItem(trail, 0.35)
	end
	
	-- Energy burst
	for i = 1, 16 do
		local particle = Instance.new("Part")
		particle.Size = Vector3.new(2, 2, 2)
		particle.Position = position
		particle.Anchored = true
		particle.CanCollide = false
		particle.Material = Enum.Material.Neon
		particle.Color = isPerfect and Color3.fromRGB(255, 255, 200) or Color3.fromRGB(180, 220, 255)
		particle.Transparency = 0.2
		particle.Shape = Enum.PartType.Ball
		particle.Parent = FXFolder
		
		local angle = (i / 16) * math.pi * 2
		local targetPos = position + Vector3.new(
			math.cos(angle) * 11,
			math.random(-3, 3),
			math.sin(angle) * 11
		)
		
		TweenService:Create(particle, TweenInfo.new(0.45), {
			Position = targetPos,
			Size = Vector3.new(0.3, 0.3, 0.3),
			Transparency = 1
		}):Play()
		Debris:AddItem(particle, 0.45)
	end
	
	TweenService:Create(part, TweenInfo.new(0.5), {
		Size = Vector3.new(30, 30, 30),
		Transparency = 1
	}):Play()
	Debris:AddItem(part, 0.5)
	
	createShockwave(position)
	
	if isPerfect then
		createPerfectDodgeEffect(position)
	end
end

-- TRANSMISSION EFFECT
local function createTransmissionEffect(position)
	for i = 1, 12 do
		local particle = Instance.new("Part")
		particle.Size = Vector3.new(1.2, 1.2, 1.2)
		particle.Position = position
		particle.Anchored = true
		particle.CanCollide = false
		particle.Material = Enum.Material.Neon
		particle.Color = Color3.fromRGB(150, 200, 255)
		particle.Transparency = 0.25
		particle.Shape = Enum.PartType.Ball
		particle.Parent = FXFolder
		
		local angle = (i / 12) * math.pi * 2
		local targetPos = position + Vector3.new(
			math.cos(angle) * 6,
			math.random(-1.5, 1.5),
			math.sin(angle) * 6
		)
		
		TweenService:Create(particle, TweenInfo.new(0.3), {
			Position = targetPos,
			Size = Vector3.new(0.15, 0.15, 0.15),
			Transparency = 1
		}):Play()
		Debris:AddItem(particle, 0.3)
	end
end

-- PROXIMITY DETECTION
local function checkProximity()
	local nearbyThreats = 0
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local theirRoot = player.Character:FindFirstChild("HumanoidRootPart")
			if theirRoot then
				local distance = (theirRoot.Position - RootPart.Position).Magnitude
				if distance < PROXIMITY_RANGE then
					nearbyThreats = nearbyThreats + 1
				end
			end
		end
	end
	
	WarningFrame.Visible = nearbyThreats > 0
	if nearbyThreats > 0 then
		TweenService:Create(WarningFrame, TweenInfo.new(0.15), {BackgroundTransparency = 0.1}):Play()
		wait(0.15)
		TweenService:Create(WarningFrame, TweenInfo.new(0.15), {BackgroundTransparency = 0.25}):Play()
	end
end

-- PREDICTION DODGE (ENHANCED)
local function checkPrediction()
	if not UI_ENABLED then return end
	
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local theirRoot = player.Character:FindFirstChild("HumanoidRootPart")
			if theirRoot then
				local distance = (theirRoot.Position - RootPart.Position).Magnitude
				local theirVelocity = theirRoot.Velocity.Magnitude
				
				if distance < PREDICTION_RANGE and theirVelocity > 500 then
					local direction = (RootPart.Position - theirRoot.Position).Unit
					local theirDirection = theirRoot.Velocity.Unit
					local dotProduct = direction:Dot(theirDirection)
					
					if dotProduct > 0.4 then
						local dodgeDirection = (RootPart.Position - theirRoot.Position).Unit
						local dodgePosition = RootPart.Position + (dodgeDirection * 22)
						
						createTransmissionEffect(RootPart.Position)
						RootPart.CFrame = CFrame.new(dodgePosition)
						createDodgeEffect(dodgePosition, false)
						
						dodgeCount = dodgeCount + 1
						DodgeLabel.Text = "⚡ Dodges: " .. dodgeCount
						
						-- Perfect dodge if timed well
						if tick() - lastDodgeTime < PERFECT_DODGE_WINDOW then
							perfectDodgeCount = perfectDodgeCount + 1
							PerfectDodgeLabel.Text = "🌟 Perfect Dodges: " .. perfectDodgeCount
							createDodgeEffect(dodgePosition, true)
						end
						
						lastDodgeTime = tick()
						break
					end
				end
			end
		end
	end
end

-- DIVINE BARRIER (ENHANCED)
local barrierParts = {}
local function createBarrier()
	for _, part in pairs(barrierParts) do
		if part and part.Parent then
			part:Destroy()
		end
	end
	barrierParts = {}
	
	-- Create multiple barrier layers
	for layer = 1, 3 do
		for i = 1, 16 do
			local barrier = Instance.new("Part")
			barrier.Size = Vector3.new(1.5, 14 - layer * 2, 0.4)
			barrier.Anchored = true
			barrier.CanCollide = false
			barrier.Material = Enum.Material.Neon
			barrier.Color = Color3.fromRGB(100 - layer * 20, 150 - layer * 20, 255 - layer * 20)
			barrier.Transparency = 0.5 + layer * 0.1
			barrier.Parent = FXFolder
			
			table.insert(barrierParts, barrier)
		end
	end
end

-- AUTO-DODGE SYSTEM
local function checkAutoDodge()
	if not UI_ENABLED then return end
	
	-- Check for incoming attacks
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local theirRoot = player.Character:FindFirstChild("HumanoidRootPart")
			if theirRoot then
				local distance = (theirRoot.Position - RootPart.Position).Magnitude
				local theirVelocity = theirRoot.Velocity.Magnitude
				
				-- If they're moving fast toward us at close range
				if distance < 15 and theirVelocity > 800 then
					local directionToUs = (RootPart.Position - theirRoot.Position).Unit
					local theirDirection = theirRoot.Velocity.Unit
					
					if directionToUs:Dot(theirDirection) > 0.7 then
						-- Quick dodge to the side
						local side = math.random() > 0.5 and 1 or -1
						local dodgePosition = RootPart.Position + (RootPart.CFrame.RightVector * side * 10) + Vector3.new(0, 2, 0)
						
						createTransmissionEffect(RootPart.Position)
						RootPart.CFrame = CFrame.new(dodgePosition)
						createDodgeEffect(dodgePosition, false)
						
						dodgeCount = dodgeCount + 1
						DodgeLabel.Text = "⚡ Dodges: " .. dodgeCount
						
						break
					end
				end
			end
		end
	end
end

-- MAIN SYSTEM
local function startPureUI()
	if DodgeConnection then DodgeConnection:Disconnect() end
	if AuraConnection then AuraConnection:Disconnect() end
	if ProximityConnection then ProximityConnection:Disconnect() end
	if AfterimageConnection then AfterimageConnection:Disconnect() end
	if PredictionConnection then PredictionConnection:Disconnect() end
	if BarrierConnection then BarrierConnection:Disconnect() end
	if AutoDodgeConnection then AutoDodgeConnection:Disconnect() end
	
	-- Speed boost
	Humanoid.WalkSpeed = 16 * SPEED_BOOST
	
	-- Apply lighting effects
	applyUILighting()
	
	-- Create aura
	local aura = createAura()
	local particleIndex = 1
	
	-- Aura animation
	AuraConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED or not aura or not aura.Parent then return end
		
		-- Animate main aura
		aura.CFrame = RootPart.CFrame * CFrame.Angles(0, math.rad(tick() * 80), 0)
		local pulse = 1 + math.sin(tick() * 5) * 0.15
		aura.Size = Vector3.new(16 * pulse, 16 * pulse, 16 * pulse)
		
		-- Animate rings
		local ringIndex = 1
		for _, obj in pairs(auraObjects) do
			if obj ~= aura and obj.Parent and obj:IsA("Part") and obj.Shape ~= Enum.PartType.Ball then
				local speed = 120 + ringIndex * 30
				obj.CFrame = RootPart.CFrame * CFrame.Angles(
					math.rad(90),
					0,
					math.rad((ringIndex * 30) + (tick() * speed))
				)
				ringIndex = ringIndex + 1
			end
		end
		
		-- Animate floating particles
		particleIndex = particleIndex + 1
		local particleNum = 1
		for _, obj in pairs(auraObjects) do
			if obj.Shape == Enum.PartType.Ball and obj ~= aura then
				if particleNum <= 24 then
					-- Floating particles
					local angle = ((particleNum + particleIndex) / 24) * math.pi * 2
					local radius = 20 + math.sin(tick() * 2 + particleNum) * 8
					local height = math.sin(tick() * 3 + particleNum) * 12
					obj.CFrame = RootPart.CFrame * CFrame.new(
						math.cos(angle) * radius,
						height,
						math.sin(angle) * radius
					)
				else
					-- Static orbs
					local orbIndex = particleNum - 24
					if orbIndex <= 8 then
						local angle = (orbIndex / 8) * math.pi * 2 + tick() * 0.5
						local radius = 25
						obj.CFrame = RootPart.CFrame * CFrame.new(
							math.cos(angle) * radius,
							math.sin(tick() * 2 + orbIndex) * 3,
							math.sin(angle) * radius
						)
					end
				end
				particleNum = particleNum + 1
			end
		end
	end)
	
	-- Proximity detection
	ProximityConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED then return end
		checkProximity()
	end)
	
	-- Prediction dodge
	local predictionTick = 0
	PredictionConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED then return end
		predictionTick = predictionTick + 1
		if predictionTick >= 8 then
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
		local barrierIndex = 0
		for _, barrier in pairs(barrierParts) do
			if barrier and barrier.Parent then
				barrierIndex = barrierIndex + 1
				local layer = math.floor((barrierIndex - 1) / 16) + 1
				local indexInLayer = ((barrierIndex - 1) % 16)
				
				local radius = 20 - layer * 3
				local angle = (indexInLayer / 16) * math.pi * 2 + tick() * (1 + layer * 0.5)
				barrier.CFrame = RootPart.CFrame * CFrame.new(
					math.cos(angle) * radius,
					math.sin(tick() * 2 + indexInLayer) * 2,
					math.sin(angle) * radius
				) * CFrame.Angles(0, angle + math.rad(90), 0)
			end
		end
	end)
	
	-- Auto-dodge
	local autoDodgeTick = 0
	AutoDodgeConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED then return end
		autoDodgeTick = autoDodgeTick + 1
		if autoDodgeTick >= 5 then
			checkAutoDodge()
			autoDodgeTick = 0
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
					wait(0.6)
					isInvincible = false
				end)
			end
			
			local dodgeFrom = RootPart.Position
			local dodgeDirection = -currentVelocity.Unit
			local dodgePosition = lastPosition + (dodgeDirection * DODGE_DISTANCE)
			
			-- Clamp position
			dodgePosition = Vector3.new(
				dodgePosition.X,
				math.clamp(dodgePosition.Y, lastPosition.Y - 8, lastPosition.Y + 8),
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
			
			-- Check for perfect dodge
			local isPerfect = tick() - lastDodgeTime < PERFECT_DODGE_WINDOW
			if isPerfect then
				perfectDodgeCount = perfectDodgeCount + 1
				PerfectDodgeLabel.Text = "🌟 Perfect Dodges: " .. perfectDodgeCount
			end
			
			createDodgeEffect(dodgeFrom, isPerfect)
			createDodgeEffect(dodgePosition, isPerfect)
			createTransmissionEffect(dodgePosition)
			
			lastDodgeTime = tick()
			
			-- Flash GUI
			Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			HeaderCover.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			wait(0.04)
			Header.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
			HeaderCover.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
		end
		
		if velocityMagnitude < 40 then
			lastPosition = RootPart.Position
		end
	end)
end

local function stopPureUI()
	if DodgeConnection then DodgeConnection:Disconnect() end
	if AuraConnection then AuraConnection:Disconnect() end
	if ProximityConnection then ProximityConnection:Disconnect() end
	if AfterimageConnection then AfterimageConnection:Disconnect() end
	if PredictionConnection then PredictionConnection:Disconnect() end
	if BarrierConnection then BarrierConnection:Disconnect() end
	if AutoDodgeConnection then AutoDodgeConnection:Disconnect() end
	
	Humanoid.WalkSpeed = 16
	WarningFrame.Visible = false
	
	-- Restore lighting
	restoreLighting()
	
	-- Clean effects
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
		ToggleButton.Text = "PURE FORM"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
		ButtonGradient.Color = ColorSequence.new(
			Color3.fromRGB(80, 150, 255),
			Color3.fromRGB(40, 100, 200)
		)
		Header.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
		HeaderCover.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
		StatusLabel.Text = "⚡ PURE ULTRA INSTINCT ⚡"
		StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 255)
		startPureUI()
		
		-- UI effects
		spawn(function()
			while UI_ENABLED do
				Frame.BorderColor3 = Color3.fromHSV(tick() % 1, 0.7, 1)
				wait(0.05)
			end
		end)
	else
		ToggleButton.Text = "AWAKEN"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
		ButtonGradient.Color = ColorSequence.new(
			Color3.fromRGB(150, 50, 50),
			Color3.fromRGB(100, 30, 30)
		)
		Header.BackgroundColor3 = Color3.fromRGB(150, 200, 255)
		HeaderCover.BackgroundColor3 = Color3.fromRGB(150, 200, 255)
		StatusLabel.Text = "🔴 DORMANT 🔴"
		StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		Frame.BorderColor3 = Color3.fromRGB(100, 150, 255)
		stopPureUI()
	end
end)

-- Character respawn
LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	Humanoid = char:WaitForChild("Humanoid")
	RootPart = char:WaitForChild("HumanoidRootPart")
	dodgeCount = 0
	perfectDodgeCount = 0
	DodgeLabel.Text = "⚡ Dodges: 0"
	PerfectDodgeLabel.Text = "🌟 Perfect Dodges: 0"
	wait(0.5)
	if UI_ENABLED then
		startPureUI()
	end
end)

print("⚡⚡⚡ PURE ULTRA INSTINCT - DEFENSE EDITION LOADED ⚡⚡⚡")
print("💨 SPEED: 2.8x (44.8 studs/sec)")
print("⚡ DEFENSE: Pure Evasion Only - No Counters")
print("🌟 FEATURES: Perfect Dodge System, Auto-Dodge, Prediction")
print("✨ AURA: 12 Rings + 24 Particles + 8 Orbs")
print("🛡️ BARRIER: 3-Layer Divine Protection")
print("🌈 EFFECTS: Environment Lighting, Shockwaves, Afterimages")
print("⚡ DODGE: 60-stud FTL Teleport")
print("🎯 Perfect Dodges: Golden Effects & Tracking")
print("✨ PURE DEFENSE PERFECTION ACHIEVED!")
