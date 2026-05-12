

;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙


;;∙=============================================∙
;;∙======∙DIRECTIVES & SETTINGS∙=================∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWinDelay, -1
ListLines, Off
SetWorkingDir, %A_ScriptDir%

OnMessage(0x0201, "WM_LBUTTONDOWNdrag")
ScriptID := "Task_Tracker"

Menu, Tray, Icon, imageres.dll, 46
GoSub, TrayMenu

;;∙=============================================∙
;;∙======∙VARIABLES & SETTINGS∙==================∙
guiX := 200
guiY := 200
guiW := 380
guiH := 555

;;∙------∙Color Scheme∙-------------------------∙
gui_Border_Color := "Magenta"
gui_Header_Color := "Aqua"
gui_Bg_Color := "Black"
gui_Divider_Color := "Rose"
gui_Task_Divider_Color := "Aqua"
gui_Filter_Color := "Yellow"
gui_Text_Color := "Blue"
gui_Label_Color := "Violet"
gui_Input_Bg := "1A1A2E"
gui_Add_Btn_Color := "Lime"
gui_Complete_Color := "Green"
gui_Scroll_Color := "Aqua"
gui_Delete_Color := "Red"
gui_Priority_High := "Red"
gui_Priority_Med := "Orange"
gui_Priority_Low := "Lime"
gui_Progress_Color := "Azure"
gui_Category_Color := "Cyan"
gui_ProgressBar_Length := 47
gui_ProgressFill_Color := "Lime"
gui_ProgressEmpty_Color := "Green"
gui_ProgressCap_Color := "Orange"

;;∙------∙Task Data Storage∙-------------------∙
global TaskList := []
global TaskFile := A_ScriptDir . "\tasks_data.txt"

;;∙------∙Filter State∙------------------------∙
global FilterMode := "All"
global TaskScrollOffset := 0

;;∙======∙STARTUP∙=============================∙
LoadTasks()
GoSub, BuildTaskGUI
SetTimer, UpdateCheck, 500
Return

;;∙=============================================∙
;;∙======∙COLOR CONVERTER∙=====================∙
Color(ColorName, Format := "GUI") {
    static colorMap := Object()
    if (colorMap.Count() = 0) {
        colorMap["Black"] := "000000"
        colorMap["Gray"] := "808080"
        colorMap["Silver"] := "C0C0C0"
        colorMap["White"] := "FFFFFF"
        colorMap["Maroon"] := "800000"
        colorMap["Red"] := "FF0000"
        colorMap["Magenta-Red"] := "FF0066"
        colorMap["Rose"] := "FF007F"
        colorMap["Salmon"] := "FA8072"
        colorMap["Light Salmon"] := "FFA07A"
        colorMap["Coral"] := "FF7F50"
        colorMap["Hot Pink"] := "FF69B4"
        colorMap["Deep Pink"] := "FF1493"
        colorMap["Rose Pink"] := "FF66CC"
        colorMap["Pink"] := "FF80FF"
        colorMap["Red-Orange"] := "FF3300"
        colorMap["Orange"] := "FF6600"
        colorMap["Yellow-Red"] := "FF6347"
        colorMap["Yellow-Orange"] := "FF8C00"
        colorMap["Yellow"] := "FFFF00"
        colorMap["Chartreuse"] := "DFFF00"
        colorMap["Olive"] := "808000"
        colorMap["Green"] := "008000"
        colorMap["Lime"] := "00FF00"
        colorMap["Spring Green"] := "00FF7F"
        colorMap["Cyan-Green"] := "00FA9A"
        colorMap["Teal"] := "008080"
        colorMap["Aqua"] := "00FFFF"
        colorMap["Azure"] := "007FFF"
        colorMap["Blue"] := "0000FF"
        colorMap["Navy"] := "000080"
        colorMap["Indigo"] := "8B00FF"
        colorMap["Violet"] := "7F00FF"
        colorMap["Purple"] := "800080"
        colorMap["Fuchsia"] := "FF00FF"
        colorMap["Magenta"] := "FF00FF"
        colorMap["Grey"] := colorMap["Gray"]
        colorMap["Cyan"] := colorMap["Aqua"]
        colorMap["1A1A2E"] := "1A1A2E"
        colorMap["2E2E42"] := "2E2E42"
    }
    ColorName := Trim(ColorName)

    if (RegExMatch(ColorName, "^(0x)?[0-9A-Fa-f]{6}$")) {
        hex := RegExReplace(ColorName, "^(0x)", "")
    } else {
        hex := colorMap[ColorName]
        if (hex = "")
            hex := "FFFFFF"
    }

    if (Format = "GUI")
        return hex
    else if (Format = "Background")
        return hex
    else if (Format = "GUI0x")
        return "0x" . hex
}

;;∙=============================================∙
;;∙======∙BOX & BAR ROUTINES∙===================∙
boxline(GuiName, X, Y, W, H, ColorTop := "Black", ColorBottom := "Black", ColorLeft := "Black", ColorRight := "Black", Thickness := 1)
{
    bgTop := Color(ColorTop, "Background")
    bgBottom := Color(ColorBottom, "Background")
    bgLeft := Color(ColorLeft, "Background")
    bgRight := Color(ColorRight, "Background")

    BottomY := Y + H - Thickness
    RightX := X + W - Thickness

    Gui, %GuiName%:Add, Progress, x%X% y%Y% w%W% h%Thickness% Background%bgTop%
    Gui, %GuiName%:Add, Progress, x%X% y%BottomY% w%W% h%Thickness% Background%bgBottom%
    Gui, %GuiName%:Add, Progress, x%X% y%Y% w%Thickness% h%H% Background%bgLeft%
    Gui, %GuiName%:Add, Progress, x%RightX% y%Y% w%Thickness% h%H% Background%bgRight%
}

barLine(GuiName, X, Y, W, H, Color1 := "Black")
{
    bgColor := Color(Color1, "Background")
    Gui, %GuiName%:Add, Progress, x%X% y%Y% w%W% h%H% Background%bgColor%
}

;;∙=============================================∙
;;∙======∙TASK DATA MANAGEMENT∙===============∙
SaveTasks() {
    global TaskList, TaskFile
    data := ""
    for index, task in TaskList {
        data .= task["id"] . "|" . task["text"] . "|" . task["priority"] . "|" . task["category"] . "|" . task["completed"] . "|" . task["created"] . "`n"
    }
    FileDelete, %TaskFile%
    FileAppend, %data%, %TaskFile%
}

LoadTasks() {
    global TaskList, TaskFile
    TaskList := []
    if FileExist(TaskFile) {
        FileRead, data, %TaskFile%
        Loop, Parse, data, `n, `r
        {
            if (A_LoopField = "")
                continue
            fields := StrSplit(A_LoopField, "|")
            if (fields.Length() < 6)
                continue
            task := Object()
            task["id"] := fields[1]
            task["text"] := fields[2]
            task["priority"] := fields[3]
            task["category"] := fields[4]
            task["completed"] := fields[5]
            task["created"] := fields[6]
            TaskList.Push(task)
        }
    }
    if (TaskList.Count() = 0) {
        AddSampleTasks()
    }
}

AddSampleTasks() {
    global TaskList

    TaskList := []

    task := Object()
    task["id"] := "1"
    task["text"] := "Review project documentation"
    task["priority"] := "High"
    task["category"] := "Work"
    task["completed"] := "0"
    task["created"] := A_Now
    TaskList.Push(task)

    task := Object()
    task["id"] := "2"
    task["text"] := "Buy groceries for the week"
    task["priority"] := "Medium"
    task["category"] := "Personal"
    task["completed"] := "0"
    task["created"] := A_Now
    TaskList.Push(task)

    task := Object()
    task["id"] := "3"
    task["text"] := "Schedule team meeting"
    task["priority"] := "High"
    task["category"] := "Work"
    task["completed"] := "0"
    task["created"] := A_Now
    TaskList.Push(task)

    task := Object()
    task["id"] := "4"
    task["text"] := "Read new book chapter"
    task["priority"] := "Low"
    task["category"] := "Learning"
    task["completed"] := "1"
    task["created"] := A_Now
    TaskList.Push(task)

    task := Object()
    task["id"] := "5"
    task["text"] := "Update resume"
    task["priority"] := "Medium"
    task["category"] := "Career"
    task["completed"] := "0"
    task["created"] := A_Now
    TaskList.Push(task)

    task := Object()
    task["id"] := "6"
    task["text"] := "Morning workout routine"
    task["priority"] := "Low"
    task["category"] := "Health"
    task["completed"] := "0"
    task["created"] := A_Now
    TaskList.Push(task)

    SaveTasks()
}

GetTaskStats() {
    global TaskList, FilterMode
    total := 0
    completed := 0
    highPriority := 0

    for index, task in TaskList {
        if (FilterMode = "Active" && task["completed"] = "1")
            continue
        if (FilterMode = "Completed" && task["completed"] = "0")
            continue
        total++
        if (task["completed"] = "1")
            completed++
        if (task["priority"] = "High" && task["completed"] = "0")
            highPriority++
    }

    if (total > 0)
        progressPercent := Round((completed / total) * 100, 0)
    else
        progressPercent := 0

    statObj := Object()
    statObj["total"] := total
    statObj["completed"] := completed
    statObj["highPriority"] := highPriority
    statObj["percent"] := progressPercent
    return statObj
}

;;∙=============================================∙
;;∙======∙GUI BUILDING∙=========================∙
BuildTaskGUI:
    Gui, Task:Destroy

    Gui, Task:New, +AlwaysOnTop -Caption +ToolWindow +E0x02000000 +E0x00080000
    bgColorHex := Color(gui_Bg_Color, "GUI0x")
    Gui, Task:Color, %bgColorHex%
    Gui, Task:Font, s9 Q5, Segoe UI

    boxline("Task", 0, 0, guiW, guiH, gui_Border_Color, gui_Border_Color, gui_Border_Color, gui_Border_Color, 2)

    fontColorHex := Color(gui_Header_Color, "GUI0x")
    Gui, Task:Font, % "s12 c" fontColorHex " Q5 Bold", Segoe UI
    ;;∙------∙Title box.
    boxline("Task", 135, 19, 110, 24, gui_Header_Color, gui_Header_Color, gui_Header_Color, gui_Header_Color, 1)
    ;;∙------∙Title text.
    Gui, Task:Add, Text, x0 y20 w%guiW% BackgroundTrans Center, Task Tracker

    ;;∙------∙Close button.
    Gui, Task:Add, Picture, x355 y10 w14 h14 Icon277 gCloseTask BackgroundTrans, imageres.dll

    ;;∙------∙Stats text.
    fontColorHex := Color(gui_Label_Color, "GUI0x")
    Gui, Task:Font, % "s8 c" fontColorHex " Q5 Bold", Segoe UI
    Gui, Task:Add, Text, x25 y56 w350 h14 vStatsText BackgroundTrans, Loading stats...
    
    ;;∙------∙Progress bar - left cap.
    fontColorHex := Color(gui_ProgressCap_Color, "GUI0x")
    Gui, Task:Font, % "s8 c" fontColorHex " Q5 Norm", Segoe UI
    Gui, Task:Add, Text, x15 y70 w10 h14 vProgressCapLeft BackgroundTrans,
    
    ;;∙------∙Progress bar - filled portion.
    fontColorHex := Color(gui_ProgressFill_Color, "GUI0x")
    Gui, Task:Font, % "s8 c" fontColorHex " Q5 Norm", Segoe UI
    Gui, Task:Add, Text, x25 y70 w10 h14 vProgressFilled BackgroundTrans,
    
    ;;∙------∙Progress bar - empty portion.
    fontColorHex := Color(gui_ProgressEmpty_Color, "GUI0x")
    Gui, Task:Font, % "s8 c" fontColorHex " Q5 Norm", Segoe UI
    Gui, Task:Add, Text, x35 y70 w10 h14 vProgressEmpty BackgroundTrans,
    
    ;;∙------∙Progress bar - right cap.
    fontColorHex := Color(gui_ProgressCap_Color, "GUI0x")
    Gui, Task:Font, % "s8 c" fontColorHex " Q5 Norm", Segoe UI
    Gui, Task:Add, Text, x45 y70 w10 h14 vProgressCapRight BackgroundTrans,

    barLine("Task", 15, 95, guiW - 30, 1, gui_Divider_Color)

    barLine("Task", 14, 95, 1, 97, gui_Divider_Color)  ; 97 = 192 - 95 VERTICAL

    barLine("Task", 364, 95, 1, 97, gui_Divider_Color)  ; 97 = 192 - 95 VERTICAL

    ;;∙------∙Filter label.
    fontColorHex := Color(gui_Filter_Color, "GUI0x")
    Gui, Task:Font, % "s8 c" fontColorHex " Q5 Norm", Segoe UI
    Gui, Task:Add, Text, x45 y100 BackgroundTrans, Filter:

    ;;∙------∙Filter buttons.
    Gui, Task:Add, Text, x85 y100 w40 h18 vFilterAll gSetFilterAll Center BackgroundTrans
    GuiControl, Task: +Border, FilterAll
    Gui, Task:Add, Text, x130 y100 w50 h18 vFilterActive gSetFilterActive Center BackgroundTrans
    GuiControl, Task: +Border, FilterActive
    Gui, Task:Add, Text, x185 y100 w60 h18 vFilterCompleted gSetFilterCompleted Center BackgroundTrans
    GuiControl, Task: +Border, FilterCompleted

    Gui, Task:Add, Text, x250 y100 w50 h18 vClearCompleted gClearCompletedTasks Center BackgroundTrans
    GuiControl, Task: +Border, ClearCompleted

    GoSub, UpdateFilterLabels

    ;;∙------∙Divider line.
    barLine("Task", 15, 120, guiW - 30, 1, gui_Divider_Color)

    ;;∙------∙New Task label.
    fontColorHex := Color(gui_Label_Color, "GUI0x")
    Gui, Task:Font, % "s8 c" fontColorHex " Q5 Bold", Segoe UI
    Gui, Task:Add, Text, x20 y125 BackgroundTrans, New Task:

    ;;∙------∙Edit field.
    Gui, Task:Font, % "s9 c" Color(gui_Text_Color, "GUI0x") " Q5 Bold", Segoe UI
    inputBgHex := Color(gui_Input_Bg, "GUI0x")
    Gui, Task:Add, Edit, % "x20 y142 w290 h22 vNewTaskText +Background" inputBgHex
    GuiControl, Task: Focus, NewTaskText

    ;;∙------∙Priority label.
    fontColorHex := Color(gui_Label_Color, "GUI0x")
    Gui, Task:Font, % "s8 c" fontColorHex " Q5 Bold", Segoe UI
    Gui, Task:Add, Text, x40 y168 BackgroundTrans, Priority:

    ;;∙------∙Priority dropdown.
    Gui, Task:Font, % "s8 c" Color(gui_Text_Color, "GUI0x") " Q5 Norm", Segoe UI
    Gui, Task:Add, DropDownList, x85 y166 w70 vNewTaskPriority Choose1, High||Medium|Low

    ;;∙------∙Category label.
    fontColorHex := Color(gui_Label_Color, "GUI0x")
    Gui, Task:Font, % "s8 c" fontColorHex " Q5 Bold", Segoe UI
    Gui, Task:Add, Text, x170 y168 BackgroundTrans, Category:

    ;;∙------∙Category dropdown.
    Gui, Task:Font, % "s8 c" Color(gui_Text_Color, "GUI0x") " Q5 Norm", Segoe UI
    Gui, Task:Add, DropDownList, x225 y166 w85 vNewTaskCategory Choose1, Work|Personal|Health||Learning|Career|Other

    ;;∙------∙Add button.
    fontColorHex := Color(gui_Add_Btn_Color, "GUI0x")
    Gui, Task:Font, % "s9 c" fontColorHex " Q5 Bold", Segoe UI
    Gui, Task:Add, Text, x315 y142 w50 h22 vAddTaskBtn gAddTask Center BackgroundTrans
    GuiControl, Task: +Border, AddTaskBtn
    Gui, Task:Add, Text, x320 y143 BackgroundTrans Center, + Add

    ;;∙------∙Divider line.
    barLine("Task", 15, 192, guiW - 30, 1, gui_Divider_Color)

    ;;∙------∙Tasks Divider line.
    barLine("Task", 15, 205, guiW - 30, 1, gui_Task_Divider_Color)
    barLine("Task", 15, 205, 1, 330, gui_Task_Divider_Color)  ; 97 = 192 - 95 VERTICAL
    barLine("Task", 364, 205, 1, 330, gui_Task_Divider_Color)  ; 97 = 192 - 95 VERTICAL

    fontColorHex := Color(gui_Header_Color, "GUI0x")
    Gui, Task:Font, % "s9 c" fontColorHex " Q5 Bold", Segoe UI
    Gui, Task:Add, Text, x20 y211 BackgroundTrans, Tasks:
    Gui, Task:Font, % "s8 c" fontColorHex " Q5 Norm", Arial
    Gui, Task:Add, Text, x310 y211 w50 vTaskCountText BackgroundTrans, 0 items

    GoSub, RenderTasks

    Gui, Task:Show, x%guiX% y%guiY% w%guiW% h%guiH%, Task Tracker

    Hotkey, IfWinActive, Task Tracker ahk_class AutoHotkeyGUI
    Hotkey, ~Enter, AddTaskEnter
    Hotkey, IfWinActive
Return

;;∙=============================================∙
;;∙======∙TASK RENDERING∙=======================∙
RenderTasks:
    global TaskList, FilterMode, guiW, TaskScrollOffset

    filteredTasks := []
    for index, task in TaskList {
        if (FilterMode = "Active" && task["completed"] = "1")
            continue
        if (FilterMode = "Completed" && task["completed"] = "0")
            continue
        filteredTasks.Push(task)
    }

    totalTasks := filteredTasks.Count()
    maxVisible := 7
    
    if (TaskScrollOffset < 0)
        TaskScrollOffset := 0
    if (totalTasks > maxVisible && TaskScrollOffset > totalTasks - maxVisible)
        TaskScrollOffset := totalTasks - maxVisible
    
    filterCount := totalTasks
    GuiControl, Task:, TaskCountText, %filterCount% items

    startY := 230
    taskHeight := 42
    
    Loop, % maxVisible {
        taskIndex := A_Index + TaskScrollOffset
        if (taskIndex > totalTasks)
            break
        
        task := filteredTasks[taskIndex]
        currentY := startY + ((A_Index - 1) * taskHeight)

        ;;∙------∙Top divider line for each row.
        if (A_Index > 1)
            barLine("Task", 16, currentY, guiW - 32, 1, "2E2E42")

        ;;∙------∙Checkbox.
        checkChar := task["completed"] = "1" ? "✓" : "○"
        checkColor := task["completed"] = "1" ? gui_Complete_Color : gui_Text_Color
        fontColorHex := Color(checkColor, "GUI0x")
        Gui, Task:Font, % "s12 c" fontColorHex " Q5 Norm", Segoe UI
        Gui, Task:Add, Text, % "x20 y" (currentY + 8) " w20 h20 vCheckbox_" task["id"] " gToggleTask Center BackgroundTrans", %checkChar%

        ;;∙------∙Priority dot.
        priColor := task["priority"] = "High" ? gui_Priority_High : task["priority"] = "Medium" ? gui_Priority_Med : gui_Priority_Low
        fontColorHex := Color(priColor, "GUI0x")
        Gui, Task:Font, % "s6 c" fontColorHex " Q5 Bold", Segoe UI
        Gui, Task:Add, Text, % "x41 y" (currentY + 10) " w8 h8 BackgroundTrans Center", ●

        ;;∙------∙Task text.
        fontColorHex := Color(gui_Text_Color, "GUI0x")
        strikeStyle := task["completed"] = "1" ? " Strike" : " Norm"
        Gui, Task:Font, % "s9 c" fontColorHex " Q5" strikeStyle, Segoe UI
        taskText := task["text"]
        Gui, Task:Add, Text, % "x55 y" (currentY + 6) " w255 h18 BackgroundTrans", %taskText%

        ;;∙------∙Category.
        fontColorHex := Color(gui_Category_Color, "GUI0x")
        Gui, Task:Font, % "s7 c" fontColorHex " Q5 Norm", Segoe UI
        taskCat := task["category"]
        catText := "[" . taskCat . "]"
        Gui, Task:Add, Text, % "x55 y" (currentY + 24) " w100 h14 BackgroundTrans", %catText%

        ;;∙------∙Delete button.
        fontColorHex := Color(gui_Delete_Color, "GUI0x")
        Gui, Task:Font, % "s8 c" fontColorHex " Q5 Bold", Segoe UI
        Gui, Task:Add, Text, % "x340 y" (currentY + 8) " w14 h14 vDelete_" task["id"] " gDeleteTask Center BackgroundTrans", ×
    }

    if (totalTasks > maxVisible) {
        fontColorHex := Color(gui_Scroll_Color, "GUI0x")
        Gui, Task:Font, % "s8 c" fontColorHex " Q5 Norm", Segoe UI
        
        ;;∙------∙Scroll buttons.
        if (TaskScrollOffset > 0) {
            Gui, Task:Add, Text, x100 y530 w80 h16 vScrollUp gScrollUp Center BackgroundTrans, ▲ Scroll Up
        }
        if (TaskScrollOffset < totalTasks - maxVisible) {
            Gui, Task:Add, Text, x200 y530 w80 h16 vScrollDown gScrollDown Center BackgroundTrans, ▼ Scroll Down
        }
    }

    GoSub, UpdateStats
Return

;;∙=============================================∙
;;∙======∙SCROLL CONTROLS∙======================∙
ScrollUp:
    TaskScrollOffset -= 1
    GoSub, BuildTaskGUI
Return

ScrollDown:
    TaskScrollOffset += 1
    GoSub, BuildTaskGUI
Return

;;∙=============================================∙
;;∙======∙TASK OPERATIONS∙======================∙
AddTask:
    Gui, Task:Submit, NoHide
    taskText := Trim(NewTaskText)

    if (taskText = "") {
        ToolTip, Please enter a task description!
        SetTimer, RemoveTooltip, -2000
        Return
    }

    newTask := Object()
    newTask["id"] := A_Now
    newTask["text"] := taskText
    newTask["priority"] := NewTaskPriority
    newTask["category"] := NewTaskCategory
    newTask["completed"] := "0"
    newTask["created"] := A_Now

    TaskList.Push(newTask)
    SaveTasks()

    GuiControl, Task:, NewTaskText,
    GuiControl, Task: Focus, NewTaskText
    GoSub, BuildTaskGUI
Return

AddTaskEnter:
    Gui, Task:Submit, NoHide
    if (A_GuiControl = "NewTaskText" && Trim(NewTaskText) != "") {
        Gosub, AddTask
    }
Return

ToggleTask:
    controlID := A_GuiControl
    taskID := SubStr(controlID, 10)

    for index, task in TaskList {
        if (task["id"] = taskID) {
            task["completed"] := task["completed"] = "1" ? "0" : "1"
            break
        }
    }

    SaveTasks()
    GoSub, BuildTaskGUI
Return

DeleteTask:
    controlID := A_GuiControl
    taskID := SubStr(controlID, 8)

    tempList := []
    for index, task in TaskList {
        if (task["id"] != taskID) {
            tempList.Push(task)
        }
    }
    TaskList := tempList
    SaveTasks()
    GoSub, BuildTaskGUI
Return

ClearCompletedTasks:
    tempList := []
    for index, task in TaskList {
        if (task["completed"] != "1") {
            tempList.Push(task)
        }
    }
    TaskList := tempList
    TaskScrollOffset := 0
    SaveTasks()
    GoSub, BuildTaskGUI
Return

;;∙=============================================∙
;;∙======∙STATS & UI UPDATES∙====================∙
UpdateStats:
    global gui_ProgressFill_Color, gui_ProgressEmpty_Color, gui_ProgressCap_Color
    stats := GetTaskStats()

    statPct := stats["percent"]
    statComp := stats["completed"]
    statTotal := stats["total"]
    statHigh := stats["highPriority"]

    statsText := "Progress: " . statPct . "%  ✅ " . statComp . "/" . statTotal . "  🔴 " . statHigh . " high"
    GuiControl, Task:, StatsText, %statsText%

    ;;∙------∙Build progress bar.
    barLength := gui_ProgressBar_Length
    filledCount := Floor((statPct / 100) * barLength)
    unfilledCount := barLength - filledCount
    
    ;;∙------∙Left cap.
    GuiControl, Task:, ProgressCapLeft, ▌
    
    ;;∙------∙Filled blocks.
    filledText := ""
    Loop, % filledCount {
        filledText .= "█"
    }
    GuiControl, Task:, ProgressFilled, %filledText%
    
    ;;∙------∙Empty blocks.
    emptyText := ""
    Loop, % unfilledCount {
        emptyText .= "░"
    }
    GuiControl, Task:, ProgressEmpty, %emptyText%
    
    ;;∙------∙Right cap.
    GuiControl, Task:, ProgressCapRight, ▐
    
    ;;∙------∙Reposition controls.
    capWidth := 8
    blockWidth := 7
    
    ;;∙------∙Left cap.
    ;;∙------∙Filled bar starts after left cap.
    GuiControl, Task: Move, ProgressFilled, % "x" (15 + capWidth) " w" (filledCount * blockWidth)
    
    ;;∙------∙Empty bar starts after filled bar.
    emptyX := 15 + capWidth + (filledCount * blockWidth)
    GuiControl, Task: Move, ProgressEmpty, % "x" emptyX " w" (unfilledCount * blockWidth)
    
    ;;∙------∙Right cap after empty bar.
    GuiControl, Task: Move, ProgressCapRight, % "x" (emptyX + (unfilledCount * blockWidth))

    GoSub, UpdateFilterLabels
Return

UpdateFilterLabels:
    GuiControl, Task:, FilterAll, All
    GuiControl, Task:, FilterActive, Active
    GuiControl, Task:, FilterCompleted, Done
    GuiControl, Task:, ClearCompleted, Clear
Return

SetFilterAll:
    FilterMode := "All"
    TaskScrollOffset := 0
    GoSub, BuildTaskGUI
Return

SetFilterActive:
    FilterMode := "Active"
    TaskScrollOffset := 0
    GoSub, BuildTaskGUI
Return

SetFilterCompleted:
    FilterMode := "Completed"
    TaskScrollOffset := 0
    GoSub, BuildTaskGUI
Return

RemoveTooltip:
    ToolTip
Return

;;∙=============================================∙
;;∙======∙WINDOW CONTROLS∙===================∙
WM_LBUTTONDOWNdrag() {
    PostMessage, 0x00A1, 2, 0
}
Return

CloseTask:
    SoundBeep, 700, 100
    SoundBeep, 900, 100
    Gui, Task:Hide
    Menu, Tray, Rename, Hide Tracker, Show Tracker
    Menu, Tray, Icon, Show Tracker, shell32.dll, 247
Return

;;∙=============================================∙
;;∙======∙HOTKEY TOGGLE∙========================∙
^!t::
    GoSub, ToggleTracker
Return

;;∙=============================================∙
;;∙======∙TRACKER TOGGLE∙=======================∙
ToggleTracker:
    if WinExist("Task Tracker") {
        Gui, Task:+LastFound
        if DllCall("IsWindowVisible", "Ptr", WinExist()) {
            Gui, Task:Hide
            SoundBeep, 900, 100
            SoundBeep, 700, 100
            Menu, Tray, Rename, Hide Tracker, Show Tracker
            Menu, Tray, Icon, Show Tracker, shell32.dll, 247
        } else {
            GoSub, BuildTaskGUI
            Menu, Tray, Rename, Show Tracker, Hide Tracker
            Menu, Tray, Icon, Hide Tracker, shell32.dll, 248
        }
    } else {
        GoSub, BuildTaskGUI
        Menu, Tray, Rename, Show Tracker, Hide Tracker
        Menu, Tray, Icon, Hide Tracker, shell32.dll, 248
    }
Return

;;∙=============================================∙
;;∙======∙SCRIPT EDIT / RELOAD / EXIT∙=============∙
Script·Edit:
    Edit
Return

^Home::
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)
    Script·Reload:
        Reload
Return

^Esc::
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)
    Script·Exit:
        SoundBeep, 800, 150
        SoundBeep, 500, 100
        ExitApp
Return

;;∙=============================================∙
;;∙======∙AUTO-RELOAD MONITOR∙================∙
UpdateCheck:    ;;∙------Check if script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload

;;∙=============================================∙
;;∙======∙TRAY MENU CONFIGURATION∙============∙
TrayMenu:
    Menu, Tray, Tip, %ScriptID%
    Menu, Tray, NoStandard
    Menu, Tray, Click, 2
    Menu, Tray, Color, ABCDEF

    Menu, Tray, Add
    Menu, Tray, Add, Hide Tracker, ToggleTracker
    Menu, Tray, Icon, Hide Tracker, shell32.dll, 248
    Menu, Tray, Default, Hide Tracker

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
Return

;;∙=============================================∙
;;∙======∙TRAY UTILITIES∙=========================∙
Documentation:
    Run, "C:\Program Files\AutoHotkey\AutoHotkey.chm"
Return

ShowKeyHistory:
    KeyHistory
Return

ShowWindowSpy:
    Run, "C:\Program Files\AutoHotkey\WindowSpy.ahk"
Return

;;∙=============================================∙
;;∙========∙TRAY MENU POSITIONING∙=============∙
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20
Return

NotifyTrayClick(P*) {
Static Msg, Fun:="NotifyTrayClick", NM:=OnMessage(0x404,Func(Fun),-1),  Chk,T:=-250,Clk:=1
  If ( (NM := Format(Fun . "_{:03X}", Msg := P[2])) && P.Count()<4 )
     return ( T := Max(-5000, 0-(P[1] ? Abs(P[1]) : 250)) )
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


;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙

