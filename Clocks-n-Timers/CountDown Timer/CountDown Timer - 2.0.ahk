
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


;;∙======∙Directives.
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force
SetBatchLines -1
SetWinDelay 0
SetTimer, UpdateCheck, 500
ScriptID := "Count_Down_Timer"
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")
Menu, Tray, Icon, Shell32.dll, 266


^t::    ;;∙------∙🔥∙(Ctrl + T)


;;∙======∙Timer Expiration Action Options.
;;∙------∙Options: Open Folder / Open File / Open App / Beep / Chime / MsgBox
expireAction := "Beep"

;;∙------∙Paths for Open actions (edit as needed).
EnvGet, envUserProfile, USERPROFILE

FolderPath := envUserProfile . "\Downloads\"
FilePath := envUserProfile . "\Downloads\TestScript.ahk"
AppPath := A_WinDir . "\System32\notepad.exe"

MsgBoxMessage := "Your countdown timer has completed!"


;;∙======∙GUI Settings.
guiColor := "Silver"
guiFont := "Segoe UI"
guiFontSize := 14    ;;∙------∙Sets time text (Hr/min/sec), which also adjusts all other controls.
guiFontTextColor := "171717"
guiFontTimeColor := "Blue"
guiSelectSize := (guiFontSize - 4)
guiBoxSize := 8


;;∙======∙Default values for ComboBoxes.
selectedHours := 0
selectedMinutes := 0
selectedSeconds := 0


;;∙======∙Pause / Resume Toggle.
PAUSE:
IF Stop =
{
    Start := A_TickCount
    SetTimer, Clock, 100
    Stop = 0

    Gui, 1:+AlwaysOnTop -Caption +Border +Owner
    Gui, 1:Color, %guiColor%
    Gui, 1:Font, s%guiFontSize% w400 c%guiFontTextColor% q5, %guiFont%
    Gui, 1:Add, Text, x15 y10 vLabels BackgroundTrans, Hours`t Minutes`t   Seconds

        guiFontSize2 := guiFontSize * 2.5
    Gui, 1:Font, s%guiFontSize2% w800 c%guiFontTimeColor% q5, %guiFont%
        yP := 10 + (guiFontSize + 1)
    Gui, 1:Add, Text, x15 y%yP% vStopWatch BackgroundTrans, 00 : 00 : 00


;;∙======∙GUI Height Calculation.
guiH := (guiFontSize + 10) + guiFontSize2 + 10 + (guiSelectSize + 10) + (guiBoxSize + 20) + 30 + (guiFontSize + 8) + 15


;;∙======∙ComboBoxes: Hours, Minutes, Seconds.
        yP += 80
    Gui, 1:Font, s%guiSelectSize% c%guiFontTextColor% w400, %guiFont%
    Gui, 1:Add, Text, x20 y+1, Select Time:

    Gui, 1:Font, s%guiBoxSize% c%guiFontTextColor% w400, %guiFont%

;;∙------∙Hours ComboBox (0–23).
    Gui, 1:Add, ComboBox, x15 y+3 w65 vselectedHours Choose1, % "00|" . Format("{:02}", 1) . "|" . Format("{:02}", 2) . "|" . Format("{:02}", 3) . "|" . Format("{:02}", 4) . "|" . Format("{:02}", 5) . "|" . Format("{:02}", 6) . "|" . Format("{:02}", 7) . "|" . Format("{:02}", 8) . "|" . Format("{:02}", 9) . "|10|11|12|13|14|15|16|17|18|19|20|21|22|23"

;;∙------∙Minutes ComboBox (0–59).
        yP2 := (yP + 3)
    Gui, 1:Add, ComboBox, x+5 y%yP2% w65 vselectedMinutes Choose1, % "00|" . Format("{:02}", 1) . "|" . Format("{:02}", 2) . "|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59"

;;∙------∙Seconds ComboBox (0–59) / Default = 15.
    Gui, 1:Add, ComboBox, x+5 y%yP2% w65 vselectedSeconds Choose16, % "00|" . Format("{:02}", 1) . "|" . Format("{:02}", 2) . "|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59"


;;∙======∙Buttons: Start Timer / Pause & Unpause.
    Gui, 1:Add, Button, x15 y+10 w80 h22 gStartCountdown, Start Timer
    Gui, 1:Add, Button, x+5 yp w121 h22 gPauseCountdown, Pause / Unpause


;;∙======∙Icon Buttons: Options / Reload / Exit.
        iconSize := (guiFontSize + 8)
        yPi := yP-10
    Gui, 1:Add, Picture, x+15 y%yPi% HwndhText BackgroundTrans gShowOptions w%iconSize% h%iconSize% Icon211, Shell32.dll
        GuiTip(hText, "Options")
    Gui, 1:Add, Picture, y+5 HwndhText BackgroundTrans gRELOAD w%iconSize% h%iconSize% Icon239, Shell32.dll
        GuiTip(hText, "Reload")
    Gui, 1:Add, Picture, y+5 HwndhText BackgroundTrans gEXIT w%iconSize% h%iconSize% Icon2, comctl32.dll
        GuiTip(hText, "Exit")

    Gui, 1:Submit, NoHide
    Gui, 1:Show, h%guiH%
}

;;∙======∙First Pause: Freeze Timer.
Else If Stop := !Stop
{
    Start -= A_TickCount
    Soundbeep, 900, 100
}

;;∙======∙Second Pause: Resume Timer.
Else
{
    Start += A_TickCount
    Soundbeep, 1100, 100
}
Return


;;∙======∙Options Popup GUI.
ShowOptions:
    Gui, 2:Destroy

    ;;∙------∙Get position of main GUI to anchor popup nearby.
    Gui, 1:+LastFound
    WinGetPos, mainX, mainY, mainW, mainH

    Gui, 2:+AlwaysOnTop -Caption +Border +Owner1
    Gui, 2:Color, Silver
    Gui, 2:Font, s9 w400 c171717 q5, Segoe UI
    Gui, 2:Add, Text, x10 y8 w140, On Timer Expiration:

    ;;∙------∙Pre-check currently active action.
    openFolderSel := (expireAction = "Open Folder") ? 1 : 0
    openFileSel := (expireAction = "Open File") ? 1 : 0
    openAppSel := (expireAction = "Open App") ? 1 : 0
    beepSel := (expireAction = "Beep") ? 1 : 0
    chimeSel := (expireAction = "Chime") ? 1 : 0
    msgBoxSel := (expireAction = "MsgBox") ? 1 : 0

    Gui, 2:Add, Radio, x10 y+6 w140 vOptOpenFolder Checked%openFolderSel%, Open Folder
    Gui, 2:Add, Radio, x10 y+4 w140 vOptOpenFile Checked%openFileSel%, Open File
    Gui, 2:Add, Radio, x10 y+4 w140 vOptOpenApp Checked%openAppSel%, Open App
    Gui, 2:Add, Radio, x10 y+4 w140 vOptBeep Checked%beepSel%, Beep
    Gui, 2:Add, Radio, x10 y+4 w140 vOptChime Checked%chimeSel%, Chime
    Gui, 2:Add, Radio, x10 y+4 w140 vOptMsgBox Checked%msgBoxSel%, MsgBox

    Gui, 2:Add, Button, x10 y+10 w70 h20 gOptionsSave, OK
    Gui, 2:Add, Button, x+5  yp  w70 h20 gOptionsCancel, Cancel

    ;;∙------∙Show popup below-right of main GUI.
    popX := mainX + mainW - 170
    popY := mainY + mainH
    Gui, 2:Show, x%popX% y%popY% w165 AutoSize, Timer Options
Return


;;∙======∙Save Options.
OptionsSave:
    Gui, 2:Submit, NoHide
    if OptOpenFolder
        expireAction := "Open Folder"
    else if OptOpenFile
        expireAction := "Open File"
    else if OptOpenApp
        expireAction := "Open App"
    else if OptBeep
        expireAction := "Beep"
    else if OptChime
        expireAction := "Chime"
    else if OptMsgBox
        expireAction := "MsgBox"
    Gui, 2:Destroy
Return


;;∙======∙Cancel Options.
OptionsCancel:
    Gui, 2:Destroy
Return


;;∙======∙Pause / Unpause Countdown.
isPaused := false

PauseCountdown:
    if !isPaused
    {
        isPaused := true
        SetTimer, Clock, Off
        remainingTime := totalTime - ((A_TickCount - Start) // 1000)
        GuiControl, 1:, PauseCountdown, Resume Countdown
    }
    else
    {
        isPaused := false
        Start := A_TickCount
        totalTime := remainingTime
        SetTimer, Clock, 100
        GuiControl, 1:, PauseCountdown, Pause Countdown
    }
Return


;;∙======∙Start Countdown.
isCounting := false
StartCountdown:
    Gui, 1:Submit, NoHide
    totalTime := (selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds
    Start := A_TickCount
    isCounting := true
    isPaused := false
    Stop := 0
    SetTimer, Clock, 100
    GuiControl, 1:, PauseCountdown, Pause Countdown
Return


;;∙======∙Clock Tick: Update Countdown Display.
Clock:
    elapsedTime := (A_TickCount - Start) // 1000
    remainingTime := totalTime - elapsedTime

    if (remainingTime <= 0 && isCounting)
    {
        SetTimer, Clock, Off
        GuiControl, 1:, StopWatch, 00 : 00 : 00
        isCounting := false
        GoSub, ExpirationAction
        Return
    }

    hours := Format("{:02}", Floor(remainingTime / 3600))
    minutes := Format("{:02}", Floor(Mod(remainingTime, 3600) / 60))
    seconds := Format("{:02}", Mod(remainingTime, 60))

    GuiControl, 1:, StopWatch, % hours " : " minutes " : " seconds
Return


;;∙======∙Run Expire Action.
ExpirationAction:
    Gui, 1:-AlwaysOnTop
    if (expireAction = "Beep")
    {
        SoundBeep, 1150, 150
    }
    else if (expireAction = "Chime")
    {
        SoundPlay, *64
    }
    else if (expireAction = "MsgBox")
    {
        MsgBox, 64, Timer Expired, %MsgBoxMessage%
    }
    else if (expireAction = "Open Folder")
    {
        if (FolderPath != "")
            Run, explorer.exe %FolderPath%
        else
            MsgBox, 48, Options Error, No folder path set. Please edit FolderPath in the script.
    }
    else if (expireAction = "Open File")
    {
        if (FilePath != "")
            Run, %FilePath%
        else
            MsgBox, 48, Options Error, No file path set. Please edit FilePath in the script.
    }
    else if (expireAction = "Open App")
    {
        if (AppPath != "")
            Run, %AppPath%
        else
            MsgBox, 48, Options Error, No app path set. Please edit AppPath in the script.
    }
    Gui, 1:+AlwaysOnTop
        Gui, 1:Show
Return


;;∙======∙Tooltip Helper Function.
GuiTip(hCtrl, text:="")
{
    hGui := text!="" ? DlLCall("GetParent", "Ptr", hCtrl) : hCtrl
    static hTip
    if !hTip
    {
        hTip := DllCall("CreateWindowEx", "UInt", 0x8, "Str", "tooltips_class32"
             , "Ptr", 0, "UInt", 0x80000002
             , "Int", 0x80000000, "Int", 0x80000000, "Int", 0x80000000, "Int", 0x80000000
             , "Ptr", hGui, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Ptr")

        DllCall("SendMessage", "Ptr", hTip, "Int", 0x0418, "Ptr", 0, "Ptr", 0)
        if (A_OsVersion == "WIN_XP")
            GuiTip(hGui)
    }
    static sizeof_TOOLINFO := 24 + (6 * A_PtrSize)
    VarSetCapacity(TOOLINFO, sizeof_TOOLINFO, 0)
    , NumPut(sizeof_TOOLINFO, TOOLINFO, 0, "UInt")
    , NumPut(0x11, TOOLINFO, 4, "UInt")
    , NumPut(hGui, TOOLINFO, 8, "Ptr")
    , NumPut(hCtrl, TOOLINFO, 8 + A_PtrSize, "Ptr")
    , NumPut(&text, TOOLINFO, 24 + (3 * A_PtrSize), "Ptr")
    static TTM_ADDTOOL := A_IsUnicode ? 0x0432 : 0x0404
    return DllCall("SendMessage", "Ptr", hTip, "Int", TTM_ADDTOOL, "Ptr", 0, "Ptr", &TOOLINFO)
}
Return


;;∙======∙Gui Drag.
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}
Return

;;∙======∙Reload Script.
RELOAD:
    Reload
Return

;;∙======∙Exit Script.
EXIT:
    ExitApp
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
;    RELOAD:    ;;∙------∙Script call.
        Soundbeep, 1200, 250
    Reload
Return

 ;;∙------∙EXIT∙----------------------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
;    EXIT:    ;;∙------∙Script call.
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
Count_Down_Timer:    ;;∙------∙Suspends hotkeys then pauses script.
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

