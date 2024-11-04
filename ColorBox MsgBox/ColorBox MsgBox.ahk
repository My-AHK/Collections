
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
» Author:  paulobuchsbaum
» Source:  SOURCE :  https://www.autohotkey.com/boards/viewtopic.php?t=15787#p80109
» Custom Minimalist MsgBox
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "ColorBox"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙🔥 HotKey 🔥∙===========================================∙
^t::    ;;∙------∙(Ctrl+T) 
   Soundbeep, 1100, 100
;;∙============================================================∙




;;∙============================================================∙
;;∙--------∙ColorBox∙---------------------∙
ReStart:
;;∙------∙Initial Variables∙------∙
Title := "HEADER"    ;;∙------∙Title of the ColorBox window
MsG := "TESTing"    ;;∙------∙Message displayed inside the ColorBox
NbrButtons := "2"    ;;∙------∙Number of buttons shown in the ColorBox
TimeOut := "15"    ;;∙------∙Time before the ColorBox closes automatically (in seconds)
DefaultButton := "1"    ;;∙------∙Specifies the default button (1 = first button)
Text1 := "Retry"    ;;∙------∙Label for the first button
Text2 := "Exit"    ;;∙------∙Label for the second button
Text3 := "Cancel"    ;;∙------∙Label for the third button (unused here, as NbrButtons = 2)
Text4 := "Extra"    ;;∙------∙Label for the fourth button (unused)
Text5 := "Plus"    ;;∙------∙Label for the fifth button (unused)
FontLabel := "Segoe UI"    ;;∙------∙Font name used for the ColorBox text
FontOptions := "cAqua s12 w800"    ;;∙------∙Font options (color, size, weight)
WindowColor := "Teal"    ;;∙------∙Background color of the ColorBox window
CallerGui := ""    ;;∙------∙ID of the calling GUI (if any)
;;∙------∙
ColorBox(Title, MsG, NbrButtons, TimeOut, DefaultButton, Text1, Text2, Text3, Text4, Text5, FontLabel, FontOptions, WindowColor, CallerGui)


;;∙------------------------------------------------------------------------------------------∙
;;∙--------∙ColorBox Function∙---------∙
ColorBox(Tit = "HEADER", Mess="Pause", NBut=1,TOut=3, DefL=1, Text1L:="Retry", Text2L = "Exit", Text3L="Cancel", Text4L="Extra", Text5L = "Plus"
         , FontL="", FontOpt="cBlue w500 s12",WindowColor="85DEFF", CallerGui="")
{
    Static ETimeOut    ;;∙------∙Variable shared with timeout section
    Local RetLoc, HasGui, NInd, MaxBut=5
    ETimeOut := false
    RetLoc := 1
    HasGui := (CallerGui<>"")
    Labels := ["Retry","Exit","Cancel","Xtra","Plus"]
    if (HasGui)
       Gui,  %CallerGui%: +Disabled
       Gui, ColorBox: Destroy
       Gui, ColorBox: Color, %WindowColor%
    ;;∙------∙Apply Font Options (FontL = font name, FontOpt = font options)
    if (FontL <> "")
        Gui, ColorBox: Font, %FontOpt%, %FontL%
    else
        Gui, ColorBox: Font, %FontOpt%
       Gui, ColorBox: Add,Text, , %Mess%
       Gui, ColorBox: Font
       GuiControlGet,Text, ColorBox: Pos, Static1
    if (TOut<>0)    ;;∙------∙Prepare for default answer also in timeout event
    if (DefL<=1)  
       RetLoc := DefL=0 ? -1 : 1    ;;∙------∙Return -1 (No default) or 1 (OK)
    else   
       Loop % MaxBut-1  {
            NInd := A_Index+1    ;;∙------∙Return 0 (2 buttons and default 2nd Button) or (Button Number-1) if Default 3nd button and so on
        if ( DefL=NInd and NBut>=NInd ) 
            RetLoc := ( DefL=2 ? 0 : NInd-1 )
        }
    if (TOut<>0)    ;;∙------∙Prepare for default answer also in timeout event
      RetLoc  :=  DefL=0 ? -1 :  ( DefL=1 ?  1  :  (DefL = 2 and NBut>=2 ?  0 : ( DefL = 3 and NBut=3  ? 2 : DefL ) ) )
    Loop % NBut {
      if ( (Text1L = "Retry") and  (NBut=1) )
        Text1L := "OK"
      if (A_Index=1)    ;;∙------∙TextW: Non-documented variable that stores text width
        Gui, ColorBox: Add,Button,%  (DefL=1 or NBut=1 ? "Default " :  "") . "y+10 w75 gRetry xp+" (TextW / 2) - 38 * NBut , %Text1L% 
      else
        Gui, ColorBox: Add,Button,%  (DefL=A_Index ? "Default " :  "") . "yp+0 w75 g" .  Labels[A_Index] . " x+" 10, % Text%A_Index%L  
    }
;;∙------------------------------------------------------------------------------------------∙
;;∙--------∙ColorBox GUI∙---------------∙
;;∙------∙Clean and modal window message. No Minimize, Maximize, Close icons and AHK icon.
Gui, ColorBox: +AlwaysOnTop -Caption +OwnDialogs -SysMenu 
Gui, ColorBox: Show, , %Tit%
    If (TOut<>0)    ;;∙------∙TimeOut in seconds.
      SetTimer TimeOut, % TOut*1000
        Gui, ColorBox: +LastFound    ;;∙------∙Last selected window.
    WinWaitClose    ;;∙------∙Wait for the GUI window closes. Make it strictly modal.
    if (HasGui)
      Gui,  %CallerGui%:-Disabled    ;;∙------∙Enable caller GUI back .
    SetTimer TimeOut, Off
    Return RetLoc

 Retry:    ;;∙------∙1st button.
    Gui, ColorBox: Destroy
    RetLoc := 1
        Soundbeep, 1400, 100
        GoSub ReStart
    Return 
     
 Exit:    ;;∙------∙2nd button.
    Gui, ColorBox: Destroy
    RetLoc := 0
        Soundbeep, 900, 100
        Reload
    Return
    
 TimeOut:    ;;∙------∙Timeout section.
    Gui, ColorBox: Destroy  
    ETimeOut := True    ;;∙------∙Share just static variables with enclosing function.
    Return
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
;    Soundbeep, 1700, 100
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
Menu, Tray, Icon, imageres.dll, 3
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
ColorBox:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

