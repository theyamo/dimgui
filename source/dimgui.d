module dimgui;

import core.stdc.stdarg:va_list;

const ImVec2 Vec2_0_0 = ImVec2(0,0);
const ImVec2 Vec2_1_1 = ImVec2(1,1);
const ImVec4 Vec4_0_0_0_0 = ImVec4(0,0,0,0);
const ImVec4 Vec4_1_1_1_1 = ImVec4(1,1,1,1);

enum
{
    ImGuiKey_Tab,       // for tabbing through fields
    ImGuiKey_LeftArrow, // for text edit
    ImGuiKey_RightArrow,// for text edit
    ImGuiKey_UpArrow,   // for text edit
    ImGuiKey_DownArrow, // for text edit
    ImGuiKey_PageUp,
    ImGuiKey_PageDown,
    ImGuiKey_Home,      // for text edit
    ImGuiKey_End,       // for text edit
    ImGuiKey_Delete,    // for text edit
    ImGuiKey_Backspace, // for text edit
    ImGuiKey_Enter,     // for text edit
    ImGuiKey_Escape,    // for text edit
    ImGuiKey_A,         // for text edit CTRL+A: select all
    ImGuiKey_C,         // for text edit CTRL+C: copy
    ImGuiKey_V,         // for text edit CTRL+V: paste
    ImGuiKey_X,         // for text edit CTRL+X: cut
    ImGuiKey_Y,         // for text edit CTRL+Y: redo
    ImGuiKey_Z,         // for text edit CTRL+Z: undo
    ImGuiKey_COUNT
};

enum
{
    // Default: 0
    ImGuiWindowFlags_NoTitleBar             = 1 << 0,   // Disable title-bar
    ImGuiWindowFlags_NoResize               = 1 << 1,   // Disable user resizing with the lower-right grip
    ImGuiWindowFlags_NoMove                 = 1 << 2,   // Disable user moving the window
    ImGuiWindowFlags_NoScrollbar            = 1 << 3,   // Disable scrollbar (window can still scroll with mouse or programatically)
    ImGuiWindowFlags_NoScrollWithMouse      = 1 << 4,   // Disable user scrolling with mouse wheel
    ImGuiWindowFlags_NoCollapse             = 1 << 5,   // Disable user collapsing window by double-clicking on it
    ImGuiWindowFlags_AlwaysAutoResize       = 1 << 6,   // Resize every window to its content every frame
    ImGuiWindowFlags_ShowBorders            = 1 << 7,   // Show borders around windows and items
    ImGuiWindowFlags_NoSavedSettings        = 1 << 8,   // Never load/save settings in .ini file
    ImGuiWindowFlags_NoInputs               = 1 << 9,   // Disable catching mouse or keyboard inputs
    ImGuiWindowFlags_MenuBar                = 1 << 10,   // Has a menubar
    ImGuiWindowFlags_HorizontalScrollbar    = 1 << 11,  // Enable horizontal scrollbar (off by default). You need to use SetNextWindowContentSize(ImVec2(width,0.0f)); prior to calling Begin() to specify width. Read code in imgui_demo in the "Horizontal Scrolling" section.
    ImGuiWindowFlags_NoFocusOnAppearing     = 1 << 12,  // Disable taking focus when transitioning from hidden to visible state
    ImGuiWindowFlags_NoBringToFrontOnFocus  = 1 << 13,  // Disable bringing window to front when taking focus (e.g. clicking on it or programatically giving it focus)
    // [Internal]
    ImGuiWindowFlags_ChildWindow            = 1 << 20,  // Don't use! For internal use by BeginChild()
    ImGuiWindowFlags_ChildWindowAutoFitX    = 1 << 21,  // Don't use! For internal use by BeginChild()
    ImGuiWindowFlags_ChildWindowAutoFitY    = 1 << 22,  // Don't use! For internal use by BeginChild()
    ImGuiWindowFlags_ComboBox               = 1 << 23,  // Don't use! For internal use by ComboBox()
    ImGuiWindowFlags_Tooltip                = 1 << 24,  // Don't use! For internal use by BeginTooltip()
    ImGuiWindowFlags_Popup                  = 1 << 25,  // Don't use! For internal use by BeginPopup()
    ImGuiWindowFlags_Modal                  = 1 << 26,  // Don't use! For internal use by BeginPopupModal()
    ImGuiWindowFlags_ChildMenu              = 1 << 27   // Don't use! For internal use by BeginMenu()
}

enum
{
    // Default: 0
    ImGuiInputTextFlags_CharsDecimal        = 1 << 0,   // Allow 0123456789.+-*/
    ImGuiInputTextFlags_CharsHexadecimal    = 1 << 1,   // Allow 0123456789ABCDEFabcdef
    ImGuiInputTextFlags_CharsUppercase      = 1 << 2,   // Turn a..z into A..Z
    ImGuiInputTextFlags_CharsNoBlank        = 1 << 3,   // Filter out spaces, tabs
    ImGuiInputTextFlags_AutoSelectAll       = 1 << 4,   // Select entire text when first taking mouse focus
    ImGuiInputTextFlags_EnterReturnsTrue    = 1 << 5,   // Return 'true' when Enter is pressed (as opposed to when the value was modified)
    ImGuiInputTextFlags_CallbackCompletion  = 1 << 6,   // Call user function on pressing TAB (for completion handling)
    ImGuiInputTextFlags_CallbackHistory     = 1 << 7,   // Call user function on pressing Up/Down arrows (for history handling)
    ImGuiInputTextFlags_CallbackAlways      = 1 << 8,   // Call user function every time
    ImGuiInputTextFlags_CallbackCharFilter  = 1 << 9,   // Call user function to filter character. Modify data->EventChar to replace/filter input, or return 1 to discard character.
    ImGuiInputTextFlags_AllowTabInput       = 1 << 10,  // Pressing TAB input a '\t' character into the text field
    ImGuiInputTextFlags_CtrlEnterForNewLine = 1 << 11,  // In multi-line mode, allow exiting edition by pressing Enter. Ctrl+Enter to add new line (by default adds new lines with Enter).
    ImGuiInputTextFlags_NoHorizontalScroll  = 1 << 12,  // Disable following the cursor horizontally
    ImGuiInputTextFlags_AlwaysInsertMode    = 1 << 13,  // Insert mode
    ImGuiInputTextFlags_ReadOnly            = 1 << 14,  // Read-only mode
    ImGuiInputTextFlags_Password            = 1 << 15,  // Password mode, display all characters as '*'
    // [Internal]
    ImGuiInputTextFlags_Multiline           = 1 << 20   // For internal use by InputTextMultiline()
}

enum
{
    // Default: 0
    ImGuiSelectableFlags_DontClosePopups    = 1 << 0,   // Clicking this don't close parent popup window
    ImGuiSelectableFlags_SpanAllColumns     = 1 << 1,    // Selectable frame can span all columns (text will still fit in current column)
    ImGuiSelectableFlags_AllowDoubleClick   = 1 << 2    // Generate press events on double clicks too
}

enum
{
    ImGuiSetCond_Always        = 1 << 0, // Set the variable
    ImGuiSetCond_Once          = 1 << 1, // Only set the variable on the first call per runtime session
    ImGuiSetCond_FirstUseEver  = 1 << 2, // Only set the variable if the window doesn't exist in the .ini file
    ImGuiSetCond_Appearing     = 1 << 3  // Only set the variable if the window is appearing after being inactive (or the first time)
}

enum
{
    ImGuiCol_Text,
    ImGuiCol_TextDisabled,
    ImGuiCol_WindowBg,
    ImGuiCol_ChildWindowBg,
    ImGuiCol_PopupBg,
    ImGuiCol_Border,
    ImGuiCol_BorderShadow,
    ImGuiCol_FrameBg,               // Background of checkbox, radio button, plot, slider, text input
    ImGuiCol_FrameBgHovered,
    ImGuiCol_FrameBgActive,
    ImGuiCol_TitleBg,
    ImGuiCol_TitleBgCollapsed,
    ImGuiCol_TitleBgActive,
    ImGuiCol_MenuBarBg,
    ImGuiCol_ScrollbarBg,
    ImGuiCol_ScrollbarGrab,
    ImGuiCol_ScrollbarGrabHovered,
    ImGuiCol_ScrollbarGrabActive,
    ImGuiCol_ComboBg,
    ImGuiCol_CheckMark,
    ImGuiCol_SliderGrab,
    ImGuiCol_SliderGrabActive,
    ImGuiCol_Button,
    ImGuiCol_ButtonHovered,
    ImGuiCol_ButtonActive,
    ImGuiCol_Header,
    ImGuiCol_HeaderHovered,
    ImGuiCol_HeaderActive,
    ImGuiCol_Column,
    ImGuiCol_ColumnHovered,
    ImGuiCol_ColumnActive,
    ImGuiCol_ResizeGrip,
    ImGuiCol_ResizeGripHovered,
    ImGuiCol_ResizeGripActive,
    ImGuiCol_CloseButton,
    ImGuiCol_CloseButtonHovered,
    ImGuiCol_CloseButtonActive,
    ImGuiCol_PlotLines,
    ImGuiCol_PlotLinesHovered,
    ImGuiCol_PlotHistogram,
    ImGuiCol_PlotHistogramHovered,
    ImGuiCol_TextSelectedBg,
    ImGuiCol_ModalWindowDarkening,  // darken entire screen when a modal window is active
    ImGuiCol_COUNT
}

enum
{
    ImGuiStyleVar_Alpha,               // float
    ImGuiStyleVar_WindowPadding,       // ImVec2
    ImGuiStyleVar_WindowRounding,      // float
    ImGuiStyleVar_WindowMinSize,       // ImVec2
    ImGuiStyleVar_ChildWindowRounding, // float
    ImGuiStyleVar_FramePadding,        // ImVec2
    ImGuiStyleVar_FrameRounding,       // float
    ImGuiStyleVar_ItemSpacing,         // ImVec2
    ImGuiStyleVar_ItemInnerSpacing,    // ImVec2
    ImGuiStyleVar_IndentSpacing,       // float
    ImGuiStyleVar_GrabMinSize          // float
}

enum
{
    ImGuiAlign_Left     = 1 << 0,
    ImGuiAlign_Center   = 1 << 1,
    ImGuiAlign_Right    = 1 << 2,
    ImGuiAlign_Top      = 1 << 3,
    ImGuiAlign_VCenter  = 1 << 4,
    ImGuiAlign_Default  = ImGuiAlign_Left | ImGuiAlign_Top,
}

enum
{
    ImGuiColorEditMode_UserSelect = -2,
    ImGuiColorEditMode_UserSelectShowButton = -1,
    ImGuiColorEditMode_RGB = 0,
    ImGuiColorEditMode_HSV = 1,
    ImGuiColorEditMode_HEX = 2
}

enum
{
    ImGuiMouseCursor_Arrow = 0,
    ImGuiMouseCursor_TextInput,         // When hovering over InputText, etc.
    ImGuiMouseCursor_Move,              // Unused
    ImGuiMouseCursor_ResizeNS,          // Unused
    ImGuiMouseCursor_ResizeEW,          // When hovering over a column
    ImGuiMouseCursor_ResizeNESW,        // Unused
    ImGuiMouseCursor_ResizeNWSE,        // When hovering over the bottom-right corner of a window
    ImGuiMouseCursor_Count_
}

enum
{
    ImGuiTreeNodeFlags_Selected             = 1 << 0,   // Draw as selected
    ImGuiTreeNodeFlags_Framed               = 1 << 1,   // Full colored frame (e.g. for CollapsingHeader)
    ImGuiTreeNodeFlags_AllowOverlapMode     = 1 << 2,   // Hit testing to allow subsequent widgets to overlap this one
    ImGuiTreeNodeFlags_NoTreePushOnOpen     = 1 << 3,   // Don't do a TreePush() when open (e.g. for CollapsingHeader) = no extra indent nor pushing on ID stack
    ImGuiTreeNodeFlags_NoAutoOpenOnLog      = 1 << 4,   // Don't automatically and temporarily open node when Logging is active (by default logging will automatically open tree nodes)
    ImGuiTreeNodeFlags_DefaultOpen          = 1 << 5,   // Default node to be open
    ImGuiTreeNodeFlags_OpenOnDoubleClick    = 1 << 6,   // Need double-click to open node
    ImGuiTreeNodeFlags_OpenOnArrow          = 1 << 7,   // Only open when clicking on the arrow part. If ImGuiTreeNodeFlags_OpenOnDoubleClick is also set, single-click arrow or double-click all box to open.
    ImGuiTreeNodeFlags_Leaf                 = 1 << 8,   // No collapsing, no arrow (use as a convenience for leaf nodes).
    ImGuiTreeNodeFlags_Bullet               = 1 << 9,   // Display a bullet instead of arrow
    //ImGuITreeNodeFlags_SpanAllAvailWidth  = 1 << 10,  // FIXME: TODO: Extend hit box horizontally even if not framed
    //ImGuiTreeNodeFlags_NoScrollOnOpen     = 1 << 11,  // FIXME: TODO: Disable automatic scroll on TreePop() if node got just open and contents is not visible
    ImGuiTreeNodeFlags_CollapsingHeader     = ImGuiTreeNodeFlags_Framed | ImGuiTreeNodeFlags_NoAutoOpenOnLog
};

align(1) struct ImVec2
{
    float x=0;
    float y=0;
}

align(1) struct ImVec4
{
    float x=0;
    float y=0;
    float z=0;
    float w=0;
}

struct ImFont{}
struct ImFontAtlas{}
struct ImDrawList{}
struct ImGuiStorage{}

alias uint ImU32;
alias ushort ImWchar;     // character for display
alias void* ImTextureID;          // user data to refer to a texture (e.g. store your texture handle/id)
alias ImU32 ImGuiID;              // unique ID used by widgets (typically hashed from a stack of string)
alias int ImGuiCol;               // enum ImGuiCol_
alias int ImGuiStyleVar;          // enum ImGuiStyleVar_
alias int ImGuiKey;               // enum ImGuiKey_
alias int ImGuiAlign;             // enum ImGuiAlign_
alias int ImGuiColorEditMode;     // enum ImGuiColorEditMode_
alias int ImGuiMouseCursor;       // enum ImGuiMouseCursor_
alias int ImGuiWindowFlags;       // enum ImGuiWindowFlags_
alias int ImGuiSetCond;           // enum ImGuiSetCond_
alias int ImGuiInputTextFlags;    // enum ImGuiInputTextFlags_
alias int ImGuiSelectableFlags;   // enum ImGuiSelectableFlags_
alias int ImGuiTreeNodeFlags;
alias int function(ImGuiTextEditCallbackData *data) ImGuiTextEditCallback;

extern(C) nothrow {
    alias RenderDrawListFunc = void function(ImDrawData* data);
    alias GetClipboardTextFunc = const(char)* function();
    alias SetClipboardTextFunc = void function(const(char)*);
    alias MemAllocFunc = void* function(size_t);
    alias MemFreeFunc = void function(void*);
    alias ImeSetInputScreenPosFunc = void function(int,int);
}

extern(C++) nothrow @nogc {
    int ImDrawList_GetVertexBufferSize(ImDrawList* list);
    ImDrawVert* ImDrawList_GetVertexPtr(ImDrawList* list, int n);
    int ImDrawList_GetIndexBufferSize(ImDrawList* list);
    ImDrawIdx* ImDrawList_GetIndexPtr(ImDrawList* list, int n);
    int ImDrawList_GetCmdSize(ImDrawList* list);
    ImDrawCmd* ImDrawList_GetCmdPtr(ImDrawList* list, int n);
    void ImDrawData_DeIndexAllBuffers(ImDrawData* drawData);
    ImDrawList* ImDrawList_Create();
    void ImDrawList_Clear(ImDrawList* list);
    void ImDrawList_ClearFreeMemory(ImDrawList* list);
    void ImDrawList_PushClipRect(ImDrawList* list, const ImVec4 clip_rect);
    void ImDrawList_PushClipRectFullScreen(ImDrawList* list);
    void ImDrawList_PopClipRect(ImDrawList* list);
    void ImDrawList_PushTextureID(ImDrawList* list, const ImTextureID texture_id);
    void ImDrawList_PopTextureID(ImDrawList* list);
    void ImDrawList_AddLine(ImDrawList* list, const ImVec2 a, const ImVec2 b, ImU32 col, float thickness);
    void ImDrawList_AddRect(ImDrawList* list, const ImVec2 a, const ImVec2 b, ImU32 col, float rounding, int rounding_corners, float thickness);
    void ImDrawList_AddRectFilled(ImDrawList* list, const ImVec2 a, const ImVec2 b, ImU32 col, float rounding, int rounding_corners);
    void ImDrawList_AddRectFilledMultiColor(ImDrawList* list, const ImVec2 a, const ImVec2 b, ImU32 col_upr_left, ImU32 col_upr_right, ImU32 col_bot_right, ImU32 col_bot_left);
    void ImDrawList_AddTriangle(ImDrawList* list, const ImVec2 a, const ImVec2 b, const ImVec2 c, ImU32 col, float thickness);
    void ImDrawList_AddTriangleFilled(ImDrawList* list, const ImVec2 a, const ImVec2 b, const ImVec2 c, ImU32 col);
    void ImDrawList_AddCircle(ImDrawList* list, const ImVec2 centre, float radius, ImU32 col, int num_segments, float thickness);
    void ImDrawList_AddCircleFilled(ImDrawList* list, const ImVec2 centre, float radius, ImU32 col, int num_segments);
    void ImDrawList_AddText(ImDrawList* list, const ImVec2 pos, ImU32 col, const char* text_begin, const char* text_end);
    void ImDrawList_AddTextExt(ImDrawList* list, const ImFont* font, float font_size, const ImVec2 pos, ImU32 col, const char* text_begin, const char* text_end, float wrap_width, const ImVec4* cpu_fine_clip_rect);
    void ImDrawList_AddImage(ImDrawList* list, ImTextureID user_texture_id, const ImVec2 a, const ImVec2 b, const ImVec2 uv0, const ImVec2 uv1, ImU32 col);
    void ImDrawList_AddPolyline(ImDrawList* list, const ImVec2* points, const int num_points, ImU32 col, bool closed, float thickness, bool anti_aliased);
    void ImDrawList_AddConvexPolyFilled(ImDrawList* list, const ImVec2* points, const int num_points, ImU32 col, bool anti_aliased);
    void ImDrawList_AddBezierCurve(ImDrawList* list, const ImVec2 pos0, const ImVec2 cp0, const ImVec2 cp1, const ImVec2 pos1, ImU32 col, float thickness, int num_segments);
    void ImDrawList_PathClear(ImDrawList* list);
    void ImDrawList_PathLineTo(ImDrawList* list, const ImVec2 pos);
    void ImDrawList_PathLineToMergeDuplicate(ImDrawList* list, const ImVec2 pos);
    void ImDrawList_PathFill(ImDrawList* list, ImU32 col);
    void ImDrawList_PathStroke(ImDrawList* list, ImU32 col, bool closed, float thickness);
    void ImDrawList_PathArcTo(ImDrawList* list, const ImVec2 centre, float radius, float a_min, float a_max, int num_segments);
    void ImDrawList_PathArcToFast(ImDrawList* list, const ImVec2 centre, float radius, int a_min_of_12, int a_max_of_12);
    void ImDrawList_PathBezierCurveTo(ImDrawList* list, const ImVec2 p1, const ImVec2 p2, const ImVec2 p3, int num_segments);
    void ImDrawList_PathRect(ImDrawList* list, const ImVec2 rect_min, const ImVec2 rect_max, float rounding, int rounding_corners);
    void ImDrawList_ChannelsSplit(ImDrawList* list, int channels_count);
    void ImDrawList_ChannelsMerge(ImDrawList* list);
    void ImDrawList_ChannelsSetCurrent(ImDrawList* list, int channel_index);
    void ImDrawList_AddCallback(ImDrawList* list, ImDrawCallback callback, void* callback_data);
    void ImDrawList_AddDrawCmd(ImDrawList* list);
    void ImDrawList_PrimReserve(ImDrawList* list, int idx_count, int vtx_count);
    void ImDrawList_PrimRect(ImDrawList* list, const ImVec2 a, const ImVec2 b, ImU32 col);
    void ImDrawList_PrimRectUV(ImDrawList* list, const ImVec2 a, const ImVec2 b, const ImVec2 uv_a, const ImVec2 uv_b, ImU32 col);
    void ImDrawList_PrimQuadUV(ImDrawList* list,const ImVec2 a, const ImVec2 b, const ImVec2 c, const ImVec2 d, const ImVec2 uv_a, const ImVec2 uv_b, const ImVec2 uv_c, const ImVec2 uv_d, ImU32 col);
    void ImDrawList_PrimVtx(ImDrawList* list, const ImVec2 pos, const ImVec2 uv, ImU32 col);
    void ImDrawList_PrimWriteVtx(ImDrawList* list, const ImVec2 pos, const ImVec2 uv, ImU32 col);
    void ImDrawList_PrimWriteIdx(ImDrawList* list, ImDrawIdx idx);
    void ImDrawList_UpdateClipRect(ImDrawList* list);
    void ImDrawList_UpdateTextureID(ImDrawList* list);

    void ImGuiIO_AddInputCharacter(ushort c);
    void ImGuiIO_AddInputCharactersUTF8(const char* utf8_chars);
    void ImGuiIO_ClearInputCharacters();
    void ImFontConfig_DefaultConstructor(ImFontConfig* config);
    void ImFontAtlas_GetTexDataAsRGBA32(ImFontAtlas* atlas, ubyte** out_pixels, int* out_width, int* out_height, int* out_bytes_per_pixel);
    void ImFontAtlas_GetTexDataAsAlpha8(ImFontAtlas* atlas, ubyte** out_pixels, int* out_width, int* out_height, int* out_bytes_per_pixel);
    void ImFontAtlas_SetTexID(ImFontAtlas* atlas, void* tex);
    ImFont* ImFontAtlas_AddFont(ImFontAtlas* atlas, const ImFontConfig* font_cfg);
    ImFont* ImFontAtlas_AddFontDefault(ImFontAtlas* atlas, const ImFontConfig* font_cfg);
    ImFont* ImFontAtlas_AddFontFromFileTTF(ImFontAtlas* atlas,const char* filename, float size_pixels, const ImFontConfig* font_cfg, const ImWchar* glyph_ranges);
    ImFont* ImFontAtlas_AddFontFromMemoryTTF(ImFontAtlas* atlas, void* ttf_data, int ttf_size, float size_pixels, const ImFontConfig* font_cfg, const ImWchar* glyph_ranges);
    ImFont* ImFontAtlas_AddFontFromMemoryCompressedTTF(ImFontAtlas* atlas, const void* compressed_ttf_data, int compressed_ttf_size, float size_pixels, const ImFontConfig* font_cfg, const ImWchar* glyph_ranges);
    ImFont* ImFontAtlas_AddFontFromMemoryCompressedBase85TTF(ImFontAtlas* atlas, const char* compressed_ttf_data_base85, float size_pixels, const ImFontConfig* font_cfg, const ImWchar* glyph_ranges);
    void ImFontAtlas_ClearTexData(ImFontAtlas* atlas);
    void ImFontAtlas_Clear(ImFontAtlas* atlas);
}

// Shared state of InputText(), passed to callback when a ImGuiInputTextFlags_Callback* flag is used.
align(1) struct ImGuiTextEditCallbackData
{
    ImGuiInputTextFlags EventFlag;      // One of ImGuiInputTextFlags_Callback* // Read-only
    ImGuiInputTextFlags Flags;          // What user passed to InputText()      // Read-only
    void*               UserData;       // What user passed to InputText()      // Read-only

    // CharFilter event:
    ImWchar             EventChar;      // Character input                      // Read-write (replace character or set to zero)

    // Completion,History,Always events:
    ImGuiKey            EventKey;       // Key pressed (Up/Down/TAB)            // Read-only
    char*               Buf;            // Current text                         // Read-write (pointed data only)
    size_t              BufSize;        //                                      // Read-only
    bool                BufDirty;       // Set if you modify Buf directly       // Write
    int                 CursorPos;      //                                      // Read-write
    int                 SelectionStart; //                                      // Read-write (== to SelectionEnd when no selection)
    int                 SelectionEnd;   //                                      // Read-write

    // NB: calling those function loses selection.
    //void DeleteChars(int pos, int bytes_count);
    //void InsertChars(int pos, const char* text, const char* text_end = NULL);

    bool                HasSelection() const        { return SelectionStart != SelectionEnd; }
};

align(1) struct ImGuiIO
{
    ImVec2        DisplaySize;              // <unset>              // Display size, in pixels. For clamping windows positions.
    float         DeltaTime;                // = 1.0f/60.0f         // Time elapsed since last frame, in seconds.
    float         IniSavingRate;            // = 5.0f               // Maximum time between saving positions/sizes to .ini file, in seconds.
    const char*   IniFilename;              // = "imgui.ini"        // Path to .ini file. NULL to disable .ini saving.
    const char*   LogFilename;              // = "imgui_log.txt"    // Path to .log file (default parameter to ImGui::LogToFile when no file is specified).
    float         MouseDoubleClickTime;     // = 0.30f              // Time for a double-click, in seconds.
    float         MouseDoubleClickMaxDist;  // = 6.0f               // Distance threshold to stay in to validate a double-click, in pixels.
    float         MouseDragThreshold;       // = 6.0f               // Distance threshold before considering we are dragging
    int[ImGuiKey_COUNT]           KeyMap;   // <unset>              // Map of indices into the KeysDown[512] entries array
    float         KeyRepeatDelay;           // = 0.250f             // When holding a key/button, time before it starts repeating, in seconds. (for actions where 'repeat' is active)
    float         KeyRepeatRate;            // = 0.020f             // When holding a key/button, rate at which it repeats, in seconds.
    void*         UserData;                 // = NULL               // Store your own data for retrieval by callbacks.

    ImFontAtlas*  Fonts;                    // <auto>               // Load and assemble one or more fonts into a single tightly packed texture. Output to Fonts array.
    float         FontGlobalScale;          // = 1.0f               // Global scale all fonts
    bool          FontAllowUserScaling;     // = false              // Allow user scaling text of individual window with CTRL+Wheel.
    ImVec2        DisplayFramebufferScale;  // = (1.0f,1.0f)        // For retina display or other situations where window coordinates are different from framebuffer coordinates. User storage only, presently not used by ImGui.
    ImVec2        DisplayVisibleMin;        // <unset> (0.0f,0.0f)  // If you use DisplaySize as a virtual space larger than your screen, set DisplayVisibleMin/Max to the visible area.
    ImVec2        DisplayVisibleMax;        // <unset> (0.0f,0.0f)  // If the values are the same, we defaults to Min=(0.0f) and Max=DisplaySize

    // Advanced/subtle behaviors
    bool          WordMovementUsesAltKey;   // = defined(__APPLE__) // OS X style: Text editing cursor movement using Alt instead of Ctrl
    bool          ShortcutsUseSuperKey;     // = defined(__APPLE__) // OS X style: Shortcuts using Cmd/Super instead of Ctrl
    bool          DoubleClickSelectsWord;   // = defined(__APPLE__) // OS X style: Double click selects by word instead of selecting whole text
    bool          MultiSelectUsesSuperKey;  // = defined(__APPLE__) // OS X style: Multi-selection in lists uses Cmd/Super instead of Ctrl [unused yet]

    //------------------------------------------------------------------
    // User Functions
    //------------------------------------------------------------------

    // REQUIRED: rendering function.
    // See example code if you are unsure of how to implement this.
    RenderDrawListFunc RenderDrawListsFn;

    // Optional: access OS clipboard
    // (default to use native Win32 clipboard on Windows, otherwise uses a private clipboard. Override to access OS clipboard on other architectures)
    GetClipboardTextFunc GetClipboardTextFn;
    SetClipboardTextFunc SetClipboardTextFn;

    // Optional: override memory allocations. MemFreeFn() may be called with a NULL pointer.
    // (default to posix malloc/free)
    MemAllocFunc MemAllocFn;
    MemFreeFunc MemFreeFn;

    // Optional: notify OS Input Method Editor of the screen position of your cursor for text input position (e.g. when using Japanese/Chinese IME in Windows)
    // (default to use native imm32 api on Windows)
    ImeSetInputScreenPosFunc ImeSetInputScreenPosFn;
    void*       ImeWindowHandle;            // (Windows) Set this to your HWND to get automatic IME cursor positioning.

    //------------------------------------------------------------------
    // Input - Fill before calling NewFrame()
    //------------------------------------------------------------------

    ImVec2          MousePos;                   // Mouse position, in pixels (set to -1,-1 if no mouse / on another screen, etc.)
    bool[5]         MouseDown;                  // Mouse buttons. ImGui itself only uses button 0 (left button). Others buttons allows to track if mouse is being used by your application + available to user as a convenience via IsMouse** API.
    float           MouseWheel;                 // Mouse wheel: 1 unit scrolls about 5 lines text.
    bool            MouseDrawCursor;            // Request ImGui to draw a mouse cursor for you (if you are on a platform without a mouse cursor).
    bool            KeyCtrl;                    // Keyboard modifier pressed: Control
    bool            KeyShift;                   // Keyboard modifier pressed: Shift
    bool            KeyAlt;                     // Keyboard modifier pressed: Alt
    bool            KeySuper;                   // Keyboard modifier pressed: Cmd/Super/Windows

    bool[512]       KeysDown;              // Keyboard keys that are pressed (in whatever storage order you naturally have access to keyboard data)
    ImWchar[16+1]   InputCharacters;      // List of characters input (translated by user from keypress+keyboard state). Fill using AddInputCharacter() helper.

    //------------------------------------------------------------------
    // Output - Retrieve after calling NewFrame(), you can use them to discard inputs or hide them from the rest of your application
    //------------------------------------------------------------------

    bool        WantCaptureMouse;           // Mouse is hovering a window or widget is active (= ImGui will use your mouse input)
    bool        WantCaptureKeyboard;        // Widget is active (= ImGui will use your keyboard input)
    bool        WantTextInput;              // Some text input widget is active, which will read input characters from the InputCharacters array.
    float       Framerate;                  // Framerate estimation, in frame per second. Rolling average estimation based on IO.DeltaTime over 120 frames
    int         MetricsAllocs;              // Number of active memory allocations
    int         MetricsRenderVertices;      // Vertices processed during last call to Render()
    int         MetricsRenderIndices;       //
    int         MetricsActiveWindows;       // Number of visible windows (exclude child windows)

    //------------------------------------------------------------------
    // [Internal] ImGui will maintain those fields for you
    //------------------------------------------------------------------

    ImVec2      MousePosPrev;               // Previous mouse position
    ImVec2      MouseDelta;                 // Mouse delta. Note that this is zero if either current or previous position are negative to allow mouse enabling/disabling.
    bool[5]     MouseClicked;            // Mouse button went from !Down to Down
    ImVec2[5]   MouseClickedPos;         // Position at time of clicking
    float[5]    MouseClickedTime;        // Time of last click (used to figure out double-click)
    bool[5]     MouseDoubleClicked;      // Has mouse button been double-clicked?
    bool[5]     MouseReleased;           // Mouse button went from Down to !Down
    bool[5]     MouseDownOwned;          // Track if button was clicked inside a window. We don't request mouse capture from the application if click started outside ImGui bounds.
    float[5]    MouseDownDuration;       // Duration the mouse button has been down (0.0f == just clicked)
    float[5]    MouseDownDurationPrev;   // Previous time the mouse button has been down
    float[5]    MouseDragMaxDistanceSqr; // Squared maximum distance of how much mouse has traveled from the click point
    float[512]  KeysDownDuration;      // Duration the keyboard key has been down (0.0f == just pressed)
    float[512]  KeysDownDurationPrev;  // Previous duration the key has been down
}

align(1) struct ImGuiStyle
{
    float       Alpha;                      // Global alpha applies to everything in ImGui
    ImVec2      WindowPadding;              // Padding within a window
    ImVec2      WindowMinSize;              // Minimum window size
    float       WindowRounding;             // Radius of window corners rounding. Set to 0.0f to have rectangular windows
    ImGuiAlign  WindowTitleAlign;           // Alignment for title bar text
    float       ChildWindowRounding;        // Radius of child window corners rounding. Set to 0.0f to have rectangular windows
    ImVec2      FramePadding;               // Padding within a framed rectangle (used by most widgets)
    float       FrameRounding;              // Radius of frame corners rounding. Set to 0.0f to have rectangular frame (used by most widgets).
    ImVec2      ItemSpacing;                // Horizontal and vertical spacing between widgets/lines
    ImVec2      ItemInnerSpacing;           // Horizontal and vertical spacing between within elements of a composed widget (e.g. a slider and its label)
    ImVec2      TouchExtraPadding;          // Expand reactive bounding box for touch-based system where touch position is not accurate enough. Unfortunately we don't sort widgets so priority on overlap will always be given to the first widget. So don't grow this too much!
    float       IndentSpacing;              // Horizontal indentation when e.g. entering a tree node
    float       ColumnsMinSpacing;          // Minimum horizontal spacing between two columns
    float       ScrollbarSize;             // Width of the vertical scrollbar
    float       ScrollbarRounding;          // Radius of grab corners for scrollbar
    float       GrabMinSize;                // Minimum width/height of a grab box for slider/scrollbar
    float       GrabRounding;               // Radius of grabs corners rounding. Set to 0.0f to have rectangular slider grabs.
    ImVec2      DisplayWindowPadding;       // Window positions are clamped to be visible within the display area by at least this amount. Only covers regular windows.
    ImVec2      DisplaySafeAreaPadding;     // If you cannot see the edge of your screen (e.g. on a TV) increase the safe area padding. Covers popups/tooltips as well regular windows.
    bool        AntiAliasedLines;           // Enable anti-aliasing on lines/borders. Disable if you are really tight on CPU/GPU.
    bool        AntiAliasedShapes;          // Enable anti-aliasing on filled shapes (rounded rectangles, circles, etc.)
    float       CurveTessellationTol;       // Tessellation tolerance. Decrease for highly tessellated curves (higher quality, more polygons), increase to reduce quality.
    ImVec4[ImGuiCol_COUNT]      Colors;
};

align(1) struct ImDrawVert
{
    ImVec2  pos;
    ImVec2  uv;
    ImU32   col;
};

alias ImDrawCallback = void function(const ImDrawList* parent_list, const ImDrawCmd* cmd) nothrow;

align(1) struct ImDrawCmd
{
    uint            ElemCount;              // Number of indices (multiple of 3) to be rendered as triangles. Vertices are stored in the callee ImDrawList's vtx_buffer[] array, indices in idx_buffer[].
    ImVec4          ClipRect;               // Clipping rectangle (x1, y1, x2, y2)
    ImTextureID     TextureId;              // User-provided texture ID. Set by user in ImfontAtlas::SetTexID() for fonts or passed to Image*() functions. Ignore if never using images or multiple fonts atlas.
    ImDrawCallback  UserCallback;           // If != NULL, call the function instead of rendering the vertices. clip_rect and texture_id will be set normally.
    void*           UserCallbackData;       // The draw callback code can access this.
}

alias ImDrawIdx = ushort;

align(1) struct ImDrawData
{
    bool            Valid;
    ImDrawList**    CmdLists;
    int             CmdListsCount;
    int             TotalVtxCount;          // For convenience, sum of all cmd_lists vtx_buffer.Size
    int             TotalIdxCount;          // For convenience, sum of all cmd_lists idx_buffer.Size
}

align(1) struct ImFontConfig
{
    void*           FontData;
    int             FontDataSize;
    bool            FontDataOwnedByAtlas=true;
    int             FontNo=0;
    float           SizePixels=0.0f;
    int             OversampleH=3, OversampleV=1;
    bool            PixelSnapH=false;
    ImVec2          GlyphExtraSpacing;
    const ImWchar*  GlyphRanges;
    bool            MergeMode=false;
    bool            MergeGlyphCenterV=false;

    // [Internal]
    char[32]        Name;
    ImFont*         DstFont;
}

align(1) struct ImColor
{
    ImU32 value;
    alias value this;

    this(ubyte r, ubyte g, ubyte b, ubyte a = 255)
    {
        value = r | (g<<8) | (b<<16) | (a<<24);
    }

    this(float r, float g, float b, float a = 1.0f)
    {
        static float imSaturate(float f)
        {
            return (f < 0.0f) ? 0.0f : (f > 1.0f) ? 1.0f : f;
        }
        value  = (cast(ImU32)(imSaturate(r)*255));
        value |= (cast(ImU32)(imSaturate(g)*255) << 8);
        value |= (cast(ImU32)(imSaturate(b)*255) << 16);
        value |= (cast(ImU32)(imSaturate(a)*255) << 24);
    }

    ImVec4 asImVec4() @property
    {
        float s = 1.0f/255.0f;
        return ImVec4((value & 0xFF) * s, ((value >> 8) & 0xFF) * s, ((value >> 16) & 0xFF) * s, (value >> 24) * s);
    }

    ImColor HSV(float h, float s, float v, float a = 1.0f)
    {
        //import derelict.imgui.funcs;
        float r,g,b;
        ColorConvertHSVtoRGB(h, s, v, r, g, b);
        //this = ImColor(r,g,b,a);
        return ImColor(r,g,b,a);
    }

}

align(1) struct ImGuiListClipper {
//  import derelict.imgui.funcs : igCalcListClipping, igGetCursorPosY, igSetCursorPosY;

    float itemsHeight = 0f;
    int itemsCount = -1, displayStart = -1, displayEnd = -1;

    this(int count, float height) {
        itemsCount = -1;
        Begin(count, height);
    }

    void Begin(int count, float height) {
        assert(itemsCount == -1);
        itemsCount = count;
        itemsHeight = height;
        ImGui.CalcListClipping(itemsCount, itemsHeight, &displayStart, &displayEnd);
        ImGui.SetCursorPosY(ImGui.GetCursorPosY() + displayStart * itemsHeight);
    }

    void End() {
        assert(itemsCount >= 0);
        ImGui.SetCursorPosY(ImGui.GetCursorPosY() + (itemsCount - displayEnd) * itemsHeight);
        itemsCount = -1;
    }

}

extern(C++, ImGui) nothrow @nogc {
     ImGuiIO*      GetIO();
     ImGuiStyle*   GetStyle();
     ImDrawData*   GetDrawData();                              // same value as passed to your io.RenderDrawListsFn() function. valid after Render() and until the next call to NewFrame()
     void          NewFrame();                                 // start a new ImGui frame, you can submit any command from this point until NewFrame()/Render().
     void          Render();                                   // ends the ImGui frame, finalize rendering data, then call your io.RenderDrawListsFn() function if set.
     void          Shutdown();
     void          ShowUserGuide();                            // help block
     void          ShowStyleEditor(ImGuiStyle* sref = null);    // style editor block
     void          ShowTestWindow(bool* opened = null);        // test window demonstrating ImGui features
     void          ShowMetricsWindow(bool* opened = null);     // metrics window for debugging ImGui

    // Window
     bool          Begin(const char* name, bool* p_opened = null, ImGuiWindowFlags flags = 0);                                                   // push window to the stack and start appending to it. see .cpp for details. return false when window is collapsed, so you can early out in your code. 'bool* p_opened' creates a widget on the upper-right to close the window (which sets your bool to false).
     bool          Begin(const char* name, bool* p_opened, ref const ImVec2 size_on_first_use, float bg_alpha = -1.0f, ImGuiWindowFlags flags = 0); // OBSOLETE. this is the older/longer API. the extra parameters aren't very relevant. call SetNextWindowSize() instead if you want to set a window size. For regular windows, 'size_on_first_use' only applies to the first time EVER the window is created and probably not what you want! might obsolete this API eventually.
     void          End();                                                                                                                        // finish appending to current window, pop it off the window stack.
     bool          BeginChild(const char* str_id, const ref ImVec2 size = Vec2_0_0, bool border = false, ImGuiWindowFlags extra_flags = 0);      // begin a scrolling region. size==0.0f: use remaining window size, size<0.0f: use remaining window size minus abs(size). size>0.0f: fixed size. each axis can use a different mode, e.g. ImVec2(0,400).
     bool          BeginChild(ImGuiID id, const ref ImVec2 size = Vec2_0_0, bool border = false, ImGuiWindowFlags extra_flags = 0);              // "
     void          EndChild();
     ImVec2        GetContentRegionMax();                                              // current content boundaries (typically window boundaries including scrolling, or current column boundaries), in windows coordinates
     ImVec2        GetContentRegionAvail();                                            // == GetContentRegionMax() - GetCursorPos()
     float         GetContentRegionAvailWidth();                                       //
     ImVec2        GetWindowContentRegionMin();                                        // content boundaries min (roughly (0,0)-Scroll), in window coordinates
     ImVec2        GetWindowContentRegionMax();                                        // content boundaries max (roughly (0,0)+Size-Scroll) where Size can be override with SetNextWindowContentSize(), in window coordinates
     float         GetWindowContentRegionWidth();                                      //
     ImDrawList*   GetWindowDrawList();                                                // get rendering command-list if you want to append your own draw primitives
     ImVec2        GetWindowPos();                                                     // get current window position in screen space (useful if you want to do your own drawing via the DrawList api)
     ImVec2        GetWindowSize();                                                    // get current window size
     float         GetWindowWidth();
     float         GetWindowHeight();
     bool          IsWindowCollapsed();
     void          SetWindowFontScale(float scale);                                    // per-window font scale. Adjust IO.FontGlobalScale if you want to scale all windows

     void          SetNextWindowPos(ref const ImVec2 pos, ImGuiSetCond cond = 0);         // set next window position. call before Begin()
     void          SetNextWindowPosCenter(ImGuiSetCond cond = 0);                      // set next window position to be centered on screen. call before Begin()
     void          SetNextWindowSize(ref const ImVec2 size, ImGuiSetCond cond = 0);       // set next window size. set axis to 0.0f to force an auto-fit on this axis. call before Begin()
     void          SetNextWindowContentSize(ref const ImVec2 size);                       // set next window content size (enforce the range of scrollbars). set axis to 0.0f to leave it automatic. call before Begin()
     void          SetNextWindowContentWidth(float width);                             // set next window content width (enforce the range of horizontal scrollbar). call before Begin()
     void          SetNextWindowCollapsed(bool collapsed, ImGuiSetCond cond = 0);      // set next window collapsed state. call before Begin()
     void          SetNextWindowFocus();                                               // set next window to be focused / front-most. call before Begin()
     void          SetWindowPos(ref const ImVec2 pos, ImGuiSetCond cond = 0);             // set current window position - call within Begin()/End(). may incur tearing
     void          SetWindowSize(ref const ImVec2 size, ImGuiSetCond cond = 0);           // set current window size. set to ImVec2(0,0) to force an auto-fit. may incur tearing
     void          SetWindowCollapsed(bool collapsed, ImGuiSetCond cond = 0);          // set current window collapsed state
     void          SetWindowFocus();                                                   // set current window to be focused / front-most
     void          SetWindowPos(const char* name, const ref ImVec2 pos, ImGuiSetCond cond = 0);      // set named window position.
     void          SetWindowSize(const char* name, const ref ImVec2 size, ImGuiSetCond cond = 0);    // set named window size. set axis to 0.0f to force an auto-fit on this axis.
     void          SetWindowCollapsed(const char* name, bool collapsed, ImGuiSetCond cond = 0);   // set named window collapsed state
     void          SetWindowFocus(const char* name);                                              // set named window to be focused / front-most. use null to remove focus.

     float         GetScrollX();                                                       // get scrolling amount [0..GetScrollMaxX()]
     float         GetScrollY();                                                       // get scrolling amount [0..GetScrollMaxY()]
     float         GetScrollMaxX();                                                    // get maximum scrolling amount ~~ ContentSize.X - WindowSize.X
     float         GetScrollMaxY();                                                    // get maximum scrolling amount ~~ ContentSize.Y - WindowSize.Y
     void          SetScrollX(float scroll_x);                                         // set scrolling amount [0..GetScrollMaxX()]
     void          SetScrollY(float scroll_y);                                         // set scrolling amount [0..GetScrollMaxY()]
     void          SetScrollHere(float center_y_ratio = 0.5f);                         // adjust scrolling amount to make current cursor position visible. center_y_ratio=0.0: top, 0.5: center, 1.0: bottom.
     void          SetScrollFromPosY(float pos_y, float center_y_ratio = 0.5f);        // adjust scrolling amount to make given position valid. use GetCursorPos() or GetCursorStartPos()+offset to get valid positions.
     void          SetKeyboardFocusHere(int offset = 0);                               // focus keyboard on the next widget. Use positive 'offset' to access sub components of a multiple component widget
     void          SetStateStorage(ImGuiStorage* tree);                                // replace tree state storage with our own (if you want to manipulate it yourself, typically clear subsection of it)
     ImGuiStorage* GetStateStorage();

    // Parameters stacks (shared)
     void          PushFont(ImFont* font);                                             // use null as a shortcut to push default font
     void          PopFont();
     void          PushStyleColor(ImGuiCol idx, const ref ImVec4 col);
     void          PopStyleColor(int count = 1);
     void          PushStyleVar(ImGuiStyleVar idx, float val);
     void          PushStyleVar(ImGuiStyleVar idx, const ref ImVec2 val);
     void          PopStyleVar(int count = 1);
     ImFont*       GetFont();                                                          // get current font
     float         GetFontSize();                                                      // get current font size (= height in pixels) of current font with current scale applied
     ImVec2        GetFontTexUvWhitePixel();                                           // get UV coordinate for a while pixel, useful to draw custom shapes via the ImDrawList API
     ImU32         GetColorU32(ImGuiCol idx, float alpha_mul = 1.0f);                  // retrieve given style color with style alpha applied and optional extra alpha multiplier
     ImU32         GetColorU32(const ref ImVec4 col);                                     // retrieve given color with style alpha applied

    // Parameters stacks (current window)
     void          PushItemWidth(float item_width);                                    // width of items for the common item+label case, pixels. 0.0f = default to ~2/3 of windows width, >0.0f: width in pixels, <0.0f align xx pixels to the right of window (so -1.0f always align width to the right side)
     void          PopItemWidth();
     float         CalcItemWidth();                                                    // width of item given pushed settings and current cursor position
     void          PushTextWrapPos(float wrap_pos_x = 0.0f);                           // word-wrapping for Text*() commands. < 0.0f: no wrapping; 0.0f: wrap to end of window (or column); > 0.0f: wrap at 'wrap_pos_x' position in window local space
     void          PopTextWrapPos();
     void          PushAllowKeyboardFocus(bool v);                                     // allow focusing using TAB/Shift-TAB, enabled by default but you can disable it for certain widgets
     void          PopAllowKeyboardFocus();
     void          PushButtonRepeat(bool repeat);                                      // in 'repeat' mode, Button*() functions return repeated true in a typematic manner (uses io.KeyRepeatDelay/io.KeyRepeatRate for now). Note that you can call IsItemActive() after any Button() to tell if the button is held in the current frame.
     void          PopButtonRepeat();

    // Cursor / Layout
     void          BeginGroup();                                                       // lock horizontal starting position. once closing a group it is seen as a single item (so you can use IsItemHovered() on a group, SameLine() between groups, etc.
     void          EndGroup();
     void          Separator();                                                        // horizontal line
     void          SameLine(float pos_x = 0.0f, float spacing_w = -1.0f);              // call between widgets or groups to layout them horizontally
     void          Spacing();                                                          // add spacing
     void          Dummy(const ref ImVec2 size);                                          // add a dummy item of given size
     void          Indent();                                                           // move content position toward the right by style.IndentSpacing pixels
     void          Unindent();                                                         // move content position back to the left (cancel Indent)
     ImVec2        GetCursorPos();                                                     // cursor position is relative to window position
     float         GetCursorPosX();                                                    // "
     float         GetCursorPosY();                                                    // "
     void          SetCursorPos(const ref ImVec2 local_pos);                              // "
     void          SetCursorPosX(float x);                                             // "
     void          SetCursorPosY(float y);                                             // "
     ImVec2        GetCursorStartPos();                                                // initial cursor position
     ImVec2        GetCursorScreenPos();                                               // cursor position in absolute screen coordinates [0..io.DisplaySize]
     void          SetCursorScreenPos(const ref ImVec2 pos);                              // cursor position in absolute screen coordinates [0..io.DisplaySize]
     void          AlignFirstTextHeightToWidgets();                                    // call once if the first item on the line is a Text() item and you want to vertically lower it to match subsequent (bigger) widgets
     float         GetTextLineHeight();                                                // height of font == GetWindowFontSize()
     float         GetTextLineHeightWithSpacing();                                     // distance (in pixels) between 2 consecutive lines of text == GetWindowFontSize() + GetStyle().ItemSpacing.y
     float         GetItemsLineHeightWithSpacing();                                    // distance (in pixels) between 2 consecutive lines of standard height widgets == GetWindowFontSize() + GetStyle().FramePadding.y*2 + GetStyle().ItemSpacing.y

    // Columns
    // You can also use SameLine(pos_x) for simplified columning. The columns API is still work-in-progress.
     void          Columns(int count = 1, const char* id = null, bool border = true);  // setup number of columns. use an identifier to distinguish multiple column sets. close with Columns(1).
     void          NextColumn();                                                       // next column
     int           GetColumnIndex();                                                   // get current column index
     float         GetColumnOffset(int column_index = -1);                             // get position of column line (in pixels, from the left side of the contents region). pass -1 to use current column, otherwise 0..GetcolumnsCount() inclusive. column 0 is usually 0.0f and not resizable unless you call this
     void          SetColumnOffset(int column_index, float offset_x);                  // set position of column line (in pixels, from the left side of the contents region). pass -1 to use current column
     float         GetColumnWidth(int column_index = -1);                              // column width (== GetColumnOffset(GetColumnIndex()+1) - GetColumnOffset(GetColumnOffset())
     int           GetColumnsCount();                                                  // number of columns (what was passed to Columns())

    // ID scopes
    // If you are creating widgets in a loop you most likely want to push a unique identifier so ImGui can differentiate them.
    // You can also use the "##foobar" syntax within widget label to distinguish them from each others. Read "A primer on the use of labels/IDs" in the FAQ for more details.
     void          PushID(const char* str_id);                                         // push identifier into the ID stack. IDs are hash of the *entire* stack!
     void          PushID(const char* str_id_begin, const char* str_id_end);
     void          PushID(const void* ptr_id);
     void          PushID(int int_id);
     void          PopID();
     ImGuiID       GetID(const char* str_id);                                          // calculate unique ID (hash of whole ID stack + given parameter). useful if you want to query into ImGuiStorage yourself. otherwise rarely needed
     ImGuiID       GetID(const char* str_id_begin, const char* str_id_end);
     ImGuiID       GetID(const void* ptr_id);

    // Widgets
     void          Text(const char* fmt, ...); // IM_PRINTFARGS(1);
     void          TextV(const char* fmt, va_list args);
     void          TextColored(const ref ImVec4 col, const char* fmt, ...); // IM_PRINTFARGS(2);  // shortcut for PushStyleColor(ImGuiCol_Text, col); Text(fmt, ...); PopStyleColor();
     void          TextColoredV(const ref ImVec4 col, const char* fmt, va_list args);
     void          TextDisabled(const char* fmt, ...); // IM_PRINTFARGS(1);                    // shortcut for PushStyleColor(ImGuiCol_Text, style.Colors[ImGuiCol_TextDisabled]); Text(fmt, ...); PopStyleColor();
     void          TextDisabledV(const char* fmt, va_list args);
     void          TextWrapped(const char* fmt, ...); // IM_PRINTFARGS(1);                     // shortcut for PushTextWrapPos(0.0f); Text(fmt, ...); PopTextWrapPos();. Note that this won't work on an auto-resizing window if there's no other widgets to extend the window width, yoy may need to set a size using SetNextWindowSize().
     void          TextWrappedV(const char* fmt, va_list args);
     void          TextUnformatted(const char* text, const char* text_end = null);         // doesn't require null terminated string if 'text_end' is specified. no copy done to any bounded stack buffer, recommended for long chunks of text
     void          LabelText(const char* label, const char* fmt, ...); // IM_PRINTFARGS(2);    // display text+label aligned the same way as value+label widgets
     void          LabelTextV(const char* label, const char* fmt, va_list args);
     void          Bullet();                                                               // draw a small circle and keep the cursor on the same line. advance you by the same distance as an empty TreeNode() call.
     void          BulletText(const char* fmt, ...); // IM_PRINTFARGS(1);
     void          BulletTextV(const char* fmt, va_list args);
     bool          Button(const char* label, const ref ImVec2 size = Vec2_0_0);
     bool          SmallButton(const char* label);
     bool          InvisibleButton(const char* str_id, const ref ImVec2 size);
     void          Image(ImTextureID user_texture_id, const ref ImVec2 size, const ref ImVec2 uv0 = Vec2_0_0, const ref ImVec2 uv1 = Vec2_1_1, const ref ImVec4 tint_col = Vec4_1_1_1_1, const ref ImVec4 border_col = Vec4_0_0_0_0);
     bool          ImageButton(ImTextureID user_texture_id, const ref ImVec2 size, const ref ImVec2 uv0 = Vec2_0_0,  const ref ImVec2 uv1 = Vec2_1_1, int frame_padding = -1, const ref ImVec4 bg_col = Vec4_0_0_0_0, const ref ImVec4 tint_col = Vec4_1_1_1_1);    // <0 frame_padding uses default frame padding settings. 0 for no padding
     bool          CollapsingHeader(const char* label, ImGuiTreeNodeFlags flags = 0);      // if returning 'true' the header is open. doesn't indent nor push on ID stack. user doesn't have to call TreePop().
     bool          CollapsingHeader(const char* label, bool* p_open, ImGuiTreeNodeFlags flags = 0); // when 'p_open' isn't NULL, display an additional small close button on upper right of the header
     bool          Checkbox(const char* label, bool* v);
     bool          CheckboxFlags(const char* label, uint* flags, uint flags_value);
     bool          RadioButton(const char* label, bool active);
     bool          RadioButton(const char* label, int* v, int v_button);
     bool          Combo(const char* label, int* current_item, const(char)** items, int items_count, int height_in_items = -1);
     bool          Combo(const char* label, int* current_item, const char* items_separated_by_zeros, int height_in_items = -1);      // separate items with \0, end item-list with \0\0
     bool          Combo(const char* label, int* current_item, bool function(void* data, int idx, const char** out_text) items_getter, void* data, int items_count, int height_in_items = -1);
     bool          ColorButton(const ref ImVec4 col, bool small_height = false, bool outline_border = true);
     bool          ColorEdit3(const char* label, float[3] col);
     bool          ColorEdit4(const char* label, float[4] col, bool show_alpha = true);
     void          ColorEditMode(ImGuiColorEditMode mode);                                 // FIXME-OBSOLETE: This is inconsistent with most of the API and should be obsoleted.
     void          PlotLines(const char* label, const float* values, int values_count, int values_offset = 0, const char* overlay_text = null, float scale_min = float.max, float scale_max = float.max, ImVec2 graph_size = ImVec2(0,0), int stride = float.sizeof);
     void          PlotLines(const char* label, float function(void* data, int idx) values_getter, void* data, int values_count, int values_offset = 0, const char* overlay_text = null, float scale_min = float.max, float scale_max = float.max, ImVec2 graph_size = ImVec2(0,0));
     void          PlotHistogram(const char* label, const float* values, int values_count, int values_offset = 0, const char* overlay_text = null, float scale_min = float.max, float scale_max = float.max, ImVec2 graph_size = ImVec2(0,0), int stride = float.sizeof);
     void          PlotHistogram(const char* label, float function(void* data, int idx) values_getter, void* data, int values_count, int values_offset = 0, const char* overlay_text = null, float scale_min = float.max, float scale_max = float.max, ImVec2 graph_size = ImVec2(0,0));
     void          ProgressBar(float fraction, const ImVec2 size_arg = ImVec2(-1,0), const char* overlay = null);

    // Widgets: Drags (tip: ctrl+click on a drag box to input with keyboard. manually input values aren't clamped, can go off-bounds)
     bool          DragFloat(const char* label, float* v, float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const char* display_format = "%.3f", float power = 1.0f);     // If v_min >= v_max we have no bound
     bool          DragFloat2(const char* label, float[2] v, float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const char* display_format = "%.3f", float power = 1.0f);
     bool          DragFloat3(const char* label, float[3] v, float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const char* display_format = "%.3f", float power = 1.0f);
     bool          DragFloat4(const char* label, float[4] v, float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const char* display_format = "%.3f", float power = 1.0f);
     bool          DragFloatRange2(const char* label, float* v_current_min, float* v_current_max, float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const char* display_format = "%.3f", const char* display_format_max = null, float power = 1.0f);
     bool          DragInt(const char* label, int* v, float v_speed = 1.0f, int v_min = 0, int v_max = 0, const char* display_format = "%.0f");                                       // If v_min >= v_max we have no bound
     bool          DragInt2(const char* label, int[2] v, float v_speed = 1.0f, int v_min = 0, int v_max = 0, const char* display_format = "%.0f");
     bool          DragInt3(const char* label, int[3] v, float v_speed = 1.0f, int v_min = 0, int v_max = 0, const char* display_format = "%.0f");
     bool          DragInt4(const char* label, int[4] v, float v_speed = 1.0f, int v_min = 0, int v_max = 0, const char* display_format = "%.0f");
     bool          DragIntRange2(const char* label, int* v_current_min, int* v_current_max, float v_speed = 1.0f, int v_min = 0, int v_max = 0, const char* display_format = "%.0f", const char* display_format_max = null);

    // Widgets: Input with Keyboard
     bool          InputText(const char* label, char* buf, size_t buf_size, ImGuiInputTextFlags flags = 0, ImGuiTextEditCallback callback = null, void* user_data = null);
     bool          InputTextMultiline(const char* label, char* buf, size_t buf_size, const ImVec2 size = ImVec2(0,0), ImGuiInputTextFlags flags = 0, ImGuiTextEditCallback callback = null, void* user_data = null);
     bool          InputFloat(const char* label, float* v, float step = 0.0f, float step_fast = 0.0f, int decimal_precision = -1, ImGuiInputTextFlags extra_flags = 0);
     bool          InputFloat2(const char* label, float[2] v, int decimal_precision = -1, ImGuiInputTextFlags extra_flags = 0);
     bool          InputFloat3(const char* label, float[3] v, int decimal_precision = -1, ImGuiInputTextFlags extra_flags = 0);
     bool          InputFloat4(const char* label, float[4] v, int decimal_precision = -1, ImGuiInputTextFlags extra_flags = 0);
     bool          InputInt(const char* label, int* v, int step = 1, int step_fast = 100, ImGuiInputTextFlags extra_flags = 0);
     bool          InputInt2(const char* label, int[2] v, ImGuiInputTextFlags extra_flags = 0);
     bool          InputInt3(const char* label, int[3] v, ImGuiInputTextFlags extra_flags = 0);
     bool          InputInt4(const char* label, int[4] v, ImGuiInputTextFlags extra_flags = 0);

    // Widgets: Sliders (tip: ctrl+click on a slider to input with keyboard. manually input values aren't clamped, can go off-bounds)
     bool          SliderFloat(const char* label, float* v, float v_min, float v_max, const char* display_format = "%.3f", float power = 1.0f);     // adjust display_format to decorate the value with a prefix or a suffix. Use power!=1.0 for logarithmic sliders
     bool          SliderFloat2(const char* label, float[2] v, float v_min, float v_max, const char* display_format = "%.3f", float power = 1.0f);
     bool          SliderFloat3(const char* label, float[3] v, float v_min, float v_max, const char* display_format = "%.3f", float power = 1.0f);
     bool          SliderFloat4(const char* label, float[4] v, float v_min, float v_max, const char* display_format = "%.3f", float power = 1.0f);
     bool          SliderAngle(const char* label, float* v_rad, float v_degrees_min = -360.0f, float v_degrees_max = +360.0f);
     bool          SliderInt(const char* label, int* v, int v_min, int v_max, const char* display_format = "%.0f");
     bool          SliderInt2(const char* label, int[2] v, int v_min, int v_max, const char* display_format = "%.0f");
     bool          SliderInt3(const char* label, int[3] v, int v_min, int v_max, const char* display_format = "%.0f");
     bool          SliderInt4(const char* label, int[4] v, int v_min, int v_max, const char* display_format = "%.0f");
     bool          VSliderFloat(const char* label, const ref ImVec2 size, float* v, float v_min, float v_max, const char* display_format = "%.3f", float power = 1.0f);
     bool          VSliderInt(const char* label, const ref ImVec2 size, int* v, int v_min, int v_max, const char* display_format = "%.0f");

    // Widgets: Trees
     bool          TreeNode(const char* str_label_id);                                     // if returning 'true' the node is open and the user is responsible for calling TreePop().
     bool          TreeNode(const char* str_id, const char* fmt, ...);// IM_PRINTFARGS(2);    // read the FAQ about why and how to use ID. to align arbitrary text at the same level as a TreeNode() you can use Bullet().
     bool          TreeNode(const void* ptr_id, const char* fmt, ...);// IM_PRINTFARGS(2);    // "
     bool          TreeNodeV(const char* str_id, const char* fmt, va_list args);           // "
     bool          TreeNodeV(const void* ptr_id, const char* fmt, va_list args);           // "
     void          TreePush(const char* str_id = null);                                    // already called by TreeNode(), but you can call Push/Pop yourself for layouting purpose
     void          TreePush(const void* ptr_id = null);                                    // "
     void          TreePop();
     void          SetNextTreeNodeOpened(bool opened, ImGuiSetCond cond = 0);              // set next tree node/collapsing header to be opened.

    // Widgets: Selectable / Lists
     bool          Selectable(const char* label, bool selected = false, ImGuiSelectableFlags flags = 0, const ImVec2 size = ImVec2(0,0));  // size.x==0.0: use remaining width, size.x>0.0: specify width. size.y==0.0: use label height, size.y>0.0: specify height
     bool          Selectable(const char* label, bool* p_selected, ImGuiSelectableFlags flags = 0, const ImVec2 size = ImVec2(0,0));
     bool          ListBox(const char* label, int* current_item, const(char)** items, int items_count, int height_in_items = -1);
     bool          ListBox(const char* label, int* current_item, bool function(void* data, int idx, const char** out_text) items_getter, void* data, int items_count, int height_in_items = -1);
     bool          ListBoxHeader(const char* label, const ImVec2 size = ImVec2(0,0)); // use if you want to reimplement ListBox() will custom data or interactions. make sure to call ListBoxFooter() afterwards.
     bool          ListBoxHeader(const char* label, int items_count, int height_in_items = -1); // "
     void          ListBoxFooter();                                                    // terminate the scrolling region

    // Widgets: Value() Helpers. Output single value in "name: value" format (tip: freely declare more in your code to handle your types. you can add functions to the ImGui namespace)
     void          Value(const char* prefix, bool b);
     void          Value(const char* prefix, int v);
     void          Value(const char* prefix, uint v);
     void          Value(const char* prefix, float v, const char* float_format = null);
     void          ValueColor(const char* prefix, const ref ImVec4 v);
     void          ValueColor(const char* prefix, uint v);

    // Tooltips
     void          SetTooltip(const char* fmt, ...);// IM_PRINTFARGS(1);                  // set tooltip under mouse-cursor, typically use with ImGui::IsHovered(). last call wins
     void          SetTooltipV(const char* fmt, va_list args);
     void          BeginTooltip();                                                     // use to create full-featured tooltip windows that aren't just text
     void          EndTooltip();

    // Menus
     bool          BeginMainMenuBar();                                                 // create and append to a full screen menu-bar. only call EndMainMenuBar() if this returns true!
     void          EndMainMenuBar();
     bool          BeginMenuBar();                                                     // append to menu-bar of current window (requires ImGuiWindowFlags_MenuBar flag set). only call EndMenuBar() if this returns true!
     void          EndMenuBar();
     bool          BeginMenu(const char* label, bool enabled = true);                  // create a sub-menu entry. only call EndMenu() if this returns true!
     void          EndMenu();
     bool          MenuItem(const char* label, const char* shortcut = null, bool selected = false, bool enabled = true);  // return true when activated. shortcuts are displayed for convenience but not processed by ImGui at the moment
     bool          MenuItem(const char* label, const char* shortcut, bool* p_selected, bool enabled = true);              // return true when activated + toggle (*p_selected) if p_selected != null

    // Popups
     void          OpenPopup(const char* str_id);                                      // mark popup as open. popups are closed when user click outside, or activate a pressable item, or CloseCurrentPopup() is called within a BeginPopup()/EndPopup() block. popup identifiers are relative to the current ID-stack (so OpenPopup and BeginPopup needs to be at the same level).
     bool          BeginPopup(const char* str_id);                                     // return true if popup if opened and start outputting to it. only call EndPopup() if BeginPopup() returned true!
     bool          BeginPopupModal(const char* name, bool* p_opened = null, ImGuiWindowFlags extra_flags = 0);             // modal dialog (can't close them by clicking outside)
     bool          BeginPopupContextItem(const char* str_id, int mouse_button = 1);                                        // helper to open and begin popup when clicked on last item. read comments in .cpp!
     bool          BeginPopupContextWindow(bool also_over_items = true, const char* str_id = null, int mouse_button = 1);  // helper to open and begin popup when clicked on current window.
     bool          BeginPopupContextVoid(const char* str_id = null, int mouse_button = 1);                                 // helper to open and begin popup when clicked in void (no window).
     void          EndPopup();
     void          CloseCurrentPopup();                                                // close the popup we have begin-ed into. clicking on a MenuItem or Selectable automatically close the current popup.

    // Logging: all text output from interface is redirected to tty/file/clipboard. Tree nodes are automatically opened.
     void          LogToTTY(int max_depth = -1);                                       // start logging to tty
     void          LogToFile(int max_depth = -1, const char* filename = null);         // start logging to file
     void          LogToClipboard(int max_depth = -1);                                 // start logging to OS clipboard
     void          LogFinish();                                                        // stop logging (close file, etc.)
     void          LogButtons();                                                       // helper to display buttons for logging to tty/file/clipboard
     void          LogText(const char* fmt, ...); // IM_PRINTFARGS(1);                     // pass text data straight to log (without being displayed)

    // Utilities
     bool          IsItemHovered();                                                    // was the last item hovered by mouse?
     bool          IsItemHoveredRect();                                                // was the last item hovered by mouse? even if another item is active or window is blocked by popup while we are hovering this
     bool          IsItemActive();                                                     // was the last item active? (e.g. button being held, text field being edited- items that don't interact will always return false)
     bool          IsItemVisible();                                                    // was the last item visible? (aka not out of sight due to clipping/scrolling.)
     bool          IsAnyItemHovered();
     bool          IsAnyItemActive();
     ImVec2        GetItemRectMin();                                                   // get bounding rect of last item in screen space
     ImVec2        GetItemRectMax();                                                   // "
     ImVec2        GetItemRectSize();                                                  // "
     void          SetItemAllowOverlap();                                              // allow last item to be overlapped by a subsequent item. sometimes useful with invisible buttons, selectables, etc. to catch unused area.
     bool          IsWindowHovered();                                                  // is current window hovered and hoverable (not blocked by a popup) (differentiate child windows from each others)
     bool          IsWindowFocused();                                                  // is current window focused
     bool          IsRootWindowFocused();                                              // is current root window focused (top parent window in case of child windows)
     bool          IsRootWindowOrAnyChildFocused();                                    // is current root window or any of its child (including current window) focused
     bool          IsRectVisible(const ref ImVec2 size);                                  // test if rectangle of given size starting from cursor pos is visible (not clipped). to perform coarse clipping on user's side (as an optimization)
     bool          IsPosHoveringAnyWindow(const ref ImVec2 pos);                          // is given position hovering any active imgui window
     float         GetTime();
     int           GetFrameCount();
     /+const+/ char*   GetStyleColName(ImGuiCol idx);
     ImVec2        CalcItemRectClosestPoint(const ref ImVec2 pos, bool on_edge = false, float outward = +0.0f);   // utility to find the closest point the last item bounding rectangle edge. useful to visually link items
     ImVec2        CalcTextSize(const char* text, const char* text_end = null, bool hide_text_after_double_hash = false, float wrap_width = -1.0f);
     void          CalcListClipping(int items_count, float items_height, int* out_items_display_start, int* out_items_display_end);    // calculate coarse clipping for large list of evenly sized items. Prefer using the ImGuiListClipper higher-level helper if you can.

     bool          BeginChildFrame(ImGuiID id, const ref ImVec2 size, ImGuiWindowFlags extra_flags = 0);    // helper to create a child window / scrolling region that looks like a normal widget frame
     void          EndChildFrame();

     ImVec4        ColorConvertU32ToFloat4(ImU32 in_val);
     ImU32         ColorConvertFloat4ToU32(const ref ImVec4 in_val);
     void          ColorConvertRGBtoHSV(float r, float g, float b, ref float out_h, ref float out_s, ref float out_v);
     void          ColorConvertHSVtoRGB(float h, float s, float v, ref float out_r, ref float out_g, ref float out_b);

    // Inputs
     int           GetKeyIndex(ImGuiKey key);                                          // map ImGuiKey_* values into user's key index. == io.KeyMap[key]
     bool          IsKeyDown(int key_index);                                           // key_index into the keys_down[] array, imgui doesn't know the semantic of each entry, uses your own indices!
     bool          IsKeyPressed(int key_index, bool repeat = true);                    // uses user's key indices as stored in the keys_down[] array. if repeat=true. uses io.KeyRepeatDelay / KeyRepeatRate
     bool          IsKeyReleased(int key_index);                                       // "
     bool          IsMouseDown(int button);                                            // is mouse button held
     bool          IsMouseClicked(int button, bool repeat = false);                    // did mouse button clicked (went from !Down to Down)
     bool          IsMouseDoubleClicked(int button);                                   // did mouse button double-clicked. a double-click returns false in IsMouseClicked(). uses io.MouseDoubleClickTime.
     bool          IsMouseReleased(int button);                                        // did mouse button released (went from Down to !Down)
     bool          IsMouseHoveringWindow();                                            // is mouse hovering current window ("window" in API names always refer to current window). disregarding of any consideration of being blocked by a popup. (unlike IsWindowHovered() this will return true even if the window is blocked because of a popup)
     bool          IsMouseHoveringAnyWindow();                                         // is mouse hovering any visible window
     bool          IsMouseHoveringRect(const ref ImVec2 r_min, const ref ImVec2 r_max, bool clip = true);  // is mouse hovering given bounding rect (in screen space). clipped by current clipping settings. disregarding of consideration of focus/window ordering/blocked by a popup.
     bool          IsMouseDragging(int button = 0, float lock_threshold = -1.0f);      // is mouse dragging. if lock_threshold < -1.0f uses io.MouseDraggingThreshold
     ImVec2        GetMousePos();                                                      // shortcut to ImGui::GetIO().MousePos provided by user, to be consistent with other calls
     ImVec2        GetMousePosOnOpeningCurrentPopup();                                 // retrieve backup of mouse positioning at the time of opening popup we have BeginPopup() into
     ImVec2        GetMouseDragDelta(int button = 0, float lock_threshold = -1.0f);    // dragging amount since clicking. if lock_threshold < -1.0f uses io.MouseDraggingThreshold
     void          ResetMouseDragDelta(int button = 0);                                //
     ImGuiMouseCursor GetMouseCursor();                                                // get desired cursor type, reset in ImGui::NewFrame(), this updated during the frame. valid before Render(). If you use software rendering by setting io.MouseDrawCursor ImGui will render those for you
     void          SetMouseCursor(ImGuiMouseCursor type);                              // set desired cursor type
     void          CaptureKeyboardFromApp(bool capture = true);                        // manually override io.WantCaptureKeyboard flag next frame (said flag is entirely left for your application handle). e.g. force capture keyboard when your widget is being hovered.
     void          CaptureMouseFromApp(bool capture = true);                           // manually override io.WantCaptureMouse flag next frame (said flag is entirely left for your application handle).

    // Helpers functions to access functions pointers in ImGui::GetIO()
     void*         MemAlloc(size_t sz);
     void          MemFree(void* ptr);
     /+const+/ char*   GetClipboardText();
     void          SetClipboardText(const char* text);

    // Internal state/context access - if you want to use multiple ImGui context, or share context between modules (e.g. DLL), or allocate the memory yourself
     /+const+/ char*   GetVersion();
     void*         GetInternalState();
     size_t        GetInternalStateSize();
     void          SetInternalState(void* state, bool construct = false);

     void          RenderText(ImVec2 pos, const char* text, const char* text_end = null, bool hide_text_after_hash = true);
     void          RenderTextWrapped(ImVec2 pos, const char* text, const char* text_end, float wrap_width);
}
