
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  PhiLho
» Original Source:  https://www.autohotkey.com/board/topic/7022-acbattery-status/
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

;;∙======∙HotKey∙===============================================∙
^t::    ;;∙------∙🔥∙(Ctrl + T)
    Soundbeep, 1000, 200
;;∙============================================================∙




;;∙============================================================∙
;;∙============================================================∙
/*∙------∙System Power Status Monitor∙------------∙
Retrieves and displays detailed system power information using Windows API GetSystemPowerStatus.

Features:
    ▹ AC power connection status interpretation.
    ▹ Battery charge state and capacity description.
    ▹ Battery life percentage formatting.
    ▹ Estimated remaining and full battery life formatted output.

Includes:
    ▹ Utility functions for extracting integers from memory buffer.
    ▹ Time formatting function for battery life durations.

Requirements:
    ▹ AutoHotkey v1.1 or later.
    ▹ Windows OS supporting GetSystemPowerStatus API.
∙-------------------------------------------------------------∙
*/


#SingleInstance Force
#Persistent
#NoEnv
SetBatchLines, -1

;;∙------∙Allocate buffer for SYSTEM_POWER_STATUS structure (12 bytes total).
VarSetCapacity(powerStatus, 12)

;;∙------∙Call WinAPI to retrieve power information.
success := DllCall("GetSystemPowerStatus", "UInt", &powerStatus)

If (ErrorLevel != 0 or success = 0)
{
    MsgBox 16, Power Status, Can't get the power status..., 5
    ExitApp
}

;;∙------∙Extract struct members from the buffer.
acLineStatus 	:= GetInteger(powerStatus, 0, false, 1)
batteryFlag 	:= GetInteger(powerStatus, 1, false, 1)
batteryLifePercent 	:= GetInteger(powerStatus, 2, false, 1)
batteryLifeTime 	:= GetInteger(powerStatus, 4, true)
batteryFullLifeTime 	:= GetInteger(powerStatus, 8, true)

;;∙------∙Interpret AC line status.
If (acLineStatus = 0)
    acLineStatus := "Offline"
Else If (acLineStatus = 1)
    acLineStatus := "Online"
Else If (acLineStatus = 255)
    acLineStatus := "Unknown"

;;∙------∙Interpret battery flag.
If (batteryFlag = 0)
    batteryFlag := "Not being charged - Between 33 and 66 percent"
Else If (batteryFlag = 1)
    batteryFlag := "High - More than 66 percent"
Else If (batteryFlag = 2)
    batteryFlag := "Low - Less than 33 percent"
Else If (batteryFlag = 4)
    batteryFlag := "Critical - Less than 5 percent"
Else If (batteryFlag = 8)
    batteryFlag := "Charging"
Else If (batteryFlag = 128)
    batteryFlag := "No system battery"
Else If (batteryFlag = 255)
    batteryFlag := "Unknown"

;;∙------∙Format battery life percentage.
If (batteryLifePercent = 255)
    batteryLifePercent := "Unknown"
Else
    batteryLifePercent := batteryLifePercent . "`%"

;;∙------∙Format estimated battery times.
If (batteryLifeTime = -1)
    batteryLifeTime := "Unknown"
Else
    batteryLifeTime := GetFormatedTime(batteryLifeTime)

If (batteryFullLifeTime = -1)
    batteryFullLifeTime := "Unknown"
Else
    batteryFullLifeTime := GetFormatedTime(batteryFullLifeTime)

;;∙------∙Build and show output.
output := "AC Status: " . acLineStatus . "`n"
        . "Battery state and capacity: " . batteryFlag . "`n"
        . "Battery Life: " . batteryLifePercent . "`n"
        . "Remaining Battery Life: " . batteryLifeTime . "`n"
        . "Full Battery Life: " . batteryFullLifeTime

MsgBox, 64, Power Status, %output%, 5
Return


;;∙========∙FUNCTIONS∙================∙
GetInteger(ByRef source, offset = 0, bIsSigned = false, size = 4)
{
    local result := 0
    Loop % size    ;;∙------∙Build the integer by accumulating bytes.
    {
        result += *( &source + offset + A_Index - 1 ) << (8 * (A_Index - 1))
    }

    If (!bIsSigned or size > 4 or result < 0x80000000)
        Return result

    return -(0xFFFFFFFF - result + 1)
}

GetFormatedTime(seconds)
{
    local h, m, s, t := ""

    h := seconds // 3600
    seconds -= h * 3600

    m := seconds // 60
    s := seconds - (m * 60)

    If (h > 1)
        t := h . " hours"
    Else If (h = 1)
        t := "1 hour"

    If (t != "" and m + s > 0)
        t .= " "

    If (m > 1)
        t .= m . " minutes"
    Else If (m = 1)
        t .= "1 minute"

    If (t != "" and s > 0)
        t .= " "

    If (s > 1)
        t .= s . " seconds"
    Else If (s = 1)
        t .= "1 second"
    Else If (t = "")
        t := "0 seconds"

    return t
}
Return
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

