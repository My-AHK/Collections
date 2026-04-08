
;;∙============================================================∙
;;∙======∙DIRECTIVES & SETTINGS∙================================∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force

SendMode, Input
SetBatchLines -1
SetWinDelay 0

OnMessage(0x0201, "WM_LBUTTONDOWNdrag")
Menu, Tray, Icon, shell32.dll, 246

SetTimer, UpdateCheck, 750
ScriptID := "BoxAndBars"
GoSub, TrayMenu


;;∙======∙GUI BUILD∙============================================∙
Gui, MyGui:New
Gui, MyGui:+AlwaysOnTop +ToolWindow
Gui, MyGui:Color, Black
Gui, MyGui:Font, s8 cWhite, Arial


;;∙======∙4-Color Box Outline Bars Example∙==============∙
;;∙------∙boxline(GuiName, X, Y, W, H, ColorTop, ColorBottom, ColorLeft, ColorRight, Thickness)

Gui, MyGui:Add, Text, x85 y10, 4-Color Box
boxline("MyGui", 15, 25, 200, 100, "Yellow", "Blue", "Lime", "Red", 4)


;;∙======∙Solid Horizontal & Vertical Bar Examples∙========∙
;;∙------∙barLine(GuiName, X, Y, W, H, Color1) 

Gui, MyGui:Add, Text, x60 y160, Colored Horizontal Bar
barLine("MyGui", 15, 175, 200, 4, "Maroon")    ;;∙------∙Horizontal bar (width=200, height=4)

Gui, MyGui:Add, Text, x250 y75, Colored`nVertical`nBar
barLine("MyGui", 240, 25, 4, 150, "Aqua")    ;;∙------∙Vertical bar (width=4, height=100)


;;∙======∙Diagonal Angle Bar Examples∙==================∙
;;∙------∙barLineAngle(GuiName, X, Y, Length, Thickness, Color, Angle, Direction)

Gui, MyGui:Add, Text, x310 y20, 45° Diagonal 'Up' (/) 
barLineAngle("MyGui", 400, 40, 50, 3, "Fuchsia", 45, "up")

Gui, MyGui:Add, Text, x310 y120, 45° Diagonal 'Down' (\)
barLineAngle("MyGui", 350, 140, 50, 3, "Fuchsia", 45, "down")


Gui, MyGui:Add, Text, x440 y20, 30° Diagonal (/) 
barLineAngle("MyGui", 500, 40, 60, 3, "White", 30, "up")

Gui, MyGui:Add, Text, x440 y120, 30° Diagonal (\) 
barLineAngle("MyGui", 450, 140, 60, 3, "White", 30, "down")


Gui, MyGui:Add, Text, x550 y20, 60° Diagonal (/) 
barLineAngle("MyGui", 600, 40, 30, 3, "Green", 60, "up")

Gui, MyGui:Add, Text, x550 y120, 60° Diagonal (\) 
barLineAngle("MyGui", 570, 140, 30, 3, "Green", 60, "down")


;;∙======∙Bar Thickness Examples∙======================∙
Gui, MyGui:Add, Text, x60 y200, Bar Thickness Examples (1-px, 2-px, 3-px, 4-px, 5-px)
barLine("MyGui", 15, 220, 610, 1, "Yellow")
barLine("MyGui", 15, 230, 610, 2, "Yellow")
barLine("MyGui", 15, 240, 610, 3, "Yellow")
barLine("MyGui", 15, 250, 610, 4, "Yellow")
barLine("MyGui", 15, 260, 610, 5, "Yellow")


;;∙======∙Combined Bars Example∙======================∙
Gui, MyGui:Add, Text, x60 y270, Bars Combined Example
barLine("MyGui", 15, 285, 610, 10, "Aqua")
barLine("MyGui", 17, 287, 606, 6, "Blue")


Gui, MyGui:Show, w640 h310, Box & Bars
Return

MyGuiGuiClose:
    ExitApp
Return


;;∙=============∙BOX & BAR ROUTINES∙===========================∙
;;∙========∙boxLine Routine∙===========================∙
;;∙====∙Draw a 4-color bordered box (hollow rectangle).
;;∙------∙GuiName: Target GUI
;;∙------∙X, Y: Top-left corner position of the box
;;∙------∙W: Width of the box (in pixels)
;;∙------∙H: Height of the box (in pixels)
;;∙------∙ColorTop: Color name or hex code for the top edge
;;∙------∙ColorBottom: Color name or hex code for the bottom edge
;;∙------∙ColorLeft: Color name or hex code for the left edge
;;∙------∙ColorRight: Color name or hex code for the right edge
;;∙------∙Thickness: Thickness of all four borders (1-? pixels)

boxline(GuiName, X, Y, W, H, ColorTop := "Black", ColorBottom := "Black", ColorLeft := "Black", ColorRight := "Black", Thickness := 1)
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


;;∙========∙barLine Routine∙===========================∙
;;∙====∙Draw a solid horizontal or vertical bar (filled rectangle).
;;∙------∙GuiName: Target GUI
;;∙------∙X, Y: Top-left corner position of the bar
;;∙------∙W: Width of the bar (in pixels) — use small value (e.g., 4) for vertical bar
;;∙------∙H: Height of the bar (in pixels) — use small value (e.g., 4) for horizontal bar
;;∙------∙Color1: Color name or hex code for the bar

barLine(GuiName, X, Y, W, H, Color1 := "Black") 
{
    Gui, %GuiName%:Add, Progress, x%X% y%Y% w%W% h%H% Background%Color1%
}


;;∙========∙barLineAngle Routine∙=======================∙
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
    ;;∙------∙Edge cases.
    if (Angle = 0) {
        ;;∙------∙Horizontal line.
        Gui, %GuiName%:Add, Progress, x%X% y%Y% w%Length% h%Thickness% Background%Color%
        return
    }
    if (Angle = 90) {
        ;;∙------∙Vertical line.
        Gui, %GuiName%:Add, Progress, x%X% y%Y% w%Thickness% h%Length% Background%Color%
        return
    }
    
    ;;∙------∙Convert angle to radians.
    Radians := Angle * 3.141592653589793 / 180
    
    ;;∙------∙Calculate Y increment per step (tangent of angle).
    TanAngle := Tan(Radians)
    
    if (Direction = "down") {
        ;;∙------∙Top-left to bottom-right: X increases, Y increases (slope = +tan(angle)).
        Loop, % Length
        {
            CurrentX := X + (A_Index - 1)
            CurrentY := Y + Round((A_Index - 1) * TanAngle)
            Gui, %GuiName%:Add, Progress, x%CurrentX% y%CurrentY% w%Thickness% h%Thickness% Background%Color%
        }
    } else if (Direction = "up") {
        ;;∙------∙Top-right to bottom-left: X decreases, Y increases (slope = -tan(angle)).
        Loop, % Length
        {
            CurrentX := X - (A_Index - 1)
            CurrentY := Y + Round((A_Index - 1) * TanAngle)
            Gui, %GuiName%:Add, Progress, x%CurrentX% y%CurrentY% w%Thickness% h%Thickness% Background%Color%
        }
    }
}


;;∙========∙GUI Drag∙=================================∙
WM_LBUTTONDOWNdrag() {    ;;∙------∙Gui Drag.
   PostMessage, 0x00A1, 2, 0
}
Return

;;∙============================================================∙

;;∙========∙Edit / Reload / Exit∙==========================∙
 ;;∙------∙EDIT∙---------------------------∙
Script·Edit:    ;;∙------∙Menu Call.
    Edit
Return

;;∙------∙RELOAD∙-----------------------∙
^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        Soundbeep, 1200, 250
    Reload
Return

 ;;∙------∙EXIT∙----------------------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        Soundbeep, 1000, 300
    ExitApp
Return


;;∙========∙Script Update∙=============================∙
UpdateCheck:    ;;∙------Check if script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload


;;∙========∙Tray Menu∙===============================∙
TrayMenu:
Menu, Tray, Tip, Box &&& Bars
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Suspend / Pause, % ScriptID    ;;∙------∙Script Header.
Menu, Tray, Icon, Suspend / Pause, shell32, 28
Menu, Tray, Default, Suspend / Pause    ;;∙------∙Makes Bold.

;;∙------∙MENU-EXTENTIONS∙---------∙
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

;;∙------∙MENU-OPTIONS∙-------------∙
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

;;∙------∙EXTENTIONS∙------------------∙
Documentation:
    Run, "C:\Program Files\AutoHotkey\AutoHotkey.chm"
Return
ShowKeyHistory:
    KeyHistory
Return
ShowWindowSpy:
    Run, "C:\Program Files\AutoHotkey\WindowSpy.ahk"
Return

;;∙------∙MENU-HEADER∙---------------∙
BoxAndBars:    ;;∙------∙Suspends hotkeys then pauses script.
    Suspend
    Soundbeep, 700, 100
    Pause
Return


;;∙========∙Tray Menu Positioning∙=====================∙
 ;;∙------∙MENU POSITION∙-----------∙
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20
Return

 ;;∙------∙POSITION FUNTION∙-------∙
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
;;∙========================∙SCRIPT END∙=========================∙
;;∙============================================================∙

