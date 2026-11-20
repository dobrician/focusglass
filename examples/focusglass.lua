-- focusglass: keep your attention on the active window.
--
-- Windows that lose focus fade to grayscale, get darker, slightly frosted and
-- see-through. The window you work in stays as it is.
--
-- Change any value below and save: Hyprland reloads its config and focusglass
-- applies the new values right away. Every effect goes from 0 (off) to 100.
--
-- Load this file from ~/.config/hypr/hyprland.lua, after require("hypr.looknfeel"),
-- so these values win over the ones there:
--
--   require("hypr.focusglass")

local plugin = (os.getenv("HOME") or "") .. "/.config/omarchy/plugins/dc.focusglass/hypr/focusglass.lua"
local ok, focusglass = pcall(dofile, plugin)
if not ok then return end -- the plugin was removed: nothing to do

focusglass.setup({
  -- false turns focusglass off and gives you back Hyprland's normal windows.
  enabled = true,

  -- How much color inactive windows lose. 100 = black and white, 0 = full color.
  grayscale = 100,

  -- How much darker inactive windows get. 50 = half as bright, 0 = no darkening.
  darkness = 50,

  -- How see-through inactive windows are. 45 = 55% opaque, 0 = fully opaque.
  transparency = 45,

  -- How frosted the content of inactive windows is. 12 = a light frost you can
  -- still read through, 100 = unreadable, 0 = sharp.
  blur = 12,

  -- Blur what shows through see-through windows (Hyprland's own blur).
  -- false leaves Hyprland's blur setting as it is.
  background_blur = true,

  -- Key that keeps the focused window normal when it loses focus, and toggles
  -- it back. It replaces Omarchy's "toggle transparency" key, and does that
  -- too. false leaves the key to Omarchy.
  exempt_key = "SUPER + BACKSPACE",
})
