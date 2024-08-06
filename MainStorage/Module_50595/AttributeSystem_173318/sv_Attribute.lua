Attribute = Attribute or {}

Attribute.DefaultData = {
    Hp = 100,                     -- 生命值
    Hp_Regen = 0,                 -- 生命值回复速度
    Mana = 0,                     -- 法力值
    Mana_Regen = 0,               -- 法力值回复速度
    PhysicDanmage = 10,           -- 物理攻击力
    MagicDanmage = 10,            -- 魔法攻击力
    PhysicDefens = 10,            -- 物理防御力
    MagicDefensPhysicDefens = 10, -- 魔法防御力
    CritRate = 10,                -- 暴击几率
    CritDanmage = 10,             -- 暴击伤害
    Speed = 500,                  -- 移动速度
    Gravity = 100,                -- 重力
    Vamp = 0,                     -- 吸血率
    Magic_Pen = 10,               -- 魔法穿透
    Physic_Pen = 10,              -- 物理穿透
}





--玩家加入服务器 给背包初始化
hook.Add("PlayerSqlDataInit", "Attribute_PlayerJoinServer", function(ply)
    --数据初始化
    sqldata.InitSqlData(ply.UserId,"Attribute",Attribute.DefaultData)
    local m_data = sqldata.GetSqlData(ply.UserId,"Attribute")
    --属性初始化
    ply:SetAttribute("Hp", m_data.Hp)
    ply:SetAttribute("Hp_Regen", m_data.Hp_Regen)
    ply:SetAttribute("Mana", m_data.Mana)
    ply:SetAttribute("Mana_Regen", m_data.Mana_Regen)
    ply:SetAttribute("PhysicDanmage", m_data.PhysicDanmage)
    ply:SetAttribute("MagicDanmage", m_data.MagicDanmage)
    ply:SetAttribute("PhysicDefens", m_data.PhysicDefens)
    ply:SetAttribute("MagicDefensPhysicDefens", m_data.MagicDefensPhysicDefens)
    ply:SetAttribute("CritRate", m_data.CritRate)
    ply:SetAttribute("CritDanmage", m_data.CritDanmage)
    ply:SetAttribute("Speed", m_data.Speed)
    ply:SetAttribute("Gravity", m_data.Gravity)
    ply:SetAttribute("Vamp", m_data.Vamp)
    ply:SetAttribute("Magic_Pen", m_data.Magic_Pen)
    ply:SetAttribute("Physic_Pen", m_data.Physic_Pen)
end)


