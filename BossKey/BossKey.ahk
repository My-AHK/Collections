
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




;;∙============================================================∙
;;∙============================================================∙

;;∙------------∙Configuration.
CLOSE_TIMEOUT := 2000        ; Time to wait for graceful close (ms)
FORCE_CLOSE_TIMEOUT := 1000  ; Time to wait before force close (ms)
MAX_LOG_SIZE := 50000        ; Max log file size before rotation (bytes)

;;∙------------∙Whitelist of applications to never close (add process names without .exe).
PROTECTED_APPS := "keepass,keepassxc,bitwarden,1password,lastpass,dashlane,explorer,dwm,winlogon,csrss,lsass,services,smss,wininit"

;;∙------------∙Sound configuration.
SOUND_SUCCESS_FREQ := 800
SOUND_SUCCESS_DUR := 200
SOUND_PARTIAL_FREQ := 600
SOUND_PARTIAL_DUR := 300
SOUND_FAILURE_FREQ := 400
SOUND_FAILURE_DUR := 500

;;∙------------∙Global variables for button handlers.
CurrentReport := ""
CurrentLogFile := A_ScriptDir . "\ClosedWindowsLog.txt"

^t::    ;;∙------∙🔥∙(Ctrl + T) - Normal close
    close_windows_main(false)
Return

^+t::   ;;∙------∙🔥∙(Ctrl + Shift + T) - Dry run mode
    close_windows_main(true)
Return

close_windows_main(dryRun := false) {
    Soundbeep, 1000, 200
    
    modeText := dryRun ? " (DRY RUN - Preview Only)" : ""
    confirmText := dryRun ? "Preview what windows would be closed?" : "Close all open windows except the active one?"
    confirmText .= "`n`n• Hidden windows will be minimized`n• Protected apps will be skipped`n• Ctrl+Shift+T for dry run mode"
    
    MsgBox, 4, closeOTHERS%modeText%, %confirmText%
    IfMsgBox, No
        Return
    
    close_all_but_active(dryRun)
}

close_all_but_active(dryRun := false) {
    global CurrentReport, CurrentLogFile
    static ProgressBar, StatusText, ResultsEdit, WhitelistEdit
    
    keepThis := WinExist("A")
    if (!keepThis) {
        MsgBox, 48, closeOTHERS, No active window found!
        return
    }
    
    ;;∙------∙Get active window info.
    WinGetTitle, activeTitle, ahk_id %keepThis%
    WinGetClass, activeClass, ahk_id %keepThis%
    WinGet, activeProcess, ProcessName, ahk_id %keepThis%
    
    ;;∙------∙Show progress GUI.
    progressTitle := dryRun ? "Analyzing Windows (DRY RUN)" : "Processing Windows"
    Gui, Progress:New, +AlwaysOnTop -MaximizeBox -MinimizeBox, %progressTitle%
    Gui, Progress:Add, Text, w300 Center, Analyzing windows...
    Gui, Progress:Add, Progress, w300 h20 vProgressBar
    Gui, Progress:Add, Text, w300 Center vStatusText, Preparing...
    if (dryRun)
        Gui, Progress:Add, Text, w300 Center c0x0080FF, PREVIEW MODE - No windows will be closed
    Gui, Progress:Show, w320 h120
    
    ;;∙------∙Get all windows and group by process.
    WinGet, winList, List
    windowsByProcess := {}
    
    ;;∙------∙First pass: categorize all windows.
    Loop, %winList% {
        hwnd := winList%A_Index%
        if (hwnd = keepThis)
            continue
            
        WinGetClass, class, ahk_id %hwnd%
        WinGetTitle, title, ahk_id %hwnd%
        WinGet, processName, ProcessName, ahk_id %hwnd%
        
        ;;∙------∙Skip system windows.
        if class in Progman,WorkerW,Shell_TrayWnd,NotifyIconOverflowWindow,TaskListThumbnailWnd,MultitaskingViewFrame,Windows.UI.Core.CoreWindow,ApplicationFrameWindow
            continue
            
        ;;∙------∙Check visibility.
        WinGet, isVisible, Style, ahk_id %hwnd%
        isWindowVisible := !!(isVisible & 0x10000000)
        
        ;;∙------∙Store window info as simple variables (AHK v1.1 compatible).
        windowInfo := processName . "|" . hwnd . "|" . title . "|" . class . "|" . isWindowVisible
        
        if (!windowsByProcess[processName])
            windowsByProcess[processName] := ""
        windowsByProcess[processName] .= windowInfo . "`n"
    }
    
    ;;∙------∙Initialize result tracking.
    closedList := ""
    forceKillList := ""
    minimizedList := ""
    skippedList := ""
    protectedList := ""
    errorList := ""
    
    totalProcesses := 0
    for processName, windows in windowsByProcess {
        totalProcesses++
    }
    processedCount := 0
    
    ;;∙------∙Process each application group.
    for processName, windowData in windowsByProcess {
        processedCount++
        progress := Round((processedCount / totalProcesses) * 100)
        GuiControl, Progress:, ProgressBar, %progress%
        
        ;;∙------∙Count windows for this process.
        StringReplace, windowData, windowData, `n, `n, UseErrorLevel
        windowCount := ErrorLevel
        GuiControl, Progress:, StatusText, Processing: %processName% (%windowCount% windows)
        
        ;;∙------∙Check if process is protected.
        if IsProtectedApp(processName) {
            ;;∙------∙Parse window data and add to protected list.
            Loop, Parse, windowData, `n
            {
                if (A_LoopField = "")
                    continue
                StringSplit, parts, A_LoopField, |
                winTitle := parts3 ? parts3 : "[" . parts4 . "]"
                protectedList .= "• " . winTitle . " (" . processName . ")`n"
            }
            continue
        }
        
        ;;∙------∙Process windows in this group.
        Loop, Parse, windowData, `n
        {
            if (A_LoopField = "")
                continue
                
            ;;∙------∙Parse window info: processName|hwnd|title|class|visible.
            StringSplit, parts, A_LoopField, |
            winHwnd := parts2
            winTitle := parts3
            winClass := parts4
            winVisible := parts5
            
            windowTitle := winTitle ? winTitle : "[" . winClass . "]"
            
            if (!winVisible) {
                ;;∙------∙Handle invisible windows.
                if (!dryRun)
                    WinMinimize, ahk_id %winHwnd%
                minimizedList .= "• " . windowTitle . " (" . processName . ")`n"
                continue
            }
            
            ;;∙------∙For visible windows, simulate or perform close.
            if (dryRun) {
                ;;∙------∙Dry run - just categorize what would happen.
                WinGet, isMinimized, MinMax, ahk_id %winHwnd%
                if (isMinimized = -1) {
                    closedList .= "• " . windowTitle . " (" . processName . ") [Would restore & close]`n"
                } else {
                    closedList .= "• " . windowTitle . " (" . processName . ") [Would close]`n"
                }
            } else {
                ;;∙------∙Actually close the window.
                WinGet, isMinimized, MinMax, ahk_id %winHwnd%
                if (isMinimized = -1)
                    WinRestore, ahk_id %winHwnd%
                
                ;;∙------∙Try graceful close.
                WinClose, ahk_id %winHwnd%
                
                ;;∙------∙Wait for close with timeout.
                closeStart := A_TickCount
                while (WinExist("ahk_id " . winHwnd) && (A_TickCount - closeStart) < CLOSE_TIMEOUT) {
                    Sleep, 50
                }
                
                if WinExist("ahk_id " . winHwnd) {
                    ;;∙------∙Force close.
                    WinKill, ahk_id %winHwnd%
                    
                    forceStart := A_TickCount
                    while (WinExist("ahk_id " . winHwnd) && (A_TickCount - forceStart) < FORCE_CLOSE_TIMEOUT) {
                        Sleep, 50
                    }
                    
                    if WinExist("ahk_id " . winHwnd) {
                        errorList .= "• " . windowTitle . " (" . processName . ")`n"
                    } else {
                        forceKillList .= "• " . windowTitle . " (" . processName . ")`n"
                    }
                } else {
                    closedList .= "• " . windowTitle . " (" . processName . ")`n"
                }
            }
            
            Sleep, 10  ;;∙------∙Small delay between windows.
        }
    }
    
    ;;∙------∙Close progress GUI.
    Gui, Progress:Destroy
    
    ;;∙------∙Determine completion status and play appropriate sound.
    totalActions := CountLines(closedList) + CountLines(forceKillList) + CountLines(minimizedList)
    errorCount := CountLines(errorList)
    
    if (!dryRun) {
        if (errorCount = 0 && totalActions > 0) {
            ;;∙------∙Complete success.
            Soundbeep, %SOUND_SUCCESS_FREQ%, %SOUND_SUCCESS_DUR%
        } else if (errorCount > 0 && totalActions > 0) {
            ;;∙------∙Partial success.
            Soundbeep, %SOUND_PARTIAL_FREQ%, %SOUND_PARTIAL_DUR%
        } else {
            ;;∙------∙Failure or no actions.
            Soundbeep, %SOUND_FAILURE_FREQ%, %SOUND_FAILURE_DUR%
        }
    }
    
    ;;∙------∙Build comprehensive report.
    report := "=== WINDOW " . (dryRun ? "ANALYSIS" : "CLOSING") . " REPORT ===`n"
    report .= "Active Window Kept: " . (activeTitle ? activeTitle : "[" . activeClass . "]") . " (" . activeProcess . ")`n"
    if (dryRun)
        report .= "MODE: DRY RUN - No actions were performed`n"
    report .= "`n"
    
    if (closedList != "") {
        actionText := dryRun ? "WOULD BE CLOSED" : "GRACEFULLY CLOSED"
        report .= "✓ " . actionText . " (" . CountLines(closedList) . "):`n" . closedList . "`n"
    }
    if (forceKillList != "") {
        actionText := dryRun ? "WOULD BE FORCE CLOSED" : "FORCE CLOSED"
        report .= "⚠ " . actionText . " (" . CountLines(forceKillList) . "):`n" . forceKillList . "`n"
    }
    if (minimizedList != "") {
        actionText := dryRun ? "WOULD BE MINIMIZED" : "MINIMIZED"
        report .= "⬇ " . actionText . " (" . CountLines(minimizedList) . "):`n" . minimizedList . "`n"
    }
    if (protectedList != "") {
        report .= "🛡 PROTECTED (SKIPPED) (" . CountLines(protectedList) . "):`n" . protectedList . "`n"
    }
    if (errorList != "") {
        report .= "❌ FAILED TO CLOSE (" . CountLines(errorList) . "):`n" . errorList . "`n"
    }
    
    if (totalActions = 0 && CountLines(protectedList) = 0) {
        report .= "ℹ No closable windows found.`n"
    }
    
    ;;∙------∙Copy to clipboard and store in global variables for button access.
    Clipboard := report
    CurrentReport := report
    CurrentLogFile := A_ScriptDir . "\ClosedWindowsLog.txt"
    
    ;;∙------∙Show enhanced results GUI.
    guiTitle := dryRun ? "Window Analysis Results (DRY RUN)" : "Window Closing Results"
    Gui, Results:New, +AlwaysOnTop +Resize, %guiTitle%
    Gui, Results:Add, Edit, w600 h350 ReadOnly VScroll vResultsEdit, %report%
    Gui, Results:Add, Button, x10 y+10 w100 h30 Default gResultsOK, OK
    Gui, Results:Add, Button, x+10 w100 h30 gCopyReport, Copy Report
    Gui, Results:Add, Button, x+10 w100 h30 gOpenLog, View Log
    Gui, Results:Add, Button, x+10 w100 h30 gEditWhitelist, Edit Whitelist
    if (dryRun)
        Gui, Results:Add, Button, x+10 w100 h30 gRunActual, Run for Real
    Gui, Results:Add, Text, xp y+5, Report copied to clipboard
    Gui, Results:Show, x1100 y125 w620 h430
    GuiControl, Focus, Button1    ;;∙------∙Removes highlighting from text by switching focus.

    ;;∙------∙Enhanced logging (skip for dry runs).
    if (!dryRun) {
        FormatTime, timeStr,, yyyy-MM-dd HH:mm:ss
        
        FileGetSize, logSize, %CurrentLogFile%
        if (logSize > MAX_LOG_SIZE) {
            FileMove, %CurrentLogFile%, %A_ScriptDir%\ClosedWindowsLog_backup.txt
        }
        
        logEntry := "[" . timeStr . "] " . A_UserName . " on " . A_ComputerName . "`n"
        logEntry .= report . "`n" . StringRepeat("=", 60) . "`n`n"
        FileAppend, %logEntry%, %CurrentLogFile%
    }
    
    return
}

;;∙------------∙GLOBAL BUTTON EVENT HANDLERS (moved outside function).
ResultsOK:
Results:GuiClose:
    Gui, Results:Destroy
return

CopyReport:
    if (CurrentReport != "") {
        Clipboard := CurrentReport
        MsgBox, 64, , Report copied to clipboard!
    } else {
        MsgBox, 48, , No report available to copy. Run the script first!
    }
return

OpenLog:
    if FileExist(CurrentLogFile) {
        Run, notepad.exe "%CurrentLogFile%"
    } else {
        ;;∙------∙Create empty log file with header.
        FormatTime, timeStr,, yyyy-MM-dd HH:mm:ss
        logHeader := "=== WINDOW CLOSING LOG ===`n"
        logHeader .= "Created: " . timeStr . "`n"
        logHeader .= "User: " . A_UserName . " on " . A_ComputerName . "`n"
        logHeader .= StringRepeat("=", 60) . "`n`n"
        logHeader .= "No window closing operations have been performed yet.`n"
        logHeader .= "This log will be populated when you close windows using Ctrl+T.`n`n"
        
        FileAppend, %logHeader%, %CurrentLogFile%
        Run, notepad.exe "%CurrentLogFile%"
    }
return

EditWhitelist:
    ShowWhitelistEditor()
return

RunActual:
    Gui, Results:Destroy
    ;;∙------∙Skip confirmation dialog since user already confirmed in dry run.
    close_all_but_active(false)
return

;;∙------∙Check if an application is protected.
IsProtectedApp(processName) {
    StringLower, processName, processName
    processName := StrReplace(processName, ".exe", "")
    return InStr("," . PROTECTED_APPS . ",", "," . processName . ",") > 0
}

;;∙------∙Show whitelist editor.
ShowWhitelistEditor() {
    static WhitelistEdit
    
    Gui, Whitelist:New, +AlwaysOnTop, Edit Protected Applications
    Gui, Whitelist:Add, Text, w400, Protected applications (one per line, without .exe):
    Gui, Whitelist:Add, Edit, w400 h200 VScroll vWhitelistEdit, % StrReplace(PROTECTED_APPS, ",", "`n")
    Gui, Whitelist:Add, Button, x10 y+10 w100 h30 Default gSaveWhitelist, Save
    Gui, Whitelist:Add, Button, x+10 w100 h30 gCancelWhitelist, Cancel
    Gui, Whitelist:Add, Button, x+10 w100 h30 gResetWhitelist, Reset to Default
    Gui, Whitelist:Show, w420 h280
    return
}

;;∙------------∙GLOBAL WHITELIST BUTTON HANDLERS.
SaveWhitelist:
    GuiControlGet, newList, Whitelist:, WhitelistEdit
    PROTECTED_APPS := StrReplace(newList, "`n", ",")
    PROTECTED_APPS := RegExReplace(PROTECTED_APPS, ",+", ",")    ;;∙------∙Remove duplicate commas.
    PROTECTED_APPS := Trim(PROTECTED_APPS, ",")    ;;∙------∙Remove leading/trailing commas.
    MsgBox, 64, , Whitelist updated! Changes apply to current session only.
    Gui, Whitelist:Destroy
return

CancelWhitelist:
Whitelist:GuiClose:
    Gui, Whitelist:Destroy
return

ResetWhitelist:
    PROTECTED_APPS := "keepass,keepassxc,bitwarden,1password,lastpass,dashlane,explorer,dwm,winlogon,csrss,lsass,services,smss,wininit"
    GuiControl, Whitelist:, WhitelistEdit, % StrReplace(PROTECTED_APPS, ",", "`n")
return

;;∙------∙Helper functions
CountLines(str) {
    if (str = "")
        return 0
    StringReplace, str, str, `n, `n, UseErrorLevel
    return ErrorLevel
}

StringRepeat(str, count) {
    result := ""
    Loop, %count% {
        result .= str
    }
    return result
}

;;∙------∙Help hotkey.
^F1::
    helpText := "ENHANCED WINDOW CLOSER HELP`n`n"
    helpText .= "Hotkeys:`n"
    helpText .= "• Ctrl+T: Close all windows except active`n"
    helpText .= "• Ctrl+Shift+T: Dry run (preview only)`n"
    helpText .= "• Ctrl+F1: Show this help`n`n"
    helpText .= "Features:`n"
    helpText .= "• Protected app whitelist`n"
    helpText .= "• Window grouping by process`n"
    helpText .= "• Sound notifications`n"
    helpText .= "• Detailed logging`n"
    helpText .= "• Dry run mode for safety`n`n"
    helpText .= "The whitelist protects password managers and system processes."
    MsgBox, 64, Enhanced Window Closer Help, %helpText%
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

