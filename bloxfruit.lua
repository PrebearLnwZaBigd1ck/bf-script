-- BF AUTO FARM | PROJECT REAL COMPATIBLE
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local VIM        = game:GetService("VirtualInputManager")

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

-- หา mob ใกล้ที่สุด
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

-- M1 click
local function click()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local c = cam.ViewportSize / 2
    VIM:SendMouseButtonEvent(c.X, c.Y, 0, true,  game, 1)
    task.wait(0.06)
    VIM:SendMouseButtonEvent(c.X, c.Y, 0, false, game, 1)
end

-- Farm loop
task.spawn(function()
    while task.wait(cfg.Rate) do
        if not cfg.Farm then continue end
        if not char or not hrp or not hum then continue end
        if hum.Health <= 0 then task.wait(3) continue end

        local t = getTarget()
        if t and t:FindFirstChild("HumanoidRootPart") then
            -- ลอยเหนือหัว
            local cf = t.HumanoidRootPart.CFrame
            hrp.CFrame = cf * CFrame.new(0, cfg.Y, 0)
            task.wait(0.05)
            click()
        end
    end
end)

-- ============ GUI (Maru Style) ============
local cg = game:GetService("CoreGui")
if cg:FindFirstChild("BF_UI") then cg.BF_UI:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name, sg.ResetOnSpawn = "BF_UI", false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = cg

-- Window
local win = Instance.new("Frame")
win.Size             = UDim2.new(0, 320, 0, 240)
win.Position         = UDim2.new(0.5,-160, 0.5,-120)
win.BackgroundColor3 = Color3.fromRGB(13,13,22)
win.BorderSizePixel  = 0
win.Active           = true
win.Draggable        = true
win.Parent           = sg
Instance.new("UICorner", win).CornerRadius = UDim.new(0,10)

-- Top bar (Maru style)
local topBar = Instance.new("Frame")
topBar.Size             = UDim2.new(1,0,0,46)
topBar.BackgroundColor3 = Color3.fromRGB(10,10,18)
topBar.BorderSizePixel  = 0
topBar.Parent           = win
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0,10)

-- Fix bottom corners of topbar
local topFix = Instance.new("Frame")
topFix.Size             = UDim2.new(1,0,0,10)
topFix.Position         = UDim2.new(0,0,1,-10)
topFix.BackgroundColor3 = Color3.fromRGB(10,10,18)
topFix.BorderSizePixel  = 0
topFix.Parent           = topBar

-- Blue accent line
local accent = Instance.new("Frame")
accent.Size             = UDim2.new(0,3,1,-16)
accent.Position         = UDim2.new(0,0,0,8)
accent.BackgroundColor3 = Color3.fromRGB(80,140,255)
accent.BorderSizePixel  = 0
accent.Parent           = topBar
Instance.new("UICorner", accent).CornerRadius = UDim.new(1,0)

-- Hub name
local hubName = Instance.new("TextLabel")
hubName.Size              = UDim2.new(1,0,0,24)
hubName.Position          = UDim2.new(0,14,0,6)
hubName.Text              = "🔧  Auto Farm Script"
hubName.TextColor3        = Color3.fromRGB(220,225,255)
hubName.Font              = Enum.Font.GothamBold
hubName.TextSize          = 13
hubName.TextXAlignment    = Enum.TextXAlignment.Left
hubName.BackgroundTransparency = 1
hubName.Parent            = topBar

local gameName = Instance.new("TextLabel")
gameName.Size             = UDim2.new(1,0,0,16)
gameName.Position         = UDim2.new(0,14,0,26)
gameName.Text             = "[ Blox Fruits ]"
gameName.TextColor3       = Color3.fromRGB(80,140,255)
gameName.Font             = Enum.Font.Gotham
gameName.TextSize         = 11
gameName.TextXAlignment   = Enum.TextXAlignment.Left
gameName.BackgroundTransparency = 1
gameName.Parent           = topBar

-- Content area
local content = Instance.new("Frame")
content.Size              = UDim2.new(1,-24,0,180)
content.Position          = UDim2.new(0,12,0,56)
content.BackgroundTransparency = 1
content.Parent            = win

-- Section label
local secLbl = Instance.new("TextLabel")
secLbl.Size               = UDim2.new(1,0,0,18)
secLbl.Text               = "●  Farm Settings"
secLbl.TextColor3         = Color3.fromRGB(80,140,255)
secLbl.Font               = Enum.Font.GothamBold
secLbl.TextSize           = 12
secLbl.TextXAlignment     = Enum.TextXAlignment.Left
secLbl.BackgroundTransparency = 1
secLbl.Parent             = content

-- ---- Auto Farm toggle card ----
local card1 = Instance.new("Frame")
card1.Size             = UDim2.new(1,0,0,56)
card1.Position         = UDim2.new(0,0,0,24)
card1.BackgroundColor3 = Color3.fromRGB(20,20,34)
card1.BorderSizePixel  = 0
card1.Parent           = content
Instance.new("UICorner", card1).CornerRadius = UDim.new(0,8)

local c1title = Instance.new("TextLabel")
c1title.Size   = UDim2.new(0.7,0,0,20)
c1title.Position = UDim2.new(0,12,0,8)
c1title.Text   = "Auto Farm"
c1title.TextColor3 = Color3.fromRGB(230,235,255)
c1title.Font   = Enum.Font.GothamBold
c1title.TextSize = 13
c1title.TextXAlignment = Enum.TextXAlignment.Left
c1title.BackgroundTransparency = 1
c1title.Parent = card1

local c1sub = Instance.new("TextLabel")
c1sub.Size     = UDim2.new(0.7,0,0,16)
c1sub.Position = UDim2.new(0,12,0,28)
c1sub.Text     = "M1 hover บนหัว mob อัตโนมัติ"
c1sub.TextColor3 = Color3.fromRGB(100,105,140)
c1sub.Font     = Enum.Font.Gotham
c1sub.TextSize = 10
c1sub.TextXAlignment = Enum.TextXAlignment.Left
c1sub.BackgroundTransparency = 1
c1sub.Parent   = card1

-- Toggle pill
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
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size   = UDim2.new(1,0,1,0)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Text   = ""
toggleBtn.Parent = card1

local tw = game:GetService("TweenService")
toggleBtn.MouseButton1Click:Connect(function()
    farmOn = not farmOn
    cfg.Farm = farmOn
    if farmOn then
        tw:Create(pill, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80,140,255)}):Play()
        tw:Create(dot,  TweenInfo.new(0.2), {Position = UDim2.new(1,-21,0.5,-9), BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
        c1sub.Text = "✅ กำลัง farm: " .. cfg.Mob
        c1sub.TextColor3 = Color3.fromRGB(80,200,120)
    else
        tw:Create(pill, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40,40,60)}):Play()
        tw:Create(dot,  TweenInfo.new(0.2), {Position = UDim2.new(0,3,0.5,-9), BackgroundColor3 = Color3.fromRGB(140,140,160)}):Play()
        c1sub.Text = "M1 hover บนหัว mob อัตโนมัติ"
        c1sub.TextColor3 = Color3.fromRGB(100,105,140)
    end
end)

-- ---- Mob Name ----
local card2 = Instance.new("Frame")
card2.Size             = UDim2.new(1,0,0,46)
card2.Position         = UDim2.new(0,0,0,88)
card2.BackgroundColor3 = Color3.fromRGB(20,20,34)
card2.BorderSizePixel  = 0
card2.Parent           = content
Instance.new("UICorner", card2).CornerRadius = UDim.new(0,8)

local mobLbl = Instance.new("TextLabel")
mobLbl.Size   = UDim2.new(0.45,0,1,0)
mobLbl.Position = UDim2.new(0,12,0,0)
mobLbl.Text   = "🎯 Mob Name"
mobLbl.TextColor3 = Color3.fromRGB(200,205,230)
mobLbl.Font   = Enum.Font.GothamBold
mobLbl.TextSize = 12
mobLbl.TextXAlignment = Enum.TextXAlignment.Left
mobLbl.BackgroundTransparency = 1
mobLbl.Parent = card2

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
        if farmOn then c1sub.Text = "✅ กำลัง farm: " .. cfg.Mob end
    end
end)

print("[✓] Script loaded on Project Real")
