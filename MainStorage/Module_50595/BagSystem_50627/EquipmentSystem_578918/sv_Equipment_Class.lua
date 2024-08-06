EquipmentManager = {}


function EquipmentManager:new()
    local obj = {
        AllEquipment = {}
    }
    
    self.__index = self
    setmetatable(obj, self)
    return obj
end

--拿到信息
function EquipmentManager:GetInfo()
    local clientitemdata = {} 
    for key, itemdata in pairs(self.AllEquipment) do
        local itemObj = itemdata
        local newitem = {
            Y = itemdata.Y,
            X = itemdata.X,
            ItemObj = {
                Size = itemObj:GetSize(),
                Name = itemObj:GetName(),
                Icon = itemObj:GetIcon(),
                Color = itemObj:GetColor(),
                TypeName = itemObj:GetTypeName(),
                Quality = itemObj:GetQuality(),
                Data = itemObj:GetData(),
                UseFunc = itemObj:CanUse(),
                classname = itemObj:GetClassName(), 
                Introduce = itemObj:GetIntroduce(),
                Strengthen = itemObj:GetStrengthen(),
                Rotate = itemObj:GetRotate(),
                Id = itemObj:GetId(),
            }
        }
        table.insert(clientitemdata, newitem)
    end
    return {
        Items = clientitemdata,
        MaxSize = self.Size,
    }
end

--添加装备
function EquipmentManager:AddEquipment(Slot,items)
    if self.AllEquipment[Slot] then return false end
    self.AllEquipment[Slot] = items
    return true
end

--是否有装备
function EquipmentManager:HasEquipment(Slot)
    if self.AllEquipment[Slot] then return true end
    return false
end

--删除装备
function EquipmentManager:DelectEquipment(Slot)
    self.AllEquipment[Slot] = nil
end 

--获取装备
function EquipmentManager:GetEquipment(Slot)
    return self.AllEquipment[Slot]
end 

--获取所有装备
function EquipmentManager:GetAllEquipment()
    return self.AllEquipment
end

--删除所有装备
function EquipmentManager:DelectAllEquipment()
    self.AllEquipment = {}
end

