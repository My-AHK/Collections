
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  Self
» Original Source:  (SWAT) Style Windows Alpha Topmost
    ▹ Make current window Transparent, Resizable, Borderless, & AlwaysOnTop.
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "HEXIS"    ;;∙------∙(Hybrid ExStyle & Interface System)
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙

Hotkey, ^t, ToggleWindowProperties    ;;∙------∙🔥∙(Ctrl + T)

;;∙------------∙Toggle window Transparency, AlwaysOnTop, and Style∙------------∙
ToggleWindowProperties() {
;;∙------∙(Enables Transparency Effects / Makes AlwaysOnTop).
    static WS_EX_LAYERED := 0x80000, WS_EX_TOPMOST := 0x8
;;∙------∙(Retrieve-Set Extended Window Styles / Retrieve-Set Basic Window Styles).
    static GWL_EXSTYLE := -20, GWL_STYLE := -16
;;∙------∙Flags to enable alpha-based transparency / Preserve window size during changes / Preserve window position during changes / Transparancy range: 0-255).
    static LWA_ALPHA := 0x2, SWP_NOSIZE := 0x1, SWP_NOMOVE := 0x2, WN_TRSP := 128
;;∙------∙Flags to Force window to redraw its frame / Ensure window remains visible.
    static SWP_FRAMECHANGED := 0x20, SWP_SHOWWINDOW := 0x40

    hwnd := WinExist("A")

    ;;∙------∙Get current styles.
    ExStyle := DllCall("GetWindowLong", "Ptr", hwnd, "Int", GWL_EXSTYLE)
    Style := DllCall("GetWindowLong", "Ptr", hwnd, "Int", GWL_STYLE)
    ;;∙------∙Check current states.
    isLayered := ExStyle & WS_EX_LAYERED
    isTopmost := ExStyle & WS_EX_TOPMOST
    if (isLayered && isTopmost) {
        ;;∙------∙Disable effects.
        NewExStyle := ExStyle & ~(WS_EX_LAYERED | WS_EX_TOPMOST)
        DllCall("SetWindowLong", "Ptr", hwnd, "Int", GWL_EXSTYLE, "UInt", NewExStyle)
        DllCall("SetLayeredWindowAttributes", "Ptr", hwnd, "UInt", 0, "UInt", 255, "UInt", LWA_ALPHA)
        DllCall("SetWindowPos", "Ptr", hwnd, "Ptr", -2, "Int",0, "Int",0, "Int",0, "Int",0, "UInt", SWP_NOSIZE | SWP_NOMOVE | SWP_FRAMECHANGED)
        ;;∙------∙Restore window styles.
        NewStyle := (Style & ~0x40000) | 0xC00000  ; Remove WS_SIZEBOX, add WS_CAPTION
        DllCall("SetWindowLong", "Ptr", hwnd, "Int", GWL_STYLE, "UInt", NewStyle)
    } else {
        ;;∙------∙Enable effects.
        NewExStyle := ExStyle | WS_EX_LAYERED | WS_EX_TOPMOST
        DllCall("SetWindowLong", "Ptr", hwnd, "Int", GWL_EXSTYLE, "UInt", NewExStyle)
        DllCall("SetLayeredWindowAttributes", "Ptr", hwnd, "UInt", 0, "UInt", WN_TRSP, "UInt", LWA_ALPHA)
        DllCall("SetWindowPos", "Ptr", hwnd, "Ptr", -1, "Int",0, "Int",0, "Int",0, "Int",0, "UInt", SWP_NOSIZE | SWP_NOMOVE | SWP_FRAMECHANGED)
        ;;∙------∙Modify window styles.
        NewStyle := (Style | 0x40000) & ~0xC00000  ; Add WS_SIZEBOX, remove WS_CAPTION
        DllCall("SetWindowLong", "Ptr", hwnd, "Int", GWL_STYLE, "UInt", NewStyle)
    }
    ;;∙------∙Force window redraw.
    DllCall("SetWindowPos", "Ptr", hwnd, "Ptr", 0, "Int",0, "Int",0, "Int",0, "Int",0, "UInt", SWP_NOSIZE | SWP_NOMOVE | SWP_FRAMECHANGED | SWP_SHOWWINDOW)
}
Return
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
HEXIS:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

