local Kamu = "纸道了"
if Kamu then
local ReGui = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua'))();
local PrefabsId = "rbxassetid://" .. ReGui.PrefabsId;
ReGui:Init({
	Prefabs = cloneref(game:GetService('InsertService'):LoadLocalAsset(PrefabsId)),
});
local function Notify(Title, Text, Duration)
	game:GetService('StarterGui'):SetCore("SendNotification", {
		Title = Title,
		Text = Text,
		Duration = Duration,
	})
end
Notify("请验证!", game.Players.LocalPlayer.Name, 7);
local Window = ReGui:PopupModal({
	Title = "冻羊验证GUI",
	NoClose = true,
})
Window:Label({
	Text = "等待 5 秒后点击“纸道了”就可进行下一步操作\n 此验证作者: 预制菜"
});
wait(5)
Window:Button({
	Text = Kamu,
	Callback = function()
		Window:ClosePopup();
	end
});
end
wait(3.5)
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
    [18687417158] = "https://raw.github.com/OAO-Kamu/I/main/fask.raw",--Forsaken
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