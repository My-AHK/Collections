
;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙

;;∙=============================================∙
;;∙======∙DIRECTIVES & SETTINGS∙=================∙
#NoEnv
#SingleInstance force
#Persistent
SetBatchLines, -1
ScriptID := "Just_A_Calendar"
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")
SetWorkingDir, %A_ScriptDir%

SetTimer, UpdateCheck, 750
Menu, Tray, Icon, shell32.dll, 252
GoSub, TrayMenu

;;∙------∙Global Variables.
global current_year, current_month, today, ini_file
global DayDate := Object()    ;;∙------∙Array to store dates for each day control.
global calendar_font, calendar_font_size, calendar_number_color, calendar_today_color, calendar_asterisk_color
global calendar_box_color, calendar_bars_color, calendar_grid_color, calendar_today_font_style

;;∙=============================================∙
;;∙======∙CREATE GUI∙============================∙
CreateCalendar:
    ;;∙------∙User-defined Variables.
    ;;∙------∙Extensive Color Table & Hex Code (6-digit hex or with 0x prefix) Support.
    
    calendar_bg_color := "Black"           ;;∙------∙Calendar background.
    calendar_day_color := "Aqua"           ;;∙------∙Day labels (Sun, Mon, etc.).
    calendar_number_color := "Lime"        ;;∙------∙Regular day numbers.
    calendar_today_color := "Red"          ;;∙------∙Today's number color.
    calendar_today_font_style := "Italic Underline"    ;;∙------∙Options: "Norm", "Bold", "Italic", "Underline", or combinations.
    calendar_asterisk_color := "Yellow"    ;;∙------∙Asterisk color for notes.
    calendar_box_color := "Salmon"        ;;∙------∙Outer border color.
    calendar_bars_color := "Yellow"        ;;∙------∙Header separator bar color.
    calendar_grid_color := "Aqua"          ;;∙------∙Grid line color.
    calendar_header_color := "Blue"        ;;∙------∙Month/Year header color.

    calendar_font := "Segoe UI"            ;;∙------∙Font family.
    calendar_font_size := 12               ;;∙------∙Font size.
    note_text_color := "Blue"             ;;∙------∙Note editor text color.
    note_font_size := 10                   ;;∙------∙Note editor font size.
    note_bg_color := "Black"               ;;∙------∙Note editor background.
    note_label_color := "Aqua"             ;;∙------∙Note editor label color.

    ini_file := A_ScriptDir "\Calendar_Notes.ini"

    ;;∙------∙Verify System Date/Time On Startup (on first run).
    if (current_year = "")
    {
        current_date := A_YYYY A_MM A_DD
        FormatTime, current_day, %current_date%, d
        FormatTime, current_month_name, %current_date%, MMMM
        FormatTime, current_year, %current_date%, yyyy
        today := A_DD + 0
        current_month := A_MM
        current_year := A_YYYY
    }

    ;;∙------∙Destroy any existing calendar GUI before creating new one.
    Gui, Calendar:Destroy
    Gui, Calendar:New, +AlwaysOnTop -Caption +ToolWindow
    Gui, Calendar:Color, % Color(calendar_bg_color, "GUI0x")

    ;;∙------∙Get Current Month Name For Header.
    month_date := current_year . SubStr("0" . current_month, -1) . "01"
    FormatTime, current_month_name, %month_date%, MMMM

    ;;∙------∙Show Month & Year Header.
    headerColorHex := Color(calendar_header_color, "GUI0x")
    Gui, Calendar:Font, c%headerColorHex% s%calendar_font_size% Bold, %calendar_font%
    calendar_month_header := current_month_name " " current_year
    Gui, Calendar:Add, Text, x80 y25 w250 h25 vHeaderText, %calendar_month_header%

    ;;∙------∙Navigation Arrows With Click Handlers.
    ;;∙------∙Note: Picture controls don't support custom colors easily, using default icons.
    Gui, Calendar:Add, Picture, x215 y28 w16 h16 Icon247 gPrevMonth, shell32.dll    ;;∙------∙Up Arrow (previous month).
    Gui, Calendar:Add, Picture, x+5 y28 w16 h16 Icon246 gCurrentMonth, shell32.dll  ;;∙------∙Home (current month).
    Gui, Calendar:Add, Picture, x+5 y28 w16 h16 Icon248 gNextMonth, shell32.dll    ;;∙------∙Down Arrow (next month).
    Gui, Calendar:Add, Picture, x+10 y28 w16 h16 Icon132 gEXIT, shell32.dll    ;;∙------∙Script Exit.

    ;;∙------∙Day Labels.
    dayColorHex := Color(calendar_day_color, "GUI0x")
    Gui, Calendar:Font, c%dayColorHex% s%calendar_font_size% Norm, %calendar_font%
    day_names := "Sun,Mon,Tue,Wed,Thu,Fri,Sat"
    Loop, Parse, day_names, `,
    {
        x := 20 + ((A_Index - 1) * 40)
        Gui, Calendar:Add, Text, x%x% y55 w40 Center, %A_LoopField%
    }

    ;;∙------∙Find Which Day Of Week Month Starts On.
    start_date := current_year . SubStr("0" . current_month, -1) . "01"
    FormatTime, start_dow, %start_date%, WDay
    start_dow := start_dow - 1

    ;;∙------∙Determine Number Of Days In Current Month.
    days_in_month := 31
    this_month := current_month + 0
    this_year := current_year + 0
    if (this_month = 4 or this_month = 6 or this_month = 9 or this_month = 11)
        days_in_month := 30
    else if (this_month = 2)
    {
        if (Mod(this_year, 4) = 0 && (Mod(this_year, 100) != 0 or Mod(this_year, 400) = 0))
            days_in_month := 29
        else
            days_in_month := 28
    }

    ;;∙------∙Cache Notes For This Month (read all notes once instead of 30+ times).
    ;;∙------∙Create An Object To Store Which Dates Have Notes.
    month_notes := Object()
    
    ;;∙------∙Build Date Strings For Entire Month & Check For Notes.
    Loop, %days_in_month%
    {
        day_num_padded := SubStr("0" . A_Index, -1)
        month_num_padded := SubStr("0" . current_month, -1)
        full_date_check := month_num_padded "-" day_num_padded "-" current_year
        IniRead, note_content, %ini_file%, Notes, %full_date_check%
        if (note_content != "ERROR" && note_content != "")
            month_notes[full_date_check] := true
    }

    ;;∙------∙Define Number Grid Dimensions.
    grid_left := 20
    grid_top := 85
    cell_width := 40
    cell_height := 40
    grid_width := 7 * cell_width
    grid_height := 6 * cell_height

    ;;∙------∙Add Day Number (buttons).
    row := 0
    Loop, %days_in_month%
    {
        col := Mod((A_Index - 1 + start_dow), 7)
        if (col = 0 && A_Index > 1)
            row++

        ;;∙------∙Center Text Control Within The Cell.
        x := grid_left + (col * cell_width) + 5
        y := grid_top + (row * cell_height) + 7
        
        ;;∙------∙Format Date.
        day_num := A_Index
        day_num_padded := SubStr("0" . day_num, -1)
        month_num_padded := SubStr("0" . current_month, -1)
        full_date := month_num_padded "-" day_num_padded "-" current_year

        ;;∙------∙Store Date In Global Array.
        DayDate[day_num] := full_date
        
        ;;∙------∙Check If Date Has Note (using cached data instead of reading INI each time).
        has_note_value := month_notes[full_date]
        
        ;;∙------∙Determine Color (today or normal).
        is_today := (day_num = today && current_month = A_MM && current_year = A_YYYY)
        number_color := is_today ? calendar_today_color : calendar_number_color
        numberColorHex := Color(number_color, "GUI0x")
        
        ;;∙------∙Determine Font Style (apply only to today).
        if (is_today)
            font_style := calendar_today_font_style
        else
            font_style := "Norm"
        
        ;;∙------∙Create Text Control With Day Number & Asterisk If Needed.
        if (has_note_value)
        {
            ;;∙------∙Create Two Text Controls: One For Number, One For Asterisk.
            Gui, Calendar:Font, c%numberColorHex% s%calendar_font_size% %font_style%, %calendar_font%
            Gui, Calendar:Add, Text, x%x% y%y% w20 h26 Center gDayClick vDay%day_num%, %day_num%
            
            asteriskColorHex := Color(calendar_asterisk_color, "GUI0x")
            Gui, Calendar:Font, c%asteriskColorHex% s%calendar_font_size% Norm, %calendar_font%
            Gui, Calendar:Add, Text, xp+18 y%y% w15 h26 BackgroundTrans gDayClick vAsterisk%day_num%, %A_Space%*
        }
        else
        {
            Gui, Calendar:Font, c%numberColorHex% s%calendar_font_size% %font_style%, %calendar_font%
            Gui, Calendar:Add, Text, x%x% y%y% w30 h26 Center gDayClick vDay%day_num%, %day_num%
        }
    }

    ;;∙------∙Draw Grid Lines.
    gridColorHex := Color(calendar_grid_color, "GUI")
    Loop, 5
    {
        line_y := grid_top + (A_Index * cell_height)
        barLine(grid_left, line_y, grid_width, 1, gridColorHex)
    }

    Loop, 6
    {
        line_x := grid_left + (A_Index * cell_width)
        barLine(line_x, grid_top, 1, grid_height, gridColorHex)
    }

    ;;∙------∙Draw Bars.
    barsColorHex := Color(calendar_bars_color, "GUI")
    barLine(20, 50, 280, 2, barsColorHex)
    barLine(20, 80, 280, 2, barsColorHex)

    ;;∙------∙Draw Box.
    boxColorHex := Color(calendar_box_color, "GUI")
    calendar_left := 15
    calendar_top := 20
    calendar_right := 305
    calendar_bottom := 330
    calendar_width := calendar_right - calendar_left
    calendar_height := calendar_bottom - calendar_top
    boxline(calendar_left, calendar_top, calendar_width, calendar_height, boxColorHex, boxColorHex, boxColorHex, boxColorHex, 2)

    ;;∙------∙Show GUI.
    Gui, Calendar:Show, w320 h350 x200 y200, Just A Calendar
Return

;;∙=============================================∙
;;∙======∙MONTH NAVIGATION∙====================∙
;;∙------∙Navigation Handlers.
PrevMonth:
    current_month -= 1
    if (current_month < 1)
    {
        current_month := 12
        current_year -= 1
    }
    GoSub, CreateCalendar
Return

CurrentMonth:
    current_month := A_MM
    current_year := A_YYYY
    GoSub, CreateCalendar
Return

NextMonth:
    current_month += 1
    if (current_month > 12)
    {
        current_month := 1
        current_year += 1
    }
    GoSub, CreateCalendar
Return

;;∙=============================================∙
;;∙======∙CREATE NOTE GUI∙=======================∙
;;∙------∙Single Click Handler For All Days.
DayClick:
    ;;∙------∙A_GuiControl Contains Variable Name Of Clicked Control (e.g., "Day18" or "Asterisk18").
    clicked_control := A_GuiControl
    
    ;;∙------∙Extract Day Number From Control Name.
    if (SubStr(clicked_control, 1, 8) = "Asterisk")
        StringTrimLeft, day_num, clicked_control, 8
    else
        StringTrimLeft, day_num, clicked_control, 3
    
    ;;∙------∙Get Full Date From Array.
    full_date := DayDate[day_num]
    
    if (full_date = "")
    {
        Tooltip, Error: Could not find date for day %day_num% (Control: %clicked_control%)
        SetTimer, RemoveTooltip, -1500
        return
    }
    
    ;;∙------∙Read Existing Note For Specific Date.
    IniRead, current_note, %ini_file%, Notes, %full_date%
    
    ;;∙------∙If No Note Exists, current_note Will Be "ERROR" - Treat As Empty.
    if (current_note = "ERROR")
        current_note := ""
    else
        ;;∙------∙Decode Note (convert [BR] back to line breaks).
        StringReplace, current_note, current_note, `%5B`%BR`%5D`%, `n, All
    
    ;;∙------∙Show Custom Multi-line Note Editor.
    noteBgHex := Color(note_bg_color, "GUI0x")
    noteLabelHex := Color(note_label_color, "GUI0x")
    noteTextHex := Color(note_text_color, "GUI0x")
    
    Gui, NoteEditor:Destroy
    Gui, NoteEditor:New, +AlwaysOnTop -Caption +Border +ToolWindow
    Gui, NoteEditor:Color, %noteBgHex%
    Gui, NoteEditor:Font, c%noteLabelHex% s%note_font_size%, %calendar_font%
    
    Gui, NoteEditor:Add, Text, x10 y10 w380 h20, Edit note for %full_date%:
    
    Gui, NoteEditor:Font, c%noteTextHex% s%note_font_size% Norm, %calendar_font%
    Gui, NoteEditor:Add, Edit, x10 y35 w380 h200 vNoteContent HScroll WantReturn gNoteEditorFocus, %current_note%
    
    Gui, NoteEditor:Font, c%noteTextHex% s%note_font_size% Bold, %calendar_font%
    Gui, NoteEditor:Add, Button, x100 y250 w100 h30 gSaveNote Default, Save
    Gui, NoteEditor:Add, Button, x+10 y250 w100 h30 gCancelNote, Cancel
    
    ;;∙------∙Store full_date For Use In SaveNote.
    Gui, NoteEditor:Add, Text, x0 y0 Hidden vFullDate, %full_date%
    
    Gui, NoteEditor:Show, w400 h300, Note Editor
    
    ;;∙------∙Set Focus To Edit Control & Move Caret To End.
    GuiControl, NoteEditor:Focus, NoteContent
    SendMessage, EM_SETSEL := 0xB1, -1, -1, Edit1, Note Editor
Return

NoteEditorFocus:
    ;;∙------∙Move Caret To End Of Text (triggered when edit control gains focus).
    SendMessage, EM_SETSEL := 0xB1, -1, -1, Edit1, Note Editor
Return

SaveNote:
    Gui, NoteEditor:Submit, NoHide
    user_input := NoteContent
    GuiControlGet, saved_date, NoteEditor:, FullDate
    
    ;;∙------∙Encode Note (convert line breaks to [BR] for INI storage).
    StringReplace, user_input, user_input, `n, `%5B`%BR`%5D`%, All
    
    ;;∙------∙Save Note To The INI File Under This Date.
    if (user_input = "")
    {
        ;;∙------∙If User Input Empty, Delete Note.
        IniDelete, %ini_file%, Notes, %saved_date%
    }
    else
    {
        ;;∙------∙Save Encoded Note.
        IniWrite, %user_input%, %ini_file%, Notes, %saved_date%
    }
    
    ;;∙------∙Store Date For Tooltip Before Destroying GUI.
    tooltip_date := saved_date
    
    ;;∙------∙Close Note Editor.
    Gui, NoteEditor:Destroy
    
    ;;∙------∙Refresh Calendar To Show/hide Asterisk Properly.
    GoSub, CreateCalendar
    
    ;;∙------∙Show Tooltip With Confirmation Using Stored Date.
    Tooltip, Note saved for %tooltip_date%
    SetTimer, RemoveTooltip, -2000
Return
;;∙------------------------∙
CancelNote:
    Gui, NoteEditor:Destroy
Return
;;∙------------------------∙
RemoveTooltip:
    Tooltip
Return
;;∙------------------------∙
GuiClose:
GuiEscape:
    ExitApp
Return

;;∙=============================================∙
;;∙======∙COLOR CONVERTER∙=====================∙
Color(ColorName, Format := "GUI") {
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
    else    ;;∙------∙GUI0x format (with 0x prefix).
        return "0x" . hex
}

;;∙=============================================∙
;;∙======∙BOX & BAR ROUTINES∙===================∙
boxline(X, Y, W, H, ColorTop := "Black", ColorBottom := "Black", ColorLeft := "Black", ColorRight := "Black", Thickness := 1)
{	
    BottomY := Y + H - Thickness
    RightX := X + W - Thickness
    
    Gui, Calendar:Add, Progress, x%X% y%Y% w%W% h%Thickness% Background%ColorTop%
    Gui, Calendar:Add, Progress, x%X% y%BottomY% w%W% h%Thickness% Background%ColorBottom%
    Gui, Calendar:Add, Progress, x%X% y%Y% w%Thickness% h%H% Background%ColorLeft%
    Gui, Calendar:Add, Progress, x%RightX% y%Y% w%Thickness% h%H% Background%ColorRight%
}

barLine(X, Y, W, H, Color1 := "Black") 
{
    Gui, Calendar:Add, Progress, x%X% y%Y% w%W% h%H% Background%Color1%
}

;;∙=============================================∙
;;∙======∙GUI DRAG∙=============================∙
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}
Return

;;∙=============================================∙
;;∙======∙TRAY MENU∙============================∙
TrayMenu:
Menu, Tray, Tip, %ScriptID%
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Suspend / Pause, Just_A_Calendar
Menu, Tray, Icon, Suspend / Pause, shell32, 28
Menu, Tray, Default, Suspend / Pause
;;∙------∙Extentions.
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
;;∙------∙Options.
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

;;∙=============================================∙
;;∙======∙MENU EXTENSIONS∙=====================∙
Documentation:
    Run, "C:\Program Files\AutoHotkey\AutoHotkey.chm"
Return
;;∙------------------------∙
ShowKeyHistory:
    KeyHistory
Return
;;∙------------------------∙
ShowWindowSpy:
    Run, "C:\Program Files\AutoHotkey\WindowSpy.ahk"
Return
;;∙------------------------∙
Just_A_Calendar:
    Suspend
    Soundbeep, 700, 100
    Pause
Return

;;∙=============================================∙
;;∙======∙TRAY MENU POSITIONING∙===============∙
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20
Return
;;∙------------------------∙
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
return True
}
Return

;;∙=============================================∙
;;∙======∙RELOAD UPON SCRIPT SAVE∙==============∙
UpdateCheck:
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload

;;∙=============================================∙
;;∙======∙EDIT / RELOAD / EXIT∙====================∙
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
    EXIT:
        Soundbeep, 1000, 300
    ExitApp
Return
;;∙=============================================∙

;;∙========================∙SCRIPT END∙=========================∙
;;∙------------------------------------------------------------------------------------------∙