--[[
|                       |               |     
|      __ \   _` |  __| __|  _ \    __| __ \  
|      |   | (   |\__ \ |    __/  \__ \ | | | 
|      .__/ \__,_|____/\__|\___|_)____/_| |_| 
|     _|                                      
               Made By: NOEKemono-Kamu
]]
local Lib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/BoredStuff2/notify-lib/main/lib'),true))()
getgenv().Games = {
    [9872472334] = "https://raw.github.com/OAO-Kamu/Roblox-Kamu-Evade-CHANGED-Script/refs/heads/main/Evade.Luau",--EVADE PC
    [124387865885397] = "https://raw.github.com/OAO-Kamu/Main/refs/heads/main/%E8%A2%AB%E9%81%97%E5%BC%83.lua",--Forsaken Mobile
    [1] = "https://raw.github.com/OAO-Kamu/I/refs/heads/main/I.luau"--anygame
}

local id = game.PlaceId
local url = getgenv().Games[id]
if url then
 Lib.prompt('✅| |成功!', '已找到服务器: '..game.GameId)
    loadstring(game:HttpGet(url))()
end