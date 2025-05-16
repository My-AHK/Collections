
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  Self
» Original Source:  
» Code Flow: 
    ▹ First run → UAC → normal or reload if RDP.
    ▹ Reload triggered → reload tooltip shown, new instance launched with /reloaded.
    ▹ New instance → tray tip "Script relaunched..." → then exits.
    ▹ Original instance → exits after reload timer triggers.
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
#SingleInstance, Force    ;;∙------∙Prevents multiple instances of the script and forces new execution.

#InstallKeybdHook    ;;∙------∙Ensures the hook is installed immediately before any hotkeys that might depend on it.
#InstallMouseHook    ;;∙------∙Ensures the hook is installed immediately before any mouse-keys are defined.
;;∙------∙#UseHook    ;;∙------∙Uncomment if hotkeys misbehave (Positional).

#MaxThreadsPerHotkey 3    ;;∙------∙Sets the maximum simultaneous threads for each hotkey.
#NoEnv    ;;∙------∙Avoids checking empty environment variables for optimization.
#Persistent    ;;∙------∙Keeps the script running indefinitely when there are no hotkeys, timers, or GUI.

SendMode, Input    ;;∙------∙Sets SendMode to Input for faster and more reliable keystrokes.
SetBatchLines -1    ;;∙------∙Disables batch line delays for immediate execution of commands.
SetWinDelay 0    ;;∙------∙Removes delays between window-related commands.

SetTitleMatchMode 2    ;;∙------∙Enables partial title matching for window detection.

OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.
SetTimer, UpdateCheck, 750    ;;∙------∙Sets a timer to call UpdateCheck every 750 milliseconds.

ScriptID := "RDP_Reloader"

Menu, Tray, Icon, mstscax.dll, 10    ;;∙------∙Sets the system tray icon.
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
;;∙============================================================∙
#Requires AutoHotkey 1.1    ;;∙------∙AHK version compliance check.
#SingleInstance, Force    ;;∙------∙Prevents double-launch or error dialogs before anything else runs.
#InstallKeybdHook    ;;∙------∙Ensures the hook is installed immediately before any hotkeys that might depend on it.
#InstallMouseHook    ;;∙------∙Ensures the hook is installed immediately before any mouse-keys are defined.
#UseHook    ;;∙------∙Force all hotkeys defined after it (positional) to use the hook method.

if (!A_IsAdmin) {
    try {
        Run *RunAs "%A_ScriptFullPath%" %A_Args%    ;;∙------∙Relaunch with admin rights + preserve args.
        ExitApp
    } catch {
        MsgBox,,, Admin Required, This script requires administrator privileges., 5
        ExitApp
    }
}

global HasReloadedAlready := A_Args[1] = "/reloaded"    ;;∙------∙Short form (Concise and easy to read/yields false if it doesn’t exist).
;;∙------∙global HasReloadedAlready := (A_Args.Length() > 0 && A_Args[1] = "/reloaded")    ;;∙------∙Long form (Guards against out‑of‑bounds access/Useful for clarity or defensive coding).

if (HasReloadedAlready) {
    TrayTip,, Script relaunched for RDP adaptation.`nExiting original instance..., 2, 1    ;;∙------∙Notify user before exit.
    Sleep 1500
    ExitApp    ;;∙------∙Exit immediately if this is the reloaded RDP session.
}

CheckIfRunningInRDP()
Return


;;∙------------------------------------------------∙
CheckIfRunningInRDP() {
    global HasReloadedAlready

    rdpSession := DllCall("GetSystemMetrics", "Int", 0x1000)    ;;∙------∙SM_REMOTESESSION = 0x1000

    if (rdpSession && !HasReloadedAlready) {
        HasReloadedAlready := true
        SetTimer, ReloadScript, -100
    }
}

ReloadScript:
    try {
        TrayTip,, Reloading for RDP adaptation..., 1
        Reload "/reloaded"
    } catch {
        MsgBox,,, Failed to reload script., 3
    }
Return
;;∙============================================================∙
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
RDP_Reloader:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

