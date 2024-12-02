
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙--------∙Origins∙-------------------------∙
» Author:  
» Original Source:  
» 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "SnippetSnagger"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
;;∙------------------∙Set Paths∙-----------------------------∙
    ;;∙------∙Keep the Back\Slash and change the Folder and File names between the "quotes".
    ;;∙------∙~  Same Folder\File as script  ~
    ;;∙------∙FolderPath := A_ScriptDir "\FolderName"

FolderPath := A_ScriptDir "\Snagged"

    ;;∙------∙FilePath := FolderPath "\FileName.txt"

FilePath := FolderPath "\Snips.txt"

;;∙------∙~  Separate folder\file located elsewhere  ~ *Use for full Folder and File paths.
;;∙------∙FolderPath := "C:\Full\Path\To\Your\Folder"
;;∙------∙FilePath := "C:\Full\Path\To\Your\File.txt"
;;∙-------------------------------------------------------------∙

^+c::    ;;∙------∙(Ctrl+Shift+c)∙🔥HotKey🔥
    Soundbeep, 1100, 100

ClipSaved := ClipboardAll
    Sleep, 100
Clipboard := ""
Send, ^c
ClipWait, 2
    if ErrorLevel
    {
        MsgBox,,, Copy text to clipboard has failed., 3
        return
    }
if !FileExist(FolderPath)
    {
        FileCreateDir, %FolderPath%
    }
fileContent := ""
fileSize := 0
    if FileExist(FilePath)
    {
        FileGetSize, fileSize, %FilePath%
        if (fileSize > 0)
        {
            File := FileOpen(FilePath, "r", "UTF-8")
            if !File
            {
                MsgBox,,, % "Unable to open file for reading:n" TruncatedPath(FilePath), 3
                Clipboard := TruncatedPath(FilePath)
                return
            }
            fileContent := File.Read()
            File.Close()
        }
    }
File := FileOpen(FilePath, "a", "UTF-8")
if !File
    {
        MsgBox,,, % "Unable to open or create file:n" TruncatedPath(FilePath), 3
        Clipboard := TruncatedPath(FilePath)
        return
    }
if RegExMatch(fileContent, "\S")
    {
        File.Write("`n")
    }
File.Write(Clipboard)
File.Close()
if WinExist("ahk_class Notepad")
{
    WinActivate
    WinWaitActive, ahk_class Notepad
    Sleep, 100
    WinGetTitle, NotepadTitle
    If (NotepadTitle = "Log Entries.txt - Notepad")
    {
        Send, ^{End}
            Sleep, 100
        Send, {Enter}
            Sleep, 100
        Send, ^v
            Sleep, 100
        Send, ^s
    }
    else
    {
        MsgBox,,, % "The active Notepad window is not 'Log Entries.txt'.", 3
    }
}
else
{
    Soundbeep, 1700, 75
    Sleep, 200
    ;;∙------∙Run, notepad.exe "%FilePath%"    ;;∙------∙*Leave Run commented for 'silent' text file updating.
}
Clipboard := ClipSaved
Return


;;∙------------------∙View 'txt' file∙-------------------------∙
^F1::
    Run, notepad.exe "%FilePath%"
Return

;;∙------------------∙Truncate Function∙------------------∙
TruncatedPath(Path) {
    Drive := SubStr(Path, 1, InStr(Path, "\") - 1)
    Path := SubStr(Path, InStr(Path, "\") + 1)
    LastFolder := RegExReplace(Path, ".*\\(.*)\\[^\\]*$", "$1")
    FileName := RegExReplace(Path, ".*\\([^\\]*)$", "$1")
    TruncedPath := Drive . "\...\\" . LastFolder . "\" . FileName
    return TruncedPath
}
Return
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
        SoundBeep, 1100, 75
        Soundbeep, 1200, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        Soundbeep, 1100, 75
        Soundbeep, 1000, 100
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
#MaxThreadsPerHotkey 3
#NoEnv
;;∙------∙#NoTrayIcon
#Persistent
#SingleInstance, Force
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.
SetBatchLines -1
SetTimer, UpdateCheck, 500
SetTitleMatchMode 2
SetWinDelay 0
Menu, Tray, Icon, imageres.dll, 3
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
SnippetSnagger:    ;;∙------∙Suspends hotkeys then cs script. (Script Header)
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

