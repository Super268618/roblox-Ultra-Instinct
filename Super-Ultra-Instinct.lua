-- ULTRA INSTINCT DODGER - ANTI-FLING SYSTEM
-- Automatically dodges fling attacks with instant teleportation
-- Place in StarterPlayer → StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- SETTINGS
local DODGE_ENABLED = false
local VELOCITY_THRESHOLD = 100 -- Detect when velocity exceeds this
local DODGE_DISTANCE = 20 -- How far to teleport when dodging
local CHECK_INTERVAL = 0.01 -- How often to check (faster = better)

-- Visual Effects
local DodgeConnection
local EffectsFolder = Instance.new("Folder", workspace)
EffectsFolder.Name = "UltraInstinctFX"

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraInstinctGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Frame.BorderColor3 = Color3.fromRGB(100, 200, 255)
Frame.BorderSizePixel = 3
Frame.Position = UDim2.new(0.4, 0, 0.3, 0)
Frame.Size = UDim2.new(0, 220, 0, 180)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

local Header = Instance.new("Frame")
Header.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 35)
Header.Parent = Frame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local HeaderCover = Instance.new("Frame")
HeaderCover.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
HeaderCover.BorderSizePixel = 0
HeaderCover.Position = UDim2.new(0, 0, 0.5, 0)
HeaderCover.Size = UDim2.new(1, 0, 0.5, 0)
HeaderCover.Parent = Header

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ ULTRA INSTINCT ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Parent = Header

local StatusLabel = Instance.new("TextLabel")
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.1, 0, 0.25, 0)
StatusLabel.Size = UDim2.new(0.8, 0, 0, 25)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Text = "🛡️ PROTECTION: OFF 🛡️"
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.TextSize = 14
StatusLabel.Parent = Frame

local DodgeCounter = Instance.new("TextLabel")
DodgeCounter.BackgroundTransparency = 1
DodgeCounter.Position = UDim2.new(0.1, 0, 0.42, 0)
DodgeCounter.Size = UDim2.new(0.8, 0, 0, 20)
DodgeCounter.Font = Enum.Font.Gotham
DodgeCounter.Text = "Dodges: 0"
DodgeCounter.TextColor3 = Color3.fromRGB(200, 200, 200)
DodgeCounter.TextSize = 13
DodgeCounter.Parent = Frame

local ToggleButton = Instance.new("TextButton")
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleButton.Position = UDim2.new(0.15, 0, 0.62, 0)
ToggleButton.Size = UDim2.new(0.7, 0, 0, 50)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "ACTIVATE"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 20
ToggleButton.Parent = Frame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 10)
ButtonCorner.Parent = ToggleButton

-- Dodge Counter
local dodgeCount = 0

-- Create dodge effect
local function createDodgeEffect(position)
	local part = Instance.new("Part")
	part.Size = Vector3.new(4, 4, 4)
	part.Position = position
	part.Anchored = true
	part.CanCollide = false
	part.Material = Enum.Material.Neon
	part.Color = Color3.fromRGB(100, 200, 255)
	part.Transparency = 0.3
	part.Shape = Enum.PartType.Ball
	part.Parent = EffectsFolder
	
	-- Expand effect
	local tween = game:GetService("TweenService"):Create(part, TweenInfo.new(0.3), {
		Size = Vector3.new(8, 8, 8),
		Transparency = 1
	})
	tween:Play()
	
	game:GetService("Debris"):AddItem(part, 0.3)
end

-- Main dodge function
local function startDodging()
	if DodgeConnection then
		DodgeConnection:Disconnect()
	end
	
	local lastPosition = RootPart.Position
	local lastVelocity = RootPart.Velocity
	
	DodgeConnection = RunService.Heartbeat:Connect(function()
		if not DODGE_ENABLED then return end
		
		local currentVelocity = RootPart.Velocity
		local velocityMagnitude = currentVelocity.Magnitude
		
		-- Detect sudden velocity change (fling attack)
		if velocityMagnitude > VELOCITY_THRESHOLD then
			-- DODGE ACTIVATED
			dodgeCount = dodgeCount + 1
			DodgeCounter.Text = "Dodges: " .. dodgeCount
			
			-- Save current position before dodge
			local dodgeFrom = RootPart.Position
			
			-- Calculate dodge direction (opposite of velocity)
			local dodgeDirection = -currentVelocity.Unit
			local dodgePosition = lastPosition + (dodgeDirection * DODGE_DISTANCE)
			
			-- Make sure dodge position is valid (not too high/low)
			dodgePosition = Vector3.new(
				dodgePosition.X,
				math.clamp(dodgePosition.Y, lastPosition.Y - 5, lastPosition.Y + 5),
				dodgePosition.Z
			)
			
			-- INSTANT TELEPORT
			RootPart.CFrame = CFrame.new(dodgePosition)
			RootPart.Velocity = Vector3.new(0, 0, 0)
			RootPart.RotVelocity = Vector3.new(0, 0, 0)
			
			-- Reset all body parts velocity
			for _, part in pairs(Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Velocity = Vector3.new(0, 0, 0)
					part.RotVelocity = Vector3.new(0, 0, 0)
				end
			end
			
			-- Create visual effects
			createDodgeEffect(dodgeFrom)
			createDodgeEffect(dodgePosition)
			
			-- Flash the GUI
			Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			wait(0.05)
			Header.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
		end
		
		-- Update last safe position
		if velocityMagnitude < 50 then
			lastPosition = RootPart.Position
		end
		
		lastVelocity = currentVelocity
	end)
end

local function stopDodging()
	if DodgeConnection then
		DodgeConnection:Disconnect()
		DodgeConnection = nil
	end
end

-- Toggle button
ToggleButton.MouseButton1Click:Connect(function()
	DODGE_ENABLED = not DODGE_ENABLED
	
	if DODGE_ENABLED then
		ToggleButton.Text = "DEACTIVATE"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
		Header.BackgroundColor3 = Color3.fromRGB(50, 255, 150)
		HeaderCover.BackgroundColor3 = Color3.fromRGB(50, 255, 150)
		StatusLabel.Text = "🛡️ PROTECTION: ON 🛡️"
		StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
		startDodging()
	else
		ToggleButton.Text = "ACTIVATE"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		Header.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
		HeaderCover.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
		StatusLabel.Text = "🛡️ PROTECTION: OFF 🛡️"
		StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		stopDodging()
	end
end)

-- Character respawn
LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	Humanoid = char:WaitForChild("Humanoid")
	RootPart = char:WaitForChild("HumanoidRootPart")
	dodgeCount = 0
	DodgeCounter.Text = "Dodges: 0"
	wait(0.5)
	if DODGE_ENABLED then
		startDodging()
	end
end)

print("⚡ ULTRA INSTINCT DODGER LOADED ⚡")
print("Auto-dodge fling attacks with instant teleportation!")
print("Drag GUI to move it around")
print("Click ACTIVATE to enable protection")
