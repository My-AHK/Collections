
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
;;∙======∙🔥 HotKey 🔥∙===========================================∙
;^t::    ;;∙------∙(Ctrl+T) 
;    Soundbeep, 1000, 200
;;∙============================================================∙




;;∙============================================================∙
;;∙========∙CONFIGURATION SECTION∙========================∙

;;∙------∙Chime Settings.
HourlyBeepFreq := 1500    ;;∙------∙Frequency for hourly chime sound.
HourlyBeepDuration := 2500    ;;∙------∙Duration (in milliseconds) for hourly chime sound.

HalfHourlyBeepFreq := 1200    ;;∙------∙Frequency for 1/2 hour chime sound.
HalfHourlyBeepDuration := 1500    ;;∙------∙Duration (in milliseconds) for 1/2 hour chime sound.

QuarterHourlyBeepFreq := 1000    ;;∙------∙Frequency for 15 & 45-minute chime sound.
QuarterHourlyBeepDuration := 750    ;;∙------∙Duration (in milliseconds) for 15 & 45 minute chime sound.

;;∙------∙Alarm Settings.
AlarmEnabled := true    ;;∙------∙Set to 'false' to disable alarm functionality.
AlarmHour := 9    ;;∙------∙Hour (in 24-hour format) for alarm to trigger.
AlarmMinute := 26    ;;∙------∙Minute for alarm to trigger.
AlarmBeepFreq := 1400    ;;∙------∙Frequency for alarm sound.
AlarmBeepDuration := 500    ;;∙------∙Duration (in milliseconds) for each alarm beep.
AlarmRepeat := 3    ;;∙------∙Number of consecutive beeps for alarm.

;;∙------∙Timing Setting.
AlertWindow := 15    ;;∙------∙Time (in seconds) after minute starts during which alerts are allowed.

;;∙------∙ToolTip Removal Time.
TtRT := 2500    ;;∙------∙Time to display ToolTips.

;;∙------∙Testing Hotkeys∙🔥(Ctrl + Alt + 1/2/3/4)🔥∙
EnableTestHotkeys := true    ;;∙------∙Set to 'false' to disable testing hotkeys.

;;∙========∙RUNTIME SECTION∙===============================∙

#Persistent    ;;∙------∙Keep script running in background.
SetTimer, CheckTime, 1000    ;;∙------∙Call the 'CheckTime' label every 1 second.
LastBeepMinute := -1    ;;∙------∙Initialize variable to track last minute a chime was played.
LastAlarmDate := "none"    ;;∙------∙Initialize variable to track last date alarm was triggered.

;;∙------∙Hour + minute tracking variables.
LastBeepTime := "none"    ;;∙------∙Tracks HHMM format for accurate hourly checks.
LastBeepDate := "none"    ;;∙------∙Handles midnight reset.
Return

;;∙------∙Sound Testing Hotkeys.
if (EnableTestHotkeys)    ;;∙------∙Check if testing hotkeys are enabled.
{
    ;;∙------∙🔥∙(Ctrl + Alt + 1) Test hourly chime sound.
    ^!1::
        FormatTime, CurrentTime,, HH:mm
        ToolTip, Hourly Test Chime at`n`t %CurrentTime%
        SetTimer, ClearTip, % -TtRT
        SoundBeep, % HourlyBeepFreq, HourlyBeepDuration
    Return

    ;;∙------∙🔥∙(Ctrl + Alt + 2) Test 1/2 hourly chime sound.
    ^!2::
        FormatTime, CurrentTime,, HH:mm
        ToolTip, 1/2 Hourly Test Chime at`n`t %CurrentTime%
        SetTimer, ClearTip, % -TtRT
        SoundBeep, % HalfHourlyBeepFreq, HalfHourlyBeepDuration
    Return

    ;;∙------∙🔥∙(Ctrl + Alt + 3) Test 15 & 45-minute chime sound.
    ^!3::
        FormatTime, CurrentTime,, HH:mm
        ToolTip, 1/4 Hourly Test Chime at`n`t %CurrentTime%
        SetTimer, ClearTip, % -TtRT
        SoundBeep, % QuarterHourlyBeepFreq, QuarterHourlyBeepDuration
    Return

    ;;∙------∙🔥∙(Ctrl + Alt + 4) Test alarm chime sequence.
    ^!4::
        FormatTime, CurrentTime,, HH:mm
        ToolTip, Alarm Test At`n`t %CurrentTime%
        SetTimer, ClearTip, % -TtRT
        Loop % AlarmRepeat {
            SoundBeep, % AlarmBeepFreq, AlarmBeepDuration
            Sleep 150
        }
    return
}

CheckTime:
    ;;∙------∙Get padded time components.
    FormatTime, CurrentHour,, HH    ;;∙------∙24-hour format with leading zero.
    FormatTime, CurrentMinute,, mm    ;;∙------∙Minute with leading zero.
    CurrentSecond := A_Sec
    CurrentDate := A_YYYYMMDD
    
    ;;∙------∙Create unique time identifier.
    CurrentTimeKey := CurrentHour . CurrentMinute    ;;∙------∙HHMM format.

    ;;∙------∙Midnight reset.
    if (CurrentDate != LastBeepDate) {
        LastBeepTime := "none"
        LastBeepDate := CurrentDate
    }

    if (CurrentSecond > AlertWindow)    ;;∙------∙Skip if current second is outside alert window.
        return

    if CurrentMinute in 00,15,30,45    ;;∙------∙Padded string format.
    {
        ;;∙------∙Compare full hour + minute.
        if (CurrentTimeKey != LastBeepTime)    ;;∙------∙Ensure chime is only played once per hour + minute.
        {
            if (CurrentMinute = "00") {    ;;∙------∙String comparison for padded value.
                FormatTime, CurrentTime,, HH:mm    ;;∙------∙Display time.
                ToolTip, Hourly Chime at`n`t %CurrentTime%
                SetTimer, ClearTip, % -TtRT
                SoundBeep, % HourlyBeepFreq, HourlyBeepDuration
            }
            else if (CurrentMinute = "30") {    ;;∙------∙Play 1/2 hour chime at 30-minute mark.
                FormatTime, CurrentTime,, HH:mm    ;;∙------∙Display time.
                ToolTip, 1/2 Hourly Chime at`n`t %CurrentTime%
                SetTimer, ClearTip, % -TtRT
                SoundBeep, % HalfHourlyBeepFreq, HalfHourlyBeepDuration
            }
            else {    ;;∙------∙Play 1/4 hour chimes at 15 & 45-minute marks.
                FormatTime, CurrentTime,, HH:mm    ;;∙------∙Display time.
                ToolTip, 1/4 Hourly Chime at`n`t %CurrentTime%
                SetTimer, ClearTip, % -TtRT
                SoundBeep, % QuarterHourlyBeepFreq, QuarterHourlyBeepDuration
            }
            LastBeepTime := CurrentTimeKey    ;;∙------∙Update tracking with full time.
        }
    }
    else
    {
        LastBeepTime := "none"    ;;∙------∙Reset outside chime minutes.
    }

;;∙========∙ALARM SECTION∙=================================∙

    if (AlarmEnabled)    ;;∙------∙Check if alarm is enabled.
    {
        CurrentDate := A_YYYYMMDD    ;;∙------∙Get current date in YYYYMMDD format.
        ;;∙------∙Reset alarm trigger if date has changed.
        if (CurrentDate != LastAlarmDate)
        {
            LastAlarmDate := CurrentDate
            AlarmTriggered := false
        }
        
        ;;∙------∙Check if current time matches alarm time and alarm hasn't been triggered yet.
        if (A_Hour = AlarmHour && A_Min = AlarmMinute && !AlarmTriggered)
        {
            FormatTime, CurrentTime,, HH:mm    ;;∙------∙Display time.
            ToolTip, Alarm Triggered at`n`t %CurrentTime%
            SetTimer, ClearTip, % -TtRT
            ;;∙------∙Loop to play alarm beep multiple times.
            Loop % AlarmRepeat
            {
                SoundBeep, % AlarmBeepFreq, AlarmBeepDuration    ;;∙------∙Play alarm beep.
                Sleep 150    ;;∙------∙Pause for 150ms between beeps.
            }
            AlarmTriggered := true    ;;∙------∙Mark alarm as triggered.
        }
    }
Return

ClearTip:    ;;∙------∙Clear the tooltip.
    ToolTip
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
Menu, Tray, Icon, shell32.dll, 266    ;;∙------∙Sets the system tray icon.
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

