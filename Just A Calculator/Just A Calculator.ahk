;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙

;;∙=============================================∙
;;∙======∙DIRECTIVES & SETTINGS∙=================∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force

SendMode, Input
SetBatchLines -1
SetWinDelay 0

OnMessage(0x0201, "WM_LBUTTONDOWNdrag")
Menu, Tray, Icon, imageres.dll, 240

SetTimer, UpdateCheck, 750
ScriptID := "Just_A_Calculator"
GoSub, TrayMenu

;;∙=============================================∙
;;∙======∙GLOBAL VARIABLES∙=====================∙
global history := Object()    ;;∙------∙Array to store calculation history entries.
global history_max := 20    ;;∙------∙Maximum number of history entries to keep.

global ini_file := A_ScriptDir "\Calculator_History.ini"    ;;∙------∙Path to INI file for persisting history.

global calc_bg_color := "Black"    ;;∙------∙Gui Background Color.
global calc_border_color := "Blue"    ;;∙------∙Main Gui window border color.

global calc_font := "Segoe UI"    ;;∙------∙Display Box Text Font.
global calc_font_size := 14    ;;∙------∙Display Box Text Font Size.
global calc_display_color := "Aqua"    ;;∙------∙Display Box Font Color.

global calc_text_color := "Blue"    ;;∙------∙History Text color.

global calc_result_color := "Yellow"    ;;∙------∙Result display text color (equation & answer).
global calc_result_copy_color := "Lime"    ;;∙------∙Temporary color when result is copied to clipboard.

global calc_grid_color := "Silver"    ;;∙------∙Inner grid line color between buttons.
Global calc_gridEdge_color :="Gray"    ;;∙------∙Outer grid edge color (border around button grid).

global calc_top_buttons_color1 := "Gray"    ;;∙------∙Outer border color for H/C button area.
global calc_top_buttons_color2 := "Silver"    ;;∙------∙Inner border color for H/C button area.

global calc_name_color := "Aqua"    ;;∙------∙"Just A Calculator" text color at bottom.

global calc_mem := "x"    ;;∙------∙Multiplication symbol used for multiply button.
global calc_mem2 := "÷"    ;;∙------∙Division symbol used for divide button.

global memory := 0    ;;∙------∙Memory storage value (M+, M-, MR, MC functions).
global history_param := ""    ;;∙------∙Temporary variable to pass history entry to AddToHistory subroutine.

;;∙=============================================∙
;;∙======∙FORMAT NUMBER∙======================∙
;;∙------∙Takes numeric result & formats it by removing unnecessary trailing zeros & decimal points.
FormatNumber(num) {
    ;;∙------∙If number is a whole number (no fractional part), return it as an integer.
    if (num = floor(num))
        return floor(num)
    ;;∙------∙Otherwise, round to 8 decimal places, trim trailing zeros, & trim trailing decimal point if necessary.
    return RTrim(RTrim(Round(num, 8), "0"), ".")
}

;;∙=============================================∙
;;∙======∙MANUAL MATH PARSER∙=================∙
;;∙------∙Manual math expression parser & evaluator. Handles +, -, *, /, ^, parentheses, & basic error checking.
;;∙------∙Returns numeric result of the expression, or the string "ERROR".
EvaluateExpression(expr) {
    ;;∙------∙Replace bullet (multiplication symbol) with asterisk for evaluation.
    StringReplace, expr, expr, %calc_mem%, *, All
    ;;∙------∙Replace division symbol with slash for evaluation.
    StringReplace, expr, expr, %calc_mem2%, /, All
    ;;∙------∙Remove all spaces from expression.
    StringReplace, expr, expr, %A_Space%, , All
    
    ;;∙------∙Handle parentheses recursively using a while loop.
    while (InStr(expr, "(")) {
        ;;∙------∙Find innermost set of parentheses.
        if !RegExMatch(expr, "\(([^()]+)\)", match)
            return "ERROR"
        ;;∙------∙Recursively evaluate inner expression.
        inner := EvaluateExpression(match1)
        if (inner = "ERROR")
            return "ERROR"
        ;;∙------∙Replace parentheses & their contents with the evaluated result.
        StringReplace, expr, expr, %match%, %inner%, All
    }
    
    ;;∙------∙Handle power operator ^ (highest precedence).
    Loop {
        pos := InStr(expr, "^")    ;;∙------∙Find position of the first '^'.
        if !pos
            break    ;;∙------∙Exit loop if no more '^' operators.
            
        ;;∙------∙Find left operand number.
        left_start := pos
        Loop {
            if (left_start = 1)
                break
            char := SubStr(expr, left_start - 1, 1)
            ;;∙------∙Check if previous character is an operator.
            if (char = "+" or char = "-" or char = "*" or char = "/" or char = "^")
                break
            left_start--
        }
        
        ;;∙------∙Find right operand number.
        right_end := pos
        len := StrLen(expr)
        Loop {
            if (right_end = len)
                break
            char := SubStr(expr, right_end + 1, 1)
            ;;∙------∙Check if next character is an operator.
            if (char = "+" or char = "-" or char = "*" or char = "/" or char = "^")
                break
            right_end++
        }
        
        ;;∙------∙Extract left & right number strings.
        left_num := SubStr(expr, left_start, pos - left_start)
        right_num := SubStr(expr, pos + 1, right_end - pos)
        
        ;;∙------∙Convert string numbers to actual numeric values.
        left_num += 0
        right_num += 0
        
        ;;∙------∙Calculate the power.
        result := left_num ** right_num
        
        ;;∙------∙Replace the entire operation (e.g., "2^3") with its result.
        StringReplace, expr, expr, % SubStr(expr, left_start, right_end - left_start + 1), % result, All
    }
    
    ;;∙------∙Handle multiplication & division (same precedence level).
    Loop {
        pos_mult := InStr(expr, "*")
        pos_div := InStr(expr, "/")
        
        pos := 0
        op := ""
        
        ;;∙------∙Determine first occurring operator (* or /).
        if (pos_mult > 0 and pos_div > 0)
            pos := (pos_mult < pos_div) ? pos_mult : pos_div
        else if (pos_mult > 0)
            pos := pos_mult
        else if (pos_div > 0)
            pos := pos_div
        else
            break    ;;∙------∙Exit loop if no * or / found.
            
        ;;∙------∙Set operator based on position.
        if (pos = pos_mult)
            op := "*"
        else
            op := "/"
        
        ;;∙------∙Find left operand number.
        left_start := pos
        Loop {
            if (left_start = 1)
                break
            char := SubStr(expr, left_start - 1, 1)
            if (char = "+" or char = "-" or char = "*" or char = "/")
                break
            left_start--
        }
        
        ;;∙------∙Find right operand number.
        right_end := pos
        len := StrLen(expr)
        Loop {
            if (right_end = len)
                break
            char := SubStr(expr, right_end + 1, 1)
            if (char = "+" or char = "-" or char = "*" or char = "/")
                break
            right_end++
        }
        
        ;;∙------∙Extract left & right number strings.
        left_num := SubStr(expr, left_start, pos - left_start)
        right_num := SubStr(expr, pos + 1, right_end - pos)
        
        ;;∙------∙Convert to numeric values.
        left_num += 0
        right_num += 0
        
        ;;∙------∙Perform calculation.
        if (op = "*")
            result := left_num * right_num
        else if (op = "/")
            result := (right_num != 0) ? left_num / right_num : "ERROR"    ;;∙------∙Check for division by zero.
        
        if (result = "ERROR")
            return "ERROR"
        
        ;;∙------∙Replace operation with its result.
        StringReplace, expr, expr, % SubStr(expr, left_start, right_end - left_start + 1), % result, All
    }
    
    ;;∙------∙Handle addition & subtraction sequentially.
    result := 0
    sign := 1    ;;∙------∙Current sign for next number (1 for +, -1 for -).
    i := 1
    len := StrLen(expr)
    
    while (i <= len) {
        char := SubStr(expr, i, 1)
        if (char = "+") {
            sign := 1
            i++
        } else if (char = "-") {
            sign := -1
            i++
        } else {
            ;;∙------∙Find full number string.
            num_start := i
            while (i <= len) {
                next_char := SubStr(expr, i, 1)
                if (next_char = "+" || next_char = "-")
                    break
                i++
            }
            num := SubStr(expr, num_start, i - num_start)
            num += 0
            result += sign * num
        }
    }
    
    return result    ;;∙------∙Return final calculated result.
}

;;∙=============================================∙
;;∙======∙LOAD/SAVE HISTORY∙====================∙
;;∙------∙Reads history entries from INI file & populates the history object.
LoadHistory:
    history := Object()    ;;∙------∙Initialize an empty object for history.
    Loop, %history_max%    ;;∙------∙Loop up to maximum number of history entries.
    {
        ;;∙------∙Read an entry from INI file.
        IniRead, entry, %ini_file%, History, entry_%A_Index%, ERROR
        ;;∙------∙If entry exists & is not empty, insert it into the history object.
        if (entry != "ERROR" && entry != "")
            history.Insert(entry)
        else
            break    ;;∙------∙Stop reading if an entry is missing or empty.
    }
Return

;;∙------∙Writes the contents of the history object to INI file (called after new history entry or when history cleared).
SaveHistory:
    IniDelete, %ini_file%, History    ;;∙------∙Delete entire History section to clear old data.
    ;;∙------∙Loop through the history object & write each entry to INI file.
    for index, entry in history
        IniWrite, %entry%, %ini_file%, History, entry_%index%
Return

;;∙------∙Adds new entry to the history object, enforces maximum size limit, & saves history (called when a calculation is performed).
AddToHistory:
    entry := history_param    ;;∙------∙Get new history entry from the global variable.
    global history, history_max
    history.Insert(entry)    ;;∙------∙Add new entry to end of the history array.
    ;;∙------∙If history exceeds maximum allowed size, remove oldest entry (index 1).
    while (history.MaxIndex() > history_max)
        history.Remove(1)
    GoSub, SaveHistory    ;;∙------∙Persist updated history to INI file.
Return

;;∙=============================================∙
;;∙======∙CREATE CALCULATOR GUI∙================∙
;;∙------∙Creates & displays main calculator Gui.
CreateCalculator:
    ;;∙------∙Subroutine global variables.
    global calc_bg_color, calc_font, calc_font_size, calc_display_color
    global calc_text_color, calc_result_color, calc_grid_color
    global calc_border_color, calc_top_buttons_color1, calc_top_buttons_color2, calc_name_color, calc_mem

    Gui, Calculator:Destroy
    Gui, Calculator:New, +AlwaysOnTop -Caption +ToolWindow +E0x02000000
    Gui, Calculator:Color, % Color(calc_bg_color, "GUI0x")    ;;∙------∙Gui background color.

    ;;∙------∙Main display Edit control.
    displayColorHex := Color(calc_display_color, "GUI0x")
    Gui, Calculator:Font, s%calc_font_size% c%displayColorHex%, %calc_font%
    Gui, Calculator:Add, Edit, x10 y10 w230 h40 vDisplay ReadOnly -E0x2000000, 0

    ;;∙------∙History & Clear Buttons.
    textColorHex := Color(calc_text_color, "GUI0x")
    Gui, Calculator:Font, s8 c%textColorHex% Bold, %calc_font%
    Gui, Calculator:Add, Button, x255 y15 w30 h19 gShowHistory, H    ;;∙------∙History.
    Gui, Calculator:Add, Button, x255 y36 w30 h19 gClearDisplay, C    ;;∙------∙Clear.

    ;;∙------∙History & Clear Buttons Borders.
    topButtonsBG1 := Color(calc_top_buttons_color1, "Background")
    topButtonsBG2 := Color(calc_top_buttons_color2, "Background")
    ;;∙------∙Outer border.
    boxline("Calculator", 251, 11, 38, 48, topButtonsBG1, topButtonsBG1, topButtonsBG1, topButtonsBG1, 1)
    ;;∙------∙Inner border.
    boxline("Calculator", 253, 13, 34, 44, topButtonsBG2, topButtonsBG2, topButtonsBG2, topButtonsBG2, 2)

    ;;∙------∙Result Display Text Control (clicking result text triggers the g-label CopyResult.).
    resultColorHex := Color(calc_result_color, "GUI0x")
    Gui, Calculator:Font, s10 c%resultColorHex% Norm Italic, %calc_font%
    Gui, Calculator:Add, Text, x15 y55 w270 h20 vResultText gCopyResult,

    ;;∙------∙Reset font to Bold for number & operator buttons.
    Gui, Calculator:Font, Bold, %calc_font%

    ;;∙------∙Define dimensions & starting coordinates for main button grid.
    btn_x := 10
    btn_y := 85
    btn_w := 52
    btn_h := 35
    btn_gap := 5

    ;;∙------∙Row 1:  7 8 9 ÷ ←
    Gui, Calculator:Add, Button, x%btn_x% y%btn_y% w%btn_w% h%btn_h% gNum7, 7
    Gui, Calculator:Add, Button, x+%btn_gap% y%btn_y% w%btn_w% h%btn_h% gNum8, 8
    Gui, Calculator:Add, Button, x+%btn_gap% y%btn_y% w%btn_w% h%btn_h% gNum9, 9
    Gui, Calculator:Add, Button, x+%btn_gap% y%btn_y% w%btn_w% h%btn_h% gOpDiv, %calc_mem2%
    Gui, Calculator:Add, Button, x+%btn_gap% y%btn_y% w%btn_w% h%btn_h% gBackspace, ←
    
    ;;∙------∙Row 2:  4 5 6 x (
    row2_y := btn_y + btn_h + btn_gap
    Gui, Calculator:Add, Button, x%btn_x% y%row2_y% w%btn_w% h%btn_h% gNum4, 4
    Gui, Calculator:Add, Button, x+%btn_gap% y%row2_y% w%btn_w% h%btn_h% gNum5, 5
    Gui, Calculator:Add, Button, x+%btn_gap% y%row2_y% w%btn_w% h%btn_h% gNum6, 6
    Gui, Calculator:Add, Button, x+%btn_gap% y%row2_y% w%btn_w% h%btn_h% gOpMult, %calc_mem%
    Gui, Calculator:Add, Button, x+%btn_gap% y%row2_y% w%btn_w% h%btn_h% gOpenParen, (
    
    ;;∙------∙Row 3:  1 2 3 - )
    row3_y := row2_y + btn_h + btn_gap
    Gui, Calculator:Add, Button, x%btn_x% y%row3_y% w%btn_w% h%btn_h% gNum1, 1
    Gui, Calculator:Add, Button, x+%btn_gap% y%row3_y% w%btn_w% h%btn_h% gNum2, 2
    Gui, Calculator:Add, Button, x+%btn_gap% y%row3_y% w%btn_w% h%btn_h% gNum3, 3
    Gui, Calculator:Add, Button, x+%btn_gap% y%row3_y% w%btn_w% h%btn_h% gOpSub, -
    Gui, Calculator:Add, Button, x+%btn_gap% y%row3_y% w%btn_w% h%btn_h% gCloseParen, )
    
    ;;∙------∙Row 4:  0 . = + ^
    row4_y := row3_y + btn_h + btn_gap
    Gui, Calculator:Add, Button, x%btn_x% y%row4_y% w%btn_w% h%btn_h% gNum0, 0
    Gui, Calculator:Add, Button, x+%btn_gap% y%row4_y% w%btn_w% h%btn_h% gDecimal, .
    Gui, Calculator:Add, Button, x+%btn_gap% y%row4_y% w%btn_w% h%btn_h% gEquals, =
    Gui, Calculator:Add, Button, x+%btn_gap% y%row4_y% w%btn_w% h%btn_h% gOpAdd, +
    Gui, Calculator:Add, Button, x+%btn_gap% y%row4_y% w%btn_w% h%btn_h% gOpPow, ^
    
;;∙------∙Function buttons - Math functions.
    func_y := row4_y + btn_h + btn_gap
    btn_w_func := 52
    Gui, Calculator:Font, s7 c%textColorHex% Bold, %calc_font%
    Gui, Calculator:Add, Button, x%btn_x% y%func_y% w%btn_w_func% h%btn_h% gFuncSqrt,     sqrt
    Gui, Calculator:Add, Button, x+%btn_gap% y%func_y% w%btn_w_func% h%btn_h% gFuncPercent,  `%
    Gui, Calculator:Add, Button, x+%btn_gap% y%func_y% w%btn_w_func% h%btn_h% gFuncPlusMinus, ±
    Gui, Calculator:Add, Button, x+%btn_gap% y%func_y% w%btn_w_func% h%btn_h% gFuncCubeRoot, ^⅓
    Gui, Calculator:Add, Button, x+%btn_gap% y%func_y% w%btn_w_func% h%btn_h% gFuncSquared,  x²

;;∙------∙Function buttons - Memory functions.
    func2_y := func_y + btn_h + btn_gap
    Gui, Calculator:Add, Button, x%btn_x% y%func2_y% w%btn_w_func% h%btn_h% gMemAdd,    M+
    Gui, Calculator:Add, Button, x+%btn_gap% y%func2_y% w%btn_w_func% h%btn_h% gMemSub,  M-
    Gui, Calculator:Add, Button, x+%btn_gap% y%func2_y% w%btn_w_func% h%btn_h% gMemClear, MC
    Gui, Calculator:Add, Button, x+%btn_gap% y%func2_y% w%btn_w_func% h%btn_h% gMemRecall, MR
    Gui, Calculator:Add, Button, x+%btn_gap% y%func2_y% w%btn_w_func% h%btn_h% gMemStore, MS

    ;;∙------∙Memory indicator (dot that appears when memory is non-zero).
    memColorHex := Color(calc_result_color, "GUI0x")
    ;;∙------∙Position dot centered under the MS button (5th button, 4 gaps from start).
    mem_x := btn_x + 4 * (btn_w_func + btn_gap) + (btn_w_func // 2) + 20
    mem_y := func2_y + btn_h - 1   ;;∙------∙ Just below MS button, above the bottom edge bar.
    Gui, Calculator:Font, s12 c%memColorHex% Bold, %calc_font%
    Gui, Calculator:Add, Text, x%mem_x% y%mem_y% vMemIndicator BackgroundTrans, 

    ;;∙------∙Calculate total window dimensions based on button layout.
    total_w := 300
    total_h := func2_y + btn_h + 20

    ;;∙=============================================∙
    ;;∙======∙GRID BARS∙============================∙
    ;;∙------∙Draw custom grid lines to visually separate buttons using the barLine function.

    gridColorBG := Color(calc_grid_color, "Background")
    gridColorBGedge := Color(calc_gridEdge_color, "Background")

    ;;∙====∙Vertical Edge Bars∙==============∙
    barLine("Calculator", 6,   81, 3, 243, gridColorBGedge)     ;;∙------∙Left edge
    barLine("Calculator", 291, 81, 3, 243, gridColorBGedge)     ;;∙------∙Right edge

    ;;∙====∙Horizontal Edge Bars∙=============∙
    barLine("Calculator", 6, 81,  287, 3, gridColorBGedge)      ;;∙------∙Top edge
    barLine("Calculator", 6, 321, 288, 3, gridColorBGedge)      ;;∙------∙Bottom edge

    ;;∙====∙Vertical Inner Bars∙============∙
    barLine("Calculator", 63,  81, 3, 243, gridColorBG)         ;;∙------∙Inner vertical 1
    barLine("Calculator", 120, 81, 3, 243, gridColorBG)         ;;∙------∙Inner vertical 2
    barLine("Calculator", 177, 81, 3, 243, gridColorBG)         ;;∙------∙Inner vertical 3
    barLine("Calculator", 234, 81, 3, 243, gridColorBG)         ;;∙------∙Inner vertical 4

    ;;∙====∙Horizontal Inner Bars∙==========∙
    barLine("Calculator", 6, 121, 288, 3, gridColorBG)          ;;∙------∙Inner horizontal 1
    barLine("Calculator", 6, 161, 288, 3, gridColorBG)          ;;∙------∙Inner horizontal 2
    barLine("Calculator", 6, 201, 288, 3, gridColorBG)          ;;∙------∙Inner horizontal 3
    barLine("Calculator", 6, 241, 288, 3, gridColorBG)          ;;∙------∙Inner horizontal 4
    barLine("Calculator", 6, 281, 288, 3, gridColorBG)          ;;∙------∙Inner horizontal 5
    
    ;;∙------∙Calculate total window dimensions based on button layout.
    total_w := 300
    total_h := func2_y + btn_h + 20

    ;;∙=============================================∙
    ;;∙======∙WINDOW BORDER∙======================∙
    ;;∙------∙Draw main window border using the boxline function.

    borderColorBG := Color(calc_border_color, "Background")
    ;;∙------∙Draw a 2-pixel thick border around the entire window.
    boxline("Calculator", 0, 0, total_w, total_h, borderColorBG, borderColorBG, borderColorBG, borderColorBG, 2)

    ;;∙------∙Show Gui window.
    Gui, Calculator:Show, w%total_w% h%total_h% x300 yCenter, Just A Calculator

    ;;∙------∙Set keyboard focus to Edit control display.
    GuiControl, Calculator:Focus, Display
    ;;∙------∙Send EM_SETSEL (-1, -1) to move caret to end of the text in Edit control.
    SendMessage, 0xB1, -1, -1, Edit1, Just A Calculator
    
    ;;∙------∙Set up context-sensitive keyboard hooks that only work when calculator window is active.
    Hotkey, IfWinActive, Just A Calculator
    ;;∙------∙Map standard number keys & numpad keys to respective button labels.
    Hotkey, ~0, Num0
    Hotkey, ~1, Num1
    Hotkey, ~2, Num2
    Hotkey, ~3, Num3
    Hotkey, ~4, Num4
    Hotkey, ~5, Num5
    Hotkey, ~6, Num6
    Hotkey, ~7, Num7
    Hotkey, ~8, Num8
    Hotkey, ~9, Num9
    Hotkey, ~Numpad0, Num0
    Hotkey, ~Numpad1, Num1
    Hotkey, ~Numpad2, Num2
    Hotkey, ~Numpad3, Num3
    Hotkey, ~Numpad4, Num4
    Hotkey, ~Numpad5, Num5
    Hotkey, ~Numpad6, Num6
    Hotkey, ~Numpad7, Num7
    Hotkey, ~Numpad8, Num8
    Hotkey, ~Numpad9, Num9
    Hotkey, ~., Decimal
    Hotkey, ~NumpadDot, Decimal
    Hotkey, ~+, OpAdd
    Hotkey, ~NumpadAdd, OpAdd
    Hotkey, ~-, OpSub
    Hotkey, ~NumpadSub, OpSub
    Hotkey, ~*, OpMult
    Hotkey, ~NumpadMult, OpMult
    Hotkey, ~/, OpDiv
    Hotkey, ~NumpadDiv, OpDiv
    Hotkey, ~^, OpPow
    Hotkey, ~=, Equals
    Hotkey, ~NumpadEnter, Equals
    Hotkey, ~Enter, Equals
    Hotkey, ~Backspace, Backspace
    Hotkey, ~Delete, ClearDisplay
    Hotkey, ~Escape, CloseCalculator
    ;;∙------∙For parentheses, use the actual key with Shift modifier.
    Hotkey, ~( , OpenParen
    Hotkey, ~) , CloseParen
    Hotkey, IfWinActive    ;;∙------∙Reset context-sensitivity.
Return

;;∙=============================================∙
;;∙======∙BUTTON HANDLERS∙=====================∙
;;∙------∙Triggered by clicking number buttons or pressing the corresponding number keys.

Num0:
    btn_value = 0
    GoSub, HandleNumber    ;;∙------∙Delegate to the generic number handler.
Return

Num1:
    btn_value = 1
    GoSub, HandleNumber
Return

Num2:
    btn_value = 2
    GoSub, HandleNumber
Return

Num3:
    btn_value = 3
    GoSub, HandleNumber
Return

Num4:
    btn_value = 4
    GoSub, HandleNumber
Return

Num5:
    btn_value = 5
    GoSub, HandleNumber
Return

Num6:
    btn_value = 6
    GoSub, HandleNumber
Return

Num7:
    btn_value = 7
    GoSub, HandleNumber
Return

Num8:
    btn_value = 8
    GoSub, HandleNumber
Return

Num9:
    btn_value = 9
    GoSub, HandleNumber
Return

Decimal:
    btn_value = .
    GoSub, HandleNumber
Return

OpenParen:
    btn_value = (
    GoSub, HandleNumber
Return

CloseParen:
    btn_value = )
    GoSub, HandleNumber
Return

;;∙------∙Manages appending a digit, decimal point, or parenthesis to the current display value.
HandleNumber:
    GuiControlGet, current, Calculator:, Display    ;;∙------∙Get current text from the display.
    if (current = "Error")    ;;∙------∙If display shows "Error", reset to "0".
        current := "0"
    ;;∙------∙If display is exactly "0" & new value is not a decimal point, replace "0".
    if (current = "0" && btn_value != ".")
        new_display := btn_value
    else
        new_display := current . btn_value    ;;∙------∙Append new value to existing display.
    GuiControl, Calculator:, Display, %new_display%    ;;∙------∙Update display.
    GuiControl, Calculator:Focus, Display    ;;∙------∙Refocus display control.
    SendMessage, 0xB1, -1, -1, Edit1, Just A Calculator    ;;∙------∙Move caret to the end.
Return

    ;;∙------∙Operator handlers set btn_value & delegate to the generic operator handler.
OpAdd:
    btn_value = +
    GoSub, HandleOperator
Return

OpSub:
    btn_value = -
    GoSub, HandleOperator
Return

OpMult:
    btn_value = %calc_mem%    ;;∙------∙Use display symbol for multiplication.
    GoSub, HandleOperator
Return

OpDiv:
    btn_value = %calc_mem2%    ;;∙------∙Use display symbol for division.
    GoSub, HandleOperator
Return

OpPow:
    btn_value = ^
    GoSub, HandleOperator
Return

    ;;∙------∙Manages adding an operator (+, -, *, /, ^) to the display. Prevents multiple operators in a row.
HandleOperator:
    GuiControlGet, current, Calculator:, Display    ;;∙------∙Get current display text.
    if (current = "Error")
        current := "0"
    operators := "+-*/^x÷"    ;;∙------∙List of valid operator characters.
    last_char := SubStr(current, 0)    ;;∙------∙Get last character of the display.
    last_is_operator := InStr(operators, last_char) > 0    ;;∙------∙Check if last character is an operator.
    if (last_is_operator)
        new_display := SubStr(current, 1, -1) . btn_value    ;;∙------∙Replace last operator with the new one.
    else
        new_display := current . " " . btn_value . " "    ;;∙------∙Append the operator with spaces for readability.
    GuiControl, Calculator:, Display, %new_display%
    GuiControl, Calculator:Focus, Display
    SendMessage, 0xB1, -1, -1, Edit1, Just A Calculator
Return

;;∙------∙Removes last character from the display.
Backspace:
    GuiControlGet, current, Calculator:, Display
    if (StrLen(current) > 1)
        new_display := SubStr(current, 1, -1)    ;;∙------∙Remove last character.
    else
        new_display := "0"    ;;∙------∙If only one character remains, reset to "0".
    GuiControl, Calculator:, Display, %new_display%
    GuiControl, Calculator:Focus, Display
    SendMessage, 0xB1, -1, -1, Edit1, Just A Calculator
Return

;;∙------∙Resets display to "0" & clears result text.
ClearDisplay:
    GuiControl, Calculator:, Display, 0
    GuiControl, Calculator:, ResultText, 
    GuiControl, Calculator:Focus, Display
Return

;;∙------∙Hides calculator window (does not destroy it).
CloseCalculator:
    Gui, Calculator:Hide
Return

;;∙------∙Evaluates the expression in the display, shows result, & adds it to history.
Equals:
    GuiControlGet, expression, Calculator:, Display    ;;∙------∙Get expression string.
    result := EvaluateExpression(expression)    ;;∙------∙Call math parser.
    
    if (result = "ERROR")    ;;∙------∙Handle evaluation errors.
    {
        GuiControl, Calculator:, ResultText, Error!
        GuiControl, Calculator:, Display, Error
        SetTimer, ClearError, -1500    ;;∙------∙Set one-time timer to clear error message after 1.5 seconds.
    }
    else
    {
        result_formatted := FormatNumber(result)    ;;∙------∙Format numeric result.
        ;;∙------∙Show full equation & result in the result text area.
        GuiControl, Calculator:, ResultText, %expression% = %result_formatted%
        GuiControl, Calculator:, Display, %result_formatted%     ;;∙------∙Put result in main display for further calculations.
        ;;∙------∙Prepare & add the history entry.
        history_entry := expression . " = " . result_formatted
        history_param := history_entry
        GoSub, AddToHistory
    }
    
    GuiControl, Calculator:Focus, Display
    SendMessage, 0xB1, -1, -1, Edit1, Just A Calculator
Return

;;∙------∙Clears "Error" text from the display & result area (triggered by the timer set in Equals).
ClearError:
    GuiControlGet, current, Calculator:, Display
    if (current = "Error")
        GuiControl, Calculator:, Display, 0
    GuiControl, Calculator:, ResultText, 
Return

;;∙------∙Calculates square root of current display value.
FuncSqrt:
    GuiControlGet, current, Calculator:, Display
    if (current = "Error")
        current := "0"
    result := Sqrt(current)
    result_formatted := FormatNumber(result)
    GuiControl, Calculator:, ResultText, √%current% = %result_formatted%
    GuiControl, Calculator:, Display, %result_formatted%
    history_param := "√" . current . " = " . result_formatted
    GoSub, AddToHistory
    GuiControl, Calculator:Focus, Display
    SendMessage, 0xB1, -1, -1, Edit1, Just A Calculator
Return

;;∙------∙Divides current display value by 100.
FuncPercent:
    GuiControlGet, current, Calculator:, Display
    if (current = "Error")
        current := "0"
    result := current / 100
    result_formatted := FormatNumber(result)
    GuiControl, Calculator:, ResultText, %current%`% = %result_formatted%
    GuiControl, Calculator:, Display, %result_formatted%
    history_param := current . "% = " . result_formatted
    GoSub, AddToHistory
    GuiControl, Calculator:Focus, Display
    SendMessage, 0xB1, -1, -1, Edit1, Just A Calculator
Return

;;∙------∙Negates (changes the sign of) current display value.
FuncPlusMinus:
    GuiControlGet, current, Calculator:, Display
    if (current = "Error")
        current := "0"
    result := -current
    result_formatted := FormatNumber(result)
    GuiControl, Calculator:, ResultText, ±%current% = %result_formatted%
    GuiControl, Calculator:, Display, %result_formatted%
    history_param := "±" . current . " = " . result_formatted
    GoSub, AddToHistory
    GuiControl, Calculator:Focus, Display
    SendMessage, 0xB1, -1, -1, Edit1, Just A Calculator
Return

;;∙------∙Raises current display value to the power of 1/3 (cube root).
FuncCubeRoot:
    GuiControlGet, current, Calculator:, Display
    if (current = "Error")
        current := "0"
    result := current ** (1/3)
    result_formatted := FormatNumber(result)
    GuiControl, Calculator:, ResultText, ∛%current% = %result_formatted%
    GuiControl, Calculator:, Display, %result_formatted%
    history_param := "∛" . current . " = " . result_formatted
    GoSub, AddToHistory
    GuiControl, Calculator:Focus, Display
    SendMessage, 0xB1, -1, -1, Edit1, Just A Calculator
Return

;;∙------∙Squares the current display value.
FuncSquared:
    GuiControlGet, current, Calculator:, Display
    if (current = "Error")
        current := "0"
    result := current ** 2
    result_formatted := FormatNumber(result)
    GuiControl, Calculator:, ResultText, %current%² = %result_formatted%
    GuiControl, Calculator:, Display, %result_formatted%
    history_param := current . "² = " . result_formatted
    GoSub, AddToHistory
    GuiControl, Calculator:Focus, Display
    SendMessage, 0xB1, -1, -1, Edit1, Just A Calculator
Return

;;∙------∙Copies calculation result to clipboard. If Ctrl is held, copies entire equation.
CopyResult:
    GuiControlGet, result_text, Calculator:, ResultText
    if (result_text != "")
    {
        ;;∙------∙Check if Ctrl key is currently held down.
        GetKeyState, ctrl_state, Ctrl, P
        
        if (ctrl_state = "D")    ;;∙------∙Ctrl key is down.
        {
            ;;∙------∙Copy entire equation (e.g., "2+2 = 4").
            Clipboard := result_text
        }
        else
        {
            ;;∙------∙ Extract just the result after the equals sign.
            if (InStr(result_text, "="))
            {
                StringSplit, parts, result_text, =
                result_value := Trim(parts2)
                Clipboard := result_value
            }
            else
            {
                Clipboard := result_text    ;;∙------∙Fallback if no '=' is found.
            }
        }
        
        ;;∙------∙ Visual feedback: briefly change color of the result text.
        Gui, Calculator:Font, s10 c%calc_result_copy_color% Norm Italic
        GuiControl, Calculator:Font, ResultText
        GuiControl, Calculator:, ResultText, %result_text%

        ;;∙------∙Set timer to restore original color.
        SetTimer, RestoreResultColor, -400
    }
Return

;;∙------∙Restores result text's original color after "copied" visual feedback.
RestoreResultColor:
    GuiControlGet, result_text, Calculator:, ResultText
    Gui, Calculator:Font, s10 c%calc_result_color% Norm Italic
    GuiControl, Calculator:Font, ResultText
    GuiControl, Calculator:, ResultText, %result_text%
Return

;;∙------∙Clears memory storage (sets memory to 0) & hides memory indicator.
MemClear:
    memory := 0
    GuiControl, Calculator:, MemIndicator, 
Return

;;∙------∙Purpose: Recalls value stored in memory & displays it.
MemRecall:
    GuiControl, Calculator:, Display, %memory%
    GuiControl, Calculator:Focus, Display
    SendMessage, 0xB1, -1, -1, Edit1, Just A Calculator
Return

    MemAdd:
    GuiControlGet, current, Calculator:, Display
    if (current = "Error")
        current := "0"
    memory += current
    ;;∙------∙Update memory indicator (show a dot if memory is not zero).
    if (memory != 0)
        GuiControl, Calculator:, MemIndicator, •
    else
        GuiControl, Calculator:, MemIndicator, 
Return

;;∙------∙Subtracts current display value from value stored in memory.
MemSub:
    GuiControlGet, current, Calculator:, Display
    if (current = "Error")
        current := "0"
    memory -= current
    ;;∙------∙Update memory indicator.
    if (memory != 0)
        GuiControl, Calculator:, MemIndicator, •
    else
        GuiControl, Calculator:, MemIndicator, 
Return

;;∙------∙Stores current display value into memory.
MemStore:
    GuiControlGet, current, Calculator:, Display
    if (current = "Error")
        current := "0"
    memory := current
    ;;∙------∙Update memory indicator.
    if (memory != 0)
        GuiControl, Calculator:, MemIndicator, •
    else
        GuiControl, Calculator:, MemIndicator, 
Return

;;∙=============================================∙
;;∙======∙HISTORY WINDOW∙=====================∙
    ;;∙------∙Displays a separate GUI window that lists the calculation history.
ShowHistory:
    Gui, History:Destroy    ;;∙------∙Destroy any existing history window to refresh it.
    Gui, History:New, +AlwaysOnTop +ToolWindow -Caption +Border
    Gui, History:Color, % Color(calc_bg_color, "GUI0x")    ;;∙------∙Match main window's background.
    textColorHex := Color(calc_text_color, "GUI0x")
    Gui, History:Font, s10 c%textColorHex%, %calc_font%
    
    ;;∙------∙ Build pipe-separated ("|") string of history entries for the ListBox control.
    history_text := ""
    for index, entry in history
    {
        if (history_text = "")
            history_text := entry
        else
            history_text := history_text . "|" . entry
    }
    if (history_text = "")
        history_text := "No history at this time."    ;;∙------∙Placeholder if history is empty.
    
    ;;∙------∙Add ListBox control to display history entries.
    Gui, History:Add, ListBox, x10 y10 w280 h150 vHistoryList gHistorySelect, %history_text%
    
    ;;∙------∙Add action buttons.
    Gui, History:Font, s8 c%textColorHex% Bold, %calc_font%
    Gui, History:Add, Button, x10 y170 w90 h25 gClearHistory, Clear All
    Gui, History:Add, Button, x110 y170 w90 h25 gCloseHistory, Close
    Gui, History:Add, Button, x210 y170 w80 h25 gUseSelected, Use
    
    ;;∙------∙Disable main calculator window while history window is open.
    Gui, Calculator:+Disabled
    Gui, History:Show, w300 h205, Calculation History
Return

;;∙------∙Handles selection changes in history ListBox. Currently just retrieves the selection.
HistorySelect:
    GuiControlGet, selected, History:, HistoryList
Return

;;∙------∙Takes currently selected history entry, extracts expression part, & places it into calculator's display.
UseSelected:
    GuiControlGet, selected, History:, HistoryList
    if (selected && selected != "No history yet.")
    {
        ;;∙------∙Split the selected string by " = " to get expression part.
        StringSplit, parts, selected, %A_Space%=%A_Space%
        if (parts1 != "")
        {
            GuiControl, Calculator:, Display, %parts1%    ;;∙------∙Set display to the expression.
            GuiControl, Calculator:Focus, Display
            SendMessage, 0xB1, -1, -1, Edit1, Just A Calculator
        }
    }
    GoSub, CloseHistory    ;;∙------∙Close history window.
Return

;;∙------∙Prompts user for confirmation & if confirmed, clears all history entries.
ClearHistory:
    MsgBox, 4148, Clear History, Are you sure you want to clear all calculation history?
    IfMsgBox, Yes
    {
        history := Object()    ;;∙------∙Reset history to an empty object.
        GoSub, SaveHistory    ;;∙------∙Save the empty state to INI file.
        GoSub, ShowHistory    ;;∙------∙Refresh history window to show it's empty.
    }
Return

;;∙------∙Closes history window & re-enables main calculator window.
CloseHistory:
    Gui, History:Destroy
    Gui, Calculator:-Disabled    ;;∙------∙Re-enable main calculator GUI.
    GuiControl, Calculator:Focus, Display    ;;∙------∙Set focus back to main display.
Return

;;∙=============================================∙
;;∙======∙BARLINE∙==============================∙
;;∙------∙Helper function to easily add a colored line (using a Progress control) to a GUI.
;;∙------∙Format: barLine("Calculator", X, Y, Width, Height, "Color")

barLine(GuiName, X, Y, W, H, Color1 := "Black") 
{
    Gui, %GuiName%:Add, Progress, x%X% y%Y% w%W% h%H% Background%Color1%
}

;;∙=============================================∙
;;∙======∙BOXLINE∙==============================∙
;;∙------∙Function to draw a rectangular box using four Progress controls (one for each side).
;;∙------∙Format: boxline("Calculator", X, Y, Width, Height, ColorTop, ColorBottom, ColorLeft, ColorRight, Thickness)

boxline(GuiName, X, Y, W, H, ColorTop := "Black", ColorBottom := "Black", ColorLeft := "Black", ColorRight := "Black", Thickness := 1)
{	
    ;;∙------∙Calculate starting positions for bottom & right edges based on thickness.
    BottomY := Y + H - Thickness
    RightX := X + W - Thickness
    
    ;;∙------∙Draw top edge.
    Gui, %GuiName%:Add, Progress, x%X% y%Y% w%W% h%Thickness% Background%ColorTop%
    ;;∙------∙Draw bottom edge.
    Gui, %GuiName%:Add, Progress, x%X% y%BottomY% w%W% h%Thickness% Background%ColorBottom%
    ;;∙------∙Draw left edge.
    Gui, %GuiName%:Add, Progress, x%X% y%Y% w%Thickness% h%H% Background%ColorLeft%
    ;;∙------∙Draw right edge.
    Gui, %GuiName%:Add, Progress, x%RightX% y%Y% w%Thickness% h%H% Background%ColorRight%
}

;;∙=============================================∙
;;∙======∙HOTKEYS∙==============================∙
;;∙------∙Toggles visibility of the calculator window (creates it if it doesn't exist).
F1::    ;;∙------∙🔥∙(Ctrl + Alt + C) - Show/Hide Calculator
    if WinExist("A Calculator")
    {
        if WinActive("A Calculator")
            Gui, Calculator:Hide    ;;∙------∙Hide if it's currently active.
        else
        {
            Gui, Calculator:Show    ;;∙------∙Show if it exists but is hidden or inactive.
            GuiControl, Calculator:Focus, Display    ;;∙------∙Focus display.
        }
    }
    else
        GoSub, CreateCalculator    ;;∙------∙Create calculator if it hasn't been created yet.
Return

;;∙------∙Shows calculation history window.
F2::    ;;∙------∙🔥∙(Ctrl + Alt + H) - Show History
    GoSub, ShowHistory
Return

;;∙------∙Opens simple input Gui for a quick calculation, shows result in a tooltip, & saves it to history.
F3::     ;;∙------∙🔥∙(Win + C) - Quick calculation
    GoSub, ShowQuickCalc
Return

;;∙------∙Creates & displays the Quick Calculator input Gui.
ShowQuickCalc:
    Gui, QuickCalc:Destroy
    Gui, QuickCalc:New, +AlwaysOnTop +ToolWindow -Caption +Border
    Gui, QuickCalc:Color, % Color(calc_bg_color, "GUI0x")

    ;;∙------∙Label.
    textColorHex := Color(calc_display_color, "GUI0x")
    Gui, QuickCalc:Font, s9 c%textColorHex% Bold, %calc_font%
    Gui, QuickCalc:Add, Text, x10 y12 w200, Enter expression:

    ;;∙------∙Input Edit control.
    displayColorHex := Color(calc_display_color, "GUI0x")
    Gui, QuickCalc:Font, s%calc_font_size% c%displayColorHex%, %calc_font%
    Gui, QuickCalc:Add, Edit, x10 y30 w230 h34 vQuickExpr,

    ;;∙------∙OK & Cancel buttons.
    Gui, QuickCalc:Font, s8 c%textColorHex% Bold, %calc_font%
    Gui, QuickCalc:Add, Button, x10 y74 w110 h25 gQuickCalcOK, OK
    Gui, QuickCalc:Add, Button, x130 y74 w110 h25 gQuickCalcCancel, Cancel

    ;;∙------∙Divider bar between main buttons & function buttons.
    gridColorBGedge := Color(calc_gridEdge_color, "Background")
    barLine("QuickCalc", 6, 108, 238, 2, gridColorBGedge)

    ;;∙------∙Function buttons row 1: sqrt, %, ±, ^½, ^⅓
    Gui, QuickCalc:Font, s7 c%textColorHex% Bold, %calc_font%
    Gui, QuickCalc:Add, Button, x10  y115 w42 h22 gQC_Sqrt,    sqrt
    Gui, QuickCalc:Add, Button, x57  y115 w42 h22 gQC_Percent,  `%
    Gui, QuickCalc:Add, Button, x104 y115 w42 h22 gQC_PlusMinus, ±
    Gui, QuickCalc:Add, Button, x151 y115 w42 h22 gQC_CubeRoot, ^⅓
    Gui, QuickCalc:Add, Button, x198 y115 w42 h22 gQC_Squared,  x²

    ;;∙------∙Window border (matches main calculator style).
    borderColorBG := Color(calc_border_color, "Background")
    boxline("QuickCalc", 0, 0, 250, 147, borderColorBG, borderColorBG, borderColorBG, borderColorBG, 2)

    ;;∙------∙Disable main calculator window while quick calc is open.
    Gui, Calculator:+Disabled
    Gui, QuickCalc:Show, w250 h147, Just A Quick Calculator

    ;;∙------∙Set keyboard hotkeys while QuickCalc window is active.
    Hotkey, IfWinActive, Just A Quick Calculator
    Hotkey, ~Enter,       QuickCalcOK
    Hotkey, ~NumpadEnter, QuickCalcOK
    Hotkey, ~Escape,      QuickCalcCancel
    Hotkey, IfWinActive
Return

;;∙------∙Evaluates expression entered in QuickCalc Gui, shows tooltip result, & saves to history.
QuickCalcOK:
    GuiControlGet, quick_expr, QuickCalc:, QuickExpr
    GoSub, QuickCalcClose
    if (quick_expr != "")
    {
        result := EvaluateExpression(quick_expr)
        if (result = "ERROR")
            Tooltip, Error: Invalid expression
        else
        {
            result_formatted := FormatNumber(result)
            Tooltip, %quick_expr% = %result_formatted%
            history_param := quick_expr . " = " . result_formatted
            GoSub, AddToHistory
        }
        SetTimer, RemoveTooltip, -2000
    }
Return

;;∙------∙Appends sqrt(...) wrapper around current expression in the input field.
QC_Sqrt:
    GuiControlGet, quick_expr, QuickCalc:, QuickExpr
    if (quick_expr = "")
        quick_expr := "0"
    GuiControl, QuickCalc:, QuickExpr, % "(" . quick_expr . ")^0.5"
Return

;;∙------∙Appends /100 to current expression to calculate percentage.
QC_Percent:
    GuiControlGet, quick_expr, QuickCalc:, QuickExpr
    if (quick_expr = "")
        quick_expr := "0"
    GuiControl, QuickCalc:, QuickExpr, % "(" . quick_expr . ")/100"
Return

;;∙------∙Wraps current expression in negation.
QC_PlusMinus:
    GuiControlGet, quick_expr, QuickCalc:, QuickExpr
    if (quick_expr = "")
        quick_expr := "0"
    ;;∙------∙If already negated, remove the negation; otherwise wrap in -(...)
    if (SubStr(quick_expr, 1, 2) = "-(")
        GuiControl, QuickCalc:, QuickExpr, % SubStr(quick_expr, 3, StrLen(quick_expr) - 3)
    else
        GuiControl, QuickCalc:, QuickExpr, % "-(" . quick_expr . ")"
Return

;;∙------∙Appends cube root exponent to current expression.
QC_CubeRoot:
    GuiControlGet, quick_expr, QuickCalc:, QuickExpr
    if (quick_expr = "")
        quick_expr := "0"
    GuiControl, QuickCalc:, QuickExpr, % "(" . quick_expr . ")^(1/3)"
Return

;;∙------∙Squares the current expression.
QC_Squared:
    GuiControlGet, quick_expr, QuickCalc:, QuickExpr
    if (quick_expr = "")
        quick_expr := "0"
    GuiControl, QuickCalc:, QuickExpr, % "(" . quick_expr . ")^2"
Return

;;∙------∙Closes QuickCalc Gui & re-enables main calculator window.
QuickCalcCancel:
    GoSub, QuickCalcClose
Return

;;∙------∙Shared cleanup: destroys QuickCalc Gui & restores calculator focus.
QuickCalcClose:
    Gui, QuickCalc:Destroy
    Gui, Calculator:-Disabled
    GuiControl, Calculator:Focus, Display
Return

RemoveTooltip:
    Tooltip
Return

;;∙=============================================∙
;;∙======∙GUI DRAG∙=============================∙
;;∙------∙Allows user to drag Gui window by clicking on it.
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}
Return

;;∙=============================================∙
;;∙======∙COLOR CONVERTER∙======================∙
;;∙------∙Converts a color name (like "Navy") or a 6-digit hex code into a format usable by AHK Gui commands.
Color(ColorName, Format := "GUI") {
    ;;∙------∙Static associative array mapping color names to hex values.
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
        colorMap["Grey"] := colorMap["Gray"]    ;;∙------∙Aliases.
        colorMap["Cyan"] := colorMap["Aqua"]
        colorMap["Magenta"] := colorMap["Fuchsia"]
    }
    ColorName := Trim(ColorName)
    ;;∙------∙Check if input is already a 6-digit hex code (with or without "0x" prefix).
    if (RegExMatch(ColorName, "^(0x)?[0-9A-Fa-f]{6}$")) {
        hex := RegExReplace(ColorName, "^(0x)", "")    ;;∙------∙Remove "0x" prefix if present.
    } else {
        hex := colorMap[ColorName]    ;;∙------∙Look up color in the map.
        if (hex = "")
            hex := "FFFFFF"    ;;∙------∙Default to white if color name is not found.
    }
    ;;∙------∙Return hex string in requested format.
    if (Format = "GUI")
        return hex
    else if (Format = "Background")
        return hex
    else if (Format = "GUI0x")
        return "0x" . hex
}

;;∙=============================================∙
;;∙======∙TRAY MENU∙============================∙
;;∙------∙Custom menu for the script's icon in the system tray.
TrayMenu:
Menu, Tray, Tip, %ScriptID%
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Show Calculator, CreateCalculator
Menu, Tray, Icon, Show Calculator, shell32.dll, 246
Menu, Tray, Default, Show Calculator
Menu, Tray, Add
Menu, Tray, Add, Show History, ShowHistory
Menu, Tray, Icon, Show History, shell32.dll, 239
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
Menu, Tray, Add
Return
;;∙------------------------∙
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

;;∙=============================================∙
;;∙======∙TRAY MENU POSITIONING∙================∙
;;∙------∙Handles right-click events on tray icon to position menu near the mouse.
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    ;;∙------∙Show tray menu near the mouse, offset slightly to the top-left.
    Menu, Tray, Show, % mx - 20, % my - 20
Return

NotifyTrayClick(P*) { 
Static Msg, Fun:="NotifyTrayClick", NM:=OnMessage(0x404,Func(Fun),-1),  Chk,T:=-250,Clk:=1
  If ( (NM := Format(Fun . "_{:03X}", Msg := P[2])) && P.Count()<4 )
     return ( T := Max(-5000, 0-(P[1] ? Abs(P[1]) : 250)) )
  Critical
  If ( ( Msg<0x201 || Msg>0x209 ) || ( IsFunc(NM) || Islabel(NM) )=0 )
     return
  Chk := (Fun . "_" . (Msg<=0x203 ? "203" : Msg<=0x206 ? "206" : Msg<=0x209 ? "209" : ""))
  SetTimer, %NM%,  %  (Msg==0x203        || Msg==0x206        || Msg==0x209)
    ? (-1, Clk:=2) : ( Clk=2 ? ("Off", Clk:=1) : ( IsFunc(Chk) || IsLabel(Chk) ? T : -1) )
return True
}
Return

;;∙=============================================∙
;;∙======∙RELOAD UPON SCRIPT SAVE∙==============∙
;;∙------∙Monitors script file for changes, automatically reloads.
UpdateCheck:
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        return
    Soundbeep, 1700, 100
Reload

;;∙=============================================∙
;;∙======∙EDIT / RELOAD / EXIT∙=================∙
Script·Edit:
    Edit
Return
;;∙------------------------∙
^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)
    Script·Reload:
        Soundbeep, 1200, 250
    Reload
Return
;;∙------------------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)
    Script·Exit:
        GoSub, SaveHistory
        Soundbeep, 1000, 300
    ExitApp ; Terminate the script.
Return

;;∙=============================================∙
;;∙========================∙SCRIPT END∙=========================∙
;;∙------------------------------------------------------------------------------------------∙