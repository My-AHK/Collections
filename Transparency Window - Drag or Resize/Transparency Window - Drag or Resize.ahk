



SetTimer, UpdateCheck, 500
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")
Menu, Tray, Icon, shell32.dll, 270
GoSub, TrayMenu
;;∙---------------------------------------------------------------------∙


;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙


;;∙======∙DIRECTIVES∙=============================∙
#Requires AutoHotkey 1
#NoEnv
#SingleInstance, Force
SetBatchLines -1
SetWorkingDir %A_ScriptDir%

;;∙======∙VARIABLES∙==============================∙
semiTransparentLevel := 180    ;;∙------∙Opacity level while dragging (0=invisible, 255=fully opaque).
holdDelay := 50    ;;∙------∙Milliseconds to hold before transparency kicks in (prevents flash on quick clicks).
isDragging := false    ;;∙------∙Tracks whether a drag operation is currently active.
win := ""    ;;∙------∙Stores the window ID (ahk_id) of the window being dragged.
enableResizeTransparency := true    ;;∙------∙true = move AND resize, false = move ONLY.

;;∙------∙Hit-test constants - identify which part of a window the cursor is over.
HTCAPTION := 2    ;;∙------∙Title bar (for moving the window).
HTLEFT := 10    ;;∙------∙Left border (for horizontal resize).
HTBOTTOMRIGHT := 17    ;;∙------∙Bottom-right corner (for diagonal resize).

/*∙------∙(Unused resize zones - kept for reference only)∙
HTBOTTOM := 15    ;;∙------∙Bottom border (for vertical resize).
HTBOTTOMLEFT := 16    ;;∙------∙Bottom-left corner (for diagonal resize).
HTSIZE := 4    ;;∙------∙General sizing border (fallback, rarely used).
HTRIGHT := 11    ;;∙------∙Right border (for horizontal resize).
HTTOP := 12    ;;∙------∙Top border (for vertical resize).
HTTOPLEFT := 13    ;;∙------∙Top-left corner (for diagonal resize).
HTTOPRIGHT := 14    ;;∙------∙Top-right corner (for diagonal resize).
∙--------------------------------------------------∙
*/


;;∙======∙ADMIN TOGGLE HOTKEY∙==================∙
;;∙------∙For use with Elevated apps such as Task Manager.
^!+F1::    ;;∙------∙🔥∙(Ctrl + Alt + Shift + F1)∙🔥∙(Toggle between elevated and non-elevated)
    if A_IsAdmin {
        Run, % "explorer.exe """ A_ScriptFullPath """"    ;;∙------∙Launch as Non-elevated.
        ExitApp
    } else {
        try {
            Run *RunAs "%A_ScriptFullPath%"    ;;∙------∙Launch as Elevated.
        } catch {
            return    ;;∙------∙User canceled UAC prompt, keep running normally.
        }
        ExitApp
    }
Return


;;∙======∙HOTKEY TRIGGER∙========================∙
~LButton::    ;;∙------∙🔥∙(Left mouse button)∙🔥∙
    SetTimer, CheckHold, -%holdDelay%
Return


;;∙======∙ROUTINE∙===============================∙
CheckHold:
    if GetKeyState("LButton", "P") {
        CoordMode, Mouse, Screen
        MouseGetPos, xPos, yPos, hwnd
        WinGetClass, class, ahk_id %hwnd%
        if (class != "Shell_TrayWnd") {
            result := DllCall("SendMessage", "Ptr", hwnd, "UInt", 0x84, "Ptr", 0, "Ptr", (yPos << 16) | xPos)
            ;;∙------∙Toggle between move-ONLY, or move AND resize transparency.
            if (enableResizeTransparency) {
                isDragArea := (result = HTCAPTION || (result >= HTLEFT && result <= HTBOTTOMRIGHT))
            } else {
                isDragArea := (result = HTCAPTION)
            }
            if (isDragArea) {
                isDragging := true
                win := "ahk_id " hwnd
                WinSet, Transparent, %semiTransparentLevel%, %win%
                while GetKeyState("LButton", "P")
                    Sleep, 10
                if (isDragging) {
                    WinSet, Transparent, 255, %win%
                    isDragging := false
                }
            }
        }
    }
Return
;;∙==============================================∙




;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙

;;∙======∙SCRIPT EDIT / RELOAD / EXIT∙==============∙
;;∙------∙EDIT∙---------------------------∙
Script·Edit:    ;;∙------∙Menu Call.
    Edit
Return

;;∙------∙RELOAD∙-----------------------∙
^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        ;;∙------∙Soundbeep, 1000, 200
    Reload
Return

;;∙------∙EXIT∙----------------------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        ;;∙------∙Soundbeep, 1000, 200
    ExitApp
Return


;;∙======∙SCRIPT UPDATE∙=========================∙
UpdateCheck:    ;;∙------Check if script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload


;;∙======∙TRAY MENU∙=============================∙
TrayMenu:
Menu, Tray, Tip, %ScriptID%
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add

;;∙------∙MENU-EXTENTIONS∙---------∙
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

;;∙------∙MENU-OPTIONS∙-------------∙
Menu, Tray, Add
Menu, Tray, Add, Script Edit, Script·Edit
Menu, Tray, Icon, Script Edit, imageres.dll, 247
Menu, Tray, Add
Menu, Tray, Add, Script Reload, Script·Reload
Menu, Tray, Icon, Script Reload, mmcndmgr.dll, 47
Menu, Tray, Add
Menu, Tray, Add, Script Exit, Script·Exit
Menu, Tray, Icon, Script Exit, shell32.dll, 272
Menu, Tray, Default, Script Exit
Menu, Tray, Add
Menu, Tray, Add
Return

;;∙------∙EXTENTIONS∙------------------∙
Documentation:
    Run, "C:\Program Files\AutoHotkey\AutoHotkey.chm"
Return
ShowKeyHistory:
    KeyHistory
Return
ShowWindowSpy:
    Run, "C:\Program Files\AutoHotkey\WindowSpy.ahk"
Return

;;∙======∙TRAY MENU POSITION∙====================∙
;;∙------∙TRAY MENU SHOW∙--------∙
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20
Return

;;∙------∙POSITION FUNTION∙-------∙
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

;;***********************************************
;;****************** SCRIPT END ******************
;;***********************************************

