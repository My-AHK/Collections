
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
    ▹ 🎚️ 🎚️
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TEMPLATE"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙



/*    	* * 10-Variable Progress Bar Function * * ShowProgressBar (1,2,3,4,5,6,7,8,9,10)
ShowProgressBar (aboveText, aTextColor, pBarColor, pBarBkgColor, belowText, bTextColor, allWidths, steps:=48, stepDelay:=16, postDelay:=1750)

aboveText   ∙------∙   Text above the progress bar.
aTextColor   ∙------∙   Color of text above the progress bar.
pBarColor   ∙------∙   Progress bar color.
pBarBkgColor   ∙------∙   Progress bar background color.
belowText   ∙------∙   Text below the progress bar.
bTextColor   ∙------∙   Color of text below the progress bar.
allWidths   ∙------∙   Progress bar width setting. 
steps   ∙------∙   Total number of increments for progress completion (default: 48).
stepDelay   ∙------∙   Time between progress increments (default: 16ms /about ~60Hz refresh rate).
postDelay   ∙------∙   Time to display completed bar before closing (default: 500ms).
*/


;;∙======∙HOTKEY EXAMPLES∙=====================================∙
;;∙------------------------------------------------------------------------------------------∙
^Numpad1::    ;;∙------∙🔥∙(Ctrl + Numberpad1) Starting progress bar.
    ShowProgressBar("Starting...", "Blue", "16DE16", "000000", "( Ctrl + Esc )`nto Exit Script", "DEDE16", 160)
Return
;;∙---------------------------------------------∙
^Numpad2::    ;;∙------∙🔥∙(Ctrl + Numberpad2) Stopping progress bar.
    ShowProgressBar("Stopping...", "Aqua", "Red", "000000", "Exiting`nScript", "DE1616", 160, 48, 16, 3750)
Return
;;∙---------------------------------------------∙
^Numpad3::    ;;∙------∙🔥∙(Ctrl + Numberpad3) Fast-to-Slow (Ease-Out).
    delays := GenerateEaseOutDelays(48, 16, 3)
    ShowProgressBar("Processing...", "Yellow", "FFA500", "222222", "Almost there...", "FFFFFF", 160, 48,, 1000, delays)
Return
;;∙---------------------------------------------∙
^Numpad4::    ;;∙------∙🔥∙(Ctrl + Numberpad4)  Slow-to-Fast (Ease-In).
    delays := GenerateEaseInDelays(24, 32, 2)
    ShowProgressBar("Initializing...", "Silver", "888888", "111111", "Preparing modules", "CCCCCC", 180, 24,, 500, delays)
Return
;;∙---------------------------------------------∙
^Numpad5::    ;;∙------∙🔥∙(Ctrl + Numberpad5)  Pulsing Effect.
    delays := GeneratePulseDelays(36, 20)
    ShowProgressBar("Scanning...", "Lime", "00FF00", "002200", "Checking files", "88FF88", 200, 36,, 800, delays)
Return
;;∙---------------------------------------------∙
^Numpad6::    ;;∙------∙🔥∙(Ctrl + Numberpad6) Custom "stair-step" pattern.
    delays := []
    Loop, 48 {
        if (A_Index <= 12)
            delays.Push(50)    ;;∙------∙Slow initial phase.
        else if (A_Index <= 36)
            delays.Push(10)    ;;∙------∙Fast middle phase.
        else
            delays.Push(30)    ;;∙------∙Moderate final phase.
    }
    
    ShowProgressBar("Advanced Load"    ;;∙------∙aboveText
        ,"FF8800"    ;;∙------∙aTextColor (Orange)
        ,"0088FF"     ;;∙------∙pBarColor (Blue)
        ,"002244"    ;;∙------∙pBarBkgColor (Dark Blue)
        ,"Phase: Custom"    ;;∙------∙belowText
        ,"88FF88"    ;;∙------∙bTextColor (Light Green)
        ,220    ;;∙------∙allWidths
        ,48    ;;∙------∙steps
        ,    ;;∙------∙stepDelay (blank = use default)
        ,1200    ;;∙------∙postDelay
        ,delays)    ;;∙------∙delayArray
Return
;;∙------------------------------------------------------------------------------------------∙


;∙================∙PROGRESS BAR FUNCTION∙====================∙
;;∙-----------------------------------------------------------------------------------------∙
ShowProgressBar(aboveText, aTextColor, pBarColor, pBarBkgColor, belowText, bTextColor, allWidths, steps:=48, stepDelay:=16, postDelay:=1750, delayArray:="") {
    Gui, New
    Gui, Color, 010101
    Gui +AlwaysOnTop -Caption
    Gui +LastFound
    WinSet, TransColor, 010101

    ;;∙------∙Above text.
    Gui, Font, s14 Bold c%aTextColor% q5, Segoe UI
    Gui, Add, Text, Center x0 y0 cBlack w%allWidths% BackgroundTrans, %aboveText%    ;;∙------∙Text contrast shadow.
    Gui, Add, Text, Center x1 yp+1 w%allWidths% BackgroundTrans, %aboveText%

    ;;∙------∙Progress bar.
    Gui, Add, Progress, xCenter y+3 w%allWidths% h10 c%pBarColor% Background%pBarBkgColor% Range1-%steps% HwndhProgress

    ;;;∙------∙Below text.
    Gui, Font, s10 w600 c%bTextColor% q5, Segoe UI
    Gui, Add, Text, x0 y+3 Center cBlack w%allWidths% BackgroundTrans, %belowText%    ;;∙------∙Text contrast shadow.
    Gui, Add, Text, x1 yp+1 Center w%allWidths% BackgroundTrans, %belowText%

    Gui, Show
    GuiControl,, %hProgress%, 0
    
    Loop, %steps% {
        currentDelay := (delayArray != "") ? delayArray[A_Index] : stepDelay
        GuiControl,, %hProgress%, +1
        Sleep, %currentDelay%
    }
    Sleep, %postDelay%
    Gui, Destroy
}

;;∙-------------------------------------------------------∙
;;∙--------------∙HELPER FUNCTIONS∙--------------∙
;;∙------∙Linear (default)
GenerateLinearDelays(steps, baseDelay) {
    arr := []
    Loop, %steps%
        arr.Push(baseDelay)
    return arr
}

;;∙------∙Ease-in (start slow → end fast)
GenerateEaseInDelays(steps, baseDelay, intensity:=2) {
    arr := []
    Loop, %steps% {
        t := (A_Index/steps)
        arr.Push(Round(baseDelay * (1 - t**intensity)))
    }
    return arr
}

;;∙------∙Ease-out (start fast → end slow)
GenerateEaseOutDelays(steps, baseDelay, intensity:=2) {
    arr := []
    Loop, %steps% {
        t := (A_Index/steps)
        arr.Push(Round(baseDelay * t**intensity))
    }
    return arr
}

;;∙------∙Pulse (slow-fast-slow)
GeneratePulseDelays(steps, baseDelay) {
    arr := []
    Loop, %steps% {
        pos := (A_Index/steps) * 3.14159 ; π radians
        arr.Push(Round(baseDelay * (1 + Sin(pos))/2))
    }
    return arr
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

