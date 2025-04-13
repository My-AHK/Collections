
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
;;∙------------∙ORIGINAL VERSION∙------------∙
;;∙============================================================∙
^Numpad1::    ;;∙------∙🔥∙(Ctrl + Numpad1)
;;∙------------∙Start Bar∙------------∙
Progress, b ZH5 h54 w130 fm9 fs8 wm400 ws400 cb00FF00 ct00B4FD cw000000, , Script Enabled
Progress, 5
Sleep 75
Progress, 10
Sleep 75
Progress, 15
Sleep 75
Progress, 20
Sleep 75
Progress, 25
Sleep 75
Progress, 30
Sleep 75
Progress, 35
Sleep 75
Progress, b ZH5 h54 w130 fm9 fs8 wm400 ws400 cb00FF00 ct00B4FD cw000000, Press 'Ctrl+Esc' to exit, Script Enabled
Progress, 40
Sleep 75
Progress, 45
Sleep 75
Progress, 50
Sleep 75
Progress, 55
Sleep 75
Progress, 60
Sleep 75
Progress, 65
Sleep 75
Progress, 70
Sleep 75
Progress, 75
Sleep 75
Progress, 80
Sleep 75
Progress, 85
Sleep 75
Progress, 90
Sleep 75
Progress, 95
Sleep 75
Progress, 100
Sleep, 500
    SoundBeep, 1400, 250    ;;∙------∙"Script Enabled Beep"
Progress, 100
    Sleep, 300
Progress, Off
Return

;;∙==================================∙

^Numpad2::    ;;∙------∙🔥∙(Ctrl + Numpad2)
;;∙------------∙Stop Bar∙------------∙
Progress, b ZH5 h54 w130 fm9 fs8 wm400 ws400 cbFF0000 ctFFFF00 cw000000, , Script Exiting
Progress, 5
Sleep 75
Progress, 10
Sleep 75
Progress, 15
Sleep 75
Progress, 20
Sleep 75
Progress, 25
Sleep 75
Progress, 30
Sleep 75
Progress, 35
Sleep 75
Progress, b ZH5 h54 w130 fm9 fs8 wm400 ws400 cbFF0000 ctFFFF00 cw000000, Good Bye, Script Exiting
Progress, 40
Sleep 75
Progress, 45
Sleep 75
Progress, 50
Sleep 75
Progress, 55
Sleep 75
Progress, 60
Sleep 75
Progress, 65
Sleep 75
Progress, 70
Sleep 75
Progress, 75
Sleep 75
Progress, 80
Sleep 75
Progress, 85
Sleep 75
Progress, 90
Sleep 75
Progress, 95
Sleep 75
Progress, 100
    SoundBeep, 1100, 250    ;;∙------∙"Script Disabled Beep"
Sleep, 200
Progress, Off
Return
;;∙------------------------------------------------------------------------------------------∙



;;∙============================================================∙
;;∙------------∙LOOP VERSION∙------------∙
;;∙------∙advantages∙(Reduces code duplication/Easier to maintain and modify)
;;∙============================================================∙
^Numpad3::    ;;∙------∙🔥∙(Ctrl + Numpad3)
;;∙------------∙Start Bar∙------------∙
Progress, b ZH5 h54 w130 fm9 fs8 wm400 ws400 cb00FF00 ct00B4FD cw000000, , Script Enabled
Loop 19 {
    current := A_Index * 5
    Progress, %current%
    Sleep 75
    if (current = 35) {
        Progress, b ZH5 h54 w130 fm9 fs8 wm400 ws400 cb00FF00 ct00B4FD cw000000, Press 'Ctrl+Esc' to exit, Script Enabled
    }
}
Progress, 100
Sleep, 500
SoundBeep, 1400, 250
Sleep, 300
Progress, Off
Return

;;∙==================================∙

^Numpad4::    ;;∙------∙🔥∙(Ctrl + Numpad4)
;;∙------------∙Stop Bar∙------------∙
Progress, b ZH5 h54 w130 fm9 fs8 wm400 ws400 cbFF0000 ctFFFF00 cw000000, , Script Exiting
Loop 19 {
    current := A_Index * 5
    Progress, %current%
    Sleep 75
    if (current = 35) {
        Progress, b ZH5 h54 w130 fm9 fs8 wm400 ws400 cbFF0000 ctFFFF00 cw000000, Good Bye, Script Exiting
    }
}
Progress, 100
SoundBeep, 1100, 250
Sleep, 200
Progress, Off
Return
;;∙------------------------------------------------------------------------------------------∙



;;∙============================================================∙
;;∙------------∙SETTIMER VERSION 1∙------------∙
;;∙------∙advantages∙(Non-blocking execution / More responsive / Easier to Extend)
;;∙============================================================∙
^Numpad5::    ;;∙------∙🔥∙(Ctrl + Numpad5)
;;∙------------∙Start Bar∙------------∙
    Progress, b ZH5 h54 w130 fm9 fs8 wm400 ws400 cb00FF00 ct00B4FD cw000000, , Script Enabled
    step1 := 0
    Gosub, UpdateProgress1    ;;∙------∙First update immediately.
    SetTimer, UpdateProgress1, 75    ;;∙------∙Subsequent updates every 75ms.
Return

;;∙-------------------------------------∙
UpdateProgress1:
    step1 += 1
    current := step1 * 5
    Progress, %current%
    if (current = 35) {
        Progress, b ZH5 h54 w130 fm9 fs8 wm400 ws400 cb00FF00 ct00B4FD cw000000, Press 'Ctrl+Esc' to exit, Script Enabled
    }
    if (step1 >= 19) {
        SetTimer, UpdateProgress1, Off
        Progress, 100
        Sleep, 500
        SoundBeep, 1400, 250
        Sleep, 300
        Progress, Off
    }
Return

;;∙==================================∙

^Numpad6::    ;;∙------∙🔥∙(Ctrl + Numpad6)
;;∙------------∙Stop Bar∙------------∙
    Progress, b ZH5 h54 w130 fm9 fs8 wm400 ws400 cbFF0000 ctFFFF00 cw000000, , Script Exiting
    step2 := 0
    Gosub, UpdateProgress2    ;;∙------∙First update immediately.
    SetTimer, UpdateProgress2, 75    ;;∙------∙Subsequent updates every 75ms.
Return

;;∙-------------------------------------∙
UpdateProgress2:
    step2 += 1
    current := step2 * 5
    Progress, %current%
    if (current = 35) {
        Progress, b ZH5 h54 w130 fm9 fs8 wm400 ws400 cbFF0000 ctFFFF00 cw000000, Good Bye, Script Exiting
    }
    if (step2 >= 19) {
        SetTimer, UpdateProgress2, Off
        Progress, 100
        SoundBeep, 1100, 250
        Sleep, 200
        Progress, Off
    }
Return
;;∙------------------------------------------------------------------------------------------∙



;;∙============================================================∙
;;∙------------∙SETTIMER VERSION 2∙------------∙with hotkey execution overlap prevention.
;;∙------∙advantages∙(Non-blocking execution / More responsive / Easier to Extend)
;;∙------∙added advantage∙(Single Lock (isActive) w-Full Reset)
;;∙============================================================∙

isActive := false    ;;∙------∙Global flag to track active state.

^Numpad7::    ;;∙------∙🔥∙(Ctrl + Numpad7)
    if (isActive)    ;;∙------∙Block if any progress is running.
        return

    ;;∙------------∙Start Bar∙------------∙
    isActive := true    ;;∙------∙Lock execution.

    Progress, b ZH5 h54 w130 fm9 fs8 wm400 ws400 cb00FF00 ct00B4FD cw000000, , Script Enabled
    step1 := 1    ;;∙------∙Start counter.
    Gosub, UpdateProgress3
    SetTimer, UpdateProgress3, 75
Return

;;∙-------------------------------------∙
UpdateProgress3:
    current := step1 * 5
    Progress, %current%
    
    if (current = 35) {
        Progress, b ZH5 h54 w130 fm9 fs8 wm400 ws400 cb00FF00 ct00B4FD cw000000, Press 'Ctrl+Esc' to exit, Script Enabled
    }
    
    if (step1 >= 19) {
        SetTimer, UpdateProgress3, Off
        Progress, 100
        Sleep, 500
        SoundBeep, 1400, 250
        Sleep, 300
        Progress, Off
        isActive := false    ;;∙------∙Lock release.
        step1 := 0
    } else {
        step1 += 1
    }
Return

;;∙==================================∙

^Numpad8::    ;;∙------∙🔥∙(Ctrl + Numpad8)
    if (isActive)    ;;∙------∙Block if any progress is running.
        return
    
    ;;∙------------∙Stop Bar∙------------∙
    isActive := true    ;;∙------∙Lock execution.

    Progress, b ZH5 h54 w130 fm9 fs8 wm400 ws400 cbFF0000 ctFFFF00 cw000000, , Script Exiting
    step2 := 1
    Gosub, UpdateProgress4
    SetTimer, UpdateProgress4, 75
Return

;;∙-------------------------------------∙
UpdateProgress4:
    current := step2 * 5
    Progress, %current%
    
    if (current = 35) {
        Progress, b ZH5 h54 w130 fm9 fs8 wm400 ws400 cbFF0000 ctFFFF00 cw000000, Good Bye, Script Exiting
    }
    
    if (step2 >= 19) {
        SetTimer, UpdateProgress4, Off
        Progress, 100
        Sleep, 200
    SoundBeep, 1100, 250
        Progress, Off
        isActive := false    ;;∙------∙Lock release.
        step2 := 0
    } else {
        step2 += 1
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

