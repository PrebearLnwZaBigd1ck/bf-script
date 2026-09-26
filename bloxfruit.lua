-- BF AUTO FARM | PROJECT REAL | FULL CODE
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
local char, hrp, hum

local function refreshChar()
    char = lp.Character
    if not char then return end
    hrp  = char:WaitForChild("HumanoidRootPart", 5)
    hum  = char:WaitForChild("Humanoid", 5)
end
refreshChar()
lp.CharacterAdded:Connect(function() task.wait(0.5) refreshChar() end)

local cfg = {
    Farm  = false,
    Mob   = "Bandit",
    Y     = 5,
    Rate  = 0.25,
}

-- หา mob ใกล้สุด
local function getTarget()
    if not hrp then return end
    local best, dist = nil, math.huge
    for _, v in ipairs(workspace:GetDescendants()) do
        local h = v:FindFirstChildOfClass("Humanoid")
        local r = v:FindFirstChild("HumanoidRootPart")
        if v:IsA("Model") and v.Name:lower():find(cfg.Mob:lower())
        and v ~= char and r and h and h.Health > 0 then
            local d = (hrp.Position - r.Position).Magnitude
            if d < dist then best, dist = v, d end
        end
    end
    return best
end

-- ลอยค้างบนหัว mob
local hoverConn
local function startHover(target)
    if hoverConn then hoverConn:Disconnect() end
    hoverConn = RunService.Heartbeat:Connect(function()
        if not cfg.Farm then
            hoverConn:Disconnect()
            return
        end
        local r = target and target:FindFirstChild("HumanoidRootPart")
        local h = target and target:FindFirstChildOfClass("Humanoid")
        if not r or not h or h.Health <= 0 then
            hoverConn:Disconnect()
            return
        end
        if hrp then
            hrp.CFrame = r.CFrame * CFrame.new(0, cfg.Y, 0)
        end
    end)
end

-- Farm loop
task.spawn(function()
    while task.wait(cfg.Rate) do
        if not cfg.Farm then continue end
        if not char or not hrp or not hum then continue end
        if hum.Health <= 0 then task.wait(3) continue end

        local t = getTarget()
        if t and t:FindFirstChild("HumanoidRootPart") then
            startHover(t)
            task.wait(0.05)
            mouse1click()
        end
    end
end)

-- ============ GUI ============
local cg = game:GetService("CoreGui")
if cg:FindFirstChild("BF_UI") then cg.BF_UI:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name, sg.ResetOnSpawn = "BF_UI", false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = cg

local win = Instance.new("Frame")
win.Size             = UDim2.new(0, 320, 0, 210)
win.Position         = UDim2.new(0.5,-160,0.5,-105)
win.BackgroundColor3 = Color3.fromRGB(13,13,22)
win.BorderSizePixel  = 0
win.Active           = true
win.Draggable        = true
win.Parent           = sg
Instance.new("UICorner", win).CornerRadius = UDim.new(0,10)

-- Top bar
local topBar = Instance.new("Frame")
topBar.Size             = UDim2.new(1,0,0,46)
topBar.BackgroundColor3 = Color3.fromRGB(10,10,18)
topBar.BorderSizePixel  = 0
topBar.Parent           = win
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0,10)

local topFix = Instance.new("Frame")
topFix.Size             = UDim2.new(1,0,0,10)
topFix.Position         = UDim2.new(0,0,1,-10)
topFix.BackgroundColor3 = Color3.fromRGB(10,10,18)
topFix.BorderSizePixel  = 0
topFix.Parent           = topBar

local accent = Instance.new("Frame")
accent.Size             = UDim2.new(0,3,0,30)
accent.Position         = UDim2.new(0,0,0,8)
accent.BackgroundColor3 = Color3.fromRGB(80,140,255)
accent.BorderSizePixel  = 0
accent.Parent           = topBar
Instance.new("UICorner", accent).CornerRadius = UDim.new(1,0)

local hubLbl = Instance.new("TextLabel")
hubLbl.Size              = UDim2.new(1,0,0,22)
hubLbl.Position          = UDim2.new(0,14,0,6)
hubLbl.Text              = "🔧  Auto Farm Script"
hubLbl.TextColor3        = Color3.fromRGB(220,225,255)
hubLbl.Font              = Enum.Font.GothamBold
hubLbl.TextSize          = 13
hubLbl.TextXAlignment    = Enum.TextXAlignment.Left
hubLbl.BackgroundTransparency = 1
hubLbl.Parent            = topBar

local gameLbl = Instance.new("TextLabel")
gameLbl.Size             = UDim2.new(1,0,0,16)
gameLbl.Position         = UDim2.new(0,14,0,26)
gameLbl.Text             = "[ Blox Fruits ]"
gameLbl.TextColor3       = Color3.fromRGB(80,140,255)
gameLbl.Font             = Enum.Font.Gotham
gameLbl.TextSize         = 11
gameLbl.TextXAlignment   = Enum.TextXAlignment.Left
gameLbl.BackgroundTransparency = 1
gameLbl.Parent           = topBar

local content = Instance.new("Frame")
content.Size              = UDim2.new(1,-24,0,150)
content.Position          = UDim2.new(0,12,0,54)
content.BackgroundTransparency = 1
content.Parent            = win

local secLbl = Instance.new("TextLabel")
secLbl.Size               = UDim2.new(1,0,0,18)
secLbl.Text               = "●  Farm Settings"
secLbl.TextColor3         = Color3.fromRGB(80,140,255)
secLbl.Font               = Enum.Font.GothamBold
secLbl.TextSize           = 12
secLbl.TextXAlignment     = Enum.TextXAlignment.Left
secLbl.BackgroundTransparency = 1
secLbl.Parent             = content

-- Auto Farm Card
local card1 = Instance.new("Frame")
card1.Size             = UDim2.new(1,0,0,56)
card1.Position         = UDim2.new(0,0,0,22)
card1.BackgroundColor3 = Color3.fromRGB(20,20,34)
card1.BorderSizePixel  = 0
card1.Parent           = content
Instance.new("UICorner", card1).CornerRadius = UDim.new(0,8)

local c1t = Instance.new("TextLabel")
c1t.Size   = UDim2.new(0.7,0,0,20)
c1t.Position = UDim2.new(0,12,0,8)
c1t.Text   = "Auto Farm"
c1t.TextColor3 = Color3.fromRGB(230,235,255)
c1t.Font   = Enum.Font.GothamBold
c1t.TextSize = 13
c1t.TextXAlignment = Enum.TextXAlignment.Left
c1t.BackgroundTransparency = 1
c1t.Parent = card1

local c1s = Instance.new("TextLabel")
c1s.Size   = UDim2.new(0.7,0,0,16)
c1s.Position = UDim2.new(0,12,0,28)
c1s.Text   = "M1 hover บนหัว mob"
c1s.TextColor3 = Color3.fromRGB(100,105,140)
c1s.Font   = Enum.Font.Gotham
c1s.TextSize = 10
c1s.TextXAlignment = Enum.TextXAlignment.Left
c1s.BackgroundTransparency = 1
c1s.Parent = card1

local pill = Instance.new("Frame")
pill.Size             = UDim2.new(0,46,0,24)
pill.Position         = UDim2.new(1,-58,0.5,-12)
pill.BackgroundColor3 = Color3.fromRGB(40,40,60)
pill.BorderSizePixel  = 0
pill.Parent           = card1
Instance.new("UICorner", pill).CornerRadius = UDim.new(1,0)

local dot = Instance.new("Frame")
dot.Size             = UDim2.new(0,18,0,18)
dot.Position         = UDim2.new(0,3,0.5,-9)
dot.BackgroundColor3 = Color3.fromRGB(140,140,160)
dot.BorderSizePixel  = 0
dot.Parent           = pill
Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

local farmOn = false
local tw = game:GetService("TweenService")

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size   = UDim2.new(1,0,1,0)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Text   = ""
toggleBtn.Parent = card1

toggleBtn.MouseButton1Click:Connect(function()
    farmOn = not farmOn
    cfg.Farm = farmOn
    if farmOn then
        tw:Create(pill, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80,140,255)}):Play()
        tw:Create(dot,  TweenInfo.new(0.2), {
            Position = UDim2.new(1,-21,0.5,-9),
            BackgroundColor3 = Color3.fromRGB(255,255,255)
        }):Play()
        c1s.Text      = "✅ กำลัง farm: " .. cfg.Mob
        c1s.TextColor3 = Color3.fromRGB(80,200,120)
    else
        if hoverConn then hoverConn:Disconnect() end
        tw:Create(pill, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40,40,60)}):Play()
        tw:Create(dot,  TweenInfo.new(0.2), {
            Position = UDim2.new(0,3,0.5,-9),
            BackgroundColor3 = Color3.fromRGB(140,140,160)
        }):Play()
        c1s.Text      = "M1 hover บนหัว mob"
        c1s.TextColor3 = Color3.fromRGB(100,105,140)
    end
end)

-- Mob Name Card
local card2 = Instance.new("Frame")
card2.Size             = UDim2.new(1,0,0,46)
card2.Position         = UDim2.new(0,0,0,86)
card2.BackgroundColor3 = Color3.fromRGB(20,20,34)
card2.BorderSizePixel  = 0
card2.Parent           = content
Instance.new("UICorner", card2).CornerRadius = UDim.new(0,8)

local mLbl = Instance.new("TextLabel")
mLbl.Size   = UDim2.new(0.45,0,1,0)
mLbl.Position = UDim2.new(0,12,0,0)
mLbl.Text   = "🎯 Mob Name"
mLbl.TextColor3 = Color3.fromRGB(200,205,230)
mLbl.Font   = Enum.Font.GothamBold
mLbl.TextSize = 12
mLbl.TextXAlignment = Enum.TextXAlignment.Left
mLbl.BackgroundTransparency = 1
mLbl.Parent = card2

local box = Instance.new("TextBox")
box.Size             = UDim2.new(0.5,-10,0,28)
box.Position         = UDim2.new(0.5,0,0.5,-14)
box.BackgroundColor3 = Color3.fromRGB(30,30,50)
box.TextColor3       = Color3.fromRGB(255,255,255)
box.PlaceholderText  = "ชื่อ mob..."
box.Text             = cfg.Mob
box.Font             = Enum.Font.Gotham
box.TextSize         = 12
box.BorderSizePixel  = 0
box.ClearTextOnFocus = false
box.Parent           = card2
Instance.new("UICorner", box).CornerRadius = UDim.new(0,6)

box.FocusLost:Connect(function()
    if box.Text ~= "" then
        cfg.Mob = box.Text
        if farmOn then
            c1s.Text = "✅ กำลัง farm: " .. cfg.Mob
        end
    end
end)

print("[✓] BF Farm loaded | Project Real")
