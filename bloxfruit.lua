-- ========================================
-- BLOX FRUITS SCRIPT — NO KEY
-- ========================================

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local lp   = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp, hum

local function updateChar()
    char = lp.Character
    if not char then return end
    hrp  = char:WaitForChild("HumanoidRootPart", 3)
    hum  = char:WaitForChild("Humanoid", 3)
end
updateChar()
lp.CharacterAdded:Connect(updateChar)

-- ========== CONFIG ==========
local cfg = {
    AutoFarm  = false,
    ESP       = false,
    NoClip    = false,
    Speed     = 16,
    FarmMob   = "Pirate",  -- เปลี่ยนชื่อ mob ได้เลย
}

-- ========== AUTO FARM ==========
local function getClosestMob()
    local closest, dist = nil, math.huge
    if not hrp then return end
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:find(cfg.FarmMob)
           and v:FindFirstChild("HumanoidRootPart")
           and v:FindFirstChildOfClass("Humanoid")
           and v:FindFirstChildOfClass("Humanoid").Health > 0 then
            local d = (hrp.Position - v.HumanoidRootPart.Position).Magnitude
            if d < dist then
                closest, dist = v, d
            end
        end
    end
    return closest
end

-- ========== ESP ==========
local espTag = "ESP_COOK45"

local function clearESP()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name == espTag then v:Destroy() end
    end
end

local function drawESP()
    clearESP()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model")
           and v:FindFirstChildOfClass("Humanoid")
           and v:FindFirstChild("HumanoidRootPart")
           and v ~= char then

            local root = v:FindFirstChild("HumanoidRootPart")
            local bb = Instance.new("BillboardGui")
            bb.Name          = espTag
            bb.Size          = UDim2.new(0, 120, 0, 28)
            bb.StudsOffset   = Vector3.new(0, 4, 0)
            bb.AlwaysOnTop   = true
            bb.Parent        = root

            local lbl = Instance.new("TextLabel")
            lbl.Size                = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundColor3    = Color3.fromRGB(0, 0, 0)
            lbl.BackgroundTransparency = 0.4
            lbl.TextColor3          = Color3.fromRGB(255, 80, 80)
            lbl.Text                = "👾 " .. v.Name
            lbl.Font                = Enum.Font.GothamBold
            lbl.TextSize            = 13
            lbl.Parent              = bb
        end
    end
end

-- ========== MAIN LOOP ==========
RunService.Heartbeat:Connect(function()
    if not char or not hrp or not hum then return end

    -- NoClip
    if cfg.NoClip then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end

    -- Speed
    if hum and hum.WalkSpeed ~= cfg.Speed then
        hum.WalkSpeed = cfg.Speed
    end

    -- Auto Farm
    if cfg.AutoFarm then
        local mob = getClosestMob()
        if mob then
            hrp.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
        end
    end
end)

-- ESP refresh ทุก 3 วิ
task.spawn(function()
    while task.wait(3) do
        if cfg.ESP then drawESP()
        else clearESP() end
    end
end)

-- ========== GUI ==========
local old = game:GetService("CoreGui"):FindFirstChild("BF_GUI")
if old then old:Destroy() end

local screen = Instance.new("ScreenGui")
screen.Name          = "BF_GUI"
screen.ResetOnSpawn  = false
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.Parent        = game:GetService("CoreGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size              = UDim2.new(0, 230, 0, 280)
frame.Position          = UDim2.new(0, 15, 0.25, 0)
frame.BackgroundColor3  = Color3.fromRGB(15, 15, 25)
frame.BorderSizePixel   = 0
frame.Active            = true
frame.Draggable         = true
frame.Parent            = screen

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- Title
local title = Instance.new("TextLabel")
title.Size              = UDim2.new(1, 0, 0, 38)
title.BackgroundColor3  = Color3.fromRGB(8, 8, 18)
title.Text              = "🌊  BloxFruit Script"
title.TextColor3        = Color3.fromRGB(255, 210, 0)
title.Font              = Enum.Font.GothamBold
title.TextSize          = 14
title.BorderSizePixel   = 0
title.Parent            = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

-- Toggle builder
local yOff = 48
local function addToggle(label, key, color)
    local btn = Instance.new("TextButton")
    btn.Size              = UDim2.new(1, -20, 0, 32)
    btn.Position          = UDim2.new(0, 10, 0, yOff)
    btn.Text              = "⬛  " .. label .. "  [OFF]"
    btn.BackgroundColor3  = Color3.fromRGB(30, 30, 48)
    btn.TextColor3        = Color3.fromRGB(200, 200, 210)
    btn.Font              = Enum.Font.Gotham
    btn.TextSize          = 13
    btn.BorderSizePixel   = 0
    btn.Parent            = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        cfg[key] = not cfg[key]
        if cfg[key] then
            btn.Text             = "✅  " .. label .. "  [ON]"
            btn.BackgroundColor3 = color or Color3.fromRGB(0, 160, 80)
        else
            btn.Text             = "⬛  " .. label .. "  [OFF]"
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 48)
        end
    end)

    yOff = yOff + 38
end

addToggle("Auto Farm",  "AutoFarm",  Color3.fromRGB(0, 160, 80))
addToggle("ESP",        "ESP",       Color3.fromRGB(180, 0, 200))
addToggle("NoClip",     "NoClip",    Color3.fromRGB(200, 80, 0))

-- Speed Slider label
local speedLbl = Instance.new("TextLabel")
speedLbl.Size             = UDim2.new(1, -20, 0, 20)
speedLbl.Position         = UDim2.new(0, 10, 0, yOff)
speedLbl.Text             = "Speed: " .. cfg.Speed
speedLbl.TextColor3       = Color3.fromRGB(160, 160, 180)
speedLbl.BackgroundTransparency = 1
speedLbl.Font             = Enum.Font.Gotham
speedLbl.TextSize         = 12
speedLbl.TextXAlignment   = Enum.TextXAlignment.Left
speedLbl.Parent           = frame
yOff = yOff + 22

-- Speed +/-
local spFrame = Instance.new("Frame")
spFrame.Size             = UDim2.new(1, -20, 0, 30)
spFrame.Position         = UDim2.new(0, 10, 0, yOff)
spFrame.BackgroundTransparency = 1
spFrame.Parent           = frame

local btnMinus = Instance.new("TextButton")
btnMinus.Size            = UDim2.new(0, 40, 1, 0)
btnMinus.Text            = "  -  "
btnMinus.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
btnMinus.TextColor3      = Color3.fromRGB(255,255,255)
btnMinus.Font            = Enum.Font.GothamBold
btnMinus.TextSize        = 16
btnMinus.BorderSizePixel = 0
btnMinus.Parent          = spFrame
Instance.new("UICorner", btnMinus).CornerRadius = UDim.new(0, 6)

local btnPlus = Instance.new("TextButton")
btnPlus.Size             = UDim2.new(0, 40, 1, 0)
btnPlus.Position         = UDim2.new(1, -40, 0, 0)
btnPlus.Text             = "  +  "
btnPlus.BackgroundColor3 = Color3.fromRGB(30, 130, 30)
btnPlus.TextColor3       = Color3.fromRGB(255,255,255)
btnPlus.Font             = Enum.Font.GothamBold
btnPlus.TextSize         = 16
btnPlus.BorderSizePixel  = 0
btnPlus.Parent           = spFrame
Instance.new("UICorner", btnPlus).CornerRadius = UDim.new(0, 6)

btnMinus.MouseButton1Click:Connect(function()
    cfg.Speed = math.max(16, cfg.Speed - 10)
    speedLbl.Text = "Speed: " .. cfg.Speed
end)
btnPlus.MouseButton1Click:Connect(function()
    cfg.Speed = math.min(500, cfg.Speed + 10)
    speedLbl.Text = "Speed: " .. cfg.Speed
end)

print("[✓] BF Script loaded — no key required")
