goto FadeTextEnd ; Allows inclusion at the beginning
; =================================================================================
; | FadeText.ahk by Holle. Special thanks to "just me" for creating function "StrPixel()"
; |
; | Syntax: FadeText(Text , Trans , Speed , FontSize , Width , Height , X , Y , TextColor , BgColor , Boderderless, Font)
; | Defaults:   Trans = 250 , Speed = 5 , Fontsize = 18 , Width = 0 (auto) , Height = 0 (auto) , X = 0 (center) , Y = 0 (center) ,
; |             TextColor = "" (Black) , BgColor = "" (Grey) , Borderless = 0 (show border) , Font = "" (Arial)
; |
; | Tip: If the Width and the Height are specified and FontSize is 0 or "" then the FontSize will scale automatically.
; |
; | Examples:
; | FadeText("This is a Test." , Trans , Speed , FontSize , Width , X , Y , TextColor , BgColor , Boderderless, Font)
; | --> Generates a Fade-Text with default settings (when variables = "" or "0"), or with specified values if variables are defined.
; |
; | FadeText("This is a Test." ,,,,,,,,"Red","White",1)
; | --> Generate a Fade-Text with default "Trans/Speed/FontSize/X/Y/Font", but with red text on the white background without a border.
; |
; | FadeText("This is a Test." , 1300 , 8 , 12 , 300 , 50 , 50 , 50, "FFFFFF" , "Black" , 1, "Courier")
; | --> Generate a Fade-Text with specified values (with white text in Courier on the black background without a border).
; |
; | FadeText("This is a Test." , Trans := 300 , Speed := 8 , FontSize := 12 , Width := 300 , X := 50 , Y := 50 ,
; |                             TextColor := "White" , BgColor := "Black" , Borderless := 1 , Font := "Courier")
; | --> Same as above!
; |
; | FadeText("This is a Test." ,,8, FontSize := 12 , Width , X := 50 , 30 ,, "Red" , "MS Sans Serif")
; | --> Default Trans and Width (if 0 or ""), Speed = 8 , FontSize = 12 , X = 50 , Y = 30 , Background = red , Font = MS Sans Serif
; |
; =================================================================================
FadeText(text , Trans = 500 , Speed = 4 , FontSize = 0 , Width = 0 , Height = 0 , X = 0 , Y = 0, TextColor = "" , BgColor = "" , Borderless = 0 , Font := "Arial")
{  
    Trans := Trans<1?500:Trans>5000?5000:Trans     
    Speed := Speed<1?4:Speed>20?20:Speed   
    Width := Width<1?300:Width>A_ScreenWidth?A_ScreenWidth:Width
    ; calculate number of rows...
    RowNumber := 0
    row := StrSplit(text, "`n")
    MaxFontSize := 1
    if !FontSize && Width && Height ; Scale FontSize to fit on BoxSize
        MaxFontSize := 200 , FontSize := 1
    FontSize := FontSize<1?18:FontSize>200?200:FontSize
    Loop %MaxFontSize% {
        if (MaxFontSize > 1)
            FontSizeBefore := FontSize , RowNumberBefore := RowNumber , FontSize := a_index , RowNumber := 0
        Loop {
            RowNumber ++
            if (StrPixel(row[A_Index], "s" FontSize, Font).width > Width - 32) && InStr(row[A_Index],A_Space) {
                string =
                documented =
                This_Row := row[A_Index]
                Loop , Parse, This_Row, %A_Space%
                {
                    string .= A_Space A_LoopField
                    if (StrPixel(RegExReplace(string,"^\s?") , "s" FontSize, Font).width > Width - 16)
                    {
                        position := InStr(string, A_LoopField ,-1) -1
                        documented .= SubStr(string,1,position) "`n"
                        RowNumber ++
                        string := A_LoopField
                    }
                }
            }
        } Until !row[A_Index] && (A_Index >= row.MaxIndex())
        RowNumber --
        if !RowNumber
            RowNumber := 1  
        TextHeight := StrPixel("H", "s" FontSize, Font).height * RowNumber
        if (MaxFontSize > 1) && (((TextHeight +10) > Height) || (FontSize > 200)) {
            TextHeight := TextHeightBefore?TextHeightBefore:TextHeight
            FontSize := FontSizeBefore
            RowNumber := RowNumberBefore
            break
        }
        else
            TextHeightBefore := TextHeight , RowNumberBefore := RowNumber
    }
    TextHeight := StrPixel("H", "s" FontSize, Font).height * RowNumber
    Height := Height<1?TextHeight:Height>A_ScreenHeight?A_ScreenHeight:Height
    X := X<1?0:X>(A_ScreenWidth-Width-(Width/4 +16))?Round(A_ScreenWidth-Width-(Width/4+16)):X
    Y := Y<1?0:Y>(A_ScreenHeight-Height-(Height/4+16))?Round(A_ScreenHeight-Height-(Height/4+16)):Y
    Parameter := "b zh0 c11 fs" FontSize
	Parameter := Borderless?Parameter:"m2 " . Parameter
    parameter .= Width?" w" Width:
    parameter .= Height?" h" Height " zy" Round((Height/2-TextHeight/2) * (A_ScreenDPI / 96)):
    parameter .= X?" x" X:
    parameter .= Y?" y" Y:
	parameter .= TextColor?" CT" TextColor:
	parameter .= BgColor?" CW" BgColor:
    global FadeTrans := Trans , FadeSpeed := Speed 
    Progress, %Parameter%, %text%,, Fade, %Font%
    SetTimer, Fade, 1
Return
}

StrPixel(Str, FontOptions, FontName) { ; by "just me"
    Gui, StrPixelDummyGUI:Font, %FontOptions%, %FontName%
    Gui, StrPixelDummyGUI:Add, Text, hwndHTX, %Str%
    GuiControlGet, S, StrPixelDummyGUI:Pos, %HTX%
    Gui, StrPixelDummyGUI:Destroy
    result := {width:SW,height:SH}
    Return result
}

Fade:
{
    WinSet, Transparent, %FadeTrans%, Fade
    FadeTrans -= %FadeSpeed%
    if (FadeTrans < 0)
        SetTimer, Fade, off
Return
}

FadeTextEnd:
{
}