BagManager = BagManager or {}
local config= {}
--背包UI路径
config.BagUIPath = localPlayer.PlayerGui.Equipment
config.BagSlide = localPlayer.PlayerGui.Equipment.Bag.background.Slide 


 
local isRender = false
------------------------[[ 界面处理 ]]------------------------


--请求初始化玩家背包 
function BagManager.PlayerOpenBag()
    net.Fire("Equipment_PlayerOpenBag")
end  

--背包开启
config.BagUIPath.BagOpen.Click:Connect(function(node,issuccess,mousepos) 
    config.BagUIPath.Bag.Visible = true
    isRender = true


    BagManager.PlayerOpenBag() --玩家请求打开背包

    
    local m_BagRender = data.GetData(localPlayer.UserId,"Bag")
    m_BagRender:ShowItemHandle()  
end) 
--背包关闭 
config.BagUIPath.Bag.background.Close.Click:Connect(function(node,issuccess,mousepos) 
    config.BagUIPath.Bag.Visible = false
    isRender = false


    local m_BagRender = data.GetData(localPlayer.UserId,"Bag")
    m_BagRender:CloseItemHandle()  
end)   

--渲染-- 
RunService.RenderStepped:Connect(function() 
    if not isRender then return end
end)
 
------------------------[[ 网络传输 ]]------------------------

--接收到服务器的打开背包准许 
net.Receive("Equipment_SendBagInfo",function (m_data)
    --传来的值
    --#region
        --Items
        --MaxSize 
    --#endregion

    local m_BagRender = data.GetData(localPlayer.UserId,"Bag")
    if not m_BagRender then  --如果没有那么 创建render
        m_BagRender = BagRender:new(config.BagSlide,m_data.MaxSize,80,80,3,3,"Bag")
        data.SetData(localPlayer.UserId,"Bag",m_BagRender)  
    end
    m_BagRender:FrashItems(m_data.Items) --有的话就刷新一下items
end)

--------------------------[[玩家重生]]
