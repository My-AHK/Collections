
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
;;∙============∙ MISCELLANEOUS ∙===============================∙
;;∙============================================================∙
SetBatchLines, -1 	;;∙------∙Make the script run at maximum speed.
Process, Priority,, R 	;;∙------∙Set script process priority to Realtime.

This := "Volume" 	;;∙------∙Store title for GUI 2.
That := "Window Transparency"    ;;∙------∙Store title for GUI 3.
Ok := "System Info" 	;;∙------∙Store title for GUI 4.

;;∙============================================================∙
;;∙============∙ GUI 1 ∙=========================================∙
;;∙=========∙ Main Menu ∙=======================================∙
;;∙============================================================∙
SysGet, Workarea, MonitorWorkArea    ;;∙------∙Get primary monitor dimensions.
Gui, Color, ABCDEF
Gui, Add, Text, x15 y10 w400 h30 BackgroundTrans, Choose a function by`nclicking on its button.    ;;∙------∙Instructional text.
Gui, Add, Button, x15 y+5 w100 h25 gSound BackgroundTrans, Sound Settings    ;;∙------∙Add sound settings button.
Gui, Add, Button, x15 y+5 w100 h25 gWindow, Window Settings    ;;∙------∙Add window settings button.
Gui, Add, Button, x15 y+5 w100 h25 gSys, System Info    ;;∙------∙Add system info button.
Gui, Add, Button, x60 y+5 w55 h25 gEscape, Close    ;;∙------∙Add close button.
Gui, Show, %WorkArea% w130 h170, Settings Utility    ;;∙------∙Display main GUI.
Return

;;∙============================================================∙
;;∙============∙ GUI 2 ∙=========================================∙
;;∙========∙ Sound Settings ∙=====================================∙
;;∙============================================================∙
Sound:    ;;∙------∙Sound settings button handler.
Gui, 1:Submit    ;;∙------∙Hide main GUI without destroying it.
SoundGet, Masta, Master, Volume  	;;∙------∙Retrieve master volume level.
SoundGetWaveVolume, Waver 	;;∙------∙Retrieve wave output volume.
SoundGet, Mic, Microphone, Volume 	;;∙------∙Retrieve microphone volume.
SoundGet, Compa, PCSPEAKER, Volume 	;;∙------∙Retrieve PC speaker volume.
SoundGet, Head, Headphones, Volume 	;;∙------∙Retrieve headphones volume.

;;∙------∙Slider controls.
Gui, 2:Color, ABCDEF
Gui, 2:Add, Slider, x35 y40 w30 h125 gTreb vTreb Vertical Invert TickInterval5, %Mic% 		;;∙------∙Microphone volume slider.
Gui, 2:Add, Slider, x145 y40 w30 h125 gHead vHead TickInterval5 Invert Vertical, %Head% 		;;∙------∙Headphones volume slider.
Gui, 2:Add, Slider, x20 y205 w750 h35 gBass vBass Range0-100 TickInterval10, %Compa% 		;;∙------∙PC speaker volume slider.
Gui, 2:Add, Slider, x65 y260 w715 h20 gDurat vDuration Range100-10000 TickInterval1000, 500 	;;∙------∙Beep duration slider.
Gui, 2:Add, Slider, x250 y40 w30 h125 gWave vWave Vertical Line1 Invert TickInterval5, %Waver% 	;;∙------∙Wave volume slider.
Gui, 2:Add, Slider, x350 y40 w30 h125 gMaster vMaster Vertical Invert TickInterval5, %Masta% 	;;∙------∙Master volume slider.

;;∙------∙Group Boxes.
Gui, 2:Add, GroupBox, x10 y25 w65 h155, Microphone 	;;∙------∙Microphone group container.
Gui, 2:Add, GroupBox, x120 y25 w65 h155, Headphones 	;;∙------∙Headphones group container.
Gui, 2:Add, GroupBox, x10 y190 w785 h120, PC Speaker 	;;∙------∙PC Speaker group container.
Gui, 2:Add, GroupBox, x55 y240 w725 h60, Beep Duration 	;;∙------∙Beep duration group container.
Gui, 2:Add, GroupBox, x225 y25 w65 h155, Wave 		;;∙------∙Wave group container.
Gui, 2:Add, GroupBox, x325 y25 w65 h155, Master 		;;∙------∙Master volume group container.

;;∙------∙Value Displays.
Gui, 2:Add, Edit, x392 y40 w25 h20 vEdit1 ReadOnly, %Masta% 	;;∙------∙Master volume display.
Gui, 2:Add, Edit, x292 y40 w25 h20 vEdit2 ReadOnly, %Waver% 	;;∙------∙Wave volume display.
Gui, 2:Add, Edit, x187 y40 w25 h20 vEdit6 ReadOnly, %Head% 	;;∙------∙Headphones volume display.
Gui, 2:Add, Edit, x15 y280 w40 h20 vEdit5 ReadOnly, 500 		;;∙------∙Beep duration display.
Gui, 2:Add, Edit, x15 y240 w40 h20 vEdit3 ReadOnly, %Compa% 	;;∙------∙PC speaker volume display.
Gui, 2:Add, Edit, x77 y40 w25 h20 vEdit4 ReadOnly, %Mic% 		;;∙------∙Microphone volume display.

;;∙------∙Mute Checkboxes.
Gui, 2:Add, CheckBox, x15 y165 vRadio gRadio, Mute 	;;∙------∙Microphone mute checkbox.
Gui, 2:Add, CheckBox, x125 y165 vRadio3 gRadio3, Mute 	;;∙------∙Headphones mute checkbox.
Gui, 2:Add, CheckBox, x230 y165 vRadio1 gRadio1, Mute 	;;∙------∙Master mute checkbox.
Gui, 2:Add, CheckBox, x330 y165 vRadio2 gRadio2, Mute 	;;∙------∙Wave mute checkbox.

Gui, 2:Show, %WorkArea% w800 h325, %This%    ;;∙------∙Display sound settings GUI.
Return 

;;∙============================================================∙
;;∙============∙ GUI 3 ∙=========================================∙
;;∙====∙ Window Transparency ∙===================================∙
;;∙============================================================∙
Window:    ;;∙------∙Window settings button handler.
Gui, 1:Submit    ;;∙------∙Hide main GUI
Gui, 3:Color, ABCDEF
Gui, 3:Add, GroupBox, x10 y20 w135 h60, Transparency    ;;∙------∙Transparency group container.
Gui, 3:Add, Slider, x16 y40 w120 h30 gTrans vTrans Range0-255 Invert TickInterval8, 255    ;;∙------∙Transparency slider.
Gui, 3:Add, Edit, x146 y40 w25 h20 vEdit5 ReadOnly, 255    ;;∙------∙Transparency value display.
Gui, 3:Show, %WorkArea% w180 h100, %That%    ;;∙------∙Display transparency GUI.
Return 

;;∙============================================================∙
;;∙============∙ GUI 4 ∙=========================================∙
;;∙=========∙ System Info ∙=======================================∙
;;∙============================================================∙
Sys:    ;;∙------∙System info button handler.
Gui, 1:Submit  ; Hide main GUI
;;∙------∙Buttons.
Gui, 4:Add, Button, x140 y680 w50 h20 +Default gSubmit, Update    ;;∙------∙System info refresh button.

;;∙------∙Info labels.
Gui, 4:Color, ABCDEF
Gui, 4:Add, Text, x5 y0, MouseWheel Count 
Gui, 4:Add, Text, x5 y40, Mouse Button Count 
Gui, 4:Add, Text, x5 y80, Screen Resolution 
Gui, 4:Add, Text, x5 y120, Current Time 
Gui, 4:Add, Text, x5 y165, System Uptime (ms) 
Gui, 4:Add, Text, x5 y205, Date 
Gui, 4:Add, Text, x5 y245, Mouse Position (Screen) 
Gui, 4:Add, Text, x5 y285, AHK Version 
Gui, 4:Add, Text, x5 y515, Computer Name 
Gui, 4:Add, Text, x5 y325, Username 
Gui, 4:Add, Text, x5 y365, System Language 
Gui, 4:Add, Text, x5 y400, OS Type 
Gui, 4:Add, Text, x5 y435, IP Address 
Gui, 4:Add, Text, x5 y475, Cursor Type 
Gui, 4:Add, Text, x5 y550, Physical Idle Time 
Gui, 4:Add, Text, x5 y590, Mouse Position (Active Window)

;;∙------∙Value Displays.
Gui, 4:Add, Edit, x5 y15 w25 vText1 ReadOnly, 	;;∙------∙Mouse wheel count display.
Gui, 4:Add, Edit, x5 y55 w25 vText2 ReadOnly, 	;;∙------∙Mouse button count display.
Gui, 4:Add, Edit, x5 y95 w85 vText3 ReadOnly, 	;;∙------∙Screen width display.
Gui, 4:Add, Edit, x95 y95 w60 vText9 ReadOnly, 	;;∙------∙Screen pixel count display.
Gui, 4:Add, Edit, x5 y140 w60 vText4 ReadOnly, 	;;∙------∙Current time display.
Gui, 4:Add, Edit, x5 y180 w100 vText5 ReadOnly, 	;;∙------∙Uptime display.
Gui, 4:Add, Edit, x5 y220 w140 vText6 ReadOnly, 	;;∙------∙Date display.
Gui, 4:Add, Edit, x5 y260 w115 vText7 ReadOnly, 	;;∙------∙Mouse position display.
Gui, 4:Add, Edit, x5 y300 w160 vText8 ReadOnly, 	;;∙------∙AHK version display.
Gui, 4:Add, Edit, x5 y530 w140 vText10 ReadOnly, 	;;∙------∙Computer name display.
Gui, 4:Add, Edit, x5 y340 w120 vText11 ReadOnly, 	;;∙------∙Username display.
Gui, 4:Add, Edit, x5 y380 w150 vText12 ReadOnly, 	;;;∙------∙System language display.
Gui, 4:Add, Edit, x5 y415 w100 vText13 ReadOnly, 	;;∙------∙OS type display.
Gui, 4:Add, Edit, x5 y450 w150 vText14 ReadOnly, 	;;∙------∙IP address display.
Gui, 4:Add, Edit, x5 y495 w100 vText15 ReadOnly, 	;;∙------∙Cursor type display.
Gui, 4:Add, Edit, x5 y570 w100 vText16 ReadOnly, 	;;∙------∙Physical idle time display.
Gui, 4:Add, Edit, x5 y610 w115 vText17 ReadOnly, 	;;∙------∙Relative mouse position display.
Gui, 4:Show, %WorkArea% AutoSize, %OK% 	;;∙------∙Display system info GUI.
Return 

;;∙============================================================∙
;;∙============∙ SYSTEM INFO CONTROLS ∙========================∙
;;∙============================================================∙
Submit:    ;;∙------∙System info update handler.
Gui, 4:Submit, NoHide    ;;∙------∙Preserve GUI state while updating.
SysGet, MouseWheelCount, 75    ;;∙------∙Get number of mouse wheel lines.
GuiControl, 4:, Text1, %MouseWheelCount%    ;;∙------∙Update mouse wheel display.
SysGet, MouseButtonCount, 43    ;;∙------∙Get number of mouse buttons.
GuiControl, 4:, Text2, %MouseButtonCount%    ;;∙------∙Update mouse button display.
SysGet, ScreenWidth, 16    ;;∙------∙Get screen width.
SysGet, ScreenHeight, 17    ;;∙------∙Get screen height.
GuiControl, 4:, Text3, %ScreenWidth%x%ScreenHeight%    ;;∙------∙Update resolution display.
GuiControl, 4:, Text4, %A_Hour%:%A_Min%:%A_Sec%    ;;∙------∙Update time display.
GuiControl, 4:, Text5, %A_TickCount%    ;;∙------∙Update uptime display.
GuiControl, 4:, Text6, %A_DDDD%, %A_MMMM% %A_DD%  %A_Year%    ;;∙------∙Update date display.
CoordMode, Mouse, Screen    ;;∙------∙Set mouse coord mode to screen.
MouseGetPos, Posx, Posy    ;;∙------∙Get current mouse position.
GuiControl, 4:, Text7, X:%Posx% | Y:%PosY%    ;;∙------∙Update mouse position display.
GuiControl, 4:, Text8, %A_AhkVersion%    ;;∙------∙Update AHK version display.
PixelCount := ScreenWidth * ScreenHeight    ;;∙------∙Calculate total pixels.
GuiControl, 4:, Text9, %PixelCount%    ;;∙------∙Update pixel count display.
GuiControl, 4:, Text10, %A_ComputerName%    ;;∙------∙Update computer name display.
GuiControl, 4:, Text11, %A_UserName%    ;;∙------∙Update username display.

;;∙------∙Language conversion
the_language := A_Language    ;;∙------∙Get system language code
langMap := { "0436": "Afrikaans", "041c": "Albanian", "0401": "Arabic", "042b": "Armenian"
    , "042c": "Azeri", "0423": "Belarusian", "0402": "Bulgarian", "0403": "Catalan"
    , "0404": "Chinese (TW)", "0804": "Chinese (PRC)", "041a": "Croatian", "0405": "Czech"
    , "0406": "Danish", "0413": "Dutch", "0409": "English (US)", "0809": "English (UK)"
    , "040b": "Finnish", "040c": "French", "0437": "Georgian", "0407": "German"
    , "0408": "Greek", "040d": "Hebrew", "0439": "Hindi", "040e": "Hungarian"
    , "040f": "Icelandic", "0421": "Indonesian", "0410": "Italian", "0411": "Japanese"
    , "043f": "Kazakh", "0412": "Korean", "0426": "Latvian", "0427": "Lithuanian"
    , "042f": "Macedonian", "043e": "Malay", "0414": "Norwegian", "0415": "Polish"
    , "0416": "Portuguese", "0418": "Romanian", "0419": "Russian", "041b": "Slovak"
    , "0424": "Slovenian", "040a": "Spanish", "0441": "Swahili", "041d": "Swedish"
    , "041e": "Thai", "041f": "Turkish", "0422": "Ukrainian", "0420": "Urdu", "042a": "Vietnamese" }    ;;∙------∙Language code map.

If langMap.HasKey(the_language)    ;;∙------∙Check if code exists in map.
    the_language := langMap[the_language]    ;;∙------∙Convert to language name.

GuiControl, 4:, Text12, %the_language%    ;;∙------∙Update language display.
GuiControl, 4:, Text13, %A_OSType%    ;;∙------∙Update OS type display.
GuiControl, 4:, Text14, %A_IPAddress1%    ;;∙------∙Update IP address display.
GuiControl, 4:, Text15, %A_Cursor%    ;;∙------∙Update cursor type display.
GuiControl, 4:, Text16, %A_TimeIdlePhysical%    ;;∙------∙Update physical idle time display.
Coordmode, Mouse, Relative    ;;∙------∙Set mouse coord mode to active window.
MouseGetPos, Pos1x, Pos1y    ;;∙------∙Get relative mouse position.
GuiControl, 4:, Text17, X:%Pos1x% | Y:%Pos1Y%    ;;∙------∙Update relative position display.
return 

;;∙============================================================∙
;;∙============∙ SOUND CONTROLS ∙==============================∙
;;∙============================================================∙
Radio1:    ;;∙------∙Master mute toggle.
Gui, 2:Submit, NoHide 
SoundSet, % (Radio1 ? 1 : 0), Master, Mute    ;;∙------∙Toggle mute based on checkbox.
return 

Radio2:    ;;∙------∙Wave mute toggle.
Gui, 2:Submit, NoHide 
SoundSet, % (Radio2 ? 1 : 0), Wave, Mute    ;;∙------∙Toggle mute based on checkbox.
return 

Radio:    ;;∙------∙Microphone mute toggle.
Gui, 2:Submit, NoHide 
SoundSet, % (Radio ? 1 : 0), Microphone, Mute    ;;∙------∙Toggle mute based on checkbox.
return 

Radio3:    ;;∙------∙Headphones mute toggle.
Gui, 2:Submit, NoHide
SoundSet, % (Radio3 ? 1 : 0), Headphones, Mute    ;;∙------∙Toggle mute based on checkbox.
return

Head:    ;;∙------∙Headphones volume change.
Gui, 2:Submit, NoHide
SoundSet, %Head%, Headphones, Volume    ;;∙------∙Set new volume.
GuiControl,, Edit6, %Head%    ;;∙------∙Update display.
return

Master:    ;;∙------∙Master volume change.
Gui, 2:Submit, NoHide 
SoundSet, %Master%, Master, Volume    ;;∙------∙Set new volume.
GuiControl,, Edit1, %Master%    ;;∙------∙Update display.
return 

Wave:    ;;∙------∙Wave volume change.
Gui, 2:Submit, NoHide 
SoundSetWaveVolume, %Wave%    ;;∙------∙Set new volume.
GuiControl,, Edit2, %Wave%    ;;∙------∙Update display.
return 

Treb:    ;;∙------∙Microphone volume change.
Gui, 2:Submit, NoHide 
SoundSet, %Treb%, Microphone, Volume    ;;∙------∙Set new volume.
GuiControl,, Edit4, %Treb%    ;;∙------∙Update display.
return 

Bass:    ;;∙------∙PC Speaker volume change.
Gui, 2:Submit, NoHide 
SoundSet, %Bass%, PCSPEAKER, Volume    ;;∙------∙Set new volume.
GuiControl,, Edit3, %Bass%    ;;∙------∙Update display.
return 

Durat:    ;;∙------∙Beep duration change.
Gui, 2:Submit, NoHide
GuiControl,, Edit5, %Duration%    ;;∙------∙Update duration display.
return 

;;∙============================================================∙
;;∙============∙ TRANSPARENCY WINDOW ∙=======================∙
;;∙============================================================∙
Trans:    ;;∙------∙Transparency slider handler.
Gui, 3:Submit, NoHide 
WinGet, activeID, ID, A     ;;∙------∙Get active window ID.
WinSet, Transparent, %Trans%, ahk_id %activeID%    ;;∙------∙Apply transparency.
GuiControl,, Edit5, %Trans%    ;;∙------∙Update display.
Return 

;;∙============================================================∙
;;∙============∙ CLOSE HANDLERS ∙===============================∙
;;∙============================================================∙
3GuiClose:    ;;∙------∙GUI 3 close handler.
4GuiClose:    ;;∙------∙GUI 4 close handler.
2GuiClose:    ;;∙------∙GUI 2 close handler.
Gui, Destroy    ;;∙------∙Destroy current GUI.
Return 

GuiClose:
Escape:
ExitApp
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

