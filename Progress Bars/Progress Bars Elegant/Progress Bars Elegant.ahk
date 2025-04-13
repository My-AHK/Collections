
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
;;∙======∙STARTING PROGRESS BAR∙===============================∙
;;∙----------------∙SETTINGS∙------------------------------------------------------------∙
allWidths1 := "160"    ;;∙------∙Width for all.

aboveText1 := "Starting..."    ;;∙------∙Text above progress bar 1.
aTextColor1 := "1616DE"    ;;∙------∙Text above progress bar 1 color (Blue).

pBarColor1 := "16DE16"    ;;∙------∙Progress bar 1 color (Green).
pBarBkgColor1 := "000000"    ;;∙------∙Progress bar 1 background color (Black).

belowText1 := "( Ctrl + Esc )`nto Exit Script"    ;;∙------∙Text below progress bar 1.
bTextColor1 := "DEDE16"    ;;∙------∙Text below progress bar 1 color (Yellow).


allWidths2 := "160"    ;;∙------∙Width for all.

aboveText2 := "Stopping..."    ;;∙------∙Text above progress bar 2.
aTextColor2 := "DEDE16"    ;;∙------∙Text above progress bar 2 color (Yellow).

pBarColor2 := "DE1616"    ;;∙------∙Progress bar 2 color (Red).
pBarBkgColor2 := "000000"    ;;∙------∙Progress bar 2 background color (Black).

belowText2 := "Exiting`nScript"    ;;∙------∙Text below progress bar 2.
bTextColor2 := "16DEDE"    ;;∙------∙Text below progress bar 2 color (Aqua).


;;∙-----------------------------------------------∙
^Numpad1::    ;;∙------∙🔥∙(Ctrl + Numberpad1)
global allWidths1, aboveText1, aTextColor1, pBarColor1, pBarBkgColor1, belowText1, bTextColor1

Gui, New
Gui, Color, 010101
Gui +AlwaysOnTop -Caption
Gui +LastFound    ;;∙------∙Make last found for next line.
WinSet, TransColor, 010101    ;;∙------∙Transparent Gui.

Gui, Font, s14 Bold c%aTextColor1% q5, Segoe UI
Gui, Add, Text, Center x0 y0 cBlack w%allWidths1% BackgroundTrans, %aboveText1%    ;;∙------∙Text contrast shadow.
Gui, Add, Text, Center x1 yp+1 w%allWidths1% BackgroundTrans, %aboveText1%
Gui, Add, Progress, xCenter y+3 w%allWidths1% h10 c%pBarColor1% Background%pBarBkgColor1% Range1-48 vMyProgress
Gui, Font, s10 w600 c%bTextColor1% q5, Segoe UI
Gui, Add, Text, x0 y+3 Center cBlack w%allWidths1% BackgroundTrans, %belowText1%    ;;∙------∙Text contrast shadow.
Gui, Add, Text, x1 yp+1 Center w%allWidths1% BackgroundTrans, %belowText1%
Gui, Show
GuiControl,, MyProgress, 0
    Loop, 48
        {
        GuiControl,, MyProgress, +1
        Sleep, 16
        }
    Sleep 1500
Gui, Destroy
Return

;;∙============================================================∙
;;∙======∙STOPPING PROGRESS BAR∙===============================∙
;;∙------------------------------------------------------------------------------------------∙
^Numpad2::    ;;∙------∙🔥∙(Ctrl + Numberpad2)
global allWidths, aboveText2, aTextColor2, pBarColor2, pBarBkgColor2, belowText2, bTextColor2

Gui, New
Gui, Color, 010101
Gui +AlwaysOnTop -Caption
Gui +LastFound
WinSet, TransColor, 010101

Gui, Font, s14 Bold c%aTextColor2% q5, Segoe UI
Gui, Add, Text, Center x0 y0 cBlack w%allWidths2% BackgroundTrans, %aboveText2%    ;;∙------∙Text contrast shadow
Gui, Add, Text, Center x1 yp+1  w%allWidths2% BackgroundTrans, %aboveText2%
Gui, Add, Progress, xCenter y+3 w%allWidths2% h10 c%pBarColor2% Background%pBarBkgColor2% Range1-48 vMyProgress
Gui, Font, s10 w600 c%bTextColor2% q5, Segoe UI
Gui, Add, Text, x0 y+3 Center cBlack w%allWidths2% BackgroundTrans, %belowText2%    ;;∙------∙Text contrast shadow
Gui, Add, Text, x1 yp+1 Center w%allWidths2% BackgroundTrans, %belowText2%
Gui, Show
GuiControl,, MyProgress, 0
    Loop, 48
        {
        GuiControl,, MyProgress, +1
        Sleep, 16
        }
    Sleep 1500
Gui, Destroy
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

