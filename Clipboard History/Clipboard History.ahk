
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  ManaUser
» Original Source:  https://www.autohotkey.com/board/topic/32719-clipboard-history/
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
» Tray icon behavior: Right-click shows options to clear history or open GUI.
» GUI preview: Shows clipboard history with selectable entries and preview.
» Save/load history to file: Preserves clipboard history between sessions.
» Paste directly via hotkey: Press Win+Enter to paste the currently selected item.

∙------------∙🔥∙HOTKEYS∙🔥∙------------∙
Win+Up		 -- Previous item
Win+Down	 -- Next item
Win+Delete	 -- Delete current
Win+Shift+Delete	 -- Clear all
Win+Ctrl+Delete	 -- Empty clipboard
Win+Space	 -- Open history GUI
Win+Enter	 -- Paste current item
*/

#SingleInstance Force
#NoEnv
Menu, Tray, Icon, Shell32.dll, 22, 1
Menu, Tray, Add, Open Clipboard History, ShowHistoryGui
Menu, Tray, Add, Clear Clipboard History, ClearHistory
Menu, Tray, Default, Open Clipboard History

MAX_CLIPS := 10
TIP_DELAY := 2
DATA_FILE := A_ScriptDir "\ClipHistory.bin"

LastClip := 0
NewClip := 0
CurClip := 0
Watch := 1

LoadHistory()
SetTimer, WatchWait, -1000
Return
∙===============================================∙
;;∙======∙Clipboard navigation∙=====================∙
#Up::
#Down::
    If (LastClip = 0)
        Return
    CurClip += (A_ThisHotkey = "#Down") ? 1 : -1
    If (CurClip < 1)
        CurClip := LastClip
    If (CurClip > LastClip)
        CurClip := 1
    ShowPreview(SavedShortClip%CurClip%)
    Watch := 0
    Clipboard := SavedClip%CurClip%
    SetTimer, WatchWait, -1000
Return

;;∙======∙Delete single clipboard entry∙==============∙
#Delete::
    If (LastClip = 0)
        Return
    SavedClip%CurClip% :=
    SavedShortClip%CurClip% :=
    Collapse(CurClip)
    ShowPreview("Deleted item.")
Return

;;∙======∙Clear entire clipboard history∙==============∙
#+Delete::
ClearHistory:
    Loop, %MAX_CLIPS%
    {
        SavedClip%A_Index% :=
        SavedShortClip%A_Index% :=
    }
    LastClip := 0
    NewClip := 0
    CurClip := 0
    ShowPreview("Clipboard History Cleared.")
    FileDelete, %DATA_FILE%
Return

;;∙======∙Clear actual clipboard contents∙=============∙
#^Delete::
    Clipboard :=
    ShowPreview("Clipboard Cleared.")
Return

;;∙======∙Open GUI clipboard history∙================∙
#Space::
ShowHistoryGui:
    Gui, Destroy
    Gui, Add, ListBox, vClipList gClipSelect w400 h200
    Gui, Add, Edit, vClipPreview w400 h80 ReadOnly
    Loop, %LastClip%
        GuiControl,, ClipList, % A_Index ": " SavedShortClip%A_Index%
    Gui, Show, , Clipboard History Viewer
Return

ClipSelect:
    GuiControlGet, ClipList
    index := RegExReplace(ClipList, "[:].*")
    GuiControl,, ClipPreview, % SavedShortClip%index%
    CurClip := index
Return

;;∙======∙Paste current entry with hotkey∙============∙
#Enter::
    If (CurClip > 0)
    {
        ClipBak := ClipboardAll
        Clipboard := SavedClip%CurClip%
        SendInput, ^v
        Sleep, 50
        Clipboard := ClipBak
        ClipBak := ""
    }
Return

;;∙======∙Clipboard watcher∙=======================∙
OnClipboardChange:
    If (Watch = 0 OR A_EventInfo = 0)
    {
        Watch := 0
        SetTimer, WatchWait, -1000
        Return
    }

    If (A_EventInfo = 1)
    {
        NewClip++
        If (NewClip > MAX_CLIPS)
            NewClip := 1
        If (NewClip > LastClip)
            LastClip := NewClip
        CurClip := NewClip
        SavedClip%NewClip% := ClipboardAll
        Temp := Clipboard
        Temp := RegExReplace(Temp, "^\s*|\s*$", "")
        If (StrLen(Temp) > 100 OR InStr(Temp, "`n"))
            Temp := RegExReplace(Temp, "`as)^([^`r`n]{1,50}).*?([^`r`n]{1,50})$", "$1...`n...$2")
        SavedShortClip%NewClip% := Temp
        SaveHistory()
    }
Return

;;∙======∙Clipboard monitoring resume∙==============∙
WatchWait:
    Watch := 1
Return

;;∙======∙Collapse entries upward∙==================∙
Collapse(Position)
{
    Global
    If (CurClip > Position)
        CurClip--
    Loop
    {
        Temp := Position + 1
        SavedClip%Position% := SavedClip%Temp%
        SavedShortClip%Position% := SavedShortClip%Temp%
        Position++
        If (Position >= LastClip)
            Break
    }
    SavedClip%LastClip% :=
    SavedShortClip%LastClip% :=
    LastClip--
    If (NewClip > LastClip)
        NewClip := LastClip
    SaveHistory()
}

;;∙======∙Tooltip preview display∙===================∙
ShowPreview(text)
{
    ToolTip, %text%
    SetTimer, KillToolTip, % TIP_DELAY * -1000
}

KillToolTip:
    ToolTip
Return

;;∙======∙Save clipboard history to disk∙==============∙
SaveHistory()
{
    Global
    FileDelete, %DATA_FILE%
    FileAppend, %LastClip%`n%NewClip%`n%CurClip%`n, %DATA_FILE%
    Loop, %LastClip%
    {
        FileAppend, % SavedShortClip%A_Index% "`n", %DATA_FILE%
        FileAppend, % SavedClip%A_Index% "`n<<<END>>>\n", %DATA_FILE%
    }
}

;;∙======∙Load clipboard history from disk∙===========∙
LoadHistory()
{
    Global
    IfNotExist, %DATA_FILE%
        Return
    FileRead, content, %DATA_FILE%
    Loop, Parse, content, `n
    {
        If (A_Index = 1)
            LastClip := A_LoopField
        Else If (A_Index = 2)
            NewClip := A_LoopField
        Else If (A_Index = 3)
            CurClip := A_LoopField
        Else
        {
            static i := 1, mode := 0, clipData := ""
            If (mode = 0)
            {
                SavedShortClip%i% := A_LoopField
                mode := 1
            }
            Else
            {
                If (A_LoopField = "<<<END>>>")
                {
                    SavedClip%i% := clipData
                    clipData := "", mode := 0, i++
                }
                Else
                    clipData .= A_LoopField "`n"
            }
        }
    }
}
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

