-- function UIDepthSearch(elementName, current, visited, traversing)
--     current = current or Ext.UI.GetRoot()
--     visited = visited or {}
--     traversing = traversing or {}

--     if current:Find(elementName) then
--         return current
--     end

--     traversing[current] = true

--     for i = 0, current.ChildrenCount - 1 do
--         local child = current:Child(i)
--         if not traversing[child] and not visited[child] then
--             local result = UIDepthSearch(elementName, child, visited, traversing)
--             if result then
--                 return result
--             end
--         end
--     end

--     traversing[current] = nil
--     visited[current] = true

--     return nil
-- end

-- function GetTopLevelTable(nestedTable)
--     local currentTable = nestedTable
--     local meta = getmetatable(nestedTable)
--     while meta and meta.__index do
--         currentTable = meta.__index
--         meta = getmetatable(currentTable)
--     end
--     return currentTable
-- end

-- GetTopLevelTable(_G)["UIDepthSearch"] = UIDepthSearch
