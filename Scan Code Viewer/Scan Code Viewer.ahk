
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
ScriptID := "Scan_Code_Viewer"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙

;;∙======∙HotKey∙===============================================∙
;^t::    ;;∙------∙🔥∙(Ctrl + T)
    Soundbeep, 1000, 200
;;∙============================================================∙




;;∙============================================================∙
;;∙============================================================∙
#NoEnv
#Persistent
ListLines, Off
SetBatchLines, -1

global hHook := SetWindowsHookEx()
tHeight := 200
twidth  := 240

Gui, +AlwaysOnTop
Gui, Color, Black
Gui, Font, s10 cAqua q5, Arial
Gui, Add, Text, x20 y20 vScanCodeText w%twidth% h%tHeight%, Press any key...
Gui, Show, x1600 y450, Scan Code Viewer
Return

GuiClose:
    UnhookWindowsHookEx(hHook)
ExitApp

SetWindowsHookEx() {
    static WH_KEYBOARD_LL := 13
    return DllCall("SetWindowsHookEx", "Int", WH_KEYBOARD_LL
        , "Ptr", RegisterCallback("LowLevelKeyboardProc", "Fast")
        , "Ptr", DllCall("GetModuleHandle", "Ptr", 0, "Ptr")
        , "UInt", 0, "Ptr")
}

LowLevelKeyboardProc(nCode, wParam, lParam) {
    static WM_KEYDOWN := 0x100, WM_SYSKEYDOWN := 0x104

    if (nCode >= 0 && (wParam = WM_KEYDOWN || wParam = WM_SYSKEYDOWN)) {
        vk  := NumGet(lParam + 0, 0, "UInt")
        sc  := NumGet(lParam + 4, 0, "UInt") & 0xFF
        ext := (NumGet(lParam + 4, 0, "UInt") >> 24) & 1

        VarSetCapacity(keyboardState, 256, 0)
        DllCall("GetKeyboardState", "Ptr", &keyboardState)

        VarSetCapacity(charBuffer, 2, 0)
        result := DllCall("ToAscii"
            , "UInt", vk
            , "UInt", sc
            , "Ptr", &keyboardState
            , "Ptr", &charBuffer
            , "UInt", 0, "Int")

        if (result = 1) {
            asciiVal   := NumGet(charBuffer, 0, "UChar")
            keyDisplay := Chr(asciiVal)
            asciiText  := "Chr(" . asciiVal . ")"
        } else {
            keyDisplay := GetKeyName("vk" . Format("{:02X}", vk) . "sc" . Format("{:02X}", sc))
            asciiText  := "N/A"
        }

        ;;∙------∙Replace specific character codes with names.
        if (keyDisplay = Chr(13)) {
            keyDisplay := "Enter"
        } else if (keyDisplay = Chr(27)) {
            keyDisplay := "Esc"
        } else if (keyDisplay = Chr(32)) {
            keyDisplay := "Space"
        } else if (keyDisplay = Chr(9)) {
            keyDisplay := "Tab"
        } else if (keyDisplay = Chr(8)) {
            keyDisplay := "Backspace"
        }

        ;;∙------∙Detect and rename numpad keys.
        if (vk >= 0x60 && vk <= 0x69) {
            keyDisplay := "Numpad" . (vk - 0x60)
        } else if (vk = 0x6E) {
            keyDisplay := "NumpadDot"
        } else if (vk = 0x6F) {
            keyDisplay := "NumpadDiv"
        } else if (vk = 0x6A) {
            keyDisplay := "NumpadMult"
        } else if (vk = 0x6D) {
            keyDisplay := "NumpadSub"
        } else if (vk = 0x6B) {
            keyDisplay := "NumpadAdd"
        } else if (vk = 0x6C) {
            keyDisplay := "NumpadEnter"
        }

        formattedKeyDisplay := " " . keyDisplay . " "

        text := "Key Pressed  -  (also shows shifted)`n"
             . "`t: """ . formattedKeyDisplay . """`n`n"
             . "Virtual Key  -  (VK" . Format("{:02X}", vk) . ")`n"
             . "`t: 0x" . Format("{:02X}", vk) . "`n`n"
             . "Scan Code  -  (SC" . Format("{:03X}", sc) . ")`n"
             . "`t: 0x" . Format("{:02X}", sc) . "   (Decimal : " . sc . ")`n`n"
             . "ASCII Code  -  (also shows shifted)`n"
             . "`t: " . asciiText

        GuiControl,, ScanCodeText, %text%
    }
    return DllCall("CallNextHookEx", "Ptr", 0, "Int", nCode, "Ptr", wParam, "Ptr", lParam)
}

UnhookWindowsHookEx(hHook) {
    return DllCall("UnhookWindowsHookEx", "Ptr", hHook)
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
Scan_Code_Viewer:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

