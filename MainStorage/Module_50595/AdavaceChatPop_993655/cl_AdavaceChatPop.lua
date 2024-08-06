local workspace = game:GetService("WorkSpace")
local TweenService = game:GetService("TweenService")

ChatPop = {}
 

function ChatPop:NewPop(text)


    local obj = {}
    obj.pop = script.Parent.Prefab.TEXTPANEL:Clone()
    obj.pop.Position = Vector3.new(0,0,0)
    obj.pop.LocalScale =  Vector3.new(0,0,0)
    obj.pop.LocalEuler =  Vector3.new(0,0,190)
    
    -- 出现动画
    local tweenInfo = TweenInfo.new(
        0.7,                             -- 时间长度
        Enum.EasingStyle.Bounce,       -- 缓动样式
        Enum.EasingDirection.Out,      -- 缓动方向
        0,
        1                            -- 循环次数（-1表示无限循环）
    )
    -- 创建Tween
    local goal = {LocalScale = Vector3.new(1.28,0.75,0)}
    local tween = TweenService:Create(obj.pop, tweenInfo, goal)
    -- 播放Tween
    tween:Play() 




    --设置时间
    local time  =  #text/3 * 0.2 + 4
    --打字机效果实现
    local typewriter = Typewriter:new(text,0.05)
    typewriter:start(function (char)
        obj.pop.TEXT.Title = char
    end)
    --时间到之后删除
    Timer.Simple(time,function ()
        -- 出现动画
        local tweenInfo = TweenInfo.new(
            0.6,                             -- 时间长度
            Enum.EasingStyle.Quart,       -- 缓动样式
            Enum.EasingDirection.Out,      -- 缓动方向
            0,
            1                            -- 循环次数（-1表示无限循环）
        )
        -- 创建Tween
        local goal = {LocalScale = Vector3.new(0,0,0)}
        local tween = TweenService:Create(obj.pop, tweenInfo, goal)
        -- 播放Tween
        tween:Play()

        wait(1)
        obj.pop:Destroy() 
        typewriter:Destroy()
        
    end)

    self.__index = self
    setmetatable(obj,self)


    return obj
end


function ChatPop:SetPos(pos)
    self.pop.LocalPosition = pos
end


function ChatPop:SetParent(Parent)
    self.pop.Parent = Parent
end