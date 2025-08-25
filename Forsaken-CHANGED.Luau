
local L = loadstring or load
local GitHub = "https://raw.github.com/OAO-Kamu/"
local ID = GitHub .. "I/main/"
local Noti = GitHub .. "UI-Library-Interface/refs/heads/main/%E9%80%9A%E7%9F%A5.lua"
local notifs = loadstring(game:HttpGet(Noti))()
local Compkiller = L(game:HttpGet("https://raw.githubusercontent.com/4lpaca-pin/CompKiller/refs/heads/main/src/source.luau"))();
local Notifier = Compkiller.newNotify();
local url = "https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"
local MacLib = L(game:HttpGet(url))()

local ConfigManager = Compkiller:ConfigManager({
        Directory = "Compkiller-UI",
        Config = "Example-Configs"
});
local Window = MacLib:Window({
    Title = "",
    Subtitle = "",
    Size = UDim2.fromOffset(0, 0), --宽,长
    DragStyle = 0,
    DisabledWindowControls = {},
    ShowUserInfo = false,
    Keybind = Enum.KeyCode.RightControl,
    AcrylicBlur = false,
})

Window:Dialog({
    Title = "CHANGED HUB | 引导界面",
    Description = "封号或者是被封服务器我们概不负责!",
    Buttons = {
        {
            Name = "我知道",
            Callback = function()
                MacLib:Destroy()
                    getgenv().Games = {
                  [18687417158] = ID .. "A.Luau",--Forsaken
                }
                local id = game.PlaceId
                local url = getgenv().Games[id]
                if url then
                   Compkiller:Loader("rbxassetid://120245531583106" , 5.698745).yield();
                   L(game:HttpGet(url))()
                end
                local ulr = ID .. "A.Lua"
                if not url then
                    Notifier.new({
                                    Title = "你这服务器是啥呀, 脚本不支持这个服务器",
                                    Content = "看源码就可知道支持什么服务器",
                                    Duration = 60,
                                    Icon = "rbxassetid://120245531583106"
                        });
                    L(game:HttpGet(ulr, true))()
                end
            end,
        },
        {
            Name = "别管了"
            Callback = function()
              MacLib:Destroy()
            end
        }
    }
})