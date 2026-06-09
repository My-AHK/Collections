

SetTimer, UpdateCheck, 500
GoSub, TrayMenu
;;∙---------------------------------------------------------------------∙



;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙


;;∙==============================================∙




/*∙======∙🔥∙HOTKEYS USED∙🔥∙====================∙
∙--------∙INCREASE OPACITY∙-----------∙(↑)
^!WheelUp::    ;;∙------∙(Ctrl + Alt + WheelUp)
^!Up::         ;;∙------∙(Ctrl + Alt + Up Arrow)

∙--------∙DECREASE OPACITY∙-----------∙(↓)
^!WheelDown::   ;;∙------∙(Ctrl + Alt + WheelDown)
^!Down::        ;;∙------∙(Ctrl + Alt + Down Arrow)

∙--------∙RESET∙----------------------------∙(↩)
^!MButton::     ;;∙------∙(Ctrl + Alt + MButton)
^!r::           ;;∙------∙(Ctrl + Alt + R)
∙--------∙& TOGGLE∙-----------------------∙(↔)
^!T::           ;;∙------∙(Ctrl + Alt + T) Toggle.

∙--------∙ALWAYS-ON-TOP∙--------------∙(⊤)
^!a::    ;;∙------∙(Ctrl + Alt + A)

∙--------∙CLEANUP & EXIT∙---------------∙
^!Esc::    ;;∙------∙(Ctrl + Alt + Esc)
∙--------------------------------------------------------------∙
*/

;;∙======∙DIRECTIVES & SETTINGS∙==================∙

#Requires AutoHotkey 1
#NoEnv
#SingleInstance, Force
SetBatchLines -1
SetWinDelay 0
Menu, Tray, Icon, imageres.dll, 255
Menu, Tray, Tip, OPACITY

;;∙------∙User opacity settings (set as percentages, 0–100).
maxOpacity  := 100    ;;∙------∙Fully opaque ceiling & reset value.
minOpacity  := 10    ;;∙------∙Floor, keeps window minimally visible.
opacityStep := 5    ;;∙------∙Per-tick increment/decrement amount.
opacityDefaultToggle := 70    ;;∙------∙Default toggle target when no previous transparency level is stored.

;;∙------∙User Always-On-Top appearance settings. 
aotText := "Always On Top"    ;;∙------∙Always-On-Top indicator text.
aotTextColor := "Lime"    ;;∙------∙Always-On-Top indicator text color.
aotTrimColor := "Red"    ;;∙------∙Always-On-Top indicator trim color.
aotBkGrnd := "0000FF"    ;;∙------∙Always-On-Top indicator background color.
aotBgTrans := False    ;;∙------∙Make Always-On-Top indicator background transparent (True/False).

;;∙====∙Base settings (leave as is).
opacity := {}    ;;∙------∙Track opacity per window handle (% scale, 0–100).
lastOpacity := {}    ;;∙------∙Store last non-full opacity for toggle restore.
alwaysOnTop := {}    ;;∙------∙Track Always-On-Top state per window handle (0 or 1).
aotGuis := {}    ;;∙------∙Track indicator Gui name per window handle.
aotGuiWidths := {}    ;;∙------∙Store indicator Gui width per window handle for centering.
aotGuiHeights := {}    ;;∙------∙Store indicator Gui height per window handle for trimming.
aotGuiCount := 0    ;;∙------∙Incrementing counter for unique Gui names.
SetTimer, CleanOpacityTable, 60000    ;;∙------∙Remove tracking entries for closed windows every 60-seconds.
SetTimer, AlwaysOnTopIndicator, 100    ;;∙------∙Reposition Always-On-Top indicator Guis each tick.
OnExit, ExitCleanup    ;;∙------∙Restore all window opacities on script exit.
;;∙---------------------------------------------------------------------∙


;;∙======∙HOTKEYS∙===============================∙

;;∙---------∙(↑)∙🔥∙INCREASE∙🔥∙(↑)∙------------------∙
^!WheelUp::    ;;∙------∙(Ctrl + Alt + WheelUp) Increase.
^!Up::    ;;∙------∙(Ctrl + Alt + Up Arrow) Increase.
    WinGet, hwnd, ID, A
    if !hwnd    ;;∙------∙No active window found (WinGet returns 0 or "" on failure).
    {
        ToolTip, ! No active window found !
        SetTimer, KillTip, -1500
        return
    }
    if !WinExist("ahk_id " hwnd)    ;;∙------∙Window closed between calls, abort.
        return
    Gosub, VerifyOpacity
    opacity[hwnd] += opacityStep
    if (opacity[hwnd] > maxOpacity)
        opacity[hwnd] := maxOpacity    ;;∙------∙Cap at fully opaque.
    WinSet, Transparent, % Round(opacity[hwnd] / 100 * 255), ahk_id %hwnd%
    if ErrorLevel
    {
        ToolTip, Cannot modify this window's opacity
        SetTimer, KillTip, -1500
        return
    }
    if (opacity[hwnd] < maxOpacity)    ;;∙------∙Remember last non-full value for toggle.
        lastOpacity[hwnd] := opacity[hwnd]
    Gosub, OpacityToolTip    ;;∙------∙Visual feedback of current opacity.
Return

;;∙---------∙(↓)∙🔥∙DECREASE∙🔥∙(↓)∙------------------∙
^!WheelDown::    ;;∙------∙(Ctrl + Alt + WheelDown) Decrease.
^!Down::    ;;∙------∙(Ctrl + Alt + Down Arrow) Decrease.
    WinGet, hwnd, ID, A
    if !hwnd    ;;∙------∙No active window found (WinGet returns 0 or "" on failure).
    {
        ToolTip, ! No active window found !
        SetTimer, KillTip, -1500
        return
    }
    if !WinExist("ahk_id " hwnd)    ;;∙------∙Window closed between calls, abort.
        return
    Gosub, VerifyOpacity
    opacity[hwnd] -= opacityStep
    if (opacity[hwnd] < minOpacity)    ;;∙------∙Floor at minOpacity% to keep window minimally visible.
        opacity[hwnd] := minOpacity
    WinSet, Transparent, % Round(opacity[hwnd] / 100 * 255), ahk_id %hwnd%
    if ErrorLevel
    {
        ToolTip, Cannot modify this window's opacity
        SetTimer, KillTip, -1500
        return
    }
    if (opacity[hwnd] < maxOpacity)    ;;∙------∙Remember last non-full value for toggle.
        lastOpacity[hwnd] := opacity[hwnd]
    Gosub, OpacityToolTip    ;;∙------∙Visual feedback of current opacity.
Return

;;∙---------∙(↩)∙🔥∙RESET & TOGGLE∙🔥∙(↔)∙---------∙
^!MButton::    ;;∙------∙(Ctrl + Alt + MButton) Reset.
^!r::    ;;∙------∙(Ctrl + Alt + R) Reset.
^!T::    ;;∙------∙(Ctrl + Alt + T) Toggle.
    WinGet, hwnd, ID, A
    if !hwnd    ;;∙------∙No active window found (WinGet returns 0 or "" on failure).
    {
        ToolTip, ! No active window found !
        SetTimer, KillTip, -1500
        return
    }
    if !WinExist("ahk_id " hwnd)    ;;∙------∙Window closed between calls, abort.
        return
    Gosub, VerifyOpacity
    ;;∙------∙Determine if this is a reset (A_ThisHotkey = "^!r" or "^!MButton") or a toggle.
    isReset := (A_ThisHotkey = "^!r") || (A_ThisHotkey = "^!MButton")
    if (isReset || opacity[hwnd] = maxOpacity)    ;;∙------∙Reset hotkey OR currently fully opaque, perform reset or toggle-to-transparency action.
    {
        if (isReset && opacity[hwnd] = maxOpacity)    ;;∙------∙Already at full with reset key, nothing to do.
        {
            ToolTip, Opacity: 100`%`n (already reset)
            SetTimer, KillTip, -1500
            return
        }
        if (isReset)    ;;∙------∙Reset hotkey, go to full opacity.
        {
            opacity[hwnd] := maxOpacity
            lastOpacity.Delete(hwnd)    ;;∙------∙Clear toggle memory on reset.
            WinSet, Transparent, % Round(maxOpacity / 100 * 255), ahk_id %hwnd%
            if ErrorLevel
            {
                ToolTip, Cannot modify this window's opacity
                SetTimer, KillTip, -1500
                return
            }
            ToolTip, Opacity: 100`%`n (Reset)
        }
        else    ;;∙------∙Toggle hotkey: switch to stored/default transparency level.
        {
            targetOpacity := lastOpacity.HasKey(hwnd) ? lastOpacity[hwnd] : opacityDefaultToggle    ;;∙------∙Restore last or default to opacityDefaultToggle%.
            opacity[hwnd] := targetOpacity
            WinSet, Transparent, % Round(targetOpacity / 100 * 255), ahk_id %hwnd%
            if ErrorLevel
            {
                ToolTip, Cannot modify this window's opacity
                SetTimer, KillTip, -1500
                return
            }
            ToolTip, % "Opacity: " targetOpacity "%`n (Toggled)"
        }
    }
    else    ;;∙------∙Toggle hotkey & currently below full opacity, restore to full.
    {
        lastOpacity[hwnd] := opacity[hwnd]    ;;∙------∙Remember this level for next toggle.
        opacity[hwnd] := maxOpacity
        WinSet, Transparent, % Round(maxOpacity / 100 * 255), ahk_id %hwnd%
        if ErrorLevel
        {
            ToolTip, Cannot modify this window's opacity
            SetTimer, KillTip, -1500
            return
        }
        ToolTip, Opacity: 100`%`n (Toggled)
    }
    SetTimer, KillTip, -1500
Return

;;∙--------------∙(⊤)∙🔥∙ALWAYS ON TOP∙🔥∙(⊤)∙----------------∙
^!a::    ;;∙------∙(Ctrl + Alt + A) Toggle always-on-top for the active window.
    WinGet, hwnd, ID, A
    if !hwnd    ;;∙------∙No active window found (WinGet returns 0 or "" on failure).
    {
        ToolTip, ! No active window found !
        SetTimer, KillTip, -1500
        return
    }
    if !WinExist("ahk_id " hwnd)    ;;∙------∙Window closed between calls, abort.
        return
    Gosub, VerifyAlwaysOnTop
    alwaysOnTop[hwnd] := !alwaysOnTop[hwnd]    ;;∙------∙Flip state.
    WinSet, AlwaysOnTop, % (alwaysOnTop[hwnd] ? "On" : "Off"), ahk_id %hwnd%
    if ErrorLevel
    {
        ToolTip, Cannot modify this window's always-on-top state
        SetTimer, KillTip, -1500
        return
    }
    if (alwaysOnTop[hwnd])
        Gosub, CreateAotGui    ;;∙------∙Spawn indicator Gui for this window.
    else
        Gosub, DestroyAotGui    ;;∙------∙Remove indicator Gui for this window.
    ToolTip, % "Always On Top: " (alwaysOnTop[hwnd] ? "ON" : "OFF")
    SetTimer, KillTip, -1500
Return
;;∙---------------------------------------------------------------------∙


;;∙======∙ROUTINES & FUNCTIONS∙==============================∙

;;∙====∙Verify Current Opacity Level
VerifyOpacity:
    if !WinExist("ahk_id " hwnd)    ;;∙------∙Guard against deleted windows.
        return
    ;;∙------∙Initialize opacity tracking using window's current opacity on first access.
    if (!opacity.HasKey(hwnd))
    {
        WinGet, currentOpacity, Transparent, ahk_id %hwnd%
        if (currentOpacity = "")
            currentOpacity := maxOpacity    ;;∙------∙No transparency set, assume opaque.
        else
            currentOpacity := Round(currentOpacity / 255 * 100)    ;;∙------∙Convert raw to % for table storage.
        opacity[hwnd] := currentOpacity
        if (currentOpacity < maxOpacity)    ;;∙------∙Remember last non-full value for toggle.
            lastOpacity[hwnd] := currentOpacity
    }
Return

;;∙====∙Verify If Current Window Always On Top
VerifyAlwaysOnTop:
    if !WinExist("ahk_id " hwnd)    ;;∙------∙Guard against deleted windows.
        return
    ;;∙------∙Initialize always-on-top tracking from the window's current state on first access.
    if (!alwaysOnTop.HasKey(hwnd))
    {
        WinGet, exStyle, ExStyle, ahk_id %hwnd%
        alwaysOnTop[hwnd] := (exStyle & 0x8) ? 1 : 0    ;;∙------∙WS_EX_TOPMOST = 0x8.
    }
Return

;;∙====∙Create Always-On-Top Gui.
CreateAotGui:
    aotGuiCount++
    gName := "AOT" . aotGuiCount
    WinGetPos, wX, wY, wW, wH, ahk_id %hwnd%
    if (aotBgTrans)
    {
        ;;∙------∙Transparent background with visible trim border.
        Gui, %gName%: New, +AlwaysOnTop -Caption +ToolWindow +LastFound +E0x20
        Gui, %gName%: Color, %aotBkGrnd%
        WinSet, TransColor, %aotBkGrnd% 150
        Gui, %gName%: Margin, 1, 1
        Gui, %gName%: Font, s9 c%aotTextColor% q5, Segoe UI
        Gui, %gName%: Add, Text, x4 y3 BackgroundTrans, %aotText%%A_Space%
    }
    else
    {
        ;;∙------∙Solid background: original behavior.
        Gui, %gName%: New, +AlwaysOnTop -Caption +ToolWindow +LastFound +E0x02000000 +E0x00080000
        Gui, %gName%: Margin, 0, 0
        Gui, %gName%: Color, %aotBkGrnd%
        Gui, %gName%: Font, s9 c%aotTextColor% q5, Segoe UI
        Gui, %gName%: Add, Text, x4 BackgroundTrans, %aotText%%A_Space%
    }
    Gui, %gName%: Show, % "x" (wX + 8) " y" (wY + 2) " NoActivate"
    WinGetPos, , , guiW, guiH, % "ahk_id " . WinExist()
    aotGuiWidths[hwnd] := guiW
    aotGuiHeights[hwnd] := guiH
    ;;∙------∙Apply trim border for both modes.
    Gui, %gName%: Show, % "x" (wX + (wW // 2) - (guiW // 2)) " y" (wY + 5) " NoActivate"
    guiTrim(gName, 0, 0, guiW, guiH, aotTrimColor, aotTrimColor, aotTrimColor, aotTrimColor, 1)
    aotGuis[hwnd] := gName
Return

;;∙====∙Terminate The Always-On-Top Gui.
DestroyAotGui:
    ;;∙------∙Destroy the indicator Gui for the given hwnd if one exists.
    if (aotGuis.HasKey(hwnd))
    {
        gName := aotGuis[hwnd]
        Gui, %gName%: Destroy
        aotGuis.Delete(hwnd)
        aotGuiWidths.Delete(hwnd)
        aotGuiHeights.Delete(hwnd)
    }
Return

;;∙====∙Reposition Always-On-Top Indicator Guis
AlwaysOnTopIndicator:
    for hwnd, gName in aotGuis
    {
        if !WinExist("ahk_id " hwnd)
            continue
        WinGetPos, wX, wY, wW, wH, ahk_id %hwnd%
        guiW := aotGuiWidths[hwnd]
        Gui, %gName%: +AlwaysOnTop
        Gui, %gName%: Show, % "NA x" (wX + (wW // 2) - (guiW // 2)) " y" (wY + 5) " NoActivate"
    }
Return

;;∙====∙Cleanup The Opacity Table
CleanOpacityTable:
    ;;∙------∙Remove entries for windows that no longer exist.
    dead := []
    for hwnd, val in opacity
    {
        if !WinExist("ahk_id " hwnd)
            dead.Push(hwnd)
    }
    for _, hwnd in dead
    {
        opacity.Delete(hwnd)
        lastOpacity.Delete(hwnd)    ;;∙------∙Clean toggle memory.
        alwaysOnTop.Delete(hwnd)    ;;∙------∙Clean always-on-top tracking.
        if (aotGuis.HasKey(hwnd))    ;;∙------∙Clean up orphaned indicator Gui if window closed while on top.
        {
            gName := aotGuis[hwnd]
            Gui, %gName%: Destroy
            aotGuis.Delete(hwnd)
            aotGuiWidths.Delete(hwnd)
            aotGuiHeights.Delete(hwnd)
        }
    }
Return

;;∙====∙Display Opacity ToolTips
OpacityToolTip:
    ;;∙------∙Display current opacity as percentage for 1.5 seconds.
    ToolTip, % "Opacity: " opacity[hwnd] "%"
    SetTimer, KillTip, -1500
Return

;;∙====∙Terminate ToolTips
KillTip:    ;;∙------∙Clear the opacity ToolTip display.
    ToolTip
Return

;;∙====∙Gui Edge Trim
guiTrim(GuiName, X, Y, W, H, ColorTop := "Black", ColorBottom := "Black", ColorLeft := "Black", ColorRight := "Black", Thickness := 1)
{	
    ;;∙------∙Calculate positions.
    BottomY := Y + H - Thickness
    RightX := X + W - Thickness
    ;;∙------∙Top edge.
    Gui, %GuiName%:Add, Progress, x%X% y%Y% w%W% h%Thickness% Background%ColorTop%
    ;;∙------∙Bottom edge.
    Gui, %GuiName%:Add, Progress, x%X% y%BottomY% w%W% h%Thickness% Background%ColorBottom%
    ;;∙------∙Left edge.
    Gui, %GuiName%:Add, Progress, x%X% y%Y% w%Thickness% h%H% Background%ColorLeft%
    ;;∙------∙Right edge.
    Gui, %GuiName%:Add, Progress, x%RightX% y%Y% w%Thickness% h%H% Background%ColorRight%
}

;;∙====∙Restore Window States, Cleanup Guis & ToolTips, Then Exit
^!Esc::    ;;∙------∙🔥∙(Ctrl + Alt + Esc) Terminate script.
ExitCleanup:    ;;∙------∙Restore all tracked windows to full opacity before exiting.
    for hwnd, val in opacity
    {
        if WinExist("ahk_id " hwnd)
            WinSet, Transparent, 255, ahk_id %hwnd%
    }
    for hwnd, val in alwaysOnTop    ;;∙------∙Clear Always-On-Top on all tracked windows before exiting.
    {
        if (val && WinExist("ahk_id " hwnd))
            WinSet, AlwaysOnTop, Off, ahk_id %hwnd%
    }
    for hwnd, gName in aotGuis    ;;∙------∙Destroy all indicator Guis before exiting.
    {
        Gui, %gName%: Destroy
    }
    SetTimer, KillTip, -100
    opacity := {}
    lastOpacity := {}
    alwaysOnTop := {}
    aotGuis := {}
    aotGuiWidths := {}
    aotGuiHeights := {}
ExitApp
;;∙==============================================∙




;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙



;;∙======∙SCRIPT EDIT / RELOAD / EXIT∙==============∙
;;∙------∙EDIT∙---------------------------∙
Script·Edit:    ;;∙------∙Menu Call.
    Edit
Return

;;∙------∙RELOAD∙-----------------------∙
^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        ;;∙------∙Soundbeep, 1000, 200
    Reload
Return

;;∙------∙EXIT∙----------------------------∙
;  ^Esc:: 
;      If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        ;;∙------∙Soundbeep, 1000, 200
    ExitApp
Return


;;∙======∙SCRIPT UPDATE∙=========================∙
UpdateCheck:    ;;∙------Check if script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload


;;∙======∙TRAY MENU∙=============================∙
TrayMenu:
Menu, Tray, Tip, %ScriptID%
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add

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
Menu, Tray, Default, Script Exit
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


;;∙======∙TRAY MENU POSITION∙====================∙
;;∙------∙TRAY MENU SHOW∙--------∙
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

;;***********************************************
;;****************** SCRIPT END ******************
;;***********************************************

