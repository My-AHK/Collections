
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
#SingleInstance Force
#Persistent
SetTitleMatchMode 2
SetWinDelay, 0
CoordMode, ToolTip, Screen

;;∙------------∙Variables∙-----------------------∙
ToolTipText := ""
ToolTipX := 20    ;;∙------∙Initial ToolTip x-axis location.
ToolTipY := 20    ;;∙------∙Initial ToolTip y-axis location.
ToolTipHwnd := 0
LastClickTime := 0
ToolTipCleared := 15000    ;;∙------∙Initial ToolTip timeout.

;;∙------------∙🔥∙Hotkeys∙🔥∙-----------------∙
F1::
    UpdateToolTip("`nThe hotkey """ A_ThisHotkey """ was pressed.")
Return

F2::
    UpdateToolTip("`nThe Hotkey`n      """ A_ThisHotkey """`nWas Pressed")
Return

Esc::
    ExitApp
Return
;;∙------------------------------------------------∙


UpdateToolTip(message) {
    global ToolTipText, ToolTipX, ToolTipY, ToolTipHwnd, ToolTipCleared

    SetTimer, ClearToolTip, -%ToolTipCleared%    ;;∙------∙Reset automatic clear timer.
    
    FormatTime, timeStr, A_Now, HH:mm:ss tt    ;;∙------∙Add timestamp and message.
    ToolTipText .= " @ "timeStr "... " message "`n"
    
    if ToolTipHwnd {    ;;∙------∙Create/Update ToolTip.
        ControlSetText, Static1, %ToolTipText%, ahk_id %ToolTipHwnd%
    } else {
        ToolTip %ToolTipText%, %ToolTipX%, %ToolTipY%, 10
        WinGet, ToolTipHwnd, ID, ahk_class tooltips_class32
        MakeToolTipDraggable()
    }
}

MakeToolTipDraggable() {
    global ToolTipHwnd
    WS_EX_LAYERED := 0x80000
    WinSet, ExStyle, +%WS_EX_LAYERED%, ahk_id %ToolTipHwnd%
    WinSet, Transparent, 255, ahk_id %ToolTipHwnd%
}

;;∙------------∙Mouse handling∙--------------∙
#If IsMouseOverToolTip()
~LButton::
    ;;∙------∙Double-click detection.
    if (A_TimeSincePriorHotkey < 250 && A_PriorHotkey = "~LButton") {
        Clipboard := ToolTipText
        ShowCopyFeedback()
        ClearToolTip()
        return
    }

    ;;∙------------∙Drag implementation∙-------∙
    CoordMode, Mouse, Screen
    MouseGetPos, StartX, StartY
    WinGetPos, ttX, ttY,,, ahk_id %ToolTipHwnd%
    StartX -= ttX
    StartY -= ttY

    While GetKeyState("LButton", "P") {
        MouseGetPos, CurrentX, CurrentY
        newX := CurrentX - StartX
        newY := CurrentY - StartY
        WinMove, ahk_id %ToolTipHwnd%,, %newX%, %newY%
        ToolTipX := newX
        ToolTipY := newY
        Sleep 10
    }
return
#If

IsMouseOverToolTip() {
    global ToolTipHwnd
    MouseGetPos,,, winId
    return (winId = ToolTipHwnd)
}

ClearToolTip() {
    global ToolTipText, ToolTipHwnd
    ToolTipText := ""
    ToolTip,,,, 10    ;;∙------∙Clear main ToolTip.
    ToolTipHwnd := 0
    SetTimer, ClearToolTip, Off
}

ShowCopyFeedback() {
    global ToolTipX, ToolTipY
    ToolTip Copied to clipboard!, % ToolTipX, % ToolTipY + 30, 11
    SetTimer, HideCopyFeedback, -1000
}

HideCopyFeedback:
    ToolTip,,,, 11
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
#SingleInstance, Force    ;;∙------∙Prevents multiple instances of the script and forces new execution.
#MaxThreadsPerHotkey 3    ;;∙------∙Sets the maximum simultaneous threads for each hotkey.
#NoEnv    ;;∙------∙Avoids checking empty environment variables for optimization.
#Persistent    ;;∙------∙Keeps the script running indefinitely.
;;∙------∙#NoTrayIcon    ;;∙------∙Hides the tray icon if uncommented.
SendMode, Input    ;;∙------∙Sets SendMode to Input for faster and more reliable keystrokes.
SetBatchLines -1    ;;∙------∙Disables batch line delays for immediate execution of commands.
SetTitleMatchMode 2    ;;∙------∙Enables partial title matching for window detection.
SetWinDelay 0    ;;∙------∙Removes delays between window-related commands.
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.
SetTimer, UpdateCheck, 500    ;;∙------∙Sets a timer to call UpdateCheck every 500 milliseconds.
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

