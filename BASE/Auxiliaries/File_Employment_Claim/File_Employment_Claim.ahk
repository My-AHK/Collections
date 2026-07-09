
;;∙---------------------------------------------------------------------∙

SetTimer, UpdateCheck, 500
GoSub, TrayMenu

;;∙---------------------------------------------------------------------∙
;;∙==============================================∙




;;∙======∙DIRECTIVES & SETTINGS∙==================∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force
SendMode, Input
SetBatchLines -1
SetWinDelay 0
Menu, Tray, Icon, shell32.dll, 245
#NoTrayIcon
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")
SetWorkingDir %A_ScriptDir%

;;∙======∙WEEKLY CONFIGURATION∙=================∙
;;∙------∙Configure your weekly schedule here.
TargetDay := "Sunday"    ;;∙------∙Day of week (Sunday, Monday, Tuesday, etc.).
TargetHour := 6    ;;∙------∙Hour in 12-hour format.
TargetMinute := 00    ;;∙------∙Minute.
TargetAMPM := "AM"    ;;∙------∙AM or PM.

MessageText := "Time To File`nUnemployment"  ;;∙------∙Display Message.

FirefoxPath := "C:\Program Files\Mozilla Firefox\firefox.exe"    ;;∙------∙Path to browser executable (Firefox).
ClaimURL := "https://frances.oregon.gov/Claimant/_/"    ;;∙------∙Site to open.


;;∙======∙WEEKDAY CHECK∙========================∙
;;∙------∙Check immediately on startup.
GoSub, Check_Weekly_Day
;;∙------∙Then check once per hour.
SetTimer, Check_Weekly_Day, 1000
Return

;;∙======∙WEEKDAY CHECK ROUTINE∙================∙
Check_Weekly_Day:
    ;;∙------∙Check if today is the desired day and time, and we haven't run it this week yet.
    FormatTime, CurrentDay, , dddd
    CurrentWeek := A_YYYY . A_WDay    ;;∙------∙Create unique week identifier.
    
    ;;∙------∙Convert target 12-hour time to 24-hour format for comparison.
    Target24Hour := TargetHour
    if (TargetAMPM = "PM" && TargetHour != 12)
        Target24Hour += 12
    else if (TargetAMPM = "AM" && TargetHour = 12)
        Target24Hour := 0
    
    ;;∙------∙Get current time in 24-hour format
    CurrentHour := A_Hour
    CurrentMinute := A_Min
    
    if (CurrentDay = TargetDay && CurrentHour >= Target24Hour && CurrentMinute >= TargetMinute && A_LastWeeklyCheck != CurrentWeek)
    {
        A_LastWeeklyCheck := CurrentWeek    ;;∙------∙Store that it ran this week.
        SoundBeep, 1200, 350
        ;;∙------∙Open the unemployment filing site in Firefox.
        Run, "%FirefoxPath%" "%ClaimURL%"
        ;;∙------∙Show GUI notification.
        GoSub, ShowNotification
    }
Return

;;∙======∙NOTIFICATION∙==========================∙
ShowNotification:
FormattedMessage := StrReplace(MessageText, "`n", "`r`n")
Gui, +AlwaysOnTop -Caption +hwndHGUI +Owner
        +LastFound +E0x02000000 +E0x00080000
Gui, Color, Black
Gui, Font, s24 cYellow Bold, ARIAL
Gui, Margin, 15, 10
Gui, Add, Text, vMainText w320 h80 +Border Center BackgroundTrans, %FormattedMessage%
GuiControlGet, Pos, Pos, MainText
Xpos := PosX + PosW - 20    ;;∙------∙Right edge inside border.
Ypos := PosY + PosH + 5    ;;∙------∙Just below the textbox, small gap.
Gui, Font, s14 cRed Bold
Gui, Add, Text, x%Xpos% y%Ypos% w20 h20 gCloseGUI, X
Gui, Show, Hide
WinGetPos, X, Y, W, H
R := Min(W, H) // 5
WinSet, Region, 0-0 W%W% H%H% R%R%-%R%
Gui, Show, x1285 y275
Return

;;∙======∙GUI DRAG & CLOSE∙======================∙
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}

CloseGUI:
    Gui, Destroy
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

;;∙======∙ASYNCHRONOUS SOUNDBEEP∙=============∙
aSoundBeep(Frequency, Duration) {
    AutoHotkeyPath := A_AhkPath    
    shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec("""" AutoHotkeyPath """ *")
    exec.StdIn.Write("#NoTrayIcon`nSoundBeep, " Frequency "," Duration "`nExitApp")
    exec.StdIn.Close()
}

;;∙======∙RELOAD UPON SCRIPT CHANGE∙============∙
UpdateCheck:    ;;∙------Check if script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload

;;∙======∙TRAY MENU∙============================∙
TrayMenu:
Menu, Tray, Tip, File Employment
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


