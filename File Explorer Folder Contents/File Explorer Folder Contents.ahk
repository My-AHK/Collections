
;;∙---------------------------------------------------------------------∙

SetTimer, UpdateCheck, 500
GoSub, TrayMenu

;;∙---------------------------------------------------------------------∙


;;∙---------------------------------------------------------------------∙
;;∙==============================================∙










;;∙---------------------------------------------------------------------∙

;;∙======∙DIRECTIVES & SETTINGS∙==================∙
#Requires AutoHotkey 1
#NoEnv
#SingleInstance, Force
SendMode, Input
Menu, Tray, Icon, imageres.dll, 180
Menu, Tray, Tip, File Explorer Folder Contents
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")
SetWorkingDir %A_ScriptDir%
;;∙------∙Set DPI awareness for proper high-DPI display scaling.
DllCall("user32.dll\SetProcessDpiAwarenessContext", "ptr", -3, "ptr")

;;∙---------------------------------------------------------------------∙
recursive := false    ;;∙------∙Set to true to include subfolders, false for top-level only.
showHidden := false    ;;∙------∙Set to true to show hidden files/folders, false to hide them.
global folderPath := ""

;;∙---------------------------------------------------------------------∙
F1::    ;;∙------∙🔥∙
    folderPath := GetExplorerPath()
    guiW := 700
    guiH := 410

    if (folderPath = "") {
        MsgBox, 4, Folder Path, Could not detect the folder path automatically.`nWould you like to select a folder manually?
        IfMsgBox, Yes
        {
            FileSelectFolder, folderPath, , 3, Select the folder to list
            if (folderPath = "") {
                MsgBox, No folder selected.
                return
            }
        } Else {
            MsgBox, Could not determine the folder path. Make sure you're in a File Explorer window.
            return
        }
    }
    if (folderPath != "" and InStr(FileExist(folderPath), "D")) {
        Gui, New, +AlwaysOnTop -Caption +ToolWindow +Border, , File Explorer Folder Contents
        Gui, Color, Black
        Gui, Font, s9 q5 cBlue Bold
        Gui, Add, Text, x10 y10 w680, Contents of: %folderPath%
        Gui, Font, s9 q5 cAqua Norm
        Gui, Add, ListView, x10 y30 w680 h300 vItemListView Grid -Hdr Background111111, Name|Date Created|Date Modified
        LV_ModifyCol(1, 340)
        LV_ModifyCol(2, 170)
        LV_ModifyCol(3, 170)
        RefreshListView()
        Gui, Font, s9 q5 cBlue Bold
        Gui, Add, Text, x10 y340 w200, Current`nSettings:
        recursiveColor := recursive ? "Lime" : "Red"
        recursiveDisplay := recursive ? "true" : "false"
        Gui, Font, s9 q5 cAqua Norm
        Gui, Add, Text, x20 y+5, Recursive Subfolders:
        Gui, Font, s9 q5 c%recursiveColor% Norm
        Gui, Add, Text, x+5 yp vRecursiveStatus, %recursiveDisplay%
        hiddenColor := showHidden ? "Lime" : "Red"
        hiddenDisplay := showHidden ? "true" : "false"
        Gui, Font, s9 q5 cAqua Norm
        Gui, Add, Text, x20 y385, Show Hidden Items:  %A_Space%
        Gui, Font, s9 q5 c%hiddenColor% Norm
        Gui, Add, Text, x+5 yp vHiddenStatus, %hiddenDisplay%
        Gui, Font, s9 q5 Norm
            buttonSpot := (guiW - 250)    ;;∙------∙Toggle buttons
        Gui, Font, s9 q5 cBlue Bold
        Gui, Add, Text, x%buttonSpot% y340, Toggle`nAttributes:
        Gui, Font, s9 q5 Norm
        Gui, Add, Button, x+10 yp w80 h20 gToggleRecursive, Recursive
        Gui, Add, Button, x+10 yp w80 h20 gToggleHidden, Hidden
            buttonSpot := (guiW - 270)    ;;∙------∙Action buttons
        Gui, Add, Button, x%buttonSpot% y375 w120 gCopyList, Copy to Clipboard
        Gui, Add, Button, x+10 y375 w60 gRetryList, Retry
        Gui, Add, Button, x+10 y375 w60 gCloseGui, Close
        Gui, Add, Button, Hidden Default gCloseGui,
        Gui, Show, w%guiW% h%guiH%
        GuiControl, Focus, Close
    } else {
        MsgBox,,, Invalid folder path. Please try again.,2
    }
Return

;;∙---------------------------------------------------------------------∙
GetExplorerPath() {
    try {
        shell := ComObjCreate("Shell.Application")
        for window in shell.Windows {
            if (window.HWND = WinExist("A")) {
                folderPath := window.Document.Folder.Self.Path
                return folderPath
            }
        }
    }
    WinGetClass, winClass, A
    if (winClass = "CabinetWClass" or winClass = "ExploreWClass") {
        ControlGetText, folderPath, Edit1, A
        if (folderPath = "") {
            ControlGetText, folderPath, Edit2, A
        }
        if (folderPath = "") {
            ControlGetText, folderPath, ToolbarWindow32, A
        }
        if (folderPath = "") {
            ControlGetText, folderPath, ComboBox3, A
        }
        if (folderPath = "") {
            WinGetTitle, winTitle, A
            StringGetPos, pos, winTitle,  - 
            if (pos = -1) {
                StringGetPos, pos, winTitle,  — 
            }
            if (pos > 0) {
                folderPath := SubStr(winTitle, 1, pos)
            } else {
                folderPath := winTitle
            }
            folderPath := RegExReplace(folderPath, "^\s+|\s+$")
        }
        folderPath := RegExReplace(folderPath, "^Address:\s*", "")
        folderPath := RegExReplace(folderPath, "^\s+|\s+$")
        return folderPath
    }
    return ""
}

;;∙---------------------------------------------------------------------∙
RefreshListView() {
    global folderPath, recursive
    LV_Delete()
    LV_Add("", "      ◆ Name ◆", "      ◆ Date Created ◆", "      ◆ Date Modified ◆")
    PopulateListView(folderPath, recursive)
}

;;∙---------------------------------------------------------------------∙
ToggleRecursive:
    recursive := !recursive
    Gosub, UpdateSettings
    if (folderPath != "") {
        RefreshListView()
    }
Return

ToggleHidden:
    showHidden := !showHidden
    Gosub, UpdateSettings
    if (folderPath != "") {
        RefreshListView()
    }
Return

UpdateSettings:
    recursiveColor := recursive ? "Lime" : "Red"
    recursiveDisplay := recursive ? "true" : "false"
        Gui, Font, s9 q5 c%recursiveColor% Norm
        GuiControl, Font, RecursiveStatus
        GuiControl, Text, RecursiveStatus, %recursiveDisplay%
    hiddenColor := showHidden ? "Lime" : "Red"
    hiddenDisplay := showHidden ? "true" : "false"
        Gui, Font, s9 q5 c%hiddenColor% Norm
        GuiControl, Font, HiddenStatus
        GuiControl, Text, HiddenStatus, %hiddenDisplay%
Return

;;∙---------------------------------------------------------------------∙
PopulateListView(path, recurse) {
    global showHidden

    Loop, Files, %path%\*.*, D
    {
        FileGetAttrib, attribs, %A_LoopFileFullPath%
        if (!showHidden and InStr(attribs, "H")) {
            continue
        }
        FileGetTime, createdTime, %A_LoopFileFullPath%, C
        FileGetTime, modifiedTime, %A_LoopFileFullPath%, M
        FormatTime, formattedCreated, %createdTime%, MM-dd-yyyy   hh:mm tt
        FormatTime, formattedModified, %modifiedTime%, MM-dd-yyyy   hh:mm tt
        LV_Add("", A_LoopFileName . " [FOLDER]", formattedCreated, formattedModified)
        if (recurse) {
            subPath := path . "\" . A_LoopFileName
            if InStr(FileExist(subPath), "D") {
                PopulateListViewRecursive(subPath, "  ")
            }
        }
    }
    Loop, Files, %path%\*.*, F
    {
        FileGetAttrib, attribs, %A_LoopFileFullPath%
        if (!showHidden and InStr(attribs, "H")) {
            continue
        }
        FileGetTime, createdTime, %A_LoopFileFullPath%, C
        FileGetTime, modifiedTime, %A_LoopFileFullPath%, M
        FormatTime, formattedCreated, %createdTime%, MM-dd-yyyy   hh:mm tt
        FormatTime, formattedModified, %modifiedTime%, MM-dd-yyyy   hh:mm tt
        LV_Add("", A_LoopFileName, formattedCreated, formattedModified)
    }
}

;;∙---------------------------------------------------------------------∙
PopulateListViewRecursive(path, indent) {
    global showHidden

    Loop, Files, %path%\*.*, D
    {
        FileGetAttrib, attribs, %A_LoopFileFullPath%
        if (!showHidden and InStr(attribs, "H")) {
            continue
        }
        FileGetTime, createdTime, %A_LoopFileFullPath%, C
        FileGetTime, modifiedTime, %A_LoopFileFullPath%, M
        FormatTime, formattedCreated, %createdTime%, MM-dd-yyyy   hh:mm tt
        FormatTime, formattedModified, %modifiedTime%, MM-dd-yyyy   hh:mm tt
        LV_Add("", indent . A_LoopFileName . " [FOLDER]", formattedCreated, formattedModified)
        
        subPath := path . "\" . A_LoopFileName
        if InStr(FileExist(subPath), "D") {
            PopulateListViewRecursive(subPath, indent . "  ")
        }
    }
    Loop, Files, %path%\*.*, F
    {
        FileGetAttrib, attribs, %A_LoopFileFullPath%
        if (!showHidden and InStr(attribs, "H")) {
            continue
        }
        FileGetTime, createdTime, %A_LoopFileFullPath%, C
        FileGetTime, modifiedTime, %A_LoopFileFullPath%, M
        FormatTime, formattedCreated, %createdTime%, MM-dd-yyyy   hh:mm tt
        FormatTime, formattedModified, %modifiedTime%, MM-dd-yyyy   hh:mm tt
        LV_Add("", indent . A_LoopFileName, formattedCreated, formattedModified)
    }
}

;;∙---------------------------------------------------------------------∙

RetryList:
    if (folderPath != "") {
        RefreshListView()
    }
Return

CopyList:
    clipboard := ""
    totalRows := LV_GetCount()
    Loop, %totalRows%
    {
        LV_GetText(col1, A_Index, 1)
        LV_GetText(col2, A_Index, 2)
        LV_GetText(col3, A_Index, 3)
        clipboard .= col1 . "`t" . col2 . "`t" . col3 . "`r`n"
    }
    MsgBox,,, List copied to clipboard! (Tab-separated format), 2
Return

CloseGui:
    Gui, Destroy
Return

;;∙---------------------------------------------------------------------∙
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}
Return
;;∙==============================================∙




;;∙======∙SCRIPT EDIT/RELOAD/EXIT∙================∙
;;∙------∙Edit∙-----------------------------∙
Script·Edit:    ;;∙------∙Menu Call.
    Edit
Return
;;∙------∙Reload∙-------------------------∙
^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        ;;∙------∙aSoundBeep(1000, 200)    ;;∙------∙Async SoundBeep.
    Reload
Return
;;∙------∙Exit∙-----------------------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        ;;∙------∙aSoundBeep(1000, 200)    ;;∙------∙Async SoundBeep.
    ExitApp
Return

;;∙======∙SCRIPT UPDATE∙=========================∙
UpdateCheck:    ;;∙------Check if script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        return
        aSoundBeep(1500, 100)    ;;∙------∙Async SoundBeep.
Reload

;;∙======∙ASYNCHRONOUS SOUNDBEEP∙=============∙
aSoundBeep(Frequency, Duration) {
    AutoHotkeyPath := A_AhkPath    
    shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec("""" AutoHotkeyPath """ *")
    exec.StdIn.Write("#NoTrayIcon`nSoundBeep, " Frequency "," Duration "`nExitApp")
    exec.StdIn.Close()
}

;;∙======∙TRAY MENU∙============================∙
TrayMenu:
; Menu, Tray, Tip, File Explorer Folder Contents
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add
;;∙------∙Menu-Extentions∙------------∙
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
;;∙------∙Menu-Options∙---------------∙
Menu, Tray, Add
Menu, Tray, Add, Script Edit, Script·Edit
Menu, Tray, Icon, Script Edit, imageres.dll, 247
Menu, Tray, Add
Menu, Tray, Add, Script Reload, Script·Reload
Menu, Tray, Icon, Script Reload, mmcndmgr.dll, 47
Menu, Tray, Add
Menu, Tray, Add, Script Exit, Script·Exit
Menu, Tray, Icon, Script Exit, shell32.dll, 272
Menu, Tray, Default, Script Exit
Menu, Tray, Add
Menu, Tray, Add
Return

;;∙======∙TRAY MENU EXTENTIONS∙=================∙
Documentation:
    Run, "C:\Program Files\AutoHotkey\AutoHotkey.chm"
Return
ShowKeyHistory:
    KeyHistory
Return
ShowWindowSpy:
    Run, "C:\Program Files\AutoHotkey\WindowSpy.ahk"
Return

;;∙======∙TRAY MENU POSITION∙===================∙
;;∙------∙Tray Menu Show∙-----------∙
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20
Return
;;∙------∙Position Funtion∙-----------∙
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
    return True
    }
Return
;;∙==============================================∙
;;∙======∙SCRIPT END∙=============================∙
;;∙---------------------------------------------------------------------∙


