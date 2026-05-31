

/*
Use any time a SoundBeep or MsgBox would land inside a loop, timer, hotkey chain, or error handler where blocking would cause missed keystrokes, stalled timers, or a degraded user experience.



*/


;;∙======∙DIRECTIVES & SETTINGS∙==================∙
#Requires AutoHotkey 1
#NoEnv
#SingleInstance, Force
SendMode, Input
SetWorkingDir %A_ScriptDir%
SetTimer, UpdateCheck, 500
GoSub, TrayMenu


;;∙======∙ASYNCHRONOUS FUNCTIONS∙==============∙
;;∙------∙(* define before hotkey calls *)

;;∙------∙Asynchronous MsgBox∙--------------∙
aMsgBox(Text, Title := "Alert", Timeout := 0) {
    AutoHotkeyPath := A_AhkPath
    shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec("""" AutoHotkeyPath """ *")
    Script := "msg =`n(" . "`n" . Text . "`n)`n"
   ; Script := "msg =`n(" "`n" Text "`n)`n"
    if (Timeout > 0)
        Script .= "MsgBox, 262144, " Title ", %msg%, " Timeout "`nExitApp"
    else
        Script .= "MsgBox, 0, " Title ", %msg%`nExitApp"
    exec.StdIn.Write(Script)
    exec.StdIn.Close()
}

;;∙------∙Asynchronous SoundBeep∙----------∙
aSoundBeep(Frequency, Duration) {
    AutoHotkeyPath := A_AhkPath    
    shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec("""" AutoHotkeyPath """ *")
    exec.StdIn.Write("SoundBeep, " Frequency "," Duration "`nExitApp")
    exec.StdIn.Close()
}


;;∙======∙USAGE EXAMPLES∙========================∙
;;∙--------------------------------------------------------------∙
;;∙------∙aMsgBox() spawns a separate process & returns instantly, so the SoundBeeps don't wait for the user to close the dialog.
;;∙------∙All five SoundBeeps play in sequence while the MsgBox is still open.

F1::    ;;∙------∙🔥∙Non-blocking MsgBox.

aMsgBox("Imagine that, the SoundBeeps`ndidn't wait for the MsgBox to end.", "Alert", 10)

    SoundBeep, 1000, 1500
    SoundBeep, 800, 1500
    SoundBeep, 1200, 1500
    SoundBeep, 1400, 1500
    SoundBeep, 1000, 1500
Return

;;∙--------------------------------------------------------------∙
;;∙------∙aSoundBeep() spawns a separate process & returns instantly, so the MsgBox appears immediately without waiting for the beep to finish.
;;∙------∙The 8-second beep plays in the background while the MsgBox is already open, and the MsgBox closes 2 seconds before the beep completes.

F2::    ;;∙------∙🔥∙Non-blocking SoundBeep.

aSoundBeep(1200, 8000)    ;;∙------∙Plays in background, returns instantly.
    MsgBox,,, This MsgBox appears immediately while`nthe 8-second SoundBeep plays in another`nprocess then closes 2-seconds before`nthe beep completes., 6
Return

;;∙--------------------------------------------------------------∙
;;∙------∙A normal SoundBeep(1000, 5000) would freeze all hotkeys for 5 seconds, making Send and Sleep unreachable until the beep finishes.
;;∙------∙aSoundBeep() spawns a separate process & returns instantly, so Send and Sleep fire without waiting for the beep to complete.

F3::    ;;∙------∙🔥∙Hotkey That Must Keep Running Immediately.
    aSoundBeep(1000, 5000)    ;;∙------∙Long alarm plays in background, returns instantly.
    Send, ^c    ;;∙------∙These all fire instantly, not after the beep completes.
    Sleep, 50
    Send, ^v
Return

;;∙--------------------------------------------------------------∙
;;∙------∙A normal MsgBox inside a timer callback would defer the timer thread until user clicks OK, causing missed or delayed clipboard checks during that window.
;;∙------∙aMsgBox() spawns a separate process & returns instantly, so the timer keeps firing on schedule regardless of whether the dialog is still open.

SetTimer, WatchClipboard, 500        ;;∙------∙Registered at script load.

F4::    ;;∙------∙🔥∙Toggle timer on/off for demonstration.
    MsgBox,, Clipboard Watch, Timer is running. Trigger it by copying text with "password"., 3
Return

WatchClipboard:
    static LastClipboard := ""
    CurrentClipboard := Clipboard
    if (CurrentClipboard != LastClipboard)
    {
        LastClipboard := CurrentClipboard
        if (CurrentClipboard ~= "i)password")
        {
            aMsgBox("⚠️ Sensitive word detected in clipboard!", "Warning", 5)
            aSoundBeep(500, 300)
        }
    }
Return

;;∙--------------------------------------------------------------∙
;;∙------∙A normal SoundBeep or MsgBox inside a loop would stall each iteration, delaying feedback until the beep or dialog finishes before the next file is processed.
;;∙------∙aSoundBeep() & aMsgBox() both return instantly, so the loop keeps processing without waiting, and each progress dialog auto-closes before the next one appears.

F5::    ;;∙------∙🔥∙User gets audio & visual feedback immediately every 25 files without the loop stalling.

    Loop, 100
    {
        Sleep, 100    ;;∙------∙Simulates per-file processing time (100ms × 25 files = 2.5s between progress updates)
        if (Mod(A_Index, 25) = 0) {
            aSoundBeep(1000, 200)    ;;∙------∙Tick sound doesn't stall loop.
            aMsgBox("Processed " A_Index " of 100 files.", "Progress", 2)    ;;∙------∙Non-blocking, auto-closes in 2s (before next update at 2.5s)
        }
    }
    
    ;;∙------∙Final completion notification.
    aSoundBeep(1500, 500)
    aMsgBox("All 100 files processed!", "Complete", 5)
Return

;;∙--------------------------------------------------------------∙
;;∙------∙A normal MsgBox inside a catch block would block script execution until the user clicks OK.
;;∙------∙aMsgBox() & aSoundBeep() both return instantly, so the handler exits quickly & the script resumes on the line after the try/catch without waiting for dialog or beep.

F6::    ;;∙------∙🔥∙Script resumes immediately after the error, dialog & beep finish in the background.

    try {
        throw Exception("Test Error")    ;;∙------∙Intentionally throws an exception to demonstrate the handler.
    } catch e {
        aMsgBox("Error: " e.Message "`nLine: " e.Line, "Script Error", 8)    ;;∙------∙Non-blocking, handler continues instantly.
        aSoundBeep(600, 1500)    ;;∙------∙Low warning tone, non-blocking.
    }
    ToolTip, Script resumed after error.    ;;∙------∙Proves execution continued without waiting for the dialog.
    Sleep, 2000
    ToolTip
Return

;;∙--------------------------------------------------------------∙





;;∙==============================================∙



;;∙======∙SCRIPT EDIT / RELOAD / EXIT∙==============∙
;;∙------∙EDIT∙---------------------------∙
Script·Edit:    ;;∙------∙Menu Call.
    Edit
Return

;;∙------∙RELOAD∙-----------------------∙
^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        ;;∙------∙Soundbeep, 1000, 200
    Reload
Return

;;∙------∙EXIT∙----------------------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        ;;∙------∙Soundbeep, 1000, 200
    ExitApp
Return


;;∙======∙SCRIPT UPDATE∙=========================∙
UpdateCheck:    ;;∙------Check if script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload


;;∙======∙TRAY MENU∙=============================∙
TrayMenu:
Menu, Tray, Tip, AsyncBeep
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add

;;∙------∙MENU-EXTENTIONS∙---------∙
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

;;∙------∙MENU-OPTIONS∙-------------∙
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

;;∙------∙EXTENTIONS∙------------------∙
Documentation:
    Run, "C:\Program Files\AutoHotkey\AutoHotkey.chm"
Return
ShowKeyHistory:
    KeyHistory
Return
ShowWindowSpy:
    Run, "C:\Program Files\AutoHotkey\WindowSpy.ahk"
Return

;;∙------∙MENU-HEADER∙---------------∙
TEMPLATE:    ;;∙------∙Suspends hotkeys then pauses script.
    Suspend
    Soundbeep, 800, 200
    Pause
Return


;;∙======∙TRAY MENU POSITION∙====================∙
;;∙------∙TRAY MENU SHOW∙--------∙
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20
Return

;;∙------∙POSITION FUNTION∙-------∙
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

