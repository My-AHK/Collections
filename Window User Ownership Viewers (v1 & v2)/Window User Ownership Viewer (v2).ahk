/*------∙NOTES∙--------------------------------------------------------------------------∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------------------------------------------------------------------------------------------∙
*/

;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙
;;∙======∙DIRECTIVES.
#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

SetTitleMatchMode 2
SetWorkingDir A_ScriptDir

OnMessage(0x0201, WM_LBUTTONDOWNdrag)
SetTimer(UpdateCheck, 750)

ScriptID := "Ownership_Viewer_v2"
TraySetIcon("shell32.dll", 313)

BuildTrayMenu()


;;∙======∙HOTKEY.
^t:: {
    myGui.Show()
}


;;∙======∙GLOBAL VARIABLES.
global vWinList
global CharSet := "UTF-16"
global myGui


;;∙======∙GUI BUILD.
myGui := Gui("+AlwaysOnTop +Resize +MinSize400x300")
myGui.SetFont("s10", "Segoe UI")

myGui.AddText("x10 y8", "Visible Window Owners:")
vWinList := myGui.AddListView("x10 y30 w640 h400 Grid", ["PID", "Process Name", "User", "Window Title"])

myGui.AddButton("x10 y440 w100", "Refresh").OnEvent("Click", RefreshList)
myGui.AddButton("x120 y440 w100", "Exit").OnEvent("Click", (*) => ExitApp())

myGui.Title := "Window User Ownership Viewer"
myGui.Show("w660 h480")

RefreshList()


;;∙======∙ENUMERATE WINDOWS.
RefreshList(*) {
    global vWinList

    vWinList.Delete()

    for hwnd in WinGetList()
    {
        try {
            pid := WinGetPID("ahk_id " hwnd)
            title := WinGetTitle("ahk_id " hwnd)

            if (title = "")
                continue  ;;∙------∙Skip untitled invisible windows.

            image := GetProcessName(pid)
            user := GetProcessUser(pid)

            vWinList.Add("", pid, image, user, title)
        }
    }

    vWinList.ModifyCol()
}


;;∙======∙PROCESS NAME.
GetProcessName(PID) {
    global CharSet

    hProcess := DllCall("OpenProcess", "uint", 0x0410, "int", 0, "uint", PID, "ptr")
    if !hProcess
        return "Access Denied"

    FileName := Buffer(520, 0)
    len := DllCall("psapi.dll\GetModuleBaseNameW", "ptr", hProcess, "ptr", 0, "ptr", FileName, "uint", 260)

    DllCall("CloseHandle", "ptr", hProcess)

    return (len) ? StrGet(FileName, len, CharSet) : "Unknown"
}


;;∙======∙PROCESS USER.
GetProcessUser(PID) {
    global CharSet

    TOKEN_QUERY := 0x0008
    PROCESS_QUERY_LIMITED_INFORMATION := 0x1000

    hProcess := DllCall("OpenProcess", "uint", PROCESS_QUERY_LIMITED_INFORMATION, "int", 0, "uint", PID, "ptr")
    if !hProcess
        return "Access Denied"

    hToken := 0
    if !DllCall("advapi32.dll\OpenProcessToken", "ptr", hProcess, "uint", TOKEN_QUERY, "ptr*", &hToken)
    {
        DllCall("CloseHandle", "ptr", hProcess)
        return "Access Denied"
    }

    size := 0
    DllCall("advapi32.dll\GetTokenInformation", "ptr", hToken, "int", 1, "ptr", 0, "uint", 0, "uint*", &size)

    TOKENINFO := Buffer(size, 0)

    if !DllCall("advapi32.dll\GetTokenInformation", "ptr", hToken, "int", 1, "ptr", TOKENINFO, "uint", size, "uint*", &size)
    {
        DllCall("CloseHandle", "ptr", hToken)
        DllCall("CloseHandle", "ptr", hProcess)
        return "Access Denied"
    }

    pSID := NumGet(TOKENINFO, 0, "ptr")

    cchName := 260
    cchDomain := 260

    Name := Buffer(cchName * 2, 0)
    Domain := Buffer(cchDomain * 2, 0)

    peUse := 0

    if !DllCall("advapi32.dll\LookupAccountSidW"
        , "ptr", 0
        , "ptr", pSID
        , "ptr", Name
        , "uint*", &cchName
        , "ptr", Domain
        , "uint*", &cchDomain
        , "uint*", &peUse)
    {
        user := "Unknown"
    }
    else
    {
        user := StrGet(Domain, CharSet) "\" StrGet(Name, CharSet)
    }

    DllCall("CloseHandle", "ptr", hToken)
    DllCall("CloseHandle", "ptr", hProcess)

    return user
}


;;∙======∙GUI DRAG.
WM_LBUTTONDOWNdrag(wParam, lParam, msg, hwnd) {
    if (hwnd = myGui.Hwnd)
        PostMessage(0x00A1, 2, 0)
}


;;∙====================================∙
;;∙------∙SCRIPT UPDATE∙-------------∙
UpdateCheck(*) {
    static oldModTime := ""

    currentModTime := FileGetTime(A_ScriptFullPath)

    if (oldModTime = "" || oldModTime = currentModTime)
    {
        oldModTime := currentModTime
        return
    }

    SoundBeep(1700, 100)
    Reload()
}


;;∙====================================∙
;;∙------∙TRAY MENU∙------------------∙
BuildTrayMenu() {
    A_TrayMenu.Delete()

    A_TrayMenu.Add("Suspend / Pause", ToggleScript)
    A_TrayMenu.Default := "Suspend / Pause"

    A_TrayMenu.Add()
    A_TrayMenu.Add("Help Docs", (*) => Run("C:\Program Files\AutoHotkey\AutoHotkey.chm"))
    A_TrayMenu.Add("Key History", (*) => KeyHistory())
    A_TrayMenu.Add("Window Spy", (*) => Run("C:\Program Files\AutoHotkey\WindowSpy.ahk"))

    A_TrayMenu.Add()
    A_TrayMenu.Add("Script Edit", (*) => Edit())
    A_TrayMenu.Add("Script Reload", ScriptReload)
    A_TrayMenu.Add("Script Exit", ScriptExit)
}

;;∙------∙SCRIPT HEADER∙
ToggleScript(*) {
    Suspend(-1)
    SoundBeep(700, 100)
    Pause(-1)
}

;;∙------∙RELOAD∙
^Home:: {
    static last := 0
    if (A_TickCount - last < 200)
    {
        SoundBeep(1200, 250)
        Reload()
    }
    last := A_TickCount
}

;;∙------∙EXIT∙
^Esc:: {
    static last := 0
    if (A_TickCount - last < 200)
    {
        SoundBeep(1000, 300)
        ExitApp()
    }
    last := A_TickCount
}



ScriptReload(*) {
    SoundBeep(1200, 250)
    Reload()
}

ScriptExit(*) {
    SoundBeep(1000, 300)
    ExitApp()
}


;;∙------------------------------------------------------------------------------------------∙
;;∙========================∙SCRIPT END∙=========================∙
;;∙------------------------------------------------------------------------------------------∙

