# dimgui

**dimgui** - [`imgui`](https://github.com/ocornut/imgui) wrapper for D

**Note**: Currently supports `imgui` version 1.49

##

Possible reasons to use this instead of `derelictimgui/cimgui`:
- Slightly more performant - no indirection for most common function calls
- Supports D namespacing; every common `imgui` call is prefixed with `ImGui.*`
Allows conveniently to use `with(ImGui)` when writing masses of calls
- Allows (in fact, only supports) static linking of `imgui` into your executable

Some less used functions (such as draw list and font handling) are based
on `cimgui` wrapper.

##

### Usage
- Clone repo where do you like it to be.
- In dependence list of your project, add `dimgui` and path to it:
```JSON
"dependencies": {
    "dimgui": {
        "path": "$DIMGUI_PATH"
    }
}
```
Now to use it in a code just add `import dimgui;` and you ready to go.
