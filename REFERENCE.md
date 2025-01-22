## Backbone API reference

This is the API reference for the Backbone framework, where you can find all the available methods and properties. Each method is listed with its signature, along with a description of what it does and, if required, a detailed description of special parameters and return values.

*The methods/properties are listed in alphabetical order.*

---

### activeLocale

Contains a string representation of the currently active locale, such as `enUS` or `frFR`.

---

### createToken

?

`backbone.createToken(name: string): backbone.token`

---

### currentExpansion

Contains a number representing the current expansion level of the game.

---

### getAddonVersionNumber

Returns the version number of the specified addon, or `0` if not specified.

`backbone.getAddonVersionNumber(addon: string|number): number`

> *The version number is specified in the addon metadata using the `Version` key.*

For example, `1.5.3` would be returned as `10503`.

---

### isAddonLoaded

Returns `true` if the specified addon is loaded, `false` otherwise.

`backbone.isAddonLoaded(addon: string|number): boolean`

---

### parseAddonMetadata

Parses the metadata for the specified key from the specified addon. Returns an array of strings without any leading or trailing whitespace, or `nil` if the key does not exist.

`backbone.parseAddonMetadata(addon: string|number, key: string, separator?: string): array<string>?`

> *The `separator` parameter is optional and defaults to a comma.*

---