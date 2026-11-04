## `plugin`

Every plugin must have a `plugin` table containing the following fields:

* `name` - the name of the plugin.
* `startup` - a function called when the plugin is loaded. It returns the plugin's initial state.
* `process` - a function that processes an audio buffer. It takes `state` and `buffer` as arguments.
* `draw` - a function called every frame to draw the plugin's UI. It takes `rect` and `state` as arguments.

## Before you start

The DAW's built-in plugins are implemented using this same API.
Their Lua source is available in `/plugins/` next to the executable and can be used as reference when developing your own plugins.

For example:

- Need an effect? Look at the built-in effects.
- Need a generator? Look at the built-in instruments.

The built-in plugins are not special implementations, they use the same public plugin API available to user plugins.

### Usage example

This example implements a simple sine-wave oscillator.

The plugin stores the oscillator's current phase in `state.value`,
along with its frequency and the device's sample rate. The frequency is specified in Hz, while `state.increment` represents how many radians the phase advances for each audio frame

```lua
local plugin = {}

plugin.name = "Sine Oscillator"

function plugin.startup()
    local sampleRate = daw.getDevice().getSampleRate()

    return {
        value = 0,
        frequency = 440,
        sampleRate = sampleRate,
    }
end

function plugin.process(state, buffer)
    for i = 1, buffer.frames do
        for channel = 1, buffer.channels do
            buffer:set(i, channel, math.sin(state.value))
        end

        local increment = 2 * math.pi * state.frequency / daw.getDevice().getSampleRate()

        state.value = state.value + increment

        if state.value >= 2 * math.pi then
            state.value = state.value - 2 * math.pi
        end
    end
end

function plugin.draw(rect, state)
    state.frequency = ui.knob(10, 10, state.frequency, {
        suffix = " Hz",
        min = 10.0,
        max = 1000.0,
        defaultValue = 440.0,
    })
end

return plugin
```

Most of the UI has been implemented with immediete-mode in mind, meaning states are directly handled by the widget itself, [ui.knob()](ui.md#uiknob) directly returns the value (even if the user isnt interacting with the knob)

---

### Threaded state access

[plugin.process()](#pluginprocessstate-buffer) and [plugin.draw()](#plugindrawrect-state) may execute concurrently on the same `state` table. 

Shared state uses a `last-writer-wins` semantics. If multiple callbacks write the same state value concurrently, the value from the most recent write is retained.


### `plugin.draw(rect, state)`

Draws the plugin's UI.

[Rect](types/Rect.md) is the total rectangle allocated to the plugin.

For more information on how to draw UI elements, see the [UI](UI.md) documentation.

### `name : string`

Defines the name of the plugin.

```lua
plugin.name = "myplugin"
```

### `plugin.startup()`

Called when the plugin is loaded,

It must return a table containing the plugin's initial state values. This table is passed to [plugin.process()](#pluginprocessstate-buffer) and [plugin.draw()](#plugindrawrect-state) as the `state` argument. Plugins should modify the existing state rather than returing or replacing it.

### `plugin.process(state, buffer)`

Processes the audio data in the buffer.

---

> **Important: `plugin.process()` does not run the garbage collector.**
>
> Memory allocated during `plugin.process()` will not be automatically garbage collected. Plugins should avoid creating tables, strings, or other objects while processing audio. Allocating memory repeatedly may cause the plugin or DAW to eventually run out of memory.
>
> The `state` table should be used to store persistent plugin state rather than creating new objects during processing.
>
> The garbage collector is available when `plugin.draw()` is called, so normal Lua allocations are allowed in UI code.
>
> In the future, allocations during `plugin.process()` will be detected automatically and the plugin will be stopped before it is loaded. For now, **here be dragons.**


```lua
function plugin.process(state, buffer)

    -- is not ok! and will cause memory usage to grow.
    local data = {}
    local str = "hello!"
    state.data_table = {}
    state.str = "hi!"

    -- is ok!
    local x = 4.2
    local y = 10
    local answer = x * y
    local buffer_value = buffer:get(1, 1)
    state.data = state.data + answer
    buffer:set(1, 1, state.data + 4.5)

end
```

Presistent tables and buffers should be allcated during startup()
and stored in state. They can then be reused by process() without
allocating new memory.

For example:

```lua
local buffer = table.create(16384, 0) -- allocates a new table with 16k values, all initialized to 0.

buffer[17000] = 42 -- allocates a new position at 17000. which wouldnt be ok in plugin.process()

buffer[1000] = 0.5 -- doesnt allocate and rather changes the already existing value.
```

---


`buffer` contains interleaved floating-point samples. Samples are stored consecutively by channel for each frame.

For example, a stereo buffer is laid out as:

```lua
buffer[1] -- left, frame 1
buffer[2] -- right, frame 1
buffer[3] -- left, frame 2
buffer[4] -- right, frame 2
```
A mono buffer is laid out as:

```lua
buffer[1] -- frame 1
buffer[2] -- frame 2
buffer[3] -- frame 3
```
`buffer.frames` contains the number of frames in the buffer, and `buffer.channels` contains the number of channels.

The buffer uses 1-based indexing, as is standard for Lua.

Plugins should iterate over the buffer using:

```lua
for i = 1, buffer.frames * buffer.channels do
    -- process buffer[i]
end
```
`buffer[i]` represents a single audio sample.

You may also access the buffer via `:set` and `:get`, as shown:

```lua
-- may produce an error if frame or channel isnt a valid index, i.e frame > buffer.frames or channel > buffer.channel
buffer:set(frame, channel, value)

buffer:get(frame, channel)
```

These helpers perform no memory allocation and are safe to use during [plugin.process()](#pluginprocessstate-buffer).