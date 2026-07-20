
;;∙---------------------------------------------------------------------∙

SetTimer, UpdateCheck, 500
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")
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
Menu, Tray, Icon, shell32.dll, 270
SetWorkingDir %A_ScriptDir%

;;∙======∙HOTKEY∙================================∙
^t::    ;;∙------∙🔥∙(Ctrl + T)
    aSoundBeep(1000, 100)    ;;∙------∙Asynchronous SoundBeep (non-blocking).

;;∙======∙GET MONITOR INFO∙=====================∙
;;∙------∙Connect to WMI.
try {
    wmi := ComObjGet("winmgmts:{impersonationLevel=impersonate}!\\" . A_ComputerName . "\root\wmi")
} catch {
    MsgBox, 16, Error, Failed to connect to WMI.
    ExitApp
}

;;∙------∙Get primary monitor & monitor names.
SysGet, primaryMonitor, MonitorPrimary
SysGet, monitorCount, MonitorCount

;;∙------∙Store SysGet monitor names.
global sysGetNames := Object()
Loop, % monitorCount {
    SysGet, monitorName, MonitorName, % A_Index
    sysGetNames[A_Index] := monitorName
}

;;∙------∙Query supported modes.
try {
    monitors := wmi.ExecQuery("SELECT * FROM WmiMonitorListedSupportedSourceModes WHERE Active=TRUE")
} catch {
    MsgBox, 16, Error, Failed to query monitor modes.
    ExitApp
}

;;∙======∙BUILD OUTPUT∙==========================∙
;;∙------∙Build output for each monitor separately.
global monitorOutputs := Object()
wmiMonitorCount := 0
for monitor in monitors {
    wmiMonitorCount++
    output := ""

    ;;∙------∙Check if this is the primary monitor by matching monitor number.
    isPrimary := (wmiMonitorCount = primaryMonitor)
    output .= "Monitor " . wmiMonitorCount . ":"
    if (isPrimary) {
        output .= " (Primary)"
    }
    output .= "`n"
    output .= "    " . monitor.InstanceName . "`n"

    ;;∙------∙Get native resolution for monitor size.
    maxPixels := 0, monitorWidth := 0, monitorHeight := 0
    for mode in monitor.MonitorSourceModes {
        totalPixels := mode.HorizontalActivePixels * mode.VerticalActivePixels
        if (totalPixels > maxPixels && mode.HorizontalImageSize > 100) {
            maxPixels := totalPixels
            monitorWidth := mode.HorizontalImageSize
            monitorHeight := mode.VerticalImageSize
        }
    }
    if (monitorWidth > 0 && monitorHeight > 0) {
        diagonalInches := Round(Sqrt(monitorWidth**2 + monitorHeight**2) / 25.4, 1)
        output .= "Physical Size:`n"
        output .= "    " . monitorWidth . "x" . monitorHeight . "mm (" . diagonalInches . " inch)`n"
    }

    ;;∙------∙Add SysGet monitor name.
    if (sysGetNames.HasKey(wmiMonitorCount)) {
        output .= "Name:`n"
        output .= "    " . sysGetNames[wmiMonitorCount] . "`n"
    }
    output .= "`nSupported Modes:`n"
    modeCount := 0
    for mode in monitor.MonitorSourceModes {
        modeCount++

        ;;∙------∙Calculate refresh rate.
        refreshRate := Round(mode.VerticalRefreshRateNumerator / mode.VerticalRefreshRateDenominator, 1)
        output .= "  " . mode.HorizontalActivePixels . "x" . mode.VerticalActivePixels
               . " @ " . refreshRate . "Hz"
               . "`n"
        if (modeCount >= 50) {
            output .= "  ... and more`n"
            break
        }
    }
    if (modeCount = 0) {
        output .= "  No modes found`n"
    }
    monitorOutputs[wmiMonitorCount] := output
}
if (wmiMonitorCount = 0) {
    MsgBox, No active monitors found or no modes reported.
    ExitApp
}

;;∙======∙COPY TO CLIPBOARD∙=====================∙
clipboardOutput := ""
Loop, % wmiMonitorCount {
    clipboardOutput .= monitorOutputs[A_Index] . "`n"
}
Clipboard := clipboardOutput

;;∙======∙CREATE GUI∙=============================∙
Gui, +AlwaysOnTop +ToolWindow
Gui, Color, 000000

;;∙------∙Define colors array (cycling colors).
colors := ["00FFFF", "00FF00", "FFFF00", "FF00FF", "FF0000", "0000FF"]

;;∙------∙Add each monitor's output with cycling colors.
Loop, % wmiMonitorCount {
    colorIndex := Mod(A_Index - 1, colors.MaxIndex()) + 1
    currentColor := colors[colorIndex]
    Gui, Font, s10 c%currentColor%, Consolas
    if (A_Index = 1) {
        Gui, Add, Text, x10 y10 vMonitor%A_Index%Text, % monitorOutputs[A_Index]
    } else {
        Gui, Add, Text, x+30 y10 vMonitor%A_Index%Text, % monitorOutputs[A_Index]
    }
}
Gui, Show, AutoSize, Screen Resolutions
Return

;;∙======∙GUI DRAG∙==============================∙
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}
Return

;;∙======∙GUI CLOSE∙==============================∙
GuiEscape:
GuiClose:
    ExitApp
Return



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


