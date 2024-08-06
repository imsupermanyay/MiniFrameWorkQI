local config ={}
config.EquipmentPath = localPlayer.PlayerGui.Equipment.Bag.background.Equipment
config.EquipmentSlot = {} 
for slotname, number in pairs(EQUIPMENT) do
    config.EquipmentSlot[number] = localPlayer.PlayerGui.Equipment.Bag.background.Equipment[slotname]


    --点击此栏位
    config.EquipmentSlot[number].Click:Connect(function(node,issuccess,mousepos) 
        net.Fire("Equipment_ClickEquipment",number)
    end)
end
 
 
 
 
 
--客户端接收到了装备栏信息 开始渲染
net.Receive("Equipment_E_SendBagInfo",function (data)
    print("客户端接收到了装备栏信息 开始渲染")
    for __, value in pairs(data.Items) do
        local itemdata = value.ItemObj
        config.EquipmentSlot[itemdata.Data.Slot].Ui.Icon = itemdata.Icon
    end
end)  

--显示装备信息 
net.Receive("Equipment_E_SendEquipmentInfo",function (data)
    local iteminfo  = CreateItemInfo(data,config.EquipmentPath.Parent.Parent)
end)