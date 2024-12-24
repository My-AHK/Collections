
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙--------∙Origins∙-------------------------∙
» Original Author:  skrommel
» Original Source:  https://www.dcmembers.com/skrommel/download/batteryrun/
» BatteryRun.exe "notepad.exe" "taskkill /IM notepad.exe & calc.exe"    ;;<∙---∙ExampleSample
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "BatteryRun"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
If 0=0    ;;∙------∙Always true, triggers About routine.
    GoSub, About    ;;∙------∙Calls About routine.

onlinecommand=%1%    ;;∙------∙Initializes onlinecommand with 1st command-line parameter.
offlinecommand=%2%    ;;∙------∙Initializes offlinecommand with 2nd command-line parameter.

/*∙-----------------∙COMMAND LINE SETTINGS∙------------------------------------∙
Sets The Command For Both Online & Offline States∙------------∙
•[Online]∙Opens Notepad when the system is plugged in.
•[Offline]∙Terminates Notepad and opens Calculator when using battery power.
  ∙-------------------------------------------------------------------------------------------∙
*/

onlinecommand := "BatteryRun.exe ""notepad.exe"" ""taskkill /IM notepad.exe & calc.exe"""
offlinecommand := "BatteryRun.exe ""notepad.exe"" ""taskkill /IM notepad.exe & calc.exe"""
;;∙------------------------∙(* see script end for other examples *)∙----------------∙

;;∙------------------------------------------------∙
VarSetCapacity(powerStatus, 1+1+1+1+4+4)    ;;∙------∙Allocates memory for powerStatus variable.
    acLineStatus=FirstRun    ;;∙------∙Initializes acLineStatus to "FirstRun".
    SetTimer, GETSYSTEMPOWERSTATUS, 1000    ;;∙------∙Sets a timer to call GETSYSTEMPOWERSTATUS every 1 second.
Return
;;∙------------------------∙
GETSYSTEMPOWERSTATUS:    ;;∙------∙Defines the GETSYSTEMPOWERSTATUS label.
    success := DllCall("GetSystemPowerStatus", "UInt", &powerStatus)    ;;∙------∙Calls GetSystemPowerStatus API function.
    If (ErrorLevel != 0 Or success = 0)    ;;∙------∙Checks if function call failed.
    {
        MsgBox,, %ScriptID%, Can't get the power state!    ;;∙------∙Displays an error message if function call failed.
        ExitApp    ;;∙------∙Exits the script.
    }
    oldacLineStatus := acLineStatus    ;;∙------∙Saves current acLineStatus value to oldacLineStatus.
    acLineStatus := GetInteger(powerStatus, 0, false, 1)    ;;∙------∙Extracts AC line status from powerStatus variable.
    If (acLineStatus <> oldacLineStatus And oldacLineStatus <> "FirstRun")    ;;∙------∙Checks if AC line status has changed.
    {
        If acLineStatus = 1    ;;∙------∙If system is online (plugged in).
        {
            SplitPath, onlinecommand, name, dir, ext, name_no_ext, drive    ;;∙------∙Splits online command into its components.
            If ext In wav    ;;∙------∙If the command file extension is "wav".
                SoundPlay, %onlinecommand%    ;;∙------∙Plays online sound file.
            Else
                Run, %onlinecommand%, , , UseErrorLevel    ;;∙------∙Runs online command.
        }
        Else If acLineStatus = 0    ;;∙------∙If system is offline (on battery).
        {
            SplitPath, offlinecommand, name, dir, ext, name_no_ext, drive    ;;∙------∙Splits offline command into its components.
            If ext In wav    ;;∙------∙If the command file extension is "wav".
                SoundPlay, %offlinecommand%    ;;∙------∙Plays offline sound file.
            Else
                Run, %offlinecommand%, , , UseErrorLevel    ;;∙------∙Runs offline command.
        }
    }
Return
;;∙------------------------∙
GetInteger(ByRef @source, _offset = 0, _bIsSigned = false, _size = 4)    ;;∙------∙Defines GetInteger function.
{
    Local result    ;;∙------∙Declares a local variable result.
    Loop %_size%    ;;∙------∙Loops _size times (default is 4).
    {
        result += *(&@source + _offset + A_Index - 1) << 8 * (A_Index - 1)    ;;∙------∙Calculates integer value from byte data.
    }
    If (!_bIsSigned OR _size > 4 OR result < 0x80000000)    ;;∙------∙Checks if value should be unsigned.
        Return result    ;;∙------∙Returns the result.
    Return -(0xFFFFFFFF - result + 1)    ;;∙------∙Returns signed result if necessary.
}
;;∙------------------------∙
About:
    Gui, Destroy
    Gui, +AlwaysOnTop
    Gui, Margin, 20, 20
    Gui, Font, cRed Bold
    Gui, Color, Black
    Gui, Add, Text, x10 y10, Hello
    Gui, Font, cWhite
    Gui, Add, Text, x10 y+5, • Run commands when the power plug is connected or disconnected.
    Gui, Add, Text, x10 y+10, • Command line:
    Gui, Add, Text, x20 y+5, BatteryRun.exe "<connect_command>" "<disconnect_command>"
    Gui, Font, cWhite
    Gui, Add, Text, x10 y+10, • Example 1: 
    Gui, Font, cSilver
    Gui, Add, Text, x20 y+5, BatteryRun.exe "notepad.exe" "calc.exe"
    Gui, Add, Text, x30 y+5, + Opens Notepad when the system is plugged in.
    Gui, Add, Text, x30 y+5, + Opens the Calculator when the system switches to battery.
    Gui, Font, cWhite
    Gui, Add, Text, x10 y+10, • Example 2: 
    Gui, Font, cSilver
    Gui, Add, Text, x20 y+5, BatteryRun.exe "notepad.exe" "taskkill /IM notepad.exe & calc.exe"
    Gui, Add, Text, x30 y+5, + Opens Notepad when the system is plugged in.
    Gui, Add, Text, x30 y+5, + Uses taskkill to terminate Notepad by its process name (notepad.exe).
    Gui, Add, Text, x30 y+5, + After that, opens Calculator (calc.exe).
    Gui, Add, Button, x10 y+20 Default w75, OK
    Gui, Show, , %ScriptID%
Return
;;∙------------------------∙
ButtonOK:
    ExitApp
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
BatteryRun:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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


/*∙=====∙15  Examples∙========================================∙

;;∙---∙ex #1∙---∙Play Sound on Power Change
BatteryRun.exe "online.wav" "offline.wav"
  • Plays the sound online.wav when the system is plugged into power.
  • Plays the sound offline.wav when the system switches to battery.

;;∙---∙ex #2∙---∙Open Applications
BatteryRun.exe "notepad.exe" "calc.exe"
  • Opens Notepad when the system is plugged in.
  • Opens the Calculator when the system switches to battery.

;;∙---∙ex #3∙---∙Run Scripts
BatteryRun.exe "C:\Scripts\backup.bat" "C:\Scripts\close_apps.bat"
  • Runs backup.bat when the system is plugged in (e.g., to start a backup process).
  • Runs close_apps.bat when the system switches to battery (e.g., to close resource-intensive applications).

;;∙---∙ex #4∙---∙Network Commands
BatteryRun.exe "net start MyService" "net stop MyService"
  • Starts a network service when plugged in.
  • Stops the service when switching to battery to conserve resources.

;;∙---∙ex #5∙---∙Adjust System Settings
BatteryRun.exe "powercfg /setactive HighPerformance" "powercfg /setactive PowerSaver"
  • Switches to the High Performance power plan when plugged in.
  • Switches to the Power Saver plan when running on battery.

;;∙---∙ex #6∙---∙Control External Devices
BatteryRun.exe "start C:\Scripts\TurnOnLight.exe" "start C:\Scripts\TurnOffLight.exe"
  • Runs a script to turn on external lights when plugged in.
  • Runs a script to turn them off when switching to battery.

;;∙---∙ex #7∙---∙Adjust Volume Based on Power State
BatteryRun.exe "nircmd.exe setsysvolume 65535" "nircmd.exe setsysvolume 32768"
  • Sets the system volume to maximum (65535) when plugged in.
  • Lowers the system volume to 50% (32768) when running on battery.

;;∙---∙ex #8∙---∙Launch Browser and Close It on Battery
BatteryRun.exe "chrome.exe" "taskkill /IM chrome.exe"
  • Opens Google Chrome when plugged in.
  • Closes Chrome when switching to battery power.

;;∙---∙ex #9∙---∙Activate and Deactivate File Sync
BatteryRun.exe "C:\SyncTools\sync_on.bat" "C:\SyncTools\sync_off.bat"
  • Runs a batch file to start file synchronization (sync_on.bat) when plugged in.
  • Runs another batch file to stop synchronization (sync_off.bat) when on battery.

;;∙---∙ex #10∙---∙Display Notifications on Power Change
BatteryRun.exe "msg * 'System is now plugged in!'" "msg * 'Running on battery power!'"
  • Displays a pop-up notification indicating that the system is plugged in.
  • Displays another notification when it switches to battery.

;;∙---∙ex #11∙---∙Toggle External Monitor
BatteryRun.exe "DisplaySwitch.exe /extend" "DisplaySwitch.exe /internal"
  • Extends the display to an external monitor when plugged in.
  • Switches to the laptop's internal display when on battery.

;;∙---∙ex #12∙---∙Change Screen Brightness
BatteryRun.exe "powershell.exe -Command \"(Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,100)\"" "powershell.exe -Command \"(Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,40)\""
  • Sets the screen brightness to 100% when plugged in.
  • Reduces the brightness to 40% when on battery.

;;∙---∙ex #13∙---∙Enable and Disable Background Tasks
BatteryRun.exe "schtasks /Run /TN 'BackgroundTask'" "schtasks /End /TN 'BackgroundTask'"
  • Starts a scheduled background task when plugged in.
  • Stops the same task when running on battery.

;;∙---∙ex #14∙---∙Switch Audio Profiles
BatteryRun.exe "C:\AudioTools\set_high_performance.bat" "C:\AudioTools\set_low_power.bat"
  • Switches to a high-performance audio profile when plugged in.
  • Switches to a low-power audio profile when on battery.

;;∙---∙ex #15∙---∙Backup Files and Shutdown on Battery
BatteryRun.exe "C:\BackupTools\start_backup.bat" "C:\BackupTools\stop_backup.bat & shutdown /s /t 30"
  • Initiates a backup process when plugged in.
  • Stops the backup and schedules a shutdown after 30 seconds when on battery.

*/