dimgui - imgui wrapper for D

Currently supports imgui version 1.62

Possible reasons to use this instead of derelictimgui/cimgui:
- Slightly more performant - no indirection for most common function calls
- Supports D namespacing; every common imgui call is prefixed with ImGui.*
Allows conveniently to use "with(ImGui)" when writing masses of calls
- Allows (in fact, only supports) static linking of imgui into your executable

Usage:
- Include dimgui.d into your build
- Link against imgui v1.62
