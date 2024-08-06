---@diagnostic disable: duplicate-set-field

Effect = {}
local workspace = game:GetService("WorkSpace")
local RunService = game:GetService("RunService")
 
if RunService:IsClient() then 
    --添加一个特效
    function Effect:NewEffect(EffectName,offset,timer)
        if not script.Parent.Prefab[EffectName] then print("lua error: 特效不存在NewActorEffect") return end
        if not timer then timer = 10 end
        Trans =SandboxNode.New('Transform',workspace)
        Trans.Name= EffectName
        Trans.LocalPosition= Vector3.New(0,0,0)
        Trans.Position= offset or Vector3.New(0,0,0)
        local Effect = script.Parent.Prefab[EffectName]:Clone() 
        Effect.Parent = Trans  
        Effect.LocalPosition = Vector3.New(0,0,0)
        if Effect.ReStart then 
            Effect:ReStart()
        end
        Effect.Enabled = true
        Effect.Visible = true 
        if Effect.ReStart then
            Effect.EnabledRenderer = true  
        end
        Timer.Simple(timer,function () 
            Trans:Destroy()
        end)
        return Trans
    end
    --添加一个角色特效
    function Effect:NewActorEffect(EffectName,offset,Actor,timer)
        if not script.Parent.Prefab[EffectName] then print("lua error: 特效不存在NewActorEffect") return end
        if not timer then timer = 10 end 
        
        Trans =SandboxNode.New('Transform',Actor)
        Trans.Name= EffectName
        Trans.LocalPosition= offset or Vector3.New(0,0,0)
        local Effect = script.Parent.Prefab[EffectName]:Clone()
        Effect.Parent = Trans
        Effect.LocalPosition = Vector3.New(0,0,0)
        if Effect.ReStart then
            Effect:ReStart()
        end
        Effect.Enabled = true
        Effect.Visible = true

        if Effect.ReStart then
            Effect.EnabledRenderer = true  
        end


        Timer.Simple(timer,function ()
            Trans:Destroy()
        end)
        return Trans
    end

    net.Receive("HandyEffectNet", function (EffectName,offset,timer)
        Effect:NewEffect(EffectName,offset,timer)
    end)

    net.Receive("HandyEffectActorNet", function (EffectName,offset,Actor,timer)
        Effect:NewActorEffect(EffectName,offset,Actor,timer)
    end)

else
 
    function Effect:NewEffect(ply,EffectName,offset,timer)
        print(tostring(offset))
        net.Fire(ply.UserId,"HandyEffectNet",EffectName,offset,timer)
    end
    function Effect:NewActorEffect(ply,EffectName,offset,Actor,timer)
        print(tostring(offset))
        net.Fire(ply.UserId,"HandyEffectActorNet",EffectName,offset,Actor,timer)
    end

end

 