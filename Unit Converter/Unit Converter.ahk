
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  fuzz54
» Original Source:  https://www.autohotkey.com/board/topic/39359-unit-converter/
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

;;∙======∙HotKey∙===============================================∙
^t::    ;;∙------∙🔥∙(Ctrl + T)
    Soundbeep, 1000, 200
;;∙============================================================∙




;;∙============================================================∙
;;∙============================================================∙
;;∙------------∙Variables∙--------------------------------------------------------------------∙
xe = 2.718281828459045, xpi = 3.141592653589793

;;∙------------∙Number formatting, decimals, and groupbox dividers∙------------∙
Gui, +AlwaysOnTop -Caption +Border
Gui, Color, 00ABFF

Gui, Add, GroupBox, x10 y35 w260 h235 cblack, MAIN BOX
Gui, Add, GroupBox, x10 y10 w260 h95 BackgroundTrans cblack, ; MAIN BOUNDRY BOX
Gui, Add, GroupBox, x15 y105 w135 h60 BackgroundTrans cblack,    ;;∙------∙RegSci Box.
Gui, Add, GroupBox, x160 y105 w100 h60 BackgroundTrans cblack,    ;;∙------∙SaveResult Box.

Gui, Add, Radio, x20 y115 h20 BackgroundTrans checked greg, Regular
Gui, Add, Radio, x20 y135 h20 BackgroundTrans gsci, Scientific

Gui, Add, Edit, x95 y130 w40 h20 BackgroundTrans gRpre vRP,    ;;∙------∙Decimals counter.

Gui, Add, UpDown, Range0-18 0x80, 2
Gui, Add, Text, x95 y115 BackgroundTrans Hide, Decimals    ;;∙------∙Decimal label text.

;;∙------------∙Memory variable controls∙------------∙
Gui, Add, Text, x170 y115 BackgroundTrans vgobyebye, Save Result To    ;;∙------∙Save Result text.
Gui, Add, Text, x170 y87 BackgroundTrans vgone, paste memory
Gui, Add, DropDownList, x170 y135 w75 h17 BackgroundTrans r5 gmem vmem, Memory1Memory2Memory3Memory4Memory5
Gui, Add, DropDownList, x170 y135 w75 h17 BackgroundTrans r5 gmemrec vmemrec, Memory1Memory2Memory3Memory4Memory5

;;∙------------∙Top GUI control - quanitity dropdown list∙---------------------------∙
Gui, Add, DropDownList, x75 y10 w145 h20 BackgroundTrans r26 gunits vunits, AccelerationAngleAreaCoeff. of Thermal ExpansionDensityDistanceElectric CurrentEnergyForceHeat CapacityHeat Transfer CoefficientMassPowerPressureSpecific HeatSpeedTemperatureThermal ConductivityTimeVolume --------------------------------------------Physical ConstantsMathematical ConstantsCALCULATOR

;;∙------------∙Middle GUI controls, from and to units∙------------------------------∙
Gui, Add, DropDownList, x15 y50 w110 h20 BackgroundTrans r30 vfrom gcalc,    ;;∙------∙1st (ms2)
Gui, Add, Text, x130 y50 w17 h20 BackgroundTrans gswap vswap +Center, To    ;;∙------∙To text.
Gui, Add, DropDownList, x150 y50 w110 h20 BackgroundTrans r30 vto gcalc,    ;;∙------∙2nd (ms2)

;;∙------------∙Bottom GUI controls, input and result∙-------------------------------∙
Gui, Add, Edit, x15 y75 w110 h20 BackgroundTrans gcalc vtot,    ;;∙------∙From Box
Gui, add, updown,range1-1000 +wrap 0x80 vgoaway,1
Gui, Add, Text, x130 y75 w17 h20 BackgroundTrans +Center vequal, =    ;;∙------∙(=) Equal sign.
Gui, Add, Edit, x150 y75 w110 h20 BackgroundTrans vrez +readonly,    ;;∙------∙To Box

;;∙------------∙Calculator∙------------------------------------------------------------------∙
Gui Add, Edit, x15 y190 w130 h20 vcode Hidden,
Gui Add, Edit, x160 y190 w100 h20 vres Hidden Readonly ; no scroll bar for results
Gui, Add, Text, x150 y190 w5 h20 +Center vequals, =

Gui Add, Button, x125 y215 w40 h20 Hidden vclear, &Clear
Gui Add, Button, x+5 y215 w55 h20 Default Hidden vevaluate, &Evaluate
Gui Add, Button, x+5 y215 w30 h20 Hidden vhelp, &Help

Gui Add, Button, x127 y240 w16 h20 Hidden vlparen, (
Gui Add, Button, x+2 y240 w16 h20 Hidden vrparen, )
Gui Add, Button, x+2 y240 w16 h20 Hidden vmultiply, x
Gui Add, Button, x+2 y240 w16 h20 Hidden vdivide, 
Gui Add, Button, x+2 y240 w16 h20 Hidden vadd, +
Gui Add, Button, x+2 y240 w16 h20 Hidden vsubtract, -
Gui Add, Button, x+2 y240 w24 h20 Hidden vexponent,exp

Gui, Font, s12 w600 q5, Calibri
Gui, Add, Text, x20 y275 cBlue gReload, Reload
Gui, Add, Text, x235 y275 cRed gExit, Exit

gosub, units
gosub reg
Gui, Show, w280 h300, Unit Converter v2.1
Return
;;∙---------------------------------------------------------------------------------------------∙


;;∙---------------------------------------------------------------------------------------------∙
Reload
    Reload
Return
;;∙----------------------------------------∙
Exit
GuiClose
ExitApp
Return
;;∙---------------------------------------------------------------------------------------------∙


;;∙---------------------------------------------------------------------------------------------∙
swap
If units=Physical Constants
   return
If units=Mathematical Constants
   return
Gui, submit, nohide
GuiControlGet, From, , Combobox4
GuiControlGet, To, , Combobox5
ControlGet, List ,List, List, Combobox4
StringReplace, List, List, `n, , all
List .= 
StringReplace, FromList, List, %From%, %From%
StringReplace, ToList, List, %To%, %To%
GuiControl, , Combobox4, 
GuiControl, , Combobox4, %ToList%
GuiControl, , Combobox5, 
GuiControl, , Combobox5, %FromList%
gosub calc
Return
;;∙----------------------------------------∙
mem
Gui, submit, nohide
If mem = Memory1
     Mem1=%rez%
If mem = Memory2
     Mem2=%rez%
If mem = Memory3
     Mem3=%rez%
If mem = Memory4
     Mem4=%rez%
If mem = Memory5
     Mem5=%rez%
Return
;;∙----------------------------------------∙
memrec
Gui, submit, nohide
If memrec = Memory1
     Pastemem=%Mem1%
If memrec = Memory2
     Pastemem=%Mem2%
If memrec = Memory3
     Pastemem=%Mem3%
If memrec = Memory4
     Pastemem=%Mem4%
If memrec = Memory5
     Pastemem=%Mem5%
coded=%code%%Pastemem%
Guicontrol,, code, %coded%
Guicontrol,focus,code
Send, {END}
gosub buttonevaluate
Return
;;∙----------------------------------------∙
reg
pre = 0
If units=CALCULATOR
     gosub buttonevaluate
Else
     gosub calc
return
;;∙----------------------------------------∙
sci
pre = 1
If units=CALCULATOR
     gosub buttonevaluate
Else
     gosub calc
Return

Rpre
Gui, submit, nohide
RegP = 0.%RP%
SetFormat, Float, %RegP%
If Units=CALCULATOR
     gosub buttonevaluate
Else
     gosub calc
Return
;;∙----------------------------------------∙
ButtonClear
   Gui Submit, Nohide
   Guicontrol,, code,
   Guicontrol,, res,
   Guicontrol,focus,code
Return
;;∙----------------------------------------∙
ButtonEvaluate                                ; Alt-V or Enter evaluate expression
   Gui Submit, NoHide
   if pre
      SetFormat, float, %RegP%E
   else
      SetFormat, float, %RegP%
   coded=code
   GuiControl,,Res,% Eval(coded)
   Guicontrol,focus,code
   Send, {END}
Return
;;∙----------------------------------------∙
Button(
   Gui Submit, Nohide
   codeadd=%code%(
   Guicontrol,, code, %codeadd%
   Guicontrol,focus,code
   Send, {END}   
Return   
;;∙----------------------------------------∙
Button)
   Gui Submit, Nohide
   codeadd=%code%)
   Guicontrol,, code, %codeadd%
   Guicontrol,focus,code
   Send, {END}   
Return
;;∙----------------------------------------∙
Buttonx
   Gui Submit, Nohide
   codeadd=%code%
   Guicontrol,, code, %codeadd%
   Guicontrol,focus,code
   Send, {END}   
Return   
;;∙----------------------------------------∙
Button
   Gui Submit, Nohide
   codeadd=%code%
   Guicontrol,, code, %codeadd%
   Guicontrol,focus,code
   Send, {END}   
Return
;;∙----------------------------------------∙
Button+
   Gui Submit, Nohide
   codeadd=%code%+
   Guicontrol,, code, %codeadd%
   Guicontrol,focus,code
   Send, {END}   
Return
;;∙----------------------------------------∙
Button-
   Gui Submit, Nohide
   codeadd=%code%-
   Guicontrol,, code, %codeadd%
   Guicontrol,focus,code
   Send, {END}
Return
;;∙----------------------------------------∙
ButtonExp
   Gui Submit, Nohide
   codeadd=%code%
   Guicontrol,, code, %codeadd%
   Guicontrol,focus,code
   Send, {END}
Return
;;∙----------------------------------------∙
units
Gui, submit, nohide
if units=CALCULATOR
{
Guicontrol,focus,code
Guicontrol,Show,Code
Guicontrol,Show,Res
Guicontrol,Show,gone
Guicontrol,Show,memrec
Guicontrol,Show,Help
Guicontrol,Show,Evaluate
Guicontrol,Show,Clear
Guicontrol,Show,multiply
Guicontrol,Show,divide
Guicontrol,Show,add
Guicontrol,Show,subtract
Guicontrol,Show,exponent
Guicontrol,Show,equals
Guicontrol,Show,lparen
Guicontrol,Show,rparen
Guicontrol,Show,RP
Guicontrol,Hide,tot
Guicontrol,Hide,rez
Guicontrol,Hide,from
Guicontrol,Hide,to
Guicontrol,Hide,To
Guicontrol,Hide,goaway
Guicontrol,Hide,gobyebye
Guicontrol,Hide,mem
Guicontrol,Hide,equal
}
else
{
Guicontrol,hide,Code
Guicontrol,hide,Res
Guicontrol,hide,gone
Guicontrol,hide,memrec
Guicontrol,hide,Help
Guicontrol,hide,Evaluate
Guicontrol,hide,Clear
Guicontrol,hide,multiply
Guicontrol,hide,divide
Guicontrol,hide,add
Guicontrol,hide,subtract
Guicontrol,hide,exponent
Guicontrol,hide,equals
Guicontrol,hide,lparen
Guicontrol,hide,rparen
Guicontrol,show,tot
Guicontrol,show,rez
Guicontrol,show,from
Guicontrol,show,to
Guicontrol,show,To
Guicontrol,show,goaway
Guicontrol,show,gobyebye
Guicontrol,show,mem
Guicontrol,show,equal
Guicontrol,show,RP
}
;;∙----------------------------------------∙
if units=Mass
{
Guicontrol,, from, 
Guicontrol,, from, kilogramsgramsouncespoundsstonetonton(uk)slugs
Guicontrol,, to, 
Guicontrol,, to, kilogramsgramsouncespoundsstonetonton(uk)slugs
}
;;∙----------------------------------------∙
if units=Distance
{
Guicontrol,, from, 
Guicontrol,, from, feetinchesmilmeterscentimeterkilometermillimetermicronmilefurlongyardAngstromlight yearparsecAU
Guicontrol,, to, 
Guicontrol,, to, feetinchesmilmeterscentimeterkilometermillimetermicronmilefurlongyardAngstromlight yearparsecAU
}
;;∙----------------------------------------∙
if units=Density
{
Guicontrol,, from, 
Guicontrol,, from, lbin³lbft³gcm³kgm³slugsft³
Guicontrol,, to, 
Guicontrol,, to, lbin³lbft³gcm³kgm³slugsft³
}
;;∙----------------------------------------∙
if units=Acceleration
{
Guicontrol,, from, 
Guicontrol,, from, ms²ins²fts²g's
Guicontrol,, to, 
Guicontrol,, to, ms²ins²fts²g's
}
;;∙----------------------------------------∙
if units=Force
{
Guicontrol,, from, 
Guicontrol,, from, Newtonlbfdyne
Guicontrol,, to, 
Guicontrol,, to, Newtonlbfdyne
}
;;∙----------------------------------------∙
if units=Pressure
{
Guicontrol,, from, 
Guicontrol,, from, Pascalpsipsftorrbaratmmm mercurycm water
Guicontrol,, to, 
Guicontrol,, to, Pascalpsipsftorrbaratmmm mercurycm water
}
;;∙----------------------------------------∙
if units=Energy
{
Guicontrol,, from, 
Guicontrol,, from, JouleBTUin lbfft lbfkcaltherm
Guicontrol,, to, 
Guicontrol,, to, JouleBTUin lbfft lbfkcaltherm
}
;;∙----------------------------------------∙
if units=Power
{
Guicontrol,, from, 
Guicontrol,, from, WattBTUsecBTUhourhpft lbfs
Guicontrol,, to, 
Guicontrol,, to, WattBTUsecBTUhourhpft lbfs
}
;;∙----------------------------------------∙
if units=Time
{
Guicontrol,, from, 
Guicontrol,, from, secondsminuteshoursdaysweeksmonths(30d)years
Guicontrol,, to, 
Guicontrol,, to, secondsminuteshoursdaysweeksmonths(30d)years
}
;;∙----------------------------------------∙
if units=Thermal Conductivity
{
Guicontrol,, from, 
Guicontrol,, from, Wattm-KkiloWattm-KBTUhr-ft-FBTUhr-in-FBTU-inhr-ft²-Fcals-cm-C
Guicontrol,, to, 
Guicontrol,, to, Wattm-KkiloWattm-KBTUhr-ft-FBTUhr-in-FBTU-inhr-ft²-Fcals-cm-C
}
;;∙----------------------------------------∙
if units=Specific Heat
{
Guicontrol,, from, 
Guicontrol,, from, KiloJoulekg-KBTUlb-Fcalg-C
Guicontrol,, to, 
Guicontrol,, to, KiloJoulekg-KBTUlb-Fcalg-C
}
;;∙----------------------------------------∙
if units=Heat Capacity
{
Guicontrol,, from, 
Guicontrol,, from, Jkg-KBTUlb-CBTUlb-Fcalg-C
Guicontrol,, to, 
Guicontrol,, to, Jkg-KBTUlb-CBTUlb-Fcalg-C
}
;;∙----------------------------------------∙
if units=Heat Transfer Coefficient
{
Guicontrol,, from, 
Guicontrol,, from, Wattm²-KBTUhr-ft²-Fcals-cm²-Ckcalhr-ft²-C
Guicontrol,, to, 
Guicontrol,, to, Wattm²-KBTUhr-ft²-Fcals-cm²-Ckcalhr-ft²-C
}
;;∙----------------------------------------∙
if units=Area
{
Guicontrol,, from, 
Guicontrol,, from, m²cm²mm²micron²in²ft²yd²mil²acre
Guicontrol,, to, 
Guicontrol,, to, m²cm²mm²micron²in²ft²yd²mil²acre
}
;;∙----------------------------------------∙
if units=Volume
{
Guicontrol,, from, 
Guicontrol,, from, m³cm³mm³in³ft³yd³ouncepintquarttsptbspliter
Guicontrol,, to, 
Guicontrol,, to, m³cm³mm³in³ft³yd³ouncepintquarttsptbspliter
}
;;∙----------------------------------------∙
if units=Angle
{
Guicontrol,, from, 
Guicontrol,, from, radiansdegreesmilsminutesecondgradcycle
Guicontrol,, to, 
Guicontrol,, to, radiansdegreesmilsminutesecondgradcycle
}
;;∙----------------------------------------∙
if units=Temperature
{
Guicontrol,, from, 
Guicontrol,, from, KelvinCelsiusFahrenheitRankineReaumur
Guicontrol,, to, 
Guicontrol,, to, KelvinCelsiusFahrenheitRankineReaumur
}
;;∙----------------------------------------∙
if units=Speed
{
Guicontrol,, from, 
Guicontrol,, from, mskmhinsftsyardsmphMach Numberspeed of light
Guicontrol,, to, 
Guicontrol,, to, mskmhinsftsyardsmphMach Numberspeed of light
}
;;∙----------------------------------------∙
if units=Electric Current
{
Guicontrol,, from, 
Guicontrol,, from, amperecoulombsstatampere
Guicontrol,, to, 
Guicontrol,, to, amperecoulombsstatampere
}
;;∙----------------------------------------∙
if units=Physical Constants
{
Guicontrol,, from, 
Guicontrol,, from, Speed of Light (ms)Gravitation (m³kg-s²)Planck's Constant (J-s)magnetic constant (NA²)electric constant (Fm)Coulomb cons. (N-m²C²)elementary charge (C)Electron Mass (kg)Proton Mass (kg)fine structure constantRydberg constant (1m)atomic mass unit (kg)Avogadro's # (1mol)Boltzmann constant (JK)Faraday constant (Cmol)gas constant (JK-mol)Stefan-Boltz. (Wm²-K^4)
Guicontrol,Hide, to
Guicontrol,Hide, swap
}
;;∙----------------------------------------∙
if units=Coeff. of Thermal Expansion
{
Guicontrol,, from, 
Guicontrol,, from, 1°K1°C1°F1°R
Guicontrol,, to, 
Guicontrol,, to, 1°K1°C1°F1°R
}
;;∙----------------------------------------∙
if units=Mathematical Constants
{
Guicontrol,, from, 
Guicontrol,, from, PieEuler-MascheroniGolden RatioSilver RatioFeigenbaum 1Feigenbaum 2Twin Prime constantMeissel-MertensLaplace limitApéry's constantLévy's constantOmega constantPlastic ConstantParabolic ConstantBrun's Twin PrimeBrun's Quad PrimeKhinchin's constantFransén-Robinson
Guicontrol,Hide, to
Guicontrol,Hide, swap
}
gosub, calc
return
;;∙------------------------------------------------------------------------------------------∙
calc
gui, submit, nohide
SetFormat, Float, 0.16E
;;∙----------------------------------------∙
; ▁▁▁ distance from
if from=feet
from=1.0
if from=inches
from=.0833333
if from=mil
from=.0000833333
if from=microns
from=3.2808E-6
if from=meters
from=3.2808
if from=kilometer
from=3280.8399
if from=centimeter
from=0.032808399
if from=millimeter
from=0.0032808399
if from=mile
from=5280
if from=furlong
from=660
if from=yard
from=3
if from=Angstrom
from=3.280839895E-10
if from=light year
from=31017896836000000
if from=parsec
from=101236138050000000
if from=AU
from=490806662370
; ▁▁▁ distance to
if to=feet
to=1.0
if to=inches
to=.0833333
if to=mil
to=.0000833333
if to=micron
to=3.2808E-6
if to=meters
to=3.2808
if to=kilometer
to=3280.8399
if to=centimeter
to=0.032808399
if to=millimeter
to=0.0032808399
if to=mile
to=5280
if to=furlong
to=660
if to=yard
to=3
if to=Angstrom
to=3.280839895E-10
if to=light year
to=31017896836000000
if to=parsec
to=101236138050000000
if to=AU
to=490806662370


; ▁▁▁ Area from
If From=m²
From=1.0
If From=cm²
From=.0001
If From=mm²
From=0.000001
If From=micron²
From=1.0E-12
If From=in²
From=0.00064516
If From=ft²
From=0.09290304
If From=yd²
From=0.83612736
If From=mil²
From=6.4516E-10
If From=acre
From=4046.8564224
; ▁▁▁ Area to
If To=m²
To=1.0
If To=cm²
To=.0001
If To=mm²
To=0.000001
If To=micron²
To=1.0E-12
If To=in²
To=0.00064516
If To=ft²
To=0.09290304
If To=yd²
To=0.83612736
If To=mil²
To=6.4516E-10
If To=acre
To=4046.8564224

; ▁▁▁ Volume from
If From=m³
From=1.0
If From=cm³
From=0.000001
If From=mm³
From=1.0E-9
If From=in³
From=0.000016387064
If From=ft³
From=0.028316846592
If From=yd³
From=0.76455485798
If From=cup
From=0.0002365882365
If From=ounce
From=0.000029573529563
If From=pint
From=0.000473176473
If From=quart
From=0.000946352946
If From=tsp
From=0.0000049289215938
If From=tbsp
From=0.000014786764781
If From=liter
From=0.001
; ▁▁▁ Volume to
If To=m³
To=1.0
If To=cm³
To=0.000001
If To=mm³
To=1.0E-9
If To=in³
To=0.000016387064
If To=ft³
To=0.028316846592
If To=yd³
To=0.76455485798
If To=cup
To=0.0002365882365
If To=ounce
To=0.000029573529563
If To=pint
To=0.000473176473
If To=quart
To=0.000946352946
If To=tsp
To=0.0000049289215938
If To=tbsp
To=0.000014786764781
If To=liter
To=0.001

; ▁▁▁ Angle from
If From=radians
From=1.0
If From=degrees
From=0.01745329252
If From=minute
From=0.00029088820867
If From=second
From=0.0000048481368111
If From=mils
From=0.00098174770425
If From=grad
From=0.015707963268
If From=cycle
From=6.2831853072
If From=circle
From=6.2831853072
; ▁▁▁ Angle to
If To=radians
To=1.0
If To=degrees
To=0.01745329252
If To=minute
To=0.00029088820867
If To=second
To=0.0000048481368111
If To=mils
To=0.00098174770425
If To=grad
To=0.015707963268
If To=cycle
To=6.2831853072
If To=circle
To=6.2831853072

; ▁▁▁ weight from
If From=Kilograms
From=2.2046226218
If From=Grams
From=0.0022046226218
If From=Ounces
From=0.0625
If From=Pounds
From=1
If From=Stone
From=14
If From=Ton
From=2000
If From=Ton(Uk)
From=2240
If From=slugs
From=32.174048695
; ▁▁▁ weight to
If To=Kilograms
To=2.2046
If To=Grams
To=0.0022046226218
If To=Ounces
To=0.0625
If To=Pounds
To=1
If To=Stone
To=14
If To=Ton
To=2000
If To=Ton(Uk)
To=2240
If To=slugs
To=32.174048695

; ▁▁▁ density from
If From=lbin³
From=1
If From=lbft³
From=0.000578703
If From=Kgm³
From=3.6127E-5
If From=slugsft³
From=515.31788206
If From=gcm³
From=0.036127292927
; ▁▁▁ density to
If To=lbin³
To=1
If To=lbft³
To=0.000578703
If To=Kgm³
To=3.6127E-5
If To=slugsft³
To=515.31788206
If To=gcm³
To=0.036127292927

; ▁▁▁ acceleration from
If From=ms²
From=1
If From=ins²
From=0.0254
If From=fts²
From=0.3048
If From=g's
From=9.80665
; ▁▁▁ acceleration to
If To=ms²
To=1
If To=ins²
To=0.0254
If To=fts²
To=0.3048
If To=g's
To=9.80665

; ▁▁▁ Force from
If From=Newton
From=1
If From=lbf
From=4.4482
If From=dyne
From=10.0E-6
; ▁▁▁ Force to
If To=Newton
To=1
If To=lbf
To=4.4482
If To=dyne
To=10.0E-6

; ▁▁▁ Pressure from
If From=Pascal
From=1
If From=psi
From=6894.757
If From=psf
From=47.88025
If From=torr
From=133.3224
If From=mm mercury
From=133.3224
If From=bar
From=1.0E5
If From=atm
From=101325
If From=cm water
From=98.0665
; ▁▁▁ Pressure to
If To=Pascal
To=1
If To=psi
To=6894.757
If To=psf
To=47.88025
If To=torr
To=133.3224
If To=mm mercury
To=133.3224
If To=bar
To=1.0E5
If To=atm
To=101325
If To=cm water
To=98.0665

; ▁▁▁ Energy from
If From=Joule
From=1
If From=BTU
From=1.055055E3
If From=in lbf
From=0.112984
If From=ft lbf
From=1.355817
If From=kcal
From=4186.8
If From=therm
From=105505585.257348
; ▁▁▁ Energy to
If To=Joule
To=1
If To=BTU
To=1.055055E3
If To=in lbf
To=0.112984
If To=ft lbf
To=1.355817
If To=kcal
To=4186.8
If To=therm
To=105505585.257348

; ▁▁▁ Power from
If From=Watt
From=1
If From=BTUhour
From=0.293071
If From=BTUsec
From=1055.055
If From=hp
From=735.49875
If From=ft lbfs
From=1.355817
; ▁▁▁ Power to
If To=Watt
To=1
If To=BTUhour
To=0.293071
If To=BTUsec
To=1055.055
If To=hp
To=735.49875
If To=ft lbfs
To=1.355817

; ▁▁▁ Time from
If From=seconds
From=1
If From=minutes
From=60
If From=hours
From=3600
If From=days
From=86400
If From=weeks
From=604800
If From=months(30d)
From=2592000
If From=years
From=31536000
; ▁▁▁ Time to
If To=seconds
To=1
If To=minutes
To=60
If To=hours
To=3600
If To=days
To=86400
If To=weeks
To=604800
If To=months(30d)
To=2592000
If To=years
To=31536000

; ▁▁▁ Thermal Conductivity from
If From=Wattm-K
From=1
If From=kiloWattm-K
From=1000
If From=BTUhr-ft-F
From=1.729577
If From=BTUhr-in-F
From=20.754924
If From=BTU-inhr-ft²-F
From=0.144131
If From=cals-cm-C
From=418.4
; ▁▁▁ Thermal Conductivity to
If To=Wattm-K
To=1
If To=kiloWattm-K
To=1000
If To=BTUhr-ft-F
To=1.729577
If To=BTUhr-in-F
To=20.754924
If To=BTU-inhr-ft²-F
To=0.144131
If To=cals-cm-C
To=418.4

; ▁▁▁ Specific Heat from
If units=Specific Heat
{
If From=KiloJoulekg-K
From=1
If From=BTUlb-F
From=4.1868
If From=calg-C
From=4.1868
; ▁▁▁ Specific Heat to
If To=KiloJoulekg-K
To=1
If To=BTUlb-F
To=4.1868
If To=calg-C
To=4.1868
}

; ▁▁▁ Heat Capacity from
If From=Jkg-K
From=1
If From=BTUlb-C
From=2326
If From=BTUlb-F
From=4186.8
If From=calg-C
From=4186.8
; ▁▁▁ Heat Capacity to
If To=Jkg-K
To=1
If To=BTUlb-C
To=2326
If To=BTUlb-F
To=4186.8
If To=calg-C
To=4186.8

; ▁▁▁ Heat Transfer Coefficient from
If From=Wattm²-K
From=1
If From=BTUhr-ft²-F
From=5.678263
If From=cals-cm²-C
From=41868
If From=kcalhr-ft²-C
From=12.518428
; ▁▁▁ Heat Transfer Coefficient to
If To=Wattm²-K
To=1
If To=BTUhr-ft²-F
To=5.678263
If To=cals-cm²-C
To=41868
If To=kcalhr-ft²-C
To=12.518428

; ▁▁▁ Speed from
If From=ms
From=1
If From=kmh
From=0.277777777778
If From=ins
From=0.0254
If From=fts
From=0.3048
If From=yards
From=0.9144
If From=mph
From=0.44704
If From=Mach Number
From=340.2933
If From=speed of light
From=299790000
; ▁▁▁ Speed to
If To=ms
To=1
If To=kmh
To=0.277777777778
If To=ins
To=0.0254
If To=fts
To=0.3048
If To=yards
To=0.9144
If To=mph
To=0.44704
If To=Mach Number
To=340.2933
If To=speed of light
To=299790000

; ▁▁▁ Electric Current from
If From=ampere
From=1
If From=coulombs
From=1
If From=statampere
From=3.335641E-10
; ▁▁▁ Electric Current to
If To=ampere
To=1
If To=coulombs
To=1
If To=statampere
To=3.335641E-10

; ▁▁▁ Coefficient of Thermal Expansion from
If From=1°K
From=1.0
If From=1°C
From=1.0
If From=1°F
From=1.8
If From=1°R
From=1.8
; ▁▁▁ Coefficient of Thermal Expansion to
If to=1°K
to=1.0
If to=1°C
to=1.0
If to=1°F
to=1.8
If to=1°R
to=1.8

val=(fromto)tot


; ▁▁▁ Temperature Equation - SPECIAL CASE
If units=Temperature
   {
   If From=Kelvin
     {
     If To=Kelvin
        val=tot
     If To=Fahrenheit
        val=tot95-459.67
     If To=Celsius
        val=tot-273.15
     If To=Rankine
        val=tot95
     If To=Reaumur
        val=(tot-273.15)45
     }
   Else If From=Fahrenheit
     {
     If To=Kelvin
        val=(tot+459.67)59
     If To=Fahrenheit
        val=tot
     If To=Celsius
        val=(tot-32)59
     If To=Rankine
        val=tot+459.67
     If To=Reaumur
        val=(tot-32)49
     }
   Else If From=Celsius
     {
     If To=Kelvin
        val=tot+273.15
     If To=Fahrenheit
        val=tot95+32
     If To=Celsius
        val=tot
     If To=Rankine
        val=(tot+273.15)95
     If To=Reaumur
        val=tot45
     }
   Else If From=Rankine
     {
     If To=Kelvin
        val=tot59
     If To=Fahrenheit
        val=tot-459.67
     If To=Celsius
        val=(tot-491.67)59
     If To=Rankine
        val=tot
     If To=Reaumur
        val=(tot-491.67)49
     }
   Else If From=Reaumur
     {
     If To=Kelvin
        val=tot54+273.15
     If To=Fahrenheit
        val=tot94+32
     If To=Celsius
        val=tot54
     If To=Rankine
        val=tot94+491.67
     If To=Reaumur
        val=tot
     }
   }

; ▁▁▁ Physical Constants - SPECIAL CASE
If Units=Physical Constants
     {
     If From=Speed of Light (ms)
          val=299792458.
     If From=Gravitation (m³kg-s²)
          val=6.67428E-11
     If From=Planck's constant (J-s)
          val=6.62606896E-34
     If From=magnetic constant (NA²)
          val=1.256637061E-6
     If From=electric constant (Fm)
          val=8.854187817E-12
     If From=Coulomb cons. (N-m²C²)
          val=8.9875517873681764E9
     If From=elementary charge (C)
          val=1.602176487E-19
     If From=Electron Mass (kg)
          val=9.10938215E-31
     If From=Proton Mass (kg)
          val=1.672621637E-27
     If From=fine structure constant
          val=7.2973525376E-3
     If From=Rydberg constant (1m)
          val=10973731.568525
     If From=atomic mass unit (kg)
          val=1.66053886E-27
     If From=Avogadro's # (1mol)
          val=6.0221415E23
     If From=Boltzmann constant (JK)
          val=1.3806503882381375462532721956135E-23
     If From=Faraday constant (Cmol)
          val=96485.3371638995
     If From=gas constant (JK-mol)
          val=8.314472
     If From=Stefan-Boltz. (Wm²-K^4)
          val=5.670400E-8
     }

; ▁▁▁ Mathematical Constants - SPECIAL CASE
If Units=Mathematical Constants
     {
     If From=Pi
          val=3.14159265358979323846264338327950288
     If From=e
          val=2.71828182845904523536028747135266249
     If From=Euler-Mascheroni
          val=0.57721566490153286060651209008240243
     If From=Golden Ratio
          val=1.61803398874989484820458683436563811
     If From=Silver Ratio
          val=2.4142135623730949
     If From=Feigenbaum 1
          val=4.66920160910299067185320382046620161
     If From=Feigenbaum 2
          val=4.66920160910299067185320382046620161
     If From=Twin Prime constant
          val=0.66016181584686957392781211001455577
     If From=Meissel-Mertens
          val=0.26149721284764278375542683860869585
     If From=Laplace limit
          val=0.66274341934918158097474209710925290
     If From=Apéry's constant
          val=1.20205690315959428539973816151144999
     If From=Lévy's constant
          val=3.27582291872181115978768188245384386
     If From=Omega constant
          val= 0.56714329040978387299996866221035555
     If From=Plastic Constant
          val=1.32471795724474602596090885447809734
     If From=Brun's Twin Prime
          val=1.9021605823
     If From=Brun's Quad Prime
          val=0.8705883800
     If From=Khinchin's constant
          val=2.68545200106530644530971483548179569
     If From=Fransén-Robinson
          val=2.80777024202851936522150118655777293
     If From=Parabolic Constant
          val=2.29558714939263807403429804918949039
               }

if pre
   SetFormat, float, %RegP%E
else
   SetFormat, float, %RegP%
val = val + 0
guicontrol,, rez, %val%
return



▪◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘▪ 
» Expression Evaluation code by Laszlo at httpwww.autohotkey.comforumviewtopic.phpt=17058
» ALL THE CODE FROM HERE AND BELOW IS ONLY FOR CALCULATOR  EXPRESSION EVALUATOR!!
▪◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘◘▪ 


SetFormat Float, 0.16e                         ; max precise AHK internal format

ButtonHelp                                    ; Alt-H

If units=CALCULATOR
{
   MsgBox,                                     ; list of shortcuts, functions
(
Shortcut commands
   Alt-V, Enter evaluate expression
   Alt-c, Clear clear calculator

Functions (AHK's and the following)

   MONSTER Version 1.1 (needs AHK 1.0.46.12+)
   EVALUATE ARITHMETIC EXPRESSIONS containing HEX, Binary ('1001), scientific numbers (1.2e+5)
   (..); variables, constants e, pi;
   ( ); logicals ; &&; relationals =,; ,,=,=; user operators GCD,MIN,MAX,Choose;
   ; ^; &; , ; +, -; , ,  (or  = mod);  (or @ = power); !,~;
   
   Functions AHK's and AbsCeilExpFloorLogLnRoundSqrtSinCosTanASinACosATanSGNFibfac;
   User defined functions f(x) = expr;

Math Constants
   pi  = pi       e   = e

)
}
Return

Eval(x) {                              ; non-recursive PREPOST PROCESSING IO forms, numbers, ops, ;
   Local FORM, FormF, FormI, i, W, y, y1, y2, y3, y4
   FormI = A_FormatInteger, FormF = A_FormatFloat

   SetFormat Integer, D                ; decimal intermediate results!
   RegExMatch(x, $(bhx)(d[eEgG]), y)
   FORM = y1, W = y2                 ; HeX, Bin, .{digits} output format
   SetFormat FLOAT, 0.16e              ; Full intermediate float precision
   StringReplace x, x, %y%             ; remove $..
   Loop
      If RegExMatch(x, i)(.)(0x[a-fd])(.), y)
         x = y1 . y2+0 . y3           ; convert hex numbers to decimal
      Else Break
   Loop
      If RegExMatch(x, (.)'([01])(.), y)
         x = y1 . FromBin(y2) . y3    ; convert binary numbers to decimal sign = first bit
      Else Break
   x = RegExReplace(x,(^[^.d])(d+)(eE),$1$2.$3) ; add missing '.' before E (1e3 - 1.e3)
                                       ; literal scientific numbers between ‘ and ’ chars
   x = RegExReplace(x,(d.dd)([eE][+-]d+),‘$1$2’)

   StringReplace x, x,`%, , All       ; %  -  (= MOD)
   StringReplace x, x, ,@, All       ;  - @ for easier process
   StringReplace x, x, +, ±, All       ; ± is addition
   x = RegExReplace(x,(‘[^’])±,$1+) ; ...not inside literal numbers
   StringReplace x, x, -, ¬, All       ; ¬ is subtraction
   x = RegExReplace(x,(‘[^’])¬,$1-) ; ...not inside literal numbers

   Loop Parse, x, `;
      y = Eval1(A_LoopField)          ; work on pre-processed sub expressions
                                       ; return result of last sub-expression (numeric)
   If FORM = b                         ; convert output to binary
      y = W  ToBinW(Round(y),W)  ToBin(Round(y))
   Else If (FORM=h or FORM=x) {
      if pre
         SetFormat, float, %RegP%E
      else
         SetFormat, float, %RegP%
; ▁▁▁ SetFormat Integer, Hex           ; convert output to hex
      y = Round(y) + 0
   }
   Else {
      W = W=  0.6g  0. . W    ; Set output form, Default = 6 decimal places
      if pre
         SetFormat, float, %RegP%E
      else
         SetFormat, float, %RegP%
; ╞────  SetFormat FLOAT, %W%
      y += 0.0
   }
   if pre
      SetFormat, float, %RegP%E
   else
      SetFormat, float, %RegP%
; ╞────  SetFormat Integer, %FormI%          ; restore original formats
; ╞────  SetFormat FLOAT,   %FormF%
   Return y
}

Eval1(x) {                             ; recursive PREPROCESSING of =, vars, (..) [decimal, no ;]
   Local i, y, y1, y2, y3
                                       ; save function definition f(x) = expr
   If RegExMatch(x, (S)((.))s=s(.), y) {
      f%y1%__X = y2, f%y1%__F = y3
      Return
   }
                                       ; execute leftmost = operator of a = b = ...
   If RegExMatch(x, (S)s=s(.), y) {
      y = x . y1                    ; user vars internally start with x to avoid name conflicts
      Return %y% = Eval1(y2)
   }
                                       ; here no variable to the left of last =
   x = RegExReplace(x,([)’.w]s+[)’])([a-z_A-Z]+),$1«$2»)  ; op - «op»

   x = RegExReplace(x,s+)          ; remove spaces, tabs, newlines

   x = RegExReplace(x,([a-z_A-Z]w)(,'$1'() ; func( - 'func'( to avoid atantan conflicts

   x = RegExReplace(x,([a-z_A-Z]w)([^w'»’]$),%x$1%$2) ; VAR - %xVAR%
   x = RegExReplace(x,(‘[^’])%x[eE]%,$1e) ; in numbers %xe% - e
   x = RegExReplace(x,‘’)          ; no more need for number markers
   Transform x, Deref, %x%             ; dereference all right-hand-side %var%-s

   Loop {                              ; find last innermost (..)
      If RegExMatch(x, (.)(([^()]))(.), y)
         x = y1 . Eval@(y2) . y3      ; replace (x) with value of x
      Else Break
   }

   Return Eval@(x)
}

Eval@(x) {                             ; EVALUATE PRE-PROCESSED EXPRESSIONS [decimal, NO space, vars, (..), ;, =]
   Local i, y, y1, y2, y3, y4

   If x is number                      ; no more operators left
      Return x
                                       ; execute rightmost , operator
   RegExMatch(x, (.)()(.), y)
   IfEqual y2,,  Return Eval@(y1)  Eval@(y3)  
   IfEqual y2,,  Return ((y = Eval@(y1)) =   Eval@(y3)  y)

   StringGetPos i, x, , R            ; execute rightmost  operator
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i))  Eval@(SubStr(x,3+i))
   StringGetPos i, x, &&, R            ; execute rightmost && operator
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) && Eval@(SubStr(x,3+i))
                                       ; execute rightmost =,  operator
   RegExMatch(x, (.)(![])(=)(.), y)
   IfEqual y2,=,  Return Eval@(y1) =  Eval@(y3)
   IfEqual y2,, Return Eval@(y1)  Eval@(y3)
                                       ; execute rightmost ,,=,= operator
   RegExMatch(x, (.)(![])(==)(![])(.), y)
   IfEqual y2,,  Return Eval@(y1)   Eval@(y3)
   IfEqual y2,,  Return Eval@(y1)   Eval@(y3)
   IfEqual y2,=, Return Eval@(y1) = Eval@(y3)
   IfEqual y2,=, Return Eval@(y1) = Eval@(y3)
                                       ; execute rightmost user operator (low precedence)
   RegExMatch(x, i)(.)«(.)»(.), y)
   IfEqual y2,choose,Return Choose(Eval@(y1),Eval@(y3))
   IfEqual y2,Gcd,   Return GCD(   Eval@(y1),Eval@(y3))
   IfEqual y2,Min,   Return (y1=Eval@(y1))  (y3=Eval@(y3))  y1  y3
   IfEqual y2,Max,   Return (y1=Eval@(y1))  (y3=Eval@(y3))  y1  y3

   StringGetPos i, x, , R             ; execute rightmost  operator
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i))  Eval@(SubStr(x,2+i))
   StringGetPos i, x, ^, R             ; execute rightmost ^ operator
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) ^ Eval@(SubStr(x,2+i))
   StringGetPos i, x, &, R             ; execute rightmost & operator
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) & Eval@(SubStr(x,2+i))
                                       ; execute rightmost ,  operator
   RegExMatch(x, (.)()(.), y)
   IfEqual y2,, Return Eval@(y1)  Eval@(y3)
   IfEqual y2,, Return Eval@(y1)  Eval@(y3)
                                       ; execute rightmost +- (not unary) operator
   RegExMatch(x, (.[^!~±¬@])(±¬)(.), y) ; lower precedence ops already handled
   IfEqual y2,±,  Return Eval@(y1) + Eval@(y3)
   IfEqual y2,¬,  Return Eval@(y1) - Eval@(y3)
                                       ; execute rightmost % operator
   RegExMatch(x, (.)()(.), y)
   IfEqual y2,,  Return Eval@(y1)  Eval@(y3)
   IfEqual y2,,  Return Eval@(y1)  Eval@(y3)
   IfEqual y2,,  Return Mod(Eval@(y1),Eval@(y3))
                                       ; execute rightmost power
   StringGetPos i, x, @, R
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i))  Eval@(SubStr(x,2+i))
                                       ; execute rightmost function, unary operator
   If !RegExMatch(x,(.)(!±¬~'(.)')(.), y)
      Return x                         ; no more function (y1   only at multiple unaries --+-)
   IfEqual y2,!,Return Eval@(y1 . !y4) ; unary !
   IfEqual y2,±,Return Eval@(y1 .  y4) ; unary +
   IfEqual y2,¬,Return Eval@(y1 . -y4) ; unary - (they behave like functions)
   IfEqual y2,~,Return Eval@(y1 . ~y4) ; unary ~
   If IsLabel(y3)
      GoTo %y3%                        ; built-in functions are executed last y4 is number
   Return Eval@(y1 . Eval1(RegExReplace(f%y3%__F, f%y3%__X, y4))) ; user defined function
Abs
   Return Eval@(y1 . Abs(y4))
Ceil
   Return Eval@(y1 . Ceil(y4))
Exp
   Return Eval@(y1 . Exp(y4))
Floor
   Return Eval@(y1 . Floor(y4))
Log
   Return Eval@(y1 . Log(y4))
Ln
   Return Eval@(y1 . Ln(y4))
Round
   Return Eval@(y1 . Round(y4))
Sqrt
   Return Eval@(y1 . Sqrt(y4))
Sin
   Return Eval@(y1 . Sin(y4))
Cos
   Return Eval@(y1 . Cos(y4))
Tan
   Return Eval@(y1 . Tan(y4))
ASin
   Return Eval@(y1 . ASin(y4))
ACos
   Return Eval@(y1 . ACos(y4))
ATan
   Return Eval@(y1 . ATan(y4))
Sgn
   Return Eval@(y1 . (y40)) ; Sign of x = (x0)-(x0)
Fib
   Return Eval@(y1 . Fib(y4))
Fac
   Return Eval@(y1 . Fac(y4))
}

ToBin(n) {      ; Binary representation of n. 1st bit is SIGN -8 - 1000, -1 - 1, 0 - 0, 8 - 01000
   Return n=0n=-1  -n  ToBin(n1) . n&1
}
ToBinW(n,W=8) { ; LS W-bits of Binary representation of n
   Loop %W%     ; Recursive (slower) Return W=1  n&1  ToBinW(n1,W-1) . n&1
      b = n&1 . b, n = 1
   Return b
}
FromBin(bits) { ; Number converted from the binary bits string, 1st bit is SIGN
   n = 0
   Loop Parse, bits
      n += n + A_LoopField
   Return n - (SubStr(bits,1,1)StrLen(bits))
}

GCD(a,b) {      ; Euclidean GCD
   Return b=0  Abs(a)  GCD(b, mod(a,b))
}
Choose(n,k) {   ; Binomial coefficient
   p = 1, i = 0, k = k  n-k  k  n-k
   Loop %k%                   ; Recursive (slower) Return k = 0  1  Choose(n-1,k-1)nk
      p = (n-i)(k-i), i+=1  ; FOR INTEGERS p = n-i, p = ++i
   Return Round(p)
}

Fib(n) {        ; n-th Fibonacci number (n  0 OK, iterative to avoid globals)
   a = 0, b = 1
   Loop % abs(n)-1
      c = b, b += a, a = c
   Return n=0  0  n0  n&1  b  -b
}
fac(n) {        ; n!
   Return n2  1  nfac(n-1)
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

