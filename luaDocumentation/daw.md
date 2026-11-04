## `daw`

`daw` is a global table that provides read-only access to information about the current device and project, as well as functions for converting values

### `daw.dBtoLinear(dB)`

Converts a decibel value to a linear value.
This is calculated as `10 ^ (dB / 20)`.

```lua
local linear = daw.dBtoLinear(-6) -- linear = 0.5
```

### `daw.linearTodB(linear)`

Converts a linear value to a decibel value.
This is calculated as `20 * log10(linear)`

```lua
local dB = daw.linearTodB(0.5) -- dB = -6
```

### `daw.bpm()`

Returns the current project's BPM (beats per minute).

This value is read-only. Plugins cannot change the project's BPM.

```lua
local bpm = daw.bpm()
```

### `daw.getDevice()`

Returns information about the current [Device](device.md) in use.

Note: for providing audio data into the device, look at [plugin.process()](plugin.md#pluginprocessstate-buffer) 

```lua
local device = daw.getDevice()
local sampleRate = device.getSampleRate() -- 44100 hz (devices may differ)
```