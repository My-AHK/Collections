
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
; F1::    ;;∙------∙🔥∙(F1)∙🔥∙Release cage hotkey.
;     GoSub, MouseCage
; Return

;;∙==============================================∙
;;∙======∙CAGE SETTINGS∙=========================∙
cageColor := "010101"   ;;∙------∙TransColor key (must differ from borderColor).
cageX := 700    ;;∙------∙The Cage x-axis starting point.
cageY := 20     ;;∙------∙The Cage y-axis starting point.
cageW := 500    ;;∙------∙Width of Cage.
cageH := 700    ;;∙------∙Height of Cage.

borderT := 2              ;;∙------∙Thickness of Gui cage border.
borderColor := "Yellow"   ;;∙------∙Color of Gui cage border.
escapeColor := "Red"   ;;∙------∙Color of diagonal escape corner.

;;∙==============================================∙
;;∙======∙BUTTON SETTINGS∙=======================∙
buttonX := 5    ;;∙------∙Gui button x-axis starting point.
buttonY := 5    ;;∙------∙Gui button y-axis starting point.

buttonW := 80   ;;∙------∙Button Width.
buttonH := 30   ;;∙------∙Button Height.

btnBorderW := 2           ;;∙------∙Thickness of Gui button border.
btnBorderColor := "Blue"  ;;∙------∙Color of Gui button border.

;;∙==============================================∙
;;∙======∙GUI BUTTON BUILD∙======================∙
Gui, 1:+AlwaysOnTop -Caption +ToolWindow
Gui, 1:Color, Lime
;;∙------∙Two overlapping labels swap visibility on toggle, each has its own font color.
Gui, 1:Font, s12 q5 Bold cBlack, Arial
Gui, 1:Add, Text, x0 y0 w%buttonW% h%buttonH% Center 0x200 gMouseCage vStatusText, CAGE
Gui, 1:Font, s12 q5 Bold cWhite, Arial
Gui, 1:Add, Text, x0 y0 w%buttonW% h%buttonH% Center 0x200 gMouseCage vStatusText2, RELEASE
GuiControl, 1:Hide, StatusText2
Gui, 1:Show, x%buttonX% y%buttonY% w%buttonW% h%buttonH%, CageToggle
    boxLine(1, 0, 0, buttonW, buttonH, btnBorderColor, btnBorderColor, btnBorderColor, btnBorderColor, btnBorderW)
Return

;;∙==============================================∙
;;∙======∙MOUSE CAGE FUNCTION∙===================∙
MouseCage:
    toggled := !toggled
    if (toggled) {
        ;;∙------∙Gui 2: Solid near-transparent blocker. Physically blocks mouse input.
        Gui, 2:+AlwaysOnTop -Caption +ToolWindow +LastFound -E0x20
        Gui, 2:Color, %cageColor%
        ;;∙------∙Blank clickable escape zone positioned under the triangle area.
        triX := cageW - borderT - 20
        triY := borderT
        triW := 16
        triH := 16
        Gui, 2:Add, Text, x%triX% y%triY% w%triW% h%triH% gMouseCage,
        WinSet, Transparent, 1
        Gui, 2:Show, % "x" cageX " y" cageY " w" cageW " h" cageH, Region Cage

        ;;∙------∙Gui 3: Click-through border overlay + escape triangle.
        ;;∙------∙All controls added before WinSet TransColor is applied.
        Gui, 3:+AlwaysOnTop -Caption +ToolWindow +E0x20
        Gui, 3:Color, %cageColor%
        Gui, 3:Show, % "x" cageX " y" cageY " w" cageW " h" cageH, Cage Border
            boxLine(3, 0, 0, cageW, cageH, borderColor, borderColor, borderColor, borderColor, borderT)
            ;;∙------∙Escape triangle - hardcoded lines, no loop, no flicker.
            ;;∙------∙barLineAngle(GuiName, X, Y, Length, Thickness, Color, Angle, Direction)
            barLineAngle(3, cageW - borderT - 27, borderT + 0,  29, 1, escapeColor, 45, "down")
            barLineAngle(3, cageW - borderT - 23, borderT + 0,  26, 1, escapeColor, 45, "down")
            barLineAngle(3, cageW - borderT - 19, borderT + 0,  23, 1, escapeColor, 45, "down")
            barLineAngle(3, cageW - borderT - 15, borderT + 0,  20, 1, escapeColor, 45, "down")
            barLineAngle(3, cageW - borderT - 11, borderT + 0,  17, 1, escapeColor, 45, "down")
            barLineAngle(3, cageW - borderT - 7,  borderT + 0,  14, 1, escapeColor, 45, "down")
            barLineAngle(3, cageW - borderT - 3,  borderT + 0,  11, 1, escapeColor, 45, "down")
        ;;∙------∙Apply TransColor after all controls are added.
        Gui, 3:+LastFound
        WinSet, TransColor, %cageColor%

        ;;∙------∙Start the clamp loop.
        SetTimer, ClampMouse, 10

        Gui, 1:Color, Red
        GuiControl, 1:Hide, StatusText
        GuiControl, 1:Show, StatusText2
        Menu, Tray, Icon, imageres.dll, 101
    } else {
        SetTimer, ClampMouse, Off
        Gui, 2:Destroy
        Gui, 3:Destroy
        Gui, 1:Color, Lime
        GuiControl, 1:Hide, StatusText2
        GuiControl, 1:Show, StatusText
        Menu, Tray, Icon, imageres.dll, 102
    }
Return

;;∙==============================================∙
;;∙======∙CLAMP MOUSE ROUTINE∙===================∙
;;∙------∙Fires every 10ms. Reads mouse position and snaps it back
;;∙------∙inside the cage boundaries if it has escaped.
ClampMouse:
    CoordMode, Mouse, Screen
    MouseGetPos, mx, my
    nx := Max(cageX, Min(mx, cageX + cageW - 1))
    ny := Max(cageY, Min(my, cageY + cageH - 1))
    if (mx != nx || my != ny)
        MouseMove, %nx%, %ny%, 0
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
    BottomY := Y + H - Thickness
    RightX  := X + W - Thickness
    Gui, %GuiName%:Add, Progress, x%X% y%Y% w%W% h%Thickness% Background%ColorTop%
    Gui, %GuiName%:Add, Progress, x%X% y%BottomY% w%W% h%Thickness% Background%ColorBottom%
    Gui, %GuiName%:Add, Progress, x%X% y%Y% w%Thickness% h%H% Background%ColorLeft%
    Gui, %GuiName%:Add, Progress, x%RightX% y%Y% w%Thickness% h%H% Background%ColorRight%
}

;;∙==============================================∙
;;∙========∙barLineAngle Routine∙=================∙
;;∙====∙Draw diagonal bar at any angle (0-90 degrees).
;;∙------∙GuiName: Target GUI
;;∙------∙X, Y: Starting position
;;∙------∙Length: Number of pixels/segments in the diagonal
;;∙------∙Thickness: Thickness of the line (1-? pixels)
;;∙------∙Color: Color name or hex code
;;∙------∙Angle: Degrees (0=horizontal, 90=vertical)
;;∙------∙Direction: "up" (/) or "down" (\)
barLineAngle(GuiName, X, Y, Length, Thickness, Color, Angle, Direction := "down")
{
    if (Angle = 0) {
        Gui, %GuiName%:Add, Progress, x%X% y%Y% w%Length% h%Thickness% Background%Color%
        return
    }
    if (Angle = 90) {
        Gui, %GuiName%:Add, Progress, x%X% y%Y% w%Thickness% h%Length% Background%Color%
        return
    }
    Radians  := Angle * 3.141592653589793 / 180
    TanAngle := Tan(Radians)
    if (Direction = "down") {
        Loop, % Length
        {
            CurrentX := X + (A_Index - 1)
            CurrentY := Y + Round((A_Index - 1) * TanAngle)
            Gui, %GuiName%:Add, Progress, x%CurrentX% y%CurrentY% w%Thickness% h%Thickness% Background%Color%
        }
    } else if (Direction = "up") {
        Loop, % Length
        {
            CurrentX := X - (A_Index - 1)
            CurrentY := Y + Round((A_Index - 1) * TanAngle)
            Gui, %GuiName%:Add, Progress, x%CurrentX% y%CurrentY% w%Thickness% h%Thickness% Background%Color%
        }
    }
}

;;∙==============================================∙
;;∙======∙CLOSE ROUTINES∙========================∙
CloseGui:
GuiClose:
    global toggled
    if (toggled) {
        SetTimer, ClampMouse, Off
        Gui, 2:Destroy
        Gui, 3:Destroy
    }
    Gui, 1:Destroy
    ExitApp
Return

;;∙==============================================∙
;;∙======∙SCRIPT EDIT / RELOAD / EXIT∙===========∙
;;∙------∙EDIT∙---------------------------∙
Script·Edit:
    Edit
Return

;;∙------∙RELOAD∙-----------------------∙
^Home::
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Reload:
        ;;∙------∙Soundbeep, 1000, 200
    Reload
Return

;;∙------∙EXIT∙----------------------------∙
^Esc::
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:
        Soundbeep, 1000, 200
    ExitApp
Return

;;∙==============================================∙
;;∙======∙SCRIPT UPDATE∙=========================∙
UpdateCheck:
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload

;;∙==============================================∙
;;∙======∙TRAY MENU∙=============================∙
TrayMenu:
Menu, Tray, Tip, Mouse Cage
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

;;∙------∙Position Function∙------------∙
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
;;∙==============================================∙

;;∙============================================================∙
;;∙------------------------------------∙SCRIPT END∙-------------------------------------∙
;;∙============================================================∙

