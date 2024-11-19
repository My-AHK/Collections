
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙--------∙Origins∙-------------------------∙
» Author:  jay lee
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?f=6&t=117003&p=521577&hilit=Scrollbar+Color#p521577
» 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TEMPLATE"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
#Include Gdip_All.ahk
Gdip_Startup()

;;∙------------∙Settings∙------------∙
;;∙------∙Drop-down list of color selections and their color mappings.
colors := "Red|Orange|Yellow|Green|Cyan|Blue|Indigo|Violet|Magenta|Pink|Brown|Gray"
colorMap := {"Red": "ff0000", "Orange": "ff8000", "Yellow": "ffff00", "Green": "00ff00", "Cyan": "00ffff", "Blue": "0000ff", "Indigo": "4b0082", "Violet": "9400d3", "Magenta": "ff00ff", "Pink": "ffc0cb", "Brown": "a52a2a", "Gray": "808080"}

guiColor := "011167"
guiW := "200" , guiH := "90"    ;;∙------∙Gui width and height.
guiWX1 := guiW - 190    ;;∙------∙Drop-down x-axis position.
guiWX2 := guiW - 60    ;;∙------∙Button x-axis position.

global maxImageWidth := "3000"    ;;∙------∙In pixels, dynamically calculates aspect ratio (width/height) of original image.

;;∙------------------------------------∙
^t::    ;;∙------∙🔥(Ctrl+T)🔥
    Soundbeep, 1100, 100
    Clipboard := ""
    Send, ^c    ;;∙------∙Copy selected file path.
    ClipWait, 2
        if (Clipboard = "")    ;;∙------∙Restart if no file was copied.
        {
            MsgBox,,, No file was copied`nto the clipboard!!,3
            Reload
        }

    ;;∙------∙Check if the copied item is a valid image file.
    inputImage := Clipboard
    if !RegExMatch(inputImage, "\.(bmp|gif|jpg|png|tif)$", match)    ;;∙------∙Regex to check if the copied item is a valid image file format.
    {
        MsgBox,,, The selected file is not an image.`n`tPlease try again.,3
        Reload
    }

Gui, Color, %guiColor%
Gui, Add, Text, x0 y10 w200 cABCDEF Center, Select a Color Hue:
Gui, Add, DropDownList, x%guiWX1% vSelectedColor gSetColor w180, %colors%
Gui, Add, Button, x%guiWX2% w50 Center Default gSaveSelection, OK
Gui, Show, w%guiW% h%guiH%, Select Color Hue
Return

SetColor:
Gui, Submit, NoHide
Return

SaveSelection:
Gui, Submit
colorHue := colorMap[SelectedColor]    ;;∙------∙Set colorHue based on selection.
colorName := SelectedColor    ;;∙------∙Store the color name for appending to the file name.
Gui, Destroy

inputcolor := "0x"colorHue
pBitmap := Gdip_CreateBitmapFromFile(inputImage)    ;;∙------∙Input Image.
converttocolor(inputcolor, pBitmap)
Gdip_SaveBitmapToFile(pBitmap, colorName "-Hue.png", 100)    ;;∙------∙Output Image with color hue name appended.
converttocolor(inputcolor, pbitmap) {
    SplitRGBColor(inputcolor, R, G, B)
    R2 := round(((R / 255) + 1) * 100) / 100
    G2 := round(((G / 255) + 1) * 100) / 100
    B2 := round(((B / 255) + 1) * 100) / 100
    Matrix=
    (
    %R2%   	|0		|0		|0		|0
    0		|%G2%  	|0		|0		|0
    0		|0		|%b2%  	|0		|0
    0		|0		|0		|1		|0
    0   	|0  	|0  	|0		|1
    )

;;∙------∙Dynamically calculate aspect ratio of the original image.
G := Gdip_GraphicsFromImage(pbitmap)
originalWidth := Gdip_GetImageWidth(pbitmap)
originalHeight := Gdip_GetImageHeight(pbitmap)
    aspectRatio := originalWidth / originalHeight
    newWidth := maxImageWidth
    newHeight := Round(newWidth / aspectRatio)
GDIP_drawimage(G, pbitmap, 0, 0, newWidth, newHeight, 0, 0, newWidth, newHeight, matrix)
Gdip_DeleteGraphics(G)

/*∙------∙* Use Aspect Ration Calculation Above Instead!! *
    G := Gdip_GraphicsFromImage(pbitmap)
    ;;∙------∙GDIP_drawimage(G,pbitmap,0,0,980,980,0,0,980,980,matrix)    ;;∙------∙Original image output boundaries.
    GDIP_drawimage(G, pbitmap, 0, 0, 1920, 1080, 0, 0, 1920, 1080, matrix)    ;;∙------∙1920x1080 Width & Height image output boundaries.
    Gdip_DeleteGraphics(G)
*/

}
;;∙------∙Reload    ;;∙------∙DELETE???
SplitRGBColor(RGBColor, ByRef Red, ByRef Green, ByRef Blue)
{
    Red := RGBColor >> 16 & 0xFF
    Green := RGBColor >> 8 & 0xFF
    Blue := RGBColor & 0xFF
}
Return
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
        SoundBeep, 1100, 75
        Soundbeep, 1200, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        Soundbeep, 1100, 75
        Soundbeep, 1000, 100
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
#MaxThreadsPerHotkey 3
#NoEnv
;;∙------∙#NoTrayIcon
#Persistent
#SingleInstance, Force
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.
SetBatchLines -1
SetTimer, UpdateCheck, 500
SetTitleMatchMode 2
SetWinDelay 0
Menu, Tray, Icon, imageres.dll, 3
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

