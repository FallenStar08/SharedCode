Net = {}

if Ext.IsClient() then
    ---Send payload to server
    ---@param channel string
    ---@param payload string
    function Net.Send(channel, payload)
        if type(payload) == "string" then
            Ext.ClientNet.PostMessageToServer(channel, payload)
        elseif type(payload) == "table" then
            Ext.ClientNet.PostMessageToServer(channel, JSON.Stringify(payload))
        end
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
        if type(payload) == "string" then
            Ext.ServerNet.BroadcastMessage(channel, payload)
        elseif type(payload) == "table" then
            Ext.ServerNet.BroadcastMessage(channel, JSON.Stringify(payload))
        end
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
