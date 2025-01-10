
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  MedBooster
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?f=76&t=87453#p506455
» 
    ▹ 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "Rotate_Monitor"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙🔥 HotKey 🔥∙===========================================∙
;^t::    ;;∙------∙🔥∙(Ctrl+T) 
    Soundbeep, 1000, 200
;;∙============================================================∙




;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
lookup:={"^!UP":[0,0],"^!DOWN":[2,0],"^!LEFT":[1,1],"^!RIGHT":[3,1]}
Return

;;∙------------∙🔥∙HOTKEYS∙🔥∙----------------∙
^!UP::    ;;∙------∙(Ctrl+Alt+Up)
^!DOWN::    ;;∙------∙(Ctrl+Alt+Down)
^!LEFT::    ;;∙------∙(Ctrl+Alt+Left)
^!RIGHT::    ;;∙------∙(Ctrl+Alt+Right)
;;∙------------------------------------------------∙

display := GetMonitorName("Window")
if (lookup[a_thisHotkey][2]){    ;;∙------∙ROTATING TO PORTRAIT.
    sRes:=strSplit((cRes:=screenRes_Get(display)),["x","@"])
        if (sRes[2] < sRes[1]) {
            cRes:=sRes[2] "x" sRes[1] "@" sRes[3]
            }
        } else {    ;;∙------∙ROTATING TO LANDSCAPE.
            sRes:=strSplit((cRes:=screenRes_Get(display)),["x","@"])
            if (sRes[2] > sRes[1]) {
                cRes:=sRes[2] "x" sRes[1] "@" sRes[3]
            }
        }
screenRes_Set(cRes,display,lookup[a_thisHotkey][1])
Return
;;∙------------------------∙
screenRes_Set(WxHaF, Disp:=0, orient:=0) {
    Local DM, N:=VarSetCapacity(DM,220,0), F:=StrSplit(WxHaF,["x","@"],A_Space)
    Return DllCall("ChangeDisplaySettingsExW",(Disp=0 ? "Ptr" : "WStr"),Disp,"Ptr",NumPut(F[3],NumPut(F[2],NumPut(F[1]
            ,NumPut(32,NumPut(0x5C0080,NumPut(220,NumPut(orient,DM,84,"UInt")-20,"UShort")+2,"UInt")+92,"UInt"),"UInt")
            ,"UInt")+4,"UInt")-188, "Ptr",0, "Int",0, "Int",0)  
    }
screenRes_Get(Disp:=0) {
    Local DM, N:=VarSetCapacity(DM,220,0) 
    Return DllCall("EnumDisplaySettingsW", (Disp=0 ? "Ptr" : "WStr"),Disp, "Int",-1, "Ptr",&DM)=0 ? ""
            : Format("{:}x{:}@{:}", NumGet(DM,172,"UInt"),NumGet(DM,176,"UInt"),NumGet(DM,184,"UInt")) 
    }
;;∙------------------------∙
GetMonitorName(method := "Window", coords := "", default_to := "Nearest") {
    static default := {"Null": MONITOR_DEFAULTTONULL := 0x0, "Primary": MONITOR_DEFAULTTOPRIMARY := 0x1, "Nearest": MONITOR_DEFAULTTONEAREST := 0x2}
    If (method = "Window")
        hMonitor := DllCall("MonitorFromWindow", "UInt", WinExist("A"), "UInt", default[default_to], "Ptr")
    Else if (method = "Point") {
        if coords
            x := coords[1], y := coords[2]
        Else
            MouseGetPos, x, y
        hMonitor := DllCall("MonitorFromPoint", "Int64", (x&0xFFFFFFFF) | (y<<32), "Int", default[default_to], "Ptr")
    }
    Else if (method = "Rect") {
        if !coords
            Throw % "Rect method requires coordinates"
        VarSetCapacity(RECT, 16, 0)
        NumPut(coords[4], NumPut(coords[3], NumPut(coords[2], NumPut(coords[1], &RECT, "UInt"), "UInt"), "UInt"), "UInt")
        hMonitor := DllCall("MonitorFromRect", "Ptr", &RECT, "UInt", default[default_to], "Ptr")
    }
    Else
        Throw % "Invalid method"
    NumPut(VarSetCapacity(MONITORINFOEX, 40 + (32 << !!A_IsUnicode)), MONITORINFOEX, 0, "UInt")
    DllCall("GetMonitorInfoW", "Ptr", hMonitor, "Ptr", &MONITORINFOEX)
    return StrGet(&MONITORINFOEX + 40, 32)
}
Return
;;∙------------------------------------------------------------------------------------------∙
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
Menu, Tray, Icon, shell32.dll, 147    ;;∙------∙Sets the system tray icon.
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
Rotate_Monitor:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

