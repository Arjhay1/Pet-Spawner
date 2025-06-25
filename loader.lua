-- LocalScript in StarterGui
local Players            = game:GetService("Players")
local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local player             = Players.LocalPlayer

-- load spawner (no default UI)
local Spawner = loadstring(game:HttpGet("https://codeberg.org/DarkBackup/script/raw/branch/main/loadstring"))()

-- parent ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name   = "DupeSpawnerUI"
gui.Parent = player:WaitForChild("PlayerGui")

-- main window (collapsed)
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
titleBar.Size               = UDim2.new(1, 0, 0, 36)
titleBar.Position           = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3   = Color3.fromRGB(35,35,35)
titleBar.BorderSizePixel    = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0,8)
titleBar.ZIndex = 2

-- Title text
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

-- Minimize button
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

-- Dragging logic
do
    local dragging, dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos  = window.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    titleBar.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Pet tab bar
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

-- Content area
local content = Instance.new("Frame", window)
content.Name             = "PetContent"
content.Size             = UDim2.new(1,-16,1,-100)
content.Position         = UDim2.new(0,8,0,84)
content.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", content).CornerRadius = UDim.new(0,6)
content.ZIndex           = 1

local layout = Instance.new("UIListLayout", content)
layout.Padding             = UDim.new(0,8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment   = Enum.VerticalAlignment.Top
layout.SortOrder           = Enum.SortOrder.LayoutOrder

-- Dropdown helper
local function makeDropdown(labelText, items)
    local frame = Instance.new("Frame", content)
    frame.Size = UDim2.new(1,-20,0,36)
    frame.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", frame)
    lbl.Text = labelText
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 14
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(0.4,0,1,0)

    local btn = Instance.new("TextButton", frame)
    btn.Text = items[1]
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(0.55,0,1,0)
    btn.Position = UDim2.new(0.45,0,0,0)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)

    local opts = Instance.new("Frame", frame)
    opts.Visible = false
    opts.BackgroundColor3 = Color3.fromRGB(45,45,45)
    opts.BorderSizePixel = 0
    opts.Position = UDim2.new(0.45,0,1,2)
    opts.Size = UDim2.new(0.55,0,0,#items*36)
    Instance.new("UICorner", opts).CornerRadius = UDim.new(0,4)

    local lst = Instance.new("UIListLayout", opts)
    lst.SortOrder = Enum.SortOrder.LayoutOrder
    lst.Padding   = UDim.new(0,2)

    for i,v in ipairs(items) do
        local e = Instance.new("TextButton", opts)
        e.Text             = v
        e.Font             = Enum.Font.SourceSans
        e.TextSize         = 14
        e.TextColor3       = Color3.new(1,1,1)
        e.BackgroundColor3 = Color3.fromRGB(55,55,55)
        e.BorderSizePixel  = 0
        e.Size             = UDim2.new(1,0,0,36)
        e.LayoutOrder      = i
        Instance.new("UICorner", e).CornerRadius = UDim.new(0,4)
        e.MouseButton1Click:Connect(function()
            btn.Text   = v
            opts.Visible = false
        end)
    end

    btn.MouseButton1Click:Connect(function()
        opts.Visible = not opts.Visible
    end)

    return btn
end

-- Fields
local nameBtn = makeDropdown("Pet Name:", {"Mimic Octopus","Raccoon","Disco Bee","Dragonfly","Queen Bee","Red Fox","Seal"})

local function makeBox(labelText, placeholder)
    local frame = Instance.new("Frame", content)
    frame.Size = UDim2.new(1,-20,0,36)
    frame.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", frame)
    lbl.Text = labelText
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 14
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(0.4,0,1,0)

    local box = Instance.new("TextBox", frame)
    box.PlaceholderText  = placeholder
    box.Text             = ""
    box.Font             = Enum.Font.SourceSans
    box.TextSize         = 14
    box.TextColor3       = Color3.new(1,1,1)
    box.BackgroundColor3 = Color3.fromRGB(45,45,45)
    box.BorderSizePixel  = 0
    box.Size             = UDim2.new(0.55,0,1,0)
    box.Position         = UDim2.new(0.45,0,0,0)
    Instance.new("UICorner", box).CornerRadius = UDim.new(0,4)

    return box
end

local kgBox  = makeBox("Weight (KG):", "e.g. 1")
local ageBox = makeBox("Age:",         "e.g. 2")

-- Spawn button
local spawnBtn = Instance.new("TextButton", content)
spawnBtn.Text             = "Spawn"
spawnBtn.Font             = Enum.Font.SourceSansBold
spawnBtn.TextSize         = 18
spawnBtn.TextColor3       = Color3.new(1,1,1)
spawnBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
spawnBtn.BorderSizePixel  = 0
spawnBtn.Size             = UDim2.new(0.5,0,0,36)
spawnBtn.Position         = UDim2.new(0.25,0,0,0)
Instance.new("UICorner", spawnBtn).CornerRadius = UDim.new(0,6)
spawnBtn.ZIndex = 1

spawnBtn.MouseButton1Click:Connect(function()
    local pet = nameBtn.Text
    local kg  = tonumber(kgBox.Text)  or 1
    local age = tonumber(ageBox.Text) or 1
    if pet ~= "" then
        Spawner.SpawnPet(pet, kg, age)
    end
end)

-- Fade-in
TweenService:Create(window, TweenInfo.new(0.4), {Size = origSize}):Play()

-- Minimize handler
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        window.Size = minimizedSize
        for _,c in ipairs(window:GetChildren()) do
            if c.Name ~= "TitleBar" then
                c.Visible = false
            end
        end
    else
        window.Size = origSize
        for _,c in ipairs(window:GetChildren()) do
            c.Visible = true
        end
    end
end)
