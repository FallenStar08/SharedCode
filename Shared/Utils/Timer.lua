---Measure the execution time of a given function
---@param func function the function to measure the execution time of
function MeasureExecutionTime(func)
    local startTime = Ext.Utils.MonotonicTime()
    func() -- Execute the provided function
    local endTime = Ext.Utils.MonotonicTime()
    local elapsedTime = endTime - startTime
    return elapsedTime
end

---Delay a function call by the given time
---@param ms integer
---@param func function
function DelayedCall(ms, func)
    if ms == 0 then
        func()
        return
    end
    local Time = 0
    local handler
    handler = Ext.Events.Tick:Subscribe(function(e)
        Time = Time + e.Time.DeltaTime * 1000
        if (Time >= ms) then
            func()
            Ext.Events.Tick:Unsubscribe(handler)
        end
    end)
end

---Bouncy bounce
---@param fn function the callback
---@param delay number delay in sec
---@return function
function Debounce(fn, delay)
    local timer = nil
    return function(...)
        local args = { ... }
        if timer then
            Ext.Timer.Cancel(timer)
        end
        timer = Ext.Timer.WaitFor(delay * 1000, function()
            fn(table.unpack(args))
            timer = nil
        end)
    end
end
