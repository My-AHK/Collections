
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  SELF
» Original Source:  
» Run one or Multiple Actions @ Different Times w/Error Checking
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
;;∙======∙ENVIRONMENT∙==================================∙
#NoEnv
#Persistent
#SingleInstance, Force
SendMode Input
SetWorkingDir %A_ScriptDir%
ListLines, Off
SetBatchLines, -1
SetTimer, Check_Time, 1000    ;;∙------∙Check every second.
SetTimer, Midnight_Reset, 60000    ;;∙------∙Check for daily reset every 60s.

FlagFile := A_ScriptDir "\time_trigger_flags.txt"    ;;∙------∙Flag file to store executed times.
LogFile := A_ScriptDir "\time_trigger_log.txt"    ;;∙------∙Execution log file.

;;∙======∙CONFIGURATION∙================================∙
TargetActions := {}
TargetActions["8:01 PM"] := ["SoundBeep"]
TargetActions["8:02 PM"] := ["SoundBeep", "Delay:2000", "Reload"]
TargetActions["8:03 PM"] := ["notepad.exe", "Delay:1000", "SoundBeep"]
TargetActions["8:04 PM"] := ["SoundBeep", "Delay:1500", "SoundBeep", "Delay:1500", "https://www.google.com"]
TargetActions["8:05 PM"] := ["SoundBeep", "Delay:2500", "ExitApp"]

;;∙======∙STARTUP INITIALIZATION∙=========================∙
Validate_Configuration()    ;;∙------∙Validate Configuration On Startup.
ExecutedTimes := {}    ;;∙------∙Load Execution Flags.
Load_Flags()    ;;∙------∙"  "
LastResetDate := A_YYYY A_MM A_DD    ;;∙------∙Track Last Reset Date.

;;∙------------------------------------------------------------------------∙
;;∙----------------∙Manual Trigger For Testing∙---------------------∙
^!t::    ;;∙------∙🔥∙(Ctrl + Alt + T)🔥∙
    Log_Entry("Manual trigger invoked.")
    TestActions := ["SoundBeep", "Delay:1500", "Reload"]
    for index, act in TestActions
        Perform_Action(act)
Return
;;∙------------------------------------------------------------------------∙
;;∙------------------------------------------------------------------------∙

;;∙======∙MAIN CHECK ROUTINE∙===========================∙
Check_Time:
    FormatTime, FormattedTime, , h:mm tt    ;;∙------∙Convert to 12-hour format with AM/PM.
    if TargetActions.HasKey(FormattedTime)
    {
        if !ExecutedTimes.HasKey(FormattedTime)
        {
            ExecutedTimes[FormattedTime] := True
            Save_Flags()
            Log_Entry("Triggered at " FormattedTime)
            for index, act in TargetActions[FormattedTime]
                Perform_Action(act)
        }
    }
Return

;;∙======∙DAILY RESET AT MIDNIGHT∙========================∙
Midnight_Reset:
    CurrentDate := A_YYYY A_MM A_DD
    if (CurrentDate != LastResetDate)
    {
        ExecutedTimes := {}    ;;∙------∙Clear executed flags.
        Save_Flags()           ;;∙------∙Overwrite file with empty list.
        LastResetDate := CurrentDate
        Log_Entry("Daily reset performed. Flags cleared.")
    }
Return

;;∙======∙PERFORM ACTION OR DELAY∙======================∙
Perform_Action(action)
{
    if (SubStr(action, 1, 6) = "Delay:")
    {
        delayTime := SubStr(action, 7)
        if delayTime is not integer
        {
            Log_Entry("Error: Invalid delay time format - " action)
            return
        }
        if (delayTime < 0 or delayTime > 300000)  ;;∙------∙Max 5 minutes delay!
        {
            Log_Entry("Error: Delay time out of range (0-300000ms) - " delayTime)
            return
        }
        Log_Entry("Action: Delay for " delayTime " ms.")
        Sleep, %delayTime%
    }
    else if (action = "Reload")
    {
        Log_Entry("Action: Reloading script.")
        Reload
    }
    else if (action = "ExitApp")
    {
        Log_Entry("Action: Exiting script.")
        ExitApp
    }
    else if (action = "SoundBeep")
    {
        Log_Entry("Action: Beep executed.")
        SoundBeep, 750, 300
    }
    else
    {
        Log_Entry("Action: Running command - " action)
        Run, %action%, , , RunPID
        if ErrorLevel
        {
            Log_Entry("Error: Failed to execute command - " action " (ErrorLevel: " ErrorLevel ")")
        }
        else
        {
            Log_Entry("Success: Command executed with PID " RunPID)
        }
    }
}

;;∙======∙LOAD EXECUTION FLAGS FROM FILE∙===============∙
Load_Flags()
{
    global ExecutedTimes, FlagFile
    if FileExist(FlagFile)
    {
        FileRead, FileContents, %FlagFile%
        if ErrorLevel
        {
            Log_Entry("Error: Could not read flag file - " FlagFile " (ErrorLevel: " ErrorLevel ")")
            return
        }
        if (FileContents = "")
        {
            Log_Entry("Info: Flag file is empty, starting fresh.")
            return
        }
        Loop, Parse, FileContents, `n, `r
        {
            line := Trim(A_LoopField)
            if (line != "")
            {
                if Validate_Time_Format(line)
                    ExecutedTimes[line] := True
                else
                    Log_Entry("Warning: Invalid time format in flag file - " line)
            }
        }
        Log_Entry("Info: Loaded " ExecutedTimes.Count() " executed time flags.")
    }
    else
    {
        Log_Entry("Info: Flag file does not exist, starting fresh.")
    }
}

;;∙======∙SAVE EXECUTED FLAGS TO FILE∙====================∙
Save_Flags()
{
    global ExecutedTimes, FlagFile
    ;;∙------∙Create backup of existing file.
    if FileExist(FlagFile)
    {
        FileCopy, %FlagFile%, %FlagFile%.backup, 1
        if ErrorLevel
            Log_Entry("Warning: Could not create backup of flag file.")
    }
    ;;∙------∙Write new flag file.
    FileDelete, %FlagFile%
    if ErrorLevel and FileExist(FlagFile)
    {
        Log_Entry("Error: Could not delete existing flag file (ErrorLevel: " ErrorLevel ")")
        return
    }
    flagCount := 0
    for key, _ in ExecutedTimes
    {
        FileAppend, %key%`n, %FlagFile%
        if ErrorLevel
        {
            Log_Entry("Error: Could not write to flag file - " key " (ErrorLevel: " ErrorLevel ")")
            ;;∙------∙Restore backup if write failed.
            if FileExist(FlagFile . ".backup")
            {
                FileCopy, %FlagFile%.backup, %FlagFile%, 1
                Log_Entry("Info: Restored flag file from backup.")
            }
            return
        }
        flagCount++
    }
    Log_Entry("Info: Saved " flagCount " time flags to file.")
    ;;∙------∙Clean up backup file on success.
    if FileExist(FlagFile . ".backup")
        FileDelete, %FlagFile%.backup
}

;;∙======∙VALIDATE TIME FORMAT∙==========================∙
Validate_Time_Format(timeStr)
{
    ;;∙------∙Check basic format: H:MM AM/PM or HH:MM AM/PM.
    if !RegExMatch(timeStr, "^(1?\d):(0[0-9]|[1-5][0-9]) (AM|PM)$")
        return false
    ;;∙------∙Extract hour and minute.
    RegExMatch(timeStr, "^(\d{1,2}):(\d{2}) (AM|PM)$", match)
    hour := match1
    minute := match2
    period := match3
    ;;∙------∙Validate hour range.
    if (hour < 1 or hour > 12)
        return false
    ;;∙------∙Validate minute range.
    if (minute < 0 or minute > 59)
        return false
        return true
}

;;∙======∙VALIDATE CONFIGURATION ON STARTUP∙============∙
Validate_Configuration()
{
    global TargetActions
    errorCount := 0
    for timeStr, actions in TargetActions
    {
        ;;∙------∙Validate time format.
        if !Validate_Time_Format(timeStr)
        {
            Log_Entry("Error: Invalid time format in configuration - " timeStr)
            errorCount++
            continue
        }
        ;;∙------∙Validate actions array.
        if !IsObject(actions)
        {
            Log_Entry("Error: Actions for " timeStr " is not an array.")
            errorCount++
            continue
        }
        if (actions.Count() = 0)
        {
            Log_Entry("Warning: No actions defined for " timeStr)
            continue
        }

        ;;∙------∙Validate individual actions.
        for index, action in actions
        {
            if (action = "")
            {
                Log_Entry("Warning: Empty action found for " timeStr " at index " index)
            }
            else if (SubStr(action, 1, 6) = "Delay:")
            {
                delayTime := SubStr(action, 7)
                if delayTime is not integer
                {
                    Log_Entry("Error: Invalid delay format for " timeStr " - " action)
                    errorCount++
                }
            }
        }
    }
    if (errorCount > 0)
    {
        Log_Entry("Warning: " errorCount " configuration errors found. Script may not work as expected.")
        MsgBox, 48, Configuration Warning, %errorCount% configuration errors found.`n`nCheck the log file for details:`n%LogFile%
    }
    else
    {
        Log_Entry("Info: Configuration validation passed. " TargetActions.Count() " time triggers loaded.")
    }
}

;;∙======∙LOG ENTRIES WITH TIMESTAMP∙===================∙
Log_Entry(msg)
{
    global LogFile
    FormatTime, ts, , yyyy-MM-dd HH:mm:ss
    FileAppend, [%ts%] %msg%`n, %LogFile%
    if ErrorLevel
    {
        ;;∙------∙If log file fails, try to show message box as fallback.
        MsgBox, 16, Logging Error, Could not write to log file:`n%LogFile%`n`nMessage: %msg%
    }
}

;;∙======∙CLEAN EXIT ON SCRIPT CLOSE∙=====================∙
OnExit, Handle_Exit
Handle_Exit:
    Save_Flags()
    Log_Entry("Script terminated cleanly.")
ExitApp
;;∙============================================================∙

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

