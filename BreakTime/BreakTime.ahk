
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
» Author:  
» 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "BreakTime"    ;;∙------∙Need to also change in "MENU CALLS"
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙🔥 HotKey 🔥∙===========================================∙
; ^t::    ;;∙------∙(Ctrl+T) 
;    Soundbeep, 1100, 100
;;∙============================================================∙



;;∙======∙Settings Variables∙======================================∙
;;∙------∙Page to open when timer ends.
URL := "https://put/web URL here"

;;∙------∙Gui Basic Colors.
guiColor := "111111"
guiFont := "Segoe UI"
fontColor := "327FFF"    ;;∙------∙Minutes / Seconds.

;;∙------∙Gui Positioning.
guiX := "1650"    ;;∙------∙Gui x-axis.
guiY := "100"    ;;∙------∙Gui y-axis.
guiW := "225"    ;;∙------∙Gui width.
guiH := "165"    ;;∙------∙Gui Height.

;;∙------∙Edit Boxes
editTextColor := "0322B0"    ;;∙------∙Editbox text color.
minDefault := "00"    ;;∙------∙Default Minute start value.
secDefault := "59"    ;;∙------∙Default Second start value.

;;∙------∙Progress Bar.
barColor := "32E90DE"    ;;∙------∙Progress bar backgroundolor.
barTextColor := "0322B0"    ;;∙------∙Progress bar text color.

;;∙------∙Aligned from Gui rightside.
guiInterior1 := (guiW - 50)    ;;∙------∙Reload Button.
guiInterior2 := (guiW - 40)    ;;∙------∙Progress bar & Counter.
guiInterior3 := (guiW - 70)    ;;∙------∙Pause button.

;;∙------∙Reload Exit buttons..
iSizeW := "12"    ;;∙------∙Icon button Width.
iSizeH := "12"    ;;∙------∙Icon button Height.

;;∙------------------------------------------------------------------------------------------∙
;;∙------------------------∙GUI PREP∙------------------------∙
Gui, Destroy
Gui, +AlwaysOnTop -Caption +hwndHGUI +LastFound +Owner
        +E0x02000000 +E0x00080000    ;;∙------∙Gui Double Buffer flicker reducer.
Gui, Color, %guiColor%
;;∙------∙MINUTES
    Gui, Font, s10 c%editTextColor% Bold, %guiFont%
Gui, Add, Edit, x30 y15 w55 BackgroundTrans Limit3 number right vEdit1    ;;∙------∙Add a read-only edit box for minutes input.
Gui, Add, UpDown, vMinutes Range0-360 wrap, %minDefault%    ;;∙------∙Add an up-down control for minutes ranging from 0-119.
    Gui, Font, s10 c%fontColor% Norm, %guiFont%
Gui, Add, Text, x80 y17 BackgroundTrans, %A_Space%  Minutes
;;∙------∙SECONDS
    Gui, Font, s10 c%editTextColor% Bold, %guiFont%
Gui, Add, Edit, x30 y50 w55 BackgroundTrans Limit2 number right vEdit2    ;;∙------∙Add a read-only edit box for seconds input.
Gui, Add, UpDown, vSeconds Range0-59 wrap, %secDefault%    ;;∙------∙Add an up-down control for seconds ranging from 0-59.
    Gui, Font, s10 c%fontColor% Norm, %guiFont%
Gui, Add, Text, x80 y52 BackgroundTrans, %A_Space%  Seconds    ;;∙------∙Add a label for the seconds input.
;;∙------∙EXIT & RELOAD BUTTONS
Gui, Add, Picture, x%guiInterior1% y15 BackgroundTrans gReload w%iSizeW% h%iSizeH% Icon239, shell32.dll    ;;∙------∙Reload
Gui, Add, Picture, x+5 y15 BackgroundTrans gExit w%iSizeW% h%iSizeH% Icon132, shell32.dll    ;;∙------∙Exit
;;∙------∙TIME REMAINING DISPLAY
Gui, Add, Text, x20 y90 w%guiInterior2% c%barTextColor% BackgroundTrans Center vTimeRemaining, Default: %minDefault%:%secDefault%
;;∙------∙PROGRESS BAR
Gui, Add, Progress, x20 y90 w%guiInterior2% h20 BackgroundBlack c%barColor% vMyProgress    ;;∙------∙Add a progress bar to show countdown progress.
;;∙------∙START/PAUSE BUTTONS
Gui, Add, Button, x20 y120 w130 h25 vStartButton Default, Start    ;;∙------∙Start button.
Gui, Add, Button, x%guiInterior3% y120 w50 h25, Pause    ;;∙------∙Pause button.
GuiControl, Focus, StartButton
 ;;∙------∙Gui Shaping
Gui, Show, x%guiX% y%guiY% w%guiW% h%guiH% Hide
WinGetPos, X, Y, W, H
R := Min(W, H) // 3    ;;∙------∙Set cornering value. (0.5=Oval, 0=square, 1= capsule, 3=lrg curve corner, etc.)
WinSet, Region, 0-0 W%W% H%H% R%R%-%R%
 ;;∙------∙
Gui, Show,, BreakTime
Return

;;∙------------------------------------------------------------------------------------------∙
;;∙-----------------------∙Start Button∙----------------------∙
ButtonStart:
Gui, Submit, NoHide    ;;∙------∙Submit the GUI values without hiding the window.
TotalSec := (Minutes * 60 + Seconds)    ;;∙------∙Convert the Minutes and Seconds to Total Seconds.
StopTime := A_TickCount + (TotalSec * 1000)    ;;∙------∙Calculate when the countdown should stop.
Paused := false    ;;∙------∙Track pause state.

;;∙------∙Update initial display with entered time
FormattedTime := Format("{:02}", Minutes) ":" Format("{:02}", Seconds)  ;;∙------∙Format time for initial display
GuiControl,, TimeRemaining, Time Remaining:  %FormattedTime%
GuiControl,, Edit1, %Minutes%    ;;∙------∙Update the Minutes display in the GUI.
GuiControl,, Edit2, %Seconds%    ;;∙------∙Update the Seconds display in the GUI.

Loop    ;;∙------∙Start countdown loop.
{
    If (Paused)
    {
        Sleep, 100    ;;∙------∙Sleep briefly while paused.
        Continue    ;;∙------∙Skip to the next loop iteration if paused.
    }

    Sleep 1000    ;;∙------∙Wait for 1 Second.
    TimeLeft := (StopTime - A_TickCount) / 1000    ;;∙------∙Calculate the remaining time in Seconds.
    ProgressBar := 100 - (TimeLeft / TotalSec * 100)    ;;∙------∙Calculate the percentage of Progress completed.
    Minutes := Floor(TimeLeft / 60)    ;;∙------∙Calculate the remaining Minutes.
    Seconds := Round(Mod(TimeLeft, 60))    ;;∙------∙Calculate the remaining Seconds.
    
    If TimeLeft >= 0
    {
        GuiControl,, Edit1, % Minutes    ;;∙------∙Update the Minutes display in the GUI.
        GuiControl,, Edit2, % Seconds    ;;∙------∙Update the Seconds display in the GUI.
        
        ;;∙------∙Format and update the time remaining display
        FormattedTime := Format("{:02}", Minutes) ":" Format("{:02}", Seconds)
        GuiControl,, TimeRemaining, Time Remaining:  %FormattedTime%
    }
    
    GuiControl,, MyProgress, % ProgressBar    ;;∙------∙Update the Progress Bar with the calculated value.
    
    If (A_TickCount >= StopTime)
    {
        Break    ;;∙------∙Exit the loop when the countdown reaches zero.
    }
}
Loop, 2
{
    SoundBeep, 987, 100
}
Gui, Destroy
    SoundGet, master_volume    ;;∙------∙Retrieve system volume.
    SoundSet, 5    ;;∙------∙Raise system volume for announcement.
ComObjCreate("SAPI.SpVoice").Speak("Your break is over!!!")    ;;∙------∙Use text-to-speech to announce the break is over.
Run % URL    ;;∙------∙Open website when timer completes.
    SoundSet, master_volume    ;;∙------∙Restore system volume.
    Reload
Return

;;∙------------------------------------------------------------------------------------------∙
;;∙----------------------∙Pause Button∙----------------------∙
ButtonPause:
Paused := !Paused    ;;∙------∙Toggle the pause state.
If (Paused)
{
    Soundbeep, 444, 100    ;;∙------∙Beep to indicate paused state.
    GuiControl,, ButtonPause, Resume    ;;∙------∙Change button text to Resume.
}
else
{
    Soundbeep, 555, 100    ;;∙------∙Beep to indicate resuming state.
    StopTime := A_TickCount + (Minutes * 60 + Seconds) * 1000    ;;∙------∙Update StopTime for remaining duration.
    GuiControl,, ButtonPause, Pause    ;;∙------∙Change button text to Pause.
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
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)        ;;∙------∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
    Reload:    ;;∙------∙Button Call.
        Soundbeep, 1200, 75
        Soundbeep, 1400, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)        ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
    Exit:    ;;∙------∙Button Call.
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
Menu, Tray, Icon, Imageres.dll, 65    ;;∙------∙Tray Icon.
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
BreakTime:    ;;∙------∙Change as needed to match the 'ScriptID' variable in AutoExe section.
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

