
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  Self
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?f=76&t=136301#p599630
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

^t::    ;;∙------∙🔥∙(Ctrl+T) 

;;∙------------∙Last 5 boxes will never be used∙------------∙
#NoEnv
#SingleInstance Force

;;∙------------∙GUI VARIABLES∙---------------------------------------∙
;;∙------------∙Calendar Gui 'X' and 'Y' Axis Positions.
guiCalPosX := 1550
guiCalPosY := 150

;;∙------------∙Main Gui Color.
guiColor := "Black"

;;∙------------∙Gridlines.
guiHorzGridline := "003FFF"    ;;∙------∙Horizontal & Vertical gridlines. (blue)
guiVertGridlines := "003FFF"

;;∙------------∙Header Gridlines.
guiTopGridline := "009BFF"    ;;∙------∙Header top grid line. (lighter blue)
guiHeaderGridline := "009BFF"    ;;∙------∙Header bottom grid line.

;;∙------------∙Header.
headerFont := "Verdana"
    headerFontSize := "10"
    headerFontColor := "Aqua"

;;∙------------∙Current Date.
currentdateFont := "Verdana"
    currentdateFontSize := "12"
    currentdateFontColor := "DEDE00"    ;;∙------∙Yellow

;;∙------------∙Date Numbers.
dateFont := "Verdana"
    dateFontSize := "10"
    dateFontColor := "Lime"

;;∙------------∙Exit Text.
exitTextFont := "Calibri"
    exitTextFontSize := "10"
    exitTextFontColor := "DE0000"    ;;∙------∙Red
;;∙------------∙VARIABLES END∙---------------------------------------∙


Gui, Calendar:Destroy
Gui, Calendar:New, +AlwaysOnTop -Caption +Border +ToolWindow, Calendar
Gui, Color, %guiColor%

;;∙------------∙GRIDLINES MATH∙------------∙
;;∙------∙Grid dimensions.
cellW := 40, cellH := 30, spacer := 2
headerH := 30    ;;∙------∙Header height.
startX := 10, startY := 10

;;∙------∙Calculate total size.
totalWidth := 7*(cellW + spacer) - spacer
totalHeight := headerH + 6*(cellH + spacer)


;;∙------∙Main background.  ;;∙------∙(commented out due to gLabel (Exit) blocking).
 ; Gui, Add, Progress, BackGroundTrans x%startX% y%startY% w%totalWidth% h%totalHeight% Background%guiColor%

;;∙------------∙VERTICAL GRIDLINES∙------------∙
Loop 8 {    ;;∙------∙8 vertical lines for 7 columns .
    x := startX + (A_Index-1)*(cellW + spacer)
    height := totalHeight
    Gui, Add, Progress, BackGroundTrans x%x% y%startY% w%spacer% h%height% Background%guiVertGridlines%
    }

;;∙------------∙HORIZONTAL GRIDLINES∙------------∙
;;∙------∙(extended by x# pixels)
extendedWidth := totalWidth + 4    ;;∙------∙Extend length to right edge gridline.
    
;;∙------∙1-Top border.
Gui, Add, Progress, BackGroundTrans x%startX% y%startY% w%extendedWidth% h%spacer% Background%guiTopGridline%
    
;;∙------∙2-Header separator.
headerLineY := startY + headerH
Gui, Add, Progress, BackGroundTrans x%startX% y%headerLineY% w%extendedWidth% h%spacer% Background%guiHeaderGridline%

;;∙------∙3-Date row separators.
Loop 6 {
    y := headerLineY + A_Index*(cellH + spacer)
    Gui, Add, Progress, BackGroundTrans x%startX% y%y% w%extendedWidth% h%spacer% Background%guiHorzGridline%
    }

;;∙------------∙HEADER∙------------∙
;;∙------∙Header row.
Gui, Font, s%headerFontSize% c%headerFontColor% Bold q5, %headerFont%
days := ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
Loop 7 {
    col := A_Index-1
    xPos := startX + (col*(cellW + spacer)) + (cellW//2 - 15)
    yPos := startY + (headerH//2 - 8)    ;;∙------∙Vertically centered in header.
    Gui, Add, Text, BackGroundTrans x%xPos% y%yPos% w30 h%headerH% Center, % days[A_Index]
    }

;;∙------------------∙CURRENT DATE∙------------∙
;;∙------∙Current date info.
FormatTime, currentYear,, yyyy
FormatTime, currentMonth,, MM
FormatTime, currentDay,, dd

;;∙------∙Calculate days in month.
DaysInMonth := GetDaysInMonth(currentYear, currentMonth)

;;∙------∙First weekday position.
firstDay := currentYear currentMonth "01"
FormatTime, firstWeekday, %firstDay%, WDay
firstCol := firstWeekday - 1

;;∙------------∙DATE NUMBERS∙------------∙
;;∙------∙Date grid.
yRowStart := startY + headerH + spacer
Gui, Font, s%dateFontSize% Norm, %dateFont%
Loop %DaysInMonth% {
    dayNum := A_Index
    dayPos := firstCol + A_Index - 1
    col := Mod(dayPos, 7)
    row := Floor(dayPos/7)
    x := startX + col*(cellW + spacer) + (cellW//2 - 5)
    y := yRowStart + row*(cellH + spacer) + (cellH//2 - 8)
    color := (dayNum = currentDay) ? currentdateFontColor : dateFontColor    ;;∙------∙Highlight current date.
    if (dayNum = currentDay)

    Gui, Font, s%currentdateFontSize% Bold, %currentdateFont%
    Gui, Add, Text, BackGroundTrans x%x% y%y% w20 h20 Center c%color%, %dayNum%
    Gui, Font, s%dateFontSize% Norm, %dateFont%
    }

;;∙------------∙EXIT TEXT∙------------∙
;;∙------∙Last box position.
totalCells := 6 * 7   ;;∙------∙Total grid slots (6 rows, 7 columns).
lastBoxIndex := totalCells - 1
lastCol := Mod(lastBoxIndex, 7)
lastRow := Floor(lastBoxIndex / 7)
x := startX + lastCol * (cellW + spacer) + (cellW // 2 - 15)    ;;∙------∙Adjust last number to accomodate different text lengths.
y := yRowStart + lastRow * (cellH + spacer) + (cellH // 2 - 8)    ;;∙------∙Adjust last number to accomodate different fonts/sizes.

Gui, Font, s%exitTextFontSize% c%exitTextFontColor%, %exitTextFont%    ;;∙------∙Add "Exit" label in the last box.
Gui, Add, Text, BackGroundTrans x%x% y%y% w30 h20 Center +Background gExit, Exit
Gui, Show, x%guiCalPosX% y%guiCalPosY% AutoSize, Calendar
Return

;;∙------------∙ROUTINES & FUNCTIONS∙------------∙
Exit:
    SoundBeep, 1200, 250
;    MsgBox,,, Exit button clicked.,3
    Gui, Destroy
    ExitApp
Return

GetDaysInMonth(year, month) {
    daysInMonth := [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]    ;;∙------∙Days in each month.
    if (month = 2) {    ;;∙------∙Check for leap year (February).
        isLeap := (!Mod(year, 4) && Mod(year, 100)) || !Mod(year, 400)
        return isLeap ? 29 : 28
    }
    return daysInMonth[month]
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

