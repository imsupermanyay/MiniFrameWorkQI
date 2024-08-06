MainStorage = game:GetService("MainStorage")
PrintRemote = MainStorage:WaitForChild("PrintRemote")
Players = game:GetService("Players")
localPlayer = Players.LocalPlayer
--导入所有config
for key, file in pairs(MainStorage.config.Children) do
    if #file.Children <= 0 then
        require(file)
    end
end 

--初始化打印
    local origin = print
    print = function(...)
        origin("[CLIENT]  ",...)
    end 


--远程打印
    PrintRemote.OnClientNotify:Connect(function(text)
        origin("[SV_RELAY]  "..text)
    end)

 
--自动加载脚本
    local function getPriority(name)
        return ExecutesQueue[name] or DefaultQueueValue -- 如果没有找到优先级，默认为0
    end
    local function load(node) 
        local itemsToLoad = {}

        for _, child in ipairs(node.Children) do
            if #child.Children > 0 then
                load(child)
            end
            
            local scriptName = child.Name
            local prefix = string.sub(scriptName, 1, 3)

            -- 如果是需要加载的前缀，则将其添加到待加载列表
            if prefix == "sh_" or prefix == "cl_" then
                table.insert(itemsToLoad, child)
            end  
        end
 
        -- 根据优先级排序
        table.sort(itemsToLoad, function(a, b)
            return getPriority(a.Name) > getPriority(b.Name)
        end)

        -- 加载排序后的脚本
        for _, item in ipairs(itemsToLoad) do
            print("Load : " .. item.Name)
            require(item)
        end
    end 
 
    
    load(MainStorage) 
    print("==========> 客户端所有加载完毕 <==========")
    print("服务端LUA版本为",_VERSION)

 

    net.Receive("PlayerLeaveServerNet",function (ply)
        hook.Run("PlayerLeaveServer",ply)
    end)    
    net.Receive("PlayerJoinServerNet",function (ply)
        hook.Run("PlayerJoinServer",ply)
    end)





