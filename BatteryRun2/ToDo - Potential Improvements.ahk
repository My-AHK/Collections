
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙--------∙Origins∙-------------------------∙
» Author:  
» Original Source:  
» 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TEMPLATE"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙🔥 HotKey 🔥∙===========================================∙
^t::    ;;∙------∙(Ctrl+T) 
    Soundbeep, 1100, 100
;;∙============================================================∙




/*
Expanding the GUI (Graphical User Interface) can make the script more user-friendly and versatile, allowing users to interact with the script in real-time. Below are a few ideas for extending the GUI to improve functionality, user interaction, and control over the script's behavior:
*/

;;∙============================================================∙
;;∙------∙1. Add Command Inputs for Customization
;;∙------• Feature: Allow the user to enter or modify the online and offline commands directly from the GUI.
;;∙------• Benefit: Users can specify different commands without modifying the script file.

Gui, Add, Text, x10 y10 w120 h30, Online Command:
Gui, Add, Edit, vOnlineCmd x140 y10 w200 h30, 
Gui, Add, Text, x10 y50 w120 h30, Offline Command:
Gui, Add, Edit, vOfflineCmd x140 y50 w200 h30, 
Gui, Add, Button, gSaveCommands x140 y90 w100 h30, Save Commands
Gui, Show, w400 h150, BatteryRun Settings
Return

SaveCommands:
    Gui, Submit
    ; Save the commands to variables or a file for future use
    MsgBox, Commands saved! Online: %OnlineCmd% Offline: %OfflineCmd%
Return
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙2. Add a Status Indicator
;;∙------• Feature: Display the current power state (plugged in or on battery) in real-time on the GUI.
;;∙------• Benefit: Provides immediate visual feedback about the power state, letting the user know what state the system is in.

Gui, Add, Text, vPowerStatusText x10 y130 w200 h30, Power Status: Unknown
Gui, Show, w400 h200, BatteryRun Status
Return

GETSYSTEMPOWERSTATUS:
    ; Assuming you already have code for checking power state
    If (acLineStatus = 1)
        GuiControl,, PowerStatusText, Power Status: Plugged In
    Else
        GuiControl,, PowerStatusText, Power Status: On Battery
Return
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙3. Add a Button for Manual Command Execution
;;∙------• Feature: Provide a button that allows the user to manually execute the online or offline command.
;;∙------• Benefit: Users can immediately run their commands regardless of the power state.

Gui, Add, Button, gRunOnlineCommand x10 y170 w180 h30, Run Online Command
Gui, Add, Button, gRunOfflineCommand x200 y170 w180 h30, Run Offline Command
Gui, Show, w400 h250, Manual Command Controls
Return

RunOnlineCommand:
    Run, %OnlineCmd%
    MsgBox, Executing Online Command: %OnlineCmd%
Return

RunOfflineCommand:
    Run, %OfflineCmd%
    MsgBox, Executing Offline Command: %OfflineCmd%
Return
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙4. Add Logging Functionality
;;∙------• Feature: Include a logging area in the GUI to display the actions being taken (e.g., when commands are executed or power state changes).
;;∙------• Benefit: Users can see a log of the script's activity, which helps in debugging or understanding what actions were taken.

Gui, Add, Edit, vLogOutput x10 y210 w380 h100 ReadOnly, 
Gui, Show, w400 h320, Log Output
Return

GETSYSTEMPOWERSTATUS:
    ; Assuming the power state is checked here
    LogMessage := "Power state changed. Status: " (acLineStatus ? "Plugged In" : "On Battery")
    GuiControl,, LogOutput, %LogMessage%`n%LogOutput%
Return
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙5. Add Options for Sound or Notifications
;;∙------• Feature: Allow the user to toggle whether they want to play a sound or show a notification when the power state changes.
;;∙------• Benefit: Gives users more control over how they are notified.

Gui, Add, Checkbox, vPlaySound x10 y320 w180 h30, Play Sound on Power Change
Gui, Add, Checkbox, vShowNotification x10 y350 w180 h30, Show Notification on Power Change
Gui, Show, w400 h400, Notifications Settings
Return

GETSYSTEMPOWERSTATUS:
    If PlaySound
    {
        ; Play sound logic here
    }
    If ShowNotification
    {
        ; Show notification logic here
    }
Return
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙6. Add Timer Controls for Command Frequency
;;∙------• Feature: Add controls to let the user set how frequently the script checks for power state
;;∙------• Benefit: Allows users to adjust the behavior of the script based on their needs (e.g., for more responsiveness or lower system impact).

Gui, Add, Text, x10 y380 w150 h30, Check Interval (seconds):
Gui, Add, Edit, vCheckInterval x160 y380 w50 h30, 10
Gui, Add, Button, gSetTimer x220 y380 w100 h30, Set Interval
Gui, Show, w400 h450, Timer Controls
Return

SetTimer, GETSYSTEMPOWERSTATUS, % CheckInterval * 1000
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙7. Allow Configuration of Power State Actions
;;∙------• Feature: Add options to configure different actions for each power state (e.g., different commands or files to run for plugged-in vs. battery).
;;∙------• Benefit: Makes the script more flexible and user-configurable for varying use cases.

Gui, Add, Text, x10 y410 w150 h30, Online Command:
Gui, Add, Edit, vOnlineCmd x160 y410 w200 h30, 
Gui, Add, Text, x10 y450 w150 h30, Offline Command:
Gui, Add, Edit, vOfflineCmd x160 y450 w200 h30, 
Gui, Add, Button, gSaveCommands x160 y490 w100 h30, Save Settings
Gui, Show, w400 h500, Configuration
Return
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙8. Add a "Quit" Button for Easy Script Exit
;;∙------• Feature: A "Quit" button that allows the user to exit the script gracefully.
;;∙------• Benefit: Provides a clear, user-friendly way to exit the script without having to close the script window manually.

Gui, Add, Button, gExitApp x10 y500 w100 h30, Quit
Gui, Show, w400 h550, Exit Control
Return

ExitApp:
    ExitApp
Return
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙9. Allow Multiple Profiles for Different Scenarios
;;∙------• Feature: Provide users the ability to create multiple profiles (e.g., "Work", "Home", "Travel") with different commands for each profile.
;;∙------• Benefit: Users can quickly switch between different power state handling scenarios.

Gui, Add, DropDownList, vProfileSelector x10 y530 w150 h30, Work|Home|Travel
Gui, Add, Button, gLoadProfile x170 y530 w100 h30, Load Profile
Gui, Show, w400 h600, Profile Selector
Return

LoadProfile:
    If (ProfileSelector = "Work")
        ; Load work-related settings
    Else If (ProfileSelector = "Home")
        ; Load home-related settings
    Else If (ProfileSelector = "Travel")
        ; Load travel-related settings
Return
;;∙============================================================∙




;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙EDIT \ RELOAD / EXIT∙===================================∙
;;∙-----------------------∙EDIT \ RELOAD / EXIT∙--------------------------∙
RETURN
;;∙-------∙EDIT∙-------∙EDIT∙------------∙
Script·Edit:    ;;∙------∙Menu Call.
    Edit
Return
;;∙------∙RELOAD∙----∙RELOAD∙-------∙
^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        SoundBeep, 1100, 75
        Soundbeep, 1200, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        Soundbeep, 1100, 75
        Soundbeep, 1000, 100
    ExitApp
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Gui Drag Pt 2∙==========================================∙
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Script Updater∙=========================================∙
UpdateCheck:    ;;∙------Check if the script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute Sub∙======================================∙
AutoExecute:
#MaxThreadsPerHotkey 3
#NoEnv
;;∙------∙#NoTrayIcon
#Persistent
#SingleInstance, Force
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.
SetBatchLines -1
SetTimer, UpdateCheck, 500
SetTitleMatchMode 2
SetWinDelay 0
Menu, Tray, Icon, imageres.dll, 3
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Tray Menu∙============================================∙
TrayMenu:
Menu, Tray, Tip, %ScriptID%
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Suspend / Pause, %ScriptID%    ;;∙------∙Script Header.
Menu, Tray, Icon, Suspend / Pause, shell32, 28
Menu, Tray, Default, Suspend / Pause    ;;∙------∙Makes Bold.
;;∙------∙Script∙Extentions∙------------∙
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
;;∙------∙Script∙Options∙---------------∙
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
;;------------------------------------------∙
Documentation:
    Run, "C:\Program Files\AutoHotkey\AutoHotkey.chm"
Return
ShowKeyHistory:
    KeyHistory
Return
ShowWindowSpy:
    Run, "C:\Program Files\AutoHotkey\WindowSpy.ahk"
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙MENU CALLS∙==========================================∙
TEMPLATE:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
    Suspend
    Soundbeep, 700, 100
    Pause
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙TRAY MENU POSITION∙==================================∙
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20
Return
;;∙------∙TRAY MENU POSITION FUNTION∙------∙
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
;;∙============================================================∙

;;∙------------------------------------------------------------------------------------------∙
;;∙========================∙SCRIPT END∙=========================∙
;;∙------------------------------------------------------------------------------------------∙

