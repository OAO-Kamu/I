--半开源脚本谢谢支持❤️
local L = loadstring or load
local Lib = "https://raw.github.com/OAO-Kamu/UI-Library-Interface/main/SP%20LibraryMain.lua"
local Noti = "https://raw.githubusercontent.com/BloodLetters/Ash-Libs/refs/heads/main/source.lua"
local splib = L(game:HttpGet(Lib))()
local GUI = loadstring(game:HttpGet(Noti))()
local function Hi()
      GUI:CreateNotify({
         title = "当前脚本开源代码!",
         description = "CHANGED HUB 半开源脚本"
     })
end
 
 
local Window = splib:MakeWindow({
 Name = "CHANGED HUB  | 暴力区 V1.2",
 HidePremium = false,
 SaveConfig = true,
 Setting = true,
 ToggleIcon = "rbxassetid://82795327169782",
 ConfigFolder = "CHANGED 配置文件",
 CloseCallback = true
})

MainTab = Window:MakeTab({
  IsMobile = true,
  Name = "主要",
  Icon = "rbxassetid://4483345998"
})

MainTab:AddSection({
  Name = "主要"  
})

local old
old = hookmetamethod(game, "__namecall", function (self, ...)
    if _G.antiFail and tostring(self) == "SkillCheckResultEvent" and not checkcaller() then
        return
    end
    return old(self, ...)
end)
MainTab:AddToggle({
    Name = "反炸机",
    Desc = "修发电机的时候没按到区域也不会炸机",
    Default = false,
    IsMobile = true,
	Flag = "NoFail",
	Save = true,
    Callback = function(s)  
        _G.antiFail = s
    end
})
MainTab:AddToggle({
    Name = "去雾和高亮",
    Desc = "去掉雾效果",
    Default = false,
    IsMobile = true,
	Flag = "NoFog",
	Save = true,
    Callback = function(s) 
      	for i,v in pairs(game.Lighting:GetDescendants()) do
        if not v:IsA("Atmosphere") then continue end
		v:Destroy()
	end
    game.Lighting.FogEnd = 999999
    if s == false then
        return v:Destroy()
    end
    end
})
ESPTab = Window:MakeTab({
  IsMobile = true,
  Name = "绘制",
  Icon = "rbxassetid://4483345998"
})

ESPTab:AddSection({
  Name = "基础绘制"  
})
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

local function getKillerModel()
    for i, v in pairs(players:GetPlayers()) do
        if tostring(v.Team) == "Killer" then
            return v.Character
        end
    end
end
ESPTab:AddToggle({
    Name = "绘制杀手",
    Desc = "高亮显示杀手",
    Default = false,
    IsMobile = true,
	Flag = "EspKiller",
	Save = true,
    Callback = function(Value)
          _G.killers = Value
    task.spawn(function()
        while task.wait() do
            if _G.killers == true then
                local v = getKillerModel()
                if v then
                    if not v:FindFirstChild("iskiddedfromneptz") then
                        local hl = Instance.new("Highlight", v)
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Name = "iskiddedfromneptz"
                    end
                end
            else
                local v = getKillerModel()
                if v then
                    if v:FindFirstChild("iskiddedfromneptz") then
                        v.iskiddedfromneptz:Destroy()
                    end
                end
                break
            end
        end
    end)
    end
})
ESPTab:AddToggle({
    Name = "绘制发电机",
    Desc = "高亮显示发电机",
    Default = false,
    IsMobile = true,
	Flag = "EspGen",
	Save = true,
    Callback = function(Value)
          _G.generators = Value
    task.spawn(function()
        while task.wait() do
            if _G.generators then
                pcall(function()
                    for i, v in pairs(workspace.Map:GetChildren()) do
                        if v.Name == "Generator" and not v:FindFirstChild("iskiddedfromneptz") then
                            local hl = Instance.new("Highlight", v)
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.Name = "iskiddedfromneptz"
                            hl.FillColor = Color3.fromRGB(51, 255, 51)
                        end
                    end
                end)
            else
                pcall(function()
                    for i, v in pairs(workspace.Map:GetChildren()) do
                        if v.Name == "Generator" and v:FindFirstChild("iskiddedfromneptz") then
                            v.iskiddedfromneptz:Destroy()
                        end
                    end
                end)
                break
            end
        end
    end)
    end
})
ESPTab:AddToggle({
    Name = "绘制幸存者",
    Desc = "高亮显示幸存者(这个不重要不加文本)",
    Default = false,
    IsMobile = true,
	Flag = "EspSuor",
	Save = true,
    Callback = function(Value)
    _G.survivors = Value
    task.spawn(function()
        while task.wait() do
            if _G.survivors == true then
                for i, v in pairs(players:GetPlayers()) do
                    if tostring(v.Team) ~= "Killer" and v.Character and not v.Character:FindFirstChild("iskiddedfromneptz") then
                        local hl = Instance.new("Highlight", v.Character)
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Name = "iskiddedfromneptz"
                        hl.FillColor = Color3.fromRGB(255, 204, 255)
                    end
                end
            else
                for i, v in pairs(players:GetPlayers()) do
                    if tostring(v.Team) ~= "Killer" and v.Character and v.Character:FindFirstChild("iskiddedfromneptz") then
                        v.Character.iskiddedfromneptz:Destroy()
                    end
                end
                break
            end
        end
    end)
    end
})
ESPTab:AddToggle({
    Name = "显示杀手文本",
    Desc = "在杀手的位置加一个文本",
    Default = true,
    IsMobile = true,
	Flag = "KillerText",
	Save = true,
    Callback = function(Value)
    _G.killerNametags = Value
    task.spawn(function()
        while task.wait() do
            if _G.killerNametags then
                pcall(function()
                    local v = getKillerModel()
                    if v and not v:FindFirstChild("nametag") then
                        local bb = Instance.new("BillboardGui", v)
                        bb.Size = UDim2.new(4, 0, 1, 0)
                        bb.AlwaysOnTop = true
                        bb.Name = "nametag"
                        local text = Instance.new("TextLabel", bb)
                        text.TextColor3 = Color3.fromRGB(255, 0, 0)
                        text.TextStrokeTransparency = 0
                        text.Text = "杀手"
                        text.TextSize = 12
                        text.BackgroundTransparency = 1
                        text.Size = UDim2.new(1, 0, 1, 0)
                    end
                end)
            else
                pcall(function()
                    local v = getKillerModel()
                    if v and v:FindFirstChild("nametag") then
                        v.nametag:Destroy()
                    end
                end)
                break
            end
        end
    end)
    end
})
ESPTab:AddToggle({
    Name = "显示发电机文本",
    Desc = "在发电机的位置加一个文本",
    Default = true,
    IsMobile = true,
	Flag = "TextGen",
	Save = true,
    Callback = function(Value)
    _G.generatorstag = Value
    task.spawn(function()
        while task.wait() do
            if _G.generatorstag then
                local suc, res=  pcall(function()
                    for i, v in pairs(workspace.Map:GetChildren()) do
                        if v.Name == "Generator" and not v:FindFirstChild("nametag",true) then
                            local bb = Instance.new("BillboardGui", v.HitBox)
                            bb.Size = UDim2.new(4, 0, 1, 0)
                            bb.AlwaysOnTop = true
                            bb.Name = "nametag"
                            local text = Instance.new("TextLabel", bb)
                            text.TextColor3 = Color3.fromRGB(51, 255, 51)
                            text.TextStrokeTransparency = 0
                            text.Text = "发电机"
                            text.TextSize = 10
                            text.BackgroundTransparency = 1
                            text.Size = UDim2.new(1, 0, 1, 0)
                        elseif v:FindFirstChild("nametag",true) and v.Name == "Generator" then
                            
                        end
                    end
                end)
            else
                pcall(function()
                    for i, v in pairs(workspace.Map:GetChildren()) do
                        if v.Name == "Generator" and v:FindFirstChild("nametag",true) then
                            v.nametag:Destroy()
                        end
                    end
                end)
                break
            end
        end
    end)
    end
})
Hi()