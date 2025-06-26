-- LocalScript in StarterGui
local Players         = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local UserInputService= game:GetService("UserInputService")
local player          = Players.LocalPlayer
local Spawner         = loadstring(game:HttpGet("https://raw.githubusercontent.com/ataturk123/GardenSpawner/refs/heads/main/Spawner.lua"))()

-- parent ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name   = "DupeSpawnerUI"
gui.Parent = player:WaitForChild("PlayerGui")

-- main window (start hidden for fade-in)
local window = Instance.new("Frame", gui)
window.Name             = "Window"
window.Size             = UDim2.new(0, 360, 0, 0)  -- start at 0 height
window.Position         = UDim2.new(0.5, -180, 0.5, -150)
window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
window.BorderSizePixel  = 0
window.ClipsDescendants = true
Instance.new("UICorner", window).CornerRadius = UDim.new(0, 8)

local origSize      = UDim2.new(0,360,0,300)
local minimizedSize = UDim2.new(0,360,0,36)
local isMinimized   = false

-- Title bar
local titleBar = Instance.new("Frame", window)
titleBar.Name               = "TitleBar"
titleBar.Size               = UDim2.new(1,0,0,36)
titleBar.Position           = UDim2.new(0,0,0,0)
titleBar.BackgroundColor3   = Color3.fromRGB(35,35,35)
titleBar.BorderSizePixel    = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0,8)
titleBar.ZIndex = 2

-- Centered title
local title = Instance.new("TextLabel", titleBar)
title.Name                   = "Title"
title.Text                   = "No Lag Pet Spawner V1.1"
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

-- make window draggable by titleBar
local dragging, dragInput, dragStart, startPos
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
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        window.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Pet Spawner tab
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

-- container for pet controls
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

-- Pet Name dropdown
local petList = {"Raccoon","Dragonfly","Queen Bee","Red Fox"}
local dropdownFrame = Instance.new("Frame", content)
dropdownFrame.Size              = UDim2.new(1,-20,0,36)
dropdownFrame.BackgroundTransparency = 1
dropdownFrame.ZIndex            = 2

local lblName = Instance.new("TextLabel", dropdownFrame)
lblName.Text = "Pet Name:"; lblName.Font = Enum.Font.SourceSans; lblName.TextSize = 14
lblName.TextColor3 = Color3.new(1,1,1); lblName.BackgroundTransparency = 1
lblName.Size = UDim2.new(0.4,0,1,0); lblName.ZIndex = 2

local dropBtn = Instance.new("TextButton", dropdownFrame)
dropBtn.Text = petList[1]; dropBtn.Font = Enum.Font.SourceSans; dropBtn.TextSize = 14
dropBtn.TextColor3 = Color3.new(1,1,1); dropBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
dropBtn.BorderSizePixel = 0; dropBtn.Size = UDim2.new(0.55,0,1,0); dropBtn.Position = UDim2.new(0.45,0,0,0)
Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0,4)
dropBtn.ZIndex = 2

local opts = Instance.new("Frame", dropdownFrame)
opts.Visible           = false
opts.BackgroundColor3  = Color3.fromRGB(45,45,45)
opts.BorderSizePixel   = 0
opts.Position          = UDim2.new(0.45,0,1,2)
opts.Size              = UDim2.new(0.55,0,0,#petList*36)
Instance.new("UICorner", opts).CornerRadius = UDim.new(0,4)
opts.ZIndex            = 2

local optsLayout = Instance.new("UIListLayout", opts)
optsLayout.SortOrder = Enum.SortOrder.LayoutOrder
optsLayout.Padding   = UDim.new(0,2)

for i,v in ipairs(petList) do
    local entry = Instance.new("TextButton", opts)
    entry.Text             = v
    entry.Font             = Enum.Font.SourceSans
    entry.TextSize         = 14
    entry.TextColor3       = Color3.new(1,1,1)
    entry.BackgroundColor3 = Color3.fromRGB(55,55,55)
    entry.BorderSizePixel  = 0
    entry.Size             = UDim2.new(1,0,0,36)
    entry.LayoutOrder      = i
    Instance.new("UICorner", entry).CornerRadius = UDim.new(0,4)
    entry.ZIndex           = 2
    entry.MouseButton1Click:Connect(function()
        dropBtn.Text = v
        opts.Visible  = false
    end)
end
dropBtn.MouseButton1Click:Connect(function() opts.Visible = not opts.Visible end)

-- helper for weight & age
local function makeField(labelText, placeholder)
    local frame = Instance.new("Frame", content)
    frame.Size = UDim2.new(1,-20,0,36); frame.BackgroundTransparency = 1; frame.ZIndex = 1
    local lbl = Instance.new("TextLabel", frame)
    lbl.Text = labelText; lbl.Font = Enum.Font.SourceSans; lbl.TextSize = 14
    lbl.TextColor3 = Color3.new(1,1,1); lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(0.4,0,1,0); lbl.ZIndex = 1
    local box = Instance.new("TextBox", frame)
    box.PlaceholderText  = placeholder or ""
    box.Text             = ""      -- ensure no default "TextBox"
    box.Font             = Enum.Font.SourceSans
    box.TextSize         = 14
    box.TextColor3       = Color3.new(1,1,1)
    box.BackgroundColor3 = Color3.fromRGB(45,45,45)
    box.BorderSizePixel  = 0
    box.Size             = UDim2.new(0.55,0,1,0)
    box.Position         = UDim2.new(0.45,0,0,0)
    Instance.new("UICorner", box).CornerRadius = UDim.new(0,4)
    box.ZIndex = 1
    return box
end

local kgBox  = makeField("Weight (KG):", "e.g. 1")
local ageBox = makeField("Age:",         "e.g. 2")

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
spawnBtn.ZIndex           = 1

spawnBtn.MouseButton1Click:Connect(function()
    local pet = dropBtn.Text
    local kg  = tonumber(kgBox.Text) or 1
    local age = tonumber(ageBox.Text) or 1
    if pet and pet ~= "" then
        Spawner.SpawnPet(pet, kg, age)
    end
end)

-- FADE-IN on start
TweenService:Create(window, TweenInfo.new(0.4), {Size = origSize}):Play()

-- MINIMIZE with animation and placeholders preserved
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    tabBar.Visible, content.Visible = not isMinimized, not isMinimized
    local target = isMinimized and minimizedSize or origSize
    TweenService:Create(window, TweenInfo.new(0.3), {Size = target}):Play()
end)
