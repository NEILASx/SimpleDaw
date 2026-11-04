## `UI`

`UI` is a global table that provides access to the DAW's UI.

UI also includes widgets that can be used to create a more friendly User Interface.

UI is commonly used with the [colors](colors.md) global. which reflects the user's color preferences.

### `UI.fillRect(rect, color)`

Draws a filled [rectangle](Rect.md) to the screen.

```lua
UI.fillRect({x = 0, y = 0, w = 100, h = 100}, color.accent)
```

### `UI.fullScreen()`

Returns a [Rect](Rect.md) that represents the entire window.

*NOTE: when writing [plugins](plugin.md), you should use the Rect provided in [plugin.draw()](plugin.md#plugindrawrect-state).