--[[
|                       |               |     
|      __ \   _` |  __| __|  _ \    __| __ \  
|      |   | (   |\__ \ |    __/  \__ \ | | | 
|      .__/ \__,_|____/\__|\___|_)____/_| |_| 
|     _|                                      
               Made By: NOEKemono-Kamu
]]
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
    [9872472334] = "https://raw.github.com/OAO-Kamu/Roblox-Kamu-Evade-CHANGED-Script/refs/heads/main/Evade.Luau",--EVADE PC
    [18687417158] = "https://raw.github.com/OAO-Kamu/Main/refs/heads/main/Forsaken.Main.Main.raw",--Forsaken Mobile+PC
    [16991287194] = "https://raw.github.com/OAO-Kamu/I/refs/heads/main/S.E.W.H..Luau",--Something Evil Will Happen 
    [13772394625] = "https://raw.github.com/OAO-Kamu/I/refs/heads/main/BladeBall.Luau",--Blade Ball Mobile+PC
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