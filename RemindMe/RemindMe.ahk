
/*------∙NOTES∙--------------------------------------------------------------------------∙
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
∙--------------------------------------------------------------------------------------------∙
*/


SetTimer, UpdateCheck, 750    ;;∙------∙Sets a timer to call UpdateCheck every 750 milliseconds.
ScriptID := "RemindMe"    ;;∙------∙Also change in 'MENU HEADER' at scripts end!!
GoSub, TrayMenu


;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙
#Requires AutoHotkey 1
#NoEnv
#SingleInstance Force
SendMode, Input
SetBatchLines -1
SetWinDelay 0
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")
SetWorkingDir %A_ScriptDir%
Menu, Tray, Icon, shell32.dll, 245

global Reminder_Check_Interval := 5000
global Min_Year := 2020
global Max_Year := 2100
global Gui_Update_Interval := 1000

global reminders := []
global reminderFile := A_ScriptDir . "\reminders.txt"
global calendarOpen := false

global textColor := "759FFF"
global guiColor := "000000"
global currentColor := "94C4FF"
global messageColor := "FFFF00"
global errorColor := "FF0000"
global warningColor := "FF8000"
global successColor := "00FF00"

global ChimeEnabled := false

guiWidth := 310
guiHeight := 255
padding := 10

;;∙------∙GUI position selectors∙---∙(0= Edge+10, 1 = 1/4, 2 = 1/2, 3 = 3/4 of screen).
global Calendar_X_Quarter := 3
global Calendar_Y_Quarter := 2

global Reminder_X_Quarter := 3
global Reminder_Y_Quarter := 1

global Error_X_Quarter := 2
global Error_Y_Quarter := 1

global Warning_X_Quarter := 2
global Warning_Y_Quarter := 2

global Success_X_Quarter := 2
global Success_Y_Quarter := 3

LoadReminders()
SetTimer, CheckReminders, %Reminder_Check_Interval%

;;∙🔥∙==============================∙🔥∙
^r::    ;;∙------∙🔥∙(Ctrl + R+R)
if (A_PriorHotkey != "^r" or A_TimeSincePriorHotkey > 250)
    {
        return
    }
    ShowCalendar()
Return

;;∙---------------------------------------------------∙
GetGuiPosition(X_Quarter, Y_Quarter, guiWidth, guiHeight, cascadeOffset := 0) {
    static guiCount := {}

    positionKey := X_Quarter . "_" . Y_Quarter
    if (!IsObject(guiCount) || !guiCount[positionKey])
        guiCount[positionKey] := 0

    guiCount[positionKey]++
    cascadeMultiplier := guiCount[positionKey] - 1

    SysGet, MonitorWorkArea, MonitorWorkArea
    screenWidth := MonitorWorkAreaRight - MonitorWorkAreaLeft
    screenHeight := MonitorWorkAreaBottom - MonitorWorkAreaTop

    quarterX := screenWidth / 4
    quarterY := screenHeight / 4

    guiX := MonitorWorkAreaLeft + (quarterX * X_Quarter)
    guiY := MonitorWorkAreaTop + (quarterY * Y_Quarter)

    guiX += (cascadeMultiplier * 10)
    guiY += (cascadeMultiplier * 10)

    if (X_Quarter = 0)
        guiX := MonitorWorkAreaLeft + padding

    if (Y_Quarter = 0)
        guiY := MonitorWorkAreaTop + padding

    ;;∙------∙Clamp X within screen bounds (left and right).
    if (guiX < MonitorWorkAreaLeft + padding)
        guiX := MonitorWorkAreaLeft + padding

    overflowX := (guiX + guiWidth) - MonitorWorkAreaRight
    if (overflowX > 0)
        guiX := MonitorWorkAreaRight - guiWidth - padding

    ;;∙------∙Clamp Y within screen bounds (top and bottom).
    if (guiY < MonitorWorkAreaTop + padding)
        guiY := MonitorWorkAreaTop + padding

    overflowY := (guiY + guiHeight) - MonitorWorkAreaBottom
    if (overflowY > 0)
        guiY := MonitorWorkAreaBottom - guiHeight - padding

    return {x: guiX, y: guiY}
}

;;∙---------------------------------------------------∙
ResetGuiCounter(X_Quarter, Y_Quarter) {
    static guiCount := {}
    positionKey := X_Quarter . "_" . Y_Quarter
    guiCount[positionKey] := 0
}

;;∙---------------------------------------------------∙
ShowCalendar() {
    global

    if (calendarOpen) {
        SetTimer, UpdateCalendarTime, Off
    }

    Gui, Calendar:Destroy
    Gui, Calendar:New, +AlwaysOnTop -Caption +Border +ToolWindow, Set Reminder
    Gui, Calendar:Font, s10 c%textColor%, Segoe UI
    Gui, Calendar:Color, %guiColor%

    FormatTime, CurrentDate,, dddd`, MMM. dd, yyyy
    FormatTime, CurrentTime12,, h:mm
    FormatTime, CurrentTime24,, HH:mm:ss  tt
    FormatTime, CurrentAmPm,, tt

    Gui, Calendar:Add, Text, x15 y15, Set The Date:
    Gui, Calendar:Font, s10 c%guiColor%, Courier

    Gui, Calendar:Add, DropDownList, x+5 y12 w100 vSelectedMonth gUpdateDayList, % GetMonthList()
    Gui, Calendar:Add, DropDownList, x+5 w40 r31 vSelectedDay AltSubmit, % GetDayList(GetCurrentMonth(), GetCurrentYear())

    FormatTime, currentYear,, yyyy
    Gui, Calendar:Add, Edit, x+5 w50 vSelectedYear gUpdateDayList, %currentYear%

    Gui, Calendar:Font, s10 c%textColor%, Segoe UI
    Gui, Calendar:Add, Text, x15 y+10, For The Time:
    Gui, Calendar:Font, s10 c%guiColor%, Courier

    FormatTime, CurrentHour12,, h
    FormatTime, CurrentMinute,, mm

    Gui, Calendar:Add, DropDownList, x+5 w45 vSelectedHour, % GetHourList(CurrentHour12)
    Gui, Calendar:Add, Text, x+2, :
    Gui, Calendar:Add, DropDownList, x+2 w45 vSelectedMinute, % GetMinuteList(CurrentMinute)
    Gui, Calendar:Add, DropDownList, x+5 w45 vSelectedAmPm, % (CurrentAmPm = "AM" ? "AM||PM" : "PM||AM")

    Gui, Calendar:Font, s10 c%textColor%, Segoe UI

    chimeCheckboxState := ChimeEnabled ? "Checked" : ""
    Gui, Calendar:Add, Text, x210 y+10, Play Chime
    Gui, Calendar:Add, CheckBox, x+5 vChimeCheckbox %chimeCheckboxState%

    Gui, Calendar:Font, s10 c%textColor%
    Gui, Calendar:Add, Text, x15 yp, Set Reminder Message:

    Gui, Calendar:Font, s10 c%guiColor%, Cambria
    Gui, Calendar:Add, Edit, x15 y+5 w280 h80 vReminderText, Enter message here...
    Gui, Calendar:Font, s10 c%textColor%, Segoe UI

    Gui, Calendar:Add, Text, x15 y+10, Currently: 
    Gui, Calendar:Font, s10 c%currentColor%, Segoe UI
    Gui, Calendar:Add, Text, x15 y+2 vCurrentDateTime, %CurrentTime24%`n%CurrentDate%

    pos := GetGuiPosition(Calendar_X_Quarter, Calendar_Y_Quarter, guiWidth, guiHeight)
    guiX := pos.x
    guiY := pos.y

    Gui, Calendar:Add, Button, x170 yp w60 gSetReminder, Schedule
    Gui, Calendar:Add, Button, x+5 w60 gCancelCalendar, Cancel

    Gui, Calendar:Show, x%guiX% y%guiY% w%guiWidth% h%guiHeight%, RemindMe

    GuiControl, Focus, ReminderText
    Send, ^{Home}+^{End}

    calendarOpen := true

    SetTimer, UpdateCalendarTime, %Gui_Update_Interval%
}

;;∙---------------------------------------------------∙
UpdateDayList:
    Gui, Calendar:Submit, NoHide

    if (SelectedYear = "") {
        return
    }

    monthNum := GetMonthNumber(SelectedMonth)
    year := SelectedYear

    GuiControl, , SelectedDay, % "|" . GetDayList(monthNum, year)
    GuiControl, Choose, SelectedDay, 1
Return

;;∙---------------------------------------------------∙
UpdateCalendarTime:
    if (WinExist("Set Reminder")) {
        FormatTime, CurrentDate,, dddd`, MMM. dd, yyyy
        FormatTime, CurrentTime24,, HH:mm:ss  tt
        GuiControl, Calendar:, CurrentDateTime, %CurrentTime24%`n%CurrentDate%
    } else {
        SetTimer, UpdateCalendarTime, Off
    }
Return

;;∙---------------------------------------------------∙
GetCurrentMonth() {
    FormatTime, currentMonth,, MM
    return currentMonth
}

;;∙---------------------------------------------------∙
GetCurrentYear() {
    FormatTime, currentYear,, yyyy
    return currentYear
}

;;∙---------------------------------------------------∙
GetMonthList() {
    FormatTime, currentMonth,, MM
    monthNames := ["January", "February", "March", "April", "May", "June"
                  , "July", "August", "September", "October", "November", "December"]

    monthList := ""
    for index, monthName in monthNames {
        if (index = currentMonth)
            monthList .= monthName . "||"
        else
            monthList .= monthName . "|"
    }
    return monthList
}

;;∙---------------------------------------------------∙
GetDayList(month, year) {
    FormatTime, currentDay,, dd
    currentDay := SubStr(currentDay, 1) + 0
    FormatTime, currentMonth,, MM
    FormatTime, currentYear,, yyyy

    maxDays := GetMaxDaysInMonth(month, year)

    dayList := ""
    Loop, %maxDays% {
        if (A_Index = currentDay and month = currentMonth and year = currentYear)
            dayList .= A_Index . "||"
        else
            dayList .= A_Index . "|"
    }
    return dayList
}

;;∙---------------------------------------------------∙
GetMaxDaysInMonth(month, year) {
    daysInMonth := [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    if (month = 2) {
        isLeapYear := ((Mod(year, 4) = 0 and Mod(year, 100) != 0) or Mod(year, 400) = 0)
        return isLeapYear ? 29 : 28
    }

    return daysInMonth[month]
}

;;∙---------------------------------------------------∙
GetHourList(currentHour) {
    hourList := ""
    Loop, 12 {
        hour := A_Index
        if (hour = currentHour)
            hourList .= hour . "||"
        else
            hourList .= hour . "|"
    }
    return hourList
}

;;∙---------------------------------------------------∙
GetMinuteList(currentMinute) {
    minuteList := ""
    Loop, 60 {
        minute := Format("{:02d}", (A_Index - 1))
        if (minute = currentMinute)
            minuteList .= minute . "||"
        else
            minuteList .= minute . "|"
    }
    return minuteList
}

;;∙---------------------------------------------------∙
SetReminder() {
    global

    Gui, Calendar:Submit, NoHide

    ChimeEnabled := ChimeCheckbox

    timeString := SelectedHour . ":" . SelectedMinute
    validationResult := ValidateReminderInputs(SelectedMonth, SelectedDay, SelectedYear, timeString, SelectedAmPm, ReminderText)
    if (!validationResult.success) {
        ShowErrorGui(validationResult.error)
        return
    }

    parsedTime := Parse12HourTime(timeString, SelectedAmPm)
    if (!parsedTime.success) {
        ShowErrorGui(parsedTime.error)
        return
    }

    monthNumber := GetMonthNumber(SelectedMonth)
    monthStr := Format("{:02d}", monthNumber)
    dayStr := Format("{:02d}", SelectedDay)
    dateString := SelectedYear . "-" . monthStr . "-" . dayStr

    timestamp := ParseDateTime(dateString, parsedTime.hour24, parsedTime.minute)

    if (timestamp <= A_Now) {
        ShowPastDateWarning(SelectedMonth, SelectedDay, SelectedYear, parsedTime.display12, ReminderText)
        return
    }

    reminder := {}
    reminder.date := dateString
    reminder.time := parsedTime.display12
    reminder.text := ReminderText
    reminder.timestamp := timestamp
    reminder.chime := ChimeEnabled

    reminders.Push(reminder)
    SaveReminders()

    SetTimer, UpdateCalendarTime, Off
    Gui, Calendar:Destroy
    calendarOpen := false

    ShowSuccessGui(ReminderText, timestamp)
}

;;∙---------------------------------------------------∙
ShowErrorGui(errorMessage) {
    global errorColor, guiColor, Error_X_Quarter, Error_Y_Quarter

    textLength := StrLen(errorMessage)
    estimatedRows := Ceil(textLength / 40)
    rowsNeeded := Min(Max(estimatedRows, 2), 8)

    baseWidth := 300
    baseHeight := 100
    rowHeight := 20
    guiHeight := baseHeight + (rowsNeeded * rowHeight)
    guiWidth := baseWidth + 30

    textWidth := guiWidth - 40

    ResetGuiCounter(Error_X_Quarter, Error_Y_Quarter)

    Gui, Error:Destroy
    Gui, Error:New, +AlwaysOnTop -Caption +Border +ToolWindow, Error
    Gui, Error:Color, %guiColor%

    Gui, Error:Font, s12 c%errorColor% Bold, Segoe UI
    Gui, Error:Add, Text, x20 y20 w%textWidth% Center, ⚠ Error

    Gui, Error:Font, s10 c%textColor% Norm, Segoe UI
    Gui, Error:Add, Text, x20 y+10 w%textWidth% Center, %errorMessage%

    buttonX := (guiWidth // 2) - 30
    Gui, Error:Font, s9 c%guiColor%, Segoe UI
    Gui, Error:Add, Button, x%buttonX% y+20 w60 gCloseErrorGui, OK

    Gui, Error:Add, Text    ;;∙------∙Gui bottom space.

    pos := GetGuiPosition(Error_X_Quarter, Error_Y_Quarter, guiWidth, guiHeight)
    guiX := pos.x
    guiY := pos.y

    Gui, Error:Show, x%guiX% y%guiY% w%guiWidth%
    WinSet, AlwaysOnTop, On, Error
}

;;∙---------------------------------------------------∙
ShowPastDateWarning(month, day, year, time, reminderText) {
    global warningColor, guiColor, textColor, currentColor, Warning_X_Quarter, Warning_Y_Quarter

    warningMessage := "The selected date and time is in the past.`n`n"
    warningMessage .= "Do you want to set this reminder anyway?"

    textLength := StrLen(warningMessage)
    estimatedRows := Ceil(textLength / 40)
    rowsNeeded := Min(Max(estimatedRows, 3), 10)

    baseWidth := 350
    baseHeight := 140
    rowHeight := 18
    guiHeight := baseHeight + (rowsNeeded * rowHeight)
    guiWidth := baseWidth

    textWidth := guiWidth - 40

    ResetGuiCounter(Warning_X_Quarter, Warning_Y_Quarter)

    Gui, PastWarning:Destroy
    Gui, PastWarning:New, +AlwaysOnTop -Caption +Border +ToolWindow, Past Date Warning
    Gui, PastWarning:Color, %guiColor%

    Gui, PastWarning:Font, s12 c%warningColor% Bold, Segoe UI
    Gui, PastWarning:Add, Text, x20 y20 w%textWidth% Center, ⚠ Warning

    Gui, PastWarning:Font, s10 c%textColor% Norm, Segoe UI
    Gui, PastWarning:Add, Text, x20 y+10 w%textWidth% Center, %warningMessage%

    Gui, PastWarning:Font, s9 c%guiColor%, Segoe UI
    buttonWidth := 80
    buttonSpacing := 20
    totalButtonsWidth := (buttonWidth * 2) + buttonSpacing
    startX := (guiWidth - totalButtonsWidth) // 2

    Gui, PastWarning:Add, Button, x%startX% y+20 w%buttonWidth% gAcceptPastDate, Yes
    Gui, PastWarning:Add, Button, x+%buttonSpacing% w%buttonWidth% gCancelPastDate, No

    Gui, PastWarning:Add, Text

    pos := GetGuiPosition(Warning_X_Quarter, Warning_Y_Quarter, guiWidth, guiHeight)
    guiX := pos.x
    guiY := pos.y

    Gui, PastWarning:Show, x%guiX% y%guiY% w%guiWidth%
    WinSet, AlwaysOnTop, On, Past Date Warning

    global pendingPastReminder := {}
    pendingPastReminder.month := month
    pendingPastReminder.day := day
    pendingPastReminder.year := year
    pendingPastReminder.time := time
    pendingPastReminder.text := reminderText
    pendingPastReminder.chime := ChimeEnabled
}

;;∙---------------------------------------------------∙
AcceptPastDate:
    global pendingPastReminder

    if (pendingPastReminder) {

        timeParts := StrSplit(pendingPastReminder.time, " ")
        timeStr := timeParts[1]
        ampm := timeParts[2]

        parsedTime := Parse12HourTime(timeStr, ampm)
        if (parsedTime.success) {
            monthNumber := GetMonthNumber(pendingPastReminder.month)
            monthStr := Format("{:02d}", monthNumber)
            dayStr := Format("{:02d}", pendingPastReminder.day)
            dateString := pendingPastReminder.year . "-" . monthStr . "-" . dayStr

            timestamp := ParseDateTime(dateString, parsedTime.hour24, parsedTime.minute)

            reminder := {}
            reminder.date := dateString
            reminder.time := parsedTime.display12
            reminder.text := pendingPastReminder.text
            reminder.timestamp := timestamp
            reminder.chime := pendingPastReminder.chime

            reminders.Push(reminder)
            SaveReminders()

            SetTimer, UpdateCalendarTime, Off
            Gui, Calendar:Destroy
            global calendarOpen := false

            ShowSuccessGui(pendingPastReminder.text, timestamp)
        }
    }

    Gui, PastWarning:Destroy
Return

;;∙---------------------------------------------------∙
CancelPastDate:
    Gui, PastWarning:Destroy
Return

;;∙---------------------------------------------------∙
ShowSuccessGui(reminderText, timestamp) {
    global successColor, guiColor, currentColor, messageColor, Success_X_Quarter, Success_Y_Quarter

    scheduledTimestamp := SubStr(timestamp, 1, 12) . "00"
    FormatTime, scheduledFormatted, %scheduledTimestamp%, MMM. dd, yyyy @ h:mm tt
    FormatTime, currentTimeFormatted,, MMM. dd, yyyy @ h:mm tt

    baseWidth := 400
    baseHeight := 120
    rowHeight := 18
    guiWidth := baseWidth

    textLength := StrLen(reminderText)
    estimatedRows := Ceil(textLength / 40)
    reminderRows := Min(Max(estimatedRows, 1), 3)
    guiHeight := baseHeight + (reminderRows * rowHeight)

    textWidth := guiWidth - 40

    ResetGuiCounter(Success_X_Quarter, Success_Y_Quarter)

    Gui, Success:Destroy
    Gui, Success:New, +AlwaysOnTop -Caption +Border +ToolWindow, Reminder Set
    Gui, Success:Color, %guiColor%

    Gui, Success:Font, s12 c%successColor% Bold, Segoe UI
    Gui, Success:Add, Text, x20 y20 w%textWidth% Center, ✓ Reminder Set

    Gui, Success:Font, s8 c%messageColor%, Cambria
    Gui, Success:Add, Text, x20 y+10 w%textWidth% Center, """%reminderText%"""

    Gui, Success:Font, s9 c%currentColor%, Segoe UI
    Gui, Success:Add, Text, x20 y+10 w%textWidth%, Scheduled for:`t%scheduledFormatted%
    Gui, Success:Add, Text, x20 y+5 w%textWidth%, Current time:`t%currentTimeFormatted%

    buttonX := (guiWidth // 2) - 30
    Gui, Success:Font, s9 c%guiColor%, Segoe UI
    Gui, Success:Add, Button, x%buttonX% y+15 w60 gCloseSuccessGui, OK

    Gui, Success:Add, Text

    pos := GetGuiPosition(Success_X_Quarter, Success_Y_Quarter, guiWidth, guiHeight)
    guiX := pos.x
    guiY := pos.y

    Gui, Success:Show, x%guiX% y%guiY% w%guiWidth% 
    WinSet, AlwaysOnTop, On, Reminder Set
}

;;∙---------------------------------------------------∙
CloseErrorGui:
    Gui, Error:Destroy
Return

;;∙---------------------------------------------------∙
CloseSuccessGui:
    Gui, Success:Destroy
Return

;;∙---------------------------------------------------∙
ValidateReminderInputs(month, day, year, time, ampm, text) {
    result := {}

    if (!month or !day or !year or !time or !text) {
        result.success := false
        result.error := "Please fill in all fields!"
        return result
    }

    if (year < Min_Year or year > Max_Year) {
        result.success := false
        result.error := "Year must be between " . Min_Year . " and " . Max_Year . "!"
        return result
    }

    if year is not integer
    {
        result.success := false
        result.error := "Year must be a valid number!"
        return result
    }

    monthNum := GetMonthNumber(month)
    maxDays := GetMaxDaysInMonth(monthNum, year)
    if (day < 1 or day > maxDays) {
        result.success := false
        result.error := "Invalid day for " . month . "! (Max: " . maxDays . " days)"
        return result
    }

    if (text = "Enter message here...") {
        result.success := false
        result.error := "Please enter a reminder message!"
        return result
    }

    result.success := true
    return result
}

;;∙---------------------------------------------------∙
CancelCalendar() {
    global calendarOpen
    SetTimer, UpdateCalendarTime, Off
    Gui, Calendar:Destroy
    calendarOpen := false
}

;;∙---------------------------------------------------∙
Parse12HourTime(timeStr, ampm) {
    result := {}

    result.success := false
    result.hour24 := ""
    result.minute := ""
    result.display12 := ""
    result.error := ""

    timeStr := Trim(timeStr)
    ampm := Trim(ampm)

    if (RegExMatch(timeStr, "^(1[0-2]|[1-9]):([0-5][0-9])$", match)) {
        hour := match1
        minute := match2
    } 
    else if (RegExMatch(timeStr, "^(1[0-2]|[1-9])$", match)) {
        hour := match1
        minute := "00"
    } 
    else {
        result.error := "Invalid time format! Use h:mm or h (e.g., 2:30 or 2)"
        return result
    }

    if (ampm = "AM") {
        if (hour = 12) {
            result.hour24 := "00"
        } else {
            result.hour24 := Format("{:02d}", hour)
        }
    } else if (ampm = "PM") {
        if (hour = 12) {
            result.hour24 := "12"
        } else {
            result.hour24 := Format("{:02d}", hour + 12)
        }
    } else {
        result.error := "Invalid AM/PM selection!"
        return result
    }

    result.minute := minute

    if (minute = "00") {
        result.display12 := hour . " " . ampm
    } else {
        result.display12 := hour . ":" . minute . " " . ampm
    }

    result.success := true
    return result
}

;;∙---------------------------------------------------∙
GetMonthNumber(monthName) {
    if (monthName = "January")
        return 1
    if (monthName = "February")
        return 2
    if (monthName = "March")
        return 3
    if (monthName = "April")
        return 4
    if (monthName = "May")
        return 5
    if (monthName = "June")
        return 6
    if (monthName = "July")
        return 7
    if (monthName = "August")
        return 8
    if (monthName = "September")
        return 9
    if (monthName = "October")
        return 10
    if (monthName = "November")
        return 11
    if (monthName = "December")
        return 12
    return 1
}

;;∙---------------------------------------------------∙
IsValidDate(dateStr) {
    if (RegExMatch(dateStr, "^\d{4}-\d{2}-\d{2}$")) {
        year := SubStr(dateStr, 1, 4)
        month := SubStr(dateStr, 6, 2)
        day := SubStr(dateStr, 9, 2)

        if (month < 1 or month > 12)
            return false

        maxDays := GetMaxDaysInMonth(month, year)

        if (day < 1 or day > maxDays)
            return false
        return true
    }
    return false
}

;;∙---------------------------------------------------∙
ParseDateTime(dateStr, hour24, minute) {
    year := SubStr(dateStr, 1, 4)
    month := SubStr(dateStr, 6, 2)
    day := SubStr(dateStr, 9, 2)

    timestamp := year . month . day . hour24 . minute . "00"
    return timestamp
}

;;∙---------------------------------------------------∙
SaveReminders() {
    global reminders, reminderFile

    fileContent := ""
    for index, reminder in reminders {
        rDate := reminder.date
        rTime := reminder.time
        rText := reminder.text
        rTimestamp := reminder.timestamp
        rChime := reminder.chime ? "1" : "0"
        fileContent .= rDate . "|" . rTime . "|" . rText . "|" . rTimestamp . "|" . rChime . "`n"
    }

    FileDelete, %reminderFile%
    if (fileContent != "") {
        FileAppend, %fileContent%, %reminderFile%
    }
}

;;∙---------------------------------------------------∙
LoadReminders() {
    global reminders, reminderFile, ChimeEnabled

    if (FileExist(reminderFile)) {
        FileRead, content, %reminderFile%
        Loop, Parse, content, `n, `r
        {
            if (A_LoopField != "") {
                parts := StrSplit(A_LoopField, "|")
                if (parts.Length() >= 4) {
                    reminder := {}
                    reminder.date := parts[1]
                    reminder.time := parts[2]
                    reminder.text := parts[3]
                    reminder.timestamp := parts[4]

                    reminder.chime := (parts.Length() >= 5 && parts[5] = "1") ? true : false

                    reminders.Push(reminder)

                    ChimeEnabled := reminder.chime
                }
            }
        }
    }
}

;;∙---------------------------------------------------∙
CheckReminders:
    CheckDueReminders()
Return

CheckDueReminders() {
    global reminders

    if (reminders.Length() = 0)
        return

    currentTime := A_Now
    Loop % reminders.Length() {
        index := reminders.Length() - A_Index + 1
        reminder := reminders[index]
        rTimestamp := reminder.timestamp
        if (rTimestamp <= currentTime) {
            ShowReminder(reminder)
            reminders.RemoveAt(index)
            SaveReminders()
        }
    }
}

;;∙---------------------------------------------------∙
ShowReminder(reminder) {
    global Reminder_X_Quarter, Reminder_Y_Quarter

    if (reminder.chime) {
        SoundPlay, *64
    }

    FormatTime, currentTimeFormatted,, MMM. dd, yyyy @ h:mm tt

    scheduledTimestamp := SubStr(reminder.timestamp, 1, 12) . "00"
    FormatTime, scheduledFormatted, %scheduledTimestamp%, MMM. dd, yyyy @ h:mm tt

    rText := reminder.text

    textLength := StrLen(rText)
    estimatedRows := Ceil(textLength / 50)
    rowsNeeded := Min(Max(estimatedRows, 2), 10)

    baseHeight := 160
    rowHeight := 20
    guiHeight := baseHeight + (rowsNeeded * rowHeight)

    guiWidth := 330
    padding := 10

    pos := GetGuiPosition(Reminder_X_Quarter, Reminder_Y_Quarter, guiWidth, guiHeight)
    guiX := pos.x
    guiY := pos.y

    static reminderCount := 0
    reminderCount++
    guiName := "ReminderGUI" . reminderCount

    Gui, %guiName%:New, +AlwaysOnTop -Caption +Border +ToolWindow, Reminder
    Gui, %guiName%:Color, %guiColor%
    Gui, %guiName%:Font, s9 c%textColor% Bold, Segoe UI
    Gui, %guiName%:Add, Text, x10 y10 w300, 🔔 Reminder! 🔔

    Gui, %guiName%:Font, s10 c%messageColor%, Cambria
    Gui, %guiName%:Add, Edit, x10 y+10 w300 R%rowsNeeded% +ReadOnly +BackgroundTrans +VScroll -E0x200, %rText%

    Gui, %guiName%:Font, s9 c%currentColor% Norm, Segoe UI
    Gui, %guiName%:Add, Text, x10 y+10 w300, Scheduled For:`t%scheduledFormatted%
    Gui, %guiName%:Add, Text, x10 y+5 w300, Presented At:`t%currentTimeFormatted%

    Gui, %guiName%:Font, s9 c%guiColor%, Segoe UI
    Gui, %guiName%:Add, Button, x140 y+15 w60 gCloseReminder, OK
    
    GuiControl, Focus, Button1
    Gui, %guiName%:Add, Text

    Gui, %guiName%:Show, x%guiX% y%guiY% w330, Reminder
    return
}

CloseReminder:
    Gui, Destroy
Return

;;∙---------------------------------------------------∙
OnExit("ExitFunc")

ExitFunc(ExitReason, ExitCode) {
    SaveReminders()
}

WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙



;;∙====================================∙
 ;;∙------∙EDIT∙---------------------------∙
Script·Edit:    ;;∙------∙Menu Call.
    Edit
Return

;;∙------∙RELOAD∙-----------------------∙
^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        Soundbeep, 1200, 250
    Reload
Return

 ;;∙------∙EXIT∙----------------------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        Soundbeep, 1000, 300
    ExitApp
Return

;;∙====================================∙
 ;;∙------∙SCRIPT UPDATE∙-------------∙
UpdateCheck:    ;;∙------Check if script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload

;;∙====================================∙
 ;;∙------∙TRAY MENU∙------------------∙
TrayMenu:
Menu, Tray, Tip, %ScriptID%
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Suspend / Pause, % ScriptID    ;;∙------∙Script Header.
Menu, Tray, Icon, Suspend / Pause, shell32, 28
Menu, Tray, Default, Suspend / Pause    ;;∙------∙Makes Bold.

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

;;∙------∙MENU-HEADER∙---------------∙
RemindMe:    ;;∙------∙Suspends hotkeys then pauses script.
    Suspend
    Soundbeep, 700, 100
    Pause
Return

;;∙====================================∙
 ;;∙------∙MENU POSITION∙-----------∙
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20
Return

 ;;∙------∙POSITION FUNTION∙-------∙
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
;;∙------------------------------------------------------------------------------------------∙
;;∙========================∙SCRIPT END∙=========================∙
;;∙------------------------------------------------------------------------------------------∙

