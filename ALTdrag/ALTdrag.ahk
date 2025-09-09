
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  Cobracrystal (AHK V2)
» Original Source:  https://discord.com/channels/115993023636176902/1325991318299873401
    ▹ https://github.com/Cobracrystal/ahk/blob/main/Demo_Scripts/AltDragStandalone.ahk
» Now converted to AHK v1.1
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "ALTdrag"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
;;∙============================================================∙

/*
∙------∙TRADITIONAL HOTKEYS∙-------------∙
 • Alt + Left Mouse Button: Click and drag to move a window around the screen.
 • Alt + Right Mouse Button: Click and drag to resize a window from any edge/corner.
 • Alt + Middle Mouse Button: Click to toggle between maximized and restored window state.
∙------∙NON-TRADITIONAL HOTKEYS∙------∙
 • Alt + Scroll Wheel Up: Scale the window up (make it larger) while maintaining aspect ratio.
 • Alt + Scroll Wheel Down: Scale the window down (make it smaller) while maintaining aspect ratio.
 • Alt + Mouse Back Button (X1): Click to minimize the window.
 • Alt + Mouse Forward Button (X2): Click to make the window enter borderless fullscreen mode.
∙------∙ADDITIONAL FEATURES∙-------------∙
 • Window Snapping: Windows will snap to monitor edges and other window edges while dragging or resizing (can be toggled in the system tray menu).
 • Window Alignment: Windows will align with other windows when snapping occurs during resize operations.
 • Smart Scaling: Scaling stops before reaching the actual maximum window size due to client area differences.
∙------∙NOTE∙------------------------------------∙
These hotkeys work on most windows but exclude certain system windows
(like the NVIDIA GeForce Overlay, taskbar, desktop background, etc.)
and don't work on minimized/maximized windows.
*/

;;∙======∙DIRECTIVEs∙============================∙
#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines -1
SetTitleMatchMode 2
SetWinDelay 0

AltDrag_Init()    ;;∙------∙ Initialize script & create tray menu item.

;;∙======∙🔥∙HOTKEYS∙🔥∙==========================∙
;;∙------∙Drag Window.
!LButton::    ;;∙------∙🔥∙(Alt + Left Mouse Button)
    AltDrag_moveWindow()
Return

;;∙------∙Resize Window.
!RButton::    ;;∙------∙🔥∙(Alt + Right Mouse Button)
    AltDrag_resizeWindow()
Return

;;∙------∙Toggle Max/Restore of clicked window.
!MButton::    ;;∙------∙🔥∙(Alt + Middle Mouse Button)
    AltDrag_toggleMaxRestore()
Return

;;∙------∙Scale Window Down.
!WheelDown::    ;;∙------∙🔥∙(Alt + WheelDown)
    AltDrag_scaleWindow(-1)
Return

;;∙------∙Scale Window Up.
!WheelUp::    ;;∙------∙🔥∙(Alt + WheelUp)
    AltDrag_scaleWindow(1)
Return

;;∙------∙Minimize Window.
!XButton1::    ;;∙------∙🔥∙(Alt + Mouse Back Button (X1))
    AltDrag_minimizeWindow()
Return

;;∙------∙Make Window Borderless Fullscreen.
!XButton2::    ;;∙------∙🔥∙(Alt + Mouse Forward Button (X2))
    AltDrag_borderlessFullscreenWindow()
Return

;;∙======∙CLASS INITIALIZATION∙===================∙
AltDrag_Init() {
    global
    if (AltDrag_initialized)
        return
    
    AltDrag_initialized := true
    #InstallMouseHook

/*
Note: Snapping can be toggled (both at once) in the tray menu.
Snapping to window edges includes all windows (that are actual windows on the desktop) with a window behind another, that can cause snapping to windows which aren't visible.
Aligning windows is only possible when resizing in the corresponding corner of the window.
*/
    AltDrag_snapToMonitorEdges := true
    AltDrag_snapToWindowEdges := true
    AltDrag_snapToAlignWindows := true
    AltDrag_snapOnlyWhileHoldingModifierKey := true    ;;∙------∙Snaps to edges/windows while holding alt.
    AltDrag_snappingRadius := 40    ;;∙------∙In pixels.
    AltDrag_aligningRadius := 40
    AltDrag_modifierKeyList := {"#": "LWin", "!": "Alt", "^": "Control", "+": "Shift"}
    AltDrag_blacklist := [""
        , "NVIDIA GeForce Overlay",
        , "ahk_class MultitaskingViewFrame ahk_exe explorer.exe",
        , "ahk_class Windows.UI.Core.CoreWindow",
        , "ahk_class WorkerW ahk_exe explorer.exe",
        , "ahk_class Progman ahk_exe explorer.exe",
        , "ahk_class Shell_TrayWnd ahk_exe explorer.exe",
        , "ahk_class Shell_SecondaryTrayWnd ahk_exe explorer.exe"]
    Menu, Tray, Add, Enable Snapping, AltDragSnappingToggle
    Menu, Tray, Check, Enable Snapping
    AltDrag_monitors := {}
}

;;∙======∙FUNCTION LIBRARY∙=====================∙
AltDrag_moveWindow(overrideBlacklist = false) {
    global AltDrag_snapToMonitorEdges, AltDrag_snapToWindowEdges, AltDrag_snapOnlyWhileHoldingModifierKey
    global AltDrag_snappingRadius, AltDrag_aligningRadius, AltDrag_modifierKeyList
    
    AltDrag_Init()
    
    ;;∙------∙Get initial mouse position and window handle
    CoordMode, Mouse, Screen
    MouseGetPos, mouseX1, mouseY1, wHandle
    WinGet, winState, MinMax, ahk_id %wHandle%
    
    if ((AltDrag_winInBlacklist(wHandle) && !overrideBlacklist) || winState != 0)
        return
    
    ;;∙------∙Get window position and size
    WinGetPos, winX, winY, winW, winH, ahk_id %wHandle%
    
    ;;∙------∙DEBUG: Show initial positions, then move.
    ;;∙------∙ToolTip, Window: %winX%`,%winY%  Size: %winW%x%winH%  Mouse: %mouseX1%`,%mouseY1%
    ;;∙------∙Sleep, 2000
    ;;∙------∙ToolTip
    
    ;;∙------∙Calculate mouse offset within the window
    offsetX := mouseX1 - winX
    offsetY := mouseY1 - winY
    
    WinActivate, ahk_id %wHandle%
    
    ;;∙------∙DRAGGING LOOP WITH SNAPPING
    while (GetKeyState("LButton", "P") && GetKeyState("Alt", "P")) {
        MouseGetPos, mouseX2, mouseY2
        
        ;;∙------∙Calculate new window position.
        newX := mouseX2 - offsetX
        newY := mouseY2 - offsetY
        
        ;;∙------∙Store original position before snapping.
        originalX := newX
        originalY := newY
        
        ;;∙------∙DEBUG: Show current position.
        ;;∙------∙ToolTip, New: %newX%`,%newY%  Mouse: %mouseX2%`,%mouseY2%
        ;;∙------∙Sleep, 2000
        ;;∙------∙ToolTip

        ;;∙------∙Apply snapping if enabled.
        if (AltDrag_snapToMonitorEdges) {
            AltDrag_calculateMonitorSnapping(newX, newY, winW, winH, wHandle)
        }
        
        ;;∙------∙Apply window snapping if enabled (only if monitor snapping didn't already snap)
        if (AltDrag_snapToWindowEdges && (newX = originalX && newY = originalY)) {
            AltDrag_calculateWindowSnapping(newX, newY, winW, winH, wHandle)
        }
        
        ;;∙------∙DEBUG: Show if snapping occurred.
        ;;∙------∙if (originalX != newX || originalY != newY)
        ;;∙------∙ToolTip, SNAPPED: %originalX%`,%originalY% -> %newX%`,%newY%
        
        ;;∙------∙Move the window.
        WinMove, ahk_id %wHandle%,, %newX%, %newY%
        
        Sleep, 10
    }
    
    ;;∙------∙ToolTip    ;;∙------∙Clear debug tooltip.
}

AltDrag_calculateMonitorSnapping(ByRef x, ByRef y, width, height, wHandle) {
    global AltDrag_snappingRadius
    
    ;;∙------∙Get monitor info for the CURRENT mouse position, not the window position.
    CoordMode, Mouse, Screen
    MouseGetPos, mouseX, mouseY
    monitorHandle := DllCall("MonitorFromPoint", "Int", mouseX, "Int", mouseY, "UInt", 0x2, "Ptr")
    monitor := AltDrag_monitorGetInfo(monitorHandle)
    
    ;;∙------∙Calculate distances to monitor edges.
    leftDist := abs(x - monitor.wLeft)
    rightDist := abs((x + width) - monitor.wRight)
    topDist := abs(y - monitor.wTop)
    bottomDist := abs((y + height) - monitor.wBottom)
    
    ;;∙------∙DEBUG: Show distances.
    ;;∙------∙ToolTip, Left: %leftDist%  Right: %rightDist%  Top: %topDist%  Bottom: %bottomDist%
    
    ;;∙------∙Only snap if within radius.
    if (leftDist <= AltDrag_snappingRadius) {
        x := monitor.wLeft
    } else if (rightDist <= AltDrag_snappingRadius) {
        x := monitor.wRight - width
    }
    
    if (topDist <= AltDrag_snappingRadius) {
        y := monitor.wTop
    } else if (bottomDist <= AltDrag_snappingRadius) {
        y := monitor.wBottom - height
    }
}

AltDrag_monitorGetInfo(monitorHandle) {
    VarSetCapacity(monitorInfo, 40, 0)
    NumPut(40, monitorInfo, 0, "UInt")
    if (DllCall("GetMonitorInfo", "Ptr", monitorHandle, "Ptr", &monitorInfo)) {
        return { left: NumGet(monitorInfo, 4, "Int")
                , top: NumGet(monitorInfo, 8, "Int")
                , right: NumGet(monitorInfo, 12, "Int")
                , bottom: NumGet(monitorInfo, 16, "Int")
                , wLeft: NumGet(monitorInfo, 20, "Int")
                , wTop: NumGet(monitorInfo, 24, "Int")
                , wRight: NumGet(monitorInfo, 28, "Int")
                , wBottom: NumGet(monitorInfo, 32, "Int")
                , flag: NumGet(monitorInfo, 36, "UInt") }
    }

    ;;∙------∙Fallback to primary monitor if GetMonitorInfo fails.
    SysGet, monitor, Monitor, 0
    return { left: monitorLeft
            , top: monitorTop
            , right: monitorRight
            , bottom: monitorBottom
            , wLeft: monitorLeft
            , wTop: monitorTop
            , wRight: monitorRight
            , wBottom: monitorBottom
            , flag: 1 }
}

AltDrag_calculateWindowSnapping(ByRef x, ByRef y, width, height, currentHandle) {
    global AltDrag_snappingRadius
    
    ;;∙------∙Get all other windows.
    otherWindows := AltDrag_getWindowRects(currentHandle)
    
    ;;∙------∙Find closest snap point.
    closestDist := AltDrag_snappingRadius + 1
    bestX := x
    bestY := y
    
    for index, win in otherWindows {
        ;;∙------∙Skip minimized windows and system windows - use traditional object syntax.
        winHwnd := win.hwnd    ;;∙------∙Extract the value first.
        WinGet, winState, MinMax, ahk_id %winHwnd%
        if (winState != 0 || AltDrag_winInBlacklist(winHwnd))
            continue
        
        ;;∙------∙Use traditional object syntax for all properties.
        winX := win.x
        winY := win.y
        winW := win.w
        winH := win.h
        
        ;;∙------∙Check horizontal snapping (left/right edges).
        if (Abs(y - winY) < height + AltDrag_snappingRadius && Abs((y + height) - (winY + winH)) < height + AltDrag_snappingRadius) {
            ;;∙------∙Left edge to right edge.
            dist := abs(x - (winX + winW))
            if (dist < closestDist) {
                closestDist := dist
                bestX := winX + winW
                bestY := y
            }
            
            ;;∙------∙Right edge to left edge.
            dist := abs((x + width) - winX)
            if (dist < closestDist) {
                closestDist := dist
                bestX := winX - width
                bestY := y
            }
        }
        
        ;;∙------∙Check vertical snapping (top/bottom edges).
        if (Abs(x - winX) < width + AltDrag_snappingRadius && Abs((x + width) - (winX + winW)) < width + AltDrag_snappingRadius) {
            ;;∙------∙Top edge to bottom edge.
            dist := abs(y - (winY + winH))
            if (dist < closestDist) {
                closestDist := dist
                bestX := x
                bestY := winY + winH
            }
            
            ;;∙------∙Bottom edge to top edge.
            dist := abs((y + height) - winY)
            if (dist < closestDist) {
                closestDist := dist
                bestX := x
                bestY := winY - height
            }
        }
    }
    
    ;;∙------∙Apply snapping if we found a close enough point.
    if (closestDist <= AltDrag_snappingRadius) {
        x := bestX
        y := bestY
    }
}

AltDrag_getWindowRects(exceptHandle) {
    windows := []
    WinGet, windowList, List
    
    Loop, %windowList% {
        hwnd := windowList%A_Index%
        if (hwnd = exceptHandle || AltDrag_winInBlacklist(hwnd))
            continue
            
        WinGet, winState, MinMax, ahk_id %hwnd%
        if (winState != 0)    ;;∙------∙Skip minimized/maximized windows.
            continue
            
        WinGetPos, x, y, w, h, ahk_id %hwnd%
        windows.Push({hwnd: hwnd, x: x, y: y, w: w, h: h})
    }
    
    return windows
}

AltDrag_resizeWindow(overrideBlacklist = false) {
    global AltDrag_snapToMonitorEdges, AltDrag_snapToWindowEdges, AltDrag_snapOnlyWhileHoldingModifierKey
    global AltDrag_snappingRadius, AltDrag_aligningRadius
    
    AltDrag_Init()
    SetWinDelay, -1
       if (!GetKeyState("Alt", "P") || !GetKeyState("RButton", "P"))
        return

    CoordMode, Mouse, Screen
    MouseGetPos, mouseX1, mouseY1, wHandle
    WinGet, winState, MinMax, ahk_id %wHandle%

    pos := AltDrag_WinGetPosEx(wHandle)
    curWindowPositions := AltDrag_getWindowRects(wHandle)
    WinActivate, ahk_id %wHandle%
    resizeLeft := (mouseX1 < pos.x + pos.w / 2)
    resizeUp := (mouseY1 < pos.y + pos.h / 2)
    limits := AltDrag_getMinMaxResizeCoords(wHandle)
    
    while (GetKeyState("Alt", "P") && GetKeyState("RButton", "P")) {
        MouseGetPos, mouseX2, mouseY2
        
        ;;∙------∙Only process if mouse actually moved.
        if (mouseX2 = mouseX1 && mouseY2 = mouseY1) {
            Sleep, 10
            continue
        }
        
        diffX := mouseX2 - mouseX1
        diffY := mouseY2 - mouseY1
        
        nx := pos.x
        ny := pos.y
        if resizeLeft
            nx += AltDrag_clamp(diffX, pos.w - limits.maxW, pos.w - limits.minW)
        if resizeUp
            ny += AltDrag_clamp(diffY, pos.h - limits.maxH, pos.h - limits.minH)
        
        nw := AltDrag_clamp(resizeLeft ? pos.w - diffX : pos.w + diffX, limits.minW, limits.maxW)
        nh := AltDrag_clamp(resizeUp ? pos.h - diffY : pos.h + diffY, limits.minH, limits.maxH)
        
        ;;∙------∙Apply snapping only if modifier condition is met.
        if (!AltDrag_snapOnlyWhileHoldingModifierKey || GetKeyState(modSymbol)) {
            originalX := nx, originalY := ny, originalW := nw, originalH := nh
            
            if AltDrag_snapToMonitorEdges
                AltDrag_calculateResizeMonitorSnapping(nx, ny, nw, nh, resizeLeft, resizeUp, wHandle)
            
            if AltDrag_snapToWindowEdges
                AltDrag_calculateResizeWindowSnapping(nx, ny, nw, nh, resizeLeft, resizeUp, curWindowPositions)
        }
        
        WinMove, ahk_id %wHandle%,, % (nx - pos.LB), % (ny - pos.TB), % (nw + pos.LB + pos.RB), % (nh + pos.TB + pos.BB)
        DllCall("Sleep", "UInt", 5)
    }
}

AltDrag_calculateResizeMonitorSnapping(ByRef nx, ByRef ny, ByRef nw, ByRef nh, resizeLeft, resizeUp, wHandle) {
    global AltDrag_snappingRadius
    monitor := AltDrag_monitorGetInfoFromWindow(wHandle)
    if (resizeLeft && abs(nx - monitor.wLeft) < AltDrag_snappingRadius) {
        nw := nw + nx - monitor.wLeft
        nx := monitor.wLeft
    } else if (abs(nx + nw - monitor.wRight) < AltDrag_snappingRadius)
        nw := monitor.wRight - nx
    if (resizeUp && abs(ny - monitor.wTop) < AltDrag_snappingRadius) {
        nh := nh + ny - monitor.wTop
        ny := monitor.wTop    ;;∙------∙Top edge.
    } else if (abs(ny + nh - monitor.wBottom) < AltDrag_snappingRadius)
        nh := monitor.wBottom - ny
}

AltDrag_calculateResizeWindowSnapping(ByRef nx, ByRef ny, ByRef nw, ByRef nh, resizeLeft, resizeUp, curWindowPositions) {
    global AltDrag_snappingRadius, AltDrag_aligningRadius, AltDrag_snapToAlignWindows
    
    Loop % curWindowPositions.Length() {
        win := curWindowPositions[A_Index]
        if (AltDrag_isClamped(ny, win.y, win.y2) || AltDrag_isClamped(win.y, ny, ny + nh)) {
            if (resizeLeft && (abs(nx - win.x2) < AltDrag_snappingRadius)) {    ;;∙------∙Left edge of moving window to right edge of desktop window.
                nw := nw + nx - win.x2
                nx := win.x2
                if (AltDrag_snapToAlignWindows) {
                    if (resizeUp && abs(ny - win.y) < AltDrag_aligningRadius) {
                        nh := nh + ny - win.y
                        ny := win.y
                    } else if (abs(ny + nh - win.y2) < AltDrag_aligningRadius) {
                        nh := win.y2 - ny
                    }
                }
            } else if (abs(nx + nw - win.x) < AltDrag_snappingRadius) {    ;;∙------∙Right edge to left edge.
                nw := win.x - nx
                if (AltDrag_snapToAlignWindows) {
                    if (resizeUp && abs(ny - win.y) < AltDrag_aligningRadius) {
                        nh := nh + ny - win.y
                        ny := win.y
                    } else if (abs(ny + nh - win.y2) < AltDrag_aligningRadius) {
                        nh := win.y2 - ny
                    }
                }
            }
        }
        if (AltDrag_isClamped(nx, win.x, win.x2) || AltDrag_isClamped(win.x, nx, nx + nw)) {
            if (resizeUp && (abs(ny - win.y2) < AltDrag_snappingRadius)) {    ;;∙------∙Top edge to bottom edge.
                nh := nh + ny - win.y2
                ny := win.y2
                if (AltDrag_snapToAlignWindows) {
                    if (resizeLeft && abs(nx - win.x) < AltDrag_aligningRadius) {
                        nw := nw + nx - win.x
                        nx := win.x
                    } else if (abs(nx + nw - win.x2) < AltDrag_aligningRadius) {
                        nw := win.x2 - nx
                    }
                }
            } else if (abs(ny + nh - win.y) < AltDrag_snappingRadius) {
                nh := win.y - ny
                if (AltDrag_snapToAlignWindows) {
                    if (resizeLeft && abs(nx - win.x) < AltDrag_aligningRadius) {
                        nw := nw + nx - win.x
                        nx := win.x
                    } else if (abs(nx + nw - win.x2) < AltDrag_aligningRadius) {
                        nw := win.x2 - nx
                    }
                }
            }
        }
    }
}

AltDrag_scaleWindow(direction = 1, scale_factor = 1.1, wHandle = 0, overrideBlacklist = false) {
    AltDrag_Init()
    
    if (!wHandle) {
        MouseGetPos,,, wHandle
    }
    
    WinGet, mmx, MinMax, ahk_id %wHandle%
    if ((AltDrag_winInBlacklist(wHandle) && !overrideBlacklist) || mmx != 0) {
        return
    }
    
    ;;∙------∙Get current window position and size.
    WinGetPos, currentX, currentY, currentW, currentH, ahk_id %wHandle%
    
    ;;∙------∙Calculate the center point of the window.
    centerX := currentX + (currentW / 2)
    centerY := currentY + (currentH / 2)
    
    ;;∙------∙Calculate new dimensions.
    if (direction == 1) {
        ;;∙------∙Scale up.
        newW := Round(currentW * scale_factor)
        newH := Round(currentH * scale_factor)
    } else {
        ;;∙------∙Scale down.
        newW := Round(currentW / scale_factor)
        newH := Round(currentH / scale_factor)
    }
    
    ;;∙------∙Get size limits to prevent scaling too small or too large.
    limits := AltDrag_getMinMaxResizeCoords(wHandle)
    newW := Max(Min(newW, limits.maxW), limits.minW)
    newH := Max(Min(newH, limits.maxH), limits.minH)
    
    ;;∙------∙If we hit the limits, don't resize.
    if (newW == currentW && newH == currentH) {
        return
    }

    ;;∙------∙Calculate new position to keep window centered.
    newX := centerX - (newW / 2)
    newY := centerY - (newH / 2)
    
    ;;∙------∙Move and resize the window.
    WinMove, ahk_id %wHandle%,, %newX%, %newY%, %newW%, %newH%
}

AltDrag_minimizeWindow(overrideBlacklist = false) {
    AltDrag_Init()
    MouseGetPos,,, wHandle
    if (AltDrag_winInBlacklist(wHandle) && !overrideBlacklist)
        return
    WinMinimize, ahk_id %wHandle%
}

AltDrag_maximizeWindow(overrideBlacklist = false) {
    AltDrag_Init()
    MouseGetPos,,, wHandle
    if (AltDrag_winInBlacklist(wHandle) && !overrideBlacklist)
        return
    WinMaximize, ahk_id %wHandle%
}

AltDrag_toggleMaxRestore(overrideBlacklist = false) {
    AltDrag_Init()
    MouseGetPos,,, wHandle
    if (AltDrag_winInBlacklist(wHandle) && !overrideBlacklist)
        return
    WinGet, win_mmx, MinMax, ahk_id %wHandle%
    if (win_mmx)
        WinRestore, ahk_id %wHandle%
    else {
        if (AltDrag_isBorderlessFullscreen(wHandle))
            AltDrag_resetWindowPosition(wHandle, 5/7)
        else
            WinMaximize, ahk_id %wHandle%
    }
}

AltDrag_borderlessFullscreenWindow(wHandle = 0, overrideBlacklist = false) {
    AltDrag_Init()
    static BorderlessWindows := {}    ;;∙------∙Store original styles and positions.
    
    if (!wHandle) {
        MouseGetPos,,, wHandle
    }
    
    if (AltDrag_winInBlacklist(wHandle) && !overrideBlacklist) {
        return
    }
    
    ;;∙------∙Check if the window is already in our borderless mode.
    if (BorderlessWindows.HasKey(wHandle)) {
        ;;∙------∙RESTORE to original state.
        original := BorderlessWindows[wHandle]
        WinSet, Style, % original.Style, ahk_id %wHandle%
        WinSet, ExStyle, % original.ExStyle, ahk_id %wHandle%
        WinMove, ahk_id %wHandle%,, % original.X, % original.Y, % original.W, % original.H
        BorderlessWindows.Delete(wHandle)    ;;∙------∙Remove from tracking.
        SoundBeep, 1000, 200    ;;∙------∙Restore.
    } else {
        ;;∙------∙ENTER borderless fullscreen.
        ;;∙------∙Store original state.
        WinGet, OldStyle, Style, ahk_id %wHandle%
        WinGet, OldExStyle, ExStyle, ahk_id %wHandle%
        WinGetPos, OldX, OldY, OldW, OldH, ahk_id %wHandle%
        
        BorderlessWindows[wHandle] := {Style: OldStyle, ExStyle: OldExStyle, X: OldX, Y: OldY, W: OldW, H: OldH}
        
        ;;∙------∙Get monitor info and maximize.
        monitor := AltDrag_monitorGetInfoFromWindow(wHandle)
        WinMove, ahk_id %wHandle%,, % monitor.wLeft, % monitor.wTop, % monitor.wRight - monitor.wLeft, % monitor.wBottom - monitor.wTop
        
        ;;∙------∙Remove borders and title bar.
        WinSet, Style, -0xC00000, ahk_id %wHandle%    ;;∙------∙Remove WS_CAPTION (title bar).
        WinSet, Style, -0x800000, ahk_id %wHandle%    ;;∙------∙Remove WS_BORDER.
        SoundBeep, 1500, 200    ;;∙------∙Fullscreen.
    }
}

AltDrag_isBorderlessFullscreen(wHandle) {
    AltDrag_Init()
    WinGetPos, x, y, w, h, ahk_id %wHandle%

    ;;∙------∙Replacement for WinGetClientPos.
    VarSetCapacity(rc, 16, 0)
    DllCall("GetClientRect", "ptr", wHandle, "ptr", &rc)
    cw := NumGet(rc, 8, "int")
    ch := NumGet(rc, 12, "int")
    VarSetCapacity(pt, 8, 0)
    DllCall("ClientToScreen", "ptr", wHandle, "ptr", &pt)
    cx := NumGet(pt, 0, "int")
    cy := NumGet(pt, 4, "int")

    mHandle := DllCall("MonitorFromWindow", "Ptr", wHandle, "UInt", 0x2, "Ptr")
    mon := AltDrag_monitorGetInfo(mHandle)
    if (mon.left == cx && mon.top == cy && mon.right == mon.left + cw && mon.bottom == mon.top + ch)
        return true
    else
        return false
}

AltDrag_resetWindowPosition(wHandle = 0, sizePercentage = 0.7142857) {
    AltDrag_Init()
    if (!wHandle)
        wHandle := WinExist("A")
    monitor := AltDrag_monitorGetInfoFromWindow(wHandle)
    WinRestore, ahk_id %wHandle%
    mWidth := monitor.right - monitor.left, mHeight := monitor.bottom - monitor.top
    WinMove, ahk_id %wHandle%,, % monitor.left + mWidth / 2 * (1 - sizePercentage), % monitor.top + mHeight / 2 * (1 - sizePercentage), % mWidth * sizePercentage, % mHeight * sizePercentage
}

AltDrag_winInBlacklist(wHandle) {
    AltDrag_Init()
    for index, e in AltDrag_blacklist {
        WinGetTitle, winTitle, ahk_id %wHandle%
        if ((e != "" && WinExist(e " ahk_id " wHandle)) || (e == "" && winTitle == ""))
            return 1
    }
    return 0
}

AltDrag_monitorGetInfoFromWindow(wHandle, cache = true) {
    AltDrag_Init()
    monitorHandle := DllCall("MonitorFromWindow", "Ptr", wHandle, "UInt", 0x2, "Ptr")
    if (cache) {
        if !AltDrag_monitors.HasKey(monitorHandle) 
            AltDrag_monitors[monitorHandle] := AltDrag_monitorGetInfo(monitorHandle)
        return AltDrag_monitors[monitorHandle]
    }
    return AltDrag_monitorGetInfo(monitorHandle)
}

AltDrag_WinGetPosEx(hwnd) {
    AltDrag_Init()
    static S_OK := 0x0
    static DWMWA_EXTENDED_FRAME_BOUNDS := 9
    VarSetCapacity(rect, 16, 0)
    VarSetCapacity(rectExt, 24, 0)
    DllCall("GetWindowRect", "Ptr", hwnd, "Ptr", &rect)
    try {
        DWMRC := DllCall("dwmapi\DwmGetWindowAttribute", "Ptr", hwnd, "UInt", DWMWA_EXTENDED_FRAME_BOUNDS, "Ptr", &rectExt, "UInt", 16, "UInt")
    } catch {
        return 0
    }
    L := NumGet(rectExt,  0, "Int")
    T := NumGet(rectExt,  4, "Int")
    R := NumGet(rectExt,  8, "Int")
    B := NumGet(rectExt, 12, "Int")
    leftBorder        := L - NumGet(rect,  0, "Int")
    topBorder        := T - NumGet(rect,  4, "Int")
    rightBorder        :=        NumGet(rect,  8, "Int") - R
    bottomBorder    :=        NumGet(rect, 12, "Int") - B
    return { x: L, y: T, w: R - L, h: B - T, LB: leftBorder, TB: topBorder, RB: rightBorder, BB: bottomBorder}
}

AltDrag_getMinMaxResizeCoords(hwnd) {
    AltDrag_Init()
    static WM_GETMINMAXINFO := 0x24
    static SM_CXMINTRACK := 34, SM_CYMINTRACK := 35, SM_CXMAXTRACK := 59, SM_CYMAXTRACK := 60
    SysGet, sysMinWidth, % SM_CXMINTRACK
    SysGet, sysMinHeight, % SM_CYMINTRACK
    SysGet, sysMaxWidth, % SM_CXMAXTRACK
    SysGet, sysMaxHeight, % SM_CYMAXTRACK
    VarSetCapacity(MINMAXINFO, 40, 0)
    SendMessage, % WM_GETMINMAXINFO, , &MINMAXINFO, , ahk_id %hwnd%
    minWidth  := NumGet(MINMAXINFO, 24, "Int")
    minHeight := NumGet(MINMAXINFO, 28, "Int")
    maxWidth  := NumGet(MINMAXINFO, 32, "Int")
    maxHeight := NumGet(MINMAXINFO, 36, "Int")
    
    minWidth  := Max(minWidth, sysMinWidth)
    minHeight := Max(minHeight, sysMinHeight)
    maxWidth  := maxWidth == 0 ? sysMaxWidth : maxWidth
    maxHeight := maxHeight == 0 ? sysMaxHeight : maxHeight
    return { minW: minWidth, minH: minHeight, maxW: maxWidth, maxH: maxHeight }
}

AltDrag_snappingToggle() {
    global AltDrag_snapToMonitorEdges, AltDrag_snapToWindowEdges
    AltDrag_Init()
    
    ;;∙------∙Toggle both snapping options.
    AltDrag_snapToMonitorEdges := !AltDrag_snapToMonitorEdges
    AltDrag_snapToWindowEdges := !AltDrag_snapToWindowEdges
    
    ;;∙------∙Update tray menu checkmark.
    if (AltDrag_snapToMonitorEdges) {
        Menu, Tray, Check, Enable Snapping
        TrayTip, AltDrag, Snapping ENABLED, 1, 1
    } else {
        Menu, Tray, Uncheck, Enable Snapping
        TrayTip, AltDrag, Snapping DISABLED, 1, 1
    }
}

AltDrag_clamp(n, minimum, maximum) {
    return Max(minimum, Min(n, maximum))
}

AltDrag_isClamped(n, minimum, maximum) {
    return (n <= maximum && n >= minimum)
}

AltDrag_sendKey(hkey) {
    AltDrag_Init()
    if (!hkey)
        return
    if (hkey = "WheelDown" || hkey = "WheelUp")
        hkey := "{" hkey "}"
    if (hkey = "LButton" || hkey = "RButton" || hkey = "MButton") {
        StringLeft, hhL, hkey, 1
        Click, Down %hhL%
        Hotkey, *%hkey% Up, AltDragSendClickUp, On
    } else
        Send, {Blind}%hkey%
    return 0
}

AltDrag_sendClickUp:
    ;;∙------∙Extract the button name from the hotkey (e.g., "LButton" from "*LButton Up").
    buttonName := RegExReplace(A_ThisHotkey, "^\*| Up$")
    Click, Up %buttonName%
    Hotkey, %A_ThisHotkey%, Off
Return

;;∙------∙Separate function for the tray menu callback.
AltDragSnappingToggle:
    AltDrag_snappingToggle()
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
ALTdrag:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

