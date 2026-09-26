-- BLOX FRUITS | M1 HOVER FARM
-- ================================
local VIM      = game:GetService("VirtualInputManager")
local Players  = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS      = game:GetService("UserInputService")

local lp   = Players.LocalPlayer
local char, hrp, hum

local function refreshChar()
    char = lp.Character
    if not char then return end
    hrp  = char:WaitForChild("HumanoidRootPart", 5)
    hum  = char:WaitForChild("Humanoid", 5)
end
refreshChar()
lp.CharacterAdded:Connect(function()
    task.wait(0.5)
    refreshChar()
end)

-- ============ CONFIG ============
local cfg = {
    AutoFarm   = false,
    ESP        = false,
    AutoBuso   = false,
    FarmMob    = "Monkey",   -- ชื่อ mob
    HoverY     = 6,          -- ความสูงเหนือหัว mob
    M1Rate     = 0.3,        -- วินาทีต่อครั้ง
    Speed      = 16,
}

-- ============ FIND MOB ============
local function getTarget()
    if not hrp then return end
    local best, dist = nil, math.huge
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model")
        and v.Name:lower():find(cfg.FarmMob:lower())
        and v ~= char
        and v:FindFirstChild("HumanoidRootPart")
        and v:FindFirstChildOfClass("Humanoid")
        and v:FindFirstChildOfClass("Humanoid").Health > 0 then
            local d = (hrp.Position - v.HumanoidRootPart.Position).Magnitude
            if d < dist then best, dist = v, d end
        end
    end
    return best
end

-- ============ M1 SIMULATE ============
local function doM1()
    local cx = workspace.CurrentCamera
    if not cx then return end
    local screenCenter = cx.ViewportSize / 2
    VIM:SendMouseButtonEvent(screenCenter.X, screenCenter.Y, 0, true,  game, 1)
    task.wait(0.05)
    VIM:SendMouseButtonEvent(screenCenter.X, screenCenter.Y, 0, false, game, 1)
end

-- ============ FARM LOOP ============
task.spawn(function()
    while task.wait(cfg.M1Rate) do
        if not cfg.AutoFarm then continue end
        if not char or not hrp or not hum then continue end
        if hum.Health <= 0 then task.wait(2) continue end

        local mob = getTarget()
        if mob and mob:FindFirstChild("HumanoidRootPart") then
            -- ลอยเหนือหัว
            hrp.CFrame = mob.HumanoidRootPart.CFrame
                       * CFrame.new(0, cfg.HoverY, 0)
            task.wait(0.05)
            -- โจมตี
            doM1()
        end
    end
end)

-- ============ AUTO BUSO ============
task.spawn(function()
    while task.wait(1) do
        if not cfg.AutoBuso then continue end
        -- กด B เพื่อเปิด Buso Haki
        VIM:SendKeyEvent(true,  Enum.KeyCode.B, false, game)
        task.wait(0.1)
        VIM:SendKeyEvent(false, Enum.KeyCode.B, false, game)
    end
end)

-- ============ ESP ============
local espTag = "BF_ESP2"
local function clearESP()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name == espTag then v:Destroy() end
    end
end
local function drawESP()
    clearESP()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v ~= char
        and v:FindFirstChildOfClass("Humanoid")
        and v:FindFirstChild("HumanoidRootPart") then
            local bb = Instance.new("BillboardGui")
            bb.Name        = espTag
            bb.Size        = UDim2.new(0, 100, 0, 24)
            bb.StudsOffset = Vector3.new(0, 3.5, 0)
            bb.AlwaysOnTop = true
            bb.Parent      = v.HumanoidRootPart
            local lbl = Instance.new("TextLabel")
            lbl.Size                    = UDim2.new(1,0,1,0)
            lbl.BackgroundTransparency  = 0.3
            lbl.BackgroundColor3        = Color3.fromRGB(10,10,20)
            lbl.TextColor3              = Color3.fromRGB(255,100,100)
            lbl.Text                    = v.Name
            lbl.Font                    = Enum.Font.GothamBold
            lbl.TextSize                = 12
            lbl.Parent                  = bb
        end
    end
end
task.spawn(function()
    while task.wait(3) do
        if cfg.ESP then drawESP() else clearESP() end
    end
end)

-- ============ SPEED ============
RunService.Heartbeat:Connect(function()
    if hum then hum.WalkSpeed = cfg.Speed end
end)

-- ============ GUI ============
-- ลบ GUI เก่า
local cg = game:GetService("CoreGui")
if cg:FindFirstChild("BF_MAIN") then cg:FindFirstChild("BF_MAIN"):Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name = "BF_MAIN"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = cg

-- Shadow/Background
local shadow = Instance.new("Frame")
shadow.Size             = UDim2.new(0, 256, 0, 380)
shadow.Position         = UDim2.new(0, 12, 0.15, 0)
shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
shadow.BackgroundTransparency = 0.5
shadow.BorderSizePixel  = 0
shadow.Parent           = sg
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0,12)

-- Main Frame
local fr = Instance.new("Frame")
fr.Size             = UDim2.new(0, 250, 0, 375)
fr.Position         = UDim2.new(0, 10, 0.15, 0)
fr.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
fr.BorderSizePixel  = 0
fr.Active           = true
fr.Draggable        = true
fr.Parent           = sg
Instance.new("UICorner", fr).CornerRadius = UDim.new(0, 10)

-- Gradient top
local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30,10,60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12,12,20)),
}
grad.Rotation = 90
grad.Parent   = fr

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size             = UDim2.new(1,0,0,44)
titleBar.BackgroundTransparency = 1
titleBar.Parent           = fr

local titleLbl = Instance.new("TextLabel")
titleLbl.Size         = UDim2.new(1,-10,1,0)
titleLbl.Position     = UDim2.new(0,12,0,0)
titleLbl.Text         = "🌊  BloxFruit  |  M1 Farm"
titleLbl.TextColor3   = Color3.fromRGB(255,220,80)
titleLbl.Font         = Enum.Font.GothamBold
titleLbl.TextSize     = 15
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.BackgroundTransparency = 1
titleLbl.Parent       = titleBar

local divider = Instance.new("Frame")
divider.Size             = UDim2.new(1,-20,0,1)
divider.Position         = UDim2.new(0,10,0,44)
divider.BackgroundColor3 = Color3.fromRGB(60,40,100)
divider.BorderSizePixel  = 0
divider.Parent           = fr

-- Toggle builder
local yy = 54
local function mkToggle(label, desc, key, onColor)
    local card = Instance.new("Frame")
    card.Size             = UDim2.new(1,-16,0,52)
    card.Position         = UDim2.new(0,8,0,yy)
    card.BackgroundColor3 = Color3.fromRGB(20,20,35)
    card.BorderSizePixel  = 0
    card.Parent           = fr
    Instance.new("UICorner", card).CornerRadius = UDim.new(0,8)

    local lbl = Instance.new("TextLabel")
    lbl.Size              = UDim2.new(0.7,0,0,22)
    lbl.Position          = UDim2.new(0,10,0,6)
    lbl.Text              = label
    lbl.TextColor3        = Color3.fromRGB(230,230,240)
    lbl.Font              = Enum.Font.GothamBold
    lbl.TextSize          = 13
    lbl.TextXAlignment    = Enum.TextXAlignment.Left
    lbl.BackgroundTransparency = 1
    lbl.Parent            = card

    local sub = Instance.new("TextLabel")
    sub.Size              = UDim2.new(0.7,0,0,18)
    sub.Position          = UDim2.new(0,10,0,26)
    sub.Text              = desc
    sub.TextColor3        = Color3.fromRGB(130,120,160)
    sub.Font              = Enum.Font.Gotham
    sub.TextSize          = 10
    sub.TextXAlignment    = Enum.TextXAlignment.Left
    sub.BackgroundTransparency = 1
    sub.Parent            = card

    -- Toggle pill
    local pill = Instance.new("Frame")
    pill.Size             = UDim2.new(0,44,0,24)
    pill.Position         = UDim2.new(1,-54,0.5,-12)
    pill.BackgroundColor3 = Color3.fromRGB(50,50,70)
    pill.BorderSizePixel  = 0
    pill.Parent           = card
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1,0)

    local dot = Instance.new("Frame")
    dot.Size             = UDim2.new(0,18,0,18)
    dot.Position         = UDim2.new(0,3,0.5,-9)
    dot.BackgroundColor3 = Color3.fromRGB(160,160,180)
    dot.BorderSizePixel  = 0
    dot.Parent           = pill
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

    local on = false
    local btn = Instance.new("TextButton")
    btn.Size              = UDim2.new(1,0,1,0)
    btn.BackgroundTransparency = 1
    btn.Text              = ""
    btn.Parent            = card

    btn.MouseButton1Click:Connect(function()
        on = not on
        cfg[key] = on
        if on then
            pill.BackgroundColor3 = onColor
            dot.BackgroundColor3  = Color3.fromRGB(255,255,255)
            dot.Position          = UDim2.new(1,-21,0.5,-9)
        else
            pill.BackgroundColor3 = Color3.fromRGB(50,50,70)
            dot.BackgroundColor3  = Color3.fromRGB(160,160,180)
            dot.Position          = UDim2.new(0,3,0.5,-9)
        end
    end)

    yy = yy + 60
end

mkToggle("Auto Farm",  "M1 hover บนหัว mob",    "AutoFarm", Color3.fromRGB(80,200,120))
mkToggle("Auto Buso",  "กด B เปิด Armament Haki","AutoBuso", Color3.fromRGB(255,160,20))
mkToggle("ESP",        "แสดงชื่อ mob/player",    "ESP",      Color3.fromRGB(160,80,255))

-- Mob Name input
local mobCard = Instance.new("Frame")
mobCard.Size             = UDim2.new(1,-16,0,50)
mobCard.Position         = UDim2.new(0,8,0,yy)
mobCard.BackgroundColor3 = Color3.fromRGB(20,20,35)
mobCard.BorderSizePixel  = 0
mobCard.Parent           = fr
Instance.new("UICorner", mobCard).CornerRadius = UDim.new(0,8)

local mobLbl = Instance.new("TextLabel")
mobLbl.Size   = UDim2.new(0.45,0,0,20)
mobLbl.Position = UDim2.new(0,10,0.5,-10)
mobLbl.Text   = "🎯 Mob Name"
mobLbl.TextColor3 = Color3.fromRGB(200,200,220)
mobLbl.Font   = Enum.Font.GothamBold
mobLbl.TextSize = 12
mobLbl.TextXAlignment = Enum.TextXAlignment.Left
mobLbl.BackgroundTransparency = 1
mobLbl.Parent = mobCard

local mobBox = Instance.new("TextBox")
mobBox.Size             = UDim2.new(0.5,-10,0,28)
mobBox.Position         = UDim2.new(0.5,0,0.5,-14)
mobBox.BackgroundColor3 = Color3.fromRGB(30,30,50)
mobBox.TextColor3       = Color3.fromRGB(255,255,255)
mobBox.PlaceholderText  = "Monkey..."
mobBox.Text             = cfg.FarmMob
mobBox.Font             = Enum.Font.Gotham
mobBox.TextSize         = 12
mobBox.BorderSizePixel  = 0
mobBox.ClearTextOnFocus = false
mobBox.Parent           = mobCard
Instance.new("UICorner", mobBox).CornerRadius = UDim.new(0,6)

mobBox.FocusLost:Connect(function()
    if mobBox.Text ~= "" then
        cfg.FarmMob = mobBox.Text
    end
end)

yy = yy + 58

-- Speed control
local spCard = Instance.new("Frame")
spCard.Size             = UDim2.new(1,-16,0,42)
spCard.Position         = UDim2.new(0,8,0,yy)
spCard.BackgroundColor3 = Color3.fromRGB(20,20,35)
spCard.BorderSizePixel  = 0
spCard.Parent           = fr
Instance.new("UICorner", spCard).CornerRadius = UDim.new(0,8)

local spLbl = Instance.new("TextLabel")
spLbl.Size   = UDim2.new(0.5,0,1,0)
spLbl.Position = UDim2.new(0,10,0,0)
spLbl.Text   = "⚡ Speed: " .. cfg.Speed
spLbl.TextColor3 = Color3.fromRGB(200,200,220)
spLbl.Font   = Enum.Font.GothamBold
spLbl.TextSize = 12
spLbl.TextXAlignment = Enum.TextXAlignment.Left
spLbl.BackgroundTransparency = 1
spLbl.Parent = spCard

local function mkSpBtn(txt, xp, col, delta)
    local b = Instance.new("TextButton")
    b.Size             = UDim2.new(0,32,0,26)
    b.Position         = UDim2.new(xp,-36,0.5,-13)
    b.Text             = txt
    b.BackgroundColor3 = col
    b.TextColor3       = Color3.fromRGB(255,255,255)
    b.Font             = Enum.Font.GothamBold
    b.TextSize         = 16
    b.BorderSizePixel  = 0
    b.Parent           = spCard
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    b.MouseButton1Click:Connect(function()
        cfg.Speed = math.clamp(cfg.Speed + delta, 16, 500)
        spLbl.Text = "⚡ Speed: " .. cfg.Speed
    end)
end
mkSpBtn("-", 0.72, Color3.fromRGB(180,30,30),  -10)
mkSpBtn("+", 1.0,  Color3.fromRGB(30,150,30),  10)

print("[✓] BF M1 Farm loaded")
