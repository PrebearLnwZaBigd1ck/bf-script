-- BLOX FRUITS SCRIPT — NO KEY
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp         = Players.LocalPlayer
local char, hrp, hum

local function updateChar()
    char = lp.Character
    if not char then return end
    hrp  = char:WaitForChild("HumanoidRootPart", 5)
    hum  = char:WaitForChild("Humanoid", 5)
end
updateChar()
lp.CharacterAdded:Connect(function(c)
    task.wait(0.5)
    char = c
    hrp  = c:WaitForChild("HumanoidRootPart", 5)
    hum  = c:WaitForChild("Humanoid", 5)
end)

local cfg = {
    AutoFarm = false,
    ESP      = false,
    NoClip   = false,
    Speed    = 16,
    FarmMob  = "Pirate",
}

-- AUTO FARM
local function farmLoop()
    while task.wait(0.1) do
        if not cfg.AutoFarm then continue end
        if not char or not hrp or not hum then continue end
        if hum.Health <= 0 then continue end

        local target = nil
        local dist   = math.huge

        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Model")
            and v.Name:lower():find(cfg.FarmMob:lower())
            and v ~= char
            and v:FindFirstChild("HumanoidRootPart")
            and v:FindFirstChildOfClass("Humanoid")
            and v:FindFirstChildOfClass("Humanoid").Health > 0 then
                local d = (hrp.Position - v.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    target = v
                    dist   = d
                end
            end
        end

        if target then
            -- เทเลพอร์ตชิดข้างๆ mob
            hrp.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3.5)
            task.wait(0.05)
            -- จำลองกดปุ่มโจมตี (ใช้ VirtualUser)
            local vu = game:GetService("VirtualUser")
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end
    end
end
task.spawn(farmLoop)

-- ESP
local espTag = "BF_ESP"
local function clearESP()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name == espTag then v:Destroy() end
    end
end
local function drawESP()
    clearESP()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid")
        and v:FindFirstChild("HumanoidRootPart") and v ~= char then
            local root = v:FindFirstChild("HumanoidRootPart")
            local bb   = Instance.new("BillboardGui")
            bb.Name          = espTag
            bb.Size          = UDim2.new(0, 120, 0, 26)
            bb.StudsOffset   = Vector3.new(0, 4, 0)
            bb.AlwaysOnTop   = true
            bb.Parent        = root
            local lbl = Instance.new("TextLabel")
            lbl.Size                    = UDim2.new(1,0,1,0)
            lbl.BackgroundColor3        = Color3.fromRGB(0,0,0)
            lbl.BackgroundTransparency  = 0.4
            lbl.TextColor3              = Color3.fromRGB(255,80,80)
            lbl.Text                    = "👾 " .. v.Name
            lbl.Font                    = Enum.Font.GothamBold
            lbl.TextSize                = 13
            lbl.Parent                  = bb
        end
    end
end
task.spawn(function()
    while task.wait(3) do
        if cfg.ESP then drawESP() else clearESP() end
    end
end)

-- MAIN LOOP
RunService.Heartbeat:Connect(function()
    if not char or not hrp or not hum then return end
    if cfg.NoClip then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
    if hum then hum.WalkSpeed = cfg.Speed end
end)

-- GUI
local old = game:GetService("CoreGui"):FindFirstChild("BF_GUI")
if old then old:Destroy() end
local screen = Instance.new("ScreenGui")
screen.Name           = "BF_GUI"
screen.ResetOnSpawn   = false
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.Parent         = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size             = UDim2.new(0, 230, 0, 300)
frame.Position         = UDim2.new(0, 15, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
frame.BorderSizePixel  = 0
frame.Active           = true
frame.Draggable        = true
frame.Parent           = screen
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size             = UDim2.new(1, 0, 0, 38)
title.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
title.Text             = "🌊  BloxFruit Script"
title.TextColor3       = Color3.fromRGB(255, 210, 0)
title.Font             = Enum.Font.GothamBold
title.TextSize         = 14
title.BorderSizePixel  = 0
title.Parent           = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

local yOff = 48
local function addToggle(label, key, color)
    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(1, -20, 0, 32)
    btn.Position         = UDim2.new(0, 10, 0, yOff)
    btn.Text             = "⬛  " .. label .. "  [OFF]"
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 48)
    btn.TextColor3       = Color3.fromRGB(200, 200, 210)
    btn.Font             = Enum.Font.Gotham
    btn.TextSize         = 13
    btn.BorderSizePixel  = 0
    btn.Parent           = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        cfg[key] = not cfg[key]
        btn.Text             = (cfg[key] and "✅  " or "⬛  ") .. label .. "  [" .. (cfg[key] and "ON" or "OFF") .. "]"
        btn.BackgroundColor3 = cfg[key] and color or Color3.fromRGB(30, 30, 48)
    end)
    yOff = yOff + 38
end

addToggle("Auto Farm", "AutoFarm", Color3.fromRGB(0, 160, 80))
addToggle("ESP",       "ESP",      Color3.fromRGB(180, 0, 200))
addToggle("NoClip",    "NoClip",   Color3.fromRGB(200, 80, 0))

-- Speed
local speedLbl = Instance.new("TextLabel")
speedLbl.Size                   = UDim2.new(1,-20,0,20)
speedLbl.Position               = UDim2.new(0,10,0,yOff)
speedLbl.Text                   = "Speed: " .. cfg.Speed
speedLbl.TextColor3             = Color3.fromRGB(160,160,180)
speedLbl.BackgroundTransparency = 1
speedLbl.Font                   = Enum.Font.Gotham
speedLbl.TextSize               = 12
speedLbl.TextXAlignment         = Enum.TextXAlignment.Left
speedLbl.Parent                 = frame
yOff = yOff + 22

local spFrame = Instance.new("Frame")
spFrame.Size                    = UDim2.new(1,-20,0,30)
spFrame.Position                = UDim2.new(0,10,0,yOff)
spFrame.BackgroundTransparency  = 1
spFrame.Parent                  = frame

local function makeBtn(txt, xPos, col)
    local b = Instance.new("TextButton")
    b.Size             = UDim2.new(0,40,1,0)
    b.Position         = UDim2.new(xPos,0,0,0)
    b.Text             = txt
    b.BackgroundColor3 = col
    b.TextColor3       = Color3.new(1,1,1)
    b.Font             = Enum.Font.GothamBold
    b.TextSize         = 16
    b.BorderSizePixel  = 0
    b.Parent           = spFrame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    return b
end

local bMinus = makeBtn("-", 0,   Color3.fromRGB(180,30,30))
local bPlus  = makeBtn("+", 0.7, Color3.fromRGB(30,130,30))
bMinus.MouseButton1Click:Connect(function()
    cfg.Speed = math.max(16, cfg.Speed - 10)
    speedLbl.Text = "Speed: " .. cfg.Speed
end)
bPlus.MouseButton1Click:Connect(function()
    cfg.Speed = math.min(500, cfg.Speed + 10)
    speedLbl.Text = "Speed: " .. cfg.Speed
end)

print("[✓] BF Script loaded")
