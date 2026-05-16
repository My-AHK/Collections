
;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙

;;∙==============================================∙
;;∙======∙DIRECTIVES & SETTINGS∙==================∙
#Requires AutoHotkey 1
#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines -1
SetWinDelay 0
SetWorkingDir %A_ScriptDir%

SetTimer, UpdateCheck, 500
Menu, Tray, Icon, imageres.dll, 102
GoSub, TrayMenu

;;∙==============================================∙
;;∙======∙HOTKEY∙================================∙
; F1::    ;;∙------∙🔥∙(F1)∙🔥∙(Use if not using the button)

;;∙==============================================∙
;;∙======∙SHIELD SETTINGS∙========================∙
shieldX := 700    ;;∙------∙The Shield x-axis starting point.
shieldY := 20    ;;∙------∙The Shield y-axis starting point.

shieldW := 500    ;;∙------∙Width of Shield.
shieldH := 700    ;;∙------∙Height of Shield.

shieldColor := "010101"    ;;∙------∙Color of transparent shield (must differ from borderColor or border will be invisible).
borderT := 1    ;;∙------∙Thickness of Gui shield border.
borderColor := "Red"    ;;∙------∙Color of Gui shield border.

;;∙==============================================∙
;;∙======∙BUTTON SETTINGS∙=======================∙(delete if no button desired)
buttonX := 5    ;;∙------∙Gui button x-axis starting point.
buttonY := 5    ;;∙------∙Gui button y-axis starting point.

buttonW := 80    ;;∙------∙Buttton Width.
buttonH := 30    ;;∙------∙Buttton Height.

btnBorderW := 2    ;;∙------∙Thickness of Gui button border.
btnBorderColor := "Blue"    ;;∙------∙Color of Gui button border.

;;∙==============================================∙
;;∙======∙GUI BUTTON BUILD∙======================∙(delete if no button desired)
Gui, 1:+AlwaysOnTop -Caption +ToolWindow
Gui, 1:Color, Lime
;;∙------∙Two overlapping labels swap visibility on toggle, each has its own font color.
Gui, 1:Font, s12 q5 Bold cBlack, Arial
Gui, 1:Add, Text, x0 y0 w%buttonW% h%buttonH% Center 0x200 gRegionShield vStatusText, LOCK
Gui, 1:Font, s12 q5 Bold cWhite, Arial
Gui, 1:Add, Text, x0 y0 w%buttonW% h%buttonH% Center 0x200 gRegionShield vStatusText2, UNLOCK
GuiControl, 1:Hide, StatusText2
Gui, 1:Show, x%buttonX% y%buttonY% w%buttonW% h%buttonH%, ShieldToggle
    boxLine(1, 0, 0, buttonW, buttonH, btnBorderColor, btnBorderColor, btnBorderColor, btnBorderColor, btnBorderW)
Return

;;∙==============================================∙
;;∙======∙REGION SHIELD FUNCTION∙================∙
RegionShield:
    toggled := !toggled
    if (toggled) {
        ;;∙------∙Gui 2: Physically blocks mouse input. Uses Transparent instead of TransColor
        ;;∙------∙because TransColor re-enables click-through at the OS level regardless of -E0x20.
        Gui, 2:+AlwaysOnTop -Caption +ToolWindow +LastFound -E0x20
        Gui, 2:Color, %shieldColor%
        WinSet, Transparent, 1
        Gui, 2:Show, % "x" shieldX " y" shieldY " w" shieldW " h" shieldH, Region Shield

        ;;∙------∙Gui 3: Click-through border overlay. TransColor punches out the interior,
        ;;∙------∙leaving only the boxLine border visible. +E0x20 passes clicks through to Gui 2.
        Gui, 3:+AlwaysOnTop -Caption +ToolWindow +LastFound +E0x20
        Gui, 3:Color, %shieldColor%
        WinSet, TransColor, %shieldColor%
        Gui, 3:Show, % "x" shieldX " y" shieldY " w" shieldW " h" shieldH, Region Border
            boxLine(3, 0, 0, shieldW, shieldH, borderColor, borderColor, borderColor, borderColor, borderT)

        Gui, 1:Color, Red
        GuiControl, 1:Hide, StatusText
        GuiControl, 1:Show, StatusText2
        Menu, Tray, Icon, imageres.dll, 101
    } else {
        Gui, 2:Destroy
        Gui, 3:Destroy
        Gui, 1:Color, Lime
        GuiControl, 1:Hide, StatusText2
        GuiControl, 1:Show, StatusText
        Menu, Tray, Icon, imageres.dll, 102
    }
Return

;;∙==============================================∙
;;∙========∙boxLine ROUTINE∙======================∙
;;∙====∙Draw a border around a GUI using four edge bars.
;;∙------∙GuiName: Target GUI
;;∙------∙X, Y: Top-left corner position of the border
;;∙------∙W: Total width of the bordered area
;;∙------∙H: Total height of the bordered area
;;∙------∙ColorTop/Bottom/Left/Right: Color for each edge
;;∙------∙Thickness: Width of each edge bar in pixels
boxLine(GuiName, X, Y, W, H, ColorTop := "Black", ColorBottom := "Black", ColorLeft := "Black", ColorRight := "Black", Thickness := 1)
{
    ;;∙------∙Calculate positions.
    BottomY := Y + H - Thickness
    RightX := X + W - Thickness

    ;;∙------∙Top edge.
    Gui, %GuiName%:Add, Progress, x%X% y%Y% w%W% h%Thickness% Background%ColorTop%
    ;;∙------∙Bottom edge.
    Gui, %GuiName%:Add, Progress, x%X% y%BottomY% w%W% h%Thickness% Background%ColorBottom%
    ;;∙------∙Left edge.
    Gui, %GuiName%:Add, Progress, x%X% y%Y% w%Thickness% h%H% Background%ColorLeft%
    ;;∙------∙Right edge.
    Gui, %GuiName%:Add, Progress, x%RightX% y%Y% w%Thickness% h%H% Background%ColorRight%
}

;;∙==============================================∙
;;∙======∙CLOSE ROUTINES∙========================∙
CloseGui:
GuiClose:
    global toggled
    if (toggled) {
        Gui, 2:Destroy
        Gui, 3:Destroy
    }
    Gui, 1:Destroy
    ExitApp
Return

;;∙==============================================∙
;;∙======∙SCRIPT EDIT / RELOAD / EXIT∙==============∙
;;∙------∙EDIT∙---------------------------∙
Script·Edit:    ;;∙------∙Menu Call.
    Edit
Return

;;∙------∙RELOAD∙-----------------------∙
^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        ;;∙------∙Soundbeep, 1000, 200
    Reload
Return

;;∙------∙EXIT∙----------------------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        Soundbeep, 1000, 200
    ExitApp
Return

;;∙==============================================∙
;;∙======∙SCRIPT UPDATE∙=========================∙
UpdateCheck:    ;;∙------Check if script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload

;;∙==============================================∙
;;∙======∙TRAY MENU∙=============================∙
TrayMenu:
Menu, Tray, Tip, Region Shield
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add

;;∙------∙MENU-EXTENTIONS∙-------∙
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

;;∙------∙MENU-OPTIONS∙------------∙
Menu, Tray, Add
Menu, Tray, Add, Script Edit, Script·Edit
Menu, Tray, Icon, Script Edit, imageres.dll, 247
Menu, Tray, Add
Menu, Tray, Add, Script Reload, Script·Reload
Menu, Tray, Icon, Script Reload, mmcndmgr.dll, 47
Menu, Tray, Add
Menu, Tray, Add, Script Exit, Script·Exit
Menu, Tray, Icon, Script Exit, shell32.dll, 272
Menu, Tray, Default, Script Exit
Menu, Tray, Add
Menu, Tray, Add
Return

;;∙------∙EXTENTIONS∙----------------∙
Documentation:
    Run, "C:\Program Files\AutoHotkey\AutoHotkey.chm"
Return
ShowKeyHistory:
    KeyHistory
Return
ShowWindowSpy:
    Run, "C:\Program Files\AutoHotkey\WindowSpy.ahk"
Return

;;∙==============================================∙
;;∙======∙TRAY MENU POSITION∙====================∙
;;∙------∙Tray Menu Show∙-----------∙
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20
Return

;;∙------∙Position Funtion∙------------∙
NotifyTrayClick(P*) { 
Static Msg, Fun:="NotifyTrayClick", NM:=OnMessage(0x404,Func(Fun),-1),  Chk,T:=-250,Clk:=1
  If ( (NM := Format(Fun . "_{:03X}", Msg := P[2])) && P.Count()<4 )
     return ( T := Max(-5000, 0-(P[1] ? Abs(P[1]) : 250)) )
  Critical
  If ( ( Msg<0x201 || Msg>0x209 ) || ( IsFunc(NM) || Islabel(NM) )=0 )
     return
  Chk := (Fun . "_" . (Msg<=0x203 ? "203" : Msg<=0x206 ? "206" : Msg<=0x209 ? "209" : ""))
  SetTimer, %NM%,  %  (Msg==0x203        || Msg==0x206        || Msg==0x209)
    ? (-1, Clk:=2) : ( Clk=2 ? ("Off", Clk:=1) : ( IsFunc(Chk) || IsLabel(Chk) ? T : -1) )
return True
}
Return

;;∙============================================================∙
;;∙------------------------------------∙SCRIPT END∙-------------------------------------∙
;;∙============================================================∙

