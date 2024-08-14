--玩家加入服务器 给宠物初始化
hook.Add("PlayerSqlDataInit", "Equipment_PlayerJoinServer_Pet_Pet", function(ply)
    --数据初始化
    sqldata.InitSqlData(ply.UserId,"Pet",{})
    local m_data = sqldata.GetSqlData(ply.UserId,"Pet")
    --宠物初始化
    -- PlayerPet:SetAllPet(m_data)  -- 将数据设置给Manager

    
    local PlayerPet = PetManager:new(ply)  
    data.SetData(ply.UserId,"PetManager",PlayerPet)
end)




 
net.Receive("Test2",function (ply)

    -- local PlayerPet = data.GetData(ply.UserId,"PetManager") 
    -- local dog = PetClass:new("Dog",ply)
    -- PlayerPet:AddPet(dog)

end)


net.Receive("Test3",function (ply)

    
    local PlayerPet = data.GetData(ply.UserId,"PetManager") 
    local dog = PetClass:new("Dog",ply)
    PlayerPet:AddPet(dog)

    
    local PlayerPet = data.GetData(ply.UserId,"PetManager") 
    PlayerPet:OpenBag()

    

end)
