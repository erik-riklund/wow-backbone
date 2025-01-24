# Backbone
`version 1.0.0`

**Backbone** is an addon development framework for [World of Warcraft](https://worldofwarcraft.blizzard.com). Whether you are a seasoned developer or just starting out, Backbone provides the essential tools needed to build robust addons with less complexity. The framework offers an intuitive API for common tasks like event handling, localization, settings management, and more.

This project is open source and available under the [GNU General Public License](https://www.gnu.org/licenses/).

## Table of contents

- [Getting started](#getting-started)
- [Event handling](#event-handling)
- [Custom events](#custom-events)
- [State management](#state-management)
- [Settings](#settings)
- [Localization](#localization)
- [Services](#services)

## Getting started

After installing Backbone, you will gain access to the global `backbone` object which serves as the gateway to the framework's API. This object allows you to interact with all of the framework's features.

Every addon should register themselves with the framework by creating a token. Tokens are unique objects that represent an addon within the framework's ecosystem. They are used to identify and manage the addon's settings, events, and other resources.

```lua
local yourToken = backbone.createToken 'YourAddon'
```

> This documentation uses `YourAddon` as the example addon name throughout. The `yourToken` variable represents the addon instance in code samples.

## Event handling

Listening for events is a fundamental part of addons. The framework provides a simple and efficient way to register event handlers:

```lua
backbone.registerEventListener(
  'LOOT_OPENED', function(payload)
    -- the implementation for this event handler --
  end
)
```

The second parameter can also be an object with the properties `callback` and `persistent`:

```lua
backbone.registerEventListener(
  'LOOT_OPENED', {
    persistent = false, -- optional, default: true
    callback = function(payload)
      -- the implementation for this event handler --
    end
  }
)
```

> If the `persistent` property is explicitly set to `false`, the event handler will be automatically removed after the first invocation.

### Removing a listener

To remove an existing listener, a reference to the original object or function is required:

```lua
local listener = {
  persistent = true,
  callback = function(payload)
    -- the implementation for this event handler --
  end
}

backbone.registerEventListener('LOOT_OPENED', listener)
-- one eternity later...
backbone.removeEventListener('LOOT_OPENED', listener)
```

## Custom events

The framework allows you to create your own event types. These events can be triggered by your addon, and can be used to communicate and share data, both internally and between addons.

```lua
backbone.createCustomEvent(yourToken, 'YourEvent', 'public')
```

The third parameter controls the event's visibility. The default value is `public`, which means that the event is visible to all addons. If you want to make the event private, you can set it to `private`.

> Regardless of visibility, the event can only be triggered by the addon that created it.

### Triggering a custom event

Triggering a custom event is simple:

```lua
local payload = { alpha = 'a', beta = 'b' }
backbone.triggerCustomEvent(yourToken, 'YourEvent', payload)
```

> The third argument is optional and can be used to pass data to the event listeners.

### Managing listeners for custom events

Registering and removing listeners for custom events follow the same pattern as for regular events, with one exception. To be able to listen to a private event, the `listener` object requires a `token` property to verify the event owner.

```lua
backbone.registerCustomEventListener(
  'YourPrivateEvent', {
    token = yourToken,
    persistent = false, -- optional, default: true
    callback = function(payload)
      -- the implementation for this event handler --
    end
  }
)
```

## State management

In order to use the framework's state management features, you must specify the saved variables in your addon's `.TOC` file. The names of the saved variables must follow the naming rules below:

```
## SavedVariables: YourAddonAccountVariables
## SavedVariablesPerCharacter: YourAddonCharacterVariables
```

> To use `account` or `realm` storage, the `SavedVariables` key must be defined.

Once these lines have been added, you can use `backbone.useStorage` to obtain a storage manager:

```lua
local accountStorage = backbone.useStorage(yourToken, 'account')
```

> The second parameter accepts `account`, `realm` and `character` as valid values. If omitted, the default value is `account`.

The framework will throw an error if you attempt to use the storage while the addon is not fully loaded, so you should use `backbone.onAddonLoaded` to ensure that the saved variables are available.

 ```lua
 backbone.onAddonLoaded('YourAddon', function()
  local accountStorage = backbone.useStorage(yourToken)
  -- It's safe to use the storage here, as the saved variables have been loaded.
end)
```

### Using the storage manager

The storage manager provides methods for setting and getting values from the addon's saved variables. The methods use a key to identify the value to be set or retrieved. Nested keys can be specified by using a slash-separated path.

```lua
backbone.onAddonLoaded('YourAddon', function()
  local realmStorage = backbone.useStorage(yourToken, 'realm')
  realmStorage:set('my/nested/key', 'Hello world')

  print(realmStorage:get 'my/nested/key') -- output: Hello world
end)
```

## Settings

The framework provides functionality for managing addon settings. It allows you to define the default settings for your addon, and you have the option to use specific scopes, such as `account`, `realm` and `character`. The default settings are defined as follows:

```lua
local defaultSettings = {
  someSetting = 'Hello world',
  anotherSetting = { nestedValue = 12345 }
}

local settings = backbone.useSettings(yourToken, defaultSettings, 'account')
```

> The third parameter define the scope of the settings. It is optional and defaults to `account`.

### Using the settings manager

The settings manager provides methods for getting and setting values. The methods use a key to identify the value to be set or retrieved. Nested keys can be specified by using a slash-separated path.

```lua
-- We assume that we have access to the settings defined in the previous example.
print(settings:getValue 'someSetting') -- output: Hello world
```

When setting values, the framework will perform a type-check against the default value. If the type of the value to be set does not match the type of the default value, an error will be thrown.

```lua
settings:setValue('anotherSetting/nestedValue', '54321') -- expects a number, got a string.
```

### Handling lists

The settings manager supports lists, which are arrays of values. Lists are defined as follows:

```lua
local defaultSettings = {
  interestingItems = backbone.createListSetting('boolean', { 1, 2, 3 })
  -- result -> { [1] = true, [2] = true, [3] = true }
}
```

> The first parameter defines the expected type of values in the list. It must be one of `boolean`, `string` or `number`.

To retrieve a value from a list, use the `getListValue` method:

```lua
if settings:getListValue('interestingItems', 1) == true then
  print 'Item 1 is interesting!'
end
```

> The second parameter specifies the key of the value to retrieve. It is automatically converted to a string, as list keys are always strings.

In the same way, to set a value in a list, use the `setListValue` method:

```lua
settings:setListValue('interestingItems', 4, true) -- item 4 is now interesting!
```

If you need to obtain values from the default settings, the methods `getDefaultValue` and `getDefaultValueFromList` are available. These work the same way as the `getValue` and `getListValue` methods, respectively.

### Custom event for changed settings

The framework provides custom events, named `SETTING_CHANGED/{addonName}`, which can be used to react to changes in settings. For simple values, the payload is the `key` and its new `value`. For lists, the payload has the following properties:

```lua
{
  list: string   -- the path to the list, e.g. 'interestingItems'
  key: string    -- the key that was changed, e.g. '1'
  value: unknown -- the new value
}
```

## Localization

?

## Services

?

---

You have reached the end of the documentation. [Return to the table of contents.](#table-of-contents)