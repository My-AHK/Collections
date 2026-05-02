;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙

;;∙================================================∙
;;∙======∙DIRECTIVES & SETTINGS∙====================∙
#Requires AutoHotkey 1
#NoEnv
#SingleInstance, Force
#Persistent
SetBatchLines, -1
SetWinDelay, 0
SetWorkingDir, %A_ScriptDir%
SetTimer, UpdateCheck, 500

;;∙================================================∙
;;∙======∙CUSTOMIZATION VARIABLES∙================∙
/*
• Extensive Color Table & Hex Code (6-digit hex or with 0x prefix) Support.
    » Supported Color Names:
    ▹ Grayscales: Black, Gray/Grey, Silver, White
    ▹ Reds:  Maroon, Red, Magenta-Red, Rose
    ▹ Pinks:  Salmon, Light Salmon, Coral, Hot Pink, Deep Pink, Rose Pink, Pink
    ▹ Oranges:  Red-Orange, Orange, Yellow-Red, Yellow-Orange
    ▹ Yellows:  Yellow, Chartreuse
    ▹ Greens:  Olive, Green, Lime, Spring Green, Cyan-Green
    ▹ Cyans:  Teal, Aqua/Cyan, Azure
    ▹ Blues:  Blue, Navy
    ▹ Violets:  Indigo, Violet, Purple
    ▹ Magenta:  Magenta/Fuchsia
*/

;;∙------∙Window Settings∙-------------------------------------------∙
defaultOrientation := "Horizontal"    ;;∙------∙
iconThemeColor := "0"    ;;∙------∙0 = white icon, 1 = black icon (Transparency & Orientation buttons).
rulerLength := 800    ;;∙------∙
rulerThickness := 70    ;;∙------∙
windowTransparency := 255    ;;∙------∙
transparencyLevel := 150    ;;∙------∙Transparency level when toggled on (0-254).
rulerOnTop := true    ;;∙------∙
guiX := 100    ;;∙------∙
guiY := 100    ;;∙------∙
pixelsPerInch := 96  	;;∙------∙1 inch...
    		;;∙------∙ = 96 pixels (typical screen assumption).
    		;;∙------∙ = 300 pixels (typical print quality).

;;∙------∙Colors & Appearance∙--------------------------------------∙
gBackground := "Black"    ;;∙------∙
outerBorder := "Magenta"    ;;∙------∙
tickColor := "Yellow"    ;;∙------∙
tickLabelColor := "Aqua"    ;;∙------∙
measureTextColor := "Lime"    ;;∙------∙
titleBarColor := "Azure"    ;;∙------∙
rulerOutlineColor := "Orange"    ;;∙------∙

;;∙================================================∙
;;∙======∙GLOBAL VARIABLES∙========================∙
ScriptID := "Desktop_Ruler"    ;;∙------∙
orientation := defaultOrientation
isMeasuring := false
measureStartX := 0
measureStartY := 0
measureEndX := 0
measureEndY := 0
measureClickCount := 0
measureModeActive := false    ;;∙------∙Tracks if Ctrl+Alt+M has been pressed.

;;∙================================================∙
;;∙======∙TRAY ICON & DRAG∙========================∙
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")
Menu, Tray, Icon, imageres.dll, 188
GoSub, TrayMenu
GoSub, BuildRulerGUI
Return

;;∙================================================∙
;;∙======∙HOTKEYS∙=================================∙
^!c::    ;;∙------∙🔥∙(Ctrl+Alt+C)
    GoSub, CopyMeasurement
Return
^!o::    ;;∙------∙🔥∙(Ctrl+Alt+O)
    GoSub, ToggleOrientation
Return
^!t::    ;;∙------∙🔥∙(Ctrl+Alt+T)
    GoSub, ToggleTransparency
Return
^!m::    ;;∙------∙🔥∙(Ctrl+Alt+M)
    GoSub, ActivateMeasuring
Return
^!LButton::    ;;∙------∙🔥∙(Ctrl+Alt+LButton)
    GoSub, SetMeasurePoint
Return
Esc::    ;;∙------∙🔥∙(Ctrl+Alt+C)
    GoSub, ClearMeasurement
Return

;;∙================================================∙
;;∙======∙GUI BUILD∙================================∙
BuildRulerGUI:
    GuiTip(0)    ;;∙------∙Reset tooltip control for new GUI
    Gui, Ruler:Destroy
    Gui, Ruler:New
    Gui, Ruler:+AlwaysOnTop -Caption +ToolWindow +E0x02000000 +E0x00080000
    Gui, Ruler:Margin, 0, 0
    Gui, Ruler:Color, % Color(gBackground, "GUI0x")
    Gui, Ruler:Font, s10 Q5, Segoe UI
    
    If (orientation = "Horizontal") {
        winW := rulerLength + 70
        winH := rulerThickness + 70
        rulerStartX := 35
        rulerStartY := 55
        rulerW := rulerLength + 1
        rulerH := rulerThickness
    } Else {
        winW := rulerThickness + 70
        winH := rulerLength + 70
        rulerStartX := 60
        rulerStartY := 50
        rulerW := rulerThickness
        rulerH := rulerLength + 1
    }
    guiW := winW
    guiH := winH
    
    ;;∙------∙Outer Border.
    outerBorderHex := Color(outerBorder, "GUI")
    boxline("Ruler", 0, 0, winW, winH, outerBorderHex, outerBorderHex, outerBorderHex, outerBorderHex, 2)
    
    ;;∙------∙Main Ruler Outline (1px outline).
    rulerBarHex := Color(rulerOutlineColor, "GUI")
    boxline("Ruler", rulerStartX, rulerStartY, rulerW, rulerH, rulerBarHex, rulerBarHex, rulerBarHex, rulerBarHex, 1)
    
    ;;∙------∙Tick Marks.
    tickHex := Color(tickColor, "GUI")
    labelHex := Color(tickLabelColor, "GUI0x")
    
    If (orientation = "Horizontal") {
        totalLength := rulerLength
        Loop, % (totalLength // 10) + 1 {
            pos := (A_Index - 1) * 10
            tickX := rulerStartX + pos
            If (Mod(pos, 50) = 0) {
                tickH := 20
                If (pos <= totalLength) {
                    barLine("Ruler", tickX, rulerStartY + rulerThickness - tickH, 1, tickH, tickHex)  ; Bottom tick
                    barLine("Ruler", tickX, rulerStartY, 1, tickH, tickHex)  ; Top tick
                    Gui, Ruler:Font, s7 c%labelHex% Q5 Norm, Segoe UI
                    Gui, Ruler:Add, Text, % "x" (tickX - 15) " y" (rulerStartY + 25) " w30 h15 Center BackgroundTrans", % pos
                }
            } Else {
                tickH := 10
                If (pos <= totalLength) {
                    barLine("Ruler", tickX, rulerStartY + rulerThickness - tickH, 1, tickH, tickHex)  ; Bottom tick
                    barLine("Ruler", tickX, rulerStartY, 1, tickH, tickHex)  ; Top tick
                }
            }
        }
    } Else {
        totalLength := rulerLength
        Loop, % (totalLength // 10) + 1 {
            pos := (A_Index - 1) * 10
            tickY := rulerStartY + pos
            If (Mod(pos, 50) = 0) {
                tickW := 20
                If (pos <= totalLength) {
                    barLine("Ruler", rulerStartX + rulerThickness - tickW, tickY, tickW, 1, tickHex)  ; Right tick
                    barLine("Ruler", rulerStartX, tickY, tickW, 1, tickHex)  ; Left tick
                    Gui, Ruler:Font, s7 c%labelHex% Q5 Norm, Segoe UI
                    Gui, Ruler:Add, Text, % "x" (rulerStartX - 2) " y" (tickY - 8) " w45 h15 Right BackgroundTrans", % pos
                }
            } Else {
                tickW := 10
                If (pos <= totalLength) {
                    barLine("Ruler", rulerStartX + rulerThickness - tickW, tickY, tickW, 1, tickHex)  ; Right tick
                    barLine("Ruler", rulerStartX, tickY, tickW, 1, tickHex)  ; Left tick
                }
            }
        }
    }
    
    ;;∙------∙Title Bar.
    titleColorHex := Color(titleBarColor, "GUI0x")
    If (orientation = "Horizontal") {
        Gui, Ruler:Font, s12 c%titleColorHex% Q5 Norm, Arial
        Gui, Ruler:Add, Text, x35 y8 w%winW% h20 Left BackgroundTrans,   Desktop Ruler - %orientation% Mode (%rulerLength%px)
    } Else {
        Gui, Ruler:Font, s9 c%titleColorHex% Q5 Norm, Arial
        Gui, Ruler:Add, Text, x7 y45 w60 h80 Left BackgroundTrans, Desktop`n  Ruler`nVertical`n  Mode`n(%rulerLength%px)
    }

    ;;∙------∙Close Button.
    XguiW := (winW - 30)
    Gui, Ruler:Add, Picture, x%XguiW% y10 w16 h16 Icon277 HwndhText gCloseRuler BackgroundTrans, imageres.dll
        GuiTip(hText, " Close ")

    ;;∙------∙Hide Button.
    X2guiW := (XguiW - 25)
    Gui, Ruler:Add, Picture, x%X2guiW% y10 w18 h18 Icon248 HwndhText gMinimizeRuler BackgroundTrans, shell32.dll
        GuiTip(hText, " Hide ")

    ;;∙------∙Orientation Toggle Button.
    X3guiW := (X2guiW - 25)
    orientationIcon := 326
    If (iconThemeColor = "0")
        orientationIcon := 324
    Gui, Ruler:Add, Picture, x%X3guiW% y10 w16 h16 Icon%orientationIcon% HwndhText gToggleOrientation BackgroundTrans, imageres.dll
        GuiTip(hText, " Orientation ")


    ;;∙------∙Transparency Button.
    X4guiW := (X3guiW - 25)
    transparencyIcon := 333  ; Default to black (333)
    If (iconThemeColor = "0")
        transparencyIcon := 332  ; White icon
    Gui, Ruler:Add, Picture, x%X4guiW% y10 w16 h16 Icon%transparencyIcon% HwndhText gToggleTransparency BackgroundTrans, imageres.dll
        GuiTip(hText, " Transparency ")



    ;;∙------∙Measurement Display.
    measureTextColorHex := Color(measureTextColor, "GUI0x")
    If (orientation = "Horizontal") {
        Gui, Ruler:Font, s10 c%measureTextColorHex% Q5 Norm, Segoe UI
        Gui, Ruler:Add, Text, x35 y30 w400 h20 vMeasureDisplay BackgroundTrans, % GetInitialDisplayText()
    } Else {
        Gui, Ruler:Font, s8 c%measureTextColorHex% Q5 Norm, Segoe UI
        Gui, Ruler:Add, Text, x7 y130 w60 h80 vMeasureDisplay Left BackgroundTrans, % GetInitialDisplayText()
    }

    Gui, Ruler:Show, x%guiX% y%guiY% w%winW% h%winH%, %ScriptID%

    If (windowTransparency < 255) {
        WinGet, hwnd, ID, %ScriptID%
        WinSet, Transparent, %windowTransparency%, ahk_id %hwnd%
    }
Return

;;∙================================================∙
;;∙======∙DISPLAY TEXT MANAGEMENT∙=================∙
GetInitialDisplayText() {
    global orientation
    If (orientation = "Horizontal")
        Return "Press (Ctrl+Alt+M) to measure"
    Else
        Return "Press`nCtrl+Alt`n+M`nTo`nMeasure"
}

UpdateMeasureDisplayText(state) {
    global orientation, measureClickCount, measureModeActive
    If (state = "idle") {
        If (orientation = "Horizontal")
            GuiControl, Ruler:, MeasureDisplay, Press (Ctrl+Alt+M) to measure
        Else
            GuiControl, Ruler:, MeasureDisplay, Press`nCtrl+Alt`n+M`nTo`nMeasure
    }
    Else If (state = "awaiting_start") {
        If (orientation = "Horizontal")
            GuiControl, Ruler:, MeasureDisplay, Press (Ctrl+Alt+LClick) to start measure
        Else
            GuiControl, Ruler:, MeasureDisplay, Press`nCtrl+Alt`n+LClick`nto start`nmeasure
    }
    Else If (state = "awaiting_stop") {
        If (orientation = "Horizontal")
            GuiControl, Ruler:, MeasureDisplay, Press (Ctrl+Alt+LClick) to stop measure
        Else
            GuiControl, Ruler:, MeasureDisplay, Press`nCtrl+Alt`n+LClick`nto stop`nmeasure
    }
}

;;∙================================================∙
;;∙======∙MEASUREMENT LOGIC∙=======================∙
ActivateMeasuring:
    measureModeActive := true
    measureClickCount := 0
    UpdateMeasureDisplayText("awaiting_start")
    ToolTip, Measuring mode active. Press Ctrl+Alt+LClick to set start point.
    SetTimer, RemoveToolTip, -2500
Return

SetMeasurePoint:
    If (!measureModeActive) {
        ToolTip, Press Ctrl+Alt+M first to activate measuring mode.
        SetTimer, RemoveToolTip, -2500
        Return
    }
    
    If (measureClickCount = 0) {
        MouseGetPos, clickX, clickY
        measureStartX := clickX
        measureStartY := clickY
        measureClickCount := 1
        UpdateMeasureDisplayText("awaiting_stop")
        SetTimer, LiveAngleTooltip, 50    ;;∙------∙Start live angle tooltip updates.
    } Else If (measureClickCount = 1) {
        MouseGetPos, clickX, clickY
        measureEndX := clickX
        measureEndY := clickY
        measureClickCount := 2
        
        SetTimer, LiveAngleTooltip, Off    ;;∙------∙Stop live angle tooltip.
        ToolTip                            ;;∙------∙Clear tooltip.

        dx := measureEndX - measureStartX
        dy := measureEndY - measureStartY
        pixelDist := Sqrt(dx*dx + dy*dy)
        
        inchDist := pixelDist / pixelsPerInch
        cmDist := inchDist * 2.54
        mmDist := cmDist * 10
        
        ;;∙------∙Angle calculation (0°=right, +up, -down, range -180 to 180).
        If (dx = 0 && dy = 0)
            angleDeg := 0
        Else
            angleDeg := ATan2_Deg(-dy, dx)
        
        If (orientation = "Horizontal") {
            measureStr := "Pixels: " . Round(pixelDist, 1) . "px"
            measureStr .= "  |  " . Format("{:.2f}", inchDist) . " in"
            measureStr .= "  |  " . Format("{:.2f}", cmDist) . " cm"
            measureStr .= "  |  " . Format("{:.1f}", mmDist) . " mm"
            measureStr .= "  |  " . Format("{:.1f}", angleDeg) . "°"
        } Else {
            measureStr := Format("{:.1f}", pixelDist) . "-px"
            measureStr .= "`n" . Format("{:.2f}", inchDist) . "-in"
            measureStr .= "`n" . Format("{:.2f}", cmDist) . "-cm"
            measureStr .= "`n" . Format("{:.1f}", mmDist) . "-mm"
            measureStr .= "`n" . Format("{:.1f}", angleDeg) . "deg"
        }
        GuiControl, Ruler:, MeasureDisplay, %measureStr%
        
        Clipboard := measureStr
        
        ToolTip, Measurement: %measureStr%
        SetTimer, RemoveToolTip, -2500
        
        measureModeActive := false
        measureClickCount := 0
    }
Return

;;∙================================================∙
;;∙======∙LIVE ANGLE TOOLTIP∙======================∙
LiveAngleTooltip:
    MouseGetPos, curX, curY
    dx := curX - measureStartX
    dy := curY - measureStartY
    If (dx = 0 && dy = 0) {
        liveAngle := 0
        livePx := 0
        liveIn := 0
        liveCm := 0
        liveMm := 0
    } Else {
        liveAngle := ATan2_Deg(-dy, dx)
        livePx    := Sqrt(dx*dx + dy*dy)
        liveIn    := livePx / pixelsPerInch
        liveCm    := liveIn * 2.54
        liveMm    := liveCm * 10
    }
    tipText := Format("{:.1f}", liveAngle) . "°"
    tipText .= "`n" . Round(livePx, 1) . " px"
    tipText .= "`n" . Format("{:.2f}", liveIn) . " in"
    tipText .= "`n" . Format("{:.2f}", liveCm) . " cm"
    tipText .= "`n" . Format("{:.1f}", liveMm) . " mm"
    ToolTip, %tipText%, % curX + 20, % curY - 20
Return

;;∙================================================∙
;;∙======∙ATan2 HELPER∙============================∙
ATan2_Deg(y, x) {
    static Pi := 3.14159265358979
    If (x > 0)
        return ATan(y / x) * (180 / Pi)
    Else If (x < 0 && y >= 0)
        return (ATan(y / x) + Pi) * (180 / Pi)
    Else If (x < 0 && y < 0)
        return (ATan(y / x) - Pi) * (180 / Pi)
    Else If (x = 0 && y > 0)
        return 90.0
    Else If (x = 0 && y < 0)
        return -90.0
    Else
        return 0.0
}

;;∙================================================∙
;;∙======∙MODE CONTROLS∙=========================∙
ToggleOrientation:
    orientation := (orientation = "Horizontal") ? "Vertical" : "Horizontal"
    measureModeActive := false
    measureClickCount := 0
    GoSub, BuildRulerGUI
Return

ClearMeasurement:
    measureModeActive := false
    measureClickCount := 0
    UpdateMeasureDisplayText("idle")
Return

CopyMeasurement:
    If (measureClickCount = 2) {
        GuiControlGet, measureText, Ruler:, MeasureDisplay
        Clipboard := measureText
        ToolTip, Measurement copied!
        SetTimer, RemoveToolTip, -1200
    } Else {
        ToolTip, No measurement to copy.
        SetTimer, RemoveToolTip, -1200
    }
Return

RemoveToolTip:
    ToolTip
Return

ToggleTransparency:
    windowTransparency := (windowTransparency = 255) ? transparencyLevel : 255
    WinGet, hwnd, ID, %ScriptID%
    If (windowTransparency = 255)
        WinSet, Transparent, Off, ahk_id %hwnd%
    Else
        WinSet, Transparent, %windowTransparency%, ahk_id %hwnd%
Return

;;∙================================================∙
;;∙======∙WINDOW CONTROLS∙=======================∙
WM_LBUTTONDOWNdrag() {
    PostMessage, 0x00A1, 2, 0
}
Return

CloseRuler:
RulerGuiClose:
    Soundbeep, 800, 300
    ExitApp
Return

MinimizeRuler:
    GoSub, RestoreRulerWindow
Return

RestoreRulerWindow:
    DetectHiddenWindows, On
    IfWinExist, %ScriptID%
    {
        Winget, winState, Style, %ScriptID%
        If (winState & 0x10000000) {
            Gui, Ruler:Hide
            Menu, Tray, Icon, Show/Hide Ruler, shell32.dll, 247  ; Hidden icon
        } Else {
            Gui, Ruler:Show
            Menu, Tray, Icon, Show/Hide Ruler, shell32.dll, 248  ; Visible icon
        }
    }
    DetectHiddenWindows, Off
Return

;;∙================================================∙
;;∙======∙COLOR CONVERTER∙========================∙
Color(ColorName, Format := "GUI") {
    static colorMap := {}
    if (!colorMap.Count()) {
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
        colorMap["Spring-Green"] := "00FF7F"
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
        colorMap["Grey"] := colorMap["Gray"]
        colorMap["Cyan"] := colorMap["Aqua"]
        colorMap["Magenta"] := colorMap["Fuchsia"]
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
    else if (Format = "GUI0x")
        return "0x" . hex
}

;;∙================================================∙
;;∙======∙BOX & BAR ROUTINES∙======================∙
boxline(GuiName, X, Y, W, H, ColorTop := "Black", ColorBottom := "Black", ColorLeft := "Black", ColorRight := "Black", Thickness := 1)
{	
    BottomY := Y + H - Thickness
    RightX := X + W - Thickness
    Gui, %GuiName%:Add, Progress, x%X% y%Y% w%W% h%Thickness% Background%ColorTop%
    Gui, %GuiName%:Add, Progress, x%X% y%BottomY% w%W% h%Thickness% Background%ColorBottom%
    Gui, %GuiName%:Add, Progress, x%X% y%Y% w%Thickness% h%H% Background%ColorLeft%
    Gui, %GuiName%:Add, Progress, x%RightX% y%Y% w%Thickness% h%H% Background%ColorRight%
}

barLine(GuiName, X, Y, W, H, Color1 := "Black") 
{
    Gui, %GuiName%:Add, Progress, x%X% y%Y% w%W% h%H% Background%Color1%
}

;;∙======∙GuiTip Function∙========================================∙
GuiTip(hCtrl, text:="")
{
    ttMaxWidth := 200
    hGui := text!="" ? DllCall("GetParent", "Ptr", hCtrl) : hCtrl
    static hTip
    if !hTip
    {
        hTip := DllCall("CreateWindowEx", "UInt", 0x8, "Str", "tooltips_class32"
             ,  "Ptr", 0, "UInt", 0x80000002
             ,  "Int", 0x80000000, "Int",  0x80000000, "Int", 0x80000000, "Int", 0x80000000
             ,  "Ptr", hGui, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Ptr")
        DllCall("SendMessage", "Ptr", hTip, "Int", 0x0418, "Ptr", 0, "Ptr", ttMaxWidth)
        if (A_OsVersion == "WIN_XP")
            GuiTip(hGui)
    }
    static sizeof_TOOLINFO := 24 + (6 * A_PtrSize)
    VarSetCapacity(TOOLINFO, sizeof_TOOLINFO, 0)
    , NumPut(sizeof_TOOLINFO, TOOLINFO, 0, "UInt")
    , NumPut(0x11, TOOLINFO, 4, "UInt")
    , NumPut(hGui, TOOLINFO, 8, "Ptr")
    , NumPut(hCtrl, TOOLINFO, 8 + A_PtrSize, "Ptr")
    , NumPut(&text, TOOLINFO, 24 + (3 * A_PtrSize), "Ptr")
    static TTM_ADDTOOL := A_IsUnicode ? 0x0432 : 0x0404
    return DllCall("SendMessage", "Ptr", hTip, "Int", TTM_ADDTOOL, "Ptr", 0, "Ptr", &TOOLINFO)
}
Return

;;∙=============================================∙
;;∙======∙SCRIPT EDIT / RELOAD / EXIT∙=============∙
Script-Edit:
    Edit
Return
;;∙------------------------∙
^Home::     ;;∙------∙🔥∙(Ctrl + (Home*2))
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)
    Script-Reload:
        Reload
Return
;;∙------------------------∙
^Esc::     ;;∙------∙🔥∙(Ctrl + (Esc*2))
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)
    Script-Exit:
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
Menu, Tray, Add, Show/Hide Ruler, RestoreRulerWindow
Menu, Tray, Icon, Show/Hide Ruler, shell32.dll, 248
Menu, Tray, Default, Show/Hide Ruler
Menu, Tray, Add
Menu, Tray, Add, Toggle Orientation, ToggleOrientation
Menu, Tray, Icon, Toggle Orientation, imageres.dll, 326
Menu, Tray, Add
Menu, Tray, Add, Toggle Transparency, ToggleTransparency
Menu, Tray, Icon, Toggle Transparency, imageres.dll, 333
Menu, Tray, Add
Menu, Tray, Add, Copy Measurement, CopyMeasurement
Menu, Tray, Icon, Copy Measurement, imageres.dll, 143
Menu, Tray, Add
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
Menu, Tray, Add, Script Edit, Script-Edit
Menu, Tray, Icon, Script Edit, imageres.dll, 247
Menu, Tray, Add
Menu, Tray, Add, Script Reload, Script-Reload
Menu, Tray, Icon, Script Reload, mmcndmgr.dll, 47
Menu, Tray, Add
Menu, Tray, Add, Script Exit, Script-Exit
Menu, Tray, Icon, Script Exit, shell32.dll, 272
Menu, Tray, Add
Return

;;∙=============================================∙
;;∙======∙TRAY UTILITIES∙=========================∙
Documentation:
    ;;∙------∙Open AutoHotkey help file.
    Run, "C:\Program Files\AutoHotkey\AutoHotkey.chm"
Return
;;∙------------------------∙
ShowKeyHistory:
    ;;∙------∙Display key history window.
    KeyHistory
Return
;;∙------------------------∙
ShowWindowSpy:
    ;;∙------∙Launch Window Spy tool.
    Run, "C:\Program Files\AutoHotkey\WindowSpy.ahk"
Return

;;∙=============================================∙
;;∙========∙TRAY MENU POSITIONING∙=============∙
NotifyTrayClick_205:
    ;;∙------∙Position Tray Menu Near Mouse Cursor.
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20
Return
;;∙------------------------∙
NotifyTrayClick(P*) { 
    ;;∙------∙Tray Click Handler.
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

