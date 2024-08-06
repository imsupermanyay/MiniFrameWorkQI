--创建GameRemote MainStorage了没有GameRemote就一直等待直到创建  
MainStorage = game:GetService("MainStorage")
GameRemote = MainStorage:WaitForChild("GameRemote")
Players = game:GetService("Players")
CloudService = game:GetService("CloudService")
RunService = game:GetService("RunService")
PlayerSqlData = {}

local dataname = "_PlayerSqlData_"
sqldata = {}


if RunService:IsClient() then 
    local IsFrist = true
------------------------[[ 网络传输 ]]------------------------
    function sqldata.RequestSqlDataToServer()
        net.Fire("SqlData_RequestSqlDataServer") 
    end

    --返回玩家数据
    net.Receive("SqlData_RequestSqlDataServer",function (m_data,plyuserid)
        PlayerSqlData = m_data
        if IsFrist then  --第一次拿玩家数据
            hook.Run("PlayerSqlDataInit",plyuserid)
            IsFrist = false
        end
    end) 

elseif RunService:IsServer() then 
 
    function sqldata.InitSqlData(playerid,key,sqldata) 
        if not PlayerSqlData[playerid][key] then
            PlayerSqlData[playerid][key] = sqldata 
        end
    end
    function sqldata.SetSqlData(playerid,key,sqldata) 
        PlayerSqlData[playerid][key] = sqldata
    end 
    function sqldata.GetSqlData(playerid,key)
        return PlayerSqlData[playerid][key]
    end
    function sqldata.SyncSqlDataToPlayer(ply)
        net.Fire(ply.UserId,"SqlData_RequestSqlDataServer",PlayerSqlData[ply.UserId],ply.UserId)
    end
------------------------[[ 网络传输 ]]------------------------ 
    --服务器收到同步此玩家在SERVER中的数据请求 
    net.Receive("SqlData_RequestSqlDataServer", function(ply)
        sqldata.SyncSqlDataToPlayer(ply)
    end)     

    -- --服务器收到 从sql拉取此玩家数据请求           
    -- net.Receive("RequestSQLSqlDataToServer", function(ply)

    -- end)


------------------------[[ 逻辑处理 ]]------------------------
    --玩家离开时保存所有玩家数据
    hook.Add("PlayerLeaveServer","SqlData_PlayerLeaveServer",function (player)
        local playerid = player.UserId
        CloudService:SetTableAsync(tostring(playerid)..dataname,PlayerSqlData[playerid], function (code)
             if not code then
                print("设置Table时失败,玩家数据可能会丢失"..tostring(code))
             end
        end) 
    end)
    --玩家加入服务器初始化数据   
    hook.Add("PlayerJoinServer","SqlData_PlayerJoinServer",function (player)
        local playerid = player.UserId
        CloudService:GetTableAsync(tostring(playerid)..dataname, function (code,value)
            if not code then
                print("进入服务器时设置数据失败"..tostring(code))
                PlayerSqlData[playerid]= {}
            else
                PlayerSqlData[playerid] = value
            end
            sqldata.SyncSqlDataToPlayer(player)
            hook.Run("PlayerSqlDataInit",player)
       end)
    end)

end

