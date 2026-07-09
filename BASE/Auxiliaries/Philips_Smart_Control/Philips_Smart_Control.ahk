

;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙
;;∙======∙AUTO-EXECUTE∙========∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force
SendMode, Input
SetBatchLines -1
SetWinDelay 0
SetWorkingDir %A_ScriptDir%
SetTimer, UpdateCheck, 750
ScriptID := "Philips_Smart_Control"
#NoTrayIcon


;;∙======∙INITIALIZE∙============∙
TargetProcess := "SmartControl.exe"
CheckInterval := 3000 
SetTimer, CheckPROG, %CheckInterval% 	 


;;∙======∙CLOSE∙================∙
CheckPROG:
    If (ProcessDoesExist(TargetProcess)) {    ;;∙------∙Check if process is running.
    Sleep, 3000
        If (ProcessDoesExist(TargetProcess)) {    ;;∙------∙Check if process is still running.
            Process, Close, %TargetProcess%    ;;∙------∙If still running, terminate process.
    Soundbeep, 500, 75
        } 
    }
Return


;;∙======∙CLOSE-FUNCTION∙======∙
ProcessDoesExist(Name){
    Process, Exist, %Name%
    Return ErrorLevel
}
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


