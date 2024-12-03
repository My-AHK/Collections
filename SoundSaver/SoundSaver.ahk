
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙--------∙Origins∙-------------------------∙
» Author:  
» Original Source:  
» 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TEMPLATE"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
#Persistent
#SingleInstance
global Secs := 5    ;;∙------∙Timeout for MsgBox.
global Debug := false    ;;∙------∙Set to boolean true/false (true = enable debugging / false = disable debugging)

;;∙------------∙Set Variables∙------------∙
global VolDbPath := A_MyDocuments "\SoundSaver\Vol.db"    ;;∙------∙Dynamic path to volume settings file.
global DirPath := A_MyDocuments "\SoundSaver"    ;;∙------∙Dynamic path to volume settings directory.
;;∙------∙Saves Vol.db settings to...  "C:\Users\UserName\Documents\SoundSaver\Vol.db"

OnExit("CaptureVolume")    ;;∙------∙Save volume settings on exit.
CBTProc_Init()    ;;∙------∙Initialize MsgBox positioning hook.

;;∙------------∙Ensure Directory and File Exist∙------------∙
EnsurePathExists(DirPath, "Directory")
EnsurePathExists(VolDbPath, "File", "New File created at...")

;;∙------------∙Retrieve and Apply Volume Setting∙------------∙
if FileExist(VolDbPath) {
    VolumeSetting := ReadFromFile(VolDbPath)
    if (VolumeSetting != "") {
        SetVolume(VolumeSetting)
    } else {
        DebugMsgBox("No volume setting to apply.")
    }
}
Return

CaptureVolume() {
    SoundGet, VolumeSetting, Master    ;;∙------∙Capture current volume.
    VolumePercentage := Round(VolumeSetting)    ;;∙------∙Round to nearest whole number.
    EnsurePathExists(DirPath, "Directory")
    if WriteToFile(VolDbPath, VolumePercentage) {    ;;∙------∙Save rounded volume level.
        DebugMsgBox("Volume setting of " VolumePercentage "% saved at...`n" DirPath)
    }
}
Return


;;∙------------∙CBTProc Hook∙------------∙
CBTProc_Init() {
    static HCBT_CREATEWND := 3, WH_CBT := 5
    , hHook := DllCall("SetWindowsHookEx", Int, WH_CBT
                                        , Ptr, RegisterCallback("CBTProc", "Fast")
                                        , Ptr, 0
                                        , UInt, DllCall("GetCurrentThreadId") , Ptr)
}

CBTProc(nCode, wp, lp)  {
    static HCBT_CREATEWND := 3, WH_CBT := 5
        , hHook := DllCall("SetWindowsHookEx", Int, WH_CBT
                                            , Ptr, RegisterCallback("CBTProc", "Fast")
                                            , Ptr, 0
                                            , UInt, DllCall("GetCurrentThreadId") , Ptr)
    if (nCode = HCBT_CREATEWND)  {
        VarSetCapacity(WinClass, 256)
        DllCall("GetClassName", Ptr, hwnd := wp, Str, WinClass, Int, 256)
        if (WinClass != "#32770")
            Return
        pCREATESTRUCT := NumGet(lp + 0)
        sTitle := StrGet(pTitle := NumGet(pCREATESTRUCT + A_PtrSize * 5 + 4 * 4), "UTF-16")
        RegExMatch(sTitle, "^(.*)\•(?:x(\d+)\s?)?(?:y(\d+))?$", match)
        ( !(match2 = "" && match3 = "") && StrPut(match1, pTitle, "UTF-16") )
        ( match2 != "" && NumPut(match2, pCREATESTRUCT + A_PtrSize * 4 + 4 * 3, "Int") )
        ( match3 != "" && NumPut(match3, pCREATESTRUCT + A_PtrSize * 4 + 4 * 2, "Int") )
    }
}

;;∙------------∙Utility Functions∙------------∙
EnsurePathExists(path, type, msg := "") {
    if !FileExist(path) {
        if (type = "Directory") {
            FileCreateDir, %path%
        } else if (type = "File") {
            FileAppend,, %path%    ;;∙------∙Create empty file.
            ;;∙------∙FileSetAttrib, +H, %path%    ;;∙------∙*Optional: Make file hidden. (•••)
        }
        DebugMsgBox((msg ? msg : "New " type " created at...`n") path)
    } else {
        DebugMsgBox(type " already exists at...`n" path)
    }
}

ReadFromFile(path) {
    file := FileOpen(path, "r")
    if !file.InError() {
        content := file.Read()
        file.Close()
        return content
    } else {
        MsgBox, 16, Error, Error reading file at...`n %path%, %Secs%
        return ""
    }
}

WriteToFile(path, content) {
    file := FileOpen(path, "w")
    if !file.InError() {
        file.Write(content)
        file.Close()
        ;;∙------∙FileSetAttrib, +H, %path%    ;;∙------∙*Optional: Make file hidden. (•••)
        return true
    } else {
        MsgBox, 16, Error, Error writing to file: %path%, %Secs%
        return false
    }
}

SetVolume(volume) {
    VolumePercentage := Round(volume)    ;;∙------∙Round the volume to nearest whole number.
    SoundSet, %VolumePercentage%
    DebugMsgBox("Volume set to prior instance of " VolumePercentage "%.")
}

DebugMsgBox(text, roundVolume := "") {
    if (Debug) {
        if (roundVolume != "") {
            text := StrReplace(text, "%", Round(roundVolume) "%")    ;;∙------∙Replace placeholders with rounded value.
        }
        MsgBox, , SoundSaver•x1500 y550, %text%, %Secs%    ;;∙------∙MsgBox options, text, timeout.
    }
}

;;∙------------∙MsgBox Timer∙------------∙
MBTimer:
    Secs -= 1
    if (Secs <= 0) {
        SetTimer, MBTimer, Off
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

