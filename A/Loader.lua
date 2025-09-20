--[[
nice skid❤️
很好的 skid❤️
]]
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EnhancedProfileCard"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0.86, 0, 0.9, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = mainFrame

local backgroundImage = Instance.new("ImageLabel")
backgroundImage.Name = "Background"
backgroundImage.Size = UDim2.new(1, 0, 1, 0)
backgroundImage.Image = "rbxassetid://7071423635"
backgroundImage.ImageTransparency = 0.6
backgroundImage.ScaleType = Enum.ScaleType.Crop
backgroundImage.BackgroundTransparency = 1
backgroundImage.Parent = mainFrame

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
header.BackgroundTransparency = 0.2
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

local headerDecoration = Instance.new("Frame")
headerDecoration.Name = "HeaderDecoration"
headerDecoration.Size = UDim2.new(1, 0, 0, 4)
headerDecoration.Position = UDim2.new(0, 0, 1, -4)
headerDecoration.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
headerDecoration.BorderSizePixel = 0
headerDecoration.Parent = header

local headerCorner2 = Instance.new("UICorner")
headerCorner2.CornerRadius = UDim.new(0, 4)
headerCorner2.Parent = headerDecoration

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "CHANGED HUB | 公告"
title.TextColor3 = Color3.fromRGB(255, 240, 245)
title.Font = Enum.Font.GothamBlack
title.TextSize = 22
title.Parent = header

local titleStroke = Instance.new("UIStroke")
titleStroke.Color = Color3.fromRGB(255, 182, 193)
titleStroke.Thickness = 2
titleStroke.Parent = title

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, 0, 1, -50)
content.Position = UDim2.new(0, 0, 0, 50)
content.BackgroundTransparency = 1
content.Parent = mainFrame

local leftPanel = Instance.new("Frame")
leftPanel.Name = "LeftPanel"
leftPanel.Size = UDim2.new(0.4, 0, 1, 0)
leftPanel.BackgroundTransparency = 1
leftPanel.Parent = content

local avatarContainer = Instance.new("Frame")
avatarContainer.Name = "AvatarContainer"
avatarContainer.Size = UDim2.new(1, -40, 0, 173)
avatarContainer.Position = UDim2.new(0, 20, 0, 20)
avatarContainer.BackgroundTransparency = 1
avatarContainer.Parent = leftPanel

local avatarImage = Instance.new("ImageLabel")
avatarImage.Name = "Avatar"
avatarImage.Size = UDim2.new(1, 0, 1, 0)
avatarImage.BackgroundTransparency = 1
avatarImage.Parent = avatarContainer

local userId = player.UserId
local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=".. userId .."&width=420&height=420&format=png"
avatarImage.Image = avatarUrl

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(0, 16)
avatarCorner.Parent = avatarImage

local avatarStroke = Instance.new("UIStroke")
avatarStroke.Color = Color3.fromRGB(255, 182, 193)
avatarStroke.Thickness = 4
avatarStroke.Parent = avatarImage

local avatarGlow = Instance.new("ImageLabel")
avatarGlow.Name = "AvatarGlow"
avatarGlow.Size = UDim2.new(1, 20, 1, 20)
avatarGlow.Position = UDim2.new(0, -10, 0, -10)
avatarGlow.BackgroundTransparency = 1
avatarGlow.Image = "rbxassetid://4996896980"
avatarGlow.ImageColor3 = Color3.fromRGB(255, 182, 193)
avatarGlow.ImageTransparency = 0.7
avatarGlow.ScaleType = Enum.ScaleType.Slice
avatarGlow.SliceCenter = Rect.new(19, 19, 81, 81)
avatarGlow.Parent = avatarImage

local imageName = Instance.new("TextLabel")
imageName.Name = "ImageName"
imageName.Size = UDim2.new(1, -40, 0, 30)
imageName.Position = UDim2.new(0, 20, 0, 270)
imageName.BackgroundTransparency = 1
imageName.Text = "Main"
imageName.TextColor3 = Color3.fromRGB(255, 240, 245)
imageName.Font = Enum.Font.GothamBold
imageName.TextSize = 18
imageName.TextXAlignment = Enum.TextXAlignment.Center
imageName.Parent = leftPanel

local imageNameStroke = Instance.new("UIStroke")
imageNameStroke.Color = Color3.fromRGB(255, 182, 193)
imageNameStroke.Thickness = 1
imageNameStroke.Parent = imageName

local username = Instance.new("TextLabel")
username.Name = "Username"
username.Size = UDim2.new(1, -40, 0, 30)
username.Position = UDim2.new(0, 20, 0, 300)
username.BackgroundTransparency = 1
username.Text = ""
username.TextColor3 = Color3.fromRGB(255, 240, 245) 
username.Font = Enum.Font.GothamMedium
username.TextSize = 16
username.TextXAlignment = Enum.TextXAlignment.Center
username.Parent = leftPanel

local usernameStroke = Instance.new("UIStroke")
usernameStroke.Color = Color3.fromRGB(255, 182, 193) 
usernameStroke.Thickness = 1
usernameStroke.Parent = username

local rightPanel = Instance.new("Frame")
rightPanel.Name = "RightPanel"
rightPanel.Size = UDim2.new(0.6, 0, 1, 0)
rightPanel.Position = UDim2.new(0.4, 0, 0, 0)
rightPanel.BackgroundTransparency = 1
rightPanel.Parent = content

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(1, -40, 0.7, -10)
scrollFrame.Position = UDim2.new(0, 20, 0, 20)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 182, 193)
scrollFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
scrollFrame.Parent = rightPanel

local infoText = Instance.new("TextLabel")
infoText.Name = "InfoText"
infoText.Size = UDim2.new(1, 0, 1, 0)
infoText.BackgroundTransparency = 1
infoText.Text = [[
====脚本信息====
-半开源脚本
-不圈钱
-不跑路
-更新快
-UI/视觉 优美

====脚本作者(3)====
-yzc | 专业: 改枪 绘制 子弹追踪等....
-Q3E4 | 专业: 创建UI(刚学不久) 传送 自动 绘制
-mjay | 专业: 修复脚本 混淆脚本 汉化脚本
#-暂无联系方式-#

====支持游戏====
-被遗弃 | 混淆 | 🔴
-暴力区 | 开源 | 🟢
-Piggy(小猪) | 混淆 | 🟢
-兵工厂 | 汉化开源 | 🟢
-WW1 | 汉化开源 | 🟢
-兄弟的誓言 | 汉化开源 | 🟢
-摔断骨头 | 汉化开源 | 🟢
-奇怪枪游戏 | 汉化开源 | 🟢
-CW(战斗勇士) | 汉化不开源 | 🟢



-mjay到此一游😝~
]]
infoText.TextColor3 = Color3.fromRGB(255, 240, 245) 
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 16
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.TextWrapped = true
infoText.Parent = scrollFrame

local infoTextStroke = Instance.new("UIStroke")
infoTextStroke.Color = Color3.fromRGB(255, 182, 193) 
infoTextStroke.Thickness = 1
infoTextStroke.Parent = infoText

infoText:GetPropertyChangedSignal("TextBounds"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, infoText.TextBounds.Y + 20)
end)

local buttonContainer = Instance.new("Frame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.Size = UDim2.new(0.8, 0, 0, 50)
buttonContainer.Position = UDim2.new(0.1, 0, 0.75, 0) 
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = rightPanel 

local actionButton = Instance.new("TextButton")
actionButton.Name = "ActionButton"
actionButton.Size = UDim2.new(1, 0, 1, 0)
actionButton.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
actionButton.Text = "我已阅读"
actionButton.TextColor3 = Color3.fromRGB(255, 240, 245) 
actionButton.Font = Enum.Font.GothamBold 
actionButton.TextSize = 18 
actionButton.Parent = buttonContainer 

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 12)
buttonCorner.Parent = actionButton

local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(255, 182, 193)
buttonStroke.Thickness = 2 
buttonStroke.Parent = actionButton

local buttonGlow = Instance.new("ImageLabel")
buttonGlow.Name = "ButtonGlow"
buttonGlow.Size = UDim2.new(1, 15, 1, 15) 
buttonGlow.Position = UDim2.new(0, -7.5, 0, -7.5)
buttonGlow.BackgroundTransparency = 1
buttonGlow.Image = "rbxassetid://4996896980"
buttonGlow.ImageColor3 = Color3.fromRGB(255, 182, 193)
buttonGlow.ImageTransparency = 0.8
buttonGlow.ScaleType = Enum.ScaleType.Slice
buttonGlow.SliceCenter = Rect.new(19, 19, 81, 81)
buttonGlow.ZIndex = -1
buttonGlow.Parent = actionButton

actionButton.MouseEnter:Connect(function()
    TweenService:Create(
        actionButton,
        TweenInfo.new(0.2),
        {BackgroundColor3 = Color3.fromRGB(255, 200, 210)}
    ):Play()
    TweenService:Create(
        buttonGlow,
        TweenInfo.new(0.2),
        {ImageColor3 = Color3.fromRGB(255, 200, 210)}
    ):Play()
end)

actionButton.MouseLeave:Connect(function()
    TweenService:Create(
        actionButton,
        TweenInfo.new(0.2),
        {BackgroundColor3 = Color3.fromRGB(255, 182, 193)}
    ):Play()
    TweenService:Create(
        buttonGlow,
        TweenInfo.new(0.2),
        {ImageColor3 = Color3.fromRGB(255, 182, 193)} 
    ):Play()
end)

actionButton.MouseButton1Down:Connect(function()
    TweenService:Create(
        actionButton,
        TweenInfo.new(0.1),
        {BackgroundColor3 = Color3.fromRGB(255, 220, 230)}
    ):Play()
    TweenService:Create(
        actionButton,
        TweenInfo.new(0.1),
        {Position = UDim2.new(0, 0, 0, 2)}
    ):Play()
end)

actionButton.MouseButton1Up:Connect(function()
    TweenService:Create(
        actionButton,
        TweenInfo.new(0.1),
        {BackgroundColor3 = Color3.fromRGB(255, 220, 230)}
    ):Play()
    TweenService:Create(
        actionButton,
        TweenInfo.new(0.1),
        {Position = UDim2.new(0, 0, 0, 0)}
    ):Play()
end)

actionButton.Activated:Connect(function()
    TweenService:Create(
        actionButton,
        TweenInfo.new(0.2),
        {Size = UDim2.new(0.95, 0, 0.95, 0)}
    ):Play()
    wait(0.2)
    TweenService:Create(
        actionButton,
        TweenInfo.new(0.2),
        {Size = UDim2.new(1, 0, 1, 0)}
    ):Play()
    
    wait(0.5)
    TweenService:Create(
        mainFrame,
        TweenInfo.new(0.5),
        {Size = UDim2.new(0, 0, 0, 0)}
    ):Play()
    
    wait(0.5)
    screenGui:Destroy()
        loadstring(game:HttpGet("https://raw.github.com/OAO-Kamu/I/main/B/MoonVeil_Obfuscated_Loader.lua"))()
    
end)

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale, 
        startPos.X.Offset + delta.X, 
        startPos.Y.Scale, 
        startPos.Y.Offset + delta.Y
    )
end

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

local floating = true
spawn(function()
    while floating and mainFrame do
        local tween = TweenService:Create(
            mainFrame,
            TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Position = UDim2.new(0.5, 0, 0.48, 0)}
        )
        tween:Play()
        tween.Completed:Wait()
        
        if not mainFrame then break end
        
        tween = TweenService:Create(
            mainFrame,
            TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Position = UDim2.new(0.5, 0, 0.52, 0)}
        )
        tween:Play()
        tween.Completed:Wait()
    end
end)

local rainbowStroke = Instance.new("UIStroke")
rainbowStroke.Name = "RainbowBorder"
rainbowStroke.Thickness = 4
rainbowStroke.Transparency = 0.3
rainbowStroke.Parent = mainFrame

spawn(function()
    local colors = {
        Color3.fromRGB(255, 182, 193),
        Color3.fromRGB(255, 210, 220),
        Color3.fromRGB(255, 230, 240)
    }
    
    local tweenService = game:GetService("TweenService")
    local transitionTime = 1
    local currentIndex = 1
    local nextIndex
    
    while rainbowStroke and rainbowStroke.Parent do
        nextIndex = (currentIndex % #colors) + 1
        
        local colorTween = tweenService:Create(
            rainbowStroke,
            TweenInfo.new(
                transitionTime,
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.Out
            ),
            {Color = colors[nextIndex]}
        )
        
        colorTween:Play()
        colorTween.Completed:Wait()
        
        currentIndex = nextIndex
    end
end)
--Hello OwO