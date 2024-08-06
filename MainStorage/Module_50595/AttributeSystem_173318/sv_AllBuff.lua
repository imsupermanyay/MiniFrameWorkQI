BuffSystem ={
    AllBuff = {
        {
            BuffID = 1,
            BuffName = "Buff1",
            BuffType = "Debuff",
            BuffTime = 10,
            BuffEffect = function()
                --print("Debuff1")
            end
        }
    }
}
BuffObj ={}

function BuffObj:new(Actor)
    local obj = {}
    obj.Actor = Actor
    obj.AllBuff =  {}

    self.__index = self
    setmetatable(obj, self)
    return obj
end














function BuffSystem.AddBuff()
    
end
function BuffSystem.DelectBuff()
    
end