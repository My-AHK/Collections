
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  polyethene
» Original Source:  https://www.autohotkey.com/board/topic/8556-file-get-size/
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
;^t::    ;;∙------∙🔥∙(Ctrl + T)
;    Soundbeep, 1000, 200
;;∙============================================================∙




;;∙============================================================∙
;;∙============================================================∙
#NoEnv
Gui, +AlwaysOnTop -Caption +Border +Owner
Gui, Color, Black
Gui, Font, s8 w400 c676767 q5, Times New Roman
Gui, Add, Text, x0 y10 w300 Center BackgroundTrans, Select Wanted Unit Size(s) then Select A File For Retrieval

Gui, Font, s10 w400 c43A7FF q5, Arial
Gui, Add, Text, x10 y+10 BackgroundTrans, Select Unit Size:

Gui, Font, cA7A743 Bold q5
Gui, Add, Checkbox, x20 y+5 vBytes Checked gUpdateDisplay BackgroundTrans, Bytes
Gui, Add, Checkbox, x+10 vKB Checked gUpdateDisplay BackgroundTrans, KB
Gui, Add, Checkbox, x+10 vMB Checked gUpdateDisplay BackgroundTrans, MB
Gui, Add, Checkbox, x+10 vGB Checked gUpdateDisplay BackgroundTrans, GB
Gui, Add, Checkbox, x+10 vTB Checked gUpdateDisplay BackgroundTrans, TB

Gui, Font, c43A7FF Norm q5
Gui, Add, Text, x10 y+10 Right BackgroundTrans, Select File To Check:

Gui, Font, cBC5800 q5    ;;∙------∙Orange.
Gui, Add, Edit, x20 y+5 w190 h20 vFile gUpdateDisplay BackgroundTrans
Gui, Add, Button, x220 yp h20 w65 BackgroundTrans gGet_File, Get File

;;∙------∙Result display area - lime text with monospaced font for alignment.
Gui, Font, s10 w400 c22D37F q5, Consolas   ;;∙------∙Monospaced font for alignment.
Gui, Add, Text, x20 y+20 w260 h95 vResultDisplay BackgroundTrans,

;;∙------∙View/Copy button.
Gui, Font, s10 w400 c000000 q5, Arial
Gui, Add, Button, x220 yp h20 w65 h35 gViewCopy BackgroundTrans, View &&`nCopy

Gui, Font, s8 w400 c000000 q5, Calibri
Gui, Add, Button, x220 y+10 w25 h65 gRELOAD BackgroundTrans, H`nO`nM`nE
Gui, Add, Button, x+15 w25 h65 gEXIT BackgroundTrans, E`nX`nI`nT
Gui +E0x10   ;;∙------∙Drag&Drop style flag.
Gui, Show, x1450 y400 w300 h265, File Size Checker
Return


;;∙========∙FUNCTIONS∙================∙
;;∙------------------------------∙
Get_File:
    FileSelectFile, SelectedFile, 3, %A_MyDocuments%
    if (SelectedFile = "")
        Return
    GuiControl, , File, %SelectedFile%
    Gosub, UpdateDisplay
Return

UpdateDisplay:
   ;;∙------∙Clear display area immediately.
    GuiControl, , ResultDisplay, 
    
    Gui, Submit, NoHide
    
    if (File = "") {
        ;;∙------∙Keep display area blank.
        Return
    }
    
    ;;∙------∙Check if file exists.
    IfNotExist, %File%
    {
        GuiControl, , ResultDisplay, File not found!`n"%File%"
        Return
    }
    
    FileGetSize, SizeBytes, %File%
    if ErrorLevel {
        GuiControl, , ResultDisplay, Error reading file!`n"%File%"
        Return
    }
    
    if (!Bytes && !KB && !MB && !GB && !TB) {
        GuiControl, , ResultDisplay, Select at least one unit size
        Return
    }
    
    ;;∙------∙Calculate all selected units with table formatting∙------∙
    ;;∙------∙Create unit information array (label, divisor, decimals).
    UnitInfo := []
    UnitInfo.Push({Label: "bytes", Divisor: 1, Decimals: 0, Enabled: Bytes})
    UnitInfo.Push({Label: "KB",    Divisor: 1024, Decimals: 2, Enabled: KB})
    UnitInfo.Push({Label: "MB",    Divisor: 1048576, Decimals: 2, Enabled: MB})
    UnitInfo.Push({Label: "GB",    Divisor: 1073741824, Decimals: 2, Enabled: GB})
    UnitInfo.Push({Label: "TB",    Divisor: 1099511627776, Decimals: 3, Enabled: TB})
    
    ;;∙------∙Find longest label for alignment.
    MaxLabelLength := 0
    for _, Unit in UnitInfo {
        if (Unit.Enabled) {
            if (StrLen(Unit.Label) > MaxLabelLength)
                MaxLabelLength := StrLen(Unit.Label)
        }
    }
    
    ;;∙------∙Build results table.
    ResultText := "File Sizes Returned:`n"
    for _, Unit in UnitInfo {
        if (!Unit.Enabled)
            continue
            
        ;;∙------∙Calculate size.
        SizeInUnit := SizeBytes / Unit.Divisor
        
        ;;∙------∙Format label with right padding.
        LabelText := Unit.Label
        Loop % MaxLabelLength - StrLen(Unit.Label) {
            LabelText .= " "
        }
        
        ;;∙------∙Format number based on decimals.
        if (Unit.Decimals = 0) {
            FormattedSize := Format("{1:}", Round(SizeInUnit))
        } else {
            FormatStr := "{1:." Unit.Decimals "f}"
            FormattedSize := Format(FormatStr, SizeInUnit)
        }
        
        ;;∙------∙Add to result with 5 spaces after colon.
        ResultText .= LabelText ":     " FormattedSize " " Unit.Label "`n"
    }
    
    ;;∙------∙Remove trailing newline.
    ResultText := RTrim(ResultText, "`n")
    
    ;;∙------∙Show results.
    GuiControl, , ResultDisplay, %ResultText%
Return

;;∙------------------------------∙
ViewCopy:
    ;;∙------∙Get current display text.
    GuiControlGet, DisplayText,, ResultDisplay
    
    ;;∙------∙If display is blank, run update first.
    if (DisplayText = "")
        Gosub, UpdateDisplay
    
    ;;∙------∙Re-fetch after potential update.
    GuiControlGet, DisplayText,, ResultDisplay
    
    ;;∙------∙Get filename.
    GuiControlGet, FilePath,, File
    
    ;;∙------∙Prepare message based on content.
    if (DisplayText != "") {
        if (InStr(DisplayText, "File Sizes Returned:")) {
            ;;∙------∙Remove header for cleaner copy.
            SizeResults := StrReplace(DisplayText, "File Sizes Returned:`n", "")
            FullMessage := "The size of """ FilePath """ is:`n" . SizeResults
        }
        else {
            ;;∙------∙For error states.
            FullMessage := DisplayText
        }
        
        Clipboard := FullMessage
        MsgBox, 64, File Size, %FullMessage%,7
    }
    else {
        ;;∙------∙Only show message if no file is selected.
        MsgBox,,, 48, Error, No file selected!,3
    }
Return

;;∙------------------------------∙
GuiDropFiles(GuiHwnd, FileArray, CtrlHwnd, X, Y) {
    if (FileArray.MaxIndex() < 1)
        return
    
    SelectedFile := FileArray[1]
    GuiControl, , File, %SelectedFile%
    Gosub, UpdateDisplay
}
Return

;;∙------------------------------∙
RELOAD:
    Reload
Return

EXIT:
GuiClose:
    ExitApp
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

