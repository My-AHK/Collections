
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
» 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TEMPLATE"    ;;∙------∙Need to also change in "MENU CALLS"
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙🔥 HotKey 🔥∙===========================================∙
 ^t::    ;;∙------∙(Ctrl+T) 
;    Soundbeep, 1100, 100
;;∙============================================================∙




;;∙============================================================∙
;;∙------∙Initial Gui build.
guiColor := "000000"
guiFont := "Segoe UI"
guiFontColor := "BLUE"
guiFontSize := "17"
;;∙------∙Gui 'x' and 'y' axis.
guiX := "1300"
guiY := "300"
;;∙------∙Initial Gui width and height.
guiW := "300"
guiH := "200"
;;∙------∙Set Gui Minimum and Maximum dimensions.
guiMin := "200x100"
guiMax := "600x400"


OnMessage(0x84, "WM_NCHITTEST")    ;;∙------∙Intercept non-client hit test. (used for resizing)
OnMessage(0x83, "WM_NCCALCSIZE")    ;;∙------∙Intercept non-client size calculation. (used for border sizing)

Gui, +AlwaysOnTop
Gui, Color, %guiColor%
Gui, +resize MinSize%guiMin% maxsize%guiMax%    ;;∙------∙Make the GUI resizable with min and max size constraints.
Gui, Font, s%guiFontSize% c%guiFontColor% Bold, %guiFont%
Gui, Add, Text, vCenteredText, Resize && Drag`n  As Needed    ;;∙------∙Add a text label with a variable name for future reference.
Gui, Show, x%guiX% y%guiY% w%guiW% h%guiH%    ;;∙------∙Display the GUI with initial width 300 and height 200.
    OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙-------∙Gui Drag Pt 1.
Return

GuiSize:    ;;∙------∙Handle resizing of the GUI.
{
    Gui, Submit, NoHide    ;;∙------∙Submit the current GUI state. (NoHide to keep the window visible)
    
;∙------∙Get the current width and height of the GUI.
    GuiControlGet, pos, Pos, CenteredText
    Gui, +LastFound    ;;∙------∙Make the last created GUI window the default.
    WinGetPos, , , guiWidth, guiHeight
    
;;∙------∙Calculate new x and y positions to keep the text centered.
    newX := (guiWidth - posW) / 2
    newY := (guiHeight - posH) / 2
    
;;∙------∙Move the text to the new position.
    GuiControl, Move, CenteredText, x%newX% y%newY%
}
Return

WM_NCCALCSIZE()    ;;∙------∙Function to handle WM_NCCALCSIZE message.
{
    if A_Gui    ;;∙------∙If the message is for a GUI window.
        return 0    ;;∙------∙Return 0 to remove default sizing borders.
}

;;∙------∙Redefine where the sizing borders are. This is necessary since returning 0 for WM_NCCALCSIZE effectively gives borders zero size.

WM_NCHITTEST(wParam, lParam)    ;;∙------∙Function to handle WM_NCHITTEST message. (for border resizing logic)
{
    static border_size = 6    ;;∙------∙Define a custom border size of 6 pixels.
        if !A_Gui    ;;∙------∙If the message is not for a GUI window, exit the function.
        return
        WinGetPos, gX, gY, gW, gH    ;;∙------∙Get the current position and size of the window.
    
    x := lParam<<48>>48  ,  y := lParam<<32>>48    ;;∙------∙Extract the x and y coordinates from lParam.
    
    hit_left    := x <  gX+border_size    ;;∙------∙Detect if the hit is on the left border.
    hit_right   := x >= gX+gW-border_size    ;;∙------∙Detect if the hit is on the right border.
    hit_top     := y <  gY+border_size    ;;∙------∙Detect if the hit is on the top border.
    hit_bottom  := y >= gY+gH-border_size    ;;∙------∙Detect if the hit is on the bottom border.
    
    if hit_top    ;;∙------∙If hit on the top border.
    {
        if hit_left    ;;∙------∙Top-left corner.
            return 0xD    ;;∙------∙Return value for resizing from the top-left corner.
        else if hit_right    ;;∙------∙Top-right corner.
            return 0xE    ;;∙------∙Return value for resizing from the top-right corner.
        else
            return 0xC    ;;∙------∙Return value for resizing from the top edge.
    }
    else if hit_bottom    ;;∙------∙If hit on the bottom border.
    {
        if hit_left    ;;∙------∙Bottom-left corner.
            return 0x10    ;;∙------∙Return value for resizing from the bottom-left corner.
        else if hit_right    ;;∙------∙Bottom-right corner.
            return 0x11    ;;∙------∙Return value for resizing from the bottom-right corner.
        else
            return 0xF    ;;∙------∙Return value for resizing from the bottom edge.
    }
    else if hit_left    ;;∙------∙If hit on the left border.
        return 0xA    ;;∙------∙Return value for resizing from the left edge.
    else if hit_right    ;;∙------∙If hit on the right border.
        return 0xB    ;;∙------∙Return value for resizing from the right edge.
}
Return

WM_LBUTTONDOWNdrag() {    ;;∙-------∙Gui Drag Pt 2.
   PostMessage, 0x00A1, 2, 0
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
        Soundbeep, 1200, 75
        Soundbeep, 1400, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙--∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        Soundbeep, 1400, 75
        Soundbeep, 1200, 100
    ExitApp
Return
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
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;; Gui Drag Pt 1.
SetBatchLines -1
SetTimer, UpdateCheck, 500
SetTitleMatchMode 2
SetWinDelay 0
Menu, Tray, Icon, Imageres.dll, 65
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Tray Menu∙============================================∙
TrayMenu:
Menu, Tray, Tip, %ScriptID%    ;;∙------∙Suspends hotkeys then pauses script.
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, %ScriptID%
Menu, Tray, Icon, %ScriptID%, Imageres.dll, 65
Menu, Tray, Default, %ScriptID%    ;;∙------∙Makes Bold.
Menu, Tray, Add
;;∙------∙  ∙--------------------------------∙

;;∙------∙Script∙Options∙---------------∙
Menu, Tray, Add
Menu, Tray, Add, Script·Edit
Menu, Tray, Icon, Script·Edit, shell32.dll, 270
Menu, Tray, Add
Menu, Tray, Add, Script·Reload
Menu, Tray, Icon, Script·Reload, mmcndmgr.dll, 47
Menu, Tray, Add
Menu, Tray, Add, Script·Exit
Menu, Tray, Icon, Script·Exit, shell32.dll, 272
Menu, Tray, Add
Menu, Tray, Add
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙MENU CALLS∙==========================================∙
TEMPLATE:    ;;∙------∙Change as needed to match the 'ScriptID' variable in AutoExe section.
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

