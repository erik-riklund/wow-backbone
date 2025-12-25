--  ____             _    _                      
-- | __ )  __ _  ___| | _| |__   ___  _ __   ___ 
-- |  _ \ / _` |/ __| |/ / '_ \ / _ \| '_ \ / _ \
-- | |_) | (_| | (__|   <| |_) | (_) | | | |  __/
-- |____/ \__,_|\___|_|\_\_.__/ \___/|_| |_|\___|
--                                  version 1.0.0
--                                               
-- github.com/erik-riklund/wow-backbone (2025)

local API = extendable({})
declare('Backbone', immutable(API))

--
-- [ Callback handler ]
--
-- A queued task execution system to manage callbacks,
-- ensuring no single frame is overwhelmed, preventing lag.
--

local tasks = {
  -- a sequential array of callbacks queued for execution.
}

CreateFrame('Frame')
  :SetScript('OnUpdate', function()
    if tasks[1] ~= nil then
      local time_limit = 0.01667 -- ~60 fps
      local time_started = GetTimePreciseSec()

      while tasks[1] ~= nil and (GetTimePreciseSec() - time_started < time_limit) do
        local success, result = pcall(table.remove(tasks, 1))
        
        if not success then
          local file, line, message = string.split(':', result, 3)
          printf('%s\n%s (line %d)', message, file, line)
        end
      end
    end
  end)

--
-- Defers the execution of a callback to the next update cycle.
-- Queues the function into the internal task buffer for safe execution.
--
-- @param callback (function) - The function to be executed.
--
-- # version: 1.0.0
--
Backbone.extend(
  'ExecuteCallback', function (callback)
    if type(callback) ~= 'function' then
      throw ('Expected `callback` to be a function, got %s.', type(callback))
    end
    table.insert(tasks, callback)
  end
)

--
-- [ Event handler ]
--
-- Registers addon event listeners and dispatches events to registered callbacks,
-- queuing them for safe execution via `Backbone.ExecuteCallback`.
--

local events = {
  -- event_id -> list of callbacks
}

local events_frame = CreateFrame('Frame')
events_frame:RegisterEvent('ADDON_LOADED')

events_frame:SetScript('OnEvent',
  function (_, event_name, ...)
    local args = {...}
    
    switch(event_name,
      {
        ADDON_LOADED = function ()
          local addon_name = args[1]
          local event_id = string.format(
            'ADDON_LOADED/%s', string.upper(addon_name)
          )
          
          if events[event_id] ~= nil then
            for _, callback in ipairs(events[event_id]) do
              Backbone.ExecuteCallback(
                function() callback(unpack(args)) end
              )
            end
            events[event_id] = nil
          end
        end,
        
        default = function ()
          local event_id = string.upper(event_name)
          
          if events[event_id] ~= nil then
            for _, callback in ipairs(events[event_id]) do
              Backbone.ExecuteCallback(
                function() callback(unpack(args)) end
              )
            end
          end
        end
      }
    )
  end
)

--
-- Subscribes to a standard WoW game event.
-- Registers the event with the internal frame if it is the first listener.
--
-- @param event_name (string) - The name of the Blizzard game event.
-- @param callback (function) - The function to execute when the event fires.
--
-- # version: 1.0.0
--
Backbone.extend(
  'OnEvent', function (event_name, callback)
    if event_name == 'ADDON_LOADED' then
      throw 'Use `Backbone.OnAddonLoaded` for the "ADDON_LOADED" event.'
    end
  
    local event_id = string.upper(event_name)
    if events[event_id] == nil then
      events_frame:RegisterEvent(event_name)
      events[event_id] = {}
    end
    table.insert(events[event_id], callback)
  end
)

--
-- Subscribes to the loading of a specific addon.
-- Executes immediately if the addon is already loaded, otherwise waits for the event.
--
-- @param addon_name (string) - The name of the addon to watch for.
-- @param callback (function) - The function to execute once the addon is ready.
--
-- # version: 1.0.0
--
Backbone.extend(
  'OnAddonLoaded', function (addon_name, callback)
    if select(2, C_AddOns.IsAddOnLoaded(addon_name)) then
      Backbone.ExecuteCallback(function() callback() end)
      
      return -- the addon is already loaded.
    end
  
    local event_id = string.format(
      'ADDON_LOADED/%s', string.upper(addon_name)
    )
    events[event_id] = events[event_id] or {}
    table.insert(events[event_id], callback)
  end
)