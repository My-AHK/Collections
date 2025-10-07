
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  Flipeador
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?t=36346#p167385
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
/*∙------------------------------------------------------------------------------------------∙
This AutoHotkey script creates a window locking/unlocking system using Windows API functions.
The windows will NOT remain locked if the script is not running.
The lock is temporary and only exists while the script is actively running.
All locked windows are automatically unlocked when the script exits.
∙---------------------------------------------------------------------------------------------∙

∙======∙LOCK WINDOW∙=================================∙
∙------∙(Ctrl+1 or Ctrl+Numpad1)
WHAT IT DOES:
 • Gets the handle of the currently active window
 • Uses EnableWindow Windows API function to disable user interaction
 • Parameters explained:
    ◦ "Ptr", WindowHandle - Pointer to the window handle
    ◦ "Int", 0 - Disable the window (0 = disabled, 1 = enabled)
 • Stores window information (handle, title, process) in an array
 • Uses IsWindowEnabled to verify the window was successfully locked
 • Shows a message box confirming the lock with window title and count


∙======∙UNLOCK LAST∙===================================∙
∙------∙(Ctrl+2 or Ctrl+Numpad2)
WHAT IT DOES:
 • Retrieves the most recently locked window from the array
 • Verifies the window still exists before attempting unlock
 • Uses enhanced UnlockWindow function with multiple unlock attempts:
    ◦ Direct unlock attempt
    ◦ Focus window first, then unlock
    ◦ Set foreground window, then unlock
    ◦ Show window, then unlock
 • Uses IsWindowEnabled to verify successful unlock
 • Removes the window from the locked windows array


∙======∙UNLOCK ALL∙====================================∙
∙------∙(Ctrl+3 or Ctrl+Numpad3)
WHAT IT DOES:
 • Processes all windows in the locked windows array
 • Attempts to unlock each window using the enhanced UnlockWindow function
 • Counts successfully unlocked windows
 • Clears the entire locked windows array
 • Shows total count of unlocked windows


∙======∙MANUAL UNLOCK∙===============================∙
∙------∙(Ctrl+4 or Ctrl+Numpad4)
WHAT IT DOES:
 • Prompts user to click on a window to unlock
 • Gets the window handle under the mouse cursor
 • Uses enhanced UnlockWindow function to unlock the clicked window
 • Removes the window from the locked windows array if present
 • Useful for unlocking specific windows without using the array order

KEY POINTS:
 • Window Disabling: Prevents user interaction with locked windows
 • Handle-based: Uses Windows window handles for precise targeting
 • Array Management: Tracks multiple locked windows with full information
 • Enhanced Unlock: Multiple unlock methods ensure reliable operation
 • Manual Control: Full control over which windows to lock/unlock
 • Auto-cleanup: Automatically unlocks all windows when script exits

USE CASE:
This is useful for temporarily preventing user interaction with specific windows while working,
ensuring no accidental clicks or input affects those windows. Perfect for presentations,
demonstrations, or when you need to "freeze" certain application windows.

NOTE: 
    * Locked windows cannot receive mouse clicks or keyboard input
    ** Windows can still be closed by their processes or system operations
    *** The lock is visual/interactive only - it doesn't prevent programmatic access
∙---------------------------------------------------------------------------------------------∙

∙======∙WINDOWS API FUNCTIONS USED∙==================∙
EnableWindow(hWnd, bEnable)
 • hWnd: Handle to the window
 • bEnable: 0 to disable, 1 to enable
 • Returns: Previous enabled state (not success/failure)

IsWindowEnabled(hWnd)
 • hWnd: Handle to the window  
 • Returns: 0 if disabled, non-zero if enabled
 • Used to verify actual window state

SetForegroundWindow(hWnd)
 • hWnd: Handle to the window
 • Brings window to foreground
 • Used in unlock attempts for better reliability
∙---------------------------------------------------------------------------------------------∙
*/


;;∙======∙Directives & Settings∙============================∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force
#WinActivateForce
#MaxThreadsPerHotkey 1
SendMode, Input
SetBatchLines -1
SetTitleMatchMode 2
SetWinDelay 0

Global LockedWindows := []    ;;∙------∙Array to store multiple window handles.

;;∙======∙Lock (Active Window)∙===========================∙
^1::    ;;∙------∙🔥∙(Ctrl + 1)
^Numpad1::    ;;∙------∙🔥∙(Ctrl + Numpad1)

    WinGet, ActiveWindowHandle, ID, A
    WinGetTitle, WindowTitle, ahk_id %ActiveWindowHandle%
    WinGet, ProcessName, ProcessName, ahk_id %ActiveWindowHandle%
    
    if (ActiveWindowHandle = 0) {
        MsgBox, Failed to get active window handle!
        Return
    }
    
    ;;∙------∙Check if already locked.
    if (IsWindowLocked(ActiveWindowHandle)) {
        MsgBox, This window is already locked!
        Return
    }
    
    ;;∙------∙Disable window.
        ;;∙------∙EnableWindow returns previous state: 0 if disabled, non-zero if enabled.
        ;;∙------∙So we expect it to return non-zero (the window was previously enabled).
    PreviousState := DllCall("User32.dll\EnableWindow", "Ptr", ActiveWindowHandle, "Int", 0)
    
    ;;∙------∙Check if window is actually disabled.
    CurrentState := DllCall("User32.dll\IsWindowEnabled", "Ptr", ActiveWindowHandle)
    
    if (CurrentState = 0) {  ;; 0 means disabled (locked)
        WindowInfo := {Handle: ActiveWindowHandle, Title: WindowTitle, Process: ProcessName}
        LockedWindows.Push(WindowInfo)
        TotalLocked := LockedWindows.Length()
        MsgBox, 0, Window Locked, Window locked!`nTitle: %WindowTitle%`nTotal locked: %TotalLocked%
    } else {
        MsgBox, Failed to lock window! Window is still enabled.
    }
Return

;;∙======∙Unlock (Last Locked Window)∙====================∙
^2::    ;;∙------∙🔥∙(Ctrl + 2)
^Numpad2::    ;;∙------∙🔥∙(Ctrl + Numpad2)

    ;;∙------∙Check if any locked windows.
    TotalWindows := LockedWindows.Length()
    if (TotalWindows = 0) {
        MsgBox, No windows are locked!
        Return
    }
    
    ;;∙------∙Get last locked window info.
    WindowInfo := LockedWindows.Pop()
    WindowHandle := WindowInfo.Handle
    WindowTitle := WindowInfo.Title
    
    ;;∙------∙Verify window still exists before trying to unlock.
    if !WinExist("ahk_id " . WindowHandle) {
        MsgBox, 0, Window Missing, Window no longer exists! It may have been closed.`nTitle: %WindowTitle%
        Return
    }
    
    ;;∙------∙Try to unlock window.
    Success := UnlockWindow(WindowHandle)
    
    if (Success) {
        RemainingCount := LockedWindows.Length()
        MsgBox, 0, Window Unlocked, Window unlocked!`nTitle: %WindowTitle%`nRemaining locked: %RemainingCount%
    } else {
        MsgBox, Failed to unlock window!`nTitle: %WindowTitle%
        ;;∙------∙Put window back in array since unlock failed.
        LockedWindows.Push(WindowInfo)
    }
Return

;;∙======∙Unlock (All Windows)∙===========================∙
^3::    ;;∙------∙🔥∙(Ctrl + 3)
^Numpad3::    ;;∙------∙🔥∙(Ctrl + Numpad3)

    ;;∙------∙Check if any locked windows.
    TotalWindows := LockedWindows.Length()
    if (TotalWindows = 0) {
        MsgBox, No windows are locked!
        Return
    }
    
    UnlockedCount := 0
    
    ;;∙------∙Process all windows in array.
    Loop %TotalWindows% {
        WindowInfo := LockedWindows[1]    ;;∙------∙Always get first element.
        WindowHandle := WindowInfo.Handle
        LockedWindows.RemoveAt(1)    ;;∙------∙Remove it from array.
        
        if WinExist("ahk_id " . WindowHandle) {
            Success := UnlockWindow(WindowHandle)
            if (Success) {
                UnlockedCount++
            }
        } else {
            UnlockedCount++    ;;∙------∙Count as unlocked since window no longer exists.
        }
    }
    
    ;;∙------∙Clear array to ensure it's empty.
    LockedWindows := []
    MsgBox, 0, All Windows Unlocked, %UnlockedCount% windows unlocked out of %TotalWindows% total!
Return

;;∙======∙Manual Unlock (By Clicking)∙======================∙
^4::    ;;∙------∙🔥∙(Ctrl + 4)
^Numpad4::    ;;∙------∙🔥∙(Ctrl + Numpad4)

    MsgBox, 0, Manual Unlock, Click on the window you want to unlock...
    
    ;;∙------∙Wait for mouse click.
    KeyWait, LButton, D
    MouseGetPos, , , ClickedWindow
    WinGetTitle, WindowTitle, ahk_id %ClickedWindow%
    
    ;;∙------∙Try to unlock clicked window.
    Success := UnlockWindow(ClickedWindow)
    
    if (Success) {
        MsgBox, 0, Manual Unlock Success, Manually unlocked window: %WindowTitle%
        ;;∙------∙Remove from locked windows if it was there.
        RemoveWindowFromLocked(ClickedWindow)
    } else {
        MsgBox, Manual unlock failed for: %WindowTitle%
    }
Return


;;∙=====================================================∙
;;∙======∙Helper Functions∙===============================∙
IsWindowLocked(WindowHandle) {
    global LockedWindows
    for index, WindowInfo in LockedWindows {
        InfoHandle := WindowInfo.Handle
        if (InfoHandle = WindowHandle) {
            return true
        }
    }
    return false
}

UnlockWindow(WindowHandle) {

    ;;∙------∙Check current state first.
    CurrentState := DllCall("User32.dll\IsWindowEnabled", "Ptr", WindowHandle)
    if (CurrentState != 0) {
        return true    ;;∙------∙Already unlocked.
    }
    
    ;;∙------∙1st attempt: Direct unlock.
    DllCall("User32.dll\EnableWindow", "Ptr", WindowHandle, "Int", 1)
    CurrentState := DllCall("User32.dll\IsWindowEnabled", "Ptr", WindowHandle)
    if (CurrentState != 0) {
        return true
    }
    
    ;;∙------∙2nd attempt: Focus window first, then unlock.
    WinActivate, ahk_id %WindowHandle%
    Sleep, 100
    DllCall("User32.dll\EnableWindow", "Ptr", WindowHandle, "Int", 1)
    CurrentState := DllCall("User32.dll\IsWindowEnabled", "Ptr", WindowHandle)
    if (CurrentState != 0) {
        return true
    }
    
    ;;∙------∙3rd attempt: Bring to foreground & try again.
    DllCall("User32.dll\SetForegroundWindow", "Ptr", WindowHandle)
    Sleep, 100
    DllCall("User32.dll\EnableWindow", "Ptr", WindowHandle, "Int", 1)
    CurrentState := DllCall("User32.dll\IsWindowEnabled", "Ptr", WindowHandle)
    if (CurrentState != 0) {
        return true
    }
    
    ;;∙------∙4th attempt: Show window & unlock.
    WinShow, ahk_id %WindowHandle%
    Sleep, 50
    DllCall("User32.dll\EnableWindow", "Ptr", WindowHandle, "Int", 1)
    CurrentState := DllCall("User32.dll\IsWindowEnabled", "Ptr", WindowHandle)
    if (CurrentState != 0) {
        return true
    }
    
    return false
}

RemoveWindowFromLocked(WindowHandle) {
    global LockedWindows
    for index, WindowInfo in LockedWindows {
        InfoHandle := WindowInfo.Handle
        if (InfoHandle = WindowHandle) {
            LockedWindows.RemoveAt(index)
            break
        }
    }
}

;;∙======∙Auto-Unlock (All Windows Upon Exit)∙==============∙
OnExit("ExitFunc")
ExitFunc(ExitReason, ExitCode) {
    global LockedWindows
    for index, WindowInfo in LockedWindows {
        WindowHandle := WindowInfo.Handle
        if WinExist("ahk_id " . WindowHandle) {
            UnlockWindow(WindowHandle)
        }
    }
}
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

