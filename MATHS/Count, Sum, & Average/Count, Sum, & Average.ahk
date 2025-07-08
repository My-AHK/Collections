
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  Larry
» Original Source:  https://www.autohotkey.com/board/topic/44579-clipboard-totalizer-v11-for-web-page-tables-and-more/
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
/*
Clipboard Totalizer v1.1 (for Web Page Tables, and more)
Date: 08-31-09

Have you ever come across a column of numbers on a web page
or some other document that you'd like to get a total for?
This script tries to fill that need. It does however need to copy
the selected values to the Windows Clipboard to do the math.

It provides the Sum, Average, and Count of a Column of Numbers.
This script will work on many Web Pages that use tables to
display numbers and pricing information, although it was written
primarily for use on Yahoo Personal Stock Portfolio Listings.
The script will not work on all web pages as some sites disable
clipboard captures, and/or may contain formatting that this script
doesn't recognize. This script was written for use with the Firefox
Web Browser (v3.5.2), and may or may not work properly with
other Web Browsers. The script will work elsewhere too (such as
in Text Editors), as long as the Data is separated by Tabs or
Line Feeds, and can be copied to the Windows Clipboard.

In Firefox, use the Control Key to Select multiple table items
just as you would to Select Multiple Items elsewhere in Windows.
Then, use the "Ctrl-Alt-t" Hotkey --or-- "Click the Tray Icon" to
Display the Sum, Average, and a count of the number of values
Summed and Averaged.

  Features and Limitations:
* Number Values are rounded to two places.
* Selected Web Page Table Items Need Not be adjacent to one another
* Original Clipboard Contents is Saved and Restored
* Pressing "Ctrl-Win-Alt-t" will Paste the Sum elsewhere if needed.
* Known Issue: This script will not work with Internet Explorer

You can test the script with your Web Browser on the chart
of Prime Numbers shown on the Web Page Linked to below:

  http://www.factmonster.com/math/numbers/prime.html
*/

;;∙============================================================∙
;;  Count, Sum, and Average Script for Selected Text
;;  Features:
;;    Calculates count, total, and average from selected numeric text.
;;    Formats output with commas.
;;    Stores result for later paste with (Ctrl+Win+Alt+T).
;;∙============================================================∙

#Persistent
SetTitleMatchMode, 3    ;;∙------∙Exact window title matching.
MsgBoxTitle := "Count, Sum, & Average"
SplitPath, A_ScriptName,,,, ScriptName
WinGet, ScriptID, ID, %ScriptName%
SetTimer, GetWinID, 1000

global val, avg, qq

Menu, tray, add
Menu, tray, add
Menu, tray, add, Paste the Previously Calculated Sum: Ctrl-Win-Alt-t, null
Menu, tray, add
Menu, tray, add
Menu, tray, add, Get the Sum of the Selected Items, sum
Menu, tray, Default, Get the Sum of the Selected Items
Menu, tray, Click, 1
Menu, tray, add
Menu, tray, add
Menu, Tray, NoStandard
Menu, tray, Standard

null:
Return

GetWinID:
    WinGet, Active_ID, ID, A
    WinGet, msgboxID, ID, %MsgBoxTitle%
    WinGetClass, class, A
    if (Active_ID != ScriptID && Active_ID != msgboxID && class != "Shell_TrayWnd")
        ReturnID := Active_ID
Return

sum:
^+t::    ;;∙------∙Ctrl+Alt+T = Calculate total from selected numbers.
    WinActivate, ahk_id %ReturnID%
    WinWaitActive, ahk_id %ReturnID%

    clipbak := clipboardAll
    clipboard :=
    Send, ^c
    ClipWait, 3
    if ErrorLevel
    {
        MsgBox,,, Text not copied. Please try again., 3
        clipboard := clipbak
        Return
    }

    StringReplace, clipboard, clipboard, %A_Tab%, `n, All
    qq := 0
    val := 0

    Loop, Parse, clipboard, `n, `r
    {
        if (A_LoopField = "")
            continue

        qq++
        value := A_LoopField

        if (SubStr(value, 1, 1) = "$")
            value := SubStr(value, 2)

        StringReplace, value, value, `,, , All
        value := RegExReplace(value, "(^\s*|\s*$)")

        if InStr(value, "$")
            val += SubStr(value, InStr(value, "$") + 1)
        else
            val += value
    }

    val := Round(val, 2)
    avg := Round(val / qq, 2)

    val := RegExReplace(val, "(\d)(?=(?:\d{3})+(?:\.|$))", "$1,")
    avg := RegExReplace(avg, "(\d)(?=(?:\d{3})+(?:\.|$))", "$1,")

    MsgBox,, %MsgBoxTitle%, % "Records Count:`t" . qq . " total`nRecords Sum:`t" . val . "`nAverage Value:`t" . avg, 7
    clipboard := clipbak
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

