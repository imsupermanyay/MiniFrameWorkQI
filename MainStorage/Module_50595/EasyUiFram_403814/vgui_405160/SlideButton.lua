local PANEL = { button = {} }
function PANEL:Init()
    self.MainNode =  self.Prefab.SlideButton:Clone()
end

function PANEL:AddButton(name,func)
    local button = self.Prefab.btn:Clone()
    button.Parent = self.MainNode
    button.text.Title = name 
    button.Name = name 
    button.Click:Connect(function(node,issuccess,mousepos) 
        func(button)
    end)
    self.button[name] = button
end  
 
function PANEL:RemoveButton(name) 
    self.button[name]:Destroy()
    self.button[name] = nil 
end 

function PANEL:RemoveAllButton()
    for key, node in pairs(self.button) do
        self:RemoveButton(node.Name)
    end
end  



EasyUI:register(script.Name, PANEL)