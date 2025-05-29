
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  Laszlo
» Original Source:  https://www.autohotkey.com/board/topic/12177-new-window-popup-blocker/
» Usage:
    ▹ Toggle with Win+X
    ▹ Emergency exit with Win+Esc
    ▹ Customize ExceptionTitles and CheckInterval as needed
    ▹ Uncomment FileAppend line for logging

∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TEMPLATE"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙



;;∙============================================================∙
;;∙============================================================∙
#SingleInstance Force
#NoEnv
SetBatchLines -1
SetTitleMatchMode 2
SetWinDelay 0

;;∙================∙SETTINGS∙==========================∙
global CheckInterval := 200

ExceptionTitles =    ;;∙------∙Add/Remove exception titles here.
(
;;∙========∙Antivirus & Security Software (3rd Party)∙========∙
Avast Antivirus, 		;;∙------∙Avast UI or alert window.
AVG Antivirus, 		;;∙------∙AVG user interface.
Bitdefender Alert, 		;;∙------∙Bitdefender warning popup.
ESET Notification, 		;;∙------∙ESET alert window.
Kaspersky Internet Security, 	;;∙------∙Kaspersky main UI.
McAfee Notification Center, 	;;∙------∙McAfee alert popups.
Norton Security, 		;;∙------∙Norton AV UI or warnings.
;;∙========∙Language & Input∙============================∙
Default IME, 	;;∙------∙Asian language input.
MSCTFIME UI 	;;∙------∙Input Method Editor (IME).
;;∙========∙Overlays & Flyouts∙===========================∙
Clipboard, 		;;∙------∙Windows clipboard history (Win+V).
Network Connections, 	;;∙------∙Wi-Fi/ethernet quick panel.
Snipping Tool, 		;;∙------∙Prevent killing the snip bar or tool window.
Volume, 			;;∙------∙System volume overlay.
;;∙========∙Security & Defender∙==========================∙
Windows Security, 	;;∙------∙Defender notifications.
;;∙=======∙System Components∙==========================∙
User Account Control, 		;;∙------∙UAC prompt title (backup for non-class detection).
;;  Windows Default Lock Screen, 	;;∙------∙*Handled via class 'LockScreenApp'.
;;  On-Screen Keyboard, 		;;∙------∙*Handled via class 'OSKMainClass'.
;;∙========∙System Tools & Settings∙=======================∙
Run, 		;;∙------∙Run dialog (Win+R) – handled via class '#32770'.
Search, 		;;∙------∙Windows 10/11 search flyout.
Settings, 		;;∙------∙Windows Settings app.
Task Manager, 	;;∙------∙Windows Task Manager.
;;∙========∙System UI Containers & Shell∙==================∙
Action Center, 			;;∙------∙Windows notifications panel (aka Notification Hub).
Start Menu, 			;;∙------∙Start menu UI.
Task Switching, 			;;∙------∙Alt+Tab interface.
Windows Shell Experience Host, 	;;∙------∙Modern UI elements.
;;;  Program Manager, 		;;∙------∙*Handled via class 'Progman' (desktop).
;;;  System Tray, 			;;∙------∙*Handled via class 'Shell_TrayWnd'.
;;;  Windows Explorer, 		;;∙------∙*Handled via class 'CabinetWClass'.
;;;  Touch Keyboard, 			;;∙------∙*Handled via class 'IPTip_Main_Window'.
;;;  Security Prompts, 		;;∙------∙*Handled via class 'Credential Dialog Xaml Host'.
;;∙=======∙Third-Party Tools∙=============================∙
Dropbox, 		;;∙------∙Cloud sync popups.
LastPass, 		;;∙------∙Password manager dialogs.
NordVPN, 	;;∙------∙VPN connection prompts.
)

;;∙================∙VARIABLES∙=========================∙
BlockingEnabled := false
InitialIDs := []
MouseX := 0
MouseY := 0


^F1::    ;;∙------∙🔥∙(Ctrl + F1)
    BlockingEnabled := !BlockingEnabled
    MouseGetPos, MouseX, MouseY    ;;∙------∙Capture cursor position.
    
    if (BlockingEnabled)
    {
        InitialIDs := GetWindowIDs()
        SetTimer, CheckWindows, %CheckInterval%

        text :=  "Blocking Active`n"
        text .= "Monitoring " . InitialIDs.Length() . " windows`n"
        text .= "Check every " . CheckInterval . " ms"

        ToolTip, % text, MouseX+20, MouseY+20
        SetTimer, TerminateTip, -2500
        SoundBeep, 1400, 300
    }
    else
    {
        SetTimer, CheckWindows, Off
        InitialIDs := []
        ToolTip, % "Blocking Disabled", MouseX+20, MouseY+20
        SetTimer, TerminateTip, -2500
        SoundBeep, 1200, 300
    }
Return


;;∙====================================================∙
CheckWindows:
    currentIDs := GetWindowIDs()
    for _, id in currentIDs    ;;∙------∙Check for new windows.
    {
        if (HasValue(InitialIDs, id))    ;;∙------∙Skip if window was in initial list.
            continue
        WinGetTitle, title, ahk_id %id%    ;;∙------∙Check exceptions.
        WinGetClass, class, ahk_id %id%
        if IsException(title, class)
            continue
        WinKill ahk_id %id%
        ;;∙------∙FileAppend, Killed %title% (%id%) [%class%]`n, blocked_windows.log    ;;∙------∙*(OPTIONAL: Log action).
    }
Return

TerminateTip:
    ToolTip
Return

GetWindowIDs() {
    ids := []
    WinGet, windows, List
    Loop %windows%
        ids.Push(windows%A_Index%)
    return ids
}

HasValue(arr, value) {
    for _, v in arr
        if (v = value)
            return true
    return false
}

IsException(title, class := "") {
    global ExceptionTitles
    if title in %ExceptionTitles%    ;;∙------∙Check full match first.
        return true
    if InStr(title, "MSCTFIME UI")    ;;∙------∙Check partial matches for dynamic system windows.
        || InStr(title, "Default IME")
        || InStr(title, "Notification Hub") 
        return true

    ;;∙------∙Class-based exceptions (common for context menus).
    if (class = "#32768") 			;;∙------∙Standard Win32 context menu.
        || (class = "Windows.UI.Core.CoreWindow") 	;;∙------∙Modern UI (Start Menu, etc).
        || (class = "Shell_TrayWnd") 		;;∙------∙System Tray.
        || (class = "CabinetWClass") 		;;∙------∙Explorer & Control Panel.
        || (class = "#32770") 			;;∙------∙SYSTEM DIALOGS (UAC, Alt+F4, Run dialog).
        || (class = "LockScreenApp") 		;;∙------∙Lock Screen.
        || (class = "IPTip_Main_Window") 		;;∙------∙Touch Keyboard.
        || (class = "OSKMainClass") 		;;∙------∙On-Screen Keyboard.
        || (class = "Progman") 			;;∙------∙DESKTOP (Program Manager).
        || (class = "Credential Dialog Xaml Host") 	;;∙------∙Password/security prompts.
        return true
    return false
}

!Esc::ExitApp    ;;∙------∙🔥∙(Alt + Esc)
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
;    Soundbeep, 1700, 100
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

