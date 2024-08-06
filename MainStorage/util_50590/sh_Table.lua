-- 深度复制
function table.deepcopy(orig)
    local copy
    if type(orig) == "table" then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.deepcopy(orig_key)] = table.deepcopy(orig_value)
        end
    else
        copy = orig
    end
    return copy
end
--根据值删除表
function table.removeByValue(tbl, value)
    for i = #tbl, 1, -1 do
        if tbl[i] == value then
            table.remove(tbl, i)
        end
    end
end
--打印表
function table.printTable(obj, indent)
    indent = indent or 0
    local indentStr = string.rep("  |    |", indent)
    
    if type(obj) == "table" then
        for k, v in pairs(obj) do
            -- 打印键
            local keyStr = indentStr .. tostring(k) .. ": "
            
            if type(v) == "table" then
                print(keyStr)
                -- 递归打印值（自动生成适当的缩进级别）
                table.printTable(v, indent + 1)
            else
                -- 打印值
                print(keyStr .. tostring(v))
            end
        end
    else
        -- 打印值
        print(indentStr .. tostring(obj))
    end
end
--是否又值
function table.hasValue(tbl, value)
    for _, v in pairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end
--洗牌算法打乱表
function table.shuffleTable(t)
    -- 提取键值对到数组中
    local keys = {}
    for key in pairs(t) do
        table.insert(keys, key)
    end

    -- 使用 Fisher-Yates 洗牌算法打乱键
    for i = #keys, 2, -1 do
        local j = math.random(i) -- 在 1 到 i 之间生成一个随机数
        keys[i], keys[j] = keys[j], keys[i] -- 交换键
    end

    -- 创建一个新的表来存储打乱的结果
    local shuffled = {}
    for _, key in ipairs(keys) do
        shuffled[key] = t[key] 
    end

    return shuffled 
end 
--数组随机取值
function table.random(tbl)
    -- 获取表中的所有键
    local keys = {}
    for key in pairs(tbl) do
        table.insert(keys, key)
    end
    math.randomseed(math:MathSeed())
    -- 生成一个随机索引
    local randomIndex = math.random(1, #keys)
    -- 返回随机索引处的键对应的值
    return tbl[keys[randomIndex]]
end