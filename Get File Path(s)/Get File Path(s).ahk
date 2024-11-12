
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script ∙---------∙ DoubleTap--⮚ Ctrl + [HOME] 
» Exit Script ∙-------------∙ DoubleTap--⮚ Ctrl + [Esc] 
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
» 
∙--------∙Source∙-------------------------∙
» 
» Author:  
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙🔥 HotKey 🔥∙===========================================∙


^g::    ;;∙------∙(Ctrl+g) (may require a quick interup here such as Sleep or Soundbeep)
Sleep 10
Soundbeep, 1000, 100


;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Get Path(s)∙============================================∙
GetPaths() {
    selectFiles := ""
    selectFolder := ""
    activeApp := ""

    hwnd := WinExist("A")
    WinGetClass, Class, ahk_id %hwnd%
    WinGet, Process, ProcessName, ahk_id %hwnd%

    if (Process = "explorer.exe") {
            if (Class ~= "Progman|WorkerW") {
                    ControlGet, Files, List, Selected Col1, SysListView321, ahk_Class %Class%
                    loop, Parse, Files, `n, `r
                            selectFiles .= A_Desktop "\" A_LoopField "`n"
            } else if (Class ~= "(Cabinet|Explore)WClass") {
                    for window in ComObjCreate("Shell.Application").Windows
                            if (window.hwnd == hwnd)
                                    sel := window.Document.SelectEditems
                    for item in sel
                            selectFiles .= item.path "`n"
                    if (selectFiles = "")
                            selectFolder := window.Document.Folder.Self.Path
                }
    } else {
            activeApp := ProcessPath := GetActiveAppPath()
        }
    if (selectFiles = "") {
            if (selectFolder = "") {
                    if (activeApp = "") {
                            MsgBox, 64,, Nothing was found`n`tTry Again, 5
                            return ""
                    } else {
                            return activeApp
                        }
            } else {
                    return selectFolder
                }
    } else {
            return selectFiles
        }
}
GetActiveAppPath() {
    hwnd := WinExist("A")
    WinGet, ProcessPath, ProcessPath, ahk_id %hwnd%
    return ProcessPath
}

selectFiles := GetPaths()
Clipboard := selectFiles
ToolTip, Selected Path(s) Copied To Clipboard`n`n%selectFiles%
SetTimer, TimerKillswitch, -4000
Return

;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Timer Kill Switch∙=======================================∙
TimerKillSwitch:
    ToolTip
Return
;;∙============================================================∙




;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙EDIT \ RELOAD / EXIT∙===================================∙
;;----------------------- EDIT \ RELOAD / EXIT --------------------------∙
RETURN
;;∙-------∙EDIT∙-------∙EDIT∙------------∙
Script·Edit:
    Edit
Return
;;∙------∙RELOAD∙----∙RELOAD∙-------∙
^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;; Double-Tap.
    Script·Reload:    ;;----Menu Call.
    ; Soundbeep, 1200, 75
        ; Soundbeep, 1400, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;; Double-Tap.
    Script·Exit:    ;;----Menu Call.
        ; Soundbeep, 1400, 75
    ; Soundbeep, 1200, 100
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
UpdateCheck:        ;; Check if the script file has been modified.
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
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;; Gui Drag Pt 1.
SetBatchLines -1
SetTimer, UpdateCheck, 500
SetTitleMatchMode 2
SetWinDelay 0
Menu, Tray, Icon, Imageres.dll, 65
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Tray Menu∙============================================∙
TrayMenu:
Menu, Tray, Tip, Get_Paths    ;;----Suspends hotkeys then pauses script.
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Get_Paths
Menu, Tray, Icon, Get_Paths, Imageres.dll, 65
Menu, Tray, Default, Get_Paths    ;; Makes Bold.
Menu, Tray, Add
;;∙------∙  ∙--------------------------------∙

;;∙------∙Script∙Options∙---------------∙
Menu, Tray, Add
Menu, Tray, Add, Script·Edit
Menu, Tray, Icon, Script·Edit, shell32.dll, 270
Menu, Tray, Add
Menu, Tray, Add, Script·Reload
Menu, Tray, Icon, Script·Reload, mmcndmgr.dll, 47
Menu, Tray, Add
Menu, Tray, Add, Script·Exit
Menu, Tray, Icon, Script·Exit, shell32.dll, 272
Menu, Tray, Add
Menu, Tray, Add
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙MENU CALLS∙==========================================∙
Get_Paths:
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
;;∙======∙TRAY MENU POSITION FUNTION∙======∙
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
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙

;;∙========================∙SCRIPT END∙=========================∙
;;∙------------------------------------------------------------------------------------------∙

