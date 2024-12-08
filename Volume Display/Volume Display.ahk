
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙--------∙Origins∙-------------------------∙
» Author:  
» Original Source:  
» 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "Volume_Display"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
;;∙------------∙Settings∙------------------------------------∙
defaultVolume := "1"

volumeTextFont := "Verdana"
volumeLevelFont := "Calibri"

SWide := A_ScreenWidth - 53
SHigh := A_ScreenHeight - 40
GWidth := 48
GHeight := 41

TaskbarAreaX := A_ScreenWidth - 153    ;;∙------∙400 pixels from the right side of the screen
TaskbarAreaY := A_ScreenHeight - 39    ;;∙------∙50 pixels from the bottom of the screen

;;∙------------∙Timers∙------------------------------------∙
SetTimer, ShowVol, 50    ;;∙------∙Keeps above taskbar in z-order.
;;∙------∙SetTimer, RefreshTime, 540000    ;;∙------∙Reloads script every 9 minutes. (resets default valume also)
SoundSet, %defaultVolume%    ;;∙------∙Sets starting volume level.


Gui, +AlwaysOnTop -Caption +LastFound +ToolWindow
;;∙------∙            +E0x20    ;;<∙------∙UnComment to allow click-through ability.
 WinSet Transparent, 255    ;;∙------∙Full Opaqueness.
Gui, Color, 1B1F21
Gui, Margin, 3, 2

Gui, Font, s6 w600 cAQUA q5, %volumeTextFont%    ;;∙------∙Aqua VOLUME.
    Gui, Add, Text, x3 y6 gVolume, VOLUME
Gui, Font, s12 w400 cLIME q5, %volumeLevelFont%    ;;∙------∙Lime % Volume Value.
    Gui, Add, Text, x5 y16 w%GWidth% BackgroundTrans vVolumeText, 
Gui, Font, s8 w400 c6F0000 q5, %volumeLevelFont%    ;;∙------∙TERMINATE!
    Gui, Add, Text, x35 y18 BackgroundTrans gCloseV, X

Gui, Show, x%SWide% y%SHigh% w%GWidth% h%GHeight% NA, Vol-Level
    SetTimer, updateVolume, 500
Return

;;------------------------------------------------------------- 

updateVolume() { ;;∙------∙ Function for updating volume.
    SoundGet, Volume
    VolumePercentage := Round(Volume)
        if (Volume == 0) {
            GuiControl, -Redraw, VolumeText
            Gui, Font, s6 w600 cC0C0C0 q5, %volumeTextFont%    ;;∙------∙ SILVER > MUTED VOLUME.
            GuiControl, Font, VolumeText
            GuiControl, +Redraw, VolumeText
            GuiControl,, VolumeText, MUTE    ;;∙------∙ MUTED VOLUME.  BOLD
        }
        else if (Volume == 100) {
            GuiControl, -Redraw, VolumeText
            Gui, Font, s10 w600 cFF0000 q5, %volumeTextFont%    ;;∙------∙ RED > MAX VOLUME.
            GuiControl, Font, VolumeText
            GuiControl, +Redraw, VolumeText
            GuiControl,, VolumeText, MAX    ;;∙------∙ MAXED VOLUME.  BOLD
        }
        else if (Volume >= 25 && Volume <= 35) {
            GuiControl, -Redraw, VolumeText
            Gui, Font, s12 w400 cBFFF00 q5, %volumeLevelFont% 
            GuiControl, Font, VolumeText
            GuiControl, +Redraw, VolumeText
            GuiControl,, VolumeText, %VolumePercentage%`%    ;;∙------∙ Lime/Yellow Zone.  (25%-35%)
        }
        else if (Volume >= 35 && Volume <= 50) {
            GuiControl, -Redraw, VolumeText
            Gui, Font, s12 w400 cFFFF00 q5, %volumeLevelFont% 
            GuiControl, Font, VolumeText
            GuiControl, +Redraw, VolumeText
            GuiControl,, VolumeText, %VolumePercentage%`%    ;;∙------∙ Yellow Zone.  (35%-50%)
        }
        else if (Volume >= 50 && Volume <= 65) {
            GuiControl, -Redraw, VolumeText
            Gui, Font, s12 w400 cFFBE00 q5, %volumeLevelFont% 
            GuiControl, Font, VolumeText
            GuiControl, +Redraw, VolumeText
            GuiControl,, VolumeText, %VolumePercentage%`%    ;;∙------∙ Yellow/Orange Zone.  (50%-65%)
        }
        else if (Volume >= 65 && Volume <= 80) {
            GuiControl, -Redraw, VolumeText
            Gui, Font, s12 w400 cFF8000 q5, %volumeLevelFont% 
            GuiControl, Font, VolumeText
            GuiControl, +Redraw, VolumeText
            GuiControl,, VolumeText, %VolumePercentage%`%    ;;∙------∙ Orange Zone.  (65%-80%)
        }
        else if (Volume >= 80 && Volume <= 90) {
            GuiControl, -Redraw, VolumeText
            Gui, Font, s12 w400 cFF5500 q5, %volumeLevelFont% 
            GuiControl, Font, VolumeText
            GuiControl, +Redraw, VolumeText
            GuiControl,, VolumeText, %VolumePercentage%`%    ;;∙------∙ Orange/Red Zone.  (80%-90%)
        }
        else if (Volume >= 90 && Volume <= 99) {
            GuiControl, -Redraw, VolumeText
            Gui, Font, s12 w400 cFF1111 q5, %volumeLevelFont% 
            GuiControl, Font, VolumeText
            GuiControl, +Redraw, VolumeText
            GuiControl,, VolumeText, %VolumePercentage%`%    ;;∙------∙ Red Zone.  (90%-99%)
        }
        else {
            GuiControl, -Redraw, VolumeText
            Gui, Font, s12 w400 cLIME q5, %volumeLevelFont% 
            GuiControl, Font, VolumeText
            GuiControl, +Redraw, VolumeText
            GuiControl,, VolumeText, %VolumePercentage%`%    ;;∙------∙ Lime > Comfort Zone Volume.  (1%-24%)
        }
    }
Return
;--------------- 
ShowVol:
    Gui, Show, NA, Vol-Level
Return

Volume:
    SoundSet, %defaultVolume%
Return

;;------------------------------------------------------------- 

;;---------- VOLUME HOVER
;;==========UP=========== 
~WheelUp::    ;;∙------∙ ~ = When the hotkey fires, its key's native function will not be blocked (hidden from the system).
CoordMode, Mouse, Screen
MouseGetPos, xPos, yPos
    if (xPos >= TaskbarAreaX && yPos >= TaskbarAreaY && xPos <= (TaskbarAreaX + 150) && yPos <= (TaskbarAreaY + 40))
        {
        SoundSet +2
        }
Return
;;========DOWN========= 
~WheelDown::    ;;∙------∙ ~ = When the hotkey fires, its key's native function will not be blocked (hidden from the system).
CoordMode, Mouse, Screen
MouseGetPos, xPos, yPos
    if (xPos >= TaskbarAreaX && yPos >= TaskbarAreaY && xPos <= (TaskbarAreaX + 150) && yPos <= (TaskbarAreaY + 40))
        {
        SoundSet -2
        }
Return
;;------------------------------------------------------------- 
RefreshTime:
    Reload
Return

CloseV:
    ExitApp
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
        SoundBeep, 1100, 75
        Soundbeep, 1200, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
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
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.
SetBatchLines -1
SetTimer, UpdateCheck, 500
SetTitleMatchMode 2
SetWinDelay 0
Menu, Tray, Icon, wmploc.dll, 67
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
Volume_Display:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

