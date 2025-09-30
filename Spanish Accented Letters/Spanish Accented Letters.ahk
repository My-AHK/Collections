
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

;;∙======∙HotKey∙===============================================∙
^t::    ;;∙------∙🔥∙(Ctrl + T)
    Soundbeep, 1000, 200
;;∙============================================================∙




;;∙============================================================∙
;;∙============================================================∙

;;∙============================================================∙
;;∙------∙Spanish Accent Script
;;∙------∙Double-tap ALT to activate Accent mode for the next character.

#NoEnv
#SingleInstance Force
#Persistent

AltTapCount := 0
AccentMode := false
SetTimer, ResetAltTap, 750

;;∙------∙🔥∙Detect ALT key presses.
LAlt::
RAlt::
    AltTapCount++
    
    ;;∙------∙If double-tapped within time limit.
    if (AltTapCount = 2) {
        AccentMode := true
        AltTapCount := 0

        ToolTip, Accent Mode Active - Press a/e/i/o/u/n/!/? for Spanish characters
        SetTimer, HideToolTip, 3000

        Hotkey, a, AccentA, On
        Hotkey, e, AccentE, On
        Hotkey, i, AccentI, On
        Hotkey, o, AccentO, On
        Hotkey, u, AccentU, On
        Hotkey, n, AccentN, On
        Hotkey, !, InvertedExclamation, On
        Hotkey, ?, InvertedQuestion, On
        Hotkey, +a, AccentShiftA, On
        Hotkey, +e, AccentShiftE, On
        Hotkey, +i, AccentShiftI, On
        Hotkey, +o, AccentShiftO, On
        Hotkey, +u, AccentShiftU, On
        Hotkey, +n, AccentShiftN, On

        SetTimer, AutoCancelAccent, 5000
        SoundPlay, *48
    }
Return

ResetAltTap:
    if (AltTapCount > 0) {
        AltTapCount--
    }
Return

HideToolTip:
    ToolTip
    SetTimer, HideToolTip, Off
Return

AutoCancelAccent:
    if (AccentMode) {
        DisableAccentMode()
    }
Return

DisableAccentMode() {
    global AccentMode
    AccentMode := false
    ToolTip

    Hotkey, a, AccentA, Off
    Hotkey, e, AccentE, Off
    Hotkey, i, AccentI, Off
    Hotkey, o, AccentO, Off
    Hotkey, u, AccentU, Off
    Hotkey, n, AccentN, Off
    Hotkey, !, InvertedExclamation, Off
    Hotkey, ?, InvertedQuestion, Off
    Hotkey, +a, AccentShiftA, Off
    Hotkey, +e, AccentShiftE, Off
    Hotkey, +i, AccentShiftI, Off
    Hotkey, +o, AccentShiftO, Off
    Hotkey, +u, AccentShiftU, Off
    Hotkey, +n, AccentShiftN, Off

    SetTimer, AutoCancelAccent, Off
    SetTimer, HideToolTip, Off
}

;;∙------∙Lowercase accented vowels and ñ.
AccentA:
    SendRaw, á
    DisableAccentMode()
Return

AccentE:
    SendRaw, é
    DisableAccentMode()
Return

AccentI:
    SendRaw, í
    DisableAccentMode()
Return

AccentO:
    SendRaw, ó
    DisableAccentMode()
Return

AccentU:
    SendRaw, ú
    DisableAccentMode()
Return

AccentN:
    SendRaw, ñ
    DisableAccentMode()
Return

;;∙------∙Uppercase accented vowels and Ñ.
AccentShiftA:
    SendRaw, Á
    DisableAccentMode()
Return

AccentShiftE:
    SendRaw, É
    DisableAccentMode()
Return

AccentShiftI:
    SendRaw, Í
    DisableAccentMode()
Return

AccentShiftO:
    SendRaw, Ó
    DisableAccentMode()
Return

AccentShiftU:
    SendRaw, Ú
    DisableAccentMode()
Return

AccentShiftN:
    SendRaw, Ñ
    DisableAccentMode()
Return

;;∙------∙Inverted punctuation.
InvertedExclamation:
    SendRaw, ¡
    DisableAccentMode()
Return

InvertedQuestion:
    SendRaw, ¿
    DisableAccentMode()
Return

;;∙------∙Initialize hotkeys in off state.
Hotkey, a, AccentA, Off
Hotkey, e, AccentE, Off
Hotkey, i, AccentI, Off
Hotkey, o, AccentO, Off
Hotkey, u, AccentU, Off
Hotkey, n, AccentN, Off
Hotkey, !, InvertedExclamation, Off
Hotkey, ?, InvertedQuestion, Off
Hotkey, +a, AccentShiftA, Off
Hotkey, +e, AccentShiftE, Off
Hotkey, +i, AccentShiftI, Off
Hotkey, +o, AccentShiftO, Off
Hotkey, +u, AccentShiftU, Off
Hotkey, +n, AccentShiftN, Off

Esc::    ;;∙------∙🔥∙(ESC) Exit Accent Mode.
    if (AccentMode) {
        DisableAccentMode()
    } else {
        Send, {Esc}
    }
Return

^!h::    ;;∙------∙🔥∙(Ctrl + Alt + H)
    MsgBox, , Spanish Accent Help, 
    (
    Spanish Accent Script Help:
    
    1. Double-tap ALT (left or right) to activate Accent mode
    2. Press the corresponding key:
       • a → á
       • e → é
       • i → í
       • o → ó
       • u → ú
       • n → ñ
       • ! → ¡
       • ? → ¿
       
       Uppercase:
       • Shift+a → Á
       • Shift+e → É
       • Shift+i → Í
       • Shift+o → Ó
       • Shift+u → Ú
       • Shift+n → Ñ
    
    • Press ESC to cancel Accent mode
    • Mode auto-cancels after 5 seconds
    • Ctrl+Alt+H shows this help
    • Ctrl+Alt+Q exits script
    
    The script shows a tooltip when Accent mode is active.
    )
Return

^!q::ExitApp  ;;∙------∙🔥∙(Ctrl + Alt + Q) Exit Script.
;;∙============================================================∙

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

