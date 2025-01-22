# Backbone

**Backbone** is an addon development framework for [World of Warcraft](https://worldofwarcraft.blizzard.com). Whether you are a seasoned developer or just starting out, Backbone provides the essential tools needed to build robust addons with less complexity. The framework offers an intuitive API for common tasks like event handling, localization, settings management, and more.

This project is open source and available under the [GNU General Public License](https://www.gnu.org/licenses/).

## Table of contents

- [Getting started](#getting-started)

## Getting started

After installing Backbone, you will gain access to the global `backbone` object which serves as the gateway to the framework's API. Many of the framework's features require a token, which you can create using `backbone.createToken`. With the token in hand, your addon is ready to harness the full power of the framework - from creating custom events to managing addon settings and beyond.

- `backbone.createToken(name: string): backbone.token`

  Creates a new token for your addon, used to uniquely identify it within the framework.
  
  *The `name` parameter must match the folder name of your addon.*

```lua
local token = backbone.createToken 'MyAddon'
```

## API reference

### Environment

The framework supports two environment modes: `development` and `production`. The environment controls the behavior of the framework and its features. In development mode, the framework provides more detailed error messages, while in production mode, it optimizes performance.

- `backbone.isDevelopment(): boolean`

  Returns `true` if the framework is operating in development mode, `false` otherwise.

- `backbone.setEnvironment(mode: 'development'|'production')`

  Sets the environment mode to either `development` or `production`.
