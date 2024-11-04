
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
ScriptID := "CountUp_Timer"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙




guiColor := "Aqua"
guiFont := "Segoe UI"
guiFontSize := "15"    ;;∙------∙Sets time text (Hr/min/sec), which also adjust all other controls.
    guiFontTextColor := "171717"
    guiFontTimeColor := "Blue"


PAUSE:
IF Stop =    
    {
        Start := A_TickCount
        SetTimer, Clock, 100
        Stop = 0

        Gui, +AlwaysOnTop -Caption +Border +Owner
        Gui, Color, %guiColor%
        Gui, Font, s%guiFontSize% w400 c%guiFontTextColor% q5, %guiFont%
        Gui, Add, Text, x15 y10 vLabels BackgroundTrans, %A_Space%Hour`t Minute`t  Second%A_Space%
            iconSize := (guiFontSize + 4)
        Gui, Add, Picture, x+15 y10 HwndhText BackgroundTrans gPAUSE w%iconSize% h%iconSize% Icon14, accessibilitycpl.dll
            GuiTip(hText, "Pause / Unpause")
        Gui, Add, Picture, y+5 HwndhText BackgroundTrans gRELOAD w%iconSize% h%iconSize% Icon239, Shell32.dll
            GuiTip(hText, "Reload")
        Gui, Add, Picture, y+5 HwndhText BackgroundTrans gEXIT w%iconSize% h%iconSize% Icon2, comctl32.dll
            GuiTip(hText, "Exit")
            guiFontSize2 := guiFontSize * 2.5
        Gui, Font, s%guiFontSize2% w800 c%guiFontTimeColor% q5, %guiFont%
            yP := 10 + (guiFontSize + 1)
        Gui, Add, Text, x15 y%yP% vStopWatch BackgroundTrans, 00 : 00 : 00
            guiH := (guiFontSize + guiFontSize2 * 2) +10
        Gui, Submit, NoHide
        Gui, Show, h%guiH%
    }
    Else If Stop := !Stop
    {
        Start -= A_TickCount
        Soundbeep, 900, 100
    }
    Else
    {
        Start += A_TickCount
        Soundbeep, 1100, 100
    }
Return

Clock:
    Clock = 20000101000000
    Clock += (A_TickCount-Start)//1000, Seconds
    IF (Clock = OldClock) Or Stop
        Return
    FormatTime, Clock,% OldClock := Clock, HH:mm:ss
    ;;∙------∙Update the stopwatch display
    GuiControl,, StopWatch,% SubStr(Clock,1,2) " : " SubStr(Clock,4,2) " : " SubStr(Clock,7,2)
Return

GuiTip(hCtrl, text:="")
    {
        hGui := text!="" ? DlLCall("GetParent", "Ptr", hCtrl) : hCtrl
        static hTip
        if !hTip
        {
            hTip := DllCall("CreateWindowEx", "UInt", 0x8, "Str", "tooltips_class32"
                 ,  "Ptr", 0, "UInt", 0x80000002 ;// WS_POPUP:=0x80000000|TTS_NOPREFIX:=0x02
                 ,  "Int", 0x80000000, "Int",  0x80000000, "Int", 0x80000000, "Int", 0x80000000
                 ,  "Ptr", hGui, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Ptr")
            ;;∙------∙TTM_SETMAXTIPWIDTH = 0x0418
            DllCall("SendMessage", "Ptr", hTip, "Int", 0x0418, "Ptr", 0, "Ptr", 0)
            if (A_OsVersion == "WIN_XP")
                GuiTip(hGui)
        }
        static sizeof_TOOLINFO := 24 + (6 * A_PtrSize)
        VarSetCapacity(TOOLINFO, sizeof_TOOLINFO, 0)
        , NumPut(sizeof_TOOLINFO, TOOLINFO, 0, "UInt")
        , NumPut(0x11, TOOLINFO, 4, "UInt") ; TTF_IDISHWND:=0x0001|TTF_SUBCLASS:=0x0010
        , NumPut(hGui, TOOLINFO, 8, "Ptr")
        , NumPut(hCtrl, TOOLINFO, 8 + A_PtrSize, "Ptr")
        , NumPut(&text, TOOLINFO, 24 + (3 * A_PtrSize), "Ptr")
        static TTM_ADDTOOL := A_IsUnicode ? 0x0432 : 0x0404
        return DllCall("SendMessage", "Ptr", hTip, "Int", TTM_ADDTOOL, "Ptr", 0, "Ptr", &TOOLINFO)
    }
Return




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
        RELOAD:
        SoundBeep, 1100, 75
        Soundbeep, 1200, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙--∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
    EXIT:
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
 ;   Soundbeep, 1700, 100
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
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;; Gui Drag Pt 1.
SetBatchLines -1
SetTimer, UpdateCheck, 500
SetTitleMatchMode 2
SetWinDelay 0
Menu, Tray, Icon, Shell32.dll, 266
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
CountUp_Timer:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

