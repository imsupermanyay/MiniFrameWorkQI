Fight = {
    Func = {},
    Data = {}
}
--初始化所有武器
Fight.Data.Weapons = {}
function Fight.Func.InitWeapons()
    for key, wp in pairs(script.Parent.Library.Children) do
            local wpdata = require(wp)
            wpdata.classname = wp.Name
            Fight.Data.Weapons[wp.Name] = wpdata
    end
end
--初始化所有武器 
--AllActData[武器名][动作名]
Fight.Data.AllActData = {} 
function Fight.Func.InitAllActData()
    for key, wp in pairs(script.Parent.Config.Children) do
        Fight.Data.AllActData[wp.Name] = {}
        for key, act in pairs(wp.Children) do
            local actdata = require(act) 
            actdata.classname = act.Name
            Fight.Data.AllActData[wp.Name][act.Name] = actdata
        end
    end
end


 
Fight.Func.InitWeapons()
Fight.Func.InitAllActData() 