Net = {}

if Ext.IsClient() then
    ---Send payload to server
    ---@param channel string
    ---@param payload string
    function Net.Send(channel, payload)
        Ext.ClientNet.PostMessageToServer(channel, payload)
    end

    ---Listen for payload from server on a specific channel and run function
    ---@param channel string
    ---@param func fun(payload:string,user:integer?)
    function Net.ListenFor(channel, func)
        Ext.RegisterNetListener(channel, function(channel, payload, user)
            func(payload, user)
        end)
    end
end


if Ext.IsServer() then
    ---Send payload to all clients
    ---@param channel string
    ---@param payload string
    function Net.Send(channel, payload)
        Ext.ServerNet.BroadcastMessage(channel, payload)
    end

    ---Listen for payload from client on a specific channel and run function
    ---@param channel string
    ---@param func fun(payload:string,user:integer?)
    function Net.ListenFor(channel, func)
        Ext.RegisterNetListener(channel, function(channel, payload, user)
            func(payload, user)
        end)
    end
end
