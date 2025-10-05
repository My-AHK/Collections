
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
» Snaps the active window to a position within a user-defined grid.
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
;;∙===========∙DIRECIVES & SETTINGS∙==============∙
#MaxThreadsPerHotkey 2
#NoEnv
#Persistent
#SingleInstance, Force
#WinActivateForce
SendMode, Input
SetBatchLines -1
SetTitleMatchMode 2
SetWinDelay 0

;;∙======∙GLOBAL VARIABLES∙===∙RETAIN SIZE MODE∙================∙
global g_RetainSizeMode := false
global g_RetainedWidth := 0
global g_RetainedHeight := 0

/*∙======∙🔥∙HOTKEYS∙🔥∙===∙QUICK REFERENCE GUIDE∙==============∙
Use  'SnapActiveWindowGridSpan'  for ALL positioning:
   Single-cell: SnapActiveWindowGridSpan(rows, cols, targetRow, targetCol, 1, 1)
   Multi-cell:  SnapActiveWindowGridSpan(rows, cols, startRow, startCol, rowSpan, colSpan)

Examples:
   - Left half: SnapActiveWindowGridSpan(1, 2, 1, 1, 1, 1)
   - Right half: SnapActiveWindowGridSpan(1, 2, 1, 2, 1, 1)  
   - Top left quarter: SnapActiveWindowGridSpan(2, 2, 1, 1, 1, 1)
   - Center area: SnapActiveWindowGridSpan(3, 3, 2, 2, 1, 1)
   - Left two-thirds: SnapActiveWindowGridSpan(1, 3, 1, 1, 1, 2)
   - Bottom two-thirds: SnapActiveWindowGridSpan(3, 1, 2, 1, 2, 1)
   - Center 2x2 area: SnapActiveWindowGridSpan(4, 4, 2, 2, 2, 2)

Retain Size Mode:
   - Press Ctrl+F1 to toggle Retain Size Mode ON/OFF
   - When ON: All positioning hotkeys will maintain the current window size
   - When OFF: Normal behavior (window resizes to fit grid position)
   - Visual feedback: Tooltip shows current mode and retained dimensions
   - Useful for keeping custom window sizes while repositioning

Workflow:
   1. Size a window to your preferred dimensions
   2. Press Ctrl+F1 (tooltip confirms "Retain Size Mode: ON")
   3. Use any positioning hotkey - window moves but keeps its size
   4. Press Ctrl+F1 again to return to normal resizing behavior
∙----------------------------------------------------------------------∙
*/

;;∙======∙HOTKEY∙===∙TOGGLE RETAIN SIZE MODE∙=============∙
^F1::
    g_RetainSizeMode := !g_RetainSizeMode
    if (g_RetainSizeMode) {
        WinGetPos,,, currentWidth, currentHeight, A
        g_RetainedWidth := currentWidth
        g_RetainedHeight := currentHeight
        ToolTip, Retain Size Mode: ON - Width: %g_RetainedWidth% Height: %g_RetainedHeight%
    } else {
        ToolTip, Retain Size Mode: OFF
    }
    SetTimer, RemoveToolTip, 2000
Return

RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
Return

;;∙===========∙(Win + Alt + ARROW)∙================∙
;;∙------∙Single cell positioning (using SnapActiveWindowGridSpan).
#!Up::SnapActiveWindowGridSpan(2, 1, 1, 1, 1, 1) 		;;∙------∙Top half
#!Down::SnapActiveWindowGridSpan(2, 1, 2, 1, 1, 1) 	;;∙------∙Bottom half

;;∙===========∙(Ctrl + Win + Alt + ARROW)∙===========∙
^#!Up::SnapActiveWindowGridSpan(3, 1, 1, 1, 1, 1) 		;;∙------∙Top third
^#!Down::SnapActiveWindowGridSpan(3, 1, 3, 1, 1, 1) 	;;∙------∙Bottom third

;;∙===========∙(Win + Alt + Numpad)∙================∙
;;∙------∙Mixed usage - some single cell & some spanning.
#!Numpad4::SnapActiveWindowGridSpan(1, 4, 1, 1, 1, 1)    ;;∙------∙Left fourth (single cell)
#!Numpad5::SnapActiveWindowGridSpan(1, 4, 1, 2, 1, 2)    ;;∙------∙Center half (spanning)
#!Numpad6::SnapActiveWindowGridSpan(1, 4, 1, 4, 1, 1)    ;;∙------∙Right fourth (single cell)

;;∙===========∙(Ctrl + Win + Numpad)∙===============∙
^#Numpad8::SnapActiveWindowGridSpan(3, 1, 1, 1, 1, 1)    ;;∙------∙Upper third
^#Numpad5::SnapActiveWindowGridSpan(3, 1, 2, 1, 1, 1)    ;;∙------∙Middle third  
^#Numpad2::SnapActiveWindowGridSpan(3, 1, 3, 1, 1, 1)    ;;∙------∙Bottom third

;;∙===========∙(Ctrl + Numpad)∙=====================∙
;;∙------∙Spanning examples for more complex layouts.
^Numpad1::SnapActiveWindowGridSpan(2, 3, 1, 1, 1, 2)    ;;∙------∙Top two-thirds width
^Numpad2::SnapActiveWindowGridSpan(2, 3, 1, 2, 1, 2)    ;;∙------∙Top two-thirds width (right side)
^Numpad3::SnapActiveWindowGridSpan(2, 3, 2, 1, 1, 2)    ;;∙------∙Bottom two-thirds width
^Numpad4::SnapActiveWindowGridSpan(2, 3, 2, 2, 1, 2)    ;;∙------∙Bottom two-thirds width (right side)
^Numpad5::SnapActiveWindowGridSpan(3, 3, 1, 1, 2, 2)    ;;∙------∙Large top-left quadrant (2x2)
    ;;∙------∙High-density grid examples.
^Numpad6::SnapActiveWindowGridSpan(5, 7, 2, 1, 2, 3) 	;;∙------∙5×7 grid: rows 2-3, cols 1-3
^Numpad7::SnapActiveWindowGridSpan(10, 10, 1, 1, 1, 5) 	;;∙------∙10×10 grid: top half-width thin strip
^Numpad8::SnapActiveWindowGridSpan(8, 12, 3, 4, 3, 4) 	;;∙------∙8×12 grid: perfect center area
^Numpad9::SnapActiveWindowGridSpan(6, 6, 1, 1, 2, 1) 	;;∙------∙6×6 grid: left sidebar (1/6 width, 1/3 height)

;;∙===========∙(Ctrl + Win + Alt + Numpad)∙===========∙
;;∙------∙Single cell positioning in 3x3 grid.
^#!Numpad7::SnapActiveWindowGridSpan(3, 3, 1, 1, 1, 1)    ;;∙------∙Top left
^#!Numpad8::SnapActiveWindowGridSpan(3, 3, 1, 2, 1, 1)    ;;∙------∙Top middle
^#!Numpad9::SnapActiveWindowGridSpan(3, 3, 1, 3, 1, 1)    ;;∙------∙Top right

^#!Numpad4::SnapActiveWindowGridSpan(3, 3, 2, 1, 1, 1)    ;;∙------∙Center left
^#!Numpad5::SnapActiveWindowGridSpan(3, 3, 2, 2, 1, 1)    ;;∙------∙Center
^#!Numpad6::SnapActiveWindowGridSpan(3, 3, 2, 3, 1, 1)    ;;∙------∙Center right

^#!Numpad1::SnapActiveWindowGridSpan(3, 3, 3, 1, 1, 1)    ;;∙------∙Bottom left
^#!Numpad2::SnapActiveWindowGridSpan(3, 3, 3, 2, 1, 1)    ;;∙------∙Bottom middle
^#!Numpad3::SnapActiveWindowGridSpan(3, 3, 3, 3, 1, 1)    ;;∙------∙Bottom right


;;∙======∙FUNCTION∙===∙SnapActiveWindowGridSpan∙==============∙
SnapActiveWindowGridSpan(numRows, numCols, row, col, rowSpan := 1, colSpan := 1) {
    WinGet activeWin, ID, A
    activeMon := GetMonitorIndexFromWindow(activeWin)
    SysGet, MonitorWorkArea, MonitorWorkArea, %activeMon%

    ;;∙------∙Determine width & height of a grid cell.
    height := (MonitorWorkAreaBottom - MonitorWorkAreaTop)/numRows
    width := (MonitorWorkAreaRight - MonitorWorkAreaLeft)/numCols

    ;;∙------∙Determine X & Y offsets.
    posX  := MonitorWorkAreaLeft + (col - 1) * width
    posY  := MonitorWorkAreaTop + (row - 1) * height

    ;;∙------∙Apply rowSpan/colSpan after determining offsets.
    width *= colSpan
    height *= rowSpan

    ;;∙------∙Use WinGetPosEx to determine position/size offsets (to remove gaps around windows).
    WinGetPosEx(activeWin, X, Y, realWidth, realHeight, offsetX, offsetY)

    ;;∙------∙Move & resize active window.
    if (g_RetainSizeMode) {
        ;;∙------∙Keep retained size but move to calculated position
        WinMove, A,, (posX + offsetX), (posY + offsetY), g_RetainedWidth, g_RetainedHeight
    } else {
        ;;∙------∙Use calculated size and position
        WinMove, A,, (posX + offsetX), (posY + offsetY), (width + offsetX * -2), (height + (offsetY - 2) * -2)
    }
}

;;∙======∙FUNCTION∙===∙GetMonitorIndexFromWindow∙============∙
GetMonitorIndexFromWindow(windowHandle) {
    ;;∙------∙Starts with 1.
    monitorIndex := 1

    VarSetCapacity(monitorInfo, 40)
    NumPut(40, monitorInfo)

    if (monitorHandle := DllCall("MonitorFromWindow", "uint", windowHandle, "uint", 0x2))
        && DllCall("GetMonitorInfo", "uint", monitorHandle, "uint", &monitorInfo) {
        monitorLeft   := NumGet(monitorInfo,  4, "Int")
        monitorTop    := NumGet(monitorInfo,  8, "Int")
        monitorRight  := NumGet(monitorInfo, 12, "Int")
        monitorBottom := NumGet(monitorInfo, 16, "Int")
        workLeft      := NumGet(monitorInfo, 20, "Int")
        workTop       := NumGet(monitorInfo, 24, "Int")
        workRight     := NumGet(monitorInfo, 28, "Int")
        workBottom    := NumGet(monitorInfo, 32, "Int")
        isPrimary     := NumGet(monitorInfo, 36, "Int") & 1

        SysGet, monitorCount, MonitorCount

        Loop, %monitorCount% {
            SysGet, tempMon, Monitor, %A_Index%

            ;;∙------∙Compare location to determine monitor index.
            if ((monitorLeft = tempMonLeft) and (monitorTop = tempMonTop)
                and (monitorRight = tempMonRight) and (monitorBottom = tempMonBottom)) {
                monitorIndex := A_Index
                break
            }
        }
    }
    return %monitorIndex%
}


;;∙======∙FUNCTION∙===∙WinGetPosEx∙===========================∙
WinGetPosEx(hWindow,ByRef X="",ByRef Y="",ByRef Width="",ByRef Height="",ByRef Offset_X="",ByRef Offset_Y="") {
    Static Dummy5693
          ,RECTPlus
          ,S_OK:=0x0
          ,DWMWA_EXTENDED_FRAME_BOUNDS:=9

    ;;∙------∙Workaround for AutoHotkey Basic.
    PtrType:=(A_PtrSize=8) ? "Ptr":"UInt"

    ;;∙------∙Get window's dimensions.
    ;;∙------∙Note: Only first 16 bytes of the RECTPlus structure are used by DwmGetWindowAttribute & GetWindowRect functions.
    VarSetCapacity(RECTPlus,24,0)
    DWMRC:=DllCall("dwmapi\DwmGetWindowAttribute"
        ,PtrType,hWindow    				;;∙------∙hwnd
        ,"UInt",DWMWA_EXTENDED_FRAME_BOUNDS    	;;∙------∙dwAttribute
        ,PtrType,&RECTPlus    				;;∙------∙pvAttribute
        ,"UInt",16)    					;;∙------∙cbAttribute

    if (DWMRC<>S_OK)
        {
        if ErrorLevel in -3,-4    ;;∙------∙Dll or function not found (older than Vista).
            {
            ;;∙------∙Do nothing else.
            }
         else
            outputdebug,
               (ltrim join`s
                Function: %A_ThisFunc% -
                Unknown error calling "dwmapi\DwmGetWindowAttribute".
                RC=%DWMRC%,
                ErrorLevel=%ErrorLevel%,
                A_LastError=%A_LastError%.
                "GetWindowRect" used instead.
               )

        ;;∙------∙Collect position & size from "GetWindowRect".
        DllCall("GetWindowRect",PtrType,hWindow,PtrType,&RECTPlus)
        }

    ;;∙------∙Populate output variables.
    X:=Left :=NumGet(RECTPlus,0,"Int")
    Y:=Top  :=NumGet(RECTPlus,4,"Int")
    Right   :=NumGet(RECTPlus,8,"Int")
    Bottom  :=NumGet(RECTPlus,12,"Int")
    Width   :=Right-Left
    Height  :=Bottom-Top
    OffSet_X:=0
    OffSet_Y:=0

    ;;∙------∙If DWM is not used (older than Vista or DWM not enabled), we're done.
    if (DWMRC<>S_OK)
        Return &RECTPlus

    ;;∙------∙Collect dimensions via GetWindowRect.
    VarSetCapacity(RECT,16,0)
    DllCall("GetWindowRect",PtrType,hWindow,PtrType,&RECT)
    GWR_Width :=NumGet(RECT,8,"Int")-NumGet(RECT,0,"Int")
        ;;∙------∙Right minus Left.
    GWR_Height:=NumGet(RECT,12,"Int")-NumGet(RECT,4,"Int")
        ;;∙------∙Bottom minus Top.

    ;;∙------∙Calculate offsets & update output variables.
    NumPut(Offset_X:=(Width-GWR_Width)//2,RECTPlus,16,"Int")
    NumPut(Offset_Y:=(Height-GWR_Height)//2,RECTPlus,20,"Int")
    Return &RECTPlus
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

