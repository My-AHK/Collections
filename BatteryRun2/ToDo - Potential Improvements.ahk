
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
Expanding the GUI (Graphical User Interface) can make the script more user-friendly and versatile, allowing users to interact with the script in real-time. Below are 36 ideas for extending the GUI to improve functionality, user interaction, and control over the script's behavior:
*/

;;∙============================================================∙
;;∙------∙1. Add Command Inputs for Customization.
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
    ;;∙------∙Save the commands to variables or a file for future use.
    MsgBox, Commands saved! Online: %OnlineCmd% Offline: %OfflineCmd%
Return


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙2. Add a Status Indicator.
;;∙------• Feature: Display the current power state (plugged in or on battery) in real-time on the GUI.
;;∙------• Benefit: Provides immediate visual feedback about the power state, letting the user know what state the system is in.

Gui, Add, Text, vPowerStatusText x10 y130 w200 h30, Power Status: Unknown
Gui, Show, w400 h200, BatteryRun Status
Return

GETSYSTEMPOWERSTATUS:
    ;;∙------∙Assuming you already have code for checking power state.
    If (acLineStatus = 1)
        GuiControl,, PowerStatusText, Power Status: Plugged In
    Else
        GuiControl,, PowerStatusText, Power Status: On Battery
Return


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙3. Add a Button for Manual Command Execution.
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
;;∙------∙4. Add Logging Functionality.
;;∙------• Feature: Include a logging area in the GUI to display the actions being taken (e.g., when commands are executed or power state changes).
;;∙------• Benefit: Users can see a log of the script's activity, which helps in debugging or understanding what actions were taken.

Gui, Add, Edit, vLogOutput x10 y210 w380 h100 ReadOnly, 
Gui, Show, w400 h320, Log Output
Return

GETSYSTEMPOWERSTATUS:
    ;;∙------∙Assuming the power state is checked here.
    LogMessage := "Power state changed. Status: " (acLineStatus ? "Plugged In" : "On Battery")
    GuiControl,, LogOutput, %LogMessage%`n%LogOutput%
Return
;;∙------------------------------------------------------------------------------------------∙
;;∙------∙5. Add Options for Sound or Notifications.
;;∙------• Feature: Allow the user to toggle whether they want to play a sound or show a notification when the power state changes.
;;∙------• Benefit: Gives users more control over how they are notified.

Gui, Add, Checkbox, vPlaySound x10 y320 w180 h30, Play Sound on Power Change
Gui, Add, Checkbox, vShowNotification x10 y350 w180 h30, Show Notification on Power Change
Gui, Show, w400 h400, Notifications Settings
Return

GETSYSTEMPOWERSTATUS:
    If PlaySound
    {
        ;;∙------∙Play sound logic here...
    }
    If ShowNotification
    {
        ;;∙------∙Show notification logic here...
    }
Return


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙6. Add Timer Controls for Command Frequency.
;;∙------• Feature: Add controls to let the user set how frequently the script checks for power state.
;;∙------• Benefit: Allows users to adjust the behavior of the script based on their needs (e.g., for more responsiveness or lower system impact).

Gui, Add, Text, x10 y380 w150 h30, Check Interval (seconds):
Gui, Add, Edit, vCheckInterval x160 y380 w50 h30, 10
Gui, Add, Button, gSetTimer x220 y380 w100 h30, Set Interval
Gui, Show, w400 h450, Timer Controls
Return

SetTimer, GETSYSTEMPOWERSTATUS, % CheckInterval * 1000


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙7. Allow Configuration of Power State Actions.
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
;;∙------∙8. Add a "Quit" Button for Easy Script Exit.
;;∙------• Feature: A "Quit" button that allows the user to exit the script gracefully.
;;∙------• Benefit: Provides a clear, user-friendly way to exit the script without having to close the script window manually.

Gui, Add, Button, gExitApp x10 y500 w100 h30, Quit
Gui, Show, w400 h550, Exit Control
Return

ExitApp:
    ExitApp
Return


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙9. Allow Multiple Profiles for Different Scenarios.
;;∙------• Feature: Provide users the ability to create multiple profiles (e.g., "Work", "Home", "Travel") with different commands for each profile.
;;∙------• Benefit: Users can quickly switch between different power state handling scenarios.

Gui, Add, DropDownList, vProfileSelector x10 y530 w150 h30, Work|Home|Travel
Gui, Add, Button, gLoadProfile x170 y530 w100 h30, Load Profile
Gui, Show, w400 h600, Profile Selector
Return

LoadProfile:
    If (ProfileSelector = "Work")
        ;;∙------∙Load work-related settings.
    Else If (ProfileSelector = "Home")
        ;;∙------∙Load home-related settings.
    Else If (ProfileSelector = "Travel")
        ;;∙------∙Load travel-related settings.
Return


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙10. Add Default Command Reset Option.
;;∙------• Feature: Provide a button in the GUI to reset the online and offline commands to their default values.
;;∙------• Benefit: Allows users to revert quickly to a known working state if customizations cause issues.

Gui, Add, Button, gResetCommands x10 y570 w150 h30, Reset to Defaults
Gui, Show, w400 h650, Reset Commands
Return

ResetCommands:
    OnlineCmd := "BatteryRun.exe ""notepad.exe"" ""taskkill /IM notepad.exe & calc.exe"""
    OfflineCmd := "BatteryRun.exe ""notepad.exe"" ""taskkill /IM notepad.exe & calc.exe"""
    MsgBox, Commands reset to defaults!
Return
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙11. Provide a Reset to Defaults Option.
;;∙------• Feature: Add a button to reset all user settings to their default values.
;;∙------• Benefit: Allows users to revert changes quickly if they make mistakes.

ResetDefaults:
    GuiControl,, OnlineCmd, DefaultOnlineCommand
    GuiControl,, OfflineCmd, DefaultOfflineCommand
    MsgBox, Settings have been reset to defaults.
Return


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙12. Add a Comprehensive Reset to Defaults Option.
;;∙------• Feature: Provide a single reset option that restores all user-configurable settings (commands, profiles, timer intervals, notifications, etc.) to their original default values.
;;∙------• Benefit: Simplifies restoring the script to its initial state, ensuring all features revert to their default settings with one action.

Gui, Add, Button, gResetToDefaults x10 y550 w150 h30, Reset to Defaults
Gui, Show, w400 h600, Settings

ResetToDefaults:
    ;;∙------∙Reset commands.
    OnlineCmd := "BatteryRun.exe ""notepad.exe"" ""taskkill /IM notepad.exe & calc.exe"""
    OfflineCmd := "BatteryRun.exe ""notepad.exe"" ""taskkill /IM notepad.exe & calc.exe"""

    ;;∙------∙Reset other settings.
    CheckInterval := 10
    SilentMode := 0
    GuiControl,, OnlineCmdInput, %OnlineCmd%
    GuiControl,, OfflineCmdInput, %OfflineCmd%
    GuiControl,, CheckIntervalInput, %CheckInterval%
    GuiControl,, SilentModeCheckbox, 0    ;;∙------∙Uncheck the silent mode option.

    ;;∙------∙Notify user.
    MsgBox, All settings have been reset to their defaults!
Return


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙13. Include a Pause/Resume Feature.
;;∙------• Feature: Add a button to pause or resume the script's power state monitoring.
;;∙------• Benefit: Allows the user to temporarily disable the script's functionality without exiting it.

Gui, Add, Button, gTogglePause x10 y610 w150 h30, Pause Monitoring
Gui, Show, w400 h700, Pause/Resume Monitoring
Return

TogglePause:
    If (PauseFlag := !PauseFlag)
    {
        SetTimer, GETSYSTEMPOWERSTATUS, Off
        GuiControl,, TogglePause, Resume Monitoring
    }
    Else
    {
        SetTimer, GETSYSTEMPOWERSTATUS, On
        GuiControl,, TogglePause, Pause Monitoring
    }
Return


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙14. Add Export and Import Settings.
;;∙------• Feature: Enable users to save their configurations to a file and reload them later.
;;∙------• Benefit: 

Gui, Add, Button, gExportSettings x10 y650 w150 h30, Export Settings
Gui, Add, Button, gImportSettings x170 y650 w150 h30, Import Settings
Gui, Show, w400 h750, Export/Import Settings
Return

ExportSettings:
    FileAppend, OnlineCommand=%OnlineCmd%`nOfflineCommand=%OfflineCmd%, Config.ini
    MsgBox, Settings exported to Config.ini
Return

ImportSettings:
    IfNotExist, Config.ini
    {
        MsgBox, Config.ini not found!
        Return
    }
    Loop, Read, Config.ini
    {
        StringSplit, KeyValue, A_LoopReadLine, =
        %KeyValue1% := KeyValue2
    }
    MsgBox, Settings imported successfully!
Return


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙15. Add Help/Documentation Tab.
;;∙------• Feature: Include a tab in the GUI with usage instructions, examples, and troubleshooting tips.
;;∙------• Benefit: Helps new users understand and utilize the script effectively.

Gui, Add, Tab, x10 y690 w380 h120, Help|Examples|Troubleshooting
Gui, Tab, Help
Gui, Add, Text, x20 y720, Use this script to manage power state commands.
Gui, Tab, Examples
Gui, Add, Text, x20 y740, Example: BatteryRun.exe "notepad.exe" "calc.exe"
Gui, Tab, Troubleshooting
Gui, Add, Text, x20 y760, Issue: Commands not running? Check file paths.
Gui, Show, w400 h850, Help Section
Return


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙16. Add Confirmation Prompts.
;;∙------• Feature: Confirm actions such as exiting the script or resetting commands.
;;∙------• Benefit: Prevents accidental actions that could disrupt functionality.

ExitApp:
    If (MsgBox("Are you sure you want to exit?", 4) == "Yes")
        ExitApp
Return


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙17. Add a Real-Time Command Preview.
;;∙------• Feature: Display the constructed command string before execution.
;;∙------• Benefit: Allows users to verify the command is correct before it runs.

Gui, Add, Text, x10 y770 w380 h30, Current Command: 
Gui, Add, Edit, ReadOnly vCurrentCommand x10 y800 w380 h30, %OnlineCmd%
Gui, Show, w400 h880, Command Preview
Return


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙18. Add a "Test Command" Button.
;;∙------• Feature: Let users test the online/offline commands directly from the GUI.
;;∙------• Benefit: Ensures the commands work as expected without waiting for power state changes.

Gui, Add, Button, gTestOnlineCommand x10 y870 w150 h30, Test Online Command
Gui, Add, Button, gTestOfflineCommand x170 y870 w150 h30, Test Offline Command
Gui, Show, w400 h950, Test Commands
Return

TestOnlineCommand:
    Run, %OnlineCmd%
    MsgBox, Online Command executed: %OnlineCmd%
Return

TestOfflineCommand:
    Run, %OfflineCmd%
    MsgBox, Offline Command executed: %OfflineCmd%
Return


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙19. Add Notifications for Command Completion.
;;∙------• Feature: Notify the user when an online/offline command finishes executing.
;;∙------• Benefit: Provides feedback that the action was successful.

RunOnlineCommand:
    Run, %OnlineCmd%
    MsgBox, Online Command completed!
Return

RunOfflineCommand:
    Run, %OfflineCmd%
    MsgBox, Offline Command completed!
Return


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙20. Add Error Handling for Commands.
;;∙------• Feature: Validate and test online/offline commands before execution, providing feedback to the user if they fail.
;;∙------• Benefit: Prevents unexpected script failures and provides helpful debugging information.

RunCommand(Command) {
    Try {
        Run, %Command%
        MsgBox, Command executed successfully: %Command%
    } Catch e {
        MsgBox, Error executing command: %Command%`nDetails: %e%
    }
}

; Replace all `Run, %Command%` lines with:
RunCommand(onlinecommand)
RunCommand(offlinecommand)


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙21. Add Command Validation.
;;∙------• Feature: Validate entered commands to ensure they are executable.
;;∙------• Benefit: Prevents errors caused by invalid or missing commands.

SaveCommands:
    Gui, Submit
    If (OnlineCmd = "" Or OfflineCmd = "")
    {
        MsgBox, Please enter both commands before saving.
        Return
    }
    MsgBox, Commands saved successfully!
Return


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙22. Add Dark/Light Theme Options.
;;∙------• Feature: Feature: Allow users to switch between dark and light themes for the GUI.
;;∙------• Benefit: Improves user experience by providing a customizable interface.

Gui, Add, Button, gToggleTheme x10 y910 w150 h30, Switch to Light Theme
Gui, Show, w400 h1000, Theme Toggle
Return

ToggleTheme:
    If (CurrentTheme := !CurrentTheme)
    {
        Gui, Color, White
        GuiControl,, ToggleTheme, Switch to Dark Theme
    }
    Else
    {
        Gui, Color, Black
        GuiControl,, ToggleTheme, Switch to Light Theme
    }
Return


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙23. Add Scheduling Feature.
;;∙------• Feature: Schedule commands to run at specific times regardless of power state.
;;∙------• Benefit: Expands the script's functionality beyond power state monitoring.

Gui, Add, Text, x10 y960 w150 h30, Schedule Time (HH:MM):
Gui, Add, Edit, vScheduleTime x160 y960 w100 h30, 
Gui, Add, Button, gSetSchedule x270 y960 w100 h30, Set Schedule
Gui, Show, w400 h1050, Scheduling
Return

SetSchedule:
    Gui, Submit
    SetTimer, ScheduledCommand, % (CalculateTimeDifference(ScheduleTime) * 1000)
    MsgBox, Command scheduled at %ScheduleTime%
Return

ScheduledCommand:
    Run, %OnlineCmd%
    MsgBox, Scheduled Command executed!
Return


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙24. Add "Minimize to Tray" Option.
;;∙------• Feature: Minimize the script window to the system tray with an icon.
;;∙------• Benefit: Keeps the GUI unobtrusive while the script runs.

Gui, Add, Button, gMinimizeToTray x10 y1010 w150 h30, Minimize to Tray
Gui, Show, w400 h1100, Tray Controls
Return

MinimizeToTray:
    Gui, Hide
    Menu, Tray, Icon, shell32.dll, 44
    Menu, Tray, Tip, BatteryRun Script
Return


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙25. Add a Silent Mode Option.
;;∙------• Feature: Allow the user to enable a "silent mode" where notifications and message boxes are suppressed.
;;∙------• Benefit: Prevents interruptions when running the script in the background.

SilentMode := 0    ;;∙------∙Initializes SilentMode with disabled state.

Notify(Message) {
    Global SilentMode
    If (!SilentMode) {
        MsgBox, %Message%
    }
}

;;∙------∙Example usage:
Notify("Power state changed to On Battery")

;;∙------∙Add a toggle for silent mode in the GUI:
Gui, Add, Checkbox, vSilentMode, Enable Silent Mode
Return


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙26. Add Auto-Save for User Preferences.
;;∙------• Feature: Save GUI settings (commands, check interval, preferences) to an .ini or .txt file.
;;∙------• Benefit: Restores the user's configuration when the script restarts.

IniWrite, %OnlineCmd%, Config.ini, Commands, Online
IniWrite, %OfflineCmd%, Config.ini, Commands, Offline

;;∙------• On script startup:
IniRead, OnlineCmd, Config.ini, Commands, Online
IniRead, OfflineCmd, Config.ini, Commands, Offline


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙27. Add Script Update Checker. ???
;;∙------• Feature: Automatically check for script updates online and notify the user.
;;∙------• Benefit: Keeps the script up-to-date with the latest features and bug fixes.

UrlDownloadToFile, https://example.com/CurrentVersion.txt, CurrentVersion.txt
FileRead, CurrentVersion, CurrentVersion.txt
If (CurrentVersion > A_ScriptVersion)
    MsgBox, A new version is available. Please update.


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙28. Add Tooltip for Power State Changes.
;;∙------• Feature: Display a tooltip when the power state changes, indicating the new state and executed action.
;;∙------• Benefit: Provides non-intrusive feedback about the script's behavior.

GETSYSTEMPOWERSTATUS:
    If (acLineStatus = 1) {
        Tooltip, Power Status: Plugged In
        Sleep, 3000
        Tooltip
    } Else {
        Tooltip, Power Status: On Battery
        Sleep, 3000
        Tooltip
    }


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙29. Include System Resource Monitoring.
;;∙------• Feature: Add an option to display system resource usage (CPU, RAM) in real-time.
;;∙------• Benefit: Helps users monitor system performance alongside power state changes.

Loop {
    ;;∙------∙Example for monitoring memory.
    MemoryUsage := A_MemTotal - A_MemFree
    GuiControl,, ResourceText, Memory Usage: %MemoryUsage% KB
    Sleep, 1000
}


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙30. Add Multi-Language Support.
;;∙------• Feature: Allow the user to switch the script's UI and messages to different languages.
;;∙------• Benefit: Expands the script's usability for non-English users.

IniRead, Language, Config.ini, Settings, Language, en
MsgBox, % (Language = "en" ? "Power Status Changed" : "Estado de energía cambiado")


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙31. Add Integration with Windows Notifications.
;;∙------• Feature: Use Windows Toast notifications instead of MsgBox or Tooltip for a more modern notification style.
;;∙------• Benefit: Provides seamless integration with the Windows UI.

Run, mshta vbscript:CreateObject("WScript.Shell").Popup(""Power State Changed"",3,""BatteryRun"",64)(window.close)


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙32. Add System Startup Option
;;∙------• Feature: Configure the script to automatically run at system startup.
;;∙------• Benefit: Ensures that the script starts with the system, so users don't need to manually launch it each time they start their computer.

;;∙------∙Add System Startup Option.
;;∙------• Feature: Configure the script to automatically run at system startup.
;;∙------• Benefit: Ensures that the script starts with the system, so users don't need to manually launch it each time they start their computer.

SetStartup() {
    RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run, BatteryRunScript, %A_ScriptFullPath%
    MsgBox, Script set to run at startup!
}

RemoveStartup() {
    RegDelete, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run, BatteryRunScript
    MsgBox, Script removed from startup!
}

;;∙------∙Add Button to enable startup:
Gui, Add, Button, gSetStartup x10 y800 w150 h30, Set to Run at Startup
Gui, Add, Button, gRemoveStartup x170 y800 w150 h30, Remove from Startup
Gui, Show, w400 h850, Startup Settings
Return

SetStartup:
    SetStartup()
Return

RemoveStartup:
    RemoveStartup()
Return


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙33. Add Execution Logs.
;;∙------• Feature: Log every action the script performs (e.g., power state changes, executed commands) to a text file with timestamps.
;;∙------• Benefit: Provides a detailed history for troubleshooting or auditing script behavior.

LogAction(Action) {
    FormatTime, TimeStamp, , yyyy-MM-dd HH:mm:ss
    FileAppend, [%TimeStamp%] %Action%`n, ScriptLog.txt
}

;;∙------∙Example usage:
LogAction("Power state changed to Plugged In")
LogAction("Executed online command: %OnlineCmd%")


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙34. Add Customizable Keyboard Shortcuts.
;;∙------• Feature: Allow users to assign custom hotkeys to frequently used actions, such as toggling silent mode, executing commands, or resetting to defaults.
;;∙------• Benefit: Improves accessibility and speeds up script interactions without relying solely on the GUI.

Gui, Add, Text, x10 y600 w200 h30, Assign Shortcut for Silent Mode:
Gui, Add, Hotkey, vSilentModeHotkey x220 y600 w100 h30, F12
Gui, Add, Button, gSaveHotkeys x330 y600 w50 h30, Save
Gui, Show, w400 h650, Hotkey Settings

SaveHotkeys:
    Gui, Submit
    Hotkey, %SilentModeHotkey%, ToggleSilentMode, On
    MsgBox, Hotkey for Silent Mode set to %SilentModeHotkey%.
Return

ToggleSilentMode:
    SilentMode := !SilentMode
    MsgBox, Silent Mode % (SilentMode ? "Enabled" : "Disabled")
Return


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙35. Add Multi-Language Support.
;;∙------• Feature: Allow the user to switch the script's UI and messages to different languages (e.g., English, Spanish, French).
;;∙------• Benefit: Expands the script's usability for non-English users, improving accessibility.

IniRead, Language, Config.ini, Settings, Language, en  ;;∙------∙Initializes Language with the value from Config.ini (default: English).

;;∙------∙UI for Language Selection:
Gui, Add, Text, x10 y730 w150 h30, Select Language:  
Gui, Add, DropDownList, vLanguageSelector x170 y730 w150 h30, English|Spanish|French  
Gui, Add, Button, gSaveLanguage x330 y730 w50 h30, Save  
Gui, Show, w400 h780, Language Settings  

SaveLanguage:  
    Gui, Submit  
    If (LanguageSelector = "Spanish")  
    {  
        GuiControl,, Text1, Estado de la batería:  
        GuiControl,, Text2, Comando en línea:  
        IniWrite, Spanish, Config.ini, Settings, Language  ;;∙------∙Saves selected language as Spanish in Config.ini.
    }  
    Else If (LanguageSelector = "French")  
    {  
        GuiControl,, Text1, État de la batterie:  
        GuiControl,, Text2, Commande en ligne:  
        IniWrite, French, Config.ini, Settings, Language  ;;∙------∙Saves selected language as French in Config.ini.
    }  
    Else  
    {  
        GuiControl,, Text1, Battery Status:  
        GuiControl,, Text2, Online Command:  
        IniWrite, English, Config.ini, Settings, Language  ;;∙------∙Saves selected language as English in Config.ini.
    }

    MsgBox, % (LanguageSelector = "English" ? "Language set to English" : (LanguageSelector = "Spanish" ? "Idioma configurado a Español" : "Langue définie sur Français"))  
Return  

;;∙------∙On Script Start, display message based on saved language in Config.ini:
MsgBox, % (Language = "en" ? "Power Status Changed" : (Language = "es" ? "Estado de energía cambiado" : "État de l'alimentation changé"))
Return


;;∙------------------------------------------------------------------------------------------∙
;;∙------∙36. Add Export and Import Configuration Option
;;∙------• Feature: Allow users to save their current script settings (e.g., commands, timer intervals, profiles) to a file and reload them later.
;;∙------• Benefit: Provides a backup mechanism for settings, making it easier to transfer configurations between systems or restore them after modifications.

Gui, Add, Button, gExportConfig x10 y680 w150 h30, Export Configuration  
Gui, Add, Button, gImportConfig x170 y680 w150 h30, Import Configuration  
Gui, Show, w400 h730, Configuration Management  

ExportConfig:  
    FileSelectFile, ConfigFile, S, , Save Configuration, Text Documents (*.txt)  
    If ConfigFile  
    {
        FileAppend, OnlineCmd=%OnlineCmd%`nOfflineCmd=%OfflineCmd%`nCheckInterval=%CheckInterval%, %ConfigFile%  
        MsgBox, Configuration exported to %ConfigFile%  
    }  
Return  

ImportConfig:  
    FileSelectFile, ConfigFile, O, , Load Configuration, Text Documents (*.txt)  
    If ConfigFile  
    {
        Loop, Read, %ConfigFile%  
        {
            StringSplit, LineParts, A_LoopReadLine, =  
            %LineParts1% := LineParts2  
        }  
        GuiControl,, OnlineCmdInput, %OnlineCmd%  
        GuiControl,, OfflineCmdInput, %OfflineCmd%  
        GuiControl,, CheckIntervalInput, %CheckInterval%  
        MsgBox, Configuration imported from %ConfigFile%  
    }  
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

