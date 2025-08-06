local Kamu = "这是一个加载器!"
if Kamu then
local ReGui = loadstring(game:HttpGet('https://raw.github.com/depthso/Dear-ReGui/main/ReGui.lua'))();
local LOL = "https://raw.github.com/"
local PrefabsId = "rbxassetid://" .. ReGui.PrefabsId;
ReGui:Init({
	Prefabs = cloneref(game:GetService('InsertService'):LoadLocalAsset(PrefabsId)),
});
local function Notify(Title, Text, Duration)	game:GetService('StarterGui'):SetCore("SendNotification", {
		Title = Title,
		Text = Text,
		Duration = Duration,
	})end
Notify("请验证!", game.Players.LocalPlayer.Name, 7);
local Window = ReGui:PopupModal({
	Title = "冻羊验证GUI",
	NoClose = true,})
local Kamu = "OAO-Kamu/I/main/"
Window:Label({Text = "等待 5 秒后点击“纸道了”就可进行下一步操作\n 此验证作者: 预制菜"});
wait(5)
Window:Button({Text = "下一步",Callback = function()Window:ClosePopup();end});end
wait(6)

getgenv().Games = {
    [18687417158] = LOL .. "" .. Kamu .. "Forasken.lua",--Forsaken
    [5670218884] = LOL .. "" .. Kamu .. "IA.luau" --Item Asylum
    [13772394625] = LOL .. "" .. Kamu .. "BladeBalls.lua" --Blade Ball
}

local id = game.PlaceId
local url = getgenv().Games[id]
if url then
    loadstring(game:HttpGet(url))()
end

if not url then
game.Players.LocalPlayer:Kick("不支持当前服务器!\n仅支持: 被遗弃 物品避难所 刀刃球!!!")
end



