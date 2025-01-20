
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  Scr1pter
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?f=76&t=60341&sid=dfaf2c30f909870481a874d7c67f95f4#p254904
» Mouse Ripple Effect.
» Only fires if F1 key is held down.
    ▹ 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "Mouse_Ripple"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙

CoordMode Mouse, Screen
Setup()
    F1::return    ;;∙------∙Suppress the default action of F1.
    ~lbutton::    ;;∙------∙🔥∙
        if GetKeyState("F1", "P")    ;;∙------∙Check if F1 is being held down.
            ShowRipple(LeftClickRippleColor)
    Return

Setup()
    {
        global
        RippleWinSize := 200
        RippleStep := 10
        RippleMinSize := 10
        RippleMaxSize := RippleWinSize - 20
        RippleAlphaMax := 0x60
        RippleAlphaStep := RippleAlphaMax // ((RippleMaxSize - RippleMinSize) / RippleStep)
        RippleVisible := False
        LeftClickRippleColor := 0xDE0000
        DllCall("LoadLibrary", Str, "gdiplus.dll")
        VarSetCapacity(buf, 16, 0)
        NumPut(1, buf)
        DllCall("gdiplus\GdiplusStartup", UIntP, pToken, UInt, &buf, UInt, 0)
        Gui Ripple: -Caption +LastFound +AlwaysOnTop +ToolWindow +Owner +E0x80000
        Gui Ripple: Show, NA, RippleWin
        hRippleWin := WinExist("RippleWin")
        hRippleDC := DllCall("GetDC", UInt, 0)
        VarSetCapacity(buf, 40, 0)
        NumPut(40, buf, 0)
        NumPut(RippleWinSize, buf, 4)
        NumPut(RippleWinSize, buf, 8)
        NumPut(1, buf, 12, "ushort")
        NumPut(32, buf, 14, "ushort")
        NumPut(0, buf, 16)
        hRippleBmp := DllCall("CreateDIBSection", UInt, hRippleDC, UInt, &buf, UInt, 0, UIntP, ppvBits, UInt, 0, UInt, 0)
        DllCall("ReleaseDC", UInt, 0, UInt, hRippleDC)
        hRippleDC := DllCall("CreateCompatibleDC", UInt, 0)
        DllCall("SelectObject", UInt, hRippleDC, UInt, hRippleBmp)
        DllCall("gdiplus\GdipCreateFromHDC", UInt, hRippleDC, UIntP, pRippleGraphics)
        DllCall("gdiplus\GdipSetSmoothingMode", UInt, pRippleGraphics, Int, 4)
    }

ShowRipple(_color, _interval:=10)
    {
        global
        if (RippleVisible)
        {
            return
        }
        RippleColor := _color
        RippleDiameter := RippleMinSize
        RippleAlpha := RippleAlphaMax
        RippleVisible := True

        MouseGetPos _pointerX, _pointerY
        SetTimer RippleTimer, % _interval
    return
    RippleTimer:
        DllCall("gdiplus\GdipGraphicsClear", UInt, pRippleGraphics, Int, 0)
        if ((RippleDiameter += RippleStep) < RippleMaxSize) 
        {
            DllCall("gdiplus\GdipCreatePen1", Int, ((RippleAlpha -= RippleAlphaStep) << 24) | RippleColor, float, 3, Int, 2, UIntP, pRipplePen)
            DllCall("gdiplus\GdipDrawEllipse", UInt, pRippleGraphics, UInt, pRipplePen, float, 1, float, 1, float, RippleDiameter - 1, float, RippleDiameter - 1)
            DllCall("gdiplus\GdipDeletePen", UInt, pRipplePen)
        }
        else 
        {
            RippleVisible := False
            SetTimer RippleTimer, Off
        }
    VarSetCapacity(buf, 8)
        NumPut(_pointerX - RippleDiameter // 2, buf, 0)
        NumPut(_pointerY - RippleDiameter // 2, buf, 4)
        DllCall("UpdateLayeredWindow", UInt, hRippleWin, UInt, 0, UInt, &buf, Int64p, (RippleDiameter + 5) 
        | (RippleDiameter + 5) << 32, UInt, hRippleDC, Int64p, 0, UInt, 0, UIntP, 0x1FF0000, UInt, 2)
        return
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
Mouse_Ripple:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

