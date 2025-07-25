
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  joedf
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?f=7&p=607398#p607312
» How to react to new instances, but keep only the original running.
    ▹ 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "SingleInstance_Notify"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
;;∙============================================================∙
/*∙======∙Helpful Topics∙=======================∙
    ▹ https://www.autohotkey.com/boards/viewtopic.php?t=124720
    ▹ https://www.autohotkey.com/docs/v1/lib/PostMessage.htm
    ▹ https://www.autohotkey.com/docs/v1/lib/_Persistent.htm
*/

;;∙============∙Initial Setup∙=========================∙
#Requires AutoHotkey v1.1.33+
#NoEnv
#Persistent
#SingleInstance Off
DetectHiddenWindows On
SetBatchLines -1
SetTitleMatchMode 2
SetWinDelay 0
SetTimer, UpdateCheck, 500

#NoTrayIcon    ;;∙------∙Suppress tray icon initially.

PID := DllCall("GetCurrentProcessId")

;;∙------∙The receiver script should have created a message with hard-coded names as below, so get its number.
;;∙------∙Note, these should probably be unique to your application. Otherwise, you could use lParam to make it more unique.
NewScript := DllCall("RegisterWindowMessage", "Str", "StahkyLaunch")
ExistingScript := DllCall("RegisterWindowMessage", "Str", "StahkyAlreadyRunning")

;;∙------∙Subscribe to check if there's already an existing script running.
OnMessage(ExistingScript, "ExistingScript")


;;∙============∙Main Execution∙======================∙
;;∙------∙Broadcast that we are a new script that wants to run.
MsgBox % "New PID = " PID
;;∙------∙Note that -456 could be whatever here, but just wParam was sufficient for this.
PostMessage, %NewScript%, %PID%, -456,, ahk_id 0xFFFF    ;;∙------∙HWND_BROADCAST := 0xFFFF

;;∙------∙At this point, we would have self-terminated if an existing script broadcasted back.
;;∙------∙Now we subscribe to check if new scripts are attempting to run.
Sleep 100 ; wait a bit so we don't trigger our own NewScriptCreated event handler.
OnMessage(NewScript, "NewScriptCreated")

;;∙------∙Otherwise, continue with normal execution / code here.
Menu, Tray, Icon    ;;∙------∙Re-enable tray icon.
Menu, Tray, Icon, wmploc.dll, 60    ;;∙------∙Primary script sets tray icon.
;;∙------∙Addition code...


;;∙============∙Message / Event handlers∙=============∙
NewScriptCreated(wParam, lParam, msg, hwnd) {
	global ExistingScript
	global PID
	;;∙------∙This check is needed so we don't react to self-origin messages
	if (PID != wParam) {
		;;∙------∙A new script that's not us wants to run, broadcast that we are already running.
		PostMessage, %ExistingScript%, %PID%, -456,, ahk_id 0xFFFF    ;;∙------∙HWND_BROADCAST := 0xFFFF
	}
}

ExistingScript(wParam, lParam, msg, hwnd) {
	global PID
	;;∙------∙Check if we got a broadcast from an existing/running script.
	;;∙------∙If it's not us, we self terminate.
	if (PID != wParam) {

		MsgBox % "Self-terminate PID = " PID "`nRetain Alpha PID = " wParam
		ExitApp
	}
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
SingleInstance_Notify:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

