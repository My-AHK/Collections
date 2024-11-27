
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙--------∙Origins∙-------------------------∙
» Author:  AutoHotkey
» Original Source:  
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
;;∙======∙🔥 HotKey 🔥∙===========================================∙
^t::    ;;∙------∙(Ctrl+T) 
    Soundbeep, 1100, 100
;;∙============================================================∙




;;∙============================================================∙
CoordMode, Pixel, Screen
txtNotFrozen := "(Hold Ctrl or Shift to suspend updates)"
txtFrozen := "(Updates suspended)"
txtMouseCtrl := "Control Under Mouse Position"
txtFocusCtrl := "Focused Control"
Gui, New, 
    +AlwaysOnTop 
    -Caption 0x00800000 ; (0x00800000 = Creates a thin-line border box) 
    +hwndhGui 
    +Owner 
    +MinSize
Gui, Margin, 10,15
Gui, Color, 0B0B0B
Gui, Font, s8 c80DDFF q5 Bold, Segoe UI
Gui, Add, Text, x10 y10, Window Title, Class and Process:
Gui, Font, s8 cFFFFFF q5 Norm, Segoe UI
Gui, Add, Checkbox,  x208 y10 w120 Right vCtrl_FollowMouse, Follow Mouse%A_Space%
Gui, Font, s8 c80DDFF q5, Segoe UI
Gui, Add, Edit, x10 y30 w320 r4 ReadOnly -Wrap vCtrl_Title
Gui, Font, s8 c80DDFF q5 Bold, Segoe UI
Gui, Add, Text, x10 y100, Mouse Position:
Gui, Font, s8 c80DDFF q5 Norm, Segoe UI
Gui, Add, Edit, x10 y120 w320 r4 ReadOnly vCtrl_MousePos
Gui, Font, s8 c80DDFF q5 Bold, Segoe UI
Gui, Add, Text, x10 y190 w320 vCtrl_CtrlLabel, % txtFocusCtrl ":"
Gui, Font, s8 c80DDFF q5Norm, Segoe UI
Gui, Add, Edit, x10 y210 w320 r4 ReadOnly vCtrl_Ctrl
Gui, Font, s8 c80DDFF q5 Bold, Segoe UI
Gui, Add, Text, x10 y280, Active Window Position:
Gui, Font, s8 c80DDFF q5Norm, Segoe UI
Gui, Add, Edit, x10 y300 w320 r2 ReadOnly vCtrl_Pos
Gui, Font, s8 c80DDFF q5 Bold, Segoe UI
Gui, Add, Text,x10 y345 , Status Bar Text:
Gui, Font, s8 c80DDFF q5Norm, Segoe UI
Gui, Add, Edit, x10 y365 w320 r2 ReadOnly vCtrl_SBText
Gui, Font, s8 cFFFFFF q5, Segoe UI
Gui, Add, Checkbox, x10 y410 vCtrl_IsSlow, %A_Space%Slow TitleMatchMode
Gui, Font, s8 c80DDFF q5, Segoe UI
Gui, Font, s8 c80DDFF q5 Bold, Segoe UI
Gui, Add, Text, x10 y435 , Visible Text:
Gui, Font, s8 c80DDFF q5Norm, Segoe UI
Gui, Add, Edit, x10 y455 w320 r2 ReadOnly vCtrl_VisText
Gui, Font, s8 c80DDFF q5 Bold, Segoe UI
Gui, Add, Text, x10 y500 BackgroundTrans, All Text:
Gui, Font, s8 c80DDFF q5Norm, Segoe UI
Gui, Add, Edit, x10 y520 w320 BackgroundTrans r2 ReadOnly vCtrl_AllText
Gui, Font, s8 cFFFFFF q5, Segoe UI
Gui, Add, Text, x10 y570 w320 BackgroundTrans r1 vCtrl_Freeze, % txtNotFrozen
Gui, Font, s8 c80DDFF q5 Bold, Calibri
Gui, Add, Text, x285 y565 cCDCD0A BackgroundTrans gRefresh, Refresh
Gui, Add, Text, x300 y580 cA70000 BackgroundTrans gExit, Exit
Gui, Show, NoActivate x1515 y406, Window Spy
    OnMessage(0x0201, "WM_LBUTTONDOWNdrag") 
GetClientSize(hGui, temp)
horzMargin := temp*96//A_ScreenDPI - 320
SetTimer, Update, 250
return
GuiSize:
Gui %hGui%:Default
if !horzMargin
return
SetTimer, Update, % A_EventInfo=1 ? "Off" : "On"
ctrlW := A_GuiWidth - horzMargin
list = Title,MousePos,Ctrl,Pos,SBText,VisText,AllText,Freeze
Loop, Parse, list, `,
GuiControl, Move, Ctrl_%A_LoopField%, w%ctrlW%
return
Update:
Gui %hGui%:Default
GuiControlGet, Ctrl_FollowMouse
CoordMode, Mouse, Screen
MouseGetPos, msX, msY, msWin, msCtrl
actWin := WinExist("A")
if Ctrl_FollowMouse
{
curWin := msWin
curCtrl := msCtrl
WinExist("ahk_id " curWin)
}
else
{
curWin := actWin
ControlGetFocus, curCtrl
}
WinGetTitle, t1
WinGetClass, t2
if (curWin = hGui || t2 = "MultitaskingViewFrame")
{
UpdateText("Ctrl_Freeze", txtFrozen)
return
}
UpdateText("Ctrl_Freeze", txtNotFrozen)
WinGet, t3, ProcessName
WinGet, t4, PID
UpdateText("Ctrl_Title", t1 "`nahk_class " t2 "`nahk_exe " t3 "`nahk_pid " t4)
CoordMode, Mouse, Relative
MouseGetPos, mrX, mrY
CoordMode, Mouse, Client
MouseGetPos, mcX, mcY
PixelGetColor, mClr, %msX%, %msY%, RGB
mClr := SubStr(mClr, 3)
UpdateText("Ctrl_MousePos", "Screen:`t" msX ", " msY " (less often used)`nWindow:`t" mrX ", " mrY " (default)`nClient:`t" mcX ", " mcY " (recommended)"
. "`nColor:`t" mClr " (Red=" SubStr(mClr, 1, 2) " Green=" SubStr(mClr, 3, 2) " Blue=" SubStr(mClr, 5) ")")
UpdateText("Ctrl_CtrlLabel", (Ctrl_FollowMouse ? txtMouseCtrl : txtFocusCtrl) ":")
if (curCtrl)
{
ControlGetText, ctrlTxt, %curCtrl%
cText := "ClassNN:`t" curCtrl "`nText:`t" textMangle(ctrlTxt)
ControlGetPos cX, cY, cW, cH, %curCtrl%
cText .= "`n`tx: " cX "`ty: " cY "`tw: " cW "`th: " cH
WinToClient(curWin, cX, cY)
ControlGet, curCtrlHwnd, Hwnd,, % curCtrl
GetClientSize(curCtrlHwnd, cW, cH)
cText .= "`nClient:`tx: " cX "`ty: " cY "`tw: " cW "`th: " cH
}
else
cText := ""
UpdateText("Ctrl_Ctrl", cText)
WinGetPos, wX, wY, wW, wH
GetClientSize(curWin, wcW, wcH)
UpdateText("Ctrl_Pos", "`tx: " wX "`ty: " wY "`tw: " wW "`th: " wH "`nClient:`tx: 0`ty: 0`tw: " wcW "`th: " wcH)
sbTxt := ""
Loop
{
StatusBarGetText, ovi, %A_Index%
if ovi =
break
sbTxt .= "(" A_Index "):`t" textMangle(ovi) "`n"
}
StringTrimRight, sbTxt, sbTxt, 1
UpdateText("Ctrl_SBText", sbTxt)
GuiControlGet, bSlow,, Ctrl_IsSlow
if bSlow
{
DetectHiddenText, Off
WinGetText, ovVisText
DetectHiddenText, On
WinGetText, ovAllText
}
else
{
ovVisText := WinGetTextFast(false)
ovAllText := WinGetTextFast(true)
}
UpdateText("Ctrl_VisText", ovVisText)
UpdateText("Ctrl_AllText", ovAllText)
return
GuiClose:
ExitApp
WinGetTextFast(detect_hidden)
{
WinGet controls, ControlListHwnd
static WINDOW_TEXT_SIZE := 32767
VarSetCapacity(buf, WINDOW_TEXT_SIZE * (A_IsUnicode ? 2 : 1))
text := ""
Loop Parse, controls, `n
{
if !detect_hidden && !DllCall("IsWindowVisible", "ptr", A_LoopField)
continue
if !DllCall("GetWindowText", "ptr", A_LoopField, "str", buf, "int", WINDOW_TEXT_SIZE)
continue
text .= buf "`r`n"
}
return text
}
UpdateText(ControlID, NewText)
{
static OldText := {}
global hGui
if (OldText[ControlID] != NewText)
{
GuiControl, %hGui%:, % ControlID, % NewText
OldText[ControlID] := NewText
}
}
GetClientSize(hWnd, ByRef w := "", ByRef h := "")
{
VarSetCapacity(rect, 16)
DllCall("GetClientRect", "ptr", hWnd, "ptr", &rect)
w := NumGet(rect, 8, "int")
h := NumGet(rect, 12, "int")
}
WinToClient(hWnd, ByRef x, ByRef y)
{
WinGetPos wX, wY,,, ahk_id %hWnd%
x += wX, y += wY
VarSetCapacity(pt, 8), NumPut(y, NumPut(x, pt, "int"), "int")
if !DllCall("ScreenToClient", "ptr", hWnd, "ptr", &pt)
return false
x := NumGet(pt, 0, "int"), y := NumGet(pt, 4, "int")
return true
}
textMangle(x)
{
if pos := InStr(x, "`n")
x := SubStr(x, 1, pos-1), elli := true
if StrLen(x) > 40
{
StringLeft, x, x, 40
elli := true
}
if elli
x .= " (...)"
return x
}
~*Ctrl::
~*Shift::
SetTimer, Update, Off
UpdateText("Ctrl_Freeze", txtFrozen)
return
~*Ctrl up::
~*Shift up::
SetTimer, Update, On
return
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
    Refresh:
        SoundBeep, 1100, 75
        Soundbeep, 1200, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
    Exit:
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

