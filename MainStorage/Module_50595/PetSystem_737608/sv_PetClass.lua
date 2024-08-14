local workspace = game:GetService("WorkSpace")

PetClass = {}
local count = 0
function PetClass:new(classname,ply)
    local pet = require(script.Parent.Library[classname])
    if not pet then print("lua error: 创建新的宠物 宠物class不存在") return end
    local obj = table.deepcopy(pet)
    obj.Id = "Pet"..tostring(count).."_"..tostring(math.random(0,9999))
    obj.__type = "Pet"
    obj.Owner = ply
    obj.isCalling = false

    obj.ZiZhi_Hp = math.floor(math.random(0,3000))
    obj.ZiZhi_PhysicDanmage = math.floor(math.random(0,3000))
    obj.ZiZhi_MagicDanmage = math.floor(math.random(0,3000))
    obj.ZiZhi_PhysicDefens = math.floor(math.random(0,3000)) 
    obj.ZiZhi_MagicDefens = math.floor(math.random(0,3000)) 

    obj.Exp = 0
    obj.MaxExp = 100
    obj.Level = 1

    obj.Hp = 0
    obj.MaxHp = 0
    obj.PhysicDanmage = 0
    obj.MagicDanmage = 0
    obj.PhysicDefens = 0
    obj.MagicDefens = 0 

    obj.Equipment ={
        Neck = nil,
        Jewelry = nil,
        Armor = nil,
    }

    obj.AllSKill = {}

    count = count + 1 
    self.__index = self
    setmetatable(obj, self)
 

    obj:CaculateMaxExp()
    obj:CaculateEquipmentAttribute()


    return obj
end

--召唤
function PetClass:Call()
    if self.isCalling then return end
    
    self.isCalling = true
    local ply = self.Owner.Character
    local pet = SandboxNode.New("Actor")
    self.Actor= pet
    self.Actor.Parent = workspace
    self.Actor.ModelId = self.Model 
    self.Actor.Animator.ControllerAsset = self.ControllerAsset
    self.Actor.LocalScale = Vector3.new(1,1,1)
    self.Actor.Name = self.Id

    --出场动画
    net.FireAllClient("PetRenderPetSpawnEffect",pet,self.Size)


    -- TP 
    local face = math.GetDir(ply)
    local dir = math.GetRightDirection(face)
    local rightBackPosition = (ply.Position + (dir * 120) + (face * 110))
    self.Actor.Position = rightBackPosition 
    Effect:NewEffect(self.Owner,"Smoke7",rightBackPosition+ Vector3.new(0,40,0))
    
    -- Behavior
    self.Behavior = PetBehavior:new(self) 
    ThinkManager:AddFunc({
        unique = "PetBehavior"..self.Id,
        func = self.Behavior.Think,
        index = 10,
        tType = "RenderStepped"},
        self.Behavior
    )
    self.Behavior:ChangeState("Idle")
end
 
--收回
function PetClass:ReCall()
    if not self.isCalling then return end
    self.isCalling = false
    Effect:NewEffect(self.Owner,"Smoke7",self.Actor.Position+ Vector3.new(0,40,0))
    self.Actor:Destroy()
    ThinkManager:RemoveFunc("RenderStepped","PetBehavior"..self.Id)
    self.Acotr = nil
    self.Behavior = nil
end

--宠物穿着装备
function PetClass:PetEquipment(Part,Armor)
    if self.Equipment[Part]  then print("lua error: 此部位已有") return false end
    self.Equipment[Part] = Armor
    self:CaculateEquipmentAttribute()
    return true
end 
--宠物卸下装备
function PetClass:PetUnEquipment(Part)
    if not self.Equipment[Part]  then print("lua error: 此部位没有") return false end
    self.Equipment[Part] = nil
    self:CaculateEquipmentAttribute()
    return true
end
--计算装备加成
function PetClass:CaculateEquipmentAttribute()
    self.MaxHp = 0
    self.PhysicDanmage = 0
    self.MagicDanmage = 0
    self.PhysicDefens = 0
    self.MagicDefens = 0 
    local level = self.Level

    --玩家属性
    local zi_zhi  =(math.pow(2,math.ceil(level/10))*level)
    local gen_gu  =(math.pow(2,math.ceil(level/10))*level)
    local shen_shi=(math.pow(2,math.ceil(level/10))*level) 
    local wu_xing =(math.pow(2,math.ceil(level/10))*level)

    self.MaxHp  = (math.pow(2,math.ceil(level/10))*50*level)
    self.physicDanmage =  level + zi_zhi * 10  + shen_shi * 5 
    self.physicDenfens =  level + gen_gu * 5
    self.magicDanmage =   level + wu_xing * 10  + shen_shi * 5 
    self.magicDenfens =   level + gen_gu * 5




    --装备提升 
    for slot, equipment in pairs(self.Equipment) do
        self.MaxHp          =      self.MaxHp            +  (equipment.Data.Hp             ~= nil  and equipment.Data.Hp            or   0)        
        self.PhysicDanmage  =      self.PhysicDanmage    +  (equipment.Data.PhysicDanmage  ~= nil  and equipment.Data.PhysicDanmage or   0)     
        self.MagicDanmage   =      self.MagicDanmage     +  (equipment.Data.MagicDanmage   ~= nil  and equipment.Data.MagicDanmage  or   0)      
        self.PhysicDefens   =      self.PhysicDefens     +  (equipment.Data.PhysicDefens   ~= nil  and equipment.Data.PhysicDefens  or   0)      
        self.MagicDefens    =      self.MagicDefens      +  (equipment.Data.MagicDefens    ~= nil  and equipment.Data.MagicDefens   or   0)      
    end




    --资质提升
        local GrowZiZhi_Hp            =  self.ZiZhi_Hp               /1000
        local GrowZiZhi_PhysicDanmage =  self.ZiZhi_PhysicDanmage    /1000
        local GrowZiZhi_MagicDanmage  =  self.ZiZhi_MagicDanmage     /1000
        local GrowZiZhi_PhysicDefens  =  self.ZiZhi_PhysicDefens     /1000
        local GrowZiZhi_MagicDefens   =  self.ZiZhi_MagicDefens      /1000

        self.MaxHp             =      self.MaxHp               + GrowZiZhi_Hp             * self.ZiZhiGrowp_Hp 
        self.PhysicDanmage  =      self.PhysicDanmage    + GrowZiZhi_PhysicDanmage  * self.ZiZhiGrowp_PhysicDanmage 
        self.MagicDanmage   =      self.MagicDanmage     + GrowZiZhi_MagicDanmage   * self.ZiZhiGrowp_MagicDanmage 
        self.PhysicDefens   =      self.PhysicDefens     + GrowZiZhi_PhysicDefens   * self.ZiZhiGrowp_PhysicDefens 
        self.MagicDefens    =      self.MagicDefens      + GrowZiZhi_MagicDefens    * self.ZiZhiGrowp_MagicDefens 

    --去小数
        self.MaxHp           =  math.floor(self.MaxHp         )
        self.PhysicDanmage   =  math.floor(self.PhysicDanmage )
        self.MagicDanmage    =  math.floor(self.MagicDanmage  )
        self.PhysicDefens    =  math.floor(self.PhysicDefens  )
        self.MagicDefens     =  math.floor(self.MagicDefens   )
end


--计算最大经验
function PetClass:CaculateMaxExp()
    self.MaxExp=(self.Level*100)*math.pow(4,math.floor(self.Level/10)) --结算最大等级
end
--检测升级
function PetClass:CheckLevelUp()
    if self.Exp >= self.MaxExp then
        self.Level = self.Level + 1  --等级+1
        self.Exp = self.Exp - self.MaxExp --经验扣掉
        self:CaculateMaxExp() --重新计算最大经验
        self:CheckLevelUp()
    end
end
--增加经验
function PetClass:AddExp(value)
    self.Exp = self.Exp + value
    self:CheckLevelUp()
end
--设置等级
function PetClass:SetLevel(value)
    self.Level = value
    self:CaculateMaxExp()
end
--设置经验
function PetClass:SetExp(value)
    self.Exp = value
    self:CheckLevelUp()
end

--[[ 

    --》玩家数值系统
            zi_zhi  =(math.pow(2,math.ceil(level/10))*level)
            gen_gu  =(math.pow(2,math.ceil(level/10))*level)
            shen_shi=(math.pow(2,math.ceil(level/10))*level)
            wu_xing =(math.pow(2,math.ceil(level/10))*level)

            Hp  = (math.pow(2,math.ceil(level/10))*50*level)
            physicDanmage =  level + zi_zhi * 10  + shen_shi * 5 
            physicDenfens =  level + gen_gu * 5
            magicDanmage =   level + wu_xing * 10  + shen_shi * 5 
            magicDenfens =   level + gen_gu * 5


    --》宠物
    此宠物资质系数 防御 = 2
    此宠物资质系数 攻击 = 3
    此宠物各种基础数值 

    资质增长值 =  资质 / 100  
    资质属性 = 资质增长值 * 资质系数


    宠物最终属性 = 玩家属性 + 资质属性 + 装备属性  
]]

-- 获取网络信息方法
function PetClass:GetInfo()
    local info = {
        Nick = self.Nick ,
        Id = self.Id,
        Level = self.Level,
        Exp = self.Exp,
        MaxExp = self.MaxExp,

        Hp = self.Hp,
        MaxHp = self.MaxHp,
        isCalling = self.isCalling,
        PhysicDanmage = self.PhysicDanmage,
        MagicDanmage = self.MagicDanmage, 
        PhysicDefens = self.PhysicDefens,
        MagicDefens = self.MagicDefens,
        Speed = self.Speed,
        SkillCoolDown = self.SkillCoolDown, 
        Model = self.Model,
        ControllerAsset = self.ControllerAsset,


        HeadIcon = self.HeadIcon,
        ZiZhi_MagicDanmage   = self.ZiZhi_MagicDanmage  ,
        ZiZhi_PhysicDefens   = self.ZiZhi_PhysicDefens  ,
        ZiZhi_MagicDefens    = self.ZiZhi_MagicDefens   ,
        ZiZhi_PhysicDanmage  = self.ZiZhi_PhysicDanmage ,
        ZiZhi_Hp          = self.ZiZhi_Hp         


    } 
    
    if self.Equipment then
        info.Equipment = {}
        if self.Equipment.Neck  then 
            info.Equipment.Neck = self.Equipment.Neck:GetInfo()
        end
        if self.Equipment.Jewelry  then
            info.Equipment.Jewelry = self.Equipment.Jewelry:GetInfo()
        end
        if self.Equipment.Armor  then
            info.Equipment.Armor = self.Equipment.Armor:GetInfo()
        end
    end

    info.AllSKill = {}
    for index, skill in pairs(self.AllSKill) do
        table.insert(info.AllSKill,skill:GetInfo())
    end


    return info
end

--获取技能
function PetClass:AddSkill(skill)
    if  self.AllSKill[skill.classname]  then
        print("宠物技能添加失败")
        return false
    end
    for __ , class in ipairs(skill.SkillClash) do
        if  self.AllSKill[class]  then
            print("宠物技能添加失败")
            return false
        end
    end
     
    print("宠物技能添加成功")
    self.AllSKill[skill.classname] = skill
    return true
end
--删除技能 
function PetClass:DelectSkill(skillclassname)
    if  not self.AllSKill[skillclassname]  then
        print("宠物技能删除失败")
        return false
    end

    self.AllSKill[skillclassname]  = nil
    print("宠物技能删除成功")
    return true
end

-- 设置方法
function PetClass:SetPhysicDanmage(value)
    self.PhysicDanmage = value
end

function PetClass:SetMagicDanmage(value)
    self.MagicDanmage = value
end

function PetClass:SetPhysicDefens(value)
    self.PhysicDefens = value
end

function PetClass:SetMagicDefens(value)
    self.MagicDefens = value
end


function PetClass:SetId(value)
    self.Id = value
end


function PetClass:SetMaxExp(value)
    self.MaxExp = value
end

function PetClass:SetMaxHp(value)
    self.MaxHp = value
end

function PetClass:SetHp(value)
    self.Hp = value
end

-- 获取方法
function PetClass:GetPhysicDanmage()
    return self.PhysicDanmage
end

function PetClass:GetMagicDanmage()
    return self.MagicDanmage
end

function PetClass:GetPhysicDefens()
    return self.PhysicDefens
end

function PetClass:GetMagicDefens()
    return self.MagicDefens
end

function PetClass:GetLevel()
    return self.Level
end

function PetClass:GetId()
    return self.Id
end

function PetClass:GetExp()
    return self.Exp
end

function PetClass:GetMaxExp()
    return self.MaxExp
end

function PetClass:GetMaxHp()
    return self.MaxHp
end

function PetClass:GetHp()
    return self.Hp
end
