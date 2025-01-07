--[[~ Updated: 2025/01/07 | Author(s): Gopher ]]
--
-- Backbone - An addon development framework for World of Warcraft.
--
--This program is free software: you can redistribute it and/or modify it under the terms
--of the GNU General Public License as published by the Free Software Foundation, either
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
--See the GNU General Public License <https://www.gnu.org/licenses/> for more details.



---
---?
---
---@param target unknown
---@param options? backbone.dump-options
---
backbone.dump = function(target, options)
  print 'backbone.dump not implemented yet.'
end






-- ---
-- ---Print a visually formatted representation of the provided value to the default
-- ---chat frame. Table values are recursively dumped, and the number of array elements
-- ---that are displayed can be limited using the `entry_limit` parameter.
-- ---
-- ---@param target unknown
-- ---@param options? backbone.dump-options
-- ---
-- backbone.dump = function(target, options)
--   ---
--   ---?
--   ---
--   ---@class backbone.dump-options
--   ---@field element_limit? number
--   ---@field recursive? boolean
--   ---@field max_depth? number
--   ---
--   options = options or {}
--   options.element_limit = options.element_limit or 10

--   local createValueDump, createTableDump
--   local array = backbone.utils.array
--   local switch = backbone.utils.logic.switch
--   local result = backbone.utils.string.builder:new()

--   createValueDump = function(value)
--     local value_type = type(value)

--     return switch(
--       value_type,
--       {
--         ['nil'] = function()
--           return '<neutral>nil</end>'
--         end,
--         ['string'] = function()
--           return '<neutral>string</end> "' .. value .. '"'
--         end,
--         [{ 'number', 'boolean' }] = function()
--           return string.format('<neutral>%s</end> %s', value_type, tostring(value))
--         end,
--         [{ 'function', 'thread', 'userdata' }] = function()
--           local value_dump = string.gsub(
--             tostring(value), '([^:]+): (.+)', '<neutral>%1</end> %2'
--           )
--           return value_dump
--         end
--       }
--     )
--   end

--   result:appendLine('[Backbone] Dumping debug information...')

--   if type(target) == 'table' then
--     local tracker = ({} --[[@as table<table, boolean>]])
--     local current_depth = 0 --[[@as number]]
--     local max_depth = options.max_depth or -1 --[[@as number]]

--     ---@param table table
--     ---@param level? number
--     createTableDump = function(table, level)
--       local space = '    '
--       local indent = string.rep(space, level or 0)
--       local nested_table = (type(level) == 'number' and level > 0)
--       local table_id = string.gsub(tostring(table), ': (.+)', ' <neutral>(%1)</end>')

--       if tracker[table] then
--         local value_dump = string.gsub(
--           tostring(table), 'table: (.+)', '<neutral>table</end> %1'
--         )
--         result:append(value_dump)
--         return -- prevent infinite recursion.
--       end

--       tracker[table] = true

--       if nested_table then
--         result:append(
--           string.format('<info>%s</end> <info>></end>', table_id)
--         )
--       else
--         result:appendLine(
--           string.format('<info>%s</end> <info>></end>', table_id)
--         )
--       end

--       if next(table) ~= nil then
--         local element_count = 0
--         local skipped_entries = 0
--         element_limit = element_limit or 10

--         local is_array = array.is(table)
--         for key, value in pairs(table) do
--           if element_limit > 0 then
--             element_count = element_count + 1
--           end

--           local is_toggle = (
--             type(key) == 'string' and type(value) == 'boolean'
--           )

--           if not (is_array or is_toggle) or (element_count <= element_limit) then
--             result:appendLine(
--               indent .. space .. string.format('<highlight>%s</end> <neutral>=</end> ', key)
--             )
--             if type(value) == 'table' then
--               if options.recursive ~= false then
--                 if max_depth == -1 or current_depth <= max_depth then
--                   current_depth = current_depth + 1
--                   createTableDump(value, (level or 0) + 1)
--                 end
--               end

--               if options.recursive == false or current_depth > max_depth then
--                 local value_dump = string.gsub(
--                   tostring(value), 'table: (.+)', '<neutral>table</end> %1'
--                 )
--                 result:append(value_dump)
--               end
--             else
--               result:append(createValueDump(value))
--             end
--           else
--             skipped_entries = skipped_entries + 1
--           end
--         end

--         if skipped_entries > 0 then
--           result:appendLine(
--             string.format(
--               indent .. space .. '<neutral>... %d skipped.</end>', skipped_entries
--             )
--           )
--         end
--       else
--         result:appendLine(indent .. space .. '<neutral>no entries</end>')
--       end

--       result:appendLine(indent .. '<info>end</end>')
--     end

--     createTableDump(target)
--   else
--     result:appendLine(createValueDump(target))
--   end

--   result:finalize(function(line) backbone.print(line) end)
-- end