
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  BobTom
» Original Source:  https://www.autohotkey.com/board/topic/11008-progress-bars-for-copying-files-and-directories/
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
/*

vsource := "C:\Users\rjcof\Downloads\1.The Source"    ;;∙------∙Source folder path (e.g., "C:\Source\").
if (SubStr(vsource, 0) != "\")
    vsource .= "\"

vdest := "C:\Users\rjcof\Downloads\2.The Destination"    ;;∙------∙Destination folder path (e.g., "D:\Backup\").
if (SubStr(vdest, 0) != "\")
    vdest .= "\"

*/
;;∙============================================================∙
;;∙============================================================∙

;;∙------∙Specify the Source & Destination directories.
vsource := ""    ;;<∙------∙Source folder path (e.g., "C:\Source\").
if (SubStr(vsource, 0) != "\")
    vsource .= "\"

vdest := ""    ;;<∙------∙Destination folder path (e.g., "D:\Backup\").
if (SubStr(vdest, 0) != "\")
    vdest .= "\"

;;∙------∙Toggle recursive copying of subfolders.
vRecursive := true    ;;<∙------∙Set to 'true' to copy subfolders recursively, 'false' for only files in root.
vFlag := vRecursive ? "R" : ""    ;;∙------∙Sets Loop flag: "R" for recursive, "" for non-recursive.

;;∙------------------------------------------------∙

;;∙------------∙Logging Pt. 1
vlog := A_ScriptDir . "\copy_log.txt"    ;;∙------∙Set the log file path.
FileDelete, %vlog%    ;;∙------∙Delete previous log to start fresh (comment out to append logs).
formattedTime := FormatDateTime(A_Now)
FileAppend, Copy started on %formattedTime%`nFrom: %vsource%`nTo: %vdest%`n`n, %vlog%    ;;∙------∙Header.

;;∙------------∙Main script.
vfilep := ""    ;;∙------∙Holds the filename with the greatest length found so far.
vstep := 0      ;;∙------∙Initialize file count to zero.

;;∙------∙Count total files and find longest filename (recursive if enabled).
Loop, Files, %vsource%*.*, %vFlag%
{
    vstep := A_Index    ;;∙------∙Track the total number of files.
    vfileplen := StrLen(vfilep)    ;;∙------∙Length of the longest filename seen so far.
    vfileclen := StrLen(A_LoopFileName)    ;;∙------∙Length of current filename.
    if (vfileclen > vfileplen)
        vfilep := A_LoopFileName    ;;∙------∙Update longest filename if current is longer.
    else
        continue
}

vfilename := StrLen(vfilep) + 6    ;;∙------∙Filename width + padding.
vsourcelen := StrLen(vsource) + 6    ;;∙------∙Source path length + padding.
vdestlen := StrLen(vdest) + 4    ;;∙------∙Destination path length + padding.

;;∙------------∙Determine progress bar width (vpwidth) based on longest string.
if not (vfilename < vsourcelen or vfilename < vdestlen)
{
    vpwidth := vfilename * 9    ;;∙------∙Use filename width.
}
else
{
    if not (vsourcelen < vdestlen or vsourcelen < vfilename)
    {
        vpwidth := vsourcelen * 9    ;;∙------∙Use source path width.
    }
    else
    {
        if not (vdestlen < vsourcelen or vdestlen < vfilename)
        {
            vpwidth := vdestlen * 9    ;;∙------∙Use destination path width.
        }
        else
        {
            MsgBox,,, Copying Did Not Work!!,3    ;;∙------∙Fallback if none of the above conditions apply.
            Return
        }
    }
}

vstepincrement := 0    ;;∙------∙Initialize progress bar step counter.
Progress, A M2 P0 R0-%vstep% H90 W%vpwidth% X1200 Y450, , From: %vsource%`nTo: %vdest%, Copying...
Progress, %vstepincrement%, , From: %vsource%`nTo: %vdest%, Copying...

;;∙------∙Loop through files and copy them (recursive if enabled).
Loop, Files, %vsource%*.*, %vFlag%
{
    Progress, , File: %A_LoopFileName%, From: %vsource%`nTo: %vdest%, Copying...

    ;;∙------∙Compute relative path of the file inside source folder.
    relPath := SubStr(A_LoopFileFullPath, StrLen(vsource) + 1)    ;;∙------∙Remove source base path.
    ;;∙------∙Extract directory path only (remove filename).
    StringTrimRight, relDir, relPath, StrLen(A_LoopFileName)
    
    ;;∙------∙Create the corresponding destination directory if it does not exist.
    if (relDir != "")
    {
        destDir := vdest . relDir
        FileCreateDir, %destDir%
    }
    else
        destDir := vdest

    ;;∙------∙Full destination path including subfolders.
    destPath := destDir . A_LoopFileName

    ;;∙------∙Logging Pt. 2 and copy file.
    FileCopy, %A_LoopFileFullPath%, %destPath%
    if ErrorLevel
        FileAppend, ‼ FAILED ‼:  %relPath%`n, %vlog%
    else
        FileAppend, • Copied:  %relPath%`n, %vlog%

    Sleep, 50    ;;∙------∙Delay for smoother progress bar update.
    vstepincrement++    ;;∙------∙Advance progress bar.
    Progress, %vstepincrement%, , From: %vsource%`nTo: %vdest%, Copying...

    ;;∙------∙(*Optional) Limit for testing - Stop after (n) files.
    if (A_Index = 10)    ;;<∙------∙Adjust for testing.
        break
}

vstepincrement++    ;;∙------∙Final increment.
Progress, %vstepincrement%, , From: %vsource%`nTo: %vdest%, Copying...
Sleep, 1000    ;;∙------∙Pause before closing progress bar.
Progress, Off    ;;∙------∙Close progress bar.
formattedTime := FormatDateTime(A_Now)
FileAppend, `nCopy finished on %formattedTime%`n, %vlog%
Return

;;∙------∙Date/time helper function.
FormatDateTime(datetime)
{
    FormatTime, out, %datetime%, MM/dd/yyyy hh.mm.sstt
    Return out
}
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

