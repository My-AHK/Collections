
/*------∙NOTES∙--------------------------------------------------------------------------∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Script Notes:
    ▹ 1. First this Kills all running AutoHotkey scripts except for itself.
    ▹ 2. Then this script removes any phantom icons from the system tray.
    ▹ 3. Finally, the script then Exits itself.
∙--------------------------------------------------------------------------------------------∙
*/




;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙
;;∙======∙AUTO-EXECUTE∙========∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force
SendMode, Input
SetBatchLines -1
SetWinDelay 0
SetTimer, UpdateCheck, 750
ScriptID := "AHK_KILLER"
Menu, Tray, Icon, shell32.dll, 313
GoSub, TrayMenu
#NoTrayIcon


;;∙======∙KILL-&-Refresh∙=========∙
AHK_Kill_All()
Tray_Refresh()
    Return


;;∙======∙KILL-ALL-AHK∙==========∙
AHK_Kill_All() {    ;;∙------∙Exits all AHK apps EXCEPT the calling script.
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
    Sleep, 200
}


;;∙======∙REFRESH-TRAY∙=========∙
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
    ExitApp    ;;∙------∙Self exit once all others scripts are exited & Tray is refreshed.
}
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙====================================∙
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

;;∙====================================∙
 ;;∙------∙SCRIPT UPDATE∙-------------∙
UpdateCheck:    ;;∙------Check if script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload

;;∙====================================∙
 ;;∙------∙TRAY MENU∙------------------∙
TrayMenu:
Menu, Tray, Tip, %ScriptID%
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
AHK_KILLER:    ;;∙------∙Suspends hotkeys then pauses script.
    Suspend
    Soundbeep, 700, 100
    Pause
Return

;;∙====================================∙
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
;;∙------------------------------------------------------------------------------------------∙
;;∙========================∙SCRIPT END∙=========================∙
;;∙------------------------------------------------------------------------------------------∙
