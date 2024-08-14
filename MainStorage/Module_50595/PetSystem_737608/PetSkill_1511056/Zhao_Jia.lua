local Skill = {}
 
Skill.ClassName = "Zhao_Jia"
Skill.Name = "招架"
Skill.Introduce = " 复苏的技能介绍在这里 "
Skill.Icon = "resid://283805233519661056"
Skill.Quality = "Artifact"
Skill.Size = {weight = 1, tall = 1}
Skill.Data = {
    -- PhysicDanmage = 0,
    -- MagicDanmage = 0,
    -- PhysicDefens = 0,
    -- MagicDefens = 0,
    -- Hp = 0,
    
}
Skill.SkillClash = {
    
}  


function Skill:Think()
     
end 

function Skill:Executes()
    print("技能被执行")
end


function Skill:Exit()
    print("技能退出")
end

return Skill