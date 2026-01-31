

; ╞═══════════ Auto-Execute ═══════════╡ 
Gosub, AutoExecute
; ╞──────── Auto-Execute End ────────╡ 

CoordMode, Pixel, Screen
txtNotFrozen := "(Hold Ctrl or Shift to suspend updates)"
txtFrozen := "(Updates suspended)"
txtMouseCtrl := "Control Under Mouse Position"
txtFocusCtrl := "Focused Control"
Gui, New, 
    +AlwaysOnTop 
    -Caption
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
Gui, Add, Text, x285 y565 cLime BackgroundTrans gRefresh, Refresh
Gui, Add, Text, x300 y580 cRed BackgroundTrans gExit, Exit
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


;•--------------------- Gui Drag ---------------------------------------------• 
WM_LBUTTONDOWNdrag() { 
   PostMessage, 0x00A1, 2, 0
} 
;○-------------------- Gui Drag End ----------------------------------------○ 
; ╞═══════════ Reload/Exit Routine ═══════════╡ 
RETURN

; ◦ ◦ ◦ ◦ ◦ ◦ ◦ RELOAD  SCRIPT ◦ ◦ ◦ ◦ ◦ ◦ ◦ 
^Home:: 
If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200) 	 ; ←←← Double-Tap in less than 200 milliseconds.
    Soundbeep, 1700, 75
    Gui, Destroy
        SoundSet, % master_volume
    Reload
Return
Refresh:
    Soundbeep, 1700, 75
        SoundSet, % master_volume
    Reload
Return
; ◦ ◦ ◦ ◦ ◦ ◦ ◦ EXIT SCRIPT ◦ ◦ ◦ ◦ ◦ ◦ ◦ 
^Esc:: 
If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200) 	 ; ←←← Double-Tap in less than 200 milliseconds.
    Soundbeep, 1700, 75
    Gui, Destroy
        SoundSet, % master_volume
        ExitApp
Return
Exit:
    Soundbeep, 1700, 75
        SoundSet, % master_volume
Sleep, 100
        ExitApp
Return
; ╞──────── Reload/Exit Routine End ────────╡ 

; ╞═══════════ Script Updater ═══════════╡ 
UpdateCheck: 				 ; Check if the script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
; ◦ ◦ ◦ ◦ ◦ ◦ If the modification timestamp has changed, reload the script.
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload

; ╞──────── Script Updater End ────────╡ 


; ╞═══════════ Auto-Execute Sub ═══════════╡ 
AutoExecute:
#SingleInstance, Force
#Persistent
SetBatchLines -1
DetectHiddenWindows, On
SetTimer, UpdateCheck, 500 		 ; Checks for script changes every 1/2 second. (Script Updater)
SoundGet, master_volume
SoundSet, 3
Menu, Tray, Icon, shell32.dll, 23 	 ; Magnify Glass
Return
; ╞──────── Auto-Execute Sub End ────────╡ 


; ╞──────── GoSubs End ────────╡ 

; ╞──────────────────────────╡ 
; ╞═══════════ Script End ═══════════╡ 
; ╞──────────────────────────╡ 


