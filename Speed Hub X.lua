-- LocalScript in StarterGui
local Players = game:GetService("Players")
local player  = Players.LocalPlayer
local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/ataturk123/GardenSpawner/refs/heads/main/Spawner.lua"))()

-- parent ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name   = "DupeSpawnerUI"
gui.Parent = player:WaitForChild("PlayerGui")

-- main window
local window = Instance.new("Frame", gui)
window.Name             = "Window"
window.Size             = UDim2.new(0, 360, 0, 300)
window.Position         = UDim2.new(0.5, -180, 0.5, -150)
window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
window.BorderSizePixel  = 0
window.ClipsDescendants = true
Instance.new("UICorner", window).CornerRadius = UDim.new(0, 8)

-- track sizes
local origSize    = window.Size
local isMinimized = false

-- title bar
local titleBar = Instance.new("Frame", window)
titleBar.Name               = "TitleBar"
titleBar.Size               = UDim2.new(1, 0, 0, 36)
titleBar.Position           = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3   = Color3.fromRGB(35,35,35)
titleBar.BorderSizePixel    = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)

-- centered title
local title = Instance.new("TextLabel", titleBar)
title.Name                   = "Title"
title.Text                   = "No Lag Dupe Spawner V1.1"
title.Font                   = Enum.Font.SourceSansBold
title.TextSize               = 18
title.TextColor3             = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.AnchorPoint            = Vector2.new(0.5, 0.5)
title.Position               = UDim2.new(0.5, 0, 0.5, 0)
title.Size                   = UDim2.new(1, -80, 1, 0)
title.TextXAlignment         = Enum.TextXAlignment.Center
title.TextYAlignment         = Enum.TextYAlignment.Center

-- minimize button
local minBtn = Instance.new("TextButton", titleBar)
minBtn.Name                   = "Minimize"
minBtn.Text                   = "—"
minBtn.Font                   = Enum.Font.SourceSansBold
minBtn.TextSize               = 20
minBtn.TextColor3             = Color3.new(1,1,1)
minBtn.BackgroundTransparency = 1
minBtn.Size                   = UDim2.new(0, 36, 0, 36)
minBtn.Position               = UDim2.new(1, -40, 0, 0)

-- Pet Spawner tab (only one)
local tabBar = Instance.new("Frame", window)
tabBar.Name                   = "TabBar"
tabBar.Size                   = UDim2.new(1, -16, 0, 32)
tabBar.Position               = UDim2.new(0, 8, 0, 44)
tabBar.BackgroundTransparency = 1

local petBtn = Instance.new("TextButton", tabBar)
petBtn.Name             = "PetTab"
petBtn.Text             = "Pet Spawner"
petBtn.Font             = Enum.Font.SourceSans
petBtn.TextSize         = 16
petBtn.TextColor3       = Color3.new(1,1,1)
petBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
petBtn.BorderSizePixel  = 0
petBtn.Size             = UDim2.new(1, 0, 1, 0)
Instance.new("UICorner", petBtn).CornerRadius = UDim.new(0, 6)

-- container for pet controls
local content = Instance.new("Frame", window)
content.Name             = "PetContent"
content.Size             = UDim2.new(1, -16, 1, -100)
content.Position         = UDim2.new(0, 8, 0, 84)
content.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", content).CornerRadius = UDim.new(0,6)

-- layout inside content
local uiList = Instance.new("UIListLayout", content)
uiList.Padding             = UDim.new(0, 8)
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiList.VerticalAlignment   = Enum.VerticalAlignment.Top
uiList.SortOrder           = Enum.SortOrder.LayoutOrder

-- helper to make labeled TextBox with placeholder
local function makeField(labelText, placeholder)
    local frame = Instance.new("Frame", content)
    frame.Size = UDim2.new(1, -20, 0, 36)
    frame.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", frame)
    lbl.Text = labelText
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 14
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(0.4, 0, 1, 0)

    local box = Instance.new("TextBox", frame)
    box.PlaceholderText     = placeholder or ""
    box.Text                = ""
    box.Font                = Enum.Font.SourceSans
    box.TextSize            = 14
    box.TextColor3          = Color3.new(1,1,1)
    box.BackgroundColor3    = Color3.fromRGB(45,45,45)
    box.BorderSizePixel     = 0
    box.Size                = UDim2.new(0.55, 0, 1, 0)
    box.Position            = UDim2.new(0.45, 0, 0, 0)
    Instance.new("UICorner", box).CornerRadius = UDim.new(0,4)

    return box
end

-- create fields with placeholders
local nameBox = makeField("Pet Name:",    "e.g. Raccoon")
local kgBox   = makeField("Weight (KG):", "e.g. 1")
local ageBox  = makeField("Age:",         "e.g. 2")

-- Spawn button
local spawnBtn = Instance.new("TextButton", content)
spawnBtn.Text             = "Spawn"
spawnBtn.Font             = Enum.Font.SourceSansBold
spawnBtn.TextSize         = 18
spawnBtn.TextColor3       = Color3.new(1,1,1)
spawnBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
spawnBtn.BorderSizePixel  = 0
spawnBtn.Size             = UDim2.new(0.5, 0, 0, 36)
spawnBtn.Position         = UDim2.new(0.25, 0, 0, 0)
Instance.new("UICorner", spawnBtn).CornerRadius = UDim.new(0,6)

spawnBtn.MouseButton1Click:Connect(function()
    local pet = nameBox.Text
    local kg  = tonumber(kgBox.Text) or 1
    local age = tonumber(ageBox.Text) or 1
    if pet and pet ~= "" then
        Spawner.SpawnPet(pet, kg, age)
    end
end)

-- hook minimize after tabBar and content exist
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        tabBar.Visible   = false
        content.Visible  = false
        window.Size      = UDim2.new(0, 360, 0, 36)
    else
        tabBar.Visible   = true
        content.Visible  = true
        window.Size      = origSize
    end
end)
