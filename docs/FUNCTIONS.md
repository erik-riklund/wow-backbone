[< Backbone documentation](../README.md)

# Backbone
Version `1.0.0` (*work in progress*)

---

- **Logic-related functions**

  - [`backbone.switch`](#backboneswitch)
  - [`backbone.when`](#backbonewhen)

- **String-related functions**

  - [`backbone.splitString`](#backbonesplitstring)

- **Table-related functions**

  - [`backbone.copyTable`](#backbonecopytable)
  - [`backbone.createImmutableProxy`](#backbonecreateimmutableproxy)
  - [`backbone.flattenTable`](#backboneflattentable)
  - [`backbone.integrateTable`](#backboneintegratetable)
  - [`backbone.integrateTables`](#backboneintegratetables)
  - [`backbone.traverseTable`](#backbonetraversetable)

## Logic-related functions

This section covers utility functions designed to simplify common logic-based operations. These functions provide concise and readable ways to handle conditions and value selection, reducing the need for verbose conditional statements in your code.

---
### backbone.switch

`backbone.switch (key: T, cases: table<T, unknown>, ...unknown) -> unknown?`

Provides a table-based switch statement operator, which can be used to select a value based on a given key. The switch statement allows for multiple cases and an optional `default` case, making it a powerful tool for handling different scenarios based on input values.

> If the selected case is a function, it will be invoked with any extra arguments provided, and its result will be returned.

---
### backbone.when

`backbone.when (condition: boolean, onTrue: T, onFalse: T) -> T`

Provides a concise way to return one of two values based on a boolean condition. This function is useful in situations where Lua's built-in short-circuit operators does not work as expected.

```lua
-- always assigns `true` as `false` short-circuits the expression.
local value = (someValue == nil and false) or true
```

## String-related functions

This section covers utility functions for working with strings. These functions provide a concise and readable way to manipulate strings, reducing the need for verbose string operations in your code.

---
### backbone.splitString

`backbone.splitString (target: string, separator: string, pieces?: number) -> Vector`

Splits a string into substrings based on the given `separator`, removing any leading or trailing whitespace from each substring. If a limit on the number of parts is provided, the split will produce no more than `pieces` substrings. Returns a `Vector` object containing the resulting substrings.

---
## Table-related functions

This section covers utility functions for working with tables. These functions provide a concise and readable way to manipulate tables, reducing the need for verbose table operations in your code.

---
### backbone.copyTable

`backbone.copyTable (source: table) -> table`

Returns a new table containing the same elements as the `source` table, preserving their order.

> The function creates a shallow copy of the table, meaning that any nested tables will still reference the original tables.

---
### backbone.createImmutableProxy

`backbone.createImmutableProxy (source: table) -> table`

Creates a read-only proxy for the provided table. The proxy retrieves values from the `source` table when accessed, but does not allow any modifications.

---
### backbone.flattenTable

`backbone.flattenTable(target: table, parents?: string, result?: table): table`

Transforms a nested table into a single-level table by representing its structure through composite keys. The function recursively traverses the input table, combining parent keys with child keys using a `/` separator to create a flattened representation.

> This method skips keys that begin with `$`, treating them as special or excluded cases. The resulting table contains a direct mapping of composite keys to their corresponding values. If a `result` table is provided, it will be updated in place; otherwise, a new table will be returned.

---
### backbone.integrateTable

`backbone.integrateTable (base: table, source: table, mode?: 'strict'|'replace'|'skip') -> table`

Merges the contents of one table (`source`) into another (`base`) with configurable handling for key collisions. The integration process depends on the specified `mode`:

- **`strict`**: Throws an error if a key in the `source` table already exists in the `base` table.
- **`replace`**: Overwrites values in the `base` table with those from the `source`.
- **`skip`**: Leaves existing keys in the `base` table unchanged.

> By default, the `strict` mode is used. The updated `base` table is returned.

---
### backbone.integrateTables

`backbone.integrateTables (base: table, sources: table, mode?: 'strict'|'replace'|'skip') -> table`

Combines multiple tables (`sources`) into a single `base` table using a configurable merge strategy. This function applies the specified `mode` to control how conflicts between keys are resolved, iterating through each table in the `sources` collection.

- **`strict`**: Throws an error if a key in any `source` table conflicts with an existing key in the `base`.
- **`replace`**: Overwrites values in the `base` table with those from the `sources`.
- **`skip`**: Preserves existing keys in the `base` table, ignoring conflicts.

> The function processes each table in `sources` in order, merging their contents into `base`. By default, the `strict` mode is used. The updated `base` table is returned.

---
### backbone.traverseTable

`backbone.traverseTable (target: table, steps: table, mode?: 'exit'|'build'|'strict') -> unknown?`

Use this function to access or ensure the existence of deeply nested structures in a table. It navigates through the `target` table's nested structure based on a sequence of `steps`, allowing for flexible handling of missing paths. The behavior depends on the specified `mode`:

- **`exit`**: Stops traversal and returns `nil` if any step in the path does not exist.
- **`build`**: Automatically creates missing tables along the specified path.
- **`strict`**: Throws an error if a step in the path is not a table or does not exist.

> By default, the `exit` mode is used.

---

[< Backbone documentation](../README.md)