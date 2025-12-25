--
-- Throws a formatted error message.
-- Aborts execution and reports the error at the level of the caller.
--
-- @param exception (string) - The error message to display.
-- @param ... (unknown)      - Optional arguments for string formatting.
--
-- # version: 1.0.0
--
declare(
  'throw', function (exception, ...)
    error(... and string.format(exception, ...) or exception, 2)
  end
)