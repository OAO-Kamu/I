local startTime = os.clock() 
do
	local n = nil
	local tries = 0
	repeat
		tries += 1
		local s, r = pcall(function()
			return loadstring(game:HttpGet("https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/NamelessAdminNotifications.lua"))()
		end)
		if s and type(r) == "table" and type(r.Notify) == "function" then
			n = r
			notifMod = r
			nt = r.Notify
		else
			task.wait(0.5)
		end
	until n ~= nil or tries >= 5
end

local function notify(info)
	if not nt or type(info) ~= "table" then
		return
	end
	pcall(function()
		nt(info)
	end)
end

notify({
	Title = "📌 | 脚本已响应",
	Description = "⏱️ | 开始加载 [计时已启用]",
	Duration = 4,
})
wait(4)



local v1 = game:GetService("Players").LocalPlayer
local function v4(p2)
    local v3 = p2:WaitForChild("Humanoid")
    v3:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    v3:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
end
v1.CharacterAdded:Connect(v4)
if v1.Character then
    v4(v1.Character)
end

local v5 = workspace:FindFirstChild("ItemFolder")
if not v5 then
    local v6, v7, v8 = pairs(workspace:GetDescendants())
    while true do
        local v9
        v8, v9 = v6(v7, v8)
        if v8 == nil then
            break
        end
        if v9.Name == "ItemPickupScript" or v9.Name == "NewItemPickupScript" then
            v5 = v9.Parent.Parent
            break
        end
    end
end

if v5 then
    v5.Name = "ItemFolder1"
end

local Starlight = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/starlight"))()  
local NebulaIcons = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/nebula-icon-library-loader"))()

local Window = Starlight:CreateWindow({
    Name = "SLDK-Piggy 1RH",
    Subtitle = "v2.6.22 - 小猪[Piggy] | 开源库: https://Github.com/OAO-Kamu/I/",
    Icon = 1234567890,

    LoadingSettings = {
        Title = "Loading...",
        Subtitle = "Welcome to SLDK-kamu script",
    },

    FileSettings = {
        ConfigFolder = "dpiggyd"
    },
})
local As = Window:CreateTabSection("Piggy features")

local Dialog = Window:PromptDialog({
    Name = "欢迎使用 SLDK-Piggy",
    Content = "我们还推出更多有趣脚本",
    Type = 2,
    Actions = { 
        Primary = {
            Name = "好的!",
            Icon = NebulaIcons:GetIcon("check", "Material"),
            Callback = function()

            end
        }, 
        {
            Name = "关闭",
            Callback = function()
                
            end
        },
    }
})
local M = As:CreateTab({
    Name = "Main | 主要",
    Icon = NebulaIcons:GetIcon('book'),
    Columns = 2,
}, "INDEX")

local P = M:CreateGroupbox({
    Name = "玩家",
    Column = 1,
}, "INDEX")

local F = M:CreateGroupbox({
    Name = "地图",
    Column = 2,
}, "INDEX")

local Toggle = P:CreateToggle({
    Name = "无敌",
    CurrentValue = false,
    Style = 2,
    Callback = function(p23)
        if p23 then
            _G.Clicker = true
            while _G.Clicker == true do
                local v24 = workspace:GetDescendants()
                local v25, v26, v27 = ipairs(v24)
                while true do
                    local v28
                    v27, v28 = v25(v26, v27)
                    if v27 == nil then
                        break
                    end
                    if v28:FindFirstChild("Enemy") and (v28:FindFirstChild("HumanoidRootPart") and not v28:FindFirstChild("ToolRequired")) then
                        local v29, v30, v31 = ipairs(v28:GetDescendants())
                        while true do
                            local v32
                            v31, v32 = v29(v30, v31)
                            if v31 == nil then
                                break
                            end
                            if v32:IsA("TouchTransmitter") then
                                v32:Remove()
                                local v33, v34, v35 = ipairs(v28:GetDescendants())
                                while true do
                                    local v36
                                    v35, v36 = v33(v34, v35)
                                    if v35 == nil then
                                        break
                                    end
                                    if v36:IsA("Script") then
                                        v36:Remove()
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        else
            _G.Clicker = false
        end
    end,
}, "INDEX")

local Toggle = P:CreateToggle({
    Name = "没有碰撞箱",
    CurrentValue = false,
    Style = 2,
    Callback = function(p50)
        if p50 then
            _G.Clicker = true
            while _G.Clicker == true do
                if Game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("CrouchBlocker") then
                    Game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("CrouchBlocker"):Remove()
                end
                task.wait(3)
            end
        else
            _G.Clicker = false
        end
    end,
}, "INDEX")

local Toggle = F:CreateToggle({
    Name = "删除陷阱",
    CurrentValue = false,
    Style = 2,
    Callback = function(p87)
        if p87 then
            _G.Clicker = true
            while _G.Clicker == true do
                local v88 = workspace:GetDescendants()
                local v89, v90, v91 = pairs(v88)
                while true do
                    local v92
                    v91, v92 = v89(v90, v91)
                    if v91 == nil then
                        break
                    end
                    if v92:IsA("Script") and (v92.Name == "BlackHoleScript" or (v92.Name == "PumpScript" or v92.Name == "ConcoctionScript")) then
                        local v93 = v92.Parent
                        local v94 = v93.Parent
                        if string.find(v93.Name, "Trap") or string.find(v94.Name, "Trap") then
                            v92.Disabled = true
                            local v95, v96, v97 = pairs(v93:GetDescendants())
                            while true do
                                local v98
                                v97, v98 = v95(v96, v97)
                                if v97 == nil then
                                    break
                                end
                                if v98:IsA("TouchTransmitter") then
                                    v98:Remove()
                                end
                            end
                            local v99, v100, v101 = pairs(v94:GetDescendants())
                            while true do
                                local v102
                                v101, v102 = v99(v100, v101)
                                if v101 == nil then
                                    break
                                end
                                if v102:IsA("TouchTransmitter") then
                                    v102:Remove()
                                end
                            end
                        end
                        if v92.Name == "CrawlTrap" and v92:FindFirstChild("HumanoidRootPart") then
                            v92:FindFirstChild("Humanoid").Health = - 9
                        end
                    end
                end
                wait(0.5)
            end
        else
            _G.Clicker = false
        end
    end,
}, "INDEX")

local Toggle = F:CreateToggle({
    Name = "开关所有门",
    CurrentValue = false,
    Style = 2,
    Callback = function(p367)
        if p367 then
            _G.Clicker = true
            while _G.Clicker == true do
                local vu368 = "rbxassetid://320946744";
                (function()
                    local v369 = game:GetService("Workspace")
                    local v370, v371, v372 = ipairs(v369:GetDescendants())
                    local v373 = false
                    while true do
                        local v374
                        v372, v374 = v370(v371, v372)
                        if v372 == nil then
                            break
                        end
                        if v374:IsA("Sound") and v374.SoundId == vu368 then
                            local v375 = v374.Parent:FindFirstChildOfClass("ClickDetector")
                            if v375 then
                                fireclickdetector(v375)
                                v373 = true
                            end
                        end
                    end
                    if not v373 then
                        local v376, v377, v378 = ipairs(v369:GetDescendants())
                        while true do
                            local v379
                            v378, v379 = v376(v377, v378)
                            if v378 == nil then
                                break
                            end
                            if v379:IsA("RemoteEvent") then
                                local v380 = v379.Parent
                                local v381 = v380:FindFirstChildOfClass("ClickDetector")
                                if v381 and v380:FindFirstChildOfClass("WeldConstraint") then
                                    fireclickdetector(v381)
                                end
                            end
                        end
                    end
                end)()
                wait(0.5)
            end
        else
            _G.Clicker = false
        end
    end,
}, "INDEX")

local Toggle = F:CreateToggle({
    Name = "卡住Piggy机器人",
    CurrentValue = false,
    Style = 2,
    Callback = function(p354)
        if p354 then
            if not workspace.PiggyNPC:FindFirstChildOfClass("Model") then
                return
            end
            workspace.PiggyNPC:FindFirstChildOfClass("Model"):FindFirstChild("Humanoid").PlatformStand = true
        else
            workspace.PiggyNPC:FindFirstChildOfClass("Model"):FindFirstChild("Humanoid").PlatformStand = false
        end
    end,
}, "INDEX")
local E = As:CreateTab({
    Name = "ESP | 透视",
    Icon = NebulaIcons:GetIcon('book'),
    Columns = 2,
}, "INDEX")

local PT = E:CreateGroupbox({
    Name = "玩家",
    Column = 1,
}, "INDEX")

local B = E:CreateGroupbox({
    Name = "机器人",
    Column = 2,
}, "INDEX")
local Toggle = B:CreateToggle({
    Name = "透视机器人",
    CurrentValue = false,
    Style = 2,
    Callback = function(p382)
        if p382 then
            _G.Clicker = true
            while _G.Clicker do
                local v383, v384, v385 = ipairs(workspace:GetDescendants())
                while true do
                    local v386
                    v385, v386 = v383(v384, v385)
                    if v385 == nil then
                        break
                    end
                    if v386:FindFirstChild("Enemy") and (not v386:FindFirstChild("CHICKEN2") and (not v386:FindFirstChild("ToolRequired") and v386 ~= game.Players.LocalPlayer.Character)) then
                        if v386:FindFirstChild("CharacterModel") and v386:FindFirstChild("CharacterModel"):FindFirstChildOfClass("Highlight") then
                            v386:FindFirstChild("CharacterModel"):FindFirstChildOfClass("Highlight"):Remove()
                        end
                        local v387 = Instance.new("Highlight")
                        v387.Adornee = v386
                        v387.Name = "CHICKEN2"
                        v387.FillTransparency = 0.5
                        v387.OutlineColor = Color3.fromRGB(255, 255, 255)
                        v387.OutlineTransparency = 0.5
                        if v386.Parent.Name ~= "PiggyNPC" then
                            v387.FillColor = Color3.fromRGB(255, 0, 0)
                        else
                            v387.FillColor = Color3.fromRGB(0, 0, 255)
                        end
                        v387.Parent = v386
                    end
                end
                task.wait(0.5)
            end
        else
            local v388, v389, v390 = ipairs(workspace:GetDescendants())
            while true do
                local v391
                v390, v391 = v388(v389, v390)
                if v390 == nil then
                    break
                end
                if v391.Name == "CHICKEN2" then
                    v391:Destroy()
                end
            end
            _G.Clicker = false
        end
    end,
}, "INDEX")

local Toggle = B:CreateToggle({
    Name = "透视其他机器人",
    CurrentValue = false,
    Style = 2,
    Callback = function(p392)
        if p392 then
            _G.Clicker = true
            while _G.Clicker == true do
                local v393 = workspace:GetDescendants()
                local v394, v395, v396 = ipairs(v393)
                while true do
                    local v397
                    v396, v397 = v394(v395, v396)
                    if v396 == nil then
                        break
                    end
                    if v397:FindFirstChild("Enemy") and (v397:FindFirstChild("HumanoidRootPart") and (v397:FindFirstChild("ToolRequired") and not v397:FindFirstChild("CHICKEN"))) then
                        local v398 = Instance.new("Highlight")
                        v398.Adornee = v397
                        v398.Name = "CHICKEN"
                        v398.FillColor = Color3.fromRGB(0, 255, 0)
                        v398.FillTransparency = 0.5
                        v398.OutlineColor = Color3.fromRGB(255, 255, 255)
                        v398.OutlineTransparency = 0.5
                        v398.Parent = v397
                    end
                end
                task.wait(0.5)
            end
        else
            _G.Clicker = false
            local v399 = workspace:GetDescendants()
            local v400, v401, v402 = ipairs(v399)
            while true do
                local v403
                v402, v403 = v400(v401, v402)
                if v402 == nil then
                    break
                end
                if v403:FindFirstChild("Enemy") and (v403:FindFirstChild("HumanoidRootPart") and (v403:FindFirstChild("ToolRequired") and v403:FindFirstChild("CHICKEN"))) then
                    v403:FindFirstChild("CHICKEN"):Remove()
                end
            end
        end
    end,
}, "INDEX")

local Toggle = PT:CreateToggle({
    Name = "透视物品",
    CurrentValue = false,
    Style = 2,
    Callback = function(p404)
        if p404 then
            _G.Clicker = true
            while _G.Clicker == true do
                local v405, v406, v407 = pairs(game.Workspace.ItemFolder1:GetDescendants())
                while true do
                    local v408
                    v407, v408 = v405(v406, v407)
                    if v407 == nil then
                        break
                    end
                    if v408.Name == "NewItemPickupScript" or v408.Name == "ItemPickupScript" or v408.Name == "Script" and (v408.Parent.Parent:IsA("Folder") and not v408.Parent:FindFirstChildOfClass("Sound")) then
                        local v409 = v408.Parent
                        local v410 = v409:FindFirstChildOfClass("BillboardGui")
                        v409:FindFirstChildOfClass("Highlight")
                        if not v410 then
                            local v411 = Instance.new("BillboardGui")
                            v411.Size = UDim2.new(4, 0, 1.5, 0)
                            v411.AlwaysOnTop = true
                            v411.Adornee = v409
                            v411.StudsOffset = Vector3.new(0, 3, 0)
                            v411.MaxDistance = 1000
                            v411.Parent = v409
                            local v412 = Instance.new("Frame")
                            v412.Size = UDim2.new(1, 0, 1, 0)
                            v412.BackgroundTransparency = 1
                            v412.Parent = v411
                            local v413 = Instance.new("TextLabel")
                            if string.match(v408.Parent.Name, "%d") then
                                v413.Text = "I"
                            else
                                v413.Text = v409.Name
                            end
                            v413.Size = UDim2.new(1, 0, 1, 0)
                            v413.BackgroundTransparency = 1
                            v413.Font = Enum.Font.SourceSansBold
                            v413.TextColor3 = Color3.new(1, 1, 1)
                            v413.TextStrokeColor3 = Color3.new(0, 0, 0)
                            v413.TextStrokeTransparency = 0.5
                            v413.TextSize = 12
                            v413.TextScaled = true
                            v413.Parent = v412
                            local v414 = Instance.new("Highlight")
                            if v409:FindFirstChildOfClass("ParticleEmitter") then
                                v414.FillColor = v409:FindFirstChildOfClass("ParticleEmitter").Color.Keypoints[1].Value
                            else
                                v414.FillColor = Color3.fromRGB(0, 255, 0)
                            end
                            v414.OutlineColor = Color3.new(1, 1, 1)
                            v414.FillTransparency = 0.6
                            v414.OutlineTransparency = 0.3
                            v414.Adornee = v409
                            v414.Parent = v409
                        end
                    end
                end
                task.wait(1)
            end
        else
            _G.Clicker = false
            local v415 = workspace:GetDescendants()
            local v416, v417, v418 = pairs(v415)
            while true do
                local v419
                v418, v419 = v416(v417, v418)
                if v418 == nil then
                    break
                end
                if v419.Name == "NewItemPickupScript" or v419.Name == "ItemPickupScript" or v419.Name == "Script" and (v419.Parent.Parent:IsA("Folder") and not v419.Parent:FindFirstChildOfClass("Sound")) then
                    local v420 = v419.Parent
                    v420:FindFirstChildOfClass("Highlight"):Remove()
                    v420:FindFirstChildOfClass("BillboardGui"):Remove()
                end
            end
        end
    end,
}, "INDEX")

local Toggle = PT:CreateToggle({
    Name = "透视玩家",
    CurrentValue = false,
    Style = 2,
    Callback = function(p435)
        if p435 then
            local v436 = game:GetService("Players")
            local _ = v436.LocalPlayer
            _G.Clicker = true
            while _G.Clicker == true do
                local v437, v438, v439 = ipairs(v436:GetPlayers())
                while true do
                    local v440
                    v439, v440 = v437(v438, v439)
                    if v439 == nil then
                        break
                    end
                    if v440 ~= game.Players.LocalPlayer and v440.Character and not v440.Character:FindFirstChild("Enemy") then
                        local v441 = v440.Character
                        if (v441.HumanoidRootPart.Position - workspace.GameFolder.MainSpawn.Position).Magnitude < 20 then
                            if existingHighlight then
                                existingHighlight:Remove()
                            end
                        elseif not v441:FindFirstChildOfClass("Highlight") then
                            local v442 = Instance.new("Highlight")
                            v442.Adornee = v441
                            v442.FillColor = Color3.fromRGB(0, 255, 255)
                            v442.FillTransparency = 0.5
                            v442.OutlineColor = Color3.fromRGB(255, 255, 255)
                            v442.OutlineTransparency = 0.5
                            v442.Parent = v441
                        end
                    end
                end
                wait(1)
            end
        else
            _G.Clicker = false
            local v443 = game:GetService("Players")
            local v444, v445, v446 = ipairs(v443:GetPlayers())
            while true do
                local v447
                v446, v447 = v444(v445, v446)
                if v446 == nil then
                    break
                end
                local v448 = v447.Character
                if v448 and (v448.HumanoidRootPart.Position - workspace.GameFolder.MainSpawn.Position).Magnitude >= 20 then
                    local v449 = v448:FindFirstChildOfClass("Highlight")
                    if v449 then
                        v449:Remove()
                    end
                end
            end
        end
    end,
}, "INDEX")

local Toggle = PT:CreateToggle({
    Name = "透视判徒",
    CurrentValue = false,
    Style = 2,
    Callback = function(p450)
        if p450 then
            _G.Clicker = true
            while _G.Clicker == true do
                local v451 = game:GetService("Players")
                local v452, v453, v454 = ipairs(v451:GetPlayers())
                while true do
                    local v455
                    v454, v455 = v452(v453, v454)
                    if v454 == nil then
                        break
                    end
                    local v456 = v455.Character
                    if v456:FindFirstChild("Traitor") and not (v456:FindFirstChildOfClass("Highlight") or v456:FindFirstChildOfClass("BillboardGui")) then
                        local v457 = Instance.new("BillboardGui")
                        v457.Size = UDim2.new(0, 100, 0, 50)
                        v457.AlwaysOnTop = true
                        v457.Adornee = v456.PrimaryPart or v456:FindFirstChildWhichIsA("Part")
                        v457.Name = v455.DisplayName
                        v457.Parent = v456
                        v457.StudsOffset = Vector3.new(0, 3.5, 0)
                        local v458 = Instance.new("Frame", v457)
                        v458.Size = UDim2.new(1, 0, 1, 0)
                        v458.BackgroundTransparency = 1
                        v458.BorderSizePixel = 0
                        local v459 = Instance.new("TextLabel", v458)
                        v459.Text = v455.DisplayName
                        v459.Size = UDim2.new(1, 0, 1, 0)
                        v459.BackgroundTransparency = 1
                        v459.BorderSizePixel = 0
                        v459.TextColor3 = Color3.fromRGB(255, 255, 255)
                        v459.TextStrokeTransparency = 0.5
                        v459.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        v459.TextSize = 5
                        local v460 = Instance.new("Highlight")
                        v460.Adornee = v456
                        v460.FillColor = Color3.fromRGB(255, 140, 0)
                        v460.FillTransparency = 0.5
                        v460.OutlineColor = Color3.fromRGB(255, 255, 255)
                        v460.OutlineTransparency = 0.5
                        v460.Parent = v456
                    end
                end
                wait(1)
            end
        else
            _G.Clicker = false
            local v461 = game:GetService("Players")
            local v462, v463, v464 = ipairs(v461:GetPlayers())
            while true do
                local v465
                v464, v465 = v462(v463, v464)
                if v464 == nil then
                    break
                end
                local v466 = v465.Character
                if v466:FindFirstChild("Traitor") then
                    local v467 = v466:FindFirstChildOfClass("Highlight")
                    if v467 then
                        v467:Remove()
                    end
                    local v468 = v466:FindFirstChildOfClass("BillboardGui")
                    if v468 then
                        v468:Remove()
                    end
                end
            end
        end
    end,
}, "INDEX")
local Toggle = PT:CreateToggle({
    Name = "透视陷阱",
    CurrentValue = false,
    Style = 2,
    Callback = function(p421)
        if p421 then
            _G.Clicker = true
            while _G.Clicker == true do
                local v422 = workspace.ItemFolder1:GetDescendants()
                local v423, v424, v425 = pairs(v422)
                while true do
                    local v426
                    v425, v426 = v423(v424, v425)
                    if v425 == nil then
                        break
                    end
                    if v426:IsA("Sound") then
                        local v427 = v426.Parent
                        local v428 = v427.Parent
                        if string.find(v427.Name, "Trap") then
                            local v429 = Instance.new("Highlight")
                            v429.Name = "CHICKEN4"
                            v429.FillTransparency = 0.5
                            Color3.fromRGB(0, 0, 0)
                            v429.OutlineTransparency = 0.5
                            v429.FillColor = Color3.fromRGB(255, 255, 255)
                            v429.Parent = v427
                            v429.Adornee = v427
                        elseif string.find(v428.Name, "Trap") then
                            local v430 = Instance.new("Highlight")
                            v430.Name = "CHICKEN4"
                            v430.FillTransparency = 0.5
                            v430.OutlineColor = Color3.fromRGB(0, 0, 0)
                            v430.OutlineTransparency = 0.5
                            v430.FillColor = Color3.fromRGB(255, 255, 255)
                            v430.Parent = v428
                            v430.Adornee = v428
                        end
                    end
                end
                task.wait(1.5)
            end
        else
            _G.Clicker = false
            local v431, v432, v433 = workspace.ItemFolder1:GetDescendants()
            while true do
                local v434
                v433, v434 = v431(v432, v433)
                if v433 == nil then
                    break
                end
                if v434.Name == "CHICKEN4" then
                    v434:Remove()
                end
            end
        end
    end,
}, "INDEX")
local O = As:CreateTab({
    Name = "Other | 其他",
    Icon = NebulaIcons:GetIcon('book'),
    Columns = 2,
}, "INDEX")

local T = O:CreateGroupbox({
    Name = "传送",
    Column = 1,
}, "INDEX")

local A = O:CreateGroupbox({
    Name = "自动",
    Column = 2,
}, "INDEX")

local Toggle = A:CreateToggle({
    Name = "自动蓝图",
    CurrentValue = false,
    Style = 2,
    Callback = function(p594)
        if p594 then
            _G.Clicker = true
            local v595 = {
                "http://www.roblox.com/asset/?id=60791940",
                "rbxassetid://60791940",
                "60791940"
            }
            while _G.Clicker do
                local v596 = game:GetService("Players").LocalPlayer
                local v597 = (v596.Character or v596.CharacterAdded:Wait()).HumanoidRootPart
                local v598, v599, v600 = ipairs(workspace:GetDescendants())
                local v601 = false
                while true do
                    local v602
                    v600, v602 = v598(v599, v600)
                    if v600 == nil then
                        break
                    end
                    if v602:IsA("Part") then
                        local v603 = v602:FindFirstChildOfClass("ClickDetector")
                        if v603 then
                            local v604, v605, v606 = ipairs(v602:GetChildren())
                            while true do
                                local v607
                                v606, v607 = v604(v605, v606)
                                if v606 == nil then
                                    break
                                end
                                if v607:IsA("SpecialMesh") then
                                    local v608, v609, v610 = ipairs(v595)
                                    while true do
                                        local v611
                                        v610, v611 = v608(v609, v610)
                                        if v610 == nil then
                                            break
                                        end
                                        if tostring(v607.MeshId):find(v611, 1, true) then
                                            local v612 = v597.CFrame
                                            v597.CFrame = v602.CFrame * CFrame.new(0, 3, 0)
                                            task.wait(0.2)
                                            fireclickdetector(v603)
                                            task.wait(0.3)
                                            v597.CFrame = v612
                                            v601 = true
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if v601 then
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "找!",
                        Text = "Ez",
                        Icon = "https://roblox.com/asset/?id=126985084896106",
                        Duration = 7,
                        Button1 = "OK EZ"
                    })
                end
                task.wait(2)
            end
        else
            _G.Clicker = false
        end
    end,
}, "INDEX")

local Toggle = A:CreateToggle({
    Name = "自动点击",
    CurrentValue = false,
    Style = 2,
    Callback = function(p613)
        if p613 then
            _G.Clicker = true
            while _G.Clicker == true do
                local vu614 = "rbxassetid://6714051581"
                local v615 = game.Players.LocalPlayer
                local vu616 = (v615.Character or v615.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
                Vector3.new(255, 255, 255)
                if (function()
                    local v617 = workspace:GetDescendants()
                    local v618, v619, v620 = ipairs(v617)
                    local v621 = false
                    while true do
                        local v622
                        v620, v622 = v618(v619, v620)
                        if v620 == nil then
                            break
                        end
                        if v622:IsA("Part") then
                            local v623 = v622:FindFirstChildOfClass("ClickDetector")
                            v622:FindFirstChildOfClass("TouchTransmitter")
                            local v624, v625, v626 = ipairs(v622:GetChildren())
                            while true do
                                local v627
                                v626, v627 = v624(v625, v626)
                                if v626 == nil then
                                    break
                                end
                                if v627:IsA("SpecialMesh") and v627.MeshId == vu614 then
                                    local v628 = vu616.CFrame
                                    vu616.CFrame = v622.CFrame + Vector3.new(0, 3, 0)
                                    wait(0.2)
                                    fireclickdetector(v623)
                                    wait(0.3)
                                    vu616.CFrame = v628
                                    v621 = true
                                end
                            end
                        end
                    end
                    return v621
                end)() then
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "!!",
                        Text = "!!",
                        Icon = "https://roblox.com/asset/?id=126985084896106",
                        Duration = 7,
                        Button1 = "OK !!"
                    })
                end
                task.wait(2)
            end
        else
            _G.Clicker = false
        end
    end,
}, "INDEX")

local Button = T:CreateButton({
    Name = "传送逃离处",
    Icon = NebulaIcons:GetIcon('check', 'Material'),
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(184.999969, 17.5, - 98, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    end,
}, "INDEX")
local Button = T:CreateButton({
    Name = "传送玩家等待大厅",
    Icon = NebulaIcons:GetIcon('check', 'Material'),
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(- 462.430878, - 26.8999672, - 92.9122467, 0.958247006, - 1.92621847e-8, 0.28594166, 4.32109672e-8, 1, - 7.74444473e-8, - 0.28594166, 8.65667289e-8, 0.958247006)
 
    end,
}, "INDEX")
local Button = T:CreateButton({
    Name = "传送 piggy 等待大厅",
    Icon = NebulaIcons:GetIcon('check', 'Material'),
    Callback = function()
        Game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(- 368.912445, - 3.70697975, - 88.2102509, - 0.177849829, - 6.23116847e-8, - 0.984057665, 8.68930528e-8, 1, - 7.90254475e-8, 0.984057665, - 9.95624347e-8, - 0.177849829)
  
    end,
}, "INDEX")
local Button = T:CreateButton({
    Name = "传送大厅背景",
    Icon = NebulaIcons:GetIcon('check', 'Material'),
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(- 458.074951, - 9.62249565, 8.91219902, 0.998103261, 2.76764887e-8, - 0.0615624413, - 3.36117942e-8, 1, - 9.53755759e-8, 0.0615624413, 9.72638929e-8, 0.998103261)
        wait(0.1)
        local v629 = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        local v630 = Vector3.new(0, - 15, 0)
        local v631 = RaycastParams.new()
        v631.FilterDescendantsInstances = {
            game.Players.LocalPlayer.Character
        }
        v631.FilterType = Enum.RaycastFilterType.Blacklist
        local v632 = workspace:Raycast(v629, v630, v631)
        if v632 then
            local v633 = v632.Instance
            if v633 and (v633:IsA("Part") and not v633.CanCollide) then
                v633.CanCollide = true
            end
        end
    end,
}, "INDEX")

wait(3.666917813)
local loadTime = os.clock() - startTime
notify({
	Title = "✅ | 加载完成",
	Description = string.format("⌛️ | 加载耗时: %.3f 秒", loadTime),
	Duration = 4,
})