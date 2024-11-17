
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
» Author:  just me
» Original Source:  https://www.autohotkey.com/board/topic/90723-achieve-rainmeter-style-gui-via-gdip-library/?p=573445
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
; ^t::    ;;∙------∙(Ctrl+T) 
;     Soundbeep, 1100, 100
;;∙============================================================∙




;;∙============================================================∙
Gui, Destroy   ;;∙------∙Destroys any existing GUI window to start fresh.
 
guiX := "1550"
guiY := "450"
guiW := "210"
guiH := "250"

guiTrans := "170"    ;;∙------∙Transparency level.
guiColor := "00006F"    ;;∙------∙Dark Blue.
guiHeaderColor := "FFFFFF"    ;;∙------∙White.
guiHeadTextColor := "DE0000"    ;;∙------∙Red.
textColor := "DEDE00"    ;;∙------∙Yellow.

Gui, +LastFound -Caption
WinSet, Transparent, %guiTrans%    ;;∙------∙Set window transparency.
Gui, Color, %guiColor%
Gui, Margin, 0, 0    ;;∙------∙Removes margins from inside GUI.
Gui, Font, s14 c%textColor% Bold, Calibri
    Gui, Add, Progress, x-1 y-1 w%guiW%+2 h31 Background%guiHeaderColor% Disabled hwndHPROG    ;;∙------∙Add progress bar to simulate colored header background.
    ;;∙------------∙Control, ExStyle, -0x20000, , ahk_id %HPROG%
    ;;∙------------∙(Optional) Removes a window style flag, useful in older Windows versions like XP.
Gui, Add, Text, x0 y0 w%guiW% h30 c%guiHeadTextColor% BackgroundTrans Center 0x200 gGuiMove vCaption, Header Example

/*∙-----------------------------------------------------------------------------------------∙
;;∙---∙SS_ENDELLIPSIS := 0x4000 (Appends an ellipsis to text that is too long)
;;∙---∙x7 := Sets the control's X position 7 pixels from the left.
;;∙---∙y+10 := Sets the control's Y position 10 pixels below the last added control.
;;∙---∙w%guiW%-14 := Sets the control's width to the GUI width minus 14 pixels.
;;∙---∙r1 := The control has 1 row of text, ensuring it takes up one line in height.
;;∙---∙+0x4000 := The SS_ENDELLIPSIS style, which appends an ellipsis(...) to text that is too long to fit within the control.
;;∙---∙vTX := Creates a variable name (vTX#) for the control to reference or manipulate later.
  ∙------------------------------------------------------------------------------------------∙
*/

Gui, Font, s10, Segoe UI
Gui, Add, Text, x7 y+10 w%guiW%-14 r1 +0x4000 vTX1 gBluegill, Lepomis macrochirus    ;;∙------∙Clickable text control for "Bluegill Sunfish".
Gui, Add, Text, x7 y+10 w%guiW%-14 r1 +0x4000 vTX2 gPumpkinseed, Lepomis gibbosus    ;;∙------∙Clickable text control for "Pumpkinseed Sunfish".
Gui, Add, Text, x7 y+10 w%guiW%-14 r1 +0x4000 vTX3 gGreen, Lepomis cyanellus    ;;∙------∙Clickable text control for "Green Sunfish".
Gui, Add, Text, x7 y+10 w%guiW%-14 r1 +0x4000 vTX4 gWarmouth, Lepomis gulosus    ;;∙------∙Clickable text control for "Warmouth Sunfish".
Gui, Add, Text, x7 y+10 cLime w%guiW%-14 r1 +0x4000 vTX5 gReload, `tReload    ;;∙------∙Clickable text control for to Reload script.
Gui, Add, Text, x7 y+10 w%guiW%-14 h5 vP    ;;∙------∙Adds a small blank text control as a separator between items.

GuiControlGet, P, Pos    ;;∙------∙Retrieves position of last text control added (vP).
H := PY + PH    ;;∙------∙Calculate total Gui height.
WinSet, Region, 0-0 w%guiW% h%H% r9-9    ;;∙------∙Rounds corners of GUI with a 9-pixel radius.
Gui, Show, w%guiW% h%guiH% x%guiX% y%guiY%
WinSet AlwaysOnTop
Return

;;∙---------------------------------------------∙
GuiMove:    ;;∙------∙Allows GUI to be dragged by header.
    PostMessage, 0xA1, 2
Return
;;∙--------------∙
Bluegill:
    MsgBox,,, You selected the Bluegill Sunfish., 3
Return
;;∙--------------∙
Pumpkinseed:
    MsgBox,,, You selected the Pumpkinseed Sunfish., 3
return
;;∙--------------∙
Green:
    MsgBox,,, You selected the Green Sunfish., 3
return
;;∙--------------∙
Warmouth:
    MsgBox,,, You selected the Warmouth Sunfish., 3
Return
;;∙--------------∙
Reload:
    Reload
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

