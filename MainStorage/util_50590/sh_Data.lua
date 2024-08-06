--创建GameRemote MainStorage了没有GameRemote就一直等待直到创建  
MainStorage = game:GetService("MainStorage")
GameRemote = MainStorage:WaitForChild("GameRemote")
Players = game:GetService("Players")
CloudService = game:GetService("CloudService")
RunService = game:GetService("RunService")
PlayerData = {}
data = {}


if RunService:IsClient() then  
------------------------[[ 网络传输 ]]------------------------
    function data.GetData(plyid,key)
        return PlayerData[plyid][key] or nil
    end
    function data.SetData(plyid,key,value)
        PlayerData[plyid][key] = value 
    end

    --玩家离开 
    hook.Add("PlayerLeaveServer","SqlData_PlayerLeaveServer",function (ply)
        PlayerData[ply.UserId] = nil
    end)
    --玩家加入
    hook.Add("PlayerJoinServer","SqlData_PlayerJoinServer",function (ply)
        PlayerData[ply.UserId] = {}
    end)
elseif RunService:IsServer() then 
    function data.InitData(playerid,key,data)
        if not PlayerSqlData[playerid][key] then
            PlayerSqlData[playerid][key] = data
        end
    end
    function data.GetData(plyid,key)
        return PlayerData[plyid][key] or nil
    end
    function data.SetData(plyid,key,value)
        PlayerData[plyid][key] = value 
    end
 

    --玩家离开
    hook.Add("PlayerLeaveServer","Data_PlayerLeaveServerS",function (player)
        PlayerData[player.UserId] = nil
    end)
    --玩家加入
    hook.Add("PlayerJoinServer","Data_PlayerJoinServerS",function (player)
        PlayerData[player.UserId] = {}
    end)
    
end



