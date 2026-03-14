
/*------∙NOTES∙--------------------------------------------------------------------------∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  
» Original Source:  
» 
    ▹ 
∙--------------------------------------------------------------------------------------------∙
*/



SetTimer, UpdateCheck, 750
ScriptID := "TEMPLATE"
Menu, Tray, Icon, shell32.dll, 313
GoSub, TrayMenu
;;∙------------------------------------------------------------------------------------------∙




;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙
;;∙------∙Zero-based alphabet indexing (a=0, z=25).
;;∙------∙Converts text into numbers (a=0, b=1, c=2, etc.)


#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")

;;∙====================================∙
Gui, +AlwaysOnTop -Caption +ToolWindow +Border
Gui, Color, c111111
Gui, Font, s10 c111111, Segoe UI

Gui, Add, Picture, x210 y5 w16 h16 Icon239 gReset, shell32.dll
Gui, Add, Picture, x230 y5 w16 h16 Icon132 gClose, shell32.dll

Gui, Add, Text, x10 y10 w100 c399AE8 , Enter Name:
Gui, Font, cCC0000
Gui, Add, Edit, x10 y30 w230 vInputName gConvertOnType, 


Gui, Add, Text, x10 y70 w100 c399AE8, Number Result:
Gui, Font, c00CC00
Gui, Add, Edit, x10 y90 w230 vOutputNumber ReadOnly,

Gui, Font, c111111
Gui, Add, Button, x60 y130 w60 gClear, &Clear
Gui, Add, Button, x130 y130 w60 gCopy, &Copy

Gui, Font, s8
Gui, Add, StatusBar, y+5, %A_Space% Enter a name to convert...
Gui, Show, w250 h195, Runescape Name Converter
Return

;;∙====================================∙
Convert:
    Gui, Submit, NoHide
    ConvertName(InputName)
Return

ConvertOnType:
    GuiControlGet, InputName,, InputName
    ConvertName(InputName)
Return

ConvertName(Name) {
    if (Name = "") {
        GuiControl,, OutputNumber
        SB_SetText("  Enter a name to convert...")
        return
    }
    
    StringReplace, Name, Name, %A_Space%, , All
    StringLower, Name, Name

    Result := ""
    Loop, Parse, Name
    {
        Char := A_LoopField

        if (Char >= "a" and Char <= "z") {
            Num := Asc(Char) - Asc("a")
            Result .= Num
        }
        else if (Char >= "0" and Char <= "9") {
            Result .= Char
        }
        else {
            continue
        }
    }

    GuiControl,, OutputNumber, %Result%

    if (Result = "")
        SB_SetText("  No valid letters found")
    else
        SB_SetText("  Conversion:  " . Name . "  >>  " . Result)
}

Reset:
    Reload
Return

Clear:
    GuiControl,, InputName
    GuiControl,, OutputNumber
    SB_SetText("  Enter a name to convert...")
    GuiControl, Focus, InputName
Return

Copy:
    GuiControlGet, OutputNumber,, OutputNumber
    if (OutputNumber != "") {
        Clipboard := OutputNumber
        SB_SetText("  Copied to clipboard: " . OutputNumber)
        GuiControl, +cGreen, Copy
        Sleep, 300
        GuiControl, +cDefault, Copy
    }
    else {
        SB_SetText("  Nothing to copy")
    }
Return

Close:
GuiClose:
    ExitApp
Return

WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙



;;∙====================================∙
 ;;∙------∙EDIT∙---------------------------∙
Script·Edit:    ;;∙------∙Menu Call.
    Edit
Return

;;∙------∙RELOAD∙-----------------------∙
^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        Soundbeep, 1200, 250
    Reload
Return

 ;;∙------∙EXIT∙----------------------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        Soundbeep, 1000, 300
    ExitApp
Return

;;∙====================================∙
 ;;∙------∙SCRIPT UPDATE∙-------------∙
UpdateCheck:    ;;∙------Check if script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload

;;∙====================================∙
 ;;∙------∙TRAY MENU∙------------------∙
TrayMenu:
Menu, Tray, Tip, %ScriptID%
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Suspend / Pause, % ScriptID    ;;∙------∙Script Header.
Menu, Tray, Icon, Suspend / Pause, shell32, 28
Menu, Tray, Default, Suspend / Pause    ;;∙------∙Makes Bold.

;;∙------∙MENU-EXTENTIONS∙---------∙
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

;;∙------∙MENU-OPTIONS∙-------------∙
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

;;∙------∙EXTENTIONS∙------------------∙
Documentation:
    Run, "C:\Program Files\AutoHotkey\AutoHotkey.chm"
Return
ShowKeyHistory:
    KeyHistory
Return
ShowWindowSpy:
    Run, "C:\Program Files\AutoHotkey\WindowSpy.ahk"
Return

;;∙------∙MENU-HEADER∙---------------∙
TEMPLATE:    ;;∙------∙Suspends hotkeys then pauses script.
    Suspend
    Soundbeep, 700, 100
    Pause
Return

;;∙====================================∙
 ;;∙------∙MENU POSITION∙-----------∙
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20
Return

 ;;∙------∙POSITION FUNTION∙-------∙
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
;;∙------------------------------------------------------------------------------------------∙
;;∙========================∙SCRIPT END∙=========================∙
;;∙------------------------------------------------------------------------------------------∙

