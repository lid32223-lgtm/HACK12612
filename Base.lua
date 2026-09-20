local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local panel = script.Parent
local minimizeBtn = panel:WaitForChild("MinimizeButton")

-- 1. CONFIGURATION & DESIGN
panel.Size = UDim2.new(0, 250, 0, 350)
panel.Position = UDim2.new(0.5, -125, 0.5, -175)
panel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
panel.BorderSizePixel = 0

-- Setup Minimize Button
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 5)
minimizeBtn.Text = "-"
minimizeBtn.TextSize = 20
minimizeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Dynamically generate 5 sample buttons
for i = 1, 5 do
	local btn = Instance.new("TextButton")
	btn.Name = "ActionButton" .. i
	btn.Size = UDim2.new(0, 210, 0, 40)
	-- Offset the position vertically based on the button index
	btn.Position = UDim2.new(0, 20, 0, 15 + (i * 50))
	btn.Text = "Button " .. i
	btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.Parent = panel
	
	-- Connect your functionality here!
	btn.MouseButton1Click:Connect(function()
		print(btn.Name .. " was clicked!")
	end)
end

-- 2. MINIMIZE LOGIC
local isMinimized = false
local originalSize = panel.Size

minimizeBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	
	if isMinimized then
		-- Shrink the panel so only the top bar/minimize button is visible
		panel.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 40)
		minimizeBtn.Text = "+"
		-- Hide all action buttons
		for _, child in ipairs(panel:GetChildren()) do
			if child:IsA("TextButton") and child ~= minimizeBtn then
				child.Visible = false
			end
		end
	else
		-- Restore the original layout
		panel.Size = originalSize
		minimizeBtn.Text = "-"
		for _, child in ipairs(panel:GetChildren()) do
			if child:IsA("TextButton") then
				child.Visible = true
			end
		end
	end
end)

-- 3. MODERN SMOOTH DRAGGING LOGIC
local dragging, dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	-- Use a short tween for premium, smooth dragging
	TweenService:Create(panel, TweenInfo.new(0.1), {Position = targetPos}):Play()
end

panel.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = panel.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

panel.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)
