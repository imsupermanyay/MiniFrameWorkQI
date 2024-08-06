local Weapons = {}
Weapons.Name = "巨剑"
Weapons.Attack = 100
Weapons.ControllerAsset = "resid&restype=12://279762338452295680"
Weapons.Anime ={ 
    ["Dead_Ground"] = "Dead_Ground",
    ["Dead_Stand"] = "Dead_Stand",
    ["Hurt_Air_Start"] = "Hurt_Air_Start",
    ["Hurt_Air_Loop"] = "Hurt_Air_Loop",
    ["Hurt_Air_End"] = "Hurt_Air_End",

    ["Walk_Forward"] = "Walk_Forward",

    ["Idle"] = "Idle",

    ["Hurt01"] = "Hurt01",
    ["Hurt02"] = "Hurt02",
    ["Hurt03"] = "Hurt03",
    ["Hurt04"] = "Hurt04",
    ["Hurt05"] = "Hurt05",


    ["Dodge_Sprint"] = "Dodge_Sprint",
    ["Dodge_Roll"] = "Dodge_Roll",

    ["Jump_Start"] = "Jump_Start",
    ["Jump_Loop"] = "Jump_Loop",
    ["Jump_End"] = "Jump_End",

    ["Light02"] = "Attack_Light02",
    ["Light03"] = "Attack_Light03",
    ["Light04"] = "Attack_Light04",

    ["Heavy01"] = "Attack_Heavy01",
    ["Heavy02"] = "Attack_Heavy02",
    ["Heavy03"] = "Attack_Heavy03",
 
    ["Dodge01"] = "Attack_Dodge01",
    ["Dodge02"] = "Attack_Dodge02",
}
Weapons.AnimeData ={
    ["Jump_Start"] = {time = 0.533},
    ["Jump_End"] = {time = 1.267},
}








Weapons.Combo = {
    -- DodgeCombo = {{Anime = "Dodge01", Type = "Light"}, {Anime = "Dodge01", Type = "Light"}},

    LightCombo1 = {{Anime = "Light02", Type = "Light"}, {Anime = "Light03", Type = "Light"}, {Anime = "Light04", Type = "Light"}},
    LightCombo2 = {{Anime = "Light02", Type = "Light"}, {Anime = "Light03", Type = "Light"}, {Anime = "Heavy03", Type = "Heavy"}},


    HeavyCombo1 = {{Anime = "Heavy01", Type = "Heavy"}, {Anime = "Heavy02", Type = "Heavy"}, {Anime = "Heavy03", Type = "Heavy"}},
    HeavyCombo2 = {{Anime = "Heavy01", Type = "Heavy"}, {Anime = "Heavy02", Type = "Heavy"}, {Anime = "Light04", Type = "Light"}},
}




function Weapons:Light02()
    print("Light02")
end
function Weapons:Light03()
    print("Light03")
end
function Weapons:Light04()
    print("Light04")

end



function Weapons:Heavy01()
    print("Heavy01")
end
function Weapons:Heavy02()
    print("Heavy02")
end
function Weapons:Heavy03()
    print("Heavy03")
end





function Weapons:Dodge()
end
  
function Weapons:Jump()
end

function Weapons:Jump_Attack()
end

function Weapons:Dash()
end

function Weapons:Dash_Attack()
end

function Weapons:Hurt()
end

function Weapons:Skill()
end 


return Weapons