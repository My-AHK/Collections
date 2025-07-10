
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
» AutoReload Scripts Monitor.
    ▹ To automatically monitor and reload .ahk scripts from a specific folder (scriptDirectory) when they are modified. This includes reloading the monitoring script itself if it changes.
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
;;∙-----------------------------------------∙
scriptDirectory := "C:\Path\To\Scripts"    ;;∙------∙Set directory path where scripts are located.
;; Ensure directory path ends with backslash for consistent matching
if (SubStr(scriptDirectory, 0) != "\")
    scriptDirectory .= "\"
    
scriptExtension := ".ahk"    ;;∙------∙Set script file extension to watch for.
pollingInterval := 1000    ;;∙------∙Set polling interval in milliseconds.
lastModified := {}    ;;∙------∙Create associative array to store last modified timestamps.


;;∙-----------------------------------------∙
^t::    ;;∙------∙🔥∙(Ctrl + T)
    Soundbeep, 1000, 200
    MsgBox,,, * AHK Script Auto-Reloader *`n`n• Monitors running .ahk scripts for file changes.`n• Automatically reloads modified scripts.`n• Watched directory:`n`t%scriptDirectory%, 5
Return


;;∙----------------------------------------------------------------------∙
SetTimer, PollScripts, % pollingInterval    ;;∙------∙Initialize polling.
Return


;;∙----------------------------------------------------------------------∙
;;∙========∙Timer-based polling function.
PollScripts:
    scripts := GetRunningScripts()    ;;∙------∙Retrieve list of actively running .ahk scripts.
    
    for index, scriptPath in scripts    ;;∙------∙Loop through each running script.
    {
        scriptName := GetScriptName(scriptPath)
        if (scriptName <> "")
        {
            if IsScriptModified(scriptPath)    ;;∙------∙If modified since last check...
            {
                ReloadScript(scriptPath)    ;;∙------∙...reload it and update timestamp.
                lastModified[scriptPath] := FileGetTime(scriptPath, "M")
            }
        }
    }

    ;;∙------∙Monitor this script for self-modification.
    if IsScriptModified(A_ScriptFullPath)    ;;∙------∙Check if current script changed.
    {
        lastModified[A_ScriptFullPath] := FileGetTime(A_ScriptFullPath, "M")
        Reload  ;;∙------∙Use built-in reload for clean self-restart.
    }
Return


;;∙----------------------------------------------------------------------∙
;;∙========∙Get list of running .ahk scripts.
GetRunningScripts()
{
    global scriptDirectory, scriptExtension
    scripts := []

    ;;∙------∙WMI query for path extraction.
    wmi := ComObjGet("winmgmts:")
    query := "SELECT CommandLine FROM Win32_Process WHERE Name='AutoHotkey.exe'"
    for process in wmi.ExecQuery(query)
    {
        if !process.CommandLine
            continue

        fullCmd := process.CommandLine
        
        ;;∙------∙Handle quoted & unquoted paths.
        scriptPath := ""
        if RegExMatch(fullCmd, "i)""([^""]+\.ahk)""", match)    ;;∙------∙Quoted paths.
            scriptPath := match1
        else if RegExMatch(fullCmd, "i)\.ahk\s+([^\s""]+)", match)    ;;∙------∙Unquoted paths.
            scriptPath := match1
        
        ;;∙------∙Validate path matches directory and extension.
        if (scriptPath != "" 
            && InStr(scriptPath, scriptDirectory) == 1
            && SubStr(scriptPath, -3) == scriptExtension
            && FileExist(scriptPath))
        {
            scripts.Push(scriptPath)
        }
    }

    return scripts
}


;;∙----------------------------------------------------------------------∙
;;∙========∙Get script name from full path.
GetScriptName(scriptPath)
{
    SplitPath, scriptPath, name
    return name
}


;;∙----------------------------------------------------------------------∙
;;∙========∙Check if a script has been modified.
IsScriptModified(scriptPath)
{
    global lastModified
    currentModified := FileGetTime(scriptPath, "M")
    lastTime := lastModified[scriptPath]
    return (currentModified != lastTime)  ;;∙------∙Strict inequality check.
}


;;∙----------------------------------------------------------------------∙
;;∙========∙Reload a script via Run and window close.
ReloadScript(scriptPath)
{
    ;;∙------∙Special case for self-reload.
    if (scriptPath == A_ScriptFullPath) {
        Reload
        return
    }

    ;;∙------∙Find and close script by PID.
    for process in ComObjGet("winmgmts:").ExecQuery("SELECT ProcessId FROM Win32_Process WHERE CommandLine LIKE '%" scriptPath "%'")
    {
        Process, Close, % process.ProcessId    ;;∙------∙Direct process termination.
        Sleep, 300  ;;∙------∙Brief pause to ensure closure
    }

    ;;∙------∙Relaunch script with proper interpreter.
    Run, "%A_AhkPath%" "%scriptPath%",, UseErrorLevel
    if ErrorLevel
        MsgBox, Failed to reload: %scriptPath%
}


;;∙----------------------------------------------------------------------∙
;;∙========∙Get modified timestamp of a file.
FileGetTime(fileName, timeType)
{
    FileGetTime, modifiedTime, % fileName, % timeType
    return modifiedTime
}
RETURN
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

