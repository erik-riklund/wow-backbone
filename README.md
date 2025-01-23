# Backbone
`version 1.0.0`

**Backbone** is an addon development framework for [World of Warcraft](https://worldofwarcraft.blizzard.com). Whether you are a seasoned developer or just starting out, Backbone provides the essential tools needed to build robust addons with less complexity. The framework offers an intuitive API for common tasks like event handling, localization, settings management, and more.

This project is open source and available under the [GNU General Public License](https://www.gnu.org/licenses/).

## Table of contents

- [Getting started](#getting-started)
- [Event handling](#event-handling)
- [Custom events](#custom-events)
- [State management](#state-management)
- [Define settings](#define-settings)

## Getting started

After installing Backbone, you will gain access to the global `backbone` object which serves as the gateway to the framework's API. This object allows you to interact with all of the framework's features.

Every addon should register themselves with the framework by creating a token. Tokens are unique objects that represent an addon within the framework's ecosystem. They are used to identify and manage the addon's settings, events, and other resources.

```lua
local token = backbone.createToken 'MyAddon'
```

## Event handling

?

## Custom events

?

## State management

In order to use the framework's state management features, you must specify the saved variables in your addon's `.TOC` file. The names of the saved variables must follow the naming rules below:

```
## SavedVariables: MyAddonAccountVariables
## SavedVariablesPerCharacter: MyAddonCharacterVariables
```

The example above assumes that the addon's name is `MyAddon`.

> To use `account` or `realm` storage, the `##SavedVariables` key must be defined.

Once these lines have been added, you can use `backbone.useStorage` to obtain a storage manager:

```lua
local accountStorageByDefault = backbone.useStorage(token)
local accountStorage = backbone.useStorage(token, 'account')
local realmStorage = backbone.useStorage(token, 'realm')
local characterStorage = backbone.useStorage(token, 'character')
```

> Note that the framework will throw an error if the addon is not fully loaded, so you should use `backbone.onAddonLoaded` to ensure that the addon is fully loaded.

```lua
backbone.onAddonLoaded('MyAddon', function()
  -- It's safe to use the storage here, as the saved variables have been loaded.
end)
```

### Using the storage manager

...

## Define settings

?