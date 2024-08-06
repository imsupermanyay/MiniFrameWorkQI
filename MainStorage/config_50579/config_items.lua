Config_Items= {}
Config_Items.Quality = {
    ["Common"] = {
        Name = "普通",
        Color = {R = 169, G = 169, B = 169, A = 255},  -- 深灰色
    },      
    ["Rare"] = {
        Name = "稀有",
        Color = {R = 0, G = 191, B = 255, A = 255},    -- 深天蓝色
    },  
    ["Epic"] = {
        Name = "史诗",
        Color = {R = 128, G = 0, B = 128, A = 255},    -- 紫色
    },  
    ["Legendary"] = {
        Name = "传说",
        Color = {R = 255, G = 140, B = 0, A = 255},    -- 深橙色
    },  
    ["Artifact"] = {
        Name = "神器",
        Color = {R = 255, G = 0, B = 0, A = 255},      -- 红色
    },
}
Config_Items.Type = {
    ["Equipment"] = {
        Name = "装备" 
    },
    ["Material"] = {
        Name = "材料"
    },
    ["Prop"] =  {
        Name = "道具"
    },
}

--#region 所有武器Data
--[[
            Hp = 1000,     --血量   
            Hp_Regen = 0, --血量回复    
            Mana = 0,     --蓝量    
            Mana_Regen = 0, --蓝量回复  
            PhysicDanmage = 100, --物理伤害    
            MagicDanmage = 100, --魔法伤害    
            PhysicDefens = 200, --物理防御    
            MagicDefensPhysicDefens = 200, --魔法防御    
            CritRate = 10, --暴击率    
            CritDanmage = 10, --暴击伤害    
            Speed = 0, --速度    
            Gravity = 0, --重力    
            Vamp = 0, --吸血    
            Magic_Pen = 0, --魔法穿透
            Physic_Pen = 0 --物理穿透
]] 
--#endregion
 

EQUIPMENT= {
    WEAPON = 1,
    FACE = 2,
    HEAD = 3,
    ARMOR = 4,
    PANTS = 5,
    SHOES = 6,
    CLOAK = 7,
    GLOVE = 8,
    RING_LEFT = 9,
    RING_RIGHT = 10,
    BAG = 11,  
    SUIT = 12
}

 

Config_Items.Items = {}
Config_Items.Items.Equipment = { 
    ["BigSword_Drgone"] = {
        Name = "斩龙刀",
        Quality = "Artifact",
        Icon = "RainbowId&filetype=5://264970277352734720",
        Size = {weight = 1, tall = 2},
        Introduce = "牺牲生命换取力量！",
        Strengthen = 0,  
        Data = { 
            Slot = EQUIPMENT.WEAPON,
            Hp = -100, 
            PhysicDanmage = 100,
            MagicDanmage = 100,
            PhysicDefens = 200,
            MagicDefensPhysicDefens = 200,
            CritRate = 10, 
            CritDanmage = 10,
            Vamp = 10,
        }
    }
}  




Config_Items.Items.Material = {
    ["Material1"] = {
        Name = "吊坠",
        Quality = "Rare",
        Icon = "RainbowId&filetype=5://264256416051986432",
        Size = {weight = 1, tall = 1},
        Introduce = "材料介绍",
    }
}  
Config_Items.Items.Prop = {
    ["Prop1"] = {
        Name = "煮熟的枸杞",
        Quality = "Common",
        Icon = "RainbowId&filetype=5://256274077445566464",
        Size = {weight = 1, tall = 1},
        Introduce = "道具介绍煮熟的枸杞，可以吃。没了。",
        UseFunc = function (self,ply)
            print("煮熟的枸杞被使用了")
            return true
        end
    }
}   