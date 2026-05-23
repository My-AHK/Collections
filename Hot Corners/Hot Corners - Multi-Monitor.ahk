
SetTimer, UpdateCheck, 500
Menu, Tray, Icon, imageres.dll, 251
GoSub, TrayMenu

;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙



;;∙======∙DIRECTIVES & SETTINGS∙==================∙
#Requires AutoHotkey 1
#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines -1
SetMouseDelay, -1
SetWinDelay, 0
AutoTrim, Off
ListLines, Off
Menu, Tray, Icon, imageres.dll, 251
SetWorkingDir, %A_ScriptDir%

;;∙------∙Enable DPI awareness so Mouse & Monitor coordinates stay aligned.
If (!DllCall("SetProcessDPIAware"))
{
    ;;∙------∙Fallback for newer Windows DPI handling APIs.
    If (!DllCall("SetProcessDpiAwarenessContext", "ptr", -4, "uint"))
    {
        MsgBox, 48, DPI Warning,
        (LTrim
            Unable to set DPI awareness.
            --  --  --  --  --   --  --  --  --  --   --
            On multi-monitor setups with different scaling levels,
            corner detection may be inaccurate or fail entirely.
            --  --  --  --  --   --  --  --  --  --   --
            Single monitor or identical scaling setups
            should still work correctly.
        ), 6
    }
}

;;∙------∙Use absolute screen coordinates for mouse & pixel checks.
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen    ;;∙------∙Prevents accidental scaling drift.


;;∙------∙Key modifier requirement for hot corners. 
RequireModifier := true    ;;∙------∙Set to false to disable modifier requirement.
RequiredModifierKey := "Ctrl"    ;;∙------∙Requires "key" held down for corner actions.

/*  ∙------------∙Modifier Key Options∙------------∙
Configuration examples... just change the RequiredModifierKey variable:
• Single Keys
        RequiredModifierKey := "Alt"

• Multiple Keys - ANY (OR logic)
        RequiredModifierKey := ["Ctrl", "Shift", "Alt"]    ;;∙------∙Ctrl OR Shift OR Alt.

• Multiple Keys - ALL (AND logic)
        RequiredModifierKey := {keys: ["Ctrl", "Shift", "Alt"], mode: "all"}    ;;∙------∙Ctrl AND Shift AND Alt together.
∙---------------------------------------------------------∙
*/


CornerSize := 30    ;;∙------∙Corner detection radius in pixels from each monitor corner.

EnableErrorLog := true    ;;∙------∙Set to false to disable error logging.
LogFile := A_ScriptDir . "\HotCorner_Errors.log"


;;∙======∙MONITOR CACHE∙=======================∙
MonitorBounds := {}
SysGet, MonitorCount, MonitorCount

;;∙------∙Abort if no monitors are detected.
If (MonitorCount < 1)
{
    MsgBox, 16, HotCorner Error, No monitors were detected. The script will now exit., 4
    ExitApp
}

Loop, %MonitorCount%
{
    ;;∙------∙Retrieve monitor boundaries.
    SysGet, Mon, Monitor, %A_Index%

    ;;∙------∙Validate boundaries, skip monitors with invalid coordinates.
    If (MonLeft >= MonRight || MonTop >= MonBottom)
    {
        LogError("Monitor " . A_Index . " has invalid boundaries - skipping")
        Continue    ;;∙------∙Skip this monitor, move to the next.
    }

    ;;∙------∙Log suspicious monitor coordinate values.
    If (Abs(MonLeft) > 20000 || Abs(MonRight) > 20000 
        || Abs(MonTop) > 20000 || Abs(MonBottom) > 20000)
    {
        LogError("Monitor " . A_Index . " has unusually large coordinates - possible driver issue")
    }

    ;;∙------∙Store monitor boundaries for faster access later.
    MonitorBounds[A_Index] := {}
    MonitorBounds[A_Index].Left   := MonLeft
    MonitorBounds[A_Index].Right  := MonRight
    MonitorBounds[A_Index].Top    := MonTop
    MonitorBounds[A_Index].Bottom := MonBottom
}


;;∙======∙ACTION MATRIX∙========================∙
;;∙------∙Maps monitor corners to function names.
Actions := {}

Actions[1, "TL"] := "TL_M1"
Actions[1, "TR"] := "TR_M1"
Actions[1, "BL"] := "BL_M1"
Actions[1, "BR"] := "BR_M1"

Actions[2, "TL"] := "TL_M2"
Actions[2, "TR"] := "TR_M2"
Actions[2, "BL"] := "BL_M2"
Actions[2, "BR"] := "BR_M2"

Actions[3, "TL"] := "TL_M3"
Actions[3, "TR"] := "TR_M3"
Actions[3, "BL"] := "BL_M3"
Actions[3, "BR"] := "BR_M3"

LastCorner := ""

;;∙------∙Poll mouse position every 200ms.
SetTimer, HotCorner, 200
Return


;;∙======∙HOT CORNER ROUTINE∙===================∙
HotCorner:
    ;;∙------∙Check if modifier key is required & pressed.
    modifierPressed := false
    
    If (RequireModifier)
    {
        modifierPressed := CheckModifierPressed()
    }
    Else
        modifierPressed := true
    
    ;;∙------∙Only detect corners if modifier is pressed (or not required).
    If (modifierPressed)
    {
        ;;∙------∙Get current mouse position.
        MouseGetPos, mouseX, mouseY
        CurrentCorner := ""
        
        ;;∙------∙Check each monitor for corner activation.
        Loop, %MonitorCount%
        {
            Mon := MonitorBounds[A_Index]
            
            ;;∙------∙Top Left Corner.
            If (mouseX >= Mon.Left
            && mouseX <= Mon.Left + CornerSize
            && mouseY >= Mon.Top
            && mouseY <= Mon.Top + CornerSize)
            {
                Corner := "TL"
                MonitorNumber := A_Index
                CurrentCorner := MonitorNumber "_" Corner
                Break
            }
            
            ;;∙------∙Top Right Corner.
            Else If (mouseX >= Mon.Right - CornerSize
            && mouseX <= Mon.Right
            && mouseY >= Mon.Top
            && mouseY <= Mon.Top + CornerSize)
            {
                Corner := "TR"
                MonitorNumber := A_Index
                CurrentCorner := MonitorNumber "_" Corner
                Break
            }
            
            ;;∙------∙Bottom Left Corner.
            Else If (mouseX >= Mon.Left
            && mouseX <= Mon.Left + CornerSize
            && mouseY >= Mon.Bottom - CornerSize
            && mouseY <= Mon.Bottom)
            {
                Corner := "BL"
                MonitorNumber := A_Index
                CurrentCorner := MonitorNumber "_" Corner
                Break
            }
            
            ;;∙------∙Bottom Right Corner.
            Else If (mouseX >= Mon.Right - CornerSize
            && mouseX <= Mon.Right
            && mouseY >= Mon.Bottom - CornerSize
            && mouseY <= Mon.Bottom)
            {
                Corner := "BR"
                MonitorNumber := A_Index
                CurrentCorner := MonitorNumber "_" Corner
                Break
            }
        }
        
        ;;∙------∙Trigger only when entering a new corner.
        If (CurrentCorner != "" && CurrentCorner != LastCorner)
        {
            LastCorner := CurrentCorner
            Gosub, ExecuteAction
        }
        
        ;;∙------∙Reset once mouse leaves all corners.
        Else If (CurrentCorner = "")
        {
            LastCorner := ""
        }
    }
    Else
    {
        ;;∙------∙Modifier not pressed, reset corner tracking.
        LastCorner := ""
    }
Return


;;∙======∙MODIFIER CHECKER∙=====================∙
CheckModifierPressed() {
    Global RequiredModifierKey
    
    ;;∙------∙Handle string input (single modifier).
    If (RequiredModifierKey = "Ctrl")
        Return GetKeyState("Ctrl", "P")
    Else If (RequiredModifierKey = "Shift")
        Return GetKeyState("Shift", "P")
    Else If (RequiredModifierKey = "Alt")
        Return GetKeyState("Alt", "P")
    Else If (RequiredModifierKey = "Win")
        Return (GetKeyState("LWin", "P") or GetKeyState("RWin", "P"))
    
    ;;∙------∙Handle array input (ANY modifier - Ctrl OR Shift).
    Else If (IsObject(RequiredModifierKey) && RequiredModifierKey.Length() && !RequiredModifierKey.HasKey("mode"))
    {
        Loop, % RequiredModifierKey.Length()
        {
            key := RequiredModifierKey[A_Index]
            If (key = "Ctrl" && GetKeyState("Ctrl", "P"))
                Return true
            Else If (key = "Shift" && GetKeyState("Shift", "P"))
                Return true
            Else If (key = "Alt" && GetKeyState("Alt", "P"))
                Return true
            Else If (key = "Win" && (GetKeyState("LWin", "P") or GetKeyState("RWin", "P")))
                Return true
        }
        Return false
    }
    
    ;;∙------∙Handle object input with mode (ALL modifiers - Ctrl AND Shift).
    Else If (IsObject(RequiredModifierKey) && RequiredModifierKey.HasKey("keys") && RequiredModifierKey.HasKey("mode"))
    {
        If (RequiredModifierKey.mode = "all")
        {
            allPressed := true
            Loop, % RequiredModifierKey.keys.Length()
            {
                key := RequiredModifierKey.keys[A_Index]
                If (key = "Ctrl" && !GetKeyState("Ctrl", "P"))
                    allPressed := false
                Else If (key = "Shift" && !GetKeyState("Shift", "P"))
                    allPressed := false
                Else If (key = "Alt" && !GetKeyState("Alt", "P"))
                    allPressed := false
                Else If (key = "Win" && !(GetKeyState("LWin", "P") or GetKeyState("RWin", "P")))
                    allPressed := false
            }
            Return allPressed
        }
    }
    
    ;;∙------∙Fallback, no modifier required.
    Return false    ;;∙------∙Changed from true to false - require modifier by default
}

;;∙======∙ACTIONS EXECUTION∙====================∙
ExecuteAction:
    ;;∙------∙Look up assigned action for this monitor corner.
    action := Actions[MonitorNumber, Corner]

    ;;∙------∙Fallback if no action is assigned.
    If (action = "")
    {
        LogError("No action mapped", MonitorNumber, Corner)
        DefaultCornerAction(MonitorNumber, Corner)
        Return
    }

    ;;∙------∙Validate function existence before calling it.
    If (!IsFunc(action))
    {
        LogError("Function not found: " . action, MonitorNumber, Corner)
        ToolTip, Function "%action%" does not exist - using fallback
        SetTimer, RemoveToolTip, -2000
        DefaultCornerAction(MonitorNumber, Corner)
        Return
    }

    ;;∙------∙Execute mapped corner function.
    Func(action).Call()
Return


;;∙======∙MONITOR 1∙(*set as needed here*)∙
TL_M1() {
    SoundBeep, 900, 250
    MsgBox,,, Monitor 1 Top Left, 2
}

TR_M1() {
    SoundBeep, 1000, 250
    MsgBox,,, Monitor 1 Top Right, 2
}

BL_M1() {
    SoundBeep, 1100, 250
    MsgBox,,, Monitor 1 Bottom Left, 2
}

BR_M1() {
    SoundBeep, 800, 250
    MsgBox,,, Monitor 1 Bottom Right, 2
}


;;∙======∙MONITOR 2∙(*set as needed here*)∙
TL_M2() {
    ToolTip, Monitor 2 Top Left
    SetTimer, RemoveToolTip, -2000
}

TR_M2() {
    ToolTip, Monitor 2 Top Right
    SetTimer, RemoveToolTip, -2000
    SoundBeep, 1550, 200
}

BL_M2() {
    ToolTip, Monitor 2 Bottom Left
    SetTimer, RemoveToolTip, -2000
}

BR_M2() {
    ToolTip, Monitor 2 Bottom Right
    SetTimer, RemoveToolTip, -2000
    SoundBeep, 1050, 200
}


;;∙======∙MONITOR 3∙(*set as needed here*)∙
TL_M3() {
    SoundBeep, 800, 150
}

TR_M3() {
    SoundBeep, 1000, 150
}

BL_M3() {
    SoundBeep, 1200, 150
}

BR_M3() {
    SoundBeep, 1400, 150
}


;;∙======∙MONITOR #4,5,6 etc...


;;∙======∙FALLBACK ACTION∙======================∙
DefaultCornerAction(monitor, corner) {
    ;;∙------∙Shown when a corner has no assigned action.
    ToolTip, Monitor %monitor% %corner% corner (no action set)
    SetTimer, RemoveToolTip, -2500
}


;;∙======∙ERROR LOGGING∙=======================∙
LogError(message, monitor := "", corner := "") {
    Global EnableErrorLog, LogFile

    ;;∙------∙Skip logging if disabled.
    If (!EnableErrorLog)
        Return

    ;;∙------∙Generate timestamp.
    timestamp := A_Now
    FormatTime, formattedTime, %timestamp%, MM-dd-yyyy hh:mm:ss tt

    ;;∙------∙Build log entry text.
    entry := formattedTime . " | " . message
    If (monitor != "")
        entry .= " | Monitor: " . monitor
    If (corner != "")
        entry .= " | Corner: " . corner
    entry .= "`n"

    ;;∙------∙Append error entry to log file.
    FileAppend, %entry%, %LogFile%
}


;;∙==================∙
RemoveToolTip:
    ToolTip
Return
;;∙=============================================∙

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
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
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

;;∙------∙MENU-HEADER∙---------------∙
TEMPLATE:    ;;∙------∙Suspends hotkeys then pauses script.
    Suspend
    Soundbeep, 800, 200
    Pause
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

