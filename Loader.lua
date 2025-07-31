local NotificationLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/DemogorgonItsMe/DemoNotifications/refs/heads/main/V2/source.lua"))()
NotificationLib:SetSettings({
    position = "BottomCenter", -- "BottomRight" or "BottomCenter"
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
    [18687417158] = "https://raw.github.com/OAO-Kamu/I/main/Fask.raw",--Forsaken
}

local id = game.PlaceId
local url = getgenv().Games[id]
if url then
    loadstring(game:HttpGet(url))()
end
--local ulr = "🥰我是福瑞控🥰"
if not url then
    NotificationLib:Notify({
    Title = "你并不在被遗弃服务器中!~",
    Message = "冻羊脚本 | 少羽吃牛逼",
    Type = "error", 
    Duration = 10
})
--loadstring(game:HttpGet(ulr, true))()
end