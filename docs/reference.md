# Backbone API reference

This is the API reference for the Backbone framework, where you can find all the available methods and properties. Each method is listed with its signature, along with a description of what it does and, if required, a detailed description of special parameters and return values.

*The methods/properties are listed in alphabetical order.*

---

## activeLocale

Contains a string representation of the currently active locale, such as `enUS` or `frFR`.

## colorizeText

Parses the provided string for color tags, and returns a string with the specified colors applied.

```
backbone.colorizeText(text: string): string
```

There are seven predefined color tags: `normal`, `neutral`, `faded`, `info`, `error`, `highlight`, and `success`. These can be used as follows:

```lua
local colorful = backbone.colorizeText(
  '<success>This text is green but <error>this is red</end>.</end>'
)
```

Custom colors are specified using the `<color: #hex>` format:

```lua
local colorful = backbone.colorizeText('Who are you? <color:#4682B4>Bluey!</end>')
```

## createCustomEvent

Creates a custom event with the specified name and access level.

```
backbone.createCustomEvent(token: backbone.token, name: string, access?: 'public'|'private'): void
```

## createToken

Returns a unique token for the specified addon.

```
backbone.createToken(name: string): backbone.token
```

> *The `name` parameter must match the folder name of the addon.*

## currentExpansion

Contains a number representing the current expansion level of the game.

## executeTask

Immediately executes the provided callback function, returning its result.

```
backbone.executeTask(task: (fun(): unknown?)): unknown
```

> *The callback function is executed in "safe mode", meaning that errors will be handled gracefully by the framework. In `development` mode, any error messages are printed to the console.*

## getAddonVersionNumber

Returns the version number of the specified addon, or `0` if not specified.

```
backbone.getAddonVersionNumber(addon: string|number): number
```

> *The version number is specified in the addon metadata using the `Version` key.*

For example, `1.5.3` would be returned as `10503`.

## isAddonLoaded

Returns `true` if the specified addon is loaded, `false` otherwise.

```
backbone.isAddonLoaded(addon: string|number): boolean
```

## isDevelopment

Returns `true` if the framework is running in development mode, `false` otherwise.

```
backbone.isDevelopment(): boolean
```

## onAddonLoaded

Executes the provided callback when the specified addon is loaded.

```
backbone.onAddonLoaded(addonName: string, callback: function): void
```

The `callback` parameter expects a function with the signature `fun(payload: table): void`.

## parseAddonMetadata

Parses the metadata for the specified key from the specified addon. Returns an array of strings without any leading or trailing whitespace, or `nil` if the key does not exist.

```
backbone.parseAddonMetadata(addon: string|number, key: string, separator?: string): array<string>?
```

> *The `separator` parameter is optional and defaults to a comma.*

## print

Prints the provided message to the console. The message is passed to the [`backbone.colorizeText`](#colorizetext) function to parse any color tags present in the message.

```
backbone.print(message: string): void
```

## printf

Same as the [`backbone.print`](#print) method, but accepts extra arguments used to format the message. These arguments are passed to the `string.format` function.

```
backbone.printf(message: string, ...: string|number): void
```

## queueTask

Queues the provided function to be executed in the next render frame.

```
backbone.queueTask(task: (fun(): unknown?)): void
```

> *Queued tasks are executed in "safe mode", meaning that errors will be handled gracefully by the framework. In `development` mode, any error messages are printed to the console.*

## registerCustomEventListener

Registers an event listener for the specified custom event.

```
backbone.registerCustomEventListener(eventName: string, listener: object|function): void
```

The `listener` parameter accepts either an object with the following properties:

```
{
  callback: fun(payload: table): void
  persistent: boolean -- optional, default: true
  token: backbone.token -- optional, but required to access private events
}
```

... or a function with the signature `fun(payload: table): void`.

## removeCustomEventListener

Removes a listener from the specified custom event.

```
backbone.removeCustomEventListener(eventName: string, listener: object|function): void
```

The `listener` parameter requires a reference to the object or function that was registered with [`backbone.registerCustomEventListener`](#registercustomeventlistener).

## setEnvironment

Sets the environment for the framework to either `development` or `production`. In development mode, the framework prioritizes debugging by providing more detailed error messages. In production mode, the focus is on performance and user experience.

```
backbone.setEnvironment(mode: 'development'|'production'): void
```

## triggerCustomEvent

Notify the observers of the specified custom event. The provided `payload` is passed to all observers.

```
backbone.triggerCustomEvent(token: backbone.token, name: string, payload?: table): void
```