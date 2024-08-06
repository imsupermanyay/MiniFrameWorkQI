Controller = {}
local mainStorageService = game:GetService("MainStorage")
local game_remote = mainStorageService:WaitForChild("GameRemote")
function Controller:new(Actor)
    local obj = {}

    obj.Actor = Actor
    obj.Animator = Actor.Animator
    obj.State = nil
    obj.Stuck = false 

    self.__index = self
    setmetatable(obj, self)
    return obj
end
  
function Controller:ChangeState(NewState,layer,total,offset)
    -- if self.Stuck then return end
    --同样的State
    if self.State and self.State == NewState then return end 
    --播放动画
    print("切换动画")
    print(NewState)
    self.Animator:CrossFade(NewState,layer or 0,total,offset)
    self.State = NewState
end  

function Controller:GetState()
    return self.State 
end

function Controller:GetStuck()
    return self.Stuck
end

function Controller:SetStuck(value)
    self.Stuck = value
end

-- function Controller:PlayAnime(NewState,layer,total,offset)
--     if type(layer) ~= "number" then print("layer必须为number类型") return end
--     --播放动画
--     game_remote:FireAllClients({name = "AnimePlay",NewState = NewState,total= total,offset = offset ,layer = layer,node = self.Actor})
-- end

function Controller:Think()
    
end


return Controller


