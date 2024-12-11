[< Backbone documentation](../README.md)

# Backbone
Version `1.0.0` (*work in progress*)

---
## Framework objects

- [`ChannelOptions`](#channeloptions)
- [`Listener`](#listener)
- [`Task`](#task)

This section contains documentation for framework objects. These objects are used to represent the structure of various entities within the framework.

---
#### `ChannelOptions`

These options are used when creating a new framework channel.

* `internal?: boolean`

  Specifies whether the channel is restricted to the owning plugin.
  - *Defaults to `false`, making the channel accessible to all plugins.*

* `executeAsync?: boolean`

  Determines whether listeners on this channel are executed immediately  or as a background task (asynchronously).
  - *Defaults to `true`, enabling background execution.*

---
#### `Listener`

The data structure for a listener reacting to channels or events.

* `id?: string`

  An optional unique identifier for the listener.
  - *If omitted, the listener will be anonymous (not eligible for targeted removal).*

* `callback: function`

  The function to execute when the channel is invoked.
  - *The callback should accept parameters specific to the channel.*

* `persistent?: boolean`

  Specifies whether the listener remains active after being invoked.
  - *Defaults to `true`. Set to `false` to remove the listener after one execution.*

---
#### `Task`

Represents a unit of work to be executed.

- `id?: string`

  An optional unique identifier for the task.
  - *If omitted, the task will be anonymous (less useful for debugging).*

- `callback: function`

  The callback function to execute.

- `arguments?: Vector`

  Arguments to pass to the callback function.

---

[< Backbone documentation](../README.md)