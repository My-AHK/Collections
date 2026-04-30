

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
defaultTab := 1    ;;∙------∙Default starting tab (1=Intro, 2=Length, 3=Weight, etc.).
windowTransparency := 255    ;;∙------∙255=opaque, 0=invisible.
converterOnTop := true    ;;∙------∙Always on top.

guiX := 200    ;;∙------∙X position for GUI window.
guiY := 200    ;;∙------∙Y position for GUI window.

guiW := 640    ;;∙------∙Gui Width (testing).
guiH := 370    ;;∙------∙Gui Height.

;;∙------∙Colors & Appearance∙--------------------------------------∙
gBackground := "Black"    ;;∙------∙GUI Background color.
outerBorder := "Magenta"    ;;∙------∙Outer window border color.
headerLabel := "Azure"    ;;∙------∙Unit Converter label highlight color.
contentBorder := "Blue"    ;;∙------∙Tab page borders color.

Font1 := "Arial"	    ;;∙------∙(	Headers, titles, buttons, navigation)%Font1%
Font2 := "Segoe UI"	    ;;∙------∙(	Form labels, dropdowns, body/info text)%Font2%
Font3 := "Consolas"	    ;;∙------∙(Numeric input/output (monospaced for alignment)%Font3%

;;∙------∙1: INTRO Tab Colors∙---------------------------------------∙
introTabLinks := "Lime"    ;;∙------∙Unit Converter label highlight color.
introReturn := "Lime"    ;;∙------∙Return to Intro tab arrow (↩).

;;∙------∙2: LENGTH Tab Colors∙-------------------------------------∙
lengthTabHeader := "Aqua"    ;;∙------∙Header text on length tab.
lengthInputText := "Blue"    ;;∙------∙Input field text color.
lengthResultText := "Yellow"    ;;∙------∙Result display text color.

;;∙------∙3: WEIGHT Tab Colors∙-------------------------------------∙
weightTabHeader := "Blue"    ;;∙------∙Header text on weight tab.
weightInputText := "Blue"    ;;∙------∙Input field text color.
weightResultText := "Yellow"    ;;∙------∙Result display text color.

;;∙------∙4: VOLUME Tab Colors∙------------------------------------∙
volumeTabHeader := "Fuchsia"    ;;∙------∙Header text on volume tab.
volumeInputText := "Blue"    ;;∙------∙Input field text color.
volumeResultText := "Yellow"    ;;∙------∙Result display text color.

;;∙------∙5: AREA Tab Colors∙-----------------------------------------∙
areaTabHeader := "Red"    ;;∙------∙Header text on area tab.
areaInputText := "Blue"    ;;∙------∙Input field text color.
areaResultText := "Yellow"    ;;∙------∙Result display text color.

;;∙------∙6: TEMPERATURE Tab Colors∙-----------------------------∙
tempTabHeader := "Orange"    ;;∙------∙Header text on temperature tab.
tempInputText := "Blue"    ;;∙------∙Input field text color.
tempResultText := "Yellow"    ;;∙------∙Result display text color.

;;∙------∙7: SPEED Tab Colors∙---------------------------------------∙
speedTabHeader := "Yellow"    ;;∙------∙Header text on speed tab.
speedInputText := "Blue"    ;;∙------∙Input field text color.
speedResultText := "Yellow"    ;;∙------∙Result display text color.

;;∙------∙8: TIME Tab Colors∙-----------------------------------------∙
timeTabHeader := "Spring-Green"    ;;∙------∙Header text on time tab.
timeInputText := "Blue"    ;;∙------∙Input field text color.
timeResultText := "Yellow"    ;;∙------∙Result display text color.

;;∙------∙9: DIGITAL STORAGE Tab Colors∙-------------------------∙
storageTabHeader := "Azure"    ;;∙------∙Header text on storage tab.
storageInputText := "Blue"    ;;∙------∙Input field text color.
storageResultText := "Yellow"    ;;∙------∙Result display text color.

;;∙------∙10: CURRENCY Tab Colors∙--------------------------------∙
currencyTabHeader := "Green"    ;;∙------∙Header text on currency tab.
currencyInputText := "Blue"    ;;∙------∙Input field text color.
currencyResultText := "Yellow"    ;;∙------∙Result display text color.

;;∙------∙11: Pressure Tab Colors∙-----------------------------------∙
pressureTabHeader := "Coral"    ;;∙------∙Header text on pressure tab.
pressureInputText := "Blue"    ;;∙------∙Input field text color.
pressureResultText := "Yellow"    ;;∙------∙Result display text color.

;;∙------∙12: ENERGYTab Colors∙-------------------------------------∙
energyTabHeader := "Chartreuse"    ;;∙------∙Header text on energy tab.
energyInputText := "Blue"    ;;∙------∙Input field text color.
energyResultText := "Yellow"    ;;∙------∙Result display text color.

;;∙------∙13: POWER Tab Colors∙------------------------------------∙
powerTabHeader := "Deep Pink"    ;;∙------∙Header text on power tab.
powerInputText := "Blue"    ;;∙------∙Input field text color.
powerResultText := "Yellow"    ;;∙------∙Result display text color.

;;∙------∙14: FUEL Consumption Tab Colors∙----------------------∙
fuelTabHeader := "Violet"    ;;∙------∙Header text on fuel tab.
fuelInputText := "Blue"    ;;∙------∙Input field text color.
fuelResultText := "Yellow"    ;;∙------∙Result display text color.

;;∙------∙15: DATA Transfer Tab Colors∙----------------------------∙
dataTabHeader := "Cyan"    ;;∙------∙Header text on data transfer tab.
dataInputText := "Blue"    ;;∙------∙Input field text color.
dataResultText := "Yellow"    ;;∙------∙Result display text color.

;;∙------∙16: ANGLE Tab Colors∙-------------------------------------∙
angleTabHeader := "Silver"    ;;∙------∙Header text on angle tab.
angleInputText := "Blue"    ;;∙------∙Input field text color.
angleResultText := "Yellow"    ;;∙------∙Result display text color.

;;∙------∙17: TORQUE Tab Colors∙-----------------------------------∙
torqueTabHeader := "Red-Orange"    ;;∙------∙Header text on torque tab.
torqueInputText := "Blue"    ;;∙------∙Input field text color.
torqueResultText := "Yellow"    ;;∙------∙Result display text color.

;;∙------∙18: FORCE Tab Colors∙-------------------------------------∙
forceTabHeader := "Lime"    ;;∙------∙Header text on force tab.
forceInputText := "Blue"    ;;∙------∙Input field text color.
forceResultText := "Yellow"    ;;∙------∙Result display text color.

;;∙------∙19: ACCELERATION Tab Colors∙---------------------------∙
accelTabHeader := "Hot Pink"    ;;∙------∙Header text on acceleration tab.
accelInputText := "Blue"    ;;∙------∙Input field text color.
accelResultText := "Yellow"    ;;∙------∙Result display text color.

;;∙================================================∙
;;∙======∙GLOBAL VARIABLES∙========================∙
ScriptID := "Unit_Converter"    ;;∙------∙Unique identifier for script window.
apiUrl := "https://open.er-api.com/v6/latest/USD"    ;;∙------∙Currency API endpoint.
lastApiCheck := ""    ;;∙------∙Timestamp of last successful currency fetch.
cachedRates := Object()    ;;∙------∙Stores currency rates for conversion.

;;∙================================================∙
;;∙======∙TRAY ICON & DRAG∙========================∙
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui drag.
Menu, Tray, Icon, imageres.dll, 229
GoSub, TrayMenu    ;;∙------∙Builds tray menu.

;;∙================================================∙
;;∙======∙TIMERS∙==================================∙
SetTimer, UpdateCheck, 750    ;;∙------∙Checks for script file changes every 750ms.
SetTimer, CurrencyRefreshTimer, 3600000    ;;∙------∙Refresh currency rates every 1 hour.


;;∙------------------------------------------------------------------------∙
;;∙================================================∙
;;∙======∙GUI BUILD∙================================∙
Gui, Converter:New
Gui, Converter:-Caption +ToolWindow -DPIScale +E0x02000000 +E0x00080000
If (converterOnTop)
    Gui, Converter:+AlwaysOnTop
Gui, Converter:Margin, 0, 0
Gui, Converter:Color, % Color(gBackground, "GUI0x")
Gui, Converter:Font, s10 q5, %Font2%

;;∙------∙Title Bar Area.
titleColorHex := Color(headerLabel, "GUI0x")
Gui, Converter:Font, s20 c%titleColorHex% Norm q5, %Font1%
Gui, Converter:Add, Text, x1 y8 w%guiW% h30 c%gBackground% Center BackgroundTrans, Just A Unit Converter
Gui, Converter:Add, Text, x0 y7 w%guiW% h30 Center BackgroundTrans, Just A Unit Converter

;;∙------∙Close Text Button (X) / DLL Icon Button (*choice).
closeColorHex := Color("Red", "GUI0x")
XguiW := (guiW - 25)
;;∙------∙Gui, Converter:Font, s12 c%closeColorHex% Bold q5, %Font1%
;;∙------∙Gui, Converter:Add, Text, x%XguiW% y5 gCloseConverter BackgroundTrans, X
Gui, Converter:Add, Picture, x%XguiW% y10 w16 h16 Icon277 gCloseConverter BackgroundTrans, imageres.dll    

;;∙------∙Hide/Minimize Text Button (-) / DLL Icon Button (*choice).
minColorHex := Color("Yellow", "GUI0x")
X2guiW := (XguiW - 20)
;;∙------∙Gui, Converter:Font, s18 c%minColorHex% Bold q5, %Font1%
;;∙------∙Gui, Converter:Add, Text, x%X2guiW% y-2 w25 h25 Center gMinimizeConverter BackgroundTrans, -
Gui, Converter:Add, Picture, x%X2guiW% y10 w16 h16 Icon248 gMinimizeConverter BackgroundTrans, shell32.dll    

;;∙------∙Main Content Area Border.
contentBorderHex := Color(contentBorder, "GUI")
boxW := guiW - 20
boxH := guiH - 55
boxline("Converter", 5, 40, boxW + 10, boxH + 10, contentBorderHex, contentBorderHex, contentBorderHex, contentBorderHex, 1)    ;;∙------∙Inner border.

outerBorderHex := Color(outerBorder, "GUI")
boxline("Converter", 0, 0, guiW, guiH, outerBorderHex, outerBorderHex, outerBorderHex, outerBorderHex, 2)    ;;∙------∙Outer border.

;;∙------∙Tab Control. (*NOTE: Currency must remain 10th Tab or Rates will not update)
TguiW := (guiW - 30) , TguiH := (guiH - 65)
Gui, Converter:Font, s10 q5, %Font2%
Gui, Converter:Add, Tab2, x15 y50 w%TguiW% h0 vConverterTabs gTabChanged AltSubmit -Wrap, Intro|Length|Weight|Volume|Area|Temp|Speed|Time|Storage|Currency|Pressure|Energy|Power|Fuel|Data|Angle|Torque|Force|Accel|    ;;∙------∙Creates an Intro tab & 18 converter tabs.

;;∙================================================∙
;;∙======∙TAB 1: INTRODUCTION∙=====================∙
Gui, Converter:Tab, 1

WguiW := (guiW -60)
headerColorHex := Color(introTabLinks, "GUI0x")
Gui, Converter:Font, s16 c%headerColorHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x30 y50 w%WguiW% Center BackgroundTrans, Welcome to Unit Converter

;;∙------∙Column 1 (left).
Gui, Converter:Font, s10 c%headerColorHex% Bold Underline q5, %Font1%
Gui, Converter:Add, Text, x50 y120 gGoToTab2, • Length
Gui, Converter:Add, Text, x50 y+5 gGoToTab3, • Weight/Mass
Gui, Converter:Add, Text, x50 y+5 gGoToTab4, • Volume
Gui, Converter:Add, Text, x50 y+5 gGoToTab5, • Area
Gui, Converter:Add, Text, x50 y+5 gGoToTab6, • Temperature
Gui, Converter:Add, Text, x50 y+5 gGoToTab7, • Speed
Gui, Converter:Add, Text, x50 y+5 gGoToTab8, • Time
Gui, Converter:Add, Text, x50 y+5 gGoToTab9, • Digital Storage
Gui, Converter:Add, Text, x50 y+5 gGoToTab10, • Currency

;;∙------∙Column 2 (right).
Gui, Converter:Add, Text, x200 y120 gGoToTab11, • Pressure
Gui, Converter:Add, Text, x200 y+5 gGoToTab12, • Energy
Gui, Converter:Add, Text, x200 y+5 gGoToTab13, • Power
Gui, Converter:Add, Text, x200 y+5 gGoToTab14, • Fuel
Gui, Converter:Add, Text, x200 y+5 gGoToTab15, • Data Transfer
Gui, Converter:Add, Text, x200 y+5 gGoToTab16, • Angle
Gui, Converter:Add, Text, x200 y+5 gGoToTab17, • Torque
Gui, Converter:Add, Text, x200 y+5 gGoToTab18, • Force
Gui, Converter:Add, Text, x200 y+5 gGoToTab19, • Acceleration

insideBoxHex := Color(introTabLinks, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)    ;;∙------∙Info panel border.
Gui, Converter:Font, s9 c%introTabLinks% Norm q5, %Font2%
Gui, Converter:Add, Text, x390 y100 w205 h225 BackgroundTrans, 
(
Select any conversion
category from the
list on the left.

Click any item to
jump directly to
that converter.

All conversions
update automatically
as you type.

Return arrows  ↩
return to this tab.
)

;;∙================================================∙
;;∙======∙TAB 2: LENGTH CONVERSIONS∙===============∙
Gui, Converter:Tab, 2

fromHeaderHex := Color(lengthTabHeader, "GUI0x")
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Length Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vFromUnit gUpdateConversion, Millimeters|Centimeters|Meters|Kilometers|Inches|Feet|Yards|Miles    ;;∙------∙Source unit selector.

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gSwapUnits BackgroundTrans, imageres.dll    ;;∙------∙Swap units icon.

toHeaderHex := Color(lengthTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vToUnit gUpdateConversion, Millimeters|Centimeters|Meters|Kilometers|Inches|Feet|Yards|Miles    ;;∙------∙Target unit selector.

inputHeaderHex := Color(lengthTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(lengthInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y170 w305 h30 vInputValue gAutoConvert    ;;∙------∙User input field.

resultLabelHex := Color(lengthTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(lengthResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y235 w305 h30 vResultValue ReadOnly    ;;∙------∙Converted result display.

;;∙------∙Full Precision Result.
fullResultHex := Color(lengthTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, %Font3%
Gui, Converter:Add, Text, x55 y268 w305 h22 vLengthFullResult BackgroundTrans    ;;∙------∙Shows full precision value (under Result display).

GuiControl, Converter:ChooseString, FromUnit, Meters    ;;∙------∙Default from unit.
GuiControl, Converter:ChooseString, ToUnit, Feet    ;;∙------∙Default to unit.

;;∙------∙Return to Intro button (arrow).
backColorHex := Color(introReturn, "GUI0x")    ;;∙------∙Return arrow color set in Variables.

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩    ;;∙------∙Return to intro arrow.

insideBoxHex := Color(lengthTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)    ;;∙------∙Info panel border.
infoTextHex := Color(lengthTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, %Font2%
Gui, Converter:Add, Text, x390 y100 w205 h225 BackgroundTrans, 
(
Convert between common
length and distance units.

Metric:
mm, cm, m, km

Imperial:
inches, feet, yards, miles
)

;;∙================================================∙
;;∙======∙TAB 3: WEIGHT CONVERSIONS∙===============∙
Gui, Converter:Tab, 3

fromHeaderHex := Color(weightTabHeader, "GUI0x")
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Weight Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vWeightFromUnit gWeightUpdateConversion, Milligrams|Grams|Kilograms|Metric Tons|Ounces|Pounds|Stone|US Tons

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gWeightSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(weightTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vWeightToUnit gWeightUpdateConversion, Milligrams|Grams|Kilograms|Metric Tons|Ounces|Pounds|Stone|US Tons

inputHeaderHex := Color(weightTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(weightInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y170 w305 h30 vWeightInputValue gWeightAutoConvert

resultLabelHex := Color(weightTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(weightResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y235 w305 h30 vWeightResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(weightTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, %Font3%
Gui, Converter:Add, Text, x55 y268 w305 h22 vWeightFullResult BackgroundTrans

GuiControl, Converter:ChooseString, WeightFromUnit, Kilograms
GuiControl, Converter:ChooseString, WeightToUnit, Pounds

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(weightTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(weightTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, %Font2%
Gui, Converter:Add, Text, x390 y100 w205 h225 BackgroundTrans, 
(
Convert between common
weight and mass units.

Metric:
mg, g, kg, metric tons

Imperial:
ounces, pounds, stone,
US tons
)

;;∙================================================∙
;;∙======∙TAB 4: VOLUME CONVERSIONS∙==============∙
Gui, Converter:Tab, 4

fromHeaderHex := Color(volumeTabHeader, "GUI0x")
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Volume Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vVolumeFromUnit gVolumeUpdateConversion, Milliliters|Liters|Cubic Meters|Teaspoons|Tablespoons|Fluid Ounces|Cups|Gallons

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gVolumeSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(volumeTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vVolumeToUnit gVolumeUpdateConversion, Milliliters|Liters|Cubic Meters|Teaspoons|Tablespoons|Fluid Ounces|Cups|Gallons

inputHeaderHex := Color(volumeTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(volumeInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y170 w305 h30 vVolumeInputValue gVolumeAutoConvert

resultLabelHex := Color(volumeTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(volumeResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y235 w305 h30 vVolumeResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(volumeTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, %Font3%
Gui, Converter:Add, Text, x55 y268 w305 h22 vVolumeFullResult BackgroundTrans

GuiControl, Converter:ChooseString, VolumeFromUnit, Liters
GuiControl, Converter:ChooseString, VolumeToUnit, Gallons

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(volumeTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(volumeTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, %Font2%
Gui, Converter:Add, Text, x390 y100 w205 h225 BackgroundTrans, 
(
Convert between common
volume and capacity units.

Metric:
mL, L, cubic meters

Cooking & Imperial:
tsp, tbsp, fl oz, cups,
gallons
)

;;∙================================================∙
;;∙======∙TAB 5: AREA CONVERSIONS∙=================∙
Gui, Converter:Tab, 5

fromHeaderHex := Color(areaTabHeader, "GUI0x")
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Area Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vAreaFromUnit gAreaUpdateConversion, Square Millimeters|Square Centimeters|Square Meters|Square Kilometers|Square Inches|Square Feet|Square Yards|Acres

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gAreaSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(areaTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vAreaToUnit gAreaUpdateConversion, Square Millimeters|Square Centimeters|Square Meters|Square Kilometers|Square Inches|Square Feet|Square Yards|Acres

inputHeaderHex := Color(areaTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(areaInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y170 w305 h30 vAreaInputValue gAreaAutoConvert

resultLabelHex := Color(areaTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(areaResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y235 w305 h30 vAreaResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(areaTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, %Font3%
Gui, Converter:Add, Text, x55 y268 w305 h22 vAreaFullResult BackgroundTrans

GuiControl, Converter:ChooseString, AreaFromUnit, Square Meters
GuiControl, Converter:ChooseString, AreaToUnit, Square Feet

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(areaTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(areaTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, %Font2%
Gui, Converter:Add, Text, x390 y100 w205 h225 BackgroundTrans, 
(
Convert between common
area and surface units.

Metric:
sq mm, sq cm, sq m, sq km

Imperial:
sq in, sq ft, sq yd, acres
)

;;∙================================================∙
;;∙======∙TAB 6: TEMPERATURE CONVERSIONS∙=========∙
Gui, Converter:Tab, 6

fromHeaderHex := Color(tempTabHeader, "GUI0x")
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Temperature Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, x55 y110 w120 r3 vTempFromUnit gTempUpdateConversion, Celsius|Fahrenheit|Kelvin

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gTempSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(tempTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, xp y110 w120 r3 vTempToUnit gTempUpdateConversion, Celsius|Fahrenheit|Kelvin

inputHeaderHex := Color(tempTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(tempInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y170 w305 h30 vTempInputValue gTempAutoConvert

resultLabelHex := Color(tempTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(tempResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y235 w305 h30 vTempResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(tempTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, %Font3%
Gui, Converter:Add, Text, x55 y268 w305 h22 vTempFullResult BackgroundTrans

GuiControl, Converter:ChooseString, TempFromUnit, Celsius
GuiControl, Converter:ChooseString, TempToUnit, Fahrenheit

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(tempTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(tempTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, %Font2%
Gui, Converter:Add, Text, x390 y100 w205 h225 BackgroundTrans, 
(
Convert between common
temperature scales.

Celsius (°C)
Fahrenheit (°F)
Kelvin (K)

Formulas:
°F = (°C × 9/5) + 32
K = °C + 273.15

Absolute zero:
-273.15°C = 0 K
No temperature can
go below this!
)

;;∙================================================∙
;;∙======∙TAB 7: SPEED CONVERSIONS∙================∙
Gui, Converter:Tab, 7

fromHeaderHex := Color(speedTabHeader, "GUI0x")
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Speed Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vSpeedFromUnit gSpeedUpdateConversion, Meters per Second|Kilometers per Hour|Miles per Hour|Knots|Feet per Second|Mach

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gSpeedSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(speedTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vSpeedToUnit gSpeedUpdateConversion, Meters per Second|Kilometers per Hour|Miles per Hour|Knots|Feet per Second|Mach

inputHeaderHex := Color(speedTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(speedInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y170 w305 h30 vSpeedInputValue gSpeedAutoConvert

resultLabelHex := Color(speedTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(speedResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y235 w305 h30 vSpeedResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(speedTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, %Font3%
Gui, Converter:Add, Text, x55 y268 w305 h22 vSpeedFullResult BackgroundTrans

GuiControl, Converter:ChooseString, SpeedFromUnit, Kilometers per Hour
GuiControl, Converter:ChooseString, SpeedToUnit, Miles per Hour

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(speedTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(speedTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, %Font2%
Gui, Converter:Add, Text, x390 y100 w205 h225 BackgroundTrans, 
(
Convert between common
speed and velocity units.

Metric & Scientific:
m/s, km/h, Mach

Nautical & Imperial:
mph, knots, ft/s

Note: Mach = sea level
(20°C / 68°F)
)

;;∙================================================∙
;;∙======∙TAB 8: TIME CONVERSIONS∙=================∙
Gui, Converter:Tab, 8

fromHeaderHex := Color(timeTabHeader, "GUI0x")
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Time Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vTimeFromUnit gTimeUpdateConversion, Milliseconds|Seconds|Minutes|Hours|Days|Weeks|Years (365)|Years (Avg)|Years (Leap)

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gTimeSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(timeTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vTimeToUnit gTimeUpdateConversion, Milliseconds|Seconds|Minutes|Hours|Days|Weeks|Years (365)|Years (Avg)|Years (Leap)

inputHeaderHex := Color(timeTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(timeInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y170 w305 h30 vTimeInputValue gTimeAutoConvert

resultLabelHex := Color(timeTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(timeResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y235 w305 h30 vTimeResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(timeTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, %Font3%
Gui, Converter:Add, Text, x55 y268 w305 h22 vTimeFullResult BackgroundTrans

GuiControl, Converter:ChooseString, TimeFromUnit, Hours
GuiControl, Converter:ChooseString, TimeToUnit, Minutes

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(timeTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(timeTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, %Font2%
Gui, Converter:Add, Text, x390 y100 w205 h225 BackgroundTrans, 
(
Convert between common
time duration units.

Base unit: Seconds

Includes:
ms, sec, min, hours,
days, weeks, years

Year options:
• Years (365) = 365 days
• Years (Avg) = 365.25 days
• Years (Leap) = 366 days
)

;;∙================================================∙
;;∙======∙TAB 9: DIGITAL STORAGE CONVERSIONS∙======∙
Gui, Converter:Tab, 9

fromHeaderHex := Color(storageTabHeader, "GUI0x")
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Digital Storage Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vStorageFromUnit gStorageUpdateConversion, Bits|Bytes|Kilobytes|Megabytes|Gigabytes|Terabytes|Petabytes

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gStorageSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(storageTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vStorageToUnit gStorageUpdateConversion, Bits|Bytes|Kilobytes|Megabytes|Gigabytes|Terabytes|Petabytes

inputHeaderHex := Color(storageTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(storageInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y170 w305 h30 vStorageInputValue gStorageAutoConvert

resultLabelHex := Color(storageTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(storageResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y235 w305 h30 vStorageResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(storageTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, %Font3%
Gui, Converter:Add, Text, x55 y268 w305 h22 vStorageFullResult BackgroundTrans

GuiControl, Converter:ChooseString, StorageFromUnit, Gigabytes
GuiControl, Converter:ChooseString, StorageToUnit, Megabytes

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(storageTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(storageTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, %Font2%
Gui, Converter:Add, Text, x390 y100 w205 h225 BackgroundTrans, 
(
Convert between digital
storage units.

Base unit: Bytes

Binary: powers of 1024
1 Byte = 8 Bits
1 KB = 1024 Bytes

Units:
Bits, Bytes, KB, MB,
GB, TB, PB
)

;;∙================================================∙
;;∙======∙TAB 10: CURRENCY CONVERSIONS∙============∙
Gui, Converter:Tab, 10

fromHeaderHex := Color(currencyTabHeader, "GUI0x")
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Currency Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vCurrencyFromUnit gCurrencyUpdateConversion, USD ($)|EUR (€)|GBP (£)|JPY Yen (¥)|CAD (C$)|AUD (A$)|CHF|CNY Yuan (¥)

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gCurrencySwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(currencyTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vCurrencyToUnit gCurrencyUpdateConversion, USD ($)|EUR (€)|GBP (£)|JPY Yen (¥)|CAD (C$)|AUD (A$)|CHF|CNY Yuan (¥)

inputHeaderHex := Color(currencyTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(currencyInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y170 w305 h30 vCurrencyInputValue gCurrencyAutoConvert

;;∙------∙Status Text.
statusTextHex := Color("Yellow", "GUI0x")
Gui, Converter:Font, s8 c%statusTextHex% Norm q5, %Font2%
Gui, Converter:Add, Text, x100 y215 w305 h20 vCurrencyStatusText Center BackgroundTrans,    ;;∙------∙Shows fetch status.

resultLabelHex := Color(currencyTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(currencyResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y235 w305 h30 vCurrencyResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(currencyTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, %Font3%
Gui, Converter:Add, Text, x55 y268 w240 h22 vCurrencyFullResult BackgroundTrans

GuiControl, Converter:ChooseString, CurrencyFromUnit, USD ($)
GuiControl, Converter:ChooseString, CurrencyToUnit, EUR (€)


;;∙------∙Rates Refresh Button / DLL Icon Button (*choice).
;;∙------∙Gui, Converter:Font, s8 c%statusTextHex% Norm q5, %Font2%
;;∙------∙Gui, Converter:Add, Button, x300 y270 w60 h20 gCurrencyFetchRates, Refresh
Gui, Converter:Add, Picture, x335 y270 w24 h24 Icon246 gCurrencyFetchRates BackgroundTrans, shell32.dll    ;;∙------∙[  ]


;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(currencyTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(currencyTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, %Font2%
Gui, Converter:Add, Text, x390 y100 w205 h225 BackgroundTrans, 
(
Live currency exchange
rates via open.er-api.com

Rates auto-fetch when
this tab is opened.

Includes major world
currencies with their
symbols for easy
identification.
)

;;∙================================================∙
;;∙======∙TAB 11: PRESSURE CONVERSIONS∙============∙
Gui, Converter:Tab, 11

fromHeaderHex := Color(pressureTabHeader, "GUI0x")
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Pressure Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vPressureFromUnit gPressureUpdateConversion, Pascals|Kilopascals|Bar|PSI|Atmospheres|mmHg|inHg|Torr

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gPressureSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(pressureTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vPressureToUnit gPressureUpdateConversion, Pascals|Kilopascals|Bar|PSI|Atmospheres|mmHg|inHg|Torr

inputHeaderHex := Color(pressureTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(pressureInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y170 w305 h30 vPressureInputValue gPressureAutoConvert

resultLabelHex := Color(pressureTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(pressureResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y235 w305 h30 vPressureResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(pressureTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, %Font3%
Gui, Converter:Add, Text, x55 y268 w305 h22 vPressureFullResult BackgroundTrans

GuiControl, Converter:ChooseString, PressureFromUnit, PSI
GuiControl, Converter:ChooseString, PressureToUnit, Bar

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(pressureTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(pressureTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, %Font2%
Gui, Converter:Add, Text, x390 y100 w205 h225 BackgroundTrans, 
(
Convert between common
pressure units.

Metric & Scientific:
Pa, kPa, Bar, atm

Imperial & Medical:
PSI, mmHg, inHg, Torr

1 atm = 101,325 Pa
)

;;∙================================================∙
;;∙======∙TAB 12: ENERGY CONVERSIONS∙==============∙
Gui, Converter:Tab, 12

fromHeaderHex := Color(energyTabHeader, "GUI0x")
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Energy Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vEnergyFromUnit gEnergyUpdateConversion, Joules|Kilojoules|Calories|Kilocalories|Watt-hours|Kilowatt-hours|BTU|Electron-volts

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gEnergySwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(energyTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vEnergyToUnit gEnergyUpdateConversion, Joules|Kilojoules|Calories|Kilocalories|Watt-hours|Kilowatt-hours|BTU|Electron-volts

inputHeaderHex := Color(energyTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(energyInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y170 w305 h30 vEnergyInputValue gEnergyAutoConvert

resultLabelHex := Color(energyTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(energyResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y235 w305 h30 vEnergyResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(energyTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, %Font3%
Gui, Converter:Add, Text, x55 y268 w305 h22 vEnergyFullResult BackgroundTrans

GuiControl, Converter:ChooseString, EnergyFromUnit, Joules
GuiControl, Converter:ChooseString, EnergyToUnit, Calories

;;∙------∙Return to Intro button (↩).
backColorHex := Color(introReturn, "GUI0x")

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(energyTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(energyTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, %Font2%
Gui, Converter:Add, Text, x390 y100 w205 h225 BackgroundTrans, 
(
Convert between common
energy units.

Scientific:
J, kJ, Wh, kWh, eV

Nutrition & Thermal:
cal, kcal, BTU

1 cal = 4.184 J
)

;;∙================================================∙
;;∙======∙TAB 13: POWER CONVERSIONS∙==============∙
Gui, Converter:Tab, 13

fromHeaderHex := Color(powerTabHeader, "GUI0x")
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Power Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vPowerFromUnit gPowerUpdateConversion, Watts|Kilowatts|Megawatts|Horsepower|BTU per Hour|Foot-pounds per Second

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gPowerSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(powerTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vPowerToUnit gPowerUpdateConversion, Watts|Kilowatts|Megawatts|Horsepower|BTU per Hour|Foot-pounds per Second

inputHeaderHex := Color(powerTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(powerInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y170 w305 h30 vPowerInputValue gPowerAutoConvert

resultLabelHex := Color(powerTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(powerResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y235 w305 h30 vPowerResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(powerTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, %Font3%
Gui, Converter:Add, Text, x55 y268 w305 h22 vPowerFullResult BackgroundTrans

GuiControl, Converter:ChooseString, PowerFromUnit, Watts
GuiControl, Converter:ChooseString, PowerToUnit, Horsepower

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(powerTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(powerTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, %Font2%
Gui, Converter:Add, Text, x390 y100 w205 h225 BackgroundTrans, 
(
Convert between common
power units.

Electrical & Mechanical:
W, kW, MW, hp, ft·lb/s

Thermal:
BTU/hr

1 hp = 745.7 W
)

;;∙================================================∙
;;∙======∙TAB 14: FUEL CONSUMPTION CONVERSIONS∙===∙
Gui, Converter:Tab, 14

fromHeaderHex := Color(fuelTabHeader, "GUI0x")
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Fuel Consumption Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vFuelFromUnit gFuelUpdateConversion, MPG (US)|MPG (UK)|L/100km|km/L|Miles per Liter

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gFuelSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(fuelTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vFuelToUnit gFuelUpdateConversion, MPG (US)|MPG (UK)|L/100km|km/L|Miles per Liter

inputHeaderHex := Color(fuelTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(fuelInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y170 w305 h30 vFuelInputValue gFuelAutoConvert

resultLabelHex := Color(fuelTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(fuelResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y235 w305 h30 vFuelResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(fuelTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, %Font3%
Gui, Converter:Add, Text, x55 y268 w305 h22 vFuelFullResult BackgroundTrans

GuiControl, Converter:ChooseString, FuelFromUnit, MPG (US)
GuiControl, Converter:ChooseString, FuelToUnit, L/100km

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(fuelTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(fuelTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, %Font2%
Gui, Converter:Add, Text, x390 y100 w205 h225 BackgroundTrans, 
(
Convert between common
fuel economy units.

US & UK MPG:
Miles per gallon

Metric:
L/100km, km/L

Lower L/100km =
better fuel economy
)

;;∙================================================∙
;;∙======∙TAB 15: DATA TRANSFER CONVERSIONS∙=======∙
Gui, Converter:Tab, 15

fromHeaderHex := Color(dataTabHeader, "GUI0x")
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Data Transfer Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vDataFromUnit gDataUpdateConversion, bps|Kbps|Mbps|Gbps|B/s|KB/s|MB/s|GB/s

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gDataSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(dataTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vDataToUnit gDataUpdateConversion, bps|Kbps|Mbps|Gbps|B/s|KB/s|MB/s|GB/s

inputHeaderHex := Color(dataTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(dataInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y170 w305 h30 vDataInputValue gDataAutoConvert

resultLabelHex := Color(dataTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(dataResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y235 w305 h30 vDataResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(dataTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, %Font3%
Gui, Converter:Add, Text, x55 y268 w305 h22 vDataFullResult BackgroundTrans

GuiControl, Converter:ChooseString, DataFromUnit, Mbps
GuiControl, Converter:ChooseString, DataToUnit, MB/s

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(dataTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(dataTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, %Font2%
Gui, Converter:Add, Text, x390 y100 w205 h225 BackgroundTrans, 
(
Convert between data
transfer speed units.

Bit-based:
bps, Kbps, Mbps, Gbps

Byte-based:
B/s, KB/s, MB/s, GB/s

1 B/s = 8 bps
)

;;∙================================================∙
;;∙======∙TAB 16: ANGLE CONVERSIONS∙===============∙
Gui, Converter:Tab, 16

fromHeaderHex := Color(angleTabHeader, "GUI0x")
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Angle Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vAngleFromUnit gAngleUpdateConversion, Degrees|Radians|Gradians|Arcminutes|Arcseconds|Revolutions

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gAngleSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(angleTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vAngleToUnit gAngleUpdateConversion, Degrees|Radians|Gradians|Arcminutes|Arcseconds|Revolutions

inputHeaderHex := Color(angleTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(angleInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y170 w305 h30 vAngleInputValue gAngleAutoConvert

resultLabelHex := Color(angleTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(angleResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y235 w305 h30 vAngleResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(angleTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, %Font3%
Gui, Converter:Add, Text, x55 y268 w305 h22 vAngleFullResult BackgroundTrans

GuiControl, Converter:ChooseString, AngleFromUnit, Degrees
GuiControl, Converter:ChooseString, AngleToUnit, Radians

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(angleTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(angleTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, %Font2%
Gui, Converter:Add, Text, x390 y100 w205 h225 BackgroundTrans, 
(
Convert between common
angle and rotation units.

Common:
Degrees, Radians,
Revolutions

Precision:
Arcminutes, Arcseconds

π rad = 180°
)

;;∙================================================∙
;;∙======∙TAB 17: TORQUE CONVERSIONS∙==============∙
Gui, Converter:Tab, 17

fromHeaderHex := Color(torqueTabHeader, "GUI0x")
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Torque Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vTorqueFromUnit gTorqueUpdateConversion, Newton-meters|Foot-pounds|Inch-pounds|Kilogram-meters|Dyne-centimeters

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gTorqueSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(torqueTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vTorqueToUnit gTorqueUpdateConversion, Newton-meters|Foot-pounds|Inch-pounds|Kilogram-meters|Dyne-centimeters

inputHeaderHex := Color(torqueTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(torqueInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y170 w305 h30 vTorqueInputValue gTorqueAutoConvert

resultLabelHex := Color(torqueTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(torqueResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y235 w305 h30 vTorqueResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(torqueTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, %Font3%
Gui, Converter:Add, Text, x55 y268 w305 h22 vTorqueFullResult BackgroundTrans

GuiControl, Converter:ChooseString, TorqueFromUnit, Newton-meters
GuiControl, Converter:ChooseString, TorqueToUnit, Foot-pounds

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(torqueTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(torqueTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, %Font2%
Gui, Converter:Add, Text, x390 y100 w205 h225 BackgroundTrans, 
(
Convert between common
torque and moment units.

Metric:
N·m, kg·m, dyne·cm

Imperial:
ft·lb, in·lb

1 ft·lb = 1.35582 N·m
)

;;∙================================================∙
;;∙======∙TAB 18: FORCE CONVERSIONS∙===============∙
Gui, Converter:Tab, 18

fromHeaderHex := Color(forceTabHeader, "GUI0x")
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Force Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vForceFromUnit gForceUpdateConversion, Newtons|Kilonewtons|Pounds-force|Kilograms-force|Dynes

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gForceSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(forceTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vForceToUnit gForceUpdateConversion, Newtons|Kilonewtons|Pounds-force|Kilograms-force|Dynes

inputHeaderHex := Color(forceTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(forceInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y170 w305 h30 vForceInputValue gForceAutoConvert

resultLabelHex := Color(forceTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(forceResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y235 w305 h30 vForceResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(forceTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, %Font3%
Gui, Converter:Add, Text, x55 y268 w305 h22 vForceFullResult BackgroundTrans

GuiControl, Converter:ChooseString, ForceFromUnit, Newtons
GuiControl, Converter:ChooseString, ForceToUnit, Pounds-force

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(forceTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(forceTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, %Font2%
Gui, Converter:Add, Text, x390 y100 w205 h225 BackgroundTrans, 
(
Convert between common
force units.

Metric:
N, kN, kg·f, dynes

Imperial:
lb·f

1 lb·f = 4.44822 N
)

;;∙================================================∙
;;∙======∙TAB 19: ACCELERATION CONVERSIONS∙========∙
Gui, Converter:Tab, 19

fromHeaderHex := Color(accelTabHeader, "GUI0x")
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Acceleration Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vAccelFromUnit gAccelUpdateConversion, m/s²|ft/s²|g-force|Gal|in/s²|km/h/s

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gAccelSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(accelTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, %Font2%
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vAccelToUnit gAccelUpdateConversion, m/s²|ft/s²|g-force|Gal|in/s²|km/h/s

inputHeaderHex := Color(accelTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(accelInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y170 w305 h30 vAccelInputValue gAccelAutoConvert

resultLabelHex := Color(accelTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, %Font2%
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(accelResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, %Font3%
Gui, Converter:Add, Edit, x55 y235 w305 h30 vAccelResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(accelTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, %Font3%
Gui, Converter:Add, Text, x55 y268 w305 h22 vAccelFullResult BackgroundTrans

GuiControl, Converter:ChooseString, AccelFromUnit, m/s²
GuiControl, Converter:ChooseString, AccelToUnit, ft/s²

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, %Font1%
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(accelTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(accelTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, %Font2%
Gui, Converter:Add, Text, x390 y100 w205 h225 BackgroundTrans, 
(
Convert between common
acceleration units.

Metric & Scientific:
m/s², Gal, km/h/s

1 Gal = 1 cm/s²
(gravimetry)

Imperial & Aviation:
ft/s², in/s², g-force

1 g = 9.80665 m/s²
)

;;∙================================================∙
;;∙======∙SHOW GUI & INITIALIZE∙====================∙
GuiControl, Converter:Choose, ConverterTabs, % defaultTab    ;;∙------∙Sets starting tab.
Gui, Converter:Show, x%guiX% y%guiY% w%guiW% h%guiH%, %ScriptID%

If (windowTransparency < 255) {
    WinGet, hwnd, ID, %ScriptID%
    WinSet, Transparent, %windowTransparency%, ahk_id %hwnd%    ;;∙------∙Applies transparency if set.
}
SetTimer, CurrencyFetchRates, -500    ;;∙------∙Fetch currency rates shortly after GUI loads.
Return
;;∙------------------------------------------------------------------------∙


;;∙======================================∙Tab 1∙====∙
;;∙======∙INTRO TAB NAVIGATION∙====================∙
GoToTab1:    ;;∙------∙Introduction.
    GuiControl, Converter:Choose, ConverterTabs, 1
Return
GoToTab2:    ;;∙------∙Length.
    GuiControl, Converter:Choose, ConverterTabs, 2
Return
GoToTab3:    ;;∙------∙Weight/Mass.
    GuiControl, Converter:Choose, ConverterTabs, 3
Return
GoToTab4:    ;;∙------∙Volume.
    GuiControl, Converter:Choose, ConverterTabs, 4
Return
GoToTab5:    ;;∙------∙Area.
    GuiControl, Converter:Choose, ConverterTabs, 5
Return
GoToTab6:    ;;∙------∙Temperature.
    GuiControl, Converter:Choose, ConverterTabs, 6
Return
GoToTab7:    ;;∙------∙Speed.
    GuiControl, Converter:Choose, ConverterTabs, 7
Return
GoToTab8:    ;;∙------∙Time.
    GuiControl, Converter:Choose, ConverterTabs, 8
Return
GoToTab9:    ;;∙------∙Digital Storage.
    GuiControl, Converter:Choose, ConverterTabs, 9
Return
GoToTab10:    ;;∙------∙Currency.
    GuiControl, Converter:Choose, ConverterTabs, 10
        GoSub, CurrencyFetchRates
Return
GoToTab11:    ;;∙------∙Pressure.
    GuiControl, Converter:Choose, ConverterTabs, 11
Return
GoToTab12:    ;;∙------∙Energy.
    GuiControl, Converter:Choose, ConverterTabs, 12
Return
GoToTab13:    ;;∙------∙Power.
    GuiControl, Converter:Choose, ConverterTabs, 13
Return
GoToTab14:    ;;∙------∙Fuel.
    GuiControl, Converter:Choose, ConverterTabs, 14
Return
GoToTab15:    ;;∙------∙Data Transfer.
    GuiControl, Converter:Choose, ConverterTabs, 15
Return
GoToTab16:    ;;∙------∙Angle.
    GuiControl, Converter:Choose, ConverterTabs, 16
Return
GoToTab17:    ;;∙------∙Torque.
    GuiControl, Converter:Choose, ConverterTabs, 17
Return
GoToTab18:    ;;∙------∙Force.
    GuiControl, Converter:Choose, ConverterTabs, 18
Return
GoToTab19:    ;;∙------∙Acceleration.
    GuiControl, Converter:Choose, ConverterTabs, 19
Return

;;∙======================================∙Tab 2∙====∙
;;∙======∙LENGTH CONVERSION LOGIC∙================∙
GetMeterFactor(unitName) {
    If (unitName = "Millimeters")
        Return 0.001    ;;∙------∙1 mm = 0.001 meters.
    If (unitName = "Centimeters")
        Return 0.01    ;;∙------∙1 cm = 0.01 meters.
    If (unitName = "Meters")
        Return 1.0    ;;∙------∙Base unit.
    If (unitName = "Kilometers")
        Return 1000.0    ;;∙------∙1 km = 1000 meters.
    If (unitName = "Inches")
        Return 0.0254    ;;∙------∙1 inch = 0.0254 meters.
    If (unitName = "Feet")
        Return 0.3048    ;;∙------∙1 foot = 0.3048 meters.
    If (unitName = "Yards")
        Return 0.9144    ;;∙------∙1 yard = 0.9144 meters.
    If (unitName = "Miles")
        Return 1609.344    ;;∙------∙1 mile = 1609.344 meters.
}
;;∙------------------------∙
ConvertLength(value, fromUnitName, toUnitName) {
    meters := value * GetMeterFactor(fromUnitName)    ;;∙------∙Convert to meters.
    result := meters / GetMeterFactor(toUnitName)    ;;∙------∙Convert from meters to target unit.
    Return result
}
;;∙------------------------∙
AutoConvert:
    Gui, Converter:Submit, NoHide
    If (InputValue = "") {
        GuiControl, Converter:, ResultValue,
        Return
    }
    If (!RegExMatch(InputValue, "^-?\d*\.?\d+$")) {    ;;∙------∙Validates numeric input.
        Return
    }
    result := ConvertLength(InputValue, FromUnit, ToUnit)
    If (Abs(result) = 0)
        GuiControl, Converter:, ResultValue, 0
    Else If (Abs(result) < 0.01 && Abs(result) > 0)
        GuiControl, Converter:, ResultValue, % Format("{:.6f}", result)    ;;∙------∙High precision for small values.
    Else If (Abs(result) >= 1000000)
        GuiControl, Converter:, ResultValue, % Format("{:.2e}", result)    ;;∙------∙Scientific notation for large values.
    Else
        GuiControl, Converter:, ResultValue, % Format("{:.2f}", result)    ;;∙------∙Standard formatting.
    ;;∙------∙Show full precision.
    fullResult := RegExReplace(Format("{:.15f}", result), "\.?0+$")
    If (StrLen(fullResult) > 30)
        fullResult := Format("{:.10e}", result)
    GuiControl, Converter:, LengthFullResult, %fullResult%
Return
;;∙------------------------∙
UpdateConversion:
    Gui, Converter:Submit, NoHide
    
    If (InputValue != "" && RegExMatch(InputValue, "^-?\d*\.?\d+$"))
        GoSub, AutoConvert
Return
;;∙------------------------∙
SwapUnits:
    Gui, Converter:Submit, NoHide
    tempFrom := FromUnit    ;;∙------∙Store current from unit.
    tempTo := ToUnit    ;;∙------∙Store current to unit.
    GuiControl, Converter:ChooseString, FromUnit, % tempTo    ;;∙------∙Swap: to becomes from.
    GuiControl, Converter:ChooseString, ToUnit, % tempFrom    ;;∙------∙Swap: from becomes to.
    Gui, Converter:Submit, NoHide
    If (InputValue != "" && RegExMatch(InputValue, "^-?\d*\.?\d+$"))
        GoSub, AutoConvert
    SoundBeep, 800, 100    ;;∙------∙Audible confirmation.
Return

;;∙======================================∙Tab 3∙====∙
;;∙======∙WEIGHT CONVERSION LOGIC∙================∙
GetGramFactor(unitName) {
    If (unitName = "Milligrams")
        Return 0.001    ;;∙------∙1 mg = 0.001 grams.
    If (unitName = "Grams")
        Return 1.0    ;;∙------∙Base unit.
    If (unitName = "Kilograms")
        Return 1000.0    ;;∙------∙1 kg = 1000 grams.
    If (unitName = "Metric Tons")
        Return 1000000.0    ;;∙------∙1 metric ton = 1,000,000 grams.
    If (unitName = "Ounces")
        Return 28.3495    ;;∙------∙1 oz = 28.3495 grams.
    If (unitName = "Pounds")
        Return 453.592    ;;∙------∙1 lb = 453.592 grams.
    If (unitName = "Stone")
        Return 6350.29    ;;∙------∙1 stone = 6350.29 grams.
    If (unitName = "US Tons")
        Return 907185.0    ;;∙------∙1 US ton = 907,185 grams.
}
;;∙------------------------∙
ConvertWeight(value, fromUnitName, toUnitName) {
    grams := value * GetGramFactor(fromUnitName)    ;;∙------∙Convert to grams.
    result := grams / GetGramFactor(toUnitName)    ;;∙------∙Convert from grams to target unit.
    Return result
}
;;∙------------------------∙
WeightAutoConvert:
    Gui, Converter:Submit, NoHide
    
    If (WeightInputValue = "") {
        GuiControl, Converter:, WeightResultValue,
        Return
    }
    If (!RegExMatch(WeightInputValue, "^-?\d*\.?\d+$")) {
        Return
    }
    ;;∙------∙Prevent negative weight/mass values
    If (WeightInputValue < 0) {
        GuiControl, Converter:, WeightResultValue, ERROR: Negative weight not allowed
        GuiControl, Converter:, WeightFullResult, Weight/mass cannot be negative!
        Return
    }
    result := ConvertWeight(WeightInputValue, WeightFromUnit, WeightToUnit)
    If (Abs(result) = 0)
        GuiControl, Converter:, WeightResultValue, 0
    Else If (Abs(result) < 0.01 && Abs(result) > 0)
        GuiControl, Converter:, WeightResultValue, % Format("{:.6f}", result)
    Else If (Abs(result) >= 1000000)
        GuiControl, Converter:, WeightResultValue, % Format("{:.2e}", result)
    Else
        GuiControl, Converter:, WeightResultValue, % Format("{:.2f}", result)
    ;;∙------∙Show full precision.
    fullResult := RegExReplace(Format("{:.15f}", result), "\.?0+$")
    If (StrLen(fullResult) > 30)
        fullResult := Format("{:.10e}", result)
    GuiControl, Converter:, WeightFullResult, %fullResult%
Return
;;∙------------------------∙
WeightUpdateConversion:
    Gui, Converter:Submit, NoHide
    
    If (WeightInputValue != "" && RegExMatch(WeightInputValue, "^-?\d*\.?\d+$"))
        GoSub, WeightAutoConvert
Return
;;∙------------------------∙
WeightSwapUnits:
    Gui, Converter:Submit, NoHide
    tempFrom := WeightFromUnit
    tempTo := WeightToUnit
    GuiControl, Converter:ChooseString, WeightFromUnit, % tempTo
    GuiControl, Converter:ChooseString, WeightToUnit, % tempFrom
    Gui, Converter:Submit, NoHide
    If (WeightInputValue != "" && RegExMatch(WeightInputValue, "^-?\d*\.?\d+$"))
        GoSub, WeightAutoConvert
    SoundBeep, 800, 100
Return

;;∙======================================∙Tab 4∙====∙
;;∙======∙VOLUME CONVERSION LOGIC∙===============∙
GetLiterFactor(unitName) {
    If (unitName = "Milliliters")
        Return 0.001    ;;∙------∙1 mL = 0.001 liters.
    If (unitName = "Liters")
        Return 1.0    ;;∙------∙Base unit.
    If (unitName = "Cubic Meters")
        Return 1000.0    ;;∙------∙1 m³ = 1000 liters.
    If (unitName = "Teaspoons")
        Return 0.00492892    ;;∙------∙1 tsp = 0.00492892 liters.
    If (unitName = "Tablespoons")
        Return 0.0147868    ;;∙------∙1 Tbsp = 0.0147868 liters.
    If (unitName = "Fluid Ounces")
        Return 0.0295735    ;;∙------∙1 fl oz = 0.0295735 liters.
    If (unitName = "Cups")
        Return 0.236588    ;;∙------∙1 cup = 0.236588 liters.
    If (unitName = "Gallons")
        Return 3.78541    ;;∙------∙1 US gallon = 3.78541 liters.
}
;;∙------------------------∙
ConvertVolume(value, fromUnitName, toUnitName) {
    liters := value * GetLiterFactor(fromUnitName)    ;;∙------∙Convert to liters.
    result := liters / GetLiterFactor(toUnitName)    ;;∙------∙Convert from liters to target unit.
    Return result
}
;;∙------------------------∙
VolumeAutoConvert:
    Gui, Converter:Submit, NoHide
    If (VolumeInputValue = "") {
        GuiControl, Converter:, VolumeResultValue,
        Return
    }
    If (!RegExMatch(VolumeInputValue, "^-?\d*\.?\d+$")) {
        Return
    }
    ;;∙------∙Prevent negative volume values
    If (VolumeInputValue < 0) {
        GuiControl, Converter:, VolumeResultValue, ERROR: Negative volume not allowed
        GuiControl, Converter:, VolumeFullResult, Volume cannot be negative!
        Return
    }
    result := ConvertVolume(VolumeInputValue, VolumeFromUnit, VolumeToUnit)
    If (Abs(result) = 0)
        GuiControl, Converter:, VolumeResultValue, 0
    Else If (Abs(result) < 0.01 && Abs(result) > 0)
        GuiControl, Converter:, VolumeResultValue, % Format("{:.6f}", result)
    Else If (Abs(result) >= 1000000)
        GuiControl, Converter:, VolumeResultValue, % Format("{:.2e}", result)
    Else
        GuiControl, Converter:, VolumeResultValue, % Format("{:.2f}", result)
    ;;∙------∙Show full precision.
    fullResult := RegExReplace(Format("{:.15f}", result), "\.?0+$")
    If (StrLen(fullResult) > 30)
        fullResult := Format("{:.10e}", result)
    GuiControl, Converter:, VolumeFullResult, %fullResult%
Return
;;∙------------------------∙
VolumeUpdateConversion:
    Gui, Converter:Submit, NoHide
    If (VolumeInputValue != "" && RegExMatch(VolumeInputValue, "^-?\d*\.?\d+$"))
        GoSub, VolumeAutoConvert
Return
;;∙------------------------∙
VolumeSwapUnits:
    Gui, Converter:Submit, NoHide
    tempFrom := VolumeFromUnit
    tempTo := VolumeToUnit
    GuiControl, Converter:ChooseString, VolumeFromUnit, % tempTo
    GuiControl, Converter:ChooseString, VolumeToUnit, % tempFrom
    Gui, Converter:Submit, NoHide
    If (VolumeInputValue != "" && RegExMatch(VolumeInputValue, "^-?\d*\.?\d+$"))
        GoSub, VolumeAutoConvert
    SoundBeep, 800, 100
Return

;;∙======================================∙Tab 5∙====∙
;;∙======∙AREA CONVERSION LOGIC∙==================∙
GetSquareMeterFactor(unitName) {
    If (unitName = "Square Millimeters")
        Return 0.000001    ;;∙------∙1 mm² = 0.000001 m².
    If (unitName = "Square Centimeters")
        Return 0.0001    ;;∙------∙1 cm² = 0.0001 m².
    If (unitName = "Square Meters")
        Return 1.0    ;;∙------∙Base unit.
    If (unitName = "Square Kilometers")
        Return 1000000.0    ;;∙------∙1 km² = 1,000,000 m².
    If (unitName = "Square Inches")
        Return 0.00064516    ;;∙------∙1 in² = 0.00064516 m².
    If (unitName = "Square Feet")
        Return 0.092903    ;;∙------∙1 ft² = 0.092903 m².
    If (unitName = "Square Yards")
        Return 0.836127    ;;∙------∙1 yd² = 0.836127 m².
    If (unitName = "Acres")
        Return 4046.86    ;;∙------∙1 acre = 4046.86 m².
}
;;∙------------------------∙
ConvertArea(value, fromUnitName, toUnitName) {
    sqMeters := value * GetSquareMeterFactor(fromUnitName)    ;;∙------∙Convert to square meters.
    result := sqMeters / GetSquareMeterFactor(toUnitName)    ;;∙------∙Convert from square meters to target unit.
    Return result
}
;;∙------------------------∙
AreaAutoConvert:
    Gui, Converter:Submit, NoHide
    If (AreaInputValue = "") {
        GuiControl, Converter:, AreaResultValue,
        Return
    }
    If (!RegExMatch(AreaInputValue, "^-?\d*\.?\d+$")) {
        Return
    }
    ;;∙------∙Prevent negative area values.
    If (AreaInputValue < 0) {
        GuiControl, Converter:, AreaResultValue, ERROR: Negative area not allowed
        GuiControl, Converter:, AreaFullResult, Area cannot be negative!
        Return
    }
    result := ConvertArea(AreaInputValue, AreaFromUnit, AreaToUnit)
    If (Abs(result) = 0)
        GuiControl, Converter:, AreaResultValue, 0
    Else If (Abs(result) < 0.01 && Abs(result) > 0)
        GuiControl, Converter:, AreaResultValue, % Format("{:.6f}", result)
    Else If (Abs(result) >= 1000000)
        GuiControl, Converter:, AreaResultValue, % Format("{:.2e}", result)
    Else
        GuiControl, Converter:, AreaResultValue, % Format("{:.2f}", result)
    ;;∙------∙Show full precision.
    fullResult := RegExReplace(Format("{:.15f}", result), "\.?0+$")
    If (StrLen(fullResult) > 30)
        fullResult := Format("{:.10e}", result)
    GuiControl, Converter:, AreaFullResult, %fullResult%
Return
;;∙------------------------∙
AreaUpdateConversion:
    Gui, Converter:Submit, NoHide
    If (AreaInputValue != "" && RegExMatch(AreaInputValue, "^-?\d*\.?\d+$"))
        GoSub, AreaAutoConvert
Return
;;∙------------------------∙
AreaSwapUnits:
    Gui, Converter:Submit, NoHide
    tempFrom := AreaFromUnit
    tempTo := AreaToUnit
    GuiControl, Converter:ChooseString, AreaFromUnit, % tempTo
    GuiControl, Converter:ChooseString, AreaToUnit, % tempFrom
    
    Gui, Converter:Submit, NoHide
    If (AreaInputValue != "" && RegExMatch(AreaInputValue, "^-?\d*\.?\d+$"))
        GoSub, AreaAutoConvert
    SoundBeep, 800, 100
Return

;;∙======================================∙Tab 6∙====∙
;;∙======∙TEMPERATURE CONVERSION LOGIC∙==========∙
ConvertTemperature(value, fromUnit, toUnit) {
    ;;∙------∙Convert input value to Celsius first (base unit).
    If (fromUnit = "Celsius")
        celsius := value
    Else If (fromUnit = "Fahrenheit")
        celsius := (value - 32) * 5 / 9    ;;∙------∙°F to °C formula.
    Else If (fromUnit = "Kelvin")
        celsius := value - 273.15    ;;∙------∙K to °C formula.
    ;;∙------∙Convert from Celsius to target unit.
    If (toUnit = "Celsius")
        Return celsius
    Else If (toUnit = "Fahrenheit")
        Return (celsius * 9 / 5) + 32    ;;∙------∙°C to °F formula.
    Else If (toUnit = "Kelvin")
        Return celsius + 273.15    ;;∙------∙°C to K formula.
    Return 0
}
;;∙------------------------∙
TempAutoConvert:
    Gui, Converter:Submit, NoHide
    If (TempInputValue = "") {
        GuiControl, Converter:, TempResultValue,
        Return
    }
    If (!RegExMatch(TempInputValue, "^-?\d*\.?\d+$")) {
        Return
    }
    ;;∙------∙Validate physically possible temperatures.
    inputValue := TempInputValue
    ;;∙------∙Check Kelvin (cannot be below 0).
    If (TempFromUnit = "Kelvin" && inputValue < 0) {
        GuiControl, Converter:, TempResultValue, ERROR: Below absolute zero (0 K)
        GuiControl, Converter:, TempFullResult, Kelvin cannot be negative!
        Return
    }
    ;;∙------∙Check Celsius (cannot be below -273.15).
    If (TempFromUnit = "Celsius" && inputValue < -273.15) {
        GuiControl, Converter:, TempResultValue, ERROR: Below absolute zero (-273.15°C)
        GuiControl, Converter:, TempFullResult, Temperature cannot go below absolute zero!
        Return
    }
    ;;∙------∙Check Fahrenheit (cannot be below -459.67).
    If (TempFromUnit = "Fahrenheit" && inputValue < -459.67) {
        GuiControl, Converter:, TempResultValue, ERROR: Below absolute zero (-459.67°F)
        GuiControl, Converter:, TempFullResult, Temperature cannot go below absolute zero!
        Return
    }
    result := ConvertTemperature(TempInputValue, TempFromUnit, TempToUnit)
    ;;∙------∙Also validate result if converting TO Kelvin/Celsius/Fahrenheit.
    If (TempToUnit = "Kelvin" && result < 0) {
        GuiControl, Converter:, TempResultValue, ERROR: Result below absolute zero (0 K)
        GuiControl, Converter:, TempFullResult, Conversion would result in negative Kelvin!
        Return
    }
    If (TempToUnit = "Celsius" && result < -273.15) {
        GuiControl, Converter:, TempResultValue, ERROR: Result below absolute zero (-273.15°C)
        GuiControl, Converter:, TempFullResult, Conversion would go below absolute zero!
        Return
    }
    If (TempToUnit = "Fahrenheit" && result < -459.67) {
        GuiControl, Converter:, TempResultValue, ERROR: Result below absolute zero (-459.67°F)
        GuiControl, Converter:, TempFullResult, Conversion would go below absolute zero!
        Return
    }
    If (Abs(result) = 0)
        GuiControl, Converter:, TempResultValue, 0
    Else If (Abs(result) < 0.01 && Abs(result) > 0)
        GuiControl, Converter:, TempResultValue, % Format("{:.6f}", result)
    Else If (Abs(result) >= 1000000)
        GuiControl, Converter:, TempResultValue, % Format("{:.2e}", result)
    Else
        GuiControl, Converter:, TempResultValue, % Format("{:.2f}", result)
    ;;∙------∙Show full precision.
    fullResult := RegExReplace(Format("{:.15f}", result), "\.?0+$")
    If (StrLen(fullResult) > 30)
        fullResult := Format("{:.10e}", result)
    GuiControl, Converter:, TempFullResult, %fullResult%
Return
;;∙------------------------∙
TempUpdateConversion:
    Gui, Converter:Submit, NoHide
    
    If (TempInputValue != "" && RegExMatch(TempInputValue, "^-?\d*\.?\d+$"))
        GoSub, TempAutoConvert
Return
;;∙------------------------∙
TempSwapUnits:
    Gui, Converter:Submit, NoHide
    tempFrom := TempFromUnit
    tempTo := TempToUnit
    GuiControl, Converter:ChooseString, TempFromUnit, % tempTo
    GuiControl, Converter:ChooseString, TempToUnit, % tempFrom
    Gui, Converter:Submit, NoHide
    If (TempInputValue != "" && RegExMatch(TempInputValue, "^-?\d*\.?\d+$"))
        GoSub, TempAutoConvert
    SoundBeep, 800, 100
Return

;;∙======================================∙Tab 7∙====∙
;;∙======∙SPEED CONVERSION LOGIC∙=================∙
GetMetersPerSecondFactor(unitName) {
    If (unitName = "Meters per Second")
        Return 1.0    ;;∙------∙Base unit.
    If (unitName = "Kilometers per Hour")
        Return 0.277778    ;;∙------∙1 km/h = 0.277778 m/s.
    If (unitName = "Miles per Hour")
        Return 0.44704    ;;∙------∙1 mph = 0.44704 m/s.
    If (unitName = "Knots")
        Return 0.514444    ;;∙------∙1 knot = 0.514444 m/s.
    If (unitName = "Feet per Second")
        Return 0.3048    ;;∙------∙1 ft/s = 0.3048 m/s.
    If (unitName = "Mach")
        Return 343.0    ;;∙------∙Mach 1 (at sea level) = 343 m/s.
}
;;∙------------------------∙
ConvertSpeed(value, fromUnitName, toUnitName) {
    mps := value * GetMetersPerSecondFactor(fromUnitName)    ;;∙------∙Convert to m/s.
    result := mps / GetMetersPerSecondFactor(toUnitName)    ;;∙------∙Convert from m/s to target unit.
    Return result
}
;;∙------------------------∙
SpeedAutoConvert:
    Gui, Converter:Submit, NoHide
    If (SpeedInputValue = "") {
        GuiControl, Converter:, SpeedResultValue,
        Return
    }
    If (!RegExMatch(SpeedInputValue, "^-?\d*\.?\d+$")) {
        Return
    }
    ;;∙------∙Prevent negative speed values
    If (SpeedInputValue < 0) {
        GuiControl, Converter:, SpeedResultValue, ERROR: Negative speed not allowed
        GuiControl, Converter:, SpeedFullResult, Speed cannot be negative!
        Return
    }
    result := ConvertSpeed(SpeedInputValue, SpeedFromUnit, SpeedToUnit)
    If (Abs(result) = 0)
        GuiControl, Converter:, SpeedResultValue, 0
    Else If (Abs(result) < 0.01 && Abs(result) > 0)
        GuiControl, Converter:, SpeedResultValue, % Format("{:.6f}", result)
    Else If (Abs(result) >= 1000000)
        GuiControl, Converter:, SpeedResultValue, % Format("{:.2e}", result)
    Else
        GuiControl, Converter:, SpeedResultValue, % Format("{:.2f}", result)
    ;;∙------∙Show full precision.
    fullResult := RegExReplace(Format("{:.15f}", result), "\.?0+$")
    If (StrLen(fullResult) > 30)
        fullResult := Format("{:.10e}", result)
    GuiControl, Converter:, SpeedFullResult, %fullResult%
Return
;;∙------------------------∙
SpeedUpdateConversion:
    Gui, Converter:Submit, NoHide
    
    If (SpeedInputValue != "" && RegExMatch(SpeedInputValue, "^-?\d*\.?\d+$"))
        GoSub, SpeedAutoConvert
Return
;;∙------------------------∙
SpeedSwapUnits:
    Gui, Converter:Submit, NoHide
    tempFrom := SpeedFromUnit
    tempTo := SpeedToUnit
    GuiControl, Converter:ChooseString, SpeedFromUnit, % tempTo
    GuiControl, Converter:ChooseString, SpeedToUnit, % tempFrom
    Gui, Converter:Submit, NoHide
    If (SpeedInputValue != "" && RegExMatch(SpeedInputValue, "^-?\d*\.?\d+$"))
        GoSub, SpeedAutoConvert
    SoundBeep, 800, 100
Return

;;∙======================================∙Tab 8∙====∙
;;∙======∙TIME CONVERSION LOGIC∙==================∙
GetSecondsFactor(unitName) {
    If (unitName = "Milliseconds")
        Return 0.001
    If (unitName = "Seconds")
        Return 1.0
    If (unitName = "Minutes")
        Return 60.0
    If (unitName = "Hours")
        Return 3600.0
    If (unitName = "Days")
        Return 86400.0
    If (unitName = "Weeks")
        Return 604800.0
    If (unitName = "Years (365)")
        Return 31536000.0    ;;∙------∙365 days = 31,536,000 seconds.
    If (unitName = "Years (Avg)")
        Return 31557600.0    ;;∙------∙365.25 days = 31,557,600 seconds.
    If (unitName = "Years (Leap)")
        Return 31622400.0    ;;∙------∙366 days = 31,622,400 seconds.
}
;;∙------------------------∙
ConvertTime(value, fromUnitName, toUnitName) {
    seconds := value * GetSecondsFactor(fromUnitName)    ;;∙------∙Convert to seconds.
    result := seconds / GetSecondsFactor(toUnitName)    ;;∙------∙Convert from seconds to target unit.
    Return result
}
;;∙------------------------∙
TimeAutoConvert:
    Gui, Converter:Submit, NoHide
    If (TimeInputValue = "") {
        GuiControl, Converter:, TimeResultValue,
        Return
    }
    If (!RegExMatch(TimeInputValue, "^-?\d*\.?\d+$")) {
        Return
    }
    ;;∙------∙Prevent negative time duration values
    If (TimeInputValue < 0) {
        GuiControl, Converter:, TimeResultValue, ERROR: Negative time not allowed
        GuiControl, Converter:, TimeFullResult, Time duration cannot be negative!
        Return
    }
    result := ConvertTime(TimeInputValue, TimeFromUnit, TimeToUnit)
    If (Abs(result) = 0)
        GuiControl, Converter:, TimeResultValue, 0
    Else If (Abs(result) < 0.01 && Abs(result) > 0)
        GuiControl, Converter:, TimeResultValue, % Format("{:.6f}", result)
    Else If (Abs(result) >= 1000000)
        GuiControl, Converter:, TimeResultValue, % Format("{:.2e}", result)
    Else
        GuiControl, Converter:, TimeResultValue, % Format("{:.2f}", result)
    ;;∙------∙Show full precision.
    fullResult := RegExReplace(Format("{:.15f}", result), "\.?0+$")
    If (StrLen(fullResult) > 30)
        fullResult := Format("{:.10e}", result)
    GuiControl, Converter:, TimeFullResult, %fullResult%
Return
;;∙------------------------∙
TimeUpdateConversion:
    Gui, Converter:Submit, NoHide
    
    If (TimeInputValue != "" && RegExMatch(TimeInputValue, "^-?\d*\.?\d+$"))
        GoSub, TimeAutoConvert
Return
;;∙------------------------∙
TimeSwapUnits:
    Gui, Converter:Submit, NoHide
    tempFrom := TimeFromUnit
    tempTo := TimeToUnit
    GuiControl, Converter:ChooseString, TimeFromUnit, % tempTo
    GuiControl, Converter:ChooseString, TimeToUnit, % tempFrom
    Gui, Converter:Submit, NoHide
    If (TimeInputValue != "" && RegExMatch(TimeInputValue, "^-?\d*\.?\d+$"))
        GoSub, TimeAutoConvert
    SoundBeep, 800, 100
Return

;;∙======================================∙Tab 9∙====∙
;;∙======∙DIGITAL STORAGE CONVERSION LOGIC∙=======∙
GetByteFactor(unitName) {
    If (unitName = "Bits")
        Return 0.125    ;;∙------∙1 bit = 0.125 bytes.
    If (unitName = "Bytes")
        Return 1.0    ;;∙------∙Base unit.
    If (unitName = "Kilobytes")
        Return 1024.0    ;;∙------∙1 KB = 1024 bytes.
    If (unitName = "Megabytes")
        Return 1048576.0    ;;∙------∙1 MB = 1024^2 bytes.
    If (unitName = "Gigabytes")
        Return 1073741824.0    ;;∙------∙1 GB = 1024^3 bytes.
    If (unitName = "Terabytes")
        Return 1099511627776.0    ;;∙------∙1 TB = 1024^4 bytes.
    If (unitName = "Petabytes")
        Return 1125899906842624.0    ;;∙------∙1 PB = 1024^5 bytes.
}
;;∙------------------------∙
ConvertStorage(value, fromUnitName, toUnitName) {
    bytes := value * GetByteFactor(fromUnitName)    ;;∙------∙Convert to bytes.
    result := bytes / GetByteFactor(toUnitName)    ;;∙------∙Convert from bytes to target unit.
    Return result
}
;;∙------------------------∙
StorageAutoConvert:
    Gui, Converter:Submit, NoHide
    If (StorageInputValue = "") {
        GuiControl, Converter:, StorageResultValue,
        Return
    }
    If (!RegExMatch(StorageInputValue, "^-?\d*\.?\d+$")) {
        Return
    }
    ;;∙------∙Prevent negative storage values
    If (StorageInputValue < 0) {
        GuiControl, Converter:, StorageResultValue, ERROR: Negative storage not allowed
        GuiControl, Converter:, StorageFullResult, Storage size cannot be negative!
        Return
    }
    result := ConvertStorage(StorageInputValue, StorageFromUnit, StorageToUnit)
    If (Abs(result) = 0)
        GuiControl, Converter:, StorageResultValue, 0
    Else If (Abs(result) < 0.01 && Abs(result) > 0)
        GuiControl, Converter:, StorageResultValue, % Format("{:.6f}", result)
    Else If (Abs(result) >= 1000000)
        GuiControl, Converter:, StorageResultValue, % Format("{:.2e}", result)
    Else
        GuiControl, Converter:, StorageResultValue, % Format("{:.2f}", result)
    ;;∙------∙Show full precision.
    fullResult := RegExReplace(Format("{:.15f}", result), "\.?0+$")
    If (StrLen(fullResult) > 30)
        fullResult := Format("{:.10e}", result)
    GuiControl, Converter:, StorageFullResult, %fullResult%
Return
;;∙------------------------∙
StorageUpdateConversion:
    Gui, Converter:Submit, NoHide
    If (StorageInputValue != "" && RegExMatch(StorageInputValue, "^-?\d*\.?\d+$"))
        GoSub, StorageAutoConvert
Return
;;∙------------------------∙
StorageSwapUnits:
    Gui, Converter:Submit, NoHide
    tempFrom := StorageFromUnit
    tempTo := StorageToUnit
    GuiControl, Converter:ChooseString, StorageFromUnit, % tempTo
    GuiControl, Converter:ChooseString, StorageToUnit, % tempFrom
    Gui, Converter:Submit, NoHide
    If (StorageInputValue != "" && RegExMatch(StorageInputValue, "^-?\d*\.?\d+$"))
        GoSub, StorageAutoConvert
    SoundBeep, 800, 100
Return

;;∙=====================================∙Tab 10∙====∙
;;∙======∙CURRENCY CONVERSION LOGIC∙==============∙
GetCurrencyCode(fullName) {
    Return SubStr(fullName, 1, 3)    ;;∙------∙Extracts 3-letter code from display name (e.g., "USD", "EUR").
}
;;∙------------------------∙
GetRate(currencyDisplay) {
    global cachedRates
    currency := GetCurrencyCode(currencyDisplay)
    
    if (currency = "USD")
        Return 1.0    ;;∙------∙USD is the base currency.
    
    if (cachedRates.HasKey(currency))
        Return cachedRates[currency]    ;;∙------∙Return cached rate.
}
;;∙------------------------∙
CurrencyFetchRates:
    GuiControl, Converter:, CurrencyStatusText, Fetching rates...    ;;∙------∙Status update.
    try {
        whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")    ;;∙------∙Create HTTP request object.
        whr.Open("GET", apiUrl, false)    ;;∙------∙false = synchronous (wait for response).
        whr.Send()
        if (whr.Status = 200) {    ;;∙------∙HTTP OK.
            response := whr.ResponseText
            ratesFound := 0
            Loop, Parse, response, `,, `"    ;;∙------∙Parse JSON response manually.
            {
                If InStr(A_LoopField, ":") && !InStr(A_LoopField, "{") && !InStr(A_LoopField, "}") {
                    parts := StrSplit(A_LoopField, ":")
                    If (parts.MaxIndex() = 2) {
                        currency := Trim(parts[1], """ `t`n`r")
                        rate := Trim(parts[2], """ `t`n`r")
                        If (StrLen(currency) = 3 && rate > 0) {
                            cachedRates[currency] := rate    ;;∙------∙Store rate.
                            ratesFound++
                        }
                    }
                }
            }
            if (ratesFound > 0) {
                lastApiCheck := A_Now    ;;∙------∙Record fetch time.
                successMsg := "Rates updated! (" . ratesFound . " currencies loaded)"
                GuiControl, Converter:, CurrencyStatusText, %successMsg%
                GoSub, CurrencyAutoConvert    ;;∙------∙Auto-convert after fetch.
            } else {
                GuiControl, Converter:, CurrencyStatusText, Error: No rates found in response.
                lastApiCheck := ""    ;;∙------∙Reset so next attempt will retry.
            }
        } else {
            errorMsg := "Error: HTTP Status " . whr.Status
            GuiControl, Converter:, CurrencyStatusText, %errorMsg%
            lastApiCheck := ""
        }
    } catch e {
        GuiControl, Converter:, CurrencyStatusText, Error: Could not connect. Check internet.
        lastApiCheck := ""
    }
Return
;;∙------------------------∙
CurrencyRefreshTimer:
    ;;∙------∙Only refresh if rates already exist.
    If (lastApiCheck != "") {
        GoSub, CurrencyFetchRates
    }
    SoundBeep, 1700, 300
        Sleep, 100
    SoundBeep, 1400, 200
Return
;;∙------------------------∙
CurrencyAutoConvert:
    Gui, Converter:Submit, NoHide
    
    If (CurrencyInputValue = "") {
        GuiControl, Converter:, CurrencyResultValue,
        Return
    }
    
    If (!RegExMatch(CurrencyInputValue, "^-?\d*\.?\d+$")) {
        Return
    }
    
    If (lastApiCheck = "") {
        GuiControl, Converter:, CurrencyResultValue, Fetch rates first
        Return
    }
    
    fromRate := GetRate(CurrencyFromUnit)
    toRate := GetRate(CurrencyToUnit)
    
    If (fromRate = 0 || toRate = 0) {
        GuiControl, Converter:, CurrencyResultValue, Rate unavailable
        Return
    }
    
    usdValue := CurrencyInputValue / fromRate    ;;∙------∙Convert to USD first.
    result := usdValue * toRate    ;;∙------∙Convert from USD to target currency.
    
    If (Abs(result) = 0)
        GuiControl, Converter:, CurrencyResultValue, 0
    Else If (Abs(result) < 0.01 && Abs(result) > 0)
        GuiControl, Converter:, CurrencyResultValue, % Format("{:.6f}", result)
    Else
        GuiControl, Converter:, CurrencyResultValue, % Format("{:.4f}", result)    ;;<∙------∙Currency shown to 4 decimals.

    ;;∙------∙Show full precision.
    fullResult := RegExReplace(Format("{:.15f}", result), "\.?0+$")
    If (StrLen(fullResult) > 30)
        fullResult := Format("{:.10e}", result)
    GuiControl, Converter:, CurrencyFullResult, %fullResult%
Return

CurrencyUpdateConversion:
    Gui, Converter:Submit, NoHide
    
    If (CurrencyInputValue != "" && RegExMatch(CurrencyInputValue, "^-?\d*\.?\d+$") && lastApiCheck != "")
        GoSub, CurrencyAutoConvert
Return
;;∙------------------------∙
CurrencySwapUnits:
    Gui, Converter:Submit, NoHide
    
    tempFrom := CurrencyFromUnit
    tempTo := CurrencyToUnit
    
    GuiControl, Converter:ChooseString, CurrencyFromUnit, % tempTo
    GuiControl, Converter:ChooseString, CurrencyToUnit, % tempFrom
    
    Gui, Converter:Submit, NoHide
    If (CurrencyInputValue != "" && RegExMatch(CurrencyInputValue, "^-?\d*\.?\d+$") && lastApiCheck != "")
        GoSub, CurrencyAutoConvert
    
    SoundBeep, 800, 100
Return

;;∙=====================================∙Tab 11∙====∙
;;∙======∙PRESSURE CONVERSION LOGIC∙==============∙
GetPascalFactor(unitName) {
    If (unitName = "Pascals")
        Return 1.0    ;;∙------∙Base unit.
    If (unitName = "Kilopascals")
        Return 1000.0    ;;∙------∙1 kPa = 1000 Pa.
    If (unitName = "Bar")
        Return 100000.0    ;;∙------∙1 bar = 100,000 Pa.
    If (unitName = "PSI")
        Return 6894.76    ;;∙------∙1 PSI = 6894.76 Pa.
    If (unitName = "Atmospheres")
        Return 101325.0    ;;∙------∙1 atm = 101,325 Pa.
    If (unitName = "mmHg")
        Return 133.322    ;;∙------∙1 mmHg = 133.322 Pa.
    If (unitName = "inHg")
        Return 3386.39    ;;∙------∙1 inHg = 3386.39 Pa.
    If (unitName = "Torr")
        Return 133.322    ;;∙------∙1 Torr = 133.322 Pa (equivalent to mmHg).
}
;;∙------------------------∙
ConvertPressure(value, fromUnitName, toUnitName) {
    pascals := value * GetPascalFactor(fromUnitName)    ;;∙------∙Convert to pascals.
    result := pascals / GetPascalFactor(toUnitName)    ;;∙------∙Convert from pascals to target unit.
    Return result
}
;;∙------------------------∙
PressureAutoConvert:
    Gui, Converter:Submit, NoHide
    If (PressureInputValue = "") {
        GuiControl, Converter:, PressureResultValue,
        Return
    }
    If (!RegExMatch(PressureInputValue, "^-?\d*\.?\d+$")) {
        Return
    }
    result := ConvertPressure(PressureInputValue, PressureFromUnit, PressureToUnit)
    If (Abs(result) = 0)
        GuiControl, Converter:, PressureResultValue, 0
    Else If (Abs(result) < 0.01 && Abs(result) > 0)
        GuiControl, Converter:, PressureResultValue, % Format("{:.6f}", result)
    Else If (Abs(result) >= 1000000)
        GuiControl, Converter:, PressureResultValue, % Format("{:.2e}", result)
    Else
        GuiControl, Converter:, PressureResultValue, % Format("{:.4f}", result)
    ;;∙------∙Show full precision.
    fullResult := RegExReplace(Format("{:.15f}", result), "\.?0+$")
    If (StrLen(fullResult) > 30)
        fullResult := Format("{:.10e}", result)
    GuiControl, Converter:, PressureFullResult, %fullResult%
Return
;;∙------------------------∙
PressureUpdateConversion:
    Gui, Converter:Submit, NoHide
    
    If (PressureInputValue != "" && RegExMatch(PressureInputValue, "^-?\d*\.?\d+$"))
        GoSub, PressureAutoConvert
Return
;;∙------------------------∙
PressureSwapUnits:
    Gui, Converter:Submit, NoHide
    tempFrom := PressureFromUnit
    tempTo := PressureToUnit
    GuiControl, Converter:ChooseString, PressureFromUnit, % tempTo
    GuiControl, Converter:ChooseString, PressureToUnit, % tempFrom
    Gui, Converter:Submit, NoHide
    If (PressureInputValue != "" && RegExMatch(PressureInputValue, "^-?\d*\.?\d+$"))
        GoSub, PressureAutoConvert
    SoundBeep, 800, 100
Return

;;∙=====================================∙Tab 12∙====∙
;;∙======∙ENERGY CONVERSION LOGIC∙================∙
GetJouleFactor(unitName) {
    If (unitName = "Joules")
        Return 1.0    ;;∙------∙Base unit.
    If (unitName = "Kilojoules")
        Return 1000.0    ;;∙------∙1 kJ = 1000 J.
    If (unitName = "Calories")
        Return 4.184    ;;∙------∙1 cal = 4.184 J.
    If (unitName = "Kilocalories")
        Return 4184.0    ;;∙------∙1 kcal = 4184 J (food calorie).
    If (unitName = "Watt-hours")
        Return 3600.0    ;;∙------∙1 Wh = 3600 J.
    If (unitName = "Kilowatt-hours")
        Return 3600000.0    ;;∙------∙1 kWh = 3,600,000 J.
    If (unitName = "BTU")
        Return 1055.06    ;;∙------∙1 BTU = 1055.06 J.
    If (unitName = "Electron-volts")
        Return 1.602176634e-19    ;;∙------∙1 eV = 1.602176634 × 10⁻¹⁹ J.
}
;;∙------------------------∙
ConvertEnergy(value, fromUnitName, toUnitName) {
    joules := value * GetJouleFactor(fromUnitName)    ;;∙------∙Convert to joules.
    result := joules / GetJouleFactor(toUnitName)    ;;∙------∙Convert from joules to target unit.
    Return result
}
;;∙------------------------∙
EnergyAutoConvert:
    Gui, Converter:Submit, NoHide
    If (EnergyInputValue = "") {
        GuiControl, Converter:, EnergyResultValue,
        Return
    }
    If (!RegExMatch(EnergyInputValue, "^-?\d*\.?\d+$")) {
        Return
    }
    result := ConvertEnergy(EnergyInputValue, EnergyFromUnit, EnergyToUnit)
    If (Abs(result) = 0)
        GuiControl, Converter:, EnergyResultValue, 0
    Else If (Abs(result) < 0.01 && Abs(result) > 0)
        GuiControl, Converter:, EnergyResultValue, % Format("{:.6f}", result)
    Else If (Abs(result) >= 1000000)
        GuiControl, Converter:, EnergyResultValue, % Format("{:.2e}", result)
    Else
        GuiControl, Converter:, EnergyResultValue, % Format("{:.4f}", result)
    ;;∙------∙Show full precision.
    fullResult := RegExReplace(Format("{:.15f}", result), "\.?0+$")
    If (StrLen(fullResult) > 30)
        fullResult := Format("{:.10e}", result)
    GuiControl, Converter:, EnergyFullResult, %fullResult%
Return
;;∙------------------------∙
EnergyUpdateConversion:
    Gui, Converter:Submit, NoHide
    If (EnergyInputValue != "" && RegExMatch(EnergyInputValue, "^-?\d*\.?\d+$"))
        GoSub, EnergyAutoConvert
Return
;;∙------------------------∙
EnergySwapUnits:
    Gui, Converter:Submit, NoHide
    tempFrom := EnergyFromUnit
    tempTo := EnergyToUnit
    GuiControl, Converter:ChooseString, EnergyFromUnit, % tempTo
    GuiControl, Converter:ChooseString, EnergyToUnit, % tempFrom
    Gui, Converter:Submit, NoHide
    If (EnergyInputValue != "" && RegExMatch(EnergyInputValue, "^-?\d*\.?\d+$"))
        GoSub, EnergyAutoConvert
    SoundBeep, 800, 100
Return

;;∙=====================================∙Tab 13∙====∙
;;∙======∙POWER CONVERSION LOGIC∙================∙
GetWattFactor(unitName) {
    If (unitName = "Watts")
        Return 1.0    ;;∙------∙Base unit.
    If (unitName = "Kilowatts")
        Return 1000.0    ;;∙------∙1 kW = 1000 W.
    If (unitName = "Megawatts")
        Return 1000000.0    ;;∙------∙1 MW = 1,000,000 W.
    If (unitName = "Horsepower")
        Return 745.7    ;;∙------∙1 hp = 745.7 W.
    If (unitName = "BTU per Hour")
        Return 0.293071    ;;∙------∙1 BTU/h = 0.293071 W.
    If (unitName = "Foot-pounds per Second")
        Return 1.35582    ;;∙------∙1 ft·lb/s = 1.35582 W.
}
;;∙------------------------∙
ConvertPower(value, fromUnitName, toUnitName) {
    watts := value * GetWattFactor(fromUnitName)    ;;∙------∙Convert to watts.
    result := watts / GetWattFactor(toUnitName)    ;;∙------∙Convert from watts to target unit.
    Return result
}
;;∙------------------------∙
PowerAutoConvert:
    Gui, Converter:Submit, NoHide
    If (PowerInputValue = "") {
        GuiControl, Converter:, PowerResultValue,
        Return
    }
    If (!RegExMatch(PowerInputValue, "^-?\d*\.?\d+$")) {
        Return
    }
    result := ConvertPower(PowerInputValue, PowerFromUnit, PowerToUnit)
    If (Abs(result) = 0)
        GuiControl, Converter:, PowerResultValue, 0
    Else If (Abs(result) < 0.01 && Abs(result) > 0)
        GuiControl, Converter:, PowerResultValue, % Format("{:.6f}", result)
    Else If (Abs(result) >= 1000000)
        GuiControl, Converter:, PowerResultValue, % Format("{:.2e}", result)
    Else
        GuiControl, Converter:, PowerResultValue, % Format("{:.4f}", result)

    ;;∙------∙Show full precision.
    fullResult := RegExReplace(Format("{:.15f}", result), "\.?0+$")
    If (StrLen(fullResult) > 30)
        fullResult := Format("{:.10e}", result)
    GuiControl, Converter:, PowerFullResult, %fullResult%
Return
;;∙------------------------∙
PowerUpdateConversion:
    Gui, Converter:Submit, NoHide
    If (PowerInputValue != "" && RegExMatch(PowerInputValue, "^-?\d*\.?\d+$"))
        GoSub, PowerAutoConvert
Return
;;∙------------------------∙
PowerSwapUnits:
    Gui, Converter:Submit, NoHide
    tempFrom := PowerFromUnit
    tempTo := PowerToUnit
    GuiControl, Converter:ChooseString, PowerFromUnit, % tempTo
    GuiControl, Converter:ChooseString, PowerToUnit, % tempFrom
    Gui, Converter:Submit, NoHide
    If (PowerInputValue != "" && RegExMatch(PowerInputValue, "^-?\d*\.?\d+$"))
        GoSub, PowerAutoConvert
    SoundBeep, 800, 100
Return

;;∙=====================================∙Tab 14∙====∙
;;∙======∙FUEL CONSUMPTION CONVERSION LOGIC∙=====∙
ConvertFuel(value, fromUnitName, toUnitName) {
    ;;∙------∙Convert input value to MPG (US) first (base unit).
    If (fromUnitName = "MPG (US)")
        mpgUS := value
    Else If (fromUnitName = "MPG (UK)")
        mpgUS := value / 1.20095    ;;∙------∙1 UK MPG = 1.20095 US MPG.
    Else If (fromUnitName = "L/100km") {
        if (value = 0) {
            MsgBox, 48, Error, Cannot convert zero L/100km to MPG. Please enter a positive value.
            Return 0
        }
        mpgUS := 235.214583 / value
    }
    Else If (fromUnitName = "km/L")
        mpgUS := value * 2.35215    ;;∙------∙1 km/L = 2.35215 US MPG.
    Else If (fromUnitName = "Miles per Liter")
        mpgUS := value * 3.78541    ;;∙------∙1 mi/L = 3.78541 US MPG.
    ;;∙------∙Convert from MPG (US) to target unit.
    If (toUnitName = "MPG (US)")
        Return mpgUS
    Else If (toUnitName = "MPG (UK)")
        Return mpgUS * 1.20095
    Else If (toUnitName = "L/100km") {
        if (mpgUS = 0) {
            MsgBox, 48, Error, Cannot convert zero MPG to L/100km. Please enter a positive value.
            Return 0
        }
        Return 235.214583 / mpgUS
    }
    Else If (toUnitName = "km/L")
        Return mpgUS / 2.35215
    Else If (toUnitName = "Miles per Liter")
        Return mpgUS / 3.78541
    Return 0
}
;;∙------------------------∙
FuelAutoConvert:
    Gui, Converter:Submit, NoHide
    If (FuelInputValue = "") {
        GuiControl, Converter:, FuelResultValue,
        Return
    }
    If (!RegExMatch(FuelInputValue, "^-?\d*\.?\d+$")) {
        Return
    }
    ;;∙------∙Prevent zero or negative fuel consumption values.
    If (FuelInputValue <= 0) {
        GuiControl, Converter:, FuelResultValue, ERROR: Fuel consumption must be positive (>0)
        GuiControl, Converter:, FuelFullResult, Zero or negative values are not allowed for fuel economy!
        Return
    }
    result := ConvertFuel(FuelInputValue, FuelFromUnit, FuelToUnit)
    If (Abs(result) = 0)
        GuiControl, Converter:, FuelResultValue, 0
    Else If (Abs(result) < 0.01 && Abs(result) > 0)
        GuiControl, Converter:, FuelResultValue, % Format("{:.6f}", result)
    Else
        GuiControl, Converter:, FuelResultValue, % Format("{:.2f}", result)
    ;;∙------∙Show full precision.
    fullResult := RegExReplace(Format("{:.15f}", result), "\.?0+$")
    If (StrLen(fullResult) > 30)
        fullResult := Format("{:.10e}", result)
    GuiControl, Converter:, FuelFullResult, %fullResult%
Return
;;∙------------------------∙
FuelUpdateConversion:
    Gui, Converter:Submit, NoHide
    If (FuelInputValue != "" && RegExMatch(FuelInputValue, "^-?\d*\.?\d+$"))
        GoSub, FuelAutoConvert
Return
;;∙------------------------∙
FuelSwapUnits:
    Gui, Converter:Submit, NoHide
    tempFrom := FuelFromUnit
    tempTo := FuelToUnit
    GuiControl, Converter:ChooseString, FuelFromUnit, % tempTo
    GuiControl, Converter:ChooseString, FuelToUnit, % tempFrom
    Gui, Converter:Submit, NoHide
    If (FuelInputValue != "" && RegExMatch(FuelInputValue, "^-?\d*\.?\d+$"))
        GoSub, FuelAutoConvert
    SoundBeep, 800, 100
Return

;;∙=====================================∙Tab 15∙====∙
;;∙======∙DATA TRANSFER CONVERSION LOGIC∙=========∙
GetBpsFactor(unitName) {
    If (unitName = "bps")
        Return 1.0    ;;∙------∙Base unit.
    If (unitName = "Kbps")
        Return 1000.0    ;;∙------∙1 Kbps = 1000 bps.
    If (unitName = "Mbps")
        Return 1000000.0    ;;∙------∙1 Mbps = 1,000,000 bps.
    If (unitName = "Gbps")
        Return 1000000000.0    ;;∙------∙1 Gbps = 1,000,000,000 bps.
    If (unitName = "B/s")
        Return 8.0    ;;∙------∙1 B/s = 8 bps.
    If (unitName = "KB/s")
        Return 8000.0    ;;∙------∙1 KB/s = 8000 bps.
    If (unitName = "MB/s")
        Return 8000000.0    ;;∙------∙1 MB/s = 8,000,000 bps.
    If (unitName = "GB/s")
        Return 8000000000.0    ;;∙------∙1 GB/s = 8,000,000,000 bps.
}
;;∙------------------------∙
ConvertDataTransfer(value, fromUnitName, toUnitName) {
    bps := value * GetBpsFactor(fromUnitName)    ;;∙------∙Convert to bps.
    result := bps / GetBpsFactor(toUnitName)    ;;∙------∙Convert from bps to target unit.
    Return result
}
;;∙------------------------∙
DataAutoConvert:
    Gui, Converter:Submit, NoHide
    If (DataInputValue = "") {
        GuiControl, Converter:, DataResultValue,
        Return
    }
    If (!RegExMatch(DataInputValue, "^-?\d*\.?\d+$")) {
        Return
    }
    result := ConvertDataTransfer(DataInputValue, DataFromUnit, DataToUnit)
    If (Abs(result) = 0)
        GuiControl, Converter:, DataResultValue, 0
    Else If (Abs(result) < 0.01 && Abs(result) > 0)
        GuiControl, Converter:, DataResultValue, % Format("{:.6f}", result)
    Else If (Abs(result) >= 1000000)
        GuiControl, Converter:, DataResultValue, % Format("{:.2e}", result)
    Else
        GuiControl, Converter:, DataResultValue, % Format("{:.2f}", result)
    ;;∙------∙Show full precision.
    fullResult := RegExReplace(Format("{:.15f}", result), "\.?0+$")
    If (StrLen(fullResult) > 30)
        fullResult := Format("{:.10e}", result)
    GuiControl, Converter:, DataFullResult, %fullResult%
Return
;;∙------------------------∙
DataUpdateConversion:
    Gui, Converter:Submit, NoHide
    If (DataInputValue != "" && RegExMatch(DataInputValue, "^-?\d*\.?\d+$"))
        GoSub, DataAutoConvert
Return
;;∙------------------------∙
DataSwapUnits:
    Gui, Converter:Submit, NoHide
    tempFrom := DataFromUnit
    tempTo := DataToUnit
    GuiControl, Converter:ChooseString, DataFromUnit, % tempTo
    GuiControl, Converter:ChooseString, DataToUnit, % tempFrom
    Gui, Converter:Submit, NoHide
    If (DataInputValue != "" && RegExMatch(DataInputValue, "^-?\d*\.?\d+$"))
        GoSub, DataAutoConvert
    SoundBeep, 800, 100
Return

;;∙=====================================∙Tab 16∙====∙
;;∙======∙ANGLE CONVERSION LOGIC∙=================∙
GetDegreeFactor(unitName) {
    If (unitName = "Degrees")
        Return 1.0    ;;∙------∙Base unit.
    If (unitName = "Radians")
        Return 57.2957795    ;;∙------∙1 rad = 57.2957795°.
    If (unitName = "Gradians")
        Return 0.9    ;;∙------∙1 grad = 0.9°.
    If (unitName = "Arcminutes")
        Return 0.0166667    ;;∙------∙1 arcmin = 1/60° = 0.0166667°.
    If (unitName = "Arcseconds")
        Return 0.000277778    ;;∙------∙1 arcsec = 1/3600° = 0.000277778°.
    If (unitName = "Revolutions")
        Return 360.0    ;;∙------∙1 revolution = 360°.
}
;;∙------------------------∙
ConvertAngle(value, fromUnitName, toUnitName) {
    degrees := value * GetDegreeFactor(fromUnitName)    ;;∙------∙Convert to degrees.
    result := degrees / GetDegreeFactor(toUnitName)    ;;∙------∙Convert from degrees to target unit.
    Return result
}
;;∙------------------------∙
AngleAutoConvert:
    Gui, Converter:Submit, NoHide
    If (AngleInputValue = "") {
        GuiControl, Converter:, AngleResultValue,
        Return
    }
    If (!RegExMatch(AngleInputValue, "^-?\d*\.?\d+$")) {
        Return
    }
    result := ConvertAngle(AngleInputValue, AngleFromUnit, AngleToUnit)
    If (Abs(result) = 0)
        GuiControl, Converter:, AngleResultValue, 0
    Else If (Abs(result) < 0.01 && Abs(result) > 0)
        GuiControl, Converter:, AngleResultValue, % Format("{:.6f}", result)
    Else If (Abs(result) >= 1000000)
        GuiControl, Converter:, AngleResultValue, % Format("{:.2e}", result)
    Else
        GuiControl, Converter:, AngleResultValue, % Format("{:.4f}", result)
    ;;∙------∙Show full precision.
    fullResult := RegExReplace(Format("{:.15f}", result), "\.?0+$")
    If (StrLen(fullResult) > 30)
        fullResult := Format("{:.10e}", result)
    GuiControl, Converter:, AngleFullResult, %fullResult%
Return
;;∙------------------------∙
AngleUpdateConversion:
    Gui, Converter:Submit, NoHide
    If (AngleInputValue != "" && RegExMatch(AngleInputValue, "^-?\d*\.?\d+$"))
        GoSub, AngleAutoConvert
Return
;;∙------------------------∙
AngleSwapUnits:
    Gui, Converter:Submit, NoHide
    tempFrom := AngleFromUnit
    tempTo := AngleToUnit
    GuiControl, Converter:ChooseString, AngleFromUnit, % tempTo
    GuiControl, Converter:ChooseString, AngleToUnit, % tempFrom
    Gui, Converter:Submit, NoHide
    If (AngleInputValue != "" && RegExMatch(AngleInputValue, "^-?\d*\.?\d+$"))
        GoSub, AngleAutoConvert
    SoundBeep, 800, 100
Return

;;∙=====================================∙Tab 17∙====∙
;;∙======∙TORQUE CONVERSION LOGIC∙================∙
GetNewtonMeterFactor(unitName) {
    If (unitName = "Newton-meters")
        Return 1.0    ;;∙------∙Base unit.
    If (unitName = "Foot-pounds")
        Return 1.35582    ;;∙------∙1 ft·lb = 1.35582 N·m.
    If (unitName = "Inch-pounds")
        Return 0.112985    ;;∙------∙1 in·lb = 0.112985 N·m.
    If (unitName = "Kilogram-meters")
        Return 9.80665    ;;∙------∙1 kg·m = 9.80665 N·m.
    If (unitName = "Dyne-centimeters")
        Return 0.0000001    ;;∙------∙1 dyne·cm = 1 × 10⁻⁷ N·m.
}
;;∙------------------------∙
ConvertTorque(value, fromUnitName, toUnitName) {
    nm := value * GetNewtonMeterFactor(fromUnitName)    ;;∙------∙Convert to N·m.
    result := nm / GetNewtonMeterFactor(toUnitName)    ;;∙------∙Convert from N·m to target unit.
    Return result
}
;;∙------------------------∙
TorqueAutoConvert:
    Gui, Converter:Submit, NoHide
    If (TorqueInputValue = "") {
        GuiControl, Converter:, TorqueResultValue,
        Return
    }
    If (!RegExMatch(TorqueInputValue, "^-?\d*\.?\d+$")) {
        Return
    }
    result := ConvertTorque(TorqueInputValue, TorqueFromUnit, TorqueToUnit)
    If (Abs(result) = 0)
        GuiControl, Converter:, TorqueResultValue, 0
    Else If (Abs(result) < 0.01 && Abs(result) > 0)
        GuiControl, Converter:, TorqueResultValue, % Format("{:.6f}", result)
    Else If (Abs(result) >= 1000000)
        GuiControl, Converter:, TorqueResultValue, % Format("{:.2e}", result)
    Else
        GuiControl, Converter:, TorqueResultValue, % Format("{:.4f}", result)
    ;;∙------∙Show full precision.
    fullResult := RegExReplace(Format("{:.15f}", result), "\.?0+$")
    If (StrLen(fullResult) > 30)
        fullResult := Format("{:.10e}", result)
    GuiControl, Converter:, TorqueFullResult, %fullResult%
Return
;;∙------------------------∙
TorqueUpdateConversion:
    Gui, Converter:Submit, NoHide
    If (TorqueInputValue != "" && RegExMatch(TorqueInputValue, "^-?\d*\.?\d+$"))
        GoSub, TorqueAutoConvert
Return
;;∙------------------------∙
TorqueSwapUnits:
    Gui, Converter:Submit, NoHide
    tempFrom := TorqueFromUnit
    tempTo := TorqueToUnit
    GuiControl, Converter:ChooseString, TorqueFromUnit, % tempTo
    GuiControl, Converter:ChooseString, TorqueToUnit, % tempFrom
    Gui, Converter:Submit, NoHide
    If (TorqueInputValue != "" && RegExMatch(TorqueInputValue, "^-?\d*\.?\d+$"))
        GoSub, TorqueAutoConvert
    SoundBeep, 800, 100
Return

;;∙=====================================∙Tab 18∙====∙
;;∙======∙FORCE CONVERSION LOGIC∙=================∙

GetNewtonFactor(unitName) {
    If (unitName = "Newtons")
        Return 1.0    ;;∙------∙Base unit.
    If (unitName = "Kilonewtons")
        Return 1000.0    ;;∙------∙1 kN = 1000 N.
    If (unitName = "Pounds-force")
        Return 4.44822    ;;∙------∙1 lbf = 4.44822 N.
    If (unitName = "Kilograms-force")
        Return 9.80665    ;;∙------∙1 kgf = 9.80665 N.
    If (unitName = "Dynes")
        Return 0.00001    ;;∙------∙1 dyne = 0.00001 N.
}
;;∙------------------------∙
ConvertForce(value, fromUnitName, toUnitName) {
    newtons := value * GetNewtonFactor(fromUnitName)    ;;∙------∙Convert to newtons.
    result := newtons / GetNewtonFactor(toUnitName)    ;;∙------∙Convert from newtons to target unit.
    Return result
}
;;∙------------------------∙
ForceAutoConvert:
    Gui, Converter:Submit, NoHide
    If (ForceInputValue = "") {
        GuiControl, Converter:, ForceResultValue,
        Return
    }
    If (!RegExMatch(ForceInputValue, "^-?\d*\.?\d+$")) {
        Return
    }
    result := ConvertForce(ForceInputValue, ForceFromUnit, ForceToUnit)
    If (Abs(result) = 0)
        GuiControl, Converter:, ForceResultValue, 0
    Else If (Abs(result) < 0.01 && Abs(result) > 0)
        GuiControl, Converter:, ForceResultValue, % Format("{:.6f}", result)
    Else If (Abs(result) >= 1000000)
        GuiControl, Converter:, ForceResultValue, % Format("{:.2e}", result)
    Else
        GuiControl, Converter:, ForceResultValue, % Format("{:.4f}", result)
    ;;∙------∙Show full precision.
    fullResult := RegExReplace(Format("{:.15f}", result), "\.?0+$")
    If (StrLen(fullResult) > 30)
        fullResult := Format("{:.10e}", result)
    GuiControl, Converter:, ForceFullResult, %fullResult%
Return
;;∙------------------------∙
ForceUpdateConversion:
    Gui, Converter:Submit, NoHide
    If (ForceInputValue != "" && RegExMatch(ForceInputValue, "^-?\d*\.?\d+$"))
        GoSub, ForceAutoConvert
Return
;;∙------------------------∙
ForceSwapUnits:
    Gui, Converter:Submit, NoHide
    tempFrom := ForceFromUnit
    tempTo := ForceToUnit
    GuiControl, Converter:ChooseString, ForceFromUnit, % tempTo
    GuiControl, Converter:ChooseString, ForceToUnit, % tempFrom
    Gui, Converter:Submit, NoHide
    If (ForceInputValue != "" && RegExMatch(ForceInputValue, "^-?\d*\.?\d+$"))
        GoSub, ForceAutoConvert
    SoundBeep, 800, 100
Return

;;∙=====================================∙Tab 19∙====∙
;;∙======∙ACCELERATION CONVERSION LOGIC∙==========∙
GetMps2Factor(unitName) {
    If (unitName = "m/s²")
        Return 1.0    ;;∙------∙Base unit.
    If (unitName = "ft/s²")
        Return 0.3048    ;;∙------∙1 ft/s² = 0.3048 m/s².
    If (unitName = "g-force")
        Return 9.80665    ;;∙------∙1 g = 9.80665 m/s².
    If (unitName = "Gal")
        Return 0.01    ;;∙------∙1 Gal = 0.01 m/s².
    If (unitName = "in/s²")
        Return 0.0254    ;;∙------∙1 in/s² = 0.0254 m/s².
    If (unitName = "km/h/s")
        Return 0.277778    ;;∙------∙1 (km/h)/s = 0.277778 m/s².
}
;;∙------------------------∙
ConvertAccel(value, fromUnitName, toUnitName) {
    mps2 := value * GetMps2Factor(fromUnitName)    ;;∙------∙Convert to m/s².
    result := mps2 / GetMps2Factor(toUnitName)    ;;∙------∙Convert from m/s² to target unit.
    Return result
}
;;∙------------------------∙
AccelAutoConvert:
    Gui, Converter:Submit, NoHide
    If (AccelInputValue = "") {
        GuiControl, Converter:, AccelResultValue,
        Return
    }
    If (!RegExMatch(AccelInputValue, "^-?\d*\.?\d+$")) {
        Return
    }
    result := ConvertAccel(AccelInputValue, AccelFromUnit, AccelToUnit)
    If (Abs(result) = 0)
        GuiControl, Converter:, AccelResultValue, 0
    Else If (Abs(result) < 0.01 && Abs(result) > 0)
        GuiControl, Converter:, AccelResultValue, % Format("{:.6f}", result)
    Else If (Abs(result) >= 1000000)
        GuiControl, Converter:, AccelResultValue, % Format("{:.2e}", result)
    Else
        GuiControl, Converter:, AccelResultValue, % Format("{:.4f}", result)
    ;;∙------∙Show full precision.
    fullResult := RegExReplace(Format("{:.15f}", result), "\.?0+$")
    If (StrLen(fullResult) > 30)
        fullResult := Format("{:.10e}", result)
    GuiControl, Converter:, AccelFullResult, %fullResult%
Return
;;∙------------------------∙
AccelUpdateConversion:
    Gui, Converter:Submit, NoHide
    If (AccelInputValue != "" && RegExMatch(AccelInputValue, "^-?\d*\.?\d+$"))
        GoSub, AccelAutoConvert
Return
;;∙------------------------∙
AccelSwapUnits:
    Gui, Converter:Submit, NoHide
    tempFrom := AccelFromUnit
    tempTo := AccelToUnit
    GuiControl, Converter:ChooseString, AccelFromUnit, % tempTo
    GuiControl, Converter:ChooseString, AccelToUnit, % tempFrom
    Gui, Converter:Submit, NoHide
    If (AccelInputValue != "" && RegExMatch(AccelInputValue, "^-?\d*\.?\d+$"))
        GoSub, AccelAutoConvert
    SoundBeep, 800, 100
Return

;;∙================================================∙
;;∙======∙TAB CHANGE HANDLER∙=====================∙
TabChanged:
    Gui, Converter:Submit, NoHide
    If (ConverterTabs = 10 && lastApiCheck = "") {    ;;∙------∙Check if Currency tab is opened without rates.
        GoTo, CurrencyFetchRates    ;;∙------∙Fetch rates on-demand.
    }
Return

;;∙================================================∙
;;∙======∙SHOW / HIDE WINDOW∙====================∙
RestoreWindow:
    DetectHiddenWindows, On
    IfWinExist, %ScriptID%
    {
        Winget, winState, Style, %ScriptID%
        If (winState & 0x10000000) {    ;;∙------∙Check if window is visible.
            Gui, Converter:Hide
            Menu, Tray, Icon, Show/Hide Window, shell32.dll, 247    ;;∙------∙Up arrow (show).
        } Else {
            Gui, Converter:Show, x%guiX% y%guiY% w%guiW% h%guiH%, %ScriptID%
            Menu, Tray, Icon, Show/Hide Window, shell32.dll, 248    ;;∙------∙Down arrow (hide).
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
    if (RegExMatch(ColorName, "^(0x)?[0-9A-Fa-f]{6}$")) {    ;;∙------∙Check if input is hex code.
        hex := RegExReplace(ColorName, "^(0x)", "")
    } else {
        hex := colorMap[ColorName]    ;;∙------∙Look up named color.
        if (hex = "")
            hex := "FFFFFF"    ;;∙------∙Default to white if not found.
    }
    if (Format = "GUI")
        return hex
    else if (Format = "GUI0x")
        return "0x" . hex    ;;∙------∙Return with 0x prefix for AHK color format.
}

;;∙================================================∙
;;∙======∙BOX & BAR ROUTINES∙======================∙
boxline(GuiName, X, Y, W, H, ColorTop := "Black", ColorBottom := "Black", ColorLeft := "Black", ColorRight := "Black", Thickness := 1)
{	
    BottomY := Y + H - Thickness    ;;∙------∙Calculate bottom edge Y position.
    RightX := X + W - Thickness    ;;∙------∙Calculate right edge X position.
    Gui, %GuiName%:Add, Progress, x%X% y%Y% w%W% h%Thickness% Background%ColorTop%    ;;∙------∙Top border.
    Gui, %GuiName%:Add, Progress, x%X% y%BottomY% w%W% h%Thickness% Background%ColorBottom%    ;;∙------∙Bottom border.
    Gui, %GuiName%:Add, Progress, x%X% y%Y% w%Thickness% h%H% Background%ColorLeft%    ;;∙------∙Left border.
    Gui, %GuiName%:Add, Progress, x%RightX% y%Y% w%Thickness% h%H% Background%ColorRight%    ;;∙------∙Right border.
}
;;∙------------------------∙
barLine(GuiName, X, Y, W, H, Color1 := "Black") 
{
    Gui, %GuiName%:Add, Progress, x%X% y%Y% w%W% h%H% Background%Color1%    ;;∙------∙Single bar/line.
}

;;∙================================================∙
;;∙======∙WINDOW DRAG & CONTROLS∙===============∙
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0    ;;∙------∙Gui window drag).
}
Return
;;∙------------------------∙
CloseConverter:
ConverterGuiClose:
    Soundbeep, 800, 300
    ExitApp
Return
;;∙------------------------∙
MinimizeConverter:
    GoSub, RestoreWindow
Return

;;∙================================================∙
;;∙======∙TRAY MENU∙===============================∙
TrayMenu:
Menu, Tray, Tip, %ScriptID%
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Show/Hide Window, RestoreWindow
Menu, Tray, Icon, Show/Hide Window, shell32.dll, 248
Menu, Tray, Default, Show/Hide Window
Menu, Tray, Add
;;∙------------------------∙
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
;;∙------------------------∙
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
;;∙======∙TRAY UTILITIES∙=========================∙
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
Unit_Converter:
    Suspend
    Soundbeep, 700, 100
    Pause
Return

;;∙================================================∙
;;∙======∙TRAY MENU POSITION∙======================∙
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20    ;;∙------∙Show tray menu at mouse position.
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
Return True
}
Return

;;∙================================================∙
;;∙======∙SCRIPT UPDATE CHECK∙=====================∙
UpdateCheck:
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
  ;  Soundbeep, 1700, 100
Reload

;;∙================================================∙
;;∙======∙EDIT / RELOAD / EXIT∙======================∙
Script·Edit:
    Edit    ;;∙------∙Open script in default editor.
Return
;;∙------------------------∙
^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)
    Script·Reload:
     ;   Soundbeep, 1200, 250
    Reload
Return
;;∙------------------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)
    Script·Exit:
     ;   Soundbeep, 1000, 300
    ExitApp
Return
;;∙================================================∙

;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙

