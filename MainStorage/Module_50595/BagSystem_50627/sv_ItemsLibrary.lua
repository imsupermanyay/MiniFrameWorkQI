
Item = {
    Func ={},
    Data ={}
}
--初始化所有配置
function Item.Func.InitAllConfig()
    for itemtype, typeobj in pairs(Config_Items.Type) do
        Item.Data[itemtype] = {} 
        for class, data in pairs(Config_Items.Items[itemtype]) do
            local itemdata = data 
            itemdata.classname = class
            itemdata.Type = itemtype
            Item.Data[itemtype][class] = itemdata 
            if itemtype == "Equipment" then
                itemdata.UseFunc = EquipmentFunc
            end
        end
    end  
end 
Item.Func.InitAllConfig() 


function Item.Func.LoadItem(tab,itemtype,typename,UseFunc)
    Config_Items.Items[itemtype] = tab
    Config_Items.Type[itemtype] = {Name =typename}
    Item.Data[itemtype] = {} 
    for class, data in pairs(tab) do
        local itemdata = data 
        itemdata.classname = class
        itemdata.Type = itemtype
        Item.Data[itemtype][class] = itemdata 
        itemdata.UseFunc = UseFunc
    end
end

--拿到某个Item的数据根据classname
function Item.Func.GetItemData(classname)
    
    for key, itemtype in pairs(Item.Data) do
        for class, data in pairs(itemtype) do
            if class == classname then
                return data
            end
        end
    end
    print("lua error : 尝试拿一个不存在的Item") 
    return nil
end
