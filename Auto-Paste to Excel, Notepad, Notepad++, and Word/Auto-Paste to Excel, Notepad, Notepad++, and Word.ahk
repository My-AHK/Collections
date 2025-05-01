
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
#NoEnv 
#Persistent 
#SingleInstance, Force 
SendMode Input
;;∙--------------------------------------∙ 

;;∙======∙AUTO-PASTE to EXCEL∙==================∙
;;∙------∙This script copies a selection and handles 3 columns, putting the data in the first empty cell in each column.

^1::    ;;∙------∙🔥∙(Ctrl + 1/2/3)
^2::
^3::
    Column := SubStr(A_ThisHotkey, 2) + 0    ;;∙------∙Extract column number from hotkey.
    ClipWaitTimeout := 2

    SendInput ^c
    ClipWait, %ClipWaitTimeout%
    if ErrorLevel {
        MsgBox, 48, Error, Clipboard copy failed or timed out., 3
        Return
    }

    try
        xlApp := ComObjActive("Excel.Application")
    catch {
        MsgBox, 48, Error, Excel is not running or accessible. Aborting., 5
        Return
    }

    try {
        ;;∙------∙Try to find the last used cell from the top (xlNext = 1).
        xlCell_LastUsed := xlApp.Columns(Column).Find("*",,,,,1)
        if (IsObject(xlCell_LastUsed) && xlCell_LastUsed.Value != "")
            xlCell_EmptyBelowData := xlCell_LastUsed.Offset(1, 0)
        else
            throw "Column empty"
    }
    catch {
        if (xlApp.Cells(1, Column).Value = "") {
            xlCell_EmptyBelowData := xlApp.Cells(1, Column)
        } else {
            try {
                ;;∙------∙Try from the bottom (xlPrevious = 2).
                xlCell_LastUsed := xlApp.Columns(Column).Find("*",,,,,2)
                xlCell_EmptyBelowData := xlCell_LastUsed.Offset(1, 0)
            }
            catch {
                ;;∙------∙Final fallback using End(xlUp).
                xlCell_EmptyBelowData := xlApp.Cells(xlApp.Rows.Count, Column).End(-4162).Offset(1, 0)
            }
        }
    }

    if (Clipboard != "") && IsObject(xlCell_EmptyBelowData) {
        xlCell_EmptyBelowData.Value := Clipboard
        ToolTip, Pasted to column %Column%
        SetTimer, RemoveToolTip, -1500
    } else {
        MsgBox, 48, Error, Failed to paste.`nClipboard: %Clipboard%`nCell: %xlCell_EmptyBelowData%, 5
    }
Return

RemoveToolTip:
    ToolTip
Return


;;∙======∙AUTO-PASTE to NOTEPAD∙===============∙
;;∙------∙This script copies a selection, and pastes the clipboard contents into Notepad.

^F1::    ;;∙------∙🔥∙(Ctrl + F1)
    ClipWaitTimeout := 2

    Send, ^c 
    ClipWait, %ClipWaitTimeout%
    if ErrorLevel
    {
        MsgBox, 48, Error, Clipboard copy failed., 3
        return
    }
    
    ;;∙------∙Store original clipboard.
    originalClipboard := ClipboardAll    ;;∙------∙ClipboardAll preserves format (text, images, etc.).
    clipboardContent := Clipboard    ;;∙------∙Just the text content.
    
    ;;∙------∙Try to paste to Notepad.
    try {
        IfWinExist, ahk_class Notepad 
        { 
            WinActivate 
            Send ^v {Enter} 
        } 
        else 
        { 
            Run, %A_WinDir%\notepad.exe 
            WinWait, ahk_class Notepad,, 3
            if ErrorLevel
                throw "Notepad failed to open"
            WinActivate 
            Send ^v {Enter} 
        }
    }
    catch e {
        ;;∙------∙If paste failed, restore clipboard and show error.
        Clipboard := originalClipboard
        MsgBox, 48, Error, % "Operation failed: " e, 3
        return
    }
        ;;∙------∙Clear the clipboard (original content preserved in variable if needed).
    Clipboard := ""
Return


;;∙======∙AUTO-PASTE to NOTEPAD++∙=============∙
;;∙------∙This script copies a selection, and pastes the clipboard contents into Notepad++.

^F2::    ;;∙------∙🔥∙(Ctrl + F2)
    oldClipboard := ClipboardAll    ;;∙------∙Backup & prep clipboard.
    Clipboard := ""
    ClipWaitTimeout := 2

    Send ^c
    ClipWait, %ClipWaitTimeout%
    if ErrorLevel {
        MsgBox, 48, Error, Failed to copy text to clipboard., 5
        goto RESTORE_CLIPBOARD
    }

    temp := StrReplace(Clipboard, "`r`n", " ")    ;;∙------∙Replace line breaks with spaces.

    if !WinExist("ahk_class Notepad++") {    ;;∙------∙Verify Notepad++ is running.
        MsgBox, 48, Error, Notepad++ is not running., 5
        goto RESTORE_CLIPBOARD
    }

    ;;∙------∙Find active Scintilla control (checking 3 possible names).
    scintillaControl := ""
    for each, controlName in ["Scintilla1", "Scintilla2", "Scintilla3"] {
        ControlGet, hwnd, Hwnd,, %controlName%, ahk_class Notepad++
        if hwnd {
            scintillaControl := hwnd
            break
        }
    }

    if !scintillaControl {
        MsgBox, 48, Error, Could not find Notepad++'s edit control., 5
        goto RESTORE_CLIPBOARD
    }

    ControlSend, ahk_id %scintillaControl%, %temp%{Enter}, ahk_class Notepad++
        ToolTip, Text sent to Notepad++
        SetTimer, KillTip, -1000

RESTORE_CLIPBOARD:    ;;∙------∙Cleanup & restore original clipboard.
    Clipboard := oldClipboard
    oldClipboard := ""    ;;∙------∙Free memory.
    temp := ""     ;;∙------∙Clear variable.
Return

KillTip:
    ToolTip
Return


;;∙======∙AUTO-PASTE to WORD∙==================∙
;;∙------∙This script copies a selection, and pastes the clipboard contents into Microsoft Word, in plain or formatted text.

^F3::    ;;∙------∙🔥∙(Ctrl + F3) Paste with source formatting.
    PasteInWord(true)
Return

^F4::    ;;∙------∙🔥∙(Ctrl + F4) Paste as plain text.
    PasteInWord(false)
Return


PasteInWord(UseFormatted) {
    Clipboard := ""
    ClipWaitTimeout := 2

    Send ^c
    ClipWait, %ClipWaitTimeout%
    if ErrorLevel {
        MsgBox, 48, Error, Failed to copy text to clipboard., 5
        Return
    }

        ;;∙------∙Try to access Word.
    try {
        wdApp := ComObjActive("Word.Application")
    } catch {
        MsgBox, 48, Error, Microsoft Word is not running., 5
        Return
    }

    ;;∙------∙Paste in Word (formatted or plain).
    sel := wdApp.Selection
    sel.Collapse(1)    ;;∙------∙Move cursor to start of selection.
    if (UseFormatted) {
        sel.Paste    ;;∙------∙Keep original formatting.
        PasteMode := "Formatted"
    } else {
        sel.PasteAndFormat(0)    ;;∙------∙wdFormatPlainText.
        PasteMode := "Plain Text"
    }

    ToolTip, % "Pasted as: " PasteMode
    SetTimer, KillTtip, -1500
}

;;∙--------------------------------------∙ 
KillTtip:
    ToolTip
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

