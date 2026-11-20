-- lua tests/test_patch.lua [path to Hyprland's surface.frag.inc]
-- Checks that focusglass can patch the installed Hyprland surface shader, that
-- settings are validated, and that a changed shader is refused instead of broken.

local dir = arg[0]:match("^(.*)/tests/") or "."
hl = nil -- not running inside Hyprland
local fg = dofile(dir .. "/hypr/focusglass.lua")

local failures = 0
local function check(cond, msg)
  if not cond then failures = failures + 1; print("FAIL: " .. msg) else print("ok:   " .. msg) end
end

local inc_path = arg[1] or "/usr/include/hyprland/src/render/shaders/surface.frag.inc"
local f = assert(io.open(inc_path), "missing " .. inc_path)
local src = f:read("a"):gsub('^R"#%(', ""):gsub('%)#"%s*$', "")
f:close()

local s = fg.resolve({})
local out, err = fg.patch(src, s)
check(out ~= nil, "patches the installed shader" .. (err and (" (" .. err .. ")") or ""))
if out then
  check(out:match("^#version 300 es\n"), "#version stays on the first line")
  check(out:find(fg.MARKER, 1, true), "carries the focusglass marker")
  check(not out:find("pixColor.rgb = pixColor.rgb * tint;", 1, true), "no plain dim left")
  check(out:find("FG_BRIGHTNESS   = 0.5000;", 1, true), "darkness 50 -> brightness 0.5")
  check(out:find("FG_BLUR_RADIUS  = 1.2000;", 1, true), "blur 12 -> 1.2 px")
  local o = io.open(os.getenv("FG_OUT") or "/dev/null", "w"); o:write(out); o:close()
end

local _, problems = fg.resolve({ darkness = 150, grayscale = "lots", nope = 1, enabled = "yes" })
check(#problems == 4, "reports bad settings (" .. #problems .. ")")
local clamped = fg.resolve({ darkness = 150 })
check(clamped.darkness == 100, "clamps out-of-range values")

local broken = src:gsub("pixColor.rgb = pixColor.rgb %* tint;", "pixColor.rgb *= tint;")
local bad, why = fg.patch(broken, s)
check(bad == nil and why, "refuses a shader it does not recognize")

os.exit(failures == 0 and 0 or 1)
