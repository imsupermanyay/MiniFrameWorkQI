
local WorldService = game:GetService("WorldService")
------------------------------------------[[ 算法 ]]----------------------------------------  
-- 返回小数点后面的数
function math.GetFractionalPart(number)
    -- 将数字转换为字符串以便于处理
    local str = tostring(number)
    
    -- 找到小数点的位置
    local decimalPointIndex = string.find(str, "%.")
    
    if decimalPointIndex then
        -- 提取小数部分
        local fractionalPart = string.sub(str, decimalPointIndex + 1)
        return tonumber(fractionalPart)
    else
        -- 如果没有小数点，返回0
        return 0
    end
end

-- 给你返回一个相对原版较好的随机的随机数
function math.MathSeed()
    local seed =  math.GetFractionalPart (tostring(os.time()):reverse():sub(1, 7)+ os.clock() + math.random() / math.random())
    return seed
end


 


------------------------------------------[[ UI ]]----------------------------------------  
function math.getGlobalPosition(uiComponent)
    print()
    if not uiComponent.Position then
        return Vector2.new(0,0)
    end
    local position = uiComponent.Position
    
    -- 如果存在父节点，递归计算父节点的全局坐标
    if uiComponent.Parent and uiComponent.Parent.Position then 
        local parentGlobalPosition = math.getGlobalPosition(uiComponent.Parent)
        position = position + parentGlobalPosition
            
    end
    
    return position
end 




------------------------------------------[[ 三维数学 ]]----------------------------------------  
--计算矢量1到矢量2的距离 
function math.CalculateDistance(vector1, vector2)
    -- 计算差值向量
    local dx = vector2.x - vector1.x
    local dy = vector2.y - vector1.y
    local dz = vector2.z - vector1.z

    -- 计算欧几里得距离
    local distance = math.sqrt(dx * dx + dy * dy + dz * dz)
    return distance
end

--计算矢量1到矢量2的方向  返回一个方向性向量
function math.CalculateDirection(vector1, vector2)

    -- 计算两个矢量的差值
    local direction = vector2 - vector1
    Vector3.Normalize(direction)

    return direction
end

-- 此方向绕 轴旋转 角度 后 求出的方向
function math.RotateVector(direction, axis, angle)
    local quaternion = Quaternion.FromAxisAngle(axis, angle)
    local rotatedVector = quaternion * direction
    return Vector3.new(rotatedVector.x, rotatedVector.y, rotatedVector.z)
end

-- 定义一个函数将方向向量转换为欧拉角
function math.DirectionToEuler(direction)
    -- 假设方向向量已经归一化
    local dx, dy, dz = direction.X, direction.Y, direction.Z

    -- 计算俯仰角（Pitch）
    local pitch = math.asin(dy)

    -- 计算偏航角（Yaw）
    local yaw = math.atan2(dx, dz)

    -- 因为我们没有倾斜角（Roll），所以设为 0
    local roll = 0

    -- 返回欧拉角
    return Vector3.new( - math.deg(pitch), math.deg(yaw), math.deg(roll))
end

-- 定义一个函数来计算两个向量的叉积
function math.CrossProduct(vector1, vector2)
    return Vector3.new(
        vector1.Y * vector2.Z - vector1.Z * vector2.Y,
        vector1.Z * vector2.X - vector1.X * vector2.Z,
        vector1.X * vector2.Y - vector1.Y * vector2.X
    )
end

-- 定义一个函数来计算方向向量的左手边方向
function math.GetLeftDirection(direction)
    -- 确保方向向量已经归一化
    Vector3.Normalize(direction)

    -- 定义一个上向量（假设 Y 轴向上）
    local up = Vector3.new(0, 1, 0)

    -- 计算左手方向向量，通过计算方向向量和上向量的叉积
    local leftDirection = math.CrossProduct(up, direction)
    Vector3.Normalize(leftDirection)
    -- 返回归一化后的左手边方向向量
    return leftDirection
end

-- 定义一个函数来计算方向向量的右手边方向
function math.GetRightDirection(direction)
    -- 确保方向向量已经归一化
    Vector3.Normalize(direction)

    -- 定义一个上向量（假设 Y 轴向上）
    local up = Vector3.new(0, 1, 0)

    -- 计算左手方向向量，通过计算方向向量和上向量的叉积
    local leftDirection = math.CrossProduct(direction, up)
    Vector3.Normalize(leftDirection)
    -- 返回归一化后的左手边方向向量
    return leftDirection
end

-- 定义一个函数来计算此方向碰撞到的点
function math.GetRayCast(pos,dir,dis)
    local posobj = WorldService:RaycastClosest(pos,dir,dis,true,{0,1,2,3,4,5,6,7,8,9,10,11})
    if posobj and posobj.isHit then
        return posobj.position
    else
        return pos + dir * dis
    end

end

--获得Actor 的面朝方向 返回方向性矢量
function math.GetDir(Actor)
    return Actor.Rotation:LookDir()     
end