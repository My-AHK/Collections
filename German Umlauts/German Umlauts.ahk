
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




;;∙============================================================∙
;;∙============================================================∙
;;∙------∙German Umlaut Script.
;;∙------∙Double-tap ALT to activate Umlaut mode for the next character.

#NoEnv
#SingleInstance Force
#Persistent

AltTapCount := 0
UmlautMode := false
SetTimer, ResetAltTap, 500

;;∙------∙🔥∙Detect ALT key presses.
LAlt::
RAlt::
    AltTapCount++
    
    ;;∙------∙If double-tapped within time limit.
    if (AltTapCount = 2) {
        UmlautMode := true
        AltTapCount := 0

        ToolTip, Umlaut Mode Active - Press a/o/u/s for umlauts
        SetTimer, HideToolTip, 3000

        Hotkey, a, UmlautA, On
        Hotkey, o, UmlautO, On
        Hotkey, u, UmlautU, On
        Hotkey, s, UmlautS, On
        Hotkey, +a, UmlautShiftA, On
        Hotkey, +o, UmlautShiftO, On
        Hotkey, +u, UmlautShiftU, On

        SetTimer, AutoCancelUmlaut, 5000
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

AutoCancelUmlaut:
    if (UmlautMode) {
        DisableUmlautMode()
    }
Return

DisableUmlautMode() {
    global UmlautMode
    UmlautMode := false
    ToolTip

    Hotkey, a, UmlautA, Off
    Hotkey, o, UmlautO, Off
    Hotkey, u, UmlautU, Off
    Hotkey, s, UmlautS, Off
    Hotkey, +a, UmlautShiftA, Off
    Hotkey, +o, UmlautShiftO, Off
    Hotkey, +u, UmlautShiftU, Off

    SetTimer, AutoCancelUmlaut, Off
    SetTimer, HideToolTip, Off
}


UmlautA:
    SendRaw, ä
    DisableUmlautMode()
Return

UmlautO:
    SendRaw, ö
    DisableUmlautMode()
Return

UmlautU:
    SendRaw, ü
    DisableUmlautMode()
Return

UmlautS:
    SendRaw, ß
    DisableUmlautMode()
Return

UmlautShiftA:
    SendRaw, Ä
    DisableUmlautMode()
Return

UmlautShiftO:
    SendRaw, Ö
    DisableUmlautMode()
Return

UmlautShiftU:
    SendRaw, Ü
    DisableUmlautMode()
Return


Hotkey, a, UmlautA, Off
Hotkey, o, UmlautO, Off
Hotkey, u, UmlautU, Off
Hotkey, s, UmlautS, Off
Hotkey, +a, UmlautShiftA, Off
Hotkey, +o, UmlautShiftO, Off
Hotkey, +u, UmlautShiftU, Off


Esc::    ;;∙------∙🔥∙(ESC) Exit Umlaut Mode.
    if (UmlautMode) {
        DisableUmlautMode()
    } else {
        Send, {Esc}
    }
Return


^!h::    ;;∙------∙🔥∙(Ctrl + Alt + H)
    MsgBox, 0, German Umlaut Help, 
    (
    German Umlaut Script Help:
    
    1. Double-tap ALT (left or right) to activate Umlaut mode
    2. Press the corresponding key:
       • a → ä
       • o → ö  
       • u → ü
       • s → ß
       • Shift+a → Ä
       • Shift+o → Ö
       • Shift+u → Ü
    
    • Press ESC to cancel Umlaut mode
    • Mode auto-cancels after 5 seconds
    • Ctrl+Alt+H shows this help
    • Ctrl+Alt+Q exits script
    
    The script shows a tooltip when Umlaut mode is active.
    )
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

