
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Author:  infogulch
» Source:  https://www.autohotkey.com/board/topic/18184-gui-float-question-expertwise-person-help-needed/page-5
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
;;∙======∙🔥 HotKey 🔥∙===========================================∙
; ^t::    ;;∙------∙(Ctrl+T) 
    Soundbeep, 1000, 200
;;∙============================================================∙




;;∙============================================================∙
;;∙================∙INITIALIZE∙================∙

INERTIA = .96    ;;∙------∙1 means Move forever, 0 means not at all.
BOUNCYNESS = .5    ;;∙------∙1 means no speed is lost, 0 means don't bounce.
SENSITIVITY = .33    ;;∙------∙Higher is more responsive, lower smooths out glitchs more.
    ;;∙------∙Must be greater than 0 and no higher than 1.

GRAVITY = 2    ;;∙------∙0 means turn gravity off. Negative values are possible too. Best results are in range from -2 to 2.
GRAVITYMODE = 6    ;;∙------∙1 means the bottom edge has gravity only.
    ;;∙------∙2 means the first edge the window hits will be its source of gravity.
    ;;∙------∙3 means the last edge the window hits will be its source of gravity.
    ;;∙------∙4 same as 2 but starts of with bottom gravity rather then moving in a straight line.
    ;;∙------∙5 same as 3 but starts of with bottom gravity rather then moving in a straight line.
    ;;∙------∙6 means gravity is based on the direction you throw it.

EnfBound = 1    ;;∙------∙1 to enforce that windows never leave a monitor
                    ;;∙------∙0 to allow a window to be dragged past the monitor and left there
                    ;;∙------∙note that throwing always makes sure the window is inside the monitor area

SCALEWIN = 0    ;;∙------∙(performance hog) 0=off, 1=on. Scale windows to get the effect of throwing windows to the background.
SCALEFACTOR = .99    ;;∙------∙0.90 - 0.99 The factor the window should be scaled down by when thrown.

;;∙------∙If one of those two minimums is reached, scaling stops.
MINWIDTH = 200 ; Minimum width a window should be scaled too.
MINHEIGHT = 100 ; Minimum height a window should be scaled too.

SpeedA := 1 - SENSITIVITY
SpeedX := SpeedY := 0    ;;∙------∙Variable initialization.

Hotkey, LButton, ThrowTitle
Hotkey, LButton Up, Release

Hotkey, RButton, ThrowAll
Hotkey, RButton Up, Release

;;∙==============∙INITIALIZE END∙==============∙

SetBatchLines -1    ;;∙------∙Run faster.
SetWinDelay -1    ;;∙------∙Makes the window moves faster/smoother.
CoordMode Mouse, Screen    ;;∙------∙Switch to screen/absolute coordinates.
SendMode, Input
OnMessage(0x1A , "WM_SETTINGCHANGE")    ;;∙------∙In case the workarea changes.
WM_SETTINGCHANGE(47)
Return

ThrowTitle:
ThrowAll:
    if (Started || WatchButton)    ;;∙------∙Only start one at a time
        return
    Started := True
    MouseGetPos StartMouseX, StartMouseY, MWin
    if (A_ThisLabel = "ThrowTitle") {
        SendMessage, 0x84,, ( StartMouseY << 16 ) | StartMouseX,, ahk_id %MWin%    ;;∙------∙WM_NCHITTEST.
        if (ErrorLevel != 2) {    ;;∙------∙Check if this is the title bar.
            Send, {%A_ThisHotkey% Down}
            Started := False
            return
        }
        isTitle := True
    }
    else
        isTitle := False
    WinGet WinState, MinMax, ahk_id %MWin%
    if (WinState != 0) {    ;;∙------∙If the window is maximized, pass through.
        Send, {%A_ThisHotkey% Down}
        Started := False
        return
    }
    WinGetClass, WinClass, ahk_id %MWin%
    if (WinClass = "Shell_TrayWnd") {    ;;∙------∙Ignore the notification area.
        Send, {%A_ThisHotkey% Down}
        Started := False
        return
    }
    If !InStr(WindowQueue, MWin) && !isTitle    ;;∙------∙It's already being moved by gravity, no need to wait.
        Loop {    ;;∙------∙Don't initiate gravity unless it actually starts being dragged at least 2 pixels.
            If !GetKeyState(A_ThisHotkey, "P") {
                Send, {%A_ThisHotkey% Down}
                Started := False
                return
            }
            MouseGetPos, _mx, _my
            If Abs(StartMouseX-_mx) >= 1 || Abs(StartMouseY-_my) >= 1
                Break    ;;∙------∙The user has attempted to drag the window more than one pixel.
            Sleep 10
        }
    SetTimer, WatchMouse, Off
    WatchButton := A_ThisHotkey
    WinActivate, ahk_id %MWin%    ;;∙------∙Activate this window.
    RemoveWin(MWin)    ;;∙------∙Necessary else GRAVITYMODE = 4 will fail sometimes.
    WinGetPos WinX, WinY, WinWidth, WinHeight, ahk_id %MWin%
    LastWinX := WinX, LastWinY := WinY, SpeedX := SpeedY := 0
    StartMouseRelX := StartMouseX - WinX, StartMouseRelY := StartMouseY - WinY
    SetTimer WatchMouse, 10    ;;∙------∙Track the mouse as the user drags it.
    Started := False
Return

Release:
    If (WatchButton = "")
        Send, {%A_ThisHotkey%}
return

WatchMouse:
    If !GetKeyState( WatchButton, "P" ) {
        SetTimer WatchMouse, Off    ;;∙------∙Button has been released, so drag is complete.
        AddWin(MWin)
        SetTimer Move, 10    ;;∙------∙Start moving.
        WatchButton := ""
        Return
    }
    ;;∙------∙Drag: Button is still pressed
    MouseGetPos MouseX, MouseY
    WinX := MouseX - StartMouseRelX
    WinY := MouseY - StartMouseRelY
    
    ;;∙------∙Enforce Boundaries
    If EnfBound
    {
        Mon := MonAtPos(MouseX, MouseY)
        WinX := WinX < WorkArea%Mon%Left ? WorkArea%Mon%Left : WinX+WinWidth > WorkArea%Mon%Right ? WorkArea%Mon%Right-WinWidth : WinX
        WinY := WinY < WorkArea%Mon%Top ? WorkArea%Mon%Top : WinY+WinHeight > WorkArea%Mon%Bottom ? WorkArea%Mon%Bottom-WinHeight : WinY
    }
    
    SpeedX := SpeedX*SpeedA + (WinX-LastWinX)*SENSITIVITY
    SpeedY := SpeedY*SpeedA + (WinY-LastWinY)*SENSITIVITY
    WinMove ahk_id %MWin%,, WinX, WinY
    LastWinX := WinX, LastWinY := WinY
Return

Move:
    If !WindowQueue
        SetTimer Move, Off
    Loop, Parse, WindowQueue , `n
        if A_LoopField
            Move(A_LoopField)
Return

WM_SETTINGCHANGE( w ) {
    global
    if w = 47 ;SPI_SETWORKAREA
    {
        SysGet, MonitorCount, MonitorCount
        Loop %MonitorCount%
            SysGet WorkArea%A_Index%, MonitorWorkArea, %A_Index%
    }
}

MonAtPos( x, y ) {
    global
    loop %MonitorCount%
        If (WorkArea%A_Index%Left <= x && x <= WorkArea%A_Index%Right) && (WorkArea%A_Index%Top <= y && y <= WorkArea%A_Index%Bottom)
            return A_Index
}

AddWin( MWin ) {
    global

    WindowQueue:=List(WindowQueue,MWin)

    %MWin%Mon := MonAtPos(MouseX, MouseY)
    %MWin%WinX := WinX, %MWin%WinY := WinY, %MWin%WinWidth := WinWidth, %MWin%WinHeight := WinHeight
    %MWin%SpeedX := SpeedX, %MWin%SpeedY := SpeedY
    If GravityMode in 1,4,5
        %MWin%gravity := "b" 
    Else If GravityMode = 6
        %MWin%gravity := Abs(%MWin%SpeedX) > Abs(%MWin%SpeedY) ? (%MWin%SpeedX > 0 ? "r" : "l") : (%MWin%SpeedY > 0 ? "b" : "t")
}
RemoveWin( MWin ) {
    global
    local s := "WinX,WinY,WinWidth,WinHeight,SpeedX,SpeedY,mon,gravity,touch,touchedonce"
    WindowQueue:=List(WindowQueue,MWin,"d")
    loop, parse, s, `,    ;;∙------∙Force variables out of persistent memory and deliberately zero their length.
        VarSetCapacity(%MWin%%A_LoopField%, 64), VarSetCapacity(%MWin%%A_LoopField%, 0)
}

Move( MWin ) {
    global
    local T, G, mon

    G := %MWin%gravity    ;;∙------∙Dereferencing is slow.
    mon := %MWin%Mon
    
    If !WinExist("ahk_id" MWin) || Abs(%MWin%SpeedX) < 2 AND Abs(%MWin%SpeedY) < 2 && (GRAVITY ? !%MWin%touchedonce || G = %MWin%Touch : True) {
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
                %MWin%gravity :=  %MWin%touchedonce ? G : T
            %MWin%touchedonce := 1
            %MWin%touch  := T  ;Used to check if window should stop moving when in gravity mode.
            %MWin%SpeedY := (T = "b" || T = "t") ? %MWin%SpeedY * -BOUNCYNESS : %MWin%SpeedY * BOUNCYNESS
            %MWin%SpeedX := (T = "l" || T = "r") ? %MWin%SpeedX * -BOUNCYNESS : %MWin%SpeedX * BOUNCYNESS
        }
        else
        {
            %MWin%touch=
            If (G = "")    ;;∙------∙If it hasn't touched yet and it doesn't have gravity, use interia to slow down.
                %MWin%SpeedX *= INERTIA,  %MWin%SpeedY *= INERTIA
        }
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
    %MWin%WinX := %MWin%WinX < WorkArea%Mon%Left ? WorkArea%Mon%Left: %MWin%WinX + %MWin%WinWidth > WorkArea%Mon%Right ? WorkArea%Mon%Right - %MWin%WinWidth : %MWin%WinX
    %MWin%WinY := %MWin%WinY < WorkArea%Mon%Top ? WorkArea%Mon%Top : %MWin%WinY + %MWin%WinHeight > WorkArea%Mon%Bottom ? WorkArea%Mon%Bottom - %MWin%WinHeight : %MWin%WinY

    if SCALEWIN
    {
        Scale(MWin)
        WinMove ahk_id %MWin%,, %MWin%WinX, %MWin%WinY , %MWin%WinWidth, %MWin%WinHeight
    }
    else
        WinMove ahk_id %MWin%,, %MWin%WinX, %MWin%WinY
}
Scale( MWin ) {
    global
    local w, h

    w:=%MWin%WinWidth * SCALEFACTOR,  h:=%MWin%WinHeight * SCALEFACTOR

    if (w > MINWIDTH AND h > MINHEIGHT)
         %MWin%WinX+=(%MWin%WinWidth-w)/2, %MWin%WinWidth := w,%MWin%WinY+=(%MWin%WinHeight-h)/2 , %MWin%WinHeight := h
}

Touch( MWin ) {
    global
    local mon
    mon := %MWin%Mon
    if (%MWin%WinY + %MWin%WinHeight >= WorkArea%Mon%Bottom)
        return "b"
    else if (%MWin%WinY <= WorkArea%Mon%Top)
        return "t"
    else if (%MWin%WinX <= WorkArea%Mon%Left)
        return "l"
    else if (%MWin%WinX + %MWin%WinWidth >= WorkArea%Mon%Right)
        return "r"

}

List( list, Item, Action="", Delim="`n" ) {
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
    list:=RegExReplace(list,"i)(\Q" . Delim . "\E) {2,}",Delim)    ;;∙------∙Replace succesive Delims.
    list:=RegExReplace(list,"i)^(\Q" . Delim . "\E)|(\Q" . Delim . "\E)$","")    ;;∙------∙Delete Delims from start and end of list.

    if Action = s
        list:=RegExReplace(list,"i)(\Q" . Item . "\E)(?:\Q" . Delim . "\E)*","$1" . Delim . Delim)

    if (Action = "s" || Action = "d" || RegExMatch(list, "i)(?:\Q" . Item . "\E)(?:\Q" . Delim . "\E)*"))    ;;∙------∙The rexexmatch assures we dont add an item twice.
        return list
    return Item . Delim . list    ;;∙------∙Prepend new items rather then apped makes it easier to debug lists.
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

