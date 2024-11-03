
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script ∙---------∙ DoubleTap--⮚ Ctrl + [HOME] 
» Exit Script ∙-------------∙ DoubleTap--⮚ Ctrl + [Esc] 
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
» 
∙--------∙Source∙-------------------------∙
» 
» Author:  
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
GoSub, AutoExecute
;;∙============================================================∙




;;∙============================================================∙
AHK_Kill_All() 	 ; 
Tray_Refresh() 	 ; https://www.autohotkey.com/boards/viewtopic.php?t=19832#p156072
    Return
;;∙------------------------------------------∙
AHK_Kill_All() { 		 ; <-- Exits all AHK apps EXCEPT the calling script.
    DetectHiddenWindows, % ( ( DHW:=A_DetectHiddenWindows ) + 0 ) . "On"
    WinGet, L, List, ahk_class AutoHotkey
        Loop %L%
            If ( L%A_Index% <> WinExist( A_ScriptFullPath " ahk_class AutoHotkey" ) )
        PostMessage, 0x111, 65405, 0,, % "ahk_id " L%A_Index%
    DetectHiddenWindows, %DHW%
Sleep, 100
    {
  eee := DllCall( "FindWindowEx", "uint", 0, "uint", 0, "str", "Shell_TrayWnd", "str", "")
  ddd := DllCall( "FindWindowEx", "uint", eee, "uint", 0, "str", "TrayNotifyWnd", "str", "")
  ccc := DllCall( "FindWindowEx", "uint", ddd, "uint", 0, "str", "SysPager", "str", "")
  hNotificationArea := DllCall( "FindWindowEx", "uint", ccc, "uint", 0, "str", "ToolbarWindow32", "str", "Notification Area")
  xx = 3
  yy = 5
  Transform, yyx, BitShiftLeft, yy, 16
  loop, 6 ;152
  {
    xx += 15
    SendMessage, 0x200, , yyx + xx, , ahk_id %hNotificationArea%
  }
}
Sleep, 250
}
;;∙------------------------------------------∙
Tray_Refresh() {
    WM_MOUSEMOVE := 0x200
    detectHiddenWin := A_DetectHiddenWindows
    DetectHiddenWindows, On

    allTitles := ["ahk_class Shell_TrayWnd"
            , "ahk_class NotifyIconOverflowWindow"]
    allControls := ["ToolbarWindow321"
                ,"ToolbarWindow322"
                ,"ToolbarWindow323"
                ,"ToolbarWindow324"]
    allIconSizes := [24,32]

    for id, title in allTitles {
        for id, controlName in allControls
        {
            for id, iconSize in allIconSizes
            {
                ControlGetPos, xTray,yTray,wdTray,htTray,% controlName,% title
                y := htTray - 10
                While (y > 0)
                {
                    x := wdTray - iconSize/2
                    While (x > 0)
                    {
                        point := (y << 16) + x
                        PostMessage,% WM_MOUSEMOVE, 0,% point,% controlName,% title
                        x -= iconSize/2
                    }
                    y -= iconSize/2
                }
            }
        }
    }
    DetectHiddenWindows, %detectHiddenWin%
Sleep, 200
;;∙------------------------------------------∙
SoundGet, master_volume
SoundSet, 3
    Soundbeep, 1900, 75
        Sleep, 10
    Soundbeep, 1600, 75
        Sleep, 10
    Soundbeep, 1800, 75
        Sleep, 10
    Soundbeep, 1500, 75
        Sleep, 10
    Soundbeep, 1700, 75
        Sleep, 10
    Soundbeep, 1400, 75
    Soundbeep, 1200, 300
SoundSet, % master_volume
;;∙------------------------------------------∙
    ExitApp 	 ; <--Self exit once all others scripts are exited and Tray is refreshed.
}
Return
;;∙============================================================∙




;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙RELOAD / EXIT∙=========================================∙
RETURN
;;∙------∙RELOAD∙----∙RELOAD∙-------∙
^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;; Double-Tap.
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;; Double-Tap.
    ExitApp
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Script Updater∙=========================================∙
UpdateCheck:        ;; Check if the script file has been modified.
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
#NoEnv
#Persistent
#SingleInstance, Force
SetBatchLines -1
SetTimer, UpdateCheck, 500
SetTitleMatchMode 2
SetWinDelay 0
Menu, Tray, Icon, netshell.dll, 99
Return
;;∙============================================================∙

;;∙------------------------------------------------------------------------------------------∙
;;∙========================∙SCRIPT END∙=========================∙
;;∙------------------------------------------------------------------------------------------∙
