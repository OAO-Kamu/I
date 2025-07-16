--[[
|                       |               |     
|      __ \   _` |  __| __|  _ \    __| __ \  
|      |   | (   |\__ \ |    __/  \__ \ | | | 
|      .__/ \__,_|____/\__|\___|_)____/_| |_| 
|     _|                                      
               Made By: NOEKemono-Kamu
]]
local OrionLib = loadstring(game:HttpGet("https://raw.github.com/XiaoLingUwU/XiaoLing_-_-R_-_-O_-_-B_-_-L_-_-O_-_-X_-UI_-X/main/XiaoLing.UI-Kong-AA.Lua"))()
getgenv().Games = {
    [9872472334] = "https://raw.github.com/OAO-Kamu/Roblox-Kamu-Evade-CHANGED-Script/refs/heads/main/Evade.Luau",--EVADE PC
    [18687417158] = "https://raw.github.com/OAO-Kamu/Main/refs/heads/main/%E8%A2%AB%E9%81%97%E5%BC%83.lua",--Forsaken Mobile
    [16991287194] = "https://raw.github.com/OAO-Kamu/I/refs/heads/main/S.E.W.H..Luau",--Something Evil Will Happen Mobile
}

local id = game.PlaceId
local url = getgenv().Games[id]
if url then
OrionLib:MakeNotification({
	Name = "成功!",
	Content = "已找到服务器: "..game.GameId,
	Image = "rbxassetid://4483345998",
	Time = 10
})
    loadstring(game:HttpGet(url))()
end
local ulr = "https://raw.github.com/OAO-Kamu/I/refs/heads/main/I.luau"
if not url then
OrionLib:MakeNotification({
	Name = "没有找到支持的服务器",
	Content = "已自动加载通用...",
	Image = "rbxassetid://4483345998",
	Time = 10
})
loadstring(game:HttpGet(ulr))()
end