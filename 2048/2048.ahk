
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  
» Original Source:  https://rosettacode.org/wiki/2048#AutoHotkey
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
Grid := [], s := 16, w := h := s * 4.5

Gui, +AlwaysOnTop -Caption +Border
Gui, Color, Black
Gui, Font, s%s%
Gui, Add, Text, y1
Loop, 4
{
    row := A_Index
    Loop, 4
    {
        col := A_Index
        if col = 1
            Gui, Add, button, v%row%_%col% xs  y+1 w%w% h%h% -TabStop, % Grid[row,col] := 0
        else
            Gui, Add, button, v%row%_%col% x+1 yp  w%w% h%h%  -TabStop, % Grid[row,col] := 0
    }
}
Gui, Font, s12 cRed q5, Arial
Gui, Add, Text, x285 y+10 BackgroundTrans gExit, Exit
Gui, Show, x1550 y450 , 2048
;;∙-----------------------∙

Start:
for row, obj in Grid
    for col, val in obj
        Grid[row,col] := 0
    
Grid[1,1]:=2
ShowGrid()
Return

;;∙-----------------------∙
GuiClose:
    ExitApp
Return

;;∙-----------------------∙
#IfWinActive, 2048
;;∙-----------------------∙
up::
move := false
Loop, 4
{
    col := A_Index
    Loop, 3
    {
        row := A_Index
        if Grid[row, col] && (Grid[row, col] = Grid[row+1, col])
            Grid[row, col] *=2    , Grid[row+1, col] := 0, move := true
    }
}

Loop, 4
{
    row := A_Index
    Loop, 4
    {
        col := A_Index
        Loop, 4
            if !Grid[row, col]
                Loop, 3
                    if !Grid[row, col] && Grid[row+A_Index, col]
                    {
                        Grid[row, col] := Grid[row+A_Index, col]    , Grid[row+A_Index, col] := 0, move := true
                        if (Grid[row, col] = Grid[row-1, col])
                            Grid[row-1, col] *=2    , Grid[row, col] := 0, move := true
                    }
    }
}
GoSub, AddNew
Return

;;∙-----------------------∙
Down::
move := false
Loop, 4
{
    col := A_Index
    Loop, 3
    {
        row := 5-A_Index
        if Grid[row, col] && (Grid[row, col] = Grid[row-1, col])
            Grid[row, col] *=2    , Grid[row-1, col] := 0, move := true
    }
}

Loop, 4
{
    row := 5-A_Index
    Loop, 4
    {
        col := A_Index
        Loop, 4
            if !Grid[row, col]
                Loop, 3
                    if !Grid[row, col] && Grid[row-A_Index, col]
                    {
                        Grid[row, col] := Grid[row-A_Index, col]    , Grid[row-A_Index, col] := 0, move := true
                        if (Grid[row, col] = Grid[row+1, col])
                            Grid[row+1, col] *=2    , Grid[row, col] := 0, move := true
                    }
    }
}
GoSub, AddNew
Return

;;∙-----------------------∙
Left::
move := false
Loop, 4
{
    row := A_Index
    Loop, 3
    {
        col := A_Index
        if Grid[row, col] && (Grid[row, col] = Grid[row, col+1])
            Grid[row, col] *=2    , Grid[row, col+1] := 0, move := true
    }
}

Loop, 4
{
    col := A_Index
    Loop, 4
    {
        row := A_Index
        Loop, 4
            if !Grid[row, col]
                Loop, 3
                    if !Grid[row, col] && Grid[row, col+A_Index]
                    {
                        Grid[row, col] := Grid[row, col+A_Index]    , Grid[row, col+A_Index] := 0, move := true
                        if (Grid[row, col] = Grid[row, col-1])
                            Grid[row, col-1] *=2    , Grid[row, col] := 0, move := true
                    }

    }
}
GoSub, AddNew
Return

;;∙-----------------------∙
Right::
move := false
Loop, 4
{
    row := A_Index
    Loop, 3
    {
        col := 5-A_Index
        if Grid[row, col] && (Grid[row, col] = Grid[row, col-1])
            Grid[row, col] *=2    , Grid[row, col-1] := 0, move := true
    }
}

Loop, 4
{
    col := 5-A_Index
    Loop, 4
    {
        row := A_Index
        Loop, 4
            if !Grid[row, col]
                Loop, 3
                    if !Grid[row, col] && Grid[row, col-A_Index]
                    {
                        Grid[row, col] := Grid[row, col-A_Index]    , Grid[row, col-A_Index] := 0, move := true
                        if (Grid[row, col] = Grid[row, col+1])
                            Grid[row, col+1] *=2    , Grid[row, col] := 0, move := true
                    }
    }
}
GoSub, AddNew
Return

;;∙-----------------------∙
#IfWinActive
;;∙-----------------------∙
AddNew:
if EndOfGame()
{
    MsgBox Done `nPress OK to retry
    GoTo Start
}
Return

;;∙-----------------------∙
EndOfGame(){
    global
    if Move
        AddRandom()
    ShowGrid()
    for row, obj in Grid
        for col, val in obj
            if !grid[row,col]
                return 0
                for row, obj in Grid
        for col, val in obj
            if (grid[row,col] = grid[row+1,col]) || (grid[row,col] = grid[row-1,col]) || (grid[row,col] = grid[row,col+1]) || (grid[row,col] = grid[row,col-1])
                return 0
    return 1
}

;;∙-----------------------∙
ShowGrid(){
    global Grid
    for row, obj in Grid
        for col, val in obj
        {
            GuiControl,, %row%_%col%, %val%
            if val
                GuiControl, Show, %row%_%col%
            else
                GuiControl, Hide, %row%_%col%
        }
}

;;∙-----------------------∙
AddRandom(){
    global Grid
    ShowGrid()
    Sleep, 200
    for row, obj in Grid
        for col, val in obj
            if !grid[row,col]
                list .= (list?"`n":"") row "," col
    Sort, list, random
    Rnd := StrSplit(list, "`n").1
    Grid[StrSplit(rnd, ",").1, StrSplit(rnd, ",").2] := 2
}
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
    Exit:
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

