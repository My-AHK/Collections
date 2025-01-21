
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  teadrinker
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?f=76&t=93964#p564321
» Minimize windows to icons in the System Tray. (Last Minimized - First Restored)
» HOTKEY Actions...
    ▹ MINIMIZE to Icon in System Tray: ∙🔥∙(Ctrl+SpaceBar)∙∙∙∙🔥∙
    ▹ RESTORE from Icon to Desktop:      ∙🔥∙(Ctrl+R)∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙🔥∙
    ▹ Last Minimized, First Restored.
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

;;∙========∙INITIALIZE∙==========================∙
DetectHiddenWindows, On
global EVENT_SYSTEM_MINIMIZEEND := 0x0017
      , EVENT_OBJECT_DESTROY     := 0x8001
      , Windows := [], orderList := []

MinimizeHook := new WinEventHook(EVENT_SYSTEM_MINIMIZEEND, EVENT_SYSTEM_MINIMIZEEND, "HookProc")
DestroyHook  := new WinEventHook(EVENT_OBJECT_DESTROY    , EVENT_OBJECT_DESTROY    , "HookProc")
OnMessage(0x404, "AHK_NOTIFYICON")
OnExit("ShowHidden")
Return
;;∙-----------------------------------------------------------------∙

;;∙========∙RESTORE∙===========================∙
^r::    ;;∙------∙🔥∙(Ctrl + R)∙🔥∙
RestoreLast() {
    AHK_NOTIFYICON(0x404, WM_LBUTTONDOWN := 0x201, 0x404, Windows[orderList.Pop()].gui)
}
Return
;;∙-----------------------------------------------------------------∙

;;∙========∙MINIMIZE∙==========================∙
^Space::    ;;∙------∙🔥∙(Ctrl + Space)∙🔥∙
AddToListAndMinimize() {
    hWnd := WinExist("A")
    SetTitleMatchMode, RegEx
    if WinActive("ahk_class ^(Progman|WorkerW|Shell_TrayWnd)$")
        return
    if !Windows.HasKey(hWnd) {
        WinGetTitle, title
        Windows[hwnd] := {title: title, hIcon: GetWindowIcon(hWnd)}
    }
    WinMinimize
    WinHide
    Windows[hwnd, "gui"] := AddTrayIcon(Windows[hwnd, "hIcon"], Windows[hwnd, "title"])
    orderList.Push(hwnd)
}
Return
;;∙-----------------------------------------------------------------∙

;;∙========∙FUNCTIONS∙========================∙
ShowHidden() {
    for hwnd, v in Windows {
        if !DllCall("IsWindowVisible", "Ptr", hwnd)
            WinShow, ahk_id %hwnd%
        if WinExist("ahk_id" . v.gui)
            RemoveTrayIcon(v.gui)
    }
    orderList := []
}
;;∙------------------∙
GetWindowIcon(hWnd) {
    static WM_GETICON := 0x007F, ICON_SMALL := 0, GCLP_HICONSM := -34
          , GetClassLong := "GetClassLong" . (A_PtrSize = 4 ? "" : "Ptr")
    SendMessage, WM_GETICON, ICON_SMALL, A_ScreenDPI,, ahk_id %hWnd%
    if !smallIcon := ErrorLevel
        smallIcon := DllCall(GetClassLong, "Ptr", hWnd, "Int", GCLP_HICONSM, "Ptr")
    return smallIcon
}
;;∙------------------∙
AddTrayIcon(hIcon, tip := "") {
    static NIF_MESSAGE := 1, NIF_ICON := 2, NIF_TIP := 4, NIM_ADD := 0
    flags := NIF_MESSAGE|NIF_ICON|(tip = "" ? 0 : NIF_TIP)
    VarSetCapacity(NOTIFYICONDATA, size := 396, 0)
    Gui, New, +hwndhGui
    NumPut(size         , NOTIFYICONDATA)
    NumPut(hGui         , NOTIFYICONDATA, A_PtrSize)
    NumPut(uID  := 0x404, NOTIFYICONDATA, A_PtrSize*2)
    NumPut(flags        , NOTIFYICONDATA, A_PtrSize*2 + 4)
    NumPut(nMsg := 0x404, NOTIFYICONDATA, A_PtrSize*2 + 8)
    NumPut(hIcon        , NOTIFYICONDATA, A_PtrSize*3 + 8)
    if (tip != "")
        StrPut(tip, &NOTIFYICONDATA + 4*A_PtrSize + 8, "CP0")
    DllCall("shell32\Shell_NotifyIcon", "UInt", NIM_ADD, "Ptr", &NOTIFYICONDATA)
    return hGui
}
;;∙------------------∙
RemoveTrayIcon(hWnd, uID := 0x404) {
    VarSetCapacity(NOTIFYICONDATA, size := 24, 0)
    NumPut(size, NOTIFYICONDATA)
    NumPut(hWnd, NOTIFYICONDATA, A_PtrSize)
    NumPut(uID , NOTIFYICONDATA, A_PtrSize*2)
    DllCall("shell32\Shell_NotifyIcon", "UInt", NIM_DELETE := 2, "Ptr", &NOTIFYICONDATA)
}
;;∙------------------∙
AHK_NOTIFYICON(wp, lp, msg, hwnd) {
    static WM_LBUTTONDOWN := 0x201, WM_RBUTTONUP := 0x205, maxLenMenuStr := 40
    if !(lp = WM_LBUTTONDOWN || lp = WM_RBUTTONUP)
        return
    for k, v in Windows
        if (v.gui = hwnd && window := k)
            break
    if !window
        return
    Switch lp {
    Case WM_LBUTTONDOWN:
        RemoveTrayIcon(hwnd)
        Gui, %hwnd%: Destroy
        WinShow, ahk_id %window%
        WinActivate, ahk_id %window%
    Case WM_RBUTTONUP:
        title := Windows[window, "title"]
        b := StrLen(title) > maxLenMenuStr
        menuText := "Restore «" . SubStr(title, 1, maxLenMenuStr) . (b ? "..." : "") . "»"
        fn := Func(A_ThisFunc).Bind(0x404, WM_LBUTTONDOWN, 0x404, hwnd)
        Menu, IconMenu, Add , % menuText, % fn
        Menu, IconMenu, Icon, % menuText, % "HICON:*" . Windows[window, "hIcon"]
        Menu, IconMenu, Add , Show all windows, ShowHidden
        Menu, IconMenu, Show
        Menu, IconMenu, DeleteAll
    }
}
;;∙------------------∙
HookProc(hWinEventHook, event, hwnd, idObject, idChild, dwEventThread, dwmsEventTime) {
    static OBJID_WINDOW := 0
    if !( idObject = OBJID_WINDOW && Windows.HasKey(hwnd) )
        return
    iconGui := Windows[hwnd, "gui"]
    if WinExist("ahk_id" . iconGui) {
        RemoveTrayIcon(iconGui)
        Gui, %iconGui%: Destroy
    }
    for k, v in orderList {
        if (v = hwnd) {
            orderList.RemoveAt(k)
            break
        }
    }
    ( event = EVENT_OBJECT_DESTROY && Windows.Delete(hwnd) )
}
;;∙------------------∙
class WinEventHook {
    __New(eventMin, eventMax, hookProc, eventInfo := 0, idProcess := 0, idThread := 0, dwFlags := 0) {
        this.pCallback := RegisterCallback(hookProc, "F",, eventInfo)
        this.hHook := DllCall("SetWinEventHook", "UInt", eventMin, "UInt", eventMax, "Ptr", 0, "Ptr", this.pCallback
                                               , "UInt", idProcess, "UInt", idThread, "UInt", dwFlags, "Ptr")
    }
    __Delete() {
        DllCall("UnhookWinEvent", "Ptr", this.hHook)
        DllCall("GlobalFree", "Ptr", this.pCallback, "Ptr")
    }
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

