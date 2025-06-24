
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  SoggyDog
» Original Source:  https://www.autohotkey.com/board/topic/29633-simple-body-mass-index-calculator/
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
;^t::    ;;∙------∙🔥∙(Ctrl + T)
    Soundbeep, 1000, 200
;;∙============================================================∙




;;∙============================================================∙
;;∙============================================================∙
#NoEnv
#SingleInstance force
#Persistent
SendMode Input

Gui, Add, Text, x16 y10 w90 h20, Unit System:
Gui, Add, DropDownList, vunitSystem gUpdateUnits x110 y10 w160, Imperial||Metric

;;∙------∙Imperial inputs: Feet, Inches, Weight (lbs) on one line.
Gui, Add, GroupBox, x16 y40 w290 h50 vGroupImperialBox, Height & Weight (ft/in/lbs)
Gui, Add, Text,     x26 y60 w20 h20 vLblFeet, Ft
Gui, Add, Edit,     vFeet x46 y61 w40 h20
Gui, Add, Text,     x96 y60 w20 h20 vLblInches, In
Gui, Add, Edit,     vInches x116 y61 w40 h20
Gui, Add, Text,     x166 y60 w30 h20 vLblWeightImp, Lbs
Gui, Add, Edit,     vWeightImp x196 y61 w40 h20

;;∙------∙Metric inputs: Height (cm) and Weight (kg) on one line.
Gui, Add, GroupBox, x16 y95 w290 h50 vGroupMetricBox Hidden, Height & Weight (cm/kg)
Gui, Add, Text,     x46 y115 w30 h20 vLblHeight Hidden, Cm
Gui, Add, Edit,     vHeight x76 y116 w50 h20 Hidden
Gui, Add, Text,     x156 y115 w30 h20 vLblWeight Hidden, Kg
Gui, Add, Edit,     vWeight x186 y116 w50 h20 Hidden

;;∙------∙Results and actions.
Gui, Add, GroupBox, x16 y150 w290 h50, Results
Gui, Add, Edit, vResults x26 y170 w200 h20 ReadOnly
Gui, Add, Button, Default gButtonCalculate x236 y170 w70 h20, Calculate
Gui, Add, Button, gButtonClear x236 y200 w70 h20, Clear

Gui, Show, w325 h240, BMI Calculator
Return

UpdateUnits:
    Gui, Submit, NoHide
    if (unitSystem = "Metric")
    {
        GuiControl, Hide, GroupImperialBox
        GuiControl, Hide, Feet
        GuiControl, Hide, Inches
        GuiControl, Hide, WeightImp
        GuiControl, Hide, LblFeet
        GuiControl, Hide, LblInches
        GuiControl, Hide, LblWeightImp

        GuiControl, Show, GroupMetricBox
        GuiControl, Show, Height
        GuiControl, Show, Weight
        GuiControl, Show, LblHeight
        GuiControl, Show, LblWeight
    }
    else
    {
        GuiControl, Show, GroupImperialBox
        GuiControl, Show, Feet
        GuiControl, Show, Inches
        GuiControl, Show, WeightImp
        GuiControl, Show, LblFeet
        GuiControl, Show, LblInches
        GuiControl, Show, LblWeightImp

        GuiControl, Hide, GroupMetricBox
        GuiControl, Hide, Height
        GuiControl, Hide, Weight
        GuiControl, Hide, LblHeight
        GuiControl, Hide, LblWeight
    }
Return

ButtonCalculate:
    Gui, Submit, NoHide
    if (unitSystem = "Metric")
    {
        Height := Height / 100.0
        BMI := Weight / (Height * Height)
        unitLabel := "kg/m²"
    }
    else
    {
        Height := (Feet * 12) + Inches
        BMI := (WeightImp * 703) / (Height * Height)
        unitLabel := "lbs/in²"
    }

    Status := "Obese"
    if (BMI < 30)
        Status := "Overweight"
    if (BMI < 25)
        Status := "Normal"
    if (BMI < 18.5)
        Status := "Underweight"

    GuiControl, , Results, % Round(BMI, 1) . " " . unitLabel . " - " . Status
Return

ButtonClear:
    GuiControl, , Feet
    GuiControl, , Inches
    GuiControl, , WeightImp
    GuiControl, , Height
    GuiControl, , Weight
    GuiControl, , Results
Return

GuiClose:
ExitApp
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

