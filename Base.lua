local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer or Players:GetPlayers()[1]
local pg = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- Remove existing panel if open
if pg:FindFirstChild("AdminPanel") then pg.AdminPanel:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name = "AdminPanel"
sg.ResetOnSpawn = false
sg.Parent = pg

local frame = Instance.new("Frame")
frame.Name = "AdminFrame"
frame.Size = UDim2.new(0, 280, 0, 420)
frame.Position = UDim2.new(0.5, -140, 0.5, -210)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = sg

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(60, 60, 70)
stroke.Thickness = 1

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local fix = Instance.new("Frame")
fix.Size = UDim2.new(1, 0, 0, 10)
fix.Position = UDim2.new(0, 0, 1, -10)
fix.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
fix.BorderSizePixel = 0
fix.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -45, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚙ Admin Panel"
title.TextColor3 = Color3.fromRGB(220, 220, 230)
title.TextSize = 15
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local container = Instance.new("Frame")
container.Size = UDim2.new(1, -20, 1, -46)
container.Position = UDim2.new(0, 10, 0, 42)
container.BackgroundTransparency = 1
container.Parent = frame
Instance.new("UIListLayout", container).Padding = UDim.new(0, 8)

-- ========================
-- ESP SYSTEM
-- ========================
local espEnabled = false
local espConnections = {}

local teamColorOverrides = {
  Red = Color3.fromRGB(255, 50, 50),
  Blue = Color3.fromRGB(50, 150, 255),
  Green = Color3.fromRGB(50, 255, 50),
  Yellow = Color3.fromRGB(255, 230, 50),
  Orange = Color3.fromRGB(255, 140, 20),
  Purple = Color3.fromRGB(180, 80, 255),
  Pink = Color3.fromRGB(255, 80, 200),
  Cyan = Color3.fromRGB(50, 255, 255),
  White = Color3.fromRGB(240, 240, 240),
  Black = Color3.fromRGB(80, 80, 80),
}

local function getTeamColor(targetPlayer)
  if targetPlayer.Team and targetPlayer.Team.TeamColor then
    return targetPlayer.Team.TeamColor.Color
  end
  return Color3.fromRGB(255, 255, 0) -- neutral / no team
end

local function addESP(targetPlayer)
    if targetPlayer == player then return end

    local function applyHighlight(character)
        if not espEnabled then return end
        if not character then return end

        local old = character:FindFirstChild("AdminESP")
        if old then old:Destroy() end

        local highlight = Instance.new("Highlight")
        highlight.Name = "AdminESP"
        highlight.Adornee = character
        highlight.FillTransparency = 0.7
        highlight.OutlineTransparency = 0
        highlight.FillColor = getTeamColor(targetPlayer)
        highlight.OutlineColor = getTeamColor(targetPlayer)
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = character

        local head = character:FindFirstChild("Head")
        if head then
            local old2 = head:FindFirstChild("AdminESPTag")
            if old2 then old2:Destroy() end

            local billboard = Instance.new("BillboardGui")
            billboard.Name = "AdminESPTag"
            billboard.Adornee = head
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 2.5, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = head

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = targetPlayer.Name
            nameLabel.TextColor3 = getTeamColor(targetPlayer)
            nameLabel.TextSize = 14
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextStrokeTransparency = 0.3
            nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            nameLabel.Parent = billboard

            local distLabel = Instance.new("TextLabel")
            distLabel.Name = "DistLabel"
            distLabel.Size = UDim2.new(1, 0, 0.5, 0)
            distLabel.Position = UDim2.new(0, 0, 0.5, 0)
            distLabel.BackgroundTransparency = 1
            distLabel.Text = "0m"
            distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            distLabel.TextSize = 12
            distLabel.Font = Enum.Font.Gotham
            distLabel.TextStrokeTransparency = 0.3
            distLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            distLabel.Parent = billboard
        end
    end

    if targetPlayer.Character then
        applyHighlight(targetPlayer.Character)
    end

    local conn = targetPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        applyHighlight(char)
    end)
    table.insert(espConnections, conn)
end

local function removeESP(targetPlayer)
    if targetPlayer.Character then
        local h = targetPlayer.Character:FindFirstChild("AdminESP")
        if h then h:Destroy() end
        local head = targetPlayer.Character:FindFirstChild("Head")
        if head then
            local tag = head:FindFirstChild("AdminESPTag")
            if tag then tag:Destroy() end
        end
    end
end

local function enableESP()
    espEnabled = true
    for _, p in Players:GetPlayers() do
        addESP(p)
    end

    local joinConn = Players.PlayerAdded:Connect(function(p)
        if espEnabled then
            task.wait(1)
            addESP(p)
        end
    end)
    table.insert(espConnections, joinConn)

    local leaveConn = Players.PlayerRemoving:Connect(function(p)
        removeESP(p)
    end)
    table.insert(espConnections, leaveConn)

    local distConn
    distConn = RunService.Heartbeat:Connect(function()
        if not espEnabled then distConn:Disconnect() return end
        local myChar = player.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
        local myPos = myChar.HumanoidRootPart.Position

        for _, p in Players:GetPlayers() do
            if p ~= player and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local head = p.Character:FindFirstChild("Head")
                if hrp and head then
                    local tag = head:FindFirstChild("AdminESPTag")
                    if tag then
                        local distLabel = tag:FindFirstChild("DistLabel")
                        if distLabel then
                            local dist = math.floor((myPos - hrp.Position).Magnitude)
                            distLabel.Text = dist .. "m"
                        end
                    end
                end
            end
        end
        local h = p.Character:FindFirstChild("AdminESP")
if h then
  local c = getTeamColor(p)
  h.FillColor = c
  h.OutlineColor = c
  if head then
    local tag = head:FindFirstChild("AdminESPTag")
    if tag then
      local nameLabel = tag:FindFirstChildOfClass("TextLabel")
      if nameLabel then nameLabel.TextColor3 = c end
    end
  end
end
    end)
    table.insert(espConnections, distConn)
end

local function disableESP()
    espEnabled = false
    for _, p in Players:GetPlayers() do
        removeESP(p)
    end
    for _, conn in espConnections do
        if typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        end
    end
    espConnections = {}
end

-- ========================
-- AIMLOCK SYSTEM
-- ========================
local aimlockHolding = false
local aimlockConn = nil
local targetLabel = nil

local function getNearestPlayer()
    local myChar = player.Character
    if not myChar or not myChar:FindFirstChild("Head") then return nil end
    local myPos = myChar.Head.Position

    local nearest = nil
    local nearestDist = math.huge

    for _, p in Players:GetPlayers() do
        if p ~= player and p.Character then
            if player.Team and p.Team and p.Team == player.Team then
                continue
            end

            local head = p.Character:FindFirstChild("Head")
            local humanoid = p.Character:FindFirstChild("Humanoid")
            if head and humanoid and humanoid.Health > 0 then
                local dist = (myPos - head.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = p
                end
            end
        end
    end

    return nearest
end

local function startAimlock()
    if aimlockConn then return end

    aimlockConn = RunService.RenderStepped:Connect(function()
        if not aimlockHolding then return end

        local target = getNearestPlayer()

        if target and target.Character then
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local camPos = camera.CFrame.Position
                local targetPos = hrp.Position
                camera.CFrame = CFrame.new(camPos, targetPos)

                local screenPos, onScreen = camera:WorldToScreenPoint(targetPos)
                if onScreen then
                    mousemoveabs(screenPos.X, screenPos.Y)
                end

                if targetLabel then
                    targetLabel.Text = "🎯 Locked: " .. target.Name
                end
            end
        else
            if targetLabel then
                targetLabel.Text = "🎯 No target found"
            end
        end
    end)
end

local function stopAimlock()
    if aimlockConn then
        aimlockConn:Disconnect()
        aimlockConn = nil
    end
    if targetLabel then
        targetLabel.Text = ""
    end
end

-- ========================
-- AUTO-ATTACK SYSTEM
-- ========================
local autoAttackEnabled = false
local autoAttackConn = nil
local MAX_DISTANCE = 15
local SPAM_DELAY = 0.1
local lastClickTime = 0

local function getNearestEnemyForAttack()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end

    local myHRP = character.HumanoidRootPart
    local nearestEnemy = nil
    local shortestDistance = MAX_DISTANCE

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local isEnemy = true
            if player.Team and p.Team and player.Team == p.Team then
                isEnemy = false
            end

            if isEnemy and p.Character then
                local enemyHRP = p.Character:FindFirstChild("HumanoidRootPart")
                local enemyHum = p.Character:FindFirstChildOfClass("Humanoid")

                if enemyHRP and enemyHum and enemyHum.Health > 0 then
                    local dist = (myHRP.Position - enemyHRP.Position).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        nearestEnemy = p
                    end
                end
            end
        end
    end

    return nearestEnemy
end

local function toggleAutoAttack(enable)
    autoAttackEnabled = enable
    if enable then
        autoAttackConn = RunService.Heartbeat:Connect(function()
            if not autoAttackEnabled then return end
            local enemy = getNearestEnemyForAttack()
            if enemy then
                local currentTime = os.clock()
                if currentTime - lastClickTime >= SPAM_DELAY then
                    lastClickTime = currentTime
                    
                    -- Use VirtualInputManager for Studio compatibility
                    local vim = game:GetService("VirtualInputManager")
                    local mouse = player:GetMouse()
                    vim:SendMouseButtonEvent(mouse.X, mouse.Y, 0, true, game, 0)
                    task.wait(0.01)
                    vim:SendMouseButtonEvent(mouse.X, mouse.Y, 0, false, game, 0)
                end
            end
        end)
        print("[Admin] Auto-Attack Enabled")
    else
        if autoAttackConn then
            autoAttackConn:Disconnect()
            autoAttackConn = nil
        end
        print("[Admin] Auto-Attack Disabled")
    end
end

-- ========================
-- AUTO BED BREAKER SYSTEM
-- ========================
local autoBedEnabled = false
local autoBedConn = nil
local BED_BREAK_RANGE = 15
local BED_CHECK_DELAY = 0.02
local BED_TOGGLE_KEY = Enum.KeyCode.Z
local autoBedButton = nil
local autoBedButtonData = nil

local function isOwnBed(bedPart)
    if not player.Team then return false end
    local myTeamName = player.Team.Name:lower()
    local myColor = player.Team.TeamColor

    local cur = bedPart
    for i = 1, 4 do
        if not cur or cur == workspace then break end

        if cur.Name:lower():find(myTeamName, 1, true) then
            return true
        end

        for _, n in { "Team", "TeamValue", "Owner", "TeamColor", "BedTeam" } do
            local v = cur:FindFirstChild(n)
            if v then
                if v:IsA("StringValue") and v.Value:lower() == myTeamName then return true end
                if v:IsA("ObjectValue") and v.Value == player.Team then return true end
                if v:IsA("BrickColorValue") and v.Value == myColor then return true end
            end
        end

        local attr = cur:GetAttribute("Team") or cur:GetAttribute("TeamName") or cur:GetAttribute("Owner")
        if type(attr) == "string" and attr:lower() == myTeamName then
            return true
        end

        if cur:IsA("BasePart") and myColor and cur.BrickColor == myColor then
            return true
        end

        cur = cur.Parent
    end
    return false
end

local function findNearestEnemyBed()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = char.HumanoidRootPart.Position

    local nearestBed = nil
    local nearestDist = BED_BREAK_RANGE

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (
            obj.Name:lower():find("bed") or
            (obj.Parent and obj.Parent.Name:lower():find("bed"))
        ) then
            if isOwnBed(obj) then continue end

            local dist = (myPos - obj.Position).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearestBed = obj
            end
        end
    end

    return nearestBed, nearestDist
end

local function updateAutoBedButton()
    if not autoBedButton then return end
    if autoBedEnabled then
        autoBedButton.Text = "🛏️ Auto Bed Break [ON] (B)"
        autoBedButton.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
        autoBedButtonData.color = Color3.fromRGB(0, 200, 80)
    else
        autoBedButton.Text = "🛏️ Auto Bed Break [OFF] (B)"
        autoBedButton.BackgroundColor3 = Color3.fromRGB(200, 100, 255)
        autoBedButtonData.color = Color3.fromRGB(200, 100, 255)
    end
end

local function toggleAutoBed(enable)
    autoBedEnabled = enable
    updateAutoBedButton()
    if enable then
        if autoBedConn then task.cancel(autoBedConn) end
        autoBedConn = task.spawn(function()
            local vim = game:GetService("VirtualInputManager")
            while autoBedEnabled do
                local bed, distance = findNearestEnemyBed()
                if bed then
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(bed.Position.X, hrp.Position.Y, bed.Position.Z))
                        camera.CFrame = CFrame.new(camera.CFrame.Position, bed.Position)
                        local screenPos = camera:WorldToScreenPoint(bed.Position)
                        vim:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, true, game, 0)
                        task.wait(0.05)
                        vim:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, false, game, 0)
                    end
                end
                task.wait(BED_CHECK_DELAY)
            end
        end)
        print("[Admin] Auto Bed Breaker Enabled")
    else
        print("[Admin] Auto Bed Breaker Disabled")
    end
end

-- ========================
-- TIME REWIND SYSTEM
-- ========================
local rewindEnabled = false
local rewindConn = nil
local positionHistory = {}
local MAX_HISTORY_TIME = 3
local REWIND_KEY = Enum.KeyCode.X

local function toggleRewind(enable)
    rewindEnabled = enable
    if enable then
        positionHistory = {}
        
        rewindConn = RunService.Heartbeat:Connect(function()
            if not rewindEnabled then return end
            
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                
                if hrp then
                    table.insert(positionHistory, {
                        position = hrp.CFrame,
                        time = tick()
                    })
                    
                    local currentTime = tick()
                    while #positionHistory > 0 and (currentTime - positionHistory[1].time) > MAX_HISTORY_TIME do
                        table.remove(positionHistory, 1)
                    end
                end
            end
        end)
        
        print("[Admin] Time Rewind Enabled - Press X to rewind 3 seconds")
    else
        if rewindConn then
            rewindConn:Disconnect()
            rewindConn = nil
        end
        positionHistory = {}
        print("[Admin] Time Rewind Disabled")
    end
end

local function rewindPosition()
    if not rewindEnabled then 
        print("[Admin] Time Rewind is not enabled!")
        return 
    end
    
    if #positionHistory == 0 then
        print("[Admin] No position history available!")
        return
    end
    
    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        
        if hrp and humanoid and humanoid.Health > 0 then
            local oldestPos = positionHistory[1]
            
            -- Reset all physics
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            
            -- Change to physics state to reset fall distance
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            task.wait(0.05)
            
            -- Teleport to old position
            hrp.CFrame = oldestPos.position
            
            -- Return to normal state
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            task.wait(0.05)
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
            
            -- Extra safety: trigger FloorMaterial to reset fall tracking
            humanoid.FloorMaterial = Enum.Material.Plastic
            
            print("[Admin] Rewound 3 seconds!")
        end
    end
end

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == REWIND_KEY then
        rewindPosition()
    end
end)

-- ========================
-- BUTTON DEFINITIONS & CREATION
-- ========================
local btns = {
    { name = "👁 ESP Players [OFF]",     color = Color3.fromRGB(0, 170, 255),   isESP = true },
    { name = "🎯 Aimlock [HOLD]",        color = Color3.fromRGB(255, 60, 120),  isAimlock = true },
    { name = "⚔ Auto-Attack [OFF]",     color = Color3.fromRGB(50, 180, 90),   isAutoAttack = true },
    { name = "⏪ Time Rewind [OFF]",    color = Color3.fromRGB(100, 200, 255), isRewind = true },
    { name = "🛏️ Auto Bed Break [OFF]", color = Color3.fromRGB(200, 100, 255), isAutoBed = true },
}

for i, data in btns do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 42)
    b.BackgroundColor3 = data.color
    b.BorderSizePixel = 0
    b.Text = data.name
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 15
    b.Font = Enum.Font.GothamSemibold
    b.LayoutOrder = i
    b.Parent = container

    if data.isAutoBed then
        autoBedButton = b
        autoBedButtonData = data
    end
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)

    b.MouseEnter:Connect(function()
        b.BackgroundColor3 = data.color:Lerp(Color3.new(1, 1, 1), 0.15)
    end)
    
        b.MouseLeave:Connect(function()
        if data.isESP and espEnabled then
            b.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
        elseif data.isAimlock and aimlockHolding then
            b.BackgroundColor3 = Color3.fromRGB(255, 30, 80)
        elseif data.isAutoAttack and autoAttackEnabled then
            b.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
        elseif data.isRewind and rewindEnabled then
            b.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
        elseif data.isAutoBed and autoBedEnabled then
            b.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
        else
            b.BackgroundColor3 = data.color
        end
    end)

    if data.isESP then
        b.MouseButton1Click:Connect(function()
            espEnabled = not espEnabled
            if espEnabled then
                b.Text = "👁 ESP Players [ON]"
                b.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
                data.color = Color3.fromRGB(0, 200, 80)
                enableESP()
            else
                b.Text = "👁 ESP Players [OFF]"
                b.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                data.color = Color3.fromRGB(0, 170, 255)
                disableESP()
            end
        end)
        
    elseif data.isAimlock then
        b.MouseButton1Down:Connect(function()
            aimlockHolding = true
            b.Text = "🎯 Aimlock [ACTIVE]"
            b.BackgroundColor3 = Color3.fromRGB(255, 30, 80)
            data.color = Color3.fromRGB(255, 30, 80)
            startAimlock()
        end)

        b.MouseButton1Up:Connect(function()
            aimlockHolding = false
            b.Text = "🎯 Aimlock [HOLD]"
            b.BackgroundColor3 = Color3.fromRGB(255, 60, 120)
            data.color = Color3.fromRGB(255, 60, 120)
            stopAimlock()
        end)

    elseif data.isAutoAttack then
        b.MouseButton1Click:Connect(function()
            autoAttackEnabled = not autoAttackEnabled
            if autoAttackEnabled then
                b.Text = "⚔ Auto-Attack [ON]"
                b.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
                data.color = Color3.fromRGB(0, 200, 80)
                toggleAutoAttack(true)
            else
                b.Text = "⚔ Auto-Attack [OFF]"
                b.BackgroundColor3 = Color3.fromRGB(50, 180, 90)
                data.color = Color3.fromRGB(50, 180, 90)
                toggleAutoAttack(false)
            end
        end)
        
    elseif data.isRewind then
        b.MouseButton1Click:Connect(function()
            rewindEnabled = not rewindEnabled
            if rewindEnabled then
                b.Text = "⏪ Time Rewind [ON]"
                b.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
                data.color = Color3.fromRGB(0, 200, 80)
                toggleRewind(true)
            else
                b.Text = "⏪ Time Rewind [OFF]"
                b.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
                data.color = Color3.fromRGB(100, 200, 255)
                toggleRewind(false)
            end
        end)

            elseif data.isAutoBed then
        b.MouseButton1Click:Connect(function()
            toggleAutoBed(not autoBedEnabled)
        end)
        
    else
        b.MouseButton1Click:Connect(function()
            print("[Admin] " .. data.name .. " clicked")
        end)
    end
end

targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(1, 0, 0, 20)
targetLabel.BackgroundTransparency = 1
targetLabel.Text = ""
targetLabel.TextColor3 = Color3.fromRGB(255, 80, 130)
targetLabel.TextSize = 13
targetLabel.Font = Enum.Font.GothamSemibold
targetLabel.LayoutOrder = 99
targetLabel.Parent = container

-- ========================
-- KEYBIND: Hold V for aimlock
-- ========================
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.V then
        aimlockHolding = true
        startAimlock()
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.V then
        aimlockHolding = false
        stopAimlock()
    end
end)

-- ========================
-- KEYBIND: Toggle UI with Right Shift
-- ========================
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        frame.Visible = not frame.Visible
    end
end)

-- ========================
-- DRAGGING
-- ========================
local dragging, dragInput, dragStart, startPos = false, nil, nil, nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == BED_TOGGLE_KEY then
        toggleAutoBed(not autoBedEnabled)
    end
end)

print("[Admin] Panel loaded successfully.")
