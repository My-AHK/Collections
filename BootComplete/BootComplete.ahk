
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
» 
    ▹ 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "BootComplete"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙




;;∙============================================================∙
#NoEnv
#Persistent 
#SingleInstance, Force
;;∙------------------------------------------------∙
^t::    ;;∙------∙🔥∙(Ctrl+T)
   SoundBeep, 1100, 200
    global startTime := A_TickCount    ;;∙------∙Track start time.
    Menu, Tray, Icon, actioncentercpl.dll, 2    ;;∙------∙Green.
    SetTimer, CheckStartup, 1500
Return


;;∙------------------------------------------------∙
CheckStartup() {  		;;∙------∙Remove/Add processes as needed.
static startupProcesses := ["explorer.exe"  		;;∙------∙Windows Explorer.
    	        	    , "OneDrive.exe"  			;;∙------∙Microsoft OneDrive.
    	        	    , "SecurityHealthSystray.exe"   	;;∙------∙Windows Security Health.
    	        	    , "Ditto.exe"  			;;∙------∙Clipboard Manager.
    	        	    , "FSCapture.exe"]  		;;∙------∙Screen Capture Utility.
;;∙------------------------------------------------∙
    static cpuThreshold := 17    ;;∙------∙CPU threshold limit (set as needed).
    static diskThreshold := 10    ;;∙------∙Disk threshold limit (set as needed).

    static retryCount := 0    ;;∙------∙Initialize retry counter.
    static maxRetries := 2    ;;∙------∙Maximum allowed retry attempts (adjust as needed).
    static retryDelay := 2000    ;;∙------∙2 second delay between retries (adjust as needed).

    missingProcesses := ""    ;;∙------∙Track missing processes.
;;∙------------------------------------------------∙
    if !AllProcessesLoaded(startupProcesses, missingProcesses) {    ;;∙------∙Pass missingProcesses by reference.
        if (retryCount >= maxRetries) {
            Gui +OwnDialogs    ;;∙------∙Prevent taskbar button.
            ;;∙------∙Calculate elapsed time since hotkey was pressed.
            elapsedTime := (A_TickCount - startTime) / 1000    ;;∙------∙Convert milliseconds to seconds.
            ;;∙------∙Format time string based on elapsed time
            if (elapsedTime >= 60) {
                minutes := Floor(elapsedTime / 60)
                seconds := Round(Mod(elapsedTime, 60), 1)
                minuteText := (minutes = 1) ? "minute" : "minutes"
                timeString := (seconds = 0) ? minutes " " minuteText : minutes " " minuteText " and " seconds " seconds"
            } else {
                timeString := Round(elapsedTime, 1) " seconds"
            }
            ClipBoard := "Critical Processes Missing After...`n" . maxRetries . " Attempts In " . timeString . "`n`n" . missingProcesses
            Menu, Tray, Icon, actioncentercpl.dll, 3    ;;∙------∙Yellow.
            MsgBox, 4144,, Critical Processes Missing After...`n %maxRetries% Attempts In %timeString%`n`n%missingProcesses%, 15
            Reload    ;;∙------∙(For testing/troubleshooting)∙--∙(Comment for production)(!X!X!X!X!)
            ;;∙------∙ExitApp    ;;∙------∙(Uncomment for production)(!X!X!X!X!)
        }
        retryCount++    ;;∙------∙Increment retry counter.
        ;;∙------∙SoundBeep, 1500, 250    ;;∙------∙Retry verification.
        SetTimer, CheckStartup, %retryDelay%    ;;∙------∙Slow down retry checks.
        return
    }
    SetTimer, CheckStartup, 1500    ;;∙------∙Restore original speed.
    if !SystemIdle(cpuThreshold, diskThreshold)    ;;∙------∙Verify system resources are below thresholds and pass both to SystemIdle.
        return
    Gui +OwnDialogs
    MsgBox, 4096,, Startup completed successfully!, 3
    ExitApp
}

AllProcessesLoaded(processList, ByRef missingProcesses) {    ;;∙------∙ByRef parameter.
    missingProcesses := ""    ;;∙------∙Reset missing list.
    for _, process in processList {
        if !ProcessExists(process) {
            missingProcesses .= "• " process "`n"    ;;∙------∙Add bullet to each process.
        }
    }
    missingProcesses := RTrim(missingProcesses, "`n")    ;;∙------∙Remove trailing newline.
    return (missingProcesses == "")    ;;∙------∙Returns boolean true only if no missing processes.
}

ProcessExists(name) {
    Process, Exist, %name%    ;;∙------∙Process check.
    return ErrorLevel    ;;∙------∙Returns PID if exists.
}

SystemIdle(cpuThreshold, diskThreshold) {
    cpu  := GetCPUUsage()
    disk := GetDiskUsage()
    return (cpu < cpuThreshold && disk < diskThreshold)    ;;∙------∙Individual comparisons.
}

GetCPUUsage() {
    cpuUsage := 0    ;;∙------∙Initialize CPU usage to 0.
    try {
        wmi := ComObjGet("winmgmts:")
    } catch e {
        errMsg := e.Message
        Gui +OwnDialogs
        ClipBoard := "Failed to initialize WMI service for CPU usage.`nError: " . errMsg
        Menu, Tray, Icon, actioncentercpl.dll, 4    ;;∙------∙Red.
        MsgBox, 16, Error, Failed to initialize WMI service for CPU usage.`nError: %errMsg%, 5
        return cpuUsage
    }

    try {
        query := wmi.ExecQuery("SELECT PercentProcessorTime FROM Win32_PerfFormattedData_PerfOS_Processor WHERE Name='_Total'")
    } catch e {
        errMsg := e.Message
        Gui +OwnDialogs
        ClipBoard := "Failed to execute CPU usage query.`nError: " . errMsg
        Menu, Tray, Icon, actioncentercpl.dll, 4    ;;∙------∙Red.
        MsgBox, 16, Error, Failed to execute CPU usage query.`nError: %errMsg%, 5
        return cpuUsage
    }

    try {
        for obj in query {
            cpuUsage := obj.PercentProcessorTime    ;;∙------∙Extract CPU usage percentage.
        }
    } catch e {
        errMsg := e.Message
        Gui +OwnDialogs
        ClipBoard := "Failed to parse CPU usage data.`nError: " . errMsg
        Menu, Tray, Icon, actioncentercpl.dll, 4    ;;∙------∙Red.
        MsgBox, 16, Error, Failed to parse CPU usage data.`nError: %errMsg%, 5
        return cpuUsage
    }
    return cpuUsage
}

GetDiskUsage() {
    diskUsage := 0    ;;∙------∙Initialize disk usage to 0.
    try {
        wmi := ComObjGet("winmgmts:")
    } catch e {
        errMsg := e.Message
        Gui +OwnDialogs
        ClipBoard := "Failed to initialize WMI service for Disk usage.`nError: " . errMsg
        Menu, Tray, Icon, actioncentercpl.dll, 4    ;;∙------∙Red.
        MsgBox, 16, Error, Failed to initialize WMI service for Disk usage.`nError: %errMsg%, 5
        return diskUsage
    }

    try {
        query := wmi.ExecQuery("SELECT PercentDiskTime FROM Win32_PerfFormattedData_PerfDisk_PhysicalDisk WHERE Name='_Total'")
    } catch e {
        errMsg := e.Message
        Gui +OwnDialogs
        ClipBoard := "Failed to execute Disk usage query.`nError: " . errMsg
        Menu, Tray, Icon, actioncentercpl.dll, 4    ;;∙------∙Red.
        MsgBox, 16, Error, Failed to execute Disk usage query.`nError: %errMsg%, 5
        return diskUsage
    }

    try {
        for obj in query {
            diskUsage := obj.PercentDiskTime    ;;∙------∙Extract disk usage percentage.
        }
    } catch e {
        errMsg := e.Message
        Gui +OwnDialogs
        ClipBoard := "Failed to parse Disk usage data.`nError: " . errMsg
        Menu, Tray, Icon, actioncentercpl.dll, 4    ;;∙------∙Red.
        MsgBox, 16, Error, Failed to parse Disk usage data.`nError: %errMsg%, 5
        return diskUsage
    }
    return diskUsage
}
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
BootComplete:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

