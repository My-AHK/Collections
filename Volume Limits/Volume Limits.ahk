
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙--------∙Origins∙-------------------------∙
» Author:  Laszlo
» Original Source:  https://www.autohotkey.com/board/topic/34174-dual-slider/
» 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "!_Volume_Limits_!"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙


;;∙======∙SETTINGS∙=============================================∙
;;∙------------∙Gui Coloring∙-------------------∙
guiNormColor := "283548"    ;;∙------∙Dark gray blue.
guiMuteColor := "6F0000"    ;;∙------∙Dark red.
;;∙------------∙Gui Positioning∙---------------∙
guiXaxis := 1600
guiYaxis := 950
;;∙------------∙Gui Dimensions∙---------------∙
guiW := 300
guiH := 80
;;∙------------∙Text Attributes∙----------------∙
guiFont := "Arial"
guiFontSize := "12"
guiFontColor := "3094E4"
guiFontWeight := "Bold"
;;∙------------∙Volume Limits∙----------------∙
minVolume := 3    ;;∙------∙Default MINimum slider position. (0...100)
maxVolume := 17    ;;∙------∙Default MAXimum slider position. (0...100)
volumeSliderWidth := 199    ;;∙------∙Slider scale width.
frequencyCheck := 300    ;;∙------∙Frequency to check volume level. (Milliseconds)
;;∙-----------------------------------------------------------------------------------------∙

;;∙======∙Gui Build∙=============================================∙
Gui, Destroy
Gui, +AlwaysOnTop -Caption +Border +Owner +E0x02000000
    DualSlide1 := minVolume , DualSlide2 := maxVolume
    DualSlideW := volumeSliderWidth
        DualSlideK := DualSlideW/100
        DualSlideU := DualSlideW+18
        DualSlideV := DualSlideU-1
Loop 2
Gui, Add, Slider, x40 y40 w%DualSlideU% vDualSlide%A_Index% gDualSlide%A_Index% hwndDualSlideHwnd%A_Index% AltSubmit Range0-100 TickInterval10 Thick13 -Theme ToolTipTop
Gui, Color, %guiNormColor%
Gui, Font, s%guiFontSize% %guiFontWeight% c%guiFontColor%, %guiFont%
Gui, Add, Text, x0 y10 w300 BackgroundTrans Center, !  Volume Limits  !
Gui, Add, Picture, x10 y5 w21 h21 Icon239 BackgroundTrans gReload, shell32.dll
Gui, Add, Picture, xp y50 w24 h24 Icon2 BackgroundTrans gMuted, SndVolSSO.dll
    Gosub Update
Gui, Add, Picture, x270 y5 w21 h21 Icon132 BackgroundTrans gExit, shell32.dll
Gui, Add, Picture, xp y50 w21 h21 BackgroundTrans Icon289 gHide, shell32.dll
Gui, Hide
    GoSub, DualSlide
Gui, Show, x%guiXaxis% y%guiYaxis% w%guiW% h%guiH%
SetTimer, VolumeLimits, %frequencyCheck%
Return
;;∙-----------------------------------------------------------------------------------------∙

;;∙======∙Routines and Functions∙=================================∙
Muted:
    SoundSet +1, , MUTE
Update:
SoundGet mute, , MUTE
    If (mute = "On") {
        Menu Tray, Icon, SndVolSSO.dll, 7
        Gui, Color, %guiMuteColor%
        Gui, Show, , Mute = ON
    } Else {
        Menu Tray, Icon, SndVolSSO.dll, 8
        Gui Color, %guiNormColor%
        Gui, Show, , Mute = OFF
    }
Return
;;∙------------------------∙
Hide:
    Gui, Hide
Return
;;∙------------------------∙
DualSlide1:
    DualSlide2 := DualSlide1 < DualSlide2 ? DualSlide2 : DualSlide1
    GoTo DualSlide
DualSlide2:
    DualSlide1 := DualSlide1 < DualSlide2 ? DualSlide1 : DualSlide2
DualSlide:
    GuiControl,,DualSlide1, %DualSlide1%
    GuiControl,,DualSlide2, %DualSlide2%
    DualSlideX := round(DualSlideK*DualSlide1+13)
    WinSet Region,% "1-1 " DualSlideX "-1 " DualSlideX "-19 1-19", ahk_id %DualSlideHwnd1%
    WinSet Region,% DualSlideX "-1 " DualSlideV "-1 " DualSlideV "-19 " DualSlideX "-19", ahk_id %DualSlideHwnd2%
Return
;;∙------------------------∙
VolumeLimits:
    SoundGet, isMuted, Master, Mute
    SoundGet, currentVolume, Master, Volume
        If (isMuted = 1 || currentVolume < DualSlide1)
            {
            SoundSet, 0, Master, Mute
            SoundSet, %DualSlide1%, Master, Volume
            }
        Else if (currentVolume > DualSlide2)
            {
            SoundSet, %DualSlide2%, Master, Volume
            }
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
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
    Reload:    ;;∙------∙Gui Button Call.
        SoundBeep, 1100, 75
        Soundbeep, 1200, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
    Exit:    ;;∙------∙Gui Button Call.
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
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.
SetBatchLines -1
SetTimer, UpdateCheck, 500
SetTitleMatchMode 2
SetWinDelay 0
Menu, Tray, Icon, SndVolSSO.dll, 8
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
Menu, Tray, Add, %ScriptID%, %ScriptID%    ;;∙------∙Script Header.
Menu, Tray, Icon, %ScriptID%, shell32, 35
Menu, Tray, Default, %ScriptID%    ;;∙------∙Makes Bold.
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
!_Volume_Limits_!:    ;;∙------∙
    Soundbeep, 700, 100
    Gui, Show
Return



/*        ∙------------∙ORIGINAL HEADER∙------------∙
Volume_Limits:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
    Suspend
    Soundbeep, 700, 100
    Pause
Return
*/

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

