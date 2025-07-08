
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  heresy
» Original Source:  https://www.autohotkey.com/board/topic/29860-this-get-script-self-informations/
» 
    ▹ 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "ActiveWindowStats"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
;;∙============================================================∙
/*   ∙---------------------------------------------------------------------------∙
        * Returns information about the currently active window. *
       ∙---------------------------------------------------------------------------∙
• ThisWindow() or ThisWindow("ID") or ThisWindow(1)
      »  Returns Unique ID (hwnd), with "ahk_id" prefix.
 
• ThisWindow("Title") or ThisWindow(2)
      »  Returns the window's title.
 
• ThisWindow("Class") or ThisWindow(3)
      »  Returns the window's class, with "ahk_class" prefix.
 
• ThisWindow("PID") or ThisWindow(4)
      »  Returns the window's Process ID (PID), with "ahk_pid" prefix.
 
• ThisWindow("ProcessName") or ThisWindow(5)
      »  Returns the executable name of the process (e.g., "notepad.exe").
 
• ThisWindow("X"), ThisWindow("Y"), ThisWindow("W"), ThisWindow("H")
      »  Returns window geometry:
            ▹ X = Left position
            ▹ Y = Top position
            ▹ W = Width
            ▹ H = Height
 
  Notes:
  ▹ Prefixes like "ahk_id", "ahk_class", and "ahk_pid" are returned as part of the string.
  ▹ Defaults to returning "ahk_id" if no argument is passed.
  ▹ DetectHiddenWindows is temporarily set to "On" during the call.
  ▹ Invalid or unknown parameters return 1.
   ∙---------------------------------------------------------------------------∙
*/

;;∙============================================================∙
^t::    ;;∙------∙🔥∙(Ctrl + T).......THE 23 EXAMPLES+.
    SoundBeep, 1200, 200

;;∙---------∙EXAMPLE 1∙----------------------------------------------------------∙
    Clipboard := "Current window ahk_id is: " . ThisWindow("ID")
    MsgBox, , Window Info, % Clipboard, 3

;;∙---------∙EXAMPLE 2∙----------------------------------------------------------∙
    Clipboard := "Current window title is: " . ThisWindow("Title")
    MsgBox, , Window Info, % Clipboard, 3

;;∙---------∙EXAMPLE 3∙----------------------------------------------------------∙
    Clipboard := "Current window class is: " . ThisWindow("Class")
    MsgBox, , Window Info, % Clipboard, 3

;;∙---------∙EXAMPLE 4∙----------------------------------------------------------∙
    Clipboard := "Window position and size: " . ThisWindow("X") . "," . ThisWindow("Y") . " - " . ThisWindow("W") . "x" . ThisWindow("H")
    MsgBox, , Window Info, % Clipboard, 3

;;∙---------∙EXAMPLE 5∙----------------------------------------------------------∙
    Clipboard := "Current window PID is: " . ThisWindow("PID")
    MsgBox, , Window Info, % Clipboard, 3

;;∙---------∙EXAMPLE 6∙----------------------------------------------------------∙
    Clipboard := "Current window process name is: " . ThisWindow("ProcessName")
    MsgBox, , Window Info, % Clipboard, 3

;;∙---------∙EXAMPLE 7∙----------------------------------------------------------∙
    Clipboard := "Current window width is: " . ThisWindow("W")
    MsgBox, , Window Info, % Clipboard, 3

;;∙---------∙EXAMPLE 8∙----------------------------------------------------------∙
    Clipboard := "Current window height is: " . ThisWindow("H")
    MsgBox, , Window Info, % Clipboard, 3

;;∙---------∙EXAMPLE 9∙----------------------------------------------------------∙
    Clipboard := "Current window top-left corner is: (" . ThisWindow("X") . "," . ThisWindow("Y") . ")"
    MsgBox, , Window Info, % Clipboard, 3

;;∙---------∙EXAMPLE 10∙--------------------------------------------------------∙
    Clipboard := "Current window ahk_class and title: " . ThisWindow("Class") . " - " . ThisWindow("Title")
    MsgBox, , Window Info, % Clipboard, 3

;;∙---------∙EXAMPLE 11∙--------------------------------------------------------∙
    Clipboard := "Window geometry: X=" . ThisWindow("X") . ", Y=" . ThisWindow("Y") . ", W=" . ThisWindow("W") . ", H=" . ThisWindow("H")
    MsgBox, , Window Info, % Clipboard, 3

;;∙---------∙EXAMPLE 12∙--------------------------------------------------------∙
    Clipboard := "Window ID and Process Name: " . ThisWindow("ID") . " | " . ThisWindow("ProcessName")
    MsgBox, , Window Info, % Clipboard, 3

;;∙---------∙EXAMPLE 13∙--------------------------------------------------------∙
    Clipboard := "Window Title Length: " . StrLen(ThisWindow("Title"))
    MsgBox, , Window Info, % Clipboard, 3

;;∙---------∙EXAMPLE 14∙--------------------------------------------------------∙
    Clipboard := "Window is located at X=" . ThisWindow("X") . " and Y=" . ThisWindow("Y")
    MsgBox, , Window Info, % Clipboard, 3

;;∙---------∙EXAMPLE 15∙--------------------------------------------------------∙
    Clipboard := "Window " . ThisWindow("Title") . " belongs to PID " . ThisWindow("PID")
    MsgBox, , Window Info, % Clipboard, 3

;;∙---------∙EXAMPLE 16∙--------------------------------------------------------∙
    Clipboard := "Window Class: " . ThisWindow("Class") . " | Process: " . ThisWindow("ProcessName")
    MsgBox, , Window Info, % Clipboard, 3

;;∙---------∙EXAMPLE 17∙--------------------------------------------------------∙
    Clipboard := "Window area: " . (ThisWindow("W") * ThisWindow("H")) . " pixels squared"
    MsgBox, , Window Info, % Clipboard, 3

;;∙---------∙EXAMPLE 18∙--------------------------------------------------------∙
    Clipboard := "Window position and size in one string: " . ThisWindow("X") . "," . ThisWindow("Y") . "," . ThisWindow("W") . "," . ThisWindow("H")
    MsgBox, , Window Info, % Clipboard, 3

;;∙---------∙EXAMPLE 19∙--------------------------------------------------------∙
    Clipboard := "Current window ahk_id in decimal: " . ThisWindow("ID")
    MsgBox, , Window Info, % Clipboard, 3

;;∙---------∙EXAMPLE 20∙--------------------------------------------------------∙
    Clipboard := "Window is active: " . (WinActive("ahk_id " . ThisWindow("ID")) ? "Yes" : "No")
    MsgBox, , Window Info, % Clipboard, 3

;;∙---------∙EXAMPLE 21∙--------------------------------------------------------∙
    WinGet, MinMax, MinMax, "ahk_id " . ThisWindow("ID")
    Clipboard := "Window is minimized: " . (MinMax = -1 ? "Yes" : "No")
    MsgBox, , Window Info, % Clipboard, 3

;;∙---------∙EXAMPLE 22∙--------------------------------------------------------∙
    transparency := GetWindowTransparency(ThisWindow("ID"))
    Clipboard := "Window transparency (alpha): " . transparency
    MsgBox, , Window Info, % Clipboard, 3

;;∙---------∙EXAMPLE 23∙------------------------------------------------------∙
    Clipboard := "Is window always on top: " . (DllCall("GetWindowLong", "Ptr", ThisWindow("ID"), "Int", -20) & 0x8 ? "Yes" : "No")
    MsgBox, , Window Info, % Clipboard, 3
∙-------------------------------------------------------------------------------------∙
;;∙---------∙ALL EXAMPLES∙------------------------------------------------------∙
    title      := ThisWindow("Title")
    class      := ThisWindow("Class")
    id         := ThisWindow("ID")
    pid        := ThisWindow("PID")
    process    := ThisWindow("ProcessName")
    x          := ThisWindow("X")
    y          := ThisWindow("Y")
    w          := ThisWindow("W")
    h          := ThisWindow("H")
    area       := w * h
    active     := WinActive("ahk_id " . id) ? "Yes" : "No"
    WinGet, MinMax, MinMax, ahk_id %id%
    minimized  := (MinMax = -1 ? "Yes" : "No")
    transparency := GetWindowTransparency(id)
    ontop      := (DllCall("GetWindowLong", "Ptr", id, "Int", -20) & 0x8 ? "Yes" : "No")
    titleLen   := StrLen(title)

    Report =
    ( LTrim
    * WINDOW INSPECTION REPORT *

    • Title.............. %title%
    • Class............. %class%
    • ahk_id.......... %id%
    • PID................ %pid%
    • Process......... %process%

    ── GEOMETRY ───────────────
    • Position......... X=%x%, Y=%y%
    • Size................ Width=%w%, Height=%h%
    • Area............... %area% pixels²
    • Combined..... %x%,%y%,%w%,%h%

    ── STATUS ─────────────────
    • Active.................. %active%
    • Minimized........... %minimized%
    • Transparency...... %transparency%
    • Always on Top.... %ontop%

    ── DETAILS ────────────────
    • Title Length........ %titleLen%
    • ID + Process....... %id% | %process%
    • Class + Title........ %class% - %title%
    )

    MsgBox, 64, Full Window Info, %Report%, 20
Return



;;∙============∙FUNCTIONS∙========================∙
GetWindowTransparency(hwnd) {
    VarSetCapacity(exStyle, 4, 0)
    exStyle := DllCall("GetWindowLong", "Ptr", hwnd, "Int", -20, "UInt")
    if !(exStyle & 0x80000)  ; WS_EX_LAYERED
        return 255  ; No layered style = fully opaque
    alpha := 0
    if !DllCall("GetLayeredWindowAttributes"
        , "Ptr", hwnd
        , "UInt*", 0
        , "UChar*", alpha
        , "UInt*", 0)
        return 255
    return alpha
}

;;∙---------------------------------------∙
ThisWindow(Return="ID")
{
    HW := A_DetectHiddenWindows
    DetectHiddenWindows, On

    ID := WinActive("A")

    If Return in ID,HWND,1
        Var := "ahk_id " . ID
    Else If Return in Title,2
    {
        WinGetTitle, WinTitle, ahk_id %ID%
        Var := WinTitle
    }
    Else If Return in Class,3
    {
        WinGetClass, Class, ahk_id %ID%
        Var := "ahk_class " . Class
    }
    Else If Return in PID,4
        Var := "ahk_pid " . ID
    Else If Return in ProcessName,5
    {
        WinGet, ProcessName, ProcessName, ahk_id %ID%
        Var := ProcessName
    }
    Else If Return in X,Y,W,H
    {
        WinGetPos, X, Y, W, H, ahk_id %ID%
        Var := (Return = "X") ? X : (Return = "Y") ? Y : (Return = "W") ? W : H
    }
    Else
        Var := 1

    DetectHiddenWindows, %HW%
    Return, Var
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
ActiveWindowStats:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

