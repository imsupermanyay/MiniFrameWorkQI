--穿着装备的函数 
function EquipmentFunc(itemdata,ply)
    print("玩家使用了装备") 
    local m_Equipment = data.GetData(ply.UserId,"Equipment")
    local result = m_Equipment:AddEquipment(itemdata.Data.Slot,itemdata)
    
    if result then 
        print("穿成功") 
        local data = m_Equipment:GetInfo() 
        net.Fire(ply.UserId,"Equipment_E_SendBagInfo",data)
    else
        print("穿失败")
    end
    
    return result
end









--接收到客户端 点击栏位
net.Receive("Equipment_ClickEquipment",function (ply,slotid)
    print("点击了栏位")
    print(slotid) 

    --如果此栏位有装备 那么显示装备信息 
    local m_Equipment = data.GetData(ply.UserId,"Equipment")
    local itemdata = m_Equipment:GetEquipment(slotid)
    if itemdata then 
        net.Fire(ply.UserId,"Equipment_E_SendEquipmentInfo",itemdata:GetInfo())
    end 

end)


--玩家加入服务器 给装备初始化
hook.Add("PlayerSqlDataInit", "Equipment_PlayerJoinServer_Equipment", function(ply)
    --数据初始化
    -- sqldata.InitSqlData(ply.UserId,"Equipment",{})
    -- local m_data = sqldata.GetSqlData(ply.UserId,"Equipment")
    --装备栏初始化
    local Equipment = EquipmentManager:new()
    data.SetData(ply.UserId,"Equipment",Equipment)
    --发送装备栏信息
    local data = Equipment:GetInfo() 
    net.Fire(ply.UserId,"Equipment_E_SendBagInfo",data)
end)

