

;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙
;;∙======∙AUTO-EXECUTE∙===============∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance Force
SendMode, Input
SetBatchLines -1
SetWorkingDir %A_ScriptDir%
ScriptID := "Screen_Saver"
SetTimer, UpdateCheck, 750
#NoTrayIcon


;;∙======∙TRIGGER_SCREENSAVER∙========∙
^Enter::    ;;∙------∙🔥∙(Ctrl + Enter)
^NumpadEnter::     ;;∙------∙🔥∙(Ctrl + NumpadEnter)
        Soundbeep, 1700, 75
SendMessage, 0x0112, 0xF140, 0,, Program Manager  ; 0x0112 is WM_SYSCOMMAND, and 0xF140 is SC_SCREENSAVE.
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



