
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
» Author:  Alguimist
» ORIGINAL SOURCE:  https://www.autohotkey.com/boards/viewtopic.php?t=52080#p228621
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TEMPLATE"    ;;∙------∙Need to also change in "MENU CALLS"
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙🔥 HotKey 🔥∙===========================================∙
; ^t::    ;;∙------∙(Ctrl+T) 
;    Soundbeep, 1100, 100
;;∙============================================================∙




;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙------∙* Set as a Hidden File in Storing Section *
Global hWnd, IniFile := "RestorGuiMetrics.ini"    ;;∙------∙INI file name.
;;∙------------------------------------------------------------------------------------------∙

;;∙======∙Gui Example∙==========================================∙
;;∙------------------------------------------------------------------------------------------∙
AxisX := "1300"    ;;∙------∙Set initial x-axis.
AxisY := "200"    ;;∙------∙Set initial y-axis.
gWidth := "350"    ;;∙------∙Set initial width. 
gHeight := "400"    ;;∙------∙Set initial height.
InState := "1"    ;;∙------∙Set initial window state/aka: Gui Show. (1=Restored, 2=Minimized, 3=Maximized)
IconSz := "64"    
;;∙--------------------------∙
Gui, Color, 000011
Gui, +AlwaysOnTop +hWndhWnd +Resize 
Gui, Font, s14 c00A7FF Bold q5, Calibri
Gui, Add, Text, x0 w%gWidth% y50 BackgroundTrans Center, Restore The Gui Position`nAnd The Gui Window State`nWhen The Gui Is Closed
Gui, Font, s10 cA70000 Norm Italic q5, Arial
Gui, Add, Text, x0 w%gWidth% y+25 BackgroundTrans Center, 1=Restored  2=Minimized  3=Maximized
    gWidthIcon := (gWidth/2) - (IconSz/2)    ;;∙------∙Icon centering.
Gui, Add, Picture, x%gWidthIcon% y+25 BackgroundTrans gSpin w%IconSz% h%IconSz% Icon239, shell32.dll
;;∙------------------------------------------------------------------------------------------∙

;;∙======∙Restoring The Window Position From The INI File∙===========∙
;;∙------------------------------------------------------------------------------------------∙
IniRead X, %IniFile%, Position, X, %AxisX%
IniRead Y, %IniFile%, Position, Y, %AxisY%
IniRead W, %IniFile%, Position, Width, %gWidth%
IniRead H, %IniFile%, Position, Height, %gHeight%
IniRead State, %IniFile%, Position, State, %InState%

If (FileExist(IniFile)) {
    SetWindowPlacement(hWnd, X, Y, W, H, State)
} Else {
    SetWindowPlacement(hWnd, X, Y, W, H, InState)    ;;∙------∙InState (aka: Gui Show).
}
Return

;;∙======∙Gui Exits∙==============================================∙
;;∙------------------------------------------------------------------------------------------∙
GuiEscape:
GuiClose:
    GoSub SaveSettings
    ExitApp

Spin:
    Reload
Return

;;∙======∙Storing The Window Position In The INI File∙================∙
;;∙------------------------------------------------------------------------------------------∙
SaveSettings:
    Pos := GetWindowPlacement(hWnd)
        IniWrite % Pos.x, %IniFile%, Position, X
        IniWrite % Pos.y, %IniFile%, Position, Y
        IniWrite % Pos.w, %IniFile%, Position, Width
        IniWrite % Pos.h, %IniFile%, Position, Height
        IniWrite % Pos.showCmd, %IniFile%, Position, State
    DllCall("SetFileAttributes", "Str", IniFile, "UInt", 0x02)    ;;∙------∙Sets the INI file attribute as hidden.
Return

;;∙======∙GetPlacement / SetPlacement Functions∙===================∙
;;∙------------------------------------------------------------------------------------------∙
GetWindowPlacement(hWnd) {
    NumPut(VarSetCapacity(WINDOWPLACEMENT, 44, 0), WINDOWPLACEMENT, 0, "UInt")
    DllCall("GetWindowPlacement", "Ptr", hWnd, "Ptr", &WINDOWPLACEMENT)
    Result := {}
    Result.x := NumGet(WINDOWPLACEMENT, 28, "Int")
    Result.y := NumGet(WINDOWPLACEMENT, 32, "Int")
    Result.w := NumGet(WINDOWPLACEMENT, 36, "Int") - Result.x
    Result.h := NumGet(WINDOWPLACEMENT, 40, "Int") - Result.y
    Result.showCmd := NumGet(WINDOWPLACEMENT, 8, "UInt") 
    Return Result
}
;;∙---------------------------------------------∙
SetWindowPlacement(hWnd, x, y, w, h, showCmd) {
    NumPut(VarSetCapacity(WINDOWPLACEMENT, 44, 0), WINDOWPLACEMENT, 0, "UInt")
    NumPut(x, WINDOWPLACEMENT, 28, "Int")
    NumPut(y, WINDOWPLACEMENT, 32, "Int")
    NumPut(w + x, WINDOWPLACEMENT, 36, "Int")
    NumPut(h + y, WINDOWPLACEMENT, 40, "Int")
    NumPut(showCmd, WINDOWPLACEMENT, 8, "UInt")
    Return DllCall("SetWindowPlacement", "Ptr", hWnd, "ptr", &WINDOWPLACEMENT)
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
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙--∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        Soundbeep, 1200, 75
        Soundbeep, 1400, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙--∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
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
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;; Gui Drag Pt 1.
SetBatchLines -1
SetTimer, UpdateCheck, 500
SetTitleMatchMode 2
SetWinDelay 0
Menu, Tray, Icon, Imageres.dll, 65
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
TEMPLATE:    ;;∙------∙Change as needed to match the 'ScriptID' variable in AutoExe section.
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

