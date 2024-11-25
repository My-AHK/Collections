
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙--------∙Origins∙-------------------------∙
» Author:  mikeyww
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?f=76&t=37209#p587350
» Can be used to automate the pasting of predefined text ("This","Is Just", and "A Quck Test" in this case) into a window with a slight delay between each pasting to avoid overwhelming the input field(s). This could be useful when working with applications that require controlled pasting intervals, or when copying multiple values into forms sequentially.
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




;;∙============================================================∙
send1 := "This"    ;;∙------∙1st text burst to paste.
send2 := "Is Just"    ;;∙------∙2nd text burst to paste.
send3 := "A Quick Test"    ;;∙------∙3rd text burst to paste.
PasteWait := 150    ;;∙------∙Milliseconds to wait after each burst pasting.

Paste(send1)    ;;∙------∙Call Paste() function to paste string 'send1'.
;;∙------∙('PasteWait' time)
SendInput, {Enter}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}    ;;∙------∙Send Enter and multiple Tabs in sequence at once.
    Paste(send2)    ;;∙------∙Call Paste() function to paste string 'send2'.
;;∙------∙('PasteWait' time)
SendInput, {Enter}    ;;∙------∙Send Enter individually.
SendInput, {Tab}    ;;∙------∙Send Tab individually.
SendInput, {Tab}    ;;∙------∙Send Tab individually.
    Paste(send3)    ;;∙------∙Call Paste() function to paste string 'send3'.
;;∙------∙('PasteWait' time)
Return    ;;∙------∙End hotkey execution.


;;∙======∙Function To Paste A String With A Delay∙====================∙
Paste(str) {
    Static end  := 0    ;;∙------∙Persistent variable to track end of last paste operation.
    global PasteWait    ;;∙------∙Use global PasteWait variable.
Sleep Max(0, end - A_TickCount)    ;;∙------∙Wait for remaining time until delay has passed.
    Clipboard := ""    ;;∙------∙Clear the clipboard before pasting.
        ClipWait, 0.5    ;;∙------∙Wait up to 0.5 seconds for clipboard to be ready.
     Clipboard := str    ;;∙------∙Set clipboard to the provided string.
Send ^v    ;;∙------∙Paste the string using Ctrl+V.
;;∙------∙Verify if clipboard content matches intended string after pasting.
ClipWait, 1    ;;∙------∙Wait for clipboard to contain data. (1 second timeout)
If (Clipboard = str) {    ;;∙------∙Check if clipboard matches intended string.
    ;;∙------∙*Add optional code here to handle successful pasting*

/*∙-------------------------------------∙(* For testing/can be removed *)
    ToolTip, Pasted Successfully    ;;∙------∙Show a tooltip for successful pasting.
        Sleep, 1000    ;;∙------∙Display tooltip for 1 second.
    ToolTip    ;;∙------∙Remove tooltip.
;;∙--------------------------------------∙(* For testing/can be removed *)
*/

    } else {
    ;;∙------∙Handle error case where clipboard content doesn't match.
    ToolTip, Pasting failed    ;;∙------∙Show a tooltip for failed pasting.
        Sleep, 1000    ;;∙------∙Display tooltip for 1 second.
    ToolTip    ;;∙------∙Remove tooltip.
    }
    Clipboard := ""    ;;∙------∙Clear the clipboard after pasting.
    end := A_TickCount + PasteWait    ;;∙------∙Update end time for next paste operation.
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

