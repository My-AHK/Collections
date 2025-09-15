
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  Self
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?f=76&t=138359#p608229
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
;;∙======∙DIRECTIVES∙=========================∙
#NoEnv
#Persistent
#SingleInstance, Force
#WinActivateForce

;;∙======∙PERFORMANCE COUNTER INIT∙=========∙
DllCall("QueryPerformanceFrequency", "Int64*", freq := 0)
DllCall("QueryPerformanceCounter", "Int64*", counterBefore := 0)

;;∙======∙GLOBAL VARIABLES∙==================∙
global F1_Active := false
global F2_Active := false
global LastF1Trigger := 0
global LastF2Trigger := 0
global LastF1Second := 0
global LastF2Second := 0
global StartTime := A_TickCount

;;∙======∙TIMERS∙============================∙
SetTimer, PrecisionTimer, 100
SetTimer, UpdateGUI, 50

;;∙======∙GUI BUILD∙==========================∙
Gui, Countdown: New, +AlwaysOnTop -Caption
Gui, Color, 212223

Gui, Font, s30 cWhite q5, Arial
Gui, Add, Text, vCurrentSecond w155 Center, %A_Sec%

Gui, Font, s10
Gui, Add, Text, vElapsedTime x10 w155 Center, Elapsed Time = 0000 ms
Gui, Add, Text, vF1Status x10 y+10 w155 Center cRed, F1: DISABLED
Gui, Add, Text, vF2Status x10 y+3 w155 Center cRed, F2: DISABLED

Gui, Add, Text, x100 y+20 cYellow 0x00800000 gExitOut, EXIT    ;<<<∙------∙gLabel as a button.

PosX := A_ScreenWidth - 180    ;<<<∙------∙CHANGE GUI POSITION WITH THESE.
PosY := A_ScreenHeight - 240

Gui, Show, w175 h200 x%PosX% y%PosY%, Countdown    ;<<<∙------∙CHANGE SIZE Via w(width) and h(height).

;;∙======∙HOTKEYS∙===========================∙
F1::    ;;∙------∙🔥∙(TOGGLE) Triggers at 15 seconds & 45 seconds.
    F1_Active := !F1_Active
    SoundBeep, % F1_Active ? 1000 : 800, 200
    MouseGetPos, x, y
    ToolTip, % "F1 " (F1_Active ? "ENABLED" : "DISABLED"), x+25, y+25
    SetTimer, KillTip, -1000
Return

F2::    ;;∙------∙🔥∙(TOGGLE) Triggers at 00 seconds & 30 seconds.
    F2_Active := !F2_Active
    SoundBeep, % F2_Active ? 1000 : 800, 200
    MouseGetPos, x, y
    ToolTip, % "F2 " (F2_Active ? "ENABLED" : "DISABLED"), x+25, y+25
    SetTimer, KillTip, -1000
Return

;;∙======∙SUBROUTINES∙======================∙
PrecisionTimer:    ;;∙------∙Get current time in μs (micro-second) precision.
    DllCall("QueryPerformanceCounter", "Int64*", counterNow := 0)
    currentMS := (counterNow - counterBefore) * 1000 // freq
    currentSecond := A_Sec
    currentMSInSecond := Mod(currentMS, 1000)

    if (F1_Active) {
        if ((currentSecond = 15 || currentSecond = 45) && (A_TickCount - LastF1Trigger > 900) && (LastF1Second != currentSecond)) {
            LastF1Trigger := A_TickCount
            LastF1Second := currentSecond
            SetTimer, F1_Action, -1    ;;∙------∙ -1 = highest priority.
        }
    }
    if (F2_Active) {
        if ((currentSecond = 0 || currentSecond = 30) && (A_TickCount - LastF2Trigger > 900) && (LastF2Second != currentSecond)) {
            LastF2Trigger := A_TickCount
            LastF2Second := currentSecond
            SetTimer, F2_Action, -1
        }
    }
Return

UpdateGUI:
    ElapsedMS := A_TickCount - StartTime
    GuiControl, Countdown:, CurrentSecond, %A_Sec%
    GuiControl, Countdown:, ElapsedTime, Elapsed Time = %ElapsedMS% ms

    if (F1_Active) {
        Gui, Countdown: Font, s12 cLime    ;<<<∙------∙GUI Font Changes.
        GuiControl, Countdown: Font, F1Status
        GuiControl, Countdown:, F1Status, F1: ENABLED
    } else {
        Gui, Countdown: Font, s10 cRed
        GuiControl, Countdown: Font, F1Status
        GuiControl, Countdown:, F1Status, F1: DISABLED
    }

    if (F2_Active) {
        Gui, Countdown: Font, s12 cLime
        GuiControl, Countdown: Font, F2Status
        GuiControl, Countdown:, F2Status, F2: ENABLED
    } else {
        Gui, Countdown: Font, s10 cRed
        GuiControl, Countdown: Font, F2Status
        GuiControl, Countdown:, F2Status, F2: DISABLED
    }
Return

F1_Action:
    DllCall("QueryPerformanceCounter", "Int64*", actionStart := 0)
    SoundBeep, 1100, 200
    DllCall("QueryPerformanceCounter", "Int64*", actionEnd := 0)
    MouseGetPos, x, y
    ToolTip, % "F1 Timed Routine`nResponse Time:`n`t " (actionEnd-actionStart)*1000//freq " µs", x+25, y+25
    SetTimer, KillTip, -3000
Return

F2_Action:
    DllCall("QueryPerformanceCounter", "Int64*", actionStart := 0)
    SoundBeep, 1200, 200
    DllCall("QueryPerformanceCounter", "Int64*", actionEnd := 0)
    MouseGetPos, x, y
    ToolTip, % "F2 Timed Routine`nResponse Time:`n`t " (actionEnd-actionStart)*1000//freq " µs", x+25, y+25
    SetTimer, KillTip, -3000
Return

KillTip:
    ToolTip
Return

;;∙======∙EXIT HANDLERS∙=====================∙
CountdownGuiClose:
CountdownGuiEscape:
ExitOut:
Esc::
    ExitApp
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

