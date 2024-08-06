local runService = game:GetService("RunService")

local PANEL = {}

function PANEL:Init(radius,returnTime)
 
    self.X = 0 
    self.Y = 0
    self.radius = radius
    self.returnTime = returnTime
    self.MainNode = self.Prefab.Joystick:Clone()
    self.MainNode.Size = Vector2.New(radius * 2, radius * 2)
    self.MainNode.Pivot = Vector2.New(0.5, 0.5)

 
    self.JoyStick = self.MainNode.JoystickDot  
    self.JoyStick.Size = Vector2.New(radius, radius)
    self.JoyStick.Pivot = Vector2.New(0.5, 0.5) 
    self.JoyStick.Position = Vector2.New(radius, radius)

    self:initializeEvents()

    self.startPos = self.JoyStick.Position
end


function PANEL:initializeEvents()
    self.MainNode.TouchBegin:Connect(function(_, _, mousePos)
        self.isDragging = true
        self.startMousePos = mousePos
    end)

    self.MainNode.TouchMove:Connect(function(_, _, mousePos)
        if self.isDragging then
            local offset = Vector2.New(mousePos.x - self.startMousePos.x, mousePos.y - self.startMousePos.y)
            local distance = math.sqrt(offset.x * offset.x + offset.y * offset.y)
            local angle = math.atan2(offset.y, offset.x)
            local clampedDistance = math.min(distance, self.radius)
            local newX = clampedDistance * math.cos(angle)
            local newY = clampedDistance * math.sin(angle)
 
            self.JoyStick.Position = Vector2.New(self.startPos.x + newX, self.startPos.y + newY)
            self.X = (newX / self.radius)
            self.Y = (newY / self.radius)

        end
    end)  

    self.MainNode.TouchEnd:Connect(function()
        self.isDragging = false
        -- self.JoyStick.Position = self.startPos
        -- self.X = 0
        -- self.Y = 0
        self:animateReturn()

    end)
end


function PANEL:animateReturn()
    local startX, startY = self.X, self.Y
    local duration = self.returnTime
    local elapsedTime = 0

    local function easeOutQuad(t)
        return t * (2 - t)
    end

    runService.RenderStepped:Connect(function(deltaTime)
        if not self.isDragging and elapsedTime < duration then
            elapsedTime = elapsedTime + deltaTime
            local t = math.min(elapsedTime / duration, 1)
            local easedT = easeOutQuad(t) 
            self.X = startX * (1 - easedT)
            self.Y = startY * (1 - easedT)
            local newPos = Vector2.New(self.startPos.x + self.X * self.radius , self.startPos.y + self.Y * self.radius ) 
            self.JoyStick.Position = newPos
    
            if t >= 1 then
                self.X = 0
                self.Y = 0
                self.JoyStick.Position = self.startPos
            end
        end
    end)
end


function PANEL:GetX()
    return self.X 
end

function PANEL:GetY()
    return self.Y
end



EasyUI:register(script.Name, PANEL)
