



;;∙======∙Auto-Execute∙==========================================∙
#Persistent
#SingleInstance, Force
SetTimer, UpdateCheck, 500
Menu, Tray, Icon, imageres.dll, 3
;;∙============================================================∙


;;∙============================================================∙
OnMessage(0x404, "AHK_NOTIFYICON")
Return

AHK_NOTIFYICON(wParam, lParam) {
    If (lParam = 0x202) {
        Menu, Tray, Show
        Return 0
        }
    }
Return
;;∙============================================================∙






;;∙======∙Script Updater∙=========================================∙
UpdateCheck:    ;;∙------Check if the script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload
;;∙============================================================∙
;;∙================================∙
^Esc::
    Soundbeep, 1100, 300
    ExitApp
Return
;;∙================================∙






