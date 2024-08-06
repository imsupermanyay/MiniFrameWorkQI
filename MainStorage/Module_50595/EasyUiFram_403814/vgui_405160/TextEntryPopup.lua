local PANEL = { button = {} }
function PANEL:Init(title,text1,text2,func1,func2)
    self.MainNode =  self.Prefab.TextEntryPopup:Clone()
    
    if title then
        self.MainNode.Text.Title.Text = title
    end
    if text1 then
        self.MainNode.Btn1.Text = text1
    end
    if text2 then
        self.MainNode.Btn2.Text = text2
    end
    if func1 then
        self:Btn1Click(func1)
    end
    if func2 then
        self:Btn1Click(func2)
    end

end

function PANEL:Btn1Click(func)
    local node = self
    self.MainNode.Btn1.Click:Connect(function(node,issuccess,mousepos) 
        func(node,node.MainNode.TextEntry.Title)
    end)
end  
function PANEL:Btn2Click(func)
    local node = self
    self.MainNode.Btn2.Click:Connect(function(node,issuccess,mousepos) 
        func(node,node.MainNode.TextEntry.Title)
    end)
end  




EasyUI:register(script.Name, PANEL)