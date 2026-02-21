;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙
;;∙======∙AUTO-EXECUTE∙==============∙
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
ScriptID := "Home+"

Menu, Tray, Icon, compstui.dll, 7
GoSub, TrayMenu

;;∙======∙INITIALIZERS∙================∙
SetNumLockState, AlwaysOn
SetScrollLockState, AlwaysOff
SetCapsLockState, Off
SoundSet, 1 

;;∙======∙RUN APPS∙===================∙
Run, Auxiliaries\Locking_Keys\Locking_Keys.ahk
    Sleep, 50
Run, Auxiliaries\Dot_Symbol_Sender\Dot_Symbol_Sender.ahk
    Sleep, 50
Run, Auxiliaries\Get_File_Path\Get_File_Path.ahk
    Sleep, 50
Run, Auxiliaries\Open_Images\Open_Images.ahk
    Sleep, 50
Run, Auxiliaries\Rent_Is_Due\Rent_Is_Due.ahk
    Sleep, 50
Run, Auxiliaries\Screen_Saver\Screen_Saver.ahk
    Sleep, 50
Run, Auxiliaries\Philips_Smart_Control\Philips_Smart_Control.ahk
    Sleep, 50
Run, Auxiliaries\Text_Assist\Text_Assist.ahk
Return

;;∙======∙Copy-Sound-Confirmation∙======∙
~^c::
    SoundGet, master_volume
    SoundSet, 5
        Sleep, 50
        SoundBeep, 800, 200
    SoundSet, %master_volume%
Return

;;∙======∙Paste-Sound-Confirmation∙======∙
~^v::
    SoundGet, master_volume
    SoundSet, 5
        Sleep, 50
        SoundBeep, 800, 200
    SoundSet, %master_volume%
Return

;;∙======∙Undo-Sound-Confirmation∙======∙
~^z::
    SoundGet, master_volume
    SoundSet, 5
        Sleep, 50
        Soundbeep, 800, 200
    SoundSet, %master_volume%
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
        Run, Auxiliaries\AHK_Killer\AHK_Killer.ahk
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
Menu, Tray, Add, Window Spy Dark, ShowWindowSpyDark
Menu, Tray, Icon, Window Spy Dark, wmploc.dll, 21
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
ShowWindowSpyDark:
;    Run, "C:\Program Files\AutoHotkey\WindowSpy.ahk"
    Run, Auxiliaries\WindowSpy_DarkMode\WindowSpy_DarkMode.ahk
Return

;;∙------∙MENU-HEADER∙---------------∙
Home+:    ;;∙------∙Suspends hotkeys then pauses script.
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

