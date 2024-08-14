PetManager = {}

function PetManager:new(ply)
    local obj = {}
    obj.Owner = ply
    obj.AllPet = {}
    self.__index = self
    setmetatable(obj, self)
    return obj 
end
 
--拿到指定ID的宠物
function PetManager:GetPetById(id)
    for index, pet in ipairs(self.AllPet) do
        if pet.Id == id then
            return index,pet
        end 
    end
    return nil
end
--添加宠物
function PetManager:AddPet(petclass) 
    local pet = nil
    if type(petclass) =="string" then
        pet = PetClass:new(petclass,self.Owner)
    else
        pet = petclass
    end

    if pet.__type ~= "Pet" then print("lua error:增加Pet时,Pet类型错误") end
    table.insert(self.AllPet,pet)
end
--删除宠物
function PetManager:DelectPetById(id)
    local index,pet = self:GetPetById(id) --拿到
    pet:ReCallPet() --召回
    self.AllPet[index] = nil  --删除
end

function PetManager:SetAllPet(allpet)
    self.AllPet = allpet
end

--召唤 指定ID宠物
function PetManager:CallPet(id)
    local index,pet = self:GetPetById(id) --拿到
    pet:Call() --召回
end

--添加物品
function PetManager:AddItem(item)
    local bag = data.GetData(self.Owner.UserId,"PetBag")
    bag:AddItem(item)
end

--删除物品
function PetManager:DelectItemById(id)
    local bag = data.GetData(self.Owner.UserId,"PetBag")
    bag:DelectItemById(id)
end

--给宠物穿上装备
function PetManager:Equipment(id,itemdata)
        --给玩家宠物穿装备
        local index,pet = self:GetPetById(id)
        if not pet then print("lua erorr : PetManager找不到pet") return end
        local result = pet:PetEquipment(itemdata.Data.Slot,itemdata)
    
        if result then 
            print("穿成功") 
            self:SyncInfo()
    
        else
            print("穿失败")
        end
        return result
end

--给宠物卸下装备
function PetManager:UnEquipment(id,Slot)
    --给玩家宠物穿装备
    local index,pet = self:GetPetById(id)
    if not pet then print("lua erorr : PetManager找不到pet") return end
    local bag = data.GetData(self.Owner.UserId,"PetBag")
    local itemdata = pet.Equipment[Slot] 
    bag:AddItem(itemdata)

    local result = pet:PetUnEquipment(Slot)

    if result then 
        print("卸成功") 
        self:SyncInfo()

    else
        print("卸失败")
    end
    return result
end

--删除某装备 根据物品ID
function PetManager:ReCallPet(id)
    local index,pet = self:GetPetById(id) --拿到
    pet:ReCall() --召回
end

--打开背包请求
function PetManager:OpenBag()
    self:SyncInfo()
end 

--发送给客户端Info渲染
function PetManager:SyncInfo()
    local petinfo = self:GetInfo()
    local bag  = data.GetData(self.Owner.UserId,"PetBag")
    local baginfo = bag:GetInfo()
    --给客户端发送渲染数据
    net.Fire(self.Owner.UserId,"SyncPetInfoAndOpenPetManager",petinfo,baginfo)
end
--得到Netinfo
function PetManager:GetInfo()
    local allinfo = {}
    for key, pet in pairs(self.AllPet) do
        local result = pet:GetInfo()
        table.insert(allinfo,result)
    end 

    return allinfo
end




local count = 0
--给某个宠物给予技能  
function PetManager:AddSkill(id,itemdata)
    local class = itemdata.classname  
    local skill = require(script.Parent.PetSkill[class])
    if not skill then print("lua error: 创建新的宠物 宠物class不存在") return end
    count = count + 1
    skill.classname = class
    skill.id = "skill"..tostring(math.random(0,100))..tostring(count)
    skill.GetInfo = function (self2)
        local info = {}
        info.ClassName = self2.ClassName
        info.Icon = self2.Icon
        info.Name = self2.Name
        info.Introduce =  self2.Introduce
        info.Data =  self2.Data
        info.Quality =  self2.Quality
        info.SkillClash = self2.SkillClash
        return info 
    end

 
  

    
    local ____,pet = self:GetPetById(id)
    local result = pet:AddSkill(table.deepcopy(skill))

    if result then
        self:SyncInfo()
    end
    return result 
end
function PetManager:DelectSkill(id,class)
    local pet = self:GetPetById(id)
    local result = pet:DelectSkill(class)
 
 
    if result then
        self:SyncInfo()
    end
end

function PetManager:RemoveSkill(class,id)

    local pet = self:GetPetById(id)
    pet:RemoveSkill(class)
end


----------------------------------------------------[[前后端交互]]
--请求出战
net.Receive("PlayerRequestCallPet",function (ply,id)
    local PlayerPet = data.GetData(ply.UserId,"PetManager") 
    local index,pet = PlayerPet:GetPetById(id)
    if pet.isCalling then
        PlayerPet:ReCallPet(id)
        net.Fire(ply.UserId,"PetReCallBtnFrash")
    else
        PlayerPet:CallPet(id)
        net.Fire(ply.UserId,"PetCallBtnFrash")
    end
end)
 
net.Receive("PlayerRequestUnEquipment",function (ply,id,slot)
    local PlayerPet = data.GetData(ply.UserId,"PetManager")
    PlayerPet:UnEquipment(id,slot)
    
end)