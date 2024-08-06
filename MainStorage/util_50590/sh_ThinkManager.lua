local RunService = game:GetService("RunService")
ThinkManager = {
    AllFuncObj = {
        RenderStepped = {},
        Stepped = {},
    },
    Handle = {
        RenderStepped = {},
        Stepped = {},
    }
}
 
-- 增加Func，index 数字越小越先执行
function ThinkManager:AddFunc(tab, ...)
    local unique, func, index, thinkType = tab.unique, tab.func, tab.index, tab.tType
    if not self.AllFuncObj[thinkType] then 
        print("lua error: [ThinkManager]尝试给一个不存在的Think类型添加Func") 
        return 
    end
    if self.AllFuncObj[thinkType][unique] then 
        print("lua error: [ThinkManager]尝试重复添加ThinkFunc") 
        return 
    end
    local funcobj = { 
        unique = unique, -- 存储 unique
        func = func,
        index = index,
        tType = thinkType,
        args = {...}
    }
    self.AllFuncObj[thinkType][unique] = funcobj
    -- 根据index排序AllFuncObj，生成Handle
    self:UpdateHandle()
end 

-- 删除Func
function ThinkManager:RemoveFunc(tType,unique)
    self.AllFuncObj[tType][unique] = nil
    self:UpdateHandle()
end

-- 更新Handle，按index排序
function ThinkManager:UpdateHandle() 
    self.Handle = {
        RenderStepped = {},
        Stepped = {},
    }
    for tType, tTypeAllFunc in pairs(self.AllFuncObj) do
        for ThinkId, ThinkObj in pairs(tTypeAllFunc) do 
            table.insert(self.Handle[tType],ThinkObj)
        end 
        table.sort(self.Handle[tType], function(a, b) return a.index < b.index end)
    end 
end

-- RenderStepped回调函数 
RunService.RenderStepped:Connect(function(deltaTime)
    for _, funcobj in ipairs(ThinkManager.Handle.RenderStepped) do
        local success, err = pcall(funcobj.func, deltaTime, unpack(funcobj.args))
        if not success then
            print("Lua error: 尝试调用函数时发生错误 ThinkManager Ident='" .. funcobj.unique .. "' 错误信息: " .. err)
            ThinkManager:RemoveFunc("RenderStepped",funcobj.unique)
        end
    end
end)

-- Stepped回调函数 
RunService.Stepped:Connect(function()
    for _, funcobj in ipairs(ThinkManager.Handle.Stepped) do
        local success, err = pcall(funcobj.func, unpack(funcobj.args))
        if not success then
            print("Lua error: 尝试调用函数时发生错误 ThinkManager Ident='" .. funcobj.unique .. "' 错误信息: " .. err)
            ThinkManager:RemoveFunc("Stepped",funcobj.unique)
        end
    end
end)
