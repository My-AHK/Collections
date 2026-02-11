
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
;;∙========∙DIRECTIVES
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force
SendMode, Input
SetBatchLines -1
SetWinDelay 0
SetTitleMatchMode 2
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")
Menu, Tray, Icon, imageres.dll, 243
ScriptID := "FileRenamer"
SetTimer, UpdateCheck, 750
GoSub, TrayMenu

;;∙========∙INITIALIZE VARIABLES
global FileList := []

;;∙------∙Set default folder here.
global CurrentFolder := ""
global CurrentFolder := "C:\Users\YourUsername\Documents""

global AppendText := ""
global IncludeSubfolders := false


;;∙========∙CREATE GUI
Gui, +AlwaysOnTop +ToolWindow -Caption +Border
Gui, Color, 151515
Gui, Font, s9 c4089FF Bold, Segoe UI
Gui, Add, Text, x10 y15 w80, Select Folder:
Gui, Font, cWhite Norm
Gui, Add, Edit, x90 y13 w470 h20 vFolderPath ReadOnly
Gui, Font, c4089FF
Gui, Add, Button, x570 y12 w80 h22 gBrowseFolder, Browse...
Gui, Font, Bold
Gui, Add, Text, x10 y45, Text to Add:
Gui, Font, cBlack Norm
Gui, Add, Edit, x90 y43 w385 h20 vAppendTextBox gUpdatePreview
Gui, Font, c4089FF Bold
Gui, Add, Text, x+15 y45, Separator:
Gui, Font, cBlack Norm
Gui, Add, Edit, x+5 y43 w40 h20 vSeparatorBox gUpdatePreview, _
Gui, Font, c4089FF
Gui, Add, Text, x+5 y45 w65, (e.g. _ - •)
Gui, Add, Radio, x90 y75 vPrependRadio gUpdatePreview, Prepend
Gui, Add, Radio, x+5 y75 Checked vAppendRadio gUpdatePreview, Append

;;∙========∙SEQUENTIAL NUMBERING
Gui, Font, Bold
Gui, Add, Text, x10 y100 w640 h70, Sequential Numbering:
Gui, Font, Norm
Gui, Add, Checkbox, x40 y120 vUseNumbering gUpdatePreview, Add Sequential Numbers

Gui, Add, Text, x+10 y120, Start Number:
Gui, Font, cBlack
Gui, Add, Edit, x+5 y118 w40 h20 vStartNumber gUpdatePreview, 1
Gui, Font, c4089FF
Gui, Add, Text, x+10 y120, Padding Digits:
Gui, Font, cBlack
Gui, Add, Edit, x+5 y118 w40 h20 vPaddingDigits gUpdatePreview, 3
Gui, Font, c4089FF
Gui, Add, Text, x+10 y122, (e.g. 3 = 001, 002, 003)
Gui, Font, Bold
Gui, Add, Text, x10 y+12, Number Positioning:
Gui, Font, Norm
Gui, Add, Radio, x40 y+5 vNumberBeforeText gUpdatePreview, Before Text
Gui, Add, Radio, x+10 yp Checked vNumberAfterText gUpdatePreview, After Text

Gui, Add, Checkbox, x+30 yp vIncludeSubfoldersCheck, Include files in subfolders
Gui, Add, Button, x+5 yp-2 w80 h22 gRefreshList, Refresh List
Gui, Font, Bold
Gui, Add, Text, x10 y205, Files in selected folder
Gui, Font, Norm
Gui, Add, Text, x+5 yp, (check files to rename):
Gui, Font, cBlack
Gui, Add, ListView, x10 y225 w640 h255 vFileListView Checked Grid +LV0x4000, Select|Current Name|New Name|Path

Gui, Add, Button, x15 y490 w90 h25 gSelectAll, Select All
Gui, Add, Button, x110 y490 w90 h25 gDeselectAll, Deselect All

Gui, Add, Button, x240 y490 w90 h25 gPreview, Preview
Gui, Add, Button, x335 y490 w90 h25 gRenameFiles, Rename

Gui, Add, Button, x460 y490 w90 h25 gReload, Reload
Gui, Add, Button, x555 y490 w90 h25 gExit, Exit

Gui, Show, w660 h530, File Name Appender/Prepender with Numbering
    GuiControl,, FolderPath, %CurrentFolder%
    Gosub, LoadFiles
Return

;;∙========∙BROWSE FOR FOLDER
BrowseFolder:
    FileSelectFolder, SelectedFolder, , 3, Select a folder containing files to rename
    if (SelectedFolder != "")
    {
        GuiControl,, FolderPath, %SelectedFolder%
        CurrentFolder := SelectedFolder
        Gosub, LoadFiles
    }
Return

;;∙========∙LOAD FILES FROM SELECTED FOLDER
LoadFiles:
    Gui, Submit, NoHide
    GuiControl, -Redraw, FileListView
    LV_Delete()
    FileList := []
    
    if (CurrentFolder = "")
        return
    
    ;;∙------∙Determine search pattern.
    if (IncludeSubfoldersCheck)
        SearchPath := CurrentFolder . "\*.*"
    else
        SearchPath := CurrentFolder . "\*.*"
    
    ;;∙------∙Get files.
    Loop, Files, %SearchPath%, % (IncludeSubfoldersCheck ? "FR" : "F")
    {
        ;;∙------∙Skip if it's a directory.
        if (InStr(FileExist(A_LoopFileFullPath), "D"))
            continue
            
        SplitPath, A_LoopFileName, , , Extension, NameNoExt
        
        FileObj := {}
        FileObj.FullPath := A_LoopFileFullPath
        FileObj.Name := A_LoopFileName
        FileObj.NameNoExt := NameNoExt
        FileObj.Extension := Extension
        FileObj.Directory := A_LoopFileDir
        
        FileList.Push(FileObj)
        
        ;;∙------∙Add to ListView (unchecked by default).
        LV_Add("", "", A_LoopFileName, "", A_LoopFileDir)
    }
    
    ;;∙------∙Auto-size columns.
    LV_ModifyCol(1, 50)
    LV_ModifyCol(2, 150)
    LV_ModifyCol(3, 150)
    LV_ModifyCol(4, 400)
    
    GuiControl, +Redraw, FileListView
    Gosub, UpdatePreview
Return

;;∙========∙REFRESH FILE LIST
RefreshList:
    Gosub, LoadFiles
Return

;;∙========∙SELECT ALL FILES
SelectAll:
    GuiControl, -Redraw, FileListView
    Loop, % LV_GetCount()
    {
        LV_Modify(A_Index, "Check")
    }
    GuiControl, +Redraw, FileListView
    Gosub, UpdatePreview
Return

;;∙========∙DESELECT ALL FILES
DeselectAll:
    GuiControl, -Redraw, FileListView
    Loop, % LV_GetCount()
    {
        LV_Modify(A_Index, "-Check")
    }
    GuiControl, +Redraw, FileListView
    Gosub, UpdatePreview
Return

;;∙========∙PREVIEW CHANGES
Preview:
    Gosub, UpdatePreview
    MsgBox, 64, Preview Updated, Preview has been updated in the "New Name" column.
Return

;;∙========∙UPDATE LISTVIEW PREVIEW
UpdatePreview:
    Gui, Submit, NoHide
    AppendText := AppendTextBox
    Separator := SeparatorBox
    
    GuiControl, -Redraw, FileListView
    
    ;;∙------∙Initialize counter for sequential numbering
    SequentialCounter := 0
    
    Loop, % LV_GetCount()
    {
        RowNum := A_Index
        
        if (FileList[RowNum].NameNoExt != "")
        {
            ;;∙------∙Increment counter for checked items only (for preview purposes)
            SequentialCounter++
            
            ;;∙------∙Generate the new filename
            NewName := GenerateNewFileName(RowNum, SequentialCounter)
            
            LV_Modify(RowNum, "Col3", NewName)
        }
    }
    
    GuiControl, +Redraw, FileListView
Return

;;∙========∙GENERATE NEW FILENAME
GenerateNewFileName(RowNum, SeqNum) {
    global FileList, AppendText, Separator, PrependRadio, UseNumbering, StartNumber, PaddingDigits, NumberBeforeText
    
    ;;∙------∙Get base filename parts
    NameNoExt := FileList[RowNum].NameNoExt
    Extension := FileList[RowNum].Extension
    
    ;;∙------∙Calculate the actual number to use
    if (UseNumbering && StartNumber != "" && PaddingDigits != "")
    {
        ActualNumber := StartNumber + SeqNum - 1
        ;;∙------∙Format with zero padding
        PaddedNumber := Format("{:0" . PaddingDigits . "d}", ActualNumber)
    }
    else
    {
        PaddedNumber := ""
    }
    
    ;;∙------∙Build the new name based on settings
    if (PrependRadio)
    {
        ;;∙------∙PREPEND mode
        if (UseNumbering && PaddedNumber != "")
        {
            if (NumberBeforeText)
            {
                ;;∙------∙Number comes first: 001-text-filename.ext
                if (AppendText != "")
                    BaseName := PaddedNumber . Separator . AppendText . Separator . NameNoExt
                else
                    BaseName := PaddedNumber . Separator . NameNoExt
            }
            else
            {
                ;;∙------∙Number comes after text: text-001-filename.ext
                if (AppendText != "")
                    BaseName := AppendText . Separator . PaddedNumber . Separator . NameNoExt
                else
                    BaseName := PaddedNumber . Separator . NameNoExt
            }
        }
        else
        {
            ;;∙------∙No numbering, just text prepending
            if (AppendText != "")
                BaseName := AppendText . Separator . NameNoExt
            else
                BaseName := NameNoExt
        }
    }
    else
    {
        ;;∙------∙APPEND mode
        if (UseNumbering && PaddedNumber != "")
        {
            if (NumberBeforeText)
            {
                ;;∙------∙Number comes before text: filename-001-text.ext
                if (AppendText != "")
                    BaseName := NameNoExt . Separator . PaddedNumber . Separator . AppendText
                else
                    BaseName := NameNoExt . Separator . PaddedNumber
            }
            else
            {
                ;;∙------∙Number comes after text: filename-text-001.ext
                if (AppendText != "")
                    BaseName := NameNoExt . Separator . AppendText . Separator . PaddedNumber
                else
                    BaseName := NameNoExt . Separator . PaddedNumber
            }
        }
        else
        {
            ;;∙------∙No numbering, just text appending
            if (AppendText != "")
                BaseName := NameNoExt . Separator . AppendText
            else
                BaseName := NameNoExt
        }
    }
    
    ;;∙------∙Add extension if exists
    if (Extension != "")
        return BaseName . "." . Extension
    else
        return BaseName
}

;;∙========∙RENAME SELECTED FILES
RenameFiles:
    Gui, Submit, NoHide
    AppendText := AppendTextBox
    Separator := SeparatorBox
    
    ;;∙------∙Count checked items.
    CheckedCount := 0
    Loop, % LV_GetCount()
    {
        if (LV_GetNext(A_Index - 1, "Checked") = A_Index)
            CheckedCount++
    }
    
    if (CheckedCount = 0)
    {
        MsgBox, 48, No Files Selected, Please select at least one file to rename.
        return
    }
    
    ;;∙------∙Validate numbering settings if enabled
    if (UseNumbering)
    {
        if (StartNumber = "" || PaddingDigits = "")
        {
            MsgBox, 48, Invalid Numbering Settings, Please enter valid Start Number and Padding Digits.
            return
        }
        if (StartNumber < 0 || PaddingDigits < 1)
        {
            MsgBox, 48, Invalid Numbering Settings, Start Number must be >= 0 and Padding Digits must be >= 1.
            return
        }
    }
    
    ;;∙------∙Determine mode text for confirmation.
    ModeText := PrependRadio ? "prepend" : "append"
    
    if (UseNumbering)
        ModeText .= " with sequential numbering"
    
    ;;∙------∙Confirm rename.
    MsgBox, 36, Confirm Rename, Are you sure you want to %ModeText% to %CheckedCount% file(s)?
    IfMsgBox No
        return
    
    ;;∙------∙Perform rename.
    SuccessCount := 0
    ErrorCount := 0
    ErrorLog := ""
    SequentialCounter := 0
    
    Loop, % LV_GetCount()
    {
        RowNum := A_Index
        
        ;;∙------∙Check if this row is checked.
        if (LV_GetNext(RowNum - 1, "Checked") = RowNum)
        {
            SequentialCounter++
            
            OldPath := FileList[RowNum].FullPath
            
            ;;∙------∙Generate new filename using the same function
            NewFileName := GenerateNewFileName(RowNum, SequentialCounter)
            
            NewPath := FileList[RowNum].Directory . "\" . NewFileName
            
            ;;∙------∙Attempt to rename.
            FileMove, %OldPath%, %NewPath%, 0
            
            if (ErrorLevel)
            {
                ErrorCount++
                ErrorLog .= "Failed: " . FileList[RowNum].Name . "`n"
            }
            else
            {
                SuccessCount++
            }
        }
    }
    
    ;;∙------∙Show results.
    if (ErrorCount > 0)
    {
        MsgBox, 48, Rename Complete with Errors, Successfully renamed: %SuccessCount%`nFailed: %ErrorCount%`n`nErrors:`n%ErrorLog%
    }
    else
    {
        MsgBox, 64, Rename Complete, Successfully renamed %SuccessCount% file(s)!
    }
    
    ;;∙------∙Reload file list.
    Gosub, LoadFiles
Return

;;∙========∙RELOAD & EXIT
Reload:
    Reload
Return

Exit:
GuiClose:
    ExitApp
Return

;;∙========∙Gui Drag
WM_LBUTTONDOWNdrag() {
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
FileRenamer:    ;;∙------∙Suspends hotkeys then pauses script.
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


