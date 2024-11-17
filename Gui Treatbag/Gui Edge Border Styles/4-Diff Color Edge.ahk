
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
» Author:  TheDewd
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?t=17535#p86229
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "Four∙Walls"    ;;∙------∙Need to also change in "MENU CALLS"
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙🔥 HotKey 🔥∙===========================================∙
; ^t::    ;;∙------∙(Ctrl+T) 
;    Soundbeep, 1100, 100
;;∙============================================================∙




;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Settings Variables.∙=====================================∙
guiColor := "161616"    ;;∙--------∙Dark Gray.

guiX := "100"    ;;∙--------∙Gui x-axis.
guiY := "150"    ;;∙--------∙Gui y-axis.

guiW := "650"    ;;∙--------∙Gui Width.
guiH := "400"    ;;∙--------∙Gui Height.

edgeColorTop := "DE0000"    ;;∙--------∙Red.
edgeColorBottom := "0000DE"    ;;∙--------∙Blue.
edgeColorLeft := "DEDE00"    ;;∙--------∙Yellow.
edgeColorRight := "00DE00"    ;;∙--------∙Green.
edgeWidth := "3"

guiFontWeight := "700"    ;;∙--------∙Font Weight.
guiFontColor := "00C8B9"    ;;∙--------∙Aqua.
guiFont := "Arial"    ;;∙--------∙Font.

;;∙------∙FontSize∙----------------------∙
RefFontSize := 16    ;;∙--------∙Defaults to calculate guiFontSize.
RefWidth := 500
RefHeight := 300
;;∙--------∙
WidthFactor := guiW / RefWidth
HeightFactor := guiH / RefHeight
if (guiW >= guiH) {
        guiFontSize := RefFontSize * (WidthFactor + HeightFactor / 2)
    } else {
        guiFontSize := RefFontSize * (HeightFactor * .1 + WidthFactor * 1.1)
    }

if (guiW <= 280) {
    guiFontSize := 10
}

if (guiFontSize > 60) {
    guiFontSize := 60
}
;;∙-----------------------------------------∙
textVCenter := guiH - guiFontSize    ;;∙--------∙Verticle text centering.


;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
Gui, +AlwaysOnTop -Caption
Gui, Color, %guiColor%
Gui, Font, s%guiFontSize% w%guiFontWeight% c%guiFontColor%, %guiFont%
Gui, Add, Text, x0 w%guiW% h%textVCenter% +0x0200 Center BackgroundTrans, Four Colored Border Walls

Gui, Add, Picture, % "x" 0 " y" 0 " w" guiW " h" edgeWidth " +0x4E +HWNDhPicture1"
    CreatePixel(edgeColorTop, hPicture1)    ;;∙------∙Top Side Border Edge.
Gui, Add, Picture, % "x" 0 " y" guiH-edgeWidth " w" guiW " h" edgeWidth " +0x4E +HWNDhPicture2"
    CreatePixel(edgeColorBottom, hPicture2)    ;;∙------∙Bottom Side Border Edge.
Gui, Add, Picture, % "x" 0 " y" 0 " w" edgeWidth " h" guiH " +0x4E +HWNDhPicture3"
    CreatePixel(edgeColorLeft, hPicture3)    ;;∙------∙Left Side Border Edge.
Gui, Add, Picture, % "x" guiW-edgeWidth " y" 0 " w" edgeWidth " h" guiH " +0x4E +HWNDhPicture4"
    CreatePixel(edgeColorRight, hPicture4)    ;;∙------∙Right Side Border Edge.

Gui, Show, % " x" guiX " y" guiY " w" guiW " h" guiH, Example


;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙CreatePixel() Function∙==================================∙
CreatePixel(Color, Handle) {
    VarSetCapacity(BMBITS, 4, 0), Numput("0x" . Color, &BMBITS, 0, "UInt")
    hBM := DllCall("Gdi32.dll\CreateBitmap", "Int", 1, "Int", 1, "UInt", 1, "UInt", 24, "Ptr", 0, "Ptr")
    hBM := DllCall("User32.dll\CopyImage", "Ptr", hBM, "UInt", 0, "Int", 0, "Int", 0, "UInt", 0x2008, "Ptr")
        DllCall("Gdi32.dll\SetBitmapBits", "Ptr", hBM, "UInt", 3, "Ptr", &BMBITS) 
        DllCall("User32.dll\SendMessage", "Ptr", Handle, "UInt", 0x172, "Ptr", 0, "Ptr", hBM)
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
Four∙Walls:    ;;∙------∙Change as needed to match the 'ScriptID' variable in AutoExe section.
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

