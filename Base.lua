-- Place this in StarterPlayerScripts or StarterGui as a LocalScript

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Create Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 350)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

-- Round corners for main frame
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Create Title Bar (for dragging)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

-- Fix bottom corners of title bar
local titleFix = Instance.new("Frame")
titleFix.Name = "CornerFix"
titleFix.Size = UDim2.new(1, 0, 0, 10)
titleFix.Position = UDim2.new(0, 0, 1, -10)
titleFix.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

-- Title Text
local titleText = Instance.new("TextLabel")
titleText.Name = "Title"
titleText.Size = UDim2.new(1, -50, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "My Custom UI"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 18
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Button Container
local buttonContainer = Instance.new("Frame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.Size = UDim2.new(1, -30, 1, -60)
buttonContainer.Position = UDim2.new(0, 15, 0, 50)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

-- Layout for buttons
local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 10)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = buttonContainer

-- Button colors
local buttonColors = {
    Color3.fromRGB(70, 130, 230),   -- Blue
    Color3.fromRGB(70, 190, 100),   -- Green
    Color3.fromRGB(230, 160, 50),   -- Orange
    Color3.fromRGB(180, 70, 220),   
