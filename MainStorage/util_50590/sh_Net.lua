--创建GameRemote MainStorage了没有GameRemote就一直等待直到创建  
MainStorage = game:GetService("MainStorage")
GameRemote = MainStorage:WaitForChild("GameRemote")
Players = game:GetService("Players")

 
RunService = game:GetService("RunService")
net = {}


if RunService:IsClient() then 

    function net.Fire(ident,...)
        local args = {...}
        GameRemote:FireServer(ident, unpack(args))
    end
    
    function net.Receive(ident,func)  
        net[ident] = func
    end
    
    GameRemote.OnClientNotify:Connect(function(ident, ...)
        if net[ident] then
            if not net[ident] then print("lua error : 客户端尝试调用一个不存在的net"..ident) return end
            -- table.printTable(...)
            local success, err = pcall(net[ident], ...)
            if not success then
                print(" 客户端Net尝试调用函数时发生错误 Ident='" .. ident .. "' 错误信息: " .. err)
            end

        end 
    end) 

elseif RunService:IsServer() then 

    function net.Receive(ident, func) 
        net[ident] = func
    end 

    function net.Fire(player, ident, ...)
        local args = {...}
        GameRemote:FireClient(player, ident, unpack(args))
    end

    function net.FireAllClient(ident, ...) 
        local args = {...}
        GameRemote:FireAllClients(ident, unpack(args))
    end

    GameRemote.OnServerNotify:Connect(function(player, ident, ...)
        if net[ident] then
            if not net[ident] then print("lua error : 服务端尝试调用一个不存在的net"..ident) return end

            local success, err = pcall(net[ident], Players:GetPlayerByUserId(player), ...)
            if not success then
                print(" 服务端Net尝试调用函数时发生错误 Ident='" .. ident .. "' 来自玩家 '" .. player .. "' 错误信息: " .. err)
            end

        end
    end)

end

