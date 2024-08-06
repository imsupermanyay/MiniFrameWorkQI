local act = nil

local function IsAir(ply)
    if ply.Character.Velocity.Y < -700 then act.FallGround = true end
    if act.IsAir then return end
    if ply.Character.Velocity.Y  < 0 or ply.Character.Velocity.Y  > 900  then
        act.IsAir = true
        hook.Run("PlayerFalling",ply)
    end
end
 
--玩家第一次重生初始化
hook.Add("PlayerSqlDataInit","FightSpawnInitHook",function (plyuserid)
    if plyuserid ~= localPlayer.UserId then return end
    act = data.GetData(localPlayer.UserId,"ActionBehavior")
    if not act then  --如果没有那么 创建render
        act = ActionBehavior:new(localPlayer.Character) 
        data.SetData(localPlayer.UserId,"ActionBehavior",act)  
    end

    localPlayer.Character:Jump(false)


    ThinkManager:AddFunc({
        unique = "IsAir"..tostring(math.random(0,9999))..tostring(localPlayer.UserId),
        func = IsAir,
        index = 10, 
        tType = "Stepped"},
        localPlayer
    )

    -- localPlayer.Character:SetEnableContinueJump(false) 
    act:SwitchWeapons(Config_Fight.defaultweapons,localPlayer)
end)

--开始移动
hook.Add("MoveStart","PlayerMoveAnime",function ()
    act:Input("Walk")
end)
--停止移动  
hook.Add("MoveStop","PlayerStopAnime",function ()
    act:Input("Idle")
end)

--轻攻击
localPlayer.PlayerGui.HUD.LightAttack.Click:Connect(function(node,issuccess,mousepos) 
    act:Input("LightAttack")
end)

--重攻击
localPlayer.PlayerGui.HUD.HeavyAttack.Click:Connect(function(node,issuccess,mousepos) 
    act:Input("HeavyAttack")
end)

--跳跃按下
localPlayer.PlayerGui.HUD.Jump.TouchBegin:Connect(function(node,issuccess,mousepos)
    act:Input("Jump")
    act.JumpHold = true
end) 
--跳跃结束
localPlayer.PlayerGui.HUD.Jump.TouchEnd:Connect(function(node,isTouchEnd,mousepos)
    act:JumpEnd()
    act.JumpHold = false
end) 



--闪避
localPlayer.PlayerGui.HUD.Dodge.Click:Connect(function(node,issuccess,mousepos) 
end)

--锁定
localPlayer.PlayerGui.HUD.Lock.Click:Connect(function(node,issuccess,mousepos) 
end)


