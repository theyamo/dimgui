dimgui - imgui wrapper for D

Currently supports imgui version 1.49

Possible reasons to use this instead of derelictimgui/cimgui:
- Slightly more performant - no indirection for most common function calls
- Supports D namespacing; every common imgui call is prefixed with ImGui.*
Allows conveniently to use "with(ImGui)" when writing masses of calls
- Allows (in fact, only supports) static linking of imgui into your executable

Some less used functions (such as draw list and font handling) are based
on cimgui wrapper.

Usage:
- Include dimgui.d, imgui_drawlist.cpp, imgui_extra.cpp into your build
- clone imgui v1.49 into imgui/imgui directory (or elsewhere, but you need
to change .cpp #include/s to match)
- remember to link stdc++ into your D project

My suggestion is to build imgui library, imgui_drawlist.cpp and imgui_extra.cpp
into a library in a separate compilation and link it to the project. Example
makefile is included for this. The program can then import dimgui and use
the functions as you want.
