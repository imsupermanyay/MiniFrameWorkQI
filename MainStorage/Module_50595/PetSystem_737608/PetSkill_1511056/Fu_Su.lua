local Skill = {}

Skill.ClassName = "Fu_Su"
Skill.Name = "复苏"
Skill.Introduce = " 复苏的技能介绍在这里 "
Skill.Icon = "resid://283805319087656960"
Skill.Quality = "Artifact"
Skill.Size = {weight = 1, tall = 1} 
Skill.Data = {
    -- PhysicDanmage = 0,
    -- MagicDanmage = 0,
    -- PhysicDefens = 0,
    -- MagicDefens = 0,
    -- Hp = 0,
}
Skill.IsActiveSkill = false
--技能冲突
Skill.SkillClash = {
    
}  



--当玩家攻击时执行
function Skill:DoAttack()
    
end

--当玩家释放技能时
function Skill:DoSkill()
    
end

--当宠物受伤时执行
function Skill:Hurt()
    
end

--当宠物锁定敌人时执行
function Skill:SetTarget(actor)
    
end



function Skill:Executes()
    print("技能被执行")
end


function Skill:Exit()
    print("技能退出")
end




return Skill