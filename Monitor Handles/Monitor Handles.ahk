
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙--------∙Origins∙-------------------------∙
» Author:  SELF
» Original Source:  
» DISPLAYS DETAILED MONITOR INFORMATION ABOUT ALL CONNECTED MONITORS.
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TEMPLATE"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
;;∙============================================================∙
^t::    ;;∙------∙🔥∙(Ctrl + T) Show detailed monitor info using EnumDisplayMonitors.
    Soundbeep, 1100, 100

    global AllMonitorsArray := []    ;;∙------∙Array to hold each monitor's info.

    Callback_Func := RegisterCallback("MONITORENUMPROC1")    ;;∙------∙Register callback function for monitor enumeration.
    DllCall("EnumDisplayMonitors", Ptr, 0, Ptr, 0, Ptr, Callback_Func, Ptr, 0)    ;;∙------∙Enumerate all display monitors using Windows API.
    DllCall("GlobalFree", Ptr, Callback_Func)    ;;∙------∙Clean up callback memory.

    ;;∙------∙Build final output string with monitor information.
    FinalInfo := ""
    for index, text in AllMonitorsArray
        FinalInfo .= (index > 1 ? "`n`n`t---------------`n`n" : "") . text

    MsgBox, % FinalInfo    ;;∙------∙Display information dialog.
    Clipboard := FinalInfo    ;;∙------∙Copy information to clipboard.
Return

;;∙------------∙Monitor Enumeration Callback Function∙------------------------∙
MONITORENUMPROC1(hMonitor, hDC, pRECT, data)
    {
    global AllMonitorsArray

    VarSetCapacity(MonitorInfo, 40, 0)    ;;∙------∙Initialize MONITORINFOEX structure (size = 40 bytes).
    NumPut(40, MonitorInfo, 0, "UInt")    ;;∙------∙Set structure size (cbSize).

    if DllCall("GetMonitorInfo", Ptr, hMonitor, Ptr, &MonitorInfo)
        {    ;;∙------∙Extract monitor bounds coordinates.
        Left := NumGet(MonitorInfo, 4, "Int")
        Top := NumGet(MonitorInfo, 8, "Int")
        Right := NumGet(MonitorInfo, 12, "Int")
        Bottom := NumGet(MonitorInfo, 16, "Int")
        ;;∙------∙Extract work area coordinates.
        WorkLeft := NumGet(MonitorInfo, 20, "Int")
        WorkTop := NumGet(MonitorInfo, 24, "Int")
        WorkRight := NumGet(MonitorInfo, 28, "Int")
        WorkBottom := NumGet(MonitorInfo, 32, "Int")
        ;;∙------∙Check if this is the primary monitor.
        Primary := (NumGet(MonitorInfo, 36, "UInt") & 1) ? "True" : "False"
        ;;∙------∙Initialize variables for device information.
        MonitorName := ""
        VarSetCapacity(Device, 424, 0)
        NumPut(424, Device, 0, "UInt")    ;;∙------∙Set DISPLAY_DEVICE structure size.

        AdapterIndex := 0    ;;∙------∙Enumerate display adapters.
        while DllCall("EnumDisplayDevices", "Ptr", 0, "UInt", AdapterIndex, "Ptr", &Device, "UInt", 0)
            {
            AdapterName := StrGet(&Device + 4, "UTF-16")    ;;∙------∙Get adapter name.
            if (StrLen(AdapterName) > 0)
            {
                MonitorIndex := 0    ;;∙------∙Enumerate monitors for current adapter.
                while DllCall("EnumDisplayDevices", "Ptr", &Device + 4, "UInt", MonitorIndex, "Ptr", &Device, "UInt", 0)
                {
                    MonitorName := StrGet(&Device + 4, "UTF-16")    ;;∙------∙Get monitor name.
                    if (StrLen(MonitorName) > 0)
                        break    ;;∙------∙Exit loop when valid name found.
                    MonitorIndex++
                }
                break    ;;∙------∙Exit adapter loop after finding first valid monitor.
            }
            AdapterIndex++
        }

        ;;∙------∙Calculate resolution from bounds coordinates.
        Width := Right - Left
        Height := Bottom - Top

        ;;∙------∙Format monitor information and add to array
        AllMonitorsArray.Push("Monitor Handle: " hMonitor "`nBounds: (" Left ", " Top ") - (" Right ", " Bottom ")`nResolution: " Width " x " Height "`nWork Area: (" WorkLeft ", " WorkTop ") - (" WorkRight ", " WorkBottom ")`nPrimary Monitor: " Primary)
    }
    return true    ;;∙------∙Continue enumeration.
}
Return
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

