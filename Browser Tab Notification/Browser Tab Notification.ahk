
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙--------∙Origins∙-------------------------∙
» Author:  Self
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?t=117062#p521818
» 
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
;^t::    ;;∙------∙(Ctrl+T) 
    Soundbeep, 1100, 100
;;∙============================================================∙


;;∙----------------------------------------------------------------------------------------------∙
;;∙▎▞▚▞▚∙3 VERSIONs∙▞▚▞▚▞∙3 VERSIONs∙▚▞▚▞▚∙3 VERSIONs∙▞▚▞▚▎∙
;;∙----------------------------------------------------------------------------------------------∙


/*
;;∙▎▞▚▞▚▞▚▞▚▞▚▞▚▞∙VERSIONS 1∙▚▞▚▞▚▞▚▞▚▞▚▞▚▞▚▞▚▎∙
;;∙------∙BEHAVIOR: (annoying)
;;∙------∙1. Open YouTube tab, it runs (SoundBeep/MsgBox) routine.
;;∙------∙2. Close and then reopen YouTube tab, it runs routine.
;;∙------∙3. Click between tabs and come back to YouTube tab, it runs routine.
;;∙------∙4. Click on a different window and come back to YouTube tab, it runs routine.
;;∙------∙5. Every single time tab is activated, it runs routine.

;;∙------------------------------------------------∙
#Persistent
#SingleInstance, Force
SetTitleMatchMode 2

;;∙------------------------------------------------∙
;;∙------∙Set Browser. (msedge.exe\firefox.exe\brave.exe\chrome.exe\etc.)
browserExe := "msedge.exe"
tabTitle := "YouTube"    ;;∙------∙Set Tab Title.

;;∙------------------------------------------------∙
SetTimer, BrowserTabCheck, 750
lastState := false    ;;∙------∙Track previous state.
Return

;;∙------------------------------------------------∙
BrowserTabCheck:
    if WinExist("ahk_exe" browserExe)    ;;∙------∙Check if browserExe is running.
        {
        WinGetTitle, activeTitle, A
        if (InStr(activeTitle, tabTitle))    ;;∙------∙Check if "tabTitle" tab is active.
            {
            if (!lastState)    ;;∙------∙Execute only if previous state was not active.
                {
                    SoundBeep, 1200, 250    ;;∙------∙Play sound when "tabTitle" tab is activated.
                    MsgBox,,, % "The selected tab...`n" tabTitle "`n...has been activated", 4    ;;∙------∙Show message when "tabTitle" tab is detected.
                    lastState := true    ;;∙------∙Set state to active.
                }
            }
            else
            {
                lastState := false    ;;∙------∙Reset state when "tabTitle" tab is not active.
            }
        }
Return
;;∙------------------------------------------------∙
;;∙============================================================∙
*/



/*
;;∙▎▞▚▞▚▞▚▞▚▞▚▞▚▞∙VERSIONS 2∙▚▞▚▞▚▞▚▞▚▞▚▞▚▞▚▞▚▎∙
;;∙------∙BEHAVIOR:
;;∙------∙1. The (SoundBeep/MsgBox) routine runs when YouTube tab is opened.
;;∙------∙2. Click on a different window and come back to YouTube tab, it does not run routine.
;;∙------∙3. Select a different browser tab and then come back to YouTube tab, it runs routine.

;;∙------------------------------------------------∙
#Persistent
#SingleInstance, Force
SetTitleMatchMode 2

;;∙------------------------------------------------∙
browserExe := "msedge.exe"    ;;∙------∙Set Browser. (msedge.exe\firefox.exe\brave.exe\chrome.exe\etc.)
tabTitle := "YouTube"    ;;∙------∙Set Tab Title.

;;∙------------------------------------------------∙
SetTimer, YouCheck, 500    ;;∙------∙Set in milliseconds.
lastState := false    ;;∙------∙Track previous state.
Return

;;∙------------------------------------------------∙
YouCheck:
    if WinExist("ahk_exe" browserExe)    ;;∙------∙Check if browserExe is running.
    {
        WinGetTitle, activeTitle, A
        if (InStr(activeTitle, tabTitle))    ;;∙------∙Check if the "tabTitle" tab is active.
        {
            if (!lastState)    ;;∙------∙Execute only if the previous state was not active.
            {
                SoundBeep, 1900, 750    ;;∙------∙Play sound when "YouTube" is activated.
                MsgBox, YouTube Detected    ;;∙------∙Show message when "YouTube" is detected.
                lastState := true    ;;∙------∙Set the state to active.
            }
        }
        else if !WinExist(tabTitle)    ;;∙------∙Check if no "tabTitle" tab exists at all.
        {
            lastState := false    ;;∙------∙Reset the state when "tabTitle" tab is closed.
        }
    }
    else
    {
        lastState := false    ;;∙------∙Reset state if browserExe is completely closed.
    }
Return
;;∙------------------------------------------------∙
;;∙============================================================∙
*/



/*
;;∙▎▞▚▞▚▞▚▞▚▞▚▞▚▞∙VERSIONS 3∙▚▞▚▞▚▞▚▞▚▞▚▞▚▞▚▞▚▎∙
;;∙------∙BEHAVIOR:
;;∙------∙1. Click between tabs and come back to YouTube tab, it does not run (SoundBeep/MsgBox) routine.
;;∙------∙2. Click on a different window and come back to YouTube tab, it runs routine.
;;∙------∙3. Close YouTube tab and then reopen YouTube tab, it does not run routine.

;;∙------------------------------------------------∙
#Persistent
#SingleInstance, Force
SetTitleMatchMode 2

;;∙------------------------------------------------∙
browserExe := "msedge.exe"    ;;∙------∙Set Browser. (msedge.exe\firefox.exe\brave.exe\chrome.exe\etc.)
tabTitle := "YouTube"    ;;∙------∙Set Tab Title.

;;∙------------------------------------------------∙
SetTimer, YouCheck, 500    ;;∙------∙Set in milliseconds.
lastState := false    ;;∙------∙Track previous state.
lastWindow := ""    ;;∙------∙Tracks previously active window.
Return

;;∙------------------------------------------------∙
YouCheck:
    if WinExist("ahk_exe" browserExe)    ;;∙------∙Check if browserExe is running.
    {
        WinGetTitle, activeTitle, A
        WinGet, activeWindow, ProcessName, A    ;;∙------∙Get the active window's process name.

        if (activeWindow = browserExe)    ;;∙------∙If the browser is the active window.
        {
            if (InStr(activeTitle, tabTitle) && lastWindow != browserExe) 
            ;;∙------∙Run routine only if returning to browserExe and "tabTitle" tab is active.
            {
                SoundBeep, 1900, 750    ;;∙------∙Play sound when "tabTitle" tab is activated.
                MsgBox, YouTube Detected    ;;∙------∙Show message when "tabTitle" tab is detected.
                lastState := true    ;;∙------∙Set state to active.
            }
            else if (!InStr(activeTitle, tabTitle))
            {
                lastState := false    ;;∙------∙Reset state if "tabTitle" tab is not active.
            }
        }
        else
        {
            lastState := false    ;;∙------∙Reset state if browserExe is not the active window.
        }

        lastWindow := activeWindow    ;;∙------∙Update last active window.
    }
    else
    {
        lastState := false    ;;∙------∙Reset state if browserExe is completely closed.
        lastWindow := ""    ;;∙------∙Clear last window.
    }
Return
;;∙------------------------------------------------∙
;;∙============================================================∙
*/

















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

