
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
#NoEnv
#Persistent
#SingleInstance, Force
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.
SetBatchLines -1
SetWinDelay 0

^F1::    ;;∙------∙🔥∙(Ctrl + F1)

;;∙------∙Cursor IDs.
IDC_APPSTARTING 	:= 32650    ;;∙------∙Standard "app starting" / busy cursor.
IDC_ARROW 	:= 32512    ;;∙------∙Normal arrow cursor.
IDC_CROSS 	:= 32515    ;;∙------∙Crosshair cursor.
IDC_HAND 	:= 32649    ;;∙------∙Hand cursor (usually for clickable items/links).
IDC_HELP 	:= 32651    ;;∙------∙Help cursor (question mark icon).
IDC_IBEAM 	:= 32513    ;;∙------∙Text input cursor (I-beam).
IDC_NO 		:= 32648    ;;∙------∙Not-allowed / prohibited cursor.
IDC_SIZEALL 	:= 32646    ;;∙------∙Move / four-way resize cursor.
IDC_SIZENESW 	:= 32643    ;;∙------∙Diagonal resize (NE ↔ SW) cursor.
IDC_SIZENS 	:= 32645    ;;∙------∙Vertical resize (N ↔ S) cursor.
IDC_SIZENWSE 	:= 32642    ;;∙------∙Diagonal resize (NW ↔ SE) cursor.
IDC_SIZEWE 	:= 32644    ;;∙------∙Horizontal resize (W ↔ E) cursor.
IDC_UPARROW 	:= 32516    ;;∙------∙Up arrow cursor (used for selections).
IDC_WAIT 	:= 32514    ;;∙------∙Hourglass / wait cursor.


BCursor   := DllCall("LoadCursor", "UInt", 0, "Int", IDC_HAND, "UInt")
LVCursor  := DllCall("LoadCursor", "UInt", 0, "Int", IDC_HELP, "UInt")
DefCursor := DllCall("LoadCursor", "UInt", 0, "Int", IDC_ARROW, "UInt")    ;;∙------∙Default arrow cursor.

;;∙------∙GUI dimensions and position.
x := 320
y := 200
w := 320
h := 230

;;∙------∙Create GUI and store HWNDs for child controls.
Gui, +AlwaysOnTop -Caption +LastFound +ToolWindow
Gui, Color, Teal
Gui, Add, Button, vButton1 hwndhButton1 x20  y20  w100 h30 gButtonHandler, Button 1
Gui, Add, Button, vButton2 hwndhButton2 x20  y60  w100 h30 gButtonHandler, Button 2
Gui, Add, Button, vButton3 hwndhButton3 x20  y100 w100 h30 gButtonHandler, Button 3
Gui, Add, Button, vButton4 hwndhButton4 x20  y140 w100 h30 gButtonHandler, Button 4
Gui, Add, Button, vButton5 hwndhButton5 x20  y180 w100 h30 gButtonHandler, Button 5
Gui, Add, ListView, vListView1 hwndhListView1 x150 y20 w150 h190 gListViewHandler AltSubmit NoSort, Column 1|Column 2

;;∙------∙Add some sample data to the ListView.
LV_Add("", "Item 1", "Data A")
LV_Add("", "Item 2", "Data B")
LV_Add("", "Item 3", "Data C")
LV_Add("", "Item 4", "Data D")

;;∙------∙Set ListView column header widths.
;;∙---∙LV_ModifyCol(1, "Auto") 	;;∙------∙Auto-size column 1 to content.
LV_ModifyCol(1, "AutoHdr") 	;;∙------∙Auto-size column 1 to header text.
;;∙---∙LV_ModifyCol(2, "Auto") 	;;∙------∙Auto-size column 2 to content.
LV_ModifyCol(2, "AutoHdr") 	;;∙------∙Auto-size column 2 to header text.

Gui, Show, x%x% y%y% w%w% h%h%, Gui Hover Cursors

;;∙------∙Intercept WM_SETCURSOR to control cursor over GUI and controls.
OnMessage(0x20, "WM_SETCURSOR")    ;;∙------∙0x20 = WM_SETCURSOR

Return

;;∙------∙Button click handler.
ButtonHandler:
    GuiControlGet, ControlName, FocusV    ;;∙------∙Get the variable name of focused control.
    Gui +OwnDialogs    ;;∙------∙Prevent MsgBox taskbar buttons.
    ButtonNum := SubStr(ControlName, 7)    ;;∙------∙Extract number from "Button1".
    MsgBox,,, You clicked Button %ButtonNum%., 3
Return


;;∙------∙ListView click handler.
ListViewHandler:
    Gui +OwnDialogs
    if (A_GuiEvent = "DoubleClick") {
        RowNumber := LV_GetNext(0, "F")    ;;∙------∙Find focused row.
        if (RowNumber) {
            LV_GetText(Col1Text, RowNumber, 1)    ;;∙------∙Get text from column 1.
            LV_GetText(Col2Text, RowNumber, 2)    ;;∙------∙Get text from column 2.
            MsgBox,,, You double-clicked on:%A_Space%Row %RowNumber%`nColumn 1: %Col1Text%`nColumn 2: %Col2Text%, 5
        }
    }
    else if (A_GuiEvent = "Normal") {    ;;∙------∙Check if any row is currently selected after a click.
        SelectedRow := LV_GetNext(0)
        
        if (SelectedRow > 0) {    ;;∙------∙Only show MsgBox if a row is actually selected.
            LV_GetText(Col1Text, SelectedRow, 1)
            LV_GetText(Col2Text, SelectedRow, 2)
            MsgBox,,, You clicked on:%A_Space%Row %SelectedRow%`nColumn 1: %Col1Text%`nColumn 2: %Col2Text%, 5
        }
    }
Return

WM_SETCURSOR(wParam, lParam)
{
    global hButton1, hButton2, hButton3, hButton4, hButton5, hListView1
    global BCursor, LVCursor, DefCursor

    hwnd := wParam

    if (hwnd = hButton1 or hwnd = hButton2 or hwnd = hButton3 or hwnd = hButton4 or hwnd = hButton5)
        DllCall("SetCursor", "UInt", BCursor)
    else if (hwnd = hListView1)
        DllCall("SetCursor", "UInt", LVCursor)
    else
        DllCall("SetCursor", "UInt", DefCursor)

    return true    ;;∙------∙Tell Windows we handled it.
}

;;∙------∙Gui Drag Pt 2.
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}

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

