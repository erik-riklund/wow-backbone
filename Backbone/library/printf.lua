--
-- Prints a formatted string to the chat frame with color tag support.
-- Replaces <color_name>, <#hex>, and </end> tags with WoW UI escape sequences.
--
-- @param message (string) - The format string containing text and tags.
-- @param ... (string)     - Optional arguments for string formatting.
--
-- # version: 1.0.0
--
declare(
  'printf', function (message, ...)
    local palette = {
      normal  = 'F5DEB3', -- Warm, wheat color.
      neutral = 'FFFFFF', -- Plain white.
      faded   = 'BEBEBE', -- Light gray.
      info    = '4682B4', -- Steel blue.
      error   = 'CC4733', -- Dark red-orange.
      warning = 'FCD462', -- Soft golden-yellow.
      success = '00AC00', -- Bright green.
    }
    
    local result = (
        ... and string.format(message, ...) or message
      )
      :gsub('<#(%x%x%x%x%x%x)>',
        function(hex_color) return '|cFF' .. hex_color end
      )
      :gsub('<([^/>]+)>',
        function(color_code)
          return switch(
            color_code,
            {
              default = function()
                return '<' .. color_code .. '>'
              end,
              [map.keys(palette)] = function()
                return '|cFF' .. palette[color_code]
              end
            }
          )
        end
      )
      :gsub('</end>', '|r')

    print(result)
  end
)