
/*∙=====∙NOTES∙===============================================∙
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
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TEMPLATE"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
;;∙============================================================∙

/*∙------------------------------------------------------------------------∙
Current Features:
  ▹ Displays ToolTip shadowing mouse icon
  ▹ Display current mouse cordinates (in real-time)
  ▹ Display current color code (RGB) at mouse position (in real-time)
  ▹ Display current active window (in real-time)
  ▹ Display current date and time (in real-time) in the following format
  ▹ Day/Month/Year - Hour:Minute:Second AM/PM

Use Tray Icon to toggle which ones you want on

Disable ALL/Pause will disable all options and stop the tooltip timer (which will automatically be re-enabled when selecting any option)
∙---------------------------------------------------------------------------∙
*/

;;∙============================================================∙
#SingleInstance Force
#Persistent
Process, Priority,, High
Menu, Tray, Icon, %A_Windir%\explorer.exe
Menu, Tray, NoStandard
Menu, Tray, Add, Show_Time, show_time
Menu, Tray, Add, Show_Mouse_Position, show_mouse_position
Menu, Tray, Add, Show_Active_Window, show_active_window
Menu, Tray, Add, Show_Color_ID, show_color_id
Menu, Tray, Add, Show_Window_Class, show_window_class
Menu, Tray, Add, Show_Control_ID, show_control_id
Menu, Tray, Add, Show_Process_Name, show_process_name
Menu, Tray, Add, Show_Clipboard_Text, show_clipboard_text
Menu, Tray, Add, Show_Screen_Resolution, show_screen_resolution
Menu, Tray, Add, Show_Idle_Time, show_idle_time
Menu, Tray, Add
Menu, Tray, Add, Reload
Menu, Tray, Add, Disable_ALL_Pause, disable_all_pause
Menu, Tray, Add, Exit

status := "on"
time_on := "off"
mouse_on := "off"
window_on := "off"
color_on := "off"
class_on := "off"
control_on := "off"
process_on := "off"
clipboard_on := "off"
screenres_on := "off"
idle_on := "off"
timer := "off"
Return

;;∙------∙Basic Menu Actions.
Reload:
    Reload
Return

Exit:
    ExitApp
Return

disable_all_pause:
    if (timer = "off")
        Return
    ToolTip
    status := "off"
    Loop, Parse, MenuItemsList, `,
    {
        Menu, Tray, Uncheck, %A_LoopField%
    }
    time_on := mouse_on := window_on := color_on := class_on := control_on := process_on := clipboard_on := screenres_on := idle_on := "off"
    SetTimer, update_tooltip, Off
    timer := "off"
Return

;;∙------∙Toggle Handlers.
show_time:
    ToggleFeature("Show_Time", time_on)
Return

show_mouse_position:
    ToggleFeature("Show_Mouse_Position", mouse_on)
Return

show_active_window:
    ToggleFeature("Show_Active_Window", window_on)
Return

show_color_id:
    ToggleFeature("Show_Color_ID", color_on)
Return

show_window_class:
    ToggleFeature("Show_Window_Class", class_on)
Return

show_control_id:
    ToggleFeature("Show_Control_ID", control_on)
Return

show_process_name:
    ToggleFeature("Show_Process_Name", process_on)
Return

show_clipboard_text:
    ToggleFeature("Show_Clipboard_Text", clipboard_on)
Return

show_screen_resolution:
    ToggleFeature("Show_Screen_Resolution", screenres_on)
Return

show_idle_time:
    ToggleFeature("Show_Idle_Time", idle_on)
Return

;;∙------∙Toggle Handler Logic.
ToggleFeature(labelName, ByRef varFlag) {
    global
    if (varFlag = "on") {
        Menu, Tray, Uncheck, %labelName%
        varFlag := "off"
        if (AllOff())
        {
            ToolTip
            status := "off"
        }
        return
    }
    Menu, Tray, Check, %labelName%
    varFlag := "on"
    status := "on"
    if (timer = "off") {
        SetTimer, update_tooltip, 50
        timer := "on"
    }
}

AllOff() {
    global
    return (time_on = "off" && mouse_on = "off" && window_on = "off" && color_on = "off"
         && class_on = "off" && control_on = "off" && process_on = "off"
         && clipboard_on = "off" && screenres_on = "off" && idle_on = "off")
}

;;∙------∙Timer Update Tooltip.
update_tooltip:
    if (timer = "off") {
        SetTimer, update_tooltip, Off
        Return
    }
    if (status = "off") {
        ToolTip
        timer := "off"
        Return
    }

    MouseGetPos, mx, my, winID, control
    if (color_on = "on")
        PixelGetColor, pc, mx, my, RGB
    if (window_on = "on")
    {
        WinGetActiveTitle, win
        if InStr(win, "Active Window:")
            win := ""
    }
    if (class_on = "on")
        WinGetClass, winClass, ahk_id %winID%
    if (process_on = "on")
        WinGet, procName, ProcessName, ahk_id %winID%
    if (time_on = "on")
        FormatTime, time, , d/M/yyyy - h:mm:ss tt
    if (clipboard_on = "on")
        clip := SubStr(clipboard, 1, 100)
    if (screenres_on = "on") {
        SysGet, ScreenW, 78
        SysGet, ScreenH, 79
    }
    if (idle_on = "on") {
        DllCall("GetLastInputInfo", "uint*", lastInput)
        idle := (A_TickCount - lastInput) // 1000
    }

    MouseGetPos, ccx, ccy
    contents := ""
    if (time_on = "on")
        contents .= "Time: " . time . "`n"
    if (mouse_on = "on")
        contents .= "X" . mx . " Y" . my . "`n"
    if (window_on = "on")
        contents .= "Active Window: " . win . "`n"
    if (class_on = "on")
        contents .= "Class: " . winClass . "`n"
    if (control_on = "on")
        contents .= "Control: " . control . "`n"
    if (process_on = "on")
        contents .= "Process: " . procName . "`n"
    if (color_on = "on")
        contents .= "Color: " . pc . "`n"
    if (clipboard_on = "on")
        contents .= "-Clipboard: " . clip . "`n"
    if (screenres_on = "on")
        contents .= "Screen: " . ScreenW . " x " . ScreenH . "`n"
    if (idle_on = "on")
        contents .= "Idle: " . idle . " sec`n"

    StringTrimRight, contents, contents, 1
    ToolTip, %contents%, ccx + 10, ccy - 40
Return

;;∙------∙Track list of items for loop-based disable.
MenuItemsList := "Show_Time,Show_Mouse_Position,Show_Active_Window,Show_Color_ID,Show_Window_Class,Show_Control_ID,Show_Process_Name,Show_Clipboard_Text,Show_Screen_Resolution,Show_Idle_Time"
;;∙============================================================∙
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
        Soundbeep, 1200, 250
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        Soundbeep, 1000, 300
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
#MaxThreadsPerHotkey 3    ;;∙------∙Sets the maximum simultaneous threads for each hotkey.
#NoEnv    ;;∙------∙Avoids checking empty environment variables for optimization.
;;∙------∙#NoTrayIcon    ;;∙------∙Hides the tray icon if uncommented.
#Persistent    ;;∙------∙Keeps the script running indefinitely.
#SingleInstance, Force    ;;∙------∙Prevents multiple instances of the script and forces new execution.
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.
SendMode, Input    ;;∙------∙Sets SendMode to Input for faster and more reliable keystrokes.
SetBatchLines -1    ;;∙------∙Disables batch line delays for immediate execution of commands.
SetTimer, UpdateCheck, 500    ;;∙------∙Sets a timer to call UpdateCheck every 500 milliseconds.
SetTitleMatchMode 2    ;;∙------∙Enables partial title matching for window detection.
SetWinDelay 0    ;;∙------∙Removes delays between window-related commands.
Menu, Tray, Icon, imageres.dll, 3    ;;∙------∙Sets the system tray icon.
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

