
/*∙=====∙NOTES∙==========================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  iPhilip
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?t=39569#p180911
» For specific notes...
    ▹ see 'INFO' after the Function.
∙=======================================================∙
*/
;;∙---------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙====================================∙
ScriptID := "TEMPLATE"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙======================================================∙
;;∙---------------------------------------------------------------------------------∙




;;∙======================================================∙
;;∙========∙VIEW  ALL  HOTKEYS∙============================∙
^t::
    GoSub, HotKeysList    ;;∙------∙View all Hotkeys.
Return
;;∙--------∙VIEW  ALL  HOTKEYS  END∙---------------------------------------∙


;;∙========∙EXAMPLE  USAGES∙==============================∙
;;∙------∙EXAMPLE: Restore SPECIFIED window to its original state.
^1::    ;;∙------∙🔥∙(Ctrl + 1)∙🔥∙
    Soundbeep, 1000, 200

;;∙------∙Match a window by its executable name.
    app := "notepad.exe"
    hwnd := WinExist("ahk_exe" app)

    if hwnd {
        ;;∙------∙Restore the SPECIFIED window to its original state.
        WinRestorePlus(hwnd)
    } else {
        MsgBox,,, Notepad window not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Move and Resize SPECIFIED Window (X-2000, Y-85, W-800, H-900).
^2::    ;;∙------∙🔥∙(Ctrl + 2)∙🔥∙
    Soundbeep, 1000, 200

    ;;∙------∙Match a window by its executable name
    app := "notepad.exe"
    hwnd := WinExist("ahk_exe" app)

    if hwnd {
        ;;∙------∙Move and resize the SPECIFIED window.
        WinRestorePlus(hwnd, 2000, 85, 800, 900)
    } else {
        MsgBox,,, Notepad window not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Move and Resize ACTIVE Window (X-100, Y-100, W-800, H-600).
^3::    ;;∙------∙🔥∙(Ctrl + 3)∙🔥∙
    Soundbeep, 1000, 200

    ;;∙------∙No need to specify a window, the active window will be used.
    WinRestorePlus(, 100, 100, 800, 600)
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Minimize the SPECIFIED Window.
^4::    ;;∙------∙🔥∙(Ctrl + 4)∙🔥∙
    Soundbeep, 1000, 200
    app := "notepad.exe"
    hwnd := WinExist("ahk_exe" app)

    if hwnd {
        ;;∙------∙Minimize the SPECIFIED window.
        WinMinimize, ahk_id %hwnd%
    } else {
        MsgBox,,, Notepad window not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Maximize the SPECIFIED Window.
^5::    ;;∙------∙🔥∙(Ctrl + 5)∙🔥∙
    Soundbeep, 1000, 200
    app := "notepad.exe"
    hwnd := WinExist("ahk_exe" app)

    if hwnd {
        ;;∙------∙Maximize the SPECIFIED window.
        WinMaximize, ahk_id %hwnd%
    } else {
        MsgBox,,, Notepad window not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Restore and Center the SPECIFIED Window on the Screen.
^6::    ;;∙------∙🔥∙(Ctrl + 6)∙🔥∙
    Soundbeep, 1000, 200
    app := "notepad.exe"
    hwnd := WinExist("ahk_exe" app)

    if hwnd {
        ;;∙------∙Get the screen dimensions.
        SysGet, MonitorWorkArea, MonitorWorkArea, Primary
        screenWidth := MonitorWorkAreaRight - MonitorWorkAreaLeft
        screenHeight := MonitorWorkAreaBottom - MonitorWorkAreaTop

        ;;∙------∙Calculate the center position.
        windowWidth := 800
        windowHeight := 600
        centerX := (screenWidth - windowWidth) // 2
        centerY := (screenHeight - windowHeight) // 2

        ;;∙------∙Restore and center the SPECIFIED window.
        WinRestorePlus(hwnd, centerX, centerY, windowWidth, windowHeight)
    } else {
        MsgBox,,, Notepad window not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Restore and Move the SPECIFIED Window to a Specific Monitor.
^7::    ;;∙------∙🔥∙(Ctrl + 7)∙🔥∙
    Soundbeep, 1000, 200
    app := "notepad.exe"
    hwnd := WinExist("ahk_exe" app)

    if hwnd {
        ;;∙------∙Get the dimensions of the second monitor.
        SysGet, Monitor2, Monitor, 2
        monitor2Width := Monitor2Right - Monitor2Left
        monitor2Height := Monitor2Bottom - Monitor2Top

        ;;∙------∙Calculate the position to move the window to the second monitor.
        windowWidth := 800
        windowHeight := 600
        posX := Monitor2Left + (monitor2Width - windowWidth) // 2
        posY := Monitor2Top + (monitor2Height - windowHeight) // 2

        ;;∙------∙Restore and move the SPECIFIED window to the second monitor.
        WinRestorePlus(hwnd, posX, posY, windowWidth, windowHeight)
    } else {
        MsgBox,,, Notepad window not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Restore and Resize the SPECIFIED Window to Half the Screen Width.
^8::    ;;∙------∙🔥∙(Ctrl + 8)∙🔥∙
    Soundbeep, 1000, 200
    app := "notepad.exe"
    hwnd := WinExist("ahk_exe" app)

    if hwnd {
        ;;∙------∙Get the screen dimensions.
        SysGet, MonitorWorkArea, MonitorWorkArea, Primary
        screenWidth := MonitorWorkAreaRight - MonitorWorkAreaLeft
        screenHeight := MonitorWorkAreaBottom - MonitorWorkAreaTop

        ;;∙------∙Calculate the new size and position.
        windowWidth := screenWidth // 2
        windowHeight := screenHeight
        posX := 0
        posY := 0

        ;;∙------∙Restore and resize the SPECIFIED window to half the screen width.
        WinRestorePlus(hwnd, posX, posY, windowWidth, windowHeight)
    } else {
        MsgBox,,, Notepad window not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Restore and Resize the SPECIFIED Window to a Quarter of the Screen.
^9::    ;;∙------∙🔥∙(Ctrl + 9)∙🔥∙
    Soundbeep, 1000, 200
    app := "notepad.exe"
    hwnd := WinExist("ahk_exe" app)

    if hwnd {
        ;;∙------∙Get the screen dimensions.
        SysGet, MonitorWorkArea, MonitorWorkArea, Primary
        screenWidth := MonitorWorkAreaRight - MonitorWorkAreaLeft
        screenHeight := MonitorWorkAreaBottom - MonitorWorkAreaTop

        ;;∙------∙Calculate the new size and position.
        windowWidth := screenWidth // 2
        windowHeight := screenHeight // 2
        posX := 0
        posY := 0

        ;;∙------∙Restore and resize the SPECIFIED window to a quarter of the screen.
        WinRestorePlus(hwnd, posX, posY, windowWidth, windowHeight)
    } else {
        MsgBox,,, Notepad window not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Restore and Resize the SPECIFIED Window to a Custom Size and Position.
^!1::    ;;∙------∙🔥∙(Ctrl + Alt + 1)∙🔥∙
    Soundbeep, 1000, 200
    app := "notepad.exe"
    hwnd := WinExist("ahk_exe" app)

    if hwnd {
        ;;∙------∙Custom size and position.
        customX := 500
        customY := 300
        customWidth := 1200
        customHeight := 800

        ;;∙------∙Restore and resize the SPECIFIED window to a custom size and position.
        WinRestorePlus(hwnd, customX, customY, customWidth, customHeight)
    } else {
        MsgBox,,, Notepad window not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Restore and Resize the SPECIFIED Window to Fit the Screen Height.
^!2::    ;;∙------∙🔥∙(Ctrl + Alt + 2)∙🔥∙
    Soundbeep, 1000, 200
    app := "notepad.exe"
    hwnd := WinExist("ahk_exe" app)

    if hwnd {
        ;;∙------∙Get the screen dimensions.
        SysGet, MonitorWorkArea, MonitorWorkArea, Primary
        screenWidth := MonitorWorkAreaRight - MonitorWorkAreaLeft
        screenHeight := MonitorWorkAreaBottom - MonitorWorkAreaTop

        ;;∙------∙Calculate the new size and position.
        windowHeight := screenHeight
        windowWidth := (windowHeight * 4) // 3    ;;∙------∙Assuming a 4:3 aspect ratio.
        posX := (screenWidth - windowWidth) // 2
        posY := 0

        ;;∙------∙Restore and resize the SPECIFIED window to fit the screen height.
        WinRestorePlus(hwnd, posX, posY, windowWidth, windowHeight)
    } else {
        MsgBox,,, Notepad window not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Restore and Resize the SPECIFIED Window to Fit the Screen Width.
^!3::    ;;∙------∙🔥∙(Ctrl + Alt + 3)∙🔥∙
    Soundbeep, 1000, 200
    app := "notepad.exe"
    hwnd := WinExist("ahk_exe" app)

    if hwnd {
        ;;∙------∙Get the screen dimensions.
        SysGet, MonitorWorkArea, MonitorWorkArea, Primary
        screenWidth := MonitorWorkAreaRight - MonitorWorkAreaLeft
        screenHeight := MonitorWorkAreaBottom - MonitorWorkAreaTop

        ;;∙------∙Calculate the new size and position.
        windowWidth := screenWidth
        windowHeight := (windowWidth * 3) // 4    ;∙------∙Assuming a 4:3 aspect ratio.
        posX := 0
        posY := (screenHeight - windowHeight) // 2

        ;;∙------∙Restore and resize the SPECIFIED window to fit the screen width.
        WinRestorePlus(hwnd, posX, posY, windowWidth, windowHeight)
    } else {
        MsgBox,,, Notepad window not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Restore and Resize the SPECIFIED Window to a Specific Aspect Ratio.
^!4::    ;;∙------∙🔥∙(Ctrl + Alt + 4)∙🔥∙
    Soundbeep, 1000, 200
    app := "notepad.exe"
    hwnd := WinExist("ahk_exe" app)

    if hwnd {
        ;;∙------∙Get the screen dimensions.
        SysGet, MonitorWorkArea, MonitorWorkArea, Primary
        screenWidth := MonitorWorkAreaRight - MonitorWorkAreaLeft
        screenHeight := MonitorWorkAreaBottom - MonitorWorkAreaTop

        ;;∙------∙Calculate the new size and position for a 16:9 aspect ratio.
        windowWidth := screenWidth // 2
        windowHeight := (windowWidth * 9) // 16
        posX := (screenWidth - windowWidth) // 2
        posY := (screenHeight - windowHeight) // 2

        ;;∙------∙Restore and resize the SPECIFIED window to a 16:9 aspect ratio.
        WinRestorePlus(hwnd, posX, posY, windowWidth, windowHeight)
    } else {
        MsgBox,,, Notepad window not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Restore and Resize the SPECIFIED Window to a Custom Aspect Ratio.
^!5::    ;;∙------∙🔥∙(Ctrl + Alt + 5)∙🔥∙
    Soundbeep, 1000, 200
    app := "notepad.exe"
    hwnd := WinExist("ahk_exe" app)

    if hwnd {
        ;;∙------∙Get the screen dimensions.
        SysGet, MonitorWorkArea, MonitorWorkArea, Primary
        screenWidth := MonitorWorkAreaRight - MonitorWorkAreaLeft
        screenHeight := MonitorWorkAreaBottom - MonitorWorkAreaTop

        ;;∙------∙Calculate the new size and position for a 21:9 aspect ratio.
        windowWidth := screenWidth // 2
        windowHeight := (windowWidth * 9) // 21
        posX := (screenWidth - windowWidth) // 2
        posY := (screenHeight - windowHeight) // 2

        ;;∙------∙Restore and resize the SPECIFIED window to a 21:9 aspect ratio.
        WinRestorePlus(hwnd, posX, posY, windowWidth, windowHeight)
    } else {
        MsgBox,,, Notepad window not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Restore and Resize the SPECIFIED Window to a Custom Size and Position.
^!6::    ;;∙------∙🔥∙(Ctrl + Alt + 6)∙🔥∙
    Soundbeep, 1000, 200
    app := "notepad.exe"
    hwnd := WinExist("ahk_exe" app)

    if hwnd {
        ;;∙------∙Custom size and position with a 16:10 aspect ratio.
        customWidth := 1280
        customHeight := (customWidth * 10) // 16
        customX := 100
        customY := 100

        ;;∙------∙Restore and resize the SPECIFIED window to a custom size and position with a 16:10 aspect ratio.
        WinRestorePlus(hwnd, customX, customY, customWidth, customHeight)
    } else {
        MsgBox,,, Notepad window not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Restore and Resize the SPECIFIED Window to a Custom Size and Position with a Specific Aspect Ratio and Centered.
^!7::    ;;∙------∙🔥∙(Ctrl + Alt + 7)∙🔥∙
    Soundbeep, 1000, 200
    app := "notepad.exe"
    hwnd := WinExist("ahk_exe" app)

    if hwnd {
        ;;∙------∙Get the screen dimensions.
        SysGet, MonitorWorkArea, MonitorWorkArea, Primary
        screenWidth := MonitorWorkAreaRight - MonitorWorkAreaLeft
        screenHeight := MonitorWorkAreaBottom - MonitorWorkAreaTop

        ;;∙------∙Custom size with a 16:10 aspect ratio.
        customWidth := 1280
        customHeight := (customWidth * 10) // 16

        ;;∙------∙Calculate the center position.
        centerX := (screenWidth - customWidth) // 2
        centerY := (screenHeight - customHeight) // 2

        ;;∙------∙Restore and resize the SPECIFIED window to a custom size and position with a 16:10 aspect ratio and centered.
        WinRestorePlus(hwnd, centerX, centerY, customWidth, customHeight)
    } else {
        MsgBox,,, Notepad window not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Restore and Resize the SPECIFIED Window to a Custom Size and Position with a Specific Aspect Ratio and Offset.
^!8::    ;;∙------∙🔥∙(Ctrl + Alt + 8)∙🔥∙
    Soundbeep, 1000, 200
    app := "notepad.exe"
    hwnd := WinExist("ahk_exe" app)

    if hwnd {
        ;;∙------∙Get the screen dimensions.
        SysGet, MonitorWorkArea, MonitorWorkArea, Primary
        screenWidth := MonitorWorkAreaRight - MonitorWorkAreaLeft
        screenHeight := MonitorWorkAreaBottom - MonitorWorkAreaTop

        ;;∙------∙Custom size with a 16:10 aspect ratio.
        customWidth := 1280
        customHeight := (customWidth * 10) // 16

        ;;∙------∙Calculate the center position with an offset.
        offsetX := 100
        offsetY := 50
        centerX := (screenWidth - customWidth) // 2 + offsetX
        centerY := (screenHeight - customHeight) // 2 + offsetY

        ;;∙------∙Restore and resize the SPECIFIED window to a custom size and position with a 16:10 aspect ratio and offset.
        WinRestorePlus(hwnd, centerX, centerY, customWidth, customHeight)
    } else {
        MsgBox,,, Notepad window not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Restore and Resize the SPECIFIED Window to a Custom Size and Position with a Specific Aspect Ratio and Multiple Monitors.
^!9::    ;;∙------∙🔥∙(Ctrl + Alt + 9)∙🔥∙
    Soundbeep, 1000, 200
    app := "notepad.exe"
    hwnd := WinExist("ahk_exe" app)

    if hwnd {
        ;;∙------∙Get the dimensions of the second monitor.
        SysGet, Monitor2, Monitor, 2
        monitor2Width := Monitor2Right - Monitor2Left
        monitor2Height := Monitor2Bottom - Monitor2Top

        ;;∙------∙Custom size with a 16:10 aspect ratio.
        customWidth := 1280
        customHeight := (customWidth * 10) // 16

        ;;∙------∙Calculate the center position on the second monitor.
        centerX := Monitor2Left + (monitor2Width - customWidth) // 2
        centerY := Monitor2Top + (monitor2Height - customHeight) // 2

        ;;∙------∙Restore and resize the SPECIFIED window to a custom size and position with a 16:10 aspect ratio on the second monitor.
        WinRestorePlus(hwnd, centerX, centerY, customWidth, customHeight)
    } else {
        MsgBox,,, Notepad window not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Restore and Resize the SPECIFIED Window to a Custom Size and Position with a Specific Aspect Ratio and Multiple Monitors with Offset.
^+1::    ;;∙------∙🔥∙(Ctrl + Shift + 1)∙🔥∙
    Soundbeep, 1000, 200
    app := "notepad.exe"
    hwnd := WinExist("ahk_exe" app)

    if hwnd {
        ;;∙------∙Get the dimensions of the second monitor.
        SysGet, Monitor2, Monitor, 2
        monitor2Width := Monitor2Right - Monitor2Left
        monitor2Height := Monitor2Bottom - Monitor2Top

        ;;∙------∙Custom size with a 16:10 aspect ratio.
        customWidth := 1280
        customHeight := (customWidth * 10) // 16

        ;;∙------∙Calculate the center position on the second monitor with an offset.
        offsetX := 100
        offsetY := 50
        centerX := Monitor2Left + (monitor2Width - customWidth) // 2 + offsetX
        centerY := Monitor2Top + (monitor2Height - customHeight) // 2 + offsetY

        ;;∙------∙Restore and resize the SPECIFIED window to a custom size and position with a 16:10 aspect ratio on the second monitor with an offset.
        WinRestorePlus(hwnd, centerX, centerY, customWidth, customHeight)
    } else {
        MsgBox,,, Notepad window not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Restore and Resize the SPECIFIED Window to a Custom Size and Position with a Specific Aspect Ratio and Multiple Monitors with Custom Offset.
^+2::    ;;∙------∙🔥∙(Ctrl + Shift + 2)∙🔥∙
    Soundbeep, 1000, 200
    app := "notepad.exe"
    hwnd := WinExist("ahk_exe" app)

    if hwnd {
        ;;∙------∙Get the dimensions of the second monitor.
        SysGet, Monitor2, Monitor, 2
        monitor2Width := Monitor2Right - Monitor2Left
        monitor2Height := Monitor2Bottom - Monitor2Top

        ;;∙------∙Custom size with a 16:10 aspect ratio.
        customWidth := 1280
        customHeight := (customWidth * 10) // 16

        ;;∙------∙Custom offset.
        customOffsetX := 200
        customOffsetY := 100

        ;;∙------∙Calculate the center position on the second monitor with a custom offset.
        centerX := Monitor2Left + (monitor2Width - customWidth) // 2 + customOffsetX
        centerY := Monitor2Top + (monitor2Height - customHeight) // 2 + customOffsetY

        ;;∙------∙Restore and resize the SPECIFIED window to a custom size and position with a 16:10 aspect ratio on the second monitor with a custom offset.
        WinRestorePlus(hwnd, centerX, centerY, customWidth, customHeight)
    } else {
        MsgBox,,, Notepad window not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Restore a SPECIFIED Window by Title.
^+3::    ;;∙------∙🔥∙(Ctrl + Shift + 3)∙🔥∙
    Soundbeep, 1000, 200

    ;;∙------∙Match a window by its exact title.
    app := "Untitled - Notepad"
    hwnd := WinExist(app)

    if hwnd {
        ;;∙------∙Restore the SPECIFIED window.
        WinRestorePlus(hwnd)
    } else {
        MsgBox,,, Notepad window with title "%app%" not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Move and Resize a SPECIFIED Window by Title.
^+4::    ;;∙------∙🔥∙(Ctrl + Shift + 4)∙🔥∙
    Soundbeep, 1000, 200

    ;;∙------∙Match a window by its exact title.
    app := "Untitled - Notepad"
    hwnd := WinExist(app)

    if hwnd {
        ;;∙------∙Move and resize the SPECIFIED window.
        WinRestorePlus(hwnd, 700, 200, 800, 600)
    } else {
        MsgBox,,, Notepad window with title "%app%" not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Restore and Center a SPECIFIED Window by Partial Title.
^+5::    ;;∙------∙🔥∙(Ctrl + Shift + 5)∙🔥∙
    Soundbeep, 1000, 200

    ;;∙------∙Match a window by partial title
    app := "Notepad"
    hwnd := WinExist(app "ahk_class Notepad")    ;;∙------∙Use ahk_class to ensure it's a Notepad window.

    if hwnd {
        ;;∙------∙Get the screen dimensions.
        SysGet, MonitorWorkArea, MonitorWorkArea, Primary
        screenWidth := MonitorWorkAreaRight - MonitorWorkAreaLeft
        screenHeight := MonitorWorkAreaBottom - MonitorWorkAreaTop

        ;;∙------∙Calculate the center position.
        windowWidth := 800
        windowHeight := 600
        centerX := (screenWidth - windowWidth) // 2
        centerY := (screenHeight - windowHeight) // 2

        ;;∙------∙Restore and center the SPECIFIED window.
        WinRestorePlus(hwnd, centerX, centerY, windowWidth, windowHeight)
    } else {
        MsgBox,,, Notepad window with title containing "%app%" not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Restore and Resize a SPECIFIED Window by Title and Class.
^+6::    ;;∙------∙🔥∙(Ctrl + Shift + 6)∙🔥∙
    Soundbeep, 1000, 200

    ;;∙------∙Match a window by title and class.
    app := "Untitled - Notepad"
    hwnd := WinExist("ahk_exe notepad.exe ahk_class Notepad ahk_title " app)

    if hwnd {
        ;;∙------∙Restore and resize the SPECIFIED window.
        WinRestorePlus(hwnd, 100, 100, 800, 600)
    } else {
        MsgBox,,, Notepad window with title "%app%" and class "Notepad" not found!,3
    }
Return


;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Restore and Resize a SPECIFIED Window by Title and Process ID.
^+7::    ;;∙------∙🔥∙(Ctrl + Shift + 7)∙🔥∙
    Soundbeep, 1000, 200

    ;;∙------∙Match a window by title and process ID.
    app := "Untitled - Notepad"
    hwnd := WinExist(app)
    WinGet, pid, PID, ahk_id %hwnd%    ;;∙------∙Get the process ID of the window.

    if hwnd {
        ;;∙------∙Restore and resize the SPECIFIED window.
        WinRestorePlus(hwnd, 200, 200, 1000, 800)
    } else {
        MsgBox,,, Notepad window with title "%app%" and PID "%pid%" not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Restore and Resize a SPECIFIED Window by Title and Handle.
^+8::    ;;∙------∙🔥∙(Ctrl + Shift + 8)∙🔥∙
    Soundbeep, 1000, 200

    ;;∙------∙Match a window by title.
    app := "Untitled - Notepad"
    hwnd := WinExist(app)

    if hwnd {
        ;;∙------∙Restore and resize the SPECIFIED window using its handle.
        WinRestorePlus(hwnd, 300, 300, 1200, 900)
    } else {
        MsgBox,,, Notepad window with title "%app%" not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Restore and Resize a SPECIFIED Window by Title and Exclude Minimized Windows.
^+9::    ;;∙------∙🔥∙(Ctrl + Shift + 9)∙🔥∙
    Soundbeep, 1000, 200

    ;;∙------∙Match a window by title.
    app := "Untitled - Notepad"
    hwnd := WinExist(app)

    if hwnd {
        ;;∙------∙Check if the window is minimized.
        WinGet, isMinimized, MinMax, ahk_id %hwnd%
        if (isMinimized = -1) {
            MsgBox,,, The window is minimized and cannot be restored!,3
        } else {
            ;;∙------∙Restore and resize the SPECIFIED window.
            WinRestorePlus(hwnd, 400, 400, 1000, 800)
        }
    } else {
        MsgBox,,, Notepad window with title "%app%" not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Restore and Resize a SPECIFIED Window by Title and Ensure It Is Active.
^+!1::    ;;∙------∙🔥∙(Ctrl + Shift + Alt + 1)∙🔥∙
    Soundbeep, 1000, 200

    ;;∙------∙Match a window by title.
    app := "Untitled - Notepad"
    hwnd := WinExist(app)

    if hwnd {
        ;;∙------∙Activate the window.
        WinActivate, ahk_id %hwnd%

        ;;∙------∙Restore and resize the SPECIFIED window.
        WinRestorePlus(hwnd, 500, 500, 1200, 900)
    } else {
        MsgBox,,, Notepad window with title "%app%" not found!,3
    }
Return

;;∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙

;;∙------∙EXAMPLE: Restore and Resize a SPECIFIED Window by Title and Match Case-Sensitive.
^+!2::    ;;∙------∙🔥∙(Ctrl + Shift + Alt + 2)∙🔥∙
    Soundbeep, 1000, 200

    ;;∙------∙Match a window by title (case-sensitive).
    app := "Untitled - Notepad"
    hwnd := WinExist(app "ahk_class Notepad")
    if hwnd {
        ;;∙------∙Restore and resize the SPECIFIED window.
        WinRestorePlus(hwnd, 600, 600, 1000, 800)
    } else {
        MsgBox,,, Notepad window with title "%app%" (case-sensitive) not found!,3
    }
Return
;;∙--------∙EXAMPLE  USAGES  END∙-----------------------------------------∙


;;∙========∙THE  FUNCTION∙================================∙
WinRestorePlus(hwnd:="", X:="", Y:="", W:="", H:="") {
    hwnd := hwnd = "" ? WinExist("A") : hwnd
    VarSetCapacity(WP, 44, 0), NumPut(44, WP, "UInt")
    DllCall("User32.dll\GetWindowPlacement", "Ptr", hwnd, "Ptr", &WP)

    Lo := NumGet(WP, 28, "Int")    ;;∙------∙X coordinate of the upper-left corner of the window in its original restored state.
    To := NumGet(WP, 32, "Int")    ;;∙------∙Y coordinate of the upper-left corner of the window in its original restored state.
    Wo := NumGet(WP, 36, "Int") - Lo    ;;∙------∙Width of the window in its original restored state.
    Ho := NumGet(WP, 40, "Int") - To    ;;∙------∙Height of the window in its original restored state.

    L := X = "" ? Lo : X    ;;∙------∙X coordinate of the upper-left corner of the window in its new restored state.
    T := Y = "" ? To : Y    ;;∙------∙Y coordinate of the upper-left corner of the window in its new restored state.
    R := L + (W = "" ? Wo : W)    ;;∙------∙X coordinate of the bottom-right corner of the window in its new restored state.
    B := T + (H = "" ? Ho : H)    ;;∙------∙Y coordinate of the bottom-right corner of the window in its new restored state.

    NumPut(9, WP, 8, "UInt")    ;;∙------∙SW_RESTORE = 9.
    NumPut(L, WP, 28, "Int")
    NumPut(T, WP, 32, "Int")
    NumPut(R, WP, 36, "Int")
    NumPut(B, WP, 40, "Int")

   Return DllCall("User32.dll\SetWindowPlacement", "Ptr", hwnd, "Ptr", &WP)
}
Return
;;∙--------∙FUNCTION  END∙---------------------------------------------------∙


;;∙========∙GUI  HOTKEYS  LIST∙=============================∙
HotKeysList:
Gui, +AlwaysOnTop -Caption
Gui, Color, Black
Gui, Font, s12 w600 q5, Segoe UI
Gui, Add, Text, x20 y20 cYellow, HOTKEYS   `t`t`tEXAMPLES
Gui, Font, s12 w400 cWhite q5, Calibri 
Gui, Add, Text, y+10, (Ctrl + 1)   `t`tRestore SPECIFIED window to its original state.
Gui, Add, Text, y+5, (Ctrl + 2)    `t`tMove and Resize SPECIFIED Window.
Gui, Add, Text, y+5, (Ctrl + 3)    `t`tMove and Resize ACTIVE Window.
Gui, Add, Text, y+5, (Ctrl + 4)    `t`tMinimize the SPECIFIED Window.
Gui, Add, Text, y+5, (Ctrl + 5)    `t`tMaximize the SPECIFIED Window.
Gui, Add, Text, y+5, (Ctrl + 6)    `t`tRestore and Center the SPECIFIED Window on the Screen.
Gui, Add, Text, y+5, (Ctrl + 7)    `t`tRestore and Move the SPECIFIED Window to a Specific Monitor.
Gui, Add, Text, y+5, (Ctrl + 8)    `t`tRestore and Resize the SPECIFIED Window to Half the Screen Width.
Gui, Add, Text, y+5, (Ctrl + 9)    `t`tRestore and Resize the SPECIFIED Window to a Quarter of the Screen.
Gui, Add, Text, y+5, (Ctrl + Alt + 1)    `t`tRestore and Resize the SPECIFIED Window to a Custom Size and Position.
Gui, Add, Text, y+5, (Ctrl + Alt + 2)    `t`tRestore and Resize the SPECIFIED Window to Fit the Screen Height.
Gui, Add, Text, y+5, (Ctrl + Alt + 3)    `t`tRestore and Resize the SPECIFIED Window to Fit the Screen Width.
Gui, Add, Text, y+5, (Ctrl + Alt + 4)    `t`tRestore and Resize the SPECIFIED Window to a Specific Aspect Ratio.
Gui, Add, Text, y+5, (Ctrl + Alt + 5)    `t`tRestore and Resize the SPECIFIED Window to a Custom Aspect Ratio.
Gui, Add, Text, y+5, (Ctrl + Alt + 6)    `t`tRestore and Resize the SPECIFIED Window to a Custom Size and Position.
Gui, Add, Text, y+5, (Ctrl + Alt + 7)    `t`tRestore and Resize the SPECIFIED Window to a Custom Size and Position with a Specific Aspect Ratio and Centered.
Gui, Add, Text, y+5, (Ctrl + Alt + 8)    `t`tRestore and Resize the SPECIFIED Window to a Custom Size and Position with a Specific Aspect Ratio and Offset.
Gui, Add, Text, y+5, (Ctrl + Alt + 9)    `t`tRestore and Resize the SPECIFIED Window to a Custom Size and Position with a Specific Aspect Ratio and Multiple Monitors.
Gui, Add, Text, y+5, (Ctrl + Shift + 1)    `t`tRestore and Resize the SPECIFIED Window to a Custom Size and Position with a Specific Aspect Ratio and Multiple Monitors with Offset.
Gui, Add, Text, y+5, (Ctrl + Shift + 2)    `t`tRestore and Resize the SPECIFIED Window to a Custom Size and Position with a Specific Aspect Ratio and Multiple Monitors with Custom Offset.
Gui, Add, Text, y+5, (Ctrl + Shift + 3)    `t`tRestore a SPECIFIED Window by Title.
Gui, Add, Text, y+5, (Ctrl + Shift + 4)    `t`tMove and Resize a SPECIFIED Window by Title.
Gui, Add, Text, y+5, (Ctrl + Shift + 5)    `t`tRestore and Center a SPECIFIED Window by Partial Title.
Gui, Add, Text, y+5, (Ctrl + Shift + 6)    `t`tRestore and Resize a SPECIFIED Window by Title and Class.
Gui, Add, Text, y+5, (Ctrl + Shift + 7)    `t`tRestore and Resize a SPECIFIED Window by Title and Process ID.
Gui, Add, Text, y+5, (Ctrl + Shift + 8)    `t`tRestore and Resize a SPECIFIED Window by Title and Handle.
Gui, Add, Text, y+5, (Ctrl + Shift + 9)    `t`tRestore and Resize a SPECIFIED Window by Title and Exclude Minimized Windows.
Gui, Add, Text, y+5, (Ctrl + Shift + Alt + 1)    `tRestore and Resize a SPECIFIED Window by Title and Ensure It Is Active.
Gui, Add, Text, y+5, (Ctrl + Shift + Alt + 2)    `tRestore and Resize a SPECIFIED Window by Title and Match Case-Sensitive.
Gui, Add, Text, y+5    ;;∙------∙Buffer.
Gui, Font, s14 w600 cRED q5, Segoe UI
Gui, Show, Hide

;;∙------∙Get the GUI dimensions.
Gui +LastFound
WinGetPos, guiX, guiY, guiWidth, guiHeight
;;∙------∙Calculate the x-axis coordinate for the text control.
textControlX := guiWidth - 30    ;;∙------∙Subtract 30 pixels from the right side.
textControlY := guiHeight - 30    ;;∙------∙Subtract 30 pixels from the bottom
;;∙------∙Add the text control at the calculated position.
Gui, Add, Text, x%textControlX% y%textControlY% BackgroundTrans gGclose, X 
Gui, Show, w%guiWidth% h%guiHeight%, My GUI
Return

Gclose:
    Gui, Destroy
Return
;;∙--------∙GUI  HOTKEYS  LIST  END∙----------------------------------------∙


/*∙=====∙INFO∙===========================================∙
WinRestorePlus(hwnd:="", X:="", Y:="", W:="", H:="")
Function:
    • Restore a window to a new set of coordinates/dimensions, regardless of its state (maximized, minimized, or normal).
    • Combines the WinRestore and WinMove commands into one function with the benefit of no flicker.
    • If the window is a normal window, this function will simply move/resize the window.
    • If no parameters are specified, this function restores the active window, as in WinRestore, A.

Tested with:
    • AHK 1.1.26.01 (A32/U32/U64)
    • AHK 2.0-a081-cad307c (U32/U64)

Tested on:
    • Win 7 (x64)

Parameters:
    • hwnd - (Optional) The handle of the window being restored. If not specified, the active window will be restored.
    • X - (Optional) The x coordinate of the upper-left corner of the target window's new location*
    • Y  - (Optional) The y coordinate of the upper-left corner of the target window's new location*
    • W - (Optional) The new width of the target window*
    •  H - (Optional) The new height of the target window*
    •  * If a coordinate is not specified, the corresponding value of the window in its restored state is used.

Return values:
    • Non-Zero if the window was successfully restored
    • Zero if the window was not successfully restored

MSDN links:
    • https://msdn.microsoft.com/en-us/library/windows/desktop/ms633518(v=vs.85).aspx - GetWindowPlacement function
    • https://msdn.microsoft.com/en-us/library/windows/desktop/ms633544(v=vs.85).aspx - SetWindowPlacement function
    • https://msdn.microsoft.com/en-us/library/windows/desktop/ms632611(v=vs.85).aspx - WINDOWPLACEMENT structure
*/
;;∙--------∙INFO END∙-----------------------------------------------------------∙
;;∙=======================================================∙




;;∙======================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙EDIT \ RELOAD / EXIT∙=============================∙
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
;;∙======================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Gui Drag Pt 2∙====================================∙
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}
;;∙======================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Script Updater∙===================================∙
UpdateCheck:    ;;∙------Check if the script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload
;;∙======================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute Sub∙================================∙
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
;;∙======================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Tray Menu∙======================================∙
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
;;∙======================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙MENU CALLS∙====================================∙
TEMPLATE:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
    Suspend
    Soundbeep, 700, 100
    Pause
Return
;;∙======================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙TRAY MENU POSITION∙============================∙
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
;;∙======================================================∙

;;∙------------------------------------------------------------------------------------------∙
;;∙========================∙SCRIPT END∙===================∙
;;∙------------------------------------------------------------------------------------------∙

