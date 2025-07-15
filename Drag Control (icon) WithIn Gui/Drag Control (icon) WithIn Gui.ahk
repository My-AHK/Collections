
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




;;∙============================================================∙
;;∙============================================================∙
Gui, +AlwaysOnTop -Caption +0x400000    ;;∙------∙Create a borderless, topmost window with thick frame style (WS_THICKFRAME).
Gui, Color, 000080                      ;;∙------∙Set the GUI background color to navy blue.

Gui, Add, Text, x0 y75 w250 cYellow Center BackgroundTrans, Drag Icons Anywhere       ;;∙------∙Add centered yellow instructional text at y=75.
Gui, Add, Text, x0 y175 w250 cYellow Center BackgroundTrans, Inside The Gui Borders   ;;∙------∙Add second instructional text near the bottom.

Gui, Add, Picture, x109 y95 w32 h32 BackgroundTrans vimageButton1 gImageClick1 Icon160, Shell32.dll   ;;∙------∙Add first draggable icon (Shell icon index 160).
Gui, Add, Picture, x109 y135 w32 h32 BackgroundTrans vimageButton2 gImageClick2 Icon160, Shell32.dll  ;;∙------∙Add second draggable icon below the first.

global guiW := 250    ;;∙------∙Store GUI width in a global variable.
global guiH := 250    ;;∙------∙Store GUI height in a global variable.
Gui, Show, w%guiW% h%guiH%    ;;∙------∙Show the GUI window with specified dimensions.

Return    ;;∙------∙End of auto-execute section.

ImageClick1:    ;;∙------∙Label for the first image's click event.
    DragControl(A_GuiControl)    ;;∙------∙Call DragControl with the clicked control's name.
Return

ImageClick2:    ;;∙------∙Label for the second image's click event.
    DragControl(A_GuiControl)    ;;∙------∙Call DragControl with the clicked control's name.
Return


;;∙------∙@struct: hold the UInt to write.
;;∙------∙value: value to write.
;;∙------∙offset: offset of the UInt from the start of the struct, in UInt size units.
SetUInt(ByRef @struct, _value, _offset=0)
{
    local addr
    addr := &@struct + _offset * 4    ;;∙------∙Calculate the byte offset into the structure.
    DllCall("RtlFillMemory", "UInt", addr,     "UInt", 1, "UChar", (_value & 0x000000FF))        ;;∙------∙Write byte 0.
    DllCall("RtlFillMemory", "UInt", addr + 1, "UInt", 1, "UChar", (_value & 0x0000FF00) >> 8)   ;;∙------∙Write byte 1.
    DllCall("RtlFillMemory", "UInt", addr + 2, "UInt", 1, "UChar", (_value & 0x00FF0000) >> 16)  ;;∙------∙Write byte 2.
    DllCall("RtlFillMemory", "UInt", addr + 3, "UInt", 1, "UChar", (_value & 0xFF000000) >> 24)  ;;∙------∙Write byte 3.
}


;;∙------∙@struct: hold the UInt to extract.
;;∙------∙_offset: offset of the UInt from the start of the struct, in UInt size units.
GetUInt(ByRef @struct, _offset=0)
{
    local addr
    addr := &@struct + _offset * 4    ;;∙------∙Calculate the byte offset into the structure.
    Return *addr + (*(addr + 1) << 8) +  (*(addr + 2) << 16) + (*(addr + 3) << 24)    ;;∙------∙Reconstruct 32-bit UInt from 4 bytes.
}


;;∙--------------------------------------------------------------------∙
DragControl(_controlName)    ;;∙------∙Makes a control draggable within GUI boundaries.
{
    local hWnd, point
    local initScrX, initScrY       ;;∙------∙Initial mouse position (screen coordinates).
    local initWinX, initWinY       ;;∙------∙Initial mouse position (relative to GUI window).
    local initCliX, initCliY       ;;∙------∙Initial mouse position (client area coordinates).
    local offsetX, offsetY         ;;∙------∙Offset between mouse and control's top-left corner.
    local mouseState, mouseX, mouseY
    local controlPos, controlPosX, controlPosY, controlPosW, controlPosH

    CoordMode Mouse, Screen
    MouseGetPos initScrX, initScrY, hWnd    ;;∙------∙Get screen coordinates and window handle.

    CoordMode Mouse, Relative
    MouseGetPos initWinX, initWinY          ;;∙------∙Get relative position within the active window.

    VarSetCapacity(point, 8)                ;;∙------∙Create 8-byte structure for POINT.
    SetUInt(point, initScrX)                ;;∙------∙Store screen X coordinate.
    SetUInt(point, initScrY, 1)             ;;∙------∙Store screen Y coordinate.
    DllCall("ScreenToClient", "UInt", hWnd, "UInt", &point)    ;;∙------∙Convert screen to client coordinates.
    initCliX := GetUInt(point)
    initCliY := GetUInt(point, 1)

    GuiControlGet controlPos, Pos, %_controlName%    ;;∙------∙Get current position of the control.
    mouseX := controlPosX
    mouseY := controlPosY

    offsetX :=  initCliX - controlPosX    ;;∙------∙Mouse offset from control’s left edge.
    offsetY :=  initCliY - controlPosY    ;;∙------∙Mouse offset from control’s top edge.

    offsetX += initWinX - initCliX       ;;∙------∙Adjust for coordinate mode differences.
    offsetY += initWinY - initCliY

    Loop
    {
        GetKeyState mouseState, LButton    ;;∙------∙Monitor mouse button state.
        If (mouseState = "u")
            Break                          ;;∙------∙Stop when left button is released.

        MouseGetPos mouseX, mouseY         ;;∙------∙Get current mouse position.

        mouseX -= offsetX                  ;;∙------∙Compute new control X.
        mouseY -= offsetY                  ;;∙------∙Compute new control Y.

        GuiControlGet controlPos, Pos, %_controlName%    ;;∙------∙Get current control size.

        if (mouseX < 0)                    ;;∙------∙Clamp X to left boundary.
            mouseX := 0
        else if (mouseX > guiW - controlPosW)    ;;∙------∙Clamp X to right boundary.
            mouseX := guiW - controlPosW
        if (mouseY < 0)                    ;;∙------∙Clamp Y to top boundary.
            mouseY := 0
        else if (mouseY > guiH - controlPosH)    ;;∙------∙Clamp Y to bottom boundary.
            mouseY := guiH - controlPosH

        GuiControl MoveDraw, %_controlName%, x%mouseX% y%mouseY%    ;;∙------∙Redraw control at new position.
        Sleep 10    ;;∙------∙Delay to reduce CPU usage/flicker.
    }
    GuiControl Move, %_controlName%, x%mouseX% y%mouseY%    ;;∙------∙Final placement after drag.
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
; OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.
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

