Timer = {}
Timer.alltimer = {}
Timer.__index = Timer

function Timer:new(ident, secend, interval, repetfunc, finalfunc)
    local obj = {
        ident = ident,
        secend = secend,
        interval = interval,
        func = func,
        currentTime = 0, 
        totalTime = secend,
        timer = SandboxNode.new("Timer") -- 创建定时器节点
    }
    obj.timer.Delay = 0 -- 延迟多少秒开始
    obj.timer.Loop = true  -- 是否循环
    obj.timer.Interval = interval -- 循环间隔时间
    obj.timer.Callback = function() -- 回调方法
        obj.currentTime = obj.currentTime + interval
        if repetfunc then repetfunc() end
        if obj.currentTime >= secend then
            if finalfunc then finalfunc() end
            obj:destroy() -- 执行完后销毁定时器节点
        end
    end
    setmetatable(obj, Timer)
    obj.timer:Start()
    Timer.alltimer[ident] = obj
    return obj
end

function Timer:isExist()
    return Timer.alltimer[self.ident] ~= nil
end

function Timer:pause()
    if self.timer then
        self.timer:Stop()
    end
end

function Timer:resume()
    if self.timer then
        self.timer:Start()
    end
end

function Timer:leftTime()
    if self.timer then
        return math.max(0, self.totalTime - self.currentTime)
    end
    return 0
end

function Timer:Destroy()
    if self.timer then
        self.timer:Destroy()
        Timer.alltimer[self.ident] = nil
    end
end


-- 类静态变量和方法
TIMER = {}
function TIMER.IsExist(ident)
    return Timer.alltimer[ident] ~= nil
end

function TIMER.Pause(ident)
    if Timer.alltimer[ident] then
        Timer.alltimer[ident]:pause()
    end
end

function TIMER.Resume(ident)
    if Timer.alltimer[ident] then
        Timer.alltimer[ident]:resume()
    end
end

function TIMER.LeftTime(ident)
    if Timer.alltimer[ident] then
        return Timer.alltimer[ident]:leftTime()
    end
    return 0
end

function TIMER.Destroy(ident)
    if Timer.alltimer[ident] then
        Timer.alltimer[ident]:destroy()
    end
end

function Timer.Simple(secend, func)
    local timer = SandboxNode.new("Timer") -- 创建定时器节点
    timer.Delay = secend -- 延迟多少秒开始
    timer.Loop = false  -- 是否循环
    timer.Interval = secend -- 循环间隔时间
    timer.Callback = function() -- 回调方法
        func()
        timer:Destroy() -- 执行完后销毁定时器节点
    end
    timer:Start()
    return timer
end
