
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙----------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙--------------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
» 
∙--------∙Origins∙-------------------------∙
» Author:  
» Source:  
» 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TimeSpeak"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
SetTimer, AnnounceHour, 1000    ;;∙------∙TimeSpeak specific.
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
^t::
    GoSub, SayTime
Return

;;∙------------------------∙
AnnounceHour:
    FormatTime, AnnounceHour, %A_Now%, h    ;;∙------∙Get current hour.
    FormatTime, AnnounceMinute, %A_Now%, m    ;;∙------∙Get current minutes.
    FormatTime, AnnounceAMPM, %A_Now%, tt    ;;∙------∙Get AM/PM.
;;∙------∙
    If(AnnounceMinute<1)
    {
        IfInString, AnnounceAMPM, AM    ;;∙------∙If AM, say a m instead of ameters.
            AnnounceAMPM = A. M.
        IfInString, AnnounceAMPM, PM    ;;∙------∙If PM, say p m instead of pmeters.
            AnnounceAMPM = P. M.
        AnnounceHourString = The time is %AnnounceHour% %AnnounceAMPM%    ;;∙------∙oh clock %AnnounceAMPM%    ;;∙------∙announce time.
        ComObjCreate("SAPI.SpVoice").Speak(AnnounceHourString)
        sleep 1000
        loop %AnnounceHour%
        {
            SoundPlay, %A_ScriptDir%\Chime.wav
            Sleep 1200
        }
    }
;;∙------∙
    If(AnnounceMinute=15 || AnnounceMinute=30 || AnnounceMinute=45)
    {
        IfInString, AnnounceAMPM, AM    ;;∙------∙If AM, say a m instead of ameters.
            AnnounceAMPM = A. M.
        IfInString, AnnounceAMPM, PM    ;;∙------∙If PM, say p m instead of pmeters.
            AnnounceAMPM = P. M.
        AnnounceHourString = The time is %AnnounceHour%  %AnnounceMinute%  %AnnounceAMPM%    ;;∙------∙oh clock %AnnounceAMPM%    ;;∙------∙announce time.
        ComObjCreate("SAPI.SpVoice").Speak(AnnounceHourString)
    }
    SetTimer, AnnounceHour, Off    ;;∙------∙Stop the timer for 65 seconds to prevent spamming.
    Sleep 65000
    SetTimer, AnnounceHour, On
Return

;;∙------------------------∙
SayTime:
    FormatTime, SayHour, %A_Now%, h    ;;∙------∙Get current hour.
    FormatTime, SayMinute, %A_Now%, m    ;;∙------∙Get current minutes.
    FormatTime, SayAMPM, %A_Now%, tt    ;;∙------∙Get AM/PM.
    ;;∙------∙
    If(SayMinute>0 && SayMinute<10)    ;;∙------∙Add the "oh" for minutes 1 through nine.
        SayMinute = oh %SayMinute%
    If(SayMinute=0)    ;;∙------∙If the current minute is 0, say oh clock instead of zero.
        SayMinute = oh clock
    IfInString, SayAMPM, AM    ;;∙------∙If AM, say a m instead of ameters.
        SayAMPM = A. M.
    IfInString, SayAMPM, PM    ;;∙------∙If PM, say p m instead of pmeters.
        SayAMPM = P. M.
;;∙------∙
    SayTimeString = The time is %SayHour% %SayMinute% %SayAMPM%    ;;∙------∙Announce time.
    ComObjCreate("SAPI.SpVoice").Speak(SayTimeString)
Return
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
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙--∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        SoundBeep, 1100, 75
        Soundbeep, 1200, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙--∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        Soundbeep, 1100, 75
        Soundbeep, 1000, 100
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
#MaxThreadsPerHotkey 3
#NoEnv
;;∙------∙#NoTrayIcon
#Persistent
#SingleInstance, Force
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙=∙Gui Drag Pt 1∙=∙
SetBatchLines -1
SetTimer, UpdateCheck, 500
SetTitleMatchMode 2
SetWinDelay 0
Menu, Tray, Icon, mmcndmgr.dll, 15
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
Menu, Tray, Icon, Suspend / Pause, shell32, 28  ;  Imageres.dll, 65
Menu, Tray, Default, Suspend / Pause    ;;∙------∙Makes Bold.
Menu, Tray, Add
;;------------------------------------------∙

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
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙MENU CALLS∙==========================================∙
TimeSpeak:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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
;;∙======∙TRAY MENU POSITION FUNTION∙======∙
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
;;∙============================================================∙

;;∙------------------------------------------------------------------------------------------∙
;;∙========================∙SCRIPT END∙=========================∙
;;∙------------------------------------------------------------------------------------------∙

