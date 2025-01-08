
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Author:  Marium0505 (v2)
» Source:  https://discord.com/channels/115993023636176902/1029753034575708260/threads/1324492757900857435
» Converted to v1
    ▹ By: Self
∙--------------------------------------------∙
» Original Author:  maul-esel
» Original Source: GITHUB:  https://github.com/maul-esel/ITaskbarList/
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
^t::    ;;∙------∙(Ctrl+T) 
    Soundbeep, 1000, 200
;;∙============================================================∙




;;∙============================================================∙
TaskbarList1 := new ITaskbarList1()    ;;∙------∙Create an instance of ITaskbarList1 class.
activeHwnd := WinExist("A")    ;;∙------∙Get handle of active window.

TaskbarList1.DeleteTab(activeHwnd)    ;;∙------∙REMOVE TaskBar Icon for active window.

Sleep, 3000  ;;∙------∙Wait 3 seconds. (for testing purpose)

;;∙------------------------------------------------------------------------∙
;;∙------∙TaskbarList1.AddTab(activeHwnd)    ;;∙------∙RESTORE TaskBar Icon. (below method has error checking)

if !TaskbarList1.AddTab(activeHwnd) {    ;;∙------∙"Try" to RESTORE TaskBar Icon.(UPGRADED !!!)
    MsgBox, 16, Error, Failed to restore TaskBar Icon. Attempting recovery...,2    ;;∙------∙Failure.
    Loop, 3 {    ;;∙------∙Retry restoring up to 3 times.
        Sleep, 1000  ;;∙------∙Wait 1 second before retrying.
        if TaskbarList1.AddTab(activeHwnd) {
            MsgBox, 64, Success, TaskBar Icon successfully restored after recovery.,2    ;;∙------∙Success.
            break
        }
    }
    if (A_Index = 3) {    ;;∙------∙All Attempts Failed!!
        MsgBox, 16, Error, Unable to restore the TaskBar Icon`n          after multiple attempts!`n      Please investigate manually.
    }
}
;;∙------------------------------------------------------------------------∙
Return


;;∙========∙FUNCTION∙==============================∙
class ITaskbarList1 {
    static IID := "{56FDF342-FD6D-11d0-958A-006097C9A090}"  ;;∙------∙Interface Identifier.
    static CLSID := "{56FDF344-FD6D-11d0-958A-006097C9A090}"  ;;∙------∙Class Identifier.

    __New() {
        this.ComObj := ComObjCreate(this.CLSID, this.IID)    ;;∙------∙Create COM object using its CLSID and IID.
        this.Ptr := ComObjQuery(this.ComObj, this.IID)    ;;∙------∙Retrieve a pointer to ITaskbarList1 interface.
        if !this.HrInit() {    ;;∙------∙Initialize COM object and check for success.
            ObjRelease(this.Ptr)    ;;∙------∙Release pointer if initialization fails.
            this.Ptr := ""    ;;∙------∙Reset pointer to an empty state.
            throw Exception("HrInit() failed")    ;;∙------∙Throw exception if initialization fails.
        }
    }

    HrInit() {    ;;∙------∙Call HrInit method to initialize taskbar interface.
        return DllCall(NumGet(NumGet(this.Ptr+0)+3*A_PtrSize), "ptr", this.Ptr, "uint") = 0
    }

    AddTab(hwnd) {    ;;∙------∙Add or restore TaskBar Icon for a given window handle.
        return DllCall(NumGet(NumGet(this.Ptr+0)+4*A_PtrSize), "ptr", this.Ptr, "ptr", hwnd, "uint") = 0
    }

    DeleteTab(hwnd) {    ;;∙------∙Remove TaskBar Icon for a given window handle.
        return DllCall(NumGet(NumGet(this.Ptr+0)+5*A_PtrSize), "ptr", this.Ptr, "ptr", hwnd, "uint") = 0
    }

    ActivateTab(hwnd) {    ;;∙------∙Set a given window as active taskbar tab.
        return DllCall(NumGet(NumGet(this.Ptr+0)+6*A_PtrSize), "ptr", this.Ptr, "ptr", hwnd, "uint") = 0
    }

    SetActiveAlt(hwnd) {    ;;∙------∙Set a given window as active tab in alternate manner.
        return DllCall(NumGet(NumGet(this.Ptr+0)+7*A_PtrSize), "ptr", this.Ptr, "ptr", hwnd, "uint") = 0
    }

    __Delete() {
        if this.Ptr    ;;∙------∙Check if pointer is valid before attempting cleanup.
            ObjRelease(this.Ptr)    ;;∙------∙Release COM pointer to prevent memory leaks.
    }
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

