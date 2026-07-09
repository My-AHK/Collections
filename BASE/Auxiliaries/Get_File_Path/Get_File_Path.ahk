

;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙
;;∙======∙AUTO-EXECUTE∙========∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance Force
SendMode, Input
SetBatchLines -1
SetWorkingDir %A_ScriptDir%
ScriptID := "Get_File_Path"
SetTimer, UpdateCheck, 750
#NoTrayIcon


;;∙======∙AUTO-EXECUTE∙========∙
^G::    ;;∙------∙🔥∙(Ctrl+G)∙🔥∙
    Soundbeep, 1700, 100

hwnd := WinExist("A")
for Window in ComObjCreate("Shell.Application").Windows  
    if (window.hwnd==hwnd) {
        Selection := Window.Document.SelectedItems
    for Items in Selection
        Get_File_Path := Items.path
    }
    Clipboard:= Get_File_Path
    Tooltip, % Get_File_Path
        SetTimer, RemoveToolTip, -3000
Return
RemoveToolTip:
ToolTip
Return


;;∙======∙SCRIPT UPDATE∙========∙
UpdateCheck:    ;;∙------Check if script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙

