
local PetEquipment = { 
    ["PetArmor"] = {
        Name = "宠物装备A",
        Quality = "Artifact",
        Icon = "resid://276169242448539648",
        Size = {weight = 1, tall = 2},
        Introduce = "宠物装备的介绍",
        Strengthen = 0,  
        Data = { 
            Slot = "Armor",
            Hp = 1000, 
        }
    },
    ["PetNeck"] = {
        Name = "宠物NeckA",
        Quality = "Artifact",
        Icon = "RainbowId&filetype=5://264256531063996416",
        Size = {weight = 1, tall = 2},
        Introduce = "宠物装备的介绍",
        Strengthen = 0,  
        Data = { 
            Slot = "Neck",
            MagicAttack = 1000, 
            PhsicAttack = 1000, 
        }
    },
    ["PetJewelry"] = {
        Name = "宠物JewelryA",
        Quality = "Artifact",
        Icon = "RainbowId&filetype=5://264970277352734720",
        Size = {weight = 1, tall = 2},
        Introduce = "宠物装备的介绍",
        Strengthen = 0,  
        Data = { 
            Slot = "Jewelry",
            MagicDefens = 100,
            PhsicDfens = 100,
        }
    } 
    
}  
 
 
--穿着宠物装备的函数 
function PetEquipmentFunc(itemdata,ply,bagobj)
    print("玩家给宠物使用了装备") 
 
    --获得Pet管理
    local PlayerPet = data.GetData(ply.UserId,"PetManager")
    local result = PlayerPet:Equipment(bagobj.ChoisePet,itemdata,ply)

    return result 
end


Item.Func.LoadItem(PetEquipment,"PetEquipment","宠物装备",PetEquipmentFunc)