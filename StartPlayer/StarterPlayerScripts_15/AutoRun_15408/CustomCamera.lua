repeat wait(0.5) until CameraModule


local config = { view = {}}
config.view.defalt = { fov = 40, distance = 1400,high = 140,Yoffset = 110,MinZoom = 100}
config.view.office = { fov = 75, distance = 700,high = 0,Yoffset = 0 , MinZoom = 200}
config.view.checfg = { fov = 75, distance = 600,high = 60,Yoffset = 30 , MinZoom = 150}
local currentviewconfig = "checfg"


--动态计算当前索引以及所有的config
local allview = {}
local currentindex = 0
for key, value in pairs(config.view) do
    table.insert(allview,key)
    if key == currentviewconfig then
        currentindex = #allview
    end
end


local Camera = {}

function Main()
    --[[  导入      ]]--
    local customCamera = {}
    local WorkSpace = game:GetService("WorkSpace")
    local Players = game:GetService('Players')
    local localplayer = Players.LocalPlayer 
    local GameSetting = game:GetService("GameSetting")
    local RunService = game:GetService("RunService")
    local cfg = config.view[currentviewconfig]
    local ConfigService = game:GetService("ConfigService")

    --#改变视角
    function Camera.ChangeCfg()

        currentindex = currentindex+1 
        if currentindex > #allview then
            currentindex = 1
        end
        currentviewconfig = allview[currentindex]
        cfg = config.view[currentviewconfig]
        
        localplayer.CameraMaxZoomDistance = cfg.distance
        CameraModule.activeCameraController.m_currentDistance = cfg.distance
        game:GetService("WorkSpace").CurrentCamera.FieldOfView = cfg.fov
        CameraModule.activeCameraController.m_player.CameraMinZoomDistance = cfg.MinZoom

        
    end



    --[[   数据初始化      ]]--
    local shakcontro = false 
    local smoothshakecontro = false
    local originax = 0
    local originay = 0
    local originaz = 0
    local offsetX = 0
    local offsetY = 0
    local offsetZ = 0
    local fovspeed = 0.1

    local StartChangeFov = false
    local desnityfov = 90
    local currentfov = 90
    local initfov = 90
    local decress = false


    --[[  函数数据初始化   ]]--


    local function startShake(intensity,speed)
        shakcontro = true 
        while (shakcontro) do
            wait(speed)
            offsetX = math.random() * intensity - intensity / 2
            offsetY = math.random() * intensity - intensity / 2
            offsetZ = math.random() * intensity - intensity / 2
        end
    end
    local function StopFlashShake()
        shakcontro = false 
        CameraModule.activeCameraController.m_rotation.x =  originax
        CameraModule.activeCameraController.m_rotation.y =  originay
        CameraModule.activeCameraController.m_rotation.z =  originaz

    end

        --[[     找到最大数字      ]]--
        local function findMaxNumber(num1, num2, num3)
            local maxNumber = num1
        
            if num2 > maxNumber then
                maxNumber = num2
            end
        
            if num3 > maxNumber then
                maxNumber = num3
            end
        
            return maxNumber
        end
    local time__ = 0
    local fov_time__ = 0
    local maxHorizontal_time = 0
    local maxVertical_time = 0
    local maxRotate_time = 0
    local maxnumber = 0
    local Horizontal_fequency = 0
    local Vertical_fequency = 0
    local Rotate_fequency = 0
    local Horizontal_amplitude = 0
    local Vertical_amplitude = 0
    local Rotate_amplitude = 0
    local turnback = 0
    
    function StartHorizontal(amplitude,frequency,time)
        maxHorizontal_time = time
        Horizontal_fequency = frequency
        Horizontal_amplitude = amplitude
    end
    function StartVertical(amplitude,frequency,time)
        maxVertical_time = time
        Vertical_fequency = frequency
        Vertical_amplitude = amplitude
    end
    function StartRotate(amplitude,frequency,time)
        maxRotate_time = time
        Rotate_fequency = frequency
        Rotate_amplitude = amplitude
    end



                                 --[[调用]]--
    -- # StartFlashShake
    --  开始瞬移抖动
    -- 
    -- 
    function Camera.StartFlashShake(intensity,speed,interval)
        originax = CameraModule.activeCameraController.m_rotation.x
        originay = CameraModule.activeCameraController.m_rotation.y
        originaz = CameraModule.activeCameraController.m_rotation.z
        coroutine.work(
            function()
                wait(interval)
                StopFlashShake()
            end
        )
        startShake(intensity,speed) 

    end


    -- # StartBounceShake(水平强度，水平频率，水平时间，垂直强度,垂直频率,垂直时间，旋转强度，旋转频率，旋转时间)
    --  开始弹跳抖动
    -- 
    -- 
    function Camera.StartBounceShake(Horizontal_amplitude,Horizontal_frequency,Horizontal_time,Vertical_amplitude,Vertical_frequency,Vertical_time,Rotate_amplitude,Rotate_frequency,Rotate_time)

        coroutine.work(
            function()
                StartHorizontal(Horizontal_amplitude,Horizontal_frequency,Horizontal_time)
                StartVertical(Vertical_amplitude,Vertical_frequency,Vertical_time)
                StartRotate(Rotate_amplitude,Rotate_frequency,Rotate_time)
            end
        )
        time__ = 0
        maxnumber = findMaxNumber(Horizontal_time,Vertical_time,Rotate_time)
        smoothshakecontro = true 
    
        
        
    end
    
    -- # TurnBack
    --  跳转角度180°
    -- 
    -- 
    function Camera.TurnBack()
        turnback = turnback == 180 and 0 or 180 
    end

    
    -- # SmoothChangeFov
    --  改变FOV 丝滑改变  注意 函数原因 目标值不能大于初始值80
    --  arg1 目标值 arg2 是否返回为原本的FOV arg3 多久后返回  arg4 每帧增加多少x轴的值
    -- 
    function Camera.SmoothChangeFov(desnityfov_,isturnback,time,speed)
        fovspeed = speed

        coroutine.work(
            function()
                Camera.SmoothChangeFovToValue(desnityfov_ + config.view[currentviewconfig].fov)
                
        
                if not isturnback then return end
                wait(time)
                Camera.SmoothChangeFovToValue(config.view[currentviewconfig].fov)
            end
        )

    end
   


    function Camera.SmoothChangeFovToValue(desnityfovs)


        --初始数据
        desnityfov = desnityfovs
        currentfov = WorkSpace.CurrentCamera.FieldOfView
        initfov = currentfov
        fov_time__ = 0

        -- 判断是否是加减
        if currentfov > desnityfov then
            decress= true
        else
            decress= false
        end


        StartChangeFov =true
    end
    

    --[[     重写      ]]--


    CameraModule.activeCameraController.SetPosition = function(self,pos)
        game:GetService("WorkSpace").CurrentCamera.Position = Vector3.New(pos.x,pos.y ,pos.z)
        self.m_lastEyePos = pos
    end


    CameraModule.activeCameraController.GetQuaternion = function(self,pos)
        if ConfigService.LCSMode then
            return self.m_quaFreeView
        end
        
        -- print(offsetX)
        -- print(offsetY)
        -- print(offsetZ)
        return Quaternion.FromEuler(self.m_rotation.x + offsetX , self.m_rotation.y +offsetY + turnback, self.m_rotation.z + offsetZ)
    end

    CameraModule.activeCameraController.Update = function (self)
        WorkSpace = game:GetService("WorkSpace")
        local camType = WorkSpace.CurrentCamera.CameraType
        if  camType == Enum.CameraType.Scriptable then
        elseif 
        camType == Enum.CameraType.Watch or 
        camType == Enum.CameraType.Track or  
        camType == Enum.CameraType.Follow or 
        camType == Enum.CameraType.Custom  then
            
            local subpos = self:GetSubjectPosAndEuler()
            if not subpos then 
                return
            end		 
            local quaternion = self:GetQuaternion()
            local lookdir = quaternion:RotateToDir(Vector3.New(0, 0, 1))
            local eyepos = Players.LocalPlayer:EyePosWithFilter(subpos, -lookdir,{2,3,4}, self:GetEyeDistance())
            -- print(tostring(self.m_rotation))
            -- table.printTable(self.m_rotation)
            -- if self.m_rotation.x <0 then
            --     eyepos = eyepos_ + Vector3.New(0, 1, 0) * 50
            -- else
            --     eyepos = eyepos_ + Vector3.New(0, -1, 0) * 50
            -- end
            
            local dist = (eyepos - subpos).Length
            local maxdist = config.view[currentviewconfig].distance
            local percent = dist/maxdist
            local Yoffset = config.view[currentviewconfig].Yoffset
            local maxhigh = config.view[currentviewconfig].high+Yoffset
    
            local hight = maxhigh * percent
            local resulthight = hight-Yoffset
            --print(percent)
            -- -- if resulthight < 0 then
            -- --     resulthight = 0
            -- -- end
            -- --print(resulthight)
            -- print(resulthight)
            -- print(self.m_rotation.x)

            eyepos = eyepos + Vector3.new(0,1,0) * resulthight
            -- print(result)
            local dir = eyepos - subpos
            local distance = dir.Length
            dir:Normalize()

            -- print(dir)
            -- print(distance)
            
            local finalresultpos = Players.LocalPlayer:EyePosWithFilter(subpos, dir,{2,3,4}, distance )

    



            self:SetPosition(finalresultpos)
            self:SetQuaternion(quaternion)
        end
    
    end
    
    

    -- timeFactor = frequency * time + degreesToRadians(phase);
    -- sinValue = Math.sin(timeFactor);
    -- rotationValue = sinValue * amplitude;
    -- transform.rotation + rotationValue;
    --y = (A / 2^n) * sin(B * x + C) + D
    --[[     函数      ]]--
    function customCamera:Init()    
        --初始化
        localplayer.CameraMaxZoomDistance = cfg.distance
        CameraModule.activeCameraController.m_currentDistance = cfg.distance
        game:GetService("WorkSpace").CurrentCamera.FieldOfView = cfg.fov
        CameraModule.activeCameraController.m_player.CameraMinZoomDistance = cfg.MinZoom
        --钩子
        RunService:UnbindFromRenderStep("CustomCameraControlUpdate")
        RunService:BindToRenderStep("CustomCameraControlUpdate", Enum.RenderPriority.Camera.Value+2, function( dt ) 
            self:Update(dt)
        end)
        
    end 


    local function log(base, x)
        return math.log(x) / math.log(base)
    end

    function customCamera:Update(dt)
        
        --[[函数曲线]]--
        if smoothshakecontro then
            -- print(tostring(maxnumber.."/"..tostring(time__)))
            -- print(tostring(offsetX.."/"..tostring(offsetY)))
            time__ = time__+dt
            if time__ > maxnumber then    --关闭
                smoothshakecontro = false 
                offsetX = 0
                offsetY = 0
                offsetZ = 0
            end 

            
            --  Horizontal_fequency  4     Rotate_fequency 2.5
            -- Horizontal_amplitude 25
            --计算偏移
            if time__ < maxHorizontal_time then
                offsetX = math.sin((time__/Horizontal_fequency)) * (maxHorizontal_time-time__) * 1/(time__+Horizontal_amplitude) 
            end
            if time__ < maxVertical_time then
                offsetY = math.sin((time__/Vertical_fequency)) * (maxVertical_time-time__) * 1/(time__+Vertical_amplitude) 
            end
            if time__ < maxRotate_time then
                offsetZ = math.sin((time__/Rotate_fequency))* (maxRotate_time-time__) * 1/(time__+Rotate_amplitude)
            end
        end

 
        --改变FOV
        if StartChangeFov then
            fov_time__ = fov_time__+fovspeed


            --缓动函数
            if decress then
                currentfov = -log(1.1,fov_time__+1)+initfov
            else
                currentfov = log(1.1,fov_time__+1)+initfov
            end
            WorkSpace.CurrentCamera.FieldOfView = currentfov





            -- 如果快到了直接结束 
            if currentfov >= desnityfov-0.01 and not decress then --达到
                currentfov = desnityfov
                WorkSpace.CurrentCamera.FieldOfView = currentfov
 
                StartChangeFov = false
                fov_time__ = 0
            elseif currentfov <= desnityfov+0.01 and decress then
                currentfov = desnityfov
                WorkSpace.CurrentCamera.FieldOfView = currentfov

                StartChangeFov = false
                fov_time__ = 0
            end




        end



    end
 

    customCamera:Init()





    





    return customCamera

end



 