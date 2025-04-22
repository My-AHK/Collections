
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  Self
» Sleep Precision Timings - Tool Index and Demo Launcher.
    ▹ Demo script showing how the various SLEEP scripts work.
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
^t::    ;;∙------∙🔥∙(Ctrl + T)
    Soundbeep, 1000, 200

Gui, Add, Text,, Select a demo to run:
Gui, Add, ListBox, vSelectedDemo w300 r10, PreciseSleepUS (Microseconds)|Periodic Timer A + B (Labels)|Periodic Timer via Function Callback

Gui, Add, Button, gRunSelectedDemo Default, Run Demo
Gui, Add, Button, gExitApp, Exit
Gui, Show,, Sleep Precision Timings - Tool Index
Return


;;∙------------∙Functions∙---------------------------------∙
RunSelectedDemo:
    Gui, Submit, NoHide
    If (SelectedDemo = "PreciseSleepUS (Microseconds)") {
        Gosub, Demo_PreciseSleepUS
    } Else If (SelectedDemo = "Periodic Timer A + B (Labels)") {
        Gosub, Demo_PeriodicLabels
    } Else If (SelectedDemo = "Periodic Timer via Function Callback") {
        Gosub, Demo_PeriodicFunction
    }
Return

Demo_PreciseSleepUS:
    MsgBox, Running PreciseSleepUS (250µs example)...
    PreciseSleepUS(250)
    MsgBox, Done! (Should be imperceptibly fast, but logs may confirm)
Return

Demo_PeriodicLabels:
    MsgBox, Starting 2 periodic timers:`nTimerA = 300ms`nTimerB = 700ms`n(ESC to exit)
    StartPeriodicTimer(300, "CheckTimerA", TimerAHandle)
    StartPeriodicTimer(700, "CheckTimerB", TimerBHandle)
Return

Demo_PeriodicFunction:
    MsgBox, Starting function-based periodic timer at 500ms interval. (ESC to exit)
    callbackFunc := Func("MyTick")
    SetTimer, __CallFunc, 500
Return

__CallFunc:
    callbackFunc.Call()
Return

ExitApp:
    StopAllTimers()
    StopFuncTimer(hFuncTimer)
    ExitApp
Return

;;∙------------∙Helper functions∙------------------------∙
PreciseSleepUS(us) {
    hTimer := DllCall("CreateWaitableTimer", "Ptr", 0, "Int", true, "Ptr", 0, "Ptr")
    If !hTimer
        Return
    interval := -us * 10
    success := DllCall("SetWaitableTimer", "Ptr", hTimer, "Int64*", interval, "Int", 0, "Ptr", 0, "Ptr", 0, "Int", false)
    If success
        DllCall("WaitForSingleObject", "Ptr", hTimer, "UInt", 0xFFFFFFFF)
    DllCall("CloseHandle", "Ptr", hTimer)
    Return
}

StartPeriodicTimer(ms, labelName, ByRef hTimer) {
    hTimer := DllCall("CreateWaitableTimer", "Ptr", 0, "Int", true, "Ptr", 0, "Ptr")
    If !hTimer
        Return false
    interval := -ms * 10000
    DllCall("SetWaitableTimer", "Ptr", hTimer, "Int64*", interval, "Int", ms, "Ptr", 0, "Ptr", 0, "Int", false)
    SetTimer, %labelName%, -1
    Return true
}

CheckTimerA:
    If DllCall("WaitForSingleObject", "Ptr", TimerAHandle, "UInt", 0) = 0 {
        Gosub, TickA
        SetTimer, CheckTimerA, -1
    }
Return

CheckTimerB:
    If DllCall("WaitForSingleObject", "Ptr", TimerBHandle, "UInt", 0) = 0 {
        Gosub, TickB
        SetTimer, CheckTimerB, -1
    }
Return

TickA:
    ToolTip % "Timer A: " A_TickCount
Return

TickB:
    ToolTip % "Timer B: " A_TickCount "`n(Second Line)"
Return

StopAllTimers() {
    global TimerAHandle, TimerBHandle
    If (TimerAHandle) {
        DllCall("CancelWaitableTimer", "Ptr", TimerAHandle)
        DllCall("CloseHandle", "Ptr", TimerAHandle)
        TimerAHandle := ""
    }
    If (TimerBHandle) {
        DllCall("CancelWaitableTimer", "Ptr", TimerBHandle)
        DllCall("CloseHandle", "Ptr", TimerBHandle)
        TimerBHandle := ""
    }
}

StartPeriodicFuncTimer(ms, callbackFunc, ByRef hTimer) {
    hTimer := DllCall("CreateWaitableTimer", "Ptr", 0, "Int", true, "Ptr", 0, "Ptr")
    If !hTimer
        Return false
    interval := -ms * 10000
    DllCall("SetWaitableTimer", "Ptr", hTimer, "Int64*", interval, "Int", ms, "Ptr", 0, "Ptr", 0, "Int", false)
    SetTimer, % Func("CheckFuncTimer").Bind(hTimer, callbackFunc), -1
    Return true
}

CheckFuncTimer(hTimer, callbackFunc) {
    If DllCall("WaitForSingleObject", "Ptr", hTimer, "UInt", 0) = 0 {
        callbackFunc.Call()
        SetTimer, % Func("CheckFuncTimer").Bind(hTimer, callbackFunc), -1
    }
}

StopFuncTimer(ByRef hTimer) {
    If (hTimer) {
        DllCall("CancelWaitableTimer", "Ptr", hTimer)
        DllCall("CloseHandle", "Ptr", hTimer)
        hTimer := ""
    }
}

MyTick() {
    ToolTip % "Function Tick at: " A_TickCount
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

