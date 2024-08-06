-- Hook系统表
local Hooks = {}
 
hook= {}
-- 添加钩子
function hook.Add(eventName, identifier, func)
    if type(identifier) ~= "string" then
        error("identifier 必须是字符串", 2) 
    end
    print("[Hook] [Add] : "..eventName.."/"..identifier)
    if not Hooks[eventName] then
        Hooks[eventName] = {}
    end
    Hooks[eventName][identifier] = func
end

-- 移除钩子
function hook.Remove(eventName, identifier)
    if Hooks[eventName] then
        Hooks[eventName][identifier] = nil
    end
end
  
-- 触发事件
function hook.Run(eventName, ...)
    print("[Hook] [Run] : "..eventName)
    if Hooks[eventName] then
        for identifier, func in pairs(Hooks[eventName]) do
            local success, err = pcall(func, ...)
            if not success then
                print(" hook 执行时发生错误 在 identifier ='" .. identifier .. "' 来自事件 '" .. eventName .. "' 错误信息: " .. err)
            end
        end
    end
end