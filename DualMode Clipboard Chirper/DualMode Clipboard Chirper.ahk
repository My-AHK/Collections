
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  Guests
» Original Concept:  https://www.autohotkey.com/board/topic/29225-clipboard-beep/
» 
    ▹ 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "Clipboard_Chirper"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
;;∙============================================================∙
/*∙----------------⮞ DUALMODE CLIPBOARD CHIRPER ⮜-------------------------∙
   • Dual operating modes:
        - CHANGE DETECTION: Beeps only when clipboard content changes
        - EVERY COPY: Beeps on every copy action (even duplicate content)
   • Tray controls:
        - SOUND TOGGLE: Enable/disable all beeping (tray icon updates)
        - MODE TOGGLE: Switch between Change/Every detection modes
   • Visual feedback:
        - Persistent tray tooltip shows current mode/mute status
        - Temporary desktop tooltips confirm toggle actions
   • Volume management:
        - Temporarily sets system volume during beep
        - Restores original volume after beep
   • Startup protection: Ignores clipboard events during first second
∙-------------------------------------------------------------------------------------------∙
*/

;;∙======⮞ Auto-Execute ⮜============∙
#NoEnv
#KeyHistory 0
#SingleInstance, Force
#Persistent
SetBatchLines, -1
SetWinDelay, -1
ListLines, Off
Menu, Tray, Icon, ieframe.dll, 97

;;∙======⮞ Initialize variables ⮜====================∙
prevClipboard := Clipboard
scriptStartTime := A_TickCount
beepEnabled := true
beepMode := "change"
beepVolume := 2

;;∙======⮞ Tray Menu Setup ⮜=====================∙
Menu, Tray, NoStandard

; Create menu items with initial text showing CURRENT STATUS
modeText := (beepMode = "change") ? "Change Detection" : "Every Copy"
Menu, Tray, Add, %modeText%, ToggleMode
Menu, Tray, Icon, %modeText%, shell32.dll, 261
currentModeText := modeText

beepText := beepEnabled ? "Beep Active" : "Beep Silent"
Menu, Tray, Add, %beepText%, ToggleBeep
Menu, Tray, Icon, %beepText%, wmploc.dll, 67
currentBeepText := beepText

Menu, Tray, Add
UpdateTrayTip()
SetTimer, ActivateClipboardMonitor, -100
Return

;;∙======⮞ MAIN CLIPBOARD HANDLER ⮜============∙
ActivateClipboardMonitor:
    OnClipboardChange:
        if (A_TickCount - scriptStartTime < 1000)
            return
        if (beepEnabled) {
            if (beepMode = "change") {
                if (Clipboard != prevClipboard) && (Clipboard != "") {
                    SoundGet, master_volume, Master
                    SoundSet, %beepVolume%, Master
                    SoundBeep, 500, 300
                    SoundSet, master_volume, Master
                    prevClipboard := Clipboard
                }
            } else {
                if (Clipboard != "") {
                    SoundGet, master_volume, Master
                    SoundSet, %beepVolume%, Master
                    SoundBeep, 500, 300
                    SoundSet, master_volume, Master
                    prevClipboard := Clipboard
                }
            }
        }
    return
Return

;;∙======⮞ TOGGLE FUNCTIONS ⮜==================∙
ToggleBeep:
    beepEnabled := !beepEnabled
    
    ; Update text to show CURRENT STATUS
    newText := beepEnabled ? "Beep Active" : "Beep Silent"
    
    ; Rename the menu item
    Menu, Tray, Rename, %currentBeepText%, %newText%
    currentBeepText := newText
    
    ; Update icon based on state
    if (beepEnabled) {
        Menu, Tray, Icon, %newText%, wmploc.dll, 67
    } else {
        Menu, Tray, Icon, %newText%, imageres.dll, 168
    }
    
    UpdateTrayTip()
    status := beepEnabled ? "ENABLED" : "MUTED"
    MouseGetPos, mx, my
    ToolTip, Clipboard beep is now %status%, mx - 60, my - 25
    SetTimer, KillTip, -2000
Return

ToggleMode:
    if (beepMode = "change") {
        beepMode := "every"
        newText := "Every Copy"  ; Show CURRENT MODE
    } else {
        beepMode := "change"
        newText := "Change Detection"  ; Show CURRENT MODE
    }
    
    ; Rename the menu item
    Menu, Tray, Rename, %currentModeText%, %newText%
    currentModeText := newText
    
    ; Update icon based on mode
    if (beepMode = "change") {
        Menu, Tray, Icon, %newText%, shell32.dll, 261
    } else {
        Menu, Tray, Icon, %newText%, imageres.dll, 242
    }
    
    UpdateTrayTip()
    modeDisplayText := (beepMode = "change") ? "Change Detection" : "Every Copy"
    MouseGetPos, mx, my
    ToolTip, Now beeping on: %modeDisplayText%, mx - 60, my - 25
    SetTimer, KillTip, -2000
Return

UpdateTrayTip() {
    global beepEnabled, beepMode
    status := beepEnabled ? "ACTIVE" : "MUTED"
    mode := (beepMode = "change") ? "Change Detection" : "Every Copy"
    Menu, Tray, Tip, % "Clipboard Monitor [" status "]`nMode: " mode
}
Return

KillTip:
    ToolTip
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
;    Soundbeep, 1700, 100
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
Clipboard_Chirper:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

