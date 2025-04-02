
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
;GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙🔥 HotKey 🔥∙===========================================∙
;^t::    ;;∙------∙(Ctrl+T) 
;    Soundbeep, 1000, 200
;;∙============================================================∙




;;∙============================================================∙
;;∙============================================================∙
#Persistent
#SingleInstance, Force
SetBatchLines, -1
ListLines, Off
OnExit, ExitSub
Process, Priority,, High

;;∙====================== CONFIGURATION ======================∙
global g_Elevating := false
global config := { refreshInterval: 60000     ;;∙------∙Base refresh interval (ms).
                , activePriority: "High"    ;;∙------∙Priority for active process.
                , othersPriority: "BelowNormal"    ;;∙------∙Priority for others.
                , logLevel: 2    ;;∙------∙0=Errors, 1=Info, 2=Debug.
                , logFile: "ProcessPriorityManager.log"
                , logMaxSizeMB: 10    ;;∙------∙Rotate logs after 10 MB.
                , whitelist: ["explorer.exe", "dwm.exe", "csrss.exe", "winlogon.exe", "System"
                            , "NortonUI.exe", "NortonSvc.exe", "aswEngSrv.exe", "aswidsagent.exe", "AvDump.exe"
                            , "svchost.exe", "RuntimeBroker.exe", "smartscreen.exe", "SearchApp.exe"
                            , "TextInputHost.exe", "conhost.exe", "sihost.exe", "taskhostw.exe"
                            , "System", "csrss.exe", "wininit.exe", "smss.exe", "CompPkgSrv.exe"
                            , "ctfmon.exe", "msedgewebview2.exe", "SearchProtocolHost.exe", "dllhost.exe"
                            , "SearchFilterHost.exe", "CompPkgSrv.exe", "SecurityHealthSystray.exe"
                            , "HPAudioSwitch.exe", "AMDRSServ.exe", "RtkAudUService64.exe"]
                , blacklist: [] }    ;;∙------∙Regex patterns.

;;∙==================== ADMIN CHECK =========================∙
R_CheckAdmin()

;;∙==================== GLOBAL VARIABLES =====================∙
global procIDList := {}
global wPID_old := ""
global dynamicTimer := config.refreshInterval
global lastActivity := A_TickCount
global isPaused := false
global processing := false

;;∙===================== MAIN ROUTINES =======================∙
R_GetProcessFullList() {
    global procIDList, config
    static lastRefresh := 0
    if (A_TickCount - lastRefresh < 5000)
        return
    lastRefresh := A_TickCount

    R_Log("Refreshing process list...", 2)
    procIDList := {}
    
    TH32CS_SNAPPROCESS := 0x2
    snapshot := DllCall("CreateToolhelp32Snapshot", "UInt", TH32CS_SNAPPROCESS, "UInt", 0, "Ptr")
    if (snapshot == -1) {
        R_Log("CreateToolhelp32Snapshot failed! Error: " A_LastError, 0)
        return
    }
    
    procEntrySize := A_PtrSize == 8 ? 568 : 556
    exeOffset := A_PtrSize == 8 ? 44 : 36
    
    VarSetCapacity(PROCESSENTRY32W, procEntrySize, 0)
    NumPut(procEntrySize, PROCESSENTRY32W, 0, "UInt")
    
    if !DllCall("Process32FirstW", "Ptr", snapshot, "Ptr", &PROCESSENTRY32W) {
        DllCall("CloseHandle", "Ptr", snapshot)
        R_Log("Process32FirstW failed! Error: " A_LastError, 0)
        return
    }
    
    Loop {
        pid := NumGet(PROCESSENTRY32W, 8, "UInt")
        ppid := NumGet(PROCESSENTRY32W, 16, "UInt")
        
        exePath := StrGet(&PROCESSENTRY32W + exeOffset, 260, "UTF-16")
        SplitPath, exePath, exeName
        
        if (exeName == "" && pid == 4)
            exeName := "System"
        
        procIDList[pid] := exeName ? exeName : "Unknown"

        ;;∙------∙Log each process at debug level.
        if (config.logLevel >= 2) {
            R_Log("Found process: " exeName " (PID: " pid ")", 2)
        }
        
        if !DllCall("Process32NextW", "Ptr", snapshot, "Ptr", &PROCESSENTRY32W)
            break
    }
    
    DllCall("CloseHandle", "Ptr", snapshot)
    R_Log("Process list refreshed. Found " procIDList.Count() " processes.", 1)
}


R_SetProcessPrio(pProcID, pState := "Normal", forceReset := false) {
    global procIDList, config, wPID_old
    
    if (pProcID == "*") {
        R_Log("=== STARTING SYSTEM-WIDE PRIORITY RESET ===", 1)
        ownPID := DllCall("GetCurrentProcessId")
        resetCount := 0
        skippedCount := 0
        failedCount := 0
        securityBlockCount := 0

        for pID, pName in procIDList {
        ;;∙------∙Skip self and non-existent processes.
            if (pID == ownPID || !R_ProcessExists(pID)) {
                skippedCount++
                continue
            }

        ;;∙------∙Security software protection.
            if (R_IsSecuritySoftware(pName)) {
                securityBlockCount++
                R_Log("Security block: " pName " (" pID ")", 1)
                continue
            }

        ;;∙------∙Whitelist check.
            if (R_IsWhitelisted(pName)) {
                skippedCount++
                continue
            }

            ;;∙------∙Get current priority with security check.
            oldPriority := R_GetProcessPriority(pID)
            if (oldPriority == "Protected") {
                securityBlockCount++
                continue
            }

            ;;∙------∙Attempt priority change.
            Process, Priority, % pID, % pState
            if (ErrorLevel = 0) {
                failedCount++
                R_Log("FAILED: " pName " (" pID ") " oldPriority " → " pState, 0)
            } else {
                resetCount++
                R_Log("Changed: " pName " (" pID ") " oldPriority " → " pState, 2)
            }
        }

        R_Log("RESET COMPLETE: Changed=" resetCount " Failed=" failedCount " SecurityBlock=" securityBlockCount " Skipped=" skippedCount, 1)
        return
    }

    if (pProcID == "*others") {
        R_Log("Adjusting background processes...", 1)
        for pID, pName in procIDList {
            if (pID == wPID_old || R_IsWhitelisted(pName))
                continue
            
            ;;∙------∙Security check for *others case.
            if (R_IsSecuritySoftware(pName)) {
                R_Log("Security block: " pName " (" pID ")", 1)
                continue
            }

            oldPriority := R_GetProcessPriority(pID)
            if (oldPriority != "Protected") {
                Process, Priority, % pID, % config.othersPriority
            }
        }
        return
    }

    ;;∙------∙Individual process handling.
    pName := procIDList.HasKey(pProcID) ? procIDList[pProcID] : "Unknown"
    
    ;;∙------∙Security check.
    if (R_IsSecuritySoftware(pName)) {
        R_Log("Security block: " pName, 1)
        return
    }

    if (!forceReset && (R_IsWhitelisted(pName) || R_IsBlacklisted(pName))) {
        R_Log("Blocked: " pName, 1)
        return
    }

    ;;∙------∙Priority change with protection check.
    oldPriority := R_GetProcessPriority(pProcID)
    if (oldPriority == "Protected") {
        R_Log("Protected process: " pName, 1)
        return
    }

    Process, Priority, % pProcID, % pState
    if (ErrorLevel) {
        R_Log("FAILED: " pName " (" pProcID ") " oldPriority " → " pState, 0)
    } else {
        R_Log("Priority changed: " pName " (" pProcID ") " oldPriority " → " pState, 2)
    }
}

;;∙===================== NEW PROTECTION CHECK ================∙
R_IsSystemProtected(pName) {
    protectedProcesses := ["RuntimeBroker.exe", "smartscreen.exe", "SearchFilterHost.exe"
                         , "CompPkgSrv.exe", "SecurityHealthSystray.exe", "HPAudioSwitch.exe"]
    return (pName in protectedProcesses)
}

;;∙===================== HELPER FUNCTIONS ====================∙
R_IsWhitelisted(pName) {
    global config
    for idx, name in config.whitelist
        if (pName = name)
            return true
    return false
}

R_IsBlacklisted(pName) {
    global config
    for idx, pattern in config.blacklist
        if RegExMatch(pName, "i)" pattern)
            return true
    return false
}

R_CheckAdmin() {    ;;∙------∙Safety net. Best practice though: Right-click → "Run as Administrator".
    global g_Elevating
    
    if !A_IsAdmin {
        g_Elevating := true
        try {
            Run *RunAs "%A_AhkPath%" "%A_ScriptFullPath%"
            ExitApp    ;;∙------∙Immediate exit without cleanup.
        } catch {
            MsgBox, 16, Admin Required, Failed to elevate privileges!
            ExitApp
        }
    }
    g_Elevating := false
}

R_ProcessExists(PID) {
    Process, Exist, %PID%
    return ErrorLevel    ;;∙------∙Returns 0 if not found, PID if exists.
}

R_GetProcessPriority(PID) {
    static PROCESS_QUERY_LIMITED_INFORMATION := 0x1000
    static priorityMap := {0x40: "Low", 0x8000: "BelowNormal", 0x20: "Normal"
                         , 0x4000: "AboveNormal", 0x80: "High", 0x100: "Realtime"}
    
    ;;∙------∙Try to open process with limited rights.
    hProcess := DllCall("OpenProcess", "UInt", PROCESS_QUERY_LIMITED_INFORMATION, "Int", 0, "UInt", PID)
    
    if (!hProcess) {
        ;;∙------∙Handle access denied specifically.
        if (A_LastError == 5) { ; ERROR_ACCESS_DENIED
            return "Protected"
        }
        return "Unknown"
    }
    
    ;;∙------∙Get priority class.
    priority := DllCall("GetPriorityClass", "Ptr", hProcess)
    DllCall("CloseHandle", "Ptr", hProcess)
    
    return priorityMap.HasKey(priority) ? priorityMap[priority] : "Unknown"
}

R_IsSecuritySoftware(pName) {
    static securityKeywords := ["Norton", "McAfee", "asw", "Avast", "avg", "Symantec", "Defender", "Sophos", "Malwarebytes", "CrowdStrike"]
    static protectedEXEs := ["NortonUI.exe", "aswEngSrv.exe", "MsMpEng.exe", "CSFalconService.exe", "SophosUI.exe", "MBAMService.exe"]
    
    ;;∙------∙Check against known security EXEs.
    if (pName in protectedEXEs)
        return true
    
    ;;∙------∙Check for security keywords.
    for idx, keyword in securityKeywords {
        if InStr(pName, keyword)
            return true
    }
    return false
}
;;∙===================== LOG MANAGEMENT ======================∙
R_ManageLogs() {
    global config

    if (config.logFile && FileExist(config.logFile)) {
        FileGetSize, logSize, % config.logFile, M
        if (logSize > config.logMaxSizeMB) {
            try {
                FileMove, % config.logFile, % config.logFile ".old", 1
            } catch e {
                OutputDebug, % "AHK| Log rotation failed: " e.Message
            }
        }
    }
}

R_Log(message, level := 1) {
    global config
    if (config.logLevel < level)
        return
    
    timestamp := Format("[{1:04}-{2:02}-{3:02} {4:02}:{5:02}:{6:02}]"
                    , A_YYYY, A_MM, A_DD, A_Hour, A_Min, A_Sec)
    logEntry := timestamp " - " message
    
    OutputDebug, % "AHK| " logEntry
    
    if (config.logFile != "") {
        tries := 0
        while (tries < 3) {
            try {
                R_ManageLogs()
                FileAppend, % logEntry "`n", % config.logFile
                break
            } catch e {
                Sleep, 100
                tries++
                if (tries >= 3)
                    OutputDebug, % "AHK| Log write failed: " e.Message
            }
        }
    }
}

;;∙===================== TIMER SUBROUTINES ===================∙
CheckActiveProcess:
    global procIDList, wPID_old, lastActivity, dynamicTimer, config, isPaused, processing
    
    if (isPaused || processing)
        return

    processing := true
    Critical, On
    try {
        WinGet, wPID, PID, A
        if (wPID != wPID_old) {
            lastActivity := A_TickCount
            dynamicTimer := 5000
            if (!procIDList.HasKey(wPID)) {
                R_GetProcessFullList()
                if (!procIDList.HasKey(wPID))
                    R_Log("Unknown PID detected: " wPID, 1)
                return
            }

            pName := procIDList[wPID]
            if (R_IsWhitelisted(pName))
                return

            R_Log("Active window changed to: " pName " (PID: " wPID ")", 1)
            R_SetProcessPrio(wPID, config.activePriority)
            wPID_old := wPID
            R_SetProcessPrio("*others", config.othersPriority)
        }
    } finally {
        processing := false
        Critical, Off
    }
Return

ActivityMonitor:
    global lastActivity, dynamicTimer, config
    if (A_TickCount - lastActivity > 30000) {
        dynamicTimer := config.refreshInterval
        SetTimer, CheckActiveProcess, % dynamicTimer
    }
Return

;;∙===================== TRAY FUNCTIONS ======================∙
Menu, Tray, Add, Pause/Resume, TogglePause
Menu, Tray, Add, Reload Script, ReloadConfig
Menu, Tray, Add, Exit, ExitSub

TogglePause:
    global isPaused
    isPaused := !isPaused
    Suspend, % isPaused ? "On" : "Off"
    Menu, Tray, ToggleCheck, Pause/Resume
    R_Log("Script " (isPaused ? "paused" : "resumed"), 0)
Return

ReloadConfig:
    EnsureCleanReload()
    SetTimer, CheckActiveProcess, Off
    SetTimer, ActivityMonitor, Off
    Sleep, 100
    Reload
Return

EnsureCleanReload() {
    if (snapshot) {
        DllCall("CloseHandle", "Ptr", snapshot)
        snapshot := 0
    }
}

;;∙===================== EXIT HANDLER ========================∙
ExitSub:
    global g_Elevating, procIDList, config    ;;∙------∙Global declarations.
    
    if (g_Elevating) {
        ExitApp    ;;∙------∙Skip cleanup during elevation attempts.
    }

    ;;∙------∙Stop all timers first.
    SetTimer, CheckActiveProcess, Off
    SetTimer, ActivityMonitor, Off

    ;;∙------∙Reduce logging during cleanup.
    originalLogLevel := config.logLevel
    config.logLevel := 0  ;; Only log critical errors.
    
    R_Log("Shutting down... Resetting all priorities", 0)
    R_GetProcessFullList()    ;;∙------∙Refresh the process list.
    R_SetProcessPrio("*", "Normal", true)    ;;∙------∙Force reset.

    ;;∙------∙Ensure clean thread state.
    Critical, Off
    Sleep, 300    ;;∙------∙Allow final operations.
    
    ;;∙------∙Restore logging and exit.
    config.logLevel := originalLogLevel
    ExitApp
Return

;;∙===========================================================∙
SetTimer, CheckActiveProcess, % dynamicTimer
SetTimer, ActivityMonitor, 5000
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

