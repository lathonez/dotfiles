import XMonad
import XMonad.Config.Gnome
import XMonad.Actions.PhysicalScreens
import XMonad.ManageHook
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import qualified Data.Map as M

main = xmonad $ gnomeConfig
	{
		borderWidth          = 1
		, terminal           = "urxvt"
		, normalBorderColor  = "#cccccc"
		, focusedBorderColor = "#cd8b00"
        , keys               = screenKeys <+> myKeys <+> keys gnomeConfig
        , manageHook         = manageDocks <+> (isFullscreen --> doFullFloat) <+> manageHook gnomeConfig
        , layoutHook = smartBorders . avoidStruts $ layoutHook defaultConfig
	}

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
	]
