
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  foom
» Original Source:  https://www.autohotkey.com/board/topic/18184-gui-float-question-expertwise-person-help-needed/page-4
» Additional Author:  
» Additional Source:  https://www.autohotkey.com/board/topic/43255-throw-windows-on-dual-monitor-computer/
    ▹ 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TEMPLATE"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙




;;∙============================================================∙
;;∙================∙INITIALIZE∙================∙
INERTIA = 0.97    ;;∙------∙1 means Move forever, 0 means not at all.
BOUNCYNESS = 0.5    ;;∙------∙1 means no speed is lost, 0 means don't bounce.

;;∙------------∙Must be greater than 0 and no higher than 1∙------------∙
SENSITIVITY = 0.33    ;;∙------∙Higher is more responsive, lower smooths out glitchs more.

GRAVITY = 1.5    ;;∙------∙0 means turn gravity off. Negative values are possible too. Best results are in range from -2 to 2.
GRAVITYMODE = 2 	;;∙------∙1 - Bottom edge gravity only.
 		;;∙------∙2 - First window edge to hit is gravity source.
 		;;∙------∙3 - Last window edge to hit is gravity source.
 		;;∙------∙4 - Same as 2, starts with Bottom gravity rather than straight line movement.
 		;;∙------∙5 - Same as 3, starts with Bottom gravity rather than straight line movement.

;;∙------∙Scale windows to get the effect of throwing windows to the background.
SCALEWIN   = 0    ;;∙------∙(performance hog) 0=off, 1=on. 
SCALEFACTOR= 0.99    ;;∙------∙0.90 - 0.99 The factor the window should be scaled down by when thrown.

MINWIDTH = 200    ;;∙------∙Minimum width a window should be scaled too.
MINHEIGHT = 100    ;;∙------∙Minimum height a window should be scaled too.
;;∙------∙If one of those two minimums is reached scaling stops.

SpeedA := 1 - SENSITIVITY
SpeedX := SpeedY := 0    ;;∙------∙Variable initialization.

;;∙==============∙INITIALIZE END∙==============∙


#SingleInstance Force
#NoEnv
SetBatchLines -1    ;;∙------∙Run faster.
SetWinDelay -1    ;;∙------∙Makes the window moves faster/smoother.
CoordMode Mouse, Screen    ;;∙------∙Switch to screen/absolute coordinates.

OnMessage(0x1A , "WM_SETTINGCHANGE")    ;;∙------∙In case the workarea changes.
WM_SETTINGCHANGE(w){
    global
    ;;∙------∙if w = 47 ;SPI_SETWORKAREA
    ;;∙------∙SysGet WorkArea, MonitorWorkArea
    if w = 47 ;SPI_SETWORKAREA 
    { 
        ;;∙------∙MSDN: The virtual screen is the bounding rectangle of all display monitors. 
        SysGet, WorkAreaLeft, 76    ; SM_XVIRTUALSCREEN 
        SysGet, WorkAreaTop, 77     ; SM_YVIRTUALSCREEN 
        SysGet, WorkAreaRight, 78   ; SM_CXVIRTUALSCREEN 
        SysGet, WorkAreaBottom, 79  ; SM_CYVIRTUALSCREEN 
        ;;∙------∙Convert width,height to right,bottom 
        WorkAreaRight += WorkAreaLeft 
        WorkAreaBottom += WorkAreaTop 
    }
}
WM_SETTINGCHANGE(47)

~^!d::ListVars    ;;∙------∙Debug.
~*LButton::    ;;∙------∙Clicking a mouse button stops movement.
~*RButton::
    loop, parse, WindowQueue, `n, `n
        RemoveWin(A_LoopField)
Return

MButton::
    ;;∙------∙SetTimer Move, Off
    MouseGetPos LastMouseX, LastMouseY, MWin
    WinGet WinState, MinMax, ahk_id %MWin%
    IfNotEqual WinState, 0    ;;∙------∙If the window is maximized, just do normal Middle Click.
    {
        Click Middle
        return
   }
   RemoveWin(MWin)    ;;∙------∙Necessary else GRAVITYMODE = 4 will fail sometimes.
   WinGetPos WinX, WinY, WinWidth, WinHeight, ahk_id %MWin%
   SetTimer WatchMouse, 10,    ;;∙------∙Track the mouse as the user drags it
Return

WatchMouse:
   If !GetKeyState("MButton","P") {
      SetTimer WatchMouse, Off    ;;∙------∙Button has been released, so drag is complete.
      AddWin(MWin)
      SetTimer Move, 10     ;;∙------∙Start moving.
      return
    }
    ;;∙------∙Drag: Button is still pressed.
    MouseGetPos MouseX, MouseY
    WinX += MouseX - LastMouseX
    WinY += MouseY - LastMouseY

    ;;∙------∙Enforce Boundaries.
   WinX := WinX < WorkAreaLeft ? WorkAreaLeft : WinX+WinWidth > WorkAreaRight ? WorkAreaRight-WinWidth : WinX
   WinY := WinY < WorkAreaTop ? WorkAreaTop : WinY+WinHeight > WorkAreaBottom ? WorkAreaBottom-WinHeight : WinY

   WinMove ahk_id %MWin%,, WinX, WinY
   SpeedX := SpeedX*SpeedA + (MouseX-LastMouseX)*SENSITIVITY
   SpeedY := SpeedY*SpeedA + (MouseY-LastMouseY)*SENSITIVITY
   LastMouseX := MouseX,     LastMouseY := MouseY
Return

AddWin(MWin)
    {
        global
        WindowQueue:=List(WindowQueue,MWin)
        %MWin%WinX := WinX, %MWin%WinY := WinY, %MWin%WinWidth := WinWidth, %MWin%WinHeight := WinHeight
        %MWin%SpeedX := SpeedX, %MWin%SpeedY := SpeedY
        %MWin%gravity := GRAVITYMODE = 1 OR GRAVITYMODE = 4 OR GRAVITYMODE = 5 ? "b" : ""
    }

RemoveWin(MWin)
    {
        global
        WindowQueue:=List(WindowQueue,MWin,"d")
        ;;∙------∙No need to remove these as they are from persistent memory (1-64 bytes).
        ;;∙------∙%MWin%WinX := %MWin%WinY := %MWin%WinWidth := %MWin%WinHeight := %MWin%SpeedX := %MWin%SpeedY := ""
        %MWin%gravity := %MWin%touch := %MWin%touchedonce := ""
    }

Move:
    If !WindowQueue
        SetTimer Move, Off

    Loop, Parse, WindowQueue , `n, `n
        Move(A_LoopField)
Return

boo(t){    ;;∙------∙Debug
        tooltip, %t%
        return t
    }

Move(MWin)
    {
        global
        local T, G
        G:=%MWin%gravity    ;;∙------∙Dereferencing is slow.
        If (GRAVITY ? Abs(%MWin%SpeedX) < 1 AND Abs(%MWin%SpeedY) < 1 AND %MWin%Touch : Abs(%MWin%SpeedX) < 1 AND Abs(%MWin%SpeedY) < 1){
            RemoveWin(MWin)
        return
    }
    if GRAVITY
    {
        %MWin%SpeedX += G = "r" ? GRAVITY : G = "l" ? -GRAVITY : 0
        %MWin%SpeedY += G = "b" ? GRAVITY : G = "t" ? -GRAVITY : 0
        ;;∙------∙Update wincoords before touch check. If touch() reports collision bouncyness kicks in.
        %MWin%WinX += %MWin%SpeedX,   %MWin%WinY += %MWin%SpeedY
        if (T:=Touch(MWin))
            {
                 if GRAVITYMODE = 2
                    %MWin%gravity := G ? G : T
                else if (GRAVITYMODE = 3 OR GRAVITYMODE = 5)
                    %MWin%gravity := T
                else if GRAVITYMODE = 4
                    %MWin%gravity :=   %MWin%touchedonce ? G : ((%MWin%touchedonce := 1) ? T : "c")
                ;;∙------∙Tooltip, % "Touchedonce: " %MWin%touchedonce "`n`nG: " G " T: " T "`n`n EXP: " (tmp:= %MWin%touchedonce ? G : ((%MWin%touchedonce := 1) ? T : "c"))
                %MWin%touch:=T  ;Used to check if window should stop moving when in gravity mode.
                %MWin%SpeedY := (T = "b" || T = "t") ? %MWin%SpeedY * -BOUNCYNESS : %MWin%SpeedY * BOUNCYNESS
                %MWin%SpeedX := (T = "l" || T = "r") ? %MWin%SpeedX * -BOUNCYNESS : %MWin%SpeedX * BOUNCYNESS
            }
            else
            %MWin%touch=
    }
    else
    {
        %MWin%SpeedX *= INERTIA,  %MWin%SpeedY *= INERTIA
        %MWin%WinX += %MWin%SpeedX,   %MWin%WinY += %MWin%SpeedY
        if (T:=Touch(MWin))
            {
                %MWin%SpeedY *= (T = "b" || T = "t") ? -BOUNCYNESS : 1
                %MWin%SpeedX *= (T = "l" || T = "r") ? -BOUNCYNESS : 1
            }
    }
    ;;∙------∙Out of bounds checks.
    %MWin%WinX := %MWin%WinX < WorkAreaLeft ? WorkAreaLeft: %MWin%WinX + %MWin%WinWidth > WorkAreaRight ? WorkAreaRight - %MWin%WinWidth : %MWin%WinX
    %MWin%WinY := %MWin%WinY < WorkAreaTop ? WorkAreaTop : %MWin%WinY + %MWin%WinHeight > WorkAreaBottom ? WorkAreaBottom - %MWin%WinHeight : %MWin%WinY
    if SCALEWIN
        {
            Scale(MWin)
            WinMove ahk_id %MWin%,, %MWin%WinX, %MWin%WinY , %MWin%WinWidth, %MWin%WinHeight
            return
        }
        WinMove ahk_id %MWin%,, %MWin%WinX, %MWin%WinY
    }

Scale(MWin)
    {
        global
        local w, h
        w:=%MWin%WinWidth * SCALEFACTOR,  h:=%MWin%WinHeight * SCALEFACTOR
        if (w > MINWIDTH AND h > MINHEIGHT)
             %MWin%WinX+=(%MWin%WinWidth-w)/2, %MWin%WinWidth := w,%MWin%WinY+=(%MWin%WinHeight-h)/2 , %MWin%WinHeight := h
    }

Touch(MWin)
    {
        global
        if (%MWin%WinY + %MWin%WinHeight >= WorkAreaBottom)
            return "b"
        else if (%MWin%WinY <= WorkAreaTop)
            return "t"
        else if (%MWin%WinX <= WorkAreaLeft)
            return "l"
        else if (%MWin%WinX + %MWin%WinWidth >= WorkAreaRight)
            return "r"
    }

List(list,Item,Action="",Delim="`n")
    {
        ;;∙------∙Adds Item to a %Delim% Delimited list, removes it, or selects it by putting 2 Delims behind it.
        ;;∙------∙Action can be s for select, d for delete, a for add. If ommited it defaults to add.
        if !Item
            return list
        if !list
            if Action = d
                return
            else if Action = s
                return Item . Delim . Delim
            else
                return Item
        if Action = d
            list:=RegExReplace(list,"i)\Q" . Item . "\E(\Q" . Delim . "\E)*","")    ;;∙------∙Delete Item if allready in list.
            list:=RegExReplace(list,"i)(\Q" . Delim . "\E){2,}",Delim)    ;;∙------∙Replace succesive Delims.
            list:=RegExReplace(list,"i)^(\Q" . Delim . "\E)|(\Q" . Delim . "\E)$","")    ;;∙------∙Delete Delims from start and end of list.
        if Action = s
            list:=RegExReplace(list,"i)(\Q" . Item . "\E)(?:\Q" . Delim . "\E)*","$1" . Delim . Delim)
        if (Action = "s" || Action = "d" || RegExMatch(list, "i)(?:\Q" . Item . "\E)(?:\Q" . Delim . "\E)*"))    ;;∙------∙The regexmatch assures we don't add an item twice.
            return list
        return Item . Delim . list    ;;∙------∙Prepend new items rather than append makes it easier to debug lists.
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

