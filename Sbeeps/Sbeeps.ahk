;;∙------------------------------------------------------------------------------------------∙

;;∙============================================================∙
;;∙------∙SCOPE:  Script Meant As An  #INCLUDE  File∙---------------------------∙
;;∙------∙Does not need to be running∙----------------------------------------------∙
;;∙------∙Just needs placed in same script folder or a full address∙------------∙
;;∙============================================================∙


;;∙============================================================∙
;;∙------∙Add to top of main scripts.
;;∙------∙#Include Sbeeps.ahk


;;∙============================================================∙
#SingleInstance, Force
#Persistent


;;∙============================================================∙
/*∙------∙USAGE EXAMPLE∙---∙(Freq1, Freq2, Freq3, Dur, Rep, Sleep)∙------∙
∙------------------------------------------------------------∙
Sbeeps(1100, 1500, 1300, 300, 1, 300)
Return
∙------------------------------------------------------------∙
*/


;;∙================∙THE FUNCTION∙==============================∙
;;∙------∙(Freq1, Freq2, Freq3, Dur, Rep, Sleep)∙------∙
Sbeeps(Frequency1 := 0, Frequency2 := 0, Frequency3 := 0, Duration := 250, Repeats := 1, sTime := 300) {
    Loop, %Repeats% {
        if (Frequency1 > 0) {  ;;∙------∙Play Frequency1 only if it's non-zero.
            SoundBeep, %Frequency1%, %Duration%
            Sleep, %sTime%   ;;∙------∙Optional delay between beeps.
        }
        if (Frequency2 > 0) {  ;;∙------∙Play Frequency2 only if it's non-zero.
            SoundBeep, %Frequency2%, %Duration%
            Sleep, %sTime%   ;;∙------∙Optional delay between beeps.
        }
        if (Frequency3 > 0) {  ;;∙------∙Play Frequency3 only if it's non-zero.
            SoundBeep, %Frequency3%, %Duration%
            Sleep, %sTime%   ;;∙------∙Optional delay between beeps.
        }
    }
    return
}
Return


;;∙======∙☠ KillKey ☠∙===========================================∙
^!Esc::    ;;∙------∙(Ctrl+Alt+Esc) 
    Soundbeep, 1500, 500
    ExitApp
Return
;;∙============================================================∙

;;∙------------------------------------------------------------------------------------------∙