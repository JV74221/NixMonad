--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------

import XMonad
import XMonad.Hooks.InsertPosition

-- Combinators
import XMonad.Hooks.EwmhDesktops

-- Xmobar
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.Loggers

-- Layouts
import XMonad.Layout.Renamed
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed

-- Bindings
import XMonad.Util.EZConfig

-- Volume
import XMonad.Actions.Volume

--------------------------------------------------------------------------------
-- Main
--------------------------------------------------------------------------------

main :: IO ()
main =
  xmonad.
  ewmhFullscreen.
  ewmh.
  withEasySB (statusBarProp "xmobar" (pure xPP)) defToggleStrutsKey
  $ myConfig

xPP :: PP
xPP = def {
  -- Print the tag of the currently focused workspace.
  ppCurrent = xmobarColor "#afd700" "" . wrap "[ " " ]",

  -- Print tags of visible but not focused workspaces.
  ppHidden = xmobarColor "#ffaf00" "" . wrap "[ " " ]",

  -- Print tags of empty hidden workspaces.
  ppHiddenNoWindows = wrap "" "",

  -- Layout name format.
  ppLayout = xmobarColor "#5fafd7" "",

  -- Window title format for the focused window.
  ppTitle = xmobarColor "#ff5faf" "" . wrap "[ " " ]",

  -- How to order the different log sections.
  ppOrder = \[ws, l, wins] -> [ws, l, wins]
}

--------------------------------------------------------------------------------
-- Configuration
--------------------------------------------------------------------------------

myConfig = def {
  -- Rebind Mod to the Super key
  -- mod1Mask = Left Alt (default)
  -- mod3Mask = Right Alt
  modMask = mod4Mask,

  -- Default terminal program
  terminal = "xterm",

  -- Border colors
  normalBorderColor = "#d0d0d0",
  focusedBorderColor = "#afd700",

  -- Mouse settings
  focusFollowsMouse = False,
  clickJustFocuses = False,

  -- Startup settings
  startupHook = spawn "/home/$USER/.config/xmonad/autostart.sh",

  ------------------------------------------------------------------------------
  -- Layout
  ------------------------------------------------------------------------------

  layoutHook =

  -- Tabbed layout without borders
  (renamed [Replace "Tabbed"] $ noBorders (tabbed shrinkText myTabConfig)) |||

  -- Vertical split with borders
  (renamed [Replace "Vsplit"] $ Tall 1 (3/100) (1/2)) |||

  -- Horizontal split with borders
  (renamed [Replace "Hsplit"] $ Mirror (Tall 1 (3/100) (1/2)))

  ------------------------------------------------------------------------------
} -- Keybindings
  ------------------------------------------------------------------------------

  `additionalKeys`
  [
    -- Volume controls
    ((mod4Mask, xK_F2), lowerVolume 2 >> return ()),
    ((mod4Mask, xK_F3), raiseVolume 2 >> return ()),
    ((mod4Mask, xK_F4), toggleMute >> return ())
  ]

--------------------------------------------------------------------------------
-- Tabbed Layout Theme
--------------------------------------------------------------------------------

myTabConfig = def {
  -- Font name
  fontName = "xft:Inter:size=10:bold:antialias=true:hinting=true",

  -- Color of the active window
  activeColor = "#1c1c1c",

  -- Color of the border of the active window
  activeBorderColor = "#afd700",

  -- Color of the text of the active window
  activeTextColor = "#afd700",

  -- Color of the inactive window
  inactiveColor = "#1c1c1c",

  -- Color of the border of the inactive window
  inactiveBorderColor = "#d7af5f",

  -- Color of the text of the inactive window
  inactiveTextColor = "#d7af5f"
}

