
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
» Author:  teadrinker
» https://www.autohotkey.com/boards/viewtopic.php?f=76&t=67571#p290563
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TEMPLATE"    ;;∙------∙Need to also change in "MENU CALLS"
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙🔥 HotKey 🔥∙===========================================∙
; ^t::    ;;∙------∙(Ctrl+T) 
;    Soundbeep, 1100, 100
;;∙============================================================∙




;;∙============================================================∙
SetBatchLines, -1    ;;∙------∙Disable time slicing to run the script at full speed.
CoordMode, Mouse    ;;∙------∙Set the coordinate mode for mouse functions to screen-relative.

guiHomeX := 300    ;;∙------∙Set the 'X' home position for the GUI.
guiHomeY := 300    ;;∙------∙Set the 'Y' home position for the GUI.

step := 300    ;;∙------∙Set the step size for movement. (distance the GUI moves per step)
period := 200    ;;∙------∙Set the timer period. (how frequently the GUI moves)

;;∙---------------------------------------------∙
Gui, New, -Caption +ToolWindow +AlwaysOnTop +hwndhGui
Gui, Color, Blue
Gui, Font, s16 q5, Calibri
Gui, Show, x%guiHomeX% y%guiHomeY% w75 h75
OnMessage( 0x201, Func("WM_LBUTTONDOWN").Bind(hGui, guiHomeX, guiHomeY, period, step) )    ;;∙------∙Bind the left mouse button click message to the WM_LBUTTONDOWN function.


;;∙---------------------------------------------∙
WM_LBUTTONDOWN(hGui, guiHomeX, guiHomeY, period, step, wp, lp, msg, hwnd) {
   static toggle := true, timer, mode := []    ;;∙------∙Initialize toggle, timer, and mode variables.
   if (hGui = hwnd) {    ;;∙------∙If the clicked window is the GUI.
      ( !timer && timer := Func("MoveGui").Bind(mode, hGui, step, guiHomeX, guiHomeY) )    ;;∙------∙Bind MoveGui function to a timer if it's not already set.
      if toggle := !toggle
         mode[1] := "goHome"    ;;∙------∙Toggle mode to move GUI back to home position.
      else {
         mode[1] := "follow"    ;;∙------∙Toggle mode to follow the mouse.
         SetTimer, % timer, Off    ;;∙------∙Ensure any previous timer is stopped.
         SetTimer, % timer, % period    ;;∙------∙Set the new timer to call MoveGui at the specified period.
      }
   }
}
;;∙---------------------------------------------∙
MoveGui(mode, hGui, step, guiHomeX, guiHomeY) {
   if (mode[1] = "follow")
      MouseGetPos, mouseX, mouseY    ;;∙------∙Get the current mouse position if in "follow" mode.
   WinGetPos, guiX, guiY, guiW, guiH, ahk_id %hGui%    ;;∙------∙Get the current position and size of the GUI.
   guiX += guiW/2, guiY += guiH/2    ;;∙------∙Adjust GUI position to center.
   nextPoint := GetNextPoint( {x: guiX, y: guiY}
                            , mode[1] = "follow" ? {x: mouseX, y: mouseY} : {x: guiHomeX, y: guiHomeY}
                            , step )    ;;∙------∙Calculate the next point to move to, based on mode.
   Gui, %hGui%: Show, % "NA x" nextPoint.x - guiW/2 " y" nextPoint.y - guiH/2    ;;∙------∙Move the GUI to the next point.
   if (mode[1] = "goHome" && nextPoint.x = guiHomeX && nextPoint.y = guiHomeY) {    ;;∙------∙If the GUI reaches home, stop the timer.
      SetTimer,, Off
   }
}
;;∙---------------------------------------------∙
GetNextPoint(point1, point2, step) {
   X := Floor(point2.x - point1.x)    ;;∙------∙Calculate the X distance between two points.
   Y := Floor(point2.y - point1.y)    ;;∙------∙Calculate the Y distance between two points.
   distance := (X**2 + Y**2)**.5    ;;∙------∙Calculate the distance between two points using the Pythagorean theorem.
   if (distance <= step)
      nextPoint := point2    ;;∙------∙If the distance is less than or equal to the step size, set next point as the target.
   else {
      stepX := Abs(X*step/distance)    ;;∙------∙Calculate the X component of the step.
      stepY := Abs(Y*step/distance)    ;;∙------∙Calculate the Y component of the step.
      nextPoint := { x: point1.x + stepX*(X > 0 ? 1 : -1)
                   , y: point1.y + stepY*(Y > 0 ? 1 : -1) }    ;;∙------∙Calculate the next point to move towards.
   }
   Return nextPoint    ;;∙------∙Return the next point to move towards.
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
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙--∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        Soundbeep, 1200, 75
        Soundbeep, 1400, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙--∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        Soundbeep, 1400, 75
        Soundbeep, 1200, 100
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
#MaxThreadsPerHotkey 3
#NoEnv
;;∙------∙#NoTrayIcon
#Persistent
#SingleInstance, Force
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;; Gui Drag Pt 1.
SetBatchLines -1
SetTimer, UpdateCheck, 500
SetTitleMatchMode 2
SetWinDelay 0
Menu, Tray, Icon, Imageres.dll, 65
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Tray Menu∙============================================∙
TrayMenu:
Menu, Tray, Tip, %ScriptID%    ;;∙------∙Suspends hotkeys then pauses script.
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, %ScriptID%
Menu, Tray, Icon, %ScriptID%, Imageres.dll, 65
Menu, Tray, Default, %ScriptID%    ;;∙------∙Makes Bold.
Menu, Tray, Add
;;∙------∙  ∙--------------------------------∙

;;∙------∙Script∙Options∙---------------∙
Menu, Tray, Add
Menu, Tray, Add, Script·Edit
Menu, Tray, Icon, Script·Edit, shell32.dll, 270
Menu, Tray, Add
Menu, Tray, Add, Script·Reload
Menu, Tray, Icon, Script·Reload, mmcndmgr.dll, 47
Menu, Tray, Add
Menu, Tray, Add, Script·Exit
Menu, Tray, Icon, Script·Exit, shell32.dll, 272
Menu, Tray, Add
Menu, Tray, Add
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙MENU CALLS∙==========================================∙
TEMPLATE:    ;;∙------∙Change as needed to match the 'ScriptID' variable in AutoExe section.
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

