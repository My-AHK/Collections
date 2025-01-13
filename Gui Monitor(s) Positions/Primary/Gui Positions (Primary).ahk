
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  Learning one
» Original Source:  https://www.autohotkey.com/board/topic/72630-gui-bottom-right/#entry461385
» Updated Source:  https://www.autohotkey.com/boards/viewtopic.php?style=17&t=117207#p522539
» 2 Options:
    ▹ Alphanumeric Number Keys
    ▹ Numpad Keys
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TEMPLATE"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
/*∙========∙GUI FUNCTION POSITIONS∙===================∙
∙-----∙Positioning based on (x,y) cartesian coordinates for maintainability and clarity.
∙--------∙(L, HC, R / U, VC, D)
∙---------------------------------------------------------------∙
∙-----∙(Horizontal)∙-----∙
      Left ............................ L
   Horizontal-Center ...... HC
Right .......................... R
∙-----∙(Vertical)∙---------∙
Up ............................. U
   Vertical-Center .......... VC
Down ........................ D  (~or~ Bottom ....... B)
∙---------------------------------------------------------------∙
∙==========∙EXAMPLE HOTKEY OPTIONS∙==================∙
∙-----------------∙Alphanumeric Numbers∙--------------∙
_______________________________
  | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
∙-----∙or∙--------∙Numpad Numbers∙---------------------∙
   _____________
     | 7 | 8 | 9 |
     | 4 | 5 | 6 |
     | 1 | 2 | 3 |
   ‾‾‾‾‾‾‾‾‾‾‾‾‾
∙---------------------------------------------------------------∙
∙=====================================================∙
*/
;;∙-------------------------------------------------------------∙
guiW := 200 , guiH := 150

Gui, +AlwaysOnTop -Caption +Border +LastFound +Owner 
    hwnd := WinExist()
Gui, Color, Red
Gui, Font, s17 w600 cYellow
Gui, Add, Text, x30 y10 Center BackgroundTrans, Basic Gui`nFor Testing
Gui, Font, s10 w400 cBlack
Gui, Add, Text, xp y+5 Center BackgroundTrans, Press Ctrl +`n'Alphanumeric' or`n'Numpad' Keys to`ncycle through options
;;∙------------------------∙
Gui, Show, w%guiW% h%guiH% HIDE
    WinMove(hwnd,"D HC")    ;;∙------∙(Down, Horizontal-Center)
Gui, Show, 	
Return
;;∙-------------------------------------------------------------∙

;;∙-------------------------------------------------------------∙
^1::    ;;∙------∙🔥∙(Ctrl+1) or (Ctrl+Numpad1)
^Numpad1::
    WinMove(hwnd,"D L") 	;;∙------∙(Down, Left)
Return
;;∙------------------∙
^2::    ;;∙------∙🔥∙(Ctrl+2) or (Ctrl+Numpad2)
^Numpad2::
    WinMove(hwnd,"D HC") 	;;∙------∙(Down, Horizontal-Center)
Return
;;∙------------------∙
^3::    ;;∙------∙🔥∙(Ctrl+3) or (Ctrl+Numpad9)
^Numpad3::
    WinMove(hwnd,"D R") 	;;∙------∙(Down, Right)
Return
;;∙------------------∙
^4::    ;;∙------∙🔥∙(Ctrl+4) or (Ctrl+Numpad4)
^Numpad4::
    WinMove(hwnd,"VC L") 	;;∙------∙(Vertical-Center, Left)
Return
;;∙------------------∙
^5::    ;;∙------∙🔥∙(Ctrl+5) or (Ctrl+Numpad5)
^Numpad5::
    WinMove(hwnd,"VC HC") 	;;∙------∙(Vertical-Center, Horizontal-Center)
Return
;;∙------------------∙
^6::    ;;∙------∙🔥∙(Ctrl+6) or (Ctrl+Numpad6)
^Numpad6::
    WinMove(hwnd,"VC r") 	;;∙------∙(Vertical-Center, Right)
Return
;;∙------------------∙
^7::    ;;∙------∙🔥∙(Ctrl+7) or (Ctrl+Numpad7)
^Numpad7::
    WinMove(hwnd,"U L") 	;;∙------∙(Up, Left)
Return
;;∙------------------∙
^8::    ;;∙------∙🔥∙(Ctrl+8) or (Ctrl+Numpad8)
^Numpad8::
    WinMove(hwnd,"U HC") 	;;∙------∙(Up, Horizontal-Center)
Return
;;∙------------------∙
^9::    ;;∙------∙🔥∙(Ctrl+9) or (Ctrl+Numpad9)
^Numpad9::
    WinMove(hwnd,"U R") 	;;∙------∙(Up, Right)
Return
;;∙-------------------------------------------------------------∙


;;∙======∙Position Function∙================================∙
;;∙-------------------------------------------------------------∙
WinMove(hwnd,position) {
    SysGet, Mon, MonitorWorkArea
    oldDHW := A_DetectHiddenWindows
    DetectHiddenWindows, On
    WinGetPos,ix,iy,w,h, ahk_id %hwnd%
        StringReplace,position,position,b,d,all
    1x := InStr(position,"l") ? MonLeft : InStr(position,"hc") ?  ((MonRight-w)/2): InStr(position,"r") ? MonRight - w : ix
    1y := InStr(position,"u") ? MonTop : InStr(position,"vc") ?  (MonBottom-h)/2 : InStr(position,"d") ? MonBottom - h : iy
    WinMove, ahk_id %hwnd%,, 1x, 1y
    DetectHiddenWindows, %oldDHW%
    }
Return
;;∙-------------------------------------------------------------∙
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

