
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙--------∙Origins∙-------------------------∙
» Author:  Helgef
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?f=6&t=30622
» Script for making a see-through shaped hole to the window under the mouse. 
    ▹ The center of the hole follows the mouse.
    ▹ The hole can be inverted.
∙--------∙How To Use∙-------------------∙
» Hotkeys:
  • Esc,exit script. Restores the window first, if needed.
  • F1 Toggle on/off.
  • F2 Toggle inverted setting when the toggle is on.
  • F3 Toggle pause when the toggle is on. When paused, the hole doesn't follow the mouse.
  • WheelUp Increases the radius of the hole
  • WheelDown Decreases the radius of the hole
∙--------∙Optional Setup∙---------------∙
    * At the top of the script, these settings can be changed...
  • Radius, the starting radius of the circle.
  • Increment the amount to decrease/increase radius of circle when turning the scroll wheel.
  • Inverted, If false, the region is see-throughable.
  • Rate, the period (ms) of the timer.
  ** For changing the shape of the hole, modify region, it should an array where each element is a pair of coordinates which forms a shape with closed boundary, eg, region:=[{x:x0,y:y0},{x:x1,y:y1},...,{x:xn,y:yn},{x:x0,y:y0}], where xk,yk are integers.
∙--------------------------------------------∙
  * * See 'just me' posting for additional Functions...
https://www.autohotkey.com/boards/viewtopic.php?f=6&t=30622#p143283
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "MouseViews"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
;;∙------∙Note: Exit script with Esc::
OnExit("exit")

;;∙------∙Settings∙------------------------∙
radius:=67    ;;∙------∙Starting radius of the hole.
increment:=10    ;;∙------∙Amount to decrease/increase circle radius using scroll wheel.
inverted:=false    ;;∙------∙If false, region is see-throughable.
rate:=40    ;;∙------∙The period (ms) of the timer. 40 ms is 25 "fps".

;;∙------∙Make the region.
region:=makeCircle(radius) 

;;∙------∙ScriptSettings
SetWinDelay,-1
listlines, off    ;;∙------∙Remove when debugging.


;;∙------∙🔥∙HOTKEYS∙🔥∙------∙
F1::timer(toggle:=!toggle,region,inverted,rate),pause:=0    ;;∙------∙Toggle on/off.
#if toggle

F2::timer(1,region,inverted:=!inverted,rate),pause:=0    ;;∙------∙When on, toggle inverted setting.

F3::timer((pause:=!pause)?-1:1)    ;;∙------∙When on, toggle pause.
return
WheelUp::    ;;∙------∙Increase circle radius.
WheelDown::    ;;∙------∙Decrease circle radius.
    InStr(A_ThisHotkey,"Up") ? radius+=increment : radius-=increment
    radius<1 ? radius:=1 : ""    ;;∙------∙Ensure greater than 0 radius.
    region:=makeCircle(radius)
    timer(1,region,inverted)
Return
#if

esc::exit()    ;;∙------∙Exit script with Esc::
exit(){
    timer(0)    ;;∙------∙For restoring window if region applied when script closes.
    ExitApp
    return
}

timer(state,region:="",inverted:=false,rate:=50){
;;∙------∙Call with state=0 to restore window and stop timer, state=-1 stop timer but do not restore
;;∙------∙region, inverted, see WinSetRegion()
;;∙------∙rate, the period of the timer.
    static timerFn, paused, hWin, aot
    if (state=0) {    ;;∙------∙Restore window and turn off timer
        if timerFn
            SetTimer,% timerFn, Off
        if !hWin
            return                                                
        WinSet, Region,, % "ahk_id " hWin
        if !aot    ;;∙------∙Restore not being aot if appropriate.
            WinSet, AlwaysOnTop, off, % "ahk_id " hWin
        hWin:="",timerFn:="",aot:="",paused:=0
        return
    } else if (timerFn) {    ;;∙------∙Pause/unpause or... 
        if (state=-1) {
            SetTimer,% timerFn, Off
            return paused:=1
        } else if paused {
            SetTimer,% timerFn, On
            return paused:=0
        } else {    ;;∙------∙Stop timer before starting a new one.
            SetTimer,% timerFn, Off
        }
    }
    if !hWin {    ;;∙------∙Get the window under the mouse.
        MouseGetPos,,,hWin
        WinGet, aot, ExStyle, % "ahk_id " hWin    ;;∙------∙Get always-on-top state, to preserve it.
        aot&=0x8
        if !aot
            WinSet, AlwaysOnTop, On, % "ahk_id " hWin
    }
    timerFn:=Func("timerFunction").Bind(hWin,region,inverted)    ;;∙------∙Initialize the timer.
    timerFn.Call(1)    ;;∙------∙For better responsiveness, 1 is for reset static.
    SetTimer, % timerFn, % rate
    return
}

timerFunction(hWin,region,inverted,resetStatic:=0){
    ;;∙------∙Get mouse position and convert coords to win coordinates, for displacing the circle.
    static px,py
    WinGetPos,wx,wy,,, % "ahk_id " hWin
    CoordMode, Mouse, Screen
    MouseGetPos,x,y
    x-=wx,y-=wy
    if (x=px && y=py && !resetStatic)
        return
    else 
        px:=x,py:=y
    WinSetRegion(hWin,region,x,y,inverted)
    
    return
}

WinSetRegion(hWin,region,dx:=0,dy:=0,inverted:=false){
;;∙------∙hWin, handle to the window to apply region to.
;;∙------∙Region should be on the form, region:=[{x:x0,y:y0},{x:x1,y:y1},...,{x:xn,y:yn},{x:x0,y:y0}]
;;∙------∙dx,dy is displacing the the region by fixed amount in x and y direction, respectively.
;;∙------∙inverted=true, make the region the only part visible, vs the only part see-throughable for inverted=false
    if !inverted {
        WinGetPos,,,w,h, % "ahk_id " hWin
        regionDefinition.= "0-0 0-" h " " w "-" h " " w "-0 " "0-0 "
    }
    for k, pt in region
        regionDefinition.= dx+pt.x "-" dy+pt.y " "
    WinSet, Region, % regionDefinition, % "ahk_id " hWin
}

;;∙------∙Function for making the circle
makeCircle(r:=100,n:=-1){
    ;;∙------∙r is the radius.
    ;;∙------∙n is the number of points, let n=-1 to set automatically (highest quality).
    static pi:=atan(1)*4
    pts:=[]
    n:= n=-1 ? Ceil(2*r*pi) : n
    n:= n>=1994 ? 1994 : n    ;;∙------∙There is a maximum of 2000 points for WinSet,Region,...
    loop, % n+1
        t:=2*pi*(A_Index-1)/n, pts.push({x:round(r*cos(t)),y:round(r*sin(t))})
    return pts
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
MouseViews:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

