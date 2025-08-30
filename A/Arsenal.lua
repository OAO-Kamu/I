local L = loadstring or load
local Lib = "https://raw.githubusercontent.com/OAO-Kamu/UI-Library-Interface/refs/heads/main/SP%20LibraryMain.lua"
local splib = L(game:HttpGet(Lib))()
--======================================================================================================================================================================================================================================--
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local GameName = "Arsenal"
if game.PlaceId ~= 286090429 then 
    return
end

if _G.AimBotScript then
    _G.AimBotScript:Destroy() 
end

local Enabled = true
local FOV = 100
local Smoothing = 0.1

local SilentAimEnabled = false
local HitboxSize = 13
local HitboxTransparency = 10

local ShowFOVCircle = true
local ShowESP = true
local ESPColor = Color3.new(0, 1, 0)

local ShowScriptUsers = true
local ScriptIdentifier = "ArsenalScript_" .. math.random(10000, 99999)
local DetectedUsers = {}
local UserListText = nil

if not Drawing then
    return
end

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = ShowFOVCircle
FOVCircle.Radius = FOV
FOVCircle.Color = Color3.new(1, 1, 1)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

local ESPDrawings = {}

local function BroadcastPresence()
    if not _G.ArsenalScriptUsers then
        _G.ArsenalScriptUsers = {}
    end
    _G.ArsenalScriptUsers[LocalPlayer.Name] = {
        identifier = ScriptIdentifier,
        timestamp = tick(),
        player = LocalPlayer
    }
end

local function UpdateDetectedUsers()
    if not _G.ArsenalScriptUsers then return end
    DetectedUsers = {}
    local currentTime = tick()
    for playerName, data in pairs(_G.ArsenalScriptUsers) do
    
        if currentTime - data.timestamp > 10 then
            _G.ArsenalScriptUsers[playerName] = nil
        else
            table.insert(DetectedUsers, playerName)
        end
    end

    if UserListText then
        if #DetectedUsers > 0 then
            UserListText.Text = "其他脚本用户 (" .. #DetectedUsers .. "):\n" .. table.concat(DetectedUsers, "\n")
        else
            UserListText.Text = "没有其他的脚本用户"
        end
        UserListText.Visible = ShowScriptUsers
    end
end

local function CreateUserListDisplay()
    if UserListText then return end
    
    UserListText = Drawing.new("Text")
    UserListText.Text = "UwU"
    UserListText.Size = 14
    UserListText.Color = Color3.new(1, 1, 1)
    UserListText.Position = Vector2.new(10, 100)
    UserListText.Outline = true
    UserListText.OutlineColor = Color3.new(0, 0, 0)
    UserListText.Visible = ShowScriptUsers
end

local function getPlayersName()
    for _, v in pairs(game:GetChildren()) do
        if v.ClassName == "Players" then
            return v.Name
        end
    end
end

local players = game[getPlayersName()]
local localPlayer = players.LocalPlayer

local silentAimConnections = {}

local function StartSilentAim()
    if silentAimConnections.transparency then
        silentAimConnections.transparency:Disconnect()
    end
    if silentAimConnections.hitbox then
        silentAimConnections.hitbox:Disconnect()
    end
    
    silentAimConnections.transparency = coroutine.wrap(function()
        while SilentAimEnabled do
            for _, player in pairs(players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                    for _, partName in pairs({"RightUpperLeg", "LeftUpperLeg", "HeadHB", "HumanoidRootPart"}) do
                        local part = player.Character:FindFirstChild(partName)
                        if part then
                            part.Transparency = HitboxTransparency
                        end
                    end
                end
            end
            wait(1)
        end
    end)()
    
    silentAimConnections.hitbox = coroutine.wrap(function()
        while SilentAimEnabled do
            for _, player in pairs(players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                    for _, partName in pairs({"RightUpperLeg", "LeftUpperLeg", "HeadHB", "HumanoidRootPart"}) do
                        local part = player.Character:FindFirstChild(partName)
                        if part then
                            part.CanCollide = false
                            part.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                        end
                    end
                end
            end
            wait(1)
        end
    end)()
end

local function StopSilentAim()
    if silentAimConnections.transparency then
        silentAimConnections.transparency:Disconnect()
        silentAimConnections.transparency = nil
    end
    if silentAimConnections.hitbox then
        silentAimConnections.hitbox:Disconnect()
        silentAimConnections.hitbox = nil
    end
    
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            for _, partName in pairs({"RightUpperLeg", "LeftUpperLeg", "HeadHB", "HumanoidRootPart"}) do
                local part = player.Character:FindFirstChild(partName)
                if part then
                    part.Transparency = 0
                    part.CanCollide = true
                
                    if partName == "HumanoidRootPart" then
                        part.Size = Vector3.new(2, 2, 1)
                    elseif partName:find("Leg") then
                        part.Size = Vector3.new(1, 2, 1)
                    elseif partName == "HeadHB" then
                        part.Size = Vector3.new(2, 1, 1)
                    end
                end
            end
        end
    end
end

local function CreateESP(player)
    if ESPDrawings[player] then return end
    local drawings = {}
    drawings.Spine = Drawing.new("Line")
    drawings.LeftUpperArm = Drawing.new("Line")
    drawings.LeftLowerArm = Drawing.new("Line")
    drawings.RightUpperArm = Drawing.new("Line")
    drawings.RightLowerArm = Drawing.new("Line")
    drawings.LeftUpperLeg = Drawing.new("Line")
    drawings.LeftLowerLeg = Drawing.new("Line")
    drawings.RightUpperLeg = Drawing.new("Line")
    drawings.RightLowerLeg = Drawing.new("Line")
    
    drawings.DistanceText = Drawing.new("Text")
    drawings.DistanceText.Text = "0m"
    drawings.DistanceText.Size = 16
    drawings.DistanceText.Color = Color3.new(1, 1, 1)
    drawings.DistanceText.Center = true
    drawings.DistanceText.Outline = true
    drawings.DistanceText.OutlineColor = Color3.new(0, 0, 0)
    drawings.DistanceText.Visible = false
    
    for name, line in pairs(drawings) do
        if name:find("Arm") or name:find("Leg") or name == "Spine" then
            line.Visible = false
            line.Color = ESPColor
            line.Thickness = 2
        end
    end

    ESPDrawings[player] = drawings
end

local function RemoveESP(player)
    if not ESPDrawings[player] then return end

    for _, drawing in pairs(ESPDrawings[player]) do
        drawing:Remove()
    end
    ESPDrawings[player] = nil
end

local function UpdateESP()
    for player, drawings in pairs(ESPDrawings) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            if player.Team ~= LocalPlayer.Team then
                local character = player.Character
                local head = character:FindFirstChild("Head")
                local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
                
                local leftUpperArm = character:FindFirstChild("Left Arm") or character:FindFirstChild("LeftUpperArm")
                local leftLowerArm = character:FindFirstChild("Left Arm") or character:FindFirstChild("LeftLowerArm")
                local rightUpperArm = character:FindFirstChild("Right Arm") or character:FindFirstChild("RightUpperArm")
                local rightLowerArm = character:FindFirstChild("Right Arm") or character:FindFirstChild("RightLowerArm")
                local leftUpperLeg = character:FindFirstChild("Left Leg") or character:FindFirstChild("LeftUpperLeg")
                local leftLowerLeg = character:FindFirstChild("Left Leg") or character:FindFirstChild("LeftLowerLeg")
                local rightUpperLeg = character:FindFirstChild("Right Leg") or character:FindFirstChild("RightUpperLeg")
                local rightLowerLeg = character:FindFirstChild("Right Leg") or character:FindFirstChild("RightLowerLeg")

                if head and torso then
                    local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position)
                    local torsoPos, torsoOnScreen = Camera:WorldToViewportPoint(torso.Position)
                    
                    if headOnScreen and torsoOnScreen then
                        drawings.Spine.From = Vector2.new(headPos.X, headPos.Y)
                        drawings.Spine.To = Vector2.new(torsoPos.X, torsoPos.Y)
                        drawings.Spine.Visible = ShowESP
                        
                        if leftUpperArm then
                            local leftUpperArmPos, leftUpperArmOnScreen = Camera:WorldToViewportPoint(leftUpperArm.Position)
                            if leftUpperArmOnScreen then
                                drawings.LeftUpperArm.From = Vector2.new(torsoPos.X, torsoPos.Y)
                                drawings.LeftUpperArm.To = Vector2.new(leftUpperArmPos.X, leftUpperArmPos.Y)
                                drawings.LeftUpperArm.Visible = ShowESP
                                
                                if leftLowerArm and leftLowerArm ~= leftUpperArm then
                                    local leftLowerArmPos, leftLowerArmOnScreen = Camera:WorldToViewportPoint(leftLowerArm.Position)
                                    if leftLowerArmOnScreen then
                                        drawings.LeftLowerArm.From = Vector2.new(leftUpperArmPos.X, leftUpperArmPos.Y)
                                        drawings.LeftLowerArm.To = Vector2.new(leftLowerArmPos.X, leftLowerArmPos.Y)
                                        drawings.LeftLowerArm.Visible = ShowESP
                                    else
                                        drawings.LeftLowerArm.Visible = false
                                    end
                                else
                                    drawings.LeftLowerArm.Visible = false
                                end
                            else
                                drawings.LeftUpperArm.Visible = false
                                drawings.LeftLowerArm.Visible = false
                            end
                        else
                            drawings.LeftUpperArm.Visible = false
                            drawings.LeftLowerArm.Visible = false
                        end
                        
                        if rightUpperArm then
                            local rightUpperArmPos, rightUpperArmOnScreen = Camera:WorldToViewportPoint(rightUpperArm.Position)
                            if rightUpperArmOnScreen then
                                drawings.RightUpperArm.From = Vector2.new(torsoPos.X, torsoPos.Y)
                                drawings.RightUpperArm.To = Vector2.new(rightUpperArmPos.X, rightUpperArmPos.Y)
                                drawings.RightUpperArm.Visible = ShowESP
                                
                                if rightLowerArm and rightLowerArm ~= rightUpperArm then
                                    local rightLowerArmPos, rightLowerArmOnScreen = Camera:WorldToViewportPoint(rightLowerArm.Position)
                                    if rightLowerArmOnScreen then
                                        drawings.RightLowerArm.From = Vector2.new(rightUpperArmPos.X, rightUpperArmPos.Y)
                                        drawings.RightLowerArm.To = Vector2.new(rightLowerArmPos.X, rightLowerArmPos.Y)
                                        drawings.RightLowerArm.Visible = ShowESP
                                    else
                                        drawings.RightLowerArm.Visible = false
                                    end
                                else
                                    drawings.RightLowerArm.Visible = false
                                end
                            else
                                drawings.RightUpperArm.Visible = false
                                drawings.RightLowerArm.Visible = false
                            end
                        else
                            drawings.RightUpperArm.Visible = false
                            drawings.RightLowerArm.Visible = false
                        end
                        
                        if leftUpperLeg then
                            local leftUpperLegPos, leftUpperLegOnScreen = Camera:WorldToViewportPoint(leftUpperLeg.Position)
                            if leftUpperLegOnScreen then
                                drawings.LeftUpperLeg.From = Vector2.new(torsoPos.X, torsoPos.Y)
                                drawings.LeftUpperLeg.To = Vector2.new(leftUpperLegPos.X, leftUpperLegPos.Y)
                                drawings.LeftUpperLeg.Visible = ShowESP
                                
                                if leftLowerLeg and leftLowerLeg ~= leftUpperLeg then
                                    local leftLowerLegPos, leftLowerLegOnScreen = Camera:WorldToViewportPoint(leftLowerLeg.Position)
                                    if leftLowerLegOnScreen then
                                        drawings.LeftLowerLeg.From = Vector2.new(leftUpperLegPos.X, leftUpperLegPos.Y)
                                        drawings.LeftLowerLeg.To = Vector2.new(leftLowerLegPos.X, leftLowerLegPos.Y)
                                        drawings.LeftLowerLeg.Visible = ShowESP
                                    else
                                        drawings.LeftLowerLeg.Visible = false
                                    end
                                else
                                    drawings.LeftLowerLeg.Visible = false
                                end
                            else
                                drawings.LeftUpperLeg.Visible = false
                                drawings.LeftLowerLeg.Visible = false
                            end
                        else
                            drawings.LeftUpperLeg.Visible = false
                            drawings.LeftLowerLeg.Visible = false
                        end
                        
                        if rightUpperLeg then
                            local rightUpperLegPos, rightUpperLegOnScreen = Camera:WorldToViewportPoint(rightUpperLeg.Position)
                            if rightUpperLegOnScreen then
                                drawings.RightUpperLeg.From = Vector2.new(torsoPos.X, torsoPos.Y)
                                drawings.RightUpperLeg.To = Vector2.new(rightUpperLegPos.X, rightUpperLegPos.Y)
                                drawings.RightUpperLeg.Visible = ShowESP
                                
                                if rightLowerLeg and rightLowerLeg ~= rightUpperLeg then
                                    local rightLowerLegPos, rightLowerLegOnScreen = Camera:WorldToViewportPoint(rightLowerLeg.Position)
                                    if rightLowerLegOnScreen then
                                        drawings.RightLowerLeg.From = Vector2.new(rightUpperLegPos.X, rightUpperLegPos.Y)
                                        drawings.RightLowerLeg.To = Vector2.new(rightLowerLegPos.X, rightLowerLegPos.Y)
                                        drawings.RightLowerLeg.Visible = ShowESP
                                    else
                                        drawings.RightLowerLeg.Visible = false
                                    end
                                else
                                    drawings.RightLowerLeg.Visible = false
                                end
                            else
                                drawings.RightUpperLeg.Visible = false
                                drawings.RightLowerLeg.Visible = false
                            end
                        else
                            drawings.RightUpperLeg.Visible = false
                            drawings.RightLowerLeg.Visible = false
                        end
                        
                        local distance = math.floor((head.Position - Camera.CFrame.Position).Magnitude)
                        drawings.DistanceText.Text = distance .. "m"
                        drawings.DistanceText.Position = Vector2.new(headPos.X, headPos.Y - 25)
                        drawings.DistanceText.Visible = ShowESP
                    else
                        for _, element in pairs(drawings) do
                            element.Visible = false
                        end
                    end
                else
                    for _, element in pairs(drawings) do
                        element.Visible = false
                    end
                end
            else
                for _, element in pairs(drawings) do
                    element.Visible = false
                end
            end
        else
            for _, element in pairs(drawings) do
                element.Visible = false
            end
        end
    end
end

local function IsPlayerVisible(player)
    if not player.Character then return false end
    local target = player.Character:FindFirstChild("Head")
    if not target then return false end

    local origin = Camera.CFrame.Position
    local direction = (target.Position - origin).Unit
    local ray = Ray.new(origin, direction * 1000)
    local hit, position = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, Camera})
    if hit and hit:IsDescendantOf(player.Character) then
        return true
    end
    return false
end

local function IsInFOVCircle(player)
    if not player.Character then return false end
    local target = player.Character:FindFirstChild("Head")
    if not target then return false end
    local screenPoint, onScreen = Camera:WorldToViewportPoint(target.Position)
    if not onScreen then return false end
    local circleCenter = FOVCircle.Position
    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - circleCenter).Magnitude

    return distance <= FOVCircle.Radius
end

local function GetClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            if player.Team ~= LocalPlayer.Team then
                if IsPlayerVisible(player) and IsInFOVCircle(player) then
                    local screenPoint = Camera:WorldToViewportPoint(player.Character.Head.Position)
                    local circleCenter = FOVCircle.Position
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - circleCenter).Magnitude

                    if distance < shortestDistance then
                        closestPlayer = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end

    return closestPlayer
end

local function AimBot()
    if not Enabled then return end 
    local closestPlayer = GetClosestPlayerInFOV()
    if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
        local target = closestPlayer.Character.Head
        
        local currentLook = Camera.CFrame.LookVector
        local targetLook = (target.Position - Camera.CFrame.Position).Unit
        local adjustedLook = (currentLook + (targetLook - currentLook) * Smoothing).Unit
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + adjustedLook)
    end
end

local Window = splib:MakeWindow({
 Name = "CHANGED-汉化 | 兵工厂 | 汉化+换UI+开源",
 HidePremium = false,
 SaveConfig = true,
 Setting = true,
 ToggleIcon = "rbxassetid://82795327169782",
 ConfigFolder = "CHANHED兵工厂Configs",
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

ATab = Window:MakeTab({
  IsMobile = true,
  Name = "瞄准",
  Icon = "rbxassetid://4483345998"
})

ATab:AddSection({
  Name = "自瞄/追踪"  
})

ATab:AddToggle({
    Name = "启用自瞄",
    Desc = "What",
    Default = false,
    IsMobile = true,
	Flag = "ToggleAimbot",
	Save = true,
    Callback = function(value)
    Enabled = value
    print("Aimbot " .. (value and "Enabled" or "Disabled"))
    end
})

ATab:AddToggle({
    Name = "启用追踪",
    Desc = "What",
    Default = false,
    IsMobile = true,
	Flag = "ToggleSilent",
	Save = true,
    Callback = function(value)
    SilentAimEnabled = value
    if value then
        StartSilentAim()
    else
        StopSilentAim()
    end
    print("Silent Aim " .. (value and "Enabled" or "Disabled"))
    end
})

ATab:AddSection({
  Name = "自瞄/追踪 POV范围/平滑速度"  
})

ATab:AddToggle({
    Name = "显示 POV",
    Desc = "What",
    Default = false,
    IsMobile = true,
	Flag = "TogglePOV",
	Save = true,
    Callback = function(value)
    ShowFOVCircle = value
    FOVCircle.Visible = value
    print("FOV Circle " .. (value and "Enabled" or "Disabled"))
    end
})

ATab:AddSlider({
  Name = "平滑速度调整",
  Min = 0,
  Max = 150,
  Default = 15,
  Increment = 1,
  ValueName = "...",
  Flag = "SliderSmooth",
  Callback = function(value)
    Smoothing = value / 100
    print("Smoothing set to: " .. (value / 100))
  end    
})

ATab:AddSlider({
  Name = "POV调整",
  Min = 0,
  Max = 300,
  Default = 50,
  Increment = 1,
  ValueName = "...",
  Flag = "SlidersPOV",
  Callback = function(value)
    FOV = value
    FOVCircle.Radius = value
    print("FOV set to: " .. value)
  end    
})

BTab = Window:MakeTab({
  IsMobile = true,
  Name = "绘制",
  Icon = "rbxassetid://4483345998"
})

BTab:AddToggle({
    Name = "绘制射线和骨骼",
    Desc = "What",
    Default = false,
    IsMobile = true,
	Flag = "ESP1",
	Save = true,
    Callback = function(value)
    ShowESP = value
    print("ESP Skeleton " .. (value and "Enabled" or "Disabled"))
    end
})

BTab:AddToggle({
    Name = "绘制颜色",
    Desc = "What",
    Default = false,
    IsMobile = true,
	Flag = "ESP2",
	Save = true,
    Callback = function(value)
    ESPColor = value
    for _, drawings in pairs(ESPDrawings) do
        if drawings.Spine then drawings.Spine.Color = value end
        if drawings.LeftUpperArm then drawings.LeftUpperArm.Color = value end
        if drawings.LeftLowerArm then drawings.LeftLowerArm.Color = value end
        if drawings.RightUpperArm then drawings.RightUpperArm.Color = value end
        if drawings.RightLowerArm then drawings.RightLowerArm.Color = value end
        if drawings.LeftUpperLeg then drawings.LeftUpperLeg.Color = value end
        if drawings.LeftLowerLeg then drawings.LeftLowerLeg.Color = value end
        if drawings.RightUpperLeg then drawings.RightUpperLeg.Color = value end
        if drawings.RightLowerLeg then drawings.RightLowerLeg.Color = value end
    end
    print("ESP Color changed to: " .. tostring(value))
    end
})

BTab:AddToggle({
    Name = "显示其他使用该脚本的用户",
    Desc = "What",
    Default = false,
    IsMobile = true,
	Flag = "ESP3",
	Save = true,
    Callback = function(value)
       ShowScriptUsers = value
    if UserListText then
        UserListText.Visible = value
    end
    print("Script User Detection " .. (value and "Enabled" or "Disabled"))
    end
})

BTab:AddButton({
    Name = "刷新列表",
    Desc = "What?",
    Callback = function()
        UpdateDetectedUsers()
        print("User list refreshed - Found " .. #DetectedUsers .. " script users")
    end
})


CTab = Window:MakeTab({
  IsMobile = true,
  Name = "设置",
  Icon = "rbxassetid://4483345998"
})

CTab:AddButton({
    Name = "恢复默认设置",
    Desc = "What?",
    Callback = function()
        Enabled = true
    SilentAimEnabled = false
    FOV = 100
    Smoothing = 0.1
    ShowFOVCircle = true
    ShowESP = true
    ESPColor = Color3.new(0, 1, 0)
    HitboxSize = 13
    HitboxTransparency = 10
    FOVCircle.Radius = FOV
    FOVCircle.Visible = ShowFOVCircle
    StopSilentAim()
    for _, drawings in pairs(ESPDrawings) do
        for _, line in pairs(drawings) do
            line.Color = ESPColor
        end
    end
    print("Settings reset to default")
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
  Name = "🟡 | 制作中: 2/10"
})
StateTab:AddSection({
  Name = "🟢 | 运行中: 5/10"
})
StateTab:AddLabel("🟢WORK |  被遗弃 <==当前使用")
StateTab:AddLabel("🟢WORK |  暴力区")
StateTab:AddLabel("🟢WORK |  兵工厂(汉化)")
StateTab:AddLabel("🟢WORK |  GL-Link <==GL-X HUB的API")
StateTab:AddLabel("🟢WORK |  通用脚本 ")
StateTab:AddLabel("🟡MAKEING |  后悔电梯")
StateTab:AddLabel("🟡MAKEING |  The Rake")
StateTab:AddLabel("🔴TAPEOUT |  刀刃球")
StateTab:AddLabel("🔴TAPEOUT |  Into The Abyss")
StateTab:AddLabel("🔴TAPEOUT |  MM2")

CreateUserListDisplay()
BroadcastPresence()

local success, err = pcall(function()
    RunService.RenderStepped:Connect(function()
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        UpdateESP()
    end)
    RunService.RenderStepped:Connect(AimBot)
    
    spawn(function()
        while _G.AimBotScript do
            BroadcastPresence()
            UpdateDetectedUsers()
            wait(2)
        end
    end)
end)

if not success then
    warn("Error in RenderStepped connection: " .. err)
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    CreateESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

_G.AimBotScript = {
    Destroy = function()

        StopSilentAim()

        if FOVCircle then
            FOVCircle:Remove()
        end

        if UserListText then
            UserListText:Remove()
        end

        if _G.ArsenalScriptUsers and _G.ArsenalScriptUsers[LocalPlayer.Name] then
            _G.ArsenalScriptUsers[LocalPlayer.Name] = nil
        end

        for player, drawings in pairs(ESPDrawings) do
            RemoveESP(player)
        end

        for _, connection in pairs(getconnections(RunService.RenderStepped)) do
            connection:Disconnect()
        end

        if gui then
            pcall(function() gui:CleanUp() end)
            pcall(function() gui:Hide() end)
            if gui.ScreenGui then
                gui.ScreenGui:Destroy()
            end
        end
        
        for _, obj in pairs(game.CoreGui:GetChildren()) do
            if obj.Name:find("DropLib") or obj.Name:find("Arsenal") then
                obj:Destroy()
            end
        end
        
        _G.AimBotScript = nil

        print("Arsenal Script and GUI destroyed")
    end
}
CreateUserListDisplay()
BroadcastPresence()

local success, err = pcall(function()
    RunService.RenderStepped:Connect(function()
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        UpdateESP()
    end)
    RunService.RenderStepped:Connect(AimBot)
    
    
    spawn(function()
        while _G.AimBotScript do
            BroadcastPresence()
            UpdateDetectedUsers()
            wait(2)
        end
    end)
end)

if not success then
    warn("Error in RenderStepped connection: " .. err)
end


for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end


Players.PlayerAdded:Connect(function(player)
    CreateESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)


_G.AimBotScript = {
    Destroy = function()

        StopSilentAim()

        if FOVCircle then
            FOVCircle:Remove()
        end

        if UserListText then
            UserListText:Remove()
        end

        if _G.ArsenalScriptUsers and _G.ArsenalScriptUsers[LocalPlayer.Name] then
            _G.ArsenalScriptUsers[LocalPlayer.Name] = nil
        end

        for player, drawings in pairs(ESPDrawings) do
            RemoveESP(player)
        end

        for _, connection in pairs(getconnections(RunService.RenderStepped)) do
            connection:Disconnect()
        end

        if gui then
            pcall(function() gui:CleanUp() end)
            pcall(function() gui:Hide() end)
            if gui.ScreenGui then
                gui.ScreenGui:Destroy()
            end
        end
        
        for _, obj in pairs(game.CoreGui:GetChildren()) do
            if obj.Name:find("DropLib") or obj.Name:find("Arsenal") then
                obj:Destroy()
            end
        end
        
        _G.AimBotScript = nil

        print("Arsenal Script and GUI destroyed")
    end
}