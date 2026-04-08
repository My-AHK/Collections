
SetTimer, UpdateCheck, 750


;;∙============================================================∙
;;∙======∙DIRECTIVES∙===================∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force
SendMode, Input
SetBatchLines -1
SetWinDelay 0

;;∙------∙Identifier for tray menu & tooltip.
ScriptID := "Font_View"

;;∙------∙Drag window by clicking anywhere on it.
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")

;;∙------∙Tray Menu.
Menu, Tray, Icon, shell32.dll, 74
Menu, Tray, Tip, %ScriptID%
Menu, Tray, NoStandard
Menu, Tray, Add, Show GUI, ShowGuiFromTray
Menu, Tray, Default, Show GUI
Menu, Tray, Add, Reload Script, ScriptReload
Menu, Tray, Add, Exit Script, ScriptClose


;;∙======∙GUI BUILD∙========================∙
WM_SETFONT := 0x30

;;∙------∙Set default text shown in the input area.
DefaultText := "
(
The quick brown fox jumps over the lazy dog.

a b c d e f g h i j k l m n o p q r s t u v w x y z
A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
0 1 2 3 4 5 6 7 8 9  ! ? # $ % & ( ) { } [ ]
)"

;;∙------∙Gui Creation.
Gui, +AlwaysOnTop -Caption +ToolWindow +Resize
        +E0x02000000 +E0x00080000    ;;∙------∙Double Buffer.
Gui, Color, White
Gui, Font, s10 q5, Arial

;;∙------∙Text input with clear button.
Gui, Add, Text, x10 y10 h25 BackgroundTrans, Text To Preview:
Gui, Font, s8
Gui, Add, Button, x+2 y8 w35 h20 gClearText, Clear
Gui, Font, s10
Gui, Add, Edit, x10 y30 w400 h100 vInputText gUpdatePreview -WantReturn, %DefaultText%

;;∙------∙Title Bar Icon Buttons (Reload, Hide, Close).
Gui Add, Picture, x350 y5 w16 h16 Icon239 gScriptReload vReloadBtn, shell32.dll
Gui Add, Picture, x+2 y5 w20 h20 Icon248 gGuiHide vHideBtn, shell32.dll
Gui Add, Picture, x+2 y5 w16 h16 Icon132 gScriptClose vCloseBtn, shell32.dll

/*∙------∙*Alternative Title Bar Icon Buttons (uncomment to use imageres.dll instead).
Gui Add, Picture, x350 y5 w16 h16 Icon229 gScriptReload vReloadBtn, imageres.dll
Gui Add, Picture, x+2 y5 w20 h20 Icon176 gGuiHide vHideBtn, imageres.dll
Gui Add, Picture, x+2 y5 w16 h16 Icon277 gScriptClose vCloseBtn, imageres.dll
*/

;;∙------∙Font Selection.
Gui, Add, Text, x10 y140 h25 BackgroundTrans, Select Font:
Gui, Add, DropDownList, x10 y160 w250 h200 vSelectedFont gChangeFont, % GetSystemFonts()

;;∙------∙Add Bold & Italic Checkboxes.
Gui, Font, Bold
Gui, Add, Checkbox, x290 y165 h25 BackgroundTrans vBoldFont gChangeFont, Bold
Gui, Font, Norm Italic
Gui, Add, Checkbox, x355 y165 h25 BackgroundTrans vItalicFont gChangeFont, Italic
Gui, Font, Norm

;;∙------∙Preview Label.
Gui, Add, Text, x10 y200 BackgroundTrans, Preview:

;;∙------∙Background Color Dropdown (mapped RGB values).
Gui, Add, Text, x85 y200 BackgroundTrans, BKGD:
Gui, Font, s8
Gui, Add, DropDownList, x+2 y195 w80 h20 r10 vBgColor gChangeBgColor, White|Blue|Red|Green|Yellow|Purple|Orange|Brown|Gray|Silver|DarkBlue|DarkRed|DarkGreen|DarkYellow
Gui, Font, s10

;;∙------∙Text Color Dropdown (mapped RGB values).
Gui, Add, Text, x+5 y200 BackgroundTrans, Text:
Gui, Font, s8
Gui, Add, DropDownList, x+2 y195 w80 h20 r10 vTextColor gChangeTextColor, Black|Blue|Red|Green|Yellow|Purple|Orange|Brown|Gray|DarkBlue|DarkRed|DarkGreen|DarkYellow
Gui, Font, s10

;;∙------∙Font Size Dropdown (mapped Size values).
Gui, Add, Text, x+5 y200 h25 BackgroundTrans, Size:
Gui, Font, s8
Gui, Add, DropDownList, x+2 y195 w50 h200 vFontSize gChangeFont, 8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24
Gui, Font, s10

;;∙------∙Preview Text Control (receives formatted font).
Gui, Font, s12 cBlack
Gui, Add, Text, x10 y220 w400 h130 vPreviewBox +0x800000
GuiControlGet, PreviewBoxHwnd, Hwnd, PreviewBox

;;∙------∙Create Default Font (Arial, Size 12, Regular) as fallback.
hFontDefault := CreateFont("Arial", 12, 400, false)

;;∙------∙Apply Default Font To Preview Box.
SendMessage, WM_SETFONT, hFontDefault, 1,, ahk_id %PreviewBoxHwnd%

;;∙------∙Get original control positions for resize calculations.
Gui, +LastFound
WinGetPos, GuiX, GuiY, GuiWidth, GuiHeight
OriginalGuiWidth := GuiWidth
OriginalGuiHeight := GuiHeight

;;∙------∙Store Original Window Dimensions For Resize Calculations.
OriginalEditW := 400
OriginalEditH := 100
OriginalPreviewW := 400
OriginalPreviewH := 130
OriginalEditX := 10
OriginalEditY := 30
OriginalPreviewX := 10
OriginalPreviewY := 220



;;∙------∙Display GUI At Startup.
Gui, Show, x270 w420 h360, Font View
GuiControl, ChooseString, SelectedFont, Arial    ;;∙------∙Select Arial in the font dropdown.
GuiControl, ChooseString, FontSize, 12    ;;∙------∙Select 12 in the size dropdown.
GuiControl, ChooseString, TextColor, Black    ;;∙------∙Select Black as default color.
GuiControl, ChooseString, BgColor, White    ;;∙------∙Select White as default background color.
GuiControl, Focus, SelectedFont

;;∙------∙Render Preview With Default Text.
Gosub, UpdatePreview
Return

;;∙======∙GUI RESIZE HANDLER∙===============∙
GuiSize:
if (A_EventInfo = 1)    ;;∙------∙If Window Minimized, Skip Resize Logic.
    return

;;∙------∙Get New Window Dimensions.
NewWidth := A_GuiWidth
NewHeight := A_GuiHeight

;;∙------∙Enforce Minimum Size (buttons overlap below this).
MinWidth := 420
MinHeight := 360
if (NewWidth < MinWidth) {
    NewWidth := MinWidth
    Gui, Show, w%NewWidth%
}
if (NewHeight < MinHeight) {
    NewHeight := MinHeight
    Gui, Show, h%NewHeight%
}

;;∙------∙Reposition Icon Buttons Along Right Edge (10px from right / right-to-left layout).
ButtonSpacing := 2    ;;∙------∙Spacing Between Buttons (Reload/Hide/Close).
ButtonX := NewWidth - 10    ;;∙------∙Start 10px From Right Edge.

;;∙------∙Close Button (rightmost, 16px wide).
CloseBtnX := ButtonX - 16
GuiControl, Move, CloseBtn, x%CloseBtnX% y5

;;∙------∙Hide Button (20px wide, spaced 2px from close button).
HideBtnX := CloseBtnX - ButtonSpacing - 20
GuiControl, Move, HideBtn, x%HideBtnX% y5

;;∙------∙Reload Button (16px wide, spaced 2px from hide button).
ReloadBtnX := HideBtnX - ButtonSpacing - 16    ;;∙------∙16 is width of reload button.
GuiControl, Move, ReloadBtn, x%ReloadBtnX% y5

;;∙------∙Resize Edit control to fill width (10px margins left and right, fixed height).
EditNewWidth := NewWidth - 20
EditNewHeight := 100
GuiControl, Move, InputText, w%EditNewWidth% h%EditNewHeight%

;;∙------∙Resize Preview box to fill remaining space (10px margins right and bottom).
PreviewNewWidth := NewWidth - 20
PreviewNewHeight := NewHeight - 230    ;;∙------∙230 Accounts For Y-axis Position (220) + 10px bottom margin.
GuiControl, Move, PreviewBox, w%PreviewNewWidth% h%PreviewNewHeight%

;;∙------∙Refresh Preview Text & Font To Ensure Proper Rendering After Resize.
Gosub, UpdatePreview
Gosub, ChangeFont
Return


;;∙======∙GUI EVENT SUBROUTINES∙===========∙
;;∙------∙Clear All Text From Input Box.
ClearText:
    GuiControl,, InputText, 
    Gosub, UpdatePreview
Return

;;∙------------------------------------------------∙
;;∙------∙Change Background Color Of Entire GUI.
ChangeBgColor:
    GuiControlGet, BgColor,, BgColor
    
;;∙------∙Map Color Names To Rgb Hex Values.
if (BgColor = "White")
        ColorValue := "FFFFFF"
    else if (BgColor = "Blue")
        ColorValue := "0000FF"
    else if (BgColor = "Red")
        ColorValue := "FF0000"
    else if (BgColor = "Green")
        ColorValue := "00FF00"
    else if (BgColor = "Yellow")
        ColorValue := "FFFF00"
    else if (BgColor = "Purple")
        ColorValue := "7F00FF"
    else if (BgColor = "Orange")
        ColorValue := "FF7A00"
    else if (BgColor = "Brown")
        ColorValue := "603810"
    else if (BgColor = "Gray")
        ColorValue := "7A7A7A"
    else if (BgColor = "Silver")
        ColorValue := "C0C0C0"
    else if (BgColor = "DarkBlue")
        ColorValue := "00007A"
    else if (BgColor = "DarkRed")
        ColorValue := "7A0000"
    else if (BgColor = "DarkGreen")
        ColorValue := "007A00"
    else if (BgColor = "DarkYellow")
        ColorValue := "7A7A00"
    else
        ColorValue := "White"  ;;∙------∙Default To White.

    
    ;;∙------∙Apply Background Color To Gui.
    Gui, Color, %ColorValue%
    
    ;;∙------∙Refresh All Controls To Show New Background.
    GuiControl, +BackgroundTrans, PreviewBox
    GuiControl, +BackgroundTrans, InputText
Return

;;∙------------------------------------------------∙
;;∙------∙Change Text Color Of Preview Box.
ChangeTextColor:
    GuiControlGet, TextColor,, TextColor
    
    ;;∙------∙Map Color Names To Rgb Hex Values.
    if (TextColor = "Black")
        ColorValue := "000000"
    else if (TextColor = "Blue")
        ColorValue := "0000FF"
    else if (TextColor = "Red")
        ColorValue := "FF0000"
    else if (TextColor = "Green")
        ColorValue := "00FF00"
    else if (TextColor = "Yellow")
        ColorValue := "FFFF00"
    else if (TextColor = "Purple")
        ColorValue := "7F00FF"
    else if (TextColor = "Orange")
        ColorValue := "FF7A00"
    else if (TextColor = "Brown")
        ColorValue := "603810"
    else if (TextColor = "Gray")
        ColorValue := "7A7A7A"
    else if (TextColor = "DarkBlue")
        ColorValue := "00007A"
    else if (TextColor = "DarkRed")
        ColorValue := "7A0000"
    else if (TextColor = "DarkGreen")
        ColorValue := "007A00"
    else if (TextColor = "DarkYellow")
        ColorValue := "7A7A00"
    else
        ColorValue := "Black"  ;;∙------∙Default To Black.
    
    ;;∙------∙Apply Text Color To Preview Box.
    Gui, Font, c%ColorValue%
    GuiControl, Font, PreviewBox
    
    ;;∙------∙Refresh Preview To Show New Color.
    Gosub, UpdatePreview
Return

;;∙======∙CORE FUNCTIONS∙==================∙
;;∙------∙Create Gdi Font With Specified Name, Size, Weight, & Italic Style.
;;∙------∙Weight: 400 = Regular, 700 = Bold. Returns A Handle To The Font.
CreateFont(FontName, FontSize, FontWeight := 400, Italic := false) {
    hDC := DllCall("GetDC", "Ptr", 0, "Ptr")
    LOGPIXELSY := 90
    PixelsPerInchY := DllCall("GetDeviceCaps", "Ptr", hDC, "Int", LOGPIXELSY, "Int")
    DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)

    ;;∙------∙Convert Point Size To Pixel Height (negative = use character height).
    FontHeight := -((FontSize * PixelsPerInchY + 72/2) // 72)

    ;;∙------∙Set Italic Flag (0 = false, 1 = true).
    ItalicFlag := Italic ? 1 : 0

    hFont := DllCall("CreateFont", "Int", FontHeight, "Int", 0, "Int", 0, "Int", 0, "Int", FontWeight
        , "Int", ItalicFlag, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "Int", 0
        , "Str", FontName, "Ptr")

    return hFont
}
Return

;;∙------------------------------------------------∙
;;∙------∙Retrieve All System Fonts From Windows Registry & Return As A Pipe-separated List.
GetSystemFonts() {
    fonts := ""

    ;;∙------∙Loop Through Hklm Registry For System-wide Installed Fonts.
    Loop, Reg, HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts
    {
        ;;∙------∙Extract Font Name By Removing Truetype/opentype Suffixes & File Extensions.
        fontName := A_LoopRegName
        fontName := RegExReplace(fontName, " \((TrueType|OpenType|Regular|Bold|Italic|Bold Italic|Light|DemiBold|Medium)\)")
        fontName := RegExReplace(fontName, "\.(ttf|otf|ttc)$", "")

        ;;∙------∙Add To List If Not Already Present.
        if (fontName != "" && !InStr(fonts, fontName "|")) {
            fonts .= fontName "|"
        }
    }

    ;;∙------∙Loop Through HKCU For User-installed Fonts.
    Loop, Reg, HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts
    {
        fontName := A_LoopRegName
        fontName := RegExReplace(fontName, " \((TrueType|OpenType|Regular|Bold|Italic|Bold Italic|Light|DemiBold|Medium)\)")
        fontName := RegExReplace(fontName, "\.(ttf|otf|ttc)$", "")

        if (fontName != "" && !InStr(fonts, fontName "|")) {
            fonts .= fontName "|"
        }
    }

    ;;∙------∙Remove Trailing Pipe.
    fonts := RTrim(fonts, "|")

    ;;∙------∙Sort Fonts Alphabetically.
    Sort, fonts, D|

    ;;∙------∙Ensure Arial Appears First In List (most common default).
    if InStr(fonts, "Arial") {
        fonts := "Arial|" . StrReplace(fonts, "Arial|", "")
        fonts := StrReplace(fonts, "||", "|")
    } else {
        fonts := "Arial|" . fonts
    }

    ;;∙------∙Fallback list in case registry reading fails (should never happen).
    if (fonts = "" || fonts = "Arial|") {
        fonts := "Arial|Times New Roman|Courier New|Verdana|Tahoma|Calibri|Cambria|Comic Sans MS|Georgia|Impact|Lucida Console|Segoe UI|Trebuchet MS"
    }

    return fonts
}
Return

;;∙------------------------------------------------∙
;;∙------∙Update Preview Text When Input Content Changes.
UpdatePreview:
    GuiControlGet, InputText,, InputText
    ;;∙------∙Escape Ampersands (&) By Doubling For Display (otherwise they become underline shortcuts).
    StringReplace, DisplayText, InputText, &, &&, All
    ;;∙------∙Add Two Spaces To Start Of Each Line For Visual Indentation.
    DisplayText := RegExReplace(DisplayText, "`am)^", "  ")
    GuiControl,, PreviewBox, % DisplayText
Return

;;∙------------------------------------------------∙
;;∙------∙Change Font When Dropdown Selection, Checkboxes, Or Size Changes.
ChangeFont:
    GuiControlGet, SelectedFont,, SelectedFont

    ;;∙------∙Fallback To Arial If No Font Selected (occurs at startup).
    if (SelectedFont = "") {
        SelectedFont := "Arial"
    }

    GuiControlGet, BoldFont,, BoldFont
    GuiControlGet, ItalicFont,, ItalicFont
    GuiControlGet, FontSize,, FontSize

    ;;∙------∙Fallback To Size 12 If No Size Selected.
    if (FontSize = "") {
        FontSize := 12
    }

    ;;∙------∙Delete Old Font Handle To Prevent Memory Leaks.
    if (hCurrentFont)
        DllCall("DeleteObject", "Ptr", hCurrentFont)

    ;;∙------∙Set Font Weight (700 = bold, 400 = regular).
    FontWeight := BoldFont ? 700 : 400

    ;;∙------∙Create New Font With Selected Font Name, Size, & Style.
    hCurrentFont := CreateFont(SelectedFont, FontSize, FontWeight, ItalicFont)

    ;;∙------∙Apply New Font To Preview Box.
    SendMessage, WM_SETFONT, hCurrentFont, 1,, ahk_id %PreviewBoxHwnd%

    ;;∙------∙Refresh Preview Box To Render With New Font.
    GuiControlGet, InputText,, InputText
    StringReplace, DisplayText, InputText, &, &&, All
    DisplayText := RegExReplace(DisplayText, "`am)^", "  ")
    GuiControl,, PreviewBox, % DisplayText
Return

;;∙======∙TRAY MENU POSITIONING∙==========∙
;;∙------∙Menu Position.
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20
Return

;;∙------∙Position Function.
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

;;∙======∙CLEANUP & EXIT∙===================∙
;;∙------∙Show GUI From Tray Menu.
ShowGuiFromTray:
    Gui, Show
Return

;;∙------∙Reload Script (tray menu & button).
ScriptReload:
    Reload
Return

;;∙------∙Hide GUI Window.
GuiHide:
    Gui, Hide
Return

;;∙------------------------------------------------∙
;;∙------∙Clean Up Font Handles & Exit Script.
GuiClose:
ScriptClose:
    if (hFontDefault)
        DllCall("DeleteObject", "Ptr", hFontDefault)
    if (hCurrentFont)
        DllCall("DeleteObject", "Ptr", hCurrentFont)
    ExitApp
Return

;;∙------------------------------------------------∙
;;∙------∙Allow Dragging Window By Clicking Anywhere On Its Surface.
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}
Return
;;∙============================================================∙




;;∙======∙SCRIPT EDIT & EXIT∙=================∙
 ;;∙------∙EDIT∙---------------------------∙
Script·Edit:    ;;∙------∙Menu Call.
    Edit
Return

 ;;∙------∙EXIT∙----------------------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        Soundbeep, 1000, 300
    ExitApp
Return

;;∙======∙SCRIPT UPDATE∙====================∙
UpdateCheck:    ;;∙------Check if script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload

;;∙------------------------------------------------------------------------------------------∙
;;∙========================∙SCRIPT END∙=========================∙
;;∙------------------------------------------------------------------------------------------∙
