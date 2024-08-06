EasyUI = { vgui = {} ,PANEL = {} }
EasyUI.Prefab = script.Parent.Prefab


 

---------------------EasyUI注册表
 
function EasyUI:Create(name,...)
    if not self:Exists(name) then print("lua error: EasyUI[尝试创建namevgui "..name.."不存在]") return end
    local obj = table.deepcopy(EasyUI.vgui[name])

    if EasyUI.Prefab[name] then
        obj.Prefab = EasyUI.Prefab[name]
    end 
    obj:Init(...) 
    
    setmetatable(obj,{__index = EasyUI.PANEL})
 
    return obj 
end

function EasyUI:register(name,tab)
    EasyUI.vgui[name] = tab
end
 
function EasyUI:Exists(name)
    return EasyUI.vgui[name] ~= nil
end 
 
----------------PAENL类
function EasyUI.PANEL:Show()
    self.MainNode.Visible = true
    if not self.m_Parent then
        self.MainNode.Parent = localPlayer.PlayerGui.EasyUiFram 
    end
end
function EasyUI.PANEL:SetPos(Pos)
    self.MainNode.Position = Pos
end 
function EasyUI.PANEL:SetSize(Size) 
    self.MainNode.Size = Size
end 
function EasyUI.PANEL:SetColor(Color)
    self.MainNode.FillColor = Color
end 
function EasyUI.PANEL:SetParent(parent)
    self.m_Parent = parent 
    self.MainNode.Parent = self.m_Parent
end
function EasyUI.PANEL:SetData(data)
    self.data = data
end
function EasyUI.PANEL:GetData()
    return self.data
end
function EasyUI.PANEL:Close()
    self.MainNode.Visible = false
end
function EasyUI.PANEL:Destroy() 
    self.MainNode:Destroy()
end  

 
----------------加载VGUI
local function LoadVGUI()
    local allgui = script.Parent.vgui.Children
    for _,node in pairs(allgui) do 
        print("加载vgui"..node.Name) 
        require(node) 
    end 
end
LoadVGUI()  