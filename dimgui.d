module dimgui;

import core.stdc.stdarg:va_list;

extern(C++):

struct ImDrawListSharedData;      // Data shared among multiple draw lists (typically owned by parent ImGui context, but you may create one yourself)
struct ImGuiContext;              // ImGui context (opaque)

alias void* ImTextureID;          // user data to refer to a texture (e.g. store your texture handle/id)

alias uint ImU32;                 // 32-bit unsigned integer (typically used to store packed colors)
alias ImU32 ImGuiID;              // Unique ID used by widgets (typically hashed from a stack of string)
alias ushort ImWchar;             // Character for keyboard input/display
alias int ImGuiCol;               // enum: a color identifier for styling     // enum ImGuiCol_
alias int ImGuiDir;               // enum: a cardinal direction               // enum ImGuiDir_
alias int ImGuiCond;              // enum: a condition for Set*()             // enum ImGuiCond_
alias int ImGuiKey;               // enum: a key identifier (ImGui-side enum) // enum ImGuiKey_
alias int ImGuiNavInput;          // enum: an input identifier for navigation // enum ImGuiNavInput_
alias int ImGuiMouseCursor;       // enum: a mouse cursor identifier          // enum ImGuiMouseCursor_
alias int ImGuiStyleVar;          // enum: a variable identifier for styling  // enum ImGuiStyleVar_
alias int ImDrawCornerFlags;      // flags: for ImDrawList::AddRect*() etc.   // enum ImDrawCornerFlags_
alias int ImDrawListFlags;        // flags: for ImDrawList                    // enum ImDrawListFlags_
alias int ImFontAtlasFlags;       // flags: for ImFontAtlas                   // enum ImFontAtlasFlags_
alias int ImGuiBackendFlags;      // flags: for io.BackendFlags               // enum ImGuiBackendFlags_
alias int ImGuiColorEditFlags;    // flags: for ColorEdit*(), ColorPicker*()  // enum ImGuiColorEditFlags_
alias int ImGuiColumnsFlags;      // flags: for *Columns*()                   // enum ImGuiColumnsFlags_
alias int ImGuiConfigFlags;       // flags: for io.ConfigFlags                // enum ImGuiConfigFlags_
alias int ImGuiDragDropFlags;     // flags: for *DragDrop*()                  // enum ImGuiDragDropFlags_
alias int ImGuiComboFlags;        // flags: for BeginCombo()                  // enum ImGuiComboFlags_
alias int ImGuiFocusedFlags;      // flags: for IsWindowFocused()             // enum ImGuiFocusedFlags_
alias int ImGuiHoveredFlags;      // flags: for IsItemHovered() etc.          // enum ImGuiHoveredFlags_
alias int ImGuiInputTextFlags;    // flags: for InputText*()                  // enum ImGuiInputTextFlags_
alias int ImGuiSelectableFlags;   // flags: for Selectable()                  // enum ImGuiSelectableFlags_
alias int ImGuiTreeNodeFlags;     // flags: for TreeNode*(),CollapsingHeader()// enum ImGuiTreeNodeFlags_
alias int ImGuiWindowFlags;       // flags: for Begin*()                      // enum ImGuiWindowFlags_
alias int function(ImGuiTextEditCallbackData* data) ImGuiTextEditCallback;
alias void function(ImGuiSizeCallbackData* data) ImGuiSizeCallback;
alias ulong ImU64;                // 64-bit unsigned integer

struct ImVec2
{
    float x = 0;
    float y = 0;

    __gshared const zero = ImVec2(0, 0);
    __gshared const one = ImVec2(1, 1);
    __gshared const one_zero = ImVec2(1, 0);
    __gshared const zero_one = ImVec2(0, 1);
    __gshared const negone_zero = ImVec2(-1, 0);
}

struct ImVec4
{
    float x = 0;
    float y = 0;
    float z = 0;
    float w = 0;

    __gshared const zero = ImVec4(0, 0, 0, 0);
    __gshared const one = ImVec4(1, 1, 1, 1);
}

// ImGui end-user API
// In a namespace so that user can add extra functions _in a separate file (e.g. Value() helpers for your vector or common types)
extern(C++, ImGui) nothrow @nogc
{
    // Context creation and access 
    // All contexts share a same ImFontAtlas by default. If you want different font atlas, you can new() them and overwrite the GetIO().Fonts variable of an ImGui context.
    // All those functions are not reliant on the current context.
    ImGuiContext* CreateContext(ImFontAtlas* shared_font_atlas = null);
    void          DestroyContext(ImGuiContext* ctx = null);   // null = destroy current context
    ImGuiContext* GetCurrentContext();
    void          SetCurrentContext(ImGuiContext* ctx);

    // Main
    ref ImGuiIO   GetIO();
    ref ImGuiStyle GetStyle();
    void          NewFrame();                                 // start a new ImGui frame, you can submit any command from this point until Render()/EndFrame().
    void          Render();                                   // ends the ImGui frame, finalize the draw data. (Obsolete: optionally call io.RenderDrawListsFn if set. Nowadays, prefer calling your render function yourself.)
    ImDrawData*   GetDrawData();                              // valid after Render() and until the next call to NewFrame(). this is what you have to render. (Obsolete: this used to be passed to your io.RenderDrawListsFn() function.)
    void          EndFrame();                                 // ends the ImGui frame. automatically called by Render(), so most likely don't need to ever call that yourself directly. If you don't need to render you may call EndFrame() but you'll have wasted CPU already. If you don't need to render, better to not create any imgui windows instead!

    // Demo, Debug, Information
    void          ShowDemoWindow(bool* p_open = null);        // create demo/test window (previously called ShowTestWindow). demonstrate most ImGui features. call this to learn about the library! try to make it always available _in your application!
    void          ShowMetricsWindow(bool* p_open = null);     // create metrics window. display ImGui internals: draw commands (with individual draw calls and vertices), window list, basic internal state, etc.
    void          ShowStyleEditor(ImGuiStyle* _ref = null);   // add style editor block (not a window). you can pass _in a reference ImGuiStyle structure to compare to, revert to and save to (else it uses the default style)
    bool          ShowStyleSelector(const(char)* label);      // add style selector block (not a window), essentially a combo listing the default styles.
    void          ShowFontSelector(const(char)* label);       // add font selector block (not a window), essentially a combo listing the loaded fonts.
    void          ShowUserGuide();                            // add basic help/info block (not a window): how to manipulate ImGui as a end-user (mouse/keyboard controls).
    const(char)*  GetVersion();                               // get a version string e.g. "1.23"

    // Styles
    void          StyleColorsDark(ImGuiStyle* dst = null);    // new, recommended style (default)
    void          StyleColorsClassic(ImGuiStyle* dst = null); // classic imgui style
    void          StyleColorsLight(ImGuiStyle* dst = null);   // best used with borders and a custom, thicker font

    // Windows
    // (Begin = push window to the stack and start appending to it. End = pop window from the stack. You may append multiple times to the same window during the same frame)
    // Begin()/BeginChild() return false to indicate the window being collapsed or fully clipped, so you may early out and omit submitting anything to the window.
    // However you need to always call a matching End()/EndChild() for a Begin()/BeginChild() call, regardless of its return value (this is due to legacy reason and is inconsistent with BeginMenu/EndMenu, BeginPopup/EndPopup and other functions where the End call should only be called if the corresponding Begin function returned true.)
    // Passing 'bool* p_open != null' shows a close widget _in the upper-right corner of the window, which when clicking will set the boolean to false.
    // Use child windows to introduce independent scrolling/clipping regions within a host window. Child windows can embed their own child.
    bool          Begin(const(char)* name, bool* p_open = null, ImGuiWindowFlags flags = 0);
    void          End();
    bool          BeginChild(const(char)* str_id, ref const(ImVec2) size = ImVec2.zero, bool border = false, ImGuiWindowFlags flags = 0); // Begin a scrolling region. size==0.0f: use remaining window size, size<0.0f: use remaining window size minus abs(size). size>0.0f: fixed size. each axis can use a different mode, e.g. ImVec2(0,400).
    bool          BeginChild(ImGuiID id, ref const(ImVec2) size = ImVec2.zero, bool border = false, ImGuiWindowFlags flags = 0);
    void          EndChild();

    // Windows Utilities
    bool          IsWindowAppearing();
    bool          IsWindowCollapsed();
    bool          IsWindowFocused(ImGuiFocusedFlags flags=0); // is current window focused? or its root/child, depending on flags. see flags for options.
    bool          IsWindowHovered(ImGuiHoveredFlags flags=0); // is current window hovered (and typically: not blocked by a popup/modal)? see flags for options. NB: If you are trying to check whether your mouse should be dispatched to imgui or to your app, you should use the 'io.WantCaptureMouse' boolean for that! Please read the FAQ!
    ImDrawList*   GetWindowDrawList();                        // get draw list associated to the window, to append your own drawing primitives
    ImVec2        GetWindowPos();                             // get current window position _in screen space (useful if you want to do your own drawing via the DrawList API)
    ImVec2        GetWindowSize();                            // get current window size
    float         GetWindowWidth();                           // get current window width (shortcut for GetWindowSize().x)
    float         GetWindowHeight();                          // get current window height (shortcut for GetWindowSize().y)
    ImVec2        GetContentRegionMax();                      // current content boundaries (typically window boundaries including scrolling, or current column boundaries), _in windows coordinates
    ImVec2        GetContentRegionAvail();                    // == GetContentRegionMax() - GetCursorPos()
    float         GetContentRegionAvailWidth();               //
    ImVec2        GetWindowContentRegionMin();                // content boundaries min (roughly (0,0)-Scroll), _in window coordinates
    ImVec2        GetWindowContentRegionMax();                // content boundaries max (roughly (0,0)+Size-Scroll) where Size can be override with SetNextWindowContentSize(), _in window coordinates
    float         GetWindowContentRegionWidth();              //

    void          SetNextWindowPos(ref const(ImVec2) pos, ImGuiCond cond = 0, ref const(ImVec2) pivot = ImVec2.zero); // set next window position. call before Begin(). use pivot=(0.5f,0.5f) to center on given point, etc.
    void          SetNextWindowSize(ref const(ImVec2) size, ImGuiCond cond = 0);                // set next window size. set axis to 0.0f to force an auto-fit on this axis. call before Begin()
    void          SetNextWindowSizeConstraints(ref const(ImVec2) size_min, ref const(ImVec2) size_max, ImGuiSizeCallback custom_callback = null, void* custom_callback_data = null); // set next window size limits. use -1,-1 on either X/Y axis to preserve the current size. Use callback to apply non-trivial programmatic constraints.
    void          SetNextWindowContentSize(ref const(ImVec2) size);                             // set next window content size (~ enforce the range of scrollbars). not including window decorations (title bar, menu bar, etc.). set an axis to 0.0f to leave it automatic. call before Begin()
    void          SetNextWindowCollapsed(bool collapsed, ImGuiCond cond = 0);                   // set next window collapsed state. call before Begin()
    void          SetNextWindowFocus();                                                         // set next window to be focused / front-most. call before Begin()
    void          SetNextWindowBgAlpha(float alpha);                                            // set next window background color alpha. helper to easily modify ImGuiCol_WindowBg/ChildBg/PopupBg.
    void          SetWindowPos(ref const(ImVec2) pos, ImGuiCond cond = 0);                      // (not recommended) set current window position - call within Begin()/End(). prefer using SetNextWindowPos(), as this may incur tearing and side-effects.
    void          SetWindowSize(ref const(ImVec2) size, ImGuiCond cond = 0);                    // (not recommended) set current window size - call within Begin()/End(). set to ImVec2.zero to force an auto-fit. prefer using SetNextWindowSize(), as this may incur tearing and minor side-effects.    
    void          SetWindowCollapsed(bool collapsed, ImGuiCond cond = 0);                       // (not recommended) set current window collapsed state. prefer using SetNextWindowCollapsed().
    void          SetWindowFocus();                                                             // (not recommended) set current window to be focused / front-most. prefer using SetNextWindowFocus().
    void          SetWindowFontScale(float scale);                                              // set font scale. Adjust IO.FontGlobalScale if you want to scale all windows
    void          SetWindowPos(const(char)* name, ref const(ImVec2) pos, ImGuiCond cond = 0);   // set named window position.
    void          SetWindowSize(const(char)* name, ref const(ImVec2) size, ImGuiCond cond = 0); // set named window size. set axis to 0.0f to force an auto-fit on this axis.
    void          SetWindowCollapsed(const(char)* name, bool collapsed, ImGuiCond cond = 0);    // set named window collapsed state
    void          SetWindowFocus(const(char)* name);                                            // set named window to be focused / front-most. use null to remove focus.

    // Windows Scrolling
    float         GetScrollX();                                                   // get scrolling amount [0..GetScrollMaxX()]
    float         GetScrollY();                                                   // get scrolling amount [0..GetScrollMaxY()]
    float         GetScrollMaxX();                                                // get maximum scrolling amount ~~ ContentSize.X - WindowSize.X
    float         GetScrollMaxY();                                                // get maximum scrolling amount ~~ ContentSize.Y - WindowSize.Y
    void          SetScrollX(float scroll_x);                                     // set scrolling amount [0..GetScrollMaxX()]
    void          SetScrollY(float scroll_y);                                     // set scrolling amount [0..GetScrollMaxY()]
    void          SetScrollHere(float center_y_ratio = 0.5f);                     // adjust scrolling amount to make current cursor position visible. center_y_ratio=0.0: top, 0.5: center, 1.0: bottom. When using to make a "default/current item" visible, consider using SetItemDefaultFocus() instead.
    void          SetScrollFromPosY(float pos_y, float center_y_ratio = 0.5f);    // adjust scrolling amount to make given position valid. use GetCursorPos() or GetCursorStartPos()+offset to get valid positions.

    // Parameters stacks (shared)
    void          PushFont(ImFont* font);                                         // use null as a shortcut to push default font
    void          PopFont();
    void          PushStyleColor(ImGuiCol idx, ImU32 col);
    void          PushStyleColor(ImGuiCol idx, ref const(ImVec4) col);
    void          PopStyleColor(int count = 1);
    void          PushStyleVar(ImGuiStyleVar idx, float val);
    void          PushStyleVar(ImGuiStyleVar idx, ref const(ImVec2) val);
    void          PopStyleVar(int count = 1);
    ref const(ImVec4) GetStyleColorVec4(ImGuiCol idx);                            // retrieve style color as stored _in ImGuiStyle structure. use to feed back into PushStyleColor(), otherwhise use GetColorU32() to get style color with style alpha baked _in.
    ImFont*       GetFont();                                                      // get current font
    float         GetFontSize();                                                  // get current font size (= height _in pixels) of current font with current scale applied
    ImVec2        GetFontTexUvWhitePixel();                                       // get UV coordinate for a while pixel, useful to draw custom shapes via the ImDrawList API
    ImU32         GetColorU32(ImGuiCol idx, float alpha_mul = 1.0f);              // retrieve given style color with style alpha applied and optional extra alpha multiplier
    ImU32         GetColorU32(ref const(ImVec4) col);                             // retrieve given color with style alpha applied
    ImU32         GetColorU32(ImU32 col);                                         // retrieve given color with style alpha applied

    // Parameters stacks (current window)
    void          PushItemWidth(float item_width);                                // width of items for the common item+label case, pixels. 0.0f = default to ~2/3 of windows width, >0.0f: width _in pixels, <0.0f align xx pixels to the right of window (so -1.0f always align width to the right side)
    void          PopItemWidth();
    float         CalcItemWidth();                                                // width of item given pushed settings and current cursor position
    void          PushTextWrapPos(float wrap_pos_x = 0.0f);                       // word-wrapping for Text*() commands. < 0.0f: no wrapping; 0.0f: wrap to end of window (or column); > 0.0f: wrap at 'wrap_pos_x' position _in window local space
    void          PopTextWrapPos();
    void          PushAllowKeyboardFocus(bool allow_keyboard_focus);              // allow focusing using TAB/Shift-TAB, enabled by default but you can disable it for certain widgets
    void          PopAllowKeyboardFocus();
    void          PushButtonRepeat(bool repeat);                                  // _in 'repeat' mode, Button*() functions return repeated true _in a typematic manner (using io.KeyRepeatDelay/io.KeyRepeatRate setting). Note that you can call IsItemActive() after any Button() to tell if the button is held _in the current frame.
    void          PopButtonRepeat();

    // Cursor / Layout
    void          Separator();                                                    // separator, generally horizontal. inside a menu bar or _in horizontal layout mode, this becomes a vertical separator.
    void          SameLine(float pos_x = 0.0f, float spacing_w = -1.0f);          // call between widgets or groups to layout them horizontally
    void          NewLine();                                                      // undo a SameLine()
    void          Spacing();                                                      // add vertical spacing
    void          Dummy(ref const(ImVec2) size);                                  // add a dummy item of given size
    void          Indent(float indent_w = 0.0f);                                  // move content position toward the right, by style.IndentSpacing or indent_w if != 0
    void          Unindent(float indent_w = 0.0f);                                // move content position back to the left, by style.IndentSpacing or indent_w if != 0
    void          BeginGroup();                                                   // lock horizontal starting position + capture group bounding box into one "item" (so you can use IsItemHovered() or layout primitives such as SameLine() on whole group, etc.)
    void          EndGroup();
    ImVec2        GetCursorPos();                                                 // cursor position is relative to window position
    float         GetCursorPosX();                                                // "
    float         GetCursorPosY();                                                // "
    void          SetCursorPos(ref const(ImVec2) local_pos);                      // "
    void          SetCursorPosX(float x);                                         // "
    void          SetCursorPosY(float y);                                         // "
    ImVec2        GetCursorStartPos();                                            // initial cursor position
    ImVec2        GetCursorScreenPos();                                           // cursor position _in absolute screen coordinates [0..io.DisplaySize] (useful to work with ImDrawList API)
    void          SetCursorScreenPos(ref const(ImVec2) screen_pos);               // cursor position _in absolute screen coordinates [0..io.DisplaySize]
    void          AlignTextToFramePadding();                                      // vertically align upcoming text baseline to FramePadding.y so that it will align properly to regularly framed items (call if you have text on a line before a framed item)
    float         GetTextLineHeight();                                            // ~ FontSize
    float         GetTextLineHeightWithSpacing();                                 // ~ FontSize + style.ItemSpacing.y (distance _in pixels between 2 consecutive lines of text)
    float         GetFrameHeight();                                               // ~ FontSize + style.FramePadding.y * 2
    float         GetFrameHeightWithSpacing();                                    // ~ FontSize + style.FramePadding.y * 2 + style.ItemSpacing.y (distance _in pixels between 2 consecutive lines of framed widgets)

    // ID stack/scopes
    // Read the FAQ for more details about how ID are handled _in dear imgui. If you are creating widgets _in a loop you most 
    // likely want to push a unique identifier (e.g. object pointer, loop index) to uniquely differentiate them.
    // You can also use the "##foobar" syntax within widget label to distinguish them from each others. 
    // In this header file we use the "label"/"name" terminology to denote a string that will be displayed and used as an ID, 
    // whereas "str_id" denote a string that is only used as an ID and not aimed to be displayed. 
    void          PushID(const(char)* str_id);                                    // push identifier into the ID stack. IDs are hash of the entire stack!
    void          PushID(const(char)* str_id_begin, const(char)* str_id_end);
    void          PushID(const(void)* ptr_id);
    void          PushID(int int_id);
    void          PopID();
    ImGuiID       GetID(const(char)* str_id);                                     // calculate unique ID (hash of whole ID stack + given parameter). e.g. if you want to query into ImGuiStorage yourself
    ImGuiID       GetID(const(char)* str_id_begin, const(char)* str_id_end);
    ImGuiID       GetID(const(void)* ptr_id);

    // Widgets: Text
    void          TextUnformatted(const(char)* text, const(char)* text_end = null);               // raw text without formatting. Roughly equivalent to Text("%s", text) but: A) doesn't require null terminated string if 'text_end' is specified, B) it's faster, no memory copy is done, no buffer size limits, recommended for long chunks of text.
    void          Text(const(char)* fmt, ...);                                                    // simple formatted text
    void          TextV(const(char)* fmt, va_list args);
    void          TextColored(ref const(ImVec4) col, const(char)* fmt, ...);                      // shortcut for PushStyleColor(ImGuiCol_Text, col); Text(fmt, ...); PopStyleColor();
    void          TextColoredV(ref const(ImVec4) col, const(char)* fmt, va_list args);
    void          TextDisabled(const(char)* fmt, ...);                                            // shortcut for PushStyleColor(ImGuiCol_Text, style.Colors[ImGuiCol_TextDisabled]); Text(fmt, ...); PopStyleColor();
    void          TextDisabledV(const(char)* fmt, va_list args);
    void          TextWrapped(const(char)* fmt, ...);                                             // shortcut for PushTextWrapPos(0.0f); Text(fmt, ...); PopTextWrapPos();. Note that this won't work on an auto-resizing window if there's no other widgets to extend the window width, yoy may need to set a size using SetNextWindowSize().
    void          TextWrappedV(const(char)* fmt, va_list args);
    void          LabelText(const(char)* label, const(char)* fmt, ...);                           // display text+label aligned the same way as value+label widgets
    void          LabelTextV(const(char)* label, const(char)* fmt, va_list args);
    void          BulletText(const(char)* fmt, ...);                                              // shortcut for Bullet()+Text()
    void          BulletTextV(const(char)* fmt, va_list args);

    // Widgets: Main
    bool          Button(const(char)* label, ref const(ImVec2) size = ImVec2.zero); // button
    bool          SmallButton(const(char)* label);                                  // button with FramePadding=(0,0) to easily embed within text
    bool          ArrowButton(const(char)* str_id, ImGuiDir dir);
    bool          InvisibleButton(const(char)* str_id, ref const(ImVec2) size);     // button behavior without the visuals, useful to build custom behaviors using the public api (along with IsItemActive, IsItemHovered, etc.)
    void          Image(ImTextureID user_texture_id, ref const(ImVec2) size, ref const(ImVec2) uv0 = ImVec2.zero, ref const(ImVec2) uv1 = ImVec2.one, ref const(ImVec4) tint_col = ImVec4.one, ref const(ImVec4) border_col = ImVec4.zero);
    bool          ImageButton(ImTextureID user_texture_id, ref const(ImVec2) size, ref const(ImVec2) uv0 = ImVec2.zero,  ref const(ImVec2) uv1 = ImVec2.one, int frame_padding = -1, ref const(ImVec4) bg_col = ImVec4.zero, ref const(ImVec4) tint_col = ImVec4.one);    // <0 frame_padding uses default frame padding settings. 0 for no padding
    bool          Checkbox(const(char)* label, bool* v);
    bool          CheckboxFlags(const(char)* label, uint* flags, uint flags_value);
    bool          RadioButton(const(char)* label, bool active);
    bool          RadioButton(const(char)* label, int* v, int v_button);
    void          PlotLines(const(char)* label, const(float)* values, int values_count, int values_offset = 0, const(char)* overlay_text = null, float scale_min = float.max, float scale_max = float.max, ImVec2 graph_size = ImVec2.zero, int stride = float.sizeof);
    void          PlotLines(const(char)* label, float function(void* data, int idx) values_getter, void* data, int values_count, int values_offset = 0, const(char)* overlay_text = null, float scale_min = float.max, float scale_max = float.max, ImVec2 graph_size = ImVec2.zero);
    void          PlotHistogram(const(char)* label, const(float)* values, int values_count, int values_offset = 0, const(char)* overlay_text = null, float scale_min = float.max, float scale_max = float.max, ImVec2 graph_size = ImVec2.zero, int stride = float.sizeof);
    void          PlotHistogram(const(char)* label, float function(void* data, int idx) values_getter, void* data, int values_count, int values_offset = 0, const(char)* overlay_text = null, float scale_min = float.max, float scale_max = float.max, ImVec2 graph_size = ImVec2.zero);
    void          ProgressBar(float fraction, ref const(ImVec2) size_arg = ImVec2.negone_zero, const(char)* overlay = null);
    void          Bullet();                                                       // draw a small circle and keep the cursor on the same line. advance cursor x position by GetTreeNodeToLabelSpacing(), same distance that TreeNode() uses

    // Widgets: Combo Box
    // The new BeginCombo()/EndCombo() api allows you to manage your contents and selection state however you want it. 
    // The old Combo() api are helpers over BeginCombo()/EndCombo() which are kept available for convenience purpose.
    bool          BeginCombo(const(char)* label, const(char)* preview_value, ImGuiComboFlags flags = 0);
    void          EndCombo(); // only call EndCombo() if BeginCombo() returns true!
    bool          Combo(const(char)* label, int* current_item, const(char*)* items, int items_count, int popup_max_height_in_items = -1);
    bool          Combo(const(char)* label, int* current_item, const(char)* items_separated_by_zeros, int popup_max_height_in_items = -1);      // Separate items with \0 within a string, end item-list with \0\0. e.g. "One\0Two\0Three\0"
    bool          Combo(const(char)* label, int* current_item, bool function(void* data, int idx, const(char)** out_text)items_getter, void* data, int items_count, int popup_max_height_in_items = -1);

    // Widgets: Drags (tip: ctrl+click on a drag box to input with keyboard. manually input values aren't clamped, can go off-bounds)
    // For all the Float2/Float3/Float4/Int2/Int3/Int4 versions of every functions, note that a 'float v[X]' function argument is the same as 'float* v', the array syntax is just a way to document the number of elements that are expected to be accessible. You can pass address of your first element out of a contiguous set, e.g. &myvector.x
    // Speed are per-pixel of mouse movement (v_speed=0.2f: mouse needs to move by 5 pixels to increase value by 1). For gamepad/keyboard navigation, minimum speed is Max(v_speed, minimum_step_at_given_precision).
    bool          DragFloat(const(char)* label, float* v, float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const(char)* display_format = "%.3f", float power = 1.0f);     // If v_min >= v_max we have no bound
    bool          DragFloat2(const(char)* label, ref float[2] v, float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const(char)* display_format = "%.3f", float power = 1.0f);
    bool          DragFloat3(const(char)* label, ref float[3] v, float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const(char)* display_format = "%.3f", float power = 1.0f);
    bool          DragFloat4(const(char)* label, ref float[4] v, float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const(char)* display_format = "%.3f", float power = 1.0f);
    bool          DragFloatRange2(const(char)* label, float* v_current_min, float* v_current_max, float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const(char)* display_format = "%.3f", const(char)* display_format_max = null, float power = 1.0f);
    bool          DragInt(const(char)* label, int* v, float v_speed = 1.0f, int v_min = 0, int v_max = 0, const(char)* display_format = "%.0f");                                       // If v_min >= v_max we have no bound
    bool          DragInt2(const(char)* label, ref int[2] v, float v_speed = 1.0f, int v_min = 0, int v_max = 0, const(char)* display_format = "%.0f");
    bool          DragInt3(const(char)* label, ref int[3] v, float v_speed = 1.0f, int v_min = 0, int v_max = 0, const(char)* display_format = "%.0f");
    bool          DragInt4(const(char)* label, ref int[4] v, float v_speed = 1.0f, int v_min = 0, int v_max = 0, const(char)* display_format = "%.0f");
    bool          DragIntRange2(const(char)* label, int* v_current_min, int* v_current_max, float v_speed = 1.0f, int v_min = 0, int v_max = 0, const(char)* display_format = "%.0f", const(char)* display_format_max = null);

    // Widgets: Input with Keyboard
    bool          InputText(const(char)* label, char* buf, size_t buf_size, ImGuiInputTextFlags flags = 0, ImGuiTextEditCallback callback = null, void* user_data = null);
    bool          InputTextMultiline(const(char)* label, char* buf, size_t buf_size, ref const(ImVec2) size = ImVec2.zero, ImGuiInputTextFlags flags = 0, ImGuiTextEditCallback callback = null, void* user_data = null);
    bool          InputFloat(const(char)* label, float* v, float step = 0.0f, float step_fast = 0.0f, int decimal_precision = -1, ImGuiInputTextFlags extra_flags = 0);
    bool          InputFloat2(const(char)* label, ref float[2] v, int decimal_precision = -1, ImGuiInputTextFlags extra_flags = 0);
    bool          InputFloat3(const(char)* label, ref float[3] v, int decimal_precision = -1, ImGuiInputTextFlags extra_flags = 0);
    bool          InputFloat4(const(char)* label, ref float[4] v, int decimal_precision = -1, ImGuiInputTextFlags extra_flags = 0);
    bool          InputInt(const(char)* label, int* v, int step = 1, int step_fast = 100, ImGuiInputTextFlags extra_flags = 0);
    bool          InputInt2(const(char)* label, ref int[2] v, ImGuiInputTextFlags extra_flags = 0);
    bool          InputInt3(const(char)* label, ref int[3] v, ImGuiInputTextFlags extra_flags = 0);
    bool          InputInt4(const(char)* label, ref int[4] v, ImGuiInputTextFlags extra_flags = 0);
    bool          InputDouble(const(char)* label, double* v, double step = 0.0f, double step_fast = 0.0f, const(char)* display_format = "%.6f", ImGuiInputTextFlags extra_flags = 0);

    // Widgets: Sliders (tip: ctrl+click on a slider to input with keyboard. manually input values aren't clamped, can go off-bounds)
    bool          SliderFloat(const(char)* label, float* v, float v_min, float v_max, const(char)* display_format = "%.3f", float power = 1.0f);     // adjust display_format to decorate the value with a prefix or a suffix for _in-slider labels or unit display. Use power!=1.0 for logarithmic sliders
    bool          SliderFloat2(const(char)* label, ref float[2] v, float v_min, float v_max, const(char)* display_format = "%.3f", float power = 1.0f);
    bool          SliderFloat3(const(char)* label, ref float[3] v, float v_min, float v_max, const(char)* display_format = "%.3f", float power = 1.0f);
    bool          SliderFloat4(const(char)* label, ref float[4] v, float v_min, float v_max, const(char)* display_format = "%.3f", float power = 1.0f);
    bool          SliderAngle(const(char)* label, float* v_rad, float v_degrees_min = -360.0f, float v_degrees_max = +360.0f);
    bool          SliderInt(const(char)* label, int* v, int v_min, int v_max, const(char)* display_format = "%.0f");
    bool          SliderInt2(const(char)* label, ref int[2] v, int v_min, int v_max, const(char)* display_format = "%.0f");
    bool          SliderInt3(const(char)* label, ref int[3] v, int v_min, int v_max, const(char)* display_format = "%.0f");
    bool          SliderInt4(const(char)* label, ref int[4] v, int v_min, int v_max, const(char)* display_format = "%.0f");
    bool          VSliderFloat(const(char)* label, ref const(ImVec2) size, float* v, float v_min, float v_max, const(char)* display_format = "%.3f", float power = 1.0f);
    bool          VSliderInt(const(char)* label, ref const(ImVec2) size, int* v, int v_min, int v_max, const(char)* display_format = "%.0f");

    // Widgets: Color Editor/Picker (tip: the ColorEdit* functions have a little colored preview square that can be left-clicked to open a picker, and right-clicked to open an option menu.)
    // Note that a 'float v[X]' function argument is the same as 'float* v', the array syntax is just a way to document the number of elements that are expected to be accessible. You can the pass the address of a first float element out of a contiguous structure, e.g. &myvector.x
    bool          ColorEdit3(const(char)* label, ref float[3] col, ImGuiColorEditFlags flags = 0);
    bool          ColorEdit4(const(char)* label, ref float[4] col, ImGuiColorEditFlags flags = 0);
    bool          ColorPicker3(const(char)* label, ref float[3] col, ImGuiColorEditFlags flags = 0);
    bool          ColorPicker4(const(char)* label, ref float[4] col, ImGuiColorEditFlags flags = 0, const(float)* ref_col = null);
    bool          ColorButton(const(char)* desc_id, ref const(ImVec4) col, ImGuiColorEditFlags flags = 0, ImVec2 size = ImVec2.zero);  // display a colored square/button, hover for details, return true when pressed.
    void          SetColorEditOptions(ImGuiColorEditFlags flags);                     // initialize current options (generally on application startup) if you want to select a default format, picker type, etc. User will be able to change many settings, unless you pass the _NoOptions flag to your calls.

    // Widgets: Trees
    bool          TreeNode(const(char)* label);                                       // if returning 'true' the node is open and the tree id is pushed into the id stack. user is responsible for calling TreePop().
    bool          TreeNode(const(char)* str_id, const(char)* fmt, ...);               // read the FAQ about why and how to use ID. to align arbitrary text at the same level as a TreeNode() you can use Bullet().
    bool          TreeNode(const(void)* ptr_id, const(char)* fmt, ...);               // "
    bool          TreeNodeV(const(char)* str_id, const(char)* fmt, va_list args);
    bool          TreeNodeV(const(void)* ptr_id, const(char)* fmt, va_list args);
    bool          TreeNodeEx(const(char)* label, ImGuiTreeNodeFlags flags = 0);
    bool          TreeNodeEx(const(char)* str_id, ImGuiTreeNodeFlags flags, const(char)* fmt, ...);
    bool          TreeNodeEx(const(void)* ptr_id, ImGuiTreeNodeFlags flags, const(char)* fmt, ...);
    bool          TreeNodeExV(const(char)* str_id, ImGuiTreeNodeFlags flags, const(char)* fmt, va_list args);
    bool          TreeNodeExV(const(void)* ptr_id, ImGuiTreeNodeFlags flags, const(char)* fmt, va_list args);
    void          TreePush(const(char)* str_id);                                      // ~ Indent()+PushId(). Already called by TreeNode() when returning true, but you can call Push/Pop yourself for layout purpose
    void          TreePush(const(void)* ptr_id = null);                               // "
    void          TreePop();                                                          // ~ Unindent()+PopId()
    void          TreeAdvanceToLabelPos();                                            // advance cursor x position by GetTreeNodeToLabelSpacing()
    float         GetTreeNodeToLabelSpacing();                                        // horizontal distance preceding label when using TreeNode*() or Bullet() == (g.FontSize + style.FramePadding.x*2) for a regular unframed TreeNode
    void          SetNextTreeNodeOpen(bool is_open, ImGuiCond cond = 0);              // set next TreeNode/CollapsingHeader open state.
    bool          CollapsingHeader(const(char)* label, ImGuiTreeNodeFlags flags = 0); // if returning 'true' the header is open. doesn't indent nor push on ID stack. user doesn't have to call TreePop().
    bool          CollapsingHeader(const(char)* label, bool* p_open, ImGuiTreeNodeFlags flags = 0); // when 'p_open' isn't null, display an additional small close button on upper right of the header

    // Widgets: Selectable / Lists
    bool          Selectable(const(char)* label, bool selected = false, ImGuiSelectableFlags flags = 0, ref const(ImVec2) size = ImVec2.zero);  // "bool selected" carry the selection state (read-only). Selectable() is clicked is returns true so you can modify your selection state. size.x==0.0: use remaining width, size.x>0.0: specify width. size.y==0.0: use label height, size.y>0.0: specify height
    bool          Selectable(const(char)* label, bool* p_selected, ImGuiSelectableFlags flags = 0, ref const(ImVec2) size = ImVec2.zero);       // "bool* p_selected" point to the selection state (read-write), as a convenient helper.
    bool          ListBox(const(char)* label, int* current_item, const(char*)* items, int items_count, int height_in_items = -1);
    bool          ListBox(const(char)* label, int* current_item, bool function(void* data, int idx, const(char)** out_text) items_getter, void* data, int items_count, int height_in_items = -1);
    bool          ListBoxHeader(const(char)* label, ref const(ImVec2) size = ImVec2.zero); // use if you want to reimplement ListBox() will custom data or interactions. make sure to call ListBoxFooter() afterwards.
    bool          ListBoxHeader(const(char)* label, int items_count, int height_in_items = -1); // "
    void          ListBoxFooter();                                                    // terminate the scrolling region

    // Widgets: Value() Helpers. Output single value _in "name: value" format (tip: freely declare more _in your code to handle your types. you can add functions to the ImGui namespace)
    void          Value(const(char)* prefix, bool b);
    void          Value(const(char)* prefix, int v);
    void          Value(const(char)* prefix, uint v);
    void          Value(const(char)* prefix, float v, const(char)* float_format = null);

    // Tooltips
    void          SetTooltip(const(char)* fmt, ...);                                  // set text tooltip under mouse-cursor, typically use with ImGui::IsItemHovered(). overidde any previous call to SetTooltip().
    void          SetTooltipV(const(char)* fmt, va_list args);
    void          BeginTooltip();                                                     // begin/append a tooltip window. to create full-featured tooltip (with any kind of contents).
    void          EndTooltip();

    // Menus
    bool          BeginMainMenuBar();                                                 // create and append to a full screen menu-bar.
    void          EndMainMenuBar();                                                   // only call EndMainMenuBar() if BeginMainMenuBar() returns true!
    bool          BeginMenuBar();                                                     // append to menu-bar of current window (requires ImGuiWindowFlags_MenuBar flag set on parent window).
    void          EndMenuBar();                                                       // only call EndMenuBar() if BeginMenuBar() returns true!
    bool          BeginMenu(const(char)* label, bool enabled = true);                 // create a sub-menu entry. only call EndMenu() if this returns true!
    void          EndMenu();                                                          // only call EndMenu() if BeginMenu() returns true!
    bool          MenuItem(const(char)* label, const(char)* shortcut = null, bool selected = false, bool enabled = true);  // return true when activated. shortcuts are displayed for convenience but not processed by ImGui at the moment
    bool          MenuItem(const(char)* label, const(char)* shortcut, bool* p_selected, bool enabled = true);              // return true when activated + toggle (*p_selected) if p_selected != null

    // Popups
    void          OpenPopup(const(char)* str_id);                                     // call to mark popup as open (don't call every frame!). popups are closed when user click outside, or if CloseCurrentPopup() is called within a BeginPopup()/EndPopup() block. By default, Selectable()/MenuItem() are calling CloseCurrentPopup(). Popup identifiers are relative to the current ID-stack (so OpenPopup and BeginPopup needs to be at the same level).
    bool          BeginPopup(const(char)* str_id, ImGuiWindowFlags flags = 0);                                            // return true if the popup is open, and you can start outputting to it. only call EndPopup() if BeginPopup() returns true!
    bool          BeginPopupContextItem(const(char)* str_id = null, int mouse_button = 1);                                // helper to open and begin popup when clicked on last item. if you can pass a null str_id only if the previous item had an id. If you want to use that on a non-interactive item such as Text() you need to pass _in an explicit ID here. read comments _in .cpp!
    bool          BeginPopupContextWindow(const(char)* str_id = null, int mouse_button = 1, bool also_over_items = true); // helper to open and begin popup when clicked on current window.
    bool          BeginPopupContextVoid(const(char)* str_id = null, int mouse_button = 1);                                // helper to open and begin popup when clicked _in void (where there are no imgui windows).
    bool          BeginPopupModal(const(char)* name, bool* p_open = null, ImGuiWindowFlags flags = 0);                    // modal dialog (regular window with title bar, block interactions behind the modal window, can't close the modal window by clicking outside)
    void          EndPopup();                                                                                             // only call EndPopup() if BeginPopupXXX() returns true!
    bool          OpenPopupOnItemClick(const(char)* str_id = null, int mouse_button = 1);                                 // helper to open popup when clicked on last item. return true when just opened.
    bool          IsPopupOpen(const(char)* str_id);                                   // return true if the popup is open
    void          CloseCurrentPopup();                                                // close the popup we have begin-ed into. clicking on a MenuItem or Selectable automatically close the current popup.

    // Columns
    // You can also use SameLine(pos_x) for simplified columns. The columns API is still work-_in-progress and rather lacking.
    void          Columns(int count = 1, const(char)* id = null, bool border = true);
    void          NextColumn();                                                       // next column, defaults to current row or next row if the current row is finished
    int           GetColumnIndex();                                                   // get current column index
    float         GetColumnWidth(int column_index = -1);                              // get column width (_in pixels). pass -1 to use current column
    void          SetColumnWidth(int column_index, float width);                      // set column width (_in pixels). pass -1 to use current column
    float         GetColumnOffset(int column_index = -1);                             // get position of column line (_in pixels, from the left side of the contents region). pass -1 to use current column, otherwise 0..GetColumnsCount() inclusive. column 0 is typically 0.0f
    void          SetColumnOffset(int column_index, float offset_x);                  // set position of column line (_in pixels, from the left side of the contents region). pass -1 to use current column
    int           GetColumnsCount();

    // Logging/Capture: all text output from interface is captured to tty/file/clipboard. By default, tree nodes are automatically opened during logging.
    void          LogToTTY(int max_depth = -1);                                       // start logging to tty
    void          LogToFile(int max_depth = -1, const(char)* filename = null);        // start logging to file
    void          LogToClipboard(int max_depth = -1);                                 // start logging to OS clipboard
    void          LogFinish();                                                        // stop logging (close file, etc.)
    void          LogButtons();                                                       // helper to display buttons for logging to tty/file/clipboard
    void          LogText(const(char)* fmt, ...);                                     // pass text data straight to log (without being displayed)

    // Drag and Drop
    // [BETA API] Missing Demo code. API may evolve.
    bool          BeginDragDropSource(ImGuiDragDropFlags flags = 0);                                      // call when the current item is active. If this return true, you can call SetDragDropPayload() + EndDragDropSource()
    bool          SetDragDropPayload(const(char)* type, const(void)* data, size_t size, ImGuiCond cond = 0);// type is a user defined string of maximum 32 characters. Strings starting with '_' are reserved for dear imgui internal types. Data is copied and held by imgui.
    void          EndDragDropSource();                                                                    // only call EndDragDropSource() if BeginDragDropSource() returns true!
    bool          BeginDragDropTarget();                                                                  // call after submitting an item that may receive an item. If this returns true, you can call AcceptDragDropPayload() + EndDragDropTarget()
    const(ImGuiPayload)* AcceptDragDropPayload(const(char)* type, ImGuiDragDropFlags flags = 0);          // accept contents of a given type. If ImGuiDragDropFlags_AcceptBeforeDelivery is set you can peek into the payload before the mouse button is released.
    void          EndDragDropTarget();                                                                    // only call EndDragDropTarget() if BeginDragDropTarget() returns true!

    // Clipping
    void          PushClipRect(ref const(ImVec2) clip_rect_min, ref const(ImVec2) clip_rect_max, bool intersect_with_current_clip_rect);
    void          PopClipRect();

    // Focus, Activation
    // (Prefer using "SetItemDefaultFocus()" over "if (IsWindowAppearing()) SetScrollHere()" when applicable, to make your code more forward compatible when navigation branch is merged)
    void          SetItemDefaultFocus();                                              // make last item the default focused item of a window. Please use instead of "if (IsWindowAppearing()) SetScrollHere()" to signify "default item".
    void          SetKeyboardFocusHere(int offset = 0);                               // focus keyboard on the next widget. Use positive 'offset' to access sub components of a multiple component widget. Use -1 to access previous widget.

    // Utilities
    bool          IsItemHovered(ImGuiHoveredFlags flags = 0);                         // is the last item hovered? (and usable, aka not blocked by a popup, etc.). See ImGuiHoveredFlags for more options.
    bool          IsItemActive();                                                     // is the last item active? (e.g. button being held, text field being edited- items that don't interact will always return false)
    bool          IsItemFocused();                                                    // is the last item focused for keyboard/gamepad navigation?
    bool          IsItemClicked(int mouse_button = 0);                                // is the last item clicked? (e.g. button/node just clicked on)
    bool          IsItemVisible();                                                    // is the last item visible? (aka not out of sight due to clipping/scrolling.)
    bool          IsAnyItemHovered();
    bool          IsAnyItemActive();
    bool          IsAnyItemFocused();
    ImVec2        GetItemRectMin();                                                   // get bounding rectangle of last item, _in screen space
    ImVec2        GetItemRectMax();                                                   // "
    ImVec2        GetItemRectSize();                                                  // get size of last item, _in screen space
    void          SetItemAllowOverlap();                                              // allow last item to be overlapped by a subsequent item. sometimes useful with invisible buttons, selectables, etc. to catch unused area.
    bool          IsRectVisible(ref const(ImVec2) size);                              // test if rectangle (of given size, starting from cursor position) is visible / not clipped.
    bool          IsRectVisible(ref const(ImVec2) rect_min, ref const(ImVec2) rect_max);    // test if rectangle (_in screen space) is visible / not clipped. to perform coarse clipping on user's side.
    float         GetTime();
    int           GetFrameCount();
    ImDrawList*   GetOverlayDrawList();                                               // this draw list will be the last rendered one, useful to quickly draw overlays shapes/text
    ImDrawListSharedData* GetDrawListSharedData();                                    // you may use this when creating your own ImDrawList instances
    const(char)*  GetStyleColorName(ImGuiCol idx);
    void          SetStateStorage(ImGuiStorage* storage);                             // replace current window storage with our own (if you want to manipulate it yourself, typically clear subsection of it)
    ImGuiStorage* GetStateStorage();
    ImVec2        CalcTextSize(const(char)* text, const(char)* text_end = null, bool hide_text_after_double_hash = false, float wrap_width = -1.0f);
    void          CalcListClipping(int items_count, float items_height, int* out_items_display_start, int* out_items_display_end);    // calculate coarse clipping for large list of evenly sized items. Prefer using the ImGuiListClipper higher-level helper if you can.

    bool          BeginChildFrame(ImGuiID id, ref const(ImVec2) size, ImGuiWindowFlags flags = 0); // helper to create a child window / scrolling region that looks like a normal widget frame
    void          EndChildFrame();                                                    // always call EndChildFrame() regardless of BeginChildFrame() return values (which indicates a collapsed/clipped window)

    ImVec4        ColorConvertU32ToFloat4(ImU32 _in);
    ImU32         ColorConvertFloat4ToU32(ref const(ImVec4) _in);
    void          ColorConvertRGBtoHSV(float r, float g, float b, ref float out_h, ref float out_s, ref float out_v);
    void          ColorConvertHSVtoRGB(float h, float s, float v, ref float out_r, ref float out_g, ref float out_b);

    // Inputs
    int           GetKeyIndex(ImGuiKey imgui_key);                                    // map ImGuiKey_* values into user's key index. == io.KeyMap[key]
    bool          IsKeyDown(int user_key_index);                                      // is key being held. == io.KeysDown[user_key_index]. note that imgui doesn't know the semantic of each entry of io.KeyDown[]. Use your own indices/enums according to how your backend/engine stored them into KeyDown[]!
    bool          IsKeyPressed(int user_key_index, bool repeat = true);               // was key pressed (went from !Down to Down). if repeat=true, uses io.KeyRepeatDelay / KeyRepeatRate
    bool          IsKeyReleased(int user_key_index);                                  // was key released (went from Down to !Down)..
    int           GetKeyPressedAmount(int key_index, float repeat_delay, float rate); // uses provided repeat rate/delay. return a count, most often 0 or 1 but might be >1 if RepeatRate is small enough that DeltaTime > RepeatRate
    bool          IsMouseDown(int button);                                            // is mouse button held
    bool          IsAnyMouseDown();                                                   // is any mouse button held
    bool          IsMouseClicked(int button, bool repeat = false);                    // did mouse button clicked (went from !Down to Down)
    bool          IsMouseDoubleClicked(int button);                                   // did mouse button double-clicked. a double-click returns false _in IsMouseClicked(). uses io.MouseDoubleClickTime.
    bool          IsMouseReleased(int button);                                        // did mouse button released (went from Down to !Down)
    bool          IsMouseDragging(int button = 0, float lock_threshold = -1.0f);      // is mouse dragging. if lock_threshold < -1.0f uses io.MouseDraggingThreshold
    bool          IsMouseHoveringRect(ref const(ImVec2) r_min, ref const(ImVec2) r_max, bool clip = true);  // is mouse hovering given bounding rect (_in screen space). clipped by current clipping settings. disregarding of consideration of focus/window ordering/blocked by a popup.
    bool          IsMousePosValid(const(ImVec2)* mouse_pos = null);                   //
    ImVec2        GetMousePos();                                                      // shortcut to ImGui::GetIO().MousePos provided by user, to be consistent with other calls
    ImVec2        GetMousePosOnOpeningCurrentPopup();                                 // retrieve backup of mouse position at the time of opening popup we have BeginPopup() into
    ImVec2        GetMouseDragDelta(int button = 0, float lock_threshold = -1.0f);    // dragging amount since clicking. if lock_threshold < -1.0f uses io.MouseDraggingThreshold
    void          ResetMouseDragDelta(int button = 0);                                //
    ImGuiMouseCursor GetMouseCursor();                                                // get desired cursor type, reset _in ImGui::NewFrame(), this is updated during the frame. valid before Render(). If you use software rendering by setting io.MouseDrawCursor ImGui will render those for you
    void          SetMouseCursor(ImGuiMouseCursor type);                              // set desired cursor type
    void          CaptureKeyboardFromApp(bool capture = true);                        // manually override io.WantCaptureKeyboard flag next frame (said flag is entirely left for your application to handle). e.g. force capture keyboard when your widget is being hovered.
    void          CaptureMouseFromApp(bool capture = true);                           // manually override io.WantCaptureMouse flag next frame (said flag is entirely left for your application to handle).

    // Clipboard Utilities (also see the LogToClipboard() function to capture or output text data to the clipboard)
    const(char)*   GetClipboardText();
    void          SetClipboardText(const(char)* text);

    // Memory Utilities
    // All those functions are not reliant on the current context.
    // If you reload the contents of imgui.cpp at runtime, you may need to call SetCurrentContext() + SetAllocatorFunctions() again.
    void          SetAllocatorFunctions(void* function(size_t sz, void* user_data) alloc_func, void function(void* ptr, void* user_data) free_func, void* user_data = null);
    void*         MemAlloc(size_t size);
    void          MemFree(void* ptr);
}

// Flags for ImGui::Begin()
enum : ImGuiWindowFlags
{
    ImGuiWindowFlags_NoTitleBar             = 1 << 0,   // Disable title-bar
    ImGuiWindowFlags_NoResize               = 1 << 1,   // Disable user resizing with the lower-right grip
    ImGuiWindowFlags_NoMove                 = 1 << 2,   // Disable user moving the window
    ImGuiWindowFlags_NoScrollbar            = 1 << 3,   // Disable scrollbars (window can still scroll with mouse or programatically)
    ImGuiWindowFlags_NoScrollWithMouse      = 1 << 4,   // Disable user vertically scrolling with mouse wheel. On child window, mouse wheel will be forwarded to the parent unless NoScrollbar is also set.
    ImGuiWindowFlags_NoCollapse             = 1 << 5,   // Disable user collapsing window by double-clicking on it
    ImGuiWindowFlags_AlwaysAutoResize       = 1 << 6,   // Resize every window to its content every frame
    //ImGuiWindowFlags_ShowBorders          = 1 << 7,   // Show borders around windows and items (OBSOLETE! Use e.g. style.FrameBorderSize=1.0f to enable borders).
    ImGuiWindowFlags_NoSavedSettings        = 1 << 8,   // Never load/save settings in .ini file
    ImGuiWindowFlags_NoInputs               = 1 << 9,   // Disable catching mouse or keyboard inputs, hovering test with pass through.
    ImGuiWindowFlags_MenuBar                = 1 << 10,  // Has a menu-bar
    ImGuiWindowFlags_HorizontalScrollbar    = 1 << 11,  // Allow horizontal scrollbar to appear (off by default). You may use SetNextWindowContentSize(ImVec2(width,0.0f)); prior to calling Begin() to specify width. Read code in imgui_demo in the "Horizontal Scrolling" section.
    ImGuiWindowFlags_NoFocusOnAppearing     = 1 << 12,  // Disable taking focus when transitioning from hidden to visible state
    ImGuiWindowFlags_NoBringToFrontOnFocus  = 1 << 13,  // Disable bringing window to front when taking focus (e.g. clicking on it or programatically giving it focus)
    ImGuiWindowFlags_AlwaysVerticalScrollbar= 1 << 14,  // Always show vertical scrollbar (even if ContentSize.y < Size.y)
    ImGuiWindowFlags_AlwaysHorizontalScrollbar=1<< 15,  // Always show horizontal scrollbar (even if ContentSize.x < Size.x)
    ImGuiWindowFlags_AlwaysUseWindowPadding = 1 << 16,  // Ensure child windows without border uses style.WindowPadding (ignored by default for non-bordered child windows, because more convenient)
    ImGuiWindowFlags_ResizeFromAnySide      = 1 << 17,  // [BETA] Enable resize from any corners and borders. Your back-end needs to honor the different values of io.MouseCursor set by imgui.
    ImGuiWindowFlags_NoNavInputs            = 1 << 18,  // No gamepad/keyboard navigation within the window
    ImGuiWindowFlags_NoNavFocus             = 1 << 19,  // No focusing toward this window with gamepad/keyboard navigation (e.g. skipped by CTRL+TAB)
    ImGuiWindowFlags_NoNav                  = ImGuiWindowFlags_NoNavInputs | ImGuiWindowFlags_NoNavFocus,

    // [Internal]
    ImGuiWindowFlags_NavFlattened           = 1 << 23,  // [BETA] Allow gamepad/keyboard navigation to cross over parent border to this child (only use on child that have no scrolling!)
    ImGuiWindowFlags_ChildWindow            = 1 << 24,  // Don't use! For internal use by BeginChild()
    ImGuiWindowFlags_Tooltip                = 1 << 25,  // Don't use! For internal use by BeginTooltip()
    ImGuiWindowFlags_Popup                  = 1 << 26,  // Don't use! For internal use by BeginPopup()
    ImGuiWindowFlags_Modal                  = 1 << 27,  // Don't use! For internal use by BeginPopupModal()
    ImGuiWindowFlags_ChildMenu              = 1 << 28   // Don't use! For internal use by BeginMenu()
}

// Flags for ImGui::InputText()
enum : ImGuiInputTextFlags
{
    ImGuiInputTextFlags_CharsDecimal        = 1 << 0,   // Allow 0123456789.+-*/
    ImGuiInputTextFlags_CharsHexadecimal    = 1 << 1,   // Allow 0123456789ABCDEFabcdef
    ImGuiInputTextFlags_CharsUppercase      = 1 << 2,   // Turn a..z into A..Z
    ImGuiInputTextFlags_CharsNoBlank        = 1 << 3,   // Filter out spaces, tabs
    ImGuiInputTextFlags_AutoSelectAll       = 1 << 4,   // Select entire text when first taking mouse focus
    ImGuiInputTextFlags_EnterReturnsTrue    = 1 << 5,   // Return 'true' when Enter is pressed (as opposed to when the value was modified)
    ImGuiInputTextFlags_CallbackCompletion  = 1 << 6,   // Call user function on pressing TAB (for completion handling)
    ImGuiInputTextFlags_CallbackHistory     = 1 << 7,   // Call user function on pressing Up/Down arrows (for history handling)
    ImGuiInputTextFlags_CallbackAlways      = 1 << 8,   // Call user function every time. User code may query cursor position, modify text buffer.
    ImGuiInputTextFlags_CallbackCharFilter  = 1 << 9,   // Call user function to filter character. Modify data->EventChar to replace/filter input, or return 1 to discard character.
    ImGuiInputTextFlags_AllowTabInput       = 1 << 10,  // Pressing TAB input a '\t' character into the text field
    ImGuiInputTextFlags_CtrlEnterForNewLine = 1 << 11,  // In multi-line mode, unfocus with Enter, add new line with Ctrl+Enter (default is opposite: unfocus with Ctrl+Enter, add line with Enter).
    ImGuiInputTextFlags_NoHorizontalScroll  = 1 << 12,  // Disable following the cursor horizontally
    ImGuiInputTextFlags_AlwaysInsertMode    = 1 << 13,  // Insert mode
    ImGuiInputTextFlags_ReadOnly            = 1 << 14,  // Read-only mode
    ImGuiInputTextFlags_Password            = 1 << 15,  // Password mode, display all characters as '*'
    ImGuiInputTextFlags_NoUndoRedo          = 1 << 16,  // Disable undo/redo. Note that input text owns the text data while active, if you want to provide your own undo/redo stack you need e.g. to call ClearActiveID().
    ImGuiInputTextFlags_CharsScientific     = 1 << 17,  // Allow 0123456789.+-*/eE (Scientific notation input)
    // [Internal]
    ImGuiInputTextFlags_Multiline           = 1 << 20   // For internal use by InputTextMultiline()
}

// Flags for ImGui::TreeNodeEx(), ImGui::CollapsingHeader*()
enum : ImGuiTreeNodeFlags
{
    ImGuiTreeNodeFlags_Selected             = 1 << 0,   // Draw as selected
    ImGuiTreeNodeFlags_Framed               = 1 << 1,   // Full colored frame (e.g. for CollapsingHeader)
    ImGuiTreeNodeFlags_AllowItemOverlap     = 1 << 2,   // Hit testing to allow subsequent widgets to overlap this one
    ImGuiTreeNodeFlags_NoTreePushOnOpen     = 1 << 3,   // Don't do a TreePush() when open (e.g. for CollapsingHeader) = no extra indent nor pushing on ID stack
    ImGuiTreeNodeFlags_NoAutoOpenOnLog      = 1 << 4,   // Don't automatically and temporarily open node when Logging is active (by default logging will automatically open tree nodes)
    ImGuiTreeNodeFlags_DefaultOpen          = 1 << 5,   // Default node to be open
    ImGuiTreeNodeFlags_OpenOnDoubleClick    = 1 << 6,   // Need double-click to open node
    ImGuiTreeNodeFlags_OpenOnArrow          = 1 << 7,   // Only open when clicking on the arrow part. If ImGuiTreeNodeFlags_OpenOnDoubleClick is also set, single-click arrow or double-click all box to open.
    ImGuiTreeNodeFlags_Leaf                 = 1 << 8,   // No collapsing, no arrow (use as a convenience for leaf nodes). 
    ImGuiTreeNodeFlags_Bullet               = 1 << 9,   // Display a bullet instead of arrow
    ImGuiTreeNodeFlags_FramePadding         = 1 << 10,  // Use FramePadding (even for an unframed text node) to vertically align text baseline to regular widget height. Equivalent to calling AlignTextToFramePadding().
    //ImGuITreeNodeFlags_SpanAllAvailWidth  = 1 << 11,  // FIXME: TODO: Extend hit box horizontally even if not framed
    //ImGuiTreeNodeFlags_NoScrollOnOpen     = 1 << 12,  // FIXME: TODO: Disable automatic scroll on TreePop() if node got just open and contents is not visible
    ImGuiTreeNodeFlags_NavLeftJumpsBackHere = 1 << 13,  // (WIP) Nav: left direction may move to this TreeNode() from any of its child (items submitted between TreeNode and TreePop)
    ImGuiTreeNodeFlags_CollapsingHeader     = ImGuiTreeNodeFlags_Framed | ImGuiTreeNodeFlags_NoAutoOpenOnLog
}

// Flags for ImGui::Selectable()
enum : ImGuiSelectableFlags
{
    ImGuiSelectableFlags_DontClosePopups    = 1 << 0,   // Clicking this don't close parent popup window
    ImGuiSelectableFlags_SpanAllColumns     = 1 << 1,   // Selectable frame can span all columns (text will still fit in current column)
    ImGuiSelectableFlags_AllowDoubleClick   = 1 << 2    // Generate press events on double clicks too
}

// Flags for ImGui::BeginCombo()
enum : ImGuiComboFlags
{
    ImGuiComboFlags_PopupAlignLeft          = 1 << 0,   // Align the popup toward the left by default
    ImGuiComboFlags_HeightSmall             = 1 << 1,   // Max ~4 items visible. Tip: If you want your combo popup to be a specific size you can use SetNextWindowSizeConstraints() prior to calling BeginCombo()
    ImGuiComboFlags_HeightRegular           = 1 << 2,   // Max ~8 items visible (default)
    ImGuiComboFlags_HeightLarge             = 1 << 3,   // Max ~20 items visible
    ImGuiComboFlags_HeightLargest           = 1 << 4,   // As many fitting items as possible
    ImGuiComboFlags_NoArrowButton           = 1 << 5,   // Display on the preview box without the square arrow button
    ImGuiComboFlags_NoPreview               = 1 << 6,   // Display only a square arrow button
    ImGuiComboFlags_HeightMask_             = ImGuiComboFlags_HeightSmall | ImGuiComboFlags_HeightRegular | ImGuiComboFlags_HeightLarge | ImGuiComboFlags_HeightLargest
}

// Flags for ImGui::IsWindowFocused()
enum : ImGuiFocusedFlags
{
    ImGuiFocusedFlags_ChildWindows                  = 1 << 0,   // IsWindowFocused(): Return true if any children of the window is focused
    ImGuiFocusedFlags_RootWindow                    = 1 << 1,   // IsWindowFocused(): Test from root window (top most parent of the current hierarchy)
    ImGuiFocusedFlags_AnyWindow                     = 1 << 2,   // IsWindowFocused(): Return true if any window is focused
    ImGuiFocusedFlags_RootAndChildWindows           = ImGuiFocusedFlags_RootWindow | ImGuiFocusedFlags_ChildWindows
}

// Flags for ImGui::IsItemHovered(), ImGui::IsWindowHovered()
// Note: If you are trying to check whether your mouse should be dispatched to imgui or to your app, you should use the 'io.WantCaptureMouse' boolean for that. Please read the FAQ!
enum : ImGuiHoveredFlags
{
    ImGuiHoveredFlags_Default                       = 0,        // Return true if directly over the item/window, not obstructed by another window, not obstructed by an active popup or modal blocking inputs under them.
    ImGuiHoveredFlags_ChildWindows                  = 1 << 0,   // IsWindowHovered() only: Return true if any children of the window is hovered
    ImGuiHoveredFlags_RootWindow                    = 1 << 1,   // IsWindowHovered() only: Test from root window (top most parent of the current hierarchy)
    ImGuiHoveredFlags_AnyWindow                     = 1 << 2,   // IsWindowHovered() only: Return true if any window is hovered
    ImGuiHoveredFlags_AllowWhenBlockedByPopup       = 1 << 3,   // Return true even if a popup window is normally blocking access to this item/window
    //ImGuiHoveredFlags_AllowWhenBlockedByModal     = 1 << 4,   // Return true even if a modal popup window is normally blocking access to this item/window. FIXME-TODO: Unavailable yet.
    ImGuiHoveredFlags_AllowWhenBlockedByActiveItem  = 1 << 5,   // Return true even if an active item is blocking access to this item/window. Useful for Drag and Drop patterns.
    ImGuiHoveredFlags_AllowWhenOverlapped           = 1 << 6,   // Return true even if the position is overlapped by another window
    ImGuiHoveredFlags_RectOnly                      = ImGuiHoveredFlags_AllowWhenBlockedByPopup | ImGuiHoveredFlags_AllowWhenBlockedByActiveItem | ImGuiHoveredFlags_AllowWhenOverlapped,
    ImGuiHoveredFlags_RootAndChildWindows           = ImGuiHoveredFlags_RootWindow | ImGuiHoveredFlags_ChildWindows
}

// Flags for ImGui::BeginDragDropSource(), ImGui::AcceptDragDropPayload()
enum : ImGuiDragDropFlags
{
    // BeginDragDropSource() flags
    ImGuiDragDropFlags_SourceNoPreviewTooltip       = 1 << 0,   // By default, a successful call to BeginDragDropSource opens a tooltip so you can display a preview or description of the source contents. This flag disable this behavior.
    ImGuiDragDropFlags_SourceNoDisableHover         = 1 << 1,   // By default, when dragging we clear data so that IsItemHovered() will return true, to avoid subsequent user code submitting tooltips. This flag disable this behavior so you can still call IsItemHovered() on the source item.
    ImGuiDragDropFlags_SourceNoHoldToOpenOthers     = 1 << 2,   // Disable the behavior that allows to open tree nodes and collapsing header by holding over them while dragging a source item.
    ImGuiDragDropFlags_SourceAllowNullID            = 1 << 3,   // Allow items such as Text(), Image() that have no unique identifier to be used as drag source, by manufacturing a temporary identifier based on their window-relative position. This is extremely unusual within the dear imgui ecosystem and so we made it explicit.
    ImGuiDragDropFlags_SourceExtern                 = 1 << 4,   // External source (from outside of imgui), won't attempt to read current item/window info. Will always return true. Only one Extern source can be active simultaneously.
    // AcceptDragDropPayload() flags
    ImGuiDragDropFlags_AcceptBeforeDelivery         = 1 << 10,  // AcceptDragDropPayload() will returns true even before the mouse button is released. You can then call IsDelivery() to test if the payload needs to be delivered.
    ImGuiDragDropFlags_AcceptNoDrawDefaultRect      = 1 << 11,  // Do not draw the default highlight rectangle when hovering over target.
    ImGuiDragDropFlags_AcceptPeekOnly               = ImGuiDragDropFlags_AcceptBeforeDelivery | ImGuiDragDropFlags_AcceptNoDrawDefaultRect  // For peeking ahead and inspecting the payload before delivery.
}

// A cardinal direction
enum : ImGuiDir
{
    ImGuiDir_None    = -1,
    ImGuiDir_Left    = 0,
    ImGuiDir_Right   = 1,
    ImGuiDir_Up      = 2,
    ImGuiDir_Down    = 3,
    ImGuiDir_COUNT
}

// User fill ImGuiIO.KeyMap[] array with indices into the ImGuiIO.KeysDown[512] array
enum : ImGuiKey
{
    ImGuiKey_Tab,
    ImGuiKey_LeftArrow,
    ImGuiKey_RightArrow,
    ImGuiKey_UpArrow,
    ImGuiKey_DownArrow,
    ImGuiKey_PageUp,
    ImGuiKey_PageDown,
    ImGuiKey_Home,
    ImGuiKey_End,
    ImGuiKey_Insert,
    ImGuiKey_Delete,
    ImGuiKey_Backspace,
    ImGuiKey_Space,
    ImGuiKey_Enter,
    ImGuiKey_Escape,
    ImGuiKey_A,         // for text edit CTRL+A: select all
    ImGuiKey_C,         // for text edit CTRL+C: copy
    ImGuiKey_V,         // for text edit CTRL+V: paste
    ImGuiKey_X,         // for text edit CTRL+X: cut
    ImGuiKey_Y,         // for text edit CTRL+Y: redo
    ImGuiKey_Z,         // for text edit CTRL+Z: undo
    ImGuiKey_COUNT
}

// [BETA] Gamepad/Keyboard directional navigation
// Keyboard: Set io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard to enable. NewFrame() will automatically fill io.NavInputs[] based on your io.KeyDown[] + io.KeyMap[] arrays.
// Gamepad:  Set io.ConfigFlags |= ImGuiConfigFlags_NavEnableGamepad to enable. Back-end: set ImGuiBackendFlags_HasGamepad and fill the io.NavInputs[] fields before calling NewFrame(). Note that io.NavInputs[] is cleared by EndFrame().
// Read instructions in imgui.cpp for more details. Download PNG/PSD at goo.gl/9LgVZW.
enum : ImGuiNavInput
{
    // Gamepad Mapping
    ImGuiNavInput_Activate,      // activate / open / toggle / tweak value       // e.g. Cross  (PS4), A (Xbox), A (Switch), Space (Keyboard)
    ImGuiNavInput_Cancel,        // cancel / close / exit                        // e.g. Circle (PS4), B (Xbox), B (Switch), Escape (Keyboard)
    ImGuiNavInput_Input,         // text input / on-screen keyboard              // e.g. Triang.(PS4), Y (Xbox), X (Switch), Return (Keyboard)
    ImGuiNavInput_Menu,          // tap: toggle menu / hold: focus, move, resize // e.g. Square (PS4), X (Xbox), Y (Switch), Alt (Keyboard)
    ImGuiNavInput_DpadLeft,      // move / tweak / resize window (w/ PadMenu)    // e.g. D-pad Left/Right/Up/Down (Gamepads), Arrow keys (Keyboard)
    ImGuiNavInput_DpadRight,     // 
    ImGuiNavInput_DpadUp,        // 
    ImGuiNavInput_DpadDown,      // 
    ImGuiNavInput_LStickLeft,    // scroll / move window (w/ PadMenu)            // e.g. Left Analog Stick Left/Right/Up/Down
    ImGuiNavInput_LStickRight,   // 
    ImGuiNavInput_LStickUp,      // 
    ImGuiNavInput_LStickDown,    // 
    ImGuiNavInput_FocusPrev,     // next window (w/ PadMenu)                     // e.g. L1 or L2 (PS4), LB or LT (Xbox), L or ZL (Switch)
    ImGuiNavInput_FocusNext,     // prev window (w/ PadMenu)                     // e.g. R1 or R2 (PS4), RB or RT (Xbox), R or ZL (Switch) 
    ImGuiNavInput_TweakSlow,     // slower tweaks                                // e.g. L1 or L2 (PS4), LB or LT (Xbox), L or ZL (Switch)
    ImGuiNavInput_TweakFast,     // faster tweaks                                // e.g. R1 or R2 (PS4), RB or RT (Xbox), R or ZL (Switch)

    // [Internal] Don't use directly! This is used internally to differentiate keyboard from gamepad inputs for behaviors that require to differentiate them.
    // Keyboard behavior that have no corresponding gamepad mapping (e.g. CTRL+TAB) will be directly reading from io.KeyDown[] instead of io.NavInputs[].
    ImGuiNavInput_KeyMenu_,      // toggle menu                                  // = io.KeyAlt
    ImGuiNavInput_KeyLeft_,      // move left                                    // = Arrow keys
    ImGuiNavInput_KeyRight_,     // move right
    ImGuiNavInput_KeyUp_,        // move up
    ImGuiNavInput_KeyDown_,      // move down
    ImGuiNavInput_COUNT,
    ImGuiNavInput_InternalStart_ = ImGuiNavInput_KeyMenu_
}

// Configuration flags stored in io.ConfigFlags. Set by user/application.
enum : ImGuiConfigFlags
{
    ImGuiConfigFlags_NavEnableKeyboard      = 1 << 0,   // Master keyboard navigation enable flag. NewFrame() will automatically fill io.NavInputs[] based on io.KeyDown[].
    ImGuiConfigFlags_NavEnableGamepad       = 1 << 1,   // Master gamepad navigation enable flag. This is mostly to instruct your imgui back-end to fill io.NavInputs[]. Back-end also needs to set ImGuiBackendFlags_HasGamepad.
    ImGuiConfigFlags_NavEnableSetMousePos   = 1 << 2,   // Instruct navigation to move the mouse cursor. May be useful on TV/console systems where moving a virtual mouse is awkward. Will update io.MousePos and set io.WantSetMousePos=true. If enabled you MUST honor io.WantSetMousePos requests in your binding, otherwise ImGui will react as if the mouse is jumping around back and forth.
    ImGuiConfigFlags_NavNoCaptureKeyboard   = 1 << 3,   // Instruct navigation to not set the io.WantCaptureKeyboard flag with io.NavActive is set. 
    ImGuiConfigFlags_NoMouse                = 1 << 4,   // Instruct imgui to clear mouse position/buttons in NewFrame(). This allows ignoring the mouse information back-end
    ImGuiConfigFlags_NoMouseCursorChange    = 1 << 5,   // Instruct back-end to not alter mouse cursor shape and visibility.

    // User storage (to allow your back-end/engine to communicate to code that may be shared between multiple projects. Those flags are not used by core ImGui)
    ImGuiConfigFlags_IsSRGB                 = 1 << 20,  // Application is SRGB-aware.
    ImGuiConfigFlags_IsTouchScreen          = 1 << 21   // Application is using a touch screen instead of a mouse.
}

// Back-end capabilities flags stored in io.BackendFlags. Set by imgui_impl_xxx or custom back-end.
enum : ImGuiBackendFlags
{
    ImGuiBackendFlags_HasGamepad            = 1 << 0,   // Back-end has a connected gamepad.
    ImGuiBackendFlags_HasMouseCursors       = 1 << 1,   // Back-end can honor GetMouseCursor() values and change the OS cursor shape.
    ImGuiBackendFlags_HasSetMousePos        = 1 << 2    // Back-end can honor io.WantSetMousePos and reposition the mouse (only used if ImGuiConfigFlags_NavEnableSetMousePos is set).
}

// Enumeration for PushStyleColor() / PopStyleColor()
enum : ImGuiCol
{
    ImGuiCol_Text,
    ImGuiCol_TextDisabled,
    ImGuiCol_WindowBg,              // Background of normal windows
    ImGuiCol_ChildBg,               // Background of child windows
    ImGuiCol_PopupBg,               // Background of popups, menus, tooltips windows
    ImGuiCol_Border,
    ImGuiCol_BorderShadow,
    ImGuiCol_FrameBg,               // Background of checkbox, radio button, plot, slider, text input
    ImGuiCol_FrameBgHovered,
    ImGuiCol_FrameBgActive,
    ImGuiCol_TitleBg,
    ImGuiCol_TitleBgActive,
    ImGuiCol_TitleBgCollapsed,
    ImGuiCol_MenuBarBg,
    ImGuiCol_ScrollbarBg,
    ImGuiCol_ScrollbarGrab,
    ImGuiCol_ScrollbarGrabHovered,
    ImGuiCol_ScrollbarGrabActive,
    ImGuiCol_CheckMark,
    ImGuiCol_SliderGrab,
    ImGuiCol_SliderGrabActive,
    ImGuiCol_Button,
    ImGuiCol_ButtonHovered,
    ImGuiCol_ButtonActive,
    ImGuiCol_Header,
    ImGuiCol_HeaderHovered,
    ImGuiCol_HeaderActive,
    ImGuiCol_Separator,
    ImGuiCol_SeparatorHovered,
    ImGuiCol_SeparatorActive,
    ImGuiCol_ResizeGrip,
    ImGuiCol_ResizeGripHovered,
    ImGuiCol_ResizeGripActive,
    ImGuiCol_PlotLines,
    ImGuiCol_PlotLinesHovered,
    ImGuiCol_PlotHistogram,
    ImGuiCol_PlotHistogramHovered,
    ImGuiCol_TextSelectedBg,
    ImGuiCol_ModalWindowDarkening,  // darken/colorize entire screen behind a modal window, when one is active
    ImGuiCol_DragDropTarget,
    ImGuiCol_NavHighlight,          // gamepad/keyboard: current highlighted item 
    ImGuiCol_NavWindowingHighlight, // gamepad/keyboard: when holding NavMenu to focus/move/resize windows
    ImGuiCol_COUNT
}

// Enumeration for PushStyleVar() / PopStyleVar() to temporarily modify the ImGuiStyle structure.
// NB: the enum only refers to fields of ImGuiStyle which makes sense to be pushed/popped inside UI code. During initialization, feel free to just poke into ImGuiStyle directly.
// NB: if changing this enum, you need to update the associated internal table GStyleVarInfo[] accordingly. This is where we link enum values to members offset/type.
enum : ImGuiStyleVar
{
    // Enum name ......................// Member in ImGuiStyle structure (see ImGuiStyle for descriptions)
    ImGuiStyleVar_Alpha,               // float     Alpha
    ImGuiStyleVar_WindowPadding,       // ImVec2    WindowPadding
    ImGuiStyleVar_WindowRounding,      // float     WindowRounding
    ImGuiStyleVar_WindowBorderSize,    // float     WindowBorderSize
    ImGuiStyleVar_WindowMinSize,       // ImVec2    WindowMinSize
    ImGuiStyleVar_WindowTitleAlign,    // ImVec2    WindowTitleAlign
    ImGuiStyleVar_ChildRounding,       // float     ChildRounding
    ImGuiStyleVar_ChildBorderSize,     // float     ChildBorderSize
    ImGuiStyleVar_PopupRounding,       // float     PopupRounding
    ImGuiStyleVar_PopupBorderSize,     // float     PopupBorderSize
    ImGuiStyleVar_FramePadding,        // ImVec2    FramePadding
    ImGuiStyleVar_FrameRounding,       // float     FrameRounding
    ImGuiStyleVar_FrameBorderSize,     // float     FrameBorderSize
    ImGuiStyleVar_ItemSpacing,         // ImVec2    ItemSpacing
    ImGuiStyleVar_ItemInnerSpacing,    // ImVec2    ItemInnerSpacing
    ImGuiStyleVar_IndentSpacing,       // float     IndentSpacing
    ImGuiStyleVar_ScrollbarSize,       // float     ScrollbarSize
    ImGuiStyleVar_ScrollbarRounding,   // float     ScrollbarRounding
    ImGuiStyleVar_GrabMinSize,         // float     GrabMinSize
    ImGuiStyleVar_GrabRounding,        // float     GrabRounding
    ImGuiStyleVar_ButtonTextAlign,     // ImVec2    ButtonTextAlign
    ImGuiStyleVar_COUNT
}

// Enumeration for ColorEdit3() / ColorEdit4() / ColorPicker3() / ColorPicker4() / ColorButton()
enum : ImGuiColorEditFlags
{
    ImGuiColorEditFlags_NoAlpha         = 1 << 1,   //              // ColorEdit, ColorPicker, ColorButton: ignore Alpha component (read 3 components from the input pointer).
    ImGuiColorEditFlags_NoPicker        = 1 << 2,   //              // ColorEdit: disable picker when clicking on colored square.
    ImGuiColorEditFlags_NoOptions       = 1 << 3,   //              // ColorEdit: disable toggling options menu when right-clicking on inputs/small preview.
    ImGuiColorEditFlags_NoSmallPreview  = 1 << 4,   //              // ColorEdit, ColorPicker: disable colored square preview next to the inputs. (e.g. to show only the inputs)
    ImGuiColorEditFlags_NoInputs        = 1 << 5,   //              // ColorEdit, ColorPicker: disable inputs sliders/text widgets (e.g. to show only the small preview colored square).
    ImGuiColorEditFlags_NoTooltip       = 1 << 6,   //              // ColorEdit, ColorPicker, ColorButton: disable tooltip when hovering the preview.
    ImGuiColorEditFlags_NoLabel         = 1 << 7,   //              // ColorEdit, ColorPicker: disable display of inline text label (the label is still forwarded to the tooltip and picker).
    ImGuiColorEditFlags_NoSidePreview   = 1 << 8,   //              // ColorPicker: disable bigger color preview on right side of the picker, use small colored square preview instead.

    // User Options (right-click on widget to change some of them). You can set application defaults using SetColorEditOptions(). The idea is that you probably don't want to override them in most of your calls, let the user choose and/or call SetColorEditOptions() during startup.
    ImGuiColorEditFlags_AlphaBar        = 1 << 9,   //              // ColorEdit, ColorPicker: show vertical alpha bar/gradient in picker.
    ImGuiColorEditFlags_AlphaPreview    = 1 << 10,  //              // ColorEdit, ColorPicker, ColorButton: display preview as a transparent color over a checkerboard, instead of opaque.
    ImGuiColorEditFlags_AlphaPreviewHalf= 1 << 11,  //              // ColorEdit, ColorPicker, ColorButton: display half opaque / half checkerboard, instead of opaque.
    ImGuiColorEditFlags_HDR             = 1 << 12,  //              // (WIP) ColorEdit: Currently only disable 0.0f..1.0f limits in RGBA edition (note: you probably want to use ImGuiColorEditFlags_Float flag as well).
    ImGuiColorEditFlags_RGB             = 1 << 13,  // [Inputs]     // ColorEdit: choose one among RGB/HSV/HEX. ColorPicker: choose any combination using RGB/HSV/HEX.
    ImGuiColorEditFlags_HSV             = 1 << 14,  // [Inputs]     // "
    ImGuiColorEditFlags_HEX             = 1 << 15,  // [Inputs]     // "
    ImGuiColorEditFlags_Uint8           = 1 << 16,  // [DataType]   // ColorEdit, ColorPicker, ColorButton: _display_ values formatted as 0..255. 
    ImGuiColorEditFlags_Float           = 1 << 17,  // [DataType]   // ColorEdit, ColorPicker, ColorButton: _display_ values formatted as 0.0f..1.0f floats instead of 0..255 integers. No round-trip of value via integers.
    ImGuiColorEditFlags_PickerHueBar    = 1 << 18,  // [PickerMode] // ColorPicker: bar for Hue, rectangle for Sat/Value.
    ImGuiColorEditFlags_PickerHueWheel  = 1 << 19,  // [PickerMode] // ColorPicker: wheel for Hue, triangle for Sat/Value.

    // [Internal] Masks
    ImGuiColorEditFlags__InputsMask     = ImGuiColorEditFlags_RGB|ImGuiColorEditFlags_HSV|ImGuiColorEditFlags_HEX,
    ImGuiColorEditFlags__DataTypeMask   = ImGuiColorEditFlags_Uint8|ImGuiColorEditFlags_Float,
    ImGuiColorEditFlags__PickerMask     = ImGuiColorEditFlags_PickerHueWheel|ImGuiColorEditFlags_PickerHueBar,
    ImGuiColorEditFlags__OptionsDefault = ImGuiColorEditFlags_Uint8|ImGuiColorEditFlags_RGB|ImGuiColorEditFlags_PickerHueBar    // Change application default using SetColorEditOptions()
}

// Enumeration for GetMouseCursor()
// User code may request binding to display given cursor by calling SetMouseCursor(), which is why we have some cursors that are marked unused here
enum : ImGuiMouseCursor
{
    ImGuiMouseCursor_None = -1,
    ImGuiMouseCursor_Arrow = 0,
    ImGuiMouseCursor_TextInput,         // When hovering over InputText, etc.
    ImGuiMouseCursor_ResizeAll,         // Unused by imgui functions
    ImGuiMouseCursor_ResizeNS,          // When hovering over an horizontal border
    ImGuiMouseCursor_ResizeEW,          // When hovering over a vertical border or a column
    ImGuiMouseCursor_ResizeNESW,        // When hovering over the bottom-left corner of a window
    ImGuiMouseCursor_ResizeNWSE,        // When hovering over the bottom-right corner of a window
    ImGuiMouseCursor_COUNT
}

// Condition for ImGui::SetWindow***(), SetNextWindow***(), SetNextTreeNode***() functions
// Important: Treat as a regular enum! Do NOT combine multiple values using binary operators! All the functions above treat 0 as a shortcut to ImGuiCond_Always. 
enum : ImGuiCond
{
    ImGuiCond_Always        = 1 << 0,   // Set the variable
    ImGuiCond_Once          = 1 << 1,   // Set the variable once per runtime session (only the first call with succeed)
    ImGuiCond_FirstUseEver  = 1 << 2,   // Set the variable if the object/window has no persistently saved data (no entry in .ini file)
    ImGuiCond_Appearing     = 1 << 3    // Set the variable if the object/window is appearing after being hidden/inactive (or the first time)
}

// You may modify the ImGui::GetStyle() main instance during initialization and before NewFrame().
// During the frame, use ImGui::PushStyleVar(ImGuiStyleVar_XXXX)/PopStyleVar() to alter the main style values, and ImGui::PushStyleColor(ImGuiCol_XXX)/PopStyleColor() for colors.
struct ImGuiStyle
{
    float       Alpha=1;                    // Global alpha applies to everything _in ImGui.
    ImVec2      WindowPadding=ImVec2(8,8);  // Padding within a window.
    float       WindowRounding=7;           // Radius of window corners rounding. Set to 0.0f to have rectangular windows.
    float       WindowBorderSize=1;         // Thickness of border around windows. Generally set to 0.0f or 1.0f. (Other values are not well tested and more CPU/GPU costly).
    ImVec2      WindowMinSize=ImVec2(32,32);    // Minimum window size. This is a global setting. If you want to constraint individual windows, use SetNextWindowSizeConstraints().
    ImVec2      WindowTitleAlign=ImVec2(0,0.5); // Alignment for title bar text. Defaults to (0.0f,0.5f) for left-aligned,vertically centered.
    float       ChildRounding=0;            // Radius of child window corners rounding. Set to 0.0f to have rectangular windows.
    float       ChildBorderSize=1;          // Thickness of border around child windows. Generally set to 0.0f or 1.0f. (Other values are not well tested and more CPU/GPU costly).
    float       PopupRounding=0;            // Radius of popup window corners rounding. (Note that tooltip windows use WindowRounding)
    float       PopupBorderSize=1;          // Thickness of border around popup/tooltip windows. Generally set to 0.0f or 1.0f. (Other values are not well tested and more CPU/GPU costly).
    ImVec2      FramePadding=ImVec2(4,3);   // Padding within a framed rectangle (used by most widgets).
    float       FrameRounding=0;            // Radius of frame corners rounding. Set to 0.0f to have rectangular frame (used by most widgets).
    float       FrameBorderSize=0;          // Thickness of border around frames. Generally set to 0.0f or 1.0f. (Other values are not well tested and more CPU/GPU costly).
    ImVec2      ItemSpacing=ImVec2(8,4);    // Horizontal and vertical spacing between widgets/lines.
    ImVec2      ItemInnerSpacing=ImVec2(4,4);   // Horizontal and vertical spacing between within elements of a composed widget (e.g. a slider and its label).
    ImVec2      TouchExtraPadding=ImVec2.zero;  // Expand reactive bounding box for touch-based system where touch position is not accurate enough. Unfortunately we don't sort widgets so priority on overlap will always be given to the first widget. So don't grow this too much!
    float       IndentSpacing=21;           // Horizontal indentation when e.g. entering a tree node. Generally == (FontSize + FramePadding.x*2).
    float       ColumnsMinSpacing=6;        // Minimum horizontal spacing between two columns.
    float       ScrollbarSize=16;           // Width of the vertical scrollbar, Height of the horizontal scrollbar.
    float       ScrollbarRounding=9;        // Radius of grab corners for scrollbar.
    float       GrabMinSize=10;             // Minimum width/height of a grab box for slider/scrollbar.
    float       GrabRounding=0;             // Radius of grabs corners rounding. Set to 0.0f to have rectangular slider grabs.
    ImVec2      ButtonTextAlign=ImVec2(0.5,0.5);    // Alignment of button text when button is larger than text. Defaults to (0.5f,0.5f) for horizontally+vertically centered.
    ImVec2      DisplayWindowPadding=ImVec2(22,22); // Window positions are clamped to be visible within the display area by at least this amount. Only covers regular windows.
    ImVec2      DisplaySafeAreaPadding=ImVec2(4,4); // If you cannot see the edge of your screen (e.g. on a TV) increase the safe area padding. Covers popups/tooltips as well regular windows.
    float       MouseCursorScale=1;         // Scale software rendered mouse cursor (when io.MouseDrawCursor is enabled). May be removed later.
    bool        AntiAliasedLines=true;      // Enable anti-aliasing on lines/borders. Disable if you are really tight on CPU/GPU.
    bool        AntiAliasedFill=true;       // Enable anti-aliasing on filled shapes (rounded rectangles, circles, etc.)
    float       CurveTessellationTol=1.25;  // Tessellation tolerance when using PathBezierCurveTo() without a specific number of segments. Decrease for highly tessellated curves (higher quality, more polygons), increase to reduce quality.
    ImVec4[ImGuiCol_COUNT]  Colors = StyleColorsDark;

    void ScaleAllSizes(float scale_factor);
}

// This is where your app communicate with ImGui. Access via ImGui::GetIO().
// Read 'Programmer guide' section in .cpp file for general usage.
struct ImGuiIO
{
    //------------------------------------------------------------------
    // Settings (fill once)                 // Default value:
    //------------------------------------------------------------------

    ImGuiConfigFlags   ConfigFlags=0;       // = 0                  // See ImGuiConfigFlags_ enum. Set by user/application. Gamepad/keyboard navigation options, etc.
    ImGuiBackendFlags  BackendFlags=0;      // = 0                  // Set ImGuiBackendFlags_ enum. Set by imgui_impl_xxx files or custom back-end.
    ImVec2        DisplaySize;              // <unset>              // Display size, in pixels. For clamping windows positions.
    float         DeltaTime=1/60.0;         // = 1.0f/60.0f         // Time elapsed since last frame, in seconds.
    float         IniSavingRate=5;          // = 5.0f               // Maximum time between saving positions/sizes to .ini file, in seconds.
    const(char)*  IniFilename="imgui.ini";  // = "imgui.ini"        // Path to .ini file. null to disable .ini saving.
    const(char)*  LogFilename="imgui_log.txt"; // = "imgui_log.txt" // Path to .log file (default parameter to ImGui::LogToFile when no file is specified).
    float         MouseDoubleClickTime=0.3; // = 0.30f              // Time for a double-click, in seconds.
    float         MouseDoubleClickMaxDist=6; // = 6.0f              // Distance threshold to stay in to validate a double-click, in pixels.
    float         MouseDragThreshold=6;     // = 6.0f               // Distance threshold before considering we are dragging.
    int[ImGuiKey_COUNT] KeyMap;             // <unset>              // Map of indices into the KeysDown[512] entries array which represent your "native" keyboard state.
    float         KeyRepeatDelay=0.25;      // = 0.250f             // When holding a key/button, time before it starts repeating, in seconds (for buttons in Repeat mode, etc.).
    float         KeyRepeatRate=0.05;       // = 0.050f             // When holding a key/button, rate at which it repeats, in seconds.
    void*         UserData=null;            // = null               // Store your own data for retrieval by callbacks.

    ImFontAtlas*  Fonts;                    // <auto>               // Load and assemble one or more fonts into a single tightly packed texture. Output to Fonts array.
    float         FontGlobalScale=1;        // = 1.0f               // Global scale all fonts
    bool          FontAllowUserScaling=false; // = false            // Allow user scaling text of individual window with CTRL+Wheel.
    ImFont*       FontDefault=null;         // = null               // Font to use on NewFrame(). Use null to uses Fonts->Fonts[0].
    ImVec2        DisplayFramebufferScale=ImVec2.one;              // For retina display or other situations where window coordinates are different from framebuffer coordinates. User storage only, presently not used by ImGui.
    ImVec2        DisplayVisibleMin=ImVec2.zero;                    // If you use DisplaySize as a virtual space larger than your screen, set DisplayVisibleMin/Max to the visible area.
    ImVec2        DisplayVisibleMax=ImVec2.zero;                    // If the values are the same, we defaults to Min=(0.0f) and Max=DisplaySize

    // Advanced/subtle behaviors
    version (OSX)
        bool      OptMacOSXBehaviors=true;  // = defined(__APPLE__) // OS X style: Text editing cursor movement using Alt instead of Ctrl, Shortcuts using Cmd/Super instead of Ctrl, Line/Text Start and End using Cmd+Arrows instead of Home/End, Double click selects by word instead of selecting whole text, Multi-selection in lists uses Cmd/Super instead of Ctrl
    else
        bool      OptMacOSXBehaviors=false; // = defined(__APPLE__) // OS X style: Text editing cursor movement using Alt instead of Ctrl, Shortcuts using Cmd/Super instead of Ctrl, Line/Text Start and End using Cmd+Arrows instead of Home/End, Double click selects by word instead of selecting whole text, Multi-selection in lists uses Cmd/Super instead of Ctrl
    bool          OptCursorBlink=true;      // = true               // Enable blinking cursor, for users who consider it annoying.

    //------------------------------------------------------------------
    // Settings (User Functions)
    //------------------------------------------------------------------

    // Optional: access OS clipboard
    // (default to use native Win32 clipboard on Windows, otherwise uses a private clipboard. Override to access OS clipboard on other architectures)
    const(char)* function(void* user_data) GetClipboardTextFn;
    void        function(void* user_data, const(char)* text) SetClipboardTextFn;
    void*       ClipboardUserData;

    // Optional: notify OS Input Method Editor of the screen position of your cursor for text input position (e.g. when using Japanese/Chinese IME in Windows)
    // (default to use native imm32 api on Windows)
    void        function(int x, int y) ImeSetInputScreenPosFn;
    void*       ImeWindowHandle;            // (Windows) Set this to your HWND to get automatic IME cursor positioning.

    //------------------------------------------------------------------
    // Input - Fill before calling NewFrame()
    //------------------------------------------------------------------

    ImVec2      MousePos;                       // Mouse position, in pixels. Set to ImVec2(-FLT_MAX,-FLT_MAX) if mouse is unavailable (on another screen, etc.)
    bool[5]     MouseDown;                      // Mouse buttons: left, right, middle + extras. ImGui itself mostly only uses left button (BeginPopupContext** are using right button). Others buttons allows us to track if the mouse is being used by your application + available to user as a convenience via IsMouse** API.
    float       MouseWheel;                     // Mouse wheel: 1 unit scrolls about 5 lines text. 
    float       MouseWheelH;                    // Mouse wheel (Horizontal). Most users don't have a mouse with an horizontal wheel, may not be filled by all back-ends.
    bool        MouseDrawCursor;                // Request ImGui to draw a mouse cursor for you (if you are on a platform without a mouse cursor).
    bool        KeyCtrl;                        // Keyboard modifier pressed: Control
    bool        KeyShift;                       // Keyboard modifier pressed: Shift
    bool        KeyAlt;                         // Keyboard modifier pressed: Alt
    bool        KeySuper;                       // Keyboard modifier pressed: Cmd/Super/Windows
    bool[512]   KeysDown;                       // Keyboard keys that are pressed (ideally left in the "native" order your engine has access to keyboard keys, so you can use your own defines/enums for keys).
    ImWchar[16+1]   InputCharacters;            // List of characters input (translated by user from keypress+keyboard state). Fill using AddInputCharacter() helper.
    float[ImGuiNavInput_COUNT] NavInputs;       // Gamepad inputs (keyboard keys will be auto-mapped and be written here by ImGui::NewFrame, all values will be cleared back to zero in ImGui::EndFrame)

    // Functions
    void AddInputCharacter(ImWchar c);                      // Add new character into InputCharacters[]
    void AddInputCharactersUTF8(const(char)* utf8_chars);   // Add new characters into InputCharacters[] from an UTF-8 string
    void ClearInputCharacters() { InputCharacters[0] = 0; } // Clear the text input buffer manually

    //------------------------------------------------------------------
    // Output - Retrieve after calling NewFrame()
    //------------------------------------------------------------------

    bool        WantCaptureMouse;           // When io.WantCaptureMouse is true, imgui will use the mouse inputs, do not dispatch them to your main game/application (in both cases, always pass on mouse inputs to imgui). (e.g. unclicked mouse is hovering over an imgui window, widget is active, mouse was clicked over an imgui window, etc.). 
    bool        WantCaptureKeyboard;        // When io.WantCaptureKeyboard is true, imgui will use the keyboard inputs, do not dispatch them to your main game/application (in both cases, always pass keyboard inputs to imgui). (e.g. InputText active, or an imgui window is focused and navigation is enabled, etc.).
    bool        WantTextInput;              // Mobile/console: when io.WantTextInput is true, you may display an on-screen keyboard. This is set by ImGui when it wants textual keyboard input to happen (e.g. when a InputText widget is active).
    bool        WantSetMousePos;            // MousePos has been altered, back-end should reposition mouse on next frame. Set only when ImGuiConfigFlags_NavEnableSetMousePos flag is enabled.
    bool        NavActive;                  // Directional navigation is currently allowed (will handle ImGuiKey_NavXXX events) = a window is focused and it doesn't use the ImGuiWindowFlags_NoNavInputs flag.
    bool        NavVisible;                 // Directional navigation is visible and allowed (will handle ImGuiKey_NavXXX events).
    float       Framerate;                  // Application framerate estimation, in frame per second. Solely for convenience. Rolling average estimation based on IO.DeltaTime over 120 frames
    int         MetricsRenderVertices;      // Vertices output during last call to Render()
    int         MetricsRenderIndices;       // Indices output during last call to Render() = number of triangles * 3
    int         MetricsActiveWindows;       // Number of visible root windows (exclude child windows)
    ImVec2      MouseDelta;                 // Mouse delta. Note that this is zero if either current or previous position are invalid (-FLT_MAX,-FLT_MAX), so a disappearing/reappearing mouse won't have a huge delta.

    //------------------------------------------------------------------
    // [Internal] ImGui will maintain those fields. Forward compatibility not guaranteed!
    //------------------------------------------------------------------

    ImVec2      MousePosPrev;               // Previous mouse position temporary storage (nb: not for public use, set to MousePos in NewFrame())
    ImVec2[5]   MouseClickedPos;            // Position at time of clicking
    float[5]    MouseClickedTime;           // Time of last click (used to figure out double-click)
    bool[5]     MouseClicked;               // Mouse button went from !Down to Down
    bool[5]     MouseDoubleClicked;         // Has mouse button been double-clicked?
    bool[5]     MouseReleased;              // Mouse button went from Down to !Down
    bool[5]     MouseDownOwned;             // Track if button was clicked inside a window. We don't request mouse capture from the application if click started outside ImGui bounds.
    float[5]    MouseDownDuration;          // Duration the mouse button has been down (0.0f == just clicked)
    float[5]    MouseDownDurationPrev;      // Previous time the mouse button has been down
    ImVec2[5]   MouseDragMaxDistanceAbs;    // Maximum distance, absolute, on each axis, of how much mouse has traveled from the clicking point
    float[5]    MouseDragMaxDistanceSqr;    // Squared maximum distance of how much mouse has traveled from the clicking point
    float[512]  KeysDownDuration;           // Duration the keyboard key has been down (0.0f == just pressed)
    float[512]  KeysDownDurationPrev;       // Previous duration the key has been down
    float[ImGuiNavInput_COUNT]  NavInputsDownDuration;
    float[ImGuiNavInput_COUNT]  NavInputsDownDurationPrev;
}

//-----------------------------------------------------------------------------
// Helpers
//-----------------------------------------------------------------------------

// Helper: Lightweight std::vector<> like class to avoid dragging dependencies (also: Windows implementation of STL with debug enabled is absurdly slow, so let's bypass it so our code runs fast in debug).
// *Important* Our implementation does NOT call C++ constructors/destructors. This is intentional, we do not require it but you have to be mindful of that. Do not use this class as a straight std::vector replacement in your code!
extern (C++, class) struct ImVector(T)
{
public:
    extern (D)        T[]       asSlice()                               { return Data[0 .. Size]; }
    extern (D) const(T)[]       asSlice() const                         { return Data[0 .. Size]; }
    alias asSlice this;

    int                         Size;
    int                         Capacity;
    T*                          Data;

    alias T                     value_type;
    alias value_type*           iterator;
    alias const(value_type)*    const_iterator;

    ~this()                                                             { if (Data) ImGui.MemFree(Data); }

    bool                        empty() const                           { return Size == 0; }
    int                         size() const                            { return Size; }
    int                         capacity() const                        { return Capacity; }
    ref value_type              opIndex(int i)                          { assert(i < Size); return Data[i]; }
    ref const(value_type)       opIndex(int i) const                    { assert(i < Size); return Data[i]; }

    void                        clear()                                 { if (Data) { Size = Capacity = 0; ImGui.MemFree(Data); Data = null; } }
    iterator                    begin()                                 { return Data; }
    const_iterator              begin() const                           { return Data; }
    iterator                    end()                                   { return Data + Size; }
    const_iterator              end() const                             { return Data + Size; }
    ref value_type              front()                                 { assert(Size > 0); return Data[0]; }
    ref const(value_type)       front() const                           { assert(Size > 0); return Data[0]; }
    ref value_type              back()                                  { assert(Size > 0); return Data[Size - 1]; }
    ref const(value_type)       back() const                            { assert(Size > 0); return Data[Size - 1]; }
    void                        swap(ref ImVector!value_type rhs)       { int rhs_size = rhs.Size; rhs.Size = Size; Size = rhs_size; int rhs_cap = rhs.Capacity; rhs.Capacity = Capacity; Capacity = rhs_cap; value_type* rhs_data = rhs.Data; rhs.Data = Data; Data = rhs_data; }

    int                         _grow_capacity(int sz) const            { int new_capacity = Capacity ? (Capacity + Capacity/2) : 8; return new_capacity > sz ? new_capacity : sz; }
    void                        resize(int new_size)                    { if (new_size > Capacity) reserve(_grow_capacity(new_size)); Size = new_size; }
    void                        resize(int new_size, ref value_type v)  { if (new_size > Capacity) reserve(_grow_capacity(new_size)); if (new_size > Size) for (int n = Size; n < new_size; n++) Data[n] = v; Size = new_size; }
    void                        reserve(int new_capacity)
    {
        if (new_capacity <= Capacity) 
            return;
        value_type* new_data = cast(value_type*)ImGui.MemAlloc(cast(size_t)new_capacity * value_type.sizeof);
        if (Data)
            new_data[0 .. Size] = Data[0 .. Size];
        ImGui.MemFree(Data);
        Data = new_data;
        Capacity = new_capacity;
    }

    // NB: &v cannot be pointing inside the ImVector Data itself! e.g. v.push_back(v[10]) is forbidden.
    void         push_back()(auto ref value_type v)                 { if (Size == Capacity) reserve(_grow_capacity(Size + 1)); Data[Size] = v; Size++; }
    void         pop_back()                                         { assert(Size > 0); Size--; }
//    void         push_front(ref const(value_type) v)                { if (Size == 0) push_back(v); else insert(Data, v); }
//    iterator     erase(const_iterator it)                           { assert(it >= Data && it < Data+Size); const ptrdiff_t off = it - Data; memmove(Data + off, Data + off + 1, (cast(size_t)Size - cast(size_t)off - 1) * value_type.sizeof); Size--; return Data + off; }
//    iterator     insert(const_iterator it, ref const(value_type) v) { assert(it >= Data && it <= Data+Size); const ptrdiff_t off = it - Data; if (Size == Capacity) reserve(_grow_capacity(Size + 1)); if (off < cast(int)Size) memmove(Data + off + 1, Data + off, (cast(size_t)Size - cast(size_t)off) * value_type.sizeof); memcpy(&Data[off], &v, v.sizeof); Size++; return Data + off; }
    bool         contains(ref const(value_type) v) const            { const(T)* data = Data;  const(T)* data_end = Data + Size; while (data < data_end) if (*data++ == v) return true; return false; }
}

// Helper: Parse and apply text filters. In format "aaaaa[,bbbb][,ccccc]"
struct ImGuiTextFilter
{
    struct TextRange
    {
        const(char)* b;
        const(char)* e;

        this(const(char)* _b, const(char)* _e) { b = _b; e = _e; }
        const(char)* begin() const { return b; }
        const(char)* end() const { return e; }
        bool empty() const { return b == e; }
        char front() const { return *b; }
        static bool is_blank(char c) { return c == ' ' || c == '\t'; }
        void trim_blanks() { while (b < e && is_blank(*b)) b++; while (e > b && is_blank(*(e-1))) e--; }
        void split(char separator, ref ImVector!TextRange _out);
    };

    char[256]           InputBuf;
    ImVector!TextRange  Filters;
    int                 CountGrep;

    this(const(char)* default_filter);
    bool                Draw(const(char)* label = "Filter (inc,-exc)", float width = 0.0f);    // Helper calling InputText+Build
    bool                PassFilter(const(char)* text, const(char)* text_end = null) const;
    void                Build();
    void                Clear() { InputBuf[0] = 0; Build(); }
    bool                IsActive() const { return !Filters.empty(); }
};

// Helper: Text buffer for logging/accumulating text
struct ImGuiTextBuffer
{
    ImVector!char       Buf;

    this() @disable;
    char                opIndex(int i) { return Buf[i]; }
    const(char)*        begin() const { return &Buf.front(); }
    const(char)*        end() const { return &Buf.back(); }      // Buf is zero-terminated, so end() will point on the zero-terminator
    int                 size() const { return Buf.Size - 1; }
    bool                empty() { return Buf.Size <= 1; }
    void                clear() { Buf.clear(); Buf.push_back(0); }
    void                reserve(int capacity) { Buf.reserve(capacity); }
    const(char)*        c_str() const { return Buf.Data; }
    void                appendf(const(char)* fmt, ...);
    void                appendfv(const(char)* fmt, va_list args);
};

// Helper: Simple Key->value storage
// Typically you don't have to worry about this since a storage is held within each Window.
// We use it to e.g. store collapse state for a tree (Int 0/1)
// This is optimized for efficient lookup (dichotomy into a contiguous buffer) and rare insertion (typically tied to user interactions aka max once a frame)
// You can use it as custom user storage for temporary values. Declare your own storage if, for example:
// - You want to manipulate the open/close state of a particular sub-tree in your interface (tree node uses Int 0/1 to store their state).
// - You want to store custom debug data easily without adding or editing structures in your code (probably not efficient, but convenient)
// Types are NOT stored, so it is up to you to make sure your Key don't collide with different types.
struct ImGuiStorage
{
    // TODO
}

// Shared state of InputText(), passed to callback when a ImGuiInputTextFlags_Callback* flag is used and the corresponding callback is triggered.
struct ImGuiTextEditCallbackData
{
    ImGuiInputTextFlags EventFlag;      // One of ImGuiInputTextFlags_Callback* // Read-only
    ImGuiInputTextFlags Flags;          // What user passed to InputText()      // Read-only
    void*               UserData;       // What user passed to InputText()      // Read-only
    bool                ReadOnly;       // Read-only mode                       // Read-only

    // CharFilter event:
    ImWchar             EventChar;      // Character input                      // Read-write (replace character or set to zero)

    // Completion,History,Always events:
    // If you modify the buffer contents make sure you update 'BufTextLen' and set 'BufDirty' to true.
    ImGuiKey            EventKey;       // Key pressed (Up/Down/TAB)            // Read-only
    char*               Buf;            // Current text buffer                  // Read-write (pointed data only, can't replace the actual pointer)
    int                 BufTextLen;     // Current text length in bytes         // Read-write
    int                 BufSize;        // Maximum text length in bytes         // Read-only
    bool                BufDirty;       // Set if you modify Buf/BufTextLen!!   // Write
    int                 CursorPos;      //                                      // Read-write
    int                 SelectionStart; //                                      // Read-write (== to SelectionEnd when no selection)
    int                 SelectionEnd;   //                                      // Read-write

    // NB: Helper functions for text manipulation. Calling those function loses selection.
    void                DeleteChars(int pos, int bytes_count);
    void                InsertChars(int pos, const(char)* text, const(char)* text_end = null);
    bool                HasSelection() const { return SelectionStart != SelectionEnd; }
}

// Resizing callback data to apply custom constraint. As enabled by SetNextWindowSizeConstraints(). Callback is called during the next Begin().
// NB: For basic min/max size constraint on each axis you don't need to use the callback! The SetNextWindowSizeConstraints() parameters are enough.
struct ImGuiSizeCallbackData
{
    void*   UserData;       // Read-only.   What user passed to SetNextWindowSizeConstraints()
    ImVec2  Pos;            // Read-only.   Window position, for reference.
    ImVec2  CurrentSize;    // Read-only.   Current window size.
    ImVec2  DesiredSize;    // Read-write.  Desired size, based on user's mouse position. Write to this field to restrain resizing.
}

// Data payload for Drag and Drop operations
struct ImGuiPayload
{
    // Members
    const(void)*    Data;               // Data (copied and owned by dear imgui)
    int             DataSize;           // Data size

    // [Internal]
    ImGuiID         SourceId;           // Source item id
    ImGuiID         SourceParentId;     // Source parent id (if available)
    int             DataFrameCount=-1;  // Data timestamp
    char[32+1]      DataType;           // Data type tag (short user-supplied string, 32 characters max)
    bool            Preview;            // Set when AcceptDragDropPayload() was called and mouse has been hovering the target item (nb: handle overlapping drag targets)
    bool            Delivery;           // Set when AcceptDragDropPayload() was called and mouse button is released over the target item.

    void Clear()                                { this = ImGuiPayload.init; }
    bool IsDataType(const(char)* type) const    { import core.stdc.string : strcmp; return DataFrameCount != -1 && strcmp(type, &DataType[0]) == 0; }
    @property bool IsPreview() const            { return Preview; }
    @property bool IsDelivery() const           { return Delivery; }
}

// Helper: ImColor() implicity converts colors to either ImU32 (packed 4x1 byte) or ImVec4 (4x1 float)
// Prefer using IM_COL32() macros if you want a guaranteed compile-time ImU32 for usage with ImDrawList API.
// **Avoid storing ImColor! Store either u32 of ImVec4. This is not a full-featured color class. MAY OBSOLETE.
// **None of the ImGui API are using ImColor directly but you can use it as a convenience to pass colors in either ImU32 or ImVec4 formats. Explicitly cast to ImU32 or ImVec4 if needed.
struct ImColor
{
    ImVec4 Value;
    alias Value this;

    this(ubyte r, ubyte g, ubyte b, ubyte a = 255)
    {
        Value.x = r/255.0f;
        Value.y = g/255.0f;
        Value.z = b/255.0f;
        Value.w = a/255.0f;
    }
    this(float r, float g, float b, float a = 1.0f)
    {
        Value.x = r;
        Value.y = g;
        Value.z = b;
        Value.w = a;
    }
    this(ImU32 rgba)
    {
        float sc = 1.0f/255.0f;
        Value.x = cast(float)((rgba>>0)&0xFF) * sc;
        Value.y = cast(float)((rgba>>8)&0xFF) * sc;
        Value.z = cast(float)((rgba>>16)&0xFF) * sc;
        Value.w = cast(float)((rgba>>24)&0xFF) * sc;
    }
    this(ref const ImVec4 col)
    {
        Value = col;
    }
}

// Helper: Manually clip large list of items.
// If you are submitting lots of evenly spaced items and you have a random access to the list, you can perform coarse clipping based on visibility to save yourself from processing those items at all.
// The clipper calculates the range of visible items and advance the cursor to compensate for the non-visible items we have skipped. 
// ImGui already clip items based on their bounds but it needs to measure text size to do so. Coarse clipping before submission makes this cost and your own data fetching/submission cost null.
// Usage:
//     ImGuiListClipper clipper(1000);  // we have 1000 elements, evenly spaced.
//     while (clipper.Step())
//         for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++)
//             ImGui::Text("line number %d", i);
// - Step 0: the clipper let you process the first element, regardless of it being visible or not, so we can measure the element height (step skipped if we passed a known height as second arg to constructor).
// - Step 1: the clipper infer height from first element, calculate the actual range of elements to display, and position the cursor before the first element.
// - (Step 2: dummy step only required if an explicit items_height was passed to constructor or Begin() and user call Step(). Does nothing and switch to Step 3.)
// - Step 3: the clipper validate that we have reached the expected Y position (corresponding to element DisplayEnd), advance the cursor to the end of the list and then returns 'false' to end the loop.
struct ImGuiListClipper
{
    float   StartPosY=0;
    float   ItemsHeight=-1;
    int     ItemsCount=-1, StepNo=0, DisplayStart=-1, DisplayEnd=-1;

    this() @disable;
    this(int items_count, float items_height = -1.0f) { Begin(items_count, items_height); }

    bool Step();                                              // Call until it returns false. The DisplayStart/DisplayEnd fields will be set and you can process/draw those items.
    void Begin(int items_count, float items_height = -1.0f);  // Automatically called by constructor if you passed 'items_count' or by Step() in Step 1.
    void End();                                               // Automatically called on the last call of Step() that returns false.
}

//-----------------------------------------------------------------------------
// Draw List
// Hold a series of drawing commands. The user provides a renderer for ImDrawData which essentially contains an array of ImDrawList.
//-----------------------------------------------------------------------------

// Draw callbacks for advanced uses.
// NB- You most likely do NOT need to use draw callbacks just to create your own widget or customized UI rendering (you can poke into the draw list for that)
// Draw callback may be useful for example, A) Change your GPU render state, B) render a complex 3D scene inside a UI element (without an intermediate texture/render target), etc.
// The expected behavior from your rendering function is 'if (cmd.UserCallback != null) cmd.UserCallback(parent_list, cmd); else RenderTriangles()'
alias ImDrawCallback = void function(const(ImDrawList)* parent_list, const(ImDrawCmd)* cmd) nothrow;

// Typically, 1 command = 1 GPU draw call (unless command is a callback)
struct ImDrawCmd
{
    uint            ElemCount;              // Number of indices (multiple of 3) to be rendered as triangles. Vertices are stored _in the callee ImDrawList's vtx_buffer[] array, indices _in idx_buffer[].
    ImVec4          ClipRect;               // Clipping rectangle (x1, y1, x2, y2)
    ImTextureID     TextureId;              // User-provided texture ID. Set by user _in ImfontAtlas::SetTexID() for fonts or passed to Image*() functions. Ignore if never using images or multiple fonts atlas.
    ImDrawCallback  UserCallback;           // If != null, call the function instead of rendering the vertices. clip_rect and texture_id will be set normally.
    void*           UserCallbackData;       // The draw callback code can access this.
}

// Vertex index (override with '#define ImDrawIdx unsigned int' inside in imconfig.h)
alias ImDrawIdx = ushort;

// Vertex layout
struct ImDrawVert
{
    ImVec2  pos;
    ImVec2  uv;
    ImU32   col;
}

// Draw channels are used by the Columns API to "split" the render list into different channels while building, so items of each column can be batched together.
// You can also use them to simulate drawing layers and submit primitives in a different order than how they will be rendered.
struct ImDrawChannel
{
    ImVector!ImDrawCmd     CmdBuffer;
    ImVector!ImDrawIdx     IdxBuffer;
}

enum : ImDrawCornerFlags
{
    ImDrawCornerFlags_TopLeft   = 1 << 0, // 0x1
    ImDrawCornerFlags_TopRight  = 1 << 1, // 0x2
    ImDrawCornerFlags_BotLeft   = 1 << 2, // 0x4
    ImDrawCornerFlags_BotRight  = 1 << 3, // 0x8
    ImDrawCornerFlags_Top       = ImDrawCornerFlags_TopLeft | ImDrawCornerFlags_TopRight,   // 0x3
    ImDrawCornerFlags_Bot       = ImDrawCornerFlags_BotLeft | ImDrawCornerFlags_BotRight,   // 0xC
    ImDrawCornerFlags_Left      = ImDrawCornerFlags_TopLeft | ImDrawCornerFlags_BotLeft,    // 0x5
    ImDrawCornerFlags_Right     = ImDrawCornerFlags_TopRight | ImDrawCornerFlags_BotRight,  // 0xA
    ImDrawCornerFlags_All       = 0xF     // In your function calls you may use ~0 (= all bits sets) instead of ImDrawCornerFlags_All, as a convenience
}

enum : ImDrawListFlags
{
    ImDrawListFlags_AntiAliasedLines = 1 << 0,
    ImDrawListFlags_AntiAliasedFill  = 1 << 1
}

// Draw command list
// This is the low-level list of polygons that ImGui functions are filling. At the end of the frame, all command lists are passed to your ImGuiIO::RenderDrawListFn function for rendering.
// Each ImGui window contains its own ImDrawList. You can use ImGui::GetWindowDrawList() to access the current window draw list and draw custom primitives.
// You can interleave normal ImGui:: calls and adding primitives to the current draw list.
// All positions are generally in pixel coordinates (top-left at (0,0), bottom-right at io.DisplaySize), however you are totally free to apply whatever transformation matrix to want to the data (if you apply such transformation you'll want to apply it to ClipRect as well)
// Important: Primitives are always added to the list and not culled (culling is done at higher-level by ImGui:: functions), if you use this API a lot consider coarse culling your drawn objects.
struct ImDrawList
{
/+
    // This is what you have to render
    ImVector!ImDrawCmd      CmdBuffer;          // Draw commands. Typically 1 command = 1 GPU draw call, unless the command is a callback.
    ImVector!ImDrawIdx      IdxBuffer;          // Index buffer. Each command consume ImDrawCmd::ElemCount of those
    ImVector!ImDrawVert     VtxBuffer;          // Vertex buffer.
    ImDrawListFlags         Flags;              // Flags, you may poke into these to adjust anti-aliasing settings per-primitive.

    // [Internal, used while building lists]
    const(ImDrawListSharedData)* _Data;          // Pointer to shared draw data (you can use ImGui::GetDrawListSharedData() to get the one from current ImGui context)
    const(char)*            _OwnerName;         // Pointer to owner window's name for debugging
    uint                    _VtxCurrentIdx;     // [Internal] == VtxBuffer.Size
    ImDrawVert*             _VtxWritePtr;       // [Internal] point within VtxBuffer.Data after each add command (to avoid using the ImVector<> operators too much)
    ImDrawIdx*              _IdxWritePtr;       // [Internal] point within IdxBuffer.Data after each add command (to avoid using the ImVector<> operators too much)
    ImVector!ImVec4         _ClipRectStack;     // [Internal]
    ImVector!ImTextureID    _TextureIdStack;    // [Internal]
    ImVector!ImVec2         _Path;              // [Internal] current path building
    int                     _ChannelsCurrent;   // [Internal] current channel number (0)
    int                     _ChannelsCount;     // [Internal] number of active channels (1+)
    ImVector!ImDrawChannel  _Channels;          // [Internal] draw channels for columns API (not resized down so _ChannelsCount may be smaller than _Channels.Size)

    // If you want to create ImDrawList instances, pass them ImGui::GetDrawListSharedData() or create and use your own ImDrawListSharedData (so you can use ImDrawList without ImGui)
    this(const(ImDrawListSharedData)* shared_data)  { _Data = shared_data; _OwnerName = null; Clear(); }
    ~this()                                         { ClearFreeMemory(); }
    void        PushClipRect(ImVec2 clip_rect_min, ImVec2 clip_rect_max, bool intersect_with_current_clip_rect = false);  // Render-level scissoring. This is passed down to your render function but not used for CPU-side coarse clipping. Prefer using higher-level ImGui::PushClipRect() to affect logic (hit-testing and widget culling)
    void        PushClipRectFullScreen();
    void        PopClipRect();
    void        PushTextureID(ImTextureID texture_id);
    void        PopTextureID();
    ImVec2      GetClipRectMin() const  { const(ImVec4)* cr = &_ClipRectStack.back(); return ImVec2(cr.x, cr.y); }
    ImVec2      GetClipRectMax() const  { const(ImVec4)* cr = &_ClipRectStack.back(); return ImVec2(cr.z, cr.w); }

    // Primitives
    void  AddLine(ref const ImVec2 a, ref const ImVec2 b, ImU32 col, float thickness = 1.0f);
    void  AddRect(ref const ImVec2 a, ref const ImVec2 b, ImU32 col, float rounding = 0.0f, int rounding_corners_flags = ImDrawCornerFlags_All, float thickness = 1.0f);   // a: upper-left, b: lower-right, rounding_corners_flags: 4-bits corresponding to which corner to round
    void  AddRectFilled(ref const ImVec2 a, ref const ImVec2 b, ImU32 col, float rounding = 0.0f, int rounding_corners_flags = ImDrawCornerFlags_All);                     // a: upper-left, b: lower-right
    void  AddRectFilledMultiColor(ref const ImVec2 a, ref const ImVec2 b, ImU32 col_upr_left, ImU32 col_upr_right, ImU32 col_bot_right, ImU32 col_bot_left);
    void  AddQuad(ref const ImVec2 a, ref const ImVec2 b, ref const ImVec2 c, ref const ImVec2 d, ImU32 col, float thickness = 1.0f);
    void  AddQuadFilled(ref const ImVec2 a, ref const ImVec2 b, ref const ImVec2 c, ref const ImVec2 d, ImU32 col);
    void  AddTriangle(ref const ImVec2 a, ref const ImVec2 b, ref const ImVec2 c, ImU32 col, float thickness = 1.0f);
    void  AddTriangleFilled(ref const ImVec2 a, ref const ImVec2 b, ref const ImVec2 c, ImU32 col);
    void  AddCircle(ref const ImVec2 centre, float radius, ImU32 col, int num_segments = 12, float thickness = 1.0f);
    void  AddCircleFilled(ref const ImVec2 centre, float radius, ImU32 col, int num_segments = 12);
    void  AddText(ref const ImVec2 pos, ImU32 col, const(char)* text_begin, const(char)* text_end = null);
    void  AddText(const(ImFont)* font, float font_size, ref const ImVec2 pos, ImU32 col, const(char)* text_begin, const(char)* text_end = null, float wrap_width = 0.0f, const(ImVec4)* cpu_fine_clip_rect = null);
    void  AddImage(ImTextureID user_texture_id, ref const ImVec2 a, ref const ImVec2 b, ref const ImVec2 uv_a = ImVec2.zero, ref const ImVec2 uv_b = ImVec2.one, ImU32 col = 0xFFFFFFFF);
    void  AddImageQuad(ImTextureID user_texture_id, ref const ImVec2 a, ref const ImVec2 b, ref const ImVec2 c, ref const ImVec2 d, ref const ImVec2 uv_a = ImVec2.zero, ref const ImVec2 uv_b = ImVec2.one_zero, ref const ImVec2 uv_c = ImVec2.one, ref const ImVec2 uv_d = ImVec2.zero_one, ImU32 col = 0xFFFFFFFF);
    void  AddImageRounded(ImTextureID user_texture_id, ref const ImVec2 a, ref const ImVec2 b, ref const ImVec2 uv_a, ref const ImVec2 uv_b, ImU32 col, float rounding, int rounding_corners = ImDrawCornerFlags_All);
    void  AddPolyline(const(ImVec2)* points, const int num_points, ImU32 col, bool closed, float thickness);
    void  AddConvexPolyFilled(const(ImVec2)* points, int num_points, ImU32 col);
    void  AddBezierCurve(ref const ImVec2 pos0, ref const ImVec2 cp0, ref const ImVec2 cp1, ref const ImVec2 pos1, ImU32 col, float thickness, int num_segments = 0);

    // Stateful path API, add points then finish with PathFill() or PathStroke()
    void  PathClear()                                                   { _Path.resize(0); }
    void  PathLineTo(ref ImVec2 pos)                                    { _Path.push_back(pos); }
    void  PathLineToMergeDuplicate(ref ImVec2 pos)                      { if (_Path.Size == 0 || _Path[_Path.Size-1] != pos) _Path.push_back(pos); }
    void  PathFillConvex(ImU32 col)                                     { AddConvexPolyFilled(_Path.Data, _Path.Size, col); PathClear(); }
    void  PathStroke(ImU32 col, bool closed, float thickness = 1.0f)    { AddPolyline(_Path.Data, _Path.Size, col, closed, thickness); PathClear(); }
    void  PathArcTo(ref const ImVec2 centre, float radius, float a_min, float a_max, int num_segments = 10);
    void  PathArcToFast(ref const ImVec2 centre, float radius, int a_min_of_12, int a_max_of_12);                                // Use precomputed angles for a 12 steps circle
    void  PathBezierCurveTo(ref const ImVec2 p1, ref const ImVec2 p2, ref const ImVec2 p3, int num_segments = 0);
    void  PathRect(ref const ImVec2 rect_min, ref const ImVec2 rect_max, float rounding = 0.0f, int rounding_corners_flags = ImDrawCornerFlags_All);

    // Channels
    // - Use to simulate layers. By switching channels to can render out-of-order (e.g. submit foreground primitives before background primitives)
    // - Use to minimize draw calls (e.g. if going back-and-forth between multiple non-overlapping clipping rectangles, prefer to append into separate channels then merge at the end)
    void  ChannelsSplit(int channels_count);
    void  ChannelsMerge();
    void  ChannelsSetCurrent(int channel_index);

    // Advanced
    void  AddCallback(ImDrawCallback callback, void* callback_data);  // Your rendering function must check for 'UserCallback' in ImDrawCmd and call the function instead of rendering triangles.
    void  AddDrawCmd();                                               // This is useful if you need to forcefully create a new draw call (to allow for dependent rendering / blending). Otherwise primitives are merged into the same draw-call as much as possible
    ImDrawList* CloneOutput() const;                                  // Create a clone of the CmdBuffer/IdxBuffer/VtxBuffer.

    // Internal helpers
    // NB: all primitives needs to be reserved via PrimReserve() beforehand!
    void  Clear();
    void  ClearFreeMemory();
    void  PrimReserve(int idx_count, int vtx_count);
    void  PrimRect(ref const ImVec2 a, ref const ImVec2 b, ImU32 col);      // Axis aligned rectangle (composed of two triangles)
    void  PrimRectUV(ref const ImVec2 a, ref const ImVec2 b, ref const ImVec2 uv_a, ref const ImVec2 uv_b, ImU32 col);
    void  PrimQuadUV(ref const ImVec2 a, ref const ImVec2 b, ref const ImVec2 c, ref const ImVec2 d, ref const ImVec2 uv_a, ref const ImVec2 uv_b, ref const ImVec2 uv_c, ref const ImVec2 uv_d, ImU32 col);
    void  PrimWriteVtx(ref const ImVec2 pos, ref const ImVec2 uv, ImU32 col)    { _VtxWritePtr.pos = pos; _VtxWritePtr.uv = uv; _VtxWritePtr.col = col; _VtxWritePtr++; _VtxCurrentIdx++; }
    void  PrimWriteIdx(ImDrawIdx idx)                                           { *_IdxWritePtr = idx; _IdxWritePtr++; }
    void  PrimVtx(ref const ImVec2 pos, ref const ImVec2 uv, ImU32 col)         { PrimWriteIdx(cast(ImDrawIdx)_VtxCurrentIdx); PrimWriteVtx(pos, uv, col); }
    void  UpdateClipRect();
    void  UpdateTextureID();
+/
}

struct ImDrawData
{
    bool            Valid;
    ImDrawList**    CmdLists;
    int             CmdListsCount;
    int             TotalVtxCount;          // For convenience, sum of all cmd_lists vtx_buffer.Size
    int             TotalIdxCount;          // For convenience, sum of all cmd_lists idx_buffer.Size
}

struct ImFontConfig
{
    void*           FontData;                       // TTF/OTF data
    int             FontDataSize;                   // TTF/OTF data size
    bool            FontDataOwnedByAtlas=true;      // TTF/OTF data ownership taken by the container ImFontAtlas (will delete memory itself).
    int             FontNo=0;                       // Index of font within TTF/OTF file
    float           SizePixels=0;                   // Size in pixels for rasterizer.
    int             OversampleH=3;                  // Rasterize at higher quality for sub-pixel positioning. We don't use sub-pixel positions on the Y axis.
    int             OversampleV=1;                  // Rasterize at higher quality for sub-pixel positioning. We don't use sub-pixel positions on the Y axis.
    bool            PixelSnapH=false;               // Align every glyph to pixel boundary. Useful e.g. if you are merging a non-pixel aligned font with the default font. If enabled, you can set OversampleH/V to 1.
    ImVec2          GlyphExtraSpacing;              // Extra spacing (in pixels) between glyphs. Only X axis is supported for now.
    ImVec2          GlyphOffset;                    // Offset all glyphs from this font input.
    const(ImWchar)* GlyphRanges;                    // Pointer to a user-provided list of Unicode range (2 value per range, values are inclusive, zero-terminated list). THE ARRAY DATA NEEDS TO PERSIST AS LONG AS THE FONT IS ALIVE.
    bool            MergeMode=false;                // Merge into previous ImFont, so you can combine multiple inputs font into one ImFont (e.g. ASCII font + icons + Japanese glyphs). You may want to use GlyphOffset.y when merge font of different heights.
    uint            RasterizerFlags=0;              // Settings for custom font rasterizer (e.g. ImGuiFreeType). Leave as zero if you aren't using one.
    float           RasterizerMultiply=1;           // Brighten (>1.0f) or darken (<1.0f) font output. Brightening small fonts may be a good workaround to make them more readable.

    // [Internal]
    char[40]        Name;                           // Name (strictly to ease debugging)
    ImFont*         DstFont;
}

struct ImFontGlyph
{
    ImWchar         Codepoint;
    float           AdvanceX=0;
    float           X0=0, Y0=0, X1=0, Y1=0;
    float           U0=0, V0=0, U1=0, V1=0;
}

enum : ImFontAtlasFlags
{
    ImFontAtlasFlags_NoPowerOfTwoHeight = 1 << 0,   // Don't round the height to next power of two
    ImFontAtlasFlags_NoMouseCursors     = 1 << 1    // Don't build software mouse cursors into the atlas
}

// Load and rasterize multiple TTF/OTF fonts into a same texture.
// Sharing a texture for multiple fonts allows us to reduce the number of draw calls during rendering.
// We also add custom graphic data into the texture that serves for ImGui.
//  1. (Optional) Call AddFont*** functions. If you don't call any, the default font will be loaded for you.
//  2. Call GetTexDataAsAlpha8() or GetTexDataAsRGBA32() to build and retrieve pixels data.
//  3. Upload the pixels data into a texture within your graphics system.
//  4. Call SetTexID(my_tex_id); and pass the pointer/identifier to your texture. This value will be passed back to you during rendering to identify the texture.
// IMPORTANT: If you pass a 'glyph_ranges' array to AddFont*** functions, you need to make sure that your array persist up until the ImFont is build (when calling GetTextData*** or Build()). We only copy the pointer, not the data.
struct ImFontAtlas
{
    this() @disable;
    ~this();
    ImFont*           AddFont(const(ImFontConfig)* font_cfg);
    ImFont*           AddFontDefault(const(ImFontConfig)* font_cfg = null);
    ImFont*           AddFontFromFileTTF(const(char)* filename, float size_pixels, const(ImFontConfig)* font_cfg = null, const(ImWchar)* glyph_ranges = null);
    ImFont*           AddFontFromMemoryTTF(void* font_data, int font_size, float size_pixels, const(ImFontConfig)* font_cfg = null, const(ImWchar)* glyph_ranges = null); // Note: Transfer ownership of 'ttf_data' to ImFontAtlas! Will be deleted after Build(). Set font_cfg->FontDataOwnedByAtlas to false to keep ownership.
    ImFont*           AddFontFromMemoryCompressedTTF(const(void)* compressed_font_data, int compressed_font_size, float size_pixels, const(ImFontConfig)* font_cfg = null, const(ImWchar)* glyph_ranges = null); // 'compressed_font_data' still owned by caller. Compress with binary_to_compressed_c.cpp.
    ImFont*           AddFontFromMemoryCompressedBase85TTF(const(char)* compressed_font_data_base85, float size_pixels, const(ImFontConfig)* font_cfg = null, const(ImWchar)* glyph_ranges = null);              // 'compressed_font_data_base85' still owned by caller. Compress with binary_to_compressed_c.cpp with -base85 parameter.
    void              ClearInputData();           // Clear input data (all ImFontConfig structures including sizes, TTF data, glyph ranges, etc.) = all the data used to build the texture and fonts.
    void              ClearTexData();             // Clear output texture data (CPU side). Saves RAM once the texture has been copied to graphics memory.
    void              ClearFonts();               // Clear output font data (glyphs storage, UV coordinates).
    void              Clear();                    // Clear all input and output.

    // Build atlas, retrieve pixel data.
    // User is in charge of copying the pixels into graphics memory (e.g. create a texture with your engine). Then store your texture handle with SetTexID().
    // RGBA32 format is provided for convenience and compatibility, but note that unless you use CustomRect to draw color data, the RGB pixels emitted from Fonts will all be white (~75% of waste). 
    // Pitch = Width * BytesPerPixels
    bool              Build();                    // Build pixels data. This is called automatically for you by the GetTexData*** functions.
    void              GetTexDataAsAlpha8(ubyte** out_pixels, int* out_width, int* out_height, int* out_bytes_per_pixel = null);  // 1 byte per-pixel
    void              GetTexDataAsRGBA32(ubyte** out_pixels, int* out_width, int* out_height, int* out_bytes_per_pixel = null);  // 4 bytes-per-pixel
    void              SetTexID(ImTextureID id)    { TexID = id; }

    //-------------------------------------------
    // Glyph Ranges
    //-------------------------------------------

    // Helpers to retrieve list of common Unicode ranges (2 value per range, values are inclusive, zero-terminated list)
    // NB: Make sure that your string are UTF-8 and NOT in your local code page. In C++11, you can create UTF-8 string literal using the u8"Hello world" syntax. See FAQ for details.
    const(ImWchar)*   GetGlyphRangesDefault();    // Basic Latin, Extended Latin
    const(ImWchar)*   GetGlyphRangesKorean();     // Default + Korean characters
    const(ImWchar)*   GetGlyphRangesJapanese();   // Default + Hiragana, Katakana, Half-Width, Selection of 1946 Ideographs
    const(ImWchar)*   GetGlyphRangesChinese();    // Default + Japanese + full set of about 21000 CJK Unified Ideographs
    const(ImWchar)*   GetGlyphRangesCyrillic();   // Default + about 400 Cyrillic characters
    const(ImWchar)*   GetGlyphRangesThai();       // Default + Thai characters

    // Helpers to build glyph ranges from text data. Feed your application strings/characters to it then call BuildRanges().
    struct GlyphRangesBuilder
    {
        ImVector!ubyte UsedChars;  // Store 1-bit per Unicode code point (0=unused, 1=used)
        void Init()               { UsedChars.resize(0x10000 / 8); UsedChars[] = 0; }
        bool GetBit(int n)        { return (UsedChars[n >> 3] & (1 << (n & 7))) != 0; }
        void SetBit(int n)        { UsedChars[n >> 3] |= 1 << (n & 7); }  // Set bit 'c' in the array
        void AddChar(ImWchar c)   { SetBit(c); }                          // Add character
        void AddText(const(char)* text, const(char)* text_end = null);    // Add string (each character of the UTF-8 string are added)
        void AddRanges(const(ImWchar)* ranges);                          // Add ranges, e.g. builder.AddRanges(ImFontAtlas::GetGlyphRangesDefault) to force add all of ASCII/Latin+Ext
        void BuildRanges(ImVector!ImWchar* out_ranges);                 // Output new ranges
    }

    //-------------------------------------------
    // Custom Rectangles/Glyphs API
    //-------------------------------------------

    // You can request arbitrary rectangles to be packed into the atlas, for your own purposes. After calling Build(), you can query the rectangle position and render your pixels.
    // You can also request your rectangles to be mapped as font glyph (given a font + Unicode point), so you can render e.g. custom colorful icons and use them as regular glyphs.
    struct CustomRect
    {
        uint            ID=0xFFFFFFFF;          // Input    // User ID. Use <0x10000 to map into a font glyph, >=0x10000 for other/internal/custom texture data.
        ushort          Width, Height;          // Input    // Desired rectangle dimension
        ushort          X=0xFFFF, Y=0xFFFF;     // Output   // Packed position in Atlas
        float           GlyphAdvanceX=0;        // Input    // For custom font glyphs only (ID<0x10000): glyph xadvance
        ImVec2          GlyphOffset=ImVec2.zero;// Input    // For custom font glyphs only (ID<0x10000): glyph display offset
        ImFont*         Font;                   // Input    // For custom font glyphs only (ID<0x10000): target font
        bool IsPacked() const   { return X != 0xFFFF; }
    }

    int                 AddCustomRectRegular(uint id, int width, int height);                                                                               // Id needs to be >= 0x10000. Id >= 0x80000000 are reserved for ImGui and ImDrawList
    int                 AddCustomRectFontGlyph(ImFont* font, ImWchar id, int width, int height, float advance_x, ref const(ImVec2) offset = ImVec2.zero);   // Id needs to be < 0x10000 to register a rectangle to map into a specific font.
    const(CustomRect)*  GetCustomRectByIndex(int index) const { return index < 0 ? null : &CustomRects[index]; }

    // [Internal]
    void      CalcCustomRectUV(const(CustomRect)* rect, ImVec2* out_uv_min, ImVec2* out_uv_max);
    bool      GetMouseCursorTexData(ImGuiMouseCursor cursor, ImVec2* out_offset, ImVec2* out_size, ref ImVec2[2] out_uv_border, ref ImVec2[2] out_uv_fill);

    //-------------------------------------------
    // Members
    //-------------------------------------------

    ImFontAtlasFlags            Flags;              // Build flags (see ImFontAtlasFlags_)
    ImTextureID                 TexID;              // User data to refer to the texture once it has been uploaded to user's graphic systems. It is passed back to you during rendering via the ImDrawCmd structure.
    int                         TexDesiredWidth;    // Texture width desired by user before Build(). Must be a power-of-two. If have many glyphs your graphics API have texture size restrictions you may want to increase texture width to decrease height.
    int                         TexGlyphPadding;    // Padding between glyphs within texture in pixels. Defaults to 1.

    // [Internal]
    // NB: Access texture data via GetTexData*() calls! Which will setup a default font for you.
    ubyte*                      TexPixelsAlpha8;    // 1 component per pixel, each component is unsigned 8-bit. Total size = TexWidth * TexHeight
    uint*                       TexPixelsRGBA32;    // 4 component per pixel, each component is unsigned 8-bit. Total size = TexWidth * TexHeight * 4
    int                         TexWidth;           // Texture width calculated during Build().
    int                         TexHeight;          // Texture height calculated during Build().
    ImVec2                      TexUvScale;         // = (1.0f/TexWidth, 1.0f/TexHeight)
    ImVec2                      TexUvWhitePixel;    // Texture coordinates to a white pixel
    ImVector!(ImFont*)          Fonts;              // Hold all the fonts returned by AddFont*. Fonts[0] is the default font upon calling ImGui::NewFrame(), use ImGui::PushFont()/PopFont() to change the current font.
    ImVector!CustomRect         CustomRects;        // Rectangles for packing custom texture data into the atlas.
    ImVector!ImFontConfig       ConfigData;         // Internal data
    int[1]                      CustomRectIds;   // Identifiers of custom texture rectangle used by ImFontAtlas/ImDrawList
}

// Font runtime data and rendering
// ImFontAtlas automatically loads a default embedded font for you when you call GetTexDataAsAlpha8() or GetTexDataAsRGBA32().
struct ImFont
{
    // Members: Hot ~62/78 bytes
    float                       FontSize;           // <user set>   // Height of characters, set during loading (don't change after loading)
    float                       Scale;              // = 1.f        // Base font scale, multiplied by the per-window font scale which you can adjust with SetFontScale()
    ImVec2                      DisplayOffset;      // = (0.f,0.f)  // Offset font rendering by xx pixels
    ImVector!ImFontGlyph        Glyphs;             //              // All glyphs.
    ImVector!float              IndexAdvanceX;      //              // Sparse. Glyphs->AdvanceX in a directly indexable way (more cache-friendly, for CalcTextSize functions which are often bottleneck in large UI).
    ImVector!ushort             IndexLookup;        //              // Sparse. Index glyphs by Unicode code-point.
    const(ImFontGlyph)*         FallbackGlyph;      // == FindGlyph(FontFallbackChar)
    float                       FallbackAdvanceX;   // == FallbackGlyph->AdvanceX
    ImWchar                     FallbackChar;       // = '?'        // Replacement glyph if one isn't found. Only set via SetFallbackChar()

    // Members: Cold ~18/26 bytes
    short                       ConfigDataCount;    // ~ 1          // Number of ImFontConfig involved in creating this font. Bigger than 1 when merging multiple font sources into one ImFont.
    ImFontConfig*               ConfigData;         //              // Pointer within ContainerAtlas->ConfigData
    ImFontAtlas*                ContainerAtlas;     //              // What we has been loaded into
    float                       Ascent, Descent;    //              // Ascent: distance from top to bottom of e.g. 'A' [0..FontSize]
    bool                        DirtyLookupTables;
    int                         MetricsTotalSurface;//              // Total surface in pixels to get an idea of the font rasterization/texture cost (not exact, we approximate the cost of padding between glyphs)

    // Methods
    this() @disable;
    ~this();
    void                ClearOutputData();
    void                BuildLookupTable();
    const(ImFontGlyph)* FindGlyph(ImWchar c) const;
    const(ImFontGlyph)* FindGlyphNoFallback(ImWchar c) const;
    void                SetFallbackChar(ImWchar c);
    float               GetCharAdvance(ImWchar c) const     { return (c < IndexAdvanceX.Size) ? IndexAdvanceX[c] : FallbackAdvanceX; }
    bool                IsLoaded() const                    { return ContainerAtlas != null; }
    const(char)*        GetDebugName() const                { return ConfigData ? &ConfigData.Name[0] : "<unknown>"; }

    // 'max_width' stops rendering after a certain width (could be turned into a 2d size). FLT_MAX to disable.
    // 'wrap_width' enable automatic word-wrapping across multiple lines to fit into given width. 0.0f to disable.
    ImVec2              CalcTextSizeA(float size, float max_width, float wrap_width, const(char)* text_begin, const(char)* text_end = null, const(char)** remaining = null) const; // utf8
    const(char)*        CalcWordWrapPositionA(float scale, const(char)* text, const(char)* text_end, float wrap_width) const;
    void                RenderChar(ImDrawList* draw_list, float size, ImVec2 pos, ImU32 col, ushort c) const;
    void                RenderText(ImDrawList* draw_list, float size, ImVec2 pos, ImU32 col, ref const(ImVec4) clip_rect, const(char)* text_begin, const(char)* text_end, float wrap_width = 0.0f, bool cpu_fine_clip = false) const;

    // [Internal]
    void                GrowIndex(int new_size);
    void                AddGlyph(ImWchar c, float x0, float y0, float x1, float y1, float u0, float v0, float u1, float v1, float advance_x);
    void                AddRemapChar(ImWchar dst, ImWchar src, bool overwrite_dst = true); // Makes 'dst' character/glyph points to 'src' character/glyph. Currently needs to be called AFTER fonts have been built.
}


extern (D):
import std.string : toStringz;

enum ImVec4[ImGuiCol_COUNT] StyleColorsDark = [
    ImVec4(1.00f, 1.00f, 1.00f, 1.00f),
    ImVec4(0.50f, 0.50f, 0.50f, 1.00f),
    ImVec4(0.06f, 0.06f, 0.06f, 0.94f),
    ImVec4(1.00f, 1.00f, 1.00f, 0.00f),
    ImVec4(0.08f, 0.08f, 0.08f, 0.94f),
    ImVec4(0.43f, 0.43f, 0.50f, 0.50f),
    ImVec4(0.00f, 0.00f, 0.00f, 0.00f),
    ImVec4(0.16f, 0.29f, 0.48f, 0.54f),
    ImVec4(0.26f, 0.59f, 0.98f, 0.40f),
    ImVec4(0.26f, 0.59f, 0.98f, 0.67f),
    ImVec4(0.04f, 0.04f, 0.04f, 1.00f),
    ImVec4(0.16f, 0.29f, 0.48f, 1.00f),
    ImVec4(0.00f, 0.00f, 0.00f, 0.51f),
    ImVec4(0.14f, 0.14f, 0.14f, 1.00f),
    ImVec4(0.02f, 0.02f, 0.02f, 0.53f),
    ImVec4(0.31f, 0.31f, 0.31f, 1.00f),
    ImVec4(0.41f, 0.41f, 0.41f, 1.00f),
    ImVec4(0.51f, 0.51f, 0.51f, 1.00f),
    ImVec4(0.26f, 0.59f, 0.98f, 1.00f),
    ImVec4(0.24f, 0.52f, 0.88f, 1.00f),
    ImVec4(0.26f, 0.59f, 0.98f, 1.00f),
    ImVec4(0.26f, 0.59f, 0.98f, 0.40f),
    ImVec4(0.26f, 0.59f, 0.98f, 1.00f),
    ImVec4(0.06f, 0.53f, 0.98f, 1.00f),
    ImVec4(0.26f, 0.59f, 0.98f, 0.31f),
    ImVec4(0.26f, 0.59f, 0.98f, 0.80f),
    ImVec4(0.26f, 0.59f, 0.98f, 1.00f),
    ImVec4(0.43f, 0.43f, 0.50f, 0.50f),
    ImVec4(0.10f, 0.40f, 0.75f, 0.78f),
    ImVec4(0.10f, 0.40f, 0.75f, 1.00f),
    ImVec4(0.26f, 0.59f, 0.98f, 0.25f),
    ImVec4(0.26f, 0.59f, 0.98f, 0.67f),
    ImVec4(0.26f, 0.59f, 0.98f, 0.95f),
    ImVec4(0.61f, 0.61f, 0.61f, 1.00f),
    ImVec4(1.00f, 0.43f, 0.35f, 1.00f),
    ImVec4(0.90f, 0.70f, 0.00f, 1.00f),
    ImVec4(1.00f, 0.60f, 0.00f, 1.00f),
    ImVec4(0.26f, 0.59f, 0.98f, 0.35f),
    ImVec4(0.80f, 0.80f, 0.80f, 0.35f),
    ImVec4(1.00f, 1.00f, 0.00f, 0.90f),
    ImVec4(0.26f, 0.59f, 0.98f, 1.00f),
    ImVec4(1.00f, 1.00f, 1.00f, 0.70f)
];

// just a bunch of helper wrappers... mostly adapting arrays to C/C++ arrays and strings
void PlotLines(const(char)[] label, const(float)[] values, int values_offset = 0, const(char)[] overlay_text = null, float scale_min = float.max, float scale_max = float.max, ImVec2 graph_size = ImVec2.zero, int stride = float.sizeof)
{
	ImGui.PlotLines(label.toStringz, values.ptr, cast(int)values.length, values_offset, overlay_text.toStringz, scale_min, scale_max, graph_size, stride);
}
void PlotHistogram(const(char)[] label, const(float)[] values, int values_offset = 0, const(char)[] overlay_text = null, float scale_min = float.max, float scale_max = float.max, ImVec2 graph_size = ImVec2.zero, int stride = float.sizeof)
{
	ImGui.PlotHistogram(label.toStringz, values.ptr, cast(int)values.length, values_offset, overlay_text.toStringz, scale_min, scale_max, graph_size, stride);
}

bool Selectable(const(char)[] label, bool selected = false, ImGuiSelectableFlags flags = 0, ref const ImVec2 size = ImVec2.zero)
{
	return ImGui.Selectable(label.toStringz, selected, flags, size);
}
bool Selectable(const(char)[] label, bool* p_selected, ImGuiSelectableFlags flags = 0, ref const ImVec2 size = ImVec2.zero)
{
	return ImGui.Selectable(label.toStringz, p_selected, flags, size);
}

bool Combo(const(char)[] label, int* current_item, string[] items, int height_in_items = -1)
{
	extern (C++) static bool getItem(void* data, int item, const(char)** output)
	{
		string[]* items = cast(string[]*)data;
		if (item >= (*items).length)
			return false;
		*output = (*items)[item].toStringz;
		return true;
	}
	return ImGui.Combo(label.toStringz, current_item, &getItem, cast(void*)&items, cast(int)items.length, height_in_items);
}
