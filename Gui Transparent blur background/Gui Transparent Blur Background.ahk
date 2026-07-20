
;;∙---------------------------------------------------------------------∙

SetTimer, UpdateCheck, 500
GoSub, TrayMenu

;;∙---------------------------------------------------------------------∙



;;∙---------------------------------------------------------------------∙
;;∙==============================================∙

SendMode, Input
Menu, Tray, Icon, shell32.dll, 270
SetWorkingDir %A_ScriptDir%
;;∙---------------------------------------------------------------------∙



/*∙---------------------------------------------------------∙
;;∙------∙SOURCE:  https://www.autohotkey.com/boards/viewtopic.php?t=65650#p282026
;;∙---∙Parent Gui gets the blur effect. The child Gui doesn't. Use two different window colors. 
;;∙---∙To function properly, the texts must be added to the parent Gui. 
;;∙---∙Buttons and edit boxes are connected to the child Gui.
∙------------------------------------------------------------∙
*/


;;∙======∙DIRECTIVES & SETTINGS∙==================∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force
SetWinDelay, -1
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")

guiX := 1500
guiY := 400
guiW := 300
guiH := 135

WS_POPUP := 0x80000000
WS_CHILD  := 0x40000000


;;∙======∙CREATE PARENT WINDOW∙================∙
;;∙------∙(transparent w/blur).
Gui, 1: +AlwaysOnTop -Caption +Border +LastFound +Owner +hWndhGui1
Gui, 1: Color, 000000
WinSet, TransColor, 000000, % "ahk_id " hGui1
Gui, 1: Font, s11 q5 bold, Segoe UI

Gui, 1: Add, Text, w270 x15 y15 BackgroundTrans cBlue, Please enter some text:

ParentHwnd := WinExist()


;;∙======∙CREATE CHILD WINDOW∙==================∙
;;∙------∙(for solid controls).
Gui, 2: Margin, 1, 1
Gui, 2: -Caption -Border +hWndhGui2 +%WS_CHILD% -%WS_POPUP%
Gui, 2: Color, 000001
WinSet, TransColor, 000001, % "ahk_id " hGui2
Gui, 2: Font, s10 q5, Segoe UI

Gui, 2: Add, Edit, x15 y+50 w270 r1 Limit20 vUserInput
Gui, 2: Add, Button, x15 y+15 w80 h30 gCopy Default, Copy
Gui, 2: Add, CheckBox, x+25 yp-5 cAqua vToggleBlur gToggleBlur Checked, Blur`n Effect
Gui, 2: Add, Button, x+25 yp+5 w80 h30 gClear, Clear

Gui, 2: +LastFound
ChildHwnd := WinExist()

;;∙------∙Attach Child To Parent.
DllCall("SetParent", "Ptr", ChildHwnd, "Ptr", ParentHwnd)

;;∙------∙Enable Blur On Parent.
Gui, 1: Show, x%guiX% y%guiY% w%guiW% h%guiH%
EnableBlur(hGui1)

;;∙------∙Show Child.
Gui, 2: Show, x0 y0 w%guiW% h%guiH%
Return


;;∙======∙ROUNTINES & FUNCTIONS∙================∙
;;∙------∙Toggle Blur Effect.
ToggleBlur:
    Gui, 2: Submit, NoHide
    if (ToggleBlur) {
        EnableBlur(hGui1)
    } else {
        DisableBlur(hGui1)
    }
Return

;;∙------∙Copy Button (copies text to clipboard).
Copy:
    Gui, 2: Submit, NoHide
    if (UserInput != "") {
        Clipboard := UserInput
        ToolTip, Copied to clipboard!
        SetTimer, RemoveToolTip, -1500
    } else {
        MsgBox, 48, Nothing to Copy, Please enter some text first.
    }
Return

;;∙------∙Clear Button.
Clear:
    GuiControl, 2:, UserInput
    Gui, 2: Submit, NoHide
Return

;;∙------∙Remove ToolTip.
RemoveToolTip:
    ToolTip
Return

;;∙------∙Enable Blur.
EnableBlur(hWnd)
{
    WCA_ACCENT_POLICY := 0x13
    ACCENT_ENABLE_BLURBEHIND := 3
    VarSetCapacity(AccentPolicy, 16, 0)
    accentStructSize := 16
    NumPut(ACCENT_ENABLE_BLURBEHIND, AccentPolicy, 0, "UInt")
    padding := (A_PtrSize = 8) ? 4 : 0
    VarSetCapacity(WindowCompositionAttributeData, 4 + padding + A_PtrSize + 4 + padding)
    NumPut(WCA_ACCENT_POLICY, WindowCompositionAttributeData, 0, "UInt")
    NumPut(&AccentPolicy,     WindowCompositionAttributeData, 4 + padding, "Ptr")
    NumPut(accentStructSize,  WindowCompositionAttributeData, 4 + padding + A_PtrSize, "UInt")
    DllCall("SetWindowCompositionAttribute", "Ptr", hWnd, "Ptr", &WindowCompositionAttributeData)
}

;;∙------∙Disable Blur.
DisableBlur(hWnd)
{
    WCA_ACCENT_POLICY := 0x13
    ACCENT_DISABLED := 0
    VarSetCapacity(AccentPolicy, 16, 0)
    accentStructSize := 16
    NumPut(ACCENT_DISABLED, AccentPolicy, 0, "UInt")
    padding := (A_PtrSize = 8) ? 4 : 0
    VarSetCapacity(WindowCompositionAttributeData, 4 + padding + A_PtrSize + 4 + padding)
    NumPut(WCA_ACCENT_POLICY, WindowCompositionAttributeData, 0, "UInt")
    NumPut(&AccentPolicy,     WindowCompositionAttributeData, 4 + padding, "Ptr")
    NumPut(accentStructSize,  WindowCompositionAttributeData, 4 + padding + A_PtrSize, "UInt")
    DllCall("SetWindowCompositionAttribute", "Ptr", hWnd, "Ptr", &WindowCompositionAttributeData)
}

;;∙------∙Gui Drag.
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}
Return

GuiClose:
    ExitApp
Return
;;∙==============================================∙




;;∙==============================================∙
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
        ;;∙------∙aSoundBeep(1500, 100)    ;;∙------∙Async SoundBeep.
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
Menu, Tray, Tip, %ScriptID%
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


