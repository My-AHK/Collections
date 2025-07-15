
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
;;∙--------------------------------------------------------------------∙
#include FadeText.ahk
^t::    ;;∙------∙🔥∙(Ctrl + T)

FadeText("This text is centered, auto-sized, and fades fast." , Trans := 1500 , Speed := 10 , FontSize := 18 , Width := 0, Height := 0 , X := 0, Y := 0)
Sleep 3000

FadeText("This text is centered, auto-sized, and fades slowly." , Trans := 500 , Speed := 2 , FontSize := 18 , Width := 0, Height := 0 , X := 0, Y := 0)
Sleep 5000

FadeText("This window has the following sizes/positions:`nWidth = 500`nHeight = 300`nX-Pos = 300`nY-Pos = 200" , Trans := 1500 , Speed := 5 , FontSize := 18 , Width := 500, Height := 300 , X := 300, Y := 200)
Sleep 5500

FadeText("This window is Y-limited by the screen height." , Trans := 1000 , Speed := 0 , FontSize := 36 , Width := 400, Height := 0 , X := 0, Y := 2000)
Sleep 3500

FadeText("This window is X-limited by the screen width." , Trans := 1000 , Speed := 0 , FontSize := 36 , Width := 400, Height := 0 , X := 2000, Y := 0)
Sleep 3500

FadeText("This text is red on a black background without a border.`nThe font is Courier." , Trans := 1000 , Speed := 0 , FontSize := 0 , Width := 0, Height := 0 , X := 0, Y := 0, TextColor := "Red", BgColor := "Black", Boderderless := 1, Font := "Courier")
Sleep 4500

FadeText("This text has more than one row.`n...and some rows are blank...`n`n`nThe script automatically scales the fontsize." , Trans := 1200, Speed , FontSize , Width := 200 , Height := 150 , X , Y , TextColor , BgColor , Boderderless)
Sleep 5000

FadeText("These are default settings..." , Trans := 0 , Speed := 0 , FontSize := 0 , Width := 0, Height := 0 , X := 0, Y := 0)
Sleep 2500

MsgBox,,, Thanks for watching! :-),3
Return


/*∙-------------------------------------------------------------------∙
;;∙======∙FadeText Parameters Explained
FadeText(Text, Trans, Speed, FontSize, Width, Height, X, Y, TextColor, BgColor, Borderless, Font)

Core Parameters:
  • Text - The actual text string to display (supports multi-line with \n)
  • Trans - Transparency duration in milliseconds
    ▹ How long the text stays visible before starting to fade
    ▹ Range: 1-5000ms (default: 500ms)
    ▹ Higher = text stays visible longer before fading
  • Speed - Fade speed
    ▹ How fast the text fades out (transparency decreases per timer tick)
    ▹ Range: 1-20 (default: 4)
    ▹ Higher = fades faster, Lower = fades slower

Display Properties:
  • FontSize - Text size in points (default: 18, max: 200)
    ▹ If 0 with Width/Height specified = auto-scales to fit
  • Width - Window width in pixels (default: 300, max: screen width)
    ▹ 0 = auto-size to content
  • Height - Window height in pixels (default: auto, max: screen height)
    ▹ 0 = auto-size to content

Positioning:
  • X - Horizontal position from left edge (default: 0 = centered)
  • Y - Vertical position from top edge (default: 0 = centered)

Styling:
  • TextColor - Text color (default: black)
    ▹ Accepts color names ("Red", "Blue") or hex codes
  • BgColor - Background color (default: grey)
    ▹ Accepts color names ("Black", "White") or hex codes
  • Borderless - Window border display
    ▹ 0 = show border (default)
    ▹ 1 = borderless window
  • Font - Font family name (default: "Arial")
    ▹ Any installed system font ("Courier", "Times New Roman", etc.)
;;∙--------------------------------------------------------------------∙
*/
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

