function GetGlobPosition()
    
end

-- 获取WorldService对象
local worldService = game:GetService("WorldService")
-- 获取屏幕尺寸
local ScreenSize = worldService:GetUISize()


BagRender = {}
-- 构造函数
BagRender.config= {
    defaultMoveChoiseColor = ColorQuad.New(0, 255, 127,255),
    defaultMoveBlockColor = ColorQuad.New(255, 0, 4,255),
    defaultSlotChoiseColor = ColorQuad.New(0,0,0,255),
    defaultSlotUnChoiseColor = ColorQuad.New(255,255,255,255),
}

function CreateItemInfo(item,Parent,mousepos,ContainerNode,IsClickClose,CloseFunc)
    local window = script.Parent.Prefab.ItemsCheck:Clone()
    window.Parent = ContainerNode.Parent.Parent
    window.Visible = true 
    window.RenderIndex = 99
    window.Size = Vector2.new(450,570)


    local x_left = ContainerNode.Parent.Position.X 
    local x_right = ContainerNode.Parent.Position.X + ContainerNode.Parent.Size.X


    -- --如果超出右边
    -- if x_right + 470 > ScreenSize.X then 
    --     --放左边
    --     window.Position = Vector2.new(x_left -450 , ContainerNode.Parent.Parent.Position.Y/2)
    -- else 
    --     --放右边
    --     window.Position = Vector2.new(x_right , ContainerNode.Parent.Parent.Position.Y/2)
    -- end
    window.Position = Vector2.new(x_left -450 , ContainerNode.Parent.Position.Y - ContainerNode.Parent.Position.Y/2 + 500)

    --创建词条
    local function AddItemWord(text,content,color)
        local word = script.Parent.Prefab.ItemsWord:Clone()
        word.Text.Title = tostring(text)
        word.Content.Title = tostring(content)
        if type(content) == "number" and content < 0 then
            color = ColorQuad.New(255,44,44,255)
        end
        word.Text.TitleColor = color or ColorQuad.New(255,255,255,255)  
        word.Content.TitleColor = color or ColorQuad.New(255,255,255,255)
        word.Parent = window.Word_List  
        word.Visible = true 
    end 

    --添加词条
    local Introduce,Name,TypeName,Color,Quality,Icon = item.Introduce, item.Name, item.TypeName, ColorQuad.New(item.Color.R,item.Color.G,item.Color.B,155),item.Quality,item.Icon
    window.ItemName.Title = Name 
    window.Head.Pic.Icon = Icon 
    window.Head.FillColor = Color
    window.Introduce.Title = Introduce 

    AddItemWord("类型",TypeName) 
    AddItemWord("品质",Quality) 
    if item.Strengthen then 
        AddItemWord("强化","+"..item.Strengthen)
    end
    -- 属性
    if item.Data then
        if item.Data.Hp then
            AddItemWord("血量", item.Data.Hp)
        end
        if item.Data.Hp_Regen then
            AddItemWord("血量回复", item.Data.Hp_Regen)
        end
        if item.Data.Mana then
            AddItemWord("法力", item.Data.Mana)
        end
        if item.Data.Mana_Regen then
            AddItemWord("法力回复", item.Data.Mana_Regen)
        end
        if item.Data.PhysicDanmage then
            AddItemWord("物理伤害", item.Data.PhysicDanmage)
        end
        if item.Data.MagicDanmage then
            AddItemWord("魔法伤害", item.Data.MagicDanmage)
        end
        if item.Data.PhysicDefens then
            AddItemWord("物理防御", item.Data.PhysicDefens)
        end
        if item.Data.MagicDefensPhysicDefens then
            AddItemWord("魔法防御", item.Data.MagicDefensPhysicDefens)
        end
        if item.Data.CritRate then
            AddItemWord("暴击率", item.Data.CritRate)
        end
        if item.Data.CritDanmage then
            AddItemWord("暴击伤害", item.Data.CritDanmage)
        end
        if item.Data.Speed then
            AddItemWord("速度", item.Data.Speed)
        end
        if item.Data.Gravity then
            AddItemWord("重力", item.Data.Gravity)
        end
        if item.Data.Vamp then
            AddItemWord("吸血", item.Data.Vamp)
        end
        if item.Data.Magic_Pen then
            AddItemWord("魔法穿透", item.Data.Magic_Pen)
        end
        if item.Data.Physic_Pen then
            AddItemWord("物理穿透", item.Data.Physic_Pen)
        end
    end
    
    window.Click:Connect(function(node, isTouchBegin, mousePos)
        if not IsClickClose then return end
        window:Destroy()
        if CloseFunc then CloseFunc() end
        
    end)

    window.TouchBegin:Connect(function(node, isTouchBegin, mousePos)
        if isTouchBegin then
            window:SetAttribute("isDragging",true)
            window:SetAttribute("dragStartPos",mousePos)
            window:SetAttribute("windowStartPos",node.Position) 
        end 
    end)
    
    window.TouchMove:Connect(function(node, isTouchMove, mousePos)  
        if window:GetAttribute("isDragging") and isTouchMove then
            local offset = Vector2.New(mousePos.x - window:GetAttribute("dragStartPos").x, mousePos.y - window:GetAttribute("dragStartPos").y)
            window.Position = Vector2.New(window:GetAttribute("windowStartPos").x + offset.x, window:GetAttribute("windowStartPos").y + offset.y)
        end 
    end) 
    
    window.TouchEnd:Connect(function(node, isTouchEnd, mousePos)
        if isTouchEnd then
            window:SetAttribute("isDragging",false)
        end
    end)


    return window
    
end
----------------------------背包
function BagRender:new(Parent,MaxGrid,GridWide,GridTall,LineGap,ColumnGap,BagType)
    local obj = {}  
    obj.GridWide = GridWide or Config_Bag.defaultGridWide
    obj.GridTall = GridTall or Config_Bag.defaultGridTall
    obj.LineGap = LineGap   or Config_Bag.defaultLineGap 
    obj.ColumnGap = ColumnGap or Config_Bag.defaultColumnGap
    obj.AllGrid = {}
    obj.Wide = MaxGrid.weight
    obj.Tall = MaxGrid.tall
    obj.ParentNode =  Parent
    obj.BagType = BagType
    self.__index = self
    setmetatable(obj, self)
    --初始化刷新网格
    obj:BuildBag(MaxGrid.weight, MaxGrid.tall)
    return obj 
end
--设置父节点
function BagRender:SetParent(node)
        self.node.Parent = node
end
-- 拿到格子
function BagRender:GetGrid(X, Y)
        -- for key, node in pairs(self.node.FrashGrid) do
        --     if node:GetAttribute("X") == X and node:GetAttribute("Y") == Y then
        --         return node
        --     end
        -- end
        if self.AllGrid[X][Y] then return self.AllGrid[X][Y] end
        return nil
end
--网格被点击
function BagRender:Grid_Click(x,y,node)
    print("点击了格子"..tostring(x)..tostring(y))
    if self.MoveSlotState then 
        self:MoveSlot_Click(x,y,node.Position)
    end
end
-- 创建格子 
function BagRender:BuildBag(Bagw, Bagh) 
            if self.node then self.node:Destroy() end
            local ContainerNode = script.Parent.Prefab.Container:Clone()  
            ContainerNode.Visible = true
            self.node = ContainerNode
        
            for x = 1, Bagw do
                self.AllGrid[x] = {} 
            end
            -- 初始化网格   
            for y = 1, Bagh, 1 do
                for x = 1, Bagw, 1 do 
                    local grid = script.Parent.Prefab.Grid:Clone()
                    local posx = ((x - 1) * self.GridWide) + self.ColumnGap
                    local posy = ((y - 1) * self.GridTall) + self.LineGap 
                    grid.Parent = ContainerNode.Grid
                    grid.Size = Vector2.new(self.GridWide,self.GridTall )
                    grid.Position = Vector2.new(posx,posy )
                    grid.Name = "Grid"..tostring(x)..tostring(y)
                    grid.Visible = true
                    grid:SetAttribute("X", x)
                    grid:SetAttribute("Y", y)
                     grid.Click:Connect(function(node,issuccess,mousepos) 
                        self:Grid_Click(x,y,grid)
                     end) 
                    self.AllGrid[x][y] = grid 
                end 
            end 
            ContainerNode.Parent = self.ParentNode    
            local CotainerWide = self.ColumnGap + (Bagw) * self.GridWide + self.ColumnGap 
            local CotainerTall = self.LineGap + (Bagh) * self.GridTall + self.LineGap
            ContainerNode.Size = Vector2.new( CotainerWide, CotainerTall )
end


-- 在指定地方创建一个Slot
function BagRender:Slot_Create(itemslot)
    local x = itemslot.X 
    local y = itemslot.Y 
    local gridnode = self:GetGrid(x, y)
    if not gridnode then 
        print("lua error: 渲染Items 写入了一个超出索引的X,Y")
        return 
    end
    local idata = itemslot.ItemObj
    local Slot = script.Parent.Prefab.Slot:Clone()
    
    local  iicon, iweight, itall =  idata.Icon, idata.Size.weight, idata.Size.tall
    local Color =  ColorQuad.New(idata.Color.R,idata.Color.G,idata.Color.B,155)
    Slot.Parent = self.node.Slot 
    Slot:SetAttribute("IsSlot", true)   
    Slot:SetAttribute("IsMoveState", false)  
    Slot:SetAttribute("Id", idata.Id)  
    Slot.Visible = true
    Slot.Icon = iicon 
    Slot.FillColor = Color
    local weight =  iweight * self.GridWide
    local tall = itall *  self.GridTall
    Slot.Size = Vector2.new(weight,tall)
    Slot.Position = gridnode.Position
    Slot.LineColor = self.config.defaultSlotUnChoiseColor
    --旋转
    if idata.Rotate then
        Slot.Rotation = -90
        Slot.Pivot = Vector2.new(1,0)
    else 
        Slot.Rotation = 0
        Slot.Pivot = Vector2.new(0,0)
    end

    Slot.Click:Connect(function(node,issuccess,mousepos) 
        local item = itemslot 
        self:Slot_Click(item,mousepos,node)
    end) 

    return Slot 
end 
 
-- 物品Slot被点击  
function BagRender:Slot_Click(item,mousepos,slotnode)
    print("点击了物品"..tostring(item.X)..tostring(item.Y))
    if self.MoveSlotState then return end
    if not item then return end --如果Slot没Item
     
    if self.Prevnode ~= nil and slotnode == self.Prevnode and self.CheckItem then --如果两次点的一样 取消选择

        self.Prevnode = slotnode  
        slotnode.LineColor = self.config.defaultSlotUnChoiseColor
        self.CheckItem = false 

        
        self:DestoryItemCheck() 
        self:DestoryItemHandle()

    else -- 如果不一样 直接选择
        if self.Prevnode then 
            self.Prevnode.LineColor = self.config.defaultSlotUnChoiseColor
            
            self:DestoryItemCheck()
            self:DestoryItemHandle()
        end
        --改变选中颜色
        slotnode.LineColor = self.config.defaultSlotChoiseColor
        --记录上一个节点
        self.Prevnode = slotnode 
        -- 创建Itemcheck
        self.ItemCheckWindow = self:CreateItemCheck(item.ItemObj,mousepos)
        self.CheckItem = true  
        --创建操作栏
        self:CreateItemHandle(item,mousepos) 
        self.Prevnode = slotnode 
    end

    


end
-- 刷新物品 
function BagRender:FrashItems(Items)
            --删除所有物品
            for key, node in pairs(self.node.Slot.Children) do
                node:Destroy()
            end
            --根据传递来的Items创建新的物品
            for index, itemslot in pairs(Items) do
                self:Slot_Create(itemslot)
            end 
end

 
-----------------------------Item信息栏
-- 创建物品详情 
function BagRender:CreateItemCheck(item,mousepos)
            local window = CreateItemInfo(item,self.ParentNode.Parent.Parent,mousepos,self.node)
            return window
end
-- 销毁物品详情
function BagRender:DestoryItemCheck()
    if self.ItemCheckWindow then
        self.ItemCheckWindow:Destroy()
        self.ItemCheckWindow = nil
    end
end
-----------------------------操作栏

--创建操作栏 
function BagRender:CreateItemHandle(item)
    if not self.SlotWindowHandleNode then 
        self.SlotWindowHandleNode = EasyUI:Create("SlideButton") 
    end   
    self.SlotWindowHandleNode:SetData(item) 
    self.SlotWindowHandleNode:SetSize(Vector2.new(260,400)) 
    self.SlotWindowHandleNode:SetParent(self.node.Parent.Parent)
    -- 如果 mousepos.X+ Size.x 大于ScreenSize.x 那么 pos为 mouspos-size 
    
    local x_left = self.node.Parent.Position.X 
    local x_right = self.node.Parent.Position.X + self.node.Parent.Size.X  

    -- print(x_right) 
    -- print(x_left)
    -- --如果超出右边
    -- if x_right + 240 > ScreenSize.X then 
    --     --放左边
    --     self.SlotWindowHandleNode:SetPos(Vector2.new(x_left ,ScreenSize.Y/2))  
    -- else 
    --     --放右边   
    --     self.SlotWindowHandleNode:SetPos(Vector2.new(x_right ,ScreenSize.Y/2))  
    -- end
    self.SlotWindowHandleNode:SetPos(Vector2.new(x_left - 280 ,self.node.Parent.Position.Y - self.node.Parent.Position.Y/1.4 ))  
    self.SlotWindowHandleNode:Show() 
    self:SwitchItemHandle_Move() 
    return self.SlotWindowHandleNode 
end  
--销毁操作栏
function BagRender:DestoryItemHandle()
    if self.SlotWindowHandleNode then 
        self.SlotWindowHandleNode:Destroy() 
        self.SlotWindowHandleNode = nil
    end 
end 
--隐藏操作栏
function BagRender:CloseItemHandle()
    if self.SlotWindowHandleNode then
        self.SlotWindowHandleNode:Close()
    end
end  
--显示操作栏
function BagRender:ShowItemHandle() 
    if self.SlotWindowHandleNode then
        self.SlotWindowHandleNode:Show()
    end
end  
--切换移动操作栏 
function BagRender:SwitchItemHandle_Move()
    local item = self.SlotWindowHandleNode:GetData()
 
    self.SlotWindowHandleNode:RemoveAllButton()
    self.SlotWindowHandleNode:AddButton("移动",function ()
        self:SwitchItemHandle_Item()
        self:MoveSlot_Start(item)  
    end) 
    self.SlotWindowHandleNode:AddButton("丢弃",function ()
        self:Drop(item)
    end)

    if item.ItemObj.UseFunc then
        self.SlotWindowHandleNode:AddButton("使用",function ()
            self:Use(item)
        end)
    end 
    return self.SlotWindowHandleNode
end
--切换物品操作栏
function BagRender:SwitchItemHandle_Item()
    -- local item = self.SlotWindowHandleNode:GetData()

    self.SlotWindowHandleNode:RemoveAllButton()
    self.SlotWindowHandleNode:AddButton("旋转",function ()
        print("点击旋转")
        self:MoveSlot_Rotate()
    end) 
    self.SlotWindowHandleNode:AddButton("确认",function ()
        print("点击确认")
        self:MoveSlot_Submit()
    end) 
    self.SlotWindowHandleNode:AddButton("取消",function ()
        self:MoveSlot_Cancel() --移动物品状态 取消
    end)
    return self.SlotWindowHandleNode
end

 
-----------------------------移动物品状态


--丢出
function BagRender:Drop(item)
    --给服务端验证是否可以通过
    net.Fire(
        "Bag_DropItem_Server",
        item.ItemObj.Id,
        self.BagType
    )
end

--使用
function BagRender:Use(item) 
    --给服务端验证是否可以通过
    net.Fire(
        "Bag_UseItem_Server",
        item.ItemObj.Id,
        self.BagType
    )
end

--开始移动物品
function BagRender:MoveSlot_Start(item)

    self.MoveSlot = table.deepcopy(item) --copy一份本体 
    self.MoveSlotState = true
    --创建Slot
    self.MoveSlotNode = self:Slot_Create(self.MoveSlot) --给本体创建Slot
    self.MoveSlotNode.FillColor = self.config.defaultMoveChoiseColor
    self.MoveSlotNode.Alpha = 0.6
    self.MoveSlotNode.Active = false 
    self.MoveSlotNode.Enabled = false
 
end

--取消操作
function BagRender:MoveSlot_Cancel()
    self.MoveSlotNode:Destroy()
    self.MoveSlotNode = nil 
    self.MoveSlot = nil
    self.MoveSlotState = false
    self:SwitchItemHandle_Move() --切换栏位
end

--提交操作
function BagRender:MoveSlot_Submit()
    if self.MoveBlock then print("无法提交") return end --如果已经阻塞


    --给服务端验证是否可以通过
    net.Fire(
        "Bag_SubmitItem_Server",
        self.MoveSlot.X,
        self.MoveSlot.Y,
        self.MoveSlot.ItemObj.Rotate,
        self.MoveSlot.ItemObj.Id,
        self.BagType
    )


end

--点击操作
function BagRender:MoveSlot_Click(x,y,pos)
    self.MoveSlot.X = x
    self.MoveSlot.Y = y



    --给服务端验证是否可以通过
    net.Fire(
        "Bag_CaculateMoveSlot_Server",
        self.MoveSlot.X,
        self.MoveSlot.Y,
        self.MoveSlot.ItemObj.Size.weight,
        self.MoveSlot.ItemObj.Size.tall,
        self.MoveSlot.ItemObj.Rotate,
        pos , 
        self.BagType
    )

end 
 
--旋转操作
function BagRender:MoveSlot_Rotate()

    if self.MoveSlot.ItemObj.Rotate then
        self.MoveSlotNode.Rotation = 0
        self.MoveSlotNode.Pivot = Vector2.new(0,0)
        self.MoveSlot.ItemObj.Rotate = false
    else   
        self.MoveSlotNode.Rotation = -90
        self.MoveSlotNode.Pivot = Vector2.new(1,0)
        self.MoveSlot.ItemObj.Rotate = true
    end 

    net.Fire(
        "Bag_CaculateMoveSlot_Server",
        self.MoveSlot.X,
        self.MoveSlot.Y,
        self.MoveSlot.ItemObj.Size.weight,
        self.MoveSlot.ItemObj.Size.tall,
        self.MoveSlot.ItemObj.Rotate,
        self.MoveSlotNode.Position ,
        self.BagType
    )
 

end  
 
--设置无阻塞
function BagRender:UnBlockMove()
    self.MoveSlotNode.FillColor = self.config.defaultMoveChoiseColor
    self.MoveBlock =  false
end 
  
--设置阻塞
function BagRender:BlockMove()
    self.MoveSlotNode.FillColor = self.config.defaultMoveBlockColor
    self.MoveBlock = true
end 
 

 

--------------------网络

--重新定义大小 渲染
net.Receive("Bag_ChangeSizes_ReRender",function (m_data) 
        table.printTable(m_data)
        local w = m_data.MaxSize.weight
        local h = m_data.MaxSize.tall 

        local bag = data.GetData(localPlayer.UserId,m_data.BagType)
        if not bag then print("lua error: 尝试给一个没有初始化背包的玩家设置背包大小") return end
         
        bag:BuildBag(w,h)
        bag:FrashItems(m_data.Items)
end)  

--服务端 提交成功 本地渲染同步位移
net.Receive("Bag_SubmitItem_Client",function (x,y,rotate,id,BagType)
    local m_BagRender = data.GetData(localPlayer.UserId,BagType) --当前玩家背包
    for key, node in pairs(m_BagRender.node.Slot.Children) do
        local nodeid = node:GetAttribute("Id")
        if nodeid == id then
            node.Position = m_BagRender.MoveSlotNode.Position
            local itemobj = {
                X = x,
                Y = y,
                ItemObj = m_BagRender.SlotWindowHandleNode.data.ItemObj
            }
            itemobj.ItemObj.Rotate = rotate 
            m_BagRender.SlotWindowHandleNode:SetData(itemobj)
            if rotate then 
                node.Rotation = -90
                node.Pivot = Vector2.new(1,0)
            else
                node.Rotation = 0
                node.Pivot = Vector2.new(0,0)
            end
            break
        end  
    end   

    --节点也需要的UI渲染也需要赋值
    m_BagRender:MoveSlot_Cancel()

end)

--每次点击移动 MOVESLOT 时  服务端返回计算是否阻塞结果
net.Receive("Bag_CaculateMoveSlot_Client",function (isblock,pos,BagType)
    local m_BagRender = data.GetData(localPlayer.UserId,BagType) --当前玩家背包
    if isblock then
        m_BagRender:BlockMove()
    else
        m_BagRender:UnBlockMove()
    end
    m_BagRender.MoveSlotNode.Position  = pos
    
end)

--服务端 删除成功 本地渲染同步删除
net.Receive("Bag_DropItem_Server",function (id,BagType)

    --本地也删除掉那个节点
    local m_BagRender = data.GetData(localPlayer.UserId,BagType) --当前玩家背包
    for key, node in pairs(m_BagRender.node.Slot.Children) do
        local nodeid = node:GetAttribute("Id")
        if nodeid == id then
            node:Destroy()
            break
        end
    end  

  
    --节点也需要的UI渲染也需要赋值
    m_BagRender:CloseItemHandle()   -- 关闭物品操作栏
    m_BagRender.CheckItem = false -- 设置没在checkitem
    m_BagRender:DestoryItemCheck()  --销毁物品详情
    m_BagRender:DestoryItemHandle()  --销毁物品操作栏
end)
