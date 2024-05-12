Net = {}

if Ext.IsClient() then
    ---Send message to server
    ---@param channel string
    ---@param message string
    function Net.Send(channel, message)
        Ext.ClientNet.PostMessageToServer(channel, message)
    end

    ---Listen for message from server on a specific channel and run function
    ---@param channel string
    ---@param func function
    function Net.ListenFor(channel, func)
        Ext.RegisterNetListener(channel, func)
    end
end



if Ext.IsServer() then
    ---Send message to all clients
    ---@param channel string
    ---@param message string
    function Net.Send(channel, message)
        Ext.ServerNet.BroadcastMessage(channel, message)
    end

    ---Listen for message from client on a specific channel and run function
    ---@param channel string
    ---@param func function
    function Net.ListenFor(channel, func)
        Ext.RegisterNetListener(channel, func)
    end
end
