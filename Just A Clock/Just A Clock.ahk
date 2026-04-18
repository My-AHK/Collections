
;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙

;;∙=============================================∙
;;∙======∙DIRECTIVES & SETTINGS∙=================∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force
SetBatchLines -1
SetWinDelay 0
SetWorkingDir, %A_ScriptDir%

;;∙=============================================∙
;;∙======∙CUSTOMIZATION VARIABLES∙=============∙
/*
• Extensive Color Table & Hex Code (6-digit hex or with 0x prefix) Support.
    » Supported Color Names:
    ▹ Grayscales: Black, Gray/Grey, Silver, White
    ▹ Reds:  Maroon, Red, Magenta-Red,Rose
    ▹ Pinks:  Salmon, Light Salmon, Coral, Hot Pink, Deep Pink, Rose Pink, Pink
    ▹ Oranges:  Red-Orange, Orange, Yellow-Red, Yellow-Orange
    ▹ Yellows:  Yellow, Chartreuse
    ▹ Greens:  Olive, Green, Lime, Spring Green, Cyan-Green
    ▹ Cyans:  Teal, Aqua/Cyan, Azure
    ▹ Blues:  Blue, Navy
    ▹ Violets:  Indigo, Violet, Purple
    ▹ Magenta:  Magenta/Fuchsia
*/

;;∙------∙Colors & Appearance∙--------∙
gBackground := "Black"    ;;∙------∙Gui Background.
dialogText := "White"    ;;∙------∙Alarm dialog box text color.
hHand := "Lime"    ;;∙------∙Hour Hand.
mHand := "Aqua"    ;;∙------∙Minute Hand.
sHand := "FF0000"    ;;∙------∙Seconds Hand (hex code example / Red).
hMarker := "0xFF80FF"    ;;∙------∙Hour Markers (0x hex prefix example / Pink).
mMarker := "Violet"    ;;∙------∙Minute Markers.
rNumeral := "Yellow"    ;;∙------∙Roman Numerals.
eTrim1 := "Blue"    ;;∙------∙Inner Clock Edge.
eTrim2 := "Magenta"    ;;∙------∙Outer Clock Edge.
dTime := "Spring Green"    ;;∙------∙Digital Time.
dDate := "Chartreuse"    ;;∙------∙Digital Date.
weekColor := "Lime"    ;;∙------∙Week Number.
cPoint := "Orange"    ;;∙------∙Clockface Center Point.

;;∙------∙Hand Geometry∙---------------∙
cPointSize := 11    ;;∙------∙Center Point Size (pixels, must be odd for centering).
hLength := 55    ;;∙------∙Hour Hand Length.
mLength := 85    ;;∙------∙Minute Hand Length.
sLength := 95    ;;∙------∙Seconds Hand Length.
hThick := 4.0    ;;∙------∙Hour Hand Thickness.
mThick := 3.0    ;;∙------∙Minute Hand Thickness.
sThick := 1.5    ;;∙------∙Seconds Hand Thickness.

;;∙------∙Display Options∙---------------∙
showDigitalTime := true    ;;∙------∙Show/hide digital time.
showDigitalDate := true    ;;∙------∙Show/hide digital date.
showWeekNumber := true    ;;∙------∙Show/hide week number.
use24HourFormat := false    ;;∙------∙true=24-hour, false=12-hour.
windowTransparency := 255    ;;∙------∙255=opaque, 0=invisible.
clockOnTop := true    ;;∙------∙Initial always-on-top state.
startX := 300    ;;∙------∙Initial window X position.
startY := 300    ;;∙------∙Initial window Y position.
showRomanNumerals := true    ;;∙------∙Show/hide Roman numerals.
showMinuteMarkers := true    ;;∙------∙Show/hide minute tick marks.

;;∙------∙Hourly Chime Settings∙-------∙
enableChime := true    ;;∙------∙Enable hourly chime.
chimeStyle := "Double"    ;;∙------∙"Single", "Double", "Triple".
chimeFrequency := 900    ;;∙------∙Base frequency in Hertz.
chimeDuration := 150    ;;∙------∙Duration of each beep in ms.
chimeStartHour := 8    ;;∙------∙Don't chime before this hour.
chimeEndHour := 17    ;;∙------∙Don't chime after this hour.

;;∙------∙Alarm Settings∙----------------∙
enableAlarm := True    ;;∙------∙Enable/disable alarm functionality.
alarmSet := false    ;;∙------∙Alarm active state (true=alarm will trigger).
alarmHour := 8    ;;∙------∙Default hour for alarm (1-12 for 12-hour, 0-23 for 24-hour).
alarmMinute := 00    ;;∙------∙Default minute for alarm (0-59).
alarmStyle := "Triple"    ;;∙------∙"Single", "Double", "Triple".
alarmFrequency := 1200    ;;∙------∙Base frequency in Hertz.
alarmDuration := 200    ;;∙------∙Duration of each beep in ms.
alarmRepeat := 5    ;;∙------∙Number of times to repeat the alarm pattern.
alarmText := "Silver"    ;;∙------∙Color of alarm text.
alarmColor := "Rose"    ;;∙------∙Color of alarm numbers.
alarmIndicate := "Lime"    ;;∙------∙Color of alarm indicator.

;;∙------∙Internal Tracking∙--------------∙(DO NOT CHANGE!)
lastDate := ""    ;;∙------∙Tracks last date for rollover detection.
lastHour := ""    ;;∙------∙Tracks last hour for chime triggering.
lastAlarmHour := ""    ;;∙------∙Tracks last alarm hour for display updates.
lastAlarmMinute := ""    ;;∙------∙Tracks last alarm minute for display updates.
lastAlarmSet := ""    ;;∙------∙Tracks last alarm set state for indicator updates.
alarmActive := false    ;;∙------∙Tracks if alarm is currently triggering.

;;∙---------∙WINDOW DRAG & TRAY ICON∙------------------∙
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Enables window dragging by left-clicking anywhere on the GUI.
Menu, Tray, Icon, shell32.dll, 266    ;∙------∙Sets the system tray icon (shell32.dll, icon index 266 = clock icon).

;;∙---------∙TIMERS & SCRIPT ID∙------------------------------∙
SetTimer, UpdateCheck, 750    ;;∙------∙Checks script file for external modifications.
SetTimer, UpdateClock, 1000    ;;∙------∙Updates clock display every second.
SetTimer, CheckAlarm, 1000    ;;∙------∙Checks alarm conditions every second.
ScriptID := "Just_A_Clock"    ;;∙------∙Unique identifier for the script window.
GoSub, TrayMenu    ;;∙------∙Builds and displays the system tray menu.

;;∙---------∙GDI+ INITIALIZATION∙-----------------------------∙
hModule := DllCall("LoadLibrary", "Str", "Gdiplus.dll", "Ptr")
VarSetCapacity(GdiplusStartupInput, 24, 0)
NumPut(1, GdiplusStartupInput, 0, "UInt")
DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", pToken, "Ptr", &GdiplusStartupInput, "Ptr", 0)

;;∙=============================================∙
;;∙======∙COLOR CONVERTER∙=====================∙
Color(ColorName, Format := "GDI+") {
    static colorMap := {}
    ;;∙------∙Build color map.
    if (!colorMap.Count()) {
        ;;∙------∙Base Color Definitions∙-------∙
        ;;∙------∙Grayscale.
        colorMap["Black"] := "000000"
        colorMap["Gray"] := "808080"
        colorMap["Silver"] := "C0C0C0"
        colorMap["White"] := "FFFFFF"
        ;;∙------∙Red.
        colorMap["Maroon"] := "800000"
        colorMap["Red"] := "FF0000"
        colorMap["Magenta-Red"] := "FF0066"
        colorMap["Rose"] := "FF007F"
        ;;∙------∙Pink.
        colorMap["Salmon"] := "FA8072"
        colorMap["Light Salmon"] := "FFA07A"
        colorMap["Coral"] := "FF7F50"
        colorMap["Hot Pink"] := "FF69B4"
        colorMap["Deep Pink"] := "FF1493"
        colorMap["Rose Pink"] := "FF66CC"
        colorMap["Pink"] := "FF80FF"
        ;;∙------∙Orange.
        colorMap["Red-Orange"] := "FF3300"
        colorMap["Orange"] := "FF6600"
        colorMap["Yellow-Red"] := "FF6347"
        colorMap["Yellow-Orange"] := "FF8C00"
        ;;∙------∙Yellow.
        colorMap["Yellow"] := "FFFF00"
        colorMap["Chartreuse"] := "DFFF00"
        ;;∙------∙Green.
        colorMap["Olive"] := "808000"
        colorMap["Green"] := "008000"
        colorMap["Lime"] := "00FF00"
        colorMap["Spring Green"] := "00FF7F"
        colorMap["Cyan-Green"] := "00FA9A"
        ;;∙------∙Cyan.
        colorMap["Teal"] := "008080"
        colorMap["Aqua"] := "00FFFF"
        colorMap["Azure"] := "007FFF"
        ;;∙------∙Blue.
        colorMap["Blue"] := "0000FF"
        colorMap["Navy"] := "000080"
        ;;∙------∙Violet.
        colorMap["Indigo"] := "8B00FF"
        colorMap["Violet"] := "7F00FF"
        colorMap["Purple"] := "800080"
        ;;∙------∙Magenta.
        colorMap["Fuchsia"] := "FF00FF"
        ;;∙------∙Other Name Variations∙-------∙
        colorMap["Grey"] := colorMap["Gray"]
        colorMap["Cyan"] := colorMap["Aqua"]
        colorMap["Magenta"] := colorMap["Fuchsia"]
    }

    ;;∙------∙Trim input.
    ColorName := Trim(ColorName)

    ;;∙------∙Check if already a hex code.
    if (RegExMatch(ColorName, "^(0x)?[0-9A-Fa-f]{6}$")) {
        hex := RegExReplace(ColorName, "^(0x)", "")
    } else {
        ;;∙------∙Look up color name.
        hex := colorMap[ColorName]
        if (hex = "")
            hex := "FFFFFF"    ;;∙------∙Default to white.
    }

        ;;∙------∙Return appropriate format.
    if (Format = "GUI")
        return hex
    else if (Format = "GUI0x")
        return "0x" . hex
    else    ;;∙------∙GDI+ format (with Alpha).
        return "0xFF" . hex
}

;;∙=============================================∙
;;∙======∙GUI BUILD∙=============================∙
Gui, MyGui:New
Gui, MyGui:-Caption +ToolWindow -DPIScale +E0x02000000 +E0x00080000
If (clockOnTop)
    Gui, MyGui:+AlwaysOnTop
Gui, MyGui:Color, % Color(gBackground, "GUI0x")
Gui, MyGui:Font, s12 q5, Segoe UI

;;∙------∙Clock Face Border Edges.
eTrim1Hex := Color(eTrim1, "GUI")
eTrim2Hex := Color(eTrim2, "GUI")
boxline("MyGui", 35, 35, 230, 230, eTrim1Hex, eTrim1Hex, eTrim1Hex, eTrim1Hex, 2)
boxline("MyGui", 25, 25, 250, 250, eTrim2Hex, eTrim2Hex, eTrim2Hex, eTrim2Hex, 2)

;;∙------∙Roman Numerals (optional via settings).
If (showRomanNumerals) {
    romanNumerals := ["XII", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI"]
    rNumeralColor := Color(rNumeral, "GUI0x")
    Gui, MyGui:Font, s8 c%rNumeralColor% bold, Times New Roman

    Loop, 12 {
        Angle := (A_Index - 3) * 30
        Rad := Angle * 3.141592653589793 / 180
        CenterX := 150
        CenterY := 150
        Radius := 78
        TextToDraw := romanNumerals[A_Index]
        
        ;;∙------∙Fixed offsets for proper adjustable centering.
        TextX := CenterX + Round(Radius * Cos(Rad)) - 5
        TextY := CenterY + Round(Radius * Sin(Rad)) - 7
        
        Gui, MyGui:Add, Text, x%TextX% y%TextY% vRomanNumeral%A_Index% BackgroundTrans, %TextToDraw%
    }
}

;;∙------∙Hour Markers (always shown).
hMarkerHex := Color(hMarker, "GUI")
Loop, 12 {
    Angle := (A_Index - 3) * 30
    Rad := Angle * 3.141592653589793 / 180
    CenterX := 150
    CenterY := 150
    Radius := 95
    MarkerX := CenterX + Round(Radius * Cos(Rad)) - 2
    MarkerY := CenterY + Round(Radius * Sin(Rad)) - 2
    Gui, MyGui:Add, Progress, x%MarkerX% y%MarkerY% w4 h4 Background%hMarkerHex%
}

;;∙------∙Minute Markers (optional via settings).
If (showMinuteMarkers) {
    mMarkerHex := Color(mMarker, "GUI")
    Loop, 60 {
        If (Mod(A_Index, 5) = 0)
            Continue
        Angle := (A_Index - 15) * 6
        Rad := Angle * 3.141592653589793 / 180
        CenterX := 150
        CenterY := 150
        Radius := 95
        MarkerX := CenterX + Round(Radius * Cos(Rad)) - 1
        MarkerY := CenterY + Round(Radius * Sin(Rad)) - 1
        Gui, MyGui:Add, Progress, x%MarkerX% y%MarkerY% w2 h2 Background%mMarkerHex%
    }
}

;;∙------∙Week Number Display (bottom right inside inner box / optional via settings).
If (showWeekNumber) {
    weekColorHex := Color(weekColor, "GUI0x")
    Gui, MyGui:Font, s8 c%weekColorHex%, Courier New
    Gui, MyGui:Add, Text, x215 y230 w60 h30 vWeekNumber gHideClock BackgroundTrans Center, Week`n00
}

;;∙------∙Alarm Settings Display (bottom left inside inner box).
If (enableAlarm) {
    alarmColorHex := Color(alarmColor, "GUI0x")
    Gui, MyGui:Font, s8 c%alarmText%, Courier New
    Gui, MyGui:Add, Text, x40 y230 gAlarmSettings BackgroundTrans, Alarm
    Gui, MyGui:Font, s8 c%alarmColorHex%, Courier New
    Gui, MyGui:Add, Text, x40 y245 gAlarmSettings vAlarmTime BackgroundTrans, % Format("{:02}:{:02}", alarmHour, alarmMinute)
    Gui, MyGui:Font, s10 c%alarmIndicate%, Courier New
    Gui, MyGui:Add, Text, x+2 y245 vAlarmIndicator BackgroundTrans,
}

;;∙------∙Dynamic Y positioning based on visible elements.
DisplayY := 285
If (showDigitalTime) {     ;;∙------∙(optional via settings)
    dTimeHex := Color(dTime, "GUI0x")
    Gui, MyGui:Font, s16 c%dTimeHex% bold, Courier New
    Gui, MyGui:Add, Text, x0 y%DisplayY% w300 Center vDigitalTime, 00:00:00 AM
    DisplayY += 25
}
If (showDigitalDate) {     ;;∙------∙(optional via settings)
    dDateHex := Color(dDate, "GUI0x")
    Gui, MyGui:Font, s12 c%dDateHex% bold, Courier New
    Gui, MyGui:Add, Text, x0 y%DisplayY% w300 Center vDigitalDate, Mon 0/00/0000
    DisplayY += 25
}

;;∙------∙Adjust window height based on visible elements.
WindowHeight := DisplayY + 10
Gui, MyGui:Add, Picture, x0 y0 w300 h310 vClockHands

;;∙------∙Add transparent clickable area over center point.
Gui, MyGui:Add, Text, x135 y135 w30 h30 gCloseClock BackgroundTrans

;;∙------∙Show window.
Gui, MyGui:Show, x%startX% y%startY% w300 h%WindowHeight%, %ScriptID%

;;∙------∙Apply transparency once window is visible.
If (windowTransparency < 255) {
    WinGet, hwnd, ID, Toy Clock
    WinSet, Transparent, %windowTransparency%, ahk_id %hwnd%
}

;;∙------∙Initialize displays on startup.
If (showDigitalDate)
    GoSub, UpdateDate
If (showWeekNumber) {
    GetWeekNumber(WeekNum)
    GuiControl, MyGui:, WeekNumber, Week`n%WeekNum%
}

;;∙------∙Initialize alarm indicator.
If (alarmSet) {
    GuiControl, MyGui:, AlarmIndicator, •
} Else {
    GuiControl, MyGui:, AlarmIndicator,
}
Return

;;∙=============================================∙
;;∙======∙ALARM SETTINGS DIALOG∙================∙
AlarmSettings:
    Global alarmSet, alarmHour, alarmMinute, enableAlarm, use24HourFormat, alarmStyle
    
    ;;∙------∙Calculate selection indices.
    If (use24HourFormat) {
        HourIndex := alarmHour + 1
    } Else {
        HourIndex := alarmHour
    }
    MinuteIndex := alarmMinute + 1
    
    ;;∙------∙Determine alarm style index for DDL.
    StyleIndex := 1
    If (alarmStyle = "Double")
        StyleIndex := 2
    Else If (alarmStyle = "Triple")
        StyleIndex := 3
    
    ;;∙------∙Build settings dialog.
    Gui, AlarmSettings:New
    Gui, AlarmSettings:+AlwaysOnTop -Caption +Border +ToolWindow
    Gui, AlarmSettings:Color, %gBackground%
    Gui, AlarmSettings:Font, c%dialogText%
    
    ;;∙------∙Hour selection.
    Gui, AlarmSettings:Add, Text, x10 y12, Hour:
    Gui, AlarmSettings:Add, DropDownList, x+5 y10 r12 w50 vNewAlarmHour Choose%HourIndex%, % BuildHourList()
    
    ;;∙------∙Minute selection.
    Gui, AlarmSettings:Add, Text, x+10 y12, Minute:
    Gui, AlarmSettings:Add, DropDownList, x+5 y10 r12 w50 vNewAlarmMinute Choose%MinuteIndex%, % BuildMinuteList()
    
    ;;∙------∙Format display.
    Gui, AlarmSettings:Font, s8 Italic
    If (use24HourFormat) {
        Gui, AlarmSettings:Add, Text, x10 y45 cGray, Format: 24-Hour (0-23)
    } Else {
        Gui, AlarmSettings:Add, Text, x60 y35 cGray, Format: 12-Hour (1-12)
    }
    Gui, AlarmSettings:Font, s8 Norm

    ;;∙------∙Alarm style selection.
    Gui, AlarmSettings:Add, Text, x10 y65, Style:
    Gui, AlarmSettings:Add, DropDownList, x+5 y62 r3 w70 vNewAlarmStyle Choose%StyleIndex%, Single|Double|Triple

    ;;∙------∙Alarm active checkbox.
    Gui, AlarmSettings:Add, Checkbox, x+10 y65 vNewAlarmSet Checked%alarmSet%, Alarm Active

    ;;∙------∙Alarm buttons.
    Gui, AlarmSettings:Add, Button, x20 y95 w80 gAlarmSettingsOK, OK
    Gui, AlarmSettings:Add, Button, x+10 y95 w80 gAlarmSettingsCancel, Cancel

        setStartX := (startX + 50), setStartY := (startY + 330)
    Gui, AlarmSettings:Show, x%setStartX% y%setStartY% w210 h130, Alarm Settings
Return

;;∙=============================================∙
;;∙======∙BUILD HOUR & MINUTE LISTS∙============∙
BuildHourList() {
    Global use24HourFormat
    HourList := ""
    If (use24HourFormat) {
        Loop, 24 {
            HourVal := A_Index - 1
            HourList .= (HourList = "" ? "" : "|") . Format("{:02}", HourVal)
        }
    } Else {
        Loop, 12 {
            HourVal := A_Index
            HourList .= (HourList = "" ? "" : "|") . Format("{:02}", HourVal)
        }
    }
    Return HourList
}

BuildMinuteList() {
    MinuteList := ""
    Loop, 60 {
        MinuteVal := A_Index - 1
        MinuteList .= (MinuteList = "" ? "" : "|") . Format("{:02}", MinuteVal)
    }
    Return MinuteList
}

;;∙=============================================∙
;;∙======∙ALARM SETTINGS∙=======================∙
AlarmSettingsOK:
    Gui, AlarmSettings:Submit
    
    ;;∙------∙Get selected values from DDL text.
    NewHour := SubStr(NewAlarmHour, 1, 2) + 0
    NewMinute := SubStr(NewAlarmMinute, 1, 2) + 0
    
    ;;∙------∙Update global variables.
    alarmHour := NewHour
    alarmMinute := NewMinute
    alarmSet := NewAlarmSet
    alarmStyle := NewAlarmStyle
    alarmActive := false
    lastAlarmSet := alarmSet
    
    ;;∙------∙Update display.
    GuiControl, MyGui:, AlarmTime, % Format("{:02}:{:02}", alarmHour, alarmMinute)
    If (alarmSet) {
        GuiControl, MyGui:, AlarmIndicator, •
    } Else {
        GuiControl, MyGui:, AlarmIndicator,
    }
    
    ;;∙------∙Confirmation beeps based on selected style.
    If (alarmStyle = "Single") {
        SoundBeep, 1000, 200
    } Else If (alarmStyle = "Double") {
        SoundBeep, 900, 100
        Sleep, 80
        SoundBeep, 1100, 100
    } Else If (alarmStyle = "Triple") {
        SoundBeep, 800, 100
        Sleep, 80
        SoundBeep, 1000, 100
        Sleep, 80
        SoundBeep, 1200, 100
    }

    Gui, AlarmSettings:Destroy
Return

AlarmSettingsCancel:
AlarmSettingsGuiClose:
AlarmSettingsGuiEscape:
    Gui, AlarmSettings:Destroy
Return

;;∙=============================================∙
;;∙======∙HOT KEYS∙=============================∙
;;∙------∙🔥∙Toggle clock AlwaysOnTop.
;;∙------∙(also available via Menu / also unhides Gui)
^!t::GoSub, ToggleclockOnTop    ;;∙------∙(Ctrl + Alt + T)

;;∙------∙🔥∙Unhide clock without affecting always on top.
^!u::    ;;∙------∙(Ctrl + Alt + U)
    Gui, MyGui:Show
    SoundBeep, 1000, 100
Return

;;∙------∙🔥∙Open alarm Settings.
^!s::GoSub, AlarmSettings    ;;∙------∙(Ctrl + Alt + S)

;;∙------∙🔥∙Toggle alarm Active state.
^!a::    ;;∙------∙(Ctrl + Alt + A)
    Global alarmSet, lastAlarmSet
    alarmSet := !alarmSet
    lastAlarmSet := alarmSet
    If (alarmSet) {
        GuiControl, MyGui:, AlarmIndicator, •
        SoundBeep, 1200, 100
        SoundBeep, 1400, 100
    } Else {
        GuiControl, MyGui:, AlarmIndicator,
        SoundBeep, 1400, 100
        SoundBeep, 1200, 100
    }
Return

;;∙=============================================∙
;;∙======∙DATE UPDATE ROUTINE∙==================∙
UpdateDate:
    If (!showDigitalDate)
        Return
    CurrentTime := A_Now
    Year := SubStr(CurrentTime, 1, 4)
    Month := SubStr(CurrentTime, 5, 2)
    Day := SubStr(CurrentTime, 7, 2)
    DayOfWeek := A_DDD
    MonthNum := Month + 0
    DayNum := Day + 0
    DigitalDateStr := DayOfWeek . " " . MonthNum . "/" . DayNum . "/" . Year
    GuiControl, MyGui:, DigitalDate, %DigitalDateStr%
Return

;;∙=============================================∙
;;∙======∙ALARM CHECK ROUTINE∙==================∙
CheckAlarm:
    Global enableAlarm, alarmSet, alarmHour, alarmMinute, alarmActive
    Global use24HourFormat, alarmColor

    If (!enableAlarm or !alarmSet)
        Return

    CurrentTime := A_Now
    CurrentHour := SubStr(CurrentTime, 9, 2) + 0
    CurrentMinute := SubStr(CurrentTime, 11, 2) + 0
    CurrentSecond := SubStr(CurrentTime, 13, 2) + 0

    ;;∙------∙Convert to 24-hour format for comparison if needed.
    alarmHour24 := alarmHour
    If (!use24HourFormat) {
        If (alarmHour = 12)
            alarmHour24 := 12
        Else
            alarmHour24 := alarmHour
    }

    ;;∙------∙Check if current time matches alarm time.
    If (CurrentHour = alarmHour24 and CurrentMinute = alarmMinute and CurrentSecond = 0 and !alarmActive) {
        alarmActive := true
        Gosub, TriggerAlarm
    }

    ;;∙------∙Reset alarm trigger after minute passes.
    If ((CurrentHour != alarmHour24 or CurrentMinute != alarmMinute) and alarmActive)
        alarmActive := false
Return

;;∙=============================================∙
;;∙======∙TRIGGER ALARM ROUTINE∙===============∙
TriggerAlarm:
    Global alarmStyle, alarmFrequency, alarmDuration, alarmRepeat, alarmActive
    
    ;;∙------∙Play alarm sound based on style.
    Loop, %alarmRepeat% {
        If (alarmStyle = "Single") {
            SoundBeep, %alarmFrequency%, %alarmDuration%
        }
        Else If (alarmStyle = "Double") {
            SoundBeep, % alarmFrequency + 200, %alarmDuration%
            Sleep, 150
            SoundBeep, %alarmFrequency%, %alarmDuration%
        }
        Else If (alarmStyle = "Triple") {
            SoundBeep, % alarmFrequency + 300, %alarmDuration%
            Sleep, 100
            SoundBeep, % alarmFrequency + 150, %alarmDuration%
            Sleep, 100
            SoundBeep, %alarmFrequency%, %alarmDuration%
        }
        
        ;;∙------∙Flash alarm indicator during alarm sequence.
        If (Mod(A_Index, 2) = 0)
            GuiControl, MyGui: Show, AlarmIndicator
        Else
            GuiControl, MyGui: Hide, AlarmIndicator
        
        ;;∙------∙Wait between repetitions (except after the last one).
        If (A_Index < alarmRepeat)
            Sleep, 300
    }
    
    GuiControl, MyGui: Show, AlarmIndicator
    alarmActive := false
Return

;;∙=============================================∙
;;∙======∙WEEK NUMBER ROUTINE∙================∙
GetWeekNumber(ByRef WeekNum) {
    ;;∙------∙Calculate ISO week number.
    CurrentDate := A_Now
    Year := SubStr(CurrentDate, 1, 4)
    Month := SubStr(CurrentDate, 5, 2)
    Day := SubStr(CurrentDate, 7, 2)

    ;;∙------∙Calculate day of year (1-366).
    DaysInMonth := [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    ;;∙------∙Leap year check.
    IsLeap := (Mod(Year, 4) = 0 && Mod(Year, 100) != 0) || Mod(Year, 400) = 0
    If IsLeap
        DaysInMonth[2] := 29

    DayOfYear := 0
    Loop, % Month - 1
        DayOfYear += DaysInMonth[A_Index]
    DayOfYear += Day

    ;;∙------∙Get day of week (1=Monday to 7=Sunday).
    ;;∙------∙A_WDay is 1=Sunday to 7=Saturday, convert to Monday-based.
    MondayBasedDOW := A_WDay - 1
    If (MondayBasedDOW = 0)
        MondayBasedDOW := 7

    ;;∙------∙Calculate ISO week number.
    WeekNum := Floor((DayOfYear - MondayBasedDOW + 10) / 7)

    ;;∙------∙Handle week 0 (belongs to previous year).
    If (WeekNum < 1) {
        ;;∙------∙Get last year's week 52 or 53.
        PrevYear := Year - 1
        PrevYearIsLeap := (Mod(PrevYear, 4) = 0 && Mod(PrevYear, 100) != 0) || Mod(PrevYear, 400) = 0
        LastDayOfPrevYear := 365 + PrevYearIsLeap
        ;;∙------∙Calculate week number for Dec 31 of previous year.
        WeekNum := Floor((LastDayOfPrevYear - MondayBasedDOW + 10) / 7)
    }

    ;;∙------∙Handle week 53 (check if it's actually week 1 of next year).
    If (WeekNum = 53) {
        ;;∙------∙Check if Jan 1 of next year is Thursday or earlier.
        NextYear := Year + 1
        NextYearJan1DOW := A_Now
        NextYearJan1DOW := NextYear . "0101"
        EnvAdd, NextYearJan1DOW, 0, Days
        FormatTime, NextYearJan1DOW, %NextYearJan1DOW%, WDay
        ;;∙------∙Convert to Monday-based (1=Monday).
        NextYearJan1DOW_Mon := NextYearJan1DOW - 1
        If (NextYearJan1DOW_Mon = 0)
            NextYearJan1DOW_Mon := 7
        If (NextYearJan1DOW_Mon <= 4)
            WeekNum := 1
    }
}

;;∙=============================================∙
;;∙======∙HOURLY CHIME ROUTINE∙================∙
HourlyChime:
    Global enableChime, chimeStyle, chimeFrequency, chimeDuration
    Global chimeStartHour, chimeEndHour

    If (!enableChime)
        Return

    ;;∙------∙Check if current hour is within allowed chime hours.
    CurrentHour := SubStr(A_Now, 9, 2) + 0
    If (CurrentHour < chimeStartHour or CurrentHour > chimeEndHour)
        Return

    If (chimeStyle = "Single") {
        SoundBeep, %chimeFrequency%, %chimeDuration%
    }
    Else If (chimeStyle = "Double") {
        SoundBeep, % chimeFrequency + 200, %chimeDuration%
        Sleep, 150
        SoundBeep, %chimeFrequency%, %chimeDuration%
    }
    Else If (chimeStyle = "Triple") {
        SoundBeep, % chimeFrequency + 300, %chimeDuration%
        Sleep, 100
        SoundBeep, % chimeFrequency + 150, %chimeDuration%
        Sleep, 100
        SoundBeep, %chimeFrequency%, %chimeDuration%
    }
Return

;;∙=============================================∙
;;∙======∙CLOCK UPDATE ROUTINE∙=================∙
UpdateClock:
    ;;∙------∙Update alarm time display if needed.
    Global enableAlarm, alarmSet, alarmHour, alarmMinute
    Global lastAlarmHour, lastAlarmMinute, lastAlarmSet

    ;;∙------∙Update alarm indicator visibility.
    If (enableAlarm and lastAlarmSet != alarmSet) {
        lastAlarmSet := alarmSet
        If (alarmSet)
            GuiControl, MyGui:, AlarmIndicator, •
        Else
            GuiControl, MyGui:, AlarmIndicator,
    }

    If (enableAlarm and (lastAlarmHour != alarmHour or lastAlarmMinute != alarmMinute)) {
        lastAlarmHour := alarmHour
        lastAlarmMinute := alarmMinute
        GuiControl, MyGui:, AlarmTime, % Format("{:02}:{:02}", alarmHour, alarmMinute)
    }

    CurrentTime := A_Now
    Hour := SubStr(CurrentTime, 9, 2)
    Minute := SubStr(CurrentTime, 11, 2)
    Second := SubStr(CurrentTime, 13, 2)

    ;;∙------∙Date rollover check.
    Global lastDate
    CurrentDate := SubStr(CurrentTime, 1, 8)
    If (CurrentDate != lastDate) {
        lastDate := CurrentDate
        If (showDigitalDate)
            GoSub, UpdateDate
        If (showWeekNumber) {
            GetWeekNumber(WeekNum)
            GuiControl, MyGui:, WeekNumber, Week`n%WeekNum%
        }
    }

    ;;∙------∙Hourly chime check.
    Global lastHour
    If (Minute = "00" and Second = "00") {
        If (lastHour != Hour) {
            lastHour := Hour
            GoSub, HourlyChime
        }
    } Else {
        If (Minute != "00" or Second != "00")
            lastHour := ""
    }

    ;;∙------∙Format time based on user preference (12/24 hour).
    If (use24HourFormat) {
        Hour24 := Hour + 0
        TimeStr := Format("{:02}:{:02}:{:02}", Hour24, Minute, Second)
    } Else {
        Hour12 := Mod(Hour, 12)
        if (Hour12 = 0)
            Hour12 := 12
        AMPM := (Hour >= 12) ? "PM" : "AM"
        TimeStr := Format("{:02}:{:02}:{:02} {}", Hour12, Minute, Second, AMPM)
    }

    ;;∙------∙Update digital time if visible.
    If (showDigitalTime)
        GuiControl, MyGui:, DigitalTime, %TimeStr%

    ;;∙------∙Calculate angles.
    If (use24HourFormat) {
        HourAngle := (Mod(Hour, 12) * 30) + (Minute * 0.5)
    } Else {
        Hour12 := Mod(Hour, 12)
        if (Hour12 = 0)
            Hour12 := 12
        HourAngle := (Hour12 * 30) + (Minute * 0.5)
    }
    MinuteAngle := (Minute * 6)
    SecondAngle := (Second * 6)

    ;;∙------∙Create and display hands.
    pBitmap := CreateHandsBitmap(HourAngle, MinuteAngle, SecondAngle)
    DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", pBitmap, "PtrP", hBitmap, "UInt", 0xFF000000)
    DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", pBitmap)
    GuiControl, MyGui:, ClockHands, *w300 *h310 HBITMAP:%hBitmap%
    DllCall("DeleteObject", "Ptr", hBitmap)
Return

;;∙=============================================∙
;;∙======∙CREATE HANDS BITMAP∙==================∙
CreateHandsBitmap(HourAngle, MinuteAngle, SecondAngle) {
    global hHand, mHand, sHand, cPoint, cPointSize
    global hLength, mLength, sLength
    global hThick, mThick, sThick

    DllCall("Gdiplus.dll\GdipCreateBitmapFromScan0", "Int", 300, "Int", 310, "Int", 0, "Int", 0x26200A, "Ptr", 0, "PtrP", pBitmap)
    DllCall("Gdiplus.dll\GdipGetImageGraphicsContext", "Ptr", pBitmap, "PtrP", pGraphics)
    DllCall("Gdiplus.dll\GdipSetSmoothingMode", "Ptr", pGraphics, "Int", 4)

    hHandColor := Color(hHand, "GDI+")
    mHandColor := Color(mHand, "GDI+")
    sHandColor := Color(sHand, "GDI+")
    cPointColor := Color(cPoint, "GDI+")

    DllCall("Gdiplus.dll\GdipCreatePen1", "UInt", hHandColor, "Float", hThick, "Int", 2, "PtrP", pHourPen)
    DllCall("Gdiplus.dll\GdipCreatePen1", "UInt", mHandColor, "Float", mThick, "Int", 2, "PtrP", pMinutePen)
    DllCall("Gdiplus.dll\GdipCreatePen1", "UInt", sHandColor, "Float", sThick, "Int", 2, "PtrP", pSecondPen)
    DllCall("Gdiplus.dll\GdipCreateSolidFill", "UInt", cPointColor, "PtrP", pCenterBrush)

    CenterX := 150
    CenterY := 150

    DrawGdiLine(pGraphics, pHourPen, CenterX, CenterY, HourAngle, hLength)
    DrawGdiLine(pGraphics, pMinutePen, CenterX, CenterY, MinuteAngle, mLength)
    DrawGdiLine(pGraphics, pSecondPen, CenterX, CenterY, SecondAngle, sLength)

    offset := cPointSize / 2
    DllCall("Gdiplus.dll\GdipFillEllipse", "Ptr", pGraphics, "Ptr", pCenterBrush, "Float", CenterX - offset, "Float", CenterY - offset, "Float", cPointSize, "Float", cPointSize)

    DllCall("Gdiplus.dll\GdipDeletePen", "Ptr", pHourPen)
    DllCall("Gdiplus.dll\GdipDeletePen", "Ptr", pMinutePen)
    DllCall("Gdiplus.dll\GdipDeletePen", "Ptr", pSecondPen)
    DllCall("Gdiplus.dll\GdipDeleteBrush", "Ptr", pCenterBrush)
    DllCall("Gdiplus.dll\GdipDeleteGraphics", "Ptr", pGraphics)

    return pBitmap
}

;;∙=============================================∙
;;∙======∙DRAW GDI+ LINE∙=======================∙
DrawGdiLine(pGraphics, pPen, CenterX, CenterY, AngleDeg, Length) {
    ScreenAngle := 90 - AngleDeg
    Rad := ScreenAngle * 3.141592653589793 / 180
    EndX := CenterX + Length * Cos(Rad)
    EndY := CenterY - Length * Sin(Rad)
    DllCall("Gdiplus.dll\GdipDrawLine", "Ptr", pGraphics, "Ptr", pPen, "Float", CenterX, "Float", CenterY, "Float", EndX, "Float", EndY)
}

;;∙=============================================∙
;;∙========∙boxLINE ROUTINE∙====================∙
boxline(GuiName, X, Y, W, H, ColorTop := "Black", ColorBottom := "Black", ColorLeft := "Black", ColorRight := "Black", Thickness := 1)
{	
    BottomY := Y + H - Thickness
    RightX := X + W - Thickness
    Gui, %GuiName%:Add, Progress, x%X% y%Y% w%W% h%Thickness% Background%ColorTop%
    Gui, %GuiName%:Add, Progress, x%X% y%BottomY% w%W% h%Thickness% Background%ColorBottom%
    Gui, %GuiName%:Add, Progress, x%X% y%Y% w%Thickness% h%H% Background%ColorLeft%
    Gui, %GuiName%:Add, Progress, x%RightX% y%Y% w%Thickness% h%H% Background%ColorRight%
}

;;∙=============================================∙
;;∙========∙GUI DRAG∙===========================∙
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}
Return

;;∙=============================================∙
;;∙========∙HIDE CLOCK ROUTINE∙================∙
HideClock:
    Gui, MyGui:Hide
Return

;;∙=============================================∙
;;∙========∙ALWAYS ON TOP TOGGLE∙==============∙
ToggleclockOnTop:
    Global clockOnTop
    Gui, MyGui:Show  ; This will unhide the GUI if it was hidden
    clockOnTop := !clockOnTop
    If (clockOnTop)
        Gui, MyGui:+AlwaysOnTop
    Else
        Gui, MyGui:-AlwaysOnTop
    SoundBeep, 1000, 100
Return

;;∙=============================================∙
;;∙========∙GUI CLEANUP & CLOSE∙================∙
CloseClock:
MyGuiGuiClose:
    DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", pToken)
    DllCall("FreeLibrary", "Ptr", hModule)
    ExitApp
Return

;;∙=============================================∙
;;∙========∙TRAY MENU∙==========================∙
TrayMenu:
Menu, Tray, Tip, %ScriptID%
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Toggle Always On Top, ToggleclockOnTop
Menu, Tray, Icon, Toggle Always On Top, shell32.dll, 266
Menu, Tray, Default, Toggle Always On Top
Menu, Tray, Add
Menu, Tray, Add, Suspend / Pause, %ScriptID%
Menu, Tray, Icon, Suspend / Pause, shell32, 28
;;∙------∙MENU-EXTENTIONS∙---------∙
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
;;∙------∙MENU-OPTIONS∙-------------∙
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

;;∙------∙EXTENTIONS∙------------------∙
Documentation:
    Run, "C:\Program Files\AutoHotkey\AutoHotkey.chm"
Return

ShowKeyHistory:
    KeyHistory
Return

ShowWindowSpy:
    Run, "C:\Program Files\AutoHotkey\WindowSpy.ahk"
Return

Just_A_Clock:
    Suspend
    Soundbeep, 700, 100
    Pause
Return

;;∙=============================================∙
;;∙======∙TRAY MENU POSITION∙===================∙
;;∙------∙Tray Menu Show∙--------∙
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20
Return

;;∙------∙Position Funtion∙-------∙
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

;;∙=============================================∙
;;∙========∙SCRIPT UPDATE∙=======================∙
UpdateCheck:
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload

;;∙=============================================∙
;;∙========∙EDIT / RELOAD / EXIT∙==================∙
Script·Edit:
    Edit
Return

^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)
    Script·Reload:
        Soundbeep, 1200, 250
    Reload
Return

^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)
    Script·Exit:
        Soundbeep, 1000, 300
        Gosub, MyGuiGuiClose
    ExitApp
Return
;;∙=============================================∙
;;∙***********************************************
;;∙****************** SCRIPT END ******************
;;∙***********************************************

