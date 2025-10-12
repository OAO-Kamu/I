if not game:IsLoaded() then 
    game.Loaded:Wait()
end

if not syn or not protectgui then
    getgenv().protectgui = function() end
end

if bypass_adonis then
    task.spawn(function()
        local g = getinfo or debug.getinfo
        local d = false
        local h = {}

        local x, y

        setthreadidentity(2)

        for i, v in getgc(true) do
            if typeof(v) == "table" then
                local a = rawget(v, "Detected")
                local b = rawget(v, "Kill")
            
                if typeof(a) == "function" and not x then
                    x = a
                    local o; o = hookfunction(x, function(c, f, n)
                        if c ~= "_" then
                            if d then
                                warn(`Adonis AntiCheat flagged\nMethod: {c}\nInfo: {f}`)
                            end
                        end
                        
                        return true
                    end)
                    table.insert(h, x)
                end

                if rawget(v, "Variables") and rawget(v, "Process") and typeof(b) == "function" and not y then
                    y = b
                    local o; o = hookfunction(y, function(f)
                        if d then
                            warn(`Adonis AntiCheat tried to kill (fallback): {f}`)
                        end
                    end)
                    table.insert(h, y)
                end
            end
        end

        local o; o = hookfunction(getrenv().debug.info, newcclosure(function(...)
            local a, f = ...

            if x and a == x then
                if d then
                    warn(`zins | adonis bypassed`)
                end

                return coroutine.yield(coroutine.running())
            end
            
            return o(...)
        end))

        setthreadidentity(7)
    end)
end

local SilentAimSettings = {
    Enabled = false,
    
    ClassName = "PasteWare  |  github.com/FakeAngles",
    ToggleKey = "U",
    
    TeamCheck = false,
    TargetPart = "HumanoidRootPart",
    SilentAimMethod = "Raycast",
    
    FOVRadius = 130,
    ShowSilentAimTarget = false, 
    HitChance = 100
}

local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local GetChildren = game.GetChildren
local GetPlayers = Players.GetPlayers
local WorldToScreen = Camera.WorldToScreenPoint
local WorldToViewportPoint = Camera.WorldToViewportPoint
local GetPartsObscuringTarget = Camera.GetPartsObscuringTarget
local FindFirstChild = game.FindFirstChild
local RenderStepped = RunService.RenderStepped
local GuiInset = GuiService.GetGuiInset
local GetMouseLocation = UserInputService.GetMouseLocation

local resume = coroutine.resume 
local create = coroutine.create

local ValidTargetParts = {"Head", "HumanoidRootPart"}
local PredictionAmount = 0.165

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local fov_circle = Drawing.new("Circle")
fov_circle.Thickness = 1
fov_circle.NumSides = 100
fov_circle.Radius = 180
fov_circle.Filled = false
fov_circle.Visible = false
fov_circle.ZIndex = 999
fov_circle.Transparency = 1
fov_circle.Color = Color3.fromRGB(54, 57, 241)

local ExpectedArguments = {
    ViewportPointToRay = {
        ArgCountRequired = 2,
        Args = { "number", "number" }
    },
    ScreenPointToRay = {
        ArgCountRequired = 2,
        Args = { "number", "number" }
    },
    Raycast = {
        ArgCountRequired = 3,
        Args = { "Instance", "Vector3", "Vector3", "RaycastParams" }
    },
    FindPartOnRay = {
        ArgCountRequired = 2,
        Args = { "Ray", "Instance?", "boolean?", "boolean?" }
    },
    FindPartOnRayWithIgnoreList = {
        ArgCountRequired = 2,
        Args = { "Ray", "table", "boolean?", "boolean?" }
    },
    FindPartOnRayWithWhitelist = { 
        ArgCountRequired = 2,
        Args = { "Ray", "table", "boolean?" }
    }
}

function CalculateChance(Percentage)

    Percentage = math.floor(Percentage)


    local chance = math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100) / 100


    return chance <= Percentage / 100
end


local function getPositionOnScreen(Vector)
    local Vec3, OnScreen = WorldToScreen(Camera, Vector)
    return Vector2.new(Vec3.X, Vec3.Y), OnScreen
end

local function ValidateArguments(Args, RayMethod)
    local Matches = 0
    if #Args < RayMethod.ArgCountRequired then
        return false
    end

    for Pos, Argument in next, Args do
        local Expected = RayMethod.Args[Pos]
        if not Expected then
            break
        end

        local IsOptional = Expected:sub(-1) == "?"
        local BaseType = IsOptional and Expected:sub(1, -2) or Expected

        if typeof(Argument) == BaseType then
            Matches = Matches + 1
        elseif IsOptional and Argument == nil then
            Matches = Matches + 1
        end
    end

    return Matches >= RayMethod.ArgCountRequired
end

local function getDirection(Origin, Position)
    return (Position - Origin).Unit * 1000
end

local function getMousePosition()
    return GetMouseLocation(UserInputService)
end

local function IsPlayerVisible(Player)
    -- safe guards
    if not Player or not Player.Character or not LocalPlayer.Character then
        return false
    end

    -- determine which part to raycast to (uses Options.TargetPart if present, falls back to HumanoidRootPart)
    local targetPartName = (Options and Options.TargetPart and Options.TargetPart.Value) or SilentAimSettings.TargetPart or "HumanoidRootPart"
    local TargetPart = FindFirstChild(Player.Character, targetPartName) or FindFirstChild(Player.Character, "HumanoidRootPart")
    if not TargetPart then
        return false
    end

    -- build cast points (center, slightly above, slightly below) to be a bit more robust
    local castPoints = {
        TargetPart.Position,
        TargetPart.Position + Vector3.new(0, 1.2, 0),
        TargetPart.Position + Vector3.new(0, -1.2, 0)
    }

    -- ignore both characters for occlusion checks
    local ignoreList = { LocalPlayer.Character, Player.Character }

    -- GetPartsObscuringTarget expects Vector3 positions for cast points
    local obscuring = GetPartsObscuringTarget(Camera, castPoints, ignoreList)

    return (#obscuring == 0)
end

local function getClosestPlayer()
    if not Options.TargetPart.Value then return end
    local Camera = workspace.CurrentCamera
    local Closest
    local DistanceToMouse
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2.5)
    local ignoredPlayers = Options.PlayerDropdown.Value 

    for _, Player in next, GetPlayers(Players) do
        if Player == LocalPlayer then continue end
        if ignoredPlayers and ignoredPlayers[Player.Name] then continue end
        if Toggles.TeamCheck.Value and Player.Team == LocalPlayer.Team then continue end

        local Character = Player.Character
        if not Character then continue end

        local HumanoidRootPart = FindFirstChild(Character, "HumanoidRootPart")
        local Humanoid = FindFirstChild(Character, "Humanoid")
        if not HumanoidRootPart or not Humanoid or Humanoid and Humanoid.Health <= 0 then continue end

        local ScreenPosition, OnScreen = getPositionOnScreen(HumanoidRootPart.Position)
        if not OnScreen then continue end

        -- ðŸ‘‡ Always enforce visible check
        if not IsPlayerVisible(Player) then continue end

        local Distance = (center - ScreenPosition).Magnitude
        if Distance <= (DistanceToMouse or Options.Radius.Value or 2000) then
            Closest = ((Options.TargetPart.Value == "Random" and Character[ValidTargetParts[math.random(1, #ValidTargetParts)]]) or Character[Options.TargetPart.Value])
            DistanceToMouse = Distance
        end
    end
    return Closest
end

RunService.RenderStepped:Connect(function()
    if aimLockEnabled and lockEnabled and isLockedOn and targetPlayer and targetPlayer.Character then
        local partName = getBodyPart(targetPlayer.Character, bodyPartSelected)
        local part = targetPlayer.Character:FindFirstChild(partName)

        if part and targetPlayer.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local predictedPosition = part.Position + (part.AssemblyLinearVelocity * predictionFactor)
            local currentCameraPosition = Camera.CFrame.Position

            Camera.CFrame = CFrame.new(currentCameraPosition, predictedPosition) * CFrame.new(0, 0, smoothingFactor)
        else
            isLockedOn = false
            targetPlayer = nil
        end
    end
end)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/FakeAngles/PasteWare/refs/heads/main/mobileLib.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/FakeAngles/PasteWare/refs/heads/main/manage2.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/FakeAngles/PasteWare/refs/heads/main/manager.lua"))()

local Window = Library:CreateWindow({
    Title = '通用子弹追踪 | 汉化',
    Center = true,
    AutoShow = true,  
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local GeneralTab = Window:AddTab("主要")
local aimbox = GeneralTab:AddRightGroupbox("瞄准锁设置")
local velbox = GeneralTab:AddRightGroupbox("反锁定")
local frabox = GeneralTab:AddRightGroupbox("本地玩家")
local ExploitTab = Window:AddTab("战争大亨")
local WarTycoonBox = ExploitTab:AddLeftGroupbox("战争大亨")
local ACSEngineBox = ExploitTab:AddRightGroupbox("改武器")
local VisualsTab = Window:AddTab("视觉")
local settingsTab = Window:AddTab("设置")
local MenuGroup = settingsTab:AddLeftGroupbox("菜单")
MenuGroup:AddButton("销毁UI", function() Library:Unload() end)
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
ThemeManager:ApplyToTab(settingsTab)
SaveManager:BuildConfigSection(settingsTab)

local ScreenGui = Instance.new("ScreenGui")
local OpenButton = Instance.new("TextButton")
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

OpenButton.Parent = ScreenGui
OpenButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
OpenButton.Size = UDim2.new(0, 80, 0, 30)
OpenButton.Position = UDim2.new(1, -100, 0.5, -15)
OpenButton.Text = "切换"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.Font = Enum.Font.Code
OpenButton.TextSize = 14
OpenButton.BorderSizePixel = 0
OpenButton.Active = true

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1.5
UIStroke.Color = Color3.fromRGB(0, 110, 255)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = OpenButton

OpenButton.MouseButton1Click:Connect(function()
    Library:Toggle()
end)

local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    OpenButton.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

OpenButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = OpenButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

OpenButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

aimbox:AddToggle("aimLock_Enabled", {
    Text = "启用瞄准锁",
    Default = false,
    Tooltip = "",
    Callback = function(value)
        aimLockEnabled = value
        if not aimLockEnabled then
            lockEnabled = false
            isLockedOn = false
            targetPlayer = nil
        end
    end
})

aimbox:AddToggle("aim_Enabled", {
    Text = "瞄准锁 快捷键",
    Default = false,
    Tooltip = "",
    Callback = function(value)
        lockEnabled = value
        if not lockEnabled then
            isLockedOn = false
            targetPlayer = nil
        end
    end,
}):AddKeyPicker("aim_Enabled_KeyPicker", {
    Default = "Q", 
    SyncToggleState = true,
    Mode = "Toggle",
    Text = "瞄准锁 快捷键",
    Tooltip = "",
    Callback = function()
        toggleLockOnPlayer()
    end,
})

aimbox:AddSlider("Smoothing", {
    Text = "相机平滑",
    Default = 0.1,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Tooltip = "调整相机平滑 Value",
    Callback = function(value)
        smoothingFactor = value
    end,
})


aimbox:AddSlider("Prediction", {
    Text = "预判 Value",
    Default = 0.0,
    Min = 0,
    Max = 2,
    Rounding = 2,
    Tooltip = ".",
    Callback = function(value)
        predictionFactor = value
    end,
})

aimbox:AddDropdown("BodyParts", {
    Values = {
        "Head", 
        "UpperTorso", 
        "RightUpperArm", 
        "LeftUpperLeg", 
        "RightUpperLeg", 
        "LeftUpperArm"
    },
    Default = "Head",
    Multi = false,
    Text = "目标身体部位",
    Tooltip = "头 上躯干 左上手 左上腿 右上手 右上腿",
    Callback = function(value)
        bodyPartSelected = value
    end,
})


local reverseResolveIntensity = 5
getgenv().Desync = false
getgenv().DesyncEnabled = false  


game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().DesyncEnabled then  
        if getgenv().Desync then
            local player = game.Players.LocalPlayer
            local character = player.Character
            if not character then return end 

            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then return end

            local originalVelocity = humanoidRootPart.Velocity

            local randomOffset = Vector3.new(
                math.random(-1, 1) * reverseResolveIntensity * 1000,
                math.random(-1, 1) * reverseResolveIntensity * 1000,
                math.random(-1, 1) * reverseResolveIntensity * 1000
            )

            humanoidRootPart.Velocity = randomOffset
            humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.Angles(
                0,
                math.random(-1, 1) * reverseResolveIntensity * 0.001,
                0
            )

            game:GetService("RunService").RenderStepped:Wait()

            humanoidRootPart.Velocity = originalVelocity
        end
    end
end)

velbox:AddToggle("desyncMasterEnabled", {
    Text = "启用去同步",
    Default = false,
    Tooltip = ".",
    Callback = function(value)
        getgenv().DesyncEnabled = value  
    end
})


velbox:AddToggle("desyncEnabled", {
    Text = "去同步 快捷键",
    Default = false,
    Tooltip = ".",
    Callback = function(value)
        getgenv().Desync = value
    end
}):AddKeyPicker("desyncToggleKey", {
    Default = "V", 
    SyncToggleState = true,
    Mode = "Toggle",
    Text = "去同步 键盘快捷键",
    Tooltip = ".",
    Callback = function(value)
        getgenv().Desync = value
    end
})


velbox:AddSlider("ReverseResolveIntensity", {
    Text = "速度/强度",
    Default = 5,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Tooltip = ".",
    Callback = function(value)
        reverseResolveIntensity = value
    end
})



local antiLockEnabled = false
local resolverIntensity = 1.0
local resolverMethod = "重新计算"


RunService.RenderStepped:Connect(function()
    if aimLockEnabled and isLockedOn and targetPlayer and targetPlayer.Character then
        local partName = getBodyPart(targetPlayer.Character, bodyPartSelected)
        local part = targetPlayer.Character:FindFirstChild(partName)

        if part and targetPlayer.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local predictedPosition = part.Position + (part.AssemblyLinearVelocity * predictionFactor)

            if antiLockEnabled then
                if resolverMethod == "重新计算" then

                    predictedPosition = predictedPosition + (part.AssemblyLinearVelocity * resolverIntensity)
                elseif resolverMethod == "随机化" then

                    predictedPosition = predictedPosition + Vector3.new(
                        math.random() * resolverIntensity - (resolverIntensity / 2),
                        math.random() * resolverIntensity - (resolverIntensity / 2),
                        math.random() * resolverIntensity - (resolverIntensity / 2)
                    )
                elseif resolverMethod == "反转" then

                    predictedPosition = predictedPosition - (part.AssemblyLinearVelocity * resolverIntensity * 2)
                end
            end

            local currentCameraPosition = Camera.CFrame.Position
            Camera.CFrame = CFrame.new(currentCameraPosition, predictedPosition) * CFrame.new(0, 0, smoothingFactor)
        else
            isLockedOn = false
            targetPlayer = nil
        end
    end
end)

aimbox:AddToggle("antiLock_Enabled", {
    Text = "启用反锁定解析器",
    Default = false,
    Tooltip = ".",
    Callback = function(value)
        antiLockEnabled = value
    end,
})

aimbox:AddSlider("ResolverIntensity", {
    Text = "解析器强度",
    Default = 1.0,
    Min = 0,
    Max = 5,
    Rounding = 2,
    Tooltip = ".",
    Callback = function(value)
        resolverIntensity = value
    end,
})

aimbox:AddDropdown("ResolverMethods", {
    Values = {
      "重新计算", 
      "随机化", 
      "反转"
    },
    Default = "重新计算", 
    Multi = false,
    Text = "解析方法",
    Tooltip = ".",
    Callback = function(value)
        resolverMethod = value
    end,
})


local MainBOX = GeneralTab:AddLeftTabbox("子弹追踪")
local Main = MainBOX:AddTab("子弹追踪")

SilentAimSettings.BulletTP = false


Main:AddToggle("aim_Enabled", {
    Text = "启用"
}):AddKeyPicker("aim_Enabled_KeyPicker", {
        Default = "U", 
        SyncToggleState = true, 
        Mode = "Toggle", 
        Text = "启用", 
        NoUI = false
    })

Options.aim_Enabled_KeyPicker:OnClick(function()
    SilentAimSettings.Enabled = not SilentAimSettings.Enabled
    Toggles.aim_Enabled.Value = SilentAimSettings.Enabled
    Toggles.aim_Enabled:SetValue(SilentAimSettings.Enabled)
    mouse_box.Visible = SilentAimSettings.Enabled
end)


Main:AddToggle("TeamCheck", {
    Text = "团队检查", 
    Default = SilentAimSettings.TeamCheck
}):OnChanged(function()
    SilentAimSettings.TeamCheck = Toggles.TeamCheck.Value
end)

Main:AddToggle("BulletTP", {
    Text = "子弹传送",
    Default = SilentAimSettings.BulletTP,
    Tooltip = ""
}):OnChanged(function()
    SilentAimSettings.BulletTP = Toggles.BulletTP.Value
end)

Main:AddDropdown("TargetPart", {
    AllowNull = true, 
    Text = "目标部位", 
    Default = SilentAimSettings.TargetPart, 
    Values = {
      "Head", 
      "HumanoidRootPart", 
      "Random"
    }
}):OnChanged(function()
    SilentAimSettings.TargetPart = Options.TargetPart.Value
end)

Main:AddDropdown("Method", {
    AllowNull = true,
    Text = "子弹追踪方法",
    Default = SilentAimSettings.SilentAimMethod,
    Values = {
        "ViewportPointToRay",
        "ScreenPointToRay",
        "Raycast",
        "FindPartOnRay",
        "FindPartOnRayWithIgnoreList",
        "CounterBlox"
    }
}):OnChanged(function() 
    SilentAimSettings.SilentAimMethod = Options.Method.Value 
end)

if not SilentAimSettings.BlockedMethods then
    SilentAimSettings.BlockedMethods = {}
end

Main:AddDropdown("Blocked Methods", {
    AllowNull = true,
    Multi = true,
    Text = "阻止方法",
    Default = SilentAimSettings.BlockedMethods,
    Values = {
        "Destroy",
        "BulkMoveTo",
        "PivotTo",
        "TranslateBy",
        "SetPrimaryPartCFrame"
    }
}):OnChanged(function()
    SilentAimSettings.BlockedMethods = Options["Blocked Methods"].Value
end)

Main:AddDropdown("Include", {
    AllowNull = true,
    Multi = true,
    Text = "忽略",
    Default = SilentAimSettings.Include or {},
    Values = {"Camera", "Character"},
    Tooltip = ""
}):OnChanged(function()
    SilentAimSettings.Include = Options.Include.Value
end)

Main:AddDropdown("Origin", {
    AllowNull = true,
    Multi = true,
    Text = "原点",
    Default = SilentAimSettings.Origin or "Camera",
    Values = {"Camera", "Custom"},
    Tooltip = ""
}):OnChanged(function()
    SilentAimSettings.Origin = Options.Origin.Value
end)

Main:AddSlider("MultiplyUnitBy", {
    Text = "乘数单位",
    Default = 1,
    Min = 0.1,
    Max = 10,
    Rounding = 1,
    Compact = false,
    Tooltip = ""
}):OnChanged(function()
    SilentAimSettings.MultiplyUnitBy = Options.MultiplyUnitBy.Value
end)

Main:AddSlider("HitChance", {
    Text = "命中几率",
    Default = 100,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Compact = false,
}):OnChanged(function()
    SilentAimSettings.HitChance = Options.HitChance.Value
end)


local FieldOfViewBOX = GeneralTab:AddLeftTabbox("视野") do
    local Main = FieldOfViewBOX:AddTab("视觉")

    Main:AddToggle("Visible", {
        Text = "显示 FOV 圈"
    }):AddColorPicker("Color", {
        Default = Color3.fromRGB(54, 57, 241)
    }):OnChanged(function()
            fov_circle.Visible = Toggles.Visible.Value
            SilentAimSettings.FOVVisible = Toggles.Visible.Value
    end)

    Main:AddSlider("Radius", {
        Text = "FOV 大小", 
        Min = 0, 
        Max = 360, 
        Default = 130, 
        Rounding = 0
    }):OnChanged(function()
        fov_circle.Radius = Options.Radius.Value
        SilentAimSettings.FOVRadius = Options.Radius.Value
    end)

    Main:AddToggle("MousePosition", {
        Text = "显示瞄准目标"
    }):AddColorPicker("MouseVisualizeColor", {
        Default = Color3.fromRGB(54, 57, 241)
    }):OnChanged(function()
            SilentAimSettings.ShowSilentAimTarget = Toggles.MousePosition.Value
    end)

    Main:AddDropdown("PlayerDropdown", {
        SpecialType = "Player",
        Text = "忽略玩家",
        Tooltip = "",
        Multi = true
    })
end

local previousHighlight = nil
local function removeOldHighlight()
    if previousHighlight then
        previousHighlight:Destroy()
        previousHighlight = nil
    end
end

task.spawn(function()
    RenderStepped:Connect(function()
        if Toggles.MousePosition.Value then
            local closestPlayer = getClosestPlayer()
            if closestPlayer then 
                local char = closestPlayer.Parent
                if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
                    if Toggles.TeamCheck.Value and closestPlayer:IsA("Player") and closestPlayer.Team == LocalPlayer.Team then
                        removeOldHighlight()
                        return
                    end
                    local Root = char.PrimaryPart or char:FindFirstChild("HumanoidRootPart")
                    if Root then
                        local RootToViewportPoint, IsOnScreen = WorldToViewportPoint(Camera, Root.Position)
                        removeOldHighlight()
                        if IsOnScreen then
                            local highlight = char:FindFirstChildOfClass("Highlight")
                            if not highlight then
                                highlight = Instance.new("Highlight")
                                highlight.Parent = char
                                highlight.Adornee = char
                            end
                            highlight.FillColor = Options.MouseVisualizeColor.Value
                            highlight.FillTransparency = 0.5
                            highlight.OutlineColor = Options.MouseVisualizeColor.Value
                            highlight.OutlineTransparency = 0
                            previousHighlight = highlight
                        end
                    end
                end
            else 
                removeOldHighlight()
            end
        end
        if Toggles.Visible.Value then 
            fov_circle.Visible = Toggles.Visible.Value
            fov_circle.Color = Options.Color.Value
            fov_circle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        end
    end)
end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local SoundService = game:GetService("SoundService")

local sounds = {
    ["RIFK7"] = "rbxassetid://9102080552",
    ["Bubble"] = "rbxassetid://9102092728",
    ["Minecraft"] = "rbxassetid://5869422451",
    ["Cod"] = "rbxassetid://160432334",
    ["Bameware"] = "rbxassetid://6565367558",
    ["Neverlose"] = "rbxassetid://6565370984",
    ["Gamesense"] = "rbxassetid://4817809188",
    ["Rust"] = "rbxassetid://6565371338",
}

local hitSound = Instance.new("Sound")
hitSound.Volume = 3
hitSound.Parent = SoundService

local HitSoundBox = GeneralTab:AddRightTabbox("打击声音") do
    local Main = HitSoundBox:AddTab("打击声音 [测试]")

    Main:AddToggle("HitSoundEnabled", {
        Text = "启用打击声音", 
        Default = true
    })

    Main:AddDropdown("HitSoundSelect", {
        Values = {
          "RIFK7",
          "Bubble",
          "Minecraft",
          "Cod",
          "Bameware",
          "Neverlose",
          "Gamesense",
          "Rust"
        },
        Default = "Neverlose",
        Text = "选择",
        Tooltip = ""
    }):OnChanged(function()
        local id = sounds[Options.HitSoundSelect.Value]
        if id then
            hitSound.SoundId = id
        end
    end)
end

hitSound.SoundId = sounds[Options.HitSoundSelect.Value]

local soundPool = {}
local soundIndex = 1

local function getNextSound()
    if soundIndex > #soundPool then
        local s = hitSound:Clone()
        s.Parent = workspace
        s.Looped = false
        table.insert(soundPool, s)
    end
    local s = soundPool[soundIndex]
    soundIndex = soundIndex + 1
    return s
end

local function playHitSound()
    local s = getNextSound()
    s:Stop()
    s:Play()
end

local function trackPlayer(plr)
    if plr == LocalPlayer then return end

    plr.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid", 10)
        if not hum then return end

        local lastHealth = hum.Health

        hum.HealthChanged:Connect(function(newHp)
            if Toggles.HitSoundEnabled.Value then
                local closest = getClosestPlayer()
                if closest and closest.Parent == char then
                    if newHp < lastHealth then
                        playHitSound()
                    end
                    if lastHealth > 0 and newHp <= 0 then
                        playHitSound()
                    end
                end
            end
            lastHealth = newHp
        end)
    end)
end

for _, plr in ipairs(Players:GetPlayers()) do
    trackPlayer(plr)
end
Players.PlayerAdded:Connect(trackPlayer)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
    local Method, Arguments = getnamecallmethod(), {...}
    local self, chance = Arguments[1], CalculateChance(SilentAimSettings.HitChance)

    local BlockedMethods = SilentAimSettings.BlockedMethods or {}
    if Method == "Destroy" and self == Client then
        return
    end
    if table.find(BlockedMethods, Method) then
        return
    end

    local CanContinue = false
    if SilentAimSettings.CheckForFireFunc and (Method == "FindPartOnRay" or Method == "FindPartOnRayWithWhitelist" or Method == "FindPartOnRayWithIgnoreList" or Method == "Raycast" or Method == "ViewportPointToRay" or Method == "ScreenPointToRay") then
        local Traceback = tostring(debug.traceback()):lower()
        if Traceback:find("bullet") or Traceback:find("gun") or Traceback:find("fire") then
            CanContinue = true
        else
            return oldNamecall(...)
        end
    end

    if Toggles.aim_Enabled and Toggles.aim_Enabled.Value and self == workspace and not checkcaller() and chance then
        local HitPart = getClosestPlayer()
        if HitPart then
            local function modifyRay(Origin)
                if SilentAimSettings.BulletTP then
                    Origin = (HitPart.CFrame * CFrame.new(0, 0, 1)).p
                end
                return Origin, getDirection(Origin, HitPart.Position)
            end
            if Method == "FindPartOnRayWithIgnoreList" and SilentAimSettings.SilentAimMethod == Method then
                if ValidateArguments(Arguments, ExpectedArguments.FindPartOnRayWithIgnoreList) then
                    local Origin, Direction = modifyRay(Arguments[2].Origin)
                    Arguments[2] = Ray.new(Origin, Direction * SilentAimSettings.MultiplyUnitBy)
                    return oldNamecall(unpack(Arguments))
                end
            elseif Method == "FindPartOnRayWithWhitelist" and SilentAimSettings.SilentAimMethod == Method then
                if ValidateArguments(Arguments, ExpectedArguments.FindPartOnRayWithWhitelist) then
                    local Origin, Direction = modifyRay(Arguments[2].Origin)
                    Arguments[2] = Ray.new(Origin, Direction * SilentAimSettings.MultiplyUnitBy)
                    return oldNamecall(unpack(Arguments))
                end
            elseif (Method == "FindPartOnRay" or Method == "findPartOnRay") and SilentAimSettings.SilentAimMethod:lower() == Method:lower() then
                if ValidateArguments(Arguments, ExpectedArguments.FindPartOnRay) then
                    local Origin, Direction = modifyRay(Arguments[2].Origin)
                    Arguments[2] = Ray.new(Origin, Direction * SilentAimSettings.MultiplyUnitBy)
                    return oldNamecall(unpack(Arguments))
                end
            elseif Method == "Raycast" and SilentAimSettings.SilentAimMethod == Method then
                if ValidateArguments(Arguments, ExpectedArguments.Raycast) then
                    local Origin, Direction = modifyRay(Arguments[2])
                    Arguments[2], Arguments[3] = Origin, Direction * SilentAimSettings.MultiplyUnitBy
                    return oldNamecall(unpack(Arguments))
                end
            elseif Method == "ViewportPointToRay" and SilentAimSettings.SilentAimMethod == Method then
                if ValidateArguments(Arguments, ExpectedArguments.ViewportPointToRay) then
                    local Origin = Camera.CFrame.p
                    if SilentAimSettings.BulletTP then
                        Origin = (HitPart.CFrame * CFrame.new(0, 0, 1)).p
                    end
                    Arguments[2] = Camera:WorldToScreenPoint(HitPart.Position)
                    return Ray.new(Origin, (HitPart.Position - Origin).Unit * SilentAimSettings.MultiplyUnitBy)
                end
            elseif Method == "ScreenPointToRay" and SilentAimSettings.SilentAimMethod == Method then
                if ValidateArguments(Arguments, ExpectedArguments.ScreenPointToRay) then
                    local Origin = Camera.CFrame.p
                    if SilentAimSettings.BulletTP then
                        Origin = (HitPart.CFrame * CFrame.new(0, 0, 1)).p
                    end
                    Arguments[2] = Camera:WorldToScreenPoint(HitPart.Position)
                    return Ray.new(Origin, (HitPart.Position - Origin).Unit * SilentAimSettings.MultiplyUnitBy)
                end
            elseif Method == "FindPartOnRayWithIgnoreList" and SilentAimSettings.SilentAimMethod == "CounterBlox" then
                local Origin, Direction = modifyRay(Arguments[2].Origin)
                Arguments[2] = Ray.new(Origin, Direction * SilentAimSettings.MultiplyUnitBy)
                return oldNamecall(unpack(Arguments))
            end
        end
    end

    return oldNamecall(...)
end))

local VisualsEx = VisualsTab:AddLeftGroupbox("视觉设置")

if not _G.ExunysESPLoaded then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/FakeAngles/PasteWare/refs/heads/main/ESP.lua"))()
end

local ESP = getgenv().ExunysDeveloperESP
if not ESP then return end 

ESP.Settings = ESP.Settings or {}
ESP.Settings.Enabled = false
ESP.Properties = ESP.Properties or {}

local queuedToggles = {
    NameTag = false,
    Box = false,
    Tracer = false,
    HeadDot = false,
    HealthBar = false,
}

local function applyQueuedToggles()
    if not ESP.Settings.Enabled or not ESP.Properties then return end

    if ESP.Properties.ESP then ESP.Properties.ESP.DisplayName = queuedToggles.NameTag end
    if ESP.Properties.Box then ESP.Properties.Box.Enabled = queuedToggles.Box end
    if ESP.Properties.Tracer then ESP.Properties.Tracer.Enabled = queuedToggles.Tracer end
    if ESP.Properties.HeadDot then ESP.Properties.HeadDot.Enabled = queuedToggles.HeadDot end
    if ESP.Properties.HealthBar then ESP.Properties.HealthBar.Enabled = queuedToggles.HealthBar end
end

local function setToggle(name, value)
    queuedToggles[name] = value
    applyQueuedToggles()
end

local function setProperty(path, value)
    local ref = ESP
    for i = 1, #path-1 do
        if ref and ref[path[i]] then
            ref = ref[path[i]]
        else
            return
        end
    end
    if ref and path[#path] then
        ref[path[#path]] = value
    end
end

VisualsEx:AddToggle("espEnabled", {
    Text = "启用ESP",
    Default = false,
    Callback = function(value)
        if value and not ESP.Loaded then
            ESP:Load()
        end
        ESP.Settings.Enabled = value
        applyQueuedToggles()
    end
})

local TeamCheck = false

local function IsEnemy(player)
    if not TeamCheck then
        return true
    end
    return player.Team ~= LocalPlayer.Team
end

VisualsEx:AddToggle("teamCheck", {
    Text = "团队检查",
    Default = ESP.Settings.TeamCheck,
    Callback = function(value)
        ESP.Settings.TeamCheck = value
        UpdateAllChams()
    end
})

local espElements = {
    {
        Name = "名称标签", 
        Path = {
          "Properties", 
          "ESP", 
          "DisplayName"
        }, 
        Type = "Toggle"
    },
    {
        Name = "方框", 
        Path = {
          "Properties", 
          "Box", 
          "Enabled"
        }, 
        Type = "Toggle"
    },
    {
        Name = "方框颜色", 
        Path = {
          "Properties", 
          "Box", 
          "Color"
        }, 
        Type = "Color"
    },
    {
        Name = "追踪线", 
        Path = {
          "Properties", 
          "Tracer", 
          "Enabled"
        }, 
        Type = "Toggle"
    },
    {
        Name = "追踪线颜色", 
        Path = {
          "Properties", 
          "Tracer", 
          "Color"
        }, 
        Type = "Color"
    },
    {
        Name = "头部圆点", 
        Path = {
          "Properties", 
          "HeadDot", 
          "Enabled"
        }, 
        Type = "Toggle"
    },
    {
        Name = "头部圆点大小", 
        Path = {
          "Properties", 
          "HeadDot", 
          "NumSides"
        }, 
        Type = "Slider", 
        Min = 3, 
        Max = 60, 
        Default = ESP.Properties.HeadDot.NumSides
    },
    {
        Name = "血条", 
        Path = {
          "Properties", 
          "HealthBar", 
          "Enabled"
        }, 
        Type = "Toggle"
    },
}

for _, element in ipairs(espElements) do
    if element.Type == "Toggle" then
        VisualsEx:AddToggle(element.Name, {
            Text = element.Name,
            Default = false,
            Callback = function(val)
                setToggle(element.Name, val)
            end
        })
    elseif element.Type == "Color" then
        VisualsEx:AddLabel(element.Name):AddColorPicker(element.Name.."Color", {
            Default = setProperty and ESP[element.Path[1]][element.Path[2]][element.Path[3]] or Color3.new(1,1,1),
            Callback = function(val)
                setProperty(element.Path, val)
            end
        })
    elseif element.Type == "Slider" then
        VisualsEx:AddSlider(element.Name, {
            Text = element.Name,
            Min = element.Min,
            Max = element.Max,
            Default = element.Default,
            Rounding = 1,
            Callback = function(val)
                setProperty(element.Path, val)
            end
        })
    end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local SelfChamsEnabled = false
local RainbowChamsEnabled = false
local SelfChamsColor = Color3.fromRGB(255, 255, 255)
local originalProperties = {}

local function HSVToRGB(h, s, v)
    local c = v * s
    local x = c * (1 - math.abs((h / 60) % 2 - 1))
    local m = v - c
    local r, g, b = 0, 0, 0

    if h < 60 then r, g, b = c, x, 0
    elseif h < 120 then r, g, b = x, c, 0
    elseif h < 180 then r, g, b = 0, c, x
    elseif h < 240 then r, g, b = 0, x, c
    elseif h < 300 then r, g, b = x, 0, c
    else r, g, b = c, 0, x end

    return Color3.new(r + m, g + m, b + m)
end

local function applyChams(char)
    if not char then return end
    originalProperties = {}
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            originalProperties[part] = {
                Color = part.Color,
                Material = part.Material
            }
            part.Material = Enum.Material.ForceField
            part.Color = SelfChamsColor
        end
    end
end

local function restoreChams()
    for part, props in pairs(originalProperties) do
        if part and part.Parent then
            part.Color = props.Color
            part.Material = props.Material
        end
    end
    originalProperties = {}
end

local function updateChams()
    if not SelfChamsEnabled then return end
    for part, _ in pairs(originalProperties) do
        if part and part.Parent then
            if RainbowChamsEnabled then
                local hue = (tick() * 120) % 360
                part.Color = HSVToRGB(hue, 1, 1)
            else
                part.Color = SelfChamsColor
            end
        end
    end
end

RunService.RenderStepped:Connect(updateChams)

LocalPlayer.CharacterAdded:Connect(function(char)
    if SelfChamsEnabled then
        task.wait(1)
        applyChams(char)
    end
end)

VisualsEx:AddToggle("selfChamsEnabled", {
    Text = "自身发光",
    Default = false,
    Callback = function(val)
        SelfChamsEnabled = val
        if val then
            if LocalPlayer.Character then
                applyChams(LocalPlayer.Character)
            end
        else
            restoreChams()
        end
    end
})

VisualsEx:AddToggle("rainbowChams", {
    Text = "彩虹发光",
    Default = false,
    Callback = function(val)
        RainbowChamsEnabled = val
    end
})

VisualsEx:AddLabel("发光颜色"):AddColorPicker("selfChamsColor", {
    Default = SelfChamsColor,
    Callback = function(val)
        SelfChamsColor = val
    end
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local ChamsEnabled = false
local ChamsOccludedColor = {Color3.fromRGB(128, 0, 128), 0.7}
local ChamsVisibleColor = {Color3.fromRGB(255, 0, 255), 0.3}

local AdornmentsCache = {}
local IgnoreNames = {["HumanoidRootPart"] = true}

local function CreateAdornment(part, isHead, vis)
    local adorn
    if isHead then
        adorn = Instance.new("CylinderHandleAdornment")
        adorn.Height = vis == 1 and 0.87 or 1.02
        adorn.Radius = vis == 1 and 0.5 or 0.65
    else
        adorn = Instance.new("BoxHandleAdornment")
        local offset = vis == 1 and -0.05 or 0.05
        adorn.Size = part.Size + Vector3.new(offset, offset, offset)
    end
    adorn.Adornee = part
    adorn.Parent = part
    adorn.ZIndex = vis == 1 and 2 or 1
    adorn.AlwaysOnTop = vis == 1
    adorn.Visible = false
    return adorn
end

local function IsEnemy(player)
    if ESP and ESP.Settings and ESP.Settings.TeamCheck then
        return player.Team ~= LocalPlayer.Team
    end
    return true
end

local function ApplyChams(player)
    if player ~= LocalPlayer and player.Character then
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") and not IgnoreNames[part.Name] then
                if not AdornmentsCache[part] then
                    AdornmentsCache[part] = {
                        CreateAdornment(part, part.Name=="Head", 1),
                        CreateAdornment(part, part.Name=="Head", 2)
                    }
                end
                local ad = AdornmentsCache[part]
                local visible = ChamsEnabled and IsEnemy(player)

                ad[1].Visible = visible
                ad[1].Color3 = ChamsOccludedColor[1]
                ad[1].Transparency = ChamsOccludedColor[2]

                ad[2].Visible = visible
                ad[2].AlwaysOnTop = true
                ad[2].ZIndex = 9e9
                ad[2].Color3 = ChamsVisibleColor[1]
                ad[2].Transparency = ChamsVisibleColor[2]
            end
        end
    end
end

local function UpdateAllChams()
    for _, player in pairs(Players:GetPlayers()) do
        ApplyChams(player)
    end
end

local function TrackPlayer(player)
    player:GetPropertyChangedSignal("Team"):Connect(function()
        if AdornmentsCache[player] then
            for _, ad in pairs(AdornmentsCache[player]) do
                ad.Visible = ChamsEnabled and IsEnemy(player)
            end
        end
    end)
end

Players.PlayerAdded:Connect(TrackPlayer)
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        TrackPlayer(plr)
    end
end

RunService.RenderStepped:Connect(UpdateAllChams)

VisualsEx:AddToggle("chamsEnabled", {
    Text = "透视效果",
    Default = ChamsEnabled,
    Callback = function(val)
        ChamsEnabled = val
        for part, ad in pairs(AdornmentsCache) do
            ad[1].Visible = val
            ad[2].Visible = val
        end
    end
})

VisualsEx:AddLabel("遮挡颜色"):AddColorPicker("chamsOccludedColor", {
    Default = ChamsOccludedColor[1],
    Callback = function(val)
        ChamsOccludedColor[1] = val
    end
})

VisualsEx:AddLabel("可见颜色"):AddColorPicker("chamsVisibleColor", {
    Default = ChamsVisibleColor[1],
    Callback = function(val)
        ChamsVisibleColor[1] = val
    end
})

VisualsEx:AddSlider("chamsOccludedTransparency", {
    Text = "遮挡透明度",
    Default = ChamsOccludedColor[2],
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(val)
        ChamsOccludedColor[2] = val
    end
})

VisualsEx:AddSlider("chamsVisibleTransparency", {
    Text = "可见透明度",
    Default = ChamsVisibleColor[2],
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(val)
        ChamsVisibleColor[2] = val
    end
})

local worldbox = VisualsTab:AddRightGroupbox("世界设置")
local lighting = game:GetService("Lighting")
local camera = game.Workspace.CurrentCamera
local lockedTime, fovValue, nebulaEnabled = 12, 70, false
local originalAmbient, originalOutdoorAmbient = lighting.Ambient, lighting.OutdoorAmbient
local originalFogStart, originalFogEnd, originalFogColor = lighting.FogStart, lighting.FogEnd, lighting.FogColor
local nebulaThemeColor = Color3.fromRGB(173, 216, 230)

worldbox:AddSlider("world_time", {
    Text = "时间设置", Default = 12, Min = 0, Max = 24, Rounding = 1,
    Callback = function(v) lockedTime = v lighting.ClockTime = v end,
})

local oldNewIndex
oldNewIndex = hookmetamethod(game, "__newindex", function(self, property, value)
    if not checkcaller() and self == lighting then
        if property == "ClockTime" then value = lockedTime end
    end
    return oldNewIndex(self, property, value)
end)

worldbox:AddSlider("fov_slider", {
    Text = "视野范围", Default = 70, Min = 30, Max = 120, Rounding = 2,
    Callback = function(v) fovValue = v end,
})

local fovEnabled = false

worldbox:AddToggle("fov_toggle", {
    Text = "启用视野修改", Default = false,
    Callback = function(state) fovEnabled = state end,
})

game:GetService("RunService").RenderStepped:Connect(function() 
    if fovEnabled then
        camera.FieldOfView = fovValue 
    end
end)

worldbox:AddToggle("nebula_theme", {
    Text = "星云主题", Default = false,
    Callback = function(state)
        nebulaEnabled = state
        if state then
            local b = Instance.new("BloomEffect", lighting) b.Intensity, b.Size, b.Threshold, b.Name = 0.7, 24, 1, "NebulaBloom"
            local c = Instance.new("ColorCorrectionEffect", lighting) c.Saturation, c.Contrast, c.TintColor, c.Name = 0.5, 0.2, nebulaThemeColor, "NebulaColorCorrection"
            local a = Instance.new("Atmosphere", lighting) a.Density, a.Offset, a.Glare, a.Haze, a.Color, a.Decay, a.Name = 0.4, 0.25, 1, 2, nebulaThemeColor, Color3.fromRGB(25, 25, 112), "NebulaAtmosphere"
            lighting.Ambient, lighting.OutdoorAmbient = nebulaThemeColor, nebulaThemeColor
            lighting.FogStart, lighting.FogEnd = 100, 500
            lighting.FogColor = nebulaThemeColor
        else
            for _, v in pairs({"NebulaBloom", "NebulaColorCorrection", "NebulaAtmosphere"}) do
                local obj = lighting:FindFirstChild(v) if obj then obj:Destroy() end
            end
            lighting.Ambient, lighting.OutdoorAmbient = originalAmbient, originalOutdoorAmbient
            lighting.FogStart, lighting.FogEnd = originalFogStart, originalFogEnd
            lighting.FogColor = originalFogColor
        end
    end,
}):AddColorPicker("nebula_color_picker", {
    Text = "星云颜色", Default = Color3.fromRGB(173, 216, 230),
    Callback = function(c)
        nebulaThemeColor = c
        if nebulaEnabled then
            local nc = lighting:FindFirstChild("NebulaColorCorrection") if nc then nc.TintColor = c end
            local na = lighting:FindFirstChild("NebulaAtmosphere") if na then na.Color = c end
            lighting.Ambient, lighting.OutdoorAmbient = c, c
            lighting.FogColor = c
        end
    end,
})


local Lighting = game:GetService("Lighting")
local Visuals = {}
local Skyboxes = {}

function Visuals:NewSky(Data)
    local Name = Data.Name
    Skyboxes[Name] = {
        SkyboxBk = Data.SkyboxBk,
        SkyboxDn = Data.SkyboxDn,
        SkyboxFt = Data.SkyboxFt,
        SkyboxLf = Data.SkyboxLf,
        SkyboxRt = Data.SkyboxRt,
        SkyboxUp = Data.SkyboxUp,
        MoonTextureId = Data.Moon or "rbxasset://sky/moon.jpg",
        SunTextureId = Data.Sun or "rbxasset://sky/sun.jpg"
    }
end

function Visuals:SwitchSkybox(Name)
    local OldSky = Lighting:FindFirstChildOfClass("Sky")
    if OldSky then OldSky:Destroy() end

    local Sky = Instance.new("Sky", Lighting)
    for Index, Value in pairs(Skyboxes[Name]) do
        Sky[Index] = Value
    end
end

if Lighting:FindFirstChildOfClass("Sky") then
    local OldSky = Lighting:FindFirstChildOfClass("Sky")
    Visuals:NewSky({
        Name = "游戏默认天空",
        SkyboxBk = OldSky.SkyboxBk,
        SkyboxDn = OldSky.SkyboxDn,
        SkyboxFt = OldSky.SkyboxFt,
        SkyboxLf = OldSky.SkyboxLf,
        SkyboxRt = OldSky.SkyboxRt,
        SkyboxUp = OldSky.SkyboxUp
    })
end

Visuals:NewSky({
    Name = "日落",
    SkyboxBk = "rbxassetid://600830446",
    SkyboxDn = "rbxassetid://600831635",
    SkyboxFt = "rbxassetid://600832720",
    SkyboxLf = "rbxassetid://600886090",
    SkyboxRt = "rbxassetid://600833862",
    SkyboxUp = "rbxassetid://600835177"
})

Visuals:NewSky({
    Name = "极光",
    SkyboxBk = "http://www.roblox.com/asset/?id=225469390",
    SkyboxDn = "http://www.roblox.com/asset/?id=225469395",
    SkyboxFt = "http://www.roblox.com/asset/?id=225469403",
    SkyboxLf = "http://www.roblox.com/asset/?id=225469450",
    SkyboxRt = "http://www.roblox.com/asset/?id=225469471",
    SkyboxUp = "http://www.roblox.com/asset/?id=225469481"
})

Visuals:NewSky({
    Name = "太空",
    SkyboxBk = "http://www.roblox.com/asset/?id=166509999",
    SkyboxDn = "http://www.roblox.com/asset/?id=166510057",
    SkyboxFt = "http://www.roblox.com/asset/?id=166510116",
    SkyboxLf = "http://www.roblox.com/asset/?id=166510092",
    SkyboxRt = "http://www.roblox.com/asset/?id=166510131",
    SkyboxUp = "http://www.roblox.com/asset/?id=166510114"
})

Visuals:NewSky({
    Name = "Roblox默认",
    SkyboxBk = "rbxasset://textures/sky/sky512_bk.tex",
    SkyboxDn = "rbxasset://textures/sky/sky512_dn.tex",
    SkyboxFt = "rbxasset://textures/sky/sky512_ft.tex",
    SkyboxLf = "rbxasset://textures/sky/sky512_lf.tex",
    SkyboxRt = "rbxasset://textures/sky/sky512_rt.tex",
    SkyboxUp = "rbxasset://textures/sky/sky512_up.tex"
})

Visuals:NewSky({
    Name = "红色夜晚", 
    SkyboxBk = "http://www.roblox.com/Asset/?ID=401664839";
    SkyboxDn = "http://www.roblox.com/Asset/?ID=401664862";
    SkyboxFt = "http://www.roblox.com/Asset/?ID=401664960";
    SkyboxLf = "http://www.roblox.com/Asset/?ID=401664881";
    SkyboxRt = "http://www.roblox.com/Asset/?ID=401664901";
    SkyboxUp = "http://www.roblox.com/Asset/?ID=401664936";
})

Visuals:NewSky({
    Name = "深空", 
    SkyboxBk = "http://www.roblox.com/asset/?id=149397692";
    SkyboxDn = "http://www.roblox.com/asset/?id=149397686";
    SkyboxFt = "http://www.roblox.com/asset/?id=149397697";
    SkyboxLf = "http://www.roblox.com/asset/?id=149397684";
    SkyboxRt = "http://www.roblox.com/asset/?id=149397688";
    SkyboxUp = "http://www.roblox.com/asset/?id=149397702";
})

Visuals:NewSky({
    Name = "粉色天空", 
    SkyboxBk = "http://www.roblox.com/asset/?id=151165214";
    SkyboxDn = "http://www.roblox.com/asset/?id=151165197";
    SkyboxFt = "http://www.roblox.com/asset/?id=151165224";
    SkyboxLf = "http://www.roblox.com/asset/?id=151165191";
    SkyboxRt = "http://www.roblox.com/asset/?id=151165206";
    SkyboxUp = "http://www.roblox.com/asset/?id=151165227";
})

Visuals:NewSky({
    Name = "紫色日落", 
    SkyboxBk = "rbxassetid://264908339";
    SkyboxDn = "rbxassetid://264907909";
    SkyboxFt = "rbxassetid://264909420";
    SkyboxLf = "rbxassetid://264909758";
    SkyboxRt = "rbxassetid://264908886";
    SkyboxUp = "rbxassetid://264907379";
})

Visuals:NewSky({
    Name = "蓝色夜晚", 
    SkyboxBk = "http://www.roblox.com/Asset/?ID=12064107";
    SkyboxDn = "http://www.roblox.com/Asset/?ID=12064152";
    SkyboxFt = "http://www.roblox.com/Asset/?ID=12064121";
    SkyboxLf = "http://www.roblox.com/Asset/?ID=12063984";
    SkyboxRt = "http://www.roblox.com/Asset/?ID=12064115";
    SkyboxUp = "http://www.roblox.com/Asset/?ID=12064131";
})

Visuals:NewSky({
    Name = "花开白昼", 
    SkyboxBk = "http://www.roblox.com/asset/?id=271042516";
    SkyboxDn = "http://www.roblox.com/asset/?id=271077243";
    SkyboxFt = "http://www.roblox.com/asset/?id=271042556";
    SkyboxLf = "http://www.roblox.com/asset/?id=271042310";
    SkyboxRt = "http://www.roblox.com/asset/?id=271042467";
    SkyboxUp = "http://www.roblox.com/asset/?id=271077958";
})

Visuals:NewSky({
    Name = "蓝色星云", 
    SkyboxBk = "http://www.roblox.com/asset?id=135207744";
    SkyboxDn = "http://www.roblox.com/asset?id=135207662";
    SkyboxFt = "http://www.roblox.com/asset?id=135207770";
    SkyboxLf = "http://www.roblox.com/asset?id=135207615";
    SkyboxRt = "http://www.roblox.com/asset?id=135207695";
    SkyboxUp = "http://www.roblox.com/asset?id=135207794";
})

Visuals:NewSky({
    Name = "蓝色星球", 
    SkyboxBk = "rbxassetid://218955819";
    SkyboxDn = "rbxassetid://218953419";
    SkyboxFt = "rbxassetid://218954524";
    SkyboxLf = "rbxassetid://218958493";
    SkyboxRt = "rbxassetid://218957134";
    SkyboxUp = "rbxassetid://218950090";
})

Visuals:NewSky({
    Name = "深空", 
    SkyboxBk = "http://www.roblox.com/asset/?id=159248188";
    SkyboxDn = "http://www.roblox.com/asset/?id=159248183";
    SkyboxFt = "http://www.roblox.com/asset/?id=159248187";
    SkyboxLf = "http://www.roblox.com/asset/?id=159248173";
    SkyboxRt = "http://www.roblox.com/asset/?id=159248192";
    SkyboxUp = "http://www.roblox.com/asset/?id=159248176";
})

local SkyboxNames = {}
for Name, _ in pairs(Skyboxes) do
    table.insert(SkyboxNames, Name)
end

local worldbox = VisualsTab:AddRightGroupbox("天空盒")
local SkyboxDropdown = worldbox:AddDropdown("SkyboxSelector", {
    AllowNull = false,
    Text = "选择天空盒",
    Default = "游戏默认天空",
    Values = SkyboxNames
}):OnChanged(function(SelectedSkybox)
    if Skyboxes[SelectedSkybox] then
        Visuals:SwitchSkybox(SelectedSkybox)
    end
end)

local localPlayer = game:GetService("Players").LocalPlayer
local Cmultiplier = 1  
local isSpeedActive = false
local isFlyActive = false
local isNoClipActive = false
local isFunctionalityEnabled = true  
local flySpeed = 1
local camera = workspace.CurrentCamera
local humanoid = nil

frabox:AddToggle("functionalityEnabled", {
    Text = "启用/禁用移动功能",
    Default = true,
    Tooltip = "启用或禁用移动功能",
    Callback = function(value)
        isFunctionalityEnabled = value
    end
})

frabox:AddToggle("speedEnabled", {
    Text = "速度开关",
    Default = false,
    Tooltip = "让你移动更快",
    Callback = function(value)
        isSpeedActive = value
    end
}):AddKeyPicker("speedToggleKey", {
    Default = "C",  
    SyncToggleState = true,
    Mode = "Toggle",
    Text = "速度切换键",
    Tooltip = "CFrame键绑定",
    Callback = function(value)
        isSpeedActive = value
    end
})

frabox:AddSlider("cframespeed", {
    Text = "CFrame倍率",
    Default = 1,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Tooltip = "CFrame速度",
    Callback = function(value)
        Cmultiplier = value
    end,
})

frabox:AddToggle("flyEnabled", {
    Text = "飞行开关",
    Default = false,
    Tooltip = "切换CFrame飞行功能",
    Callback = function(value)
        isFlyActive = value
    end
}):AddKeyPicker("flyToggleKey", {
    Default = "F",  
    SyncToggleState = true,
    Mode = "Toggle",
    Text = "飞行切换键",
    Tooltip = "CFrame飞行键绑定",
    Callback = function(value)
        isFlyActive = value
    end
})

frabox:AddSlider("flySpeed", {
    Text = "飞行速度",
    Default = 1,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Tooltip = "CFrame飞行速度",
    Callback = function(value)
        flySpeed = value
    end,
})

frabox:AddToggle("noClipEnabled", {
    Text = "穿墙开关",
    Default = false,
    Tooltip = "启用或禁用穿墙",
    Callback = function(value)
        isNoClipActive = value
    end
}):AddKeyPicker("noClipToggleKey", {
    Default = "N",
    SyncToggleState = true,
    Mode = "Toggle",
    Text = "穿墙切换键",
    Tooltip = "切换穿墙的键绑定",
    Callback = function(value)
        isNoClipActive = value
    end
})

local masterToggle = false

local function enableMasterToggle(value)
    masterToggle = value
end

WarTycoonBox:AddToggle("主开关", {
    Text = "启用/禁用",
    Default = false,
    Tooltip = "全局启用或禁用所有功能",
    Callback = enableMasterToggle
})

local function modifyWeaponSettings(property, value)
    local function findSettingsModule(parent)
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("ModuleScript") then
                local success, module = pcall(function() return require(child) end)
                if success and module[property] ~= nil then
                    return module
                end
            end
            local found = findSettingsModule(child)
            if found then
                return found
            end
        end
        return nil
    end

    local player = game:GetService("Players").LocalPlayer
    local backpack = player:WaitForChild("Backpack")
    local character = player.Character or player.CharacterAdded:Wait()
    local foundModules = {}


    local function findSettingsInWarTycoon(item)
        local weaponName = item.Name
        local settingsModule = game:GetService("ReplicatedStorage"):WaitForChild("Configurations"):WaitForChild("ACS_Guns"):FindFirstChild(weaponName)
        if settingsModule then
            return settingsModule:FindFirstChild("Settings")
        end
        return nil
    end

    if getgenv().WarTycoon then
        if getgenv().WeaponOnHands then
            local toolInHand = character:FindFirstChildOfClass("Tool")
            if toolInHand then
                local settingsModule = findSettingsInWarTycoon(toolInHand)
                if settingsModule then
                    local success, module = pcall(function() return require(settingsModule) end)
                    if success and module[property] ~= nil then
                        module[property] = value
                    end
                end
            end
        else
            for _, item in pairs(backpack:GetChildren()) do
                local settingsModule = findSettingsInWarTycoon(item)
                if settingsModule then
                    local success, module = pcall(function() return require(settingsModule) end)
                    if success and module[property] ~= nil then
                        module[property] = value
                    end
                end
            end
        end
    else
        if getgenv().WeaponOnHands then
            local toolInHand = character:FindFirstChildOfClass("Tool")
            if toolInHand then
                local settingsModule = findSettingsModule(toolInHand)
                if settingsModule then
                    local success, module = pcall(function() return require(settingsModule) end)
                    if success and module[property] ~= nil then
                        module[property] = value
                    end
                end
            end
        else
            for _, item in pairs(backpack:GetChildren()) do
                local settingsModule = findSettingsModule(item)
                if settingsModule then
                    local success, module = pcall(function() return require(settingsModule) end)
                    if success and module[property] ~= nil then
                        module[property] = value
                    end
                end
            end
        end
    end
end

ACSEngineBox:AddToggle("WarTycoon", {
    Text = "战争大亨模式",
    Default = false,
    Tooltip = "启用战争大亨模式以在ACS_Guns中搜索武器设置",
    Callback = function(value)
        getgenv().WarTycoon = value
    end
})

ACSEngineBox:AddToggle("WeaponOnHands", {
    Text = "手持武器",
    Default = false,
    Tooltip = "如果启用，则仅对手持武器应用更改",
    Callback = function(value)
        getgenv().WeaponOnHands = value
    end
})

ACSEngineBox:AddButton('无限弹药', function()
    modifyWeaponSettings("Ammo", math.huge)
end)

ACSEngineBox:AddButton('无后坐力 | 无扩散', function()
    modifyWeaponSettings("VRecoil", {0, 0})
    modifyWeaponSettings("HRecoil", {0, 0})
    modifyWeaponSettings("MinSpread", 0)
    modifyWeaponSettings("MaxSpread", 0)
    modifyWeaponSettings("RecoilPunch", 0)
    modifyWeaponSettings("AimRecoilReduction", 0)
end)

ACSEngineBox:AddButton('无限子弹距离', function()
    modifyWeaponSettings("Distance", 25000)
end)

ACSEngineBox:AddInput("BulletSpeedInput", {
    Text = "子弹速度",
    Default = "10000",
    Tooltip = "设置子弹速度",
    Callback = function(value)
        getgenv().bulletSpeedValue = tonumber(value) or 10000
    end
})

ACSEngineBox:AddButton('修改子弹速度', function()
    modifyWeaponSettings("BSpeed", getgenv().bulletSpeedValue or 10000)
    modifyWeaponSettings("MuzzleVelocity", getgenv().bulletSpeedValue or 10000)
end)

local fireRateInput
fireRateInput = ACSEngineBox:AddInput('FireRateInput', {
    Text = '输入射速',
    Default = '8888',
    Tooltip = '输入要应用的射速值',
})

ACSEngineBox:AddButton('修改射速', function()
    modifyWeaponSettings("FireRate", tonumber(fireRateInput.Value) or 8888)
    modifyWeaponSettings("ShootRate", tonumber(fireRateInput.Value) or 8888)
end)

local bulletsInput = ACSEngineBox:AddInput('BulletsInput', {
    Text = '输入子弹数量',
    Default = '50',
    Tooltip = '输入要应用的子弹数量',
    Numeric = true
})

ACSEngineBox:AddButton('多发子弹', function()
    local bulletsValue = tonumber(Options.BulletsInput.Value) or 50
    modifyWeaponSettings("Bullets", bulletsValue)
end)

local inputField
inputField = ACSEngineBox:AddInput('FireModeInput', {
    Text = '输入开火模式',
    Default = 'Auto',
    Tooltip = '输入要应用的开火模式',
})

ACSEngineBox:AddButton('修改开火模式', function()
    modifyWeaponSettings("Mode", inputField.Value or 'Auto')
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local isTankSpamEnabled = false
local spamSpeed = 1
local shellsToFire = 1
local shellNumber = 1

local FireTurret, RegisterTurretHit


local function getTank()
    if not masterToggle then return end
    local tankWorkspace = Workspace:FindFirstChild("Game Systems") 
        and Workspace["Game Systems"]:FindFirstChild("Tank Workspace")
    if not tankWorkspace then return nil end

    local closestTank = nil
    local shortestDistance = math.huge

    for _, tank in pairs(tankWorkspace:GetChildren()) do
        if tank:FindFirstChild("Misc") and tank.Misc:FindFirstChild("Turrets") then
            local tankPos = (tank.PrimaryPart and tank.PrimaryPart.Position) or Vector3.new()
            local playerPos = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position) or Vector3.new()
            local distance = (tankPos - playerPos).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestTank = tank
            end
        end
    end

    return closestTank
end

local function getTurretSmokeAndSettings(tank)
    if not masterToggle then return end
    if not tank:FindFirstChild("Misc") or not tank.Misc:FindFirstChild("Turrets") then return nil, nil, nil end
    local turretsFolder = tank.Misc.Turrets

    for _, turretGroup in pairs(turretsFolder:GetChildren()) do
        if turretGroup:IsA("Folder") or turretGroup:IsA("Model") then
            for _, turret in pairs(turretGroup:GetChildren()) do
                if turret:IsA("BasePart") or turret:IsA("Model") then
                    local smoke = turret:FindFirstChild("SmokePart")
                    local module = turret:FindFirstChildOfClass("ModuleScript")
                    if smoke and module then
                        local settings = require(module)
                        return turret, smoke, settings
                    end
                end
            end
        end
    end

    return nil, nil, nil
end

local function startTankSpam()
    if not masterToggle then return end
    if not FireTurret or not RegisterTurretHit then
        FireTurret = ReplicatedStorage.BulletFireSystem:WaitForChild("FireTurret")
        RegisterTurretHit = ReplicatedStorage.BulletFireSystem:WaitForChild("RegisterTurretHit")
    end

    local tank = getTank()
    if not tank then return end

    local turret, smoke, settings = getTurretSmokeAndSettings(tank)
    if not turret or not smoke or not settings then return end

    for i = 1, shellsToFire do
        if not isTankSpamEnabled then return end

        local targetHead = getClosestPlayer()
        if not targetHead then return end

        local origin = smoke.Position
        local targetPos = targetHead.Position
        local direction = (targetPos - origin).Unit

        FireTurret:FireServer(
            tank,
            turret,
            nil,
            nil,
            nil,
            nil,
            { {Workspace[LocalPlayer.Name], turret, Workspace.LocalPartStorage} },
            true
        )

        RegisterTurretHit:FireServer(
            turret,
            smoke,
            tank,
            {
                normal = Vector3.new(0, 1, 0),
                hitPart = targetHead,
                origin = origin,
                hitPoint = targetPos,
                direction = direction
            },
            {
                OverheatCount = settings.OverheatCount or 1,
                CooldownTime = settings.CooldownTime or 10,
                BulletSpread = settings.BulletSpread or 0.05,
                FireRate = settings.FireRate or 18
            }
        )

        shellNumber += 1
    end
end

WarTycoonBox:AddToggle("坦克连发", {
    Text = "切换坦克连发",
    Default = false,
    Tooltip = "使用静默瞄准FOV",
    Callback = function(value)
        isTankSpamEnabled = value
    end,
})
:AddKeyPicker("坦克连发键", {
    Default = "Q",
    SyncToggleState = true,
    Mode = "Toggle",
    Text = "坦克连发键",
    Tooltip = "切换坦克连发",
    Callback = function()
        if isTankSpamEnabled then
            startTankSpam()
        end
    end,
})

WarTycoonBox:AddSlider("炮弹数量", {
    Text = "每次连发炮弹数",
    Default = 1,
    Min = 1,
    Max = 500,
    Rounding = 0,
    Tooltip = "调整一次发射的炮弹数量",
    Callback = function(value)
        shellsToFire = math.floor(value)
    end,
})

WarTycoonBox:AddSlider("连发速度", {
    Text = "连发速度",
    Default = 1,
    Min = 0.01,
    Max = 5,
    Rounding = 2,
    Tooltip = "调整坦克连发的速度",
    Callback = function(value)
        spamSpeed = value
    end,
})

RunService.Heartbeat:Connect(function()
    if isTankSpamEnabled then
        task.wait(math.max(0.01, 1 / spamSpeed))
        startTankSpam()
    end
end)

local WarTycoonDead = ExploitTab:AddLeftGroupbox("坦克/载具修改器")
local properties = {"射速","过热计数","冷却时间","耗尽延迟","过热增量","子弹速度"}

local selectedProperty = properties[1]
local propertyValue = 0

local propertyDropdown = WarTycoonDead:AddDropdown("属性下拉框", {
    Values = properties,
    Default = selectedProperty,
    Multi = false,
    Text = "选择属性"
})
propertyDropdown:OnChanged(function(value)
    selectedProperty = value
end)

local valueInput = WarTycoonDead:AddInput('数值输入', {
    Text='数值',
    Default="0",
    Tooltip='输入数值'
})
valueInput:OnChanged(function(value)
    local num = tonumber(value)
    if num then
        propertyValue = num
    end
end)

function getNearestVehicle()
    if not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then return nil end
    local playerPos = LocalPlayer.Character.HumanoidRootPart.Position
    local vehicleWorkspaces = {
        Workspace["Game Systems"]:FindFirstChild("Vehicle Workspace"),
        Workspace["Game Systems"]:FindFirstChild("Tank Workspace"),
		workspace["Game Systems"]:FindFirstChild("Plane Workspace")
    }
    local shortestDist = math.huge
    local nearest = nil
    for _, ws in pairs(vehicleWorkspaces) do
        if ws then
            for _, v in pairs(ws:GetChildren()) do
                if v:IsA("Model") then
                    local posPart = v:FindFirstChildWhichIsA("BasePart")
                    if posPart then
                        local dist = (posPart.Position - playerPos).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            nearest = v
                        end
                    end
                end
            end
        end
    end
    return nearest
end

function findAllSettingsModules(vehicle)
    local settingsModules = {}
    if not vehicle then return settingsModules end
    
    local function searchForSettingsModules(object)
        if object:IsA("ModuleScript") and object.Name == "Settings" then
            table.insert(settingsModules, object)
        end
        for _, child in pairs(object:GetChildren()) do
            searchForSettingsModules(child)
        end
    end
    
    searchForSettingsModules(vehicle)
    return settingsModules
end

function modifyAllVehicleSettings()
    local vehicle = getNearestVehicle()
    if not vehicle then return end
    
    local settingsModules = findAllSettingsModules(vehicle)
    if #settingsModules == 0 then return end
    
    for _, settingsModule in pairs(settingsModules) do
        pcall(function()
            local settingsTable = require(settingsModule)
            if type(settingsTable) == "table" and settingsTable[selectedProperty] ~= nil then
                settingsTable[selectedProperty] = propertyValue
            end
        end)
    end
end

WarTycoonDead:AddButton('应用属性', modifyAllVehicleSettings)

local targetStrafe = GeneralTab:AddLeftGroupbox("目标环绕")
local strafeEnabled = false
local strafeAllowed = true
local strafeSpeed, strafeRadius = 50, 5
local strafeMode, targetPlayer = "水平", nil
local originalCameraMode = nil

local function startTargetStrafe()
    if not strafeAllowed then return end
    targetPlayer = getClosestPlayer()
    if targetPlayer and targetPlayer.Parent then
        originalCameraMode = game:GetService("Players").LocalPlayer.CameraMode
        game:GetService("Players").LocalPlayer.CameraMode = Enum.CameraMode.Classic
        local targetPos = targetPlayer.Position
        LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(targetPos))
        Camera.CameraSubject = targetPlayer.Parent:FindFirstChild("Humanoid")
    end
end

local function strafeAroundTarget()
    if not (strafeAllowed and targetPlayer and targetPlayer.Parent) then return end
    local targetPos = targetPlayer.Position
    local angle = tick() * (strafeSpeed / 10)
    local offset = strafeMode == "水平"
        and Vector3.new(math.cos(angle) * strafeRadius, 0, math.sin(angle) * strafeRadius)
        or Vector3.new(math.cos(angle) * strafeRadius, strafeRadius, math.sin(angle) * strafeRadius)
    LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(targetPos + offset))
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, targetPos)
end

local function stopTargetStrafe()
    game:GetService("Players").LocalPlayer.CameraMode = originalCameraMode or Enum.CameraMode.Classic
    Camera.CameraSubject = LocalPlayer.Character.Humanoid
    strafeEnabled, targetPlayer = false, nil
end


targetStrafe:AddToggle("环绕控制开关", {
    Text = "启用/禁用",
    Default = true,
    Tooltip = "启用或禁用目标环绕功能",
    Callback = function(value)
        strafeAllowed = value
        if not strafeAllowed and strafeEnabled then
            stopTargetStrafe()
        end
    end
})

targetStrafe:AddToggle("环绕开关", {
    Text = "启用目标环绕",
    Default = false,
    Tooltip = "启用或禁用目标环绕",
    Callback = function(value)
        if strafeAllowed then
            strafeEnabled = value
            if strafeEnabled then startTargetStrafe() else stopTargetStrafe() end
        end
    end
}):AddKeyPicker("环绕切换键", {
    Default = "L",
    SyncToggleState = true,
    Mode = "Toggle",
    Text = "目标环绕切换键",
    Tooltip = "切换目标环绕的键",
    Callback = function(value)
        if strafeAllowed then
            strafeEnabled = value
            if strafeEnabled then startTargetStrafe() else stopTargetStrafe() end
        end
    end
})

targetStrafe:AddDropdown("环绕模式下拉框", {
    AllowNull = false,
    Text = "目标环绕模式",
    Default = "水平",
    Values = {"水平", "上方"},
    Tooltip = "选择环绕模式",
    Callback = function(value) strafeMode = value end
})

targetStrafe:AddSlider("环绕半径滑块", {
    Text = "环绕半径",
    Default = 5,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Tooltip = "设置环绕目标的移动半径",
    Callback = function(value) strafeRadius = value end
})

targetStrafe:AddSlider("环绕速度滑块", {
    Text = "环绕速度",
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 1,
    Tooltip = "设置环绕目标的移动速度",
    Callback = function(value) strafeSpeed = value end
})

game:GetService("RunService").RenderStepped:Connect(function()
    if strafeEnabled and strafeAllowed then strafeAroundTarget() end
end)

while true do
    task.wait()

    if isFunctionalityEnabled then
        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            humanoid = localPlayer.Character:FindFirstChild("Humanoid")
            
            if isSpeedActive and humanoid and humanoid.MoveDirection.Magnitude > 0 then
                local moveDirection = humanoid.MoveDirection.Unit
                localPlayer.Character.HumanoidRootPart.CFrame = localPlayer.Character.HumanoidRootPart.CFrame + moveDirection * Cmultiplier
            end

            if isFlyActive then
                local flyDirection = Vector3.zero

                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                    flyDirection = flyDirection + camera.CFrame.LookVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                    flyDirection = flyDirection - camera.CFrame.LookVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                    flyDirection = flyDirection - camera.CFrame.RightVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                    flyDirection = flyDirection + camera.CFrame.RightVector
                end

                if flyDirection.Magnitude > 0 then
                    flyDirection = flyDirection.Unit
                end

                local newPosition = localPlayer.Character.HumanoidRootPart.Position + flyDirection * flySpeed
                localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(newPosition)
                localPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            end

            if isNoClipActive then
                for _, v in pairs(localPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide then
                        v.CanCollide = false
                    end
                end
            end
        end
    end
end

ThemeManager:LoadDefaultTheme()