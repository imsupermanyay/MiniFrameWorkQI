BagManager = BagManager or {}

BagManager.DefaultData = {
    ["Items"] = {},
    ["MaxSize"] = Config_Bag.defaultSize,
} 
 

------------------------[[ 业务处理 ]]------------------------
 
--玩家加入服务器 给背包初始化
hook.Add("PlayerSqlDataInit", "Equipment_PlayerJoinServer_Bag", function(ply)

    
    print("玩家加入服务器 给背包初始化")
    --数据初始化 
    sqldata.InitSqlData(ply.UserId,"Bag",BagManager.DefaultData)
    local m_data = sqldata.GetSqlData(ply.UserId,"Bag")
    --背包对象初始化   
    local bag = BagObj:new(m_data.MaxSize,m_data.Items,ply,"Bag")  
    data.SetData(ply.UserId,"Bag",bag)
    --发送背包信息
    local data = bag:GetInfo() 
    net.Fire(ply.UserId,"Equipment_SendBagInfo",data)

end)
 
------------------------[[ 网络传输 ]]------------------------
--客户端请求服务器打开玩家背包
net.Receive("Equipment_PlayerOpenBag",function (ply)
    local Bag = data.GetData(ply.UserId,"Bag") --拿到Bag对象 
    local data = Bag:GetInfo() 
    net.Fire(ply.UserId,"Equipment_SendBagInfo",data)
end) 




 
net.Receive("Test1",function (ply)
    local Bag = data.GetData(ply.UserId,"Bag") --拿到Bag对象 
    local a = ItemObj:new("Prop1")
    local b = ItemObj:new("Material1")
    local c = ItemObj:new("BigSword_Drgone")
    Bag:AddItem(a) 
    Bag:AddItem(b) 
    Bag:AddItem(c) 
    Bag:SetSize(4,4)  
end)

