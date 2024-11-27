
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙--------∙Origins∙-------------------------∙
» Author:  Coco
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?f=76&t=4373#p24512
» * Modern apps such as UWP (Universal Windows Platform) or apps with custom-built windowing systems, frequently bypass or override traditional behaviors, like remembering their previous window state and size when launched and generally do notrespect standard Run parameters.
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "Run_Min_Hide"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙🔥 HotKey 🔥∙===========================================∙
^t::    ;;∙------∙(Ctrl+T) 
    Soundbeep, 1100, 100
;;∙============================================================∙




;;∙============================================================∙
;;∙============∙ENVIROMENT∙===============∙
#NoEnv
#Persistent
SendMode Input
global hAppTitle
;;∙------------------------------------∙


;;∙============∙SETTINGS∙===================∙
;;∙------∙Set The Application Path.

APP := "C:\Windows\System32\notepad.exe"    ;;∙------∙(if left blank/undefined Red 'X' Tray Icon appears)

;;∙------∙Set The MsgBox Timeout.
mboxTimeout := 5
;;∙------------------------------------∙


;;∙============∙HIDDEN SETTINGS∙============∙
;;∙------------∙Uncomment to go "Hidden"∙------------∙
;;∙------∙#NoTrayIcon    ;;∙------∙Eliminates system tray icon.
Gui, +OwnDialogs    ;;∙------∙Eliminates MsgBox taskbar icon.


;;∙============∙TRAY ICON SETUP∙=============∙
;;∙----------∙& Handle Double-Click Events.∙-----------∙
Try {
    ;;∙------∙Check if the APP path is valid by checking the file existence.
    If !FileExist(APP)    ;;∙------∙If the file doesn't exist, force the Try block to fail.
        Throw    ;;∙------∙Manually trigger the Catch block.
        ;;∙------∙Try to use the APP's icon. (this may fail if the APP doesn't provide an icon)
    Menu Tray, Icon, %APP%
        ;;∙------∙Check if the icon was set correctly. (else fall back to a generic icon)
    If !DllCall("GetClassLong", "Ptr", WinExist("ahk_class Shell_TrayWnd"), "Int", -12) {
        Menu Tray, Icon, shell32.dll, 124    ;;∙------∙Fallback Icon (small Down arrow) if APP doesn't supply an icon.
    }
} Catch {    ;;∙------∙If Try fails, set fallback icon. (APP path invalid or other error)
    Menu Tray, Icon, shell32.dll, 132    ;;∙------∙Fallback to generic Windows icon if the APP doesn't exist. (Red 'X')
        Soundbeep, 800, 250
    ToolTip, The APP Does`n   NOT Exist!!
        sleep 2000
    ToolTip
Reload
}
Menu Tray, Add, Show / Hide AppTitle, TrayClick
Menu Tray, Default, Show / Hide AppTitle


;;∙============∙RUN THE APP∙================∙
;;∙------∙Run APP Minimized/Hidden.
DetectHiddenWindows On
Run %APP%,, Hide, PID
WinWait ahk_pid %PID%
Timeout := mboxTimeout
hAppTitle := WinExist()
WinWaitClose ahk_id %hAppTitle%
    SetTimer, Countdown, 1000
Msgbox, 4160, ALERT, % "The App Has Been Closed.`n Reloading The Script In...`n`t..." Timeout " Seconds.", % Timeout
;;∙------∙ExitApp
Reload


;;∙============∙FUNCTIONS∙=================∙

TrayClick:
    OnTrayClick()
Return
;;∙------------------------------------∙
OnTrayClick() {    ;;∙------∙Show/Hide APP on double-click.
    if DllCall("IsWindowVisible", "Ptr", hAppTitle) {
        WinHide ahk_id %hAppTitle%
    } else {
        WinShow ahk_id %hAppTitle%
        WinActivate ahk_id %hAppTitle%
        }
    }
Return
;;∙------------------------------------∙
Countdown:
    if !WinExist("ALERT ahk_class #32770") {
        SetTimer, Countdown, Off
        Return
    }
    ControlGetText, Msg, Static2
    RegExMatch(Msg, "\d+", Sec)
    ControlSetText, Static2, % RegExReplace(Msg, "\d+", Sec - 1)
    if (Sec = 1)
        SetTimer, Countdown, Off
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
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.
SetBatchLines -1
SetTimer, UpdateCheck, 500
SetTitleMatchMode 2
SetWinDelay 0
Menu, Tray, Icon, shell32.dll, 123    ;;∙------∙(large Down arrow)
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
Run_Min_Hide:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

