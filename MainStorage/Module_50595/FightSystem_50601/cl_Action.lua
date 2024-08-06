ActionBehavior = {}
ActionBehavior.Anime ={
}

-- new一个 ActionBehavior   
function ActionBehavior:new(Actor)
    local obj = {}
    obj.Actor = Actor
    obj.Weapons = nil
    obj.Contrller = Controller:new(Actor)
    obj.ComboInterval = false
    obj.CurrentIndex = 1
    obj.CurrentEnableCombo = {}
    obj.CoolDown = 0.2
    obj.Jumping =false
    obj.JumpingAcceleration = false
    obj.JumpHold = false
    obj.IsAir = false
    self.__index = self
    setmetatable(obj, self)


    
    -- Behavior
    ThinkManager:AddFunc({
        unique = "PlayerBehavior"..tostring(math.random(0,9999)),
        func = obj.ControllerMain,
        index = 10,
        tType = "Stepped"},
        obj
    )

    return obj
end


------------------------[[ 连招系统 ]]------------------------
--轻攻击


function ActionBehavior:NextAttack(attackType)
    if self.ComboInterval then return end
    local combo = nil
    if #self.CurrentEnableCombo <= 0 then
        --玩家首次输入 在Combo中判断
        for comboclass, obj in pairs(self.Weapons.Combo) do
            local v = obj[self.CurrentIndex]
            if v.Type == attackType then --如果当前Step中的Type等于传入的attackType相同 那么设置此Combo为可以启用的Combo
                table.insert(self.CurrentEnableCombo,obj)
                combo = v.Anime
            end
        end
    else
        local enabletab = {}
        --玩家次输入 只在CurrentEnableCombo 中判断
        for comboclass, obj in ipairs(self.CurrentEnableCombo) do
            local v = obj[self.CurrentIndex]
            if v ~= nil and v.Type == attackType then --如果当前Step中的Type等于传入的attackType相同 那么设置此Combo为可以启用的Combo
                table.insert(enabletab,obj)
                combo = v.Anime
            end  
        end 
        self.CurrentEnableCombo = enabletab
    end
 
    --如果结束了
    if #self.CurrentEnableCombo <= 0 then
        self.CurrentIndex = 1
        self.CurrentEnableCombo = {} 
        return
    end 
    --没结束+1
    self.CurrentIndex =  self.CurrentIndex  + 1
    self.Weapons[combo]()
    
    --0.1输入间隔
    coroutine.work(function()
        self.ComboInterval = true
        wait(0.1)
        self.ComboInterval = false
    end)
end


--停止连招
function ActionBehavior:StopCombo()

end

------------------------[[ 战斗系统 ]]------------------------
--切换武器/战斗风格
function ActionBehavior:SwitchWeapons(weapons,ply)
    self.Weapons = Fight.Data.Weapons[weapons]
    ply.Character.Animator.ControllerAsset = self.Weapons.ControllerAsset
    self.Owner = ply
end

--锁定
function ActionBehavior:Lock()
    
end  
------------------------[[ 逻辑层系统 ]]------------------------
function ActionBehavior:StuckWalkAnime()
    if self.Jumping then return true end
    if self.IsAir then return true end
    return false    
end

------------------------[[ 动作系统 ]]------------------------
function ActionBehavior:Walk()
    if self:StuckWalkAnime() then return end
    self.Contrller:ChangeState(self.Weapons.Anime.Walk_Forward,0,0.15,0)
    
end

function ActionBehavior:Idle()
    if self:StuckWalkAnime() then return end
    self.Contrller:ChangeState(self.Weapons.Anime.Idle,0,0.15,0)
end

function ActionBehavior:Dodge()
    
end

function ActionBehavior:Jump()
    if self.Jumping then return end
    local time = 0.3
    if not self.JumpHold then time = 0.1 end --是否是预输入操作 决定跳跃临界点


    --开始跳跃
    localPlayer.Character:Jump(true)
    self.Jumping = true
    self.JumpingAcceleration = true 
    --跳跃速度平滑
    coroutine.work(function ()
        for i = 50, 0, -5 do 
            wait(0.015) 
            self.Actor.JumpContinueSpeed = i
        end
    end)
    --跳跃动画 
    coroutine.work(function ()
        self.Contrller:ChangeState(self.Weapons.Anime.Jump_Start,0,0.2,0)
        wait(self.Weapons.AnimeData.Jump_Start.time)
        if not self.Jumping then return end
        self.Contrller:ChangeState(self.Weapons.Anime.Jump_Loop,0,0.2,0)
    end)


    --跳跃临界
    self.Jumptimer = Timer.Simple(time,function ()
        self:JumpEnd()
    end)
end 

function ActionBehavior:JumpEnd()
    --停止跳跃加速
    localPlayer.Character:Jump(false)
    self.JumpingAcceleration = false
    if self.Jumptimer then
        self.Jumptimer:Destroy()
    end
end


hook.Run("MoveStart")
--触碰地面
hook.Add("TouchedGround","FightTouchedGround",function (plyuserid)
    if plyuserid ~= localPlayer.UserId then return end
    --可以再次跳跃
    local act = data.GetData(localPlayer.UserId,"ActionBehavior")
    act:JumpEnd()
    act.IsAir = false
    act.Jumping = false
    act.Actor.JumpContinueSpeed = 50
    if act.FallGround then
        act.Contrller:ChangeState(act.Weapons.Anime.Jump_End,0,0.2,0)
        act.FallGround = false 
    end
end)

--空中
hook.Add("PlayerFalling","FightFallAir",function (ply)
    local act = data.GetData(localPlayer.UserId,"ActionBehavior")
    act:JumpEnd()
    act.Contrller:ChangeState(act.Weapons.Anime.Jump_Loop,0,0.2,0)
end)

function ActionBehavior:Jump_Attack()
    
end

function ActionBehavior:Dash()
    
end

function ActionBehavior:Dash_Attack()
    
end

function ActionBehavior:Hurt()
    
end

function ActionBehavior:Skill()
    
end 

--轻攻击
function ActionBehavior:LightAttack()
    self:NextAttack("Light")
end

--重攻击
function ActionBehavior:HeavyAttack()
    self:NextAttack("Heavy")
end


------------------------[[ 控制输入系统 ]]------------------------
--是否开始接受预输入
function ActionBehavior:ReceivePreInput(bool)
    self.PreInput = bool    
end

-- 输入处理
function ActionBehavior:Input(state)
    if state == "Walk" then
        self.Walking = true
    elseif state == "Idle" then
        self.Walking = false
    end
    --设置此输入为接受到的输入
    self.PreInput_Recived = state
end

--可释放时则直接释放
function ActionBehavior:Release()
    if self.PreInput_Recived then
        self[self.PreInput_Recived](self)
        self.PreInput_Recived = nil
    end
end

--控制输入主要函数. 
function ActionBehavior.ControllerMain(self)
    if self.BlockInput then return end
    if self.Walking then --如果正在走路 
        self:Walk()
    else
        self:Idle()
    end
    

    --如果能则释放
    self:Release()
end