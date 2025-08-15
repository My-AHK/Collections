
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  Rseding91
» Original Source:  https://www.autohotkey.com/board/topic/102673-function-add-tooltiptool-tip-s-to-any-gui-control/
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
;;∙============================================================∙
;;∙------∙EXAMPLE 1∙------∙Basic tool tips:
F1::    ;;∙------∙🔥∙
Gui, +AlwaysOnTop
Gui 1: Add, Button, w180 HwndButton1Hwnd gButton1, Button 1
    AddToolTip(Button1Hwnd, "Tool tip for button #1.")
Gui 1: Add, Button, w180 HwndButton2Hwnd gButton2, Button 2
    AddToolTip(Button2Hwnd, "Tool tip #2.")
Gui 1: Add, Radio, HwndRadio1Hwnd gRadio1, Radio 1
    AddToolTip(Radio1Hwnd, "Radio 1.")
Gui 1: Add, Radio, HwndRadio2Hwnd gRadio2, Radio 2
    AddToolTip(Radio2Hwnd, "Radio 2 with a`nmulti-line tool tip.")

Gui 1: Show, w300, Basic tool tips
Return


;;∙------∙EXAMPLE 2∙------∙Modify tooltip after delay with countdown:
F2::
    Gui 2: Destroy
    Countdown := 10

    Gui 2: Add, Text, w270 vCountdownLabel, Tooltip will modify in %Countdown% seconds.
    Gui 2: Add, Button, w180 HwndButton1Hwnd gButton1, Hover me before and after
    AddToolTip(Button1Hwnd, "Original tooltip.")
    Gui 2: +AlwaysOnTop
    Gui 2: Show, w300, Modifying tooltip with countdown

    SetTimer, UpdateCountdown, 1000
Return

UpdateCountdown:
    Countdown--
    GuiControl, 2:, CountdownLabel, Tooltip will modify in %Countdown% seconds.
    if (Countdown <= 0)
    {
        SetTimer, UpdateCountdown, Off
        AddToolTip(Button1Hwnd, "Modified tooltip after countdown!", 1)
        GuiControl, 2:, CountdownLabel, Tooltip modified!
    }
Return


;;∙------∙EXAMPLE 3∙------∙Removing tool tips:
F3::    ;;∙------∙🔥∙
Gui 3: Add, Text, w180, Click a button/radio.
Gui 3: Add, Button, w180 HwndButton1Hwnd gButton1, Button 1
        AddToolTip(Button1Hwnd, "Tool tip for button #1.")
Gui 3: Add, Button, w180 HwndButton2Hwnd gButton2, Button 2
    AddToolTip(Button2Hwnd, "Tool tip #2.")
Gui 3: Add, Radio, HwndRadio1Hwnd gRadio1, Radio 1
    AddToolTip(Radio1Hwnd, "Radio 1.")
Gui 3: Add, Radio, HwndRadio2Hwnd gRadio2, Radio 2
    AddToolTip(Radio2Hwnd, "Radio 2 with a`nmulti-line tool tip.")
Gui 3: Add, Button, w180 HwndButton3Hwnd gButton3, Remove all tool tips
    AddToolTip(Button3Hwnd, "Click this to remove all tool tips from this GUI.")

Gui 3: +AlwaysOnTop
Gui 3: Show, w300, Removing tool tips
Return


;;∙------∙EXAMPLE 4∙------∙Add, Modify, and Remove tooltips with countdown and auto-removal:
F4::    ;;∙------∙🔥∙
Gui 4: Destroy
Countdown := 10

Gui 4: Add, Text, w270 vCountdownLabel, Tooltips will update in %Countdown% seconds.

Gui 4: Add, Button, w180 HwndButton1Hwnd gButton1, Button 1
    AddToolTip(Button1Hwnd, "Original tooltip for Button 1.")
Gui 4: Add, Button, w180 HwndButton2Hwnd gButton2, Button 2
    AddToolTip(Button2Hwnd, "Original tooltip for Button 2.")
Gui 4: Add, Radio, HwndRadio1Hwnd gRadio1, Radio 1
    AddToolTip(Radio1Hwnd, "Radio 1 tooltip.")
Gui 4: Add, Radio, HwndRadio2Hwnd gRadio2, Radio 2
    AddToolTip(Radio2Hwnd, "Multi-line`ntooltip for Radio 2.")
Gui 4: Add, Button, w180 HwndButton3Hwnd gButton3, Remove all tool tips
    AddToolTip(Button3Hwnd, "Click to remove all tooltips from this GUI.")

Gui 4: +AlwaysOnTop
Gui 4: Show, w300, Add / Modify / Remove Tooltips
    SetTimer, UpdateCountdownLabel, 1000
Return

UpdateCountdownLabel:
    Countdown--
    GuiControl, 4:, CountdownLabel, Tooltips will update in %Countdown% seconds.
    if (Countdown <= 0)
    {
        SetTimer, UpdateCountdownLabel, Off
        AddToolTip(Button1Hwnd, "Modified tooltip for Button 1!", 1)
        GuiControl, 4:, CountdownLabel, Tooltip for Button 1 modified. Updating Button 2 next...
        SetTimer, ModifyButton2Tooltip, -3000
    }
Return

ModifyButton2Tooltip:
    AddToolTip(Button2Hwnd, "Updated tooltip for Button 2!", 1)
    GuiControl, 4:, CountdownLabel, Tooltip for Button 2 modified. It will be removed in 5 sec...
    SetTimer, RemoveButton2Tooltip, -5000
Return

RemoveButton2Tooltip:
    AddToolTip(Button2Hwnd, "", -1)
    GuiControl, 4:, CountdownLabel, Tooltip for Button 2 removed.
Return


;;∙============∙BUTTONS/RADIOS∙============∙
Button1:
    MsgBox, You clicked Button 1.
Return

Button2:
    MsgBox, You clicked Button 2.
Return

Button3:
    Gui, +LastFound
    GuiHwnd := WinExist()
    AddToolTip(GuiHwnd, "Remove All", -1)
    MsgBox, Tooltips removed!
Return

Radio1:
    MsgBox, Radio 1 selected.
Return

Radio2:
    MsgBox, Radio 2 selected.
Return

;;∙============∙FUNCTIONS∙=================∙
AddToolTip(_CtrlHwnd, _TipText, _Modify = 0)
{
    Static TTHwnds, GuiHwnds, Ptr
    , LastGuiHwnd
    , LastTTHwnd
    , TTM_DELTOOLA := 1029
    , TTM_DELTOOLW := 1075
    , TTM_ADDTOOLA := 1028
    , TTM_ADDTOOLW := 1074
    , TTM_UPDATETIPTEXTA := 1036
    , TTM_UPDATETIPTEXTW := 1081
    , TTM_SETMAXTIPWIDTH := 1048
    , WS_POPUP := 0x80000000
    , BS_AUTOCHECKBOX = 0x3
    , CW_USEDEFAULT := 0x80000000

    Ptr := A_PtrSize ? "Ptr" : "UInt"

    If (_TipText = "Destroy" Or _TipText = "Remove All" And _Modify = -1)
    {
        Loop, Parse, GuiHwnds, |
            If (A_LoopField = _CtrlHwnd)
            {
                TTHwnd := A_Index
                , TTExists := True
                Loop, Parse, TTHwnds, |
                    If (A_Index = TTHwnd)
                        TTHwnd := A_LoopField
            }
        
        If (TTExists)
        {
            If (_TipText = "Remove All")
            {
                WinGet, ChildHwnds, ControlListHwnd, ahk_id %_CtrlHwnd%
            
                Loop, Parse, ChildHwnds, `n
                    AddToolTip(A_LoopField, "", _Modify)
                
                DllCall("DestroyWindow", Ptr, TTHwnd)
            }

            GuiHwnd := _CtrlHwnd
            GoSub, RemoveCachedHwnd
        }
        return
    }

    If (!GuiHwnd := DllCall("GetParent", Ptr, _CtrlHwnd, Ptr))
        return "Invalid control Hwnd: """ _CtrlHwnd """. No parent GUI Hwnd found for control."

    If (GuiHwnd = LastGuiHwnd)
        TTHwnd := LastTTHwnd
    Else
    {
        Loop, Parse, GuiHwnds, |
            If (A_LoopField = GuiHwnd)
            {
                TTHwnd := A_Index
                Loop, Parse, TTHwnds, |
                    If (A_Index = TTHwnd)
                        TTHwnd := A_LoopField
            }
    }

    If (TTHwnd And GuiHwnd != DllCall("GetParent", Ptr, TTHwnd, Ptr))
    {
        GoSub, RemoveCachedHwnd
        TTHwnd := ""
    }

    If (!TTHwnd)
    {
        TTHwnd := DllCall("CreateWindowEx"
                        , "UInt", 0		    ;;∙------∙dwExStyle
                        , "Str", "TOOLTIPS_CLASS32"	    ;;∙------∙lpClassName
                        , "UInt", 0		    ;;∙------∙lpWindowName
                        , "UInt", WS_POPUP | BS_AUTOCHECKBOX    ;;∙------∙dwStyle
                        , "UInt", CW_USEDEFAULT	    ;;∙------∙x
                        , "UInt", 0		    ;;∙------∙y
                        , "UInt", 0		    ;;∙------∙nWidth
                        , "UInt", 0		    ;;∙------∙nHeight
                        , "UInt", GuiHwnd		    ;;∙------∙hWndParent
                        , "UInt", 0		    ;;∙------∙hMenu
                        , "UInt", 0		    ;;∙------∙hInstance
                        , "UInt", 0)		    ;;∙------∙lpParam

        DllCall("uxtheme\SetWindowTheme"
                    , Ptr, TTHwnd
                    , Ptr, 0
                    , Ptr, 0)

        TTHwnds .= (TTHwnds ? "|" : "") TTHwnd
        , GuiHwnds .= (GuiHwnds ? "|" : "") GuiHwnd
    }

    LastGuiHwnd := GuiHwnd
    , LastTTHwnd := TTHwnd
    , TInfoSize := 4 + 4 + ((A_PtrSize ? A_PtrSize : 4) * 2) + (4 * 4) + ((A_PtrSize ? A_PtrSize : 4) * 4)
    , Offset := 0
    , Varsetcapacity(TInfo, TInfoSize, 0)
    , Numput(TInfoSize, TInfo, Offset, "UInt"), Offset += 4 	    ;;∙------∙cbSize
    , Numput(1 | 16, TInfo, Offset, "UInt"), Offset += 4 	    ;;∙------∙uFlags
    , Numput(GuiHwnd, TInfo, Offset, Ptr), Offset += A_PtrSize ? A_PtrSize : 4    ;;∙------∙hwnd
    , Numput(_CtrlHwnd, TInfo, Offset, Ptr), Offset += A_PtrSize ? A_PtrSize : 4    ;;∙------∙UINT_PTR
    , Offset += 16			    ;;∙------∙RECT (not a pointer but the entire RECT)
    , Offset += A_PtrSize ? A_PtrSize : 4	    ;;∙------∙hinst
    , Numput(&_TipText, TInfo, Offset, Ptr)	    ;;∙------∙lpszText

    If (!_Modify Or _Modify = -1)
    {
        DllCall("SendMessage"
                , Ptr, TTHwnd
                , "UInt", A_IsUnicode ? TTM_DELTOOLW : TTM_DELTOOLA
                , Ptr, 0
                , Ptr, &TInfo)
        
        If (_Modify = -1)
            return

        DllCall("SendMessage"
                , Ptr, TTHwnd
                , "UInt", A_IsUnicode ? TTM_ADDTOOLW : TTM_ADDTOOLA
                , Ptr, 0
                , Ptr, &TInfo)

         DllCall("SendMessage"
                , Ptr, TTHwnd
                , "UInt", TTM_SETMAXTIPWIDTH
                , Ptr, 0
                , Ptr, A_ScreenWidth)
    }

    DllCall("SendMessage"
        , Ptr, TTHwnd
        , "UInt", A_IsUnicode ? TTM_UPDATETIPTEXTW : TTM_UPDATETIPTEXTA
        , Ptr, 0
        , Ptr, &TInfo)
    return

    RemoveCachedHwnd:
        Loop, Parse, GuiHwnds, |
            NewGuiHwnds .= (A_LoopField = GuiHwnd ? "" : ((NewGuiHwnds = "" ? "" : "|") A_LoopField))
        
        Loop, Parse, TTHwnds, |
            NewTTHwnds .= (A_LoopField = TTHwnd ? "" : ((NewTTHwnds = "" ? "" : "|") A_LoopField))
        
        GuiHwnds := NewGuiHwnds
        , TTHwnds := NewTTHwnds
        , LastGuiHwnd := ""
        , LastTTHwnd := ""
    return
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

