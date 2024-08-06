Typewriter = {}
Typewriter.__index = Typewriter
local count = 0 
function Typewriter:new(text, interval)
    local obj = {
        text = text,
        interval = interval or 0.05,  -- 默认间隔为0.1秒
        currentIndex = 1,
        displayedText = ""
    }
    self.id = "Timer"..tostring(count)..tostring(math.random(0,9999))
    setmetatable(obj, Typewriter)
    return obj
end

function Typewriter:start(callback)
    self.callback = callback
     
    self.timer = Timer:new(self.id,30,self.interval,function ()
        if callback then
            self.callback(self.displayedText)
        end
        self:update()
    end)
end

function Typewriter:update()
    if self.currentIndex <= #self.text then
        self.displayedText = self.text:sub(1, self.currentIndex)
        self.currentIndex = self.currentIndex + 1
    end
end

function Typewriter:Destroy()
    self.timer:Destroy()
end