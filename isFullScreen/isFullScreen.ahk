
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  TheGood
» Original Source:  https://www.autohotkey.com/board/topic/50876-isfullscreen-checks-if-a-window-is-in-fullscreen-mode/
» Checks if a window is in fullscreen mode.
    ▹ 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "isFullScreen"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
;;∙============================================================∙
#Requires AutoHotkey 1.1
#SingleInstance, Force
#NoEnv
#Persistent
SendMode, Input
SetBatchLines -1
SetWinDelay 0
SetTitleMatchMode 2

Global bMonitorRefreshed := False    ;;∙------∙Track refresh state.
RefreshMonitorInfo()    ;;∙------∙Initialize
SetTimer, RefreshMonitorInfo, 5000    ;;∙------∙ & refresh monitor data

;;∙::::::::::::::::::::∙USAGE EXAMPLES∙:::::::::::::::::::::::::::∙
;;∙------------∙Check If The Active Window Is Fullscreen.
^Numpad1::    ;;∙------∙🔥∙(Ctrl + Numberpad 1)
    Soundbeep, 1000, 200
    result := IsFullscreen() ? "IS FULL SCREEN!" : "Is NOT Full Screen."
    WinGetTitle, winTitle, A
    Clipboard = % "The app...`n`n"" " winTitle " ""`n`n`t..." result
    MsgBox,,Active Full Screen, % "The app...`n`n"" " winTitle " ""`n`n`t..." result, 4
Return

;;∙------------∙Check If A Specific Window Is Fullscreen.
^Numpad2::    ;;∙------∙🔥∙(Ctrl + Numberpad 2)
  appTitle := "ahk_class Chrome_WidgetWin_1"    ;;∙------∙Brave/Chrome/Edge browser window (change as needed).
WinGetTitle, winTitle, %appTitle%
  result := IsFullscreen(appTitle) ? "IS FULL SCREEN!" : "Is NOT Full Screen."
Clipboard = % "The app...`n`n"" " winTitle " ""`n`n`t..." result
MsgBox,,Specific Full Screen, % "The app...`n`n"" " winTitle " ""`n`n`t..." result, 4
Return

;;∙------------∙Refresh Monitor & Check If Active Window Is Fullscreen.
^Numpad3::    ;;∙------∙🔥∙(Ctrl + Numberpad 3)
  result := IsFullscreen("A", True)
MsgBox,,Monitor Info Refresh, % "0 = Is NOT Full Screen.`n1 = IS FULL SCREEN!`n`nReturn Report = " result, 4
Return


;;∙::::::::::::::::::::∙FUNCTIONS∙::::::::::::::::::::::::::::∙
;;∙------------∙Monitor Info Refresh.
RefreshMonitorInfo() {
    Global
    Static iPrimaryMon

    bMonitorRefreshed := True
    SysGet, Mon0, MonitorCount
    SysGet, iPrimaryMon, MonitorPrimary
    Loop, %Mon0% {
        SysGet, Mon%A_Index%, Monitor, %A_Index%
        Mon%A_Index%MidX := Mon%A_Index%Left + Ceil((Mon%A_Index%Right - Mon%A_Index%Left)/2)
        Mon%A_Index%MidY := Mon%A_Index%Top + Ceil((Mon%A_Index%Bottom - Mon%A_Index%Top)/2)
    }
}

;;∙------------∙Fullscreen Detection.
IsFullscreen(sWinTitle := "A", bRefreshRes := False) {
    Global
    Local iWinX, iWinY, iWinW, iWinH, iCltX, iCltY, iCltW, iCltH, iMidX, iMidY, iMonitor, c, D, iBestD

    ErrorLevel := False

    ;;∙------∙Only refresh if forced or not yet refreshed by timer.
    If (bRefreshRes or !bMonitorRefreshed)
        RefreshMonitorInfo()

    hWin := WinExist(sWinTitle)
    If !hWin {
        ErrorLevel := True
        Return False
    }
    WinGetClass, c, ahk_id %hWin%
    If (hWin = DllCall("GetDesktopWindow") Or (c = "Progman") Or (c = "WorkerW"))
        Return False

    VarSetCapacity(iWinRect, 16), VarSetCapacity(iCltRect, 16)
    DllCall("GetWindowRect", "Ptr", hWin, "Ptr", &iWinRect)
    DllCall("GetClientRect", "Ptr", hWin, "Ptr", &iCltRect)
    WinGet, iStyle, Style, ahk_id %hWin%

    iWinX := NumGet(iWinRect, 0, "Int")
    iWinY := NumGet(iWinRect, 4, "Int")
    iWinW := NumGet(iWinRect, 8, "Int") - iWinX
    iWinH := NumGet(iWinRect, 12, "Int") - iWinY
    iCltX := 0, iCltY := 0
    iCltW := NumGet(iCltRect, 8, "Int")
    iCltH := NumGet(iCltRect, 12, "Int")

    iMidX := iWinX + Ceil(iWinW / 2)
    iMidY := iWinY + Ceil(iWinH / 2)
    iBestD := 0xFFFFFFFF
    Loop, %Mon0% {
        D := Sqrt((iMidX - Mon%A_Index%MidX)**2 + (iMidY - Mon%A_Index%MidY)**2)
        If (D < iBestD) {
            iBestD := D
            iMonitor := A_Index
        }
    }

    ;;∙------∙Client area check.
    If (iCltX <= Mon%iMonitor%Left
        && iCltY <= Mon%iMonitor%Top
        && iCltW >= Mon%iMonitor%Right - Mon%iMonitor%Left
        && iCltH >= Mon%iMonitor%Bottom - Mon%iMonitor%Top)
            Return True

    ;;∙------∙Window area check.
    If (iWinX <= Mon%iMonitor%Left
        && iWinY <= Mon%iMonitor%Top
        && iWinW >= Mon%iMonitor%Right - Mon%iMonitor%Left
        && iWinH >= Mon%iMonitor%Bottom - Mon%iMonitor%Top
        && !(iStyle & 0x00C40000))    ;;∙------∙WS_CAPTION | WS_SIZEBOX | WS_THICKFRAME
            Return iMonitor

    Return False
}
∙=====================================================================∙
∙=====================================================================∙




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
isFullScreen:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

