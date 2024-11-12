
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
» Author:  william_ahk
» Source:  https://www.autohotkey.com/boards/viewtopic.php?f=6&t=121748&hilit=GUI#p540498
» 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "Gui_Glue"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙🔥 HotKey 🔥∙===========================================∙
; ^t::    ;;∙------∙(Ctrl+T) 
;    Soundbeep, 1100, 100
;;∙============================================================∙




;;∙============================================================∙
#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
SetWinDelay 0
SetBatchLines -1

;;∙------∙Create Main Top Gui.
Gui, +AlwaysOnTop -Caption +HwndhMain +LastFound
        +E0x02000000 +E0x00080000    ;;∙------∙Gui flicker double-buffer.
Gui, Color, AQUA
  OnMessage(0x03, "WM_MOVE")
  OnMessage(0x0112, "WM_SYSCOMMAND")
Gui, Add, Text, x10 y10, Top Gui
Gui, Show, w250 h175, Main

;;∙------∙Create Secondary Bottom Gui, centered relative to Top Main Gui.
WinGetPos, X, Y, W, H, % "ahk_id" hMain
bottomW := W + 10    ;;∙------∙Width of Bottom Gui.
bottomH := H + 10    ;;∙------∙Height of Bottom Gui.
newX := X + (W - bottomW) / 2
newY := Y + (H - bottomH) / 2

Gui, Secondary:New, +HwndhSecondary, Secondary
Gui, +Owner%hMain% -Caption
Gui, Color, TEAL
Gui, Add, Text, x10 y10, Bottom Gui
Gui, Show, % "x" newX " y" newY " w" bottomW " h" bottomH " NoActivate"
    WinSet, Transparent, 128, % "ahk_id " hSecondary    ;;∙------∙Make seconday Gui 50% transparent.
Return

GuiClose:
    ExitApp
Return

;;∙------------------------∙
WM_SYSCOMMAND(wParam, lParam, msg, hwnd) {
    Global hMain, hSecondary
    ,      main_last_x, main_last_y
    Static SC_MOVE := 0xF010
    SC := wParam & 0xFFF0
    Switch hwnd
    {
        case hMain:
            if (SC = SC_MOVE) {
                WinGetPos, main_last_x, main_last_y, , , % "ahk_id" hMain
            }
    }
}
WM_MOVE(wParam, lParam, msg, hwnd) {
    Global hMain, hSecondary
    ,      main_last_x, main_last_y
    Static last_move_time := 0
    Switch hwnd
    {
        case hMain:
            if WinExist("ahk_id" hSecondary) {
                current_time := A_TickCount
                ;;∙------∙Update position only if 10ms have passed since the last update.
                if (current_time - last_move_time > 10) {
                    WinGetPos, main_x, main_y,,, % "ahk_id" hMain
                    WinGetPos, Secondary_x, Secondary_y,,, % "ahk_id" hSecondary
                    new_x := main_x - main_last_x + Secondary_x
                    new_y := main_y - main_last_y + Secondary_y
                    WinMove, % "ahk_id" hSecondary, , % new_x, % new_y
                    main_last_x := main_x
                    main_last_y := main_y
                    last_move_time := current_time
                }
            }
    }
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
Gui_Glue:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

