

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
SetTimer, UpdateCheck, 750
ScriptID := "Dot_Symbol_Sender"
#NoTrayIcon


;;∙======∙SEND-DOTS∙===========∙
^.::    ;;∙------∙🔥∙(Ctrl + Period)
Switch, Morse() {
    Case "0": SendInput {U+2022} 	;;∙------∙ • (bullet)
    Case "00": SendInput {U+2219} 	;;∙------∙ ∙ (bullet operator)
    Case "000": SendInput {U+00B0} 	;;∙------∙ ° (degree symbol)
}
Return


;;∙======∙MORSE-PATTERN∙=======∙
Morse(Timeout = 400) {
    Global Pattern := ""
    RegExMatch(A_ThisHotkey, "\W$|\w*$", Key)
    While, !ErrorLevel {
        T := A_TickCount
        KeyWait %Key%
        PressDuration := A_TickCount - T
        If (PressDuration > Timeout) {
            SoundBeep, 800, 200    ;;∙------∙Long beep - pressed too long.
            Pattern .= 1
        } Else {
       ;     SoundBeep, 1100, 75    ;;∙------∙Short beep - short press.
            Pattern .= 0
        }
        KeyWait %Key%, % "DT" Timeout/1000
    }
    Return Pattern
}


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

