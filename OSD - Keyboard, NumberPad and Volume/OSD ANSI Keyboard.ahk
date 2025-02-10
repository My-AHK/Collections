
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  
» Original Source:  
» 
    ▹ 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TEMPLATE"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙🔥 HotKey 🔥∙===========================================∙
^t::    ;;∙------∙(Ctrl+T) 
    Soundbeep, 1000, 200
;;∙============================================================∙




;;∙============================================================∙
k_FontSize = 10    ;;<∙------∙Changing this font size will resize the keyboard.
k_FontName = Verdana    ;;∙------∙This can be blank to use the system's default font.
k_FontStyle = Bold    ;;∙------∙Example of an alternative: Italic Underline.
 
k_MenuItemHide := "Hide keyboard"
k_MenuItemShow := "Show keyboard"
 
k_Monitor = 1    ;;∙------∙Put "2" to set the keyboard on monitor 2, etc. (blank = primary monitor):

Menu, Tray, Add, %k_MenuItemHide%, k_ShowHide    ;;∙------∙Alter the tray icon menu:
Menu, Tray, Add, &Exit, k_MenuExit
Menu, Tray, Default, %k_MenuItemHide%
Menu, Tray, NoStandard

k_KeyWidth := k_FontSize * 3    ;;∙------∙Calculate object dimensions based on chosen font size:
k_KeyHeight := k_FontSize * 3
k_KeyWidth0 := k_KeyWidth * 2

k_KeyMargin := k_FontSize // 6     ;;∙------∙Spacing to be used between the keys.

width := 15 * k_KeyWidth + 14 * k_KeyMargin    ;;∙------∙The total width of the keyboard in terms of the keys and their margins.

k_KeyWidthHalf := k_KeyWidth / 2    ;;∙------∙Values for specially sized keys. The first and last keys of each row are critical for proper sizing.
k_TabW := k_FontSize * 4
k_CapsW := k_KeyWidth + k_KeyMargin + k_KeyWidthHalf
k_ShiftW := 2 * k_KeyWidth + k_KeyMargin
k_SpacebarWidth := k_FontSize * 17
k_LastKeyWidth := width - ( k_TabW + 12 * k_KeyWidth + 13 * k_KeyMargin )
k_EnterWidth := width - ( k_CapsW + 11 * k_KeyWidth + 12 * k_KeyMargin )
k_LastShiftWidth := width - ( k_ShiftW + 10 * k_KeyWidth + 11 * k_KeyMargin )
k_LastCtrlWidth := width - ( 6 * k_TabW + k_SpacebarWidth + 7 * k_KeyMargin )

k_KeySize = w%k_KeyWidth% h%k_KeyHeight%    ;;∙------∙Only a facilitator for creating GUI.
k_KeySize0 = w%k_KeyWidth0% h%k_KeyHeight%
k_Position = x+%k_KeyMargin% %k_KeySize%
k_Numpad0 = x+%k_KeyMargin% %k_KeySize0%

k_Characters := {"" : ""    ;;∙------∙This table is used to relate the hotkeys pressed with their progress bars to flash them when pressed.
    , "``"          :  1
    , 1             :  2
    , 2             :  3
    , 3             :  4
    , 4             :  5
    , 5             :  6
    , 6             :  7
    , 7             :  8
    , 8             :  9
    , 9             : 10
    , 0             : 11
    , "-"           : 12
    , "="           : 13
    , "Backspace"   : 14
    , "Tab"         : 15
    , "Q"           : 16
    , "W"           : 17
    , "E"           : 18
    , "R"           : 19
    , "T"           : 20
    , "Y"           : 21
    , "U"           : 22
    , "I"           : 23
    , "O"           : 24
    , "P"           : 25
    , "["           : 26
    , "]"           : 27
    , "\"           : 28
    , "CapsLock"    : 29
    , "A"           : 30
    , "S"           : 31
    , "D"           : 32
    , "F"           : 33
    , "G"           : 34
    , "H"           : 35
    , "J"           : 36
    , "K"           : 37
    , "L"           : 38
    , ";"           : 39
    , "'"           : 40
    , "Enter"       : 41
    , "LShift"      : 42
    , "Z"           : 43
    , "X"           : 44
    , "C"           : 45
    , "V"           : 46
    , "B"           : 47
    , "N"           : 48
    , "M"           : 49
    , ","           : 50
    , "."           : 51
    , "/"           : 52
    , "RShift"      : 53
    , "LCtrl"       : 54
    , "LWin"        : 55
    , "LAlt"        : 56
    , "Space"       : 57
    , "RAlt"        : 58
    , "RWin"        : 59
    , "AppsKey"     : 60
    , "RCtrl"       : 61
    , "Insert"      : 62
    , "Home"        : 63
    , "PgUp"        : 64
    , "Delete"      : 65
    , "End"         : 66
    , "PgDn"        : 67
    , "Up"          : 68
    , "Left"        : 69
    , "Down"        : 70
    , "Right"       : 71
    , "NumLock"     : 72
    , "NumpadDiv"   : 73
    , "NumpadMult"  : 74
    , "NumpadSub"   : 75
    , "Numpad7"     : 76
    , "Numpad8"     : 77
    , "Numpad9"     : 78
    , "NumpadAdd"   : 79
    , "Numpad4"     : 80
    , "Numpad5"     : 81
    , "Numpad6"     : 82
    , "Numpad1"     : 83
    , "Numpad2"     : 84
    , "Numpad3"     : 85
    , "NumpadEnter" : 86
    , "Numpad0"     : 87
    , "NumpadDot"   : 88 }

zwnbs := Chr(8204)    ;;∙------∙Zero-width non-breaking space
labels := { ""     : ""
    , "AppsKey"    : "App"
    , "BackSpace"  : Chr(0x1F844)
    , "CapsLock"   : "Caps"
    , "Delete"     : "Del"
    , "Down"       : Chr(0x2B9F)
    , "End"        : Chr(0x21F2)
    , "Home"       : Chr(0x21F1)
    , "Insert"     : "Ins"
    , "LAlt"       : "Alt"
    , "LCtrl"      : "Ctrl"
    , "Left"       : Chr(0x2B9C)
    , "LShift"     : "Shift"
    , "LWin"       : "Win"
    , "NumLock"    : Chr(0x1F512)
    , "Numpad0"    : "0" zwnbs
    , "Numpad1"    : "1" zwnbs
    , "Numpad2"    : "2" zwnbs
    , "Numpad3"    : "3" zwnbs
    , "Numpad4"    : "4" zwnbs
    , "Numpad5"    : "5" zwnbs
    , "Numpad6"    : "6" zwnbs
    , "Numpad7"    : "7" zwnbs
    , "Numpad8"    : "8" zwnbs
    , "Numpad9"    : "9" zwnbs
    , "NumpadAdd"  : "+"
    , "NumpadDiv"  : "/" zwnbs
    , "NumpadDot"  : "." zwnbs
    , "NumpadEnter": "Ent"
    , "NumpadMult" : "*"
    , "NumpadSub"  : "-" zwnbs
    , "PgDn"       : "PD"
    , "PgUp"       : "PU"
    , "RAlt"       : "Alt" zwnbs
    , "RCtrl"      : "Ctrl" zwnbs
    , "Right"      : Chr(0x2B9E)
    , "RShift"     : "Shift" zwnbs
    , "RWin"       : "Win" zwnbs
    , "Tab"        : Chr(0x2B7E)
    , "Up"         : Chr(0x2B9D) }

Gui, Font, s%k_FontSize% %k_FontStyle%, %k_FontName%    ;;∙------∙Create a GUI window for the on-screen keyboard:
Gui, +E0x20 -Caption +AlwaysOnTop -MaximizeBox +ToolWindow

/*
∙------------∙TAKE NOTE ∙------------------------∙
» About keyboards: Tab and Ctrl have the same size, all the buttons on the far right fit to the size of the keyboard (dictated by the first line), 
» Left Shift is the same size as Backspace (on Western keyboards), and the window size is given by x1 + 15 * + 14 * wKey kMargin and y1 + 5 * 4 * + hKey kMargin (where x1 and y1 are the coordinates of the first key on the top left of the keyboard).
∙-----------------------------------------------------∙
*/

;;∙------------∙The first row of the virtual keyboard∙-----------------∙
Gui, Add, Progress, Section xm ym %k_KeySize% Disabled vprg1
Gui, Add, Progress, %k_Position% Disabled vprg2
Gui, Add, Progress, %k_Position% Disabled vprg3
Gui, Add, Progress, %k_Position% Disabled vprg4
Gui, Add, Progress, %k_Position% Disabled vprg5
Gui, Add, Progress, %k_Position% Disabled vprg6
Gui, Add, Progress, %k_Position% Disabled vprg7
Gui, Add, Progress, %k_Position% Disabled vprg8
Gui, Add, Progress, %k_Position% Disabled vprg9
Gui, Add, Progress, %k_Position% Disabled vprg10
Gui, Add, Progress, %k_Position% Disabled vprg11
Gui, Add, Progress, %k_Position% Disabled vprg12
Gui, Add, Progress, %k_Position% Disabled vprg13
Gui, Add, Progress, x+%k_KeyMargin% w%k_ShiftW% h%k_KeyHeight% Disabled vprg14
Gui, Add, Progress, %k_Position% Disabled ; Make some space
Gui, Add, Progress, %k_Position% Disabled vprg62 ; Insert
Gui, Add, Progress, %k_Position% Disabled vprg63 ; Home
Gui, Add, Progress, %k_Position% Disabled vprg64 ; PgUp
Gui, Add, Progress, %k_Position% Disabled ; Make some space
Gui, Add, Progress, %k_Position% Disabled vprg72 ; NumLock
Gui, Add, Progress, %k_Position% Disabled vprg73 ; NumpadDiv
Gui, Add, Progress, %k_Position% Disabled vprg74 ; NumpadMult
Gui, Add, Progress, %k_Position% Disabled vprg75 ; NumpadSub

;;∙------------∙The second row of the virtual keyboard∙-------------∙
Gui, Add, Progress, xm y+%k_KeyMargin% w%k_TabW% h%k_KeyHeight% Disabled vprg15
Gui, Add, Progress, %k_Position% Disabled vprg16
Gui, Add, Progress, %k_Position% Disabled vprg17
Gui, Add, Progress, %k_Position% Disabled vprg18
Gui, Add, Progress, %k_Position% Disabled vprg19
Gui, Add, Progress, %k_Position% Disabled vprg20
Gui, Add, Progress, %k_Position% Disabled vprg21
Gui, Add, Progress, %k_Position% Disabled vprg22
Gui, Add, Progress, %k_Position% Disabled vprg23
Gui, Add, Progress, %k_Position% Disabled vprg24
Gui, Add, Progress, %k_Position% Disabled vprg25
Gui, Add, Progress, %k_Position% Disabled vprg26
Gui, Add, Progress, %k_Position% Disabled vprg27
Gui, Add, Progress, x+%k_KeyMargin% w%k_LastKeyWidth% h%k_KeyHeight% Disabled vprg28
Gui, Add, Progress, %k_Position% Disabled ; Make some space
Gui, Add, Progress, %k_Position% Disabled vprg65 ; Delete
Gui, Add, Progress, %k_Position% Disabled vprg66 ; End
Gui, Add, Progress, %k_Position% Disabled vprg67 ; PgDn
Gui, Add, Progress, %k_Position% Disabled ; Make some space
Gui, Add, Progress, %k_Position% Disabled vprg76 ; Numpad7
Gui, Add, Progress, %k_Position% Disabled vprg77 ; Numpad8
Gui, Add, Progress, %k_Position% Disabled vprg78 ; Numpad9
Gui, Add, Progress, %k_Position% Disabled vprg79 ; NumpadAdd

;;∙------------∙The third row of the virtual keyboard∙----------------∙
Gui, Add, Progress, xm y+%k_KeyMargin% w%k_CapsW% h%k_KeyHeight% Disabled vprg29
Gui, Add, Progress, %k_Position% Disabled vprg30
Gui, Add, Progress, %k_Position% Disabled vprg31
Gui, Add, Progress, %k_Position% Disabled vprg32
Gui, Add, Progress, %k_Position% Disabled vprg33
Gui, Add, Progress, %k_Position% Disabled vprg34
Gui, Add, Progress, %k_Position% Disabled vprg35
Gui, Add, Progress, %k_Position% Disabled vprg36
Gui, Add, Progress, %k_Position% Disabled vprg37
Gui, Add, Progress, %k_Position% Disabled vprg38
Gui, Add, Progress, %k_Position% Disabled vprg39
Gui, Add, Progress, %k_Position% Disabled vprg40
Gui, Add, Progress, x+%k_KeyMargin% w%k_EnterWidth% h%k_KeyHeight% Disabled vprg41
Gui, Add, Progress, %k_Position% Disabled    ;;∙------∙Make some space
Gui, Add, Progress, %k_Position% Disabled    ;;∙------∙Make some space
Gui, Add, Progress, %k_Position% Disabled    ;;∙------∙Make some space
Gui, Add, Progress, %k_Position% Disabled    ;;∙------∙Make some space
Gui, Add, Progress, %k_Position% Disabled    ;;∙------∙Make some space
Gui, Add, Progress, %k_Position% Disabled vprg80    ;;∙------∙Numpad4
Gui, Add, Progress, %k_Position% Disabled vprg81    ;;∙------∙Numpad5
Gui, Add, Progress, %k_Position% Disabled vprg82    ;;∙------∙`

;;∙------------∙The fourth row of the virtual keyboard∙--------------∙
Gui, Add, Progress, xm y+%k_KeyMargin% w%k_ShiftW% h%k_KeyHeight% Disabled vprg42
Gui, Add, Progress, %k_Position% Disabled vprg43
Gui, Add, Progress, %k_Position% Disabled vprg44
Gui, Add, Progress, %k_Position% Disabled vprg45
Gui, Add, Progress, %k_Position% Disabled vprg46
Gui, Add, Progress, %k_Position% Disabled vprg47
Gui, Add, Progress, %k_Position% Disabled vprg48
Gui, Add, Progress, %k_Position% Disabled vprg49
Gui, Add, Progress, %k_Position% Disabled vprg50
Gui, Add, Progress, %k_Position% Disabled vprg51
Gui, Add, Progress, %k_Position% Disabled vprg52
Gui, Add, Progress, x+%k_KeyMargin% w%k_LastShiftWidth% h%k_KeyHeight% Disabled vprg53
Gui, Add, Progress, %k_Position% Disabled    ;;∙------∙Make some space
Gui, Add, Progress, %k_Position% Disabled    ;;∙------∙Make some space
Gui, Add, Progress, %k_Position% Disabled vprg68    ;;∙------∙Up
Gui, Add, Progress, %k_Position% Disabled    ;;∙------∙Make some space
Gui, Add, Progress, %k_Position% Disabled    ;;∙------∙Make some space
Gui, Add, Progress, %k_Position% Disabled vprg83    ;;∙------∙Numpad1
Gui, Add, Progress, %k_Position% Disabled vprg84    ;;∙------∙Numpad2
Gui, Add, Progress, %k_Position% Disabled vprg85    ;;∙------∙Numpad3
Gui, Add, Progress, %k_Position% Disabled vprg86    ;;∙------∙NumpadEnter

;;∙------------∙The last row of the virtual keyboard keys∙------------∙
Gui, Add, Progress, xm y+%k_KeyMargin% w%k_TabW% h%k_KeyHeight% Disabled vprg54
Gui, Add, Progress, x+%k_KeyMargin% w%k_TabW% h%k_KeyHeight% Disabled vprg55
Gui, Add, Progress, x+%k_KeyMargin% w%k_TabW% h%k_KeyHeight% Disabled vprg56
Gui, Add, Progress, x+%k_KeyMargin% w%k_SpacebarWidth% h%k_KeyHeight% Disabled vprg57
Gui, Add, Progress, x+%k_KeyMargin% w%k_TabW% h%k_KeyHeight% Disabled vprg58
Gui, Add, Progress, x+%k_KeyMargin% w%k_TabW% h%k_KeyHeight% Disabled vprg59
Gui, Add, Progress, x+%k_KeyMargin% w%k_TabW% h%k_KeyHeight% Disabled vprg60
Gui, Add, Progress, x+%lastPos% w%k_LastCtrlWidth% h%k_KeyHeight% Disabled vprg61
Gui, Add, Progress, %k_Position% Disabled    ;;∙------∙Make some space
Gui, Add, Progress, %k_Position% Disabled vprg69    ;;∙------∙Left
Gui, Add, Progress, %k_Position% Disabled vprg70    ;;∙------∙Down
Gui, Add, Progress, %k_Position% Disabled vprg71    ;;∙------∙Right
Gui, Add, Progress, %k_Position% Disabled    ;;∙------∙Make some space
Gui, Add, Progress, %k_Numpad0% Disabled vprg87    ;;∙------∙Numpad0
Gui, Add, Progress, %k_Position% Disabled vprg88    ;;∙------∙NumpadDot

/*
Add a button for each key.
Position the first button with absolute coordinates so that all other buttons can be positioned relative to it.
*/

;;∙------------∙The first row of the virtual keyboard∙-----------------∙
Gui, Add, Button, section xm ym %k_KeySize%, ``
Gui, Add, Button, %k_Position%, 1
Gui, Add, Button, %k_Position%, 2
Gui, Add, Button, %k_Position%, 3
Gui, Add, Button, %k_Position%, 4
Gui, Add, Button, %k_Position%, 5
Gui, Add, Button, %k_Position%, 6
Gui, Add, Button, %k_Position%, 7
Gui, Add, Button, %k_Position%, 8
Gui, Add, Button, %k_Position%, 9
Gui, Add, Button, %k_Position%, 0
Gui, Add, Button, %k_Position%, -
Gui, Add, Button, %k_Position%, =
Gui, Add, Button, x+%k_KeyMargin% w%k_ShiftW% h%k_KeyHeight%, % labels["Backspace"]
Gui, Add, Progress, %k_Position% Disabled    ;;∙------∙Make some space
Gui, Add, Button, %k_Position%, Ins
Gui, Add, Button, %k_Position%, % labels["Home"]
Gui, Add, Button, %k_Position%, % labels["PgUp"]
Gui, Add, Progress, %k_Position% Disabled    ;;∙------∙Make some space
Gui, Add, Button, %k_Position%, % labels["NumLock"]
Gui, Add, Button, %k_Position%, % labels["NumpadDiv"]
Gui, Add, Button, %k_Position%, *
Gui, Add, Button, %k_Position%, % labels["NumpadSub"]

;;∙------------∙The second row of the virtual keyboard∙-------------∙
Gui, Add, Button, xm y+%k_KeyMargin% w%k_TabW% h%k_KeyHeight%, % labels["Tab"]
Gui, Add, Button, %k_Position%, Q
Gui, Add, Button, %k_Position%, W
Gui, Add, Button, %k_Position%, E
Gui, Add, Button, %k_Position%, R
Gui, Add, Button, %k_Position%, T
Gui, Add, Button, %k_Position%, Y
Gui, Add, Button, %k_Position%, U
Gui, Add, Button, %k_Position%, I
Gui, Add, Button, %k_Position%, O
Gui, Add, Button, %k_Position%, P
Gui, Add, Button, %k_Position%, [
Gui, Add, Button, %k_Position%, ]
Gui, Add, Button, x+%k_KeyMargin% w%k_LastKeyWidth% h%k_KeyHeight%, \
Gui, Add, Progress, %k_Position% Disabled ; Make some space
Gui, Add, Button, %k_Position%, Del
Gui, Add, Button, %k_Position%, % labels["End"]
Gui, Add, Button, %k_Position%, % labels["PgDn"]
Gui, Add, Progress, %k_Position% Disabled ; Make some space
Gui, Add, Button, %k_Position%, % labels["Numpad7"]
Gui, Add, Button, %k_Position%, % labels["Numpad8"]
Gui, Add, Button, %k_Position%, % labels["Numpad9"]
Gui, Add, Button, %k_Position%, +

;;∙------------∙The third row of the virtual keyboard∙----------------∙
Gui, Add, Button, xm y+%k_KeyMargin% w%k_CapsW% h%k_KeyHeight%, % labels["CapsLock"]
Gui, Add, Button, %k_Position%, A
Gui, Add, Button, %k_Position%, S
Gui, Add, Button, %k_Position%, D
Gui, Add, Button, %k_Position%, F
Gui, Add, Button, %k_Position%, G
Gui, Add, Button, %k_Position%, H
Gui, Add, Button, %k_Position%, J
Gui, Add, Button, %k_Position%, K
Gui, Add, Button, %k_Position%, L
Gui, Add, Button, %k_Position%, `;
Gui, Add, Button, %k_Position%, '
Gui, Add, Button, x+%k_KeyMargin% w%k_EnterWidth% h%k_KeyHeight%, Enter
Gui, Add, Progress, %k_Position% Disabled    ;;∙------∙Make some space
Gui, Add, Progress, %k_Position% Disabled    ;;∙------∙Make some space
Gui, Add, Progress, %k_Position% Disabled    ;;∙------∙Make some space
Gui, Add, Progress, %k_Position% Disabled    ;;∙------∙Make some space
Gui, Add, Progress, %k_Position% Disabled    ;;∙------∙Make some space
Gui, Add, Button, %k_Position%, % labels["Numpad4"]
Gui, Add, Button, %k_Position%, % labels["Numpad5"]
Gui, Add, Button, %k_Position%, % labels["Numpad6"]
;;∙------------∙The fourth row of the virtual keyboard∙--------------∙
Gui, Add, Button, xm y+%k_KeyMargin% w%k_ShiftW% h%k_KeyHeight%, % labels["LShift"]
Gui, Add, Button, %k_Position%, Z
Gui, Add, Button, %k_Position%, X
Gui, Add, Button, %k_Position%, C
Gui, Add, Button, %k_Position%, V
Gui, Add, Button, %k_Position%, B
Gui, Add, Button, %k_Position%, N
Gui, Add, Button, %k_Position%, M
Gui, Add, Button, %k_Position%, `,
Gui, Add, Button, %k_Position%, .
Gui, Add, Button, %k_Position%, /
Gui, Add, Button, x+%k_KeyMargin% w%k_LastShiftWidth% h%k_KeyHeight%, % labels["RShift"]
Gui, Add, Progress, %k_Position% Disabled    ;;∙------∙Make some space
Gui, Add, Progress, %k_Position% Disabled    ;;∙------∙Make some space
Gui, Add, Button, %k_Position%, % labels["Up"]
Gui, Add, Progress, %k_Position% Disabled    ;;∙------∙Make some space
Gui, Add, Progress, %k_Position% Disabled    ;;∙------∙Make some space
Gui, Add, Button, %k_Position%, % labels["Numpad1"]
Gui, Add, Button, %k_Position%, % labels["Numpad2"]
Gui, Add, Button, %k_Position%, % labels["Numpad3"]
Gui, Add, Button, %k_Position%, % labels["NumpadEnter"]

;;∙------------∙The last row of the virtual keyboard∙------------------∙
Gui, Add, Button, xm y+%k_KeyMargin% w%k_TabW% h%k_KeyHeight%, % labels["LCtrl"]
Gui, Add, Button, x+%k_KeyMargin% w%k_TabW% h%k_KeyHeight%, % labels["LWin"]
Gui, Add, Button, x+%k_KeyMargin% w%k_TabW% h%k_KeyHeight%, % labels["LAlt"]
Gui, Add, Button, x+%k_KeyMargin% w%k_SpacebarWidth% h%k_KeyHeight%, Space
Gui, Add, Button, x+%k_KeyMargin% w%k_TabW% h%k_KeyHeight%, % labels["RAlt"]
Gui, Add, Button, x+%k_KeyMargin% w%k_TabW% h%k_KeyHeight%, % labels["RWin"]
Gui, Add, Button, x+%k_KeyMargin% w%k_TabW% h%k_KeyHeight%, % labels["AppsKey"]
Gui, Add, Button, x+%k_KeyMargin% w%k_LastCtrlWidth% h%k_KeyHeight%, % labels["RCtrl"]
Gui, Add, Progress, %k_Position% Disabled    ;;∙------∙Make some space
Gui, Add, Button, %k_Position%, % labels["Left"]
Gui, Add, Button, %k_Position%, % labels["Down"]
Gui, Add, Button, %k_Position%, % labels["Right"]
Gui, Add, Progress, %k_Position% Disabled    ;;∙------∙Make some space
Gui, Add, Button, %k_Numpad0%, % labels["Numpad0"]
Gui, Add, Button, %k_Position%, % labels["NumpadDot"]

;;∙------∙Show the keyboard centered but not active (to maintain the current window's focus):
Gui, Show, xCenter NoActivate, Virtual Keyboard View
 
;;∙------∙Control whether the virtual keyboard is displayed on the screen or not.
k_IsVisible = y
 
;;∙------∙Get the window's Width and Height through the GUI's name.
WinGetPos,,, k_WindowWidth, k_WindowHeight, Virtual Keyboard View
 
;;∙------∙Position the keyboard at the bottom of the screen while avoiding the taskbar:
SysGet, k_WorkArea, MonitorWorkArea, %k_Monitor%

;;∙------------∙Calculate window's X-position∙-------------------------∙
k_WindowX = %k_WorkAreaRight%
k_WindowX -= %k_WorkAreaLeft%    ;;∙------∙Now k_WindowX contains the width of this monitor.
k_WindowX -= %k_WindowWidth%
k_WindowX /= 2    ;;∙------∙Calculate position to center it horizontally.

;;∙------∙The following is done in case the window will be on a non-primary monitor or if the taskbar is anchored on the left side of the screen:
k_WindowX += %k_WorkAreaLeft%

;;∙------------∙Calculate window's Y-position∙-------------------------∙
k_WindowY = %k_WorkAreaBottom%
k_WindowY -= %k_WindowHeight%
 
;;∙------∙Move the window to the bottom-center position of the monitor.
WinMove, Virtual Keyboard View,, %k_WindowX%, %k_WindowY%
 
;;∙------∙Make the window transparent (the number regulates the transparency).
WinSet, Transparent, 128, Virtual Keyboard View

;;∙------∙Set all keys as hotkeys. See www.asciitable.com
k_n = 1
k_ASCII = 45

Loop {
    ;;∙------∙Change number into a real character.
    k_char := Chr(k_ASCII)

    ;;∙------∙These keys are only accessible using modifier keys; that's why we're escaping them.
    if k_char not in <,>,^,`,,?,:,@
        Hotkey, ~*%k_char%, flashButton
        ;;∙------∙In the above, the asterisk prefix allows the key to be detected regardless
        ;;∙------∙of whether the user is holding down modifier keys such as Control and Shift.
        ;;∙------∙And without "~" the character wouldn't be shown in the window.

    k_ASCII++

;;∙------∙Stop looping at the last key of the keyboard ("]").
} until (k_ASCII = 94)

Return

;;∙------∙When a key is pressed by the user, flash the corresponding button on-screen:
;;∙------∙Fire the corresponding subroutine when we press special + normal keys.
~*`::
~*Backspace::
~*Tab::
~*CapsLock::
~*'::
~*Enter::
~*LShift::
~*,::
~*RShift::
~*LCtrl::    ;;∙------∙Must use Ctrl, not Control, to match button names.
~*LWin::
~*LAlt::
~*Space::
~*RAlt::
~*RWin::
~*AppsKey::
~*RCtrl::

~*Insert::
~*Home::
~*PgUp::
~*Delete::
~*End::
~*PgDn::

~*Up::
~*Left::
~*Down::
~*Right::

~*NumLock::
~*NumpadDiv::
~*NumpadMult::
~*Numpad7::
~*Numpad8::
~*Numpad9::
~*Numpad4::
~*Numpad5::
~*Numpad6::
~*Numpad1::
~*Numpad2::
~*Numpad3::
~*Numpad0::
~*NumpadDot::
~*NumpadSub::
~*NumpadAdd::
~*NumpadEnter::flashButton()


;;∙------∙Show or hide the keyboard if the variable is "y" or "n".
Ctrl & `::
k_ShowHide:
    if k_IsVisible = y
    {
        ;;∙------∙Hide the keyboard gui, change the tray option's name, and flip visibility.
        Gui, Cancel
        Menu, Tray, Rename, %k_MenuItemHide%, %k_MenuItemShow%
        k_IsVisible = n
    }
    else
    {
        ;;∙------∙Do the opposite.
        Gui, Show
        Menu, Tray, Rename, %k_MenuItemShow%, %k_MenuItemHide%
        k_IsVisible = y
    }
return

;;∙------------∙Function used to flash the button∙---------------------∙
flashButton()
{
;;∙------∙Erase the key ("~*").
    StringReplace, k_ThisHotkey, A_ThisHotkey, ~*

;;∙------∙Prevents the T and B keys from being confused as Tab and Backspace.
    SetTitleMatchMode, 3

;;∙------∙Find the variable's index for the control.
    global k_Characters
    index := k_Characters[k_ThisHotkey]

;;∙------∙Change the color of the corresponding progress bar to red (beginning of the flashing's process).
    GuiControl, +BackgroundRed, prg%index%

;;∙------∙Wait for the release of the key.
    KeyWait, %k_ThisHotkey%

;;∙------∙Remove the flash color.
    GuiControl, -Background, prg%index%

;;∙------∙Redraw the button on release (needed because the buttons' names differ from the hotkeys' names).
    global labels
    if (labels.HasKey(k_ThisHotkey))
    {
        GuiControl, MoveDraw, % labels[k_ThisHotkey]
    }
    else
    {
        GuiControl, MoveDraw, % k_ThisHotkey
    }
}

;;∙------∙Exit the script (via Escape when active, the window's x button, or system tray Exit option).
GuiEscape:
GuiClose:
k_MenuExit:
    ExitApp
;;∙============================================================∙




;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙EDIT \ RELOAD / EXIT∙===================================∙
;;∙-----------------------∙EDIT \ RELOAD / EXIT∙--------------------------∙
RETURN
;;∙-------∙EDIT∙-------∙EDIT∙------------∙
Script·Edit:    ;;∙------∙Menu Call.
    Edit
Return
;;∙------∙RELOAD∙----∙RELOAD∙-------∙
^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        Soundbeep, 1200, 250
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        Soundbeep, 1000, 300
    ExitApp
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Gui Drag Pt 2∙==========================================∙
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Script Updater∙=========================================∙
UpdateCheck:    ;;∙------Check if the script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute Sub∙======================================∙
AutoExecute:
#MaxThreadsPerHotkey 3    ;;∙------∙Sets the maximum simultaneous threads for each hotkey.
#NoEnv    ;;∙------∙Avoids checking empty environment variables for optimization.
;;∙------∙#NoTrayIcon    ;;∙------∙Hides the tray icon if uncommented.
#Persistent    ;;∙------∙Keeps the script running indefinitely.
#SingleInstance, Force    ;;∙------∙Prevents multiple instances of the script and forces new execution.
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.
SendMode, Input    ;;∙------∙Sets SendMode to Input for faster and more reliable keystrokes.
SetBatchLines -1    ;;∙------∙Disables batch line delays for immediate execution of commands.
SetTimer, UpdateCheck, 500    ;;∙------∙Sets a timer to call UpdateCheck every 500 milliseconds.
SetTitleMatchMode 2    ;;∙------∙Enables partial title matching for window detection.
SetWinDelay 0    ;;∙------∙Removes delays between window-related commands.
Menu, Tray, Icon, imageres.dll, 3    ;;∙------∙Sets the system tray icon.
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Tray Menu∙============================================∙
TrayMenu:
Menu, Tray, Tip, %ScriptID%
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Suspend / Pause, %ScriptID%    ;;∙------∙Script Header.
Menu, Tray, Icon, Suspend / Pause, shell32, 28
Menu, Tray, Default, Suspend / Pause    ;;∙------∙Makes Bold.
;;∙------∙Script∙Extentions∙------------∙
Menu, Tray, Add
Menu, Tray, Add, Help Docs, Documentation
Menu, Tray, Icon, Help Docs, wmploc.dll, 130
Menu, Tray, Add
Menu, Tray, Add, Key History, ShowKeyHistory
Menu, Tray, Icon, Key History, wmploc.dll, 65
Menu, Tray, Add
Menu, Tray, Add, Window Spy, ShowWindowSpy
Menu, Tray, Icon, Window Spy, wmploc.dll, 21
Menu, Tray, Add
;;∙------∙Script∙Options∙---------------∙
Menu, Tray, Add
Menu, Tray, Add, Script Edit, Script·Edit
Menu, Tray, Icon, Script Edit, imageres.dll, 247
Menu, Tray, Add
Menu, Tray, Add, Script Reload, Script·Reload
Menu, Tray, Icon, Script Reload, mmcndmgr.dll, 47
Menu, Tray, Add
Menu, Tray, Add, Script Exit, Script·Exit
Menu, Tray, Icon, Script Exit, shell32.dll, 272
Menu, Tray, Add
Menu, Tray, Add
Return
;;------------------------------------------∙
Documentation:
    Run, "C:\Program Files\AutoHotkey\AutoHotkey.chm"
Return
ShowKeyHistory:
    KeyHistory
Return
ShowWindowSpy:
    Run, "C:\Program Files\AutoHotkey\WindowSpy.ahk"
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙MENU CALLS∙==========================================∙
TEMPLATE:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
    Suspend
    Soundbeep, 700, 100
    Pause
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙TRAY MENU POSITION∙==================================∙
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20
Return
;;∙------∙TRAY MENU POSITION FUNTION∙------∙
NotifyTrayClick(P*) { 
Static Msg, Fun:="NotifyTrayClick", NM:=OnMessage(0x404,Func(Fun),-1),  Chk,T:=-250,Clk:=1
  If ( (NM := Format(Fun . "_{:03X}", Msg := P[2])) && P.Count()<4 )
     Return ( T := Max(-5000, 0-(P[1] ? Abs(P[1]) : 250)) )
  Critical
  If ( ( Msg<0x201 || Msg>0x209 ) || ( IsFunc(NM) || Islabel(NM) )=0 )
     Return
  Chk := (Fun . "_" . (Msg<=0x203 ? "203" : Msg<=0x206 ? "206" : Msg<=0x209 ? "209" : ""))
  SetTimer, %NM%,  %  (Msg==0x203        || Msg==0x206        || Msg==0x209)
    ? (-1, Clk:=2) : ( Clk=2 ? ("Off", Clk:=1) : ( IsFunc(Chk) || IsLabel(Chk) ? T : -1) )
Return True
}
Return
;;∙============================================================∙

;;∙------------------------------------------------------------------------------------------∙
;;∙========================∙SCRIPT END∙=========================∙
;;∙------------------------------------------------------------------------------------------∙

