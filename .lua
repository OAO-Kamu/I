--[[
|                       |               |     
|      __ \   _` |  __| __|  _ \    __| __ \  
|      |   | (   |\__ \ |    __/  \__ \ | | | 
|      .__/ \__,_|____/\__|\___|_)____/_| |_| 
|     _|                                      
               Made By: NOEKemono-Kamu
]]
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local CONFIG = {
    PARTICLE_COUNT = 20,
    PARTICLE_SPEED = 1.5
}

local TARGET_USERNAMES = {
    ["PookiePepelssz"] = true,
    ["Tweezlee"] = true
}

local function createParticles(tag, parent, accentColor)
    for i = 1, CONFIG.PARTICLE_COUNT do
        local particle = Instance.new("Frame")
        particle.Name = "Particle_" .. i
        particle.Size = UDim2.new(0, math.random(1, 6), 0, math.random(1, 6))
        particle.Position = UDim2.new(math.random(), math.random(-10, 10), 1 + math.random() * 0.5, 0)
        particle.BackgroundColor3 = accentColor
        particle.BackgroundTransparency = math.random(0, 0.4)
        particle.BorderSizePixel = 0

        local pCorner = Instance.new("UICorner")
        pCorner.CornerRadius = UDim.new(1, 10)
        pCorner.Parent = particle

        particle.Parent = parent

        task.spawn(function()
            while tag and tag.Parent do
                local startX = math.random()
                local startOffsetX = math.random(-10, 10)
                particle.Position = UDim2.new(startX, startOffsetX, 1 + math.random() * 0.5, 0)
                particle.Size = UDim2.new(0, math.random(1, 6), 0, math.random(1, 6))
                particle.BackgroundTransparency = math.random(0, 0.4)

                local duration = math.random(10, 40) / (CONFIG.PARTICLE_SPEED * 10)
                local endX = startX + (math.random() - 0.5) * 0.3
                local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)

                local tween = TweenService:Create(particle, tweenInfo, {
                    Position = UDim2.new(endX, startOffsetX, -0.5, math.random(-20, 20)),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 0)
                })
                tween:Play()
                task.wait(math.random(20, 40) / (CONFIG.PARTICLE_SPEED * 10))
            end
        end)
    end
end

local function createBillboardGui(character)
    local head = character:FindFirstChild("Head")
    if not head or head:FindFirstChild("SentinelBillboard") then return end

    local billboardGui = Instance.new("BillboardGui", head)
    billboardGui.Name = "SentinelBillboard"
    billboardGui.Active = true
    billboardGui.MaxDistance = 50
    billboardGui.ExtentsOffsetWorldSpace = Vector3.new(0, 4, 0)
    billboardGui.Size = UDim2.new(0, 180, 0, 50)
    billboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local frame = Instance.new("Frame", billboardGui)
    frame.BorderSizePixel = 0
    frame.BackgroundColor3 = Color3.fromRGB(69, 69, 69)
    frame.Size = UDim2.new(0, 170, 0, 42)
    frame.Position = UDim2.new(0, 5, 0, 5)

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

    local stroke = Instance.new("UIStroke", frame)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = 1.2
    stroke.Color = Color3.fromRGB(255, 171, 0)

    local nameLabel = Instance.new("TextLabel", frame)
    nameLabel.Text = "Sentinel Owner"
    nameLabel.TextWrapped = true
    nameLabel.BorderSizePixel = 0
    nameLabel.TextSize = 16
    nameLabel.BackgroundTransparency = 1
    nameLabel.FontFace = Font.new([[rbxassetid://12187365977]], Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.Size = UDim2.new(0, 170, 0, 42)
    nameLabel.Position = UDim2.new(0, 10, 0, -1.3)

    local crownLabel = Instance.new("TextLabel", frame)
    crownLabel.Text = "冻梨中心VIP用户"
    crownLabel.BorderSizePixel = 0
    crownLabel.TextSize = 20
    crownLabel.BackgroundTransparency = 1
    crownLabel.FontFace = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    crownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    crownLabel.Size = UDim2.new(0, 45, 0, 40)
    crownLabel.Position = UDim2.new(0, 2, 0, 0)

    local shadowHolder = Instance.new("Frame", frame)
    shadowHolder.ZIndex = 0
    shadowHolder.Size = UDim2.new(1, 0, 1, 0)
    shadowHolder.Position = UDim2.new(0, 0, -0.05, 0)
    shadowHolder.Name = "shadowHolder"
    shadowHolder.BackgroundTransparency = 1

    local function addShadow(name, transparency)
        local shadow = Instance.new("ImageLabel", shadowHolder)
        shadow.Name = name
        shadow.ZIndex = 0
        shadow.SliceCenter = Rect.new(10, 10, 118, 118)
        shadow.ScaleType = Enum.ScaleType.Slice
        shadow.ImageTransparency = transparency
        shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        shadow.AnchorPoint = Vector2.new(0.5, 0.5)
        shadow.Image = "rbxassetid://1316045217"
        shadow.Size = UDim2.new(1, 3, 1, 3)
        shadow.BackgroundTransparency = 1
        shadow.Position = UDim2.new(0.5, 0, 0.5, 2)
    end

    addShadow("umbraShadow", 0.86)
    addShadow("penumbraShadow", 0.88)
    addShadow("ambientShadow", 0.88)

    createParticles(frame, frame, Color3.fromRGB(255, 171, 0))
end

local function monitorPlayer(player)
    if TARGET_USERNAMES[player.Name] then
        player.CharacterAdded:Connect(createBillboardGui)
        if player.Character then
            createBillboardGui(player.Character)
        end
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    monitorPlayer(player)
end

Players.PlayerAdded:Connect(monitorPlayer)

task.spawn(function()
    while true do
        for name in pairs(TARGET_USERNAMES) do
            local player = Players:FindFirstChild(name)
            if player and player.Character then
                createBillboardGui(player.Character)
            end
        end
        task.wait(1)
    end
end)
local NotificationLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/DemogorgonItsMe/DemoNotifications/refs/heads/main/V2/source.lua"))()
NotificationLib:SetSettings({
    position = "BottomRight", -- "BottomRight" or "BottomCenter"
    maxNotifications = 5,     -- Max notifications shown simultaneously
    duration = 4,            -- Default duration (seconds)
    spacing = 10,            -- Space between notifications (px)
    fadeTime = 0.3,          -- Animation duration (seconds)
    slideDistance = 20       -- Slide animation distance (px)
})
NotificationLib:SetTheme({
    -- Colors
    primaryColor = Color3.fromRGB(45, 45, 45),
    successColor = Color3.fromRGB(50, 180, 100),
    errorColor = Color3.fromRGB(220, 80, 80),
    warningColor = Color3.fromRGB(240, 180, 50),
    textColor = Color3.fromRGB(255, 102, 255),
    showStroke = false,
    useBackgroundColor = false,
    backgroundTransparency = 0.1,
    
    -- Appearance
    cornerRadius = UDim.new(0, 5),
    font = Enum.Font.GothamSemibold, -- text font
    background = "rbxassetid://18610728562", -- Background Image
    closeIcon = "rbxassetid://6031094677",
    mobileScale = 0.8
})
getgenv().Games = {
    [9872472334] = "https://raw.github.com/OAO-Kamu/Frozen-sheep/refs/heads/main/CEvade.luau",--EVADE PC-Mobile
    [18687417158] = "https://raw.github.com/OAO-Kamu/Main/refs/heads/main/Forsaken.Main.Main.raw",--Forsaken Mobile+PC
    [16991287194] = "https://raw.github.com/OAO-Kamu/I/refs/heads/main/S.E.W.H..Luau",--Something Evil Will Happen 
    [13772394625] = "https://raw.github.com/OAO-Kamu/Frozen-sheep/refs/heads/main/Blade.Balls.luau",--Blade Ball Mobile+PC
}

local id = game.PlaceId
local url = getgenv().Games[id]
if url then
    NotificationLib:Notify({
    Title = "成功找到支持的服务器!",
    Message = "CHANGED HUB |  冻梨中心 V2",
    Type ="success", 
    Duration = 10
})

    loadstring(game:HttpGet(url))()
end
local ulr = "https://raw.github.com/OAO-Kamu/I/refs/heads/main/Frozen-pear-HUB.Luau"
if not url then
    NotificationLib:Notify({
    Title = "没有找到支持的服务器已自动加载通用脚本!",
    Message = "CHANGED HUB | 冻梨中心 V2",
    Type = "error", 
    Duration = 10
})

loadstring(game:HttpGet(ulr))()
end