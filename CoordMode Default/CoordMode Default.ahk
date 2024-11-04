
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
» Author:  boiler
» Source:  https://www.autohotkey.com/boards/viewtopic.php?f=76&t=129654#p570911
» Return to what previous CoordMode was without knowing what it was.
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TEMPLATE"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙🔥 HotKey 🔥∙===========================================∙
; ^t::    ;;∙------∙(Ctrl+T) 
;    Soundbeep, 1100, 100
;;∙============================================================∙




PrevCoordModeMouse := A_CoordModeMouse
CoordMode, Mouse ,Screen
MouseGetPos, MX, MY
;;∙------* SOME CODE *------∙
CoordMode, Mouse, % PrevCoordModeMouse




/*∙===========================================================∙
∙--------------∙WHAT SCRIPT DOES∙--------------∙(per ChatGPT)
• Temporarily changes the coordinate mode for mouse-related commands, allowing the mouse position to be tracked relative to the screen rather than the active window or another reference point.
• It retrieves the current mouse position, stores it in variables, and then restores the previous coordinate mode after executing some intervening code. 
• This approach is useful when you need to interact with the screen's absolute coordinates without permanently altering the script's overall mouse handling behavior.

∙--------------∙POTENTIAL USAGE∙--------------∙
• Coordinate Consistency: This script would be useful when you need to temporarily switch to screen coordinates for mouse operations while ensuring that the original coordinate mode is restored afterward. This is particularly important if other parts of the script or other running scripts rely on a different coordinate system (like client coordinates for a specific application window).

• Multi-Monitor Setups: In a multi-monitor setup, different screens may have different coordinate systems. This script ensures that mouse operations are calculated based on the entire screen layout while maintaining a clean state afterward.

• Mouse Automation Tasks: If you're performing automation tasks that require precise mouse movements based on screen position (like clicking buttons or dragging items on the screen), this script provides a reliable way to handle the mouse positioning without permanently changing the coordinate system.

• Preventing Side Effects: By storing and restoring the coordinate mode, the script prevents potential issues or bugs that could arise from accidentally altering the mouse coordinate system for other parts of the application.


∙--------------∙POTENTIAL ISSUES∙--------------∙
• Performance Overhead:
        Changing coordinate modes and retrieving mouse positions can 
        introduce slight performance overhead, especially if done repeatedly 
        in a tight loop. However, for most applications, this overhead is 
        minimal and often negligible.

• Complexity and Readability:
        Adding code to manage coordinate modes increases script complexity. 
        For someone reading the script later (or even yourself after some time), 
        it may take a moment to understand why the coordinate mode is being 
        changed and restored. Clear comments would help mitigate this.

• Potential for Errors:
        If there is an error or unexpected exit in the code between setting the 
        coordinate mode and restoring it, the original mode might not be 
        restored. This could lead to inconsistent behavior in subsequent mouse 
        operations. Proper error handling can help mitigate this risk.

• Limited Context Awareness:
        If other parts of your script or other scripts interact with the mouse 
        coordinates without knowing the current mode, it could lead to 
        confusion or unintended interactions. The script assumes that the 
        temporary change won't affect other processes, 
        which may not always be the case.

• Dependence on A_CoordModeMouse:
        This script relies on the value of A_CoordModeMouse, which may not 
        always be reliable if other scripts alter it without your knowledge. 
        If there are multiple scripts running, each could potentially change 
        the coordinate mode, leading to unpredictable behavior.

• Use Cases:
        If the operations performed in ...SOME CODE... don’t require screen 
        coordinates, it may be unnecessary to change the coordinate mode at all. 
        This adds complexity without benefiting the script's functionality.

• * To mitigate these issues, ensure that script is well-structured 
        and documented, handles errors appropriately, and only change 
        coordinate mode when absolutely necessary. *
*/
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

