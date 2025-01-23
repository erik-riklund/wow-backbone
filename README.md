# Backbone
`version 1.0.0`

**Backbone** is an addon development framework for [World of Warcraft](https://worldofwarcraft.blizzard.com). Whether you are a seasoned developer or just starting out, Backbone provides the essential tools needed to build robust addons with less complexity. The framework offers an intuitive API for common tasks like event handling, localization, settings management, and more.

This project is open source and available under the [GNU General Public License](https://www.gnu.org/licenses/).

## Table of contents

- [Getting started](#getting-started)
- [Event handling](#event-handling)
- [Custom events](#custom-events)

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
