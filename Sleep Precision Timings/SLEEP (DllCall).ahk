
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Source:  https://www.autohotkey.com/boards/viewtopic.php?f=7&t=6413&hilit=much+as+possible#p48194
» Source:  https://www.autohotkey.com/boards/viewtopic.php?f=18&t=135711#p597615
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
;;∙---------------------------------------------------------------------------∙
;;∙------------∙Script Speed Optimization∙∙
;;∙------∙https://www.autohotkey.com/boards/viewtopic.php?f=7&t=6413&hilit=much+as+possible#p48194
;;∙------------------------------∙
#NoEnv
Process, Priority, , H
SetBatchLines, -1
ListLines Off
#KeyHistory 0
SendMode Input
SetTitleMatchMode 2
SetTitleMatchMode Fast
SetKeyDelay, -1, -1, Play
SetMouseDelay, -1
SetWinDelay, 0
SetControlDelay, 0
SetDefaultMouseSpeed, 0
;;∙------------------------------∙


;∙============================================================∙
;;∙------∙DLL SLEEP - For precise sleep durations∙∙ (e.g., 1 millisecond) to increase system timer resolution.
;∙======∙Example Usage∙========================================∙
^t::    ;∙------∙🔥∙(Ctrl + T)
    Soundbeep, 1200, 250
    PreciseSleep(3)    ; Sleep for 3 milliseconds with improved precision
Return

;∙------------------------------------∙
PreciseSleep(ms) {
    DllCall("winmm\timeBeginPeriod", "UInt", 1)    ;∙------∙Set system timer resolution to 1ms for higher precision sleeps.
    DllCall("Sleep", "UInt", ms)    ;∙------∙Perform the actual sleep with requested duration.
    DllCall("winmm\timeEndPeriod", "UInt", 1)    ;∙------∙Restore default system timer resolution.
    }
Return
;∙============================================================∙


/*∙------------------------∙KNOWLEDGE∙----------------------------------------------∙
   *------------∙DLL SLEEP vs AHK SLEEP
    ∙------∙AutoHotkey's Sleep Command:
        • AutoHotkey's Sleep command is designed to have a minimum sleep duration of about 10–15 milliseconds on most systems. This is due to the granularity of the system timer and how AutoHotkey implements the Sleep command internally.
        • For example, Sleep, 1 will typically result in a sleep of around 10–15 milliseconds, not 1 millisecond.

    ∙------∙DllCall("Sleep", "UInt", 1):
        • When you use DllCall to call the Windows API Sleep function directly, you are bypassing AutoHotkey's internal implementation and interacting with the Windows API directly.
        • The Windows API Sleep function has a much finer granularity and can sleep for as little as 1 millisecond, depending on the system's timer resolution.
        • However, the actual precision of the sleep duration depends on the system's timer resolution. 
            - By default, Windows systems typically have a timer resolution of 15.6 milliseconds. Which means that even Sleep(1) may not sleep for exactly 1 millisecond. 
            - To achieve higher precision, you need to use functions like 'timeBeginPeriod' to adjust the system timer resolution.

   *------------∙KEY POINTS:
    1∙------∙AutoHotkey's Sleep command:
        • Minimum sleep duration is ~10–15 milliseconds.
        • Less precise due to AutoHotkey's implementation.
    2∙------∙DllCall("Sleep", "UInt", 1):
        • Can sleep for as little as 1 millisecond.
        • Precision depends on the system's timer resolution.
        • More precise than AutoHotkey's Sleep command, but still subject to system limitations.
    3∙------∙Conclusion:
        • DllCall("Sleep", "UInt", 1) can sleep for 1 millisecond, but the actual precision depends on the system's timer resolution.
        • AutoHotkey's Sleep command has a minimum sleep duration of ~10–15 milliseconds and is less precise.
        • If you need high-precision timing, you can use timeBeginPeriod to adjust the system timer resolution. (but should be used sparingly as it can affect system performance and power consumption)
    ∙------------------------∙KNOWLEDGE END∙----------------------------------------∙
*/
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

