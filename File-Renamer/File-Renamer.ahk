

;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙
;;∙========∙DIRECTIVES∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force
SendMode, Input
SetBatchLines -1
SetWinDelay 0
SetTitleMatchMode 2
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui drag.
OnMessage(0x0200, "WM_MOUSEMOVE")    ;;∙------∙ListView cell hover tooltip.
OnMessage(0x0232, "WM_EXITSIZEMOVE")    ;;∙------∙Detect when window stops moving.
Menu, Tray, Icon, imageres.dll, 243
SetTimer, UpdateCheck, 750    ;;∙------∙Auto Save upon script saves.
ScriptID := "File-Renamer"

;;∙========∙VARIABLES∙
;;∙------∙Set default folder here (example: "C:\Users\YourUsername\Documents").
DefaultFolder := "C:\Users\" . A_UserName . "\Downloads\AHK Collections\AHK WIP"

;;∙------∙INI file for all data.
IniFile := A_ScriptDir . "\FileRenamer.ini"

;;∙------∙Set to true to set INI file attribute to hidden, false to keep INI file visible.
HideIniFile := true

;;∙------∙Clickable header area width in pixels (centered).
HeaderClickWidth := 230

;;∙------∙Load last folder from INI, or use default.
Gosub, UnhideIni
IniRead, CurrentFolder, %IniFile%, Settings, LastFolder, %DefaultFolder%
Gosub, HideIni

;;∙------∙If saved folder doesn't exist, use default.
if (!FileExist(CurrentFolder))
    CurrentFolder := DefaultFolder

FileList := []    ;;∙------∙Array to store file objects for listview.
LastCheckState := ""    ;;∙------∙Tracks checkbox states to detect changes.
AppendText := ""    ;;∙------∙Text to append/prepend to filenames.

guiColor := "151515"    ;;∙------∙Main Gui background color (very dark gray).
textColor := "4089FF"    ;;∙------∙Primary text color (blue).

namePlate := "File-Renamer"    ;;∙------∙Window title/header text.
namePlateColor := "619EFF"    ;;∙------∙Header trim/accent color (light blue).

GoSub, TrayMenu    ;;∙------∙Custom Tray Menu.

;;∙------∙Gui visibility tracking.
GuiVisible := true
TrayMenuName := "Hide " . namePlate

selectColor := "FFFFFF"    ;;∙------∙Color for selected/active elements (white).
addColor := "000000"    ;;∙------∙Color for input fields (black).

lvBackColor := textColor   ;;∙------∙ListView background color (uses textColor blue).
lvTextColor := guiColor    ;;∙------∙ListView text color (uses guiColor dark gray).

guiX := 700    ;;∙------∙Default GUI X-axis.
guiY := 50    ;;∙------∙Default GUI Y-axis.
guiW := 660    ;;∙------∙GUI width.
guiH := 885    ;;∙------∙GUI height.

;;∙------∙Load last window position from INI, or use defaults.
Gosub, UnhideIni
IniRead, guiX, %IniFile%, Settings, GuiX, %guiX%
IniRead, guiY, %IniFile%, Settings, GuiY, %guiY%
Gosub, HideIni

trimLineColor := namePlateColor    ;;∙------∙Inner trim line color (uses trim/accent color).
trimLineWidth := "1"    ;;∙------∙Inner trim line width in pixels.
guiEdge := "0"    ;;∙------∙Inner trim offset from edge.

trimLineColor2 := namePlateColor   ;;∙------∙Outer trim line color (uses trim/accent color).
trimLineWidth2 := "1"    ;;∙------∙Outer trim line width in pixels.
guiEdge2 := "3"    ;;∙------∙Outer trim offset from edge.

CaseMode := "None"    ;;∙------∙Default case transformation (None/UPPERCASE/lowercase/Title Case/Sentence case/iNVERT cASE).
CreateFoldersByExt := false    ;;∙------∙Sort renamed files into extension-based subfolders (e.g., /jpg/, /mp3/, /docx/).

;;∙------∙Date/Time format variables (edit formatting to preference).
dateFormatStr := "MM-dd-yyyy"    ;;∙------∙Date format for filename insertion.
timeFormatStr := "hh∙mm∙ss tt"    ;;∙------∙Default time format (12-hour with AM/PM).

;;∙============================================================∙
;;∙========∙CREATE GUI∙
Gui, +AlwaysOnTop -Caption +ToolWindow
Gui, Margin, %guiEdge%, %guiEdge%
Gui, Color, %guiColor%

;;∙------∙GUI OUTER TRIM LINES∙
GuiAddTrim1(trimLineColor, trimLineWidth, "x" guiEdge " y" guiEdge " w" guiW-guiEdge*2 " h" guiH-guiEdge*2)
GuiAddTrim2(trimLineColor2, trimLineWidth2, "x" guiEdge2 " y" guiEdge2 " w" guiW-guiEdge2*2 " h" guiH-guiEdge2*2)

;;∙------∙GUI HEADER∙
Gui, Font, s26 q5 Bold, Arial
Gui, Add, Text, x1 y15 w%guiW% Center c%namePlateColor% BackgroundTrans, %namePlate%
Gui, Add, Text, x0 y12 w%guiW% Center c%guiColor% BackgroundTrans, %namePlate%

;;∙------∙Invisible clickable area centered at the top for hiding GUI.
clickX := ((guiW - HeaderClickWidth) // 2) - 2
Gui, Add, Text, x%clickX% y12 w%HeaderClickWidth% h38 HwndhText BackgroundTrans gHideGui
    GuiTip(hText, "Click to hide/show window")

;;∙------∙HEADER BOUNDRIES∙
Gui, Font, s9 q5 c%namePlateColor%, Segoe UI
Gui, Add, Text, x0 y2 w%guiW% Center BackgroundTrans, ______________________________________________
Gui, Add, Text, x0 y40 w%guiW% Center BackgroundTrans, ______________________________________________

;;∙------∙FOLDER SELECTION∙
Gui, Add, Text, x30 y75, Select Folder:
Gui, Font, q5 c%selectColor% Norm
Gui, Add, Edit, x110 y73 w425 h20 vFolderPath ReadOnly
Gui, Font, q5 c%textColor%
Gui, Add, Button, x+10 y72 w80 h22 HwndhText gBrowseFolder, Browse...
    GuiTip(hText, "Select a different folder")

;;∙------∙TEXT TO ADD∙
Gui, Font, q5 Bold
Gui, Add, Text, x30 y110, Text to Add:
Gui, Font, q5 c%addColor% Norm
Gui, Add, Edit, x110 y108 w335 h20 HwndhText vAppendTextBox gUpdatePreview
    GuiTip(hText, "Text added to all selected filenames")

;;∙------∙SEPARATOR∙
Gui, Font, q5 c%textColor% Bold
Gui, Add, Text, x+25 y110, Separator:
Gui, Font, q5 c%addColor% Norm
Gui, Add, Edit, x+5 y108 w40 h20 HwndhText vSeparatorBox gUpdatePreview, _
    GuiTip(hText, "Character between`nfilename & added text")
Gui, Font, s8 q5 c%textColor% Italic
Gui, Add, Text, x+5 y106 w55, (e.g. _ - •)

;;∙========∙TEXT PLACEMENT GROUP∙
Gui, Add, GroupBox, x30 y140 w600 h100 BackgroundTrans
Gui, Font, s9 q5 c%textColor% Norm
Gui, Font, q5 Bold
Gui, Add, Text, x50 y155 h70, Text Placement:
Gui, Font, q5 Norm
Gui, Add, Radio, x60 y175 Checked vPrependRadio gUpdateMode Group, Prepend
Gui, Add, Radio, x+15 y175 vAppendRadio gUpdateMode, Append
Gui, Add, Radio, x+15 y175 vReplaceRadio gUpdateMode, Replace Entire Name
Gui, Add, Radio, x+15 y175 vFindReplaceRadio gUpdateMode, Find && Replace

;;∙------∙FIND & REPLACE CONTROLS∙
Gui, Font, q5 c%textColor%
Gui, Add, Text, x60 y200, Find:
Gui, Font, q5 c%addColor%
Gui, Add, Edit, x+5 y198 w150 h20 vFindTextBox gUpdatePreview
Gui, Font, c%textColor%
Gui, Add, Text, x+15 y200, Replace with:
Gui, Font, q5 c%addColor%
Gui, Add, Edit, x+5 y198 w150 h20 HwndhText vReplaceTextBox gUpdatePreview
    GuiTip(hText, "Leave empty to`nremove found text.")
Gui, Font, s7 q5 c%textColor% Italic
Gui, Add, Text, x+5 y196, (leave empty to remove text)

;;∙========∙SEQUENTIAL NUMBERING GROUP∙
Gui, Add, GroupBox, x30 y245 w600 h100 BackgroundTrans
Gui, Font, s9 q5 c%textColor% Norm
Gui, Font, q5 Bold
Gui, Add, Text, x50 y260 h70, Sequential Numbering:
Gui, Font, q5 Norm
Gui, Add, Checkbox, x60 y280 w15 h15 vUseNumbering gUpdateMode
Gui, Add, Text, x+5 y280 BackgroundTrans, Add Sequential Numbers

;;∙------∙START NUMBER∙
Gui, Add, Text, x250 y280, Start Number:
Gui, Font, q5 c%addColor%
Gui, Add, Edit, x+5 y278 w40 h20 vStartNumber gUpdatePreview, 1
Gui, Font, q5 c%textColor%

;;∙------∙PADDING∙
Gui, Add, Text, x+20 y280, Padding:
Gui, Font, q5 c%addColor%
Gui, Add, Edit, x+5 y278 w40 h20 HwndhText vPaddingDigits gUpdatePreview, 1
    GuiTip(hText, "Number of digits:`n  3 = 001, 002, 003")
Gui, Font, s7 q5 c%textColor% Italic
Gui, Add, Text, x+5 y276, (e.g. 3 = 001, 002, 003)

;;∙------∙NUMBER POSITIONING∙
Gui, Font, s9 q5 Norm
Gui, Add, Text, x60 y310, Number Positioning:
Gui, Font, q5 Norm
Gui, Add, Radio, x+15 y310 w15 h15 vNumberBeforeText gUpdateMode Group
Gui, Add, Text, x+5 y310 BackgroundTrans, Before Text
Gui, Add, Radio, x+15 y310 w15 h15 Checked vNumberAfterText gUpdateMode
Gui, Add, Text, x+5 y310 BackgroundTrans, After Text

;;∙========∙CHANGE CASE & EXTENSION FILTER GROUP∙
Gui, Add, GroupBox, x30 y350 w600 h120 BackgroundTrans
Gui, Font, s9 q5 c%textColor% Bold
Gui, Add, Text, x50 y375, Change Case:
Gui, Font, q5 c%addColor% Norm
Gui, Add, DropDownList, x+5 y373 w120 vCaseMode gUpdatePreview, None|UPPERCASE|lowercase|Title Case|Sentence case|iNVERT cASE

;;∙------∙FILTER BY EXTENTION∙
Gui, Font, s9 q5 c%textColor% Bold
Gui, Add, Text, x300 y375, Filter by Extension:
Gui, Font, q5 c%addColor% Norm
Gui, Add, Edit, x+5 y373 HwndhText w80 h25 vExtFilterBox gRefreshList
    GuiTip(hText, " Filter by extension`nwith or without dot`n(e.g.  mp3 or .mp3)")
Gui, Font, s7 q5 c%textColor% Italic
Gui, Add, Text, x+5 y371, (e.g. mp3 or leave blank for all)
Gui, Font, s9 q5 c%textColor% Norm

;;∙------∙EXTENSION SUBFOLDERS∙
Gui, Add, Checkbox, x60 y410 vCreateFoldersCheck, Sort into extension subfolders
Gui, Font, s7 q5 c%textColor% Italic
Gui, Add, Text, x+2 y408, (e.g. .jpg → /jpg/, .mp3 → /mp3/)

;;∙------∙INCLUDE SUBFOLDERS∙
Gui, Font, s9 q5 c%textColor% Norm
Gui, Add, Checkbox, x60 y435 vIncludeSubfoldersCheck, Include Subfolders

;;∙------∙REFRESH LIST BUTTON∙
Gui, Add, Button, x530 y430 w80 h25 HwndhText gRefreshList, Refresh List
    GuiTip(hText, "Reload files with current filter")

;;∙========∙DATE/TIME GROUP∙
Gui, Add, GroupBox, x230 y425 w235 h45 BackgroundTrans
Gui, Add, Checkbox, x240 y445 vInsertDate gUpdateMode, Insert Date
Gui, Add, Checkbox, x+5 y445 vInsertTime gUpdateMode, Insert Time
Gui, Font, s6 q5 c%textColor% Norm
Gui, Add, Checkbox, x+3 y442 HwndhText vUse24Hour gUpdatePreview, 24-Hour
    GuiTip(hText, "   Toggle time`n     between`n12 and 24 hour")
Gui, Font, s9 q5 c%textColor% Norm

;;∙========∙TRIM CHARACTERS GROUP∙
Gui, Add, GroupBox, x30 y475 w600 h50 BackgroundTrans
Gui, Font, s9 q5 c%textColor% Bold
Gui, Add, Text, x50 y490, Trim Characters:
Gui, Font, q5 Norm
Gui, Add, Text, x160 y492, Trim from Start:
Gui, Font, q5 c%addColor%
Gui, Add, Edit, x+5 y490 w45 h20 HwndhText vTrimStartChars gUpdatePreview, 0
    GuiTip(hText, "Removes characters`nbefore other changes`nare applied.")
Gui, Font, q5 c%textColor%
Gui, Add, Text, x+15 y492, Trim from End:
Gui, Font, q5 c%addColor%
Gui, Add, Edit, x+5 y490 w45 h20 HwndhText vTrimEndChars gUpdatePreview, 0
    GuiTip(hText, "Removes characters`nbefore other changes`nare applied.")
Gui, Font, s7 q5 c%textColor% Italic
Gui, Add, Text, x+5 y488, (0 = no trim, trims before any other changes)

;;∙========∙FILE LIST∙
Gui, Font, q5 s9 c%textColor% Norm Bold
Gui, Add, Text, x10 y540 h20 HwndhText gDum, Files in Selected Folder:
    GuiTip(hText, "Select files for Renaming.")
Gui, Font, s7 w200 q5 Italic
Gui, Add, Text, x+5 y540, (check files to rename)
Gui, Font, s9 q5 c%lvTextColor% Norm
Gui, Add, ListView, x10 y560 w640 h265 vFileListView Checked Grid +LV0x4000 +LV0x8000 c%lvTextColor% Background%lvBackColor% HwndhFileListView, Select|Current Name|New Name|Path

;;∙========∙BOTTOM ROW BUTTONS∙
Gui, Add, Button, x15 y840 w90 h25 gSelectAll, Select All
Gui, Add, Button, x110 y840 w90 h25 gDeselectAll, Deselect All
Gui, Add, Button, x240 y840 w90 h25 HwndhText gRevertFiles, Revert
    GuiTip(hText, "Restore selected files`nto original names`nusing backup.")
Gui, Add, Button, x335 y840 w90 h25 HwndhText gRenameFiles, Rename
    GuiTip(hText, "Applies changes to`nall checked files.")
Gui, Add, Button, x460 y840 w90 h25 gReload, Reload
Gui, Add, Button, x555 y840 w90 h25 gExit, Exit

;;∙========∙GUI SHOW∙
Gui, Show, x%guiX% y%guiY% w%guiW% h%guiH%, File Renamer with Find & Replace
    GuiControl,, FolderPath, %CurrentFolder%
    GuiControl, Focus, AppendTextBox
    GuiControl, Choose, CaseMode, None
    Gosub, LoadFiles
    Gosub, UpdateMode
    SetTimer, CheckCheckboxChanges, 250
Return

;;∙============================================================∙
;;∙========∙BROWSE FOR FOLDER∙
BrowseFolder:
    Gui, -AlwaysOnTop
    FileSelectFolder, SelectedFolder, *%CurrentFolder%, 3, Select folder containing files for renaming.
    Gui, +AlwaysOnTop
    if (SelectedFolder != "")
    {
        GuiControl,, FolderPath, %SelectedFolder%
        CurrentFolder := SelectedFolder
        Gosub, UnhideIni
        IniWrite, %CurrentFolder%, %IniFile%, Settings, LastFolder
        Gosub, HideIni
        Gosub, LoadFiles
    }
Return

;;∙========∙LOAD FILES FROM SELECTED FOLDER∙
LoadFiles:
    Gui, Submit, NoHide
    ExtFilter := Trim(ExtFilterBox)
    if (ExtFilter != "")
        ExtFilter := RegExReplace(ExtFilter, "^\.", "")
    GuiControl, -Redraw, FileListView
    LV_Delete()
    FileList := []
    if (CurrentFolder = "")
        return
    SearchPath := CurrentFolder . "\*.*"
    TempFileList := []
    Loop, Files, %SearchPath%, % (IncludeSubfoldersCheck ? "FR" : "F")
    {
        if (A_LoopFileAttrib ~= "^[^.]*D")
            continue
        if (A_LoopFileName = "FileRenamer.ini")
            continue
        if (ExtFilter != "" && A_LoopFileExt != ExtFilter)
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
    SortedFileList := SortFilesByExtensionAndName(TempFileList)
    for index, FileObj in SortedFileList
    {
        FileList.Push(FileObj)
        LV_Add("", "", FileObj.Name, "", FileObj.Directory)
    }
    LV_ModifyCol(1, 50)
    LV_ModifyCol(2, 150)
    LV_ModifyCol(3, 150)
    LV_ModifyCol(4, 400)
    GuiControl, +Redraw, FileListView
    Gosub, ForcePreviewUpdate
Return

;;∙========∙SORT FILES BY EXTENSION THEN NAME∙
SortFilesByExtensionAndName(FileArray) {
    n := FileArray.Length()
    Loop, % n - 1
    {
        i := A_Index
        Loop, % n - i
        {
            j := A_Index
            Ext1 := FileArray[j].Extension
            Ext2 := FileArray[j + 1].Extension
            StringLower, Ext1Lower, Ext1
            StringLower, Ext2Lower, Ext2
            ShouldSwap := false
            if (Ext1Lower > Ext2Lower)
            {
                ShouldSwap := true
            }
            else if (Ext1Lower = Ext2Lower)
            {
                Name1 := FileArray[j].Name
                Name2 := FileArray[j + 1].Name
                StringLower, Name1Lower, Name1
                StringLower, Name2Lower, Name2
                if (Name1Lower > Name2Lower)
                    ShouldSwap := true
            }
            if (ShouldSwap)
            {
                Temp := FileArray[j]
                FileArray[j] := FileArray[j + 1]
                FileArray[j + 1] := Temp
            }
        }
    }
    return FileArray
}

;;∙========∙UPDATE FIELD STATES BASED ON MODE∙
UpdateMode:
    Gui, Submit, NoHide
    if (A_GuiControl = "NumberBeforeText")
    {
        GuiControl, , NumberAfterText, 0
    }
    else if (A_GuiControl = "NumberAfterText")
    {
        GuiControl, , NumberBeforeText, 0
    }
    if (FindReplaceRadio)
    {
        GuiControl, Enable, FindTextBox
        GuiControl, Enable, ReplaceTextBox
        GuiControl, Disable, AppendTextBox
        GuiControl, Disable, SeparatorBox
        GuiControl, , UseNumbering, 0
        GuiControl, Disable, UseNumbering
        GuiControl, Disable, NumberBeforeText
        GuiControl, Disable, NumberAfterText
        GuiControl, Disable, StartNumber
        GuiControl, Disable, PaddingDigits
        GuiControl, , InsertDate, 0
        GuiControl, Disable, InsertDate
        GuiControl, , InsertTime, 0
        GuiControl, Disable, InsertTime
        GuiControl, , Use24Hour, 0
        GuiControl, Disable, Use24Hour
    }
    else
    {
        GuiControl, Enable, AppendTextBox
        GuiControl, Enable, SeparatorBox
        GuiControl, Enable, UseNumbering
        if (UseNumbering)
        {
            GuiControl, Enable, NumberBeforeText
            GuiControl, Enable, NumberAfterText
            GuiControl, Enable, StartNumber
            GuiControl, Enable, PaddingDigits
        }
        else
        {
            GuiControl, Disable, NumberBeforeText
            GuiControl, Disable, NumberAfterText
            GuiControl, Disable, StartNumber
            GuiControl, Disable, PaddingDigits
        }
        GuiControl, Disable, FindTextBox
        GuiControl, Disable, ReplaceTextBox
        GuiControl, Enable, InsertDate
        GuiControl, Enable, InsertTime
        GuiControl, Enable, Use24Hour
    }
    Gosub, ForcePreviewUpdate
Return

;;∙========∙REFRESH FILE LIST∙
RefreshList:
    Gosub, LoadFiles
Return

;;∙========∙SELECT ALL FILES∙
SelectAll:
    GuiControl, -Redraw, FileListView
    Loop, % LV_GetCount()
    {
        LV_Modify(A_Index, "Check")
    }
    GuiControl, +Redraw, FileListView
    Gosub, ForcePreviewUpdate
Return

;;∙========∙DESELECT ALL FILES∙
DeselectAll:
    GuiControl, -Redraw, FileListView
    Loop, % LV_GetCount()
    {
        LV_Modify(A_Index, "-Check")
    }
    GuiControl, +Redraw, FileListView
    Gosub, ForcePreviewUpdate
Return

;;∙========∙UPDATE LISTVIEW PREVIEW∙
UpdatePreview:
ForcePreviewUpdate:
    Gui, Submit, NoHide
    AppendText := AppendTextBox
    Separator := SeparatorBox
    GuiControl, -Redraw, FileListView
    Loop, % LV_GetCount()
    {
        LV_Modify(A_Index, "Col3", "")
    }
    CheckedByExt := {}
    RowNumber := 0
    Loop
    {
        RowNumber := LV_GetNext(RowNumber, "Checked")
        if not RowNumber
            break
        Ext := FileList[RowNumber].Extension
        if (Ext = "")
            Ext := "(no extension)"
            
        if !CheckedByExt.HasKey(Ext)
            CheckedByExt[Ext] := []
        CheckedByExt[Ext].Push(RowNumber)
    }
    ;;∙------∙Track generated names per extension to flag duplicates.
    DuplicateRows := {}
    for Ext, RowArray in CheckedByExt
    {
        SequentialCounter := 0
        NamesSeenThisExt := {}
        for index, RowNum in RowArray
        {
            SequentialCounter++
            if (FileList[RowNum].NameNoExt != "")
            {
                NewName := GenerateNewFileName(RowNum, SequentialCounter)
                ;;∙------∙Check for duplicate new names within same extension group.
                if (NamesSeenThisExt.HasKey(NewName))
                {
                    DuplicateRows[RowNum] := true
                    DuplicateRows[NamesSeenThisExt[NewName]] := true
                    LV_Modify(RowNum, "Col3", "⚠ DUPLICATE: " . NewName)
                }
                else
                {
                    NamesSeenThisExt[NewName] := RowNum
                    LV_Modify(RowNum, "Col3", NewName)
                }
            }
        }
    }
    GuiControl, +Redraw, FileListView
Return

;;∙========∙GENERATE NEW FILENAME∙
GenerateNewFileName(RowNum, SeqNum) {
    global
    NameNoExt := FileList[RowNum].NameNoExt
    Extension := FileList[RowNum].Extension
    ;;∙------∙Apply trim FIRST, before any other transformations.
    TrimStart := TrimStartChars + 0
    TrimEnd   := TrimEndChars + 0
    if (TrimStart > 0)
    {
        NameLen := StrLen(NameNoExt)
        if (TrimStart >= NameLen)
            NameNoExt := ""
        else
            NameNoExt := SubStr(NameNoExt, TrimStart + 1)
    }
    if (TrimEnd > 0)
    {
        NameLen := StrLen(NameNoExt)
        if (TrimEnd >= NameLen)
            NameNoExt := ""
        else
            NameNoExt := SubStr(NameNoExt, 1, NameLen - TrimEnd)
    }
    if (UseNumbering && StartNumber != "" && PaddingDigits != "")
    {
        ActualNumber := StartNumber + SeqNum - 1
        PaddedNumber := Format("{:0" . PaddingDigits . "d}", ActualNumber)
    }
    else
    {
        PaddedNumber := ""
    }
    ;;∙------∙Handle date/time insertion.
    DateTimeStr := ""
    if (InsertDate)
    {
        FormatTime, CurrentDate,, % dateFormatStr
        DateTimeStr .= CurrentDate
    }
    if (InsertTime)
    {
        if (Use24Hour)
            FormatTime, CurrentTime,, HH∙mm∙ss
        else
            FormatTime, CurrentTime,, % timeFormatStr
        if (DateTimeStr != "")
            DateTimeStr .= Separator
        DateTimeStr .= CurrentTime
    }
    if (FindReplaceRadio)
    {
        if (FindTextBox != "")
        {
            EscapedFind := RegExReplace(FindTextBox, "[\\.*?+\[{|()^$]", "\$0")
            NameNoExt := RegExReplace(NameNoExt, "i)" . EscapedFind, ReplaceTextBox)
        }
        if (UseNumbering && PaddedNumber != "")
        {
            if (NumberBeforeText)
            {
                if (NameNoExt != "")
                    BaseName := PaddedNumber . Separator . NameNoExt
                else
                    BaseName := PaddedNumber
            }
            else
            {
                if (NameNoExt != "")
                    BaseName := NameNoExt . Separator . PaddedNumber
                else
                    BaseName := PaddedNumber
            }
        }
        else
        {
            BaseName := NameNoExt
        }
    }
    else if (ReplaceRadio)
    {
        if (UseNumbering && PaddedNumber != "")
        {
            if (NumberBeforeText)
            {
                if (AppendText != "")
                    BaseName := PaddedNumber . Separator . AppendText
                else
                    BaseName := PaddedNumber
            }
            else
            {
                if (AppendText != "")
                    BaseName := AppendText . Separator . PaddedNumber
                else
                    BaseName := PaddedNumber
            }
        }
        else
        {
            if (AppendText != "")
                BaseName := AppendText
            else
                BaseName := NameNoExt
        }
    }
    else if (PrependRadio)
    {
        if (UseNumbering && PaddedNumber != "")
        {
            if (NumberBeforeText)
            {
                if (AppendText != "")
                {
                    if (DateTimeStr != "")
                        BaseName := PaddedNumber . Separator . DateTimeStr . Separator . AppendText . Separator . NameNoExt
                    else
                        BaseName := PaddedNumber . Separator . AppendText . Separator . NameNoExt
                }
                else
                {
                    if (DateTimeStr != "")
                        BaseName := PaddedNumber . Separator . DateTimeStr . Separator . NameNoExt
                    else
                        BaseName := PaddedNumber . Separator . NameNoExt
                }
            }
            else
            {
                if (AppendText != "")
                {
                    if (DateTimeStr != "")
                        BaseName := AppendText . Separator . DateTimeStr . Separator . PaddedNumber . Separator . NameNoExt
                    else
                        BaseName := AppendText . Separator . PaddedNumber . Separator . NameNoExt
                }
                else
                {
                    if (DateTimeStr != "")
                        BaseName := DateTimeStr . Separator . PaddedNumber . Separator . NameNoExt
                    else
                        BaseName := PaddedNumber . Separator . NameNoExt
                }
            }
        }
        else
        {
            if (AppendText != "")
            {
                if (DateTimeStr != "")
                    BaseName := AppendText . Separator . DateTimeStr . Separator . NameNoExt
                else
                    BaseName := AppendText . Separator . NameNoExt
            }
            else
            {
                if (DateTimeStr != "")
                    BaseName := DateTimeStr . Separator . NameNoExt
                else
                    BaseName := NameNoExt
            }
        }
    }
    else
    {
        if (UseNumbering && PaddedNumber != "")
        {
            if (NumberBeforeText)
            {
                if (AppendText != "")
                    BaseName := NameNoExt . Separator . PaddedNumber . Separator . AppendText
                else
                    BaseName := NameNoExt . Separator . PaddedNumber
            }
            else
            {
                if (AppendText != "")
                {
                    if (DateTimeStr != "")
                        BaseName := NameNoExt . Separator . AppendText . Separator . DateTimeStr . Separator . PaddedNumber
                    else
                        BaseName := NameNoExt . Separator . AppendText . Separator . PaddedNumber
                }
                else
                {
                    if (DateTimeStr != "")
                        BaseName := NameNoExt . Separator . DateTimeStr . Separator . PaddedNumber
                    else
                        BaseName := NameNoExt . Separator . PaddedNumber
                }
            }
        }
        else
        {
            if (AppendText != "")
            {
                if (DateTimeStr != "")
                    BaseName := NameNoExt . Separator . AppendText . Separator . DateTimeStr
                else
                    BaseName := NameNoExt . Separator . AppendText
            }
            else
            {
                if (DateTimeStr != "")
                    BaseName := NameNoExt . Separator . DateTimeStr
                else
                    BaseName := NameNoExt
            }
        }
    }
    if (CaseMode = "UPPERCASE")
        StringUpper, BaseName, BaseName
    else if (CaseMode = "lowercase")
        StringLower, BaseName, BaseName
    else if (CaseMode = "Title Case")
        StringLower, BaseName, BaseName, T
    else if (CaseMode = "Sentence case")
    {
        StringLower, BaseName, BaseName
        BaseName := RegExReplace(BaseName, "((?:^|[.!?]\s+)[a-z])", "$u1")
    }
    else if (CaseMode = "iNVERT cASE")
    {
        InvOut := ""
        Loop, Parse, BaseName
        {
            if A_LoopField is Upper
                InvOut .= Chr(Asc(A_LoopField) + 32)
            else if A_LoopField is Lower
                InvOut .= Chr(Asc(A_LoopField) - 32)
            else
                InvOut .= A_LoopField
        }
        BaseName := InvOut
    }
    BaseName := Trim(BaseName)
    if (Extension != "")
        return BaseName . "." . Extension
    else
        return BaseName
}

;;∙========∙RENAME SELECTED FILES (with folder creation by extension)∙
RenameFiles:
    Gui, Submit, NoHide
    AppendText := AppendTextBox
    Separator := SeparatorBox
    CreateFoldersByExt := CreateFoldersCheck
    CheckedCount := 0
    RowNumber := 0
    Loop
    {
        RowNumber := LV_GetNext(RowNumber, "Checked")
        if !RowNumber
            break
        CheckedCount++
    }
    if (CheckedCount = 0)
    {
        Gui, -AlwaysOnTop
        MsgBox, 48, No Files Selected, Please select at least one file to rename.,4
        Gui, +AlwaysOnTop
        return
    }
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

    ;;∙------∙Detect duplicate target names before doing anything.
    PreflightDupes := {}
    PreflightByExt := {}
    RowNumber := 0
    Loop
    {
        RowNumber := LV_GetNext(RowNumber, "Checked")
        if not RowNumber
            break
        Ext := FileList[RowNumber].Extension
        if (Ext = "")
            Ext := "(no extension)"
        if !PreflightByExt.HasKey(Ext)
            PreflightByExt[Ext] := []
        PreflightByExt[Ext].Push(RowNumber)
    }
DupeCount := 0
    DupeNames := {}
    for Ext, RowArray in PreflightByExt
    {
        SeenNames := {}
        SequentialCounter := 0
        for index, RowNum in RowArray
        {
            SequentialCounter++
            NewFileName := GenerateNewFileName(RowNum, SequentialCounter)
            if (SeenNames.HasKey(NewFileName))
                DupeNames[NewFileName] := true
            else
                SeenNames[NewFileName] := true
        }
    }
    DupeLog := ""
    for DupeName, _ in DupeNames
    {
        DupeCount++
        DupeLog .= DupeName . "`n"
    }
    if (DupeCount > 0)
    {
        Gui, -AlwaysOnTop
        MsgBox, 48, Duplicate Names Detected,`nThe current settings would produce conflicts`nfor %DupeCount% unique filename(s):`n`n%DupeLog%`nPlease adjust your settings`n(e.g. enable Sequential Numbering)`nbefore renaming., 8
        Gui, +AlwaysOnTop
        return
    }
    if (FindReplaceRadio)
    {
        if (ReplaceTextBox = "")
            ModeText := "remove '" . FindTextBox . "' from"
        else
            ModeText := "replace '" . FindTextBox . "' with '" . ReplaceTextBox . "' in"
    }
    else if (ReplaceRadio)
        ModeText := "replace entire name of"
    else
        ModeText := PrependRadio ? "prepend to" : "append to"
    if (UseNumbering && !FindReplaceRadio && !ReplaceRadio)
        ModeText .= " with sequential numbering"
    if (InsertDate || InsertTime)
    {
        ModeText .= " and current "
        if (InsertDate && InsertTime)
            ModeText .= "date/time"
        else if (InsertDate)
            ModeText .= "date"
        else
            ModeText .= "time"
    }
    if (CreateFoldersByExt)
        ModeText .= " (and organize into extension folders)"
    Gui, -AlwaysOnTop
    MsgBox, 36, Confirm Rename, Are you sure you want to %ModeText% %CheckedCount% file(s)?
    Gui, +AlwaysOnTop
    IfMsgBox No
        return
    Gosub, UnhideIni
    IniDelete, %IniFile%, Backup
    SuccessCount := 0
    ErrorCount := 0
    FolderCount := 0
    ErrorLog := ""
    CreatedFolders := {}
    CheckedByExt := {}
    RowNumber := 0
    Loop
    {
        RowNumber := LV_GetNext(RowNumber, "Checked")
        if not RowNumber
            break
        Ext := FileList[RowNumber].Extension
        if (Ext = "")
            Ext := "(no extension)"
        if !CheckedByExt.HasKey(Ext)
            CheckedByExt[Ext] := []
        CheckedByExt[Ext].Push(RowNumber)
    }
    for Ext, RowArray in CheckedByExt
    {
        SequentialCounter := 0
        for index, RowNum in RowArray
        {
            SequentialCounter++
            OldPath := FileList[RowNum].FullPath
            SplitPath, OldPath, OldFileName
            NewFileName := GenerateNewFileName(RowNum, SequentialCounter)
            if (CreateFoldersByExt && Ext != "(no extension)")
            {
                StringLower, ExtLower, Ext
                TargetDir := FileList[RowNum].Directory . "\" . ExtLower
                if (!CreatedFolders.HasKey(TargetDir) && !FileExist(TargetDir))
                {
                    FileCreateDir, %TargetDir%
                    if (!ErrorLevel)
                    {
                        FolderCount++
                        CreatedFolders[TargetDir] := true
                    }
                    else
                    {
                        ErrorCount++
                        ErrorLog .= "Failed to create folder: " . TargetDir . "`n"
                        continue
                    }
                }
                NewPath := TargetDir . "\" . NewFileName
            }
            else
            {
                NewPath := FileList[RowNum].Directory . "\" . NewFileName
            }
            if (FileExist(NewPath) && NewPath != OldPath)
            {
                ErrorCount++
                ErrorLog .= "Skipped (target exists): " . NewFileName . "`n"
                continue
            }
            FileMove, %OldPath%, %NewPath%, 0
            if (ErrorLevel)
            {
                ErrorCount++
                ErrorLog .= "Failed: " . FileList[RowNum].Name . "`n"
            }
            else
            {
                SuccessCount++
                IniWrite, %NewPath%|%OldFileName%, %IniFile%, Backup, entry%SuccessCount%
            }
        }
    }
    Gosub, HideIni
    Gui, -AlwaysOnTop
    ResultMsg := "Successfully renamed: " . SuccessCount
    if (FolderCount > 0)
        ResultMsg .= "`nFolders created: " . FolderCount
    if (ErrorCount > 0)
        ResultMsg .= "`nFailed: " . ErrorCount . "`n`nErrors:`n" . ErrorLog
    if (ErrorCount > 0)
        MsgBox, 48, Rename Complete with Errors, %ResultMsg%,4
    else
        MsgBox, 64, Rename Complete, %ResultMsg%`n`nA backup file has been created for reverting.,4
    Gui, +AlwaysOnTop
    Gosub, LoadFiles
Return

;;∙========∙INVISIBLE INI HELPER FUNCTIONS∙
UnhideIni:
    FileSetAttrib, -H, %IniFile%
Return

HideIni:
    if (HideIniFile)
        FileSetAttrib, +H, %IniFile%
    else
        FileSetAttrib, -H, %IniFile%
Return

;;∙========∙CHECK FOR CHECKBOX CHANGES∙
CheckCheckboxChanges:
    CurrentState := ""
    RowNumber := 0
    Loop
    {
        RowNumber := LV_GetNext(RowNumber, "Checked")
        if !RowNumber
            break
        CurrentState .= RowNumber . ","
    }
    if (CurrentState != LastCheckState)
    {
        LastCheckState := CurrentState
        Gosub, ForcePreviewUpdate
    }
Return

;;∙========∙REVERT TO ORIGINAL FILENAMES (selective, returns to parent folder)∙
RevertFiles:
    Gui, Submit, NoHide
    CheckedCount := 0
    RowNumber := 0
    Loop
    {
        RowNumber := LV_GetNext(RowNumber, "Checked")
        if !RowNumber
            break
        CheckedCount++
    }
    if (CheckedCount = 0)
    {
        Gui, -AlwaysOnTop
        MsgBox, 48, No Files Selected, Please select at least one file to revert.,4
        Gui, +AlwaysOnTop
        return
    }
    Gui, -AlwaysOnTop
    MsgBox, 36, Confirm Revert, Are you sure you want to revert %CheckedCount% selected file(s) to the parent folder with original names?
    Gui, +AlwaysOnTop
    IfMsgBox No
        return
    Gosub, UnhideIni
    IniRead, BackupSection, %IniFile%, Backup
    if (BackupSection = "" || BackupSection = "ERROR")
    {
        Gosub, HideIni
        Gui, -AlwaysOnTop
        MsgBox, 48, No Backup Found, No backup exists. You must rename files first., 4
        Gui, +AlwaysOnTop
        return
    }
    BackupEntries := []
    Loop, Parse, BackupSection, `n, `r
    {
        if (A_LoopField = "")
            continue
        EqualPos := InStr(A_LoopField, "=")
        if (EqualPos = 0)
            continue
        Key := SubStr(A_LoopField, 1, EqualPos - 1)
        Value := SubStr(A_LoopField, EqualPos + 1)
        PipePos := InStr(Value, "|", false, 0)
        if (PipePos = 0)
            continue
        CurPath := SubStr(Value, 1, PipePos - 1)
        OrigName := SubStr(Value, PipePos + 1)
        BackupEntries.Push({Key: Key, CurPath: CurPath, OrigName: OrigName})
    }
    FilesToRevert := {}
    RowNumber := 0
    Loop
    {
        RowNumber := LV_GetNext(RowNumber, "Checked")
        if !RowNumber
            break
        CurrFileName := FileList[RowNumber].Name
        EntryFound := false
        for index, entry in BackupEntries
        {
            EntryCurPath := entry.CurPath
            SplitPath, EntryCurPath, EntryFileName
            if (EntryFileName = CurrFileName)
            {
                if (FileExist(EntryCurPath))
                {
                    FilesToRevert[entry.Key] := index
                    EntryFound := true
                    break
                }
                else
                {
                    AltPath := FileList[RowNumber].Directory . "\" . CurrFileName
                    if (FileExist(AltPath))
                    {
                        BackupEntries[index].CurPath := AltPath
                        FilesToRevert[entry.Key] := index
                        EntryFound := true
                        break
                    }
                }
            }
        }
        if (!EntryFound)
        {
            FilesToRevert["ERROR_" . CurrFileName] := 0
        }
    }
    SuccessCount := 0
    ErrorCount := 0
    ErrorLog := ""
    RevertedKeys := {}
    for RevertKey, EntryIndex in FilesToRevert
    {
        if (InStr(RevertKey, "ERROR_") = 1)
        {
            ErrorFileName := SubStr(RevertKey, 7)
            ErrorCount++
            ErrorLog .= "No backup entry found: " . ErrorFileName . "`n"
            continue
        }
        if (EntryIndex = 0)
            continue
        KeyToRemove := BackupEntries[EntryIndex].Key
        CurPathToMove := BackupEntries[EntryIndex].CurPath
        OrigNameToRestore := BackupEntries[EntryIndex].OrigName
        if (!FileExist(CurPathToMove))
        {
            ErrorCount++
            SplitPath, CurPathToMove, TempFileName
            ErrorLog .= "File not found: " . TempFileName . "`n"
            continue
        }
        SplitPath, CurPathToMove, , ActualDir
        OriginalPath := CurrentFolder . "\" . OrigNameToRestore
        if (FileExist(OriginalPath) && OriginalPath != CurPathToMove)
        {
            ErrorCount++
            ErrorLog .= "Skipped (original name exists): " . OrigNameToRestore . "`n"
            continue
        }
        FileMove, %CurPathToMove%, %OriginalPath%, 0
        if (ErrorLevel)
        {
            ErrorCount++
            SplitPath, CurPathToMove, TempFileName
            ErrorLog .= "Failed to revert: " . TempFileName . "`n"
        }
        else
        {
            SuccessCount++
            RevertedKeys[KeyToRemove] := true
            if (ActualDir != CurrentFolder)
            {
                FolderEmpty := true
                Loop, Files, %ActualDir%\*.*, FD
                {
                    FolderEmpty := false
                    break
                }
                if (FolderEmpty)
                    FileRemoveDir, %ActualDir%, 0
            }
        }
    }
    IniDelete, %IniFile%, Backup
    NewIndex := 1
    for index, entry in BackupEntries
    {
        if (!RevertedKeys.HasKey(entry.Key))
        {
            EntryCurPath := entry.CurPath
            EntryOrigName := entry.OrigName
            BackupValue := EntryCurPath . "|" . EntryOrigName
            IniWrite, %BackupValue%, %IniFile%, Backup, % "entry" . NewIndex
            NewIndex++
        }
    }
    Gosub, HideIni
    Gui, -AlwaysOnTop
    if (ErrorCount > 0)
        MsgBox, 48, Revert Complete with Errors, Successfully reverted: %SuccessCount%`nFailed: %ErrorCount%`n`nErrors:`n%ErrorLog%, 4
    else
        MsgBox, 64, Revert Complete, Successfully reverted %SuccessCount% file(s) to parent folder!`nRemaining backups kept for further reverts., 4
    Gui, +AlwaysOnTop
    Gosub, LoadFiles
Return

;;∙============================================================∙
;;∙========∙GUI ADD TRIMS∙
GuiAddTrim1(Color, Width, PosAndSize) {
   LFW := WinExist()
   DefGui := A_DefaultGui
   Gui, Add, Text, %PosAndSize% +hwndHTXT
   GuiControlGet, T, Pos, %HTXT%
   Gui, New, +Parent%HTXT% +LastFound -Caption
   Gui, Color, %Color%
   X1 := Width, X2 := TW - Width, Y1 := Width, Y2 := TH - Width
   WinSet, Region, 0-0 %TW%-0 %TW%-%TH% 0-%TH% 0-0   %X1%-%Y1% %X2%-%Y1% %X2%-%Y2% %X1%-%Y2% %X1%-%Y1%
   Gui, Show, x0 y0 w%TW% h%TH%
   Gui, %DefGui%:Default
   If (LFW)
      WinExist(LFW)
}

GuiAddTrim2(Color, Width, PosAndSize) {
   LFW := WinExist()
   DefGui := A_DefaultGui
   Gui, Add, Text, %PosAndSize% +hwndHTXT
   GuiControlGet, T, Pos, %HTXT%
   Gui, New, +Parent%HTXT% +LastFound -Caption
   Gui, Color, %Color%
   X1 := Width, X2 := TW - Width, Y1 := Width, Y2 := TH - Width
   WinSet, Region, 0-0 %TW%-0 %TW%-%TH% 0-%TH% 0-0   %X1%-%Y1% %X2%-%Y1% %X2%-%Y2% %X1%-%Y2% %X1%-%Y1%
   Gui, Show, x0 y0 w%TW% h%TH%
   Gui, %DefGui%:Default
   If (LFW)
      WinExist(LFW)
}

;;∙========∙GUI TOOLTIPS∙
GuiTip(hCtrl, text:="")
{
    ttMaxWidth := 200    ;;∙------∙Sets maximum tooltip width in pixels. (0 = no maximum limit)
    hGui := text!="" ? DllCall("GetParent", "Ptr", hCtrl) : hCtrl
    static hTip
    if !hTip
    {
        hTip := DllCall("CreateWindowEx", "UInt", 0x8, "Str", "tooltips_class32"
             ,  "Ptr", 0, "UInt", 0x80000002   ;;∙------∙(((WS_POPUP:=0x80000000|TTS_NOPREFIX:=0x02)))
             ,  "Int", 0x80000000, "Int",  0x80000000, "Int", 0x80000000, "Int", 0x80000000
             ,  "Ptr", hGui, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Ptr")
        DllCall("SendMessage", "Ptr", hTip, "Int", 0x0418, "Ptr", 0, "Ptr", ttMaxWidth)
        if (A_OsVersion == "WIN_XP")
            GuiTip(hGui)
    }
    static sizeof_TOOLINFO := 24 + (6 * A_PtrSize)
    VarSetCapacity(TOOLINFO, sizeof_TOOLINFO, 0)
    , NumPut(sizeof_TOOLINFO, TOOLINFO, 0, "UInt")
    , NumPut(0x11, TOOLINFO, 4, "UInt")   ;;∙------∙(((TTF_IDISHWND:=0x0001|TTF_SUBCLASS:=0x0010)))
    , NumPut(hGui, TOOLINFO, 8, "Ptr")
    , NumPut(hCtrl, TOOLINFO, 8 + A_PtrSize, "Ptr")
    , NumPut(&text, TOOLINFO, 24 + (3 * A_PtrSize), "Ptr")
    static TTM_ADDTOOL := A_IsUnicode ? 0x0432 : 0x0404
    return DllCall("SendMessage", "Ptr", hTip, "Int", TTM_ADDTOOL, "Ptr", 0, "Ptr", &TOOLINFO)
}
Return

;;∙========∙DUMMY LABEL (for gui tooltips)∙
Dum:
Return

;;∙========∙LISTVIEW CELL HOVER TOOLTIP∙
WM_MOUSEMOVE(wParam, lParam, Msg, Hwnd) {
    global
    ;;∙------∙Only process when hovering over the ListView control.
    if (A_GuiControl != "FileListView")
    {
        ToolTip
        return
    }
    ;;∙------∙LVM_HITTEST to get which item is under cursor.
    VarSetCapacity(LVHTI, 24, 0)    ;;∙------∙LVHITTESTINFO structure.
    NumPut(lParam & 0xFFFF, LVHTI, 0, "Int")    ;;∙------∙X coordinate.
    NumPut((lParam >> 16) & 0xFFFF, LVHTI, 4, "Int")    ;;∙------∙Y coordinate.
    Item := DllCall("SendMessage", "Ptr", Hwnd, "UInt", 0x1012, "Ptr", 0, "Ptr", &LVHTI, "Int")    ;;∙------∙LVM_HITTEST
    ;;∙------∙Check if on a valid item (0x0E = LVHT_ONITEMLABEL | LVHT_ONITEMICON | LVHT_ONITEMSTATEICON)
    if (Item >= 0) && (NumGet(LVHTI, 8, "UInt") & 0x0E)
    {
        ;;∙------∙Item is 0-based, add 1 for LV functions.
        RowNumber := Item + 1
        ;;∙------∙Check if over column 3 specifically.
        LV_GetText(NewName, RowNumber, 3)
        if (NewName != "")
        {
            ;;∙------∙Position tooltip at mouse cursor.
            CoordMode, Mouse, Screen
            CoordMode, ToolTip, Screen
            MouseGetPos, MouseX, MouseY
            TipX := MouseX + 10
            TipY := MouseY - 25
            ToolTip, New Filename:`n  %NewName%, %TipX%, %TipY%
        }
        else
        {
            ToolTip
        }
    }
    else
    {
        ToolTip
    }
}

;;∙============================================================∙
;;∙========∙HIDE/SHOW GUI∙
HideGui:
    Gui, Hide
    GuiVisible := false
    NewMenuName := "Show " . namePlate
    Menu, Tray, Rename, % TrayMenuName, % NewMenuName
    TrayMenuName := NewMenuName
Return

ToggleGui:
    if (GuiVisible)
    {
        Gui, Hide
        GuiVisible := false
        NewMenuName := "Show " . namePlate
        Menu, Tray, Rename, % TrayMenuName, % NewMenuName
        TrayMenuName := NewMenuName
    }
    else
    {
        Gui, Show
        GuiVisible := true
        NewMenuName := "Hide " . namePlate
        Menu, Tray, Rename, % TrayMenuName, % NewMenuName
        TrayMenuName := NewMenuName
    }
Return

;;∙========∙SAVE GUI POSITION∙
SaveGuiPosition:
    WinGetPos, currentX, currentY, , , File Renamer with Find & Replace
    if (currentX != "" && currentY != "")
    {
        Gosub, UnhideIni
        IniWrite, %currentX%, %IniFile%, Settings, GuiX
        IniWrite, %currentY%, %IniFile%, Settings, GuiY
        Gosub, HideIni
    }
Return

;;∙========∙DETECT WHEN WINDOW FINISHES MOVING∙
WM_EXITSIZEMOVE() {
    Gosub, SaveGuiPosition
}

;;∙========∙GUI DRAG∙
WM_LBUTTONDOWNdrag() {
    if (A_GuiControl = "")
       PostMessage, 0x00A1, 2, 0
    return
}

;;∙============================================================∙
;;∙========∙EDIT/RELOAD/EXIT∙
;;∙------∙EDIT∙
Script·Edit:
    Edit
Return

;;∙------∙RELOAD∙
^Home::    ;;∙------∙🔥∙(Ctrl + Home Twice)
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)
    Script·Reload:
    Reload:
        Soundbeep, 1200, 250
        Gosub, SaveGuiPosition
    Reload
Return

;;∙------∙EXIT∙
^Esc::    ;;∙------∙🔥∙(Ctrl + Esc Twice)
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)
    Script·Exit:
    Exit:
    GuiClose:
        Soundbeep, 1000, 300
        Gosub, SaveGuiPosition
        Gosub, UnhideIni
        IniDelete, %IniFile%, Backup
        Gosub, HideIni
    ExitApp
Return

;;∙========∙SCRIPT UPDATE∙
UpdateCheck:
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
    Reload
Return

;;∙========∙TRAY MENU∙
TrayMenu:
Menu, Tray, Tip, %ScriptID%
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add

Menu, Tray, Add
Menu, Tray, Add, Hide %namePlate%, ToggleGui
Menu, Tray, Icon, Hide %namePlate%, imageres.dll, 243
Menu, Tray, Default, Hide %namePlate%
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

;;∙------∙EXTENTIONS∙
Documentation:
    Run, "C:\Program Files\AutoHotkey\AutoHotkey.chm"
Return

ShowKeyHistory:
    KeyHistory
Return

ShowWindowSpy:
    Run, "C:\Program Files\AutoHotkey\WindowSpy.ahk"
Return

;;∙========∙TRAY MENU POSITION∙
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20
Return

;;∙------∙POSITION FUNTION∙
NotifyTrayClick(P*) { 
Static Msg, Fun:="NotifyTrayClick", NM:=OnMessage(0x404,Func(Fun),-1),  Chk,T:=-250,Clk:=1
    If ( (NM := Format(Fun . "_{:03X}", Msg := P[2])) && P.Count()<4 )
        return ( T := Max(-5000, 0-(P[1] ? Abs(P[1]) : 250)) )
    Critical
    If ( ( Msg<0x201 || Msg>0x209 ) || ( IsFunc(NM) || Islabel(NM) )=0 )
        return
    Chk := (Fun . "_" . (Msg<=0x203 ? "203" : Msg<=0x206 ? "206" : Msg<=0x209 ? "209" : ""))
    SetTimer, %NM%,  %  (Msg==0x203        || Msg==0x206        || Msg==0x209)
    ? (-1, Clk:=2) : ( Clk=2 ? ("Off", Clk:=1) : ( IsFunc(Chk) || IsLabel(Chk) ? T : -1) )
        return True
    }
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙



;;∙------------------------------------------------------------------------------------------∙

