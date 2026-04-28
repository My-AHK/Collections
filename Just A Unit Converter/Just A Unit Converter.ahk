
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

guiX := 200    ;;∙------∙X position.
guiY := 200    ;;∙------∙Y position.

guiW := 640    ;;∙------∙Gui Width (testing).
guiH := 370    ;;∙------∙Gui Height.

;;∙------∙Colors & Appearance∙--------------------------------------∙
gBackground := "Black"    ;;∙------∙GUI Background.
contentBorder := "Blue"    ;;∙------∙Tab page borders.
outerBorder := "Magenta"    ;;∙------∙Tab page borders.
introTabHeader := "Red"    ;;∙------∙Unit Converter label highlight color.

;;∙------∙1: INTRO Tab Colors∙---------------------------------------∙
introTabLinks := "Lime"    ;;∙------∙Unit Converter label highlight color.
introReturn := "Lime"    ;;∙------∙Return to Intro tab arrow (↩).

;;∙------∙2: LENGTH Tab Colors∙-------------------------------------∙
lengthTabHeader := "Aqua"    ;;∙------∙Header text on length tab.
lengthInputText := "Blue"    ;;∙------∙Input field text.
lengthResultText := "Yellow"    ;;∙------∙Result display text.

;;∙------∙3: WEIGHT Tab Colors∙-------------------------------------∙
weightTabHeader := "Blue"    ;;∙------∙Header text on weight tab.
weightInputText := "Blue"    ;;∙------∙Input field text.
weightResultText := "Yellow"    ;;∙------∙Result display text.

;;∙------∙4: VOLUME Tab Colors∙------------------------------------∙
volumeTabHeader := "Fuchsia"    ;;∙------∙Header text on volume tab.
volumeInputText := "Blue"    ;;∙------∙Input field text.
volumeResultText := "Yellow"    ;;∙------∙Result display text.

;;∙------∙5: AREA Tab Colors∙-----------------------------------------∙
areaTabHeader := "Red"    ;;∙------∙Header text on area tab.
areaInputText := "Blue"    ;;∙------∙Input field text.
areaResultText := "Yellow"    ;;∙------∙Result display text.

;;∙------∙6: TEMPERATURE Tab Colors∙-----------------------------∙
tempTabHeader := "Orange"    ;;∙------∙Header text on temperature tab.
tempInputText := "Blue"    ;;∙------∙Input field text.
tempResultText := "Yellow"    ;;∙------∙Result display text.

;;∙------∙7: SPEED Tab Colors∙---------------------------------------∙
speedTabHeader := "Yellow"    ;;∙------∙Header text on speed tab.
speedInputText := "Blue"    ;;∙------∙Input field text.
speedResultText := "Yellow"    ;;∙------∙Result display text.

;;∙------∙8: TIME Tab Colors∙-----------------------------------------∙
timeTabHeader := "Spring-Green"    ;;∙------∙Header text on time tab.
timeInputText := "Blue"    ;;∙------∙Input field text.
timeResultText := "Yellow"    ;;∙------∙Result display text.

;;∙------∙9: DIGITAL STORAGE Tab Colors∙-------------------------∙
storageTabHeader := "Azure"    ;;∙------∙Header text on storage tab.
storageInputText := "Blue"    ;;∙------∙Input field text.
storageResultText := "Yellow"    ;;∙------∙Result display text.

;;∙------∙10: CURRENCY Tab Colors∙--------------------------------∙
currencyTabHeader := "Magenta-Red"    ;;∙------∙Header text on currency tab.
currencyInputText := "Blue"    ;;∙------∙Input field text.
currencyResultText := "Yellow"    ;;∙------∙Result display text.

;;∙------∙11: Pressure Tab Colors∙-----------------------------------∙
pressureTabHeader := "Coral"    ;;∙------∙Header text on pressure tab.
pressureInputText := "Blue"    ;;∙------∙Input field text.
pressureResultText := "Yellow"    ;;∙------∙Result display text.

;;∙------∙12: ENERGYTab Colors∙-------------------------------------∙
energyTabHeader := "Chartreuse"    ;;∙------∙Header text on energy tab.
energyInputText := "Blue"    ;;∙------∙Input field text.
energyResultText := "Yellow"    ;;∙------∙Result display text.

;;∙------∙13: POWER Tab Colors∙------------------------------------∙
powerTabHeader := "Deep Pink"    ;;∙------∙Header text on power tab.
powerInputText := "Blue"    ;;∙------∙Input field text.
powerResultText := "Yellow"    ;;∙------∙Result display text.

;;∙------∙14: FUEL Consumption Tab Colors∙----------------------∙
fuelTabHeader := "Violet"    ;;∙------∙Header text on fuel tab.
fuelInputText := "Blue"    ;;∙------∙Input field text.
fuelResultText := "Yellow"    ;;∙------∙Result display text.

;;∙------∙15: DATA Transfer Tab Colors∙----------------------------∙
dataTabHeader := "Cyan"    ;;∙------∙Header text on data transfer tab.
dataInputText := "Blue"    ;;∙------∙Input field text.
dataResultText := "Yellow"    ;;∙------∙Result display text.

;;∙------∙16: ANGLE Tab Colors∙-------------------------------------∙
angleTabHeader := "Silver"    ;;∙------∙Header text on angle tab.
angleInputText := "Blue"    ;;∙------∙Input field text.
angleResultText := "Yellow"    ;;∙------∙Result display text.

;;∙------∙17: TORQUE Tab Colors∙-----------------------------------∙
torqueTabHeader := "Red-Orange"    ;;∙------∙Header text on torque tab.
torqueInputText := "Blue"    ;;∙------∙Input field text.
torqueResultText := "Yellow"    ;;∙------∙Result display text.

;;∙------∙18: FORCE Tab Colors∙-------------------------------------∙
forceTabHeader := "Lime"    ;;∙------∙Header text on force tab.
forceInputText := "Blue"    ;;∙------∙Input field text.
forceResultText := "Yellow"    ;;∙------∙Result display text.

;;∙------∙19: ACCELERATION Tab Colors∙---------------------------∙
accelTabHeader := "Hot Pink"    ;;∙------∙Header text on acceleration tab.
accelInputText := "Blue"    ;;∙------∙Input field text.
accelResultText := "Yellow"    ;;∙------∙Result display text.

;;∙================================================∙
;;∙======∙GLOBAL VARIABLES∙========================∙
ScriptID := "Unit_Converter"
apiUrl := "https://open.er-api.com/v6/latest/USD"
lastApiCheck := ""
cachedRates := Object()

;;∙================================================∙
;;∙======∙TRAY ICON & DRAG∙========================∙
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")
Menu, Tray, Icon, imageres.dll, 229

SetTimer, UpdateCheck, 750
GoSub, TrayMenu

;;∙================================================∙
;;∙======∙GUI BUILD∙================================∙
Gui, Converter:New
Gui, Converter:-Caption +ToolWindow -DPIScale +E0x02000000 +E0x00080000
If (converterOnTop)
    Gui, Converter:+AlwaysOnTop
Gui, Converter:Margin, 0, 0
Gui, Converter:Color, % Color(gBackground, "GUI0x")
Gui, Converter:Font, s10 q5, Segoe UI

;;∙------∙Title Bar Area.
titleColorHex := Color(introTabHeader, "GUI0x")
Gui, Converter:Font, s20 c%titleColorHex% Norm q5, Arial
Gui, Converter:Add, Text, x1 y8 w%guiW% h30 c%gBackground% Center BackgroundTrans, - Unit Converter -
Gui, Converter:Add, Text, x0 y7 w%guiW% h30 Center BackgroundTrans, - Unit Converter -


;;∙------∙Close Button (X).
closeColorHex := Color("Red", "GUI0x")
XguiW := (guiW - 25)
Gui, Converter:Font, s12 c%closeColorHex% Bold q5, Arial
;;  Gui, Converter:Add, Text, x%XguiW% y5 gCloseConverter BackgroundTrans, X
Gui, Converter:Add, Picture, x%XguiW% y10 w16 h16 Icon277 gCloseConverter BackgroundTrans, imageres.dll


;;∙------∙Hide/Minimize Button (-).
minColorHex := Color("Yellow", "GUI0x")
X2guiW := (XguiW - 20)
Gui, Converter:Font, s18 c%minColorHex% Bold q5, Arial
;;  Gui, Converter:Add, Text, x%X2guiW% y-2 w25 h25 Center gMinimizeConverter BackgroundTrans, -
Gui, Converter:Add, Picture, x%X2guiW% y10 w16 h16 Icon248 gMinimizeConverter BackgroundTrans, shell32.dll


;;∙------∙Main Content Area Border.
contentBorderHex := Color(contentBorder, "GUI")
boxW := guiW - 20
boxH := guiH - 55
boxline("Converter", 5, 40, boxW + 10, boxH + 10, contentBorderHex, contentBorderHex, contentBorderHex, contentBorderHex, 1)

outerBorderHex := Color(outerBorder, "GUI")
boxline("Converter", 0, 0, guiW, guiH, outerBorderHex, outerBorderHex, outerBorderHex, outerBorderHex, 2)

;;∙------∙Tab Control. (*NOTE: Currency must remain 10th Tab or Rates will not update)
TguiW := (guiW - 30) , TguiH := (guiH - 65)
Gui, Converter:Font, s10 q5, Segoe UI
Gui, Converter:Add, Tab2, x15 y50 w%TguiW% h0 vConverterTabs gTabChanged AltSubmit -Wrap, Intro|Length|Weight|Volume|Area|Temp|Speed|Time|Storage|Currency|Pressure|Energy|Power|Fuel|Data|Angle|Torque|Force|Accel|

;;∙================================================∙
;;∙======∙TAB 1: INTRODUCTION∙=====================∙
Gui, Converter:Tab, 1

WguiW := (guiW -60)
headerColorHex := Color(introTabLinks, "GUI0x")
Gui, Converter:Font, s16 c%headerColorHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x30 y50 w%WguiW% Center BackgroundTrans, Welcome to Unit Converter

;;∙------∙Column 1 (left).
Gui, Converter:Font, s10 c%headerColorHex% Bold Underline q5, Arial
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
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
Gui, Converter:Font, s9 c%introTabLinks% Norm q5, Segoe UI
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
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, Arial
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Length Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vFromUnit gUpdateConversion, Millimeters|Centimeters|Meters|Kilometers|Inches|Feet|Yards|Miles

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(lengthTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vToUnit gUpdateConversion, Millimeters|Centimeters|Meters|Kilometers|Inches|Feet|Yards|Miles

inputHeaderHex := Color(lengthTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(lengthInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y170 w305 h30 vInputValue gAutoConvert Number

resultLabelHex := Color(lengthTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(lengthResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y235 w305 h30 vResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(lengthTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, Consolas
Gui, Converter:Add, Text, x55 y268 w305 h22 vLengthFullResult BackgroundTrans

GuiControl, Converter:ChooseString, FromUnit, Meters
GuiControl, Converter:ChooseString, ToUnit, Feet

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")    ;;∙------∙Return arrow color set in Variables.

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, Arial
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(lengthTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(lengthTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, Segoe UI
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
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, Arial
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Weight Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vWeightFromUnit gWeightUpdateConversion, Milligrams|Grams|Kilograms|Metric Tons|Ounces|Pounds|Stone|US Tons

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gWeightSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(weightTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vWeightToUnit gWeightUpdateConversion, Milligrams|Grams|Kilograms|Metric Tons|Ounces|Pounds|Stone|US Tons

inputHeaderHex := Color(weightTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(weightInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y170 w305 h30 vWeightInputValue gWeightAutoConvert Number

resultLabelHex := Color(weightTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(weightResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y235 w305 h30 vWeightResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(weightTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, Consolas
Gui, Converter:Add, Text, x55 y268 w305 h22 vWeightFullResult BackgroundTrans

GuiControl, Converter:ChooseString, WeightFromUnit, Kilograms
GuiControl, Converter:ChooseString, WeightToUnit, Pounds

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")    ;;∙------∙Return arrow color set in Variables.

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, Arial
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(weightTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(weightTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, Segoe UI
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
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, Arial
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Volume Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vVolumeFromUnit gVolumeUpdateConversion, Milliliters|Liters|Cubic Meters|Teaspoons|Tablespoons|Fluid Ounces|Cups|Gallons

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gVolumeSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(volumeTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vVolumeToUnit gVolumeUpdateConversion, Milliliters|Liters|Cubic Meters|Teaspoons|Tablespoons|Fluid Ounces|Cups|Gallons

inputHeaderHex := Color(volumeTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(volumeInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y170 w305 h30 vVolumeInputValue gVolumeAutoConvert Number

resultLabelHex := Color(volumeTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(volumeResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y235 w305 h30 vVolumeResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(volumeTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, Consolas
Gui, Converter:Add, Text, x55 y268 w305 h22 vVolumeFullResult BackgroundTrans

GuiControl, Converter:ChooseString, VolumeFromUnit, Liters
GuiControl, Converter:ChooseString, VolumeToUnit, Gallons

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")    ;;∙------∙Return arrow color set in Variables.

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, Arial
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(volumeTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(volumeTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, Segoe UI
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
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, Arial
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Area Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vAreaFromUnit gAreaUpdateConversion, Square Millimeters|Square Centimeters|Square Meters|Square Kilometers|Square Inches|Square Feet|Square Yards|Acres

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gAreaSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(areaTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vAreaToUnit gAreaUpdateConversion, Square Millimeters|Square Centimeters|Square Meters|Square Kilometers|Square Inches|Square Feet|Square Yards|Acres

inputHeaderHex := Color(areaTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(areaInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y170 w305 h30 vAreaInputValue gAreaAutoConvert Number

resultLabelHex := Color(areaTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(areaResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y235 w305 h30 vAreaResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(areaTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, Consolas
Gui, Converter:Add, Text, x55 y268 w305 h22 vAreaFullResult BackgroundTrans

GuiControl, Converter:ChooseString, AreaFromUnit, Square Meters
GuiControl, Converter:ChooseString, AreaToUnit, Square Feet

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")    ;;∙------∙Return arrow color set in Variables.

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, Arial
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(areaTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(areaTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, Segoe UI
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
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, Arial
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Temperature Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, x55 y110 w120 r3 vTempFromUnit gTempUpdateConversion, Celsius|Fahrenheit|Kelvin

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gTempSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(tempTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, xp y110 w120 r3 vTempToUnit gTempUpdateConversion, Celsius|Fahrenheit|Kelvin

inputHeaderHex := Color(tempTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(tempInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y170 w305 h30 vTempInputValue gTempAutoConvert Number

resultLabelHex := Color(tempTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(tempResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y235 w305 h30 vTempResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(tempTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, Consolas
Gui, Converter:Add, Text, x55 y268 w305 h22 vTempFullResult BackgroundTrans

GuiControl, Converter:ChooseString, TempFromUnit, Celsius
GuiControl, Converter:ChooseString, TempToUnit, Fahrenheit

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")    ;;∙------∙Return arrow color set in Variables.

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, Arial
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(tempTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(tempTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, Segoe UI
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
)

;;∙================================================∙
;;∙======∙TAB 7: SPEED CONVERSIONS∙================∙
Gui, Converter:Tab, 7

fromHeaderHex := Color(speedTabHeader, "GUI0x")
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, Arial
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Speed Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vSpeedFromUnit gSpeedUpdateConversion, Meters per Second|Kilometers per Hour|Miles per Hour|Knots|Feet per Second|Mach

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gSpeedSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(speedTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vSpeedToUnit gSpeedUpdateConversion, Meters per Second|Kilometers per Hour|Miles per Hour|Knots|Feet per Second|Mach

inputHeaderHex := Color(speedTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(speedInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y170 w305 h30 vSpeedInputValue gSpeedAutoConvert Number

resultLabelHex := Color(speedTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(speedResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y235 w305 h30 vSpeedResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(speedTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, Consolas
Gui, Converter:Add, Text, x55 y268 w305 h22 vSpeedFullResult BackgroundTrans

GuiControl, Converter:ChooseString, SpeedFromUnit, Kilometers per Hour
GuiControl, Converter:ChooseString, SpeedToUnit, Miles per Hour

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")    ;;∙------∙Return arrow color set in Variables.

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, Arial
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(speedTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(speedTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, Segoe UI
Gui, Converter:Add, Text, x390 y100 w205 h225 BackgroundTrans, 
(
Convert between common
speed and velocity units.

Metric & Scientific:
m/s, km/h, Mach

Nautical & Imperial:
mph, knots, ft/s
)

;;∙================================================∙
;;∙======∙TAB 8: TIME CONVERSIONS∙=================∙
Gui, Converter:Tab, 8

fromHeaderHex := Color(timeTabHeader, "GUI0x")
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, Arial
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Time Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vTimeFromUnit gTimeUpdateConversion, Milliseconds|Seconds|Minutes|Hours|Days|Weeks|Years

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gTimeSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(timeTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vTimeToUnit gTimeUpdateConversion, Milliseconds|Seconds|Minutes|Hours|Days|Weeks|Years

inputHeaderHex := Color(timeTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(timeInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y170 w305 h30 vTimeInputValue gTimeAutoConvert Number

resultLabelHex := Color(timeTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(timeResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y235 w305 h30 vTimeResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(timeTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, Consolas
Gui, Converter:Add, Text, x55 y268 w305 h22 vTimeFullResult BackgroundTrans

GuiControl, Converter:ChooseString, TimeFromUnit, Hours
GuiControl, Converter:ChooseString, TimeToUnit, Minutes

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")    ;;∙------∙Return arrow color set in Variables.

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, Arial
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(timeTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(timeTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, Segoe UI
Gui, Converter:Add, Text, x390 y100 w205 h225 BackgroundTrans, 
(
Convert between common
time duration units.

Base unit: Seconds

Includes:
ms, sec, min, hours,
days, weeks, years

Year = 365.25 days
(accounts for leap years)
)

;;∙================================================∙
;;∙======∙TAB 9: DIGITAL STORAGE CONVERSIONS∙======∙
Gui, Converter:Tab, 9

fromHeaderHex := Color(storageTabHeader, "GUI0x")
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, Arial
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Digital Storage Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vStorageFromUnit gStorageUpdateConversion, Bits|Bytes|Kilobytes|Megabytes|Gigabytes|Terabytes|Petabytes

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gStorageSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(storageTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vStorageToUnit gStorageUpdateConversion, Bits|Bytes|Kilobytes|Megabytes|Gigabytes|Terabytes|Petabytes

inputHeaderHex := Color(storageTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(storageInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y170 w305 h30 vStorageInputValue gStorageAutoConvert Number

resultLabelHex := Color(storageTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(storageResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y235 w305 h30 vStorageResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(storageTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, Consolas
Gui, Converter:Add, Text, x55 y268 w305 h22 vStorageFullResult BackgroundTrans

GuiControl, Converter:ChooseString, StorageFromUnit, Gigabytes
GuiControl, Converter:ChooseString, StorageToUnit, Megabytes

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")    ;;∙------∙Return arrow color set in Variables.

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, Arial
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(storageTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(storageTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, Segoe UI
Gui, Converter:Add, Text, x390 y100 w205 h225 BackgroundTrans, 
(
Convert between digital
storage units.

Base unit: Bytes

Units:
Bits, Bytes, KB, MB,
GB, TB, PB

1 Byte = 8 Bits
1 KB = 1024 Bytes
)

;;∙================================================∙
;;∙======∙TAB 10: CURRENCY CONVERSIONS∙============∙
Gui, Converter:Tab, 10

fromHeaderHex := Color(currencyTabHeader, "GUI0x")
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, Arial
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Currency Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vCurrencyFromUnit gCurrencyUpdateConversion, USD ($)|EUR (€)|GBP (£)|JPY Yen (¥)|CAD (C$)|AUD (A$)|CHF|CNY Yuan (¥)

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gCurrencySwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(currencyTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vCurrencyToUnit gCurrencyUpdateConversion, USD ($)|EUR (€)|GBP (£)|JPY Yen (¥)|CAD (C$)|AUD (A$)|CHF|CNY Yuan (¥)

inputHeaderHex := Color(currencyTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(currencyInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y170 w305 h30 vCurrencyInputValue gCurrencyAutoConvert Number

;;∙------∙Status Text.
statusTextHex := Color("Yellow", "GUI0x")
Gui, Converter:Font, s8 c%statusTextHex% Norm q5, Segoe UI
Gui, Converter:Add, Text, x100 y215 w305 h20 vCurrencyStatusText Center BackgroundTrans,

resultLabelHex := Color(currencyTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(currencyResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y235 w305 h30 vCurrencyResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(currencyTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, Consolas
Gui, Converter:Add, Text, x55 y268 w305 h22 vCurrencyFullResult BackgroundTrans

GuiControl, Converter:ChooseString, CurrencyFromUnit, USD ($)
GuiControl, Converter:ChooseString, CurrencyToUnit, EUR (€)

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")    ;;∙------∙Return arrow color set in Variables.

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, Arial
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(currencyTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(currencyTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, Segoe UI
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
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, Arial
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Pressure Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vPressureFromUnit gPressureUpdateConversion, Pascals|Kilopascals|Bar|PSI|Atmospheres|mmHg|inHg|Torr

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gPressureSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(pressureTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vPressureToUnit gPressureUpdateConversion, Pascals|Kilopascals|Bar|PSI|Atmospheres|mmHg|inHg|Torr

inputHeaderHex := Color(pressureTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(pressureInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y170 w305 h30 vPressureInputValue gPressureAutoConvert Number

resultLabelHex := Color(pressureTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(pressureResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y235 w305 h30 vPressureResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(pressureTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, Consolas
Gui, Converter:Add, Text, x55 y268 w305 h22 vPressureFullResult BackgroundTrans

GuiControl, Converter:ChooseString, PressureFromUnit, PSI
GuiControl, Converter:ChooseString, PressureToUnit, Bar

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")    ;;∙------∙Return arrow color set in Variables.

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, Arial
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(pressureTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(pressureTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, Segoe UI
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
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, Arial
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Energy Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vEnergyFromUnit gEnergyUpdateConversion, Joules|Kilojoules|Calories|Kilocalories|Watt-hours|Kilowatt-hours|BTU|Electron-volts

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gEnergySwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(energyTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vEnergyToUnit gEnergyUpdateConversion, Joules|Kilojoules|Calories|Kilocalories|Watt-hours|Kilowatt-hours|BTU|Electron-volts

inputHeaderHex := Color(energyTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(energyInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y170 w305 h30 vEnergyInputValue gEnergyAutoConvert Number

resultLabelHex := Color(energyTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(energyResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y235 w305 h30 vEnergyResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(energyTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, Consolas
Gui, Converter:Add, Text, x55 y268 w305 h22 vEnergyFullResult BackgroundTrans

GuiControl, Converter:ChooseString, EnergyFromUnit, Joules
GuiControl, Converter:ChooseString, EnergyToUnit, Calories

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")    ;;∙------∙Return arrow color set in Variables.

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, Arial
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(energyTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(energyTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, Segoe UI
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
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, Arial
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Power Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vPowerFromUnit gPowerUpdateConversion, Watts|Kilowatts|Megawatts|Horsepower|BTU per Hour|Foot-pounds per Second

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gPowerSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(powerTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vPowerToUnit gPowerUpdateConversion, Watts|Kilowatts|Megawatts|Horsepower|BTU per Hour|Foot-pounds per Second

inputHeaderHex := Color(powerTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(powerInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y170 w305 h30 vPowerInputValue gPowerAutoConvert Number

resultLabelHex := Color(powerTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(powerResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y235 w305 h30 vPowerResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(powerTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, Consolas
Gui, Converter:Add, Text, x55 y268 w305 h22 vPowerFullResult BackgroundTrans

GuiControl, Converter:ChooseString, PowerFromUnit, Watts
GuiControl, Converter:ChooseString, PowerToUnit, Horsepower

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")    ;;∙------∙Return arrow color set in Variables.

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, Arial
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(powerTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(powerTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, Segoe UI
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
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, Arial
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Fuel Consumption Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vFuelFromUnit gFuelUpdateConversion, MPG (US)|MPG (UK)|L/100km|km/L|Miles per Liter

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gFuelSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(fuelTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vFuelToUnit gFuelUpdateConversion, MPG (US)|MPG (UK)|L/100km|km/L|Miles per Liter

inputHeaderHex := Color(fuelTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(fuelInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y170 w305 h30 vFuelInputValue gFuelAutoConvert Number

resultLabelHex := Color(fuelTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(fuelResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y235 w305 h30 vFuelResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(fuelTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, Consolas
Gui, Converter:Add, Text, x55 y268 w305 h22 vFuelFullResult BackgroundTrans

GuiControl, Converter:ChooseString, FuelFromUnit, MPG (US)
GuiControl, Converter:ChooseString, FuelToUnit, L/100km

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")    ;;∙------∙Return arrow color set in Variables.

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, Arial
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(fuelTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(fuelTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, Segoe UI
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
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, Arial
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Data Transfer Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vDataFromUnit gDataUpdateConversion, bps|Kbps|Mbps|Gbps|B/s|KB/s|MB/s|GB/s

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gDataSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(dataTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vDataToUnit gDataUpdateConversion, bps|Kbps|Mbps|Gbps|B/s|KB/s|MB/s|GB/s

inputHeaderHex := Color(dataTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(dataInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y170 w305 h30 vDataInputValue gDataAutoConvert Number

resultLabelHex := Color(dataTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(dataResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y235 w305 h30 vDataResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(dataTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, Consolas
Gui, Converter:Add, Text, x55 y268 w305 h22 vDataFullResult BackgroundTrans

GuiControl, Converter:ChooseString, DataFromUnit, Mbps
GuiControl, Converter:ChooseString, DataToUnit, MB/s

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")    ;;∙------∙Return arrow color set in Variables.

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, Arial
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(dataTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(dataTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, Segoe UI
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
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, Arial
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Angle Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vAngleFromUnit gAngleUpdateConversion, Degrees|Radians|Gradians|Arcminutes|Arcseconds|Revolutions

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gAngleSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(angleTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vAngleToUnit gAngleUpdateConversion, Degrees|Radians|Gradians|Arcminutes|Arcseconds|Revolutions

inputHeaderHex := Color(angleTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(angleInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y170 w305 h30 vAngleInputValue gAngleAutoConvert Number

resultLabelHex := Color(angleTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(angleResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y235 w305 h30 vAngleResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(angleTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, Consolas
Gui, Converter:Add, Text, x55 y268 w305 h22 vAngleFullResult BackgroundTrans

GuiControl, Converter:ChooseString, AngleFromUnit, Degrees
GuiControl, Converter:ChooseString, AngleToUnit, Radians

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")    ;;∙------∙Return arrow color set in Variables.

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, Arial
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(angleTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(angleTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, Segoe UI
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
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, Arial
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Torque Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vTorqueFromUnit gTorqueUpdateConversion, Newton-meters|Foot-pounds|Inch-pounds|Kilogram-meters|Dyne-centimeters

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gTorqueSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(torqueTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vTorqueToUnit gTorqueUpdateConversion, Newton-meters|Foot-pounds|Inch-pounds|Kilogram-meters|Dyne-centimeters

inputHeaderHex := Color(torqueTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(torqueInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y170 w305 h30 vTorqueInputValue gTorqueAutoConvert Number

resultLabelHex := Color(torqueTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(torqueResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y235 w305 h30 vTorqueResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(torqueTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, Consolas
Gui, Converter:Add, Text, x55 y268 w305 h22 vTorqueFullResult BackgroundTrans

GuiControl, Converter:ChooseString, TorqueFromUnit, Newton-meters
GuiControl, Converter:ChooseString, TorqueToUnit, Foot-pounds

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")    ;;∙------∙Return arrow color set in Variables.

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, Arial
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(torqueTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(torqueTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, Segoe UI
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
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, Arial
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Force Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vForceFromUnit gForceUpdateConversion, Newtons|Kilonewtons|Pounds-force|Kilograms-force|Dynes

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gForceSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(forceTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vForceToUnit gForceUpdateConversion, Newtons|Kilonewtons|Pounds-force|Kilograms-force|Dynes

inputHeaderHex := Color(forceTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(forceInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y170 w305 h30 vForceInputValue gForceAutoConvert Number

resultLabelHex := Color(forceTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(forceResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y235 w305 h30 vForceResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(forceTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, Consolas
Gui, Converter:Add, Text, x55 y268 w305 h22 vForceFullResult BackgroundTrans

GuiControl, Converter:ChooseString, ForceFromUnit, Newtons
GuiControl, Converter:ChooseString, ForceToUnit, Pounds-force

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")    ;;∙------∙Return arrow color set in Variables.

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, Arial
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(forceTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(forceTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, Segoe UI
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
Gui, Converter:Font, s14 c%fromHeaderHex% Bold q5, Arial
Gui, Converter:Add, Text, x25 y50 w%WguiW% Center BackgroundTrans, Acceleration Conversions

Gui, Converter:Font, s10 c%fromHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y90 Left BackgroundTrans, From:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, x55 y110 w120 r8 vAccelFromUnit gAccelUpdateConversion, m/s²|ft/s²|g-force|Gal|in/s²|km/h/s

Gui, Converter:Add, Picture, x+20 y110 w22 h22 Icon229 gAccelSwapUnits BackgroundTrans, imageres.dll

toHeaderHex := Color(accelTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%toHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x+20 y90 Left BackgroundTrans, To:

Gui, Converter:Font, s10 Norm q5, Segoe UI
Gui, Converter:Add, DropDownList, xp y110 w120 r8 vAccelToUnit gAccelUpdateConversion, m/s²|ft/s²|g-force|Gal|in/s²|km/h/s

inputHeaderHex := Color(accelTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%inputHeaderHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y150 Left BackgroundTrans, Enter Value:

inputTextHex := Color(accelInputText, "GUI0x")
Gui, Converter:Font, s12 c%inputTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y170 w305 h30 vAccelInputValue gAccelAutoConvert Number

resultLabelHex := Color(accelTabHeader, "GUI0x")
Gui, Converter:Font, s10 c%resultLabelHex% Bold q5, Segoe UI
Gui, Converter:Add, Text, x55 y215 Left BackgroundTrans, Result:

resultTextHex := Color(accelResultText, "GUI0x")
Gui, Converter:Font, s12 c%resultTextHex% Bold q5, Consolas
Gui, Converter:Add, Edit, x55 y235 w305 h30 vAccelResultValue ReadOnly

;;∙------∙Full Precision Result.
fullResultHex := Color(accelTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%fullResultHex% Norm q5, Consolas
Gui, Converter:Add, Text, x55 y268 w305 h22 vAccelFullResult BackgroundTrans

GuiControl, Converter:ChooseString, AccelFromUnit, m/s²
GuiControl, Converter:ChooseString, AccelToUnit, ft/s²

;;∙------∙Return to Intro button.
backColorHex := Color(introReturn, "GUI0x")    ;;∙------∙Return arrow color set in Variables.

AguiH := (guiH- 45)
Gui, Converter:Font, s12 c%backColorHex% Bold q5, Arial
Gui, Converter:Add, Text, x30 y%AguiH% w20 h20 Center gGoToTab1 BackgroundTrans, ↩

insideBoxHex := Color(accelTabHeader, "GUI")
boxline("Converter", 380, 90, 225, 250, insideBoxHex, insideBoxHex, insideBoxHex, insideBoxHex, 1)
infoTextHex := Color(accelTabHeader, "GUI0x")
Gui, Converter:Font, s9 c%infoTextHex% Norm q5, Segoe UI
Gui, Converter:Add, Text, x390 y100 w205 h225 BackgroundTrans, 
(
Convert between common
acceleration units.

Metric & Scientific:
m/s², Gal, km/h/s

Imperial & Aviation:
ft/s², in/s², g-force

1 g = 9.80665 m/s²
)

;;∙================================================∙
;;∙======∙SHOW GUI & INITIALIZE∙====================∙
GuiControl, Converter:Choose, ConverterTabs, % defaultTab
Gui, Converter:Show, x%guiX% y%guiY% w%guiW% h%guiH%, %ScriptID%

If (windowTransparency < 255) {
    WinGet, hwnd, ID, %ScriptID%
    WinSet, Transparent, %windowTransparency%, ahk_id %hwnd%
}

SetTimer, CurrencyFetchRates, -500    ;;∙------∙Fetch currency rates shortly after GUI loads.

Return

;;∙================================================∙
;;∙======∙LENGTH CONVERSION LOGIC∙================∙

GetMeterFactor(unitName) {
    If (unitName = "Millimeters")
        Return 0.001
    If (unitName = "Centimeters")
        Return 0.01
    If (unitName = "Meters")
        Return 1.0
    If (unitName = "Kilometers")
        Return 1000.0
    If (unitName = "Inches")
        Return 0.0254
    If (unitName = "Feet")
        Return 0.3048
    If (unitName = "Yards")
        Return 0.9144
    If (unitName = "Miles")
        Return 1609.344
}

ConvertLength(value, fromUnitName, toUnitName) {
    meters := value * GetMeterFactor(fromUnitName)
    result := meters / GetMeterFactor(toUnitName)
    Return result
}

AutoConvert:
    Gui, Converter:Submit, NoHide
    
    If (InputValue = "") {
        GuiControl, Converter:, ResultValue,
        Return
    }
    
    If (!RegExMatch(InputValue, "^-?\d*\.?\d+$")) {
        Return
    }
    
    result := ConvertLength(InputValue, FromUnit, ToUnit)
    
    If (Abs(result) = 0)
        GuiControl, Converter:, ResultValue, 0
    Else If (Abs(result) < 0.01 && Abs(result) > 0)
        GuiControl, Converter:, ResultValue, % Format("{:.6f}", result)
    Else If (Abs(result) >= 1000000)
        GuiControl, Converter:, ResultValue, % Format("{:.2e}", result)
    Else
        GuiControl, Converter:, ResultValue, % Format("{:.2f}", result)

    ;;∙------∙Show full precision.
    fullResult := RegExReplace(Format("{:.15f}", result), "\.?0+$")
    If (StrLen(fullResult) > 30)
        fullResult := Format("{:.10e}", result)
    GuiControl, Converter:, LengthFullResult, %fullResult%
Return

UpdateConversion:
    Gui, Converter:Submit, NoHide
    
    If (InputValue != "" && RegExMatch(InputValue, "^-?\d*\.?\d+$"))
        GoSub, AutoConvert
Return

SwapUnits:
    Gui, Converter:Submit, NoHide
    
    tempFrom := FromUnit
    tempTo := ToUnit
    
    GuiControl, Converter:ChooseString, FromUnit, % tempTo
    GuiControl, Converter:ChooseString, ToUnit, % tempFrom
    
    Gui, Converter:Submit, NoHide
    If (InputValue != "" && RegExMatch(InputValue, "^-?\d*\.?\d+$"))
        GoSub, AutoConvert
    
    SoundBeep, 800, 100
Return

;;∙================================================∙
;;∙======∙WEIGHT CONVERSION LOGIC∙================∙

GetGramFactor(unitName) {
    If (unitName = "Milligrams")
        Return 0.001
    If (unitName = "Grams")
        Return 1.0
    If (unitName = "Kilograms")
        Return 1000.0
    If (unitName = "Metric Tons")
        Return 1000000.0
    If (unitName = "Ounces")
        Return 28.3495
    If (unitName = "Pounds")
        Return 453.592
    If (unitName = "Stone")
        Return 6350.29
    If (unitName = "US Tons")
        Return 907185.0
}

ConvertWeight(value, fromUnitName, toUnitName) {
    grams := value * GetGramFactor(fromUnitName)
    result := grams / GetGramFactor(toUnitName)
    Return result
}

WeightAutoConvert:
    Gui, Converter:Submit, NoHide
    
    If (WeightInputValue = "") {
        GuiControl, Converter:, WeightResultValue,
        Return
    }
    
    If (!RegExMatch(WeightInputValue, "^-?\d*\.?\d+$")) {
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

WeightUpdateConversion:
    Gui, Converter:Submit, NoHide
    
    If (WeightInputValue != "" && RegExMatch(WeightInputValue, "^-?\d*\.?\d+$"))
        GoSub, WeightAutoConvert
Return

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

;;∙================================================∙
;;∙======∙VOLUME CONVERSION LOGIC∙===============∙

GetLiterFactor(unitName) {
    If (unitName = "Milliliters")
        Return 0.001
    If (unitName = "Liters")
        Return 1.0
    If (unitName = "Cubic Meters")
        Return 1000.0
    If (unitName = "Teaspoons")
        Return 0.00492892
    If (unitName = "Tablespoons")
        Return 0.0147868
    If (unitName = "Fluid Ounces")
        Return 0.0295735
    If (unitName = "Cups")
        Return 0.236588
    If (unitName = "Gallons")
        Return 3.78541
}

ConvertVolume(value, fromUnitName, toUnitName) {
    liters := value * GetLiterFactor(fromUnitName)
    result := liters / GetLiterFactor(toUnitName)
    Return result
}

VolumeAutoConvert:
    Gui, Converter:Submit, NoHide
    
    If (VolumeInputValue = "") {
        GuiControl, Converter:, VolumeResultValue,
        Return
    }
    
    If (!RegExMatch(VolumeInputValue, "^-?\d*\.?\d+$")) {
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

VolumeUpdateConversion:
    Gui, Converter:Submit, NoHide
    
    If (VolumeInputValue != "" && RegExMatch(VolumeInputValue, "^-?\d*\.?\d+$"))
        GoSub, VolumeAutoConvert
Return

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

;;∙================================================∙
;;∙======∙AREA CONVERSION LOGIC∙==================∙

GetSquareMeterFactor(unitName) {
    If (unitName = "Square Millimeters")
        Return 0.000001
    If (unitName = "Square Centimeters")
        Return 0.0001
    If (unitName = "Square Meters")
        Return 1.0
    If (unitName = "Square Kilometers")
        Return 1000000.0
    If (unitName = "Square Inches")
        Return 0.00064516
    If (unitName = "Square Feet")
        Return 0.092903
    If (unitName = "Square Yards")
        Return 0.836127
    If (unitName = "Acres")
        Return 4046.86
}

ConvertArea(value, fromUnitName, toUnitName) {
    sqMeters := value * GetSquareMeterFactor(fromUnitName)
    result := sqMeters / GetSquareMeterFactor(toUnitName)
    Return result
}

AreaAutoConvert:
    Gui, Converter:Submit, NoHide
    
    If (AreaInputValue = "") {
        GuiControl, Converter:, AreaResultValue,
        Return
    }
    
    If (!RegExMatch(AreaInputValue, "^-?\d*\.?\d+$")) {
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

AreaUpdateConversion:
    Gui, Converter:Submit, NoHide
    
    If (AreaInputValue != "" && RegExMatch(AreaInputValue, "^-?\d*\.?\d+$"))
        GoSub, AreaAutoConvert
Return

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

;;∙================================================∙
;;∙======∙TEMPERATURE CONVERSION LOGIC∙==========∙

ConvertTemperature(value, fromUnit, toUnit) {
    If (fromUnit = "Celsius")
        celsius := value
    Else If (fromUnit = "Fahrenheit")
        celsius := (value - 32) * 5 / 9
    Else If (fromUnit = "Kelvin")
        celsius := value - 273.15
    
    If (toUnit = "Celsius")
        Return celsius
    Else If (toUnit = "Fahrenheit")
        Return (celsius * 9 / 5) + 32
    Else If (toUnit = "Kelvin")
        Return celsius + 273.15
    
    Return 0
}

TempAutoConvert:
    Gui, Converter:Submit, NoHide
    
    If (TempInputValue = "") {
        GuiControl, Converter:, TempResultValue,
        Return
    }
    
    If (!RegExMatch(TempInputValue, "^-?\d*\.?\d+$")) {
        Return
    }
    
    result := ConvertTemperature(TempInputValue, TempFromUnit, TempToUnit)
    
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

TempUpdateConversion:
    Gui, Converter:Submit, NoHide
    
    If (TempInputValue != "" && RegExMatch(TempInputValue, "^-?\d*\.?\d+$"))
        GoSub, TempAutoConvert
Return

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

;;∙================================================∙
;;∙======∙SPEED CONVERSION LOGIC∙=================∙

GetMetersPerSecondFactor(unitName) {
    If (unitName = "Meters per Second")
        Return 1.0
    If (unitName = "Kilometers per Hour")
        Return 0.277778
    If (unitName = "Miles per Hour")
        Return 0.44704
    If (unitName = "Knots")
        Return 0.514444
    If (unitName = "Feet per Second")
        Return 0.3048
    If (unitName = "Mach")
        Return 343.0
}

ConvertSpeed(value, fromUnitName, toUnitName) {
    mps := value * GetMetersPerSecondFactor(fromUnitName)
    result := mps / GetMetersPerSecondFactor(toUnitName)
    Return result
}

SpeedAutoConvert:
    Gui, Converter:Submit, NoHide
    
    If (SpeedInputValue = "") {
        GuiControl, Converter:, SpeedResultValue,
        Return
    }
    
    If (!RegExMatch(SpeedInputValue, "^-?\d*\.?\d+$")) {
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

SpeedUpdateConversion:
    Gui, Converter:Submit, NoHide
    
    If (SpeedInputValue != "" && RegExMatch(SpeedInputValue, "^-?\d*\.?\d+$"))
        GoSub, SpeedAutoConvert
Return

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

;;∙================================================∙
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
    If (unitName = "Years")
        Return 31557600.0
}

ConvertTime(value, fromUnitName, toUnitName) {
    seconds := value * GetSecondsFactor(fromUnitName)
    result := seconds / GetSecondsFactor(toUnitName)
    Return result
}

TimeAutoConvert:
    Gui, Converter:Submit, NoHide
    
    If (TimeInputValue = "") {
        GuiControl, Converter:, TimeResultValue,
        Return
    }
    
    If (!RegExMatch(TimeInputValue, "^-?\d*\.?\d+$")) {
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

TimeUpdateConversion:
    Gui, Converter:Submit, NoHide
    
    If (TimeInputValue != "" && RegExMatch(TimeInputValue, "^-?\d*\.?\d+$"))
        GoSub, TimeAutoConvert
Return

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

;;∙================================================∙
;;∙======∙DIGITAL STORAGE CONVERSION LOGIC∙=======∙

GetByteFactor(unitName) {
    If (unitName = "Bits")
        Return 0.125
    If (unitName = "Bytes")
        Return 1.0
    If (unitName = "Kilobytes")
        Return 1024.0
    If (unitName = "Megabytes")
        Return 1048576.0
    If (unitName = "Gigabytes")
        Return 1073741824.0
    If (unitName = "Terabytes")
        Return 1099511627776.0
    If (unitName = "Petabytes")
        Return 1125899906842624.0
}

ConvertStorage(value, fromUnitName, toUnitName) {
    bytes := value * GetByteFactor(fromUnitName)
    result := bytes / GetByteFactor(toUnitName)
    Return result
}

StorageAutoConvert:
    Gui, Converter:Submit, NoHide
    
    If (StorageInputValue = "") {
        GuiControl, Converter:, StorageResultValue,
        Return
    }
    
    If (!RegExMatch(StorageInputValue, "^-?\d*\.?\d+$")) {
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

StorageUpdateConversion:
    Gui, Converter:Submit, NoHide
    
    If (StorageInputValue != "" && RegExMatch(StorageInputValue, "^-?\d*\.?\d+$"))
        GoSub, StorageAutoConvert
Return

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

;;∙================================================∙
;;∙======∙CURRENCY CONVERSION LOGIC∙==============∙

GetCurrencyCode(fullName) {
    Return SubStr(fullName, 1, 3)
}

GetRate(currencyDisplay) {
    global cachedRates
    currency := GetCurrencyCode(currencyDisplay)
    
    if (currency = "USD")
        Return 1.0
    
    if (cachedRates.HasKey(currency))
        Return cachedRates[currency]
}

CurrencyFetchRates:
    GuiControl, Converter:, CurrencyStatusText, Fetching rates...
    
    try {
        whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        whr.Open("GET", apiUrl, false)    ;;∙------∙false = synchronous (wait for response).
        whr.Send()
        
        if (whr.Status = 200) {
            response := whr.ResponseText
            
            ratesFound := 0
            Loop, Parse, response, `,, `"
            {
                If InStr(A_LoopField, ":") && !InStr(A_LoopField, "{") && !InStr(A_LoopField, "}") {
                    parts := StrSplit(A_LoopField, ":")
                    If (parts.MaxIndex() = 2) {
                        currency := Trim(parts[1], """ `t`n`r")
                        rate := Trim(parts[2], """ `t`n`r")
                        If (StrLen(currency) = 3 && rate > 0) {
                            cachedRates[currency] := rate
                            ratesFound++
                        }
                    }
                }
            }
            
            if (ratesFound > 0) {
                lastApiCheck := A_Now
                successMsg := "Rates updated! (" . ratesFound . " currencies loaded)"
                GuiControl, Converter:, CurrencyStatusText, %successMsg%
                GoSub, CurrencyAutoConvert
            } else {
                GuiControl, Converter:, CurrencyStatusText, Error: No rates found in response.
            }
        } else {
            errorMsg := "Error: HTTP Status " . whr.Status
            GuiControl, Converter:, CurrencyStatusText, %errorMsg%
        }
    } catch e {
        GuiControl, Converter:, CurrencyStatusText, Error: Could not connect. Check internet.
    }
Return

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
    
    usdValue := CurrencyInputValue / fromRate
    result := usdValue * toRate
    
    If (Abs(result) = 0)
        GuiControl, Converter:, CurrencyResultValue, 0
    Else If (Abs(result) < 0.01 && Abs(result) > 0)
        GuiControl, Converter:, CurrencyResultValue, % Format("{:.6f}", result)
    Else
        GuiControl, Converter:, CurrencyResultValue, % Format("{:.4f}", result)

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

;;∙================================================∙
;;∙======∙PRESSURE CONVERSION LOGIC∙==============∙

GetPascalFactor(unitName) {
    If (unitName = "Pascals")
        Return 1.0
    If (unitName = "Kilopascals")
        Return 1000.0
    If (unitName = "Bar")
        Return 100000.0
    If (unitName = "PSI")
        Return 6894.76
    If (unitName = "Atmospheres")
        Return 101325.0
    If (unitName = "mmHg")
        Return 133.322
    If (unitName = "inHg")
        Return 3386.39
    If (unitName = "Torr")
        Return 133.322
}

ConvertPressure(value, fromUnitName, toUnitName) {
    pascals := value * GetPascalFactor(fromUnitName)
    result := pascals / GetPascalFactor(toUnitName)
    Return result
}

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

PressureUpdateConversion:
    Gui, Converter:Submit, NoHide
    
    If (PressureInputValue != "" && RegExMatch(PressureInputValue, "^-?\d*\.?\d+$"))
        GoSub, PressureAutoConvert
Return

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

;;∙================================================∙
;;∙======∙ENERGY CONVERSION LOGIC∙================∙

GetJouleFactor(unitName) {
    If (unitName = "Joules")
        Return 1.0
    If (unitName = "Kilojoules")
        Return 1000.0
    If (unitName = "Calories")
        Return 4.184
    If (unitName = "Kilocalories")
        Return 4184.0
    If (unitName = "Watt-hours")
        Return 3600.0
    If (unitName = "Kilowatt-hours")
        Return 3600000.0
    If (unitName = "BTU")
        Return 1055.06
    If (unitName = "Electron-volts")
        Return 1.602176634e-19
}

ConvertEnergy(value, fromUnitName, toUnitName) {
    joules := value * GetJouleFactor(fromUnitName)
    result := joules / GetJouleFactor(toUnitName)
    Return result
}

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

EnergyUpdateConversion:
    Gui, Converter:Submit, NoHide
    
    If (EnergyInputValue != "" && RegExMatch(EnergyInputValue, "^-?\d*\.?\d+$"))
        GoSub, EnergyAutoConvert
Return

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

;;∙================================================∙
;;∙======∙POWER CONVERSION LOGIC∙================∙

GetWattFactor(unitName) {
    If (unitName = "Watts")
        Return 1.0
    If (unitName = "Kilowatts")
        Return 1000.0
    If (unitName = "Megawatts")
        Return 1000000.0
    If (unitName = "Horsepower")
        Return 745.7
    If (unitName = "BTU per Hour")
        Return 0.293071
    If (unitName = "Foot-pounds per Second")
        Return 1.35582
}

ConvertPower(value, fromUnitName, toUnitName) {
    watts := value * GetWattFactor(fromUnitName)
    result := watts / GetWattFactor(toUnitName)
    Return result
}

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

PowerUpdateConversion:
    Gui, Converter:Submit, NoHide
    
    If (PowerInputValue != "" && RegExMatch(PowerInputValue, "^-?\d*\.?\d+$"))
        GoSub, PowerAutoConvert
Return

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

;;∙================================================∙
;;∙======∙FUEL CONSUMPTION CONVERSION LOGIC∙=====∙

ConvertFuel(value, fromUnitName, toUnitName) {
    If (fromUnitName = "MPG (US)")
        mpgUS := value
    Else If (fromUnitName = "MPG (UK)")
        mpgUS := value / 1.20095
    Else If (fromUnitName = "L/100km")
        mpgUS := 235.214583 / value
    Else If (fromUnitName = "km/L")
        mpgUS := value * 2.35215
    Else If (fromUnitName = "Miles per Liter")
        mpgUS := value * 3.78541
    
    If (toUnitName = "MPG (US)")
        Return mpgUS
    Else If (toUnitName = "MPG (UK)")
        Return mpgUS * 1.20095
    Else If (toUnitName = "L/100km")
        Return 235.214583 / mpgUS
    Else If (toUnitName = "km/L")
        Return mpgUS / 2.35215
    Else If (toUnitName = "Miles per Liter")
        Return mpgUS / 3.78541
    
    Return 0
}

FuelAutoConvert:
    Gui, Converter:Submit, NoHide
    
    If (FuelInputValue = "") {
        GuiControl, Converter:, FuelResultValue,
        Return
    }
    
    If (!RegExMatch(FuelInputValue, "^-?\d*\.?\d+$")) {
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

FuelUpdateConversion:
    Gui, Converter:Submit, NoHide
    
    If (FuelInputValue != "" && RegExMatch(FuelInputValue, "^-?\d*\.?\d+$"))
        GoSub, FuelAutoConvert
Return

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

;;∙================================================∙
;;∙======∙DATA TRANSFER CONVERSION LOGIC∙=========∙

GetBpsFactor(unitName) {
    If (unitName = "bps")
        Return 1.0
    If (unitName = "Kbps")
        Return 1000.0
    If (unitName = "Mbps")
        Return 1000000.0
    If (unitName = "Gbps")
        Return 1000000000.0
    If (unitName = "B/s")
        Return 8.0
    If (unitName = "KB/s")
        Return 8000.0
    If (unitName = "MB/s")
        Return 8000000.0
    If (unitName = "GB/s")
        Return 8000000000.0
}

ConvertDataTransfer(value, fromUnitName, toUnitName) {
    bps := value * GetBpsFactor(fromUnitName)
    result := bps / GetBpsFactor(toUnitName)
    Return result
}

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

DataUpdateConversion:
    Gui, Converter:Submit, NoHide
    
    If (DataInputValue != "" && RegExMatch(DataInputValue, "^-?\d*\.?\d+$"))
        GoSub, DataAutoConvert
Return

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

;;∙================================================∙
;;∙======∙ANGLE CONVERSION LOGIC∙=================∙

GetDegreeFactor(unitName) {
    If (unitName = "Degrees")
        Return 1.0
    If (unitName = "Radians")
        Return 57.2957795
    If (unitName = "Gradians")
        Return 0.9
    If (unitName = "Arcminutes")
        Return 0.0166667
    If (unitName = "Arcseconds")
        Return 0.000277778
    If (unitName = "Revolutions")
        Return 360.0
}

ConvertAngle(value, fromUnitName, toUnitName) {
    degrees := value * GetDegreeFactor(fromUnitName)
    result := degrees / GetDegreeFactor(toUnitName)
    Return result
}

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

AngleUpdateConversion:
    Gui, Converter:Submit, NoHide
    
    If (AngleInputValue != "" && RegExMatch(AngleInputValue, "^-?\d*\.?\d+$"))
        GoSub, AngleAutoConvert
Return

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

;;∙================================================∙
;;∙======∙TORQUE CONVERSION LOGIC∙================∙

GetNewtonMeterFactor(unitName) {
    If (unitName = "Newton-meters")
        Return 1.0
    If (unitName = "Foot-pounds")
        Return 1.35582
    If (unitName = "Inch-pounds")
        Return 0.112985
    If (unitName = "Kilogram-meters")
        Return 9.80665
    If (unitName = "Dyne-centimeters")
        Return 0.0000001
}

ConvertTorque(value, fromUnitName, toUnitName) {
    nm := value * GetNewtonMeterFactor(fromUnitName)
    result := nm / GetNewtonMeterFactor(toUnitName)
    Return result
}

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

TorqueUpdateConversion:
    Gui, Converter:Submit, NoHide
    
    If (TorqueInputValue != "" && RegExMatch(TorqueInputValue, "^-?\d*\.?\d+$"))
        GoSub, TorqueAutoConvert
Return

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

;;∙================================================∙
;;∙======∙FORCE CONVERSION LOGIC∙=================∙

GetNewtonFactor(unitName) {
    If (unitName = "Newtons")
        Return 1.0
    If (unitName = "Kilonewtons")
        Return 1000.0
    If (unitName = "Pounds-force")
        Return 4.44822
    If (unitName = "Kilograms-force")
        Return 9.80665
    If (unitName = "Dynes")
        Return 0.00001
}

ConvertForce(value, fromUnitName, toUnitName) {
    newtons := value * GetNewtonFactor(fromUnitName)
    result := newtons / GetNewtonFactor(toUnitName)
    Return result
}

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

ForceUpdateConversion:
    Gui, Converter:Submit, NoHide
    
    If (ForceInputValue != "" && RegExMatch(ForceInputValue, "^-?\d*\.?\d+$"))
        GoSub, ForceAutoConvert
Return

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

;;∙================================================∙
;;∙======∙ACCELERATION CONVERSION LOGIC∙==========∙

GetMps2Factor(unitName) {
    If (unitName = "m/s²")
        Return 1.0
    If (unitName = "ft/s²")
        Return 0.3048
    If (unitName = "g-force")
        Return 9.80665
    If (unitName = "Gal")
        Return 0.01
    If (unitName = "in/s²")
        Return 0.0254
    If (unitName = "km/h/s")
        Return 0.277778
}

ConvertAccel(value, fromUnitName, toUnitName) {
    mps2 := value * GetMps2Factor(fromUnitName)
    result := mps2 / GetMps2Factor(toUnitName)
    Return result
}

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

AccelUpdateConversion:
    Gui, Converter:Submit, NoHide
    
    If (AccelInputValue != "" && RegExMatch(AccelInputValue, "^-?\d*\.?\d+$"))
        GoSub, AccelAutoConvert
Return

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
;;∙======∙INTRO TAB NAVIGATION∙====================∙
GoToTab1:
    GuiControl, Converter:Choose, ConverterTabs, 1
Return
GoToTab2:
    GuiControl, Converter:Choose, ConverterTabs, 2
Return
GoToTab3:
    GuiControl, Converter:Choose, ConverterTabs, 3
Return
GoToTab4:
    GuiControl, Converter:Choose, ConverterTabs, 4
Return
GoToTab5:
    GuiControl, Converter:Choose, ConverterTabs, 5
Return
GoToTab6:
    GuiControl, Converter:Choose, ConverterTabs, 6
Return
GoToTab7:
    GuiControl, Converter:Choose, ConverterTabs, 7
Return
GoToTab8:
    GuiControl, Converter:Choose, ConverterTabs, 8
Return
GoToTab9:
    GuiControl, Converter:Choose, ConverterTabs, 9
Return
GoToTab10:
    GuiControl, Converter:Choose, ConverterTabs, 10
Return
GoToTab11:
    GuiControl, Converter:Choose, ConverterTabs, 11
Return
GoToTab12:
    GuiControl, Converter:Choose, ConverterTabs, 12
Return
GoToTab13:
    GuiControl, Converter:Choose, ConverterTabs, 13
Return
GoToTab14:
    GuiControl, Converter:Choose, ConverterTabs, 14
Return
GoToTab15:
    GuiControl, Converter:Choose, ConverterTabs, 15
Return
GoToTab16:
    GuiControl, Converter:Choose, ConverterTabs, 16
Return
GoToTab17:
    GuiControl, Converter:Choose, ConverterTabs, 17
Return
GoToTab18:
    GuiControl, Converter:Choose, ConverterTabs, 18
Return
GoToTab19:
    GuiControl, Converter:Choose, ConverterTabs, 19
Return

;;∙================================================∙
;;∙======∙TAB CHANGE HANDLER∙=====================∙
TabChanged:
    Gui, Converter:Submit, NoHide
    
    If (ConverterTabs = 10 && lastApiCheck = "") {
        GoSub, CurrencyFetchRates
    }
Return

;;∙================================================∙
;;∙======∙Show/Hide Window∙========================∙
RestoreWindow:
    DetectHiddenWindows, On
    IfWinExist, %ScriptID%
    {
        Winget, winState, Style, %ScriptID%
        If (winState & 0x10000000) {
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

;;∙================================================∙
;;∙======∙WINDOW DRAG & CONTROLS∙===============∙
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}
Return

CloseConverter:
ConverterGuiClose:
    ExitApp
Return

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

Documentation:
    Run, "C:\Program Files\AutoHotkey\AutoHotkey.chm"
Return

ShowKeyHistory:
    KeyHistory
Return

ShowWindowSpy:
    Run, "C:\Program Files\AutoHotkey\WindowSpy.ahk"
Return

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
    Menu, Tray, Show, % mx - 20, % my - 20
Return

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
    Soundbeep, 1700, 100
Reload

;;∙================================================∙
;;∙======∙EDIT / RELOAD / EXIT∙======================∙
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
    ExitApp
Return
;;∙================================================∙

;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
