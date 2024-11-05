
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙----------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙--------------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
» 
∙--------∙Origins∙-------------------------∙
» Author:  
» Source:  
» Simple Gui interface to scribble on.
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "Doodler"    ;;∙------∙Need to also change in "MENU CALLS"
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙🔥 HotKey 🔥∙===========================================∙
; ^t::    ;;∙------∙(Ctrl+T) 
;    Soundbeep, 1100, 100
;;∙============================================================∙

/*
    * Listed by Rainbow Hues with neutral colors listed at the end *
colorMap["Red"] := "FF0000"
colorMap["Maroon"] := "800000"
colorMap["Fuchsia"] := "FF00FF"
colorMap["Purple"] := "800080"
colorMap["Yellow"] := "FFFF00"
colorMap["Olive"] := "808000"
colorMap["Lime"] := "00FF00"
colorMap["Green"] := "008000"
colorMap["Aqua"] := "00FFFF"
colorMap["Teal"] := "008080"
colorMap["Blue"] := "0000FF"
colorMap["Navy"] := "000080"
colorMap["Gray"] := "808080"
colorMap["Silver"] := "C0C0C0"
colorMap["Black"] := "000000"
colorMap["White"] := "FFFFFF"
*/


;;∙-------------------------------------------------------------------------------∙

guiX := "300" 		    ;;∙------∙Gui x-axis position.
guiY := "75" 		    ;;∙------∙Gui y-axis position.
guiW := "600" 		    ;;∙------∙Gui Width.
guiH := "800" 		    ;;∙------∙Gui Height.

guiColor := "Black" 		    ;;∙------∙Gui Color.

penColor := "Aqua" 		    ;;∙------∙Pen Color. (Make orange if invalid color)
penSize := "3" 		    ;;∙------∙Pen Width Size

guiFont := "Arial" 		    ;;∙------∙Font.
guiFontSize := "10" 		    ;;∙------∙Font Size.
guiFontWeight := "400" 	    ;;∙------∙Font Weight.
guiFontQuality := "5" 	    ;;∙------∙Font Render Quality.

buttonX := guiW - 55 	    ;;∙------∙Button x-axis position.
buttonWidth := "45" 	    ;;∙------∙Button Width.
buttonHeight := "20" 	    ;;∙------∙Button Height.

Button1Color := "252525" 	    ;;∙------∙Button 1 Color.
Button1TextColor := "FFFFFF" 	    ;;∙------∙Button 1 Text Color.
Button1Text := "Clear" 	    ;;∙------∙Button 1 Text.

Button2Color := "252525" 	    ;;∙------∙Button 2 Color.
Button2TextColor := "0088D1" 	    ;;∙------∙Button 2 Text Color.
Button2Text := "Reload" 	    ;;∙------∙Button 2 Text.

Button3Color := "252525" 	    ;;∙------∙Button 3 Color.
Button3TextColor := "FF0000" 	    ;;∙------∙Button 3 Text Color.
Button3Text := "Exit" 	    ;;∙------∙Button 3 Text.

;;∙-------------------------------------------------------------------------------∙

Gui, +AlwaysOnTop -Caption -DPIScale +ToolWindow +Border
Gui, Color, %guiColor%
Gui, Add, Pic, x0 y0 w%guiW% h%guiH% vBackDrop

Gui, Font, s%guiFontSize% w%guiFontWeight% q%guiFontQuality%, %guiFont%
Gui, Add, Progress, x%buttonX% y10 w%buttonWidth% h%buttonHeight% Disabled Background%Button1Color%
Gui, Add, Text, xp yp wp hp 0x201 c%Button1TextColor% gClearScreen 0x00800000 BackgroundTrans, %Button1Text%
;;∙------∙
Gui, Add, Progress, x%buttonX% y+5 w%buttonWidth% h%buttonHeight% Disabled Background%Button2Color%
Gui, Add, Text, xp yp wp hp 0x201 c%Button2TextColor% gReload 0x00800000 BackgroundTrans, %Button2Text%
;;∙------∙
Gui, Add, Progress, x%buttonX% y+5 w%buttonWidth% h%buttonHeight% Disabled Background%Button3Color%
Gui, Add, Text, xp yp wp hp 0x201 c%Button3TextColor% gExit 0x00800000 BackgroundTrans, %Button3Text%

Gui, Show, x%guiX% y%guiY% w%guiW% h%guiH%, Doodler

OnMessage(0x200, "WM_MOUSEMOVE")
OnMessage(0x201, "WM_LBUTTONDOWN")
OnMessage(0x202, "WM_LBUTTONUP")

isDrawing := false
prevX := 0
prevY := 0

WM_LBUTTONDOWN() {
    global isDrawing, prevX, prevY
    MouseGetPos, , , , ControlUnderMouse
    if (ControlUnderMouse = "Static1") {
        isDrawing := true
        MouseGetPos, prevX, prevY
    }
}

WM_LBUTTONUP() {
    global isDrawing
    isDrawing := false
}

WM_MOUSEMOVE() {
    global isDrawing, prevX, prevY, penColor, penSize
    if !isDrawing
        return
        MouseGetPos, currX, currY, , ControlUnderMouse
    if (ControlUnderMouse != "Static1")
        return
    if (currX != prevX || currY != prevY) {
        GuiControlGet, hWnd, hwnd, BackDrop
        hdc := DllCall("GetDC", "UInt", hWnd)
        ColPen := ConvertColor(penColor)
        pen := DllCall("Gdi32.dll\CreatePen", "Int", 0, "Int", penSize, "UInt", ColPen)
        oldPen := DllCall("Gdi32.dll\SelectObject", "UInt", hdc, "UInt", pen)
            DllCall("Gdi32.dll\MoveToEx", "UInt", hdc, "Int", prevX, "Int", prevY, "UInt", 0)
            DllCall("Gdi32.dll\LineTo", "UInt", hdc, "Int", currX, "Int", currY)
        DllCall("Gdi32.dll\SelectObject", "UInt", hdc, "UInt", oldPen)
        DllCall("Gdi32.dll\DeleteObject", "UInt", pen)
        DllCall("ReleaseDC", "UInt", hWnd, "UInt", hdc)
        prevX := currX
        prevY := currY
    }
}
Return

;;∙-------------------------------------------------------------------------------∙
ConvertColor(color) {
    colorMap := {}
colorMap["Red"] := "FF0000"
colorMap["Maroon"] := "800000"
colorMap["Fuchsia"] := "FF00FF"
colorMap["Purple"] := "800080"
colorMap["Yellow"] := "FFFF00"
colorMap["Olive"] := "808000"
colorMap["Lime"] := "00FF00"
colorMap["Green"] := "008000"
colorMap["Aqua"] := "00FFFF"
colorMap["Teal"] := "008080"
colorMap["Blue"] := "0000FF"
colorMap["Navy"] := "000080"
colorMap["Gray"] := "808080"
colorMap["Silver"] := "C0C0C0"
colorMap["Black"] := "000000"
colorMap["White"] := "FFFFFF"

    if (colorMap[color]) {
        rgb := colorMap[color]
    } else if (RegExMatch(color, "^[0-9A-Fa-f]{6}$")) {
        rgb := color
    } else {
        return "0x007fff"
    }
    r := SubStr(rgb, 1, 2)
    g := SubStr(rgb, 3, 2)
    b := SubStr(rgb, 5, 2)
    return "0x" . b . g . r
}
Return

;;∙-------------------------------------------------------------------------------∙
ClearScreen:
    global guiW, guiH, buttonX, buttonWidth, buttonHeight
    Gui, Destroy  ;;∙------∙Remove all existing controls.

    Gui, +AlwaysOnTop -Caption -DPIScale +ToolWindow +Border
    Gui, Color, %guiColor%
    Gui, Add, Pic, x0 y0 w%guiW% h%guiH% vBackDrop

    Gui, Font, s%guiFontSize% w%guiFontWeight% q%guiFontQuality%, %guiFont%
    Gui, Add, Progress, x%buttonX% y10 w%buttonWidth% h%buttonHeight% Disabled Background%Button1Color%
    Gui, Add, Text, xp yp wp hp 0x201 c%Button1TextColor% gClearScreen 0x00800000 BackgroundTrans, %Button1Text%
    ;;∙------∙
    Gui, Add, Progress, x%buttonX% y+5 w%buttonWidth% h%buttonHeight% Disabled Background%Button2Color%
    Gui, Add, Text, xp yp wp hp 0x201 c%Button2TextColor% gReload 0x00800000 BackgroundTrans, %Button2Text%
    ;;∙------∙
    Gui, Add, Progress, x%buttonX% y+5 w%buttonWidth% h%buttonHeight% Disabled Background%Button3Color%
    Gui, Add, Text, xp yp wp hp 0x201 c%Button3TextColor% gExit 0x00800000 BackgroundTrans, %Button3Text%
    
    Gui, Show, x%guiX% y%guiY% w%guiW% h%guiH%, Doodler
    Soundbeep, 1100, 75
Return





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
    Reload:
        Soundbeep, 1200, 75
        Soundbeep, 1400, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
    Exit:
        Soundbeep, 1400, 75
        Soundbeep, 1200, 100
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
;    Soundbeep, 1700, 100
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
Menu, Tray, Icon, comres.dll, 7
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Tray Menu∙============================================∙
TrayMenu:
Menu, Tray, Tip, %ScriptID%    ;;∙------∙Suspends hotkeys then pauses script.
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, %ScriptID%
Menu, Tray, Icon, %ScriptID%, Imageres.dll, 65
Menu, Tray, Default, %ScriptID%    ;;∙------∙Makes Bold.
Menu, Tray, Add
;;∙------∙  ∙--------------------------------∙

;;∙------∙Script∙Options∙---------------∙
Menu, Tray, Add
Menu, Tray, Add, Script·Edit
Menu, Tray, Icon, Script·Edit, shell32.dll, 270
Menu, Tray, Add
Menu, Tray, Add, Script·Reload
Menu, Tray, Icon, Script·Reload, mmcndmgr.dll, 47
Menu, Tray, Add
Menu, Tray, Add, Script·Exit
Menu, Tray, Icon, Script·Exit, shell32.dll, 272
Menu, Tray, Add
Menu, Tray, Add
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙MENU CALLS∙==========================================∙
Doodler:    ;;∙------∙Change as needed to match the 'ScriptID' variable in AutoExe section.
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
;;∙======∙TRAY MENU POSITION FUNTION∙======∙
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
;;∙============================================================∙

;;∙------------------------------------------------------------------------------------------∙
;;∙========================∙SCRIPT END∙=========================∙
;;∙------------------------------------------------------------------------------------------∙

