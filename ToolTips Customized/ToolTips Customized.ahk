
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙--------∙Origins∙-------------------------∙
» Author:  teadrinker
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?f=76&t=84750#p371706
» 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "ToolTips_Custimized"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
;;∙------------------∙Simple ToolTip Example∙------------------∙
^!t::    ;;∙------∙(Ctrl+ALT+T)∙🔥HotKey🔥
    Soundbeep, 1100, 100
WinGetPos, X, Y,, H, ahk_id %hEdit%

title := "Hello"
text := "This is my custom ToolTip!`nIt will disappear in five seconds."
hToolTip := CustomToolTip(text, 1400, 600, title, 0, , , 0x000011, 0x4A96D9, "Calibri", "s12", true, 5000)
Return
;;∙-------------------------------------------------------------------∙



;;∙------------------∙Simple Gui Example∙-----------------------∙
^!g::    ;;∙------∙(Ctrl+ALT+G)∙🔥HotKey🔥
    Soundbeep, 1100, 100
Gui, Add, Edit, x100 vMyEdit hwndhEdit, Type whatever here...
Gui, Show, x1450 y600 w300 h100, Example GUI
Gui, Add, Button, x100 y+10 gShowTooltip, Show Tooltip    ;;∙------∙Create a button to display the tooltip.
Return

ShowTooltip:
    ;;∙------∙Get the position of the Edit control.
    WinGetPos, X, Y,, H, ahk_id %hEdit%
    ;;∙------∙Display a tooltip near the Edit control.
    text := "`nThis is a tooltip for the Edit box."
    CustomToolTip(text, X + 10, Y + H + 10, "Edit Tooltip", 0, , ,0x00FFFF, 0xFF0000, "Calibri", "s12", true, 7000)
Return

GuiClose:
    ExitApp
Return
;;∙-------------------------------------------------------------------∙




;;∙------------------------------------------------------------------------------------------∙
;;∙------∙CustomToolTip(TextVariable, X , Y, TitleVariable, NonInteractive, CloseButton, BackgroundColor, TextColor, FontName, FontOptions, isBallon, Timeout, MaxWidth)

CustomToolTip( text, x := "", y := ""    ;;∙------∙Tooltip text and position (optional). 
            , title := ""    ;;∙------∙Title text for the tooltip (optional).
            , icon := 0    ;;∙------∙Can be (1-Info), (2-Warning), (3-Error), (>3-hIcon)
            , nonInteractive := false    ;;∙------∙If true, makes the tooltip non-interactive (click-through).
            , closeButton := false    ;;∙------∙If true, adds a close button to the tooltip. 
            , backColor := ""    ;;∙------∙Background color of the tooltip (optional, RGB format). 
            , textColor := 0    ;;∙------∙Text color of the tooltip (optional, RGB format). 
            , fontName := ""    ;;∙------∙Font name for the tooltip text (optional). 
            , fontOptions := ""    ;;∙------∙Font options like size, bold, or italic (as in a GUI). 
            , isBallon := false    ;;∙------∙If true, displays the tooltip in balloon style. 
            , timeout := ""    ;;∙------∙Duration (in ms) before the tooltip disappears (optional).
            , maxWidth := 600)    ;;∙------∙Maximum width of the tooltip in pixels. 

    {static ttStyles := (TTS_NOPREFIX := 2) | (TTS_ALWAYSTIP := 1), TTS_BALLOON := 0x40, TTS_CLOSE := 0x80
            , TTF_TRACK := 0x20, TTF_ABSOLUTE := 0x80
            , TTM_SETMAXTIPWIDTH := 0x418, TTM_TRACKACTIVATE := 0x411, TTM_TRACKPOSITION := 0x412
            , TTM_SETTIPBKCOLOR := 0x413, TTM_SETTIPTEXTCOLOR := 0x414
            , TTM_ADDTOOL        := A_IsUnicode ? 0x432 : 0x404
            , TTM_SETTITLE       := A_IsUnicode ? 0x421 : 0x420
            , TTM_UPDATETIPTEXT  := A_IsUnicode ? 0x439 : 0x40C
            , exStyles := (WS_EX_TOPMOST := 0x00000008) | (WS_EX_COMPOSITED := 0x2000000) | (WS_EX_LAYERED := 0x00080000)
            , WM_SETFONT := 0x30, WM_GETFONT := 0x31
    (nonInteractive && exStyles |= WS_EX_TRANSPARENT := 0x20)
    dhwPrev := A_DetectHiddenWindows
    DetectHiddenWindows, On
    defGuiPrev := A_DefaultGui, lastFoundPrev := WinExist()
    hWnd := DllCall("CreateWindowEx", "UInt", exStyles, "Str", "tooltips_class32", "Str", ""
            , "UInt", ttStyles | TTS_CLOSE * !!CloseButton | TTS_BALLOON * !!isBallon
            , "Int", 0, "Int", 0, "Int", 0, "Int", 0, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Ptr")
    WinExist("ahk_id" . hWnd)
    if (textColor != 0 || backColor != "") {
        DllCall("UxTheme\SetWindowTheme", "Ptr", hWnd, "Ptr", 0, "UShortP", empty := 0)
        ByteSwap := Func("DllCall").Bind("msvcr100\_byteswap_ulong", "UInt")
        SendMessage, TTM_SETTIPBKCOLOR  , ByteSwap.Call(backColor << 8)
        SendMessage, TTM_SETTIPTEXTCOLOR, ByteSwap.Call(textColor << 8)
    }
    if (fontName || fontOptions) {
        Gui, New
        Gui, Font, % fontOptions, % fontName
        Gui, Add, Text, hwndhText
        SendMessage, WM_GETFONT,,,, ahk_id %hText%
        SendMessage, WM_SETFONT, ErrorLevel
        Gui, Destroy
        Gui, %defGuiPrev%: Default
    }
    if (x = "" || y = "")
        DllCall("GetCursorPos", "Int64P", pt)
    (x = "" && x := (pt & 0xFFFFFFFF) + 15), (y = "" && y := (pt >> 32) + 15)
    VarSetCapacity(TOOLINFO, sz := 24 + A_PtrSize*6, 0)
    NumPut(sz, TOOLINFO)
    NumPut(TTF_TRACK | TTF_ABSOLUTE * !isBallon, TOOLINFO, 4)
    NumPut(&text, TOOLINFO, 24 + A_PtrSize*3)
        SendMessage, TTM_SETTITLE      , icon, &title
       SendMessage, TTM_TRACKPOSITION ,     , x | (y << 16)
       SendMessage, TTM_SETMAXTIPWIDTH,     , maxWidth
       SendMessage, TTM_ADDTOOL       ,     , &TOOLINFO
       SendMessage, TTM_UPDATETIPTEXT ,     , &TOOLINFO
       SendMessage, TTM_TRACKACTIVATE , true, &TOOLINFO
    if timeout {
        Timer := Func("DllCall").Bind("DestroyWindow", "Ptr", hWnd)
        SetTimer, % Timer, % "-" . timeout
        }
    WinExist("ahk_id" . lastFoundPrev)
    DetectHiddenWindows, % dhwPrev
    Return hWnd
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
ToolTips_Custimized:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

