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

Tab = Window:MakeTab({
  IsMobile = true,
  Name = "本地信息",
  Icon = "rbxassetid://4483345998"
})

Tab:AddLabel("您的用户名: "..game.Players.LocalPlayer.Name)
Tab:AddLabel("您的名称: "..game.Players.LocalPlayer.DisplayName)
Tab:AddLabel("您的语言: "..game.Players.LocalPlayer.LocaleId)
Tab:AddLabel("您的国家: "..game:GetService("LocalizationService"):GetCountryRegionForPlayerAsync(game.Players.LocalPlayer))
Tab:AddLabel("您的账户年龄(天): "..game.Players.LocalPlayer.AccountAge)
Tab:AddLabel("您的账户年龄(年): "..math.floor(game.Players.LocalPlayer.AccountAge/365*100)/(100))
Tab:AddLabel("您使用的注入器："..identifyexecutor())
Tab:AddLabel("您当前的服务器ID: "..game.PlaceId)
Tab:AddSection({
  Name = "======================================================================"  
})
Tab:AddLabel("作者Roblox用户名: plm398_qe4")
Tab:AddLabel("作者Roblox大号: plm398")
Tab:AddLabel("脚本由: Q3E4 yzc 制作")
Tab:AddLabel("半开源 半缝合")
Tab:AddLabel("加入BH团队: KamuUwU(这是微信号)")

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
StateTab = Window:MakeTab({
  IsMobile = true,
  Name = "服务状态",
  Icon = "rbxassetid://4483345998"
})
StateTab:AddSection({
  Name = "CHANGED 脚本工作状态: "
})
StateTab:AddSection({
  Name = "🔴 | 已下线: 3/10"
})
StateTab:AddSection({
  Name = "🟡 | 制作中: 1/10"
})
StateTab:AddSection({
  Name = "🟢 | 运行中: 6/10"
})
StateTab:AddLabel("🟢WORK |  被遗弃")
StateTab:AddLabel("🟢WORK |  暴力区 (当前)")
StateTab:AddLabel("🟢WORK |  兵工厂(汉化)")
StateTab:AddLabel("🟢WORK |  GL-Link <==GL-X HUB的API")
StateTab:AddLabel("🟢WORK |  通用脚本 ")
StateTab:AddLabel("🟢WORK |  后悔电梯")
StateTab:AddLabel("🟡MAKEING |  The Rake")
StateTab:AddLabel("🔴TAPEOUT |  刀刃球")
StateTab:AddLabel("🔴TAPEOUT |  Into The Abyss")
StateTab:AddLabel("🔴TAPEOUT |  MM2")

Hi()