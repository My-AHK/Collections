
/*∙=====∙NOTES∙===============================================∙
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
; AutoHotkey v1.1 Script - Mouse Hexagon Movement
; Hotkey: Ctrl+T to move mouse in a hexagon at screen center

#NoEnv
#SingleInstance Force

; Variables for hexagon movement
hexagonRadius := 120       ; Radius of the hexagon (distance from center to vertex)
moveSpeed := 2             ; Movement speed in pixels per step
isHexagoning := false      ; Track if currently moving in hexagon
currentSide := 1           ; Which side of hexagon we're on (1 through 6)
progress := 0              ; Progress along current side (0 to 1)
clockwise := true          ; Direction: true = clockwise, false = counter-clockwise

; Function to get the center of the monitor containing the current mouse position
GetCurrentMonitorCenter(ByRef centerX, ByRef centerY) {
    ; Force coordinate mode to be screen-relative
    CoordMode, Mouse, Screen
    
    ; Get current mouse position in absolute screen coordinates
    MouseGetPos, mouseX, mouseY
    
    ; Get monitor count
    SysGet, monitorCount, MonitorCount
    
    ; Check each monitor to find which one contains the mouse
    Loop, %monitorCount% {
        SysGet, mon, Monitor, %A_Index%
        if (mouseX >= monLeft && mouseX < monRight && mouseY >= monTop && mouseY < monBottom) {
            ; Found the monitor containing the mouse
            centerX := monLeft + ((monRight - monLeft) // 2)
            centerY := monTop + ((monBottom - monTop) // 2)
            return
        }
    }
    
    ; Fallback: use primary monitor if mouse position detection fails
    SysGet, MonitorPrimary, MonitorPrimary
    SysGet, mon, Monitor, %MonitorPrimary%
    centerX := monLeft + ((monRight - monLeft) // 2)
    centerY := monTop + ((monBottom - monTop) // 2)
}

; Ctrl+T hotkey to start/stop hexagon movement
^t::
    if (isHexagoning) {
        ; Stop hexagon movement
        isHexagoning := false
        SetTimer, MoveInHexagon, Off
        ToolTip, Hexagon movement stopped
        SetTimer, RemoveToolTip, 2000
    } else {
        ; Start hexagon movement - determine center based on current mouse position
        GetCurrentMonitorCenter(centerX, centerY)
        
        ; Calculate hexagon vertices (6 points, starting from top and going clockwise)
        ; Each vertex is 60 degrees (π/3 radians) apart
        pi := 3.141592653589793
        
        ; Vertex 1: Top (0°)
        vertex1X := centerX + (hexagonRadius * Cos(0))
        vertex1Y := centerY + (hexagonRadius * Sin(0))
        
        ; Vertex 2: Top-right (60°)
        vertex2X := centerX + (hexagonRadius * Cos(pi/3))
        vertex2Y := centerY + (hexagonRadius * Sin(pi/3))
        
        ; Vertex 3: Bottom-right (120°)
        vertex3X := centerX + (hexagonRadius * Cos(2*pi/3))
        vertex3Y := centerY + (hexagonRadius * Sin(2*pi/3))
        
        ; Vertex 4: Bottom (180°)
        vertex4X := centerX + (hexagonRadius * Cos(pi))
        vertex4Y := centerY + (hexagonRadius * Sin(pi))
        
        ; Vertex 5: Bottom-left (240°)
        vertex5X := centerX + (hexagonRadius * Cos(4*pi/3))
        vertex5Y := centerY + (hexagonRadius * Sin(4*pi/3))
        
        ; Vertex 6: Top-left (300°)
        vertex6X := centerX + (hexagonRadius * Cos(5*pi/3))
        vertex6Y := centerY + (hexagonRadius * Sin(5*pi/3))
        
        isHexagoning := true
        currentSide := 1
        progress := 0
        ; Start at vertex 1 (top) using screen coordinates
        CoordMode, Mouse, Screen
        MouseMove, %vertex1X%, %vertex1Y%, 0
        SetTimer, MoveInHexagon, 10  ; Update every 10ms for smooth movement
        direction := clockwise ? "clockwise" : "counter-clockwise"
        ToolTip, Hexagon movement started %direction% (Ctrl+T to stop`, Ctrl+R to reverse)
        SetTimer, RemoveToolTip, 3000
    }
return

; Ctrl+R hotkey to reverse direction
^r::
    clockwise := !clockwise
    direction := clockwise ? "clockwise" : "counter-clockwise"
    if (isHexagoning) {
        ToolTip, Direction changed to %direction%
    } else {
        ToolTip, Direction set to %direction% (Ctrl+T to start)
    }
    SetTimer, RemoveToolTip, 2000
return

; Function to move mouse in hexagon
MoveInHexagon:
    if (!isHexagoning) {
        SetTimer, MoveInHexagon, Off
        return
    }
    
    ; Ensure we're using screen coordinates
    CoordMode, Mouse, Screen
    
    ; Calculate current position based on which side we're on and direction
    if (clockwise) {
        ; Clockwise movement: 1->2->3->4->5->6->1
        if (currentSide = 1) {
            ; Side 1: From vertex1 to vertex2
            currentX := vertex1X + (vertex2X - vertex1X) * progress
            currentY := vertex1Y + (vertex2Y - vertex1Y) * progress
        } else if (currentSide = 2) {
            ; Side 2: From vertex2 to vertex3
            currentX := vertex2X + (vertex3X - vertex2X) * progress
            currentY := vertex2Y + (vertex3Y - vertex2Y) * progress
        } else if (currentSide = 3) {
            ; Side 3: From vertex3 to vertex4
            currentX := vertex3X + (vertex4X - vertex3X) * progress
            currentY := vertex3Y + (vertex4Y - vertex3Y) * progress
        } else if (currentSide = 4) {
            ; Side 4: From vertex4 to vertex5
            currentX := vertex4X + (vertex5X - vertex4X) * progress
            currentY := vertex4Y + (vertex5Y - vertex4Y) * progress
        } else if (currentSide = 5) {
            ; Side 5: From vertex5 to vertex6
            currentX := vertex5X + (vertex6X - vertex5X) * progress
            currentY := vertex5Y + (vertex6Y - vertex5Y) * progress
        } else {
            ; Side 6: From vertex6 to vertex1
            currentX := vertex6X + (vertex1X - vertex6X) * progress
            currentY := vertex6Y + (vertex1Y - vertex6Y) * progress
        }
    } else {
        ; Counter-clockwise movement: 1->6->5->4->3->2->1
        if (currentSide = 1) {
            ; Side 1: From vertex1 to vertex6
            currentX := vertex1X + (vertex6X - vertex1X) * progress
            currentY := vertex1Y + (vertex6Y - vertex1Y) * progress
        } else if (currentSide = 2) {
            ; Side 2: From vertex6 to vertex5
            currentX := vertex6X + (vertex5X - vertex6X) * progress
            currentY := vertex6Y + (vertex5Y - vertex6Y) * progress
        } else if (currentSide = 3) {
            ; Side 3: From vertex5 to vertex4
            currentX := vertex5X + (vertex4X - vertex5X) * progress
            currentY := vertex5Y + (vertex4Y - vertex5Y) * progress
        } else if (currentSide = 4) {
            ; Side 4: From vertex4 to vertex3
            currentX := vertex4X + (vertex3X - vertex4X) * progress
            currentY := vertex4Y + (vertex3Y - vertex4Y) * progress
        } else if (currentSide = 5) {
            ; Side 5: From vertex3 to vertex2
            currentX := vertex3X + (vertex2X - vertex3X) * progress
            currentY := vertex3Y + (vertex2Y - vertex3Y) * progress
        } else {
            ; Side 6: From vertex2 to vertex1
            currentX := vertex2X + (vertex1X - vertex2X) * progress
            currentY := vertex2Y + (vertex1Y - vertex2Y) * progress
        }
    }
    
    ; Move mouse to current position using absolute screen coordinates
    MouseMove, %currentX%, %currentY%, 0
    
    ; Update progress (all sides of regular hexagon are equal length)
    progress += (moveSpeed / hexagonRadius)
    
    ; Check if we've completed current side
    if (progress >= 1.0) {
        progress := 0
        currentSide++
        if (currentSide > 6) {
            currentSide := 1  ; Loop back to first side
        }
    }
return

; Remove tooltip after delay
RemoveToolTip:
    ToolTip
    SetTimer, RemoveToolTip, Off
return

; ESC key to stop script entirely
Esc::ExitApp
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

