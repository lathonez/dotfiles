import XMonad
import XMonad.Actions.PhysicalScreens
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.ManageHook
import XMonad.Util.Run
import qualified XMonad.StackSet as W
import qualified Data.Map as M

-- cant figure out the syntax to combine this with anything else
screenKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList
	[
		--
		-- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
		-- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
		--
		((modm .|. mask, key), f sc)
			| (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
			, (f, mask) <- [(viewScreen, 0), (sendToScreen, shiftMask)]
	]

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList
	[
		-- screenshotter
		((modm, xK_y), spawn "sleep 0.2; scrot -s '/home/lathonez/screens/screenshot-%Y%m%d%H%M%S-$wx$h.png' -e 'feh $f'")
		-- screenlocker
		, ((modm .|. XMonad.controlMask, xK_l), spawn "slock")
		-- volume keys
      	, ((0, 0x1008FF11), spawn "amixer set Master 2-")
      	, ((0, 0x1008FF13), spawn "amixer set Master 2+")
      	, ((0, 0x1008FF12), spawn "/home/lathonez/utils/xmonad/mute.sh")
	]

{-
  -- Xmobar configuration variables. These settings control the appearance
  -- of text which xmonad is sending to xmobar via the DynamicLog hook.
  --
-}

myTitleColor     = "#eeeeee" -- color of window title
myTitleLength    = 80 -- truncate window title to this length
myCurrentWSColor = "#e6744c" -- color of active workspace
myVisibleWSColor = "#c185a7" -- color of inactive workspace
myUrgentWSColor  = "#cc0000" -- color of workspace with 'urgent' window
myCurrentWSLeft  = "[" -- wrap active workspace with these
myCurrentWSRight = "]"
myVisibleWSLeft  = "(" -- wrap inactive workspace with these
myVisibleWSRight = ")"
myUrgentWSLeft   = "{" -- wrap urgent workspace with these
myUrgentWSRight  = "}"

myWorkspaces =
	[
	"1:Chrome"
	, "2:Serv"
	, "3:Subl"
	, "4:Pers"
	, "5:Term"
	, "6:"
	, "7:Meld"
	, "8:Chat"
	, "9:"
	]

main = do
	xmproc <- spawnPipe "xmobar"

	xmonad $ defaultConfig {
		borderWidth          = 1
		, terminal           = "urxvt"
		, normalBorderColor  = "#cccccc"
		, focusedBorderColor = "#cd8b00"
		, workspaces         = myWorkspaces
		, keys               = screenKeys <+> myKeys <+> keys defaultConfig
		, manageHook         = manageDocks <+> composeAll [
			(isFullscreen                 --> doFullFloat) <+> manageHook defaultConfig
			, className =? "Sublime_text" --> doF (W.shift "3:Subl")
			, className =? "Meld"         --> doF (W.shift "7:Meld")
			, appName =?   "crx_knipolnnllmklapflnccelgolnpehhpl" --> doF (W.shift "8:Chat")
		]
		, layoutHook = smartBorders . avoidStruts $ layoutHook defaultConfig
		, logHook = dynamicLogWithPP $ xmobarPP {
			ppOutput  = hPutStrLn    xmproc
			, ppTitle   = xmobarColor  myTitleColor "" . shorten myTitleLength
			, ppCurrent = xmobarColor  myCurrentWSColor ""
			. wrap myCurrentWSLeft myCurrentWSRight
			, ppVisible = xmobarColor  myVisibleWSColor ""
			. wrap myVisibleWSLeft myVisibleWSRight
			, ppUrgent  = xmobarColor  myUrgentWSColor ""
			. wrap myUrgentWSLeft  myUrgentWSRight
		}
	}