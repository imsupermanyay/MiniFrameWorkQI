net.Fire("PlayerScriptInit")
hook.Run("PlayerScriptInit",localPlayer)  


    
--跳跃
localPlayer.PlayerGui.HUD.Test1.Click:Connect(function(node,issuccess,mousepos) 
    net.Fire("Test1")
end) 
localPlayer.PlayerGui.HUD.Test2.Click:Connect(function(node,issuccess,mousepos) 
    net.Fire("Test2")
end) 
localPlayer.PlayerGui.HUD.Test3.Click:Connect(function(node,issuccess,mousepos) 
    net.Fire("Test3")
end) 
localPlayer.PlayerGui.HUD.Test4.Click:Connect(function(node,issuccess,mousepos) 
    net.Fire("Test4")
end) 
