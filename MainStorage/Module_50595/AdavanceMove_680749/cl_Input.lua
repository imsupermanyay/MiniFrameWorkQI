local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local camera = game:GetService("WorkSpace").CurrentCamera

Joystick = nil
local player = {
    position = Vector3.new(0, 0, 0),
    currentSpeed = Vector3.new(0, 0, 0),  
    targetRotation = Vector3.new(0, 0, 0), -- 目标
    currentRotation = Vector3.new(0, 0, 0), -- 当前
    rotationSpeed = 10, -- 旋转速度
    acceleration = 10, -- 启动加速度
    deceleration = 5, -- 停止减速度
    isMoving = false -- 用于检测移动状态
}
local W,A,S,D = false,false,false,false



-- 玩家重生时候 初始化轮盘
hook.Add("PlayerJoinServer", "JoyStickInit", function(ply)
    Joystick = EasyUI:Create("JoyStick", 100, 0.5)
    Joystick:Show()
    Joystick:SetPos(Vector2.new(173, 600))

    localPlayer.Character.Touched:Connect(function(node,pos,normal)
        if node.CollideGroupID == Config_Fight.CollideGroup_Ground and normal.Y >=  0.6 then
            hook.Run("TouchedGround",ply.UserId)
        end
    end)


end)


-- 线性插值
local function lerp(a, b, t)
    return a + (b - a) * t
end
-- 短路径插值 
local function lerpAngle(a, b, t)
    local diff = b - a
    if diff > 180 then
        diff = diff - 360
    elseif diff < -180 then
        diff = diff + 360
    end
    return a + diff * t
end

-- 更新玩家位置image.png
runService.RenderStepped:Connect(function(deltaTime)
    local x, y = Joystick:GetX(), Joystick:GetY()
    local maxSpeed = localPlayer.Character.Movespeed
 
    if W then y = -1 end
    if S then y = 1 end
    if A then x = -1 end
    if D then x = 1 end



    -- 获取摄像头的方向
    local cameraEuler = camera.Euler
    local cameraYaw = math.rad(cameraEuler.Y)
    local sinYaw = math.sin(cameraYaw)
    local cosYaw = math.cos(cameraYaw)

    -- 调整输入向量以匹配摄像头方向
    local adjustedX = x * cosYaw - y * sinYaw
    local adjustedY = x * sinYaw + y * cosYaw

    local targetSpeed = Vector3.new(adjustedX * maxSpeed, 0, adjustedY * maxSpeed)

    -- 确定使用的加速度
    local acceleration = (x ~= 0 or y ~= 0) and player.acceleration or player.deceleration


    -- 插值更新速度
    player.currentSpeed = Vector3.new(
        lerp(player.currentSpeed.x, targetSpeed.x, acceleration  * deltaTime),
        0,
        lerp(player.currentSpeed.z, targetSpeed.z, acceleration  * deltaTime)
    )

    -- 更新玩家位置 
    player.position = player.position + player.currentSpeed * deltaTime 
 
 
 

    -- 计算玩家的目标旋转角度
    if player.currentSpeed.x ~= 0 or player.currentSpeed.z ~= 0 then
        local angle = math.atan2(-player.currentSpeed.x, player.currentSpeed.z)
        local targetAngle = math.deg(angle)

        -- 确保角度平滑过渡
        if math.abs(targetAngle - player.currentRotation.y) > 180 then
            if targetAngle > player.currentRotation.y then
                player.currentRotation.y = player.currentRotation.y + 360
            else
                player.currentRotation.y = player.currentRotation.y - 360
            end
        end
        
        player.targetRotation.y = targetAngle
    end


    player.currentRotation = Vector3.new(0,lerpAngle(player.currentRotation.y, player.targetRotation.y, player.rotationSpeed * deltaTime),0)




    --最后设置
    localPlayer.Character.Euler = Vector3.new(localPlayer.Character.Euler.X, player.currentRotation.Y, localPlayer.Character.Euler.Z) 
    localPlayer.Character.Position = Vector3.new(player.position.X, localPlayer.Character.Position.Y, -player.position.Z)

    
    -- print(camera.Position) 
    -- print(camera.Euler) -- 这样可以获得摄像机的Euler。
    -- print("Player Position:", player.position)
    -- print("Current Speed:", player.currentSpeed)
end)

-- 检测移动状态变化
local function updateMoveState()
    local isCurrentlyMoving = W or A or S or D
    if isCurrentlyMoving and not player.isMoving then
        hook.Run("MoveStart")
    elseif not isCurrentlyMoving and player.isMoving then
        hook.Run("MoveStop")
    end
    player.isMoving = isCurrentlyMoving
end

 
-- 处理键盘输入开始 
local function onInputBegan(input, gameProcessed)
        if input.KeyCode == 119 then
            W = true
        elseif input.KeyCode == 115 then
            S = true
        elseif input.KeyCode == 97 then
            A = true
        elseif input.KeyCode == 100 then
            D = true
        end
        updateMoveState()
end
userInputService.InputBegan:Connect(onInputBegan)
  
  
-- 处理键盘输入结束
local function onInputEnded(input, gameProcessed)
    if input.KeyCode == 119 then
        W = false
    elseif input.KeyCode == 115 then
        S = false
    elseif input.KeyCode == 97 then
        A = false 
    elseif input.KeyCode == 100 then
        D = false
    end
    updateMoveState()
end
userInputService.InputEnded:Connect(onInputEnded)
