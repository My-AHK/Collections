
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙--------∙Origins∙-------------------------∙
» Author:  just me
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?p=26252#p26252
» ALT SOURCE:  https://www.autohotkey.com/boards/viewtopic.php?f=76&t=133645#p587150
» Multiple Display Monitors Functions -> msdn.microsoft.com/en-us/library/dd145072(v=vs.85).aspx
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "MultiMonitor_Manager"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
/*    🔥∙HOTKEYS∙🔥
∙--------------------------------------------------------------------∙
Ctrl+Alt+Numpad1	;;∙------∙Monitor of active window.
    Ctrl+Alt+1
∙--------------------------------------------------------------------∙
Ctrl+Alt+Numpad2	;;∙------∙Detects monitor under current mouse cursor.
    Ctrl+Alt+2
∙--------------------------------------------------------------------∙
Ctrl+Alt+Numpad3	;;∙------∙Detects monitor with largest intersection with a custom rectangle.
    Ctrl+Alt+3
∙--------------------------------------------------------------------∙
Ctrl+Alt+Numpad4	;;∙------∙ENHANCED: Monitor of active window with Resolution & DPI.
    Ctrl+Alt+4
∙--------------------------------------------------------------------∙
Ctrl+Alt+Numpad5	;;∙------∙ENHANCED: Detects monitor under current mouse cursor with Resolution & DPI.
    Ctrl+Alt+5
∙--------------------------------------------------------------------∙
Ctrl+Alt+Numpad6	;;∙------∙ENHANCED: Detects monitor with largest intersection with a custom rectangle.
    Ctrl+Alt+6
∙--------------------------------------------------------------------∙
Ctrl+Alt+Numpad7	;;∙------∙Move active window to the opposite monitor.
    Ctrl+Alt+7
∙--------------------------------------------------------------------∙
Ctrl+Alt+Numpad8	;;∙------∙Shows monitor information with Primary monitor listed first.
    Ctrl+Alt+8
∙--------------------------------------------------------------------∙
*/

;;∙============================================================∙
;;∙-----------------∙HOTKEYS∙------------------------------------------------------------∙
;;∙============================================================∙

Monitors := MDMF_Enum()    ;;∙------∙Retrieves All relevant monitor information. **
;;∙------∙🔥∙--------------------------------------------------------------------------------∙
^!Numpad1::    ;;∙------∙Monitor of active window.
^!1::
ActiveWindow := WinExist("A")    ;;∙------∙Determines hwnd of active window.
ActiveMonitor := Monitors[MDMF_FromHWND(ActiveWindow)]    ;;∙------∙Retrieves display monitor that has largest area of intersection with this window.
MsgBox,,,% ActiveMonitor.Num "`n" ActiveMonitor.Name, 5    ;;∙------∙Shows active monitor's Number & Name.
Return

;;∙------∙🔥∙--------------------------------------------------------------------------------∙
^!Numpad2::    ;;∙------∙Detects monitor under current mouse cursor.
^!2::
ActiveMonitor := Monitors[MDMF_FromPoint()]    ;;∙------∙Retrieves the monitor containing the cursor.
MsgBox,,,% "Monitor with Mouse Cursor: `n" ActiveMonitor.Num "`n" ActiveMonitor.Name, 5    ;;∙------∙Shows monitor number & name.
Return

;;∙------∙🔥∙--------------------------------------------------------------------------------∙
^!Numpad3::    ;;∙------∙Detects monitor with largest intersection with a custom rectangle.
^!3::
InputBox, X, Enter X Coordinate, Please enter the X coordinate., , 200, 120
InputBox, Y, Enter Y Coordinate, Please enter the Y coordinate., , 200, 120
InputBox, W, Enter Width, Please enter the width of the rectangle., , 200, 120
InputBox, H, Enter Height, Please enter the height of the rectangle., , 200, 120
ActiveMonitor := Monitors[MDMF_FromRect(X, Y, W, H)]    ;;∙------∙Retrieves monitor that intersects most with custom rectangle.
MsgBox,,,% "Monitor for Custom Rectangle: `n" ActiveMonitor.Num "`n" ActiveMonitor.Name, 5    ;;∙------∙Shows monitor number & name.
Return

;;∙------∙🔥∙--------------------------------------------------------------------------------∙
^!Numpad4::    ;;∙------∙ENHANCED: Monitor of active window with Resolution & DPI.
^!4::
ActiveWindow := WinExist("A")    ;;∙------∙Determines hwnd of active window.
If !ActiveWindow {
    MsgBox,,, Error, Active window not found., 7
    Return
}
ActiveMonitor := Monitors[MDMF_FromHWND(ActiveWindow)]    ;;∙------∙Retrieves display monitor.
If !ActiveMonitor {
    MsgBox,,, Error, No monitor found for the active window., 7
    Return
}
DisplayMonitorInfo(ActiveMonitor, "Monitor of Active Window")
Return

;;∙------∙🔥∙--------------------------------------------------------------------------------∙
^!Numpad5::    ;;∙------∙ENHANCED: Detects monitor under current mouse cursor with Resolution & DPI.
^!5::
ActiveMonitor := Monitors[MDMF_FromPoint()]    ;;∙------∙Retrieves the monitor containing the cursor.
If !ActiveMonitor {
    MsgBox,,, Error, No monitor found under the mouse cursor., 7
    Return
}
DisplayMonitorInfo(ActiveMonitor, "Monitor with Mouse Cursor")
Return

;;∙------∙🔥∙--------------------------------------------------------------------------------∙
^!Numpad6::    ;;∙------∙ENHANCED: Detects monitor with largest intersection with a custom rectangle.
^!6::
InputBox, X, Enter X Coordinate, Please enter the X coordinate., , 200, 120
InputBox, Y, Enter Y Coordinate, Please enter the Y coordinate., , 200, 120
InputBox, W, Enter Width, Please enter the width of the rectangle., , 200, 120
InputBox, H, Enter Height, Please enter the height of the rectangle., , 200, 120
ActiveMonitor := Monitors[MDMF_FromRect(X, Y, W, H)]    ;;∙------∙Retrieves monitor that intersects most with the custom rectangle.
If !ActiveMonitor {
    MsgBox,,, Error, No monitor found for the custom rectangle., 7
    Return
}
DisplayMonitorInfo(ActiveMonitor, "Monitor for Custom Rectangle")
Return

;;∙------∙🔥∙--------------------------------------------------------------------------------∙
^!Numpad7::    ;;∙------∙Move active window to the opposite monitor
^!7::
Soundbeep, 1200, 200
ActiveWindow := WinExist("A")    ;;∙------∙Determine the hwnd of the active window
If !ActiveWindow {
    MsgBox,,, Error, Active window not found., 7
    Return
}
ActiveMonitor := Monitors[MDMF_FromHWND(ActiveWindow)]    ;;∙------∙Find the active window's monitor
If !ActiveMonitor {
    MsgBox,,, Error, No monitor found for the active window., 7
    return
}
;;∙------∙Get the list of monitors, sorted to ensure the primary is first
SortedMonitors := []
For HMON, M In Monitors {
    If M.Primary
        SortedMonitors.InsertAt(1, {HMON: HMON, M: M})   ;;∙------∙Insert primary monitor at the beginning
    Else
        SortedMonitors.Push({HMON: HMON, M: M})
}
;;∙------∙Find the current monitor's index
CurrentMonitorIndex := 0
For Index, Monitor In SortedMonitors {
    If (Monitor["HMON"] = ActiveMonitor["HMON"]) {
        CurrentMonitorIndex := Index
        Break
    }
}
;;∙------∙Calculate the opposite monitor based on position.
OppositeMonitor := ""
MaxDistance := 0
For Index, Monitor In SortedMonitors {
    If (Index != CurrentMonitorIndex) {
        ;;∙------∙Calculate distance between current monitor and each other monitor
        Distance := Abs(ActiveMonitor["Left"] - Monitor["M"]["Left"]) + Abs(ActiveMonitor["Top"] - Monitor["M"]["Top"])
        If (Distance > MaxDistance) {
            MaxDistance := Distance
            OppositeMonitor := Monitor
        }
    }
}
If OppositeMonitor {
    ;;∙------∙Get the current window's size and position before moving.
    WinGetPos, X, Y, Width, Height, ahk_id %ActiveWindow%
    ;;∙------∙Get the current monitor's position. (relative to the screen)
    CurrentMonitorLeft := ActiveMonitor["Left"]
    CurrentMonitorTop := ActiveMonitor["Top"]
    ;;∙------∙Get the opposite monitor's position. (relative to the screen)
    OppositeMonitorLeft := OppositeMonitor["M"]["Left"]
    OppositeMonitorTop := OppositeMonitor["M"]["Top"]
    ;;∙------∙Calculate the new position on the opposite monitor.
    NewX := X - CurrentMonitorLeft + OppositeMonitorLeft
    NewY := Y - CurrentMonitorTop + OppositeMonitorTop
        ;;∙------∙ *DEBUGGING*  Show current position, size, and new calculated position. *DEBUGGING*
        MsgBox,,, % "Current Window Position: " X ", " Y "`nWidth: " Width "`nHeight: " Height, 5
        MsgBox,,, % "Opposite Monitor: " OppositeMonitor["M"]["Name"] "`nNew Position: " NewX ", " NewY, 5
    ;;∙------∙Move the active window to the opposite monitor's calculated position, preserving the size.
    WinMove, ahk_id %ActiveWindow%, , NewX, NewY, Width, Height
} Else {
    MsgBox,,, Error, No opposite monitor found., 7
}
Return

;;∙------∙🔥∙--------------------------------------------------------------------------------∙
^!Numpad8::    ;;∙------∙Shows monitor information with Primary monitor listed first.
^!8::
Gui, Margin, 20, 20
Gui, +OwnDialogs
Gui, Add, ListView, w660 r10 Grid, HMON|Num|Name|Primary|Left|Top|Right|Bottom|WALeft|WATop|WARight|WABottom
SortedMonitors := []    ;;∙------∙Sort monitors to bring primary one to the top.
For HMON, M In Monitors {
    If M.Primary
        SortedMonitors.InsertAt(0, {HMON: HMON, M: M})
    Else
        SortedMonitors.Push({HMON: HMON, M: M})
}
For Index, Monitor In SortedMonitors {
    LV_Add("", Monitor.HMON, Monitor.M.Num, Monitor.M.Name, Monitor.M.Primary, Monitor.M.Left, Monitor.M.Top, Monitor.M.Right, Monitor.M.Bottom, Monitor.M.WALeft, Monitor.M.WATop, Monitor.M.WARight, Monitor.M.WABottom)
}
Loop, % LV_GetCount("Column")
   LV_ModifyCol(A_Index, "AutoHdr")
Gui, Show, ,Monitors
Return
;;∙============================================================∙


;;∙============================================================∙
;;∙-----------------∙FUNCTIONS∙--------------------------------------------------------∙
;;∙============================================================∙
;;∙-----------------------∙Enumerates display monitors and returns an object containing the properties of all monitors or the specified monitor.
MDMF_Enum(HMON := "") {
    Static EnumProc := RegisterCallback("MDMF_EnumProc")
    Static Monitors := {}
    If (HMON = "")    ;;∙------∙New enumeration.
        Monitors := {}
    If (Monitors.MaxIndex() = "")    ;;∙------∙Enumerate.
        If !DllCall("User32.dll\EnumDisplayMonitors", "Ptr", 0, "Ptr", 0, "Ptr", EnumProc, "Ptr", &Monitors, "UInt")
            Return False
    Return (HMON = "") ? Monitors : Monitors.HasKey(HMON) ? Monitors[HMON] : False
    }
;;∙-----------------------∙Callback function that is called by the MDMF_Enum function.
MDMF_EnumProc(HMON, HDC, PRECT, ObjectAddr) {
    Monitors := Object(ObjectAddr) ;
    Monitors[HMON] := MDMF_GetInfo(HMON)
    Return True
    }
;;∙-----------------------∙Retrieves the display monitor that has the largest area of intersection with a specified window.
MDMF_FromHWND(HWND) {
    Return DllCall("User32.dll\MonitorFromWindow", "Ptr", HWND, "UInt", 0, "UPtr")
    }
;;∙-----------------------∙Retrieves the display monitor that contains a specified point.
;;∙------∙If either X or Y is empty, the function will use the current cursor position for this value.
MDMF_FromPoint(X := "", Y := "") {
    VarSetCapacity(PT, 8, 0)
    If (X = "") || (Y = "") {
        DllCall("User32.dll\GetCursorPos", "Ptr", &PT)
        If (X = "")
            X := NumGet(PT, 0, "Int")
        If (Y = "")
            Y := NumGet(PT, 4, "Int")
        }
        Return DllCall("User32.dll\MonitorFromPoint", "Int64", (X & 0xFFFFFFFF) | (Y << 32), "UInt", 0, "UPtr")
    }
;;∙-----------------------∙Retrieves display monitor that has largest area of intersection with a specified rectangle.
;;∙------∙Parameters consistent with common AHK definition of a rectangle, which is X, Y, W, H. (not... Left, Top, Right, Bottom)
MDMF_FromRect(X, Y, W, H) {
    VarSetCapacity(RC, 16, 0)
    NumPut(X, RC, 0, "Int"), NumPut(Y, RC, 4, Int), NumPut(X + W, RC, 8, "Int"), NumPut(Y + H, RC, 12, "Int")
    Return DllCall("User32.dll\MonitorFromRect", "Ptr", &RC, "UInt", 0, "UPtr")
    }
;;∙-----------------------∙Retrieves information about a display monitor.
MDMF_GetInfo(HMON) {
    NumPut(VarSetCapacity(MIEX, 40 + (32 << !!A_IsUnicode)), MIEX, 0, "UInt")
    If DllCall("User32.dll\GetMonitorInfo", "Ptr", HMON, "Ptr", &MIEX) {
        MonName := StrGet(&MIEX + 40, 32)    ;;∙------∙CCHDEVICENAME = 32
        MonNum := RegExReplace(MonName, ".*(\d+)$", "$1")

    ;;∙------∙Retrieve Monitor's DPI settings (Windows 8.1+)
    If (A_OSVersion >= "6.3") {
        VarSetCapacity(DPI, 8, 0)
    If (DllCall("Shcore.dll\GetDpiForMonitor", "Ptr", HMON, "UInt", 0, "UInt*", dpiX, "UInt*", dpiY) = 0) {
        dpiX := dpiX
        dpiY := dpiY
    } Else {
        dpiX := dpiY := 96    ;;∙------∙Default DPI if function fails.
        }
    } Else {
        dpiX := dpiY := 96    ;;∙------∙Default DPI for older Windows.
          }
    ;;∙------∙Get the resolution from monitor bounds
    resWidth := NumGet(MIEX, 12, "Int") - NumGet(MIEX, 4, "Int")
    resHeight := NumGet(MIEX, 16, "Int") - NumGet(MIEX, 8, "Int")
    Return {Name:      (Name := StrGet(&MIEX + 40, 32))
        , Num:       RegExReplace(Name, ".*(\d+)$", "$1")
        , Left:      NumGet(MIEX, 4, "Int")    ;;∙------∙Display rectangle.
        , Top:       NumGet(MIEX, 8, "Int")    ;;∙------∙"
        , Right:     NumGet(MIEX, 12, "Int")    ;;∙------∙"
        , Bottom:    NumGet(MIEX, 16, "Int")    ;;∙------∙"
        , ResWidth:  resWidth
        , ResHeight: resHeight
        , DPI_X:     dpiX
        , DPI_Y:     dpiY
        , WALeft:    NumGet(MIEX, 20, "Int")    ;;∙------∙Work area.
        , WATop:     NumGet(MIEX, 24, "Int")    ;;∙------∙"
        , WARight:   NumGet(MIEX, 28, "Int")    ;;∙------∙"
        , WABottom:  NumGet(MIEX, 32, "Int")    ;;∙------∙"
        , Primary:   NumGet(MIEX, 36, "UInt")}    ;;∙------∙Contains a non-zero value for the primary monitor.
   }
   Return False
}
;;∙-----------------------∙Displays monitor information in a GUI with an Edit control.
DisplayMonitorInfo(MonitorInfo, Title) {
    global EditControl  ;; Declare EditControl as global to avoid the variable scope error.
    Gui, New, +AlwaysOnTop +HwndGuiHwnd
    Gui, Add, Edit, w600 r12 ReadOnly vEditControl, % "Monitor Number: " MonitorInfo.Num "`n"
        . "Monitor Name: " MonitorInfo.Name "`n"
        . "Resolution: " MonitorInfo.ResWidth " x" MonitorInfo.ResHeight "`n"
        . "DPI: " MonitorInfo.DPI_X " x " MonitorInfo.DPI_Y "`n"
        . "Coordinates: (" MonitorInfo.Left ", " MonitorInfo.Top ") - (" MonitorInfo.Right ", " MonitorInfo.Bottom ")`n"
        . "Work Area: (" MonitorInfo.WALeft ", " MonitorInfo.WATop ") - (" MonitorInfo.WARight ", " MonitorInfo.WABottom ")`n"
        . "Primary: " (MonitorInfo.Primary ? "Yes" : "No")
    Gui, Show, , % Title
    GuiControlGet, CurrentContent, , EditControl
    GuiControl,, EditControl, % CurrentContent . "`n`n`t*END*"
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
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        SoundBeep, 1100, 75
        Soundbeep, 1200, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        Soundbeep, 1100, 75
        Soundbeep, 1000, 100
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
;    Soundbeep, 700, 75
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
Menu, Tray, Icon, imageres.dll, 291
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
MultiMonitor_Manager:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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
