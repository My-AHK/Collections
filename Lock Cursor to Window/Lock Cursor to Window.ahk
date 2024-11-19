
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
» Author:  Rijul Ahuja
» Source 1:  https://www.autohotkey.com/board/topic/61753-confining-mouse-to-a-window/page-2
» Source 2:  https://www.autohotkey.com/boards/viewtopic.php?f=6&t=88469&p=389554&hilit=contain+mouse+cursor#p445645
» Confine Mouse Cursor Within Active Window.
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "Lock_Mouse_Cursor"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙




;;∙============================================================∙
; isConfined := true    ;;∙------∙Start with mouse cursor Confined by default.
 isConfined := false    ;;∙------∙Start with mouse cursor Un-confined by default.

SetTimer, Watch, 250    ;;∙------∙Set a timer to check cursor confinement every 250 milliseconds.
    OnExit, Exit    ;;∙------∙Define an exit routine to ensure proper cleanup on exit.
Return

^t::    ;;∙------∙🔥 HotKey Toggle🔥∙------∙(Ctrl + T)∙------∙

;;∙------------------------∙
isConfined := !isConfined    ;;∙------∙Toggle the confinement state of the mouse cursor.
if (isConfined)    ;;∙------∙If cursor is to be confined...
    {
        ClipMouse()    ;;∙------∙Confine the cursor to the active window if toggled on.
       Soundbeep, 1100, 100   ;;∙------∙Play indicator sound cursor is now Confined.
    }
    else
    {
        ClipMouse(false)    ;;∙------∙Release the cursor if toggled off.
       Soundbeep, 1000, 100    ;;∙------∙Play indicator sound cursor is now Un-confined.
    }
Return
;;∙------------------------∙
Exit:
    ClipMouse(false)    ;;∙------∙Ensure the cursor is released upon exiting the script.
ExitApp    ;;∙------∙Terminate the script.
;;∙------------------------∙
ClipMouse(Param=true)    ;;∙------∙Function to confine or release the mouse cursor.
    {
        If (Param)    ;;∙------∙If confinement is requested...
    {
        WinGetPos, XPos, YPos, Width, Height, A    ;;∙------∙Get the position and size of the active window.
        ClipCursor(True, XPos, YPos, XPos+Width, YPos+Height)    ;;∙------∙Constrain the cursor within the active window's bounds.
    }
    else
        ClipCursor(false)    ;;∙------∙Release the cursor if confinement is not requested.
    }
Return
;;∙------------------------∙
Watch:    ;;∙------∙Function to monitor and manage cursor confinement.
    If (isConfined && !GetKeyState("LButton", "P"))    ;;∙------∙Only re-confine if the toggle is on and LButton isn't pressed.
        ClipMouse()    ;;∙------∙Reapply cursor confinement to the active window.
Return
;;∙------------------------∙
ClipCursor(Confines := True, Left := 0, Top := 0, Right := 1, Bottom := 1) {    ;;∙------∙Function to set cursor confinement boundaries.
    if !(Confines)    ;;∙------∙If confinement is not requested...
        return DllCall("user32.dll\ClipCursor", "Int", 0)    ;;∙------∙Release the cursor entirely.
    static RECT, init := VarSetCapacity(RECT, 16, 0)    ;;∙------∙Define a static RECT structure for cursor confinement.
    NumPut(Left, RECT, 0, "Int"), NumPut(Top, RECT, 4, "Int"), NumPut(Right, RECT, 8, "Int"), NumPut(Bottom, RECT, 12, "Int")    ;;∙------∙Set the boundaries for cursor confinement.
    if !(DllCall("user32.dll\ClipCursor", "Ptr", &RECT))    ;;∙------∙Attempt to confine the cursor.
        return DllCall("kernel32.dll\GetLastError")    ;;∙------∙Return an error code if the call fails.
    return 1    ;;∙------∙Return success status.
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
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.
SetBatchLines -1
SetTimer, UpdateCheck, 500
SetTitleMatchMode 2
SetWinDelay 0
Menu, Tray, Icon, ddores.dll, 109
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
Lock_Mouse_Cursor:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

