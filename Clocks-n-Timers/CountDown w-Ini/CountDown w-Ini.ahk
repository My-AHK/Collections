
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  HuBa
» Original Source:  https://www.autohotkey.com/board/topic/19679-yet-another-countdown-script/
» 
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
/*
   • A GUI-based countdown timer.
   • Duration settable via hours/minutes/seconds.
   • Optional sound alert when done.
   • Persistent user settings in INI file.
   • Start/Stop control and sound test feature.
*/

;;∙============================================================∙
#SingleInstance Off    ;;∙------∙Allow multiple instances.

cd_IniFile := A_ScriptDir "\CountDown.ini"

    ;;∙------∙Read settings from INI file.
IniRead cd_Duration, %cd_IniFile%, Main, Duration, % 5*60
IniRead cd_PlaySound, %cd_IniFile%, Main, PlaySound, %True%
IniRead cd_SoundFile, %cd_IniFile%, Main, SoundFile, %A_ScriptDir%\

Gui, Color, 76CEFF
Gui Add, Text, x30 y20 w100 h20, &Hours:
Gui Add, Edit, x90 y18 w80 h20 Number vcd_HoursEdit gTimeEdited, % cd_Duration // 3600
Gui Add, Text, x30 y42 w100 h20, &Minutes:
Gui Add, Edit, x90 y40 w80 h20 Number vcd_MinutesEdit gTimeEdited, % mod(cd_Duration, 3600) // 60
Gui Add, Text, x30 y64 w100 h20, S&econds:
Gui Add, Edit, x90 y62 w80 h20 Number vcd_SecondsEdit gTimeEdited, % mod(cd_Duration, 60)
Gui Add, Text, x30 y86 w210 h20 vcd_DurationText
Gui Add, Checkbox, x30 y111 w200 h30 vcd_PlaySoundCheckBox, &Play sound at the end of countdown
GuiControl,, cd_PlaySoundCheckBox, %cd_PlaySound%
Gui Add, Button, x30 y140 w80 h22 gSoundFileBrowse, Sound &file:
Gui Add, Edit, x30 y164 w200 h20 vcd_SoundFileEdit, %cd_SoundFile%
Gui Add, Button, x180 y140 w50 h22 gPlayFinishSound, &Test
Gui Font, Bold
Gui Add, Button, x30 y200 w200 h30 vcd_Button gCountDownPress Default, &START
Gosub TimeEdited
Gui Show, h250 w260, CountDown
Gui +LastFound
cd_Gui := WinExist()    ;;∙------∙Remember Gui window ID.
Return

CountDownPress:
    GuiControlGet cd_ButtonCaption,, cd_Button
    if cd_ButtonCaption = &STOP    ;;∙------∙Compare button text.
    {
        SetTimer CountDownTimer, Off
        WinSetTitle ahk_id %cd_Gui%,, CountDown
        GuiControl,, cd_Button, &START
        Return
    }
    cd_Duration := GetDurationInSec()
    if cd_Duration <= 0
    {
        MsgBox 16, Error, Invalid time.
        Return
    }
    WinSetTitle ahk_id %cd_Gui%,, %cd_Duration%    ;;∙------∙Refresh tray button text.
    GuiControl,, cd_Button, &STOP
    SetTimer CountDownTimer, 1000
Return

CountDownTimer:
    cd_Duration--
    WinSetTitle ahk_id %cd_Gui%,, %cd_Duration%    ;;∙------∙Refresh tray button text.
    if cd_Duration > 0
        Return
    Gui Flash    ;;∙------∙Flash the tray button.
    GuiControlGet cd_PlaySound,, cd_PlaySoundCheckBox
    if cd_PlaySound    ;;∙------∙Play sound if checked.
        Gosub PlayFinishSound    ;;∙------∙Let me hear that sound!.
    Gosub CountDownPress
Return

SoundFileBrowse:
    FileSelectFile cd_SoundFile, 1, %cd_SoundFile%    ;;∙------∙Open file selection dialog.
    if cd_SoundFile
        GuiControl,, cd_SoundFileEdit, %cd_SoundFile%
Return

PlayFinishSound:
    GuiControlGet cd_SoundFile,, cd_SoundFileEdit    ;;∙------∙Get filename.
    IfExist %cd_SoundFile%
        SoundPlay %cd_SoundFile%
Return

TimeEdited:    ;;∙------∙Update duration text.
    GuiControl,, cd_DurationText, % "Duration: " GetDurationInSec() " seconds"
Return

GetDurationInSec()
{
    local Hours, Minutes, Seconds
    GuiControlGet Hours,, cd_HoursEdit
    GuiControlGet Minutes,, cd_MinutesEdit
    GuiControlGet Seconds,, cd_SecondsEdit
    Return Hours * 3600 + Minutes * 60 + Seconds
}

GuiClose:    ;;∙------∙Close window, save settings to INI file.
    GuiControlGet cd_PlaySound,, cd_PlaySoundCheckBox
    GuiControlGet cd_SoundFile,, cd_SoundFileEdit
    IniWrite % GetDurationInSec(), %cd_IniFile%, Main, Duration
    IniWrite %cd_PlaySound%, %cd_IniFile%, Main, PlaySound
    IniWrite %cd_SoundFile%, %cd_IniFile%, Main, SoundFile
    ExitApp
Return
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

