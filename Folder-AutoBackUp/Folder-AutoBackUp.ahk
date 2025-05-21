
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Concept:  Jean The Blind Runner
» Original Source:  https://discord.com/channels/115993023636176902/1372074729799680010
» 
    ▹ 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "Folder-AutoBackUp"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
;;∙============================================================∙
;;∙======∙Initial Setup & Global Variables∙=====∙
#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

;;∙------∙Folder Options: (Desktop, Documents, Downloads, Favorites, Music, SavedGames, Pictures, Public, Videos)
A_MyFolder := GetSpecialFolder("Documents")    ;;∙------∙Initialize folder path (in auto-exe).


;;∙------∙EDIT below two (2) lines between double quotes as needed!!
Global WatchFolder := A_MyFolder "\WatchedFolderName"    ;;∙------∙Specifies folder to monitor for changes.
Global BackupFolder := A_MyFolder "\BackUpFolderName"    ;;∙------∙Specifies where to store backup ZIPs.


Global MaxBackups := 10    ;;∙------∙Maximum number of backup files to retain.
Global LastHash := ""    ;;∙------∙Stores last known hash of folder contents.
BackupFileName := "BackedUpFile"    ;;∙------∙Date/Time is appended after this name.

FileCreateDir, %BackupFolder%    ;;∙------∙Creates backup folder if it doesn't exist.
SetTimer, CheckFolderChanges, 10000    ;;∙------∙Checks for folder changes every 10 seconds.
Return


;;∙======∙Manual BackUp∙=================∙
;;∙------∙🔥(Ctrl+B+U)🔥∙Triggers when Ctrl released if both flags True.

;;∙------∙Initialize tracking variables.
wasBpressed := false , wasUpressed := false

~^b::wasBpressed := true    ;;∙------∙Mark 'B' as pressed under Ctrl.
~^u::wasUpressed := true    ;;∙------∙Mark 'U' as pressed under Ctrl.
;;∙------------------------------------∙
~Ctrl up::    ;;∙------∙On Ctrl release, evaluate both flags.
    if (wasBpressed and wasUpressed)
    {
        SoundBeep, 1200, 200    ;;∙------∙Begin action.
        Gosub, FolderBackup
    }
    wasBpressed := false , wasUpressed := false
Return


;;∙============∙Functions & Subroutines∙============∙
;;∙======∙Folder Change Detection via Timer∙======∙
;;∙------∙Timer function to detect folder changes & initiate backup.
CheckFolderChanges() {
    Global WatchFolder, LastHash    ;;∙------∙Access global variables.

    NewFileList := ""    ;;∙------∙Initialize a fresh list of files and timestamps.
    Loop, Files, % WatchFolder "\*.*", FR    ;;∙------∙Iterate over all files in watch folder.
    {
        FileGetTime, modTime, %A_LoopFileFullPath%    ;;∙------∙Get last modification time of current file.
        NewFileList .= A_LoopFileFullPath "|" modTime "`n"    ;;∙------∙Append file path and mod time to list.
    }

    NewHash := MD5(NewFileList)    ;;∙------∙Compute hash of current file list.

    if (LastHash != NewHash) {    ;;∙------∙If contents changed since last check.
        LastHash := NewHash    ;;∙------∙Update stored hash.
        Gosub, FolderBackup    ;;∙------∙Perform backup on change.
    }
}


;;∙======∙Folder Backup Creation & Rotation∙======∙
;;∙------∙Subroutine to create a zip backup of watch folder.
FolderBackup:
{
    FormatTime, TimeDate,, MM-dd-yyyy
    FormatTime, TimeNow,, HH.mm.sstt
    StringLower, TimeNow, TimeNow    ;;∙------∙Convert AM/PM to lowercase.

        FileName := BackupFolder "\" BackupFileName " " TimeDate " " TimeNow ".zip"    ;;∙------∙Constructs full backup zip file path.

    if FileExist(FileName) {    ;;∙------∙Checks if a backup already exists for this timestamp.
        TrayTip, Backup Exists, Backup currently exists for this moment, 3, 3    ;;∙------∙Notify user that backup exists.
        return    ;;∙------∙Exit subroutine if file exists.
    }

    ;;∙------∙Compresses watch folder into zip using PowerShell.
    RunWait, % "PowerShell.exe -Command Compress-Archive -LiteralPath '" WatchFolder "' -CompressionLevel Optimal -DestinationPath '" FileName "'",, Hide

    if !FileExist(FileName) {    ;;∙------∙Verify backup file creation.
        TrayTip, Backup Failed, Failed to create backup, 3, 3    ;;∙------∙Notify user of failure.
        return    ;;∙------∙Exit subroutine on failure.
    }

    oldestFile := ""    ;;∙------∙Path to the oldest backup file found.
    FileAge := ""    ;;∙------∙Creation time of the oldest backup file.
    Count := 0    ;;∙------∙Counter for number of backup files.

    Loop, Files, % BackupFolder "\*.zip"    ;;∙------∙Iterate through existing backup ZIP files.
    {
        Count++
        if (!FileAge || (A_LoopFileTimeCreated < FileAge)) {    ;;∙------∙Find the oldest file by creation time.
            FileAge := A_LoopFileTimeCreated    ;;∙------∙Store oldest file's creation time.
            oldestFile := A_LoopFileFullPath    ;;∙------∙Store path of oldest backup.
        }
    }

    if (Count > MaxBackups) {    ;;∙------∙If exceeding max backups, delete oldest.
        FileDelete, % oldestFile    ;;∙------∙Remove the oldest backup file.
        TrayTip, Backup Rotated,Backup saved successfully`n(Oldest deleted), 3, 1    ;;∙------∙Notify user of rotation.
    }
    else {
        TrayTip, Backup Success, Backup saved successfully, 3, 1    ;;∙------∙Notify user of successful backup.
    }
}


;;∙======∙MD5 Hash Generation∙===============∙
;;∙------∙Generates String-Based MD5 hash.
MD5(string) {
    VarSetCapacity(MD5_CTX, 104, 0)    ;;∙------∙Allocate memory for MD5 context.
    DllCall("advapi32\MD5Init", "Ptr", &MD5_CTX)    ;;∙------∙Initialize MD5 context.
    DllCall("advapi32\MD5Update", "Ptr", &MD5_CTX, "AStr", string, "UInt", StrLen(string))    ;;∙------∙Update context with data.
    DllCall("advapi32\MD5Final", "Ptr", &MD5_CTX)    ;;∙------∙Finalize hash computation.
    Loop, 16    ;;∙------∙Extract each byte of the hash.
        hash .= Format("{:02x}", NumGet(MD5_CTX, 87 + A_Index, "UChar"))    ;;∙------∙Append byte as two-digit hex.
    return hash    ;;∙------∙Return final hash string.
}


;;∙======∙GetSpecialFolder (GUID Mapping)∙======∙
;;∙------∙Map friendly names to KNOWNFOLDERID GUIDs.
;;∙------∙Find the GUID for your desired folder from Microsoft’s KNOWNFOLDERID Docs. 
;;∙------∙(https://learn.microsoft.com/en-us/windows/win32/shell/knownfolderid)
GetSpecialFolder(folderName) {
    static folderMap := { Desktop:   "{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}"
                        , Documents: "{FDD39AD0-238F-46AF-ADB4-6C85480369C7}"
                        , Downloads: "{374DE290-123F-4565-9164-39C4925E467B}"
                        , Favorites: "{1777F761-68AD-4D8A-87BD-30B759FA33DD}"
                        , Music:     "{4BD8D571-6D19-48D3-BE97-422220080E43}"
                        , SavedGames:"{4C5C32FF-BB9D-43B0-B5B4-2D72E54EAAA4}"
                        , Pictures:  "{33E28130-4E1E-4676-835A-98395C3BC3BB}"
                        , Public:    "{DFDF76A2-C82A-4D63-906A-5644AC457385}"
                        , Videos:    "{18989B1D-99B5-455B-841C-AB7C74E4DDFC}"}

    if !folderMap.HasKey(folderName) {
        MsgBox,,, Invalid folder name: %folderName%,5
        ExitApp
    }
    guid := folderMap[folderName]

    ;;∙------∙Convert GUID string to binary.
    VarSetCapacity(CLSID, 16, 0)
    if !DllCall("ole32\CLSIDFromString", "WStr", guid, "Ptr", &CLSID) {
        ;;∙------∙Call SHGetKnownFolderPath.
        VarSetCapacity(folderPath, 520, 0)    ;;∙------∙Buffer for Unicode path.
        hr := DllCall("shell32\SHGetKnownFolderPath"
            , "Ptr", &CLSID    ;;∙------∙KNOWNFOLDERID.
            , "UInt", 0    ;;∙------∙dwFlags.
            , "Ptr", 0    ;;∙------∙hToken.
            , "Ptr*", pathPtr)    ;;∙------∙Receives pointer to path string.

        if (hr = 0) {    ;;∙------∙S_OK.
            folderPath := StrGet(pathPtr, "UTF-16")
            DllCall("ole32\CoTaskMemFree", "Ptr", pathPtr)
            Return folderPath
        }
    }
    MsgBox,,, Failed to get path for: %folderName%,5
    ExitApp
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
Folder-AutoBackUp:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

