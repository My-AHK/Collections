﻿
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙----------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙--------------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
» 
∙--------∙Origins∙-------------------------∙
» Author:  Self
» Source:  
» Determine Angle from X-Axis.
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "X-Axis"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙




;;∙============================================================∙
clickCount := 0    ;;∙------∙Reset variables.
clickPoints := []
firstClickIgnored := true
;;∙------∙
~^LButton::    ;;∙------∙🔥 HotKey 🔥∙------∙(Ctrl+LeftMouseButton)
    Gosub, MouseClickHandler
Return
;;∙------∙
MouseClickHandler:
    if (firstClickIgnored) {
    clickCount++
    MouseGetPos, clickX, clickY
    clickPoints[clickCount] := {x: clickX, y: clickY}
    if (clickCount = 2) {    ;;∙------∙If two clicks have been recorded, calculate the angle.
        x1 := clickPoints[1].x    ;;∙------∙Get the coordinates of the first and second click.
        y1 := clickPoints[1].y
        x2 := clickPoints[2].x
        y2 := clickPoints[2].y
        deltaX := x2 - x1    ;;∙------∙Calculate the difference in coordinates.
        deltaY := y2 - y1
        angle := ATan(-deltaY / deltaX)    ;;∙------∙Calculate the angle in radians using horizontal x-axis as zero.
        angleDegrees := angle * (180 / 3.141592653589793)    ;;∙------∙Convert the angle to degrees.
    if (deltaX > 0 and deltaY < 0) {    ;;∙------∙Adjust the angle based on quadrant.
        angleDegrees := Abs(angleDegrees)    ;;∙------∙First quadrant (0 to 90 degrees)
    } else if (deltaX < 0) {
        angleDegrees += 180    ;;∙------∙Second and third quadrants (90 to 270 degrees)
    } else if (deltaX > 0 and deltaY > 0) {
        angleDegrees := 360 + angleDegrees    ;;∙------∙Fourth quadrant (270 to 360 degrees)
    }
;;∙------∙
roundedAngle := Round(angleDegrees, 2)    ;;∙------∙Round the angle.
    Tooltip, Angle: %roundedAngle%°    ;;∙------∙Display the angle in a tooltip.
    Clipboard:= "Angle: "roundedAngle "°"    ;;∙------∙Copy angle to clipboard.
    clickCount := 0    ;;∙------∙Reset variables for next calculation.
    clickPoints := []
    SetTimer, RemoveTooltip, -3000
        }
    } else {
        firstClickIgnored := true
    }
Return
;;∙------∙
RemoveTooltip:
    Tooltip
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
        SoundBeep, 1100, 75
        Soundbeep, 1200, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        Soundbeep, 1100, 75
        Soundbeep, 1000, 100
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
#MaxThreadsPerHotkey 3
#NoEnv
;;∙------∙#NoTrayIcon
#Persistent
#SingleInstance, Force
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.
SetBatchLines -1
SetTimer, UpdateCheck, 500
SetTitleMatchMode 2
SetWinDelay 0
Menu, Tray, Icon, imageres.dll, 3
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
Menu, Tray, Add
;;------------------------------------------∙

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
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙MENU CALLS∙==========================================∙
X-Axis:    ;;∙------∙Suspends hotkeys then pauses script. (script tray menu header)
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
;;∙======∙TRAY MENU POSITION FUNTION∙======∙
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
;;∙============================================================∙

;;∙------------------------------------------------------------------------------------------∙
;;∙========================∙SCRIPT END∙=========================∙ 
;;∙------------------------------------------------------------------------------------------∙

