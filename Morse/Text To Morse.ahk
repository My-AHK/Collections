
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
;;∙============================================================∙
#SingleInstance Force
SendMode Input
SetBatchLines -1
SetTitleMatchMode 2
DetectHiddenWindows, On

^t::    ;;∙------∙🔥∙(Ctrl + T)

Clipboard := ""         ;;∙------∙Clear Clipboard.
Send ^c
ClipWait, 1
Text := Clipboard

if !Text
{
    MsgBox, 48, ⚠ No Text Selected ⚠, Please select some text to`n  convert to Morse code, 5
    Return
}

MorseTable := Object()
MorseTable["A"] := ".-"
MorseTable["B"] := "-..."
MorseTable["C"] := "-.-."
MorseTable["D"] := "-.."
MorseTable["E"] := "."
MorseTable["F"] := "..-."
MorseTable["G"] := "--."
MorseTable["H"] := "...."
MorseTable["I"] := ".."
MorseTable["J"] := ".---"
MorseTable["K"] := "-.-"
MorseTable["L"] := ".-.."
MorseTable["M"] := "--"
MorseTable["N"] := "-."
MorseTable["O"] := "---"
MorseTable["P"] := ".--."
MorseTable["Q"] := "--.-"
MorseTable["R"] := ".-."
MorseTable["S"] := "..."
MorseTable["T"] := "-"
MorseTable["U"] := "..-"
MorseTable["V"] := "...-"
MorseTable["W"] := ".--"
MorseTable["X"] := "-..-"
MorseTable["Y"] := "-.--"
MorseTable["Z"] := "--.."
MorseTable["0"] := "-----"
MorseTable["1"] := ".----"
MorseTable["2"] := "..---"
MorseTable["3"] := "...--"
MorseTable["4"] := "....-"
MorseTable["5"] := "....."
MorseTable["6"] := "-...."
MorseTable["7"] := "--..."
MorseTable["8"] := "---.."
MorseTable["9"] := "----."
MorseTable["."] := ".-.-.-"
MorseTable[","] := "--..--"
MorseTable["?"] := "..--.."
MorseTable["'"] := ".----."
MorseTable["!"] := "-.-.--"
MorseTable["/"] := "-..-."
MorseTable["("] := "-.--."
MorseTable[")"] := "-.--.-"
MorseTable["&"] := ".-..."
MorseTable[":"] := "---..."
MorseTable[";"] := "-.-.-."
MorseTable["="] := "-...-"
MorseTable["+"] := ".-.-."
MorseTable["-"] := "-....-"
MorseTable["_"] := "..--.-"
MorseTable["\"] := ".-..-."
MorseTable["$"] := "...-..-"
MorseTable["@"] := ".--.-."

Text := Trim(Text)
Text := RegExReplace(Text, "\s+", " ")    ;;∙------∙Collapse multiple spaces.
Text := RegExReplace(Text, "\r?\n", " ")  ;;∙------∙Replace line breaks with space.
Text := Trim(Text)

UpperText := ""
Loop, Parse, Text
    UpperText .= (A_LoopField ~= "[a-z]") ? Chr(Asc(A_LoopField)-32) : A_LoopField

InvalidChars := ""
Loop, Parse, UpperText
{
    Char := A_LoopField
    if (Char = " " || MorseTable.HasKey(Char))
        continue
    if !InStr(InvalidChars, Char)
        InvalidChars .= Char
}

if (InvalidChars != "")
{
    MsgBox, 48, Invalid Characters, The following characters are not supported:`n`n%InvalidChars%, 5
    Return
}

Freq := 1200
Short := 200      ;;∙------∙Dot duration
Long := 400       ;;∙------∙Dash duration
Pause := 750      ;;∙------∙Pause between letters
WordGap := Pause * 2
SentencePause := Pause * 3

MorseOutput := ""
Loop, Parse, UpperText, %A_Space%
{
    Word := A_LoopField
    Loop, Parse, Word
    {
        Char := A_LoopField
        Morse := MorseTable[Char]
        MorseOutput .= Morse " "

        ToolTip, % "Beeping: " Char "`n" Morse
        Loop, Parse, Morse
        {
            Symbol := A_LoopField
            BeepLength := (Symbol = ".") ? Short : Long
            SoundBeep, Freq, BeepLength
            Sleep, 150    ;;∙------∙Intra-symbol pause
        }

        Sleep, Pause     ;;∙------∙Between letters
        if Char in .,?,!
            Sleep, SentencePause
    }

    Sleep, WordGap      ;;∙------∙Between words
}
ToolTip
MsgBox,,, Morse Code Output:`n%MorseOutput%`n" %Text% ", 5
Clipboard = Morse Code Output:`n%MorseOutput%`n" %Text% "
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

