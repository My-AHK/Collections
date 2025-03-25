
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
/*
» SHGetKnownFolderPath :  Reliable DllCall KFID method of tracking of system folders.
    ▹ Retrieves the exact location even if the user has moved the folder.
    ▹ Works with all known folders, including Downloads, Documents, Desktop, etc.
    ▹ Avoids SpecialFolders limitations.
    ▹ Supports all Windows languages and profiles.
    ▹ No need to rely on A_MyDocuments, A_AppData, etc.
    ▹ Ensures full compatibility across different Windows versions.
*/
;;∙============================================================∙

^t::    ;;∙------∙🔥∙(Ctrl+T) 
    Soundbeep, 1000, 200

;;∙------∙Example For Tracking Downloads Folder∙------∙
DownloadsPath := Get_KnownFolderPath("{374DE290-123F-4565-9164-39C4925E467B}") ;; Downloads
MsgBox % DownloadsPath

;;∙------∙Example For Tracking Documents Folder∙------∙
DocumentsPath := Get_KnownFolderPath("{FDD39AD0-238F-46AF-ADB4-6C85480369C7}") ;; Documents
MsgBox % DocumentsPath

;;∙------∙FUNCTION∙------∙
Get_KnownFolderPath(FolderGUID) {
    VarSetCapacity(GUID, 16)    ;;∙------∙Convert GUID string to binary format.
    if DllCall("ole32\CLSIDFromString", "WStr", FolderGUID, "Ptr", &GUID) != 0
        return ""    ;;∙------∙Invalid GUID format.
    pPath := 0    ;;∙------∙Get folder path.
    if DllCall("Shell32\SHGetKnownFolderPath", "Ptr", &GUID, "UInt", 0, "Ptr", 0, "Ptr*", pPath) != 0
        return ""    ;;∙------∙Failed to get path.
    path := StrGet(pPath, "UTF-16")    ;;∙------∙Convert and free memory.
    DllCall("ole32\CoTaskMemFree", "Ptr", pPath)
    return path
}
Return

;;∙============================================================∙


/*∙======∙ KFID List ∙================================∙
KFID (Known Folder GUID): 
   • Used by Windows to track system folders like Downloads, Documents, Desktop, etc.
   • Windows uses KFIDs with SHGetKnownFolderPath to retrieve folder locations dynamically, even if they have been moved.

;;∙------∙Commonly Used KFIDs∙----------------------------------∙
Folder			Known Folder GUID (KFID)
∙-------------------------------------------------------------------------∙
Desktop			{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}
Documents		{FDD39AD0-238F-46AF-ADB4-6C85480369C7}
Downloads		{374DE290-123F-4565-9164-39C4925E467B}
Music			{4BD8D571-6D19-48D3-BE97-422220080E43}
Pictures			{33E28130-4E1E-4676-835A-98395C3BC3BB}
Videos			{18989B1D-99B5-455B-841C-AB7C74E4DDFC}
Desktop (Public)		{C4AA340D-F20F-4863-AFEF-F87EF2E6BA25}
Documents (Public)		{ED4824AF-DCE4-45A8-81E2-FC7965083634}
Downloads (Public)		{3D644C9B-1FB8-4F30-9B45-F670235F79C0}
Music (Public)		{3214FAB5-9757-4298-BB61-92A9DEAA44FF}
Pictures (Public)		{B6EBFB86-6907-413C-9AF7-4FC2ABF07CC5}
Videos (Public)		{2400183A-6185-49FB-A2D8-4A392A602BA3}

;;∙------∙User Profile & Special Folders∙--------------------------∙
User Profile		{5E6C858F-0E22-4760-9AFE-EA3317B67173}
AppData (Roaming)		{3EB685DB-65F9-4CF6-A03A-E3EF65729F3D}
AppData (Local)		{F1B32785-6FBA-4FCF-9D55-7B8E7F157091}
AppData (LocalLow)		{A520A1A4-1780-4FF6-BD18-167343C5AF16}
Contacts			{56784854-C6CB-462B-8169-88E350ACB882}
Favorites			{1777F761-68AD-4D8A-87BD-30B759FA33DD}
Links			{BFB9D5E0-C6A9-404C-B2B2-AE6DB6AF4968}
Saved Games		{4C5C32FF-BE3A-4CBF-9D0F-3D2336E6FEA7}
Searches			{7D1D3A04-DEBB-4115-95CF-2F29DA2920DA}

;;∙------∙System & Program Folders∙-----------------------------∙
Program Files (x86)		{7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}
Program Files (x64)		{905E63B6-C1BF-494E-B29C-65B732D3D21A}
ProgramData (All Users)	{62AB5D82-FDC1-4DC3-A9DD-070D1D495D97}
Start Menu (User)		{625B53C3-AB48-4EC1-BA1F-A1EF4146FC19}
Start Menu (Common)	{A4115719-D62E-491D-AA7C-E74B8BE3B067}
Startup (User)		{B97D20BB-F46A-4C97-BA10-5E3608430854}
Startup (Common)		{D9DC8A3B-B784-432E-A781-5A1130A75963}

;;∙------∙User Folders∙-----------------------------------------------∙
3D Objects		{31C0DD25-9439-4F12-BF41-7FF4EDA38722}
Camera Roll		{AB5FB87B-7CE2-4F83-915D-550846C9537B}
Saved Pictures		{3B193882-D3AD-4EAB-965A-69829D1FB59F}
OneDrive			{A52BBA46-E9E1-435F-B3D9-28DAA648C0F6}

;;∙------∙Public & Shared Folders∙---------------------------------∙
Public			{DFDF76A2-C82A-4D63-906A-5644AC457385}
Public Documents		{ED4824AF-DCE4-45A8-81E2-FC7965083634}
Public Downloads		{3D644C9B-1FB8-4F30-9B45-F670235F79C0}
Public Music		{3214FAB5-9757-4298-BB61-92A9DEAA44FF}
Public Pictures		{B6EBFB86-6907-413C-9AF7-4FC2ABF07CC5}
Public Videos		{2400183A-6185-49FB-A2D8-4A392A602BA3}
Public Desktop		{C4AA340D-F20F-4863-AFEF-F87EF2E6BA25}

;;∙------∙System & App Folders∙-----------------------------------∙
Program Files (x86)		{7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}
Program Files (x64)		{905E63B6-C1BF-494E-B29C-65B732D3D21A}
ProgramData (All Users)	{62AB5D82-FDC1-4DC3-A9DD-070D1D495D97}
Windows Folder		{F38BF404-1D43-42F2-9305-67DE0B28FC23}
System32 Folder		{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}

;;∙------∙AppData & User Configuration∙-------------------------∙
AppData (Roaming)		{3EB685DB-65F9-4CF6-A03A-E3EF65729F3D}
AppData (Local)		{F1B32785-6FBA-4FCF-9D55-7B8E7F157091}
AppData (LocalLow)		{A520A1A4-1780-4FF6-BD18-167343C5AF16}
Temporary Files		{B97D20BB-F46A-4C97-BA10-5E3608430854}

;;∙------∙Administrative & Virtual Folders∙-----------------------∙
Control Panel		{82A74AEB-AEB4-465C-A014-D097EE346D63}
Network			{D20BEEC4-5CA8-4905-AE3B-BF251EA09B53}
Printers			{76FC4E2D-D6AD-4519-A663-37BD56068185}
Recycle Bin		{B7534046-3ECB-4C18-BE4E-64CD4CB7D6AC}
∙-------------------------------------------------------------------------∙
For More:  https://learn.microsoft.com/en-us/windows/win32/shell/knownfolderid
*/∙===========================================================∙
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

