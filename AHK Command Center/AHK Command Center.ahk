
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙----------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙--------------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
» 
∙--------∙Origins∙-------------------------∙
» Author:  bruno
» Source:  https://www.autohotkey.com/board/topic/38653-see-running-autohotkey-scripts-and-end-them/page-2
» See running AutoHotkey scripts (and control them)
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TEMPLATE"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙🔥 HotKey 🔥∙===========================================∙
; ^t::    ;;∙------∙(Ctrl+T) 
;    Soundbeep, 1100, 100
;;∙============================================================∙




;;∙============================================================∙
_Process:=Object()

Gui, 1: New
Gui, 1: +AlwaysOnTop -Caption +Border
Gui, 1: Color, 676767
Gui, 1: Margin, 10, 10

Gui, 1: Add, ListView, c57ABFF Background212121 Grid -LV0x10 -multi w277 h250 AltSubmit vListView gListView, Name|PID

Gui, 1: Add, Button, x+-262 y+5 w50 h20, Refresh
Gui, 1: Add, Button, x+0 y+-20 w50 h20, Reload
Gui, 1: Add, Button, x+0 y+-20 w50 h20, Close
Gui, 1: Add, Button, x+0 y+-20 w50 h20, Save
Gui, 1: Add, Button, x+0 y+-20 w50 h20, Edit
Gui, 1: Add, Button, x+-200 y+0 w50 h20, Pause
Gui, 1: Add, Button, x+0 y+-20 w50 h20, Suspend
Gui, 1: Add, Button, x+0 y+-20 w50 h20, KillAll

Menu, MyContextMenu, Add, Refresh, ButtonRefresh
Menu, MyContextMenu, Add, Reload, ButtonReload
Menu, MyContextMenu, Add, Close, ButtonClose
Menu, MyContextMenu, Add, Save, ButtonSave
Menu, MyContextMenu, Add, Edit, ButtonEdit
Menu, MyContextMenu, Add, Pause, ButtonPause
Menu, MyContextMenu, Add, Suspend, ButtonSuspend

LV_ModifyCol()

ButtonRefresh:
  Gui, 1: Show
    LV_Delete()
    _Processes:=0
    _Process.Remove(0,_Process.MaxIndex())
    GuiControl, -ReDraw, ListView
    For Process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process where Name='AutoHotkey.exe'")
    {
        If(Process.ExecutablePath==A_AHKPath)
        {
            _Processes++
            _Process[_Processes]:=[Extract_Script_Name_From_CommandLine(Process.CommandLine)
                  ,Extract_Script_Path_From_CommandLine(Process.CommandLine),Process.ProcessID]
            LV_Add("",_Process[_Processes,1],Process.ProcessID)
        }
    }
    LV_ModifyCol()
    GuiControl, +ReDraw, ListView
Return

ButtonSave:
t := ""
Loop % LV_GetCount()
{
    LV_GetText(OutputVar1,A_Index,1)
    LV_GetText(OutputVar2,A_Index,2)
    t .= OutputVar1 A_Space OutputVar2 "`n"
}
MsgBox, 262212, `n`n" t, Would you like to save this file to Clipboard? ; 262208+4
IfMsgBox, Yes, GoTo MN
IfMsgBox, No, Return

MN:
Clipboard := t
Return

;;∙------------------------------------------------------------------------------------------∙
ButtonKillAll:
Soundbeep, 1700,300
AHK_Kill_All()
Tray_Refresh()    ;;∙------∙https://www.autohotkey.com/boards/viewtopic.php?t=19832#p156072
    Return
;--------------------- 
AHK_Kill_All() {    ;;∙------∙<-- Exits all AHK apps EXCEPT the calling script.
    DetectHiddenWindows, % ( ( DHW:=A_DetectHiddenWindows ) + 0 ) . "On"
    WinGet, L, List, ahk_class AutoHotkey
        Loop %L%
            If ( L%A_Index% <> WinExist( A_ScriptFullPath " ahk_class AutoHotkey" ) )
        PostMessage, 0x111, 65405, 0,, % "ahk_id " L%A_Index%
    DetectHiddenWindows, %DHW%
Sleep, 100
    {
  eee := DllCall( "FindWindowEx", "uint", 0, "uint", 0, "str", "Shell_TrayWnd", "str", "")
  ddd := DllCall( "FindWindowEx", "uint", eee, "uint", 0, "str", "TrayNotifyWnd", "str", "")
  ccc := DllCall( "FindWindowEx", "uint", ddd, "uint", 0, "str", "SysPager", "str", "")
  hNotificationArea := DllCall( "FindWindowEx", "uint", ccc, "uint", 0, "str", "ToolbarWindow32", "str", "Notification Area")
  
  xx = 3
  yy = 5
  Transform, yyx, BitShiftLeft, yy, 16
  loop, 6 ;152
  {
    xx += 15
    SendMessage, 0x200, , yyx + xx, , ahk_id %hNotificationArea%
  }
}
Sleep, 250
    SoundSet, 1
    Soundbeep, 1900, 75
Sleep, 10
        Soundbeep, 1600, 75
Sleep, 10
    Soundbeep, 1800, 75
Sleep, 10
        Soundbeep, 1500, 75
Sleep, 10
    Soundbeep, 1700, 75
Sleep, 10
        Soundbeep, 1400, 75
;            Soundbeep, 1200, 300
    Sleep, 200
}
;------------------------------------------ 
Tray_Refresh() {
    WM_MOUSEMOVE := 0x200
    detectHiddenWin := A_DetectHiddenWindows
    DetectHiddenWindows, On

    allTitles := ["ahk_class Shell_TrayWnd"
            , "ahk_class NotifyIconOverflowWindow"]
    allControls := ["ToolbarWindow321"
                ,"ToolbarWindow322"
                ,"ToolbarWindow323"
                ,"ToolbarWindow324"]
    allIconSizes := [24,32]

    for id, title in allTitles {
        for id, controlName in allControls
        {
            for id, iconSize in allIconSizes
            {
                ControlGetPos, xTray,yTray,wdTray,htTray,% controlName,% title
                y := htTray - 10
                While (y > 0)
                {
                    x := wdTray - iconSize/2
                    While (x > 0)
                    {
                        point := (y << 16) + x
                        PostMessage,% WM_MOUSEMOVE, 0,% point,% controlName,% title
                        x -= iconSize/2
                    }
                    y -= iconSize/2
                }
            }
        }
    }
    DetectHiddenWindows, %detectHiddenWin%
SoundSet, 1
    Soundbeep, 1200, 400
Sleep, 200
;------------------------------------------ 
    ExitApp    ;;∙------∙<--Self exit once all others scripts are exited and Tray is refreshed.
}
Return
;;∙------------------------------------------------------------------------------------------∙

ButtonReload:
  If !LV_GetNext(0)
        Return
RowNumber = 0    ;;∙------∙This causes the first loop iteration to start the search at the top of the list
Loop
{
    RowNumber := LV_GetNext(RowNumber)    ;;∙------∙Resume the search at the row after that found by the previous iteration
    If NOT RowNumber
        Break
    ;;∙------∙LV_GetText(Text, RowNumber)
    ;;∙------∙MsgBox, The next selected row is #%RowNumber%, whose first field is "%Text%".
    _ScriptDIR:=_Process[LV_GetNext(RowNumber-1),2]
    Run, "%A_AHKPath%" /restart "%_ScriptDIR%"
    Sleep (500)
}
GoSub, ButtonRefresh
Return

ButtonEdit:
  If !LV_GetNext(0)
        Return
RowNumber = 0
Loop
{
    RowNumber := LV_GetNext(RowNumber)
    If NOT RowNumber
        Break
    _ScriptDIR:=_Process[LV_GetNext(RowNumber-1),2]
    Run, Notepad.exe %_ScriptDIR%
    Sleep (500)
}
Return

ButtonClose:
  If !LV_GetNext(0)
        Return
RowNumber = 0
Loop
{
    RowNumber := LV_GetNext(RowNumber)
    If NOT RowNumber
        Break
    Process, Close, % _Process[LV_GetNext(RowNumber-1),3]
    Sleep (500)
    Tray_Refresh()
}
GoSub, ButtonRefresh
Return

ButtonPause:
WM_COMMAND := 0x111
CMD_RELOAD := 65400
CMD_EDIT := 65401
CMD_PAUSE := 65403
CMD_SUSPEND := 65404
DetectHiddenWindows, On
  If !LV_GetNext(0)
        Return
RowNumber = 0
Loop
{
    RowNumber := LV_GetNext(RowNumber)
    If NOT RowNumber
        Break
GoSub, CMDP
    Sleep (500)
}
Return

CMDP:
Process, Exist
this_pid := _Process[LV_GetNext(RowNumber-1),3]
control_id := WinExist("ahk_class AutoHotkey ahk_pid " this_pid)
WinGet, id, list, ahk_class AutoHotkey
Loop, %id%
{
    this_id := id%A_Index%
    If (this_id = control_id)
    {
    PostMessage, WM_COMMAND, CMD_PAUSE,,, ahk_id %this_id%
    ;;∙------∙PostMessage, WM_COMMAND, CMD_SUSPEND,,, ahk_id %this_id%
    }
}
Return

ButtonSuspend:
WM_COMMAND := 0x111
CMD_RELOAD := 65400
CMD_EDIT := 65401
CMD_PAUSE := 65403
CMD_SUSPEND := 65404
DetectHiddenWindows, On
  If !LV_GetNext(0)
        Return
RowNumber = 0
Loop
{
    RowNumber := LV_GetNext(RowNumber)
    If NOT RowNumber
        Break
GoSub, CMDS
    Sleep (500)
}
Return

CMDS:
Process, Exist
this_pid := _Process[LV_GetNext(RowNumber-1),3]
control_id := WinExist("ahk_class AutoHotkey ahk_pid " this_pid)
WinGet, id, list, ahk_class AutoHotkey
Loop, %id%
{
    this_id := id%A_Index%
    If (this_id = control_id)
    {
    ;;∙------∙PostMessage, WM_COMMAND, CMD_PAUSE,,, ahk_id %this_id%
    PostMessage, WM_COMMAND, CMD_SUSPEND,,, ahk_id %this_id%
    }
}
Return

ListView:
If A_GuiEvent = DoubleClick
GoSub, ButtonEdit
Return

GuiContextMenu:    ;;∙------∙Launched in response to a right-click:
If A_GuiControl <> ListView    ;;∙------∙Display the menu only for clicks inside the ListView
Return

Menu, MyContextMenu, Show
Return

GuiControl,, Refresh,
GuiControl,, Reload,
GuiControl,, Close,
GuiControl,, Save,
GuiControl,, Edit,
GuiControl,, Pause,
GuiControl,, Suspend,
Return

Extract_Script_Name_From_CommandLine(P) {
    StringSplit,R,P,"
    SplitPath,R4,F
    Return F
}

Extract_Script_Path_From_CommandLine(P) {
    StringSplit,R,P,"
    Return R4
}
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
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙--∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        SoundBeep, 1100, 75
        Soundbeep, 1200, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙--∙Double-Tap.
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
    Soundbeep, 1700, 100
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
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;; Gui Drag Pt 1.
SetBatchLines -1
SetTimer, UpdateCheck, 500
SetTitleMatchMode 2
SetWinDelay 0
Menu, Tray, Icon, imageres.dll, 3
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
Menu, Tray, Icon, Suspend / Pause, shell32, 28  ;  Imageres.dll, 65
Menu, Tray, Default, Suspend / Pause    ;;∙------∙Makes Bold.
Menu, Tray, Add
;;------------------------------------------∙

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
;;∙======∙TRAY MENU POSITION FUNTION∙======∙
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
;;∙============================================================∙

;;∙------------------------------------------------------------------------------------------∙
;;∙========================∙SCRIPT END∙=========================∙
;;∙------------------------------------------------------------------------------------------∙

