
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  just me
» Original Source:  https://www.autohotkey.com/board/topic/79315-class-ccbutton-colored-caption-on-themed-button-l/
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




;;∙============================================================∙
/*∙======∙COLORIZED CAPTION BUTTONS - HOW TO USE∙============∙
   ▪ Call CCButton.Attach(Hwnd, Color) to register a GUI pushbutton.
     - Hwnd:  HWND of the GUI button control.
     - Color: RGB integer (e.g. 0x008000) or HTML color name (e.g. "GREEN").
     
   ▪ Call CCButton.Detach(Hwnd) to unregister and restore original behavior.
     - Hwnd:  Same HWND used in Attach().

   ▪ All attached buttons are subclassed with themed drawing support.

   ▪ Advantages:
       ✓ Colored captions on themed buttons.
       ✓ No pale borders or incorrect background.
   
   ▪ Disadvantages:
       ✗ Loss of visual animation effects on Vista+.
∙============================================================∙
*/



;;∙===========================================================∙
;;∙======∙EXAMPLE GUI TEST HARNESS∙===========================∙
#NoEnv
SetBatchLines, -1

^t::    ;;∙------∙🔥∙(Ctrl + T) Open GUI example
    Gui, Color, Gray
    Gui, Font, s10 q5, Arial

    Gui, Add, Button, x30  y30  w140, Normal Button Text

    Gui, Add, Button, x80  y80  w140 vBT1 hwndHBTN, Green Button text
        CCButton.Attach(HBTN, 0x008000)

    Gui, Add, Button, x130 y130 w140 vBT2 Default hwndHBTN, Some Blue Text
        CCButton.Attach(HBTN, 0x0000FF)

    Gui, Add, Button, x180 y180 w140 vBT3 hwndHBTN Disabled, Gray when 'Disabled'
        CCButton.Attach(HBTN, 0xFF0000)

    Gui, Font, s8 q5 Italic, Segoe UI
    Gui, Add, Text, y+2 cFF0000, `tRed When Active

    Gui, Show, w350 h250, Color Captioned Buttons
Return

GuiClose:
    Reload
Return
;;∙============================================================∙



;;∙============================================================∙
;;∙======∙CCBUTTON CLASS
Class CCButton {
    Static AttachedBtns := {}
    Static SubclassProc := ""

    ;;∙------∙Prevent class instantiation.
    __New() {
        Return False
    }

    ;;∙------∙Draws the button caption in the requested color.
    ColorCaption(HWND, TxtColor) {
        Static WM_GETFONT := 0x31, BM_GETSTATE := 0xF2
        Static BS_DEFPUSHBUTTON := 0x01, BS_LEFT := 0x0100, BS_RIGHT := 0x0200, BS_CENTER := 0x0300
             , BS_TOP := 0x0400, BS_BOTTOM := 0x0800, BS_VCENTER := 0x0C00, WS_DISABLED := 0x08000000
        Static BST_FOCUS := 0x08, BST_HOT := 0x0200, BST_PUSHED := 0x04
        Static BP_PUSHBUTTON := 1, PBS_NORMAL := 1, PBS_HOT := 2, PBS_PRESSED := 3
             , PBS_DISABLED := 4, PBS_DEFAULTED := 5
        Static DT_LEFT := 0x00, DT_TOP := 0x00, DT_CENTER := 0x01, DT_RIGHT := 0x02
             , DT_VCENTER := 0x04, DT_BOTTOM := 0x08, DT_WORDBREAK := 0x10, DT_SINGLELINE := 0x20
             , DT_NOCLIP := 0x0100, DT_CALCRECT := 0x0400

        SetWinDelay, 0
        SetControlDelay, 0

        HTHEME := This.AttachedBtns[HWND]
        ControlGet, BS, Style, , , ahk_id %HWND%
        If (BS & WS_DISABLED)
            TxtColor := DllCall("UxTheme.dll\GetThemeSysColor", "Ptr", HTHEME, "Int", 17, "UInt")

        HFONT := DllCall("User32.dll\SendMessage", "Ptr", HWND, "Int", WM_GETFONT, "Ptr", 0, "Ptr", 0)
        BST := DllCall("User32.dll\SendMessage", "Ptr", HWND, "Int", BM_GETSTATE, "Ptr", 0, "Ptr", 0)
        STID := (BS & WS_DISABLED) ? PBS_DISABLED
              : (BST & BST_PUSHED) ? PBS_PRESSED
              : (BST & BST_HOT) ? PBS_HOT
              : (BS & BS_DEFPUSHBUTTON) ? PBS_DEFAULTED
              : PBS_NORMAL

        VarSetCapacity(PAINTSTRUCT, (4 * 16) + (2 * (A_PtrSize - 4)), 0)
        HDC := DllCall("User32.dll\BeginPaint", "Ptr", HWND, "Ptr", &PAINTSTRUCT, "Ptr")
        CTLRECT := &PAINTSTRUCT + A_PtrSize + 4
        CH := NumGet(CTLRECT + 0, 12, "Int")

        VarSetCapacity(TXTRECT, 16, 0)
        DllCall("UxTheme.dll\GetThemeBackgroundContentRect", "Ptr", HTHEME, "Ptr", HDC
              , "Int", BP_PUSHBUTTON, "Int", STID, "Ptr", CTLRECT, "Ptr", &TXTRECT)

        TW := NumGet(TXTRECT, 8, "Int") - NumGet(TXTRECT, 0, "Int")
        TH := NumGet(TXTRECT, 12, "Int") - NumGet(TXTRECT, 4, "Int")
        TB := NumGet(TXTRECT, 12, "Int")

        DllCall("UxTheme.dll\DrawThemeParentBackground", "Ptr", HWND, "Ptr", HDC, "Ptr", CTLRECT)
        DllCall("UxTheme.dll\DrawThemeBackground", "Ptr", HTHEME, "Ptr", HDC
              , "Int", BP_PUSHBUTTON, "Int", STID, "Ptr", CTLRECT, "Ptr", 0)

        ControlGetText, BtnText, , ahk_id %HWND%
        DllCall("Gdi32.dll\SelectObject", "Ptr", HDC, "UInt", HFONT)
        DllCall("Gdi32.dll\SetBkMode", "Ptr", HDC, "Int", 1)
        DllCall("Gdi32.dll\SetTextColor", "Ptr", HDC, "UInt", TxtColor)

        DT_ALIGN := (BS & BS_CENTER) = BS_CENTER ? DT_CENTER
                  : (BS & BS_CENTER) = BS_RIGHT ? DT_RIGHT
                  : (BS & BS_CENTER) = BS_LEFT ? DT_LEFT
                  : DT_CENTER
        DT_ALIGN |= DT_WORDBREAK

        VC := BS & BS_VCENTER
        If (VC = BS_VCENTER Or VC = BS_BOTTOM Or VC = 0) {
            VarSetCapacity(RECT, 16, 0)
            NumPut(TW, RECT, 8, "Int")
            NumPut(TH, RECT, 12, "Int")
            DllCall("User32.dll\DrawText", "Ptr", HDC, "Str", BtnText, "Int", -1
                  , "Ptr", &RECT, "UInt", DT_ALIGN | DT_CALCRECT)
            H := NumGet(RECT, 12, "Int")
            If (VC = BS_BOTTOM)
                NumPut(TB - H, TXTRECT, 4, "Int")
            Else If (H < CH)
                NumPut((CH - H) // 2, TXTRECT, 4, "Int")
        }

        DllCall("User32.dll\DrawText", "Ptr", HDC, "Str", BtnText, "Int", -1
              , "Ptr", &TXTRECT, "UInt", DT_ALIGN)

        DllCall("User32.dll\EndPaint", "Ptr", HWND, "Ptr", &PAINTSTRUCT)
        Return True
    }

    ;;∙------∙Register a button control for colorized caption.
    Attach(HWND, Color) {
        Static HTML := {PINK: 0xFFA6C9, FUCHSIA: 0xFF00FF, VIOLET: 0x8F00FF, SCARLET: 0xFF2400
                      , MAROON:  0x800000, RED: 0xFF0000, ORANGE: 0xFFA500, Sunrise: 0xFFAE42
                      , YELLOW: 0xFFFF00, LIME: 0x00FF00, GREEN: 0x008000, OLIVE: 0x808000
                      , NAVY: 0x000080, INDIGO: 0x4B0082, BLUE: 0x0000FF, TEAL: 0x008080
                      , AQUA: 0x00FFFF, SKY: 0x87CEEB, BLACK: 0x000000, SILVER: 0xC0C0C0
                      , GRAY: 0x808080, GREY: 0x808080, WHITE: 0xFFFFFF, BROWN: 0xA52A2A, BEIGE: 0xF5F5DC}

        If (This.SubclassProc = "") {
            If !(This.SubclassProc := RegisterCallback("CCButtonSubclassProc"))
                Return False
        }
        If !DllCall("User32.dll\IsWindow", "Ptr", HWND, "UPtr")
            Return False
        If HTML.HasKey(Color)
            Color := HTML[Color]
        Color := ((Color & 0xFF) << 16) | (Color & 0xFF00) | ((Color & 0xFF0000) >> 16)

        If This.AttachedBtns.HasKey(HWND)
            This.Detach(HWND)

        If !(HTHEME := DllCall("UxTheme.dll\OpenThemeData", "Ptr", HWND, "WStr", "Button", "Ptr"))
            Return False
        If !DllCall("Comctl32.dll\SetWindowSubclass", "Ptr", HWND, "Ptr", This.SubclassProc
                  , "Ptr", HWND, "Ptr", Color) {
            DllCall("UxTheme.dll\CloseThemeData", "Ptr", HTHEME)
            Return False
        }
        This.AttachedBtns[HWND] := HTHEME
        WinSet, Redraw, , ahk_id %HWND%
        Return True
    }

    ;;∙------∙Detach button and restore default style.
    Detach(HWND) {
        If This.AttachedBtns.HasKey(HWND) {
            DllCall("UxTheme.dll\CloseThemeData", "Ptr", This.AttachedBtns[HWND])
            This.AttachedBtns.Remove(HWND, "")
            DllCall("Comctl32.dll\RemoveWindowSubclass", "Ptr", HWND
                  , "Ptr", This.SubclassProc, "Ptr", HWND)
            WinSet, Redraw, , ahk_id %HWND%
            Return True
        }
        Return False
    }
}

;;∙======∙SUBCLASS PROC HANDLER
CCButtonSubclassProc(Hwnd, Message, wParam, lParam, IdSubclass, RefData) {
    Static WM_DESTROY := 0x02, WM_PAINT := 0x0F

    If (Message = WM_PAINT) {
        If CCButton.ColorCaption(Hwnd, RefData)
            Return 0
    }
    If (Message = WM_DESTROY)
        CCButton.Detach(Hwnd)

    Return DllCall("Comctl32.dll\DefSubclassProc", "Ptr", Hwnd
                 , "UInt", Message, "Ptr", wParam, "Ptr", lParam)
}
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
 ;   Reload
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
 ;   Soundbeep, 1700, 100
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

