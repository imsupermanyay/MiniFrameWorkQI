--转发服务端print到客户端
RelayServerPrint = true 

--默认排序值
DefaultQueueValue = 10
--执行顺序 越大越早执行
ExecutesQueue = {
    ["cl_init"] = 0,  --业务层最后执行1
    ["sv_init"] = 0, --
	["sh_Hook"] = 20, -- 对于逻辑层 优先执行
	["sh_Net"] = 999,
    ["sv_Equipmente"] = 15, -- 这个要在ItemsLibrary 之前被加载
}

--请求拿去数据重试次数
NetCloudTryCount = 31