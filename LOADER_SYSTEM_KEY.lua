--[[
    REYZN X | LOADER SYSTEM KEY
    Standalone local-key prototype, styled after Reyzn X Experimental.

    IMPORTANT: This is NOT secure server-side licensing. Anyone with the
    published source can read the demonstration key or bypass a local gate.

    First-time key: reyzn-x-0809-2026
    Save file: ReyznX_KeyAccess_v1.txt (where executor supports files)
    Target: Reyzn X original, hzReyzn/Ghislain
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
if not player then return end
local playerGui = player:WaitForChild("PlayerGui")

local KEY = "reyzn-x-0809-2026"
local SAVE_FILE = "ReyznX_KeyAccess_v1.txt"
local HUB_URL = "https://raw.githubusercontent.com/hzReyzn/Ghislain/main/Reyzn%20X.lua"
local env = (type(getgenv) == "function" and getgenv()) or _G

if type(env.ReyznXKeyLoaderStop) == "function" then
    pcall(env.ReyznXKeyLoaderStop)
end

local C = {
    obsidian = Color3.fromRGB(8, 8, 13),
    deep = Color3.fromRGB(13, 12, 20),
    panel = Color3.fromRGB(23, 20, 33),
    metallic = Color3.fromRGB(66, 60, 83),
    violet = Color3.fromRGB(159, 103, 243),
    amethyst = Color3.fromRGB(117, 58, 205),
    pink = Color3.fromRGB(239, 104, 217),
    cyan = Color3.fromRGB(135, 213, 255),
    silver = Color3.fromRGB(222, 222, 235),
    white = Color3.fromRGB(248, 246, 255),
    muted = Color3.fromRGB(171, 162, 190),
    green = Color3.fromRGB(136, 229, 187),
    red = Color3.fromRGB(255, 131, 158),
}
local FONT = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
local running, launching, authorized = true, false, false
local connections, activeTweens = {}, {}
local gui

local function instance(class, parent, properties)
    local object = Instance.new(class)
    for property, value in pairs(properties or {}) do object[property] = value end
    object.Parent = parent
    return object
end

local function connect(signal, callback)
    local link = signal:Connect(function(...)
        if running then callback(...) end
    end)
    connections[#connections + 1] = link
    return link
end

local function corner(object, radius)
    return instance("UICorner", object, {CornerRadius = UDim.new(0, radius)})
end

local function stroke(object, color, transparency, thickness)
    return instance("UIStroke", object, {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = color, Transparency = transparency, Thickness = thickness or 1
    })
end

local function gradient(object, colors, rotation)
    local stops = {}
    for i, color in ipairs(colors) do
        stops[i] = ColorSequenceKeypoint.new((i - 1) / (#colors - 1), color)
    end
    return instance("UIGradient", object, {
        Color = ColorSequence.new(stops), Rotation = rotation or 90
    })
end

local function frame(parent, name, color, pos, size, transparency)
    return instance("Frame", parent, {
        Name = name, BackgroundColor3 = color, BackgroundTransparency = transparency or 0,
        BorderSizePixel = 0, Position = pos, Size = size
    })
end

local function label(parent, name, content, pos, size, fontSize, color, alignment)
    local item = instance("TextLabel", parent, {
        Name = name, Text = content, Position = pos, Size = size,
        BackgroundTransparency = 1, Font = Enum.Font.GothamMedium,
        TextColor3 = color, TextSize = fontSize,
        TextXAlignment = alignment or Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd
    })
    item.FontFace = FONT
    return item
end

local function tween(object, duration, props)
    if not running then return end
    if activeTweens[object] then activeTweens[object]:Cancel() end
    local t = TweenService:Create(
        object, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props
    )
    activeTweens[object] = t
    t:Play()
    return t
end

local function savedAccess()
    if type(isfile) ~= "function" or type(readfile) ~= "function" then return false end
    local ok, raw = pcall(function()
        if isfile(SAVE_FILE) then return readfile(SAVE_FILE) end
    end)
    return ok and type(raw) == "string" and raw == KEY
end

local function saveAccess()
    if type(writefile) ~= "function" then return false end
    return pcall(writefile, SAVE_FILE, KEY)
end

local function shutdown()
    if not running then return end
    running = false
    for _, link in ipairs(connections) do link:Disconnect() end
    table.clear(connections)
    for _, active in pairs(activeTweens) do active:Cancel() end
    table.clear(activeTweens)
    if env.ReyznXKeyLoaderStop == shutdown then env.ReyznXKeyLoaderStop = nil end
    if gui then gui:Destroy() end
end
env.ReyznXKeyLoaderStop = shutdown

-- Standalone loader: no edits to either Reyzn X repository are needed.
gui = instance("ScreenGui", playerGui, {
    Name = "ReyznXKeyLoader", ResetOnSpawn = false, IgnoreGuiInset = true,
    DisplayOrder = 150, ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local root = frame(gui, "ReyznKeyWindow", C.deep,
    UDim2.fromScale(.5, .5), UDim2.fromOffset(730, 410), 1)
root.AnchorPoint = Vector2.new(.5, .5)
root.Active = true
local rootScale = instance("UIScale", root, {Scale = 1})

local aura = frame(root, "VioletAura", C.amethyst,
    UDim2.fromOffset(-8, -8), UDim2.new(1, 16, 1, 16), .91)
corner(aura, 22)
local auraStroke = stroke(aura, C.violet, .6, 2)
local auraGradient = gradient(auraStroke, {C.amethyst, C.cyan, C.silver, C.pink, C.amethyst}, 25)

local shell = frame(root, "MetallicWindow", C.deep,
    UDim2.fromOffset(0, 0), UDim2.fromScale(1, 1))
corner(shell, 16)
gradient(shell, {Color3.fromRGB(27, 25, 39), C.obsidian, C.panel}, 95)
local shellStroke = stroke(shell, C.silver, .28, 1.2)
local shellChrome = gradient(shellStroke, {C.metallic, C.cyan, C.silver, C.violet, C.obsidian}, 25)

local side = frame(shell, "AmethystDock", C.obsidian,
    UDim2.fromOffset(3, 3), UDim2.fromOffset(203, 404))
corner(side, 13)
gradient(side, {Color3.fromRGB(35, 26, 53), C.obsidian, Color3.fromRGB(22, 17, 34)}, 115)
local sideStroke = stroke(side, C.metallic, .34)
local sideChrome = gradient(sideStroke, {C.violet, C.silver, C.cyan, C.amethyst}, 25)

local crown = label(side, "Crown", "✦", UDim2.fromOffset(17, 14),
    UDim2.fromOffset(28, 32), 30, C.violet)
local brand = label(side, "Brand", "REYZN X", UDim2.fromOffset(47, 14),
    UDim2.new(1, -60, 0, 32), 27, C.white)
local sideLine = frame(side, "Divider", C.violet,
    UDim2.fromOffset(15, 56), UDim2.new(1, -30, 0, 2), .25)
gradient(sideLine, {C.obsidian, C.violet, C.cyan, C.obsidian}, 0)

local emblemBack = frame(side, "EmblemHalo", C.amethyst,
    UDim2.fromOffset(30, 91), UDim2.fromOffset(143, 143), .94)
corner(emblemBack, 23)
local emblemBorder = stroke(emblemBack, C.violet, .30, 2)
local emblemGradient = gradient(emblemBorder, {C.pink, C.violet, C.cyan, C.silver, C.pink}, 20)
local emblem = label(emblemBack, "Emblem", "X", UDim2.fromScale(0, 0),
    UDim2.fromScale(1, 1), 102, C.light, Enum.TextXAlignment.Center)
emblem.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)

local sideBottomLine = frame(side, "LowerDivider", C.violet,
    UDim2.fromOffset(17, 265), UDim2.new(1, -34, 0, 1), .26)
gradient(sideBottomLine, {C.obsidian, C.violet, C.cyan, C.obsidian}, 0)
local accessLabel = label(side, "AccessLabel", "SECURE ACCESS",
    UDim2.fromOffset(17, 278), UDim2.new(1, -34, 0, 29), 20, C.white)
local versionLabel = label(side, "VersionLabel", "KEY SYSTEM  /  V1",
    UDim2.fromOffset(17, 308), UDim2.new(1, -34, 0, 23), 14, C.muted)
local credit = label(side, "Credit", "Made By Reyzn",
    UDim2.fromOffset(17, 375), UDim2.new(1, -34, 0, 24), 14, C.light)

local panel = frame(shell, "AccessPanel", C.panel,
    UDim2.fromOffset(216, 3), UDim2.fromOffset(511, 404))
corner(panel, 14)
gradient(panel, {C.panel, C.deep, C.obsidian}, 95)
local panelStroke = stroke(panel, C.metallic, .42, 1)
local panelChrome = gradient(panelStroke, {C.metallic, C.violet, C.silver, C.cyan}, 22)
local beam = frame(panel, "ChromeReflection", C.silver,
    UDim2.fromOffset(18, 3), UDim2.new(1, -36, 0, 2), .32)
corner(beam, 2)
local beamGradient = gradient(beam, {C.amethyst, C.violet, C.cyan, C.silver, C.amethyst}, 0)

local eyebrow = label(panel, "Eyebrow", "REYZN X  /  AUTHENTICATION",
    UDim2.fromOffset(30, 24), UDim2.new(1, -110, 0, 22), 15, C.cyan)
local title = label(panel, "Title", "ACCESS CONTROL",
    UDim2.fromOffset(30, 53), UDim2.new(1, -60, 0, 48), 34, C.white)
local subtitle = label(panel, "Subtitle", "Verify your key to launch Reyzn X.",
    UDim2.fromOffset(30, 105), UDim2.new(1, -60, 0, 30), 17, C.muted)

local inputFace = frame(panel, "KeyInputSurface", C.obsidian,
    UDim2.fromOffset(30, 158), UDim2.new(1, -60, 0, 59), .05)
corner(inputFace, 11)
local inputStroke = stroke(inputFace, C.metallic, .25, 1.1)
local inputChrome = gradient(inputStroke, {C.amethyst, C.violet, C.silver, C.cyan}, 20)
local keyIcon = label(inputFace, "KeyIcon", "✦", UDim2.fromOffset(14, 10),
    UDim2.fromOffset(28, 38), 27, C.light)
local input = instance("TextBox", inputFace, {
    Name = "EnterAccessKey", Position = UDim2.fromOffset(53, 7),
    Size = UDim2.new(1, -65, 1, -14), BackgroundTransparency = 1,
    Text = "", PlaceholderText = "ENTER YOUR ACCESS KEY",
    PlaceholderColor3 = Color3.fromRGB(126, 112, 144),
    TextColor3 = C.white, TextSize = 20, Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    ClearTextOnFocus = false, MultiLine = false,
    TextTruncate = Enum.TextTruncate.AtEnd,
})
input.FontFace = FONT

local button = instance("TextButton", panel, {
    Name = "VerifyAndLaunch", Text = "", AutoButtonColor = false,
    Position = UDim2.fromOffset(30, 232), Size = UDim2.new(1, -60, 0, 57),
    BackgroundColor3 = C.amethyst, BorderSizePixel = 0,
    Active = true, Selectable = true,
})
corner(button, 11)
gradient(button, {Color3.fromRGB(64, 37, 109), Color3.fromRGB(115, 64, 187), Color3.fromRGB(69, 43, 124)}, 16)
local buttonStroke = stroke(button, C.light, .22, 1.2)
local buttonChrome = gradient(buttonStroke, {C.violet, C.cyan, C.silver, C.pink, C.violet}, 24)
local buttonScale = instance("UIScale", button, {Scale = 1})
local buttonText = label(button, "Caption", "VERIFY & LAUNCH",
    UDim2.fromOffset(10, 0), UDim2.new(1, -20, 1, 0),
    22, C.white, Enum.TextXAlignment.Center)
buttonText.Active = false

local status = label(panel, "Status", "Enter your access key to continue.",
    UDim2.fromOffset(30, 295), UDim2.new(1, -60, 0, 43), 16, C.muted)
status.TextWrapped = true
status.TextTruncate = Enum.TextTruncate.None
local footerLine = frame(panel, "FooterDivider", C.metallic,
    UDim2.fromOffset(30, 351), UDim2.new(1, -60, 0, 1), .30)
gradient(footerLine, {C.obsidian, C.violet, C.silver, C.obsidian}, 0)
local footer = label(panel, "Footer", "✦  REMEMBER THIS DEVICE",
    UDim2.fromOffset(30, 363), UDim2.new(1, -60, 0, 23), 14, C.light)

local minimize = instance("TextButton", panel, {
    Name = "Minimize", BackgroundTransparency = 1,
    Position = UDim2.new(1, -75, 0, 16), Size = UDim2.fromOffset(27, 26),
    Text = "−", Font = Enum.Font.GothamBold, TextSize = 26, TextColor3 = C.silver,
})
local close = instance("TextButton", panel, {
    Name = "Close", BackgroundTransparency = 1,
    Position = UDim2.new(1, -44, 0, 16), Size = UDim2.fromOffset(27, 26),
    Text = "×", Font = Enum.Font.GothamBold, TextSize = 24, TextColor3 = C.silver,
})
local launcher = instance("TextButton", gui, {
    Name = "KeyLauncher", Visible = false, BackgroundColor3 = C.obsidian,
    BorderSizePixel = 0, Text = "R", Font = Enum.Font.GothamBold,
    TextSize = 32, TextColor3 = C.light, AutoButtonColor = false,
    Position = UDim2.new(0, 18, .5, -30), Size = UDim2.fromOffset(62, 62),
})
corner(launcher, 16)
local launcherStroke = stroke(launcher, C.light, .25, 1.4)
local launcherGradient = gradient(launcherStroke, {C.amethyst, C.cyan, C.silver, C.pink}, 22)

local sparks = {}
for i = 1, 12 do
    local angle = i * 2.39996
    local dot = frame(emblemBack, "GlowParticle" .. i,
        i % 3 == 0 and C.pink or C.cyan,
        UDim2.fromScale(.5 + .39 * math.cos(angle), .5 + .39 * math.sin(angle)),
        UDim2.fromOffset(i % 3 == 0 and 4 or 2, i % 3 == 0 and 4 or 2), .20)
    dot.AnchorPoint = Vector2.new(.5, .5)
    corner(dot, 5)
    sparks[#sparks + 1] = {frame = dot, angle = angle, phase = i * .55}
end

-- Optional use of the original artwork. The UI works with fallback vector/text
-- elements when custom asset and file functions are not supported.
local function tryArtwork(image, url, filename, format)
    local customAsset = getcustomasset or getsynasset
    if type(customAsset) ~= "function" or type(writefile) ~= "function" then return end
    task.spawn(function()
        local function valid(bytes)
            if type(bytes) ~= "string" then return false end
            if format == "png" then return bytes:sub(1, 8) == "\137PNG\13\10\26\10" end
            return bytes:sub(1, 3) == "\255\216\255"
        end
        local bytes
        if type(isfile) == "function" and type(readfile) == "function" then
            local ok, result = pcall(function()
                if isfile(filename) then return readfile(filename) end
            end)
            if ok and valid(result) then bytes = result end
        end
        if not bytes then
            local ok, result = pcall(function() return game:HttpGet(url) end)
            if not ok or not valid(result) then return end
            if not pcall(writefile, filename, result) then return end
        end
        local ok, uri = pcall(customAsset, filename)
        if running and ok and type(uri) == "string" and uri ~= "" then
            image.Image = uri
            if image.Name == "EmblemArtwork" then emblem.Visible = false end
        end
    end)
end

local artwork = instance("ImageLabel", emblemBack, {
    Name = "EmblemArtwork", Image = "", BackgroundTransparency = 1,
    Position = UDim2.fromScale(0, 0), Size = UDim2.fromScale(1, 1),
    ScaleType = Enum.ScaleType.Fit,
})
artwork.ZIndex = 4
tryArtwork(artwork,
    "https://raw.githubusercontent.com/hzReyzn/Ghislain/main/assets/reyzn-x/emblem-x-v1.png",
    "ReyznX-Key-Emblem.png", "png")

local function notice(message, kind)
    if not running then return end
    status.Text = message
    status.TextColor3 = kind == "success" and C.green
        or kind == "error" and C.red
        or kind == "loading" and C.cyan or C.muted
end

local function layout()
    if not running then return end
    local camera = workspace.CurrentCamera
    if not camera then return end
    local view = camera.ViewportSize
    if view.X < 1 or view.Y < 1 then return end
    local mobile = view.X < 710
    local width, height = mobile and 370 or 730, mobile and 496 or 410
    root.Size = UDim2.fromOffset(width, height)
    rootScale.Scale = math.min(1, math.max(.52, math.min((view.X - 16) / width, (view.Y - 16) / height)))
    if mobile then
        side.Position = UDim2.fromOffset(3, 3)
        side.Size = UDim2.fromOffset(width - 6, 107)
        panel.Position = UDim2.fromOffset(3, 119)
        panel.Size = UDim2.fromOffset(width - 6, height - 122)
        emblemBack.Position = UDim2.fromOffset(width - 85, 54)
        emblemBack.Size = UDim2.fromOffset(50, 50)
        emblem.TextSize = 36
        brand.Position = UDim2.fromOffset(49, 11)
        brand.Size = UDim2.fromOffset(width - 75, 33)
        crown.Position = UDim2.fromOffset(19, 11)
        sideLine.Position = UDim2.fromOffset(15, 52)
        sideLine.Size = UDim2.new(1, -30, 0, 1)
        accessLabel.Position = UDim2.fromOffset(19, 60)
        accessLabel.Size = UDim2.new(1, -115, 0, 23)
        accessLabel.TextSize = 18
        versionLabel.Position = UDim2.fromOffset(19, 82)
        versionLabel.Size = UDim2.new(1, -115, 0, 19)
        versionLabel.TextSize = 12
        sideBottomLine.Visible = false
        credit.Visible = false
        eyebrow.Position = UDim2.fromOffset(19, 12)
        eyebrow.Size = UDim2.new(1, -90, 0, 20)
        eyebrow.TextSize = 12
        title.Position = UDim2.fromOffset(19, 40)
        title.Size = UDim2.new(1, -38, 0, 46)
        title.TextSize = 28
        subtitle.Position = UDim2.fromOffset(19, 86)
        subtitle.Size = UDim2.new(1, -38, 0, 26)
        subtitle.TextSize = 15
        inputFace.Position = UDim2.fromOffset(19, 124)
        inputFace.Size = UDim2.new(1, -38, 0, 56)
        button.Position = UDim2.fromOffset(19, 191)
        button.Size = UDim2.new(1, -38, 0, 57)
        buttonText.TextSize = 20
        status.Position = UDim2.fromOffset(19, 258)
        status.Size = UDim2.new(1, -38, 0, 48)
        footerLine.Position = UDim2.fromOffset(19, 324)
        footerLine.Size = UDim2.new(1, -38, 0, 1)
        footer.Position = UDim2.fromOffset(19, 337)
        footer.Size = UDim2.new(1, -38, 0, 22)
        minimize.Position = UDim2.new(1, -71, 0, 8)
        close.Position = UDim2.new(1, -41, 0, 8)
    else
        side.Position = UDim2.fromOffset(3, 3)
        side.Size = UDim2.fromOffset(203, 404)
        panel.Position = UDim2.fromOffset(216, 3)
        panel.Size = UDim2.fromOffset(511, 404)
        emblemBack.Position = UDim2.fromOffset(30, 91)
        emblemBack.Size = UDim2.fromOffset(143, 143)
        emblem.TextSize = 102
        brand.Position = UDim2.fromOffset(47, 14)
        brand.Size = UDim2.new(1, -60, 0, 32)
        crown.Position = UDim2.fromOffset(17, 14)
        sideLine.Position = UDim2.fromOffset(15, 56)
        sideLine.Size = UDim2.new(1, -30, 0, 2)
        accessLabel.Position = UDim2.fromOffset(17, 278)
        accessLabel.Size = UDim2.new(1, -34, 0, 29)
        accessLabel.TextSize = 20
        versionLabel.Position = UDim2.fromOffset(17, 308)
        versionLabel.Size = UDim2.new(1, -34, 0, 23)
        versionLabel.TextSize = 14
        sideBottomLine.Visible = true
        credit.Visible = true
        eyebrow.Position = UDim2.fromOffset(30, 24)
        eyebrow.Size = UDim2.new(1, -110, 0, 22)
        eyebrow.TextSize = 15
        title.Position = UDim2.fromOffset(30, 53)
        title.Size = UDim2.new(1, -60, 0, 48)
        title.TextSize = 34
        subtitle.Position = UDim2.fromOffset(30, 105)
        subtitle.Size = UDim2.new(1, -60, 0, 30)
        subtitle.TextSize = 17
        inputFace.Position = UDim2.fromOffset(30, 158)
        inputFace.Size = UDim2.new(1, -60, 0, 59)
        button.Position = UDim2.fromOffset(30, 232)
        button.Size = UDim2.new(1, -60, 0, 57)
        buttonText.TextSize = 22
        status.Position = UDim2.fromOffset(30, 295)
        status.Size = UDim2.new(1, -60, 0, 43)
        footerLine.Position = UDim2.fromOffset(30, 351)
        footerLine.Size = UDim2.new(1, -60, 0, 1)
        footer.Position = UDim2.fromOffset(30, 363)
        footer.Size = UDim2.new(1, -60, 0, 23)
        minimize.Position = UDim2.new(1, -75, 0, 16)
        close.Position = UDim2.new(1, -44, 0, 16)
    end
end

-- Drag by the header/sidebar, without hijacking the key text field.
local dragPointer, dragStart, initialPosition, moved
local function startDrag(event)
    if event.UserInputType ~= Enum.UserInputType.Touch
        and event.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    dragPointer, dragStart, initialPosition, moved = event, event.Position, root.Position, false
end
connect(side.InputBegan, startDrag)
connect(eyebrow.InputBegan, startDrag)
connect(UserInputService.InputChanged, function(event)
    if not dragPointer then return end
    local typeOfPointer = dragPointer.UserInputType
    if typeOfPointer == Enum.UserInputType.Touch and event ~= dragPointer then return end
    if typeOfPointer == Enum.UserInputType.MouseButton1
        and event.UserInputType ~= Enum.UserInputType.MouseMovement then return end
    local delta = event.Position - dragStart
    if not moved and delta.Magnitude < 5 then return end
    moved = true
    root.Position = UDim2.new(initialPosition.X.Scale, initialPosition.X.Offset + delta.X,
        initialPosition.Y.Scale, initialPosition.Y.Offset + delta.Y)
end)
connect(UserInputService.InputEnded, function(event)
    if dragPointer and (dragPointer == event or
        (dragPointer.UserInputType == Enum.UserInputType.MouseButton1
        and event.UserInputType == Enum.UserInputType.MouseButton1)) then
        dragPointer = nil
    end
end)

connect(close.Activated, shutdown)
connect(minimize.Activated, function()
    root.Visible = false
    launcher.Visible = true
end)
connect(launcher.Activated, function()
    launcher.Visible = false
    root.Visible = true
end)
connect(button.MouseEnter, function()
    if not launching then
        tween(buttonScale, .17, {Scale = 1.012})
        tween(buttonStroke, .17, {Transparency = .06})
    end
end)
connect(button.MouseLeave, function()
    if not launching then
        tween(buttonScale, .17, {Scale = 1})
        tween(buttonStroke, .17, {Transparency = .22})
    end
end)
connect(button.InputBegan, function(event)
    if event.UserInputType == Enum.UserInputType.Touch
        or event.UserInputType == Enum.UserInputType.MouseButton1 then
        tween(buttonScale, .08, {Scale = .973})
    end
end)
connect(button.InputEnded, function()
    if not launching then tween(buttonScale, .16, {Scale = 1}) end
end)
connect(input.Focused, function()
    tween(inputStroke, .2, {Transparency = .03})
end)
connect(input.FocusLost, function()
    tween(inputStroke, .2, {Transparency = .25})
end)

local function setBusy(busy)
    launching = busy
    button.Active = not busy
    button.Selectable = not busy
    input.TextEditable = not busy
    buttonText.Text = busy and "LAUNCHING REYZN X..."
        or authorized and "LAUNCH REYZN X" or "VERIFY & LAUNCH"
    tween(buttonScale, .15, {Scale = busy and .985 or 1})
end

local function runOriginalHub()
    if launching or not running then return end
    setBusy(true)
    notice("Checking access and loading Reyzn X...", "loading")
    task.spawn(function()
        local success, err = pcall(function()
            if type(loadstring) ~= "function" then
                error("This environment does not provide loadstring.", 0)
            end
            local body = game:HttpGet(HUB_URL)
            if type(body) ~= "string" or body:match("^%s*$") then
                error("The source returned no script.", 0)
            end
            local executable, compileError = loadstring(body)
            if type(executable) ~= "function" then
                error(compileError or "Failed to compile Reyzn X.", 0)
            end
            executable()
        end)
        if not running then return end
        setBusy(false)
        if success then
            env.ReyznXKeySessionAuthorized = true
            notice("ACCESS GRANTED  •  REYZN X LOADED", "success")
            buttonText.Text = "ACCESS GRANTED"
            task.delay(.7, function()
                if running then shutdown() end
            end)
        else
            gui.Enabled = true
            root.Visible = true
            launcher.Visible = false
            notice("Couldn't launch Reyzn X. Tap LAUNCH to retry.", "error")
            warn("Reyzn X Key Loader: " .. tostring(err))
        end
    end)
end

local function verify()
    if not running or launching then return end
    if authorized then
        runOriginalHub()
        return
    end
    local entered = input.Text:match("^%s*(.-)%s*$")
    if entered == "" then
        notice("Enter your access key first.", "error")
        return
    end
    if entered ~= KEY then
        input.Text = ""
        notice("INVALID KEY  •  TRY AGAIN", "error")
        tween(inputStroke, .13, {Color = C.red, Transparency = 0})
        task.delay(.8, function()
            if running then tween(inputStroke, .2, {Color = C.metallic, Transparency = .25}) end
        end)
        return
    end
    authorized = true
    input.Text = ""
    local stored = saveAccess()
    if not stored then
        warn("Reyzn X: This executor cannot persist the key. It may be requested on the next session.")
    end
    notice(stored and "Key verified and saved on this device."
        or "Key verified for this session.", "success")
    runOriginalHub()
end

connect(button.Activated, verify)
connect(input.FocusLost, function(enterPressed)
    if enterPressed then verify() end
end)
connect(gui.Destroying, shutdown)

local startedAt = os.clock()
connect(RunService.RenderStepped, function()
    if not gui.Enabled or not root.Visible then return end
    local t = os.clock() - startedAt
    auraGradient.Offset = Vector2.new(math.sin(t * .42) * .35, 0)
    shellChrome.Offset = Vector2.new(math.sin(t * .40 + .5) * .25, 0)
    sideChrome.Offset = Vector2.new(math.sin(t * .47) * .34, 0)
    panelChrome.Offset = Vector2.new(math.sin(t * .36 + 1.2) * .29, 0)
    beamGradient.Offset = Vector2.new(math.sin(t * .55) * .37, 0)
    buttonChrome.Offset = Vector2.new(math.sin(t * .75) * .35, 0)
    inputChrome.Offset = Vector2.new(math.sin(t * .38) * .22, 0)
    emblemGradient.Offset = Vector2.new(math.sin(t * .51) * .22, 0)
    aura.BackgroundTransparency = .93 - .025 * math.sin(t * .58)^2
    for _, spark in ipairs(sparks) do
        local angle = spark.angle + t * .18
        spark.frame.Position = UDim2.fromScale(.5 + .39 * math.cos(angle), .5 + .39 * math.sin(angle))
        spark.frame.BackgroundTransparency = .58 - .25 * math.sin(t * .9 + spark.phase)^2
    end
end)

if workspace.CurrentCamera then
    connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), layout)
end
connect(workspace:GetPropertyChangedSignal("CurrentCamera"), function()
    layout()
end)
layout()

authorized = savedAccess() or env.ReyznXKeySessionAuthorized == true
if authorized then
    gui.Enabled = false
    task.defer(function()
        if running then runOriginalHub() end
    end)
else
    notice("Enter your key to unlock Reyzn X.", "normal")
end
