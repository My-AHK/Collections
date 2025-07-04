﻿
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
» "SUPREME" advanced Drag & Drop script.
    ▹ CUSTOMIZABLE GUI WITH ADVANCED GRAPHICS
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
;;∙============∙SETTINGS∙========================∙
DroppedTo := "C:\DropDestination"    ;;∙------∙Set target path folder.

dropBox := 35    ;;∙------∙Set GUI square dimensions.
dropBoxColor := "010101"    ;;∙------∙Gui color (standard AHK RGB format).
dropBoxX := 1750, dropBoxY := 800    ;;∙------∙Gui positioning.

lineLength := 15    ;;∙------∙Define length of lines (from corner to center).
lineLengthColor := 0xFF0000    ;;∙------∙Set in RGB format (0xRRGGBB)
lineLengthThickness := 1

;;∙============∙GUI BUILD∙========================∙
Gui, +AlwaysOnTop -Caption +LastFound +Owner
Gui, Color, %dropBoxColor%
Gui, Show, w%dropBox% h%dropBox% x%dropBoxX% y%dropBoxY%

hWnd := WinExist()
OnMessage(0x0F, "WM_PAINT")    ;;∙------∙WM_PAINT = 0x0F
DllCall("InvalidateRect", "Ptr", hWnd, "Ptr", 0, "Int", true)

IfNotExist, %DroppedTo%
    FileCreateDir, %DroppedTo%
Return

;;∙============∙GUI EVENTS∙=======================∙
GuiContextMenu:    ;;∙------∙Handle right-click to close script.
ExitApp

GuiDropFiles:
    FileList := A_GuiEvent
    X := A_GuiX
    Y := A_GuiY
    moved_files := 0

    IfNotExist, %DroppedTo%
        FileCreateDir, %DroppedTo%

    Loop, Parse, FileList, `n
    {
        Source := A_LoopField
        SplitPath, Source, FileName
        IfNotExist, %Source%
            continue
        Destination := DroppedTo . "\" . FileName
        FileMove, %Source%, %Destination%, 1
        if !ErrorLevel
            moved_files++
    }

MsgBox,,, Successfully moved %moved_files% file(s) to:`n%DroppedTo%,3
Return


;;∙============∙CUSTOM DRAWING∙==(diagonal lines)====∙
WM_PAINT(wParam, lParam, msg, hWnd) {
    global dropBox, lineLength, lineLengthColor, lineLengthThickness

    ;;∙------------∙CONVERT RGB to BGR∙----------------------∙
    color := lineLengthColor
    BGR := ((color & 0xFF) << 16) | (color & 0x00FF00) | ((color >> 16) & 0xFF)

    ;;∙------------∙DRAWING OPERATIONS∙-------------------∙
    VarSetCapacity(ps, 16, 0)
    hdc := DllCall("BeginPaint", "Ptr", hWnd, "Ptr", &ps, "Ptr")
    ColorPen := DllCall("CreatePen", "Int", 0, "Int", lineLengthThickness, "UInt", BGR, "Ptr")
    OldPen := DllCall("SelectObject", "Ptr", hdc, "Ptr", ColorPen)

    ;;∙------------∙TOP-LEFT TOWARD BOTTOM-RIGHT∙----∙
    DllCall("MoveToEx", "Ptr", hdc, "Int", 0, "Int", 0, "Ptr", 0)
    DllCall("LineTo",   "Ptr", hdc, "Int", lineLength, "Int", lineLength)

    ;;∙------------∙TOP-RIGHT TOWARD BOTTOM-LEFT∙----∙
    DllCall("MoveToEx", "Ptr", hdc, "Int", dropBox - 1, "Int", 0, "Ptr", 0)
    DllCall("LineTo",   "Ptr", hdc, "Int", dropBox - 1 - lineLength, "Int", lineLength)

    ;;∙------------∙BOTTOM-LEFT TOWARD TOP-RIGHT∙----∙
    DllCall("MoveToEx", "Ptr", hdc, "Int", 0, "Int", dropBox - 1, "Ptr", 0)
    DllCall("LineTo",   "Ptr", hdc, "Int", lineLength, "Int", dropBox - 1 - lineLength)

    ;;∙------------∙BOTTOM-RIGHT TOWARD TOP-LEFT∙----∙
    DllCall("MoveToEx", "Ptr", hdc, "Int", dropBox - 1, "Int", dropBox - 1, "Ptr", 0)
    DllCall("LineTo",   "Ptr", hdc, "Int", dropBox - 1 - lineLength, "Int", dropBox - 1 - lineLength)

    ;;∙------------∙CLEANUP∙--------------------------------------∙
    DllCall("SelectObject", "Ptr", hdc, "Ptr", OldPen)
    DllCall("DeleteObject", "Ptr", ColorPen)
    DllCall("EndPaint", "Ptr", hWnd, "Ptr", &ps)
    return
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

