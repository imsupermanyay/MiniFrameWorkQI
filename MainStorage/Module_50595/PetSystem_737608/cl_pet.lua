local TweenService = game:GetService("TweenService")



--客户端渲染聊天窗口
net.Receive("PetRenderChatPop",function (str,tall,parent)
    local pop = ChatPop:NewPop(str)
    pop:SetParent(parent) 
    pop:SetPos(Vector3.new(0,tall,0)) 
end)


--客户端渲染宠物出场动画
net.Receive("PetRenderPetSpawnEffect",function (node,size)

    -- 出生动画
    local tweenInfo = TweenInfo.new(
        0.6,                             -- 时间长度
        Enum.EasingStyle.Bounce,       -- 缓动样式
        Enum.EasingDirection.Out,      -- 缓动方向
        0,
        1                            -- 循环次数（-1表示无限循环）
    )

    -- 创建Tween
    local goal = {LocalScale = Vector3.new(size, size, size)}
    local tween = TweenService:Create(node, tweenInfo, goal)

    -- 播放Tween
    tween:Play()



end)


---------------以下为前端逻辑
------------工期有限。随便推了
local currentpet = nil
local choisbtn = "resid://279459383234228224"
local unchoisbtn =  "resid://279379170156572672" 
local Fightbtn = "resid://279379253073768448"
local ReCallbtn =  "resid://279379594158764032"

local petwin = localPlayer.PlayerGui.PetUI.Pet
local allslot = {}
local function FrashUI(info)
    --清空上次
    for key, slot in ipairs(allslot) do
        slot:Destroy() 
    end
    allslot = {}

    --你的
    for index, pet in ipairs(info) do
        local slot = petwin.PetList.Slot:Clone()
        slot.Parent = petwin.PetList.UIList 
        slot.Visible = true
        slot.Icon = unchoisbtn
        slot.PetName.Title = pet.Nick
        slot.SubText.Title = " 品阶： "..  pet.Nick
        slot.Head.Icon = pet.HeadIcon 
        table.insert(allslot,slot)
        slot.Click:Connect(function()
                currentpet = pet
                --给其他的全取消
                for index, btn in ipairs(allslot) do
                    btn.Icon = unchoisbtn
                end
                --选中
                slot.Icon = choisbtn

                petwin.Call.Icon = pet.isCalling and  ReCallbtn or Fightbtn
                
                petwin.Pet.PetName.Title = pet.Nick
                --渲染模型 
                petwin.Pet.Model.Actor.ModelId = pet.Model
                petwin.Pet.Model.Actor.Animator.ControllerAsset = pet.ControllerAsset
                --属性
                petwin.Pet.Attribute.MagicDanmage.Title = tostring(pet.MagicDanmage)
                petwin.Pet.Attribute.PhysicDanmage.Title =  tostring(pet.PhysicDanmage)
                petwin.Pet.Attribute.PhysicDefens.Title = tostring(pet.PhysicDefens)
                petwin.Pet.Attribute.MagicDefens.Title = tostring(pet.MagicDefens)
                petwin.Pet.Attribute.MaxHp.Title = tostring(pet.MaxHp)

                petwin.Pet.ExpBG.Exp.Title = "等级："..tostring(pet.Level).."["..tostring(pet.Exp) .."/"..tostring(pet.MaxExp) .."]"
 
  
                petwin.Pet.ExpBG.ExpBar.Size = Vector2.new(pet.Exp / pet.MaxExp, 1)

                petwin.Pet.HpBarBG.Hp.Title = tostring(pet.Hp)
                petwin.Pet.HpBarBG.HpBar.Size = Vector2.new(pet.Hp / pet.MaxHp, 1)

                petwin.Pet.Attribute.MagicDanmage_copy.Title = tostring(pet.ZiZhi_MagicDanmage)
                petwin.Pet.Attribute.PhysicDanmage_copy.Title =  tostring(pet.ZiZhi_PhysicDanmage)
                petwin.Pet.Attribute.PhysicDefens_copy.Title = tostring(pet.ZiZhi_PhysicDefens)
                petwin.Pet.Attribute.MagicDefens_copy.Title = tostring(pet.ZiZhi_MagicDefens)
                petwin.Pet.Attribute.MaxHp_copy.Title = tostring(pet.ZiZhi_Hp)

                print("应该渲染技能栏")
                --技能栏
                for key, skill in pairs(pet.AllSKill) do
                    local s = petwin.Bag.SkillList["Skill"..key]
                    s.Icon = skill.Icon
                end   

 
                --装备栏 
                petwin.Pet.Neck.Pic.Icon = pet.Equipment.Neck and  pet.Equipment.Neck.Icon  or ""
                petwin.Pet.Jewelry.Pic.Icon = pet.Equipment.Jewelry and  pet.Equipment.Jewelry.Icon  or ""
                petwin.Pet.Armor.Pic.Icon = pet.Equipment.Armor and  pet.Equipment.Armor.Icon  or ""
 
                

                net.Fire("PlayerChoisePetSlot", pet.Id)
                
        end)
    end

    --默认首选
    if allslot[1] then
        allslot[1].Click:Emit(allslot[1],true, Vector2.new(1,1), 0)
    end
end


--得到宠物数据
net.Receive("SyncPetInfoAndOpenPetManager",function (info,baginfo)
    FrashUI(info)
    

    local m_BagRender = data.GetData(localPlayer.UserId,"PetBag")
    if not m_BagRender then  --如果没有那么 创建render
        m_BagRender = BagRender:new(petwin.Bag.PetBag,baginfo.MaxSize,100,100,5,4,"PetBag")
        data.SetData(localPlayer.UserId,"PetBag",m_BagRender)  
    end
    m_BagRender:FrashItems(baginfo.Items) --有的话就刷新一下items
    

    localPlayer.PlayerGui.PetUI.Pet.Visible = true
end)


--出战请求
petwin.Call.Click:Connect(function()
    --出战请求
    if not currentpet then return end
    net.Fire("PlayerRequestCallPet",currentpet.Id)
end)
--刷新出战
net.Receive("PetReCallBtnFrash",function ()
    petwin.Call.Icon = Fightbtn
end)
--刷新出战 
net.Receive("PetCallBtnFrash",function ()
    petwin.Call.Icon = ReCallbtn
end)
--关闭
petwin.Close.Click:Connect(function()
    localPlayer.PlayerGui.PetUI.Pet.Visible = false
    currentpet = nil
end)

SlotWindowHandleObj = nil
ItemCheckNode = nil
--创建装备栏操作列表
function CreateItemHandle(item,node)
    if not currentpet then return end
    if not SlotWindowHandleObj then 
        SlotWindowHandleObj = EasyUI:Create("SlideButton") 
   end   
   
    SlotWindowHandleObj:RemoveAllButton()
    SlotWindowHandleObj:AddButton("卸下装备",function ()
        local id  = currentpet.Id
        local slot = item.Data.Slot
        net.Fire("PlayerRequestUnEquipment",id,slot) 
        SlotWindowHandleObj.MainNode.Visible = false
        ItemCheckNode.Visible = false 
    end)  
 
    SlotWindowHandleObj:SetData(item) 
    SlotWindowHandleObj:SetSize(Vector2.new(260,400))  
    SlotWindowHandleObj:SetParent( node) 
   -- 如果 mousepos.X+ Size.x 大于ScreenSize.x那么 pos为 mouspos-size 
--    local x_left =  node.Parent.Position.X  

 

    SlotWindowHandleObj:SetPos(Vector2.new( node.Size.X , 0 ))   
    SlotWindowHandleObj:Show() 
    SlotWindowHandleObj.RanderIndex = 99991
end




-- 点击技能按钮 
for key, Skillbtn in pairs(petwin.Bag.SkillList.Children) do
    Skillbtn.Click:Connect(function(node,issuccess,mousepos)
        if not currentpet then return end
        local AllSKill = currentpet.AllSKill
        if Skillbtn.Icon == "" or  not AllSKill[key] then return end  
        ItemCheckNode = CreateItemInfo(AllSKill[key],node.Parent.Parent,mousepos,node,true,function ()
        end)
    end)
end

--点击装备格子
petwin.Pet.Neck.Click:Connect(function(node,issuccess,mousepos)
    if not currentpet then return end
    local iteminfo = currentpet.Equipment.Neck
    if not iteminfo then return end
        ItemCheckNode = CreateItemInfo(iteminfo,node.Parent.Parent,mousepos,node,true,function ()
            SlotWindowHandleObj.MainNode.Visible = false
        end)
        CreateItemHandle(iteminfo,ItemCheckNode)
end)
petwin.Pet.Jewelry.Click:Connect(function(node,issuccess,mousepos)
    if not currentpet then return end
    local iteminfo = currentpet.Equipment.Jewelry
    if not iteminfo then return end
        ItemCheckNode = CreateItemInfo(iteminfo,node.Parent.Parent,mousepos,node,function ()
            SlotWindowHandleObj.MainNode.Visible = false
        end)
        CreateItemHandle(iteminfo,ItemCheckNode) 
end)
petwin.Pet.Armor.Click:Connect(function(node,issuccess,mousepos)
    if not currentpet then return end
    local iteminfo = currentpet.Equipment.Armor
    if not iteminfo then return end
        ItemCheckNode = CreateItemInfo(iteminfo,node.Parent.Parent,mousepos,node,function ()
            SlotWindowHandleObj.MainNode.Visible = false
        end)
        CreateItemHandle(iteminfo,ItemCheckNode)
end)
