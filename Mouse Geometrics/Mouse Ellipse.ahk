
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

/*
» ∙======∙PARAMETERS∙============∙
 • pos_X1, pos_Y1: The destination coordinates.
 • param_Options: A space-separated string of options (case-insensitive).
      ▪ OX###, OY###: Define the starting point (the origin). If omitted, the current mouse position is used.
      ▪ R: Treat pos_X1 and pos_Y1 as relative movements from the origin. Crucial for moving from the current position.
      ▪ S###: Speed. The number of pixels to move each step. Higher = faster but less smooth.
      ▪ I0 or I1: Force the direction of the elliptical arc.
      ▪ B: Block user mouse input during the movement.
*/

;;∙----------------------------------------------------------------------∙
^F1::    ;;∙------∙🔥∙(Ctrl + F1)∙Basic Ellipse (Top-Left to Bottom-Right).
;;∙------∙Move the mouse from its current position to (current X + 500, current Y + 300)
;;∙------∙using the default speed and a random inversion.
MouseMove_Ellipse(500, 300, "R")
Return
;;∙----------------------------------------------------------------------∙


;;∙----------------------------------------------------------------------∙
^F2::    ;;∙------∙🔥∙(Ctrl + F2)∙Controlled, Repeatable Animation.
;;∙------∙Move from absolute coordinates (100, 200) to (800, 500).
;;∙------∙Use a slow speed (S5), force a clockwise/inverted path (I1), 
;;∙------∙and block user mouse input (B).
MouseMove_Ellipse(800, 500, "OX100 OY200 S5 I1 B")
Return
;;∙----------------------------------------------------------------------∙


;;∙----------------------------------------------------------------------∙
^F3::    ;;∙------∙🔥∙(Ctrl + F3)∙Moving from a Known Button to a Field.
;;∙------∙Coordinates of the "New Item" button.
ButtonX := 300
ButtonY := 150

;;∙------∙Move the mouse in an ellipse starting from the button (300, 150)
;;∙------∙to a point 400px right and 100px down from the button.
MouseMove_Ellipse(400, 100, "OX" ButtonX " OY" ButtonY " R S2")
Return
;;∙----------------------------------------------------------------------∙


;;∙----------------------------------------------------------------------∙
^F4::    ;;∙------∙🔥∙(Ctrl + F4)∙Creating a "Selection Box" Animation.
BoxX := 500
BoxY := 200
BoxW := 300
BoxH := 150

;;∙------∙1. Move from top-left (500, 200) to bottom-right (500+300, 200+150).
MouseMove_Ellipse(BoxW, BoxH, "OX" BoxX " OY" BoxY " R S5 I0")    ;;∙------∙I0 for a consistent arc.

;;∙------∙Optional: Add a short pause to make the animation clear.
Sleep, 300

;;∙------∙2. Move from the current position (now at bottom-right) back to the top-left.
; This time, the offsets are negative to go back up and left.
MouseMove_Ellipse(-BoxW, -BoxH, "R S5 I1") ; I1 for the return arc.
Return
;;∙----------------------------------------------------------------------∙




;;∙======∙FUNCTION∙============================================∙
MouseMove_Ellipse(pos_X1, pos_Y1, param_Options="") {

    StringUpper, param_Options, param_Options

    MouseGetPos, loc_MouseX, loc_MouseY    ;;∙------∙Use mouse coordinates if origin is omitted.
    pos_X0 := !RegExMatch(param_Options,"i)OX\d+",loc_Match) ? loc_MouseX : SubStr(loc_Match,3)
    pos_Y0 := !RegExMatch(param_Options,"i)OY\d+",loc_Match) ? loc_MouseY : SubStr(loc_Match,3)

        ;;∙------∙Set speed (default is 1).
    loc_Speed := !RegExMatch(param_Options,"i)S\d+\.?\d*",loc_Match) ? 1 : SubStr(loc_Match,2)

    If !RegExMatch(param_Options,"i)I[01]",loc_Match)
        Random, loc_Inv, 0, 1    ;;∙------∙Randomly invert by default.
    Else
        loc_Inv := SubStr(loc_Match,2)

    If InStr(param_Options,"R")    ;;∙------∙Support relative movements.
        pos_X1 += pos_X0  ,  pos_Y1 += pos_Y0

    If ( loc_Block := InStr(param_Options,"B") )    ;;∙------∙Block any mouse input.
        BlockInput, Mouse

    loc_B := Abs(pos_X0-pos_X1) , loc_A := Abs(pos_Y0-pos_Y1)    ;;∙------∙B: Width , A: Height.

    loc_Temp := loc_Inv ^ (pos_X0<pos_X1) ^ (pos_Y0<pos_Y1)
    loc_H := pos_X%loc_Temp%    ;;∙------∙Center point X.
    loc_Temp := !loc_Temp
    loc_K := pos_Y%loc_Temp%    ;;∙------∙Center point Y.

    loc_MDelay := A_MouseDelay    ;;∙------∙Save current mouse delay before changing it.
    SetMouseDelay, 1

    If ( loc_B > loc_A ) {    ;;∙------∙If distance from pos_X0 to pos_X1 is greater then pos_Y0 to pos_Y1.
        loc_MultX := ( pos_X0 < pos_X1 ) ? 1 : (-1)
        loc_MultY := loc_MultX * ( loc_Inv ? 1 : (-1) )
        Loop, % ( loc_B / loc_Speed ) {
            loc_X := pos_X0 + ( A_Index * loc_Speed * loc_MultX )    ;;∙------∙Add or subtract loc_Speed from X.
            loc_Y := ( loc_MultY * Sqrt(loc_A**2*((loc_X-loc_H)**2/loc_B**2-1)*-1) ) + loc_K    ;;∙------∙Formula for Y with a given X    ;;∙------∙
            MouseMove, %loc_X%, %loc_Y%, 0
        }
    } Else {    ;;∙------∙If distance from pos_Y0 to pos_Y1 is greater then pos_X0 to pos_X1.
        loc_MultY := ( pos_Y0 < pos_Y1 ) ? 1 : (-1)
        loc_MultX := loc_MultY * ( loc_Inv ? (-1) : 1 )
        Loop, % ( loc_A / loc_Speed ) {
            loc_Y := pos_Y0 + ( A_Index * loc_Speed * loc_MultY )    ;;∙------∙Add or subtract loc_Speed from Y
            loc_X := ( loc_MultX * Sqrt(loc_B**2*(1-(loc_Y-loc_K)**2/loc_A**2)) ) + loc_H    ;;∙------∙Formula for X with a given Y.
            MouseMove, %loc_X%, %loc_Y%, 0    ;;∙------∙Move mouse to new position.
        }
    }

    ;;∙------∙Prevent loop ending with mouse more than "loc_Speed" pixels away from pos_X1,pos_Y1.
    MouseMove, %pos_X1%, %pos_Y1%, 0

    If ( loc_Block )
        BlockInput, Off

    SetMouseDelay, %loc_MDelay%    ;;∙------∙Restore previous mouse delay.

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

