# Backbone
Version `1.0.0` (*work in progress*)

---

- [Introduction](#introduction)
- [Developer community](#developer-community)
- [Getting started and beyond](#getting-started-and-beyond)

  - [Initialization](#initialization)
  - [Event handling](#event-handling)
  - [Framework channels](#framework-channels)
  - [Localization](#localization)
  - [State management](#state-management)
  - [Plugin settings](#plugin-settings)
  - [Services](#services)

- [Configuration panels](#configuration-panels)
- [Conditional loading of addons](#conditional-loading-of-addons)
- [Reference documentation](#reference-documentation)
- [Developer resources](#developer-resources)

---
## Introduction

Backbone is a framework that makes addon development easier and more efficient. It takes care of repetitive tasks, basic setup, and performance tuning, so you can focus on creating the features and functionality that matter most. With its simple and clear structure, Backbone helps you write clean, organized code that’s easy to manage and grow over time.

Whether you’re an experienced developer or just getting started, Backbone gives you the tools to build high-quality addons with confidence. It’s not just about the technical features—it’s also about community. Backbone brings developers together to share ideas, learn from each other, and grow as a team.

### What makes Backbone great?

- **Load smarter.** Only load addons when they’re needed to keep things running smoothly.
- **Get started fast.** Backbone handles the basics so you can focus on building.
- **React to events easily.** Create dynamic addons that respond to game events effortlessly.
- **Communicate seamlessly.** Use framework channels to share information between addons.
- **Save and manage data.** Keep data persistent across sessions with efficient state management.
- **Reach more players.** Add support for multiple languages with built-in localization tools.
- **Let players customize.** Easily specify settings and create configuration panels so users can tailor your addon to their preferences.

---
The Backbone community is all about respect, collaboration, and helping each other succeed. Whether you need advice, want to share your latest project, or just connect with other developers, the community is here for you. It’s a welcoming space where you can ask questions, learn new things, and share your own expertise.

We believe in open communication and teamwork, creating an inclusive environment where everyone—from beginners to experts—can grow and thrive. Join us to be part of a vibrant community that’s passionate about building amazing addons together.

> [Join the Backbone community on Discord](https://discord.gg/JaHq2wWweS) 💬

---
## Getting started and beyond

The [`Plugin`](docs/PLUGIN.md) class is the heart of the Backbone framework, giving you everything you need to make addon development simpler and more efficient. It takes care of the behind-the-scenes setup and lifecycle management, so you can focus on building the exciting features and functionality that make your addon unique.

Here’s how to create a plugin:

```lua
-- The plugin name should match the name of your addon folder.
local plugin = backbone.createPlugin 'MyPlugin'
```

> Throughout this guide, the `plugin` variable refers to your active plugin. It’s the main way you’ll interact with the framework to handle events, manage settings, and more.

---
## Initialization

Initialization is a key step in getting your addon ready to run. It makes sure everything is set up properly before your code starts executing. This is especially important for features like saving data or managing settings, which depend on everything being ready to go.

### Getting your plugin ready

To make sure your plugin is fully prepared, use the `Plugin.onReady` method. The code inside this method runs after the plugin has finished initializing.

```lua
plugin:onReady (
  function ()
  -- This code runs when the plugin is fully initialized.
  end
)
```

### Working with other addons

If your addon relies on another addon, you can use `backbone.onAddonReady` to wait until that addon has loaded. This ensures everything works together smoothly.

```lua
backbone.onAddonReady (
  'SomeOtherAddon', function ()
    -- This code runs when `SomeOtherAddon` is fully loaded.
  end
)
```

> Using these methods helps prevent errors and ensures everything is set up properly. This means your addon—and any addons it depends on—will work smoothly for players, creating a seamless experience.

---
## Event handling

Event handling is a core part of the framework that lets your plugin respond to in-game events dynamically. For example, you can trigger actions when a player interacts with something or when the game state changes. This makes it easy to connect your plugin’s functionality to the game.

### Listening for events

To respond to an event, you need to register an event listener using the `Plugin.registerEventListener` method. You’ll need to specify the event name and a [`Listener`](docs/OBJECTS.md) object that includes what should happen when the event occurs.

Here’s an example:

```lua
plugin:registerEventListener (
  'SOME_EVENT', {
    persistent = true, -- Keeps the listener active (default is true).
    identifier = 'MyEventListener', -- Optional: useful for removing this listener later.

    callback = function (--[[ event-specific arguments ]])
      -- This code runs when the event happens.
    end
  }
)
```

### Stopping an event listener

If you want to stop listening for an event, you can remove the listener using the `Plugin.removeEventListener` method. Just provide the event name and the identifier you used when registering it.

```lua
plugin:removeEventListener ('SOME_EVENT', 'MyEventListener')
```

---
## Framework channels

Framework channels are a powerful feature that let different parts of your plugin—or even other addons—communicate with each other. You can use channels to share data, trigger actions, and much more.

### Creating a channel

To set up a channel, use the `Plugin.createChannel` method. Give your channel a name, and you can also include optional settings with a [`ChannelOptions`](docs/OBJECTS.md) object.

```lua
plugin:createChannel (
  'MY_CHANNEL', {
    internal = false, -- Whether the channel is only for your plugin (optional).
    executeAsync = true -- Whether to run the channel asynchronously (optional).
  }
)
```

### Listening to a channel

Once your channel is created, you can add listeners to it. A listener is a function that runs when the channel is triggered. Use the `Plugin.registerChannelListener` method to register a listener.

```lua
plugin:registerChannelListener (
  'MY_CHANNEL', {
    persistent = true, -- Keeps the listener active (default is true).
    identifier = 'MyChannelListener', -- Optional: helpful for removing it later.

    callback = function (--[[ channel-specific arguments ]])
      -- Code here runs when the channel is triggered.
    end
  }
)
```

### Removing a listener

If you no longer need a listener, you can remove it using `Plugin.removeChannelListener`. Just provide the channel name and the listener’s identifier.

```lua
plugin:removeChannelListener ('MY_CHANNEL', 'MyChannelListener')
```

### Triggering a channel

To run all the listeners attached to a channel, use `Plugin.triggerChannel`. You can also pass extra information to the listeners as arguments.

```lua
plugin:triggerChannel ('MY_CHANNEL', --[[ additional arguments ]])
```
> **Tip:** If your addon uses channels to send messages or data to other addons, be sure to document what arguments the listeners should expect. This helps everyone use the channels effectively.

---
## Localization

Localization helps your addon reach more players by translating text into different languages. The framework makes it easy to manage translations, so you can define and retrieve text in multiple languages without hassle.

### Adding translations for your addon

You can register translations for a specific language using the `Plugin.registerLocalizedStrings` method. Each translation is stored with a unique key. If you try to register the same key more than once, the first translation will be kept, and duplicates will be ignored.

```lua
plugin:registerLocalizedStrings(
  'enUS', {
    HELLO_WORLD = 'Hello world!',
    GREETING = 'Welcome to the game!',
    
    -- Add more translations here
  }
)
```
> The `enUS` locale is the default language for the framework.

### Adding translations from other addons

Other addons can contribute translations to your plugin using the `backbone.registerLocalizedStrings` method. This makes it easier to support multiple languages by allowing collaboration between developers. External translations don’t overwrite your existing keys, ensuring your addon remains consistent.

```lua
backbone.registerLocalizedStrings(
  'MyPlugin', 'deDE', {
    HELLO_WORLD = 'Hallo Welt!',
    GREETING = 'Willkommen im Spiel!',
    
    -- Add more translations here
  }
)
```
> External translations are loaded after your addon’s own translations, so you don’t need to worry about conflicts.

### Retrieving a translation

To get the translated text for a specific key, use the `Plugin.getLocalizedString` method. If the key is not available in the current language, the framework will automatically use the `enUS` translation as a fallback.

```lua
print (plugin:getLocalizedString ('HELLO_WORLD')) -- Output: Hello world!
```

If the key is missing in both the current and fallback locales, the framework will return an error message:

```lua
print (plugin:getLocalizedString ('MISSING_KEY'))

-- Output: The string "MISSING_KEY" is not registered for plugin "MyPlugin".
```

### Getting translations from other addons

You can also retrieve translations from other plugins using the `backbone.getLocalizedString` method. Provide the plugin name and the key for the string you need.

```lua
print (backbone.getLocalizedString ('SomePlugin', 'GREETING'))
```
> This collaborative approach allow for shared translations across addons, reducing both memory usage and development time while maintaining consistency.

---
## State management

State management is an important feature of the framework that lets you save and retrieve data across game sessions. This means players’ settings and progress can be stored and reused automatically.

### Enabling saved variables

To use state management, you need to define the saved variable names in your addon's `.toc` file. You can choose to store data account-wide, per character, or both.

```toc
## SavedVariables: MyPluginAccountVariables
## SavedVariablesPerCharacter: MyPluginCharacterVariables
```
> Replace `MyPlugin` with the name of your addon. Choose the type of variables based on whether the data should be shared across all characters or kept specific to each one.

#### Important note!

You can’t access or modify variables until your plugin is fully initialized. Make sure to wrap any state-dependent code inside a `Plugin.onReady` method to avoid errors (see [Initialization](#initialization)).

### Retrieving saved variables

You can retrieve the value of a saved variable using `Plugin.getAccountVariable` or `Plugin.getCharacterVariable`. These methods work for both simple keys and nested paths (using a slash-separated format).

Here’s how to get saved variables:

```lua
-- Simple variables
local accountVariable = plugin:getAccountVariable 'myVariable'
local characterVariable = plugin:getCharacterVariable 'myVariable'

-- Nested variables
local nestedAccountVariable = plugin:getAccountVariable('top/myVariable')
local nestedCharacterVariable = plugin:getCharacterVariable('top/middle/myVariable')
```

### Updating saved variables

To change the value of a saved variable, use `Plugin.setAccountVariable` or `Plugin.setCharacterVariable`. Like retrieval, you can update both simple keys and nested paths.

```lua
-- Simple variables
plugin:setAccountVariable ('myVariable', true)
plugin:setCharacterVariable ('myVariable', true)

-- Nested variables
plugin:setAccountVariable ('top/myVariable', true)
plugin:setCharacterVariable ('top/middle/myVariable', true)
```
> If the path includes missing tables (e.g., `middle`), they’ll be created automatically when setting a nested variable.

---
## Plugin settings

Plugin settings let your addon adapt to player preferences, giving users control over how it works. With these tools, you can create a more flexible and personalized experience for players.

> Settings are stored using saved variables, so player preferences are remembered across game sessions for a consistent experience (see [State management](#state-management)).

### Setting up default values

You can define default settings for your addon using the `Plugin.registerDefaultSettings` method. This ensures that your addon has a baseline configuration, even if the user hasn’t changed any settings yet. If players customize a setting, their preferences will automatically override the default values.

Here’s how to register default settings:

```lua
plugin:registerDefaultSettings {
  displayMode = 'compact',
  colorTheme = 'dark',

  -- Add more settings as needed.
}
```

#### Nested settings

For better organization, you can group related settings into nested tables. Access these settings using a slash-separated path, such as `frame/windowWidth`.

```lua
plugin:registerDefaultSettings {
  displayMode = 'compact',
  colorTheme = 'dark',

  frame = {
    windowWidth = 800,
    windowHeight = 600,

    -- Add more frame settings as needed.
  }
}
```

### Retrieving a setting

To get the current value of a setting, use the `Plugin.getSetting` method. If the player has customized the setting, their value will be returned. Otherwise, the default value will be used.

```lua
-- Get the current value of a simple setting:
local displayMode = plugin:getSetting 'displayMode'

-- Get the current value of a nested setting:
local windowWidth = plugin:getSetting 'frame/windowWidth'
```
> If you try to access a setting that doesn’t exist, the framework will throw an error to help you catch potential mistakes.

### Changing a setting

You can update a setting dynamically using the `Plugin.setSetting` method. The new value will be saved and remembered across sessions.

```lua
-- Update a simple setting:
plugin:setSetting ('displayMode', 'expanded')

-- Update a nested setting:
plugin:setSetting ('frame/windowWidth', 1200)
```
> The framework checks that the new value matches the type of the default value. If it doesn’t, an error will be thrown to avoid misconfiguration.

---
## Services

Services are shared components that provide functionality to multiple addons. They help centralize common logic or data, making your addons easier to manage and maintain. The framework makes it simple to create, register, and access services.

### Creating and registering a service

To create a service, define the functionality in a service object and register it with the framework using `Plugin.registerService`. Each service needs a name and an initializer function that returns the service object.

Here’s an example of a basic calculator service:

```lua
---@class CalculatorService
local calculator = {}

-- Add methods to the service:
calculator.add = function (a, b) return a + b end
calculator.subtract = function (a, b) return a - b end

-- Register the service:
plugin:registerService (
  'CalculatorService', function () return calculator end
)
```
> **Tip:** If your addon acts as a dedicated service, use [conditional loading](#loading-for-service-requests) to optimize performance.

### Using a service

To use a service, call the `backbone.requestService` function with the service name. You’ll get the service object in return, which you can use to access its functionality.

Here’s how to access the `CalculatorService`:

```lua
local calculator = backbone.requestService 'CalculatorService'

print (calculator.add (1, 2))      -- Output:  3
print (calculator.subtract (1, 2)) -- Output: -1
```
> If the returned service object is a table, a read-only proxy will be returned to ensure immutability.

#### Handling services with parameters

If the service initializer needs extra information, you can pass arguments when requesting the service:

```lua
local someService = backbone.requestService ('SomeService', arg1, arg2)
```
> **Pro Tip:** Using the [Lua Language Server](https://luals.github.io/) is highly recommended. It automatically detects the service's type from its name, providing helpful code hints and ensuring smooth development, given that the service provider has declared the service's type properly.

---
## Configuration panels

Configuration panels make it easy for users to customize your addon directly from the user interface. The framework provides a simple API to create and manage these panels, helping you offer flexibility and personalization to players. Plus, the framework ensures settings are handled consistently across all addons in the Backbone ecosystem.

### Setting up a configuration panel

> Before creating a configuration panel, make sure you’ve [registered default settings](#setting-up-default-values) for your plugin. This ensures user preferences are ready when the panel is displayed (see [Initialization](#initialization])).

To create a configuration panel, use the `backbone.createConfigPanel` method. It returns a `ConfigPanel` object that lets you manage and customize the panel.

Here’s how to get started:

```lua
-- Create an empty panel and add it to the user interface:

local configPanel = backbone.createConfigPanel (plugin)
```

Once your panel is created, you can use it to add sections and controls, letting users easily adjust your addon’s settings to suit their preferences.

> For a complete list of methods, check out the [class reference](docs/CLASSES.md).

---
## Conditional loading of addons

To improve performance, the framework supports conditional loading of addons. This means your addon only loads when it’s actually needed, saving memory and reducing the game’s initial load time. By loading addons on demand, you can provide a smoother experience for players.

> How to enable conditional loading:
>
> Add the `LoadOnDemand` flag to your addon’s `.toc` file and specify the conditions under which it should load.

```toc
## LoadOnDemand: 1
```

### Loading based on game events

You can use the `OnEvent` trigger to load your addon in response to specific game events. This is a simple and effective way to ensure your addon activates only when it’s relevant.

```toc
## X-Load-OnEvent: FIRST_EVENT [, SECOND_EVENT [, ...]]
```

### Loading when another addon is active

The `OnAddonLoaded` trigger ensures your addon only loads after another specified addon is fully loaded. This is useful if your addon relies on or extends the functionality of another addon.

```toc
## X-Load-OnAddonLoaded: SomeOtherAddon
```

### Loading for service requests

If your addon acts as a service — such as a data provider or database — you can use the `OnServiceRequest` trigger. This ensures your addon only loads when another addon explicitly requests it, optimizing performance.

```toc
## X-Load-OnServiceRequest: MyService
```
> *This is especially helpful for background functionality that doesn’t need to be active all the time.*

---
## Reference documentation

This section is your go-to resource for learning about the core components of the framework. It provides detailed explanations of the classes, functions, methods, and other key elements you’ll use to build with Backbone. Whether you’re just starting or need an advanced reference, you’ll find everything you need here.

### Explore the documentation

- [Framework API](docs/FRAMEWORK.md)

  A detailed guide to the methods and resources provided by the framework.

- [Framework objects](docs/OBJECTS.md)

  Learn about essential framework objects and their structure.

- [Plugin methods](docs/PLUGIN.md)

  Understand the lifecycle methods and features available for plugins.

- [Utility functions](docs/FUNCTIONS.md)

  Discover helper functions that simplify common development tasks.

- [Class reference](docs/CLASSES.md)

  Explore available classes, their methods, and how to use them effectively.

- [Enumerations](docs/ENUMS.md)

  Check out predefined enumerations and their values for use in your code.

---
## Developer resources

Here are some useful resources to help you get the most out of Backbone:

- [GitHub repository](https://github.com/erik-riklund/wow-backbone)
  
  Visit the official Backbone repository to find the latest version, report issues, or contribute to the project. It’s a great starting point to explore the codebase, understand the framework’s features, and stay updated.

- [Backbone community on Discord](https://discord.gg/JaHq2wWweS)

  Connect with other developers in the Backbone community! It’s a friendly and supportive space to ask questions, get help, and share knowledge. Announce and celebrate your addon releases or find inspiration from others. Everyone’s welcome!

- [Visual Studio Code](https://code.visualstudio.com/)

  Visual Studio Code is the IDE used to develop Backbone. It’s a powerful and user-friendly tool for writing and debugging code, managing projects, and handling version control. If you’re new to development, this is a great place to start.

- [Lua Language Server](https://luals.github.io/)

  The Lua Language Server enhances Lua development with features like diagnostics, annotations, and a dynamic type system. Backbone uses annotations to provide helpful code hints, making development smoother and more consistent. This tool is highly recommended for working with Backbone.