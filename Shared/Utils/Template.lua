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