-- SUPER'S ULTRA INSTINCT + SUPERSKKSKSJSJSJ MODE
-- Multiple modes with ultimate Superskksksjsjsj transformation
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

-- MODE SETTINGS
local UI_ENABLED = false
local CURRENT_MODE = "MASTERED" -- MASTERED, PERFECTION, SUPERSKKSKSJSJSJ
local VELOCITY_THRESHOLD = 100
local DODGE_DISTANCE = {
	MASTERED = 25,
	PERFECTION = 35,
	SUPERSKKSKSJSJSJ = 50
}
local SPEED_BOOST = {
	MASTERED = 2.5,
	PERFECTION = 2.5,
	SUPERSKKSKSJSJSJ = 2.5
}
local PROXIMITY_RANGE = 15
local AFTERIMAGE_INTERVAL = {
	MASTERED = 0.08,
	PERFECTION = 0.05,
	SUPERSKKSKSJSJSJ = 0.02
}

-- Connections
local DodgeConnection, AuraConnection, ProximityConnection, AfterimageConnection, ModeEffectConnection
local dodgeCount = 0
local lastAfterimage = 0

-- Effects Folder
local FXFolder = Instance.new("Folder", workspace)
FXFolder.Name = "SuperUI_FX"

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SuperUIGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Frame.BorderColor3 = Color3.fromRGB(200, 200, 255)
Frame.BorderSizePixel = 3
Frame.Position = UDim2.new(0.35, 0, 0.25, 0)
Frame.Size = UDim2.new(0, 280, 0, 320)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = Frame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new(Color3.fromRGB(15, 15, 25), Color3.fromRGB(30, 30, 50))
UIGradient.Rotation = 45
UIGradient.Parent = Frame

local Header = Instance.new("Frame")
Header.BackgroundColor3 = Color3.fromRGB(200, 200, 255)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 40)
Header.Parent = Frame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 15)
HeaderCorner.Parent = Header

local HeaderCover = Instance.new("Frame")
HeaderCover.BackgroundColor3 = Color3.fromRGB(200, 200, 255)
HeaderCover.BorderSizePixel = 0
HeaderCover.Position = UDim2.new(0, 0, 0.5, 0)
HeaderCover.Size = UDim2.new(1, 0, 0.5, 0)
HeaderCover.Parent = Header

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ SUPER'S ULTRA INSTINCT ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.TextScaled = true
Title.Parent = Header

local StatusLabel = Instance.new("TextLabel")
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.1, 0, 0.15, 0)
StatusLabel.Size = UDim2.new(0.8, 0, 0, 25)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Text = "🔴 DORMANT 🔴"
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.TextSize = 16
StatusLabel.Parent = Frame

-- Mode Selection Frame
local ModeSelectFrame = Instance.new("Frame")
ModeSelectFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ModeSelectFrame.BorderSizePixel = 0
ModeSelectFrame.Position = UDim2.new(0.1, 0, 0.25, 0)
ModeSelectFrame.Size = UDim2.new(0.8, 0, 0, 85)
ModeSelectFrame.Parent = Frame

local ModeSelectCorner = Instance.new("UICorner")
ModeSelectCorner.CornerRadius = UDim.new(0, 8)
ModeSelectCorner.Parent = ModeSelectFrame

local ModeTitle = Instance.new("TextLabel")
ModeTitle.BackgroundTransparency = 1
ModeTitle.Position = UDim2.new(0, 0, 0, 5)
ModeTitle.Size = UDim2.new(1, 0, 0, 20)
ModeTitle.Font = Enum.Font.GothamBold
ModeTitle.Text = "SELECT MODE"
ModeTitle.TextColor3 = Color3.fromRGB(200, 220, 255)
ModeTitle.TextSize = 12
ModeTitle.Parent = ModeSelectFrame

local MasteredBtn = Instance.new("TextButton")
MasteredBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
MasteredBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
MasteredBtn.Size = UDim2.new(0.9, 0, 0, 20)
MasteredBtn.Font = Enum.Font.Gotham
MasteredBtn.Text = "🌟 MASTERED (2.5x)"
MasteredBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MasteredBtn.TextSize = 11
local MasteredCorner = Instance.new("UICorner")
MasteredCorner.CornerRadius = UDim.new(0, 5)
MasteredCorner.Parent = MasteredBtn
MasteredBtn.Parent = ModeSelectFrame

local PerfectionBtn = Instance.new("TextButton")
PerfectionBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 200)
PerfectionBtn.Position = UDim2.new(0.05, 0, 0.575, 0)
PerfectionBtn.Size = UDim2.new(0.9, 0, 0, 20)
PerfectionBtn.Font = Enum.Font.Gotham
PerfectionBtn.Text = "💫 PERFECTION (2.5)"
PerfectionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PerfectionBtn.TextSize = 11
local PerfectionCorner = Instance.new("UICorner")
PerfectionCorner.CornerRadius = UDim.new(0, 5)
PerfectionCorner.Parent = PerfectionBtn
PerfectionBtn.Parent = ModeSelectFrame

local SuperBtn = Instance.new("TextButton")
SuperBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
SuperBtn.Position = UDim2.new(0.05, 0, 0.8, 0)
SuperBtn.Size = UDim2.new(0.9, 0, 0, 20)
SuperBtn.Font = Enum.Font.GothamBold
SuperBtn.Text = "💥 SUPERSKKSKSJSJSJ (2.5x)"
SuperBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SuperBtn.TextSize = 10
local SuperCorner = Instance.new("UICorner")
SuperCorner.CornerRadius = UDim.new(0, 5)
SuperCorner.Parent = SuperBtn
SuperBtn.Parent = ModeSelectFrame

local StatsFrame = Instance.new("Frame")
StatsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
StatsFrame.BorderSizePixel = 0
StatsFrame.Position = UDim2.new(0.1, 0, 0.52, 0)
StatsFrame.Size = UDim2.new(0.8, 0, 0, 70)
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
DodgeLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
DodgeLabel.TextSize = 13
DodgeLabel.TextXAlignment = Enum.TextXAlignment.Left
DodgeLabel.Parent = StatsFrame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Position = UDim2.new(0.05, 0, 0.42, 0)
SpeedLabel.Size = UDim2.new(0.9, 0, 0, 20)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Text = "💨 Speed: 2.5x"
SpeedLabel.TextColor3 = Color3.fromRGB(150, 255, 200)
SpeedLabel.TextSize = 13
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = StatsFrame

local ModeLabel = Instance.new("TextLabel")
ModeLabel.BackgroundTransparency = 1
ModeLabel.Position = UDim2.new(0.05, 0, 0.74, 0)
ModeLabel.Size = UDim2.new(0.9, 0, 0, 20)
ModeLabel.Font = Enum.Font.Gotham
ModeLabel.Text = "🌟 Mode: MASTERED"
ModeLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
ModeLabel.TextSize = 13
ModeLabel.TextXAlignment = Enum.TextXAlignment.Left
ModeLabel.Parent = StatsFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
ToggleButton.Position = UDim2.new(0.1, 0, 0.75, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0, 60)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "AWAKEN"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 24
ToggleButton.Parent = Frame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 12)
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
WarningFrame.Position = UDim2.new(0.3, 0, 0.85, 0)
WarningFrame.Size = UDim2.new(0.4, 0, 0, 50)
WarningFrame.Visible = false
WarningFrame.Parent = ScreenGui

local WarningCorner = Instance.new("UICorner")
WarningCorner.CornerRadius = UDim.new(0, 10)
WarningCorner.Parent = WarningFrame

local WarningLabel = Instance.new("TextLabel")
WarningLabel.BackgroundTransparency = 1
WarningLabel.Size = UDim2.new(1, 0, 1, 0)
WarningLabel.Font = Enum.Font.GothamBold
WarningLabel.Text = "⚠️ DANGER CLOSE ⚠️"
WarningLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WarningLabel.TextSize = 18
WarningLabel.Parent = WarningFrame

-- AURA CREATION
local function createAura()
	local auraSize, auraColor
	
	if CURRENT_MODE == "SUPERSKKSKSJSJSJ" then
		auraSize = 15
		auraColor = Color3.fromHSV(tick() % 1, 1, 1) -- Rainbow
	elseif CURRENT_MODE == "PERFECTION" then
		auraSize = 12
		auraColor = Color3.fromRGB(255, 200, 255)
	else
		auraSize = 8
		auraColor = Color3.fromRGB(200, 200, 255)
	end
	
	local aura = Instance.new("Part")
	aura.Name = "UIAura"
	aura.Size = Vector3.new(auraSize, auraSize, auraSize)
	aura.Position = RootPart.Position
	aura.Anchored = true
	aura.CanCollide = false
	aura.Material = Enum.Material.Neon
	aura.Color = auraColor
	aura.Transparency = 0.7
	aura.Shape = Enum.PartType.Ball
	aura.Parent = FXFolder
	
	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.Sphere
	mesh.Scale = Vector3.new(1, 1, 1)
	mesh.Parent = aura
	
	return aura
end

-- AFTERIMAGE EFFECT
local function createAfterimage()
	if tick() - lastAfterimage < AFTERIMAGE_INTERVAL[CURRENT_MODE] then return end
	lastAfterimage = tick()
	
	local color
	if CURRENT_MODE == "SUPERSKKSKSJSJSJ" then
		color = Color3.fromHSV(math.random(), 1, 1)
	elseif CURRENT_MODE == "PERFECTION" then
		color = Color3.fromRGB(255, 200, 255)
	else
		color = Color3.fromRGB(200, 220, 255)
	end
	
	for _, part in pairs(Character:GetDescendants()) do
		if part:IsA("BasePart") and part.Transparency < 1 and part.Name ~= "HumanoidRootPart" then
			local clone = part:Clone()
			clone.Anchored = true
			clone.CanCollide = false
			clone.Material = Enum.Material.Neon
			clone.Color = color
			clone.Transparency = 0.5
			clone.CFrame = part.CFrame
			clone.Parent = FXFolder
			
			for _, child in pairs(clone:GetChildren()) do
				if not child:IsA("SpecialMesh") then
					child:Destroy()
				end
			end
			
			TweenService:Create(clone, TweenInfo.new(0.3), {Transparency = 1}):Play()
			Debris:AddItem(clone, 0.3)
		end
	end
end

-- DODGE EFFECT
local function createDodgeEffect(position)
	local boltCount, effectSize
	
	if CURRENT_MODE == "SUPERSKKSKSJSJSJ" then
		boltCount = 20
		effectSize = 10
	elseif CURRENT_MODE == "PERFECTION" then
		boltCount = 12
		effectSize = 8
	else
		boltCount = 8
		effectSize = 6
	end
	
	local color = CURRENT_MODE == "SUPERSKKSKSJSJSJ" and Color3.fromHSV(tick() % 1, 1, 1) or 
		(CURRENT_MODE == "PERFECTION" and Color3.fromRGB(255, 200, 255) or Color3.fromRGB(150, 200, 255))
	
	local part = Instance.new("Part")
	part.Size = Vector3.new(effectSize, effectSize, effectSize)
	part.Position = position
	part.Anchored = true
	part.CanCollide = false
	part.Material = Enum.Material.Neon
	part.Color = color
	part.Transparency = 0.2
	part.Shape = Enum.PartType.Ball
	part.Parent = FXFolder
	
	-- Lightning ring
	for i = 1, boltCount do
		local lightning = Instance.new("Part")
		lightning.Size = Vector3.new(0.3, 4, 0.3)
		lightning.Position = position
		lightning.Anchored = true
		lightning.CanCollide = false
		lightning.Material = Enum.Material.Neon
		lightning.Color = CURRENT_MODE == "SUPERSKKSKSJSJSJ" and Color3.fromHSV((i/boltCount), 1, 1) or Color3.fromRGB(255, 255, 255)
		lightning.Parent = FXFolder
		
		local angle = (i / boltCount) * math.pi * 2
		lightning.CFrame = CFrame.new(position) * CFrame.Angles(0, angle, math.rad(45)) * CFrame.new(0, 0, 3)
		
		TweenService:Create(lightning, TweenInfo.new(0.2), {Transparency = 1, Size = Vector3.new(0.1, 6, 0.1)}):Play()
		Debris:AddItem(lightning, 0.2)
	end
	
	TweenService:Create(part, TweenInfo.new(0.4), {Size = Vector3.new(effectSize * 2, effectSize * 2, effectSize * 2), Transparency = 1}):Play()
	Debris:AddItem(part, 0.4)
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
		TweenService:Create(WarningFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
		wait(0.3)
		TweenService:Create(WarningFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.5}):Play()
	end
end

-- MAIN DODGE SYSTEM
local function startUI()
	if DodgeConnection then DodgeConnection:Disconnect() end
	if AuraConnection then AuraConnection:Disconnect() end
	if ProximityConnection then ProximityConnection:Disconnect() end
	if AfterimageConnection then AfterimageConnection:Disconnect() end
	if ModeEffectConnection then ModeEffectConnection:Disconnect() end
	
	-- Speed boost
	Humanoid.WalkSpeed = 16 * SPEED_BOOST[CURRENT_MODE]
	SpeedLabel.Text = "💨 Speed: " .. SPEED_BOOST[CURRENT_MODE] .. "x"
	
	-- Create aura
	local aura = createAura()
	AuraConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED or not aura.Parent then return end
		aura.Position = RootPart.Position
		aura.CFrame = aura.CFrame * CFrame.Angles(0, math.rad(2), 0)
		
		-- Rainbow effect for SUPERSKKSKSJSJSJ
		if CURRENT_MODE == "SUPERSKKSKSJSJSJ" then
			aura.Color = Color3.fromHSV(tick() % 1, 1, 1)
		end
		
		-- Pulse effect
		local scale = 1 + math.sin(tick() * 5) * 0.1
		local size = CURRENT_MODE == "SUPERSKKSKSJSJSJ" and 15 or (CURRENT_MODE == "PERFECTION" and 12 or 8)
		aura.Size = Vector3.new(size * scale, size * scale, size * scale)
	end)
	
	-- Proximity detection
	ProximityConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED then return end
		checkProximity()
	end)
	
	-- Afterimage trail
	AfterimageConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED then return end
		if Humanoid.MoveDirection.Magnitude > 0 then
			createAfterimage()
		end
	end)
	
	-- SUPERSKKSKSJSJSJ rainbow GUI effect
	if CURRENT_MODE == "SUPERSKKSKSJSJSJ" then
		ModeEffectConnection = RunService.Heartbeat:Connect(function()
			if not UI_ENABLED then return end
			Frame.BorderColor3 = Color3.fromHSV(tick() % 1, 1, 1)
		end)
	end
	
	-- Dodge system
	local lastPosition = RootPart.Position
	local lastVelocity = RootPart.Velocity
	
	DodgeConnection = RunService.Heartbeat:Connect(function()
		if not UI_ENABLED then return end
		
		local currentVelocity = RootPart.Velocity
		local velocityMagnitude = currentVelocity.Magnitude
		
		-- DETECT FLING ATTACK
		if velocityMagnitude > VELOCITY_THRESHOLD then
			dodgeCount = dodgeCount + 1
			DodgeLabel.Text = "⚡ Dodges: " .. dodgeCount
			
			local dodgeFrom = RootPart.Position
			local dodgeDirection = -currentVelocity.Unit
			local dodgePosition = lastPosition + (dodgeDirection * DODGE_DISTANCE[CURRENT_MODE])
			
			dodgePosition = Vector3.new(
				dodgePosition.X,
				math.clamp(dodgePosition.Y, lastPosition.Y - 5, lastPosition.Y + 5),
				dodgePosition.Z
			)
			
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
			
			-- Flash GUI
			Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			HeaderCover.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			wait(0.05)
			local headerColor = CURRENT_MODE == "SUPERSKKSKSJSJSJ" and Color3.fromHSV(tick() % 1, 1, 1) or
				(CURRENT_MODE == "PERFECTION" and Color3.fromRGB(200, 150, 255) or Color3.fromRGB(150, 200, 255))
			Header.BackgroundColor3 = headerColor
			HeaderCover.BackgroundColor3 = headerColor
		end
		
		if velocityMagnitude < 50 then
			lastPosition = RootPart.Position
		end
		
		lastVelocity = currentVelocity
	end)
end

local function stopUI()
	if DodgeConnection then DodgeConnection:Disconnect() end
	if AuraConnection then AuraConnection:Disconnect() end
	if ProximityConnection then ProximityConnection:Disconnect() end
	if AfterimageConnection then AfterimageConnection:Disconnect() end
	if ModeEffectConnection then ModeEffectConnection:Disconnect() end
	
	Humanoid.WalkSpeed = 16
	WarningFrame.Visible = false
	
	-- Remove aura
	for _, v in pairs(FXFolder:GetChildren()) do
		if v.Name == "UIAura" then
			v:Destroy()
		end
	end
end

-- MODE SELECTION
MasteredBtn.MouseButton1Click:Connect(function()
	CURRENT_MODE = "MASTERED"
	ModeLabel.Text = "🌟 Mode: MASTERED"
	SpeedLabel.Text = "💨 Speed: 2.5x"
	Frame.BorderColor3 = Color3.fromRGB(200, 200, 255)
	if UI_ENABLED then
		stopUI()
		wait(0.1)
		startUI()
	end
end)

PerfectionBtn.MouseButton1Click:Connect(function()
	CURRENT_MODE = "PERFECTION"
	ModeLabel.Text = "💫 Mode: PERFECTION"
	SpeedLabel.Text = "💨 Speed: 2.5x"
	Frame.BorderColor3 = Color3.fromRGB(200, 150, 255)
	if UI_ENABLED then
		stopUI()
		wait(0.1)
		startUI()
	end
end)

SuperBtn.MouseButton1Click:Connect(function()
	CURRENT_MODE = "SUPERSKKSKSJSJSJ"
	ModeLabel.Text = "💥 Mode: SUPERSKKSKSJSJSJ"
	SpeedLabel.Text = "💨 Speed: 2.5x"
	if UI_ENABLED then
		stopUI()
		wait(0.1)
		startUI()
	end
end)

-- TOGGLE BUTTON
ToggleButton.MouseButton1Click:Connect(function()
	UI_ENABLED = not UI_ENABLED
	
	if UI_ENABLED then
		ToggleButton.Text = CURRENT_MODE
		local headerColor = CURRENT_MODE == "SUPERSKKSKSJSJSJ" and Color3.fromHSV(tick() % 1, 1, 1) or
			(CURRENT_MODE == "PERFECTION" and Color3.fromRGB(200, 150, 255) or Color3.fromRGB(100, 200, 255))
		ButtonGradient.Color = ColorSequence.new(headerColor, headerColor)
		Header.BackgroundColor3 = headerColor
		HeaderCover.BackgroundColor3 = headerColor
		StatusLabel.Text = "⚡ ACTIVE ⚡"
		StatusLabel.TextColor3 = Color3.fromRGB(150, 255, 255)
		startUI()
	else
		ToggleButton.Text = "AWAKEN"
		ButtonGradient.Color = ColorSequence.new(Color3.fromRGB(150, 50, 50), Color3.fromRGB(100, 30, 30))
		Header.BackgroundColor3 = Color3.fromRGB(200, 200, 255)
		HeaderCover.BackgroundColor3 = Color3.fromRGB(200, 200, 255)
		StatusLabel.Text = "🔴 DORMANT 🔴"
		StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		Frame.BorderColor3 = Color3.fromRGB(200, 200, 255)
		stopUI()
	end
end)

-- Character respawn
LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	Humanoid = char:WaitForChild("Humanoid")
	RootPart = char:WaitForChild("HumanoidRootPart")
	dodgeCount = 0
	DodgeLabel.Text = "⚡ Dodges: 0"
	wait(0.5)
	if UI_ENABLED then
		startUI()
	end
end)

print("⚡🔥 SUPER'S ULTRA INSTINCT LOADED 🔥⚡")
print("3 MODES: MASTERED (2.5x), PERFECTION (5x), SUPERSKKSKSJSJSJ (10x)")
print("Auto-dodge, Aura, Speed, Afterimages")
print("Select mode then click AWAKEN!")
