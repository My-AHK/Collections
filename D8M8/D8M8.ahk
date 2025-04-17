
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
;;∙────────────────────────────∙
#Persistent
#SingleInstance, Force
SetTitleMatchMode, 2
SetControlDelay -1
SetWinDelay -1

global xOffset := 15    ;;∙------∙Offset Gui positioning function x-axis (pixels) left of screen right edge.
global yOffset := 10    ;;∙------∙Offset Gui positioning function y-axis (pixels) above taskbar.
global LastTargetWin := ""

OnMessage(0x201, "WM_LBUTTONDOWN")    ;;∙------∙Capture mouse click BEFORE GUI takes focus.

^+LButton::    ;;∙------∙🔥∙(Ctrl + Shift + LeftMouse Button) to show GUI.
    WinGet, LastTargetWin, ID, A    ;;∙------∙Track the active window before GUI shows.
    Gosub, ShowMyGui
Return

;;∙─────────────────────∙
ShowMyGui:
    Gui, Destroy
    Gui, New
    Gui, +AlwaysOnTop -Caption +Border +ToolWindow
    Gui, +HwndGuiHwnd    ;;<∙------∙Required for Positioning Function.
    Gui, Color, Black
    Gui, Margin, 10, 10
    Gui, Font, s8, Segoe UI

;;∙────────────────────────────────────────────∙
;;∙────────∙Buttons Column 1∙─────────────────────∙
    Gui, Add, Button, x10 y10 w120 h22 HwndhText gSendDate, Date
        GuiTip(hText, "  Inserts current date`nExample: Apr 15, 2025")
    Gui, Add, Button,  x10 y+5 w120 h22 HwndhText gSendTomorrow, Tomorrow's Date
        GuiTip(hText, "Send tomorrow's date`nExample:`nApr/17/2025")
    Gui, Add, Button, x10 y+5 w120 h22 HwndhText gSendYesterday, Yesterday's Date
        GuiTip(hText, "Date one day ago`nExample: Apr 14, 2025")
    Gui, Add, Button, x10 y+5 w120 h22 HwndhText gSendTime, Time
        GuiTip(hText, "Current time in 12-hour format`n       Example: 01:27:42 PM")
    Gui, Add, Button, x10 y+5 w120 h22 HwndhText gSendDateTime, Date && Time
        GuiTip(hText, "    Combined date & time`nExample: Apr 15, 2025 ∙ 01:27:42 PM")
    Gui, Add, Button, x10 y+5 w120 h22 HwndhText gSendShortDate, Short Date
        GuiTip(hText, "Compact date format`n    Example: 4/15/25")
    Gui, Add, Button, x10 y+5 w120 h22 HwndhText gSendTime12hr, 12-Hour Time
        GuiTip(hText, "12h format without seconds`n       Example: 1:27 PM")
    Gui, Add, Button, x10 y+5 w120 h22 HwndhText gSendTime24hr, 24-Hour Time
        GuiTip(hText, "Military format with seconds`n      Example: 13:27:42")
    Gui, Add, Button, x10 y+5 w120 h22 HwndhText gSendISO8601, ISO 8601 Standard
        GuiTip(hText, "Standard ISO date-time format`n Example: 2025-04-15T13:27:42")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendISOWeekday, ISO Week-Weekday
        GuiTip(hText, "ISO week with weekday`nExample: 2025-W16-3")
    Gui, Add, Button, x10 y+5 w120 h22 HwndhText gSendIsoWeek, ISO Week-Year
        GuiTip(hText, "ISO year-week notation`n  Example: 2025-W16")
    Gui, Add, Button, x10 y+5 w120 h22 HwndhText gSendISOWeek2, ISO Week
        GuiTip(hText, "Week number of the year`n    Example: Week 16")

;;∙────────∙Buttons Column 2∙─────────────────────∙
    Gui, Add, Button, x+10 y10 w120 h22 HwndhText gSendDayName, Day Name
        GuiTip(hText, "Full name of weekday`n  Example: Tuesday")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendDayNumber, Day of Week Number
        GuiTip(hText, "Numeric day of month`n        Example: 15")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendWeek, Week Number
        GuiTip(hText, "Calendar week number`n         Example: 16")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendWeekdayNum, Weekday Number
        GuiTip(hText, "Numeric weekday`n     Example: 3")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendMonthName, Month Name
        GuiTip(hText, "Full month name`n  Example: April")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendMonthNum, Month Number
        GuiTip(hText, "Numeric month`n    Example: 4")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendYear, Year Only
        GuiTip(hText, "Four-digit year`n Example: 2025")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendDayOfYear, Day of Year
        GuiTip(hText, "Year day number (1-365)`n    Example: 105")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendDOYRemaining, Days Left This Year
        GuiTip(hText, "    Remaining days in year`nExample: 260 days left this year")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendRelativeDate, Date offset
        GuiTip(hText, "Custom date offset from now`n       Example: 2025-W16-3")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendBusinessDays, Business Days
        GuiTip(hText, "Work days between dates`nExample: 12 business days")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendTimeToTarget, Time To Target
        GuiTip(hText, "Time Until Target`nExample: 12 days")

;;∙────────∙Buttons Column 3∙─────────────────────∙
    Gui, Add, Button, x+10 y10 w120 h22 HwndhText gSendQuarter, Quarter
        GuiTip(hText, "Calendar quarter`n    Example: Q2")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendQuarter2, Year+Quarter
        GuiTip(hText, "Year-Quarter combination`n      Example: 2025-Q2")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendDynamicFiscalQuarter, Fiscal Quarter
        GuiTip(hText, "      Fiscal year quarter`n(dynamically configurable)`n      Example: 2025-Q2`n  Set FiscalStart in script")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendPreviousQuarter, Previous Quarter
        GuiTip(hText, "   Previous calendar quarter`nExample: If current is Q1 2024`n         outputs... Q4-2023  ")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendUTC, UTC Now
        GuiTip(hText, "        Current UTC time`nExample: 2025-04-15T17:27:42`n        (Assuming UTC-4)")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendUnix, Unix Timestamp
        GuiTip(hText, "Seconds since 1970 epoch`n    Example: 1744723662")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendUnixMilliseconds, Unix ms
        GuiTip(hText, "Milliseconds since 1970 epoch`n    Example: 1744723662392")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendJulian, Julian Date
        GuiTip(hText, "Year + day of year`n Example: 2025105")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendOrdinalDate, Ordinal Date
        GuiTip(hText, "ISO ordinal date format`n   Example: 2025-105")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendRomanDate, Roman Numeral Date
        GuiTip(hText, "Send Roman numeral date`n  Example:  XVI-IV-MMXXV`n(16-April-2025 / 16-04-2025)")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendWorkweekProgress, Work Week Progress
        GuiTip(hText, "Work week has progressed...`nExample: 12 business days")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendYearProgress, Year Progress
        GuiTip(hText, "The year has progressed...`nExample: 12 business days")

;;∙────────∙Buttons Column 4∙─────────────────────∙
    Gui, Add, Button, x+10 y10 w120 h22 HwndhText gSendCustomNamed, Named Format
        GuiTip(hText, "Customizable quick access`nExample:`nTuesday, April 15 2025 - 1:27 PM")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendFileStamp, File Stamp
        GuiTip(hText, "   Filesystem-safe timestamp`nExample: 2025-04-15_13-27-42")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendLocalTZ, Timezone Name
        GuiTip(hText, "Local timezone abbreviation`n        Example: EDT")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendLeapCheck, Is Leap Year?
        GuiTip(hText, "   Leap year verification`nExample: Not a Leap Year")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendNextLeapDay, Next Leap Day
        GuiTip(hText, "Next February 29 occurrence`n     Example: Feb 29, 2028")
     Gui, Add, Button, y+5 w120 h22 HwndhText gSendMoonPhase, Moon Phase
        GuiTip(hText, "     Current lunar phase`nExample:`nMoon Phase: First Quarter")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendDOSTimestamp, DOS Timestamp
        GuiTip(hText, "     Legacy DOS format`nExample: 20250415_132742")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendRFC2822, RFC 2822 Date
        GuiTip(hText, "Internet Message Format date`nExample:`nTue, 15 Apr 2025 13:27:42 -0400")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendHolidayCountdown, Holiday Countdown
        GuiTip(hText, "Days until major holidays`nExample:`nDec 25 - 128 days (Christmas)")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendMetSeason, Meteorology Season
        GuiTip(hText, "Current meteorology season is...`n Example:`n Spring (Meteorological)")
    Gui, Add, Button, y+5 w120 h22 HwndhText gSendZodiacSign, Zodiac Sign
        GuiTip(hText, "Astrological sign`nExample:`nCurrent zodiak sign is: Aries")
    Gui, Add, Button, y+5 w120 h22 HwndhText gHideGUISection, Hide GUI Window
        GuiTip(hText, "Dismisss the GUI")
;;∙─────────────────────∙
    Gui, Show, AutoSize Hide
        WinMove(GuiHwnd, "D R", 1)
    Gui, Show
Return

;;∙────────────────────────────────────────────∙
;;∙────────∙Functions Column 1∙────────────────────∙
SendDate:
    FormatTime, CurrentDateTime,, MMM/dd/yyyy
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    ;;∙------∙Clipboard = %CurrentDateTime%    ;;∙------∙Remove comment block to send to clipboard.
    SendInput %CurrentDateTime%
    Gui, Hide    ;;∙------∙Hide the GUI after sending.
Return

;;∙───────∙
SendTomorrow:
    Tomorrow := A_Now
    Tomorrow += 1, Days
    FormatTime, Out, %Tomorrow%, MMM/dd/yyyy
    WinActivate, ahk_id %LastTargetWin%
    ;;∙------∙Clipboard = %Out%    ;;<∙------∙Remove block to send to clipboard.
    SendInput %Out%
    Gui, Hide
Return

;;∙───────∙

SendYesterday:
ystrdy := A_Now
ystrdy += -1, Days
    formattime, ystrdy, %ystrdy%, MM-dd-yyyy
    WinActivate, ahk_id %LastTargetWin%
    ;;∙------∙Clipboard = %ystrdy%    ;;<∙------∙Remove block to clipboard.
    SendInput %ystrdy%
    Gui, Hide
Return

;;∙───────∙

SendTime:
    FormatTime, CurrentDateTime,, hh:mm:ss tt
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    ;;∙------∙Clipboard = %ystrdy%    ;;<∙------∙Remove - you get the idea.
    SendInput %CurrentDateTime%
    Gui, Hide
Return

;;∙───────∙
SendDateTime:
    FormatTime, CurrentDateTime,,MMM/dd/yyyy ∙ hh:mm:ss tt
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput %CurrentDateTime%
    Gui, Hide
Return

;;∙───────∙
SendShortDate:
    FormatTime, Out,, M/d/yy
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput %Out%
    Gui, Hide
Return

;;∙───────∙
SendTime12hr:
    FormatTime, Out,, h:mm tt
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput %Out%
    Gui, Hide
Return

;;∙───────∙
SendTime24hr:
    FormatTime, Out,, HH:mm:ss
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput %Out%
    Gui, Hide
Return

;;∙───────∙
SendISO8601:
    ;;∙------∙Get local time.
    FormatTime, LocalTime,, yyyy-MM-ddTHH:mm:ss

    ;;∙------∙Capture output of w32tm /tz.
    TempFile := A_Temp "\tz_output.txt"
    RunWait, %ComSpec% /c w32tm /tz > "%TempFile%",, Hide
    FileRead, tzOutput, %TempFile%
    FileDelete, %TempFile%

    ;;∙------∙Extract bias (time zone offset in minutes).
    RegExMatch(tzOutput, "Bias: (-?\d+)", bias)
    offsetMinutes := bias1 * -1    ;;∙------∙Invert the sign.

    ;;∙------∙Calculate hours and minutes for offset.
    offsetHours := Abs(offsetMinutes) // 60
    offsetMins := Mod(Abs(offsetMinutes), 60)
    offsetSign := (offsetMinutes > 0) ? "+" : "-"
    offset := Format("{}{:02}:{:02}", offsetSign, offsetHours, offsetMins)

    ;;∙------∙Send formatted ISO 8601 time.
    WinActivate, ahk_id %LastTargetWin%
    SendInput %LocalTime%%offset%
    Gui, Hide
Return

;;∙───────∙
SendISOWeekday:
    FormatTime, ISOWk,, YWeek
    FormatTime, WDay,, WDay
    ISOWeekday := (WDay = 1) ? 7 : WDay-1    ;;∙------∙Monday=1.
    Out := SubStr(ISOWk, 1,4) "-W" SubStr(ISOWk,5) "-" ISOWeekday
    WinActivate, ahk_id %LastTargetWin%
    SendInput %Out%
    Gui, Hide
Return

;;∙───────∙
SendIsoWeek:
    FormatTime, ISOYear,, yyyy
    FormatTime, ISOWk,, YWeek
    ISOWeek := SubStr(ISOWk, 5)
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput %ISOYear%-W%ISOWeek%
    Gui, Hide
Return

;;∙───────∙
SendISOWeek2:
    FormatTime, Y,, yyyy
    FormatTime, W,, YWeek
    Out := Y "-W" SubStr("00" W, -1)
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput %Out%
    Gui, Hide
Return

;;∙────────∙Functions Column 2∙────────────────────∙
SendDayName:
    FormatTime, DayName,, dddd    ;;∙------∙Full day name (e.g., Monday).
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput %DayName%
    Gui, Hide
Return

;;∙───────∙
SendDayNumber:
    FormatTime, DayNum,, d    ;;∙------∙Day of month as number (1-31).
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput Day %DayNum%
    Gui, Hide
Return

;;∙───────∙
SendWeek:
    FormatTime, WeekNow,, YWeek
    WeekNum := SubStr(WeekNow, 5) + 0
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput Week %WeekNum%
    Gui, Hide
Return

;;∙───────∙
SendWeekdayNum:
    FormatTime, Weekday,, WDay
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput Weekday %Weekday%
    Gui, Hide
Return

;;∙───────∙
SendMonthName:
    FormatTime, MonthName,, MMMM    ;;∙------∙Full month name (e.g., April).
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput %MonthName%
    Gui, Hide
Return

;;∙───────∙
SendMonthNum:
    FormatTime, MonthNum,, M
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput Month %MonthNum%
    Gui, Hide
Return

;;∙───────∙
SendYear:
    FormatTime, YearOnly,, yyyy
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput %YearOnly%
    Gui, Hide
Return

;;∙───────∙
SendDayOfYear:
    FormatTime, DayOfYear,, YDay
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput Day %DayOfYear% 
    Gui, Hide
Return

;;∙───────∙
SendDOYRemaining:
    FormatTime, Y,, yyyy
    FormatTime, DOY,, YDay
    TotalDays := (Mod(Y, 400) = 0 or (Mod(Y, 4) = 0 and Mod(Y, 100) != 0)) ? 366 : 365
    Left := TotalDays - DOY
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput %Left% days left this year
    Gui, Hide
Return

;;∙───────∙
SendRelativeDate:
    InputBox, DaysOffset, Date Offset, Enter days to add or subtract from now.`nExample: +7 or -3, , 270, 150
    if ErrorLevel
        return
    NewDate := A_Now
    NewDate += DaysOffset, Days
    FormatTime, FormattedDate, %NewDate%, MMM/dd/yyyy
    WinActivate, ahk_id %LastTargetWin%
    SendInput %FormattedDate%
    Gui, Hide
Return

;;∙───────∙
SendBusinessDays:
    InputBox, TargetDate, Business Days, Enter end date (YYYYMMDD),, 300, 150
    if ErrorLevel
        return
    ;;∙------∙Validate input format.
    if (StrLen(TargetDate) != 8 || TargetDate is not integer) {
        MsgBox, Invalid date format. Use YYYYMMDD.
        return
    }
    ;;∙------∙Normalize dates to YYYYMMDD format (no time).
    StartDate := SubStr(A_Now, 1, 8)  ; Extract date part (e.g., "20231010")
    EndDate := TargetDate
    ;;∙------∙Check if EndDate is valid and not in the past.
    if (EndDate < StartDate) {
        MsgBox, End date must be today or a future date.
        return
    }
    Days := 0
    CurrentDate := StartDate
    Loop {
        ;;∙------∙Break if we've passed the end date.
        if (CurrentDate > EndDate)
            break
        ;;∙------∙Check if the day is a weekday (1 = Sunday, 7 = Saturday).
        FormatTime, WDay, %CurrentDate%000000, WDay
        if (WDay != 1 && WDay != 7)
            Days++
        ;;∙------∙Move to the next day.
        CurrentDate += 1, Days
        CurrentDate := SubStr(CurrentDate, 1, 8)  ; Keep format as YYYYMMDD
    }
    WinActivate, ahk_id %LastTargetWin%
    SendInput %Days% business days
    Gui, Hide
Return

;;∙───────∙

SendTimeToTarget:
    InputBox, TargetHour, Target Time, Enter target hour (24h format):,, 300, 150
    if ErrorLevel
        return
    ;;∙------∙Calculate time until target.
    FormatTime, CurrentTime,, HHmm
    TargetTime := TargetHour . "00"
    if (TargetTime < CurrentTime) {
        ;;∙------∙Target is tomorrow.
        TargetDate := A_Now
        TargetDate += 1, Days
        TargetDate := SubStr(TargetDate, 1, 8) . TargetHour . "00"
    } else {
        TargetDate := SubStr(A_Now, 1, 8) . TargetHour . "00"
    }
    EnvSub, Diff, %TargetDate%, Minutes
    Hours := Diff // 60
    Minutes := Mod(Diff, 60)
        WinActivate, ahk_id %LastTargetWin%
    SendInput %Hours%h %Minutes%m until %TargetHour%00
    Gui, Hide
Return

;;∙────────∙Functions Column 3∙────────────────────∙
SendQuarter:
    FormatTime, M,, M
    Q := Ceil(M / 3)
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput Q%Q%
    Gui, Hide
Return

;;∙───────∙
SendQuarter2:
    FormatTime, M,, M
    FormatTime, Y,, yyyy
    Q := Ceil(M / 3)
    Out := Y "-Q" Q
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput %Out%
    Gui, Hide
Return

;;∙───────∙
;;∙------∙Add this variable at the top of your script!!!∙------------∙
    FiscalStart := 4    ;;<∙------∙April (change to 1 for January, 9 for September, etc.)

SendDynamicFiscalQuarter:
    FormatTime, M,, M
    FormatTime, Y,, yyyy
    if (M < FiscalStart) {    ;;∙------∙Year adjustment logic.
        Y -= 1
    }
    OffsetMonth := Mod(M - FiscalStart + 12, 12)    ;;∙------∙Calculate quarter dynamically.
    Q := Ceil((OffsetMonth + 1) / 3)
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput %Y%-Q%Q%
    Gui, Hide
Return

;;∙───────∙
SendPreviousQuarter:
    FormatTime, M,, M
    FormatTime, Y,, yyyy
    ;;∙------∙Calculate previous quarter.
    PrevQ := Ceil(M / 3) - 1
    if (PrevQ = 0) {
        PrevQ := 4
        Y -= 1
    }
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput Q%PrevQ%-%Y%
    Gui, Hide
Return

;;∙───────∙
SendUTC:
    EnvSub, UtcNow, A_NowUTC, Seconds
    FormatTime, UOut, %UtcNow%, yyyy-MM-ddTHH:mm:ss
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput %UOut% 
    Gui, Hide
Return

;;∙───────∙
SendUnix:
    EnvSub, UnixNow, 19700101000000, Seconds
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput %UnixNow% 
    Gui, Hide
Return

;;∙───────∙
SendUnixMilliseconds:
    FormatTime, Now,, yyyyMMddHHmmss
    EnvSub, Now, 19700101000000, ms
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput %Now%
    Gui, Hide
Return

;;∙───────∙
SendJulian:
    FormatTime, Y,, yyyy
    FormatTime, D,, YDay
    Out := Y SubStr("000" D, -2)    ;;∙------∙Pads to always 3 digits.
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput %Out%
    Gui, Hide
Return

;;∙───────∙
SendOrdinalDate:
    FormatTime, OD,, yyyy
    FormatTime, DOY,, YDay
    Out := OD "-" SubStr("000" DOY, -2)
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput %Out%
    Gui, Hide
Return

;;∙───────∙
SendRomanDate:
    FormatTime, Day,, d
    FormatTime, Month,, M
    FormatTime, Year,, yyyy
    ;;∙------∙Convert all components to Roman numerals.
    RomanDay := ToRoman(Day)
    RomanMonth := ToRoman(Month)
    RomanYear := ToRoman(Year)
    WinActivate, ahk_id %LastTargetWin%
    SendInput %RomanDay%-%RomanMonth%-%RomanYear%
    Gui, Hide
return

ToRoman(num) {    ;;∙------∙Convert Arabic numbers to Roman numerals.
    static romanMap := [[1000, "M"], [900, "CM"], [500, "D"], [400, "CD"], [100, "C"]
        , [90, "XC"], [50, "L"], [40, "XL"], [10, "X"], [9, "IX"], [5, "V"], [4, "IV"], [1, "I"]]
    roman := ""
    for _, pair in romanMap {
        while (num >= pair[1]) {
            roman .= pair[2]
            num -= pair[1]
        }
    }
    return roman
}
Return

;;∙───────∙
SendWorkweekProgress:
    FormatTime, WDay,, WDay
    FormatTime, Hours,, H
    FormatTime, Minutes,, m
    if (WDay = 1 || WDay = 7) {    ;;∙------∙Weekend.
        Progress := 100
    } else {
        TotalMinutes := (WDay-2)*1440 + Hours*60 + Minutes    ;;∙------∙Monday=0.
        Progress := Round((TotalMinutes / (5*1440)) * 100, 1)
    }
    Bar := "||||||||||||||||||||"
    Length := Round(Progress/5)
    ;;∙------∙Build the progress bar string first.
    BarDisplay := "[" . SubStr(Bar, 1, Length) . SubStr("                    ", 1, 20-Length) . "] " . Progress . "%"
    WinActivate, ahk_id %LastTargetWin%
    SendInput % BarDisplay    ;;∙------∙Send the pre-built string.
    Gui, Hide
Return

;;∙───────∙

SendYearProgress:
    FormatTime, DOY,, YDay
    FormatTime, Year,, yyyy
    Progress := Round((DOY / 365) * 100, 1)
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput It is %Progress%`% into %Year%.
    Gui, Hide
Return

;;∙────────∙Functions Column 4∙────────────────────∙
SendCustomNamed:    ;;∙------∙Customize Your Own.
    FormatTime, Out,, dddd, MMMM dd yyyy - h:mm tt
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput %Out%
    Gui, Hide
Return

;;∙───────∙
SendFileStamp:
    FormatTime, Stamp,, yyyy-MM-dd_HH-mm-ss
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput %Stamp% 
    Gui, Hide
Return

;;∙───────∙
SendLocalTZ:
    TZ := GetTimeZoneAbbreviation()
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput %TZ%
    Gui, Hide
Return

;;∙------∙ Gets the local time zone abbreviation like EST, PDT, etc.
GetTimeZoneAbbreviation() {
    tzMap := Object("Hawaiian Standard Time", "HST"
           , "Alaskan Standard Time", "AKST"
           , "Pacific Standard Time", "PST"
           , "Mountain Standard Time",  "MST"
           , "Central Standard Time", "CST"
           , "Eastern Standard Time", "EST"
           , "Atlantic Standard Time",  "AST"
           , "Newfoundland Standard Time", "NST"
           , "Greenwich Standard Time", "GMT"
           , "UTC", "UTC"    )
    for tz in ComObjGet("winmgmts:\\.\root\cimv2").ExecQuery("SELECT * FROM Win32_TimeZone") {
        fullName := tz.StandardName
        break
    }
    abbr := tzMap.HasKey(fullName) ? tzMap[fullName] : fullName
    return abbr
}
Return

;;∙───────∙
SendLeapCheck:
    FormatTime, Y,, yyyy
    IsLeap := (Mod(Y, 400) = 0 or (Mod(Y, 4) = 0 and Mod(Y, 100) != 0)) ? "Leap Year" : "Not a Leap Year"
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput %IsLeap%
    Gui, Hide
Return

;;∙───────∙
SendNextLeapDay:
    FormatTime, Y,, yyyy
    NextLeap := Y
    Loop {
        NextLeap++
        if (Mod(NextLeap, 400) = 0 or (Mod(NextLeap, 4) = 0 and Mod(NextLeap, 100) != 0))
            Break
    }
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput Next Leap Day: Feb 29, %NextLeap%
    Gui, Hide
Return

;;∙───────∙
SendMoonPhase:
    ;;∙------∙Get precise Julian Date
    Now := A_NowUTC
    FormatTime, Y,, yyyy
    FormatTime, M,, MM
    FormatTime, D,, dd
    FormatTime, H,, HH
    FormatTime, Min,, mm
    FormatTime, S,, ss
    ;;∙------∙Convert to Julian Date (UTC)
    a := (14 - M) // 12
    y := Y + 4800 - a
    m := M + 12*a - 3
    JDN := D + (153*m + 2) // 5 + 365*y + y//4 - y//100 + y//400 - 32045
    JD := JDN + (H-12)/24 + Min/1440 + S/86400
    ;;∙------∙Lunar phase calculation (0-1 where 0=New Moon)
    Phase := (JD - 2451550.1) / 29.530588853
    Phase -= Floor(Phase)
    Cycle := Phase * 29.530588853
    ;;∙------∙Detailed phase names with astronomical alignment
    Phase := (Cycle < 1.845) ? "New Moon"
           : (Cycle < 5.535) ? "Waxing Crescent"
           : (Cycle < 9.225) ? "First Quarter"
           : (Cycle < 12.915) ? "Waxing Gibbous"
           : (Cycle < 16.605) ? "Full Moon"
           : (Cycle < 20.295) ? "Waning Gibbous"
           : (Cycle < 23.985) ? "Last Quarter"
           : (Cycle < 27.675) ? "Waning Crescent"
           : "New Moon"
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput Moon Phase: %Phase%
    Gui, Hide
Return

;;∙───────∙
SendDOSTimestamp:
    FormatTime, DTS,, yyyyMMdd_HHmmss
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput %DTS%
    Gui, Hide
Return

;;∙───────∙
SendRFC2822:
    FormatTime, RFC,, ddd, dd MMM yyyy HH:mm:ss
    UTC := A_NowUTC
    Local := A_Now
    EnvSub, Local, UTC, Minutes    ;;∙------∙Calculate offset in minutes.
    sign := (Local >= 0) ? "+" : "-"
    absOffset := Abs(Local)
    hours := Floor(absOffset / 60)
    minutes := Mod(absOffset, 60)
    FormatTime, tzOffset,, % sign . Format("{:02}{:02}", hours, minutes)
    RFC := RFC . " " . tzOffset   ;;∙------∙Combine the date with timezone offset.
    WinActivate, ahk_id %LastTargetWin%
    Sleep 150
    SendInput %RFC%
    Gui, Hide
Return

;;∙───────∙
SendHolidayCountdown:
    holidayList := []
    ;;∙------∙Fixed-date holidays.
    fixedHolidays := []
    fixedHolidays.Push([1, 1, "New Year's Day"])
    fixedHolidays.Push([2, 14, "Valentine's Day"])
    fixedHolidays.Push([7, 4, "Independence Day"])
    fixedHolidays.Push([10, 31, "Halloween"])
    fixedHolidays.Push([12, 25, "Christmas Day"])
    fixedHolidays.Push([12, 31, "New Year's Eve"])
    ;;∙------∙Movable holidays.
    movableHolidays := []
    movableHolidays.Push({name: "Martin Luther King Jr. Day", func: Func("ThirdMonday").Bind(1)})
    movableHolidays.Push({name: "Presidents' Day", func: Func("ThirdMonday").Bind(2)})
    movableHolidays.Push({name: "Memorial Day", func: Func("LastMonday").Bind(5)})
    movableHolidays.Push({name: "Labor Day", func: Func("FirstMonday").Bind(9)})
    movableHolidays.Push({name: "Thanksgiving", func: Func("FourthThursday").Bind(11)})
    movableHolidays.Push({name: "Easter", func: Func("CalculateEaster")})
    ;;∙------∙Calculate dates.
    for _, holiday in fixedHolidays {
        month := holiday[1], day := holiday[2], name := holiday[3]
        nextDate := CalculateNextFixedHoliday(month, day)
        holidayList.Push({date: nextDate, name: name})
    }
    for _, holiday in movableHolidays {
        nextDate := holiday.func.Call()
        holidayList.Push({date: nextDate, name: holiday.name})
    }
    ;;∙------∙Sort and filter.
    holidayList := SortHolidaysByDate(holidayList)
    ;;∙------∙Format output.
    output := "    Upcoming Holidays:`n`n"
    FormatTime, currentDate,, yyyyMMdd  ; Today's date in YYYYMMDD format
    Loop % holidayList.MaxIndex() {
        if (A_Index > 5)
            break
        holiday := holidayList[A_Index]
        daysRemaining := holiday.date
        EnvSub, daysRemaining, %currentDate%, Days    ;;∙------∙Subtract current date from holiday date.
        FormatTime, formattedDate, % holiday.date, MMM d
        output .= formattedDate "`t - " daysRemaining " days  (" holiday.name ")`n"
    }
    ;;∙------∙Display in GUI
    Gui, Destroy
    Clipboard = %output%
    Gui, Add, Edit, w250 h200 ReadOnly, %output%
    Gui, Show,, Holiday Countdown
return

;;∙------∙Helper Functions
CalculateNextFixedHoliday(month, day) {
    FormatTime, currentYear,, yyyy
    FormatTime, currentDate,, yyyyMMdd
    candidate := currentYear . SubStr("0" month, -1) . SubStr("0" day, -1)
    if (candidate >= currentDate)
        return candidate
    return (currentYear + 1) . SubStr("0" month, -1) . SubStr("0" day, -1)
}
ThirdMonday(month) {
    year := SubStr(A_Now, 1, 4)
    firstDay := year . SubStr("0" month, -1) . "01"
    FormatTime, wday, %firstDay%, WDay
    ;;∙------∙Calculate first Monday.
    if (wday = 1)    ;;∙------∙Sunday.
        firstMonday := 2
    else if (wday = 2)    ;;∙------∙Monday.
        firstMonday := 1
    else
        firstMonday := 9 - wday
    thirdMonday := firstMonday + 14
    candidate := year . SubStr("0" month, -1) . SubStr("0" thirdMonday, -1)
    FormatTime, currentDate,, yyyyMMdd
    if (candidate >= currentDate)
        return candidate
    ;;∙------∙Next year.
    year += 1
    firstDay := year . SubStr("0" month, -1) . "01"
    FormatTime, wday, %firstDay%, WDay
    if (wday = 1)
        firstMonday := 2
    else if (wday = 2)
        firstMonday := 1
    else
        firstMonday := 9 - wday
    thirdMonday := firstMonday + 14
    return year . SubStr("0" month, -1) . SubStr("0" thirdMonday, -1)
}
LastMonday(month) {
    year := SubStr(A_Now, 1, 4)
    lastDay := year . SubStr("0" month, -1) . "01"
    EnvAdd, lastDay, 31, Days    ;;∙------∙Move to next month.
    EnvAdd, lastDay, -1, Days    ;;∙------∙Last day of target month.
    Loop {
        FormatTime, wday, %lastDay%, WDay
        if (wday = 2)    ;;∙------∙Monday.
            break
        EnvAdd, lastDay, -1, Days
    }
    FormatTime, currentDate,, yyyyMMdd
    if (lastDay >= currentDate)
        return lastDay
    ;;∙------∙Next year.
    year += 1
    lastDay := year . SubStr("0" month, -1) . "01"
    EnvAdd, lastDay, 31, Days
    EnvAdd, lastDay, -1, Days
    Loop {
        FormatTime, wday, %lastDay%, WDay
        if (wday = 2)
            break
        EnvAdd, lastDay, -1, Days
    }
    return lastDay
}
FourthThursday(month) {
    year := SubStr(A_Now, 1, 4)
    firstDay := year . SubStr("0" month, -1) . "01"
    thursdays := 0
    Loop 31 {
        FormatTime, wday, %firstDay%, WDay
        if (wday = 5) {    ;;∙------∙Thursday.
            thursdays += 1
            if (thursdays = 4) {
                FormatTime, currentDate,, yyyyMMdd
                if (firstDay >= currentDate)
                    return firstDay
                else
                    break
            }
        }
        EnvAdd, firstDay, 1, Days
    }
    ;;∙------∙Next year.
    year += 1
    firstDay := year . SubStr("0" month, -1) . "01"
    thursdays := 0
    Loop 31 {
        FormatTime, wday, %firstDay%, WDay
        if (wday = 5) {
            thursdays += 1
            if (thursdays = 4)
                return firstDay
        }
        EnvAdd, firstDay, 1, Days
    }
}
CalculateEaster() {
    year := SubStr(A_Now, 1, 4)
    a := Mod(year, 19)
    b := year // 100
    c := Mod(year, 100)
    d := b // 4
    e := Mod(b, 4)
    f := (b + 8) // 25
    g := (b - f + 1) // 3
    h := Mod(19*a + b - d - g + 15, 30)
    i := c // 4
    k := Mod(c, 4)
    l := Mod(32 + 2*e + 2*i - h - k, 7)
    m := (a + 11*h + 22*l) // 451
    month := (h + l - 7*m + 114) // 31
    day := ((h + l - 7*m + 114) Mod 31) + 1
    easterDate := year . SubStr("0" month, -1) . SubStr("0" day, -1)
    FormatTime, currentDate,, yyyyMMdd
    if (easterDate >= currentDate)
        return easterDate
    ;;∙------∙Next year.
    year += 1
    a := Mod(year, 19)
    b := year // 100
    c := Mod(year, 100)
    d := b // 4
    e := Mod(b, 4)
    f := (b + 8) // 25
    g := (b - f + 1) // 3
    h := Mod(19*a + b - d - g + 15, 30)
    i := c // 4
    k := Mod(c, 4)
    l := Mod(32 + 2*e + 2*i - h - k, 7)
    m := (a + 11*h + 22*l) // 451
    month := (h + l - 7*m + 114) // 31
    day := ((h + l - 7*m + 114) Mod 31) + 1
    return year . SubStr("0" month, -1) . SubStr("0" day, -1)
}
SortHolidaysByDate(holidays) {
    filtered := []
    FormatTime, currentDate,, yyyyMMdd
    for _, holiday in holidays {
        if (holiday.date >= currentDate)
            filtered.Push(holiday)
    }
    filtered.Sort(CompareDates)
    return filtered
}
CompareDates(a, b) {
    ;;∙------∙Treat dates as integers for numerical comparison.
    aDate := a.date + 0
    bDate := b.date + 0
    return aDate > bDate ? 1 : -1
}
Return

;;∙───────∙
SendMetSeason:
    FormatTime, Month,, M
    Season := (Month >= 3 && Month <= 5) ? "Spring"
            : (Month >= 6 && Month <= 8) ? "Summer"
            : (Month >= 9 && Month <= 11) ? "Autumn"
            : "Winter"
    WinActivate, ahk_id %LastTargetWin%
    SendInput %Season% (Meteorological)
    Gui, Hide
Return

;;∙───────∙
SendZodiacSign:
    zodiac := [[120, "Capricorn"], [219, "Aquarius"], [320, "Pisces"], [420, "Aries"]
             , [521, "Taurus"], [621, "Gemini"], [722, "Cancer"], [823, "Leo"]
             , [923, "Virgo"], [1023, "Libra"], [1122, "Scorpio"], [1222, "Sagittarius"]
             , [1231, "Capricorn"]]
    FormatTime, MD,, MMdd
    MD += 0
    for i, subArray in zodiac    ;;∙------∙Only TWO variables allowed: index + sub-array.
    {
        date := subArray[1]    ;;∙------∙First element of sub-array (e.g., 120).
        sign := subArray[2]    ;;∙------∙Second element of sub-array (e.g., "Capricorn").
        if (MD <= date)
            break
    }
    WinActivate, ahk_id %LastTargetWin%
    SendInput, Current zodiak sign is: %sign%
    Sleep, 100
    Gui, Hide
Return

;;∙───────∙
HideGUISection:
    Gui, Hide
Return

;;∙────────────────────────────────────────────∙
;;∙────────∙FUNCTIONS∙──────────────────────────∙
;;∙────────────────────────────────────────────∙
/*∙-----------∙Positioning Function (dual monitor setup)∙------------∙
∙----∙Original Author:  Learning one
∙----∙https://www.autohotkey.com/board/topic/72630-gui-bottom-right/#entry461385
Positioning based on (x,y) cartesian coordinates for maintainability and clarity.
(L, HC, R / U, VC, D) called with∙----> WinMove(GuiHwnd, "D R", 1)
∙────────────────────∙
» Horizontal
L     ▹Left
HC  ▹Horizontal-Center
R     ▹Right
∙──────────────∙
» Vertical
U    ▹ Up
VC  ▹ Vertical-Center
D    ▹ Down
∙────────────────────∙
*/

WinMove(hwnd, position, monitor) {
    SysGet, Mon, MonitorWorkArea
    SysGet, Mon2, MonitorWorkArea, 2

    if (monitor = 2) {    ;;∙------∙Monitor fallback.
        SysGet, MonitorCount, MonitorCount
        if (MonitorCount < 2) {
            monitor := 1    ;;∙------∙Fallback to primary monitor if secondary not detected.
        }
    }

    oldDHW := A_DetectHiddenWindows
    DetectHiddenWindows, On
    WinGetPos, ix, iy, w, h, ahk_id %hwnd%
    StringReplace, position, position, b, d, all
    if (monitor = 1) {
        x := InStr(position, "l") ? MonLeft : InStr(position, "hc") ? ((MonRight - w) / 2) : InStr(position, "r") ? MonRight - w - xOffset : ix
        y := InStr(position, "u") ? MonTop : InStr(position, "vc") ? ((MonBottom - h) / 2) : InStr(position, "d") ? MonBottom - h - yOffset : iy
    } else if (monitor = 2) {
        x := InStr(position, "l") ? Mon2Left : InStr(position, "hc") ? ((Mon2Right - Mon2Left - w) / 2) + Mon2Left : InStr(position, "r") ? Mon2Right - w - xOffset : ix + Mon2Right
        y := InStr(position, "u") ? Mon2Top : InStr(position, "vc") ? ((Mon2Top + Mon2Bottom - h) / 2) - Mon2Top : InStr(position, "d") ? Mon2Bottom - h - yOffset : iy + Mon2Top
    }
    WinMove, ahk_id %hwnd%,, x, y
    DetectHiddenWindows, %oldDHW%
}
Return


;;∙-----------∙GuiTip Function∙----------------------------------------------∙
;;∙----∙Original Author:  Coco
;;∙----∙https://www.autohotkey.com/boards/viewtopic.php?t=6436#p38487
GuiTip(hCtrl, text:="")
{
    ttMaxWidth := 200    ;;∙------∙Sets maximum tooltip width in pixels. (0 = no maximum limit)
    hGui := text!="" ? DlLCall("GetParent", "Ptr", hCtrl) : hCtrl
    static hTip
    if !hTip
    {
        hTip := DllCall("CreateWindowEx", "UInt", 0x8, "Str", "tooltips_class32"
             ,  "Ptr", 0, "UInt", 0x80000002   ;;∙------∙(((WS_POPUP:=0x80000000|TTS_NOPREFIX:=0x02)))
             ,  "Int", 0x80000000, "Int",  0x80000000, "Int", 0x80000000, "Int", 0x80000000
             ,  "Ptr", hGui, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Ptr")
        DllCall("SendMessage", "Ptr", hTip, "Int", 0x0418, "Ptr", 0, "Ptr", ttMaxWidth)
        if (A_OsVersion == "WIN_XP")
            GuiTip(hGui)
    }
    static sizeof_TOOLINFO := 24 + (6 * A_PtrSize)
    VarSetCapacity(TOOLINFO, sizeof_TOOLINFO, 0)
    , NumPut(sizeof_TOOLINFO, TOOLINFO, 0, "UInt")
    , NumPut(0x11, TOOLINFO, 4, "UInt")   ;;∙------∙(((TTF_IDISHWND:=0x0001|TTF_SUBCLASS:=0x0010)))
    , NumPut(hGui, TOOLINFO, 8, "Ptr")
    , NumPut(hCtrl, TOOLINFO, 8 + A_PtrSize, "Ptr")
    , NumPut(&text, TOOLINFO, 24 + (3 * A_PtrSize), "Ptr")
    static TTM_ADDTOOL := A_IsUnicode ? 0x0432 : 0x0404
    return DllCall("SendMessage", "Ptr", hTip, "Int", TTM_ADDTOOL, "Ptr", 0, "Ptr", &TOOLINFO)
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

