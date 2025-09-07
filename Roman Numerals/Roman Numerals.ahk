
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  MasterFocus
» Original Source:  https://github.com/MasterFocus/AutoHotkey/blob/master/Functions/RomanNumbers/RomanNumbers.ahk
» 
    ▹ 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "Roman_Numerals"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
;;∙============================================================∙
/*
∙------------∙ * IMPORTANT NOTE * ∙--------------------------------------∙
The bracket notation [X], [C], [M] etc. is a MODERN EXTENSION 
not used in traditional Roman numerals. Standard Roman numerals 
(I, V, X, L, C, D, M) only go up to 3,999 (MMMCMXCIX). Extended 
notation uses brackets for multiples of 1,000. This extended 
notation allows conversion of much larger numbers, but is 
not standard historical practice.
∙--------------------------------------------------------------------------------∙
Standard Roman numerals (I, V, X, L, C, D, M) only go up to 3,999 (MMMCMXCIX).
• I = 1
• V = 5
• X = 10
• L = 50
• C = 100
• D = 500
• M = 1000
∙----------------------------------------∙
Extended notation uses brackets for multiples of 1,000:
 • [X] = 10,000
 • [C] = 100,000
 • [M] = 1,000,000
 • [X][M] = 10,000,000, etc.
∙--------------------------------------------------------------------------------∙
*/

;;∙============================================================∙
;;∙======∙BASIC USAGE EXAMPLES∙==================∙
^F1::    ;;∙------∙🔥∙(Ctrl + F1)∙Convert decimal to Roman numerals.
MsgBox % Dec2Roman(42)    ;;∙------∙Returns "XLII".
MsgBox % Dec2Roman(2023)    ;;∙------∙Returns "MMXXIII".
MsgBox % Dec2Roman(3999)    ;;∙------∙Returns "MMMCMXCIX".
Return

^F2::    ;;∙------∙🔥∙(Ctrl + F2)∙Convert Roman numerals to decimal.
MsgBox % Roman2Dec("XLII")    ;;∙------∙Returns 42.
MsgBox % Roman2Dec("MMXXIII")    ;;∙------∙ Returns 2023.
MsgBox % Roman2Dec("MMMCMXCIX")    ;;∙------∙Returns 3999.
Return

;;∙======∙ADVANCED EXAMPLES∙===================∙
^F3::    ;;∙------∙🔥∙(Ctrl + F3)∙Large numbers (with brackets).
MsgBox % Dec2Roman(1000000)    ;;∙------∙Returns "[M]" (1,000,000).
MsgBox % Dec2Roman(4500000)    ;;∙------∙Returns "[C][D][M][M][M][M][M]" (4,500,000).
MsgBox % Roman2Dec("[M]")    ;;∙------∙Returns 1000000.
Return

^F4::    ;;∙------∙🔥∙(Ctrl + F4)∙Negative numbers (requires p_AllowNegative=true).
MsgBox % Dec2Roman(-42, true)    ;;∙------∙Returns "-XLII".
MsgBox % Roman2Dec("-XLII", true)    ;;∙------∙Returns -42.
Return

^F5::    ;;∙------∙🔥∙(Ctrl + F5)∙Error handling examples.
MsgBox % Dec2Roman(0)    ;;∙------∙Returns 0 (invalid input).
MsgBox % Dec2Roman(3.14)    ;;∙------∙Returns 0 (non-integer).
MsgBox % Roman2Dec("ABC")    ;;∙------∙Returns 0 (invalid Roman).
MsgBox % Roman2Dec("IIV")    ;;∙------∙Returns 0 (invalid sequence).
Return

^F6::    ;;∙------∙🔥∙(Ctrl + F6)∙Working with variables.
myNumber := 1776
romanResult := Dec2Roman(myNumber)
MsgBox % myNumber " in Roman numerals is: " romanResult

myRoman := "MDCCLXXVI"
decimalResult := Roman2Dec(myRoman)
MsgBox % myRoman " in decimal is: " decimalResult
Return

;;∙======∙PRACTICAL APPLICATION EXAMPLE∙=========∙
^F7::    ;;∙------∙🔥∙(Ctrl + F7)∙Function to validate and convert user input.
InputBox, userInput, Roman Numeral Converter, Enter a number or Roman numeral:
if (ErrorLevel)    ;;∙------∙User pressed Cancel.
    return

result := ConvertRomanNumber(userInput)
ClipBoard =  % result
MsgBox % result
Return

;;∙======∙BATCH CONVERSION EXAMPLE∙============∙
^F8::    ;;∙------∙🔥∙(Ctrl + F8)∙Convert a range of numbers.
numbers := [1, 4, 5, 9, 10, 40, 50, 90, 100, 400, 500, 900, 1000]
results := ""

for index, number in numbers {
    roman := Dec2Roman(number)
    results .= number " = " roman "`n"
}
MsgBox % results
Return

;;∙===========================================∙
;;∙======∙FUNCTIONS∙==========================∙
ConvertRomanNumber(input) {
    ;;∙------∙Try to convert as Roman to decimal first.
    decimal := Roman2Dec(input, true)
    if (decimal != 0) {
        return input " = " decimal
    }

    ;;∙------∙If that fails, try to convert as decimal to Roman.
    if input is integer
    {
        roman := Dec2Roman(input, true)
        if (roman != 0) {
            return input " = " roman
        }
    }

    return "Invalid input: " input
}

Dec2Roman(p_Number,p_AllowNegative=false) {
  If p_Number is not integer
    Return 0
  If (p_Number=0 OR (p_Number<0 AND !p_AllowNegative))
    Return 0
  p_Number := p_Number<0 ? (Abs(p_Number),l_Signal:="-") : p_Number

  RomanSymbols := ["[M]", "[C][M]", "[D]", "[C][D]", "[C]", "[X][C]", "[L]", "[X][L]", "[X]", "M[X]", "[V]", "M[V]", "M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
  RomanValues := [1000000, 900000, 500000, 400000, 100000, 90000, 50000, 40000, 10000, 9000, 5000, 4000, 1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]

  l_String := ""
  Loop % RomanSymbols.Length()
  {
    Symbol := RomanSymbols[A_Index]
    Value := RomanValues[A_Index]
    While (p_Number >= Value)
    {
      l_String .= Symbol
      p_Number -= Value
    }
  }
  Return l_Signal l_String
}

Roman2Dec(p_RomanStr,p_AllowNegative=false) {
    RomanSymbols := ["[M]", "[C][M]", "[D]", "[C][D]", "[C]", "[X][C]", "[L]", "[X][L]", "[X]", "M[X]", "[V]", "M[V]", "M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
    RomanValues := [1000000, 900000, 500000, 400000, 100000, 90000, 50000, 40000, 10000, 9000, 5000, 4000, 1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]

    ;;∙------∙Check for negative sign.
    if (SubStr(p_RomanStr, 1, 1) = "-") {
        if (!p_AllowNegative)
            return 0
        p_RomanStr := SubStr(p_RomanStr, 2)
        isNegative := true
    }

    ;;∙------∙Validation to check if string contains only valid Roman characters.
    if !RegExMatch(p_RomanStr, "i)^[MDCLXVI\[\]]+$")
        return 0

    l_Sum := 0
    i := 1
    strLen := StrLen(p_RomanStr)
    previousValue := 0
    repeatCount := 0
    lastSymbol := ""
    
    While (i <= strLen) {
        found := false
        maxLen := 0
        bestSymbol := ""
        bestValue := 0

        ;;∙------∙Find the longest matching symbol starting at current position.
        For each, symbol in RomanSymbols {
            symbolLen := StrLen(symbol)
            if (symbolLen > maxLen && SubStr(p_RomanStr, i, symbolLen) = symbol) {
                maxLen := symbolLen
                bestSymbol := symbol
                bestValue := RomanValues[each]
                found := true
            }
        }
        
        if (!found)
            return 0    ;;∙------∙Invalid symbol.
        
        ;;∙------∙Validation rules.
        if (bestValue > previousValue) {
             ;;∙------∙Subtraction case to check if valid.
            if (previousValue > 0) {
                 ;;∙------∙Only certain subtractions are allowed.
                validSubtraction := false
                For each, symbol in RomanSymbols {
                    if (RomanValues[each] = bestValue - previousValue && RomanValues[each] < previousValue) {
                        validSubtraction := true
                        break
                    }
                }
                if (!validSubtraction)
                    return 0    ;;∙------∙Invalid subtraction.
                
                 ;;∙------∙Can't have multiple subtractive pairs in a row.
                if (lastSymbol != "" && InStr("IVXLC", lastSymbol))
                    return 0
            }
            repeatCount := 0
        } else if (bestValue == previousValue) {
            ;;∙------∙Same symbol repeated so check repetition rules.
            repeatCount++
            if (bestValue < 1000 && repeatCount > 2) {
                ;;∙------∙Symbols below 1000 can't repeat more than 3 times.
                if (bestValue != 1000 && repeatCount > 3)
                    return 0
            }
            ;;∙------∙V, L, D cannot repeat at all.
            if (bestValue == 5 || bestValue == 50 || bestValue == 500)
                return 0
        } else {
            ;;∙------∙Smaller value after larger to reset repeat count.
            repeatCount := (bestSymbol == lastSymbol) ? repeatCount + 1 : 1
        }
        
        ;;∙------∙Add the value (adjust for subtraction if needed).
        if (bestValue > previousValue && previousValue > 0) {
            l_Sum += bestValue - previousValue * 2
        } else {
            l_Sum += bestValue
        }
        
        i += maxLen
        previousValue := bestValue
        lastSymbol := bestSymbol
    }
    
    return isNegative ? -l_Sum : l_Sum
}
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
Roman_Numerals:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

