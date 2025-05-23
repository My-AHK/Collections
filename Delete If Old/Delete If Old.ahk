
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.

∙--------∙ABOUT∙-------------------------∙
» Original Author:  polyethene
» Original Source:  https://www.autohotkey.com/board/topic/2879-delete-files-older-than-10days-in-a-specifict-folder/
» Modifications: Enhanced with GUI and recursive scanning.

» Use Case:  Full-featured solution with GUI.
» Adds GUI selector and recursive scanning for ease and power.

» Purpose: 
   • Advanced file cleanup utility with flexible configuration options.

» Key Features:
   • Intuitive GUI for configuration
   • Recursive folder scanning (optional)
   • Time basis selection (Accessed/Created/Modified)
   • Input validation for safety
   • Recycle Bin support (vs permanent deletion)

» Ideal Use Case: 
   • Users who need a robust, configurable solution for automated file cleanup.

» Comparison Notes:
   • More user-friendly than command-line alternatives
   • Safer than batch scripts due to input validation
   • More flexible than basic AHK implementations
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
;;∙------∙Configurations.
ScanFolder := "C:\Your\Target\Path"    	;;∙------∙Set your base folder here.
DelDays    := 10    	;;∙------∙Default days before deletion.
TimeBasis  := "M"    	;;∙------∙Default time basis: "A", "C", or "M" (Accessed-Created-Modified).
Recursive  := false    	;;∙------∙Default recursive scanning: false (sub-folders).

;;∙------∙Create the GUI for options.
Gui, Add, Text,, Select Time Basis:
Gui, Add, DropDownList, vTimeBasisChoice, Accessed|Created|Modified

;;∙------∙Pre-select default based on TimeBasis.
If (TimeBasis = "A")
    GuiControl, Choose, TimeBasisChoice, 1
Else If (TimeBasis = "C")
    GuiControl, Choose, TimeBasisChoice, 2
Else
    GuiControl, Choose, TimeBasisChoice, 3

Gui, Add, Text,, Days before deletion:
Gui, Add, Edit, vDelDaysChoice w50 Number, %DelDays%
Gui, Add, Checkbox, vRecursiveChoice, Include Subfolders
Gui, Add, Button, gStartCleaning Default, Start
Gui, Add, Button, gCancel, Cancel

Gui, Show, AutoSize Center, Select Time Basis and Age
Return

StartCleaning:
Gui, Submit, NoHide

;;∙------∙Map dropdown to code letters.
If (TimeBasisChoice = "Accessed")
    TimeBasis := "A"
Else If (TimeBasisChoice = "Created")
    TimeBasis := "C"
Else
    TimeBasis := "M"

;;∙------∙Validate days input.
If (DelDaysChoice = "" or DelDaysChoice < 0)
{
    MsgBox, 16, Error, Please enter a valid non-negative number for days.
    Return
}

DelDays := DelDaysChoice
Recursive := RecursiveChoice

;;∙------∙Close GUI.
Gui, Destroy

;;∙------∙Validate folder exists.
IfNotExist, %ScanFolder%
{
    MsgBox, 16, Error, Folder does not exist:`n%ScanFolder%
    Return
}

CurrentDate := A_Now

;;∙------∙Start scanning.
ScanFolderRecursive(ScanFolder, TimeBasis, DelDays, Recursive, CurrentDate)

MsgBox, 64, Done, Scan completed.

Return

;;∙------∙Recursive scan function.
ScanFolderRecursive(FolderPath, TimeBasis, DelDays, Recursive, CurrentDate)
{
    ;;∙------∙For non-recursive, only scan files in current directory.
    flags := Recursive ? "FR" : "F"
    
    Loop, Files, %FolderPath%\*, %flags%
    {
        FileGetTime, FileTime, %A_LoopFileFullPath%, %TimeBasis%
        if (!FileTime)
            continue

        DaysOld := DateDiff(CurrentDate, FileTime, "Days")
        if (DaysOld >= DelDays)
        {
            FileRecycle, %A_LoopFileFullPath%
        }
    }
}

;;∙------∙Date difference function.
DateDiff(NewDate, OldDate, Units)
{
    EnvSub, NewDate, %OldDate%, %Units%
    return NewDate
}

Cancel:
Gui, Destroy
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

