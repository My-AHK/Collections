
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  SirSocks
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?f=6&t=89019
» Color Changing Progress Bars
» HotKeys:  Ctrl + (1st letter of color name)
    ▹ Green-Yellow-Red-Marine Blue-Pink-Teal
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
;;∙======∙GREEN - READY/GO/START/LAUNCH/ACTIVE/∙==============∙
^g::    ;;∙------∙🔥∙(Ctrl + G)
    Soundbeep, 1000, 200

Gui, New, +HwndMyGuiHwnd

;;∙------∙Bar Start Color.
start_r := 1
start_g := 1
start_b := 1

;;∙------∙Bar End Color.
end_r := 0
end_g := 255
end_b := 0

;;∙------------------------∙

EndRBG := end_r end_g end_b

Total_Files := 0 
Cur_Step := 0 
Prog_Loc := 0 

Loop, Files, %A_WinDir%\*.*, D 
{
Total_Files++
}

math_r := (end_r - start_r) / Total_Files 
math_g := (end_g - start_g) / Total_Files 
math_b := (end_b - start_b) / Total_Files 

prog_r := start_r + math_r 
prog_g := start_g + math_g
prog_b := start_b + math_b

Gui, Color, 010101
Gui,  +AlwaysOnTop -Caption +LastFound
WinSet, TransColor, 010101

Gui, Add, progress, w200 Background000000 vMyProgress, %Prog_Loc%

Gui, Font, s10 Bold, Segoe UI
Gui, Add, text, x127 y25 w100 c00FF00 vPercentVar,
Gui, Font, s10 Normal, Segoe UI
Gui, Add, text, x67 yp w100 c00FF00, Loading....
Gui, Show

Loop,
    {    
    prog_r := prog_r + math_r 
    prog_g := prog_g + math_g
    prog_b := prog_b + math_b
    CurRBG := Round(prog_r) Round(prog_g) Round(prog_b) 
    hex := format("0x{1:02x}{2:02x}{3:02x}", prog_r, prog_g, prog_b) 

    Prog_Loc := Cur_Step/Total_Files*103 
    GuiControl, +c%hex%, MyProgress, 
    GuiControl,, MyProgress, % Prog_Loc 
    Cur_Step++    ;;∙------∙Counts the next step number.
    Sleep 12    ;;∙------∙Progress bar speed adjustment.

        If (Prog_Loc = 100) or (CurRBG = EndRBG)
        {
        GuiControl,, PercentVar, 100 `% 
        break
        }
    }
SetTimer, CloseBAR, -450
Return

/*   (Commented out to display multiple examples)
CloseBAR:
    Soundbeep, 670
    Gui, %MyGuiHwnd%:Destroy
Return
*/

;;∙============================================================∙
;;∙======∙YELLOW-WAIT/PAUSE/SLOW/SUSPEND/∙==================∙
^y::    ;;∙------∙🔥∙(Ctrl + Y)
    Soundbeep, 1000, 200

Gui, New, +HwndMyGuiHwnd
;;∙------∙Bar Start Color.
start_r := 1
start_g := 1
start_b := 1

;;∙------∙Bar End Color.
end_r := 255
end_g := 255
end_b := 0

;;∙------------------------∙

EndRBG := end_r end_g end_b

Total_Files := 0 
Cur_Step := 0 
Prog_Loc := 0 

Loop, Files, %A_WinDir%\*.*, D 
{
Total_Files++
}

math_r := (end_r - start_r) / Total_Files 
math_g := (end_g - start_g) / Total_Files 
math_b := (end_b - start_b) / Total_Files 

prog_r := start_r + math_r 
prog_g := start_g + math_g
prog_b := start_b + math_b

Gui, Color, 010101
Gui, +LastFound +AlwaysOnTop -Caption
WinSet, TransColor, 010101

Gui, Add, progress, w200 Background000000 vMyProgress, %Prog_Loc%

Gui, Font, s10 Bold, Segoe UI
Gui, Add, text, x127 y25 w100 c00FF00 vPercentVar,
Gui, Font, s10 Normal, Segoe UI
Gui, Add, text, x67 yp w100 c00FF00, Waiting....
Gui, Show

Loop,
    {    
    prog_r := prog_r + math_r 
    prog_g := prog_g + math_g
    prog_b := prog_b + math_b
    CurRBG := Round(prog_r) Round(prog_g) Round(prog_b) 
    hex := format("0x{1:02x}{2:02x}{3:02x}", prog_r, prog_g, prog_b) 

    Prog_Loc := Cur_Step/Total_Files*103 
    GuiControl, +c%hex%, MyProgress, 
    GuiControl,, MyProgress, % Prog_Loc 
    Cur_Step++    ;;∙------∙Counts the next step number.
    Sleep 12    ;;∙------∙Progress bar speed adjustment.

        If (Prog_Loc = 100) or (CurRBG = EndRBG)
        {
        GuiControl,, PercentVar, 100 `% 
        break
        }
    }
SetTimer, CloseBAR, -450
Return

/*   (Commented out to display multiple examples)
CloseBAR:
    Soundbeep, 670
    Gui, %MyGuiHwnd%:Destroy
Return
*/

;;∙============================================================∙
;;∙======∙RED-END/STOP/EXIT/FINISH/CLOSE/∙=====================∙
^r::    ;;∙------∙🔥∙(Ctrl + R)
    Soundbeep, 1000, 200

Gui, New, +HwndMyGuiHwnd

;;∙------∙Bar Start Color.
start_r := 1
start_g := 1
start_b := 1

;;∙------∙Bar End Color.
end_r := 255 ; RED
end_g := 0
end_b := 0
;;∙------------------------∙

EndRBG := end_r end_g end_b

Total_Files := 0 
Cur_Step := 0 
Prog_Loc := 0 

Loop, Files, %A_WinDir%\*.*, D 
{
Total_Files++
}

math_r := (end_r - start_r) / Total_Files 
math_g := (end_g - start_g) / Total_Files 
math_b := (end_b - start_b) / Total_Files 

prog_r := start_r + math_r 
prog_g := start_g + math_g
prog_b := start_b + math_b


Gui,  Color, 010101
Gui,  +LastFound +AlwaysOnTop -Caption
WinSet, TransColor, 010101

Gui,  Add, progress, w200 H15 Background000000 vMyProgress, %Prog_Loc%

Gui,  Font, s10 Normal , Segoe UI
Gui,  Add, text, x130 y25 w100 cRED vPercentVar,
Gui,  Font, s10 Normal, Segoe UI
Gui,  Add, text, x93 yp w100 cRED, Exiting....
Gui, Show

Loop,
    {    
    prog_r := prog_r + math_r 
    prog_g := prog_g + math_g
    prog_b := prog_b + math_b
    CurRBG := Round(prog_r) Round(prog_g) Round(prog_b) 
    hex := format("0x{1:02x}{2:02x}{3:02x}", prog_r, prog_g, prog_b) 

    Prog_Loc := Cur_Step/Total_Files*103 
    GuiControl, +c%hex%, MyProgress, 
    GuiControl,, MyProgress, % Prog_Loc 
    Cur_Step++    ;;∙------∙Counts the next step number.
    Sleep 17    ;;∙------∙Progress bar speed adjustment.

        If (Prog_Loc = 100) or (CurRBG = EndRBG) 
        {
        GuiControl,, PercentVar, 100 `% 
        break
        }
    }
SetTimer, CloseBAR, -450
Return

/*   (Commented out to display multiple examples)
CloseBAR:
    Soundbeep, 670
    Gui, %MyGuiHwnd%:Destroy
Return
*/

;;∙============================================================∙
;;∙======∙AquaMARINE-DETERMINE/YOUR/OWN/MEANING/∙=========∙
^m::    ;;∙------∙🔥∙(Ctrl + M)
    Soundbeep, 1000, 200

Gui, New, +HwndMyGuiHwnd
;;∙------∙Bar Start Color.    
start_r := 1
start_g := 1
start_b := 1

;;∙------∙Bar End Color.
end_r := 79
end_g := 232
end_b := 230

;;∙------------------------∙

EndRBG := end_r end_g end_b

Total_Files := 0 
Cur_Step := 0 
Prog_Loc := 0 

Loop, Files, %A_WinDir%\*.*, D 
{
Total_Files++
}

math_r := (end_r - start_r) / Total_Files 
math_g := (end_g - start_g) / Total_Files 
math_b := (end_b - start_b) / Total_Files 

prog_r := start_r + math_r 
prog_g := start_g + math_g
prog_b := start_b + math_b

Gui, Color, 010101
Gui, +LastFound +AlwaysOnTop -Caption
WinSet, TransColor, 010101

Gui, Add, progress, w200 Background000000 vMyProgress, %Prog_Loc%

Gui, Font, s10 Bold, Segoe UI
Gui, Add, text, x127 y25 w100 c00FF00 vPercentVar,
Gui, Font, s10 Normal, Segoe UI
Gui, Add, text, x67 yp w100 c00FF00, Loading....
Gui, Show

Loop,
    {    
    prog_r := prog_r + math_r 
    prog_g := prog_g + math_g
    prog_b := prog_b + math_b
    CurRBG := Round(prog_r) Round(prog_g) Round(prog_b) 
    hex := format("0x{1:02x}{2:02x}{3:02x}", prog_r, prog_g, prog_b) 

    Prog_Loc := Cur_Step/Total_Files*103 
    GuiControl, +c%hex%, MyProgress, 
    GuiControl,, MyProgress, % Prog_Loc 
    Cur_Step++    ;;∙------∙Counts the next step number.
    Sleep 12    ;;∙------∙Progress bar speed adjustment.

        If (Prog_Loc = 100) or (CurRBG = EndRBG)
        {
        GuiControl,, PercentVar, 100 `% 
        break
        }
    }
SetTimer, CloseBAR, -450
Return

/*   (Commented out to display multiple examples)
CloseBAR:
    Soundbeep, 670
    Gui, %MyGuiHwnd%:Destroy
Return
*/

;;∙============================================================∙
;;∙======∙BLUE-ATTENTION/INPUT NEEDED/∙=======================∙
^b::    ;;∙------∙🔥∙(Ctrl + B)
    Soundbeep, 1000, 200

Gui, New, +HwndMyGuiHwnd
;;∙------∙Bar Start Color    
start_r := 1
start_g := 1
start_b := 1

;;∙------∙Bar End Color
end_r := 0
end_g := 0
end_b := 255

;;∙------------------------∙

EndRBG := end_r end_g end_b

Total_Files := 0 
Cur_Step := 0 
Prog_Loc := 0 

Loop, Files, %A_WinDir%\*.*, D 
{
Total_Files++
}

math_r := (end_r - start_r) / Total_Files 
math_g := (end_g - start_g) / Total_Files 
math_b := (end_b - start_b) / Total_Files 

prog_r := start_r + math_r 
prog_g := start_g + math_g
prog_b := start_b + math_b

Gui, Color, 010101
Gui, +LastFound +AlwaysOnTop -Caption
WinSet, TransColor, 010101

Gui, Add, progress, w200 Background000000 vMyProgress, %Prog_Loc%

Gui, Font, s10 Bold, Segoe UI
Gui, Add, text, x127 y25 w100 c00FF00 vPercentVar,
Gui, Font, s10 Normal, Segoe UI
Gui, Add, text, x67 yp w100 c00FF00, Loading....
Gui, Show

Loop,
    {    
    prog_r := prog_r + math_r 
    prog_g := prog_g + math_g
    prog_b := prog_b + math_b
    CurRBG := Round(prog_r) Round(prog_g) Round(prog_b) 
    hex := format("0x{1:02x}{2:02x}{3:02x}", prog_r, prog_g, prog_b) 

    Prog_Loc := Cur_Step/Total_Files*103 
    GuiControl, +c%hex%, MyProgress, 
    GuiControl,, MyProgress, % Prog_Loc 
    Cur_Step++    ;;∙------∙Counts the next step number.
    Sleep 12    ;;∙------∙Progress bar speed adjustment.

        If (Prog_Loc = 100) or (CurRBG = EndRBG)
        {
        GuiControl,, PercentVar, 100 `% 
        break
        }
    }
SetTimer, CloseBAR, -450
Return

/*   (Commented out to display multiple examples)
CloseBAR:
    Soundbeep, 670
    Gui, %MyGuiHwnd%:Destroy
Return
*/

;;∙============================================================∙
;;∙======∙PINK-DETERMINE/YOUR/OWN/MEANING/∙================∙
^p::    ;;∙------∙🔥∙(Ctrl + P)
    Soundbeep, 1000, 200

Gui, New, +HwndMyGuiHwnd
;;∙------∙Bar Start Color    
start_r := 1
start_g := 1
start_b := 1

;;∙------∙Bar End Color
end_r := 232
end_g := 134
end_b := 234

;;∙------------------------∙

EndRBG := end_r end_g end_b

Total_Files := 0 
Cur_Step := 0 
Prog_Loc := 0 

Loop, Files, %A_WinDir%\*.*, D 
{
Total_Files++
}

math_r := (end_r - start_r) / Total_Files 
math_g := (end_g - start_g) / Total_Files 
math_b := (end_b - start_b) / Total_Files 

prog_r := start_r + math_r 
prog_g := start_g + math_g
prog_b := start_b + math_b

Gui, Color, 010101
Gui, +LastFound +AlwaysOnTop -Caption
WinSet, TransColor, 010101

Gui, Add, progress, w200 Background000000 vMyProgress, %Prog_Loc%

Gui, Font, s10 Bold, Segoe UI
Gui, Add, text, x127 y25 w100 c00FF00 vPercentVar,
Gui, Font, s10 Normal, Segoe UI
Gui, Add, text, x67 yp w100 c00FF00, Loading....
Gui, Show

Loop,
    {    
    prog_r := prog_r + math_r 
    prog_g := prog_g + math_g
    prog_b := prog_b + math_b
    CurRBG := Round(prog_r) Round(prog_g) Round(prog_b) 
    hex := format("0x{1:02x}{2:02x}{3:02x}", prog_r, prog_g, prog_b) 

    Prog_Loc := Cur_Step/Total_Files*103 
    GuiControl, +c%hex%, MyProgress, 
    GuiControl,, MyProgress, % Prog_Loc 
    Cur_Step++    ;;∙------∙Counts the next step number.
    Sleep 12    ;;∙------∙Progress bar speed adjustment.

        If (Prog_Loc = 100) or (CurRBG = EndRBG)
        {
        GuiControl,, PercentVar, 100 `% 
        break
        }
    }
SetTimer, CloseBAR, -450
Return

/*   (Commented out to display multiple examples)
CloseBAR:
    Soundbeep, 670
    Gui, %MyGuiHwnd%:Destroy
Return
*/

;;∙============================================================∙
;;∙======∙TEAL-DETERMINE/YOUR/OWN/MEANING/∙================∙
^t::    ;;∙------∙🔥∙(Ctrl + T)
    Soundbeep, 1000, 200

Gui, New, +HwndMyGuiHwnd
;;∙------∙Bar Start Color    
start_r := 1
start_g := 1
start_b := 1

;;∙------∙Bar End Color
end_r := 0
end_g := 124
end_b := 124

;;∙------------------------∙

EndRBG := end_r end_g end_b

Total_Files := 0 
Cur_Step := 0 
Prog_Loc := 0 

Loop, Files, %A_WinDir%\*.*, D 
{
Total_Files++
}

math_r := (end_r - start_r) / Total_Files 
math_g := (end_g - start_g) / Total_Files 
math_b := (end_b - start_b) / Total_Files 

prog_r := start_r + math_r 
prog_g := start_g + math_g
prog_b := start_b + math_b

Gui, Color, 010101
Gui, +LastFound +AlwaysOnTop -Caption
WinSet, TransColor, 010101

Gui, Add, progress, w200 Background000000 vMyProgress, %Prog_Loc%

Gui, Font, s10 Bold, Segoe UI
Gui, Add, text, x127 y25 w100 c00FF00 vPercentVar,
Gui, Font, s10 Normal, Segoe UI
Gui, Add, text, x67 yp w100 c00FF00, Loading....
Gui, Show

Loop,
    {    
    prog_r := prog_r + math_r 
    prog_g := prog_g + math_g
    prog_b := prog_b + math_b
    CurRBG := Round(prog_r) Round(prog_g) Round(prog_b) 
    hex := format("0x{1:02x}{2:02x}{3:02x}", prog_r, prog_g, prog_b) 

    Prog_Loc := Cur_Step/Total_Files*103 
    GuiControl, +c%hex%, MyProgress, 
    GuiControl,, MyProgress, % Prog_Loc 
    Cur_Step++    ;;∙------∙Counts the next step number.
    Sleep 12    ;;∙------∙Progress bar speed adjustment.

        If (Prog_Loc = 100) or (CurRBG = EndRBG)
        {
        GuiControl,, PercentVar, 100 `% 
        break
        }
    }
SetTimer, CloseBAR, -450
Return

/*   (Commented out to display multiple examples)
CloseBAR:
    Soundbeep, 670
    Gui, %MyGuiHwnd%:Destroy
Return
*/

;;∙============================================================∙

CloseBAR:
    Soundbeep, 670
    Gui, %MyGuiHwnd%:Destroy
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

