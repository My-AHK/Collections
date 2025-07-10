
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  Special-Niewbie
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?f=6&t=138126#p606610
» Original Source:  https://github.com/Special-Niewbie/FolderTreeCreator
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
^t::    ;;∙------∙🔥∙(Ctrl + T)
    Soundbeep, 1000, 200
;;∙============================================================∙




;;∙============================================================∙
;;∙============================================================∙
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

Menu, Tray, NoStandard

;;∙------∙System Tray Menu.
Menu, Tray, Add, 👉 >>> Folder Tree Creator Menu <<<, TitleLabel
Menu, Tray, Disable, 👉 >>> Folder Tree Creator Menu <<<
Menu, Tray, Add, , Separator
Menu, Tray, Add, Reload, ReloadScript
Menu, Tray, Add, , Separator
Menu, Tray, Add, Show Version, ShowVersionInfo
Menu, Tray, Add, Exit, ExitApp

Gui, Font, s10, Segoe UI

Gui, Add, Button, x430 y25 w100 h30 gSelectTarget, Target Path

Gui, Add, Text, x20 y10 w200 h30, Select the destination folder:
Gui, Font, s10 cBFBFBF, Segoe UI
Gui, Add, Edit, x20 y30 w400 h20 vSelectedFolder ReadOnly hwndhEditTarget,
GuiControl,, SelectedFolder, No folder selected...

Gui, Font, s10 c000000, Segoe UI
Gui, Add, Text, x20 y70 w300 h30, Folder structure:
Gui, Add, TreeView, x20 y90 w510 h300 vMyTree gTreeEvent

;;∙------∙Load folder icon from shell32.dll.
ImageListID := IL_Create(10)
folderIcon := IL_Add(ImageListID, "shell32.dll", 4) ; index 4 = folder
fileIcon := IL_Add(ImageListID, "shell32.dll", 2)  ; index 2 = generic file
TV_SetImageList(ImageListID)
NodeTypeMap := {}

Gui, Font, s10, Segoe UI

;;∙------∙Standard buttons.
Gui, Add, Button, x20 y400 w100 h30 vBtnAdd gAddFolder, + Add
Gui, Add, Button, x130 y400 w100 h30 vBtnRemove gRemoveFolder, - Remove
Gui, Add, Button, x440 y440 w90 h30 vBtnStart gStartProcess, Start
Gui, Add, Button, x240 y400 w100 h30 vBtnAddFile gAddFile, + Add File
Gui, Add, Button, x20 y440 w100 h30 vBtnRename gRenameFolder, Rename

;;∙------∙Retrieve button HWNDs after creating them.
GuiControlGet, hwndAdd, Hwnd, BtnAdd
GuiControlGet, hwndRemove, Hwnd, BtnRemove
GuiControlGet, hwndStart, Hwnd, BtnStart
GuiControlGet, hwndAddFile, Hwnd, BtnAddFile
GuiControlGet, hwndRename, Hwnd, BtnRename

;;∙------∙Use Windows call to color the buttons.
OnMessage(0x135, "WM_CTLCOLORBTN")

;;∙------∙Brush defined in BGR format.
hBrushAdd    := CreateSolidBrush(0xFF9933)
hBrushRemove := CreateSolidBrush(0x0000FF)
hBrushStart  := CreateSolidBrush(0xCCFF33)
 hBrushAddFile := CreateSolidBrush(0xFF66FF)
hBrushRename := CreateSolidBrush(0x00FFFF)

Gui, Show, w550 h480, Folder Tree Creator

Return

; -------------------------------------------------------
SelectTarget:
FileSelectFolder, SelectedFolder, , 3, Select the destination folder
if (SelectedFolder != "")
    GuiControl, , SelectedFolder, %SelectedFolder%
Return

; -------------------------------------------------------
AddFolder:
Gui, Submit, NoHide
selectedID := TV_GetSelection()

if (selectedID) {
    type := NodeTypeMap.HasKey(selectedID) ? NodeTypeMap[selectedID] : InferNodeType(selectedID)
    if (type = "file") {
        MsgBox, You can't add a folder inside a file!
        Return
    }
}

baseName := "New_Folder"
folderName := baseName
counter := 1

parentID := selectedID ? selectedID : 0
childID := TV_GetChild(parentID)
Loop {
    if (!childID)
        break
    TV_GetText(existingName, childID)
    if (existingName = folderName) {
        counter++
        folderName := baseName . counter
        childID := TV_GetChild(parentID)  ; the cycle begins again
        continue
    }
    childID := TV_GetNext(childID)
}

newID := TV_Add(folderName, parentID, "Icon" folderIcon)
NodeTypeMap[newID] := "folder"
if (selectedID)
    TV_Modify(selectedID, "Expand")

GuiControl, Choose, MyTree, %newID%
RenameFolderByID(newID)
GuiControl, Focus, SelectedFolder
GuiControl, Focus, MyTree
Return

; -------------------------------------------------------
RenameFolder:
Gui, Submit, NoHide
selectedID := TV_GetSelection()
if (!selectedID) {
    MsgBox, You must select a folder to rename.
    Return
}
RenameFolderByID(selectedID)
Return

; -------------------------------------------------------
RenameFolderByID(itemID) {
    TV_GetText(oldName, itemID)
    Gui, +OwnDialogs
    InputBox, newName, Rename folder, Enter new name:, , 300, 120, , , , , %oldName%
    if (ErrorLevel)
        Return
    TV_Modify(itemID, "Text", newName)
    GuiControl, Choose, MyTree, %itemID%
}

; -------------------------------------------------------
AddFile:
Gui, Submit, NoHide
selectedID := TV_GetSelection()

if (!selectedID) {
    MsgBox, You must first select a folder in the TreeView.
    Return
}

type := NodeTypeMap.HasKey(selectedID) ? NodeTypeMap[selectedID] : InferNodeType(selectedID)

if (type = "file") {
    MsgBox, You can't add a file inside a file!
    Return
}

baseName := "New_File"
ext := ".txt"
fileName := baseName . ext
counter := 1

;;∙------∙Search for duplicates among the children of the current node.
childID := TV_GetChild(selectedID)
Loop {
    if (!childID)
        break
    TV_GetText(existingName, childID)
    if (existingName = fileName) {
        counter++
        fileName := baseName . counter . ext
        childID := TV_GetChild(selectedID)  ; the cycle begins again
        continue
    }
    childID := TV_GetNext(childID)
}

newID := TV_Add(fileName, selectedID, "Icon" fileIcon)
NodeTypeMap[newID] := "file"
TV_Modify(selectedID, "Expand")
GuiControl, Choose, MyTree, %newID%
RenameFolderByID(newID)
GuiControl, Focus, SelectedFolder
GuiControl, Focus, MyTree
Return

; -------------------------------------------------------
RemoveFolder:
Gui, Submit, NoHide
selectedID := TV_GetSelection()
if (selectedID)
    RemoveNodeAndChildren(selectedID)
Return

; -------------------------------------------------------
TreeEvent:
Return

; -------------------------------------------------------
StartProcess:
Gui, Submit, NoHide
if (!SelectedFolder || SelectedFolder = "No folder selected...")
{
    MsgBox, You need to select a destination folder, please click the "Target Path" button.
    Return
}
folderPaths := []
nodeIDs := []
GetTreePaths("", 0, folderPaths, nodeIDs)

for index, path in folderPaths
{
    id := nodeIDs[index]
    type := NodeTypeMap.HasKey(id) ? NodeTypeMap[id] : InferNodeType(id)
    fullPath := SelectedFolder . "\" . path

    if (type = "file") {
        FileAppend,, %fullPath%  ; create empty file
    } else {
        FileCreateDir, %fullPath%
    }
}
MsgBox, Structure successfully created in: %SelectedFolder%
Return

; -------------------------------------------------------
;;∙------∙Title.
TitleLabel:
return

;;∙------∙Function to show version information.
ShowVersionInfo:
{
    version := "1.0.0"

    MsgBox, 64, Version Info,
    (
Folder Tree Creator: %version%
		
Author: Special-Niewbie Softwares
Copyright (C) 2025 Special-Niewbie Softwares
    )
    Return
}

ReloadScript:
    Reload
return

GuiClose:
ExitApp

ExitApp:
ExitApp

; -------------------------------------------------------
GetTreePaths(currentPath, parentID, ByRef folderPaths, ByRef nodeIDs) {
    itemID := TV_GetChild(parentID)
    while (itemID) {
        TV_GetText(text, itemID)
        fullPath := (currentPath = "" ? text : currentPath . "\" . text)
        folderPaths.Push(fullPath)
        nodeIDs.Push(itemID)
        GetTreePaths(fullPath, itemID, folderPaths, nodeIDs)
        itemID := TV_GetNext(itemID)
    }
}

; -------------------------------------------------------
;;∙------∙ADDITION: Hook function to color button borders.
WM_CTLCOLORBTN(wParam, lParam) {
    global hwndAdd, hwndRemove, hwndStart, hwndRename
    global hBrushAdd, hBrushRemove, hBrushStart, hBrushRename
    if (lParam = hwndAdd) {
        Return hBrushAdd
    } else if (lParam = hwndRemove) {
        Return hBrushRemove
    } else if (lParam = hwndStart) {
        Return hBrushStart
    } else if (lParam = hwndAddFile) {
		Return hBrushAddFile
	} else if (lParam = hwndRename) {
        Return hBrushRename
    } 
}

; -------------------------------------------------------
;;∙------∙Windows Function to color the buttons.
CreateSolidBrush(color) {
    return DllCall("gdi32.dll\CreateSolidBrush", "UInt", color, "Ptr")
}

; -------------------------------------------------------
RemoveNodeAndChildren(id) {
    global NodeTypeMap
    child := TV_GetChild(id)
    while (child) {
        RemoveNodeAndChildren(child)
        child := TV_GetNext(child)
    }
    NodeTypeMap.Delete(id)
    TV_Delete(id)
}

; -------------------------------------------------------
;;∙------∙Blow it's my Lib for TV_GetImageIndex as doesn't exist.
TV_GetImageIndex(ByRef outIndex, id) {
    ;;∙------∙LVM_GETIMAGELIST = 0x1002, TVM_GETITEM = 0x110C
    VarSetCapacity(tvi, 48, 0)    ;;∙------∙TVITEM structure (size may vary depending on AHK version)
    NumPut(0x1, tvi, 0, "UInt")    ;;∙------∙mask: TVIF_IMAGE
    NumPut(id, tvi, 4, "Ptr")    ;;∙------∙hItem
    SendMessage, 0x110C, 0, &tvi, , ahk_id %MyTree%    ;;∙------∙TVM_GETITEM
    outIndex := NumGet(tvi, 36, "Int")    ;;∙------∙iImage is at offset 36
    return outIndex != ""
}


; -------------------------------------------------------
InferNodeType(id) {
    global fileIcon
    TV_GetText(label, id)
    TV_GetImageIndex(iconIndex, id)
    ;;∙------∙If the icon matches that of the files or if it has a .txt extension or any dot, consider it a file.
    if (iconIndex = fileIcon || InStr(label, ".")) {
        NodeTypeMap[id] := "file"
        return "file"
    } else {
        NodeTypeMap[id] := "folder"
        return "folder"
    }
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

