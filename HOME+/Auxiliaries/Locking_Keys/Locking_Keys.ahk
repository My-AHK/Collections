
;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙
;;∙======∙AUTO-EXECUTE∙========∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance Force
#InstallKeybdHook
SendMode, Input
SetBatchLines -1
SetWorkingDir %A_ScriptDir%
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")
SetTimer, UpdateCheck, 750

Menu, Tray, Icon, wmploc.dll, 65    ;;∙------∙Keys Icon.
GoSub, TrayMenu
#NoTrayIcon

;;∙======∙INITIAL-STATES∙========∙
SetNumLockState, ON
SetScrollLockState, Off
SetCapsLockState, Off


;;∙======∙GUI-INDICATOR∙========∙
Gui, +AlwaysOnTop -Caption +Border +ToolWindow
Gui, Color, 202020
Gui, Font, s10 cAqua, Calibri
;;∙------∙Column 1: CapsLock∙------------∙
Gui, Add, Text, x0 y5 Center w30 BackgroundTrans, C
Gui, Add, Picture, vIconC x10 y+1 w10 h10 Icon3, C:\windows\system32\actioncentercpl.dll
;;∙------∙Column 2: NumLock∙------------∙
Gui, Add, Text, x20 y5 Center w30 BackgroundTrans, N
Gui, Add, Picture, vIconN x30 y+1 w10 h10 Icon3, C:\windows\system32\actioncentercpl.dll
;;∙------∙Column 3: ScrollLock∙------------∙
Gui, Add, Text, x40 y5 Center w30 BackgroundTrans, S
Gui, Add, Picture, vIconS x50 y+1 w10 h10 Icon3, C:\windows\system32\actioncentercpl.dll


;;∙======∙NUM-LOCK∙============∙
;;∙------∙Block physical NumLock key press.
$NumLock::    ;;∙------∙🔥∙(Blocked)∙🔥∙
    ShowBlockMessage()
Return

ShowBlockMessage() {
    ToolTip, NumLock key is disabled`nPress Alt+NumLock to toggle
    SetTimer, CloseTip, -3500
}

!NumLock::    ;;∙------∙🔥∙(Alt + NumLock)∙🔥∙
    SetNumLockState, % !GetKeyState("NumLock", "T")
    state := GetKeyState("NumLock", "T") ? "ON" : "OFF"
    ;;∙------∙Add sound feedback
    if (state = "ON")
        SoundBeep, 1100, 100    ;;∙------∙ON.
    else
        SoundBeep, 900, 100     ;;∙------∙OFF.
    ToolTip, NumLock : %state%
    SetTimer, CloseTip, -1000
    Gosub, UpdateLockIcons    ;;∙------∙Update icon.
    Gosub, ShowGuiTemporarily    ;;∙------∙Show GUI briefly.
Return


;;∙======∙CAPS-LOCK∙============∙
#If (A_TickCount < CapsDouble)
CapsLock::    ;;∙------∙🔥∙(CapsLock x 2)∙🔥∙
    SetCapsLockState, % !GetKeyState("CapsLock", "T")
    state := GetKeyState("CapsLock", "T") ? "ON" : "OFF"
    ;;∙------∙State sound.
    if GetKeyState("CapsLock", "T")
        SoundBeep, 1100, 100    ;;∙------∙CapsLock ON.
    else
        SoundBeep, 900, 100    ;;∙------∙CapsLock OFF.
    ToolTip, CapsLock : %state%
    SetTimer, CloseTip, -1000
    Gosub, UpdateLockIcons    ;;∙------∙Update icon.
    Gosub, ShowGuiTemporarily    ;;∙------∙Show GUI briefly.
    CapsDouble := 0    ;;∙------∙Reset.
Return
#If
CapsLock::CapsDouble := A_TickCount + DllCall("GetDoubleClickTime")
#If


;;∙======∙SCROLL-LOCK∙============∙
#If (A_TickCount < ScrollDouble)
ScrollLock::    ;;∙------∙🔥∙(ScrollLock x 2)∙🔥∙
    SetScrollLockState, % !GetKeyState("ScrollLock", "T")
    state := GetKeyState("ScrollLock", "T") ? "ON" : "OFF"
    
    ;;∙------∙State sound.
    if GetKeyState("ScrollLock", "T")
        SoundBeep, 1100, 100    ;;∙------∙ScrollLock ON
    else
        SoundBeep, 900, 100    ;;∙------∙ScrollLock OFF
    
    ;;∙------∙Show tooltip.
    ToolTip, ScrollLock : %state%
    SetTimer, CloseTip, -1000
    Gosub, UpdateLockIcons    ;;∙------∙Update icon.
    Gosub, ShowGuiTemporarily    ;;∙------∙Show GUI briefly.
    
    ScrollDouble := 0    ;;∙------∙Reset.
Return
#If
ScrollLock::ScrollDouble := A_TickCount + DllCall("GetDoubleClickTime")
#If


;;∙======∙UPDATE-ICONS∙=========∙
UpdateLockIcons:
    ;;∙------∙Update CapsLock icon.
    caps := GetKeyState("CapsLock", "T")
    path := "*Icon" . (caps ? 2 : 4) . " C:\windows\system32\actioncentercpl.dll"
    GuiControl,, IconC, %path%
    ;;∙------∙Update NumLock icon.
    num := GetKeyState("NumLock", "T")
    path := "*Icon" . (num ? 2 : 4) . " C:\windows\system32\actioncentercpl.dll"
    GuiControl,, IconN, %path%
    ;;∙------∙Update ScrollLock icon.
    scroll := GetKeyState("ScrollLock", "T")
    path := "*Icon" . (scroll ? 2 : 4) . " C:\windows\system32\actioncentercpl.dll"
    GuiControl,, IconS, %path%
Return

;;∙======∙SHOW-KEY-STATUS∙=====∙
ShowGuiTemporarily:
    Gui, Show, x1820 y990 w70 NoActivate, LockStatus
    SetTimer, HideGui, -2000    ;;∙------∙Hide after 2 seconds.
Return

;;∙======∙HIDE-GUI∙=============∙
HideGui:
    Gui, Hide
Return

;;∙======∙CLOSE-TIP∙============∙
CloseTip:
    ToolTip
Return

;;∙======∙Gui_Drag∙=============∙
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}
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
Menu, Tray, Add, Suspend / Pause, LockKeys    ;;∙------∙Header.
Menu, Tray, Icon, Suspend / Pause, shell32, 28
Menu, Tray, Default, Suspend / Pause    ;;∙------∙Make Bold.

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
LockKeys:    ;;∙------∙Suspends hotkeys then pauses script.
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
