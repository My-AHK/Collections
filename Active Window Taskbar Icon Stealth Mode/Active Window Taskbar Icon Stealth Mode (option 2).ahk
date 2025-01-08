
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  Marium0505/Panaku
» Original Source:  https://discord.com/channels/115993023636176902/1029753034575708260/threads/1324492757900857435
» Converted to v1
    ▹ By: Self
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
    try {
        TaskbarList := new ITaskbarList()    ;;∙------∙Create a new instance of the ITaskbarList class.
        activeHwnd := WinExist("A")    ;;∙------∙Get the handle of the currently active window.
        TaskbarList.DeleteTab(activeHwnd)    ;;∙------∙Remove the active window's taskbar tab.
        Sleep, 3000    ;;∙------∙Pause the script for 3 seconds.
        TaskbarList.AddTab(activeHwnd)    ;;∙------∙Re-add the active window's taskbar tab.
    } catch e {    ;;∙------∙Catch any errors that occur during the try block.
        MsgBox, 16, Error, % "An error occurred: " e.Message    ;;∙------∙Display an error message if an exception is caught.
    }
Return


;;∙========∙FUNCTION∙==============================∙
class ITaskbarList {
    static IID := "{56FDF342-FD6D-11d0-958A-006097C9A090}"    ;;∙------∙Define the IID for the ITaskbarList interface.
    static CLSID := "{56FDF344-FD6D-11d0-958A-006097C9A090}"    ;;∙------∙Define the CLSID for the ITaskbarList COM object.

    __New() {  ;;∙------∙Constructor to initialize the ITaskbarList object.
        VarSetCapacity(CLSID, 16, 0)    ;;∙------∙Initialize the CLSID variable to hold the binary representation.
        VarSetCapacity(IID, 16, 0)    ;;∙------∙Initialize the IID variable to hold the binary representation.

        ;;∙------∙Convert CLSID string to binary representation.
        if DllCall("ole32\CLSIDFromString", "wstr", this.CLSID, "ptr", &CLSID) != 0
            throw Exception("Invalid CLSID: " . this.CLSID)    ;;∙------∙Throw an exception if CLSID conversion fails.

        ;;∙------∙Convert IID string to binary representation.
        if DllCall("ole32\CLSIDFromString", "wstr", this.IID, "ptr", &IID) != 0
            throw Exception("Invalid IID: " . this.IID)    ;;∙------∙Throw an exception if IID conversion fails.

        ;;∙------∙Create COM object instance.
        if DllCall("ole32\CoCreateInstance", "ptr", &CLSID, "ptr", 0, "uint", 1, "ptr", &IID, "ptr*", pTaskbarList := 0) != 0
            throw Exception("Failed to create ITaskbarList object.")    ;;∙------∙Throw an exception if the COM object creation fails.

        this.Ptr := pTaskbarList    ;;∙------∙Store the COM object pointer in the Ptr variable.

        ;;∙------∙Initialize the taskbar list.
        this.HrInit()    ;;∙------∙Call the HrInit function to initialize the taskbar list.
    }

HrInit() {  ;;∙------∙Function to initialize the taskbar list.
        return DllCall(NumGet(NumGet(this.Ptr+0)+3*A_PtrSize), "ptr", this.Ptr, "uint")
    }

    AddTab(hwnd) {  ;;∙------∙Function to add a window tab to the taskbar.
        return DllCall(NumGet(NumGet(this.Ptr+0)+4*A_PtrSize), "ptr", this.Ptr, "ptr", hwnd, "uint")
    }

    DeleteTab(hwnd) {  ;;∙------∙Function to remove a window tab from the taskbar.
        return DllCall(NumGet(NumGet(this.Ptr+0)+5*A_PtrSize), "ptr", this.Ptr, "ptr", hwnd, "uint")
    }

    ActivateTab(hwnd) {  ;;∙------∙Function to activate a specific window tab on the taskbar.
        return DllCall(NumGet(NumGet(this.Ptr+0)+6*A_PtrSize), "ptr", this.Ptr, "ptr", hwnd, "uint")
    }

    SetActiveAlt(hwnd) {  ;;∙------∙Function to set a window as the active alternate window.
        return DllCall(NumGet(NumGet(this.Ptr+0)+7*A_PtrSize), "ptr", this.Ptr, "ptr", hwnd, "uint")
    }

    __Delete() {    ;;∙------∙Destructor to clean up the taskbar list object.
        if (this.Ptr)    ;;∙------∙Check if the pointer is valid.
            ObjRelease(this.Ptr)    ;;∙------∙Release the COM object pointer.
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

