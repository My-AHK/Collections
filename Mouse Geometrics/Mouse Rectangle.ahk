
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
#NoEnv
#Persistent
#SingleInstance, Force
SetBatchLines -1
SetWinDelay 0

;;∙======∙Variables∙=================================∙
rectangleWidth := 400    ;;∙------∙Width of the rectangle
rectangleHeight := 300    ;;∙------∙Height of the rectangle
moveSpeed := 5    ;;∙------∙Movement speed in pixels per step
isRectangling := false    ;;∙------∙Track if currently moving in rectangle
currentSide := 1    ;;∙------∙Which side of rectangle we're on (1, 2, 3, or 4)
progress := 0    ;;∙------∙Progress along current side (0 to 1)
clockwise := true    ;;∙------∙Direction: true = clockwise, false = counter-clockwise

;;∙======∙Center of monitor containing current mouse position.
GetCurrentMonitorCenter(ByRef centerX, ByRef centerY) {
    CoordMode, Mouse, Screen
    MouseGetPos, mouseX, mouseY
    SysGet, monitorCount, MonitorCount
    Loop, %monitorCount% {
        SysGet, mon, Monitor, %A_Index%
        if (mouseX >= monLeft && mouseX < monRight && mouseY >= monTop && mouseY < monBottom) {
            centerX := monLeft + ((monRight - monLeft) // 2)
            centerY := monTop + ((monBottom - monTop) // 2)
            return
        }
    }
    ;;∙------∙Fallback: use primary monitor if mouse position detection fails.
    SysGet, MonitorPrimary, MonitorPrimary
    SysGet, mon, Monitor, %MonitorPrimary%
    centerX := monLeft + ((monRight - monLeft) // 2)
    centerY := monTop + ((monBottom - monTop) // 2)
}

;;∙======∙🔥∙Start/Stop Toggle∙🔥∙=====================∙
^t::    ;;∙------∙🔥∙(Ctrl + T)
    if (isRectangling) {
        isRectangling := false    ;;∙------∙Stop.
        SetTimer, MoveInRectangle, Off
        ToolTip, Rectangle movement stopped
        SetTimer, RemoveToolTip, 2000
    } else {
        GetCurrentMonitorCenter(centerX, centerY)
        ;;∙------∙Corner 1: Top-left.
        corner1X := centerX - (rectangleWidth // 2)
        corner1Y := centerY - (rectangleHeight // 2)
        ;;∙------∙Corner 2: Top-right.
        corner2X := centerX + (rectangleWidth // 2)
        corner2Y := centerY - (rectangleHeight // 2)
        ;;∙------∙Corner 3: Bottom-right.
        corner3X := centerX + (rectangleWidth // 2)
        corner3Y := centerY + (rectangleHeight // 2)
        ;;∙------∙Corner 4: Bottom-left.
        corner4X := centerX - (rectangleWidth // 2)
        corner4Y := centerY + (rectangleHeight // 2)
        isRectangling := true    ;;∙------∙Start.
        currentSide := 1
        progress := 0
        CoordMode, Mouse, Screen
        MouseMove, %corner1X%, %corner1Y%, 0
        SetTimer, MoveInRectangle, 10    ;;∙------∙Update every 10ms for smooth movement.
        direction := clockwise ? "clockwise" : "counter-clockwise"
        ToolTip, Rectangle movement started %direction% (Ctrl+T to stop`, Ctrl+R to reverse)
        SetTimer, RemoveToolTip, 3000
    }
Return

;;∙======∙🔥∙Reverse Direction∙🔥∙=====================∙
^r::    ;;∙------∙🔥∙(Ctrl + R)
    clockwise := !clockwise
    direction := clockwise ? "clockwise" : "counter-clockwise"
    if (isRectangling) {
        ToolTip, Direction changed to %direction%
    } else {
        ToolTip, Direction set to %direction% (Ctrl+T to start)
    }
    SetTimer, RemoveToolTip, 2000
Return

;;∙======∙Mouse Rectangle Function∙==================∙
MoveInRectangle:
    if (!isRectangling) {
        SetTimer, MoveInRectangle, Off
        return
    }
    CoordMode, Mouse, Screen
    if (clockwise) {
        if (currentSide = 1) {
            currentX := corner1X + (corner2X - corner1X) * progress
            currentY := corner1Y + (corner2Y - corner1Y) * progress
            sideLength := rectangleWidth
        } else if (currentSide = 2) {
            currentX := corner2X + (corner3X - corner2X) * progress
            currentY := corner2Y + (corner3Y - corner2Y) * progress
            sideLength := rectangleHeight
        } else if (currentSide = 3) {
            currentX := corner3X + (corner4X - corner3X) * progress
            currentY := corner3Y + (corner4Y - corner3Y) * progress
            sideLength := rectangleWidth
        } else {
            currentX := corner4X + (corner1X - corner4X) * progress
            currentY := corner4Y + (corner1Y - corner4Y) * progress
            sideLength := rectangleHeight
        }
    } else {
        if (currentSide = 1) {
            currentX := corner1X + (corner4X - corner1X) * progress
            currentY := corner1Y + (corner4Y - corner1Y) * progress
            sideLength := rectangleHeight
        } else if (currentSide = 2) {
            currentX := corner4X + (corner3X - corner4X) * progress
            currentY := corner4Y + (corner3Y - corner4Y) * progress
            sideLength := rectangleWidth
        } else if (currentSide = 3) {
            currentX := corner3X + (corner2X - corner3X) * progress
            currentY := corner3Y + (corner2Y - corner3Y) * progress
            sideLength := rectangleHeight
        } else {
            currentX := corner2X + (corner1X - corner2X) * progress
            currentY := corner2Y + (corner1Y - corner2Y) * progress
            sideLength := rectangleWidth
        }
    }
    MouseMove, %currentX%, %currentY%, 0
    progress += (moveSpeed / sideLength)
    if (progress >= 1.0) {
        progress := 0
        currentSide++
        if (currentSide > 4) {
            currentSide := 1
        }
    }
Return

RemoveToolTip:
    ToolTip
    SetTimer, RemoveToolTip, Off
Return

Esc::ExitApp
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

