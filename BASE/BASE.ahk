
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙====∙DIRECTIVES & SETINGS∙============∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance Force
#InstallKeybdHook
#MaxThreadsPerHotkey 3

SendMode, Input
SetBatchLines -1
SetWinDelay 0
SetWorkingDir %A_ScriptDir%

ScriptID := "BASE"
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.
;;∙-------------------------------------------------------∙

;;∙====∙TIMERS & TRAY ICON∙==============∙
SetTimer, AutoReloadDaily, 60000    ;;∙------∙Daily script reload.
    ReloadDone := false    ;;∙------∙Prevent multiple reloads.
SetTimer, UpdateCheck, 500    ;;∙------∙Reload script upon saved chages.

SetTimer, TrayIconFlip, 750    ;;∙------∙Tray icon alternating.
    TrayIconState := 183
Menu, Tray, Icon, imageres.dll, 183

GoSub, TrayMenu
;;∙-------------------------------------------------------∙

;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙

;;∙======∙CONFIG∙=========================∙
ConfigDir := A_MyDocuments . "\BASE_VOL_ini"
ConfigFile := ConfigDir . "\volume_config.ini"
IfNotExist, %ConfigDir%
    FileCreateDir, %ConfigDir%
if !FileExist(ConfigFile)
    IniWrite, 1, %ConfigFile%, Settings, DefaultVolume
IniRead, DefaultVolume, %ConfigFile%, Settings, DefaultVolume, 1

;;∙======∙INITIALIZERS∙===================∙
SetNumLockState, AlwaysOn
SetScrollLockState, AlwaysOff
SetCapsLockState, Off
SoundSet, %DefaultVolume%
;;∙-------------------------------------------------------∙


;;∙======∙RUN APPS∙=====================∙
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
Run, Auxiliaries\File_Employment_Claim\File_Employment_Claim.ahk
    Sleep, 50
Run, Auxiliaries\Screen_Saver\Screen_Saver.ahk
    Sleep, 50
Run, Auxiliaries\Philips_Smart_Control\Philips_Smart_Control.ahk
    Sleep, 50
Run, Auxiliaries\Text_Assist\Text_Assist.ahk
Return
;;∙-------------------------------------------------------∙


;;∙====∙TRAY ICON ALTERNATING∙===========∙
TrayIconFlip:
    TrayIconState := (TrayIconState = 183) ? 184 : 183
    Menu, Tray, Icon, imageres.dll, %TrayIconState%
Return
;;∙-------------------------------------------------------∙


;;∙====∙CHANGE DEFAULT VOLUME∙==========∙
^!v::
    InputBox, NewVolume, Set Default Volume, Enter new default volume (1-100):, , 200, 130
    if ErrorLevel
        Return
    if NewVolume is not integer
    {
        ToolTip, Please enter a number!
        Sleep, 2000
        ToolTip
        Return
    }
    if (NewVolume < 1 || NewVolume > 100)
    {
        ToolTip, Volume must be 1-100!
        Sleep, 2000
        ToolTip
        Return
    }
    IniWrite, %NewVolume%, %ConfigFile%, Settings, DefaultVolume
    DefaultVolume := NewVolume
    SoundSet, %DefaultVolume%
    SoundBeep, 800, 200
    ToolTip, Default volume set to %NewVolume%
    Sleep, 1000
    ToolTip
Return
;;∙-------------------------------------------------------∙


;;∙====∙CONFIRMATION SOUNDS∙==========∙
;;∙--------∙COPY∙∙--------∙
~^c::
    SoundGet, master_volume
    SoundSet, 2
        Sleep, 25
    SoundSet, 5
        Sleep, 50
        SoundBeep, 800, 200
    SoundSet, %master_volume%
Return

;;∙--------∙PASTE∙--------∙
~^v::
    SoundGet, master_volume
    SoundSet, 2
        Sleep, 25
    SoundSet, 5
        Sleep, 50
        SoundBeep, 800, 200
    SoundSet, %master_volume%
Return

;;∙--------∙UNDO∙--------∙
~^z::
    SoundGet, master_volume
    SoundSet, 2
        Sleep, 25
    SoundSet, 5
        Sleep, 50
        Soundbeep, 800, 200
    SoundSet, %master_volume%
Return
;;∙-------------------------------------------------------∙


;;∙====∙DAILY SCRIPT RELOAD∙=============∙
AutoReloadDaily:
    FormatTime, CurrentTime,, HHmm
    if (CurrentTime = "0245" && !ReloadDone)   ;;∙------∙2:45 AM, only once
    {
        ReloadDone := true
        SoundGet, master_volume
        SoundSet, 2
            Sleep, 25
        SoundSet, 5
            Sleep, 50
        SoundBeep, 1200, 200
        SoundSet, %master_volume%
        Reload
    }
    else if (CurrentTime != "0245")
    {
        ReloadDone := false  ;;∙------∙Reset flag after 2:45 AM minute
    }
Return
;;∙-------------------------------------------------------∙


;;∙====∙GUI DRAG∙=======================∙
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}
Return
;;∙-------------------------------------------------------∙

;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙



;;∙====================================∙
 ;;∙------∙EDIT∙---------------------------∙
Script·Edit:    ;;∙------∙Menu Call.
    Edit
Return

;;∙------∙RELOAD∙-----------------------∙
^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
            SoundGet, master_volume
            SoundSet, 2
                Sleep, 25
            SoundSet, 5
                Sleep, 50
            Soundbeep, 1000, 200
            SoundSet, %master_volume%
    Reload
Return

 ;;∙------∙EXIT∙----------------------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
            SoundGet, master_volume
            SoundSet, 2
                Sleep, 25
            SoundSet, 5
                Sleep, 50
            Soundbeep, 1000, 200
            SoundSet, %master_volume%
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
Menu, Tray, Add, Window Spy, ShowWindowSpyDark
Menu, Tray, Icon, Window Spy, wmploc.dll, 21
Menu, Tray, Add
Menu, Tray, Add, DLL Icon Viewer, DllIconViewer
Menu, Tray, Icon,  DLL Icon Viewer, imageres.dll, 110
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
    Run, Auxiliaries\WindowSpy_DarkMode\WindowSpy_DarkMode.ahk
Return

DllIconViewer:
    Run, Auxiliaries\DLL_Icons_Viewer\DLL_Icons_Viewer.ahk
Return

;;∙------∙MENU-HEADER∙---------------∙
BASE:    ;;∙------∙Suspends hotkeys then pauses script.
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
