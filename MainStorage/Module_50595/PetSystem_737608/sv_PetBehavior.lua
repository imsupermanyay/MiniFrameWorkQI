local WorldService=game:GetService("WorldService")
local workspace = game:GetService("WorkSpace")

PetBehavior = {
    DetectRange = 1000
}
--注册State
PetBehavior.State = {
    Idle = "Idle",
    Follow = "Follow",
    Fight = "Fight",
}

function PetBehavior:new(PetObj)
    local obj = {}

    obj.Pet = PetObj
    obj.acceleration = 10
    obj.deceleration = 5
    obj.currentSpeed = 0
    obj.Attacktime = 0
    obj.neardistance = 200
    obj.fardistance = 400
    obj.Talktime = 0
    obj.Skilltime = 0
    setmetatable(obj, {
        __index = function(t, k)
            return PetBehavior[k] or PetClass[k]
        end
    }) 
 

    return obj


end
 
function PetBehavior:SetTarget(actor) 
    self.Target = actor

    --执行技能钩子
    for __, skill in pairs(self.Pet.AllSKill) do
        if skill.SetTarget then    skill:SetTarget(actor)  end
    end


    return true
end

function PetBehavior:PetDoAttack() 
    self:Talk(table.random(self.Pet.Chat["Attack"]))
    print("使用攻击")
    --执行宠物钩子
    self.Pet:DoAttack()


    --执行技能钩子
    for __, skill in pairs(self.Pet.AllSKill) do
        if skill.DoAttack then    skill:DoAttack()  end
    end


end

function PetBehavior:PetDoSkill() 
    self:Talk(table.random(self.Pet.Chat["Skill"]))
    print("使用技能")
    self.Pet:DoSkill()



    --执行技能钩子
    for __, skill in pairs(self.Pet.AllSKill) do
        if skill.DoSkill then    skill:DoSkill()  end
    end

end

function PetBehavior:PetDead() 
    self:Talk(table.random(self.Pet.Chat["Dead"]))
    self.Pet:Dead()

    

    --执行技能钩子
    for __, skill in pairs(self.Pet.AllSKill) do
        if skill.Dead then    skill:Dead()  end
    end

end 

function PetBehavior:PetHurt() 
    self:Talk(table.random(self.Pet.Chat["Hurt"]))
    self.Pet:Hurt()


    
    --执行技能钩子
    for __, skill in pairs(self.Pet.AllSKill) do
        if skill.Hurt then    skill:Hurt()  end
    end

end 



-- --寻敌逻辑
-- function PetBehavior:SearchTarget()
    
-- end 

--停止移动
function PetBehavior:StopMove()
    self.MoveStop = true
    self.Pet.Actor:StopMove()
end 
--移动到目标位置
function PetBehavior:MoveTowardsTarget(petactor, dt)
    if self.MoveStop then return end
    if not self.targetPosition then return end

    local dir = math.CalculateDirection(petactor.Position, self.targetPosition)
    local distanceToTarget = math.CalculateDistance(petactor.Position, self.targetPosition)
    local maxSpeed = self.Pet.Speed -- 使用宠物的速度属性
    
    
    -- 根据距离动态调整目标速度
    local targetSpeed
    if distanceToTarget > self.fardistance then
        targetSpeed = maxSpeed
    elseif distanceToTarget > self.neardistance + 70 then
        targetSpeed = maxSpeed * (distanceToTarget / self.fardistance) -- 距离越近速度越慢
    else
        targetSpeed = 0 -- 靠近目标时停止
    end

    -- 更新当前速度
    if self.currentSpeed < targetSpeed then
        self.currentSpeed = math.min(self.currentSpeed + self.acceleration , targetSpeed)
    elseif self.currentSpeed > targetSpeed then
        self.currentSpeed = math.max(self.currentSpeed - self.deceleration , targetSpeed)
    end
    
    -- 计算移动量
    local moveStep = Vector3.new(dir.X,0,dir.Z) * self.currentSpeed 
    petactor.Position = petactor.Position + moveStep * dt
end

--Think
function PetBehavior.Think(dt, self)
    local ply = self.Pet.Owner.Character
    local petactor = self.Pet.Actor  
    local distance = math.CalculateDistance(ply.Position, petactor.Position) 
   
    local ostime = os.time() 
    --每过10秒说话
    if self.Pet.Chat[self.State] and ostime > self.Talktime + 15 then
        self:Talk(table.random(self.Pet.Chat[self.State]))
    end

    --切换状态
    if distance > self.fardistance then
        self:ChangeState("Follow")
        --距离过远直接传送
    end
    if distance > 3000 then  
        petactor.Position = ply.Position 
        Effect:NewEffect(ply, "Smoke7", petactor.Position)
    end 
    self.Target = workspace.Actor3 
    --有目标则战斗
    if self.Target then
        self:ChangeState("Fight")
    end


    --执行当前状态
    if not self.StateThink then return end
    self:StateThink(dt) 
end
 
--切换状态 
function PetBehavior:ChangeState(State)
    if not self[State] then print("lua error : [PetBehavior]状态函数不存在") return end
    if self.State == State then return end
    self.State = State
    self.StateThink = self[State]
    
end

--跟随状态
function PetBehavior:Follow(dt)
    local ply = self.Pet.Owner.Character
    local petactor = self.Pet.Actor 
    local distance = math.CalculateDistance(ply.Position, petactor.Position) 
    local dir = math.CalculateDirection(ply.Position, petactor.Position)

    --不断的更新位置
    self.targetPosition = ply.Position 
    self:MoveTowardsTarget(petactor, dt)
    petactor.Euler = math.DirectionToEuler(Vector3.new(dir.x,0,dir.z))
  
    --太近了就取消跟随
    if distance < self.neardistance then
        self:StopMove()
        self.targetPosition = nil
        self.currentSpeed = 0
        self:ChangeState("Idle")
    end
end

--待机状态
function PetBehavior:Idle(dt)

end

--攻击状态  
function PetBehavior:Fight(dt)
    local petactor = self.Pet.Actor 
    local target= self.Target
    local distance = math.CalculateDistance(target.Position, petactor.Position) 
    local dir = math.CalculateDirection(target.Position, petactor.Position)

    --如果目标丢失就取消攻击
    if not target then
        self:ChangeState("Follow")
        return
    end

    --如果距离太远就追击
    if distance > 200 and not self.BlockAttack then
        --不断的更新位置
        self.targetPosition = target.Position 
        self:MoveTowardsTarget(petactor, dt)
        petactor.Euler = math.DirectionToEuler(Vector3.new(dir.x,0,dir.z))
        return
    end

    --每隔2秒 跑到目标面前攻击
    if os.time() > self.Attacktime + 2 and distance < 200  then
        self.BlockAttack = true
        if os.time() > self.Skilltime + self.Pet.SkillCoolDown then
            --技能攻击 
            self.Skilltime = os.time() 
            self.Attacktime = os.time()
            self:PetDoSkill() 
        else
            self.Attacktime = os.time()
            self:StopMove() 
            self:PetDoAttack()
        end
    end

    

end

--闲聊某句话
function PetBehavior:Talk(str)
    self.Talktime = os.time()
    local tall = self.Pet.Tall 
    local actor = self.Pet.Actor
    net.FireAllClient("PetRenderChatPop",str,tall,actor)
end





-------