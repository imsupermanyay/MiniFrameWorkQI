
BagObj = {}

function BagObj:new(size, items, Owner, BagType)
    if not BagType then print("lua error : BagType为空 背包创建失败") return end 
    local obj = {}
    obj.Items = items
    obj.Size = size
    obj.Owner = Owner
    obj.BagType = BagType
    obj.BanList = {}
    obj.GridStatus = {} -- 二维数组表示格子状态
    for x = 1, size.weight do
        obj.GridStatus[x] = {}
        for y = 1, size.tall do
            obj.GridStatus[x][y] = false
        end
    end
    self.__index = self
    setmetatable(obj, self)
    return obj
end

--计算BanGrild
function BagObj:CaculateBanGrid()
    for x = 1, self.Size.weight do
        for y = 1, self.Size.tall do
            self.GridStatus[x][y] = false
        end
    end 
    for key, slot in pairs(self.Items) do
        local x, y, item = slot.X, slot.Y, slot.ItemObj
        local w, h = item:GetWeight(), item:GetTall()
        if item:GetRotate() then
            w, h = h, w
        end
        for i = x, x + w - 1 do
            for j = y, y + h - 1 do
                self.GridStatus[i][j] = true
            end
        end
    end
end
--辅助函数 检查空位
function BagObj:CheckEmpty(x, y, w, h)
    if x < 1 or y < 1 or x + w - 1 > self.Size.weight or y + h - 1 > self.Size.tall then
        return false
    end
    for i = x, x + w - 1 do
        for j = y, y + h - 1 do
            if self.GridStatus[i][j] then
                return false
            end
        end
    end
    return true
end

function BagObj:SetSize(weight, tall)
    if type(weight) ~= "number" or type(tall) ~= "number" then
        print("lua error: 尝试给背包设置大小时类型错误")
        return
    end
    self.Size = {weight = weight, tall = tall}

    -- 重新初始化 GridStatus 数组
    self.GridStatus = {}
    for x = 1, self.Size.weight do
        self.GridStatus[x] = {}
        for y = 1, self.Size.tall do
            self.GridStatus[x][y] = false
        end
    end

    -- 重新计算 BanList 并更新 GridStatus
    self:CaculateBanGrid()

    net.Fire(self.Owner.UserId, "Bag_ChangeSizes_ReRender", self:GetInfo())
end 

function BagObj:GetInfo()
    local clientitemdata = {}
    for key, itemdata in pairs(self.Items) do
        local itemObj = itemdata.ItemObj
        local newitem = {
            Y = itemdata.Y,
            X = itemdata.X,
            ItemObj = itemObj:GetInfo() 
        }
        table.insert(clientitemdata, newitem)
    end
    return {
        Items = clientitemdata,
        MaxSize = self.Size,
        BagType = self.BagType
    }
end

function BagObj:GetEmptyGrid(Item)
    local itemw, itemh = Item:GetWeight(), Item:GetTall()
    local bagw, bagh = self.Size.weight, self.Size.tall

    local function findPosition(w, h)
        for y = 1, bagh - h + 1 do
            for x = 1, bagw - w + 1 do
                if self:CheckEmpty(x, y, w, h) then
                    return {x = x, y = y}
                end
            end
        end
        return nil
    end

    local pos = findPosition(itemw, itemh)
    if pos then return {rotate = false, pos = pos} end

    pos = findPosition(itemh, itemw)
    if pos then return {rotate = true, pos = pos} end

    return nil
end


----------------------------------------[[操作物品]]
--添加物品
function BagObj:AddItem(Item) 
    self:CaculateBanGrid()
    local result = self:GetEmptyGrid(Item)
    if result then
        local pos = result.pos
        local rotate = result.rotate
        local ItemSlot = {
            X = pos.x,
            Y = pos.y,
            ItemObj = Item,
        }
        Item:SetRotate(rotate)
        table.insert(self.Items, ItemSlot)
        return true
    else
        print("lua warning: 尝试放入背包 但是背包已满")
        return false
    end
end

--删除物品 
function BagObj:DelectItemById(id)
    for key, slot in pairs(self.Items) do
        if slot.ItemObj:GetId() == id then
            self.Items[key] = nil
        end
    end
end

--使用物品
function BagObj:UseItemById(id,ply)
    for key, slot in pairs(self.Items) do
        if slot.ItemObj:GetId() == id then
            return slot.ItemObj:UseFunc(ply,self)  
        end
    end
end

--改变物品位置来自ID
function BagObj:ChangeItemPosById(x, y, rotate, id)
    for key, slot in pairs(self.Items) do
        if slot.ItemObj:GetId() == id then
            slot.ItemObj:SetRotate(rotate)
            slot.X = x
            slot.Y = y
            break
        end
    end
end

-- 客户端请求 MoveSlot 点击 计算是否阻塞
net.Receive("Bag_CaculateMoveSlot_Server", function(ply, x, y, w, h, rotate, pos, BagType)
    if rotate then w, h = h, w end
    local Bag = data.GetData(ply.UserId, BagType)
    Bag:CaculateBanGrid()
    local isblock = not Bag:CheckEmpty(x, y, w, h)
    net.Fire(ply.UserId, "Bag_CaculateMoveSlot_Client", isblock, pos,Bag.BagType)
end)

-- 客户端 提交
net.Receive("Bag_SubmitItem_Server", function(ply, x, y, rotate, id, BagType)
    local Bag = data.GetData(ply.UserId, BagType)
    Bag:ChangeItemPosById(x, y, rotate, id)
    net.Fire(ply.UserId, "Bag_SubmitItem_Client",x,y,rotate,id,Bag.BagType)
end)

-- -- 客户端 丢弃
net.Receive("Bag_DropItem_Server", function(ply, id, BagType)
    local Bag = data.GetData(ply.UserId, BagType)
    Bag:DelectItemById(id)
    net.Fire(ply.UserId,"Bag_DelectItem_Server",id,Bag.BagType) --发送删除物品
end) 
 
-- 客户端 使用
net.Receive("Bag_UseItem_Server", function(ply, id, BagType)
    local Bag = data.GetData(ply.UserId, BagType)
    local result = Bag:UseItemById(id,ply)

    if result then 
        --使用成功 
        Bag:DelectItemById(id)
        net.Fire(ply.UserId,"Bag_DelectItem_Server",id,BagType) --发送删除物品
    end

end)
