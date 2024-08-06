PET = {}


PET.BaseValue_Hp = 0
PET.BaseValue_PhysicDanmage = 0
PET.BaseValue_MagicDanmage = 0
PET.BaseValue_PhysicDefens = 0
PET.BaseValue_MagicDefens = 0 

PET.Size = 1 
PET.Tall = 250
PET.Speed = 400
PET.SkillCoolDown = 10
PET.Model = "resid&restype=12://278655975002697728"
PET.ControllerAsset = "resid&restype=12://278575624803274752"
PET.HeadIcon = "resid://279379558758838272"
PET.Nick = "狗子"

PET.Chat ={  
    Attack = {
        "我咬死你"
    },
    Call ={
        "我直接登场"
    },
    Dead = {
        "我不行了，我死了，真的"
    }, 
    Fight = {
        "我以高达形态出击"
    },
    Skill = {
        "我还有技能"
    },
    Idle ={
        "我直接喵喵喵",
        "我是狗,我无敌闪电旋风劈，我龙卷风摧毁停车场",
        "什么时候充钱给我买装备？"
    },
    Follow ={
        "哎你等等我啊",
        "老登你怎么跑那么快"
    }
}



function PET:DoSkill()
    
end
function PET:DoAttack()
    
end
function PET:Dead()
    
end
function PET:Hurt()
    
end

return PET