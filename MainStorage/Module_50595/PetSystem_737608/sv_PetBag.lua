PetBagManager = PetBagManager or {}

PetBagManager.DefaultData = {
    ["Items"] = {},
    ["MaxSize"] = {weight = 5,tall = 4},
} 
 

------------------------[[ 业务处理 ]]------------------------
 
--玩家加入服务器 给背包初始化
hook.Add("PlayerSqlDataInit", "PlayerJoinServer_PetBag", function(ply)

    
    print("玩家加入服务器 给背包初始化")
    --数据初始化 
    sqldata.InitSqlData(ply.UserId,"PetBag",PetBagManager.DefaultData)
    local m_data = sqldata.GetSqlData(ply.UserId,"PetBag")
    --背包对象初始化   
    local bag = BagObj:new(m_data.MaxSize,m_data.Items,ply,"PetBag")  
    data.SetData(ply.UserId,"PetBag",bag)

    
 
end)

net.Receive("PlayerChoisePetSlot",function (ply,id)
    local petbag = data.GetData(ply.UserId,"PetBag")
    petbag.ChoisePet = id
end)


net.Receive("Test4",function (ply)
    local bag = data.GetData(ply.UserId,"PetBag")
    bag:AddItem(ItemObj:new(ply.PlayerGui.HUD.UITextInput.Text))
end)
