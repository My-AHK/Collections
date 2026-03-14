
/*------∙NOTES∙--------------------------------------------------------------------------∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  
» Original Source:  
» 
    ▹ 
∙--------------------------------------------------------------------------------------------∙
*/



;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙
#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
#Persistent
SetBatchLines -1
SetWinDelay 0
SetTimer, UpdateCheck, 750
ScriptID := "Copy_Paste_Undo"
Menu, Tray, Icon, shell32.dll, 313
GoSub, TrayMenu


;;∙======∙Variables∙======∙
volLevel := 3
beepTime := 150

;;∙======∙Copy Confirmation∙(Ctrl+C)∙======∙
~^c::
    SoundGet, master_volume    ;;∙------∙Store current system volume.
    SoundSet, %volLevel%    ;;∙------∙Set volume audible level.

    ;;∙------∙Wait until volume actually changes, timeout after 500ms.
    Loop, 50 {
        SoundGet, current_volume
        if (Abs(current_volume - volLevel) < 1)
            Break
        Sleep, 10
    }

    SoundBeep, 1000, %beepTime%    ;;∙------∙Play confirmation beep.
    SoundSet, %master_volume%    ;;∙------∙Restore original system volume.
    Show_Quadrant_ToolTip("Copy")    ;;∙------∙Display ToolTip at offset.
Return

;;∙======∙Paste Confirmation∙(Ctrl+V)∙======∙ 
~^v::
    SoundGet, master_volume
    SoundSet, %volLevel%

    ;;∙------∙Wait until volume actually changes, timeout after 500ms.
    Loop, 50 {
        SoundGet, current_volume
        if (Abs(current_volume - volLevel) < 1)
            Break
        Sleep, 10
    }

    SoundBeep, 800, %beepTime%
    SoundSet, %master_volume%
    Show_Quadrant_ToolTip("Paste")
Return

;;∙======∙Undo Confirmation∙(Ctrl+Z)∙======∙
~^z::
    SoundGet, master_volume
    SoundSet, %volLevel%

    ;;∙------∙Wait until volume actually changes, timeout after 500ms.
    Loop, 50 {
        SoundGet, current_volume
        if (Abs(current_volume - volLevel) < 1)
            Break
        Sleep, 10
    }

    Soundbeep, 900, %beepTime%
    SoundSet, %master_volume%
    Show_Quadrant_ToolTip("Undo")
Return


;;∙======∙Screen Quadrant-Aware∙=========∙
Show_Quadrant_ToolTip(Text) {
    CoordMode, Mouse, Screen    ;;∙------∙Screen-relative mouse coordinates.
    CoordMode, ToolTip, Screen    ;;∙------∙Screen-relative ToolTip coordinates.

    MouseGetPos, MouseX, MouseY    ;;∙------∙Capture current cursor position.
    ScreenW := A_ScreenWidth    ;;∙------∙Store width.
    ScreenH := A_ScreenHeight    ;;∙------∙Store height.

    ;;∙------∙Horizontal offset per left/right screen half.
    if (MouseX < ScreenW / 2) {
        X_Offset := 15    ;;∙------∙Cursor on left → ToolTip to right.
    } else {
        X_Offset := -15    ;;∙------∙Cursor on right → ToolTip to left.
    }

    ;;∙------∙Vertical offset per top/bottom screen half.
    if (MouseY < ScreenH / 2) {
        Y_Offset := 100    ;;∙------∙Cursor on top → ToolTip below.
    } else {
        Y_Offset := -100    ;;∙------∙Cursor on bottom → ToolTip above.
    }

    ToolTip, %Text%, MouseX + X_Offset, MouseY + Y_Offset    ;;∙------∙Display at offset.
    SetTimer, Clear_Quadrant_ToolTip, -800    ;;∙------∙Clear after delay.
}


;;∙======∙Clear ToolTip∙======∙
Clear_Quadrant_ToolTip:
    ToolTip
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙



;;∙====================================∙
;;∙------∙EDIT∙---------------------------∙
Script·Edit:    ;;∙------∙Menu Call.
    Edit
Return

;;∙------∙RELOAD∙-----------------------∙
^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        Soundbeep, 1700, 100
    Reload
Return

;;∙------∙EXIT∙----------------------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        Soundbeep, 1700, 100
    ExitApp
Return

;;∙====================================∙
;;∙------∙SCRIPT UPDATE∙-------------∙
UpdateCheck:    ;;∙------Check if script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload

;;∙====================================∙
;;∙------∙TRAY MENU∙------------------∙
TrayMenu:
Menu, Tray, Tip, %ScriptID%
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Suspend / Pause, % ScriptID    ;;∙------∙Script Header.
Menu, Tray, Icon, Suspend / Pause, shell32, 28
Menu, Tray, Default, Suspend / Pause    ;;∙------∙Makes Bold.

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

;;∙------∙MENU-HEADER∙---------------∙
Copy_Paste_Undo:    ;;∙------∙Suspends hotkeys then pauses script.
    Suspend
    Soundbeep, 700, 100
    Pause
Return

;;∙====================================∙
;;∙------∙MENU POSITION∙-----------∙
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
;;∙------------------------------------------------------------------------------------------∙
;;∙========================∙SCRIPT END∙=========================∙
;;∙------------------------------------------------------------------------------------------∙

