
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙--------∙Origins∙-------------------------∙
» Author:  lexikos
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?f=6&t=26059
» 
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
^t::    ;;∙------∙(Ctrl+T) 
    Soundbeep, 1100, 100
;;∙============================================================∙




;;∙============================================================∙
;;∙------∙If the most recent event is a mouse-move and the mouse moves again,
;;∙------∙ enable this to update it instead of adding another mouse-move event.
MERGE_MOVE := true

#NoEnv
#Persistent
#MouseHistory(10)

Gui, +LastFound -DPIScale
WinSet, Transparent, 200
Gui, +ToolWindow +AlwaysOnTop
Gui, Margin, 10, 10
Gui, Font,, Lucida Console
Gui, Add, Text, vMH, .                                 .
GuiControlGet, MH, Pos
GuiControl,, MH    ;;∙------∙Clear dummy sizing text.
gosub Resize
OnMessage(0x201, "WM_LBUTTONDOWN")
return

#MaxThreadsBuffer, On
!WheelUp::
!WheelDown::
#MaxThreadsBuffer, Off
    history_size := #MouseHistory() + ((A_ThisHotkey="!WheelUp") ? +1 : -1)
    #MouseHistory(history_size>0 ? history_size : 1)
    ;;∙------∙Delay resize to improve hotkey responsiveness.
    SetTimer, Resize, -10
return

Resize:
    ;;∙------∙Resize label to fit mouse history.
    gui_h := MHH*(#MouseHistory())
    GuiControl, Move, MH, h%gui_h%
    gui_h += 20

    Gui, +LastFound
    ;;∙------∙Determine visibility.
    WinGet, style, Style
    gui_visible := style & 0x10000000
    
    ;;∙------∙Determine current position and height.
    WinGetPos, gui_x, gui_y, , gui_h_old
    ;;∙------∙Use old height to determine if we should reposition, *only when shrinking*.
    ;;∙------∙This way we can move the GUI somewhere else, and the script won't reposition it.
    ;;∙------∙ if (gui_h_old < gui_h)
    ;;∙------∙    gui_h_old := gui_h
    ;;∙------∙Determine working area (primary screen size minus taskbar.)
    SysGet, wa_, MonitorWorkArea

    SysGet, twc_h, 51    ;;∙------∙SM_CYSMCAPTION
    SysGet, bdr_h, 8    ;;∙------∙SM_CYFIXEDFRAME
    if (!gui_visible)
    {
        gui_x = 10    ;;∙------∙Initially on the left side.
        gui_y := wa_bottom-(gui_h+twc_h+bdr_h*2+10)
    }
    else
    {    ;;∙------∙Move relative to bottom edge when closer to the bottom.
        if (gui_y+gui_h//2 > (wa_bottom-wa_top)//2)
            gui_y += gui_h_old-(gui_h+twc_h+bdr_h*2)
    }
    Gui, Show, x%gui_x% y%gui_y% h%gui_h% NA, Mouse History
return

Show:
    SetFormat, FloatFast, .2
    text =
    buf_size := #MouseHistory()
    Loop, % buf_size
    {
        SetFormat, IntegerFast, D
        
        if MouseHistory(A_Index, msg, x, y, mouseData, flags, time, elapsed)
        {
            SetFormat, IntegerFast, H
            msg := (msg + 0) ""
            SetFormat, IntegerFast, D
            
            ;;∙------∙WM_LBUTTONDOWN/UP/DBLCLK, WM_NC..
            if msg in 0x201,0x202,0x203,0xA1,0xA2,0xA3
                btn = Left
            ;;∙------∙WM_RBUTTONDOWN/UP/DBLCLK, WM_NC..
            else if msg in 0x204,0x205,0x206,0xA4,0xA5,0xA6
                btn = Right
            ;;∙------∙WM_MBUTTONDOWN/UP/DBLCLK, WM_NC..
            else if msg in 0x207,0x208,0x209,0xA7,0xA8,0xA9
                btn = Middle
            ;;∙------∙WM_XBUTTONDOWN/UP/DBLCLK, WM_NC..
            else if msg in 0x20B,0x20C,0x20D,0xAB,0xAC,0xAD
                btn := (mouseData & 0x10000) ? "X1" : "X2"
            ;;∙------∙WM_MOUSEWHEEL
            else if msg = 0x20A
            {
                mouseData := mouseData << 32 >> 48
                btn := (mouseData < 0) ? "WD" : "WU"
            }
            ;;∙------∙WM_MOUSEHWHEEL
            else if msg = 0x20E
            {
                mouseData := mouseData << 32 >> 48
                btn := (mouseData < 0) ? "WL" : "WR"
            }
            ;;∙------∙WM_MOUSEMOVE
            else if msg = 0x200
                btn =
            ;;∙------∙???
            else btn := msg
            
            clickCount =
            
            ;;∙------∙WM_LBUTTONDBLCLK, WM_NC.., ..R/M/XBUTTONDBLCLK..
            if msg in 0x203,0xA3,0x206,0xA6,0x209,0xA9,0x20D,0xAD
            {
                clickCount := 2
            }
            ;;∙------∙WM_MOUSEWHEEL, WM_MOUSEHWHEEL
            else if msg in 0x20A,0x20E
            {
                clickCount := Abs(mouseData)
                if !clickCount
                    clickCount =
            }
            ;;∙------∙WM_L/R/M/XBUTTONDOWN, WM_NC..
            else if msg in 0x201,0x204,0x207,0x20B,0xA1,0xA4,0xA7,0xAB
            {
                clickCount = Down
            }
            ;;∙------∙WM_L/R/M/XBUTTONUP, WM_NC..
            else if msg in 0x202,0x205,0x208,0x20C,0xA2,0xA5,0xA8,0xAC
            {
                clickCount = Up
            }

            text .= ((flags & 1) ? "* " : "  ")
            ;;∙------∙ .  SubStr(msg "      ", 1, 6)
                 .  SubStr(btn "        ", 1, 8)
                 .  SubStr("    " x, -4) "  " SubStr("    " y, -4)
                 .  SubStr("      " clickCount, -5)
                 .  SubStr("      " elapsed/1000.0, -6) "`n"
        }
        else break
    }
    GuiControl,, MH, % text
Return

GuiClose:
ExitApp


MouseHistory(N, ByRef msg, ByRef x, ByRef y, ByRef mouseData, ByRef flags, ByRef time, ByRef elapsed=-1)
{
    global MouseBuffer
    if N is not integer
        return false
    buf_max := #MouseHistory()
    if (N < 1 or N > buf_max)
        return false
    x           := NumGet(MouseBuffer, ofs:=(N-1)*24, "int") 
    y           := NumGet(MouseBuffer, ofs+4, "int")
    mouseData   := NumGet(MouseBuffer, ofs+8, "uint")
    flags       := NumGet(MouseBuffer, ofs+12, "uint")
    time        := NumGet(MouseBuffer, ofs+16, "uint")
    msg         := NumGet(MouseBuffer, ofs+20, "uint")
    elapsed := time - ((time2 := NumGet(MouseBuffer, N*24+16, "uint")) ? time2 : time)
    return !!msg
}

#MouseHistory(NewSize="")
{
    global MouseBuffer
    static MouseHook, MouseHookProc

    if NewSize =            ;;∙------∙Get current history length.
        return (cap:=VarSetCapacity(MouseBuffer)//24)>0 ? cap-1 : 0

    if NewSize
    {
        if !MouseHook
        {    ;;∙------∙Register the mouse hook.
            MouseHookProc := RegisterCallback("Mouse")
            MouseHook := DllCall("SetWindowsHookEx", "int", 14, "ptr", MouseHookProc, "uint", 0, "uint", 0, "ptr")
        }
        
        new_cap := (NewSize+1)*24    ;;∙------∙sizeof(MSLLHOOKSTRUCT)=24
        cap := VarSetCapacity(MouseBuffer)
        if (cap > new_cap)
            cap := new_cap
        VarSetCapacity(old_buffer, cap)
        ;;∙------∙Back up previous history.
        DllCall("RtlMoveMemory", "ptr", &old_buffer, "ptr", &MouseBuffer, "ptr", cap)
        
        ;;∙------∙Set new history length.
        VarSetCapacity(MouseBuffer, 0)    ;;∙------∙FORCE SHRINK
        VarSetCapacity(MouseBuffer, new_cap, 0)
        
        ;;∙------∙Restore previous history.
        DllCall("RtlMoveMemory", "ptr", &MouseBuffer, "ptr", &old_buffer, "ptr", cap)
        
        ;;∙------∙(Remember N+1 mouse events to simplify calculation of the Nth mouse event's elapsed time.)
        ;;∙------∙Put tick count so the initial mouse event has a meaningful value for "elapsed".
        NumPut(A_TickCount, MouseBuffer, 16, "uint")
    }
    else
    {
        if MouseHook
        {    ;;∙------∙Unregister the mouse hook.
            DllCall("UnhookWindowsHookEx", "ptr", MouseHook)
            DllCall("GlobalFree", "ptr", MouseHookProc)
            MouseHook =
        }
        ;;∙------∙Clear history entirely.
        VarSetCapacity(MouseBuffer, 0)
    }
}

;;∙------∙Mouse hook callback - records mouse events into MouseBuffer.
Mouse(nCode, wParam, lParam)
{
    global MouseBuffer, MERGE_MOVE
    Critical
    if (buf_max:=#MouseHistory()) > 0
    {
        if MERGE_MOVE && NumGet(MouseBuffer, 20, "uint") = 0x200
        ;;∙------∙if MERGE_MOVE && wParam = 0x200 && NumGet(MouseBuffer, 20, "uint") = 0x200
        {
            ;;∙------∙Update the most recent (mouse-move) event.
            DllCall("RtlMoveMemory", "ptr", &MouseBuffer, "ptr", lParam, "ptr", 20)
        }
        else
        {
            ;;∙------∙Push older mouse events to the back.
            if (buf_max > 1)
                DllCall("RtlMoveMemory", "ptr", &MouseBuffer+24, "ptr", &MouseBuffer, "ptr", buf_max*24)
            ;;∙------∙Copy current mouse event to the buffer.
            DllCall("RtlMoveMemory", "ptr", &MouseBuffer, "ptr", lParam, "ptr", 20)
        }
        NumPut(wParam, MouseBuffer, 20, "uint")    ;;∙------∙Put wParam in place of dwEventInfo.
        ;;∙------∙"gosub Show" slows down the mouse hook and causes problems, so use a timer.        
        SetTimer, Show, -10
    }
    return DllCall("CallNextHookEx", "uint", 0, "int", nCode, "ptr", wParam, "ptr", lParam, "ptr")
}

WM_LBUTTONDOWN(wParam, lParam)
{
    global text
    StringReplace, Clipboard, text, `n, `r`n, All
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
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.
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

