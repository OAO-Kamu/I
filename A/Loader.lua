local L = loadstring or load
local Lib = "https://raw.github.com/OAO-Kamu/UI-Library-Interface/main/SP%20LibraryMain.lua"
local splib = L(game:HttpGet(Lib))()

local Window = splib:MakeWindow({
 Name = "CHANGED HUB  | Loader",
 HidePremium = false,
 SaveConfig = false,
 Setting = true,
 ToggleIcon = "rbxassetid://82795327169782",
 ConfigFolder = "",
 CloseCallback = true
})

MainTab = Window:MakeTab({
  IsMobile = true,
  Name = "主游戏",
  Icon = "rbxassetid://4483345998"
})
--MainTab:AddButton({  这是示例不要管
--    Name = "Button",  这是示例不要管
--    Desc = "What?",  这是示例不要管
--    Callback = function()  这是示例不要管
--        print("button pressed")  这是示例不要管
--    end  这是示例不要管
--})  这是示例不要管
MainTab:AddButton({
    Name = "🟢 | 被遗弃",
    Desc = "CHANGED 不开源脚本: 被遗弃",
    Callback = function()
        local L = loadstring or load
        local ID = "https://raw.github.com/OAO-Kamu/I/main/A/fask.lua"
        L(game:HttpGet(ID))()
    end
})
MainTab:AddButton({
    Name = "🟢 | 暴力区",
    Desc = "CHANGED 开源脚本: 暴力区",
    Callback = function()
        local L = loadstring or load
        local ID = "https://raw.github.com/OAO-Kamu/I/main/A/ASII.lua"
        L(game:HttpGet(ID))()
    end
})
MainTab:AddButton({
    Name = "🟢 | Piggy",
    Desc = "CHANGED 不开源脚本: Piggy",
    Callback = function()
        local L = loadstring or load
        local ID = "https://raw.github.com/OAO-Kamu/I/main/A/Piggy.lua"
        L(game:HttpGet(ID))()
    end
})

Tab = Window:MakeTab({
  IsMobile = true,
  Name = "汉化游戏",
  Icon = "rbxassetid://4483345998"
})
Tab:AddButton({
    Name = "🟢 | 兵工厂",
    Desc = "CHANGED 汉化开源脚本: 兵工厂",
    Callback = function()
        local L = loadstring or load
        local ID = "https://raw.github.com/OAO-Kamu/I/main/A/Arsenal.lua"
        L(game:HttpGet(ID))()
    end
})
Tab:AddButton({
    Name = "🟢 | 摔断骨头",
    Desc = "CHANGED 汉化开源脚本: 摔断骨头",
    Callback = function()
        local L = loadstring or load
        local ID = "https://raw.github.com/OAO-Kamu/I/main/A/Broken%20Bone.lua"
        L(game:HttpGet(ID))()
    end
})
Tab:AddButton({
    Name = "🟢 | WW1",
    Desc = "CHANGED 汉化开源脚本: 蒂固根深 WW1",
    Callback = function()
    
    end
})

StateTab = Window:MakeTab({
  IsMobile = true,
  Name = "脚本详细状态",
  Icon = "rbxassetid://4483345998"
})
StateTab:AddSection({
  Name = "CHANGED 脚本工作状态: "
})
StateTab:AddSection({
  Name = "🔴 | 已下线: 3/13"
})
StateTab:AddSection({
  Name = "🟡 | 制作中: 2/13"
})
StateTab:AddSection({
  Name = "🟢 | 运行中: 8/13"
})
StateTab:AddLabel("🟢WORK |  被遗弃")
StateTab:AddLabel("🟢WORK |  Piggy")
StateTab:AddLabel("🟢WORK |  Loader")
StateTab:AddLabel("🟢WORK |  帝固根深 WW1")
StateTab:AddLabel("🟢WORK |  XOR Obf")
StateTab:AddLabel("🟢WORK |  暴力区")
StateTab:AddLabel("🟢WORK |  兵工厂(汉化)")
StateTab:AddLabel("🟢WORK |  GL-Link <==GL-X HUB的API")
StateTab:AddLabel("🟢WORK |  通用脚本 ")
StateTab:AddLabel("🟡MAKEING |  后悔电梯")
StateTab:AddLabel("🟡MAKEING |  The Rake")
StateTab:AddLabel("🔴TAPEOUT |  刀刃球")
StateTab:AddLabel("🔴TAPEOUT |  Into The Abyss")
StateTab:AddLabel("🔴TAPEOUT |  MM2")
