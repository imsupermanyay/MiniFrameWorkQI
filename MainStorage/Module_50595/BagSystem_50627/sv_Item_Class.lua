
ItemObj = {
    idcountunique = 0
}
  
function ItemObj:new(classname) 
    local result = Item.Func.GetItemData(classname)
    if not result then print("lua error : 新建Item对象时 尝试拿一个不存在的Item") return end
    local obj = table.deepcopy(result)
    obj.IsRotate = false
    obj.ItemId = obj.classname..math.random(0,9999)..tostring(ItemObj.idcountunique)
    ItemObj.idcountunique = ItemObj.idcountunique + 1 
    setmetatable(obj, self)
    self.__index = self
    return obj   
end
 
function ItemObj:Use()
    if not self.UseFunc then print("lua error: 尝试使用一个不能使用的Item") return end
    return self:UseFunc() 
end 

function ItemObj:CanUse()
    if not self.UseFunc then return false end
    return true
end  


function ItemObj:SetRotate(v)
    if type(v) ~= "boolean" then print("lua error: 尝试设置一个Item的旋转属性时，传入的参数不是boolean") return end
    self.IsRotate = v  
end 



function ItemObj:GetInfo()
    local info = {
        Size = self:GetSize(),
        Name = self:GetName(),
        Icon = self:GetIcon(),
        Color = self:GetColor(),
        TypeName = self:GetTypeName(),
        Quality = self:GetQuality(),
        Data = self:GetData(),
        UseFunc = self:CanUse(),
        classname = self:GetClassName(), 
        Introduce = self:GetIntroduce(),
        Strengthen = self:GetStrengthen(),
        Rotate = self:GetRotate(),
        Id = self:GetId(),
    } 
    return info
end


function ItemObj:GetId()
    return self.ObjId
end

function ItemObj:GetRotate()
    return self.IsRotate  
end 

function ItemObj:GetStrengthen() 
    return self.Strengthen or nil
end

function ItemObj:GetType()
    return self.Type
end

function ItemObj:GetTypeName()
    return Config_Items.Type[self.Type].Name
end

function ItemObj:GetColor()
    return Config_Items.Quality[self.Quality].Color
end

function ItemObj:GetQuality()
    return Config_Items.Quality[self.Quality].Name
end

function ItemObj:GetWeight()
    return self.Size.weight
end

function ItemObj:GetTall()
    return self.Size.tall
end

function ItemObj:GetIntroduce()
    return self.Introduce
end

function ItemObj:GetIcon()
    return self.Icon
end

function ItemObj:GetName()
    return self.Name
end
 
function ItemObj:GetClassName()
    return self.classname
end

function ItemObj:GetSize()
    return self.Size
end
 
function ItemObj:GetData()
    if not self.Data then return end
    return self.Data
end

function ItemObj:GetUseFunc()
    return self.UseFunc
end
