

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


;;∙====================================∙
 ;;∙------∙SCRIPT UPDATE∙-------------∙
UpdateCheck:    ;;∙------Check if script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙


