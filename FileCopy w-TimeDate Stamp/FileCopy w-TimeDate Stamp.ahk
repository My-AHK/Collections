
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
#If WinActive("ahk_class CabinetWClass")  ;;∙------∙Trigger only in File Explorer.

^t::    ;;∙------∙🔥∙(Ctrl + T)
    Soundbeep, 1000, 200

selectedFiles := getSelected()
if (selectedFiles.Length() = 0)
    return

dir := "", errors := 0
prevTime := 0  ;;∙------∙Track time between files

For _, filePath in selectedFiles {
    ;;∙------∙Get current time with milliseconds
    DllCall("GetSystemTimeAsFileTime", "int64*", filetime)
    currentTime := filetime  ;;∙------∙Time in 100-ns since 1601

    ;;∙------∙Enforce 30ms gap from previous file
    if (prevTime) {
        diffMs := (currentTime - prevTime) // 10000  ;;∙------∙Convert 100-ns to ms
        if (diffMs < 30) {
            Sleep % 30 - diffMs  ;;∙------∙Force a minimum delay
            DllCall("GetSystemTimeAsFileTime", "int64*", filetime)  ;;∙------∙Update time after delay
            currentTime := filetime
        }
    }
    prevTime := currentTime

    ;;∙------∙Convert to readable timestamp
    VarSetCapacity(ST, 16, 0)
    DllCall("FileTimeToSystemTime", "int64*", currentTime, "Ptr", &ST)
    wYear      := NumGet(ST, 0, "UShort")
    wMonth     := NumGet(ST, 2, "UShort")
    wDayOfWeek := NumGet(ST, 4, "UShort")  ; Added for day abbreviation
    wDay       := NumGet(ST, 6, "UShort")
    wHour      := NumGet(ST, 8, "UShort")
    wMinute    := NumGet(ST, 10, "UShort")
    wSecond    := NumGet(ST, 12, "UShort")
    wMs        := NumGet(ST, 14, "UShort")

    ;;∙------∙Day and month abbreviations
    days := ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    months := ["Jan", "Feb", "Mar", "Apr", "May", "Jun"
             , "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    dayAbbr := days[wDayOfWeek + 1]  ; Convert 0-based to 1-based index
    monthAbbr := months[wMonth]

    ;;∙------∙Convert to 12-hour format with AM/PM
    hour12 := wHour
    if (hour12 = 0) {
        hour12 := 12
        period := "AM"
    } else if (hour12 < 12) {
        period := "AM"
    } else {
        period := "PM"
        if (hour12 > 12)
            hour12 -= 12
    }

    ;;∙------∙Format as ddd_MMM_dd_yyyy @ HH.mm.ss.mmm-tt
    formattedTime := Format("{1}_{2}_{3:02}_{4} @ {5:02}.{6:02}.{7:02}.{8:03}-{9}"
                        , dayAbbr, monthAbbr, wDay, wYear, hour12, wMinute, wSecond, wMs, period)

    ;;∙------∙Generate filename
    SplitPath, filePath, , dir, ext, fnBare
    newName := fnBare " " formattedTime "." ext  ;;∙------∙e.g., "Report Wed_Oct_18_2023 @ 02.30.45.123-PM.txt"
    newPath := dir "\" newName

    ;;∙------∙Handle duplicates (rare but possible)
    counter := 1
    while (FileExist(newPath)) {
        newName := fnBare " " formattedTime " (" counter++ ")." ext
        newPath := dir "\" newName
    }

    ;;∙------∙Copy with feedback
    ToolTip, Copying: %newName%
    FileCopy, % filePath, % newPath, 0
    if (ErrorLevel || !pathExist(newPath)) {
        MsgBox, 48, Error, Failed to copy: %newPath%
        errors++
        break
    }
    Sleep, 200  ;;∙------∙Allow ToolTip to display
}

ToolTip
MsgBox, 64, Done, % (errors ? "Errors occurred." : "Copied " selectedFiles.Length() " files with unique timestamps!"),4
return
#If

;;∙------∙Script 1's direct file selection (no clipboard).
getSelected() {    
    hwnd := WinExist("A"), selection := []
    WinGetClass, class
    if (class ~= "(Cabinet|Explore)WClass")
        for window in ComObjCreate("Shell.Application").Windows {
            try window.hwnd
            catch
                return selection
            if (window.hwnd = hwnd) {
                items := window.document.SelectedItems
                count := items.Count
                ; Loop from last item to first to reverse the order
                Loop % count {
                    index := count - A_Index  ; Starts from count-1 down to 0
                    item := items.Item(index)
                    selection.Push(item.Path)
                }
            }
        }
    return selection
}

;;∙------∙Script 2's robust path-checking helpers.
pathExist(srcPath) {
    if (isDir(srcPath))
        return true
    fObj := FileOpen(srcPath, "r")
    if (IsObject(fObj)) {
        fObj.Close()
        return true
    }
    return false
}

isDir(srcPath) {
    return InStr(FileExist(srcPath), "D")
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

