-- LocalScript in StarterGui
local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player       = Players.LocalPlayer

-- load spawner (don’t call Spawner.Load())
local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/GrowAFilippino/GrowAGarden/refs/heads/main/Spawner.lua"))()

-- SCREENGUI
local gui = Instance.new("ScreenGui")
gui.Name   = "ArjhayDupeSpawnerV1_1"
gui.Parent = player:WaitForChild("PlayerGui")

-- MAIN WINDOW
local window = Instance.new("Frame", gui)
window.Name             = "Window"
window.AnchorPoint      = Vector2.new(0.5, 0.5)
window.Position         = UDim2.new(0.5, 0, 0.5, 0)
window.Size             = UDim2.new(0, 380, 0, 0)      -- start collapsed for fade-in
window.BackgroundColor3 = Color3.fromRGB(40, 0, 0)    -- dark maroon
window.ClipsDescendants = false
Instance.new("UICorner", window).CornerRadius = UDim.new(0, 12)

-- constants
local FULL_SIZE    = UDim2.new(0, 380, 0, 320)
local MINIMIZED_SZ = UDim2.new(0, 380, 0, 48)
local isMinimized  = false

-- TITLE BAR
local titleBar = Instance.new("Frame", window)
titleBar.Name               = "TitleBar"
titleBar.Position           = UDim2.new(0, 0, 0, 0)
titleBar.Size               = UDim2.new(1, 0, 0, 48)
titleBar.BackgroundColor3   = Color3.fromRGB(180, 0, 0)
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)
titleBar.ZIndex = 2

local title = Instance.new("TextLabel", titleBar)
title.Name                   = "Title"
title.AnchorPoint            = Vector2.new(0.5, 0.5)
title.Position               = UDim2.new(0.5, 0, 0.5, 0)
title.Size                   = UDim2.new(1, -80, 1, 0)
title.Font                   = Enum.Font.GothamBold
title.TextSize               = 20
title.Text                   = "SPD Hub Pet Spawner"
title.TextColor3             = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1

local minBtn = Instance.new("TextButton", titleBar)
minBtn.Name                   = "Minimize"
minBtn.AnchorPoint            = Vector2.new(1, 0.5)
minBtn.Position               = UDim2.new(1, -12, 0.5, 0)
minBtn.Size                   = UDim2.new(0, 32, 0, 32)
minBtn.Font                   = Enum.Font.GothamBold
minBtn.TextSize               = 24
minBtn.Text                   = "–"
minBtn.TextColor3             = Color3.fromRGB(255, 255, 255)
minBtn.BackgroundTransparency = 1
minBtn.ZIndex                 = 2

-- DRAG LOGIC
do
    local dragging, startPos, dragStart
    titleBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = i.Position
            startPos  = window.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    titleBar.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            window.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- MAIN CONTENT
local main = Instance.new("Frame", window)
main.Name                   = "MainContent"
main.Position               = UDim2.new(0, 0, 0, 48)
main.Size                   = UDim2.new(1, 0, 1, -48)
main.BackgroundTransparency = 1
main.ZIndex                 = 1

local layout = Instance.new("UIListLayout", main)
layout.Padding             = UDim.new(0, 16)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder           = Enum.SortOrder.LayoutOrder

-- FIELD HELPERS
local function makeDropdown(labelText, options)
    local container = Instance.new("Frame", main)
    container.Size = UDim2.new(0.9, 0, 0, 40)
    container.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", container)
    lbl.Text                   = labelText
    lbl.Font                   = Enum.Font.Gotham
    lbl.TextSize               = 16
    lbl.TextColor3             = Color3.fromRGB(255, 255, 255)
    lbl.BackgroundTransparency = 1
    lbl.Size                   = UDim2.new(0.4, 0, 1, 0)

    local btn = Instance.new("TextButton", container)
    btn.Text                   = options[1]
    btn.Font                   = Enum.Font.Gotham
    btn.TextSize               = 16
    btn.TextColor3             = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3       = Color3.fromRGB(120, 0, 0)
    btn.BorderSizePixel        = 0
    btn.Size                   = UDim2.new(0.55, 0, 1, 0)
    btn.Position               = UDim2.new(0.45, 0, 0, 0)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    -- popup parented to gui so it isn’t clipped
    local popup = Instance.new("Frame", gui)
    popup.Name                   = "DropdownPopup"
    popup.BackgroundColor3       = Color3.fromRGB(120, 0, 0)
    popup.BorderSizePixel        = 0
    popup.ZIndex                 = 100
    Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 6)

    local popLayout = Instance.new("UIListLayout", popup)
    popLayout.SortOrder = Enum.SortOrder.LayoutOrder
    popLayout.Padding   = UDim.new(0, 4)

    -- populate
    for i, v in ipairs(options) do
        local opt = Instance.new("TextButton", popup)
        opt.Text                   = v
        opt.Font                   = Enum.Font.Gotham
        opt.TextSize               = 16
        opt.TextColor3             = Color3.fromRGB(255, 255, 255)
        opt.BackgroundColor3       = Color3.fromRGB(160, 0, 0)
        opt.BorderSizePixel        = 0
        opt.Size                   = UDim2.new(1, 0, 0, 36)
        opt.LayoutOrder            = i
        Instance.new("UICorner", opt).CornerRadius = UDim.new(0, 6)
        opt.ZIndex = 100

        opt.MouseButton1Click:Connect(function()
            btn.Text     = v
            popup.Visible = false
        end)
    end

    btn.MouseButton1Click:Connect(function()
        -- reposition & size
        local absPos = btn.AbsolutePosition
        popup.Position = UDim2.new(0, absPos.X, 0, absPos.Y + btn.AbsoluteSize.Y + 4)
        popup.Size     = UDim2.new(0, btn.AbsoluteSize.X, 0, #options * 40 + ((#options-1)*4))
        popup.Visible  = not popup.Visible
    end)

    return btn
end

local function makeBox(labelText, placeholder)
    local container = Instance.new("Frame", main)
    container.Size = UDim2.new(0.9, 0, 0, 40)
    container.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", container)
    lbl.Text                   = labelText
    lbl.Font                   = Enum.Font.Gotham
    lbl.TextSize               = 16
    lbl.TextColor3             = Color3.fromRGB(255, 255, 255)
    lbl.BackgroundTransparency = 1
    lbl.Size                   = UDim2.new(0.4, 0, 1, 0)

    local box = Instance.new("TextBox", container)
    box.PlaceholderText     = placeholder
    box.Text                = ""
    box.Font                = Enum.Font.Gotham
    box.TextSize            = 16
    box.TextColor3          = Color3.fromRGB(255, 255, 255)
    box.BackgroundColor3    = Color3.fromRGB(120, 0, 0)
    box.BorderSizePixel     = 0
    box.Size                = UDim2.new(0.55, 0, 1, 0)
    box.Position            = UDim2.new(0.45, 0, 0, 0)
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

    return box
end

-- make fields
local petPicker = makeDropdown("Pet Name:", {"Mimic Octopus","Raccoon","Disco Bee","Butterfly","Dragonfly","Queen Bee"})
local weightBox = makeBox("Weight (KG):", "e.g. 1")
local ageBox    = makeBox("Age:",          "e.g. 2")

-- SPAWN BUTTON
local spawnBtn = Instance.new("TextButton", main)
spawnBtn.Text             = "Spawn"
spawnBtn.Font             = Enum.Font.GothamBold
spawnBtn.TextSize         = 18
spawnBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
spawnBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
spawnBtn.BorderSizePixel  = 0
spawnBtn.Size             = UDim2.new(0.5, 0, 0, 40)
spawnBtn.Position         = UDim2.new(0.25, 0, 0, 0)
Instance.new("UICorner", spawnBtn).CornerRadius = UDim.new(0, 8)
spawnBtn.ZIndex           = 1

spawnBtn.MouseButton1Click:Connect(function()
    local pet = petPicker.Text
    local kg  = tonumber(weightBox.Text) or 1
    local age = tonumber(ageBox.Text)    or 1
    if pet ~= "" then
        Spawner.SpawnPet(pet, kg, age)
    end
end)

-- FADE-IN
TweenService:Create(window, TweenInfo.new(0.4), {Size = FULL_SIZE}):Play()

-- MINIMIZE TOGGLE (robust)
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        TweenService:Create(window,
          TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
          {Size = MINIMIZED_SZ}
        ):Play()
        -- hide everything except titleBar
        for _, child in ipairs(window:GetChildren()) do
            if child.Name ~= "TitleBar" then
                child.Visible = false
            end
        end
    else
        -- restore all
        for _, child in ipairs(window:GetChildren()) do
            child.Visible = true
        end
        TweenService:Create(window,
          TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
          {Size = FULL_SIZE}
        ):Play()
    end
end)
