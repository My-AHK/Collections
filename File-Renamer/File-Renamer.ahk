
/*------∙NOTES∙--------------------------------------------------------------------------∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu namePlate: Toggles - suspending hotkeys then pausing script.
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

;;∙========∙VARIABLES
;;∙------∙Set default folder here (example: "C:\Users\YourUsername\Documents").
DefaultFolder := "C:\Users\rjcof\Downloads\AHK Collections\AHK WIP"

;;∙------∙Single INI file for all data.
IniFile := A_ScriptDir . "\FileRenamer.ini"

;;∙------∙Load last folder from INI, or use default.
IniRead, CurrentFolder, %IniFile%, Settings, LastFolder, %DefaultFolder%

;;∙------∙If the saved folder doesn't exist, use default.
if (!FileExist(CurrentFolder))
    CurrentFolder := DefaultFolder

FileList := []    ;;∙------∙Array to store file objects with path, name, extension details.
LastCheckState := ""    ;;∙------∙Tracks previous checkbox state to detect changes.

AppendText := ""    ;;∙------∙Text to be added to filenames.
IncludeSubfolders := false    ;;∙------∙Flag for including files from subfolders.

guiColor := "151515"    ;;∙------∙Color of Gui background.
textColor := "4089FF"    ;;∙------∙Color of Gui text.

namePlate := "File-Renamer"    ;;∙------∙Header text.
namePlateColor := "003FA3"    ;;∙------∙Color of header text if not same as Gui.
namePlateTrimColor := "619EFF"    ;;∙------∙Color of header outline.

selectColor := "FFFFFF"    ;;∙------∙Color of 'Select Folder' text.
addColor := "000000"    ;;∙------∙Color of 'Text to Add' text.

lvBackColor := textColor    ;;∙------∙Color of ListView background.
lvTextColor := guiColor    ;;∙------∙Color of ListView text.

guiX := 900    ;;∙------∙X-axis position of Gui window.
guiY := 100    ;;∙------∙Y-axis position of Gui window.
guiW := 660    ;;∙------∙Width of Gui window.
guiH := 640    ;;∙------∙Height of Gui window.

;;∙========∙CREATE GUI
Gui, +AlwaysOnTop +ToolWindow -Caption +Border
Gui, Color, %guiColor%

Gui, Font, s26 Bold, Arial
Gui, Add, Text, x1 y15 w%guiW% Center c%namePlateTrimColor% BackgroundTrans, %namePlate%
;;∙------∙Gui, Add, Text, x0 y10 w%guiW% Center c%namePlateColor% BackgroundTrans, %namePlate%
Gui, Add, Text, x0 y12 w%guiW% Center c%guiColor% BackgroundTrans, %namePlate%

Gui, Font, s9 c%namePlateTrimColor%, Segoe UI
Gui, Add, Text, x0 y2 w%guiW% Center BackgroundTrans, ______________________________________________
Gui, Add, Text, x0 y40 w%guiW% Center BackgroundTrans, ______________________________________________

Gui, Add, Text, x10 y75 w80, Select Folder:
Gui, Font, c%selectColor% Norm
Gui, Add, Edit, x90 y73 w470 h20 vFolderPath ReadOnly
Gui, Font, c%textColor%
Gui, Add, Button, x570 y72 w80 h22 gBrowseFolder, Browse...

Gui, Font, Bold
Gui, Add, Text, x10 y105, Text to Add:
Gui, Font, c%addColor% Norm
Gui, Add, Edit, x90 y103 w385 h20 vAppendTextBox gUpdatePreview
Gui, Font, c%textColor% Bold
Gui, Add, Text, x+15 y105, Separator:
Gui, Font, c%addColor% Norm
Gui, Add, Edit, x+5 y103 w40 h20 vSeparatorBox gUpdatePreview, _
Gui, Font, c%textColor%
Gui, Add, Text, x+5 y105 w65, (e.g. _ - •)

Gui, Add, GroupBox, x30 y130 w600 h165 BackgroundTrans
Gui, Font, s9 c%textColor%

Gui, Font, Bold
Gui, Add, Text, x50 y145 h70, Text Placement:

Gui, Font, Norm
Gui, Add, Radio, x60 y165 Checked vPrependRadio gUpdatePreview, Prepend
Gui, Add, Radio, x+5 y165 vAppendRadio gUpdatePreview, Append
Gui, Add, Radio, x+5 y165 vReplaceRadio gUpdatePreview, Replace

Gui, Font, Bold
Gui, Add, Text, x50 y195 h70, Sequential Numbering:
Gui, Font, Norm
Gui, Add, Checkbox, x60 y215 vUseNumbering gUpdatePreview, Add Sequential Numbers
Gui, Add, Text, x+10 y215, Start Number:
Gui, Font, c%addColor%
Gui, Add, Edit, x+5 y213 w40 h20 vStartNumber gUpdatePreview, 1
Gui, Font, c%textColor%
Gui, Add, Text, x+10 y215, Padding Digits:
Gui, Font, c%addColor%
Gui, Add, Edit, x+5 y213 w40 h20 vPaddingDigits gUpdatePreview, 3
Gui, Font, c%textColor%
Gui, Add, Text, x+10 y217, (e.g. 3 = 001, 002, 003)

Gui, Font, Bold
Gui, Add, Text, x50 y247, Number Positioning:
Gui, Font, Norm
Gui, Add, Radio, x60 y267 vNumberBeforeText gUpdatePreview, Before Text
Gui, Add, Radio, x+5 y267 Checked vNumberAfterText gUpdatePreview, After Text
Gui, Add, Checkbox, x+70 y267 vIncludeSubfoldersCheck, Include files in subfolders
Gui, Add, Button, x+70 y260 w80 h22 gRefreshList, Refresh List

Gui, Font, Bold
Gui, Add, Text, x10 y310, Files in selected folder:
Gui, Font, Italic w200
Gui, Add, Text, x+5 y310, (check files to rename)
Gui, Font, c%lvTextColor% Norm
Gui, Add, ListView, x10 y330 w640 h255 vFileListView Checked Grid +LV0x4000 Background%lvBackColor%, Select|Current Name|New Name|Path

Gui, Add, Button, x15 y600 w90 h25 gSelectAll, Select All
Gui, Add, Button, x110 y600 w90 h25 gDeselectAll, Deselect All

Gui, Add, Button, x240 y600 w90 h25 gRevertFiles, Revert
Gui, Add, Button, x335 y600 w90 h25 gRenameFiles, Rename

Gui, Add, Button, x460 y600 w90 h25 gReload, Reload
Gui, Add, Button, x555 y600 w90 h25 gExit, Exit

Gui, Show, x%guiX% y%guiY% w%guiW% h%guiH%, File Name Appender/Prepender with Numbering
    GuiControl,, FolderPath, %CurrentFolder%
    GuiControl, Focus, AppendTextBox    ;;∙------∙Set focus to 'Text to Add' field on startup.
    Gosub, LoadFiles
    SetTimer, CheckCheckboxChanges, 250
Return

;;∙========∙BROWSE FOR FOLDER
BrowseFolder:
    Gui, -AlwaysOnTop
    FileSelectFolder, SelectedFolder, *%CurrentFolder%, 3, Select folder containing files for renaming.
    Gui, +AlwaysOnTop
    
    if (SelectedFolder != "")
    {
        GuiControl,, FolderPath, %SelectedFolder%
        CurrentFolder := SelectedFolder
        ;;∙------∙Remove hidden attribute before writing
        FileSetAttrib, -H, %IniFile%
        ;;∙------∙Save the new folder to INI
        IniWrite, %CurrentFolder%, %IniFile%, Settings, LastFolder
        ;;∙------∙Set INI file as hidden
        FileSetAttrib, +H, %IniFile%
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
    
    ;;∙------∙Temporary array to hold files for sorting
    TempFileList := []
    
    ;;∙------∙Get files.
    Loop, Files, %SearchPath%, % (IncludeSubfoldersCheck ? "FR" : "F")
    {
        ;;∙------∙Skip if it's a directory.
        if (InStr(FileExist(A_LoopFileFullPath), "D"))
            continue
        
        ;;∙------∙Skip the INI file.
        if (A_LoopFileName = "FileRenamer.ini")
            continue
            
        SplitPath, A_LoopFileName, , , Extension, NameNoExt
        
        FileObj := {}
        FileObj.FullPath := A_LoopFileFullPath
        FileObj.Name := A_LoopFileName
        FileObj.NameNoExt := NameNoExt
        FileObj.Extension := Extension
        FileObj.Directory := A_LoopFileDir
        
        TempFileList.Push(FileObj)
    }
    
    ;;∙------∙Sort by extension, then by name
    SortedFileList := SortFilesByExtensionAndName(TempFileList)
    
    ;;∙------∙Add sorted files to FileList & ListView
    for index, FileObj in SortedFileList
    {
        FileList.Push(FileObj)
        LV_Add("", "", FileObj.Name, "", FileObj.Directory)
    }
    
    ;;∙------∙Auto-size columns.
    LV_ModifyCol(1, 50)
    LV_ModifyCol(2, 150)
    LV_ModifyCol(3, 150)
    LV_ModifyCol(4, 400)
    
    GuiControl, +Redraw, FileListView
    Gosub, ForcePreviewUpdate
Return

;;∙========∙SORT FILES BY EXTENSION THEN NAME
SortFilesByExtensionAndName(FileArray) {
    ;;∙------∙Bubble sort.
    n := FileArray.Length()
    
    Loop, % n - 1
    {
        i := A_Index
        Loop, % n - i
        {
            j := A_Index
            
            ;;∙------∙Compare extension first.
            Ext1 := FileArray[j].Extension
            Ext2 := FileArray[j + 1].Extension
            
            ;;∙------∙Convert to lowercase for case-insensitive comparison.
            StringLower, Ext1Lower, Ext1
            StringLower, Ext2Lower, Ext2
            
            ShouldSwap := false
            
            if (Ext1Lower > Ext2Lower)
            {
                ShouldSwap := true
            }
            else if (Ext1Lower = Ext2Lower)
            {
                ;;∙------∙Same extension, compare names.
                Name1 := FileArray[j].Name
                Name2 := FileArray[j + 1].Name
                
                StringLower, Name1Lower, Name1
                StringLower, Name2Lower, Name2
                
                if (Name1Lower > Name2Lower)
                    ShouldSwap := true
            }
            
            if (ShouldSwap)
            {
                ;;∙------∙Swap elements.
                Temp := FileArray[j]
                FileArray[j] := FileArray[j + 1]
                FileArray[j + 1] := Temp
            }
        }
    }
    
    return FileArray
}

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
    Gosub, ForcePreviewUpdate
Return

;;∙========∙DESELECT ALL FILES
DeselectAll:
    GuiControl, -Redraw, FileListView
    Loop, % LV_GetCount()
    {
        LV_Modify(A_Index, "-Check")
    }
    GuiControl, +Redraw, FileListView
    Gosub, ForcePreviewUpdate
Return

;;∙========∙UPDATE LISTVIEW PREVIEW
UpdatePreview:
ForcePreviewUpdate:
    Gui, Submit, NoHide
    AppendText := AppendTextBox
    Separator := SeparatorBox
    
    GuiControl, -Redraw, FileListView
    
    ;;∙------∙First, clear ALL preview columns
    Loop, % LV_GetCount()
    {
        LV_Modify(A_Index, "Col3", "")
    }
    
    ;;∙------∙Get all checked rows & organize them by extension.
    CheckedRows := []
    CheckedByExt := {}
    
    RowNumber := 0
    Loop
    {
        RowNumber := LV_GetNext(RowNumber, "Checked")
        if not RowNumber
            break
            
        ;;∙------∙Get file extension.
        Ext := FileList[RowNumber].Extension
        if (Ext = "")
            Ext := "(no extension)"
            
        ;;∙------∙Add to extension-specific array.
        if !CheckedByExt.HasKey(Ext)
            CheckedByExt[Ext] := []
        CheckedByExt[Ext].Push(RowNumber)
    }
    
    ;;∙------∙Generate previews for checked items, with numbering restarting per extension.
    for Ext, RowArray in CheckedByExt
    {
        SequentialCounter := 0
        for index, RowNum in RowArray
        {
            ;;∙------∙Increment counter for each checked item in extension group.
            SequentialCounter++
            
            if (FileList[RowNum].NameNoExt != "")
            {
                ;;∙------∙Generate new filename.
                NewName := GenerateNewFileName(RowNum, SequentialCounter)
                LV_Modify(RowNum, "Col3", NewName)
            }
        }
    }
    
    GuiControl, +Redraw, FileListView
Return

;;∙========∙GENERATE NEW FILENAME
GenerateNewFileName(RowNum, SeqNum) {
    global

    ;;∙------∙Get base filename parts.
    NameNoExt := FileList[RowNum].NameNoExt
    Extension := FileList[RowNum].Extension
    
    ;;∙------∙Calculate the actual number to use.
    if (UseNumbering && StartNumber != "" && PaddingDigits != "")
    {
        ActualNumber := StartNumber + SeqNum - 1
        ;;∙------∙Format with zero padding.
        PaddedNumber := Format("{:0" . PaddingDigits . "d}", ActualNumber)
    }
    else
    {
        PaddedNumber := ""
    }
    
    ;;∙------∙Build new name based on settings.
    if (ReplaceRadio)
    {
        ;;∙------∙REPLACE mode - completely overwrite filename.
        if (UseNumbering && PaddedNumber != "")
        {
            if (NumberBeforeText)
            {
                ;;∙------∙Number comes first: 001-text.ext or just 001.ext.
                if (AppendText != "")
                    BaseName := PaddedNumber . Separator . AppendText
                else
                    BaseName := PaddedNumber
            }
            else
            {
                ;;∙------∙Number comes after text: text-001.ext or just 001.ext.
                if (AppendText != "")
                    BaseName := AppendText . Separator . PaddedNumber
                else
                    BaseName := PaddedNumber
            }
        }
        else
        {
            ;;∙------∙No numbering, just replace with text.
            if (AppendText != "")
                BaseName := AppendText
            else
                BaseName := NameNoExt    ;;∙------∙If no text or number, keep original.
        }
    }
    else if (PrependRadio)
    {
        ;;∙------∙PREPEND mode.
        if (UseNumbering && PaddedNumber != "")
        {
            if (NumberBeforeText)
            {
                ;;∙------∙Number comes first: 001-text-filename.ext.
                if (AppendText != "")
                    BaseName := PaddedNumber . Separator . AppendText . Separator . NameNoExt
                else
                    BaseName := PaddedNumber . Separator . NameNoExt
            }
            else
            {
                ;;∙------∙Number comes after text: text-001-filename.ext.
                if (AppendText != "")
                    BaseName := AppendText . Separator . PaddedNumber . Separator . NameNoExt
                else
                    BaseName := PaddedNumber . Separator . NameNoExt
            }
        }
        else
        {
            ;;∙------∙No numbering, just text prepending.
            if (AppendText != "")
                BaseName := AppendText . Separator . NameNoExt
            else
                BaseName := NameNoExt
        }
    }
    else
    {
        ;;∙------∙APPEND mode.
        if (UseNumbering && PaddedNumber != "")
        {
            if (NumberBeforeText)
            {
                ;;∙------∙Number comes before text: filename-001-text.ext.
                if (AppendText != "")
                    BaseName := NameNoExt . Separator . PaddedNumber . Separator . AppendText
                else
                    BaseName := NameNoExt . Separator . PaddedNumber
            }
            else
            {
                ;;∙------∙Number comes after text: filename-text-001.ext.
                if (AppendText != "")
                    BaseName := NameNoExt . Separator . AppendText . Separator . PaddedNumber
                else
                    BaseName := NameNoExt . Separator . PaddedNumber
            }
        }
        else
        {
            ;;∙------∙No numbering, just text appending.
            if (AppendText != "")
                BaseName := NameNoExt . Separator . AppendText
            else
                BaseName := NameNoExt
        }
    }
    
    ;;∙------∙Add extension if exists.
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
        Gui, -AlwaysOnTop
        MsgBox, 48, No Files Selected, Please select at least one file to rename.,4
        Gui, +AlwaysOnTop
        return
    }
    
    ;;∙------∙Validate numbering settings if enabled.
    if (UseNumbering)
    {
        if (StartNumber = "" || PaddingDigits = "")
        {
            Gui, -AlwaysOnTop
            MsgBox, 48, Invalid Numbering Settings, Please enter valid Start Number and Padding Digits.,4
            Gui, +AlwaysOnTop
            return
        }
        if (StartNumber < 0 || PaddingDigits < 1)
        {
            Gui, -AlwaysOnTop
            MsgBox, 48, Invalid Numbering Settings, Start Number must be >= 0 and Padding Digits must be >= 1.,4
            Gui, +AlwaysOnTop
            return
        }
    }
    
    ;;∙------∙Determine mode text for confirmation.
    if (ReplaceRadio)
        ModeText := "replace"
    else
        ModeText := PrependRadio ? "prepend" : "append"
    
    if (UseNumbering)
        ModeText .= " with sequential numbering"
    
    ;;∙------∙Confirm rename.
    Gui, -AlwaysOnTop
    MsgBox, 36, Confirm Rename, Are you sure you want to %ModeText% to %CheckedCount% file(s)?
    Gui, +AlwaysOnTop
    IfMsgBox No
        return
    
    ;;∙------∙Remove hidden attribute before clearing backup.
    FileSetAttrib, -H, %IniFile%
    
    ;;∙------∙Clear previous backup section.
    IniDelete, %IniFile%, Backup
    
;;∙------∙Perform rename.
    SuccessCount := 0
    ErrorCount := 0
    ErrorLog := ""
    
    ;;∙------∙Get all checked rows & organize them by extension.
    CheckedByExt := {}
    
    RowNumber := 0
    Loop
    {
        RowNumber := LV_GetNext(RowNumber, "Checked")
        if not RowNumber
            break
            
        ;;∙------∙Get file extension.
        Ext := FileList[RowNumber].Extension
        if (Ext = "")
            Ext := "(no extension)"
            
        ;;∙------∙Add to extension-specific array.
        if !CheckedByExt.HasKey(Ext)
            CheckedByExt[Ext] := []
        CheckedByExt[Ext].Push(RowNumber)
    }
    
    ;;∙------∙Rename files, with numbering restarting per extension.
    for Ext, RowArray in CheckedByExt
    {
        SequentialCounter := 0
        for index, RowNum in RowArray
        {
            SequentialCounter++
            
            OldPath := FileList[RowNum].FullPath
            SplitPath, OldPath, OldFileName
            
            ;;∙------∙Generate new filename using same function.
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
                ;;∙------∙Save mapping: NewPath=OldFileName.
                IniWrite, %OldFileName%, %IniFile%, Backup, %NewPath%
            }
        }
    }
    
    ;;∙------∙Set INI file as hidden.
    if (SuccessCount > 0)
        FileSetAttrib, +H, %IniFile%
    
    ;;∙------∙Show results.
    Gui, -AlwaysOnTop
    if (ErrorCount > 0)
    {
        MsgBox, 48, Rename Complete with Errors, Successfully renamed: %SuccessCount%`nFailed: %ErrorCount%`n`nErrors:`n%ErrorLog%,4
    }
    else
    {
        MsgBox, 64, Rename Complete, Successfully renamed %SuccessCount% file(s)!`n`nA backup file has been created for reverting.,4
    }
    Gui, +AlwaysOnTop
    
    ;;∙------∙Reload file list.
    Gosub, LoadFiles
Return

;;∙========∙CHECK FOR CHECKBOX CHANGES
CheckCheckboxChanges:
    ;;∙------∙Get current checkbox state as a string.
    CurrentState := ""
    Loop, % LV_GetCount()
    {
        if (LV_GetNext(A_Index - 1, "Checked") = A_Index)
            CurrentState .= "1"
        else
            CurrentState .= "0"
    }
    
    ;;∙------∙If state changed, update preview.
    if (CurrentState != LastCheckState)
    {
        LastCheckState := CurrentState
        Gosub, ForcePreviewUpdate
    }
Return

;;∙========∙REVERT TO ORIGINAL FILENAMES
RevertFiles:
    ;;∙------∙Remove hidden attribute to access file.
    FileSetAttrib, -H, %IniFile%
    
    ;;∙------∙Check if backup section exists.
    IniRead, BackupSection, %IniFile%, Backup
    
    if (BackupSection = "" || BackupSection = "ERROR")
    {
        Gui, -AlwaysOnTop
        MsgBox, 48, No Backup Found, No backup found. You must rename files first before reverting.,4
        Gui, +AlwaysOnTop
        return
    }
    
    ;;∙------∙Confirm revert.
    Gui, -AlwaysOnTop
    MsgBox, 36, Confirm Revert, Are you sure you want to revert all files to their original names?
    Gui, +AlwaysOnTop
    IfMsgBox No
        return
    
    SuccessCount := 0
    ErrorCount := 0
    ErrorLog := ""
    
    ;;∙------∙Parse the INI section.
    Loop, Parse, BackupSection, `n, `r
    {
        if (A_LoopField = "")
            continue
            
        ;;∙------∙Split "CurrentPath=OriginalName".
        EqualPos := InStr(A_LoopField, "=")
        if (EqualPos = 0)
            continue
            
        CurrentPath := SubStr(A_LoopField, 1, EqualPos - 1)
        OriginalName := SubStr(A_LoopField, EqualPos + 1)
        
        ;;∙------∙Check if current file exists.
        if (!FileExist(CurrentPath))
        {
            ErrorCount++
            SplitPath, CurrentPath, CurrentFileName
            ErrorLog .= "Not found: " . CurrentFileName . "`n"
            continue
        }
        
        ;;∙------∙Build original path.
        SplitPath, CurrentPath, , CurrentDir
        OriginalPath := CurrentDir . "\" . OriginalName
        
        ;;∙------∙Rename back to original.
        FileMove, %CurrentPath%, %OriginalPath%, 0
        
        if (ErrorLevel)
        {
            ErrorCount++
            SplitPath, CurrentPath, CurrentFileName
            ErrorLog .= "Failed to revert: " . CurrentFileName . "`n"
        }
        else
        {
            SuccessCount++
        }
    }
    
    ;;∙------∙Show results.
    Gui, -AlwaysOnTop
    if (ErrorCount > 0)
    {
        MsgBox, 48, Revert Complete with Errors, Successfully reverted: %SuccessCount%`nFailed: %ErrorCount%`n`nErrors:`n%ErrorLog%,4
    }
    else
    {
        MsgBox, 64, Revert Complete, Successfully reverted %SuccessCount% file(s) to original names!,4
        ;;∙------∙Delete backup section after successful revert.
        IniDelete, %IniFile%, Backup
    }
    Gui, +AlwaysOnTop
    
    ;;∙------∙Reload file list.
    Gosub, LoadFiles
Return

;;∙========∙RELOAD & EXIT
Reload:
    Reload
Return

Exit:
GuiClose:
    FileSetAttrib, -H, %IniFile%    ;;∙------∙Remove hidden attribute to access file.
    IniDelete, %IniFile%, Backup    ;;∙------∙Delete backup section but keep settings.
    FileSetAttrib, +H, %IniFile%    ;;∙------∙Set INI file as hidden again.
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
Menu, Tray, Add, Suspend / Pause, % ScriptID    ;;∙------∙Script namePlate.
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

;;∙------∙MENU-namePlate∙---------------∙
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
