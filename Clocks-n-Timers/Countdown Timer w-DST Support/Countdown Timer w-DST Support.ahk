
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  Self
» Original Source:  
» Countdown Timer with DST Support
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




;;∙======∙TARGET DATE AND TIME CONFIGURATION∙============∙
;;∙------∙Change these variables to set your desired countdown target.
TargetYear := 2025
TargetMonth := 07
TargetDay := 04
TargetHour := 00    ;;∙------∙24-hour format (0-23).
TargetMinute := 00
TargetSecond := 00

Event := "Your Event of the Moment!!"

;;∙------∙DISPLAY CONFIGURATION.
WindowTitle := "Countdown Until"
UpdateInterval := 500    ;;∙------∙Update every 500ms for smooth display.
guiW := 300    ;;∙------∙Text Centering.

;;∙======∙MAIN SCRIPT EXECUTION∙==========================∙
;;∙------∙Create the target timestamp.
TargetTime := TargetYear . Format("{:02d}", TargetMonth) . Format("{:02d}", TargetDay) . Format("{:02d}", TargetHour) . Format("{:02d}", TargetMinute) . Format("{:02d}", TargetSecond)

Gui, +AlwaysOnTop -Caption +Border +Owner
Gui, Color, Black
Gui, Font, s12 q5, Segoe UI
Gui, Add, Text, x0 y15 w%guiW% h25 cRed vCountdownText Center, Calculating...
Gui, Add, Text, x0 y+10 w%guiW% h50 cYellow vTargetText Center, %Event% `n %TargetMonth%/%TargetDay%/%TargetYear% at %TargetHour%:%TargetMinute%:%TargetSecond%
Gui, Add, Text, x0 y+10 w%guiW% h50 cAqua vStatusText Center, 
Gui, Show, x1500 y400 w%guiW%, %WindowTitle%

;;∙------∙Start the timer.
SetTimer, UpdateCountdown, %UpdateInterval%

;;∙------∙Initial update.
Gosub, UpdateCountdown
Return

;;∙======∙COUNTDOWN UPDATE ROUTINE∙====================∙
UpdateCountdown:
    ;;∙------∙Get current time with high precision.
    FormatTime, CurrentTime, , yyyyMMddHHmmss
    
    ;;∙------∙Calculate difference in seconds with DST awareness.
    DiffSeconds := TargetTime
    EnvSub, DiffSeconds, %CurrentTime%, Seconds
    
    if (DiffSeconds <= 0) {
        ;;∙------∙Timer has expired.
        GuiControl,, CountdownText, TIME'S UP BITCHES!
        GuiControl,, StatusText, Target Time Has Been Reached!!
        SetTimer, UpdateCountdown, Off
        
        ;;∙------∙Optional: Play system sound or show message.
        SoundPlay, *48    ;;∙------∙Windows exclamation sound.
        return
    }
    
        ;;∙------∙Calculate time components (Days/Hours/Minutes/Seconds only).
        TotalSeconds := DiffSeconds
        ;;∙------∙Days.
        Days := Floor(TotalSeconds / 86400)
        RemainingSeconds := Mod(TotalSeconds, 86400)
        ;;∙------∙Hours.
        Hours := Floor(RemainingSeconds / 3600)
        RemainingSeconds := Mod(RemainingSeconds, 3600)
        ;;∙------∙Minutes.
        Minutes := Floor(RemainingSeconds / 60)
        ;;∙------∙Seconds.
        Seconds := Mod(RemainingSeconds, 60)
    
    ;;∙------∙Format the countdown display as Days/Hours/Minutes/Seconds.
    CountdownDisplay := ""
    if (Days > 0)
        CountdownDisplay .= Days . " Day" . (Days != 1 ? "s" : "") . " "

    ;;∙------∙Always show hours, minutes, and seconds in HH:MM:SS format.
    CountdownDisplay .= Format("{:02d}", Hours) . ":" . Format("{:02d}", Minutes) . ":" . Format("{:02d}", Seconds)

    ;;∙------∙Update GUI.
    GuiControl,, CountdownText, %CountdownDisplay%

    ;;∙------∙Show formatted time remaining in status.
    StatusDisplay := ""
    if (Days > 0)
    StatusDisplay .= "Only " Days . " day" . (Days != 1 ? "s" : "") . ", "
    StatusDisplay .= Hours . " hour" . (Hours != 1 ? "s" : "") . ", "
    StatusDisplay .= Minutes . " minute" . (Minutes != 1 ? "s" : "") . "`n and "
    StatusDisplay .= Seconds . " second" . (Seconds != 1 ? "s" : "") . " remaining."
    GuiControl,, StatusText, %StatusDisplay%
Return

;;∙======∙GUI EVENT HANDLER∙==============================∙
GuiClose:
    Reload
Return

;;∙======∙🔥∙HOTKEYS∙🔥∙====================================∙
Esc::ExitApp

F5::    ;;∙------∙F5 to refresh/restart countdown.
    SetTimer, UpdateCountdown, Off
    SetTimer, UpdateCountdown, %UpdateInterval%
    Gosub, UpdateCountdown
Return

;;∙======∙UTILITY FUNCTIONS∙==============================∙
IsLeapYear(Year) {    ;;∙------∙Function to check if a year is a leap year.
    return (Mod(Year, 4) = 0 && Mod(Year, 100) != 0) || (Mod(Year, 400) = 0)
}

GetDaysInMonth(Year, Month) {    ;;∙------∙Function to get days in a specific month.
    DaysInMonth := [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    if (Month = 2 && IsLeapYear(Year))
        return 29
    else
        return DaysInMonth[Month]
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

