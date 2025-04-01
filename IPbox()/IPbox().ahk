
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
;;∙======∙🔥 HotKey 🔥∙===========================================∙
;^t::    ;;∙------∙(Ctrl+T) 
 ;   Soundbeep, 1000, 200
;;∙============================================================∙




;;∙============================================================∙

/*
iBoX(t, p, w, h, hide, x, y, to, d)    ;;∙------∙9 parameter inputbox function.
  • t: Title of the InputBox.
  • p: Prompt text in the InputBox.
  • w: Width of the InputBox.
  • h: Height of the InputBox.
  • hide: (Optional) Password character. "Hide"
  • x: X-coordinate of the InputBox (left position).
  • y: Y-coordinate of the InputBox (top position).
  • to: Timeout for the InputBox in seconds.
  • d: Default text or value shown in the InputBox.
*/


global VERBOSE_LOGGING := FALSE     ;;∙------∙Set to 'TRUE' for detailed logging.

Log(message) {    ;;∙------∙Logging function with blank line separation.
    FormatTime, timestamp,, yyyy-MM-dd HH:mm:ss
    FileAppend, [%timestamp%] %message%`n`n, IPbox.log
    OutputDebug, [IPbox] %message%
}

^+v::    ;;∙------∙🔥∙(Ctrl + Shift + V)    ;;∙------∙Verbose Logging Toggle.
    VERBOSE_LOGGING := !VERBOSE_LOGGING
    MsgBox Verbose logging %VERBOSE_LOGGING% 
Return

^t::    ;;∙------∙🔥∙(Ctrl + T)
    result := IPbox(title, "Enter text for variable.", 130, 250, "HIDE", 750, 450, 15, "Timed Out!")
    
    if (ErrorLevel = 1) {
        MsgBox, 16, Error, Input was cancelled. Result: %result%,3
    } else if (ErrorLevel = 2) {
        MsgBox, 48, Timeout, Input timed out. Default value used:`n%result%,3
    } else if (ErrorLevel = 0) {
        MsgBox, 64, Success, Result is:`n%result%,3
    } else {
        MsgBox, 16, Error, An unexpected error occurred (ErrorLevel: %ErrorLevel%).,3
    }
Return

IPbox(t = "Input", p = "Enter text:", w = 300, h = 200, hide = "", x = "", y = "", to = "", d = "") {
    ; Parameter validation
    if !(w ~= "^\d+$") || (w <= 0) {
        Log("Invalid width: " w ". Using default 300.")
        w := 300
    }
    if !(h ~= "^\d+$") || (h <= 0) {
        Log("Invalid height: " h ". Using default 200.")
        h := 200
    }
    if (to != "" && !(to ~= "^\d+$")) {
        Log("Invalid timeout: " to ". Timeout disabled.")
        to := ""
    }
    
    if (VERBOSE_LOGGING) {    ;;∙------∙Verbose parameter logging.
        Log(StringTrim(Format("IPBOX PARAMS - Title: '{}', Prompt: '{}', W: {}, H: {}, Hide: '{}', X: {}, Y: {}, Timeout: {}, Default: '{}'"
            , t, p, w, h, hide, x, y, to, d), 200))    ;;∙------∙Truncate long messages.
    }
    
    InputBox, var, %t%, %p%, %hide%, %h%, %w%, %x%, %y%, , %to%, %d%
    if (ErrorLevel = 1) {    ;;∙------∙Handle and log results.
        Log("Input cancelled: '" var "' (Title: '" t "')")
    } else if (ErrorLevel = 2) {
        Log("Timeout occurred: '" var "' (Title: '" t "')")
    } else if (ErrorLevel = 0) {
        Log("Input received: '" var "' (Title: '" t "')")
    } else {
        Log("Unknown ErrorLevel: " ErrorLevel)
    }
        return var
}

StringTrim(text, maxLength) {    ;;∙------∙Helper function to trim long strings.
    return (StrLen(text) > maxLength) ? SubStr(text, 1, maxLength) "..." : text
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

