
/*------∙NOTES∙--------------------------------------------------------------------------∙
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
∙--------------------------------------------------------------------------------------------∙
*/


;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙
;;∙======∙DIRECTIVES.
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force
SetBatchLines -1
SetTitleMatchMode 2
SetWinDelay 0
SetWorkingDir %A_ScriptDir%

OnMessage(0x0201, "WM_LBUTTONDOWNdrag")
SetTimer, UpdateCheck, 750
ScriptID := "Ownership_Viewer_v1"
Menu, Tray, Icon, shell32.dll, 313
GoSub, TrayMenu


;;∙======∙HOTKEY.
^t::    ;;∙------∙🔥∙(Ctrl + T)


;;∙======∙GLOBAL VARIABLES.
global vWinList
global CharSet := "UTF-16"


;;∙======∙GUI BUILD.
Gui, +AlwaysOnTop +Resize +MinSize340x480
Gui, Color, Gray
Gui, Font, s12 CRed Bold, Segoe UI
Gui, Add, Text, x20 y8 cBlue, Visible Window Owners:
Gui, Font, s10 Norm, Segoe UI
Gui, Add, ListView, x10 y30 w580 h400 cBlue BackgroundSilver NoSortHdr vWinList, #|PID|Process Name|User|Window Title
Gui, Add, Button, x10 y440 w100 gRefreshList, Refresh
Gui, Add, Button, x120 y440 w100 gExitScript, Exit

Gui, Show, w600 h550, Window User Ownership Viewer
RefreshList()
Return


;;∙======∙BUTTON HANDLERS.
RefreshList:
    RefreshList()
Return

ExitScript:
    ExitApp
Return


;;∙======∙ENUMERATE ALL VISIBLE WINDOWS & RETRIEVES USER/PROCESS INFO.
RefreshList()
{
    global vWinList
    LV_Delete()
    
    WinGet, idList, List
    lineNumber := 0
    
    ;;∙------∙First pass to count total visible windows.
    totalCount := 0
    Loop, % idList
    {
        hwnd := idList%A_Index%
        WinGetTitle, title, ahk_id %hwnd%
        if (title != "")
            totalCount++
    }
    
    ;;∙------∙Determine padding based on total count.
    if (totalCount < 10)
        padWidth := 1
    else if (totalCount < 100)
        padWidth := 2
    else if (totalCount < 1000)
        padWidth := 3
    else
        padWidth := 4
    
    ;;∙------∙Second pass to populate the list.
    Loop, % idList
    {
        hwnd := idList%A_Index%
        WinGet, pid, PID, ahk_id %hwnd%
        WinGetTitle, title, ahk_id %hwnd%
        
        if (title = "")
            continue
            
        Image := GetProcessName(pid)
        User := GetProcessUser(pid)
        
        lineNumber++
        ;;∙------∙Space-pad based on total count.
        paddedNumber := Format("{:" . padWidth . "}", lineNumber)
        LV_Add("", paddedNumber, pid, Image, User, title)
    }
    LV_ModifyCol()
    LV_ModifyCol(1, "Integer")
}


;;∙======∙RETRIEVE PROCESS EXECUTABLE NAME FROM PID.
GetProcessName(PID)
{
    hProcess := DllCall("OpenProcess", "uint", 0x0410, "int", 0, "uint", PID, "ptr")
    if !hProcess
        return "Access Denied"

    VarSetCapacity(FileName, 260 * 2, 0)
    len := DllCall("psapi.dll\GetModuleBaseNameW", "ptr", hProcess, "ptr", 0, "ptr", &FileName, "uint", 260)
    DllCall("CloseHandle", "ptr", hProcess)

    return (len) ? StrGet(&FileName, len, CharSet) : "Unknown"
}


;;∙======∙RETURN USERNAME OWNING A GIVEN PROCESS.
GetProcessUser(PID)
{
    TOKEN_QUERY := 0x0008
    PROCESS_QUERY_LIMITED_INFORMATION := 0x1000

    hProcess := DllCall("OpenProcess", "uint", PROCESS_QUERY_LIMITED_INFORMATION, "int", 0, "uint", PID, "ptr")
    if !hProcess
        return "Access Denied"

    if !DllCall("advapi32.dll\OpenProcessToken", "ptr", hProcess, "uint", TOKEN_QUERY, "ptr*", hToken)
    {
        DllCall("CloseHandle", "ptr", hProcess)
        return "Access Denied"
    }

    DllCall("advapi32.dll\GetTokenInformation", "ptr", hToken, "int", 1, "ptr", 0, "uint", 0, "uint*", size)
    VarSetCapacity(TOKENINFO, size, 0)
    if !DllCall("advapi32.dll\GetTokenInformation", "ptr", hToken, "int", 1, "ptr", &TOKENINFO, "uint", size, "uint*", size)
    {
        DllCall("CloseHandle", "ptr", hToken)
        DllCall("CloseHandle", "ptr", hProcess)
        return "Access Denied"
    }

    pSID := NumGet(TOKENINFO, 0, "ptr")
    cchName := 260, cchDomain := 260
    VarSetCapacity(Name, cchName * 2, 0)
    VarSetCapacity(Domain, cchDomain * 2, 0)
    if !DllCall("advapi32.dll\LookupAccountSidW", "ptr", 0, "ptr", pSID, "ptr", &Name, "uint*", cchName, "ptr", &Domain, "uint*", cchDomain, "uint*", peUse := 0)
    {
        user := "Unknown"
    }
    else
    {
        user := StrGet(&Domain, CharSet) "\" StrGet(&Name, CharSet)
    }

    DllCall("CloseHandle", "ptr", hToken)
    DllCall("CloseHandle", "ptr", hProcess)
    return user
}
Return


;;∙======∙GUI DRAG.
WM_LBUTTONDOWNdrag() {    ;;∙------∙Gui Drag Pt 2.
   PostMessage, 0x00A1, 2, 0
}
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙



;;∙====================================∙
 ;;∙------∙EDIT∙---------------------------∙
Script·Edit:    ;;∙------∙Menu Call.
    Edit
Return

;;∙------∙RELOAD∙-----------------------∙
^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        Soundbeep, 1200, 250
    Reload
Return

 ;;∙------∙EXIT∙----------------------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        Soundbeep, 1000, 300
    ExitApp
Return

;;∙====================================∙
 ;;∙------∙SCRIPT UPDATE∙-------------∙
UpdateCheck:    ;;∙------Check if script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload

;;∙====================================∙
 ;;∙------∙TRAY MENU∙------------------∙
TrayMenu:
Menu, Tray, Tip, %ScriptID%
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Suspend / Pause, % ScriptID    ;;∙------∙Script Header.
Menu, Tray, Icon, Suspend / Pause, shell32, 28
Menu, Tray, Default, Suspend / Pause    ;;∙------∙Makes Bold.

;;∙------∙MENU-EXTENTIONS∙---------∙
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

;;∙------∙MENU-OPTIONS∙-------------∙
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

;;∙------∙EXTENTIONS∙------------------∙
Documentation:
    Run, "C:\Program Files\AutoHotkey\AutoHotkey.chm"
Return
ShowKeyHistory:
    KeyHistory
Return
ShowWindowSpy:
    Run, "C:\Program Files\AutoHotkey\WindowSpy.ahk"
Return

;;∙------∙MENU-HEADER∙---------------∙
Ownership_Viewer_v1:    ;;∙------∙Suspends hotkeys then pauses script.
    Suspend
    Soundbeep, 700, 100
    Pause
Return

;;∙====================================∙
 ;;∙------∙MENU POSITION∙-----------∙
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20
Return

 ;;∙------∙POSITION FUNTION∙-------∙
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
;;∙------------------------------------------------------------------------------------------∙
;;∙========================∙SCRIPT END∙=========================∙
;;∙------------------------------------------------------------------------------------------∙

