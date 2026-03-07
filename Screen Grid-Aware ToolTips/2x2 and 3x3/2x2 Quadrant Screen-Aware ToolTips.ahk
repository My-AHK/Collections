

;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙
;;∙======∙DIRECTIVES∙============================∙
#Requires AutoHotkey 1
#SingleInstance, Force
#NoEnv
#Persistent

SetTimer, UpdateCheck, 750
ScriptID := "Screen_Quadrant_Aware_ToolTip"
Menu, Tray, Icon, shell32.dll, 246
GoSub, TrayMenu

;;∙======∙TOOLTIP EXAMPLE∙=======================∙
^t::    ;;∙------∙🔥∙(Ctrl + T)
    Show_Quadrant_ToolTip("Two Line`nTest Tip")
Return


;;∙======∙QUADRANT AWARE FUNCTION∙============∙
Show_Quadrant_ToolTip(Text) {
    CoordMode, Mouse, Screen    ;;∙------∙Screen-relative mouse coordinates.
    CoordMode, ToolTip, Screen    ;;∙------∙Screen-relative ToolTip coordinates.

    MouseGetPos, MouseX, MouseY    ;;∙------∙Capture current cursor position.
    ScreenW := A_ScreenWidth    ;;∙------∙Store width.
    ScreenH := A_ScreenHeight    ;;∙------∙Store height.

    ;;∙------∙HORIZONTAL OFFSET per LEFT/RIGHT screen half.
    if (MouseX < ScreenW / 2) {
        X_Offset := 25    ;;∙------∙Cursor on LEFT → ToolTip to RIGHT.
    } else {
        X_Offset := -45    ;;∙------∙Cursor on RIGHT → ToolTip to LEFT.
    }

    ;;∙------∙VERTICAL OFFSET per TOP/BOTTOM screen half.
    if (MouseY < ScreenH / 2) {
        Y_Offset := 40    ;;∙------∙Cursor on TOP → ToolTip BELOW.
    } else {
        Y_Offset := -70    ;;∙------∙Cursor on BOTTOM → ToolTip ABOVE.
    }

    ToolTip, %Text%, MouseX + X_Offset, MouseY + Y_Offset    ;;∙------∙Display at offsets.
    SetTimer, Clear_Quadrant_ToolTip, -2000    ;;∙------∙Clear ToolTip after delay.
}

Clear_Quadrant_ToolTip:    ;;∙------∙Clear ToolTip.
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
        Soundbeep, 1200, 250
    Reload
Return

 ;;∙------∙EXIT∙----------------------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        Soundbeep, 1000, 300
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
Screen_Quadrant_Aware_ToolTip:    ;;∙------∙Suspends hotkeys then pauses script.
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

