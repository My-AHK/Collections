
;;∙---------------------------------------------------------------------∙

SetTimer, UpdateCheck, 500
GoSub, TrayMenu

;;∙---------------------------------------------------------------------∙


;;∙---------------------------------------------------------------------∙
;;∙==============================================∙


;;∙======∙DIRECTIVES & SETTINGS∙==================∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force
SendMode, Input
Menu, Tray, Icon, shell32.dll, 246
SetWorkingDir %A_ScriptDir%
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")

;;∙====∙Usage Notes:
;;∙------∙This needs to be called before creating any GUI elements, ideally near the auto-execute section!
DllCall("user32.dll\SetProcessDpiAwarenessContext", "ptr", -3, "ptr")
;;∙---------------------------------------------------------------------∙

;;∙==============================================∙
^t::    ;;∙------∙🔥∙(Ctrl + T)

;;∙------∙Then create the GUI.
Gui, +AlwaysOnTop -Caption +Border +ToolWindow
Gui, Margin, 0, 0
Gui, Color, Yellow
Gui, Font, s8 q5 cBlue, Arial
Gui, Add, Text, y10 cBlue w220 Center, - - - Bold Text Closes Draggable GUI - - -
Gui, Font, s14 q5 Bold
Gui, Add, Text, y+15 cBlue w220 Center gClose, This will be crisp`non High-DPI displays!
Gui, Show, w220 h100
Return

;;∙------∙Close Gui.
Close:
;    Reload
    ExitApp

;;∙------∙Drag Gui.
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}
Return
;;∙---------------------------------------------------------------------∙


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


