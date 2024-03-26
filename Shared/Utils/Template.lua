---@diagnostic disable: duplicate-set-field

Template = {}

-- -------------------------------------------------------------------------- --
--                                  Templates                                 --
-- -------------------------------------------------------------------------- --
if Ext.IsServer() then
    Template.GetAllCacheTemplates = Ext.Template.GetAllCacheTemplates
    Template.GetAllLocalCacheTemplates = Ext.Template.GetAllLocalCacheTemplates
    Template.GetAllLocalTemplates = Ext.Template.GetAllLocalTemplates
    Template.GetAllRootTemplates = Ext.Template.GetAllRootTemplates
    Template.GetCacheTemplate = Ext.Template.GetCacheTemplate
    Template.GetLocalCacheTemplate = Ext.Template.GetLocalCacheTemplate
    Template.GetLocalTemplate = Ext.Template.GetLocalTemplate
    Template.GetRootTemplate = Ext.Template.GetRootTemplate
    Template.GetTemplate = Ext.Template.GetTemplate
end

---Try its best to get the RT of something
---@param item GUIDSTRING?
---@return GameObjectTemplate?
function GetRootTemplateData(item)
    if item then
        return Template.GetRootTemplate(GUID(Osi.GetTemplate(item)))
    else
        DFprint("Couldn't get RT for item %s", item)
    end
end
