
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  
» Original Source:  
» 
    ▹ 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "Centered_Image/Text"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
;;∙============================================================∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force
SendMode, Input
SetBatchLines -1
SetTitleMatchMode 2
SetWinDelay 0
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.

^F1::    ;;∙------∙🔥∙(Ctrl + F1)

;;∙======∙SETTINGS∙========================∙
;;∙------∙Initial Gui build.
guiColor := "6F6F6F"
guiFont := "Segoe UI"
guiFontColor := "BLUE"
guiFontSize := "17"

;;∙------∙Gui 'x' & 'y' axis (If empty, will center to active screen).
guiX := "800"
guiY := "300"

;;∙------∙Initial Gui width & height.
guiW := "300"
guiH := "200"

;;∙------∙Set Gui Minimum & Maximum dimensions.
guiMin := "200x100"
guiMax := "600x400"

;;∙------∙Image Path (Set Path Detection)
;; imagePath := A_ScriptDir . "\Image.png"    ;;∙------∙Image located In Script Folder.
imagePath := A_ScriptDir . "\BAT.png"
;;∙------∙OR∙------∙
;;  imagePath := "C:\Path\To\Your\Image.png"    ;;<∙------∙Change this to your Full image path!!

;;∙========================================∙

OnMessage(0x84, "WM_NCHITTEST")    
OnMessage(0x83, "WM_NCCALCSIZE")    

Gui, +AlwaysOnTop +ToolWindow
Gui, Color, %guiColor%
Gui, +resize MinSize%guiMin% maxsize%guiMax%    
Gui, Font, s%guiFontSize% c%guiFontColor% Bold, %guiFont%

Gui, Add, Picture, vCenteredImage, %imagePath%
Gui, Add, Text, vCenteredText BackgroundTrans, Resize && Drag`n  As Needed

if (guiX = "" or guiY = "")
{
    WinGet, activeWin, ID, A
    if (activeWin) {
        WinGetPos, winX, winY, winW, winH, ahk_id %activeWin%
        activeMonitorX := (winX + winW/2)
        activeMonitorY := (winY + winH/2)
        SysGet, monitorCount, MonitorCount
        Loop, %monitorCount% {
            SysGet, monitor, Monitor, %A_Index%
            if (activeMonitorX >= monitorLeft && activeMonitorX <= monitorRight && activeMonitorY >= monitorTop && activeMonitorY <= monitorBottom) {
                centerX := monitorLeft + (monitorRight - monitorLeft - guiW) // 2
                centerY := monitorTop + (monitorBottom - monitorTop - guiH) // 2
                break
            }
        }
    }
    ;;∙------∙Fallback if can't determine active monitor, use primary monitor.
    if (centerX = "" or centerY = "") {
        SysGet, primaryMonitor, Monitor, 1
        centerX := primaryMonitorLeft + (primaryMonitorRight - primaryMonitorLeft - guiW) // 2
        centerY := primaryMonitorTop + (primaryMonitorBottom - primaryMonitorTop - guiH) // 2
    }
    Gui, Show, x%centerX% y%centerY% w%guiW% h%guiH%
}
else
{
    Gui, Show, x%guiX% y%guiY% w%guiW% h%guiH%
}
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    
Return


GuiSize:    
{
    Gui, Submit, NoHide    
    Gui, +LastFound
    WinGetPos, , , guiWidth, guiHeight
    GuiControlGet, imagePos, Pos, CenteredImage
    imageX := (guiWidth - imagePosW) / 2
    imageY := (guiHeight - imagePosH - 40) / 3    ;;∙------∙Leave space for text.
    GuiControlGet, textPos, Pos, CenteredText
    textX := (guiWidth - textPosW) / 2
    textY := imageY + imagePosH + 10    ;;∙------∙10 pixels below image.
    GuiControl, Move, CenteredImage, x%imageX% y%imageY%
    GuiControl, Move, CenteredText, x%textX% y%textY%
    WinSet, Redraw    ;;∙------∙Force redraw to fix rendering artifacts.
}
Return

WM_NCCALCSIZE()
{
    if A_Gui
        return 0
}

;;∙------∙Redefine where sizing borders are.
WM_NCHITTEST(wParam, lParam)
{
    static border_size = 6    ;;∙------∙Define border size of 6 pixels.
        if !A_Gui
        return
        WinGetPos, gX, gY, gW, gH

    x := lParam<<48>>48  ,  y := lParam<<32>>48    ;;∙------∙Extract x & y coordinates.

    hit_left    := x <  gX+border_size    ;;∙------∙Detect if hit is on left border.
    hit_right   := x >= gX+gW-border_size    ;;∙------∙Detect if hit is on right border.
    hit_top     := y <  gY+border_size    ;;∙------∙Detect if hit is on top border.
    hit_bottom  := y >= gY+gH-border_size    ;;∙------∙Detect if hit is on bottom border.

    if hit_top    ;;∙------∙If hit on the top border.
    {
        if hit_left    ;;∙------∙Top-left corner.
            return 0xD    ;;∙------∙Return value for resizing from top-left corner.
        else if hit_right    ;;∙------∙Top-right corner.
            return 0xE    ;;∙------∙Return value for resizing from top-right corner.
        else
            return 0xC    ;;∙------∙Return value for resizing from top edge.
    }
    else if hit_bottom    ;;∙------∙If hit on bottom border.
    {
        if hit_left    ;;∙------∙Bottom-left corner.
            return 0x10    ;;∙------∙Return value for resizing from bottom-left corner.
        else if hit_right    ;;∙------∙Bottom-right corner.
            return 0x11    ;;∙------∙Return value for resizing from bottom-right corner.
        else
            return 0xF    ;;∙------∙Return value for resizing from bottom edge.
    }
    else if hit_left    ;;∙------∙If hit on left border.
        return 0xA    ;;∙------∙Return value for resizing from left edge.
    else if hit_right    ;;∙------∙If hit on right border.
        return 0xB    ;;∙------∙Return value for resizing from right edge.
}
Return

WM_LBUTTONDOWNdrag() {    ;;∙-------∙Gui Drag Pt 2.
   PostMessage, 0x00A1, 2, 0
}
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
Centered_Image/Text:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

