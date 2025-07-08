
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  tidbit
» Original Source:  https://www.autohotkey.com/board/topic/100061-how-many-item-tall-are-you-or-any-object/
» Updated Source:  https://www.autohotkey.com/boards/viewtopic.php?f=76&t=137692&p=605237#p605257
» Current v1.1 Source:  
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

;;∙======∙HotKey∙===============================================∙
^t::    ;;∙------∙🔥∙(Ctrl + T)
    Soundbeep, 1000, 200
;;∙============================================================∙




;;∙============================================================∙
;;∙============================================================∙
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance, Force

;;∙------∙Script metadata.
_name_ := "How Many"
_version_ := "AHK v1.1 (June 2025)"
_created_ := "Tue December 24, 2013"
_author_ := "tidbit (tikki01@gmail.com)"

Guide := "
(
basic guide:
 ,----------,      |        OOOOOOOOOO.........
/__________/|      |      OO    |    OO        ..
|         | |      |    OO      |      OO        ..
|        h| |      |   O        |        O         .
|        e| |      |  O         |         O         .
|        i| |      |  O--------dia--------O    thick.
|        g| |      |  O         |         O         .
|        h| |      |   O        |        O         .
|        t| |      |    OO      |      OO        ..
|         | /      |      OO    |    OO        ..
|---------|/ thick |        OOOOOOOOOO.........
   width           
   length
)"

;;∙------∙Define object dimensions.
dimensions := { "8x11 paper": [21.59 "w", 27.94 "h", 0.00916 "t"]
    , "Acorn": ["Small Acorn:", 1 "h", 0.8 "d", "Average Acorn:", 3 "h", 2.0 "d", "Large Acorn:", 6 "h", 3.5 "d"]
    , "AfterLemon": [177.8 "h"]
    , "Banana": ["Average:", 17.78 "l", "`nLarge:", 22.86 "l"]
    , "Cheez-it": [2.6 "w", 2.4 "h", 0.5 "t"]
    , "Chickadee (avg adult)": [13.5 "l", 18.00 "p"]
    , "Clay brick": [22.2 "w", 7.30 "h", 10.60 "t"]
    , "Danny Devito": [152.00 "h"]
    , "Dice": [1.50 "whl"]
    , "Einstein, the world's smallest horse": [35.56 "h"]
    , "Finger nail (avg)": [0.036 "t"]
    , "Frodo (LOTR, Hobbit)": [106.68 "h"]
    , "Golf Ball": [4.267 "d"]
    , "Hair": ["Thin:", 0.018 "t", "Average:", 0.049 "t", "Thick:", 0.08 "t"]
    , "Hoover Dam": [37917.12 "w", 22128.48 "h", "`nTop:", 1371.60 "t", "Base:", 20116.80 "t"]
    , "House fly (avg)": [0.635 "l"]
    , "Human (avg, USA)": ["Adult Male:", 176 "h", "`nAdult Female:", 162 "h", "`n World averages are about the same. Give or take 5%."]
    , "Shaquille O'Neal": [216 "h"]
    , "iPhone 1": [6.21 "w", 11.55 "h", 1.23 "t"]
    , "iPhone 5": [6.02 "w", 11.43 "h", 0.94 "t"]
    , "Johnny Depp": [178.00 "h"]
    , "Justin Bieber": [170.00 "h"]
    , "M & M": [1.04 "d", 0.4 "t"]
    , "NFL Football field": [10973.8 "l", 4876.8 "w"]
    , "Skittle candy": [1.5 "d", 0.5 "t"]
    , "Tina Turner": [163.00 "h"]
    , "USA Dime": [1.791 "d", 0.135 "t"]
    , "USA Nickel": [2.121 "d", 0.195 "t"]
    , "USA Penny": [1.905 "d", 0.152 "t"]
    , "USA Quarter": [2.426 "d", 0.175 "t"]
    , "Waffle": [17.78 "d", 1.91 "t"] }

;;∙------∙Create menu.
Menu, main, Add, Unit Info, about
Menu, main, Add, Unit Guide, guide
Menu, main, Add, Help/About, Help
Gui, Menu, main

;;∙------∙Build GUI.
Gui, Margin, 6, 6
Gui, -Theme +hwndmainHWND
Gui, Font, s12, Verdana

Gui, Add, Text, ym w300 cGreen, What object would you like to compare against?

items := ""
For k, v in dimensions
    items .= k "|"
Gui, Add, ListBox, xm y+2 wp r12 0x100 HScroll vItem gUpdate, % items
Gui, Add, Text, ym w5 hp 0x11 vLine

Gui, Add, Text, ym w400 Section cBlue, How tall are you OR how tall (or long, or wide) is your specific object?
Gui, Add, Radio, xs y+10 Checked vImp gUnits, Imperial
Gui, Add, Radio, x+6 vMet gUnits, Metric

Gui, Add, Text, xs y+6 w120 vt1, miles
Gui, Add, Edit, x+6 yp w130 r1 vUnit1 gUpdate, 0

Gui, Add, Text, xs y+6 w120 vt2, feet
Gui, Add, Edit, x+6 yp w130 r1 vUnit2 gUpdate, 5

Gui, Add, Text, xs y+6 w120 vt3, inches
Gui, Add, Edit, x+6 yp w130 r1 vUnit3 gUpdate, 8

Gui, Add, Text, xs y+6 w120 cGreen, Unit:
Gui, Add, Edit, x+6 yp w130 vUnit gUpdate, tall

Gui, Add, Text, xs y+10 w400 h5 0x10,

Gui, Add, Text, xs y+10 w400 cRed, Result*: 
Gui, Font, s12, DejaVu Sans Mono
Gui, Add, Edit, xs wp r7 ReadOnly -Wrap HScroll vDisp

GuiControl, Choose, Item, 1
GuiControl, Focus, Item
Gui, Show, AutoSize, %_name_% %_version_%

OnMessage(0x20A, "wheel")  ;;∙------∙WM_MOUSEWHEEL
Gosub, Units
Return

GuiSize:
    GuiControlGet, Item, Pos
    GuiControl, Move, Item, % "h" (A_GuiHeight - ItemY) - 6
    GuiControl, Move, Line, % "h" (A_GuiHeight - ItemY) + 30
Return

Help:
    helpInfo := "Name: " _name_ "`n"
        . "Version: " _version_ "`n"
        . "Created on: " _created_ "`n"
        . "By: " _author_ "`n"
        . "-----`n"
        . "Hotkeys:`n"
        . "   esc --- Quit`n"
        . "   ? --- Info on selected unit`n"
        . "   f1 --- Help/about`n"
        . "-----`n"
        . "*   Units might not be 100% exact due to rounding, people`n"
        . "growing, fantasy characters heights being estimated`n"
        . "and many other factors. These are meant for fun and not for `n"
        . "serious use.`n"
        . "*   The ratio ""(###:1)"" in ""Unit Info"" shows how many of your units it takes`n"
        . "to fill up 1 specified item.`n"

    msgbox2(helpInfo, "Help", "w400 ReadOnly")
Return

Guide:
    msgbox2(Guide, "Basic measurement guide", "ReadOnly -Wrap r15")
Return

About:
    Gui, Submit, NoHide
    about := ""
    For k, v in dimensions[Item]
    {
        type := InStr(v, "w") ? " Width"
            : InStr(v, "h") ? " Height"
            : InStr(v, "l") ? " Length"
            : InStr(v, "d") ? " Diameter"
            : InStr(v, "t") ? " Thickness"
            : InStr(v, "p") ? " Wing span"
            : ""
        
        RegExMatch(v, "([\d .-]+)", child)
        If child is not number
            Continue

        If (Imp = 1)
            master := (Unit1 * 160934) + (Unit2 * 30.48) + (Unit3 * 2.54)
        Else If (Met = 1)
            master := (Unit1 * 100000) + (Unit2 * 100) + Unit3
        Else
            return
        
        about .= Trim(type) ":|" child "cm|(" Round(1 / (master / child), 5) ":1)`r`n"
    }
    about := Trim(columns(about), "`r`n `t")

    msgbox2(Item "  dimensions`n-----`n1 inch=2.54 cm, 1 foot=30.48 cm`n-----`n" about, "About """ Item """", "-Wrap ReadOnly")
Return

Units:
    Gui, Submit, NoHide
    If (Imp = 1)
    {
        GuiControl,, t1, Miles
        GuiControl,, t2, Feet
        GuiControl,, t3, Inches
    }
    Else If (Met = 1)
    {
        GuiControl,, t1, Kilometers
        GuiControl,, t2, Meters
        GuiControl,, t3, Centimeters
    }
    Else
        return
    Gosub, Update
Return

Update:
    Gui, Submit, NoHide
    If (Unit1 = "")
        Unit1 := 0
    If (Unit2 = "")
        Unit2 := 0
    If (Unit3 = "")
        Unit3 := 0
        
    If (Imp = 1)
        master := (Unit1 * 160934) + (Unit2 * 30.48) + (Unit3 * 2.54)
    Else If (Met = 1)
        master := (Unit1 * 100000) + (Unit2 * 100) + Unit3
    Else
        return

    data := ""
    For k, v in dimensions[Item]
    {
        RegExMatch(v, "([\d .-]+)", child)
        
        If child is not number
        {
            data .= v "`r`n"
            Continue
        }
        
        original := v
        While (InStr(v, "w") || InStr(v, "h") || InStr(v, "l") || InStr(v, "d") || InStr(v, "t") || InStr(v, "p"))
        {
            type := (InStr(v, "w")) ? " widths"
                : (InStr(v, "h")) ? " heights"
                : (InStr(v, "l")) ? " lengths"
                : (InStr(v, "d")) ? " diameters"
                : (InStr(v, "t")) ? " thickness's"
                : (InStr(v, "p")) ? " Wing spans"
                : ""
            v := RegExReplace(v, "[A-Za-z]{1}", "",, 1)
            data .= Round(master / child, 3) "|" Item type " " Unit ".|`r`n"
        }
        v := original
    }
    GuiControl,, Disp, % Trim(columns(data), "`r`n `t")
Return

GuiClose:
GuiEscape:
    ExitApp
Return

#If WinActive("ahk_id " mainHWND)
    F1::Gosub, Help
    ?::Gosub, About
#If

wheel(wParam, lParam) {
    amt := 1
    GuiControlGet, controlType, Focus
    If (!InStr(controlType, "Edit"))
        return
      
    GuiControlGet, value,, %A_GuiControl%
    If value is not number
        return
   
    mult := ((wParam & 0xFFFF) = 4) ? 0.01 : ((wParam & 0xFFFF) = 8) ? 0.1 : 1
    value += (StrLen(wParam) > 7) ? -amt * mult : amt * mult
    GuiControl,, %A_GuiControl%, % RegExReplace(value, "(\.[1-9]+)0+$", "$1")
}

msgbox2(text := "", title := "Msgbox", options := "Wrap r12", ctrl := "Edit") {
    Gui, msgbox: +OwnDialogs +hwndMBHWND
    Gui, msgbox: Add, %ctrl%, %options% -WantReturn, %text%
    GuiControlGet, x, msgbox:Pos, %ctrl%1
    xW -= 70
    Gui, msgbox: Add, Button, x%xW% y+10 w70 Default gMB2OK, OK
    Gui, msgbox: Show,, %title%
    WinWaitClose, ahk_id %MBHWND%

    msgboxGUiEscape:
    msgboxGUiClose:
    MB2OK:
        Gui, msgbox: Destroy
    return
}

columns(data, delim := "|", sep := "  ") {        
    widths := []
    dataArr := []
    
    ;;∙------∙Parse data into array.
    Loop, Parse, data, `n, `r
    {
        If (A_LoopField = "")
            Continue
        dataArr[A_Index] := StrSplit(A_LoopField, delim)
        maxr := dataArr.MaxIndex()
        maxc := dataArr[A_Index].MaxIndex()
    }
    
    ;;∙------∙Calculate column widths.
    Loop, % maxc
    {
        col := A_Index
        Loop, % maxr
        {
            If (StrLen(dataArr[A_Index, col]) > widths[col])
                widths[col] := StrLen(dataArr[A_Index, col])
        }
    }
    
    ;;∙------∙Format columns.
    out := ""
    Loop, % maxr
    {
        row := A_Index
        Loop, % maxc
        {
            out .= dataArr[row, A_Index]
            out .= fill(widths[A_Index] - StrLen(dataArr[row, A_Index])) sep
        }
        out := RTrim(out, sep)
        out .= "`r`n"
    }
    return RTrim(out, "`r`n")
}

fill(amt := 1, char := " ") {
    stuff := ""
    Loop, % amt
        stuff .= char
    return stuff
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

