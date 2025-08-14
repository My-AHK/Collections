
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙----------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙--------------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
» 
∙--------∙Origins∙-------------------------∙
» Author:  Self
» Source:  
» Simulate a "keyboard event" without sending any actual keystrokes using DllCall in AutoHotkey. This approach allows you to generate a keyboard event at the system level, which can be useful for certain cases where you want to simulate the activity of a keypress without physically typing anything.
» This method doesn't insert the character or send any visible output, but it tells the system that a key event occurred. You can adjust the virtual key code for other keys as needed.
    ▹ keybd_event is a Windows API function used to simulate keyboard events.
    ▹ The virtual key code (0x41) represents the A key.
    ▹ The first DllCall simulates a key press, and the second sim	ulates a key release.
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "ActivitySimulator"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
;;∙============================================================∙
#NoEnv
#Persistent
#SingleInstance, Force
#WinActivateForce
OnExit, CleanUp

;;∙======∙ToolTip Offsets from Cursor∙============∙
;;∙------∙Normal keys.
keyToolTipOffsetX := 20    ;;∙------∙X offset for key press ToolTip.
keyToolTipOffsetY := 0    ;;∙------∙Y offset for key press ToolTip.
;;∙------∙Modifier keys.
modToolTipOffsetX := 20    ;;∙------∙X offset for modifier ToolTip.
modToolTipOffsetY := 21    ;;∙------∙Y offset for modifier ToolTip.
;;∙------∙Mouse nudge.
nudgeToolTipOffsetX := 20    ;;∙------∙X offset for nudge ToolTip.
nudgeToolTipOffsetY := 42    ;;∙------∙Y offset for nudge ToolTip.

;;∙======∙Display Settings∙======================∙
showToolTips := true    ;;∙------∙Set to false to prevent ToolTips.
suppressIniCreation := false    ;;∙------∙Set to true to prevent INI creation.
keepLogs := false    ;;∙------∙Set to true to preserve INI file on exit.

activityLogFile := A_ScriptDir "\ActivitySimulatorLog.ini"


;;∙======∙Key Definitions∙=======================∙
keys := {0x30: "0", 0x31: "1", 0x32: "2", 0x33: "3", 0x34: "4", 0x35: "5", 0x36: "6", 0x37: "7", 0x38: "8", 0x39: "9"
                , 0x41: "A", 0x42: "B", 0x43: "C", 0x44: "D", 0x45: "E", 0x46: "F", 0x47: "G", 0x48: "H", 0x49: "I", 0x4A: "J"
                , 0x4B: "K", 0x4C: "L", 0x4D: "M", 0x4E: "N", 0x4F: "O", 0x50: "P", 0x51: "Q", 0x52: "R", 0x53: "S", 0x54: "T"
                , 0x55: "U", 0x56: "V", 0x57: "W", 0x58: "X", 0x59: "Y", 0x5A: "Z"
                , 0xBC: ",", 0xBE: ".", 0xBF: "/", 0xBD: "-", 0xBA: ";", 0xDE: "'", 0xC0: "``", 0xDB: "[", 0xDC: "\", 0xDD: "]"}

shiftPunctuation := {0xBC: "<", 0xBE: ">", 0xBF: "?", 0xBD: "_", 0xBA: ":", 0xDE: "'", 0xC0: "~"
                , 0xDB: "{", 0xDC: "|", 0xDD: "}", 0x31: "!", 0x32: "@", 0x33: "#", 0x34: "$"
                , 0x35: "%", 0x36: "^", 0x37: "&", 0x38: "*", 0x39: "(", 0x30: ")"}

modifiers := {0xA0: "Shift", 0xA1: "Shift", 0xA2: "Ctrl", 0xA3: "Ctrl", 0xA4: "Alt", 0xA5: "Alt", 0x5B: "Win", 0x5C: "Win"}


;;∙======∙Timing Settings (ms)∙===================∙
keyBounceLow := 50    ;;∙------∙Key press min delay.
keyBounceHigh := 550    ;;∙------∙Key press max delay.

nudgeBounceLow := 750    ;;∙------∙Nudge min delay.
nudgeBounceHigh := 2500    ;;∙------∙Nudge max delay.

modBounceLow := 2000    ;;∙------∙Modifier min delay.
modBounceHigh := 6000    ;;∙------∙Modifier max delay.


;;∙======∙System Initialization∙===================∙
Gui, +LastFound -Caption
Gui, Add, Edit, vHiddenEdit w1 h1
Gui, Show, Hide
hiddenHWND := GuiHwnd

keySimActive := false
idleNudgeActive := false
modifierActive := false


;;∙===========================================∙
;;∙===========================================∙
^t::    ;;∙------∙🔥∙(Ctrl + T)
    ;;∙------∙Toggle states.
    keySimActive := !keySimActive
    idleNudgeActive := !idleNudgeActive
    modifierActive := !modifierActive
    ;;∙------∙Sound feedback.
    SoundBeep, 1000 + 400 * (keySimActive + idleNudgeActive + modifierActive)
    ;;∙------∙Update timers.
    if (keySimActive) {
        SetTimer, RandomKeyPress_Timer, % GetRandomInterval()
    } else {
        SetTimer, RandomKeyPress_Timer, Off
    }
    
    if (idleNudgeActive) {
        SetTimer, InitiateNudge, 200
    } else {
        SetTimer, InitiateNudge, Off
    }
    
    if (modifierActive) {
        SetTimer, RandomModifier_Timer, % GetRandomModInterval()
    } else {
        SetTimer, RandomModifier_Timer, Off
    }
    
    ;;∙------∙Log states.
    LogScriptState("Key Simulation: " (keySimActive ? "ON" : "OFF"))
    LogScriptState("Modifier Keys: " (modifierActive ? "ON" : "OFF"))
    LogScriptState("Idle Nudge: " (idleNudgeActive ? "ON" : "OFF"))
    
    ;;∙------∙Show status.
    if (showToolTips) {
        ShowStatusTooltip()
        SetTimer, HideTooltip, -2000
    }
Return


;;∙======∙CORE FUNCTIONS∙=====================∙
RandomKeyPress_Timer:
    if (keySimActive) {
        RandomKeyPress()
        SetTimer, RandomKeyPress_Timer, % GetRandomInterval()
    }
Return

InitiateNudge:
    if (idleNudgeActive) {
        idleNudge()
    }
Return

RandomModifier_Timer:
    if (modifierActive) {
        RandomModifierPress()
        SetTimer, RandomModifier_Timer, % GetRandomModInterval()
    }
Return


;;∙======∙SUPPORT FUNCTIONS∙=================∙
RandomKeyPress() {
    global keys, shiftPunctuation, showToolTips, keyToolTipOffsetX, keyToolTipOffsetY, activityLogFile, hiddenHWND
    
    ;;∙------∙25% chance to use shifted punctuation.
    useShifted := (Mod(A_TickCount, 4) = 0) && (shiftPunctuation.Count() > 0)
    
    if (useShifted) {
        ;;∙------∙Select random shifted punctuation.
        shiftedKeys := []
        for vk, char in shiftPunctuation
            shiftedKeys.Push({vk: vk, char: char})
        
        Random, randomIndex, 1, % shiftedKeys.Length()
        selected := shiftedKeys[randomIndex]
        randomKey := selected.vk
        keyName := selected.char
        needsShift := true
    } else {
        ;;∙------∙Select random normal key.
        virtualKeyArray := []
        for vk, name in keys
            virtualKeyArray.Push({vk: vk, name: name})
        
        Random, randomIndex, 1, % virtualKeyArray.Length()
        selectedKey := virtualKeyArray[randomIndex]
        randomKey := selectedKey.vk
        keyName := selectedKey.name
        needsShift := false
    }

    ;;∙------∙Show tooltip.
    if (showToolTips) {
        MouseGetPos, mouseX, mouseY
        ToolTip, Simulating: %keyName%, mouseX + keyToolTipOffsetX, mouseY + keyToolTipOffsetY, 1
        SetTimer, HideKeyTooltip, -1000
    }

    ;;∙------∙Send the key.
    if (needsShift) {
        Send {Shift down}
        Sleep, 10
        Send {%randomKey%}
        Sleep, 10
        Send {Shift up}
    } else {
        Send {%randomKey%}
    }

    ;;∙------∙Log to INI.
    FormatTime, timestamp,, yyyy-MM-dd HH:mm:ss
    IniRead, count, %activityLogFile%, Stats, Count, 0
    count++
    IniWrite, %count%, %activityLogFile%, Stats, Count
    IniWrite, %A_Space% %keyName%`t| %timestamp%, %activityLogFile%, Keys, %count%
}

RandomModifierPress() {
    global modifiers, showToolTips, modToolTipOffsetX, modToolTipOffsetY, activityLogFile, hiddenHWND
    
    modifierArray := []
    for vk, name in modifiers
        modifierArray.Push({vk: vk, name: name})
    
    Random, randomIndex, 1, % modifierArray.Length()
    selectedMod := modifierArray[randomIndex]
    randomMod := selectedMod.vk
    modName := selectedMod.name

    ;;∙------∙Show tooltip.
    if (showToolTips) {
        MouseGetPos, mouseX, mouseY
        ToolTip, Simulating Modifier: %modName%, mouseX + modToolTipOffsetX, mouseY + modToolTipOffsetY, 3
        SetTimer, HideModTooltip, -1000
    }

    ;;∙------∙Send modifier.
    Send {%randomMod% down}
    Sleep, 50
    Send {%randomMod% up}

    ;;∙------∙Log to INI.
    FormatTime, timestamp,, yyyy-MM-dd HH:mm:ss
    IniRead, count, %activityLogFile%, Stats, ModCount, 0
    count++
    IniWrite, %count%, %activityLogFile%, Stats, ModCount
    IniWrite, %A_Space% %modName%`t| %timestamp%, %activityLogFile%, Modifiers, %count%
}

idleNudge() {
    global nudgeBounceLow, nudgeBounceHigh, showToolTips, nudgeToolTipOffsetX, nudgeToolTipOffsetY, activityLogFile
    
    Random, iNudge, nudgeBounceLow, nudgeBounceHigh
    iNudgeSec := iNudge / 1000
    formattedNudge := Format("{:.3f}", iNudgeSec)
    
    if (showToolTips) {
        MouseGetPos, mouseX, mouseY
        ToolTip, Next Nudge In:`n%formattedNudge% seconds, mouseX + nudgeToolTipOffsetX, mouseY + nudgeToolTipOffsetY, 2
        SetTimer, HideNudgeTooltip, -1000
    }
    
    Sleep %iNudge%
    MouseMove, 0, 0, 0, R
    
    ;;∙------∙Log nudge.
    FormatTime, timestamp,, yyyy-MM-dd HH:mm:ss
    IniRead, count, %activityLogFile%, Stats, NudgeCount, 0
    count++
    IniWrite, %count%, %activityLogFile%, Stats, NudgeCount
    IniWrite, %A_Space% %formattedNudge%s%A_Space% `t| %timestamp%, %activityLogFile%, Nudges, %count%
}


;;∙======∙UTILITY FUNCTIONS∙==================∙
GetRandomInterval() {
    global keyBounceLow, keyBounceHigh
    Random, interval, keyBounceLow, keyBounceHigh
    Return interval
}

GetRandomModInterval() {
    global modBounceLow, modBounceHigh
    Random, interval, modBounceLow, modBounceHigh
    Return interval
}

LogScriptState(state) {
    global activityLogFile
    FormatTime, timestamp,, yyyy-MM-dd HH:mm:ss
    IniRead, count, %activityLogFile%, Stats, StateCount, 0
    count++
    IniWrite, %count%, %activityLogFile%, Stats, StateCount
    IniWrite, %state%`t| %timestamp%, %activityLogFile%, StateChanges, %count%
}

ShowStatusTooltip() {
    global keySimActive, idleNudgeActive, modifierActive
    
    statusText := "System Status:`n"
    statusText .= "• Key Simulation: " (keySimActive ? "ACTIVE" : "INACTIVE") "`n"
    statusText .= "• Modifier Keys: " (modifierActive ? "ACTIVE" : "INACTIVE") "`n"
    statusText .= "• Idle Nudge: " (idleNudgeActive ? "ACTIVE" : "INACTIVE")
    
    ToolTip, %statusText%
}

HideTooltip:
    ToolTip
return

HideKeyTooltip:
    ToolTip,,,, 1
return

HideNudgeTooltip:
    ToolTip,,,, 2
return

HideModTooltip:
    ToolTip,,,, 3
return

Cleanup:
    SetTimer, RandomKeyPress_Timer, Off
    SetTimer, InitiateNudge, Off
    SetTimer, RandomModifier_Timer, Off
    
    ;;∙------∙Only delete INI file if keepLogs is false.
    if (!keepLogs && FileExist(activityLogFile)) {
        FileDelete, %activityLogFile%
    }
ExitApp
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
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙--∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        SoundBeep, 1100, 75
        Soundbeep, 1200, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙--∙Double-Tap.
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
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;; Gui Drag Pt 1.
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
Menu, Tray, Add
;;------------------------------------------∙

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
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙MENU CALLS∙==========================================∙
ActivitySimulator:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

