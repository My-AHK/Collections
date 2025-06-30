
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  
» Original Source:  https://pastebin.com/C9VLVAwx
» CaesarCipher
    ▹ 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "CaesarCipher"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙



;;∙============================================================∙
;;∙============================================================∙
/*
Named after Julius Caesar, who used it to protect his messages.
Caesar Cipher is one of the oldest and simplest ways to hide a message. 
It works by shifting the letters of the alphabet by a certain number of steps.
   • Pick a shift number -for example, let's say 3.
   • Each letter in your message gets moved forward by 3 letters in the alphabet.
   • If the shift goes past 'Z', it wraps around to the start of the alphabet.
   • Easy to use but easy to break (because there are only 25 possible shifts).
   * To Decode:  Just shift the letters backward by the same shift number.
*/
;;∙------------------------------------------------------------------------------------------∙
#NoEnv
#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%

iniFile := A_ScriptDir "\caesar_settings.ini"
IniRead, lastShift, %iniFile%, Settings, ShiftValue, -2    ;;∙------∙(Range= -25 to +25)

Gui, color, Black
Gui, +AlwaysOnTop +Resize
Gui, Font, s10, Segoe UI

Gui, Add, Text, x20 y15 cWhite, Enter text for Encode or Decode.:
Gui, Add, Edit, x15 y+5 vUserText w300 h100 WantTab gUpdatePreview

Gui, Add, Text, x330 y15 cYellow, Encoded / Decoded Output:
Gui, Add, Edit, x325 y+5 cGREEN vOutputBox w300 h100 ReadOnly

Gui, Add, Text, x20 y+10 cWhite, Shift Value (-25 to 25):
Gui, Add, Text, vShiftDisplay x+5 w150 cLime Center, Current Shift Value = %lastShift%
Gui, Add, Slider, x15 y+3 vShiftVal Range-25-25 w300 ToolTip TickInterval5 Line5 Page5 gUpdatePreview, %lastShift%

Gui, Add, Text, x350 y145 vStatusText Section w400 cLime,
Gui, Add, Button, x325 y170 gEncode w145, Encode
Gui, Add, Button, x+10 yp gDecode w145, Decode

Gui, Show, x1100 y400 w640 h220, CaesarCipher
Return

;;∙------------------------------------------∙
UpdatePreview:
    Gui, Submit, NoHide
    GuiControl,, ShiftDisplay, %ShiftVal%
    result := CaesarCipher(UserText, ShiftVal)
    GuiControl,, OutputBox, %result%
Return

Encode:
    Gui, Submit, NoHide
    IniWrite, %ShiftVal%, %iniFile%, Settings, ShiftValue
    result := CaesarCipher(UserText, ShiftVal)
    Clipboard := result
    GuiControl,, OutputBox, %result%
    GuiControl,, StatusText, Encoded text copied to clipboard!
Return

Decode:
    Gui, Submit, NoHide
    IniWrite, %ShiftVal%, %iniFile%, Settings, ShiftValue
    result := CaesarCipher(UserText, -ShiftVal)
    Clipboard := result
    GuiControl,, OutputBox, %result%
    GuiControl,, StatusText, Decoded text copied to clipboard!
Return

GuiClose:
    ExitApp
Return

CaesarCipher(text, shift)
{
    result := ""
    Loop, Parse, text
    {
        char := A_LoopField
        asc := Asc(char)

        ;;∙------∙Lowercase a-z.
        if (asc >= 97 && asc <= 122)
        {
            newAsc := Mod(asc - 97 + shift, 26)
            if (newAsc < 0)
                newAsc += 26
            result .= Chr(newAsc + 97)
        }
        ;;∙------∙Uppercase A-Z.
        else if (asc >= 65 && asc <= 90)
        {
            newAsc := Mod(asc - 65 + shift, 26)
            if (newAsc < 0)
                newAsc += 26
            result .= Chr(newAsc + 65)
        }
        else
        {
            result .= char
        }
    }
    return result
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
CaesarCipher:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

