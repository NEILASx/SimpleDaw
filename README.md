# SimpleDaw

A native Windows digital audio workstation, built from the ground up in C++ with WASAPI, Direct2D and the Win32 API.

> **Status:** SimpleDaw is currently published as releases only. Source code is not yet available and will be decided on later. See [LICENSE](LICENSE) for the terms that apply to the releases.

## Download

Grab the latest build from the [Releases](../../releases) page.

**Requirements**

- Windows 10 or later (64-bit)
- A WASAPI-compatible audio device

## Contributing

Pull requests are only accepted for **documentation** and **assets** (images, icons, screenshots and similar). The Lua plugin API is not implemented yet, so proposals for new APIs are welcome as documentation pull requests.

Issues are welcome for bug reports about the application itself. Feature requests are not being accepted at this time.

## Controls
 
**Timeline**
 
- `Ctrl + E`: razor tool, cut clips
- Scroll wheel: zoom
- `Ctrl + Scroll wheel`: move the view
- Undo and redo: *(keys to be added)*
**Knobs and sliders**
 
- Double-click: reset to default
- Hold `Shift` while dragging: slower, finer adjustment
- Scroll wheel: very precise adjustment
**Context menus**
 
- Right-click clips, knobs, sliders, or tracks for a context menu
- Right-click items in the inspector panel to change icons or open the file in Explorer
**Effects**
 
- `F`: show or hide the effects panel
- To add an effect, select a clip or track, then drag an effect from the inspector into the effects panel
**Layout**
 
- Drag the edge of the inspector panel to resize it

## Third-party software

see [THIRD-PARTY-LICENSES.txt](THIRD-PARTY-LICENSES.txt) for a detailed list of all third party licenses SimpleDaw uses.

## License

Copyright © NEILASc. Released under a custom copyleft license. See [LICENSE](LICENSE) for full terms.

Works created with SimpleDaw (audio, projects, presets and so on) are not covered by the license and belong to their creators.
