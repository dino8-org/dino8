---@meta

-- DINO8 Engine API Definitions
-- This file provides type definitions for IDE support
-- Note: Lint errors about "undefined type 'number'" in this file are expected and can be ignored

---  //////////////////////
---  CORE
---  //////////////////////

-- Global time variable (seconds since startup)
---@type number
T = 0

-- Delta time between frames (seconds)
---@type number
DT = 0

---Exit the application (native builds only, no-op on web)
function quit() end

---  //////////////////////
---  STRING
---  //////////////////////

-- Lua's standard string library is available globally.

---@class stringlib
string = {}

---Repeat a string n times
---@param s string The string to repeat
---@param n number Number of repetitions
---@return string result The repeated string
function string.rep(s, n) end

---Return the length of a string in bytes
---@param s string
---@return number length
function string.len(s) end

---Convert a string to uppercase
---@param s string
---@return string upper
function string.upper(s) end

---Convert a string to lowercase
---@param s string
---@return string lower
function string.lower(s) end

---Reverse a string
---@param s string
---@return string reversed
function string.reverse(s) end

---Extract a substring
---@param s string
---@param i number Start index (1-based, negative counts from end)
---@param j? number End index (default -1, i.e. end of string)
---@return string substring
function string.sub(s, i, j) end

---Find a pattern in a string
---@param s string The string to search
---@param pattern string Lua pattern to find
---@param init? number Start position (default 1)
---@param plain? boolean If true, do a plain substring match (no patterns)
---@return number|nil start Start index of match, or nil if not found
---@return number|nil end End index of match
---@return any ... Captured groups, if any
function string.find(s, pattern, init, plain) end

---Replace occurrences of a pattern in a string
---@param s string The source string
---@param pattern string Lua pattern to match
---@param repl string|table|function Replacement string, table, or function
---@param n? number Maximum number of replacements (default all)
---@return string result The modified string
---@return number count Number of replacements made
function string.gsub(s, pattern, repl, n) end

---Extract captures from a pattern match (returns an iterator)
---@param s string The string to search
---@param pattern string Lua pattern with captures
---@return fun(): any ... Iterator returning captured groups
function string.gmatch(s, pattern) end

---Return the pattern-matched captures from a string
---@param s string The string to match
---@param pattern string Lua pattern
---@param init? number Start position (default 1)
---@return any ... Captured groups, or the whole match if no captures
function string.match(s, pattern, init) end

---Return the byte value(s) of characters in a string
---@param s string
---@param i? number Start index (default 1)
---@param j? number End index (default i)
---@return number ... Byte values
function string.byte(s, i, j) end

---Return a string from byte values
---@param ... number Byte values
---@return string result
function string.char(...) end

---Format a string (like C sprintf)
---@param fmt string Format string
---@param ... any Values to format
---@return string result Formatted string
function string.format(fmt, ...) end

---  //////////////////////
---  PALETTE
---  //////////////////////

-- Default palette colors (Dawnbringer 16) - 1-based indexing:
-- 1: #140C1C  -- Dark purple/black
-- 2: #442434  -- Dark purple
-- 3: #30346D  -- Dark blue
-- 4: #4E4A4E  -- Dark gray
-- 5: #854C30  -- Brown
-- 6: #346524  -- Dark green
-- 7: #D04648  -- Red
-- 8: #757161  -- Gray
-- 9: #597DCE  -- Blue
-- 10: #D27D2C -- Orange
-- 11: #8595A1 -- Light gray
-- 12: #6DAA2C -- Green
-- 13: #D2AA99 -- Light brown/pink
-- 14: #6DC2CA -- Cyan
-- 15: #DAD45E -- Yellow
-- 16: #DEEED6 -- White/cream

-- COLOR FORMAT: All drawing functions accept colors as:
--   Palette index (1-16): Uses the color from the current palette
--   Raw RGB color (0xRRGGBB): Uses the exact color (e.g., 0xFF0000 for red)
--
-- When a color argument is passed to a drawing function, it also sets the
-- "pen color" which is used when subsequent calls omit the color argument.
--
-- CUSTOM PALETTE: Can be configured in conf.d8:
--   palette = {
--     0x000000,  -- 1: black
--     0xFF0000,  -- 2: red
--     0x00FF00,  -- 3: green
--     ... etc (16 colors in 0xRRGGBB format)
--   }


---  //////////////////////
---  GRAPHICS
---  //////////////////////

---Set a pixel at (x, y) with color
---@overload fun(x: number, y: number) Uses current pen color
---@param x number X coordinate
---@param y number Y coordinate
---@param color? number Color: palette index (1-16) OR raw 0xRRGGBB. Sets pen color if provided.
function pset(x, y, color) end

---Get the color of pixel at (x, y)
---@param x number X coordinate
---@param y number Y coordinate
---@return number color Palette index (1-16) if from palette, or raw 0xRRGGBB if drawn with raw color
function pget(x, y) end

---Clear screen with color
---@param color? number Color: palette index (1-16) OR raw 0xRRGGBB. Defaults to 1 (first palette color).
function cls(color) end

---Reset the pallet swap changes
function pal() end

---Set draw palette color mapping (PICO-8 style)
---When drawing color c0, it will appear as color c1 instead.
---This allows palette swapping for sprites (e.g., recoloring characters).
---Calling with no arguments resets the draw palette and palt transparency mask to defaults.
---@param c0 number Source color index (1-16) - the color being drawn
---@param c1 number Destination color index (1-16) - the color that will appear
function pal(c0, c1) end

---Set per-color transparency for sprite drawing (PICO-8 style)
---When a color is marked transparent via palt(), sprites drawn with spr() skip those pixels.
---
---Calling with no arguments resets all colors to opaque.
---Calling with one argument marks that color transparent.
---Calling with two arguments sets the transparency state explicitly.
---
---@param col number Color index (1-16) to configure
---@param transparent boolean True to make the color transparent, false to make it opaque
function palt(col, transparent) end

---Enable palette shift mode for read-modify-write drawing
---When enabled, shapes (rect, rectf, circ, circf, line) read existing pixels
---and remap them through the shift palette instead of drawing a new color.
---This allows creating visual effects like color shifting, shadows, or masks.
---Call with no arguments to disable shift mode and reset mappings.
---@overload fun() Disable shift mode and reset to identity mapping
---@param palette_table table 16-element array mapping each color to a new color
---Example: pals({2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,1}) shifts all colors up by 1
function pals(palette_table) end

---Set or get current pen color for drawing functions
---When drawing functions omit the color argument, the pen color is used.
---Passing a color to any drawing function also sets the pen color.
---@overload fun(): number Get current pen color
---@param c? number Color: palette index (1-16) OR raw 0xRRGGBB
---@return number? Current pen color (only when getting)
function color(c) end

---Replace the base 16-color palette at runtime
---@param colors table Array of 16 colors in 0xRRGGBB format
---Example: set_palette({0x000000, 0xFF0000, 0x00FF00, ...})
function set_palette(colors) end

---Get the current base palette as a table
---@return table colors Array of 16 colors in 0xRRGGBB format
function get_palette() end

---Convert a palette color index to an RGB table with values 0-1
---@param index integer Palette color index (1-16)
---@return number[] rgb Array of {r, g, b} values (0-1)
function rgb(index) end

---Set clipping region (restricts all drawing to this rectangle)
---Call with no arguments to reset/disable clipping
---@overload fun()
---@param x number Top-left X coordinate of clip region
---@param y number Top-left Y coordinate of clip region
---@param w number Width of clip region
---@param h number Height of clip region
function clip(x, y, w, h) end

---Print text at position (uses current pen color if no color specified)
---@overload fun(text: string, x: number, y: number)
---@overload fun(text: string, x: number, y: number, color: number)
---@overload fun(text: string, x: number, y: number, color: number, bg_color: number)
---@param text string Text to print
---@param x number X coordinate
---@param y number Y coordinate
---@param color? number Color: palette index (1-16) OR raw 0xRRGGBB. Sets pen color if provided.
---@param bg_color? number Optional background color: palette index (1-16) OR raw 0xRRGGBB
function print(text, x, y, color, bg_color) end

---Print text with a 1px outline
---@param text string Text to print
---@param x number X coordinate
---@param y number Y coordinate
---@param color? number Text color: palette index (1-16) or 0xRRGGBB
---@param outline_color? number Outline color (defaults to 1/dark)
function printo(text, x, y, color, outline_color) end

---Get the pixel width of text using the current font
---Accounts for variable-width characters, glyphs, and kerning settings
---@param text string Text to measure
---@return number width Width in pixels
function text_width(text) end

---Set or get current font style
---Default styles: 1 = PixelMplus10-Regular, 2 = PixelMplus10-Bold
---Custom styles can be defined in conf.d8 via font_styles table
---@overload fun(): number Get current font style index
---@overload fun(index: number) Set current font style
---@param index? number Font style index (1-based)
---@return number? Current font style index (only when getting)
function font_style(index) end

---Get number of available font styles
---@return number count Number of loaded font styles
function font_style_count() end

---Get line height for current font style
---Returns the actual line height from font metrics, or custom value if set in conf.d8
---@return number height Line height in pixels
function line_height() end

---Get extra kerning/letter spacing for current font style
---Returns the kerning value set in conf.d8 (0 by default)
---@return number kerning Extra letter spacing in pixels
function kerning() end

---Draw line with various argument patterns
---@overload fun()
---@overload fun(color: number)
---@overload fun(x1: number, y1: number)
---@overload fun(x1: number, y1: number, color: number)
---@overload fun(x0: number, y0: number, x1: number, y1: number)
---@overload fun(x0: number, y0: number, x1: number, y1: number, color: number)
function line(...) end

---Draw circle outline
---@param cx number Center X coordinate
---@param cy number Center Y coordinate
---@param radius? number Radius (default 4)
---@param color? number Color: palette index (1-16) OR raw 0xRRGGBB. Sets pen color if provided.
function circ(cx, cy, radius, color) end

---Draw rectangle outline
---@param x0 number Top-left X coordinate
---@param y0 number Top-left Y coordinate
---@param x1 number Bottom-right X coordinate
---@param y1 number Bottom-right Y coordinate
---@param color? number Color: palette index (1-16) OR raw 0xRRGGBB. Sets pen color if provided.
function rect(x0, y0, x1, y1, color) end

---Draw filled circle
---@param cx number Center X coordinate
---@param cy number Center Y coordinate
---@param radius? number Radius (default 4)
---@param color? number Color: palette index (1-16) OR raw 0xRRGGBB. Sets pen color if provided.
function circf(cx, cy, radius, color) end

---Draw filled rectangle
---@param x0 number Top-left X coordinate
---@param y0 number Top-left Y coordinate
---@param x1 number Bottom-right X coordinate
---@param y1 number Bottom-right Y coordinate
---@param color? number Color: palette index (1-16) OR raw 0xRRGGBB. Sets pen color if provided.
function rectf(x0, y0, x1, y1, color) end

---Draw rounded rectangle outline
---@param x0 number Top-left X coordinate
---@param y0 number Top-left Y coordinate
---@param x1 number Bottom-right X coordinate
---@param y1 number Bottom-right Y coordinate
---@param r number Corner radius in pixels (clamped to half of smallest dimension)
---@param color? number Color: palette index (1-16) OR raw 0xRRGGBB. Sets pen color if provided.
function rrect(x0, y0, x1, y1, r, color) end

---Draw filled rounded rectangle
---@param x0 number Top-left X coordinate
---@param y0 number Top-left Y coordinate
---@param x1 number Bottom-right X coordinate
---@param y1 number Bottom-right Y coordinate
---@param r number Corner radius in pixels (clamped to half of smallest dimension)
---@param color? number Color: palette index (1-16) OR raw 0xRRGGBB. Sets pen color if provided.
function rrectf(x0, y0, x1, y1, r, color) end

---Draw checkerboard pattern
---@param x number Starting X coordinate
---@param y number Starting Y coordinate
---@param width number Total width of checkerboard area
---@param height number Total height of checkerboard area
---@param cell_size number Size of each checker square
---@param color1 number First color: palette index (1-16) OR raw 0xRRGGBB. Sets pen color.
---@param color2? number Second color (odd tiles): palette index (1-16) OR raw 0xRRGGBB. Defaults to pen color.
function checker(x, y, width, height, cell_size, color1, color2) end

---Set fill pattern for rectf/circf operations (PICO-8 style)
---Pattern is a 16-bit value mapping to a 4x4 pixel grid.
---When a pattern bit is set, that pixel uses the secondary color (or is transparent).
---Call with no args to reset to solid fill.
---Can also pass a glyph character string to auto-generate pattern from font.
---@param pattern? number|string 16-bit pattern number OR glyph character string
---@param secondary_color? number Secondary color for pattern bits: palette index (1-16) OR raw 0xRRGGBB. If omitted, pattern bits are transparent.
---@overload fun(): nil Reset to solid fill
---@overload fun(pattern: number): nil Set pattern (transparent where bits are set)
---@overload fun(pattern: number, secondary_color: number): nil Set pattern with secondary color
---@overload fun(glyph: string): nil Set pattern from font glyph
---@overload fun(glyph: string, secondary_color: number): nil Set glyph pattern with secondary color
function fillp(pattern, secondary_color) end

--- Preset fill pattern constants (use with fillp)
---@class PatternPresets
---@field CHECKER number Checkerboard pattern
---@field STRIPE_H number Horizontal stripes (2px)
---@field STRIPE_V number Vertical stripes (2px)
---@field BAR_H number Wide horizontal bars
---@field THICK_H number Thick horizontal stripes
---@field DOTS_SPARSE number Sparse dots
---@field DOTS_DENSE number Dense dots (every other pixel)
---@field DIAG_R number Diagonal stripe (top-left to bottom-right)
---@field DIAG_L number Diagonal stripe (top-right to bottom-left)
---@field LIGHT number Light fill (mostly solid, sparse holes)
---@field HATCH number Cross-hatch pattern
---@type PatternPresets
PATTERN = {} ---@diagnostic disable-line: missing-fields

---  //////////////////////
---  SPRITES
---  //////////////////////

---Create a new blank image filled with palette index 0
---@param width number Image width in pixels (1-4096)
---@param height number Image height in pixels (1-4096)
---@return number|nil image_id Image ID or nil if failed
function new_image(width, height) end

---Load an image file and return its ID
---@param filename string Path to image file (PNG, JPG)
---@return number|nil image_id Image ID or nil if failed to load
function load_image(filename) end

---Get the pixel dimensions of a loaded image
---@param image_id number Loaded image ID
---@return number width Image width in pixels
---@return number height Image height in pixels
function image_size(image_id) end

---Read a palette index from a loaded image's pixel data
---@param image_id number Loaded image ID
---@param x number X coordinate in image
---@param y number Y coordinate in image
---@return number color Palette index (-1 if out of bounds)
function image_pget(image_id, x, y) end

---Write a palette index into a loaded image's pixel data
---@param image_id number Loaded image ID
---@param x number X coordinate in image
---@param y number Y coordinate in image
---@param color number Palette index
function image_pset(image_id, x, y, color) end

---Extract unique colors from a PNG image file (for palette import)
---Scans pixels in order and returns unique non-transparent colors as 0xRRGGBB
---@param filename string Path to image file (PNG, JPG)
---@return number[] colors Array of unique colors in scan order
function palette_from_image(filename) end

---Save a loaded image to disk as PNG
---@param image_id number Loaded image ID
---@param filename string Path to save the PNG file
---@return boolean success True if saved successfully
function save_image(image_id, filename) end

---Draw sprite from loaded image
---@overload fun(image_id: number, dx: number, dy: number, flip_x?: boolean, flip_y?: boolean)
---@overload fun(image_id: number, sx: number, sy: number, sw: number, sh: number, dx: number, dy: number, dw?: number, dh?: number, flip_x?: boolean, flip_y?: boolean, angle?: number, scale_x?: number, scale_y?: number)
---@param image_id number Loaded image ID
---@param sx number Source X coordinate in image
---@param sy number Source Y coordinate in image
---@param sw number Source width
---@param sh number Source height
---@param dx number Destination X coordinate on screen
---@param dy number Destination Y coordinate on screen
---@param dw? number Destination width (optional, defaults to sw)
---@param dh? number Destination height (optional, defaults to sh)
---@param flip_x? boolean Flip horizontally (optional, defaults to false)
---@param flip_y? boolean Flip vertically (optional, defaults to false)
---@param angle? number Rotation angle in radians (optional, defaults to 0)
---@param scale_x? number Horizontal scale factor (optional, defaults to 1.0)
---@param scale_y? number Vertical scale factor (optional, defaults to scale_x if omitted)
function spr(image_id, ...) end

---Draw a sprite from atlas with a 1px outline
---@param image_id number The loaded image ID
---@param sx number Source X on atlas
---@param sy number Source Y on atlas
---@param sw number Source width
---@param sh number Source height
---@param dx number Destination X on screen
---@param dy number Destination Y on screen
---@param outline_color number Outline color (palette index 1-16 or 0xRRGGBB)
---@param dw? number Destination width (defaults to sw)
---@param dh? number Destination height (defaults to sh)
---@param flip_x? boolean Flip horizontally (defaults to false)
---@param flip_y? boolean Flip vertically (defaults to false)
function spro(image_id, sx, sy, sw, sh, dx, dy, outline_color, dw, dh, flip_x, flip_y) end

---Draw a textured quad from a loaded image using affine texture mapping
---Points are specified clockwise from top-left: top-left, top-right, bottom-right, bottom-left
---@param image_id number The loaded image ID
---@param src_quad table Source UV coordinates on the atlas {x1,y1, x2,y2, x3,y3, x4,y4}
---@param dst_quad table Destination screen coordinates {x1,y1, x2,y2, x3,y3, x4,y4}
function sprq(image_id, src_quad, dst_quad) end

---Draw a nine-slice sprite. Divides source rect into 9 regions using TRBL margins.
---Corners are drawn 1:1, edges and center are stretched or tiled.
---@param image_id number The loaded image ID
---@param sx number Source X on atlas
---@param sy number Source Y on atlas
---@param sw number Source width
---@param sh number Source height
---@param dx number Destination X on screen
---@param dy number Destination Y on screen
---@param dw number Destination width
---@param dh number Destination height
---@param margins table Border insets {top, right, bottom, left}
---@param mode? string "stretch" (default) or "tile"
function spr9(image_id, sx, sy, sw, sh, dx, dy, dw, dh, margins, mode) end

---Unload an image to free memory
---@param image_id number Image ID to unload
function unload_image(image_id) end

---Get sprite flag(s). Without flag argument, returns all 8 flags as a bitmask number.
---With flag argument (0-7), returns true/false for that specific bit.
---@param sprite_id number Image ID returned by load_image
---@param flag? number Flag index (0-7)
---@return number|boolean Flag value (number if no flag specified, boolean if flag specified)
function fget(sprite_id, flag) end

---Set sprite flag(s). With 2 args, sets all flags to val (bitmask number).
---With 3 args, sets specific flag bit (0-7) to boolean val.
---@param sprite_id number Image ID returned by load_image
---@param flag_or_val number Flag index (0-7) when 3 args, or full bitmask value when 2 args
---@param val? boolean Flag value (true/false)
function fset(sprite_id, flag_or_val, val) end

---  //////////////////////
---  INPUT
---  //////////////////////

---Check if key or mouse button is currently held down
---Button numbers (1-based, Lua style):
---  1-4: d-pad (left, right, up, down)
---  5-8: face buttons (action_a, action_b, action_x, action_y)
---  9-10: shoulders (lb, rb)
---  11-12: triggers (lt, rt)
---@param input string|integer Key name (e.g., "action_a", "left", "lb", "lt") or mouse ("mouse_left") or button number (1-12)
---@param player? integer Player index (0-3, default 0). Each player has own keyboard bindings and gamepad.
---@return boolean True if input is currently pressed
function btn(input, player) end

---Check if key or mouse button was just pressed this frame (with auto-repeat)
---Returns true on initial press, then again after the initial delay,
---and repeatedly at the repeat rate while held.
---Default: 500ms initial delay, 250ms repeat delay.
---Button numbers (1-based, Lua style):
---  1-4: d-pad (left, right, up, down)
---  5-8: face buttons (action_a, action_b, action_x, action_y)
---  9-10: shoulders (lb, rb)
---  11-12: triggers (lt, rt)
---@param input string|integer Key name (e.g., "action_a", "left") or mouse ("mouse_left") or button number (1-12)
---@param player? integer Player index (0-3, default 0). Each player has own keyboard bindings and gamepad.
---@return boolean True if input was just pressed or repeat triggered
function btnp(input, player) end

---Get any key that was just pressed this frame
---@return string|nil The name of the pressed key (e.g., "a", " ", "enter") or nil if no key pressed
function get_btnp() end

---Set button repeat rates for btnp auto-repeat behavior
---Controls how quickly btnp triggers repeat presses when a button is held.
---@overload fun() Reset to default rates (250ms initial, 100ms repeat)
---@overload fun(initial_delay_ms: number) Set initial delay, use default repeat delay
---@overload fun(initial_delay_ms: number, repeat_delay_ms: number) Set both delays
---@param initial_delay_ms? number Delay in ms before first repeat (default 250)
---@param repeat_delay_ms? number Delay in ms between subsequent repeats (default 100)
function set_repeat_rates(initial_delay_ms, repeat_delay_ms) end

---Get current button repeat rates
---@return number initial_delay_ms Current initial delay in milliseconds
---@return number repeat_delay_ms Current repeat delay in milliseconds
function get_repeat_rates() end

---Mark an input as consumed/handled for this frame.
---Prevents the engine from acting on this input (e.g., opening pause menu on escape).
---Must be called during _update(). Resets automatically each frame.
---@param input string Input name (e.g., "escape", "f12", "action_a")
function consume(input) end

---Show on-screen keyboard (for mobile text input)
---On desktop this is a no-op. Text input from the keyboard feeds into
---the existing btn/btnp/get_btnp functions.
function open_keyboard() end

---Hide on-screen keyboard (for mobile text input)
---On desktop this is a no-op.
function close_keyboard() end

---Get on-screen keyboard height in pixels
---Returns 0 on desktop or when keyboard is hidden.
---Use this to adjust UI positioning when keyboard is visible.
---@return number height Keyboard height in pixels
function keyboard_height() end

---Check if a physical key is currently held (bypasses key binding remapping)
---@param key_name string Physical key name (e.g., "a", "space", "enter", "left")
---@return boolean held True if the key is currently held down
function key(key_name) end

---Check if a physical key was just pressed this frame (bypasses key binding remapping)
---@param key_name string Physical key name (e.g., "a", "space", "enter", "left")
---@return boolean pressed True if the key was pressed this frame
function keyp(key_name) end

---Get the keyboard key bound to an action for a player
---@param player number Player index (1-based)
---@param action string Action name ("up","down","left","right","action_a","action_b","action_x","action_y","lb","rb","lt","rt")
---@return string|nil key The key name, or nil if not bound
function get_key_binding(player, action) end

---Set a keyboard key binding for a player
---@param player number Player index (1-based)
---@param action string Action name ("up","down","left","right","action_a","action_b","action_x","action_y","lb","rb","lt","rt")
---@param key string Key name (e.g. "z", "x", "up", "space")
function set_key_binding(player, action, key) end

---Reset all keyboard bindings to defaults
function reset_key_bindings() end

---Save current keyboard bindings to disk
function save_key_bindings() end

---Load keyboard bindings from disk
function load_key_bindings() end

---Get any keyboard key pressed this frame (for remap capture UI)
---@return string|nil key The key name, or nil if no key pressed
function get_any_key_pressed() end

---Get the character typed this frame (preserving case, from SDL_TEXTINPUT)
---@return string|nil char The character, or nil if nothing typed
function typed() end

---Get the system clipboard text
---@return string|nil text The clipboard contents, or nil if empty
function clipboard_get() end

---Set the system clipboard text
---@param text string The text to copy to clipboard
function clipboard_set(text) end

---Get the gamepad button bound to an action for a player
---@param player number Player index (1-based)
---@param action string Action name ("up","down","left","right","action_a","action_b","action_x","action_y","lb","rb","lt","rt")
---@return string|nil button The button name ("a","b","x","y","up","down","left","right","lb","rb","ls","rs","start","back"), or nil if not bound
function get_button_binding(player, action) end

---Set a gamepad button binding for a player
---@param player number Player index (1-based)
---@param action string Action name ("up","down","left","right","action_a","action_b","action_x","action_y","lb","rb","lt","rt")
---@param button string Button name ("a","b","x","y","up","down","left","right","lb","rb","ls","rs","start","back")
function set_button_binding(player, action, button) end

---Reset all gamepad bindings to defaults
function reset_button_bindings() end

---Save current gamepad bindings to disk
function save_button_bindings() end

---Load gamepad bindings from disk
function load_button_bindings() end

---Get any gamepad button pressed this frame on a player's gamepad (for remap capture UI)
---@param player number Player index (1-based)
---@return string|nil button The button name, or nil if no button pressed
function get_any_button_pressed(player) end

---Enable or disable virtual on-screen controls for mobile platforms
---@param enabled? boolean True to show controls, false to hide. If omitted, returns current state.
---@return boolean enabled Current state of virtual controls
function mobile_controls(enabled) end

---Configure virtual mobile control appearance and behavior
---@param config? {opacity?: number, scale?: number, enabled?: boolean} Configuration table
---@return {opacity: number, scale: number, enabled: boolean} config Current configuration
function mobile_controls_config(config) end

---Check if the user is currently touching the screen
---@return boolean active True if any touch points are active
function touch_active() end

---Get position of the first active touch point in game coordinates
---@return number|nil x Touch X coordinate, or nil if no touch
---@return number|nil y Touch Y coordinate, or nil if no touch
function touch_pos() end

---  //////////////////////
---  RENDER OFFSET
---  //////////////////////

---Set render position offset within black bar region (0-1)
---Controls where the game is rendered when screen has black bars:
--- - 0.0 = top (portrait) or left (landscape)
--- - 0.5 = center (default)
--- - 1.0 = bottom (portrait) or right (landscape)
---@param offset number Normalized offset value (0-1)
function set_render_offset(offset) end

---Get current render position offset
---@return number offset Current render offset (0-1)
function get_render_offset() end

---  //////////////////////
---  ORIENTATION CALLBACK
---  //////////////////////

---Called when device orientation changes (optional callback)
---Define this function in your game to respond to orientation changes.
---@param orientation string "portrait" or "landscape"
function _orientation_changed(orientation) end

---  //////////////////////
---  NOTIFICATIONS
---  //////////////////////

---@class NotifyOptions
---@field value? string Right-aligned value text
---@field col? number Message text color (1-16, default: 16)
---@field vcol? number Value text color (1-16, default: 16)
---@field bg? number Background color (1-16, default: 7)

---Show a notification that slides up from the bottom, displays for 2 seconds, then slides down
---@param message string The notification message to display (left-aligned)
---@param options? NotifyOptions Optional configuration table
---@overload fun(message: string)
function notify(message, options) end

---Get current mouse position (combined function)
---@return number x Mouse X coordinate in screen pixels
---@return number y Mouse Y coordinate in screen pixels
function get_mouse() end

---Get hardware mouse cursor visibility
---@return boolean visible True if the hardware mouse cursor is visible
function get_hardware_mouse_visibility() end

---Show or hide the hardware mouse cursor
---@param visible boolean True to show cursor, false to hide it while window is focused
function set_hardware_mouse_visibility(visible) end

---Get current mouse X position
---@return number x Mouse X coordinate in screen pixels
function mouse_x() end

---Get current mouse Y position
---@return number y Mouse Y coordinate in screen pixels
function mouse_y() end

---Short alias for mouse_x() - get mouse X position
---@return number x Mouse X coordinate in screen pixels
function mousex() end

---Short alias for mouse_y() - get mouse Y position
---@return number y Mouse Y coordinate in screen pixels
function mousey() end

---Get mouse wheel scroll delta for the current frame
---@return number wx Horizontal scroll delta (positive = right)
---@return number wy Vertical scroll delta (positive = down / away from user)
function mouse_wheel() end

---Check if mouse button is currently held down (alternative API)
---@param button number Button number (1=left, 2=right, 3=middle)
---@return boolean True if button is currently pressed
function mouse_btn(button) end

---Check if mouse button was just pressed this frame (alternative API)
---@param button number Button number (1=left, 2=right, 3=middle)
---@return boolean True if button was just pressed
function mouse_btnp(button) end

---  //////////////////////
---  TIME
---  //////////////////////

---Get current system time
---@return string time Current time in HH:MM:SS format (e.g., "16:22:23")
function time() end

---Get time since engine start in seconds (for timing/measurements)
---@return number seconds Time in seconds since engine start (e.g., 12.345)
function t() end

---Get current frame rate (frames per second)
---@return number fps Current frames per second
function fps() end

---  //////////////////////
---  WINDOW
---  //////////////////////

---Get current fullscreen state
---@return boolean fullscreen True if window is in fullscreen mode
function get_fullscreen() end

---Set fullscreen state with proper aspect ratio handling
---@param fullscreen boolean True to enable fullscreen, false for windowed
function set_fullscreen(fullscreen) end

---Toggle between fullscreen and windowed mode
function toggle_fullscreen() end

---Set the window scale factor (ignored in fullscreen)
---@param scale integer Scale factor (1-10)
function set_window_scale(scale) end

---Get the current window scale factor
---@return integer scale Current scale factor
function get_window_scale() end

---Get the current VSync state
---@return boolean vsync True if VSync is enabled
function get_vsync() end

---Set VSync state
---@param enabled boolean True to enable VSync, false to disable
function set_vsync(enabled) end

---Toggle VSync on/off
function toggle_vsync() end

---Get current window title
---@return string title Current window title
function get_window_title() end

---Set window title
---@param title string New window title
function set_window_title(title) end

---Get screen dimensions from conf.d8
---@return number width Screen width in pixels
---@return number height Screen height in pixels
function screen_size() end

---Get screen width from conf.d8
---@return number width Screen width in pixels
function screen_width() end

---Get screen height from conf.d8
---@return number height Screen height in pixels
function screen_height() end

---  //////////////////////
---  FILE I/O
---  //////////////////////

---Write text content to a file
---@param filename string File path (relative to project directory)
---@param content string Text content to write
---@return boolean success True if file was written successfully
function write_file(filename, content) end

---Read text content from a file
---@param filename string File path (relative to project directory)
---@return string|nil content File content or nil if failed
function read_file(filename) end

---Append text content to a file
---@param filename string File path (relative to project directory)
---@param content string Text content to append
---@return boolean success True if content was appended successfully
function append_file(filename, content) end

---Check if a file exists
---@param filename string File path (relative to project directory)
---@return boolean exists True if file exists
function file_exists(filename) end

---Delete a file
---@param filename string File path (relative to project directory)
---@return boolean success True if file was deleted successfully
function delete_file(filename) end

---  //////////////////////
---  PERSISTENCE (PICO-8 style)
---  //////////////////////

---Get a persistent value by key (PICO-8 style dget)
---Data persists across sessions in:
--- - Desktop: ~/Library/Application Support/dino8/persist.txt (macOS)
--- - Web: localStorage
---@param key string Key to retrieve
---@return string|nil value Value or nil if not found
function dget(key) end

---Set a persistent value by key (PICO-8 style dset)
---Data is automatically saved to disk/localStorage
---@param key string Key to store
---@param value string Value to store
function dset(key, value) end

---Check if a directory exists
---@param path string Directory path (relative to project directory)
---@return boolean exists True if directory exists
function dir_exists(path) end

---Create a directory
---@param path string Directory path (relative to project directory)
---@return boolean success True if directory was created successfully
function create_dir(path) end

---List files and directories in a path
---@param path string Directory path (relative to project directory)
---@return table files Array of filenames in the directory
function list_dir(path) end

---Export current screen buffer as PNG image
---@param filename string PNG file path (relative to project directory)
---@return boolean success True if screen was exported successfully
function export_screen_png(filename) end

---Export current palette as JSON data
---@param filename string JSON file path (relative to project directory)
---@return boolean success True if palette was exported successfully
function export_palette(filename) end

---Get the current project directory path
---@return string path Project directory path
function get_project_dir() end

---  //////////////////////
---  MATH
---  //////////////////////

---Sine of angle (in radians)
---@param angle number Angle in radians
---@return number Sine value
function sin(angle) end

---Cosine of angle (in radians)
---@param angle number Angle in radians
---@return number Cosine value
function cos(angle) end

---Arctangent of y/x (returns angle in radians)
---@param y number Y component
---@param x number X component
---@return number Angle in radians
function atan2(y, x) end

---Square root of value
---@param value number Number to get square root of
---@return number Square root
function sqrt(value) end

---Absolute value
---@param value number Number to get absolute value of
---@return number Absolute value
function abs(value) end

---Minimum of two values
---@param a number First value
---@param b number Second value
---@return number Minimum value
function min(a, b) end

---Maximum of two values
---@param a number First value
---@param b number Second value
---@return number Maximum value
function max(a, b) end

---Middle value of three numbers
---@param a number First value
---@param b number Second value
---@param c number Third value
---@return number Middle value
function mid(a, b, c) end

---Round up to nearest integer
---@param value number Number to round up
---@return number Ceiling value
function ceil(value) end

---Round down to nearest integer (floor)
---@param value number Number to round down
---@return number Floor value
function flr(value) end

---Random number between 0 and max, or between min and max
---@param min_or_max? number If one arg: maximum value (default 1.0). If two args: minimum value
---@param max? number Maximum value (when using two args)
---@return number Random number
---@overload fun(): number
---@overload fun(max: number): number
---@overload fun(min: number, max: number): number
function rnd(min_or_max, max) end

---Seed the random number generator
---@param n number Seed value
function seed(n) end

---@class NoiseOpts
---@field seed? number Seed for the permutation table
---@field octaves? number Number of fBm octaves (1-8, default 1)
---@field lacunarity? number Frequency multiplier per octave (default 2.0)
---@field persistence? number Amplitude multiplier per octave (default 0.5)

---Create a noise source
---@param opts? NoiseOpts Configuration options
---@return integer id Noise source ID
function noise(opts) end

---Update a noise source's configuration
---@param id integer Noise source ID
---@param opts NoiseOpts Configuration options to update
function noise_set(id, opts) end

---Sample a noise source (returns values in [-1, 1])
---@param id integer Noise source ID
---@param x number X coordinate
---@param y number Y coordinate
---@param z? number Z coordinate (for 3D noise)
---@return number value Noise value in range [-1, 1]
function noise_at(id, x, y, z) end

---Wrap value within range (circular navigation)
---@param value number Value to wrap
---@param min number Minimum value (inclusive)
---@param max number Maximum value (inclusive)
---@return number Wrapped value within [min, max] range
function wrap(value, min, max) end

---Convert degrees to radians
---@param degrees number Angle in degrees
---@return number Angle in radians
function deg2rad(degrees) end

---Convert radians to degrees
---@param radians number Angle in radians
---@return number Angle in degrees
function rad2deg(radians) end

---  //////////////////////
---  COLLISION
---  //////////////////////

---Check if two axis-aligned rectangles overlap (AABB collision)
---@param x1 number First rect X
---@param y1 number First rect Y
---@param w1 number First rect width
---@param h1 number First rect height
---@param x2 number Second rect X
---@param y2 number Second rect Y
---@param w2 number Second rect width
---@param h2 number Second rect height
---@return boolean True if rectangles overlap
function collides(x1, y1, w1, h1, x2, y2, w2, h2) end

---Check if a point is inside a rectangle
---@param px number Point X
---@param py number Point Y
---@param x number Rect X
---@param y number Rect Y
---@param w number Rect width
---@param h number Rect height
---@return boolean True if point is inside rectangle
function point_in_rect(px, py, x, y, w, h) end

---Check if a point is inside a circle
---@param px number Point X
---@param py number Point Y
---@param cx number Circle center X
---@param cy number Circle center Y
---@param r number Circle radius
---@return boolean True if point is inside circle
function point_in_circ(px, py, cx, cy, r) end

---Get the overlap rectangle of two AABBs, or nil if no overlap
---@param x1 number First rect X
---@param y1 number First rect Y
---@param w1 number First rect width
---@param h1 number First rect height
---@param x2 number Second rect X
---@param y2 number Second rect Y
---@param w2 number Second rect width
---@param h2 number Second rect height
---@return number|nil x Overlap rect X (nil if no overlap)
---@return number|nil y Overlap rect Y
---@return number|nil w Overlap rect width
---@return number|nil h Overlap rect height
function rect_overlap(x1, y1, w1, h1, x2, y2, w2, h2) end

---  //////////////////////
---  UTILITIES
---  //////////////////////

---Linear interpolation between a and b
---@param a number Start value
---@param b number End value
---@param t number Interpolation factor (0-1)
---@return number Interpolated value
function lerp(a, b, t) end

---Spherical linear interpolation for angles (in radians). Takes shortest path.
---@param a number Start angle in radians
---@param b number End angle in radians
---@param t number Interpolation factor (0-1)
---@return number Interpolated angle
function slerp(a, b, t) end

---Clamp value between min and max
---@param val number Value to clamp
---@param min number Minimum bound
---@param max number Maximum bound
---@return number Clamped value
function clamp(val, min, max) end

---Get sign of number (-1, 0, or 1)
---@param x number Input value
---@return number -1 if negative, 0 if zero, 1 if positive
function sign(x) end

---Move current value toward target by step amount
---@param current number Current value
---@param target number Target value
---@param step number Maximum step size (positive)
---@return number New value (equals target if within step distance)
function approach(current, target, step) end

---Calculate 2D Euclidean distance between two points
---@param x1 number First point X
---@param y1 number First point Y
---@param x2 number Second point X
---@param y2 number Second point Y
---@return number Distance
function distance(x1, y1, x2, y2) end

---  //////////////////////
---  EASING
---  //////////////////////

---@class EaseCurves
---@field Quad number Quadratic (t^2) - default
---@field Cubic number Cubic (t^3)
---@field Quart number Quartic (t^4)
---@field Quint number Quintic (t^5)
---@field Sine number Sine-based
---@field Expo number Exponential
---@field Circ number Circular
---@field Back number Overshoot
---@field Elastic number Spring
---@field Bounce number Bounce

---Easing curve types
---@type EaseCurves
Ease = {} ---@diagnostic disable-line: missing-fields

---Ease-in (accelerating). Default curve is Ease.Quad.
---@param t number Progress (0-1)
---@param curve? number Easing curve from Ease table (e.g. Ease.Bounce, Ease.Elastic)
---@return number Eased value
function ease_in(t, curve) end

---Ease-out (decelerating). Default curve is Ease.Quad.
---@param t number Progress (0-1)
---@param curve? number Easing curve from Ease table (e.g. Ease.Bounce, Ease.Elastic)
---@return number Eased value
function ease_out(t, curve) end

---Ease-in-out (accelerate then decelerate). Default curve is Ease.Quad.
---@param t number Progress (0-1)
---@param curve? number Easing curve from Ease table (e.g. Ease.Bounce, Ease.Elastic)
---@return number Eased value
function ease_in_out(t, curve) end

---  //////////////////////
---  AUDIO
---  //////////////////////

---Load a sound effect with optional randomization
---@overload fun(filename: string): number|nil
---@overload fun(filename: string, pitch: number): number|nil
---@overload fun(filename: string, pitch: table): number|nil
---@param filename string Path to audio file(s) (supports wildcards like "*.wav")
---@param pitch number|table Pitch value or {min, max} for randomization (default 1.0)
---@param volume number|table Volume value or {min, max} for randomization (default 1.0)
---@return number|nil sfx_id Sound effect ID or nil if failed to load
function load_sfx(filename, pitch, volume) end

---Load music file
---@param filename string Path to music file (WAV, OGG, MP3)
---@return number|nil music_id Music ID or nil if failed to load
function load_music(filename) end

---Play a sound effect
---@overload fun(sfx_id: number|nil)
---@overload fun(sfx_id: number|nil, volume: number)
---@param sfx_id number|nil Sound effect ID from load_sfx (nil values are ignored)
---@param volume? number Volume override (0.0-1.0)
---@param pitch? number Pitch override (0.5-2.0 typical)
function sfx(sfx_id, volume, pitch) end

---Play music. Plays a tracker song if one exists at the given ID, otherwise
---falls back to a file-based music track loaded with load_music().
---All IDs are 1-based. Passing 0 or nil is a no-op (silent).
---@overload fun(music_id: number|nil)
---@overload fun(music_id: number|nil, volume: number)
---@param music_id number|nil Music/song ID (1-based). 0 or nil = silent.
---@param volume? number Volume (0.0-1.0)
---@param loop? boolean Whether to loop the music (default true, only for file-based music)
function music(music_id, volume, loop) end

---Stop sound effects with optional fade-out
---@overload fun()
---@overload fun(fade_time: number)
---@overload fun(channel: number)
---@overload fun(channel: number, fade_time: number)
---@param channel_or_fade? number|integer Channel number (integer) or fade time (float)
---@param fade_time? number Fade out time in seconds (0 = immediate stop)
function stop_sfx(channel_or_fade, fade_time) end

---Stop currently playing music with optional fade-out
---@param fade_time? number Fade out time in seconds (0 = immediate stop, default)
function stop_music(fade_time) end

---Pause currently playing music
function pause_music() end

---Resume paused music
function resume_music() end

---Check if music is currently playing
---@return boolean playing True if music is playing
function is_music_playing() end

---Set global sound effects volume
---@param volume number|nil Volume level (0.0-1.0, nil values are ignored)
function set_sfx_volume(volume) end

---Set global music volume
---@param volume number|nil Volume level (0.0-1.0, nil values are ignored)
function set_music_volume(volume) end

---Get the master volume level (affects all audio)
---Returns the logical volume even when muted
---@return number volume Volume level (0.0-1.0)
function get_volume() end

---Set the master volume level (affects all audio channels)
---@param volume number Volume level (0.0-1.0)
function set_volume(volume) end

---Get the current mute state
---@return boolean muted True if audio is muted
function get_mute() end

---Set the mute state (muting preserves volume levels)
---@param muted boolean True to mute, false to unmute
function set_mute(muted) end

---Toggle the mute state
function toggle_mute() end

---Unload a sound effect to free memory
---@param sfx_id number|nil Sound effect ID to unload (nil values are ignored)
function unload_sfx(sfx_id) end

---Unload music to free memory
---@param music_id number|nil Music ID to unload (nil values are ignored)
function unload_music(music_id) end

---Get the number of audio file variations loaded for a sound effect
---@param sfx_id number|nil Sound effect ID from load_sfx (nil returns 0)
---@return number count Number of audio file variations loaded (0 if sfx_id is invalid or nil)
function get_sfx_count(sfx_id) end

---Pause sound effects on a specific channel or all channels
---@param channel? integer Channel number to pause. If omitted, pauses all channels.
function pause_sfx(channel) end

---Resume paused sound effects on a specific channel or all channels
---@param channel? integer Channel number to resume. If omitted, resumes all channels.
function resume_sfx(channel) end

---Check if a specific audio channel is currently playing
---@param channel integer Mixer channel number
---@return boolean playing True if the channel is playing audio
function is_channel_playing(channel) end

---Play a sound effect on a specific mixer channel
---@param channel integer Mixer channel to play on
---@param sfx_id integer Sound effect ID from load_sfx
---@param volume? number Volume multiplier (default 1.0)
function sfx_channel(channel, sfx_id, volume) end

---Synthesize and play a sound effect from note data
---Each note is a table of {pitch, volume, wave_type, effect}:
---  pitch: 0-63 (chromatic scale, C-2 to D#-7)
---  volume: 0-7 (0 = silent)
---  wave_type: 0=sine, 1=triangle, 2=sawtooth, 3=square, 4=noise
---  effect: 0=none, 1=slide, 2=vibrato, 3=drop, 4=fade_in, 5=fade_out
---@param notes table Array of {pitch, vol, wave, fx} tables (up to 32 notes)
---@param speed? integer Ticks per note (default 8, range 1-255)
---@param scope_ch? integer Channel index (1-8) for scope capture (waveform visualization)
---@return integer channel Mixer channel number playing the synth (-1 on failure)
function synth(notes, speed, scope_ch) end

---Synthesize and play waveform notes with an effects chain applied to the output.
---Same as synth() but post-processes the PCM buffer with the given effects.
---@param notes table Array of {pitch, vol, wave, fx} tables (up to 32 notes)
---@param speed? integer Ticks per note (default 8, range 1-255)
---@param effects? table Array of {type, p1, p2, p3, p4} effect definitions
---@param channel_hint? integer Channel index (1-8) for persistent effect state across calls
---@return integer channel Mixer channel number playing the synth (-1 on failure)
function synth_fx(notes, speed, effects, channel_hint) end

---Stop a synthesized sound playing on a channel
---@param channel integer Mixer channel to stop
function synth_stop(channel) end

---Update live effects on a playing synth channel (real-time parameter changes)
---@param tracker_ch integer Channel index (1-8)
---@param effects? table Array of {type, p1, p2, p3, p4} effect definitions, or nil to clear
function synth_set_fx(tracker_ch, effects) end

---Read recent waveform samples from the scope ring buffer for a channel
---@param channel integer Channel index (1-8)
---@param count? integer Number of samples to read (default 128, max 512)
---@return number[] samples Array of float samples (-1.0 to 1.0), oldest first
function scope_read(channel, count) end

---Compute frequency spectrum from scope buffer (bass on left, treble on right)
---@param channel integer Channel index (1-8)
---@param num_bins? integer Number of frequency bins (default 64, max 256)
---@return number[] bins Array of magnitudes (0.0 to 1.0), low frequencies first
function scope_fft(channel, num_bins) end

---  //////////////////////
---  CAMERA
---  //////////////////////

---Set camera position (PICO-8 style offset)
---@param x number Camera X offset
---@param y number Camera Y offset
function cam_set(x, y) end

---PICO-8 compatible camera function.
---With arguments: sets camera position (same as cam_set(x, y)).
---With no arguments: resets camera to origin (same as cam_reset()).
---@overload fun() Reset camera to origin
---@param x number Camera X offset
---@param y number Camera Y offset
function camera(x, y) end

---Reset camera to origin (0, 0)
function cam_reset() end

---Reset camera to origin (short alias for cam_reset)
function cam() end

---Get current camera position
---@return number x Camera X position
---@return number y Camera Y position
function cam_get() end

---Create screen shake effect
---@param intensity number Shake intensity in pixels
---@param duration number Duration in seconds to decay to 0
function cam_shake(intensity, duration) end

---Set camera movement boundaries
---@param x1 number Minimum X boundary
---@param y1 number Minimum Y boundary
---@param x2 number Maximum X boundary
---@param y2 number Maximum Y boundary
function cam_bounds(x1, y1, x2, y2) end

---Save current camera state to stack
function cam_push() end

---Restore previous camera state from stack
function cam_pop() end

---Move camera relatively
---@param x number X offset to add
---@param y number Y offset to add
function cam_translate(x, y) end

---Scale camera view (zoom)
---@param sx number X scale factor
---@param sy? number Y scale factor (defaults to sx)
function cam_scale(sx, sy) end

---Smooth camera following
---@param target_x number Target X position to follow
---@param target_y number Target Y position to follow
---@param follow_time? number Time in seconds to reach target (default 1.0)
function cam_follow(target_x, target_y, follow_time) end

---Set dead zone for cam_follow (camera won't move until target exceeds this zone)
---@param half_w number Half-width of dead zone in pixels
---@param half_h? number Half-height of dead zone (defaults to half_w)
function cam_deadzone(half_w, half_h) end

---Set camera offset for smooth following
---@param x number X offset from target
---@param y number Y offset from target
function cam_offset(x, y) end

---Rotate the camera by the given angle
---@param angle number Rotation angle in radians
function cam_rotate(angle) end

---Convert screen coordinates to world coordinates
---@param x number Screen X position
---@param y number Screen Y position
---@return number world_x, number world_y
function screen_to_world(x, y) end

---Convert world coordinates to screen coordinates
---@param x number World X position
---@param y number World Y position
---@return number screen_x, number screen_y
function world_to_screen(x, y) end

---Get mouse position in screen space
---@return number x, number y
function mouse_screen_pos() end

---Get mouse position in world space (camera-transformed)
---@return number x, number y
function mouse_world_pos() end

---  //////////////////////
---  POLYGON
---  //////////////////////

---Draw outlined triangle
---@param x1 number First vertex X
---@param y1 number First vertex Y
---@param x2 number Second vertex X
---@param y2 number Second vertex Y
---@param x3 number Third vertex X
---@param y3 number Third vertex Y
---@param color? number Color: palette index (1-16) OR raw 0xRRGGBB
function tri(x1, y1, x2, y2, x3, y3, color) end

---Draw filled triangle
---@param x1 number First vertex X
---@param y1 number First vertex Y
---@param x2 number Second vertex X
---@param y2 number Second vertex Y
---@param x3 number Third vertex X
---@param y3 number Third vertex Y
---@param color? number Color: palette index (1-16) OR raw 0xRRGGBB
function trif(x1, y1, x2, y2, x3, y3, color) end

---Draw outlined polygon from table of coordinates
---@param points table Flat array of coordinates {x1,y1, x2,y2, x3,y3, ...}
---@param color? number Color: palette index (1-16) OR raw 0xRRGGBB
function poly(points, color) end

---Draw filled polygon from table of coordinates
---@param points table Flat array of coordinates {x1,y1, x2,y2, x3,y3, ...}
---@param color? number Color: palette index (1-16) OR raw 0xRRGGBB
function polyf(points, color) end

---  //////////////////////
---  BEZIER CURVES
---  //////////////////////

---Create a cubic bezier curve object
---@param x1 number Start point X
---@param y1 number Start point Y
---@param cx1 number First control point X
---@param cy1 number First control point Y
---@param cx2 number Second control point X
---@param cy2 number Second control point Y
---@param x2 number End point X
---@param y2 number End point Y
---@return number id Bezier curve ID
function bezier(x1, y1, cx1, cy1, cx2, cy2, x2, y2) end

---Draw bezier curve outline
---@param id number Bezier curve ID
---@param color? number Color: palette index (1-16) OR raw 0xRRGGBB
function bezier_draw(id, color) end

---Draw filled closed bezier shape
---@param id number Bezier curve ID
---@param color? number Color: palette index (1-16) OR raw 0xRRGGBB
function bezier_drawf(id, color) end

---Get point on bezier curve at parameter t
---@param id number Bezier curve ID
---@param t number Parameter (0..1)
---@return number x X coordinate at t
---@return number y Y coordinate at t
function bezier_point(id, t) end

---Get subdivided points along bezier curve
---@param id number Bezier curve ID
---@param segments? number Number of subdivisions (default 16)
---@return table points Flat array {x1,y1, x2,y2, ...}
function bezier_points(id, segments) end

---Update control points of an existing bezier curve (full replacement)
---@overload fun(id: number, opts: {x1?: number, y1?: number, cx1?: number, cy1?: number, cx2?: number, cy2?: number, x2?: number, y2?: number})
---@param id number Bezier curve ID
---@param x1 number Start point X
---@param y1 number Start point Y
---@param cx1 number First control point X
---@param cy1 number First control point Y
---@param cx2 number Second control point X
---@param cy2 number Second control point Y
---@param x2 number End point X
---@param y2 number End point Y
function bezier_set(id, x1, y1, cx1, cy1, cx2, cy2, x2, y2) end

---Free a bezier curve
---@param id number Bezier curve ID
function bezier_free(id) end

---  //////////////////////
---  MASK
---  //////////////////////

---@class MaskConstants
---@field Inside number Draw only where mask was drawn (0)
---@field Outside number Draw only where mask was NOT drawn (1)

---Mask mode constants
---@type MaskConstants
Mask = {} ---@diagnostic disable-line: missing-fields

---Begin capturing a mask. All subsequent drawing writes to the mask buffer instead of screen.
function mask() end

---Apply the captured mask. mode: Mask.Inside (default) or Mask.Outside.
---@param mode? number Mask.Inside (0) or Mask.Outside (1)
function mask_apply(mode) end

---End masking and return to normal drawing.
function mask_end() end

---  //////////////////////
---  PHYSICS
---  //////////////////////

---Set global gravity for the physics simulation
---@param gx number Gravity X component
---@param gy number Gravity Y component
function gravity(gx, gy) end

---Create a physics body
---@param shape string Shape type: "circle", "box", or "static_box"
---@param x number X position
---@param y number Y position
---@param w_or_r number Width (box) or radius (circle)
---@param h? number Height (box only)
---@return integer id Body handle
function body(shape, x, y, w_or_r, h) end

---Get body position
---@param id integer Body handle
---@return number x X position
---@return number y Y position
function body_pos(id) end

---Get body velocity
---@param id integer Body handle
---@return number vx X velocity
---@return number vy Y velocity
function body_vel(id) end

---Get body rotation angle
---@param id integer Body handle
---@return number angle Angle in radians
function body_angle(id) end

---Set body position
---@param id integer Body handle
---@param x number X position
---@param y number Y position
function body_set_pos(id, x, y) end

---Set body velocity
---@param id integer Body handle
---@param vx number X velocity
---@param vy number Y velocity
function body_set_vel(id, vx, vy) end

---Set body rotation angle
---@param id integer Body handle
---@param angle number Angle in radians
function body_set_angle(id, angle) end

---Set body angular velocity (radians per second)
---@param id integer Body handle
---@param w number Angular velocity in radians/sec
function body_set_angular_vel(id, w) end

---Get body angular velocity
---@param id integer Body handle
---@return number w Angular velocity in radians/sec
function body_angular_vel(id) end

---Apply continuous force to body
---@param id integer Body handle
---@param fx number Force X component
---@param fy number Force Y component
function body_push(id, fx, fy) end

---Apply instant impulse to body
---@param id integer Body handle
---@param ix number Impulse X component
---@param iy number Impulse Y component
function body_impulse(id, ix, iy) end

---Called when two bodies begin colliding (magic function)
---@param a integer First body handle
---@param b integer Second body handle
function _on_collide(a, b) end

---Called when two bodies stop colliding (magic function)
---@param a integer First body handle
---@param b integer Second body handle
function _on_separate(a, b) end

---Called when a sensor body begins overlapping another body (magic function)
---@param a integer First body handle
---@param b integer Second body handle
function _on_sensor_enter(a, b) end

---Called when a sensor body stops overlapping another body (magic function)
---@param a integer First body handle
---@param b integer Second body handle
function _on_sensor_exit(a, b) end

---Set collision group for a body
---@param id integer Body handle
---@param group integer Group number
function body_group(id, group) end

---Set two groups to ignore collisions with each other
---@param group_a integer First group number
---@param group_b integer Second group number
function body_ignore(group_a, group_b) end

---Query for a body at a point
---@param x number X position
---@param y number Y position
---@return integer|nil id Body handle at point, or nil
function body_at(x, y) end

---Cast a ray and return the first body hit
---@param x1 number Ray start X
---@param y1 number Ray start Y
---@param x2 number Ray end X
---@param y2 number Ray end Y
---@return integer|nil id Body handle hit, or nil
---@return number|nil x Hit point X
---@return number|nil y Hit point Y
function body_raycast(x1, y1, x2, y2) end

---Destroy a physics body
---@param id integer Body handle
function body_destroy(id) end

---Draw debug visualization of all physics bodies
function physics_draw() end

---Manually step the physics simulation
---@param dt? number Time step (defaults to DT)
function physics_step(dt) end

---  //////////////////////
---  PARTICLES
---  //////////////////////

---@class EmitterConfig
---@field sprite? number Image ID from load_image (omit for pixel particles)
---@field frame? number[] Source rect {sx, sy, sw, sh} for frame size
---@field frame_range? number[] Frame range {start, end} (1-based indices into sprite sheet)
---@field anim_duration? number Seconds to play through frame_range
---@field anim_loop? boolean Loop animation (true) or play once and hold last frame (false)
---@field max? number Particle pool size (default 256)
---@field rate? number Particles per second (0 = manual burst only)
---@field life? number|number[] Lifetime in seconds, or {min, max} range
---@field speed? number|number[] Initial speed, or {min, max} range
---@field direction? number Emission angle in radians (default 0 = right)
---@field spread? number Emission cone spread in radians (default 0)
---@field gravity? number[]|number Gravity {gx, gy} acceleration, or single number for gy
---@field damping? number Velocity multiplier per frame for drag (default 1.0)
---@field colors? number[] Palette color indices for progression over lifetime
---@field size? number|number[] Scale {start, end} or single value
---@field spin? number|number[] Rotation speed {min, max} in radians/sec
---@field area? table Emission shape: {"circ", radius} or {"rect", w, h}

---Create a particle emitter
---@param config EmitterConfig Emitter configuration table
---@return number emitter_id Integer handle for the emitter
function emitter(config) end

---Burst-emit particles from an emitter
---@param emitter_id number Emitter handle
---@param count number Number of particles to emit
---@return number emitter_id Same handle (for chaining)
function emit(emitter_id, count) end

---Draw all active particles at position (also updates emitter position)
---@param emitter_id number Emitter handle
---@param x number World X position
---@param y number World Y position
function emitter_draw(emitter_id, x, y) end

---Pause emission (existing particles continue their life and die naturally)
---@param emitter_id number Emitter handle
function emitter_pause(emitter_id) end

---Resume emission after pause
---@param emitter_id number Emitter handle
function emitter_resume(emitter_id) end

---Stop emission and immediately clear all active particles
---Unlike emitter_pause (which freezes emission but lets existing particles finish),
---emitter_stop kills all in-flight particles instantly. Use emitter_resume to restart.
---@param emitter_id number Emitter handle
function emitter_stop(emitter_id) end

---Update emitter properties at runtime
---@param emitter_id number Emitter handle
---@param config EmitterConfig Partial config table with properties to update
function emitter_set(emitter_id, config) end

---Set emitter position without drawing
---@param emitter_id number Emitter handle
---@param x number World X position
---@param y number World Y position
function emitter_pos(emitter_id, x, y) end

---Destroy emitter and free all particles
---@param emitter_id number Emitter handle
function emitter_destroy(emitter_id) end

---Link a sub-emitter to a parent emitter
---@param parent_id number Parent emitter handle
---@param child_id number Child emitter handle
---@param mode string "life" (emit from parent particles) or "death" (burst on parent particle death)
function emitter_sub(parent_id, child_id, mode) end

---  //////////////////////
---  TWEENS
---  //////////////////////

---@class TweenOpts
---@field on_start? function Called once when tween starts running
---@field on_complete? function Called when tween finishes
---@field on_pause? function Called when tween is paused
---@field on_resume? function Called when tween is resumed
---@field on_interval? function Called periodically at the specified interval; receives elapsed time
---@field interval? number Interval period in seconds for on_interval callback
---@field delay? number Delay in seconds before tween starts

---Create a tween that animates properties on a target table
---@param target table The table whose properties will be animated
---@param duration number Duration in seconds
---@param props table Target property values (e.g. { x = 200, y = 100 })
---@param ease? number Easing curve constant (e.g. Ease.Quad, Ease.Bounce)
---@param opts? TweenOpts|function Options table with callbacks, or bare function for on_complete
---@return table handle TweenHandle
function tween(target, duration, props, ease, opts) end

---Create a callback-only timer (no property animation)
---@param duration number Duration in seconds
---@param interval? number Interval period in seconds for on_interval callback
---@param opts? TweenOpts|function Options table with callbacks, or bare function for on_complete
---@return table handle TweenHandle
function timer(duration, interval, opts) end

---Create a sequential chain of tweens (each starts when the previous finishes)
---@param ... table Tween/chain/group handles, with optional trailing TweenOpts table or function
---@return table handle TweenHandle for the chain
function chain(...) end

---Create a parallel group of tweens (all start together, completes when last finishes)
---@param ... table Tween/chain/group handles, with optional trailing TweenOpts table or function
---@return table handle TweenHandle for the group
function group(...) end

---Pause a tween, chain, or group (and all nested children)
---@param handle table|number TweenHandle or integer ID
function tween_pause(handle) end

---Resume a paused tween, chain, or group
---@param handle table|number TweenHandle or integer ID
function tween_resume(handle) end

---Cancel a tween, chain, or group without firing on_complete
---@param handle table|number TweenHandle or integer ID
function tween_cancel(handle) end

---  //////////////////////
---  SCENES
---  //////////////////////

---Switch to a scene. Clears the scene stack and sets this as the root.
---@param scene_table table Scene table with label, _init/_enter/_exit/_update/_draw/_ui callbacks
---@param transition? string Transition name: "fade", "wipe_left", "wipe_right", "wipe_up", "wipe_down", "circle", or custom
---@param duration? number Transition duration in seconds (default 0.5)
function scene(scene_table, transition, duration) end

---Push a scene on top of the stack. Previous scene stays underneath.
---@param scene_table table Scene table with label, _init/_enter/_exit/_update/_draw/_ui callbacks
---@param transition? string Transition name
---@param duration? number Transition duration in seconds (default 0.5)
function scene_push(scene_table, transition, duration) end

---Pop the top scene off the stack, returning to the one below.
---@param transition? string Transition name
---@param duration? number Transition duration in seconds (default 0.5)
function scene_pop(transition, duration) end

---Pop scenes until the given scene is on top of the stack.
---@param scene_table table Target scene to pop back to (must be on the stack)
---@param transition? string Transition name
---@param duration? number Transition duration in seconds (default 0.5)
function scene_pop_to(scene_table, transition, duration) end

---Pop all scenes back to the root scene (set by scene()).
---@param transition? string Transition name
---@param duration? number Transition duration in seconds (default 0.5)
function scene_pop_to_root(transition, duration) end

---Get the current scene table (top of stack), or nil if no scene is active.
---@return table|nil
function scene_current() end

---Get the number of scenes on the stack.
---@return number
function scene_depth() end

---Register a custom transition effect.
---@param name string Transition name (used in scene/scene_push/scene_pop)
---@param fn fun(progress: number, from_draw: fun(), to_draw: fun()) Transition render function. progress is 0.0-1.0, from_draw() renders old scene to screen, to_draw() renders new scene to screen.
function transition_add(name, fn) end

---Transition the screen out to a solid color. Returns a tween handle for use with chain().
---@param name string Transition effect name ("fade", "wipe_left", "wipe_right", "wipe_up", "wipe_down", "circle", or custom)
---@param duration? number Duration in seconds (default 0.5)
---@param color? integer Palette color index to transition to (default 0/black)
---@return TweenHandle handle Tween handle compatible with chain() and group()
function transition_out(name, duration, color) end

---Transition the screen in from a solid color. Returns a tween handle for use with chain().
---@param name string Transition effect name ("fade", "wipe_left", "wipe_right", "wipe_up", "wipe_down", "circle", or custom)
---@param duration? number Duration in seconds (default 0.5)
---@param color? integer Palette color index to transition from (default 0/black)
---@return TweenHandle handle Tween handle compatible with chain() and group()
function transition_in(name, duration, color) end

---  //////////////////////
---  CONSOLE & LOADING
---  //////////////////////

---Log a message to the console (separate from drawing print function)
---@param message string Message to log to console
function log(message) end

---Control loading state display
---@overload fun(enabled: boolean)
---@overload fun(enabled: boolean, message: string)
---@param enabled boolean True to show loading, false to hide
---@param message? string Optional loading message to display
function set_loading(enabled, message) end

---Check if loading is currently active
---@return boolean active True if loading is currently displayed
function is_loading() end

---Sleep/delay execution for specified milliseconds
---@param ms number Milliseconds to sleep
function sleep(ms) end

---Restart the game (returns to boot screen and reinitializes)
function restart() end

---  //////////////////////
---  CALLBACKS
---  //////////////////////

---Called once at startup for initialization.
---@param kwargs? table Key-value pairs from CLI `--key value` args passed after the project path (e.g., `dino8 run . --scene bell_tower` → `{scene="bell_tower"}`). Empty table if no args.
function _init(kwargs) end

---Called every frame to update game logic
function _update() end

---Called every frame to render world graphics (affected by camera)
function _draw() end

---Called every frame to render UI graphics (NOT affected by camera)
function _ui() end

---Called when a scene is activated (pushed onto the stack or re-entered after a scene above is popped).
---Use for setup that should happen each time the scene becomes active.
function _enter() end

---Called when a scene is deactivated (popped from the stack or when another scene is pushed on top).
---Use for cleanup.
function _exit() end

---  //////////////////////
---  LEVELS
---  //////////////////////

---Create a new level from level data object
---@param level_data table Level data table with fields: width, height, grid_size, tileset, tiles, tileset_cols?, camera_x?, camera_y?
---@return number level_id Level handle for future operations (-1 if failed)
function create_level(level_data) end

---Load tile data into an existing level (legacy function, prefer create_level with tiles)
---@param level_id number Level handle from create_level
---@param tiles_data table Array of tile IDs (width * height values)
function load_level_tiles(level_id, tiles_data) end

---Get tile ID at specific coordinates
---@param level_id number Level handle
---@param x number Cell X coordinate (0-based)
---@param y number Cell Y coordinate (0-based)
---@return number tile_id Tile ID at position (0 if empty or out of bounds)
function get_tile(level_id, x, y) end

---Set tile ID at specific coordinates
---@param level_id number Level handle
---@param x number Cell X coordinate (0-based)
---@param y number Cell Y coordinate (0-based)
---@param tile_id number Tile ID to set (0 = empty, 1+ = sprite index)
function set_tile(level_id, x, y, tile_id) end

---Get tile at (x, y) in the current active level (PICO-8 style shorthand for get_tile)
---Uses whichever level was most recently created or set as active.
---@param x number Cell X coordinate (0-based)
---@param y number Cell Y coordinate (0-based)
---@return number tile_id Tile ID at position (0 if empty, no active level, or out of bounds)
function mget(x, y) end

---Set tile at (x, y) in the current active level (PICO-8 style shorthand for set_tile)
---Uses whichever level was most recently created or set as active.
---@param x number Cell X coordinate (0-based)
---@param y number Cell Y coordinate (0-based)
---@param tile_id number Tile ID to set (0 = empty, 1+ = sprite index)
function mset(x, y, tile_id) end

---Draw portion of the current active level to screen (PICO-8 style shorthand for draw_level)
---All parameters are optional – defaults to drawing the whole map at screen origin.
---@param cell_x? number Starting cell X in the level (default 0)
---@param cell_y? number Starting cell Y in the level (default 0)
---@param screen_x? number Screen X coordinate to draw at (default 0)
---@param screen_y? number Screen Y coordinate to draw at (default 0)
---@param cell_w? number Width in cells to draw (default: full map width)
---@param cell_h? number Height in cells to draw (default: full map height)
function map(cell_x, cell_y, screen_x, screen_y, cell_w, cell_h) end

---Draw portion of level to screen using sprites from tileset
---@param level_id number Level handle
---@param cell_x number Starting cell X coordinate in level (0-based)
---@param cell_y number Starting cell Y coordinate in level (0-based)
---@param screen_x number Screen X coordinate to draw at
---@param screen_y number Screen Y coordinate to draw at
---@param cell_width number Width in cells to draw
---@param cell_height number Height in cells to draw
function draw_level(level_id, cell_x, cell_y, screen_x, screen_y, cell_width, cell_height) end

---Get level dimensions and grid size
---@param level_id number Level handle
---@return number width Level width in cells
---@return number height Level height in cells
---@return number grid_size Size of each cell in pixels
function get_level_info(level_id) end

---Destroy level and free memory
---@param level_id number Level handle to destroy
function destroy_level(level_id) end

---  //////////////////////
---  SNAPSHOT
---  //////////////////////

---Capture current screen to snapshot buffer
---The snapshot can later be drawn using snap_draw()
function snap() end

---Draw portion of snapshot to screen (atlas-style, like spr)
---@param sx number Source X in snapshot
---@param sy number Source Y in snapshot
---@param sw number Source width
---@param sh number Source height
---@param dx number Destination X on screen
---@param dy number Destination Y on screen
function snap_draw(sx, sy, sw, sh, dx, dy) end

---Clear snapshot and free memory
function snap_clear() end

---  //////////////////////
---  GIF CAPTURE
---  //////////////////////

---Start recording a GIF
---Press F9 to toggle recording, or call this function from Lua
---@param duration? number Recording duration in seconds (default 10.0)
---@return boolean success True if recording started
function gif_start(duration) end

---Stop recording and save the GIF
---Automatically called after duration expires, or call manually to stop early
---@return boolean success True if GIF was saved successfully
function gif_stop() end

---Check if currently recording a GIF
---@return boolean recording True if recording is in progress
function gif_recording() end

---Get remaining recording time in seconds
---@return number seconds Remaining time (0 if not recording)
function gif_remaining() end

---  //////////////////////
---  TABLE UTILITIES (PICO-8 style)
---  //////////////////////

---Add a value to a table (PICO-8 style)
---Appends to end by default, or inserts at specific index
---@param t table The table to modify
---@param v any The value to add
---@param i? number Optional index to insert at (shifts existing elements)
---@return any value The value that was added
function add(t, v, i) end

---Delete first occurrence of value from table (PICO-8 style)
---Searches for value and removes it, shifting subsequent elements down
---@param t table The table to modify
---@param v any The value to find and delete
---@return any|nil deleted The deleted value, or nil if not found
function del(t, v) end

---Delete element at index from table (PICO-8 style)
---Removes element at index and shifts subsequent elements down
---@param t table The table to modify
---@param i? number Index to delete (defaults to last element)
---@return any|nil deleted The deleted value, or nil if index out of bounds
function deli(t, i) end

---Count elements in table sequence (PICO-8 style)
---Returns total count, or counts occurrences of specific value
---@param t table The table to count
---@param v? any Optional value to count occurrences of
---@return number count Number of elements (or occurrences of v)
function count(t, v) end

---Call function for each element in table (PICO-8 style)
---Iterates through sequence, calling fn(v) for each non-nil element
---@param t table The table to iterate
---@param fn fun(v: any) Function to call with each element
function foreach(t, fn) end

---Iterator for table sequence (PICO-8 style)
---Returns iterator that yields non-nil values, for use with for...in
---@param t table The table to iterate
---@return fun(): any iterator Iterator function
---Example: for ship in all(ships) do ship:update() end
function all(t) end

---  //////////////////////
---  FILTERS
---  //////////////////////

---@alias FilterName "hqx"|"crt"|"chromatic"

---Enable a visual filter by name
---@param name FilterName Filter name: "hqx", "crt", or "chromatic"
function filter_enable(name) end

---Disable a visual filter by name
---@param name FilterName Filter name: "hqx", "crt", or "chromatic"
function filter_disable(name) end

---Toggle a visual filter on/off
---@param name FilterName Filter name: "hqx", "crt", or "chromatic"
function filter_toggle(name) end

---Check if a visual filter is currently enabled
---@param name FilterName Filter name: "hqx", "crt", or "chromatic"
---@return boolean enabled True if the filter is enabled
function filter_is_enabled(name) end

---@class HqxFilterSettings
---@field filter "hqx"
---@field scale? 2|3|4 Upscale factor (default: 2)

---@class CrtFilterSettings
---@field filter "crt"
---@field scanline? number Scanline intensity 0.0-1.0 (default: 0.3)
---@field curvature? number Screen curvature 0.0-1.0 (default: 0.2)

---@class ChromaticFilterSettings
---@field filter "chromatic"
---@field intensity? number Aberration intensity 0.0-1.0 (default: 0.5)

---Configure filter-specific settings
---@param opts HqxFilterSettings|CrtFilterSettings|ChromaticFilterSettings Settings table with filter name and options
function filter_settings(opts) end

---@class HqxSettings
---@field enabled boolean Whether the filter is enabled
---@field scale 2|3|4 Current upscale factor

---@class CrtSettings
---@field enabled boolean Whether the filter is enabled
---@field scanline number Scanline intensity 0.0-1.0
---@field curvature number Screen curvature 0.0-1.0

---@class ChromaticSettings
---@field enabled boolean Whether the filter is enabled
---@field intensity number Aberration intensity 0.0-1.0

---Get current settings for a filter
---@param name FilterName Filter name: "hqx", "crt", or "chromatic"
---@return HqxSettings|CrtSettings|ChromaticSettings settings Current filter settings
function filter_get_settings(name) end

---  //////////////////////
---  CUSTOM SHADERS
---  //////////////////////

---Load a custom fragment shader from file or inline GLSL source.
---Returns a handle (1-8) for use with post_process_add/post_process_remove/shader_set/shader_apply.
---If the source contains "/" or ends in ".glsl", it's treated as a file path
---relative to the game directory. Otherwise it's treated as inline GLSL.
---Shaders should use VARYING, TEXTURE2D, and FRAGCOLOR macros for cross-platform compatibility.
---Engine-provided uniforms (uppercase): SCREEN (sampler2D), RESOLUTION (vec2), TIME (float), MOUSE (vec2), GAME_RESOLUTION (vec2), PALETTE (sampler2D), PALETTE_SIZE (float), MASK (sampler2D), MASK_OFFSET (vec2), MASK_SIZE (vec2).
---@param name string Shader display name
---@param source string GLSL fragment shader source or file path (e.g., "shaders/wave.glsl")
---@param uniforms? table<string, number|number[]> Initial uniform values (e.g., { amount = 0.5, tint = {0.2, 0.5, 1.0, 1.0} })
---@param post_process? boolean If true, add to the post-process pipeline immediately
---@return integer handle Shader handle (1-8)
function shader_load(name, source, uniforms, post_process) end

---Add a shader to the post-process pipeline. It will run as a full-screen effect after drawing.
---@param handle integer Shader handle returned by shader_load
function post_process_add(handle) end

---Remove a shader from the post-process pipeline.
---@param handle integer Shader handle returned by shader_load
function post_process_remove(handle) end

---Set a custom uniform on a shader. Supports float (1 arg), vec2 (2 args), vec3 (3 args), vec4 (4 args).
---Can also pass a table of 1-4 values instead of flat args (e.g., `shader_set(fx, "u_target", rgb(12))`).
---@param handle integer Shader handle returned by shader_load
---@param name string Uniform name (e.g., "u_amount")
---@param v1 number|number[] First value, or a table of 1-4 values
---@param v2? number Second value (for vec2/vec3/vec4)
---@param v3? number Third value (for vec3/vec4)
---@param v4? number Fourth value (for vec4)
function shader_set(handle, name, v1, v2, v3, v4) end

---Apply a shader to the current screen buffer mid-draw.
---The shader receives SCREEN (sampler2D), MASK (sampler2D), and engine-provided uniforms.
---Optionally pass a render target slot as mask — its pixels control where the effect applies.
---The mask position can be offset with x, y for animating panels without redrawing the mask.
---@param handle integer Shader handle returned by shader_load
---@param mask_rt? integer Render target slot (1-8) to use as mask. Omit for full-screen.
---@param x? integer X offset for mask position on screen (default 0)
---@param y? integer Y offset for mask position on screen (default 0)
function shader_apply(handle, mask_rt, x, y) end

---Unload a custom shader and free its slot
---@param handle integer Shader handle returned by shader_load
function shader_unload(handle) end

---  //////////////////////
---  PAUSE MENU
---  //////////////////////

---Add a custom item to the pause menu
---Custom items appear after RESUME and before OPTIONS in the pause menu.
---When selected, the callback function is called and the menu closes.
---@param label string The menu item label (will be converted to uppercase)
---@param callback fun() Function to call when the item is selected
function menu_item(label, callback) end

---Clear all custom menu items and submenus
---Removes all items added with menu_item() and menu_add()
function menu_clear() end

---@class MenuItemDef
---@field label string Display label for the menu item
---@field type "toggle"|"dropdown"|"range"|"action" Control type
---@field value? any Initial value (boolean for toggle, string for dropdown, number for range)
---@field options? string[] Available options for dropdown type
---@field min? number Minimum value for range type
---@field max? number Maximum value for range type
---@field step? number Step increment for range type (default 1 for int, 0.1 for float)
---@field on_changed? fun(value: any) Callback when value changes

---@class SubmenuDef
---@field title? string Submenu title (defaults to parent label)
---@field items MenuItemDef[] Array of menu items

---@class MenuAddConfig
---@field parent string Parent menu path ("main" or "main.submenu_name")
---@field label string Label shown in parent menu
---@field submenu SubmenuDef Submenu definition with items

---Add a custom submenu to the pause menu
---Creates a submenu with configurable controls (toggle, dropdown, range).
---Submenus appear in the main pause menu and can be nested.
---@param config MenuAddConfig Configuration for the submenu
---
---Example:
---```lua
---menu_add({
---    parent = "main",
---    label = "Settings",
---    submenu = {
---        title = "GAME SETTINGS",
---        items = {
---            {
---                label = "Music Volume",
---                type = "range",
---                value = 100,
---                min = 0, max = 100, step = 10,
---                on_changed = function(v) set_music_volume(v) end
---            },
---            {
---                label = "Language",
---                type = "dropdown",
---                value = "english",
---                options = {"english", "french", "german"},
---                on_changed = function(v) set_language(v) end
---            },
---            {
---                label = "Subtitles",
---                type = "toggle",
---                value = true,
---                on_changed = function(v) SUBTITLES = v end
---            }
---        }
---    }
---})
---```
function menu_add(config) end

---@class MenuAddItemConfig
---@field parent string Parent menu: "options" for system options menu, or custom menu path (e.g., "main.settings")
---@field label string Display label for the menu item
---@field type "toggle"|"dropdown"|"range"|"action" Control type
---@field value? any Initial value (boolean for toggle, string for dropdown, number for range)
---@field options? string[] Available options for dropdown type
---@field min? number Minimum value for range type
---@field max? number Maximum value for range type
---@field step? number Step increment for range type (default 1 for int, 0.1 for float)
---@field on_changed? fun(value: any) Callback when value changes

---Add a single menu item to an existing menu
---Can add items to the built-in "options" menu or to user-created custom menus.
---Duplicate items (same label) are rejected with an error.
---@param config MenuAddItemConfig Configuration for the menu item
---
---Example - Add language selector to options menu:
---```lua
---menu_add_item({
---    parent = "options",
---    label = "Language",
---    type = "dropdown",
---    value = "english",
---    options = {"english", "french", "german", "spanish"},
---    on_changed = function(val)
---        i18n.load(val)
---        save.set_setting("language", val)
---    end
---})
---```
---
---Example - Add item to custom menu:
---```lua
---menu_add_item({
---    parent = "main.settings",
---    label = "Difficulty",
---    type = "dropdown",
---    value = "normal",
---    options = {"easy", "normal", "hard"},
---    on_changed = function(val) DIFFICULTY = val end
---})
---```
function menu_add_item(config) end

---Get the current value of a menu item
---@param path string Path to the menu item (e.g., "main.settings.language" or "options.language")
---@return any|nil value The current value, or nil if not found
function menu_get(path) end

---Set the value of a menu item
---@param path string Path to the menu item (e.g., "main.settings.language")
---@param value any The new value
function menu_set(path, value) end

---Hide a section of the built-in pause menu
---@param section "options"|"filters"|"controls"|"restart"|"quit" Section to hide
function menu_hide(section) end

---Re-show a previously hidden section of the built-in pause menu
---@param section "options"|"filters"|"controls"|"restart"|"quit" Section to show
function menu_show(section) end

---Register a custom pause scene. When ESC is pressed, this scene will be pushed
---instead of the built-in pause menu. Pass nil to clear and use the built-in.
---@param scene_table table|nil Scene table with _init/_enter/_exit/_update/_draw/_ui callbacks
---
---Example:
---```lua
---local pause = { label = "pause" }
---
---function pause._enter()
---    pause()  -- freeze physics, particles, tweens
---end
---
---function pause._update()
---    if btnp("escape") or btnp(5) then
---        scene_pop()
---    end
---end
---
---function pause._draw()
---    cls(0)
---    print("PAUSED", 50, 50, 15)
---end
---
---function pause._exit()
---    unpause()
---end
---
---set_pause_scene(pause)
---```
function set_pause_scene(scene_table) end

---Freeze physics, particles, and tweens. Typically called from a pause scene's _enter.
function pause() end

---Resume physics, particles, and tweens. Typically called from a pause scene's _exit.
function unpause() end

---  //////////////////////
---  CONFIGURATION
---  //////////////////////

---@class ConfigAssets
---@field sprites? string Path to sprite sheet PNG
---@field map? string Path to tilemap JSON file
---@field music? string[] Array of music file paths

---@class Config
---@field title string Game title
---@field author string Creator name
---@field version string Semantic version string
---@field description string Short project description
---@field type string Project type: "game", "tool", or "data"
---@field entry string Entry script file
---@field thumbnail? string Path to thumbnail image
---@field tags? string[] Array of tag strings
---@field width number Canvas width in pixels
---@field height number Canvas height in pixels
---@field scale number Window scale multiplier
---@field gif_scale number GIF capture scale factor
---@field fullscreen boolean Fullscreen mode
---@field speed number Game speed multiplier
---@field assets ConfigAssets Asset paths
---@field orientation string Screen orientation: "landscape", "portrait", or "both"
---@field mobile_controls boolean Show on-screen virtual controls
---@field render_offset number Vertical render position (0-1)

---Global read-only configuration table populated from conf.d8.
---Access any conf.d8 value at runtime: CONFIG.title, CONFIG.version, etc.
---@type Config
CONFIG = {} ---@diagnostic disable-line: missing-fields

---  //////////////////////
---  PLATFORM DETECTION
---  //////////////////////

---@class Platform
---@field name string Platform category: "desktop", "mobile", or "web"
---@field os string Operating system: "macos", "windows", "linux", "ios", or "web"
---@field is_mobile boolean True if running on mobile (iOS/Android)
---@field is_web boolean True if running in web browser
---@field is_desktop boolean True if running on desktop (macOS/Windows/Linux)

---Global platform information table
---Use this to write platform-specific game logic.
---Example: if PLATFORM.is_mobile then open_keyboard() end
---@type Platform
---@diagnostic disable-next-line: missing-fields
PLATFORM = {}

---  //////////////////////
---  INPUT MODE & GLYPHS
---  //////////////////////

---@alias InputMode "keyboard"|"touch"|"gamepad"

---Get the current input mode for a player
---The input mode automatically switches based on the last input device used.
---@param player? integer Player index (0-3, default 0)
---@return InputMode mode Current input mode: "keyboard", "touch", or "gamepad"
function get_input_mode(player) end

---Called when input mode changes (optional callback)
---Implement this function in your game to react to input device changes.
---@param mode InputMode The new input mode
function _input_changed(mode) end

---Called when the app is about to be suspended (console sleep, mobile background).
---Use to save progress, pause audio, or release resources.
function _on_suspend() end

---Called when the app resumes from suspend.
---Use to validate state or refresh UI.
function _on_resume() end

---Called before the app quits.
---Use for final cleanup or save state.
function _on_quit() end

---Called when the app loses focus (alt-tab, home button).
function _on_focus_lost() end

---Called when the app gains focus.
function _on_focus_gained() end

---Returns true if the previous session crashed (crash marker was found on boot).
---Use in _init() to offer recovery or skip problematic state.
---@return boolean crashed
function had_crash() end

---Called after a hot refresh (Ctrl+R or auto-reload on file change).
---Hot refresh preserves scene state — use this to update any derived data.
---NOT called during a full hot reload (Ctrl+Shift+R), which calls _init() instead.
function _on_refresh() end

---Check if a gamepad/controller is connected
---@param player? integer Player index (0-3, default 0)
---@return boolean connected True if a gamepad is connected
function gamepad_connected(player) end

---Get the name of the connected gamepad
---@param player? integer Player index (0-3, default 0)
---@return string|nil name Controller name, or nil if none connected
function gamepad_name(player) end

---Get the number of connected gamepads
---@return integer count Number of connected gamepads (0-4)
function gamepad_count() end

---Get horizontal axis value (unified keyboard + gamepad)
---Keyboard arrows/bindings produce -1.0 or 1.0, gamepad analog stick produces -1.0 to 1.0.
---When both are active, the input with greater magnitude wins.
---@param player? integer Player index (0-3, default 0)
---@return number x Horizontal axis value from -1.0 (left) to 1.0 (right)
function axis_x(player) end

---Get vertical axis value (unified keyboard + gamepad)
---Keyboard arrows/bindings produce -1.0 or 1.0, gamepad analog stick produces -1.0 to 1.0.
---When both are active, the input with greater magnitude wins.
---@param player? integer Player index (0-3, default 0)
---@return number y Vertical axis value from -1.0 (up) to 1.0 (down)
function axis_y(player) end

---Get both axis values (unified keyboard + gamepad)
---Shorthand for calling axis_x() and axis_y() together.
---@param player? integer Player index (0-3, default 0)
---@return number x Horizontal axis (-1.0 left to 1.0 right)
---@return number y Vertical axis (-1.0 up to 1.0 down)
function axis(player) end

---Get right stick horizontal axis value (gamepad only)
---@param player? integer Player index (0-3, default 0)
---@return number rx Right stick X from -1.0 (left) to 1.0 (right), 0.0 in deadzone
function axis_rx(player) end

---Get right stick vertical axis value (gamepad only)
---@param player? integer Player index (0-3, default 0)
---@return number ry Right stick Y from -1.0 (up) to 1.0 (down), 0.0 in deadzone
function axis_ry(player) end

---Get both right stick axis values (gamepad only)
---@param player? integer Player index (0-3, default 0)
---@return number rx Right stick X (-1.0 left to 1.0 right)
---@return number ry Right stick Y (-1.0 up to 1.0 down)
function axis_right(player) end

---Get left trigger analog value (gamepad only)
---@param player? integer Player index (0-3, default 0)
---@return number value Trigger pull from 0.0 (released) to 1.0 (fully pressed)
function trigger_left(player) end

---Get right trigger analog value (gamepad only)
---@param player? integer Player index (0-3, default 0)
---@return number value Trigger pull from 0.0 (released) to 1.0 (fully pressed)
function trigger_right(player) end

---Global table of contextual input glyphs
---These glyph characters change appearance based on current input mode:
---  keyboard: arrow keys, Z, X, ESC
---  gamepad: d-pad, A button, B button, menu icon
---  touch: swipe arrows, tap icons, menu dots
---
---Usage: print(INPUT_GLYPH.ACTION_A .. " Jump", 10, 10, 7)
---@class InputGlyphTable
--- D-pad / arrows
---@field UP string D-pad/arrow up glyph
---@field DOWN string D-pad/arrow down glyph
---@field LEFT string D-pad/arrow left glyph
---@field RIGHT string D-pad/arrow right glyph
--- Face buttons
---@field ACTION_A string Primary action button (Z/A button/tap)
---@field ACTION_B string Secondary action button (X/B button/tap)
---@field ACTION_X string Third action button (C/X button)
---@field ACTION_Y string Fourth action button (V/Y button)
--- Shoulder buttons & triggers
---@field LB string Left bumper glyph
---@field RB string Right bumper glyph
---@field LT string Left trigger glyph
---@field RT string Right trigger glyph
--- System
---@field ESCAPE string Menu/escape button
---@type InputGlyphTable
INPUT_GLYPH = {} ---@diagnostic disable-line: missing-fields

---  //////////////////////
---  SYMBOL GLYPHS
---  //////////////////////

--- Built-in symbol glyphs accessible as UTF-8 strings.
--- These render using the Dino8 font's custom pixel glyphs.
---Usage: print(GLYPH.HEART .. " LIVES: 3", 10, 10, 8)
---@class GlyphTable
--- System
---@field CURSOR string Cursor glyph (0x80)
---@field MENU string Menu/pause glyph (0x81)
---@field INPUT_STAR string Star/home glyph (0x82)
--- D-pad / arrows
---@field UP string Up button glyph (0x83)
---@field DOWN string Down button glyph (0x84)
---@field LEFT string Left button glyph (0x85)
---@field RIGHT string Right button glyph (0x86)
--- Face buttons
---@field ACTION_A string Action A button glyph (0x87)
---@field ACTION_B string Action B button glyph (0x88)
---@field ACTION_X string Action X button glyph (0x89)
---@field ACTION_Y string Action Y button glyph (0x8A)
--- Shoulder buttons & triggers
---@field LB string Left bumper glyph (0x8B)
---@field RB string Right bumper glyph (0x8C)
---@field LT string Left trigger glyph (0x8D)
---@field RT string Right trigger glyph (0x8E)
---@field ARROW_LEFT string ← Left arrow (U+2190)
---@field ARROW_RIGHT string → Right arrow (U+2192)
---@field ARROW_UP string ↑ Up arrow (U+2191)
---@field ARROW_DOWN string ↓ Down arrow (U+2193)
---@field TRI_UP string ▲ Up triangle (U+25B2)
---@field TRI_RIGHT string ▶ Right triangle / play (U+25B6)
---@field TRI_DOWN string ▼ Down triangle (U+25BC)
---@field TRI_LEFT string ◀ Left triangle (U+25C0)
---@field TRI_UP_SM string ▴ Small up triangle (U+25B4)
---@field TRI_RIGHT_SM string ▸ Small right triangle (U+25B8)
---@field TRI_DOWN_SM string ▾ Small down triangle (U+25BE)
---@field TRI_LEFT_SM string ◂ Small left triangle (U+25C2)
---@field SQUARE string ■ Filled square / stop (U+25A0)
---@field SQUARE_OUTLINE string □ Outline square (U+25A1)
---@field CIRCLE string ● Filled circle (U+25CF)
---@field CIRCLE_OUTLINE string ○ Outline circle (U+25CB)
---@field BLOCK string █ Full block (U+2588)
---@field PAUSE string ⏸ Pause / double bar (U+23F8)
---@field STAR string ★ Star (U+2605)
---@field CHECK string ✓ Check mark (U+2713)
---@field CROSS string ✗ Ballot X (U+2717)
---@field NOTE string ♪ Eighth note (U+266A)
---@field NOTES string ♫ Beamed eighth notes (U+266B)
---@field HEART string ♥ Heart suit (U+2665)
---@field SPADE string ♠ Spade suit (U+2660)
---@field CLUB string ♣ Club suit (U+2663)
---@field DIAMOND string ♦ Diamond suit (U+2666)
---@type GlyphTable
GLYPH = {} ---@diagnostic disable-line: missing-fields

---Convert a Unicode codepoint to a UTF-8 string
---@param codepoint integer Unicode codepoint (e.g. 0x2082 for subscript 2)
---@return string utf8_char The encoded UTF-8 character
function chr(codepoint) end

---  //////////////////////
---  RENDER TARGETS
---  //////////////////////

-- Render targets are offscreen buffers that can be drawn to and saved as PNG.
-- Slots 1-8 are available. Drawing primitives can be redirected to render targets
-- using rt_target(). Color -2 represents transparency.

---Create a render target in the specified slot
---@param slot number Render target slot (1-8)
---@param width number Width in pixels
---@param height number Height in pixels
function rt_create(slot, width, height) end

---Destroy a render target and free its memory
---@param slot number Render target slot (1-8)
function rt_destroy(slot) end

---Clear a render target to transparent
---@param slot number Render target slot (1-8)
function rt_clear(slot) end

---Set the current drawing target
---All drawing primitives (pset, line, circ, rect, etc.) will draw to this target.
---When targeting a render target, camera transforms are disabled.
---@param slot? number Render target slot (1-8), or nil/omit to reset to screen
function rt_target(slot) end

---Draw a render target to the current target
---Transparent pixels (color -2) are not drawn.
---@param slot number Render target slot (1-8)
---@param x number Destination X coordinate
---@param y number Destination Y coordinate
function rt_draw(slot, x, y) end

---Capture the current screen buffer into a render target
---Copies screen pixels to the RT (clamped to the smaller dimensions).
---Must be called while the screen is the active draw target (not inside rt_target).
---@param slot number Render target slot (1-8)
function rt_capture(slot) end

---Save a render target as PNG with alpha channel
---Transparent pixels (color -2) are saved with alpha=0.
---@param slot number Render target slot (1-8)
---@param filename string Output filename (without extension)
---@return boolean success True if saved successfully
function rt_save(slot, filename) end

---Get render target width
---@param slot number Render target slot (1-8)
---@return number width Width in pixels (0 if not created)
function rt_width(slot) end

---Get render target height
---@param slot number Render target slot (1-8)
---@return number height Height in pixels (0 if not created)
function rt_height(slot) end

-- ============================================================================
-- Screenshot Functions
-- ============================================================================

---Save a screenshot of the current screen
---@param filename? string Optional filename (without extension). If omitted, uses timestamp.
---@return boolean success True if screenshot was saved successfully
function screenshot(filename) end

-- ============================================================================
-- WebSocket Functions
-- ============================================================================

---Connect to a WebSocket server
---@param url string WebSocket URL (ws:// or wss://)
---@return userdata|nil ws WebSocket handle, or nil on failure
function websocket_connect(url) end

---Send data through a WebSocket connection
---@param ws userdata WebSocket handle
---@param data string|table Data to send (tables are auto-encoded to JSON)
---@return boolean success True if sent successfully
function websocket_send(ws, data) end

---Receive next message from WebSocket queue
---@param ws userdata WebSocket handle
---@return string|nil message Next message, or nil if queue is empty
function websocket_receive(ws) end

---Check if a WebSocket connection is open
---@param ws userdata WebSocket handle
---@return boolean connected True if connected
function websocket_is_connected(ws) end

---Close a WebSocket connection
---@param ws userdata WebSocket handle
function websocket_close(ws) end

-- ============================================================================
-- HTTP Functions
-- ============================================================================

---Perform an async HTTP GET request
---@param url string URL to fetch
---@param callback fun(success: boolean, data: string) Called on completion
function http_get(url, callback) end

---Perform an async HTTP POST request
---@param url string URL to post to
---@param data string|table POST body (tables are auto-encoded to JSON)
---@param callback fun(success: boolean, data: string) Called on completion
function http_post(url, data, callback) end

-- ============================================================================
-- JSON Functions
-- ============================================================================

---Decode a JSON string into a Lua value
---@param json_string string Valid JSON string to parse
---@return any value Decoded Lua value (table, string, number, boolean, or nil)
function json_decode(json_string) end

---Encode a Lua value to a compact JSON string
---@param value any Lua value to encode (table, string, number, boolean, or nil)
---@return string json Compact JSON string without whitespace
function json_encode(value) end

---Encode a Lua value to a pretty-printed JSON string
---@param value any Lua value to encode (table, string, number, boolean, or nil)
---@return string json Formatted JSON string with indentation
function json_encode_pretty(value) end

-- ============================================================================
-- Preview Functions
-- ============================================================================

---@class PreviewHandle
---@field send fun(self: PreviewHandle, data: table) Send a message to the preview
---@field receive fun(self: PreviewHandle): table|nil Receive next message from preview
---@field is_open fun(self: PreviewHandle): boolean Check if preview window is open
---@field close fun(self: PreviewHandle) Close the preview window
---@field focus fun(self: PreviewHandle) Focus the preview window

---Open a preview window for another Dino8 project
---@param options {project: string, entry: string, title?: string, scale?: integer, watch?: table} Preview options
---@return PreviewHandle handle Preview window handle
function preview_open(options) end

---Send a message from inside a preview script back to the editor
---@param data table Data to send to the parent editor script
function preview_send(data) end

-- ============================================================================
-- Test Framework
-- ============================================================================

---Register a test case
---@param name string Test name
---@param fn fun() Test function
function test(name, fn) end

---Assert two values are equal
---@param actual any Actual value
---@param expected any Expected value
function assert_eq(actual, expected) end

---Assert a value is truthy
---@param value any Value to check
function assert_true(value) end

---Assert a value is falsy
---@param value any Value to check
function assert_false(value) end

---Assert a value is nil
---@param value any Value to check
function assert_nil(value) end

---Assert a value is not nil
---@param value any Value to check
function assert_not_nil(value) end

---Assert a function throws an error
---@param fn fun() Function expected to error
---@param msg? string Optional substring to match in error message
function assert_error(fn, msg) end

---Assert two numbers are approximately equal
---@param actual number Actual value
---@param expected number Expected value
---@param epsilon? number Maximum allowed difference (default: 0.0001)
function assert_near(actual, expected, epsilon) end

---Assert two values are not equal (deep comparison for tables)
---@param actual any Actual value
---@param expected any Value that should differ
function assert_not_eq(actual, expected) end

---Assert a number is greater than another
---@param actual number Actual value
---@param expected number Value to compare against
function assert_gt(actual, expected) end

---Assert a number is less than another
---@param actual number Actual value
---@param expected number Value to compare against
function assert_lt(actual, expected) end

---Assert a number is greater than or equal to another
---@param actual number Actual value
---@param expected number Value to compare against
function assert_gte(actual, expected) end

---Assert a number is less than or equal to another
---@param actual number Actual value
---@param expected number Value to compare against
function assert_lte(actual, expected) end

---Assert a sequential table contains a value (deep comparison)
---@param tbl table Table to search
---@param value any Value to find
function assert_contains(tbl, value) end

---Assert a value has the expected type
---@param value any Value to check
---@param expected_type string Expected type name ("string", "number", "table", etc.)
function assert_type(value, expected_type) end
