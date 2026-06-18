
;;∙---------------------------------------------------------------------∙

SetTimer, UpdateCheck, 500
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")
GoSub, TrayMenu

;;∙---------------------------------------------------------------------∙


;;∙---------------------------------------------------------------------∙
;;∙==============================================∙

/*∙------------------------------∙
ToastTip - (A position-aware timed ToolTip display function)
∙ - - - - - - - - - - - - - - - - - - - ∙
A customizable timed tooltip function that can display messages in three modes: 
(F1) - fixed screen coordinates
(F2) - at current cursor position
(F3) - following the cursor until a timeout expires
The function supports 20 tooltip slots, configurable display duration, and a simple, single-line function call with sensible defaults, with most parameters being optional for quick use.
∙--------------------------------∙
*/

;;∙======∙DIRECTIVES & SETTINGS∙==================∙
#Requires AutoHotkey 1
#NoEnv
#SingleInstance, Force
Menu, Tray, Icon, shell32.dll, 44
SetWorkingDir %A_ScriptDir%

;;∙======∙HOTKEY EXAMPLES∙=======================∙
F1::    ;;∙------∙🔥∙Fixed Coords (fixed screen location).
    SoundBeep 1000, 150
    ToastTip("Hello`nHave a nice day.", 2000, 1700, 800, 1)
Return

F2::    ;;∙------∙🔥∙Trigger Position (spawn at current cursor location).
    SoundBeep 1100, 100
    ToastTip("Hello`nHave a nice day.", 2000, , , 1)
Return

F3::    ;;∙------∙🔥∙Follow Cursor (follow cursor until timeout expires).
    SoundBeep 1200, 100
    ToastTip("Hello`nHave a nice day.", 4000, , , 1, 1)
Return


;;∙======∙TIMED TOOL TIP FUNCTION∙===============∙
/*∙------------------------------∙
ToastTip(Msg, Time := 2000, X := "", Y := "", TipID := 1, Trail := 0) ← Default Call.

∙------∙6 parameters∙-------∙
Msg   = Tooltip text
Time  = Display duration (ms)
X, Y  = Absolute screen coordinates (CoordMode, ToolTip, Screen)
TipID = Tooltip slot 1-20
Trail = Follow cursor (0=Static / 1=Follow)
∙--------------------------------∙
*/

ToastTip(Msg, Time := 2000, X := "", Y := "", TipID := 1, Trail := 0) {

    ;;∙------∙Use screen coordinates for both ToolTips & Mouse position.
    CoordMode, ToolTip, Screen
    CoordMode, Mouse, Screen

        if (Trail = 1) {

        ;;∙------∙Dynamic Follow Mode.
        ;;∙------∙Bound timer function that continuously updates ToolTip position while timer is active.
        timerFunc := Func("FollowTip").Bind(Msg, TipID, Time)
        SetTimer, % timerFunc, 10

    } else {

        ;;∙------∙Static Mode.
        ;;∙------∙If explicit coordinates were supplied, display there.
        if (X != "" && Y != "") {
            ToolTip, % Msg, % X, % Y, % TipID

        } else {

            ;;∙------∙Otherwise show at current mouse position.
            MouseGetPos, mX, mY
            ToolTip, % Msg, % mX, % mY, % TipID
        }

        ;;∙------∙One-shot timer to remove ToolTip.
        timerFunc := Func("EndTip").Bind(TipID)
        SetTimer, % timerFunc, % -Time
    }
}

FollowTip(Msg, TipID, Time) {

    ;;∙------∙Retains values between timer calls.
    static startTime := A_TickCount
    static init := false

    ;;∙------∙Initialize timer start time.
    if (!init) {
        startTime := A_TickCount
        init := true
    }

    ;;∙------∙Close ToolTip after requested duration expires.
    if ((A_TickCount - startTime) > Time) {
        ToolTip, , , , % TipID

        ;;∙------∙Stop currently running timer.
        SetTimer, , Off

        ;;∙------∙Reset initialization state for next call.
        init := false
        return
    }

    ;;∙------∙Track current mouse position.
    MouseGetPos, mX, mY
    ;;∙------∙Display ToolTip above & left of cursor.
    ToolTip, % Msg, % mX - 35, % mY - 35, % TipID    ;;∙------∙* Offsets 35-pixels Up & Left.
}

EndTip(TipID) {
    ;;∙------∙Clear the specified ToolTip slot.
    ToolTip, , , , % TipID
}
;;∙==============================================∙


;;∙======∙Get Total Screen Dimensions∙===============∙
F4::    ;;∙------∙🔥∙
SysGet, VirtualX, 76
SysGet, VirtualY, 77
SysGet, VirtualWidth, 78
SysGet, VirtualHeight, 79
    MsgBox, Virtual Desktop: %VirtualX%,%VirtualY% to %VirtualWidth%x%VirtualHeight%
Return
;;∙---------------------------------------------------------------------∙


;;∙======∙Show Cursor X-Y Position∙==================∙
F5::    ;;∙------∙🔥∙Toggle
    if (Toggle := !Toggle) {
        aSoundBeep(1200, 150)
        SetTimer, CursorCoords, 10
    } else {
        aSoundBeep(1000, 150)
        SetTimer, CursorCoords, Off
        ToolTip
    }
Return
;;∙-------------------------------∙
CursorCoords:
    if (GetKeyState("Ctrl", "P") && GetKeyState("Shift", "P")) {
        CoordMode, ToolTip, Screen
        CoordMode, Mouse, Screen
        MouseGetPos, mX, mY
        ToolTip, % "X: " mX "`tY: " mY, mX - 40, mY - 30
    } else {
        ToolTip
    }
Return
;;∙---------------------------------------------------------------------∙


;;∙======∙SCRIPT EDIT/RELOAD/EXIT∙================∙
;;∙------∙Edit∙-----------------------------∙
Script·Edit:    ;;∙------∙Menu Call.
    Edit
Return
;;∙------∙Reload∙-------------------------∙
^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        ;;∙------∙aSoundBeep(1000, 200)    ;;∙------∙Async SoundBeep.
    Reload
Return
;;∙------∙Exit∙-----------------------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        ;;∙------∙aSoundBeep(1000, 200)    ;;∙------∙Async SoundBeep.
    ExitApp
Return

;;∙======∙SCRIPT UPDATE∙=========================∙
UpdateCheck:    ;;∙------Check if script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        return
        aSoundBeep(1500, 100)    ;;∙------∙Async SoundBeep.
Reload

;;∙======∙ASYNCHRONOUS SOUNDBEEP∙=============∙
aSoundBeep(Frequency, Duration) {
    AutoHotkeyPath := A_AhkPath    
    shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec("""" AutoHotkeyPath """ *")
    exec.StdIn.Write("#NoTrayIcon`nSoundBeep, " Frequency "," Duration "`nExitApp")
    exec.StdIn.Close()
}

;;∙======∙TRAY MENU∙============================∙
TrayMenu:
Menu, Tray, Tip, ToastTip
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add
;;∙------∙Menu-Extentions∙------------∙
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
;;∙------∙Menu-Options∙---------------∙
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

;;∙======∙TRAY MENU EXTENTIONS∙=================∙
Documentation:
    Run, "C:\Program Files\AutoHotkey\AutoHotkey.chm"
Return
ShowKeyHistory:
    KeyHistory
Return
ShowWindowSpy:
    Run, "C:\Program Files\AutoHotkey\WindowSpy.ahk"
Return

;;∙======∙TRAY MENU POSITION∙===================∙
;;∙------∙Tray Menu Show∙-----------∙
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20
Return
;;∙------∙Position Funtion∙-----------∙
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
    return True
    }
Return
;;∙==============================================∙
;;∙======∙SCRIPT END∙=============================∙
;;∙---------------------------------------------------------------------∙


