
;;∙------------------------------------------------------------------∙


;;∙============================================∙
;;∙======∙DIRECTIVES∙===========================∙
#Requires AutoHotkey 1
#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines -1
SetWinDelay 0
SetTimer, UpdateCheck, 500
Menu, Tray, Icon, imageres.dll, 90
GoSub, TrayMenu

/*∙------------------------------------------------------------------------∙
∙======∙FORMAT - A
;;∙------∙ShowProgress(TargetPercent, TimeToComplete, Title1, titleColor1, pctColor1, Level1, barColor1, Title2, titleColor2, pctColor2, Level2, barColor2, Title3, titleColor3, pctColor3, Level3, barColor3, Title4, titleColor4, pctColor4, Level4, barColor4, boxColor, Width, Height, Mode, X, Y, ParentGui)
∙======∙FORMAT - B (easier to visualize)
ShowProgress(TargetPercent, TimeToComplete := 3000
  	, Title1 := "", titleColor1 := "", pctColor1 := "", Level1 := 25, barColor1 := "Lime"
  	, Title2 := "", titleColor2 := "", pctColor2 := "", Level2 := 50, barColor2 := "Yellow"
  	, Title3 := "", titleColor3 := "", pctColor3 := "", Level3 := 75, barColor3 := "Orange"
  	, Title4 := "", titleColor4 := "", pctColor4 := "", Level4 := 100, barColor4 := "Red"
  	, boxColor := "333333", Width := 400, Height := 40, Mode := 0, X := "", Y := "", ParentGui := "")

∙------------------∙Formatting Explained∙-----------------------------∙
∙----∙Two functions available, both use the same parameter structure shown below. Segment 5 exists only in ShowProgress5().
            ⮚ ShowProgress() for 2-4 segments (e.g., 0-25%, 26-50%, 51-75%, 76-100%)
            ⮚ ShowProgress5() for 2-5 segments.  (e.g., 0-20%, 21-40%, 41-60%, 61-80%, 81-100%)

∙----∙TargetPercent: 0-100 (percentage to reach)
∙----∙TimeToComplete: Duration in ms (0 for manual mode)

∙----∙Title1: 0% - Level1% ("" for none)
∙----∙Title2: >Level1% - Level2% ("" for none)
∙----∙Title3: >Level2% - Level3% ("" for none)
∙----∙Title4: >Level3% - Level4% ("" for none)
∙----∙Title5: >Level4% - Level5% ("" for none)    <==∙ShowProgress5() only.

∙----∙titleColor1: Color for Title1 text ("" to match barColor1)
∙----∙titleColor2: Color for Title2 text ("" to match barColor2)
∙----∙titleColor3: Color for Title3 text ("" to match barColor3)
∙----∙titleColor4: Color for Title4 text ("" to match barColor4)
∙----∙titleColor5: Color for Title5 text ("" to match barColor5)    <==∙ShowProgress5() only.

∙----∙pctColor1: Color for percentage number in segment 1 ("" to match barColor1)
∙----∙pctColor2: Color for percentage number in segment 2 ("" to match barColor2)
∙----∙pctColor3: Color for percentage number in segment 3 ("" to match barColor3)
∙----∙pctColor4: Color for percentage number in segment 4 ("" to match barColor4)
∙----∙pctColor5: Color for percentage number in segment 5 ("" to match barColor5)    <==∙ShowProgress5() only.

∙----∙Level1: Percentage threshold for first color/title (default 25 / 20 in ShowProgress5)
∙----∙Level2: Percentage threshold for second color/title (default 50 / 40 in ShowProgress5)
∙----∙Level3: Percentage threshold for third color/title (default 75 / 60 in ShowProgress5)
∙----∙Level4: Percentage threshold for fourth color/title (default 100 / 80 in ShowProgress5)
∙----∙Level5: Percentage threshold for fifth color/title (default 100)    <==∙ShowProgress5() only.

∙----∙barColor1: 0% - Level1% (hex "RRGGBB" or named color)
∙----∙barColor2: >Level1% - Level2% (hex "RRGGBB" or named color)
∙----∙barColor3: >Level2% - Level3% (hex "RRGGBB" or named color)
∙----∙barColor4: >Level3% - Level4% (hex "RRGGBB" or named color)
∙----∙barColor5: >Level4% - Level5% (hex "RRGGBB" or named color)    <==∙ShowProgress5() only.

∙----∙boxColor: Progress box border color
∙----∙Width: Total width in pixels
∙----∙Height: Total height in pixels

∙----∙Mode: 0=auto animate, 1=manual (returns control object)

∙----∙X: X position (pixels from left, "Center" for screen center, "" for default)
∙----∙Y: Y position (pixels from top, "Center" for screen center, "" for default)

∙----∙ParentGui: Name of parent GUI to embed in ("" for standalone window)
∙---------------------------------------------------------------------------∙
*/

;;∙============================================∙
;;∙======∙HOTKEYS∙=============================∙
;;∙------------------------------------------------------------------∙
;;∙--------∙CTRL + ALT Hotkey (MANUAL MODE)∙----------∙
^!1::    ;;∙------∙🔥∙(Ctrl + Alt + 1)∙🔥∙------∙Manual mode demo. Press hotkey repeatedly to advance bar by %.
    global ManualBar, ManualPercent
    
    if (!ManualBar) {
        ;;∙------∙First press: create the bar.
        ManualBar := ShowProgress(100, 0
            , "Press Alt+7 to advance", "White", "White", 25, "Red"
            , "", "", "", 50, "Orange"
            , "", "", "", 75, "Yellow"
            , "", "", "", 100, "Lime"
            , "White", 400, 50, 1, "Center", "Center")
        ManualPercent := 0
    } else {
        ManualPercent += 5    ;;<<∙------∙Subsequent presses: advance by %.
        if (ManualPercent > 100)
            ManualPercent := 100
        ManualBar.Update(ManualPercent)
        if (ManualPercent >= 100) {
            Sleep, 500
            ManualBar.Destroy()
            ManualBar := ""
            ManualPercent := ""
        }
    }
Return

/*∙-------∙CTRL Hotkeys∙---------------------------------------∙
^1 = 5-segment with single late-appearing title, box centered vertically.
^2 = Full 5-segment with custom colors on everything, narrow height, offset X.
^3 = Escalating warnings (Warning → Critical → ABORT), centered on both axes.
^4 = Save simulation with milestone titles, red-to-green gradient, offset Y.
^5 = Download simulation with silver percentage text, smaller dimensions, custom position.
^6 = Phase-based progress with unique colors per segment, specific coordinates.
∙------------------------------------------------------------------∙
*/

^1::    ;;∙------∙🔥∙(Ctrl + 1)∙🔥∙------∙5-color progress bar (Lime/Yellow/Orange/Red/Purple) shows "Critical!" only at end.
    ShowProgress5(90, 5000 		;;∙------∙Target: 90%, Duration: 5 seconds.
        , "", "", "", 20, "Lime" 		;;∙------∙Segment 1: 0-20% - No title, Lime bar.
        , "", "", "", 40, "Yellow" 		;;∙------∙Segment 2: 21-40% - No title, Yellow bar.
        , "", "", "", 60, "Orange" 		;;∙------∙Segment 3: 41-60% - No title, Orange bar.
        , "", "", "", 80, "Red" 		;;∙------∙Segment 4: 61-80% - No title, Red bar.
        , "Critical!", "", "", 100, "Purple" 	;;∙------∙Segment 5: 81-100% - "Critical!" title, Purple bar.
        , "Orange", 400, 50, 0, "", "Center") 	;;∙------∙Box color: Orange, Width:400, Height:50, Mode:0(auto), X:Default(left edge), Y:Centered.
Return

;;∙------------------------------------------------------------------∙
^2::    ;;∙------∙🔥∙(Ctrl + 2)∙🔥∙------∙Different colors for everything - titles, percentages, and bars all have custom colors.
    ShowProgress5(100, 5000  				;;∙------∙Target: 100%, Duration: 5 seconds.
        , "Start", "FF4444", "Magenta", 20, "Red" 		;;∙------∙0-20%: Red bar, Magenta %, Red title.
        , "Warming", "FFFF00", "Purple", 40, "Yellow" 		;;∙------∙21-40%: Yellow bar, Purple %, Yellow title.
        , "Processing", "00FF00", "Cyan", 60, "Green" 		;;∙------∙41-60%: Green bar, Cyan %, Green title.
        , "Finishing", "FF6600", "Spring-Green", 80, "Orange" 	;;∙------∙61-80%: Orange bar, Spring-Green %, Orange title.
        , "Complete!", "00FFFF", "White", 100, "Lime" 		;;∙------∙81-100%: Lime bar, White %, Cyan title.
        , "Lime", 600, 30, 0, "250") 			;;∙------∙Box: Lime, W:600, H:30, Mode:0, X:250px, Y:Default(top).
Return

;;∙------------------------------------------------------------------∙
^3::    ;;∙------∙🔥∙(Ctrl + 3)∙🔥∙------∙90% in 5s, WARNING at 40%, CRITICAL at 60%, ABORT at 80%.
    ShowProgress5(90, 5000 			;;∙------∙Target: 90%, Duration: 5 seconds.
        , "", "", "", 20, "Green" 			;;∙------∙0-20%: No title, Green bar.
        , "", "", "", 40, "Lime" 			;;∙------∙21-40%: No title, Lime bar.
        , "Warning!", "FFFF00", "Yellow", 60, "Yellow" 	;;∙------∙41-60%: Yellow bar, Yellow %, Yellow title.
        , "Critical!", "FF6600", "Orange", 80, "Orange" 	;;∙------∙61-80%: Orange bar, Orange %, Orange title.
        , "ABORT!", "FF0000", "Red", 100, "DarkRed" 	;;∙------∙81-100%: DarkRed bar, Red %, Red title.
        , "Violet", 400, 50, 0, "Center", "Center") 	;;∙------∙Box: Violet, W:400, H:50, Mode:0, X:Centered, Y:Centered.
Return

;;∙------------------------------------------------------------------∙
^4::    ;;∙------∙🔥∙(Ctrl + 4)∙🔥∙------∙Save simulation... red to green bar, levels at 20/40/60/80/100%, centered both axes.
    ShowProgress5(100, 5000 			;;∙------∙Target: 100%, Duration: 5 seconds.
        , "Start", "", "", 20, "Red" 			;;∙------∙0-20%: Red bar, default %, default title color.
        , "25%", "", "", 40, "Orange" 		;;∙------∙21-40%: Orange bar, default %, default title color.
        , "50%", "", "", 60, "Yellow" 		;;∙------∙41-60%: Yellow bar, default %, default title color.
        , "75%", "", "", 80, "Lime" 			;;∙------∙61-80%: Lime bar, default %, default title color.
        , "Done!", "", "", 100, "Green" 		;;∙------∙81-100%: Green bar, default %, default title color.
        , "Purple", 400, 50, 0, "Center", "100") 	;;∙------∙Box: Purple, W:400, H:50, Mode:0, X:Centered, Y:100px from top.
Return

;;∙------------------------------------------------------------------∙
^5::    ;;∙------∙🔥∙(Ctrl + 5)∙🔥∙------∙Download simulation... green to red bar, silver percentage text, 100% in 7s, 300x40px.
    ShowProgress5(100, 7000 				;;∙------∙Target: 100%, Duration: 7 seconds.
        , "Starting...", "00FF00", "Silver", 20, "Lime" 		;;∙------∙0-20%: Lime bar, Silver %, Green title.
        , "Downloading...", "FFFF00", "Silver", 40, "Yellow" 	;;∙------∙21-40%: Yellow bar, Silver %, Yellow title.
        , "Halfway...", "FF6600", "Silver", 60, "Orange" 		;;∙------∙41-60%: Orange bar, Silver %, Orange title.
        , "Almost there...", "FF0000", "Silver", 80, "Red" 	;;∙------∙61-80%: Red bar, Silver %, Red title.
        , "Complete!", "FF00FF", "Silver", 100, "Purple" 	;;∙------∙81-100%: Purple bar, Silver %, Magenta title.
        , "00FF00", 300, 40, 0, "1250", "300") 		;;∙------∙Box: Lime green, W:300, H:40, Mode:0, X:1250px, Y:300px.
Return

;;∙------------------------------------------------------------------∙
^6::    ;;∙------∙🔥∙(Ctrl + 6)∙🔥∙------∙Phase-based progress... each segment has unique title/percentage/bar colors.
    ShowProgress5(100, 6000 				;;∙------∙Target: 100%, Duration: 6 seconds.
        , "Phase 1: Init", "Orange", "Lime", 20, "Green" 		;;∙------∙0-20%: Green bar, Lime %, Orange title.
        , "Phase 2: Load", "Aqua", "Indigo", 40, "Blue" 	;;∙------∙21-40%: Blue bar, Indigo %, Aqua title.
        , "Phase 3: Process", "Orange", "Yellow", 60, "Hot-Pink" 	;;∙------∙41-60%: Orange bar, Yellow %, Hot-Pink title.
        , "Phase 4: Finalize", "Yellow", "Azure", 80, "Red" 		;;∙------∙61-80%: Red bar, Azure %, Yellow title.
        , "Phase 5: Complete!", "Lime", "Coral", 100, "Purple" 	;;∙------∙81-100%: Purple bar, Coral %, Lime title.
        , "Lime", 400, 50, 0, "1100", "700") 			;;∙------∙Box: Lime, W:400, H:50, Mode:0, X:1100px, Y:700px.
Return

;;∙------------------------------------------------------------------∙
/*∙-------∙ALT Hotkeys∙-----------------------------------------∙
!1 = Minimal 2-segment with late-appearing title.
!2 = 3-segment with mixed dark/light percentage text.
!3 = 4-segment with no titles, pure color gradient.
!4 = Full 5-segment with consistent white text, long duration.
!5 = Quick 3-segment with narrow bar and black mid-text.
!6 = Escalating urgency with titles appearing mid-progress.
∙------------------------------------------------------------------∙
*/

!1::    ;;∙------∙🔥∙(Alt + 1)∙🔥∙------∙2-segment: Blue bar to 45%, then Red "FAIL" appears from 45-75%.
    ShowProgress(75, 4000
        , "", "", "", 45, "Blue"
        , "FAIL", "", "White", 100, "Red"
        , "", "", "", 0, "Blue"
        , "", "", "", 0, "Blue"
        , "Silver", 300, 40, 0, "Center", "Center")
Return

;;∙------------------------------------------------------------------∙
!2::    ;;∙------∙🔥∙(Alt + 2)∙🔥∙------∙3-segment temperature gauge. 'Cool' blue >> 'Warm' orange >> 'Hot' red with warning.
    ShowProgress5(100, 4000
        , "Cool", "", "White", 40, "Blue"
        , "Warm", "", "Black", 75, "Orange"
        , "HOT!", "White", "Yellow", 100, "Red"
        , "", "", "", 0, "Blue"
        , "", "", "", 0, "Blue"
        , "666666", 350, 55, 0, "", "50")
Return

;;∙------------------------------------------------------------------∙
!3::    ;;∙------∙🔥∙(Alt + 3)∙🔥∙------∙4-segment battery charge. Red → Orange → Yellow → Green, centered with no titles.
    ShowProgress(100, 5000
        , "", "", "", 25, "Red"
        , "", "", "", 50, "Orange"
        , "", "", "", 75, "Yellow"
        , "", "", "", 100, "Lime"
        , "444444", 500, 35, 0, "Center", "Center")
Return

;;∙------------------------------------------------------------------∙
!4::    ;;∙------∙🔥∙(Alt + 4)∙🔥∙------∙5-segment system scan. Each phase has unique title and bar, white text throughout.
    ShowProgress5(100, 8000
        , "Scanning files...", "White", "White", 20, "Teal"
        , "Checking registry...", "White", "White", 40, "Aqua"
        , "Analyzing threats...", "White", "White", 60, "Blue"
        , "Removing malware...", "White", "White", 80, "Purple"
        , "System Clean!", "Lime", "Lime", 100, "Green"
        , "Aqua", 450, 50, 0, "Center", "200")
Return

;;∙------------------------------------------------------------------∙
!5::    ;;∙------∙🔥∙(Alt + 5)∙🔥∙------∙3-segment upload. Narrow bar, green → yellow → green, quick 2-second animation.
    ShowProgress5(100, 2000
        , "Uploading...", "", "White", 45, "Green"
        , "Processing...", "", "Black", 55, "Yellow"
        , "Complete!", "", "White", 100, "Green"
        , "", "", "", 0, "Green"
        , "", "", "", 0, "Green"
        , "Green", 250, 30, 0, "Center", "Center")
Return

;;∙------------------------------------------------------------------∙
!6::    ;;∙------∙🔥∙(Alt + 6)∙🔥∙------∙4-segment countdown style. Green → Yellow → Orange → Red, titles warn of urgency.
    ShowProgress(100, 6000
        , "All Clear", "", "White", 40, "Green"
        , "Caution", "", "Black", 70, "Yellow"
        , "Warning!", "White", "White", 90, "Orange"
        , "CRITICAL!", "White", "White", 100, "Red"
        , "Red", 400, 55, 0, "Center", "Center")
Return

;;∙============================================∙
;;∙======∙4-SEGMENT PROGRESS FUNCTION∙=======∙
ShowProgress(TargetPercent, TimeToComplete := 3000
  	, Title1 := "", titleColor1 := "", pctColor1 := "", Level1 := 25, barColor1 := "Lime"
  	, Title2 := "", titleColor2 := "", pctColor2 := "", Level2 := 50, barColor2 := "Yellow"
  	, Title3 := "", titleColor3 := "", pctColor3 := "", Level3 := 75, barColor3 := "Orange"
  	, Title4 := "", titleColor4 := "", pctColor4 := "", Level4 := 100, barColor4 := "Red"
  	, boxColor := "333333", Width := 400, Height := 40, Mode := 0, X := "", Y := "", ParentGui := "") {

    ;;∙------∙Config.
    BoxThickness := 2
    BarThickness := 2
    
    ;;∙------∙Resolve title colors (fall back to matching bar color if not set).
    titleColor1 := (titleColor1 != "") ? titleColor1 : barColor1
    titleColor2 := (titleColor2 != "") ? titleColor2 : barColor2
    titleColor3 := (titleColor3 != "") ? titleColor3 : barColor3
    titleColor4 := (titleColor4 != "") ? titleColor4 : barColor4

    ;;∙------∙Resolve percentage colors (fall back to matching bar color if not set).
    pctColor1 := (pctColor1 != "") ? pctColor1 : barColor1
    pctColor2 := (pctColor2 != "") ? pctColor2 : barColor2
    pctColor3 := (pctColor3 != "") ? pctColor3 : barColor3
    pctColor4 := (pctColor4 != "") ? pctColor4 : barColor4
    
    ;;∙------∙Generate unique name.
    if (ParentGui != "") {
        GuiName := ParentGui
        IsEmbedded := true
    } else {
        GuiName := "ProgressBar_" TargetPercent "_" A_TickCount
        IsEmbedded := false
    }
    
    ;;∙------∙Calculate positions.
    BoxX := BoxThickness + 2
    BoxY := BoxThickness + 2
    BoxW := Width - (BoxThickness * 2) - 4
    BoxH := Height - (BoxThickness * 2) - 4
    BarY := BoxY + BoxThickness + 2
    BarH := BoxH - (BoxThickness * 2) - 4
    BarStartX := BoxX + 2
    BarW := BarThickness
    
    ;;∙------∙Calculate travel distance.
    MaxBarTravel := BoxW + BoxThickness - 2 - BarW - BarStartX
    
    ;;∙------∙Convert box color.
    boxColorProgress := Color(boxColor, "GUI")
    boxColorFont := Color(boxColor, "GUI0x")
    
    ;;∙------∙Create GUI or use parent.
    if (!IsEmbedded) {
        Gui, %GuiName%:New
        Gui, %GuiName%:+AlwaysOnTop -Caption +ToolWindow
        Gui, %GuiName%:Color, 1A1A1A
    }
    
    ;;∙------∙Add Title if ANY title exists.
    HasAnyTitle := false
    if (Title1 != "" || Title2 != "" || Title3 != "" || Title4 != "")
        HasAnyTitle := true
    
    TitleOffset := 0
    TitleHwnd := ""
    if (HasAnyTitle) {
        TitleHeight := 20
        TitleOffset := TitleHeight + 5
        initTitleColorFont := Color(titleColor1, "GUI0x")
        Gui, %GuiName%:Font, s8 c%initTitleColorFont% Bold, Arial
        Gui, %GuiName%:Add, Text, % (IsEmbedded ? "x10 y5" : "x10 y5") " w" Width " h" TitleHeight " HwndTitleHwnd", %Title1%
    }
    
    ;;∙------∙Outside border.
    outerColorProgress := Color("333333", "GUI")
    boxline(GuiName, 0, TitleOffset, Width, Height, outerColorProgress, outerColorProgress, outerColorProgress, outerColorProgress, 1)
    
    ;;∙------∙Progress box.
    boxline(GuiName, BoxX, BoxY + TitleOffset, BoxW, BoxH, boxColorProgress, boxColorProgress, boxColorProgress, boxColorProgress, BoxThickness)
    
    ;;∙------∙Create bar lines (one per color segment).
    barColor1Progress := Color(barColor1, "GUI")
    barHwnd1 := barLine(GuiName, BarStartX, BarY + TitleOffset, BarW, BarH, barColor1Progress)
    
    barColor2Progress := Color(barColor2, "GUI")
    barHwnd2 := barLine(GuiName, BarStartX, BarY + TitleOffset, BarW, BarH, barColor2Progress)
    GuiControl, Hide, %barHwnd2%
    
    barColor3Progress := Color(barColor3, "GUI")
    barHwnd3 := barLine(GuiName, BarStartX, BarY + TitleOffset, BarW, BarH, barColor3Progress)
    GuiControl, Hide, %barHwnd3%
    
    barColor4Progress := Color(barColor4, "GUI")
    barHwnd4 := barLine(GuiName, BarStartX, BarY + TitleOffset, BarW, BarH, barColor4Progress)
    GuiControl, Hide, %barHwnd4%
    
    ;;∙------∙Percentage text (initial color from pctColor1).
    initPctColorFont := Color(pctColor1, "GUI0x")
    Gui, %GuiName%:Font, s10 c%initPctColorFont% Bold, Arial
    Gui, %GuiName%:Add, Text, x+30 yp+2 w50 h20 BackgroundTrans HwndTextHwnd, 0`%
    
    ;;∙------∙Handle positioning.
    totalHeight := Height + TitleOffset
    
    if (IsEmbedded) {
        if (X != "" && Y != "") {
            Gui, %GuiName%:Show, x%X% y%Y% w%Width% h%totalHeight%
        }
        Gui, %GuiName%:+HwndGuiHwnd
    } else {
        ;;∙------∙Handle X position centering.
        if (X = "Center") {
            SysGet, ScreenWidth, 0
            X := (ScreenWidth - Width) // 2
        }
        
        ;;∙------∙Handle Y position centering.
        if (Y = "Center") {
            SysGet, ScreenHeight, 1
            Y := (ScreenHeight - totalHeight) // 2
        }
        
        ;;∙------∙Build position options string.
        if (X = "")    ;;∙------∙Force X to 0 if empty to prevent Windows auto-centering.
            X := 0
        if (Y = "")    ;;∙------∙Force Y to 0 if empty to prevent Windows auto-centering.
            Y := 0

        if (X != "" && Y != "")
            posOptions := "x" X " y" Y
        else if (X != "")
            posOptions := "x" X
        else if (Y != "")
            posOptions := "y" Y
        else
            posOptions := ""
        
        Gui, %GuiName%:Show, %posOptions% w%Width% h%totalHeight%
        Gui, %GuiName%:+HwndGuiHwnd
    }
    
    ;;∙------∙Make draggable.
    if (!IsEmbedded)
        OnMessage(0x0201, "WM_LBUTTONDOWNdrag")
    
    if (Mode = 1) {
        ProgressObj := {}
        ProgressObj.GuiName := GuiName
        ProgressObj.GuiHwnd := GuiHwnd
        ProgressObj.BarHwnd1 := barHwnd1
        ProgressObj.BarHwnd2 := barHwnd2
        ProgressObj.BarHwnd3 := barHwnd3
        ProgressObj.BarHwnd4 := barHwnd4
        ProgressObj.TextHwnd := TextHwnd
        ProgressObj.TitleHwnd := TitleHwnd
        ProgressObj.BarStartX := BarStartX
        ProgressObj.MaxBarTravel := MaxBarTravel
        ProgressObj.BarW := BarW
        ProgressObj.BarY := BarY + TitleOffset
        ProgressObj.BarH := BarH
        ProgressObj.IsEmbedded := IsEmbedded
        ProgressObj.barColor1 := barColor1
        ProgressObj.barColor2 := barColor2
        ProgressObj.barColor3 := barColor3
        ProgressObj.barColor4 := barColor4
        ProgressObj.Title1 := Title1
        ProgressObj.Title2 := Title2
        ProgressObj.Title3 := Title3
        ProgressObj.Title4 := Title4
        ProgressObj.Level1 := Level1
        ProgressObj.Level2 := Level2
        ProgressObj.Level3 := Level3
        ProgressObj.Level4 := Level4
        ProgressObj.titleColor1 := titleColor1
        ProgressObj.titleColor2 := titleColor2
        ProgressObj.titleColor3 := titleColor3
        ProgressObj.titleColor4 := titleColor4
        ProgressObj.pctColor1 := pctColor1
        ProgressObj.pctColor2 := pctColor2
        ProgressObj.pctColor3 := pctColor3
        ProgressObj.pctColor4 := pctColor4
        ProgressObj.Update := Func("UpdateProgress")
        ProgressObj.Destroy := Func("DestroyProgress")
        return ProgressObj
    } else {
        AnimateBarProgress(GuiName, GuiHwnd, TargetPercent, TimeToComplete, BarStartX, MaxBarTravel, BarW, BarY + TitleOffset, BarH, barHwnd1, barHwnd2, barHwnd3, barHwnd4, TextHwnd, TitleHwnd, IsEmbedded, barColor1, barColor2, barColor3, barColor4, Title1, Title2, Title3, Title4, Level1, Level2, Level3, Level4, titleColor1, titleColor2, titleColor3, titleColor4, pctColor1, pctColor2, pctColor3, pctColor4)
    }
}

;;∙============================================∙
;;∙======∙PROGRESS ANIMATION (4-SEGMENT)∙=====∙
AnimateBarProgress(GuiName, GuiHwnd, TargetPercent, TotalTime, BarStartX, MaxBarTravel, BarW, BarY, BarH, barHwnd1, barHwnd2, barHwnd3, barHwnd4, TextHwnd, TitleHwnd, IsEmbedded, barColor1, barColor2, barColor3, barColor4, Title1, Title2, Title3, Title4, Level1, Level2, Level3, Level4, titleColor1, titleColor2, titleColor3, titleColor4, pctColor1, pctColor2, pctColor3, pctColor4) {
    Gui, %GuiName%:Default
    
    Steps := 60
    SleepTime := TotalTime // Steps
    LastTitle := ""
    CurrentSegment := 1
    LastX := BarStartX
    
    Loop, %Steps% {
        if (!IsEmbedded && !WinExist("ahk_id " GuiHwnd))
            Return
            
        percent := (A_Index / Steps) * TargetPercent
        CurrentX := BarStartX + (MaxBarTravel * percent / 100)
        
        ;;∙------∙Determine which segment is active.
        if (percent <= Level1) {
            if (CurrentSegment != 1) {
                MoveBar(barHwnd1, LastX, BarY, BarW, BarH)
                GuiControl, Show, %barHwnd1%
                GuiControl, Hide, %barHwnd2%
                GuiControl, Hide, %barHwnd3%
                GuiControl, Hide, %barHwnd4%
                CurrentSegment := 1
            }
            MoveBar(barHwnd1, CurrentX, BarY, BarW, BarH)
            currentTitle      := Title1
            currentTitleColor := Color(titleColor1, "GUI0x")
            currentPctColor   := Color(pctColor1, "GUI0x")
            
        } else if (percent <= Level2) {
            if (CurrentSegment != 2) {
                MoveBar(barHwnd2, LastX, BarY, BarW, BarH)
                GuiControl, Show, %barHwnd2%
                GuiControl, Hide, %barHwnd1%
                GuiControl, Hide, %barHwnd3%
                GuiControl, Hide, %barHwnd4%
                CurrentSegment := 2
            }
            MoveBar(barHwnd2, CurrentX, BarY, BarW, BarH)
            currentTitle      := Title2
            currentTitleColor := Color(titleColor2, "GUI0x")
            currentPctColor   := Color(pctColor2, "GUI0x")
            
        } else if (percent <= Level3) {
            if (CurrentSegment != 3) {
                MoveBar(barHwnd3, LastX, BarY, BarW, BarH)
                GuiControl, Show, %barHwnd3%
                GuiControl, Hide, %barHwnd1%
                GuiControl, Hide, %barHwnd2%
                GuiControl, Hide, %barHwnd4%
                CurrentSegment := 3
            }
            MoveBar(barHwnd3, CurrentX, BarY, BarW, BarH)
            currentTitle      := Title3
            currentTitleColor := Color(titleColor3, "GUI0x")
            currentPctColor   := Color(pctColor3, "GUI0x")
            
        } else {
            if (CurrentSegment != 4) {
                MoveBar(barHwnd4, LastX, BarY, BarW, BarH)
                GuiControl, Show, %barHwnd4%
                GuiControl, Hide, %barHwnd1%
                GuiControl, Hide, %barHwnd2%
                GuiControl, Hide, %barHwnd3%
                CurrentSegment := 4
            }
            MoveBar(barHwnd4, CurrentX, BarY, BarW, BarH)
            currentTitle      := Title4
            currentTitleColor := Color(titleColor4, "GUI0x")
            currentPctColor   := Color(pctColor4, "GUI0x")
        }
        
        LastX := CurrentX
        
        ;;∙------∙Update title text & color if changed.
        if (currentTitle != LastTitle && currentTitle != "" && TitleHwnd != "") {
            Gui, %GuiName%:Font, s8 c%currentTitleColor% Bold, Arial
            GuiControl, Font, %TitleHwnd%
            GuiControl,, %TitleHwnd%, %currentTitle%
            LastTitle := currentTitle
        }
        
        ;;∙------∙Update percentage text & color.
        Gui, %GuiName%:Font, s10 c%currentPctColor% Bold, Arial
        GuiControl, Font, %TextHwnd%
        
        displayText := Round(percent) . "`%"
        GuiControl,, %TextHwnd%, %displayText%
        
        Sleep, %SleepTime%
    }
    
    if (!IsEmbedded && !WinExist("ahk_id " GuiHwnd))
        Return
        
    ;;∙------∙Final position.
    FinalX := BarStartX + (MaxBarTravel * TargetPercent / 100)
    
    if (TargetPercent <= Level1) {
        MoveBar(barHwnd1, FinalX, BarY, BarW, BarH)
        finalTitle      := Title1
        finalTitleColor := Color(titleColor1, "GUI0x")
        finalPctColor   := Color(pctColor1, "GUI0x")
    } else if (TargetPercent <= Level2) {
        MoveBar(barHwnd2, FinalX, BarY, BarW, BarH)
        finalTitle      := Title2
        finalTitleColor := Color(titleColor2, "GUI0x")
        finalPctColor   := Color(pctColor2, "GUI0x")
    } else if (TargetPercent <= Level3) {
        MoveBar(barHwnd3, FinalX, BarY, BarW, BarH)
        finalTitle      := Title3
        finalTitleColor := Color(titleColor3, "GUI0x")
        finalPctColor   := Color(pctColor3, "GUI0x")
    } else {
        MoveBar(barHwnd4, FinalX, BarY, BarW, BarH)
        finalTitle      := Title4
        finalTitleColor := Color(titleColor4, "GUI0x")
        finalPctColor   := Color(pctColor4, "GUI0x")
    }
    
    if (finalTitle != "" && TitleHwnd != "") {
        Gui, %GuiName%:Font, s8 c%finalTitleColor% Bold, Arial
        GuiControl, Font, %TitleHwnd%
        GuiControl,, %TitleHwnd%, %finalTitle%
    }
    
    Gui, %GuiName%:Font, s10 c%finalPctColor% Bold, Arial
    GuiControl, Font, %TextHwnd%
    
    displayText := TargetPercent . "`%"
    GuiControl,, %TextHwnd%, %displayText%
    
    if (!IsEmbedded) {
        Sleep, 500
        Gui, %GuiName%:Destroy
    }
}

;;∙============================================∙
;;∙======∙5-SEGMENT PROGRESS FUNCTION∙=======∙
ShowProgress5(TargetPercent, TimeToComplete := 3000
    , Title1 := "", titleColor1 := "", pctColor1 := "", Level1 := 20, barColor1 := "Lime"
    , Title2 := "", titleColor2 := "", pctColor2 := "", Level2 := 40, barColor2 := "Yellow"
    , Title3 := "", titleColor3 := "", pctColor3 := "", Level3 := 60, barColor3 := "Orange"
    , Title4 := "", titleColor4 := "", pctColor4 := "", Level4 := 80, barColor4 := "Red"
    , Title5 := "", titleColor5 := "", pctColor5 := "", Level5 := 100, barColor5 := "Maroon"
    , boxColor := "333333", Width := 400, Height := 40, Mode := 0, X := "", Y := "", ParentGui := "") {

    ;;∙------∙Config.
    BoxThickness := 2
    BarThickness := 2
    
    ;;∙------∙Resolve title colors.
    titleColor1 := (titleColor1 != "") ? titleColor1 : barColor1
    titleColor2 := (titleColor2 != "") ? titleColor2 : barColor2
    titleColor3 := (titleColor3 != "") ? titleColor3 : barColor3
    titleColor4 := (titleColor4 != "") ? titleColor4 : barColor4
    titleColor5 := (titleColor5 != "") ? titleColor5 : barColor5

    ;;∙------∙Resolve percentage colors.
    pctColor1 := (pctColor1 != "") ? pctColor1 : barColor1
    pctColor2 := (pctColor2 != "") ? pctColor2 : barColor2
    pctColor3 := (pctColor3 != "") ? pctColor3 : barColor3
    pctColor4 := (pctColor4 != "") ? pctColor4 : barColor4
    pctColor5 := (pctColor5 != "") ? pctColor5 : barColor5
    
    ;;∙------∙Generate unique name.
    if (ParentGui != "") {
        GuiName := ParentGui
        IsEmbedded := true
    } else {
        GuiName := "ProgressBar5_" TargetPercent "_" A_TickCount
        IsEmbedded := false
    }
    
    ;;∙------∙Calculate positions.
    BoxX := BoxThickness + 2
    BoxY := BoxThickness + 2
    BoxW := Width - (BoxThickness * 2) - 4
    BoxH := Height - (BoxThickness * 2) - 4
    BarY := BoxY + BoxThickness + 2
    BarH := BoxH - (BoxThickness * 2) - 4
    BarStartX := BoxX + 2
    BarW := BarThickness
    
    ;;∙------∙Calculate travel distance.
    MaxBarTravel := BoxW + BoxThickness - 2 - BarW - BarStartX
    
    ;;∙------∙Convert box color.
    boxColorProgress := Color(boxColor, "GUI")
    boxColorFont := Color(boxColor, "GUI0x")
    
    ;;∙------∙Create GUI or use parent.
    if (!IsEmbedded) {
        Gui, %GuiName%:New
        Gui, %GuiName%:+AlwaysOnTop -Caption +ToolWindow
        Gui, %GuiName%:Color, 1A1A1A
    }
    
    ;;∙------∙Add Title if ANY title exists.
    HasAnyTitle := false
    if (Title1 != "" || Title2 != "" || Title3 != "" || Title4 != "" || Title5 != "")
        HasAnyTitle := true
    
    TitleOffset := 0
    TitleHwnd := ""
    if (HasAnyTitle) {
        TitleHeight := 20
        TitleOffset := TitleHeight + 5
        initTitleColorFont := Color(titleColor1, "GUI0x")
        Gui, %GuiName%:Font, s8 c%initTitleColorFont% Bold, Arial
        Gui, %GuiName%:Add, Text, % (IsEmbedded ? "x10 y5" : "x10 y5") " w" Width " h" TitleHeight " HwndTitleHwnd", %Title1%
    }
    
    ;;∙------∙Outside border.
    outerColorProgress := Color("333333", "GUI")
    boxline(GuiName, 0, TitleOffset, Width, Height, outerColorProgress, outerColorProgress, outerColorProgress, outerColorProgress, 1)
    
    ;;∙------∙Progress box.
    boxline(GuiName, BoxX, BoxY + TitleOffset, BoxW, BoxH, boxColorProgress, boxColorProgress, boxColorProgress, boxColorProgress, BoxThickness)
    
    ;;∙------∙Create bar lines (five segments).
    barColor1Progress := Color(barColor1, "GUI")
    barHwnd1 := barLine(GuiName, BarStartX, BarY + TitleOffset, BarW, BarH, barColor1Progress)
    
    barColor2Progress := Color(barColor2, "GUI")
    barHwnd2 := barLine(GuiName, BarStartX, BarY + TitleOffset, BarW, BarH, barColor2Progress)
    GuiControl, Hide, %barHwnd2%
    
    barColor3Progress := Color(barColor3, "GUI")
    barHwnd3 := barLine(GuiName, BarStartX, BarY + TitleOffset, BarW, BarH, barColor3Progress)
    GuiControl, Hide, %barHwnd3%
    
    barColor4Progress := Color(barColor4, "GUI")
    barHwnd4 := barLine(GuiName, BarStartX, BarY + TitleOffset, BarW, BarH, barColor4Progress)
    GuiControl, Hide, %barHwnd4%
    
    barColor5Progress := Color(barColor5, "GUI")
    barHwnd5 := barLine(GuiName, BarStartX, BarY + TitleOffset, BarW, BarH, barColor5Progress)
    GuiControl, Hide, %barHwnd5%
    
    ;;∙------∙Percentage text.
    initPctColorFont := Color(pctColor1, "GUI0x")
    Gui, %GuiName%:Font, s10 c%initPctColorFont% Bold, Arial
    Gui, %GuiName%:Add, Text, x+30 yp+2 w50 h20 BackgroundTrans HwndTextHwnd, 0`%
    
    ;;∙------∙Handle positioning.
    totalHeight := Height + TitleOffset
    
    if (IsEmbedded) {
        if (X != "" && Y != "") {
            Gui, %GuiName%:Show, x%X% y%Y% w%Width% h%totalHeight%
        }
        Gui, %GuiName%:+HwndGuiHwnd
    } else {
        ;;∙------∙Handle X position centering.
        if (X = "Center") {
            SysGet, ScreenWidth, 0
            X := (ScreenWidth - Width) // 2
        }
        
        ;;∙------∙Handle Y position centering.
        if (Y = "Center") {
            SysGet, ScreenHeight, 1
            Y := (ScreenHeight - totalHeight) // 2
        }
        
        ;;∙------∙Build position options string.
        if (X = "")    ;;∙------∙Force X to 0 if empty to prevent Windows auto-centering.
            X := 0
        if (Y = "")    ;;∙------∙Force Y to 0 if empty to prevent Windows auto-centering.
            Y := 0

        if (X != "" && Y != "")
            posOptions := "x" X " y" Y
        else if (X != "")
            posOptions := "x" X
        else if (Y != "")
            posOptions := "y" Y
        else
            posOptions := ""

        Gui, %GuiName%:Show, %posOptions% w%Width% h%totalHeight%
        Gui, %GuiName%:+HwndGuiHwnd
    }
    
    ;;∙------∙Make draggable.
    if (!IsEmbedded)
        OnMessage(0x0201, "WM_LBUTTONDOWNdrag")
    
    if (Mode = 1) {
        ProgressObj := {}
        ProgressObj.GuiName := GuiName
        ProgressObj.GuiHwnd := GuiHwnd
        ProgressObj.BarHwnd1 := barHwnd1
        ProgressObj.BarHwnd2 := barHwnd2
        ProgressObj.BarHwnd3 := barHwnd3
        ProgressObj.BarHwnd4 := barHwnd4
        ProgressObj.BarHwnd5 := barHwnd5
        ProgressObj.TextHwnd := TextHwnd
        ProgressObj.TitleHwnd := TitleHwnd
        ProgressObj.BarStartX := BarStartX
        ProgressObj.MaxBarTravel := MaxBarTravel
        ProgressObj.BarW := BarW
        ProgressObj.BarY := BarY + TitleOffset
        ProgressObj.BarH := BarH
        ProgressObj.IsEmbedded := IsEmbedded
        ProgressObj.barColor1 := barColor1
        ProgressObj.barColor2 := barColor2
        ProgressObj.barColor3 := barColor3
        ProgressObj.barColor4 := barColor4
        ProgressObj.barColor5 := barColor5
        ProgressObj.Title1 := Title1
        ProgressObj.Title2 := Title2
        ProgressObj.Title3 := Title3
        ProgressObj.Title4 := Title4
        ProgressObj.Title5 := Title5
        ProgressObj.Level1 := Level1
        ProgressObj.Level2 := Level2
        ProgressObj.Level3 := Level3
        ProgressObj.Level4 := Level4
        ProgressObj.Level5 := Level5
        ProgressObj.titleColor1 := titleColor1
        ProgressObj.titleColor2 := titleColor2
        ProgressObj.titleColor3 := titleColor3
        ProgressObj.titleColor4 := titleColor4
        ProgressObj.titleColor5 := titleColor5
        ProgressObj.pctColor1 := pctColor1
        ProgressObj.pctColor2 := pctColor2
        ProgressObj.pctColor3 := pctColor3
        ProgressObj.pctColor4 := pctColor4
        ProgressObj.pctColor5 := pctColor5
        ProgressObj.Update := Func("UpdateProgress5")
        ProgressObj.Destroy := Func("DestroyProgress5")
        return ProgressObj
    } else {
        AnimateBarProgress5(GuiName, GuiHwnd, TargetPercent, TimeToComplete, BarStartX, MaxBarTravel, BarW, BarY + TitleOffset, BarH, barHwnd1, barHwnd2, barHwnd3, barHwnd4, barHwnd5, TextHwnd, TitleHwnd, IsEmbedded, barColor1, barColor2, barColor3, barColor4, barColor5, Title1, Title2, Title3, Title4, Title5, Level1, Level2, Level3, Level4, Level5, titleColor1, titleColor2, titleColor3, titleColor4, titleColor5, pctColor1, pctColor2, pctColor3, pctColor4, pctColor5)
    }
}

;;∙============================================∙
;;∙======∙5-SEGMENT ANIMATION∙================∙
AnimateBarProgress5(GuiName, GuiHwnd, TargetPercent, TotalTime, BarStartX, MaxBarTravel, BarW, BarY, BarH, barHwnd1, barHwnd2, barHwnd3, barHwnd4, barHwnd5, TextHwnd, TitleHwnd, IsEmbedded, barColor1, barColor2, barColor3, barColor4, barColor5, Title1, Title2, Title3, Title4, Title5, Level1, Level2, Level3, Level4, Level5, titleColor1, titleColor2, titleColor3, titleColor4, titleColor5, pctColor1, pctColor2, pctColor3, pctColor4, pctColor5) {
    Gui, %GuiName%:Default
    
    Steps := 60
    SleepTime := TotalTime // Steps
    LastTitle := ""
    CurrentSegment := 1
    LastX := BarStartX
    
    Loop, %Steps% {
        if (!IsEmbedded && !WinExist("ahk_id " GuiHwnd))
            Return
            
        percent := (A_Index / Steps) * TargetPercent
        CurrentX := BarStartX + (MaxBarTravel * percent / 100)
        
        ;;∙------∙Determine which segment is active.
        if (percent <= Level1) {
            if (CurrentSegment != 1) {
                MoveBar(barHwnd1, LastX, BarY, BarW, BarH)
                GuiControl, Show, %barHwnd1%
                GuiControl, Hide, %barHwnd2%
                GuiControl, Hide, %barHwnd3%
                GuiControl, Hide, %barHwnd4%
                GuiControl, Hide, %barHwnd5%
                CurrentSegment := 1
            }
            MoveBar(barHwnd1, CurrentX, BarY, BarW, BarH)
            currentTitle      := Title1
            currentTitleColor := Color(titleColor1, "GUI0x")
            currentPctColor   := Color(pctColor1, "GUI0x")
            
        } else if (percent <= Level2) {
            if (CurrentSegment != 2) {
                MoveBar(barHwnd2, LastX, BarY, BarW, BarH)
                GuiControl, Show, %barHwnd2%
                GuiControl, Hide, %barHwnd1%
                GuiControl, Hide, %barHwnd3%
                GuiControl, Hide, %barHwnd4%
                GuiControl, Hide, %barHwnd5%
                CurrentSegment := 2
            }
            MoveBar(barHwnd2, CurrentX, BarY, BarW, BarH)
            currentTitle      := Title2
            currentTitleColor := Color(titleColor2, "GUI0x")
            currentPctColor   := Color(pctColor2, "GUI0x")
            
        } else if (percent <= Level3) {
            if (CurrentSegment != 3) {
                MoveBar(barHwnd3, LastX, BarY, BarW, BarH)
                GuiControl, Show, %barHwnd3%
                GuiControl, Hide, %barHwnd1%
                GuiControl, Hide, %barHwnd2%
                GuiControl, Hide, %barHwnd4%
                GuiControl, Hide, %barHwnd5%
                CurrentSegment := 3
            }
            MoveBar(barHwnd3, CurrentX, BarY, BarW, BarH)
            currentTitle      := Title3
            currentTitleColor := Color(titleColor3, "GUI0x")
            currentPctColor   := Color(pctColor3, "GUI0x")
            
        } else if (percent <= Level4) {
            if (CurrentSegment != 4) {
                MoveBar(barHwnd4, LastX, BarY, BarW, BarH)
                GuiControl, Show, %barHwnd4%
                GuiControl, Hide, %barHwnd1%
                GuiControl, Hide, %barHwnd2%
                GuiControl, Hide, %barHwnd3%
                GuiControl, Hide, %barHwnd5%
                CurrentSegment := 4
            }
            MoveBar(barHwnd4, CurrentX, BarY, BarW, BarH)
            currentTitle      := Title4
            currentTitleColor := Color(titleColor4, "GUI0x")
            currentPctColor   := Color(pctColor4, "GUI0x")
            
        } else {
            if (CurrentSegment != 5) {
                MoveBar(barHwnd5, LastX, BarY, BarW, BarH)
                GuiControl, Show, %barHwnd5%
                GuiControl, Hide, %barHwnd1%
                GuiControl, Hide, %barHwnd2%
                GuiControl, Hide, %barHwnd3%
                GuiControl, Hide, %barHwnd4%
                CurrentSegment := 5
            }
            MoveBar(barHwnd5, CurrentX, BarY, BarW, BarH)
            currentTitle      := Title5
            currentTitleColor := Color(titleColor5, "GUI0x")
            currentPctColor   := Color(pctColor5, "GUI0x")
        }
        
        LastX := CurrentX
        
        ;;∙------∙Update title text & color if changed.
        if (currentTitle != LastTitle && currentTitle != "" && TitleHwnd != "") {
            Gui, %GuiName%:Font, s8 c%currentTitleColor% Bold, Arial
            GuiControl, Font, %TitleHwnd%
            GuiControl,, %TitleHwnd%, %currentTitle%
            LastTitle := currentTitle
        }
        
        ;;∙------∙Update percentage text & color.
        Gui, %GuiName%:Font, s10 c%currentPctColor% Bold, Arial
        GuiControl, Font, %TextHwnd%
        
        displayText := Round(percent) . "`%"
        GuiControl,, %TextHwnd%, %displayText%
        
        Sleep, %SleepTime%
    }
    
    if (!IsEmbedded && !WinExist("ahk_id " GuiHwnd))
        Return
        
    ;;∙------∙Final position.
    FinalX := BarStartX + (MaxBarTravel * TargetPercent / 100)
    
    if (TargetPercent <= Level1) {
        MoveBar(barHwnd1, FinalX, BarY, BarW, BarH)
        finalTitle      := Title1
        finalTitleColor := Color(titleColor1, "GUI0x")
        finalPctColor   := Color(pctColor1, "GUI0x")
    } else if (TargetPercent <= Level2) {
        MoveBar(barHwnd2, FinalX, BarY, BarW, BarH)
        finalTitle      := Title2
        finalTitleColor := Color(titleColor2, "GUI0x")
        finalPctColor   := Color(pctColor2, "GUI0x")
    } else if (TargetPercent <= Level3) {
        MoveBar(barHwnd3, FinalX, BarY, BarW, BarH)
        finalTitle      := Title3
        finalTitleColor := Color(titleColor3, "GUI0x")
        finalPctColor   := Color(pctColor3, "GUI0x")
    } else if (TargetPercent <= Level4) {
        MoveBar(barHwnd4, FinalX, BarY, BarW, BarH)
        finalTitle      := Title4
        finalTitleColor := Color(titleColor4, "GUI0x")
        finalPctColor   := Color(pctColor4, "GUI0x")
    } else {
        MoveBar(barHwnd5, FinalX, BarY, BarW, BarH)
        finalTitle      := Title5
        finalTitleColor := Color(titleColor5, "GUI0x")
        finalPctColor   := Color(pctColor5, "GUI0x")
    }
    
    if (finalTitle != "" && TitleHwnd != "") {
        Gui, %GuiName%:Font, s8 c%finalTitleColor% Bold, Arial
        GuiControl, Font, %TitleHwnd%
        GuiControl,, %TitleHwnd%, %finalTitle%
    }
    
    Gui, %GuiName%:Font, s10 c%finalPctColor% Bold, Arial
    GuiControl, Font, %TextHwnd%
    
    displayText := TargetPercent . "`%"
    GuiControl,, %TextHwnd%, %displayText%
    
    if (!IsEmbedded) {
        Sleep, 500
        Gui, %GuiName%:Destroy
    }
}

;;∙============================================∙
;;∙======∙MANUAL CONTROL FUNCTIONS∙==========∙
UpdateProgress(this, percent) {
    Gui, % this.GuiName ":Default"
    
    if (!this.IsEmbedded && !WinExist("ahk_id " this.GuiHwnd))
        Return
        
    percent := percent < 0 ? 0 : percent > 100 ? 100 : percent
    CurrentX := this.BarStartX + (this.MaxBarTravel * percent / 100)
    
    if (percent <= this.Level1) {
        MoveBar(this.BarHwnd1, CurrentX, this.BarY, this.BarW, this.BarH)
        GuiControl, Show, % this.BarHwnd1
        GuiControl, Hide, % this.BarHwnd2
        GuiControl, Hide, % this.BarHwnd3
        GuiControl, Hide, % this.BarHwnd4
        currentTitle      := this.Title1
        currentTitleColor := Color(this.titleColor1, "GUI0x")
        currentPctColor   := Color(this.pctColor1, "GUI0x")
    } else if (percent <= this.Level2) {
        MoveBar(this.BarHwnd2, CurrentX, this.BarY, this.BarW, this.BarH)
        GuiControl, Show, % this.BarHwnd2
        GuiControl, Hide, % this.BarHwnd1
        GuiControl, Hide, % this.BarHwnd3
        GuiControl, Hide, % this.BarHwnd4
        currentTitle      := this.Title2
        currentTitleColor := Color(this.titleColor2, "GUI0x")
        currentPctColor   := Color(this.pctColor2, "GUI0x")
    } else if (percent <= this.Level3) {
        MoveBar(this.BarHwnd3, CurrentX, this.BarY, this.BarW, this.BarH)
        GuiControl, Show, % this.BarHwnd3
        GuiControl, Hide, % this.BarHwnd1
        GuiControl, Hide, % this.BarHwnd2
        GuiControl, Hide, % this.BarHwnd4
        currentTitle      := this.Title3
        currentTitleColor := Color(this.titleColor3, "GUI0x")
        currentPctColor   := Color(this.pctColor3, "GUI0x")
    } else {
        MoveBar(this.BarHwnd4, CurrentX, this.BarY, this.BarW, this.BarH)
        GuiControl, Show, % this.BarHwnd4
        GuiControl, Hide, % this.BarHwnd1
        GuiControl, Hide, % this.BarHwnd2
        GuiControl, Hide, % this.BarHwnd3
        currentTitle      := this.Title4
        currentTitleColor := Color(this.titleColor4, "GUI0x")
        currentPctColor   := Color(this.pctColor4, "GUI0x")
    }
    
    ;;∙------∙Update title text & color.
    if (currentTitle != "" && this.TitleHwnd != "") {
        Gui, % this.GuiName ":Font", s8 c%currentTitleColor% Bold, Arial
        GuiControl, Font, % this.TitleHwnd
        GuiControl,, % this.TitleHwnd, %currentTitle%
    }
    
    ;;∙------∙Update percentage text & color.
    Gui, % this.GuiName ":Font", s10 c%currentPctColor% Bold, Arial
    GuiControl, Font, % this.TextHwnd
    
    displayText := Round(percent) . "`%"
    GuiControl,, % this.TextHwnd, %displayText%
    
    if (!this.IsEmbedded && percent >= 100) {
        Sleep, 500
        this.Destroy()
    }
}

DestroyProgress(this) {
    Gui, % this.GuiName ":Default"
    
    if (!this.IsEmbedded)
        Gui, % this.GuiName ":Destroy"
}

UpdateProgress5(this, percent) {
    Gui, % this.GuiName ":Default"
    
    if (!this.IsEmbedded && !WinExist("ahk_id " this.GuiHwnd))
        Return
        
    percent := percent < 0 ? 0 : percent > 100 ? 100 : percent
    CurrentX := this.BarStartX + (this.MaxBarTravel * percent / 100)
    
    if (percent <= this.Level1) {
        MoveBar(this.BarHwnd1, CurrentX, this.BarY, this.BarW, this.BarH)
        GuiControl, Show, % this.BarHwnd1
        GuiControl, Hide, % this.BarHwnd2
        GuiControl, Hide, % this.BarHwnd3
        GuiControl, Hide, % this.BarHwnd4
        GuiControl, Hide, % this.BarHwnd5
        currentTitle      := this.Title1
        currentTitleColor := Color(this.titleColor1, "GUI0x")
        currentPctColor   := Color(this.pctColor1, "GUI0x")
    } else if (percent <= this.Level2) {
        MoveBar(this.BarHwnd2, CurrentX, this.BarY, this.BarW, this.BarH)
        GuiControl, Show, % this.BarHwnd2
        GuiControl, Hide, % this.BarHwnd1
        GuiControl, Hide, % this.BarHwnd3
        GuiControl, Hide, % this.BarHwnd4
        GuiControl, Hide, % this.BarHwnd5
        currentTitle      := this.Title2
        currentTitleColor := Color(this.titleColor2, "GUI0x")
        currentPctColor   := Color(this.pctColor2, "GUI0x")
    } else if (percent <= this.Level3) {
        MoveBar(this.BarHwnd3, CurrentX, this.BarY, this.BarW, this.BarH)
        GuiControl, Show, % this.BarHwnd3
        GuiControl, Hide, % this.BarHwnd1
        GuiControl, Hide, % this.BarHwnd2
        GuiControl, Hide, % this.BarHwnd4
        GuiControl, Hide, % this.BarHwnd5
        currentTitle      := this.Title3
        currentTitleColor := Color(this.titleColor3, "GUI0x")
        currentPctColor   := Color(this.pctColor3, "GUI0x")
    } else if (percent <= this.Level4) {
        MoveBar(this.BarHwnd4, CurrentX, this.BarY, this.BarW, this.BarH)
        GuiControl, Show, % this.BarHwnd4
        GuiControl, Hide, % this.BarHwnd1
        GuiControl, Hide, % this.BarHwnd2
        GuiControl, Hide, % this.BarHwnd3
        GuiControl, Hide, % this.BarHwnd5
        currentTitle      := this.Title4
        currentTitleColor := Color(this.titleColor4, "GUI0x")
        currentPctColor   := Color(this.pctColor4, "GUI0x")
    } else {
        MoveBar(this.BarHwnd5, CurrentX, this.BarY, this.BarW, this.BarH)
        GuiControl, Show, % this.BarHwnd5
        GuiControl, Hide, % this.BarHwnd1
        GuiControl, Hide, % this.BarHwnd2
        GuiControl, Hide, % this.BarHwnd3
        GuiControl, Hide, % this.BarHwnd4
        currentTitle      := this.Title5
        currentTitleColor := Color(this.titleColor5, "GUI0x")
        currentPctColor   := Color(this.pctColor5, "GUI0x")
    }
    
    ;;∙------∙Update title text & color.
    if (currentTitle != "" && this.TitleHwnd != "") {
        Gui, % this.GuiName ":Font", s8 c%currentTitleColor% Bold, Arial
        GuiControl, Font, % this.TitleHwnd
        GuiControl,, % this.TitleHwnd, %currentTitle%
    }
    
    ;;∙------∙Update percentage text & color.
    Gui, % this.GuiName ":Font", s10 c%currentPctColor% Bold, Arial
    GuiControl, Font, % this.TextHwnd
    
    displayText := Round(percent) . "`%"
    GuiControl,, % this.TextHwnd, %displayText%
    
    if (!this.IsEmbedded && percent >= 100) {
        Sleep, 500
        this.Destroy()
    }
}

DestroyProgress5(this) {
    Gui, % this.GuiName ":Default"
    
    if (!this.IsEmbedded)
        Gui, % this.GuiName ":Destroy"
}

;;∙============================================∙
;;∙======∙HELPER FUNCTIONS∙====================∙
boxline(GuiName, X, Y, W, H, ColorTop := "Black", ColorBottom := "Black", ColorLeft := "Black", ColorRight := "Black", Thickness := 1) {
    BottomY := Y + H - Thickness
    RightX := X + W - Thickness

    Gui, %GuiName%:Add, Progress, x%X% y%Y% w%W% h%Thickness% Background%ColorTop%
    Gui, %GuiName%:Add, Progress, x%X% y%BottomY% w%W% h%Thickness% Background%ColorBottom%
    Gui, %GuiName%:Add, Progress, x%X% y%Y% w%Thickness% h%H% Background%ColorLeft%
    Gui, %GuiName%:Add, Progress, x%RightX% y%Y% w%Thickness% h%H% Background%ColorRight%
}

barLine(GuiName, X, Y, W, H, Color) {
    Gui, %GuiName%:Add, Progress, x%X% y%Y% w%W% h%H% Background%Color% HwndbarHwnd
    return barHwnd
}

MoveBar(Hwnd, NewX, NewY, NewW, NewH) {
    GuiControl, Move, %Hwnd%, x%NewX% y%NewY% w%NewW% h%NewH%
}

WM_LBUTTONDOWNdrag() {
    PostMessage, 0xA1, 2,,, A
}

;;∙============================================∙
;;∙======∙COLOR CONVERTER∙====================∙
Color(ColorName, Format := "GDI+") {
    static colorMap := {}
    if (!colorMap.Count()) {
        colorMap["Black"] := "000000"
        colorMap["Gray"] := "808080"
        colorMap["Silver"] := "C0C0C0"
        colorMap["White"] := "FFFFFF"
        colorMap["Maroon"] := "800000"
        colorMap["Red"] := "FF0000"
        colorMap["Dark-Red"] := "8B0000"
        colorMap["Magenta-Red"] := "FF0066"
        colorMap["Rose"] := "FF007F"
        colorMap["Salmon"] := "FA8072"
        colorMap["Light-Salmon"] := "FFA07A"
        colorMap["Coral"] := "FF7F50"
        colorMap["Hot-Pink"] := "FF69B4"
        colorMap["Deep-Pink"] := "FF1493"
        colorMap["Rose-Pink"] := "FF66CC"
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
    else
        return "0xFF" . hex
}

;;∙============================================∙
;;∙======∙EDIT / RELOAD / EXIT∙===================∙
;;∙------∙Edit∙------------------------------∙
Script·Edit:    ;;∙------∙Menu Call.
    Edit
Return

;;∙------∙Reload∙--------------------------∙
^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)
    Script·Reload:    ;;∙------∙Menu Call.
        ;;∙------∙Soundbeep, 1000, 200
    Reload
Return

;;∙------∙Exit∙------------------------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)
    Script·Exit:    ;;∙------∙Menu Call.
        ;;∙------∙Soundbeep, 1000, 200
    ExitApp
Return

;;∙============================================∙
;;∙======∙SCRIPT UPDATE∙========================∙
UpdateCheck:    ;;∙------Check if script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload
Return

;;∙============================================∙
;;∙======∙TRAY MENU∙===========================∙
TrayMenu:
Menu, Tray, Tip, Colorful Progress Bars
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add

;;∙------∙Menu Extentions∙-------------∙
Menu, Tray, Add
Menu, Tray, Add, Help Docs, Documentation
Menu, Tray, Icon, Help Docs, wmploc.dll, 130
Menu, Tray, Default, Help Docs    ;;∙------∙Makes Bold.
Menu, Tray, Add
Menu, Tray, Add, Key History, ShowKeyHistory
Menu, Tray, Icon, Key History, wmploc.dll, 65
Menu, Tray, Add
Menu, Tray, Add, Window Spy, ShowWindowSpy
Menu, Tray, Icon, Window Spy, wmploc.dll, 21
Menu, Tray, Add

;;∙------∙Menu Options∙----------------∙
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

;;∙------∙Extensions∙---------------------∙
Documentation:
    Run, "C:\Program Files\AutoHotkey\AutoHotkey.chm"
Return
ShowKeyHistory:
    KeyHistory
Return
ShowWindowSpy:
    Run, "C:\Program Files\AutoHotkey\WindowSpy.ahk"
Return

;;∙============================================∙
;;∙======∙TRAY MENU POSITION∙==================∙
;;∙------∙Show Tray Menu∙-----------∙
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20
Return

;;∙------∙Positioning∙-------------------∙
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
;;∙============================================∙
;;∙============================================∙


;;∙------------------------------------------------------------------∙

