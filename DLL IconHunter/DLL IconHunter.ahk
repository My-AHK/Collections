
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
ScriptID := "IconHunter"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
;;∙============================================================∙
#NoEnv
#Persistent
#SingleInstance, Force
SetBatchLines, -1
ListLines, Off
SendMode Input
SetWorkingDir %A_ScriptDir%

F1::    ;;∙------∙🔥∙

;;∙======∙Configuration∙==========================================∙
outputFile := "DLLs With Icons List.txt"
system32Path := A_WinDir . "\System32\"

FileDelete, %outputFile%
header := "Comprehensive List of DLLs Containing Icons in System32`n"
        . "Generated: `t" A_YYYY "-" A_MM "-" A_DD " at " A_Hour ":" A_Min ":" A_Sec "`n"
        . "Scanned as: `t" (A_IsAdmin ? "Administrator" : "Standard User") "`n`n"
        . "File Name" . StrRepeat(" ", 55) . "Icon Count`n"
        . StrRepeat("-", 65) . "`n"
FileAppend, %header%, %outputFile%

;;∙======∙Get all DLL files in System32∙==============================∙
totalFiles := 0, foundFiles := 0, totalIcons := 0
maxNameLength := 0
dllList := []

;;∙======∙First pass: Find max filename length for alignment∙===========∙
Loop, %system32Path%*.dll
{
    totalFiles++
    if (StrLen(A_LoopFileName) > maxNameLength)
        maxNameLength := StrLen(A_LoopFileName)
}

;;∙======∙Second pass: Scan & record icons∙========================∙
Loop, %system32Path%*.dll
{
    dllFile := A_LoopFileFullPath
    dllName := A_LoopFileName
    
    Progress, % Round((A_Index/totalFiles)*100), Scanning %dllName%, Progress: %A_Index%/%totalFiles%
    
    iconCount := SafeCountIconsInDll(dllFile)
    if (iconCount > 0)
    {
        foundFiles++
        totalIcons += iconCount
        paddedName := dllName . StrRepeat(" ", maxNameLength - StrLen(dllName))
        dllList.Push(paddedName . "    " . iconCount)
    }
}

;;∙======∙Sort alphabetically∙======================================∙
Sort, dllList
for index, line in dllList
    FileAppend, %line%`n, %outputFile%

;;∙======∙Add summary∙==========================================∙
summary := "`n" . StrRepeat("-", 65) . "`n"
         . "Total DLLs scanned: `t" . totalFiles . "`n"
         . "DLLs with icons: `t" . foundFiles . "`n"
         . "Total icons found: `t" . totalIcons . "`n"
FileAppend, %summary%, %outputFile%

Progress, Off
Run, %outputFile%    ;;∙------∙Open result file.
ExitApp    ;;∙------∙And close script.

;;∙======∙Helper Functions∙=======================================∙
StrRepeat(str, count) {
    Loop, %count%
        out .= str
    return out
}

SafeCountIconsInDll(dllPath) {
    static RT_ICON := 3, RT_GROUP_ICON := 14
    iconCount := 0
    
    hModule := DllCall("LoadLibraryEx", "Str", dllPath, "UInt", 0, "UInt", 0x00000030, "Ptr")
    if !hModule
        return 0
    
    VarSetCapacity(CountStruct, 4, 0)
    EnumProc := RegisterCallback("SafeEnumIconGroups", "Fast")
    DllCall("EnumResourceNames", "Ptr", hModule, "Ptr", RT_GROUP_ICON, "Ptr", EnumProc, "Ptr", &CountStruct)
    DllCall("GlobalFree", "Ptr", EnumProc)
    iconCount := NumGet(CountStruct, 0, "UInt")
    
    if (iconCount = 0) {
        VarSetCapacity(CountStruct, 4, 0)
        EnumProc := RegisterCallback("SafeEnumIndividualIcons", "Fast")
        DllCall("EnumResourceNames", "Ptr", hModule, "Ptr", RT_ICON, "Ptr", EnumProc, "Ptr", &CountStruct)
        DllCall("GlobalFree", "Ptr", EnumProc)
        iconCount := NumGet(CountStruct, 0, "UInt")
    }
    
    DllCall("FreeLibrary", "Ptr", hModule)
    return iconCount
}

SafeEnumIconGroups(hModule, lpszType, lpszName, lParam) {
    iconCount := NumGet(lParam+0, "UInt")
    NumPut(iconCount+1, lParam+0, "UInt")
    return true
}

SafeEnumIndividualIcons(hModule, lpszType, lpszName, lParam) {
    if (lpszName & 0xFFFF0000 = 0) {
        iconCount := NumGet(lParam+0, "UInt")
        NumPut(iconCount+1, lParam+0, "UInt")
    }
    return true
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
IconHunter:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

