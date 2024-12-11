
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
» Author:  SKAN
» Source:  https://www.autohotkey.com/boards/viewtopic.php?t=4334#p24186
» Auto-elevates script without UAC prompt. (*UAC will prompt on the first run*)
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TEMPLATE"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙🔥 HotKey 🔥∙===========================================∙
; ^t::    ;;∙------∙(Ctrl+T) 
;    Soundbeep, 1100, 100
;;∙============================================================∙




;;∙============================================================∙
;;∙------∙Usage example∙-------∙
RunAsTask()    ;;∙------∙Call the function to self-elevate.
    Run RegEdit.exe    ;;∙------∙Launch RegEdit.exe with elevated rights.
Return
;;∙----------------------------------∙

RunAsTask() {
    Local CmdLine, TaskName, TaskExists, XML, TaskSchd, TaskRoot, RunAsTask    ;;∙------∙Declare local variables.
    Local TASK_CREATE := 0x2,  TASK_LOGON_INTERACTIVE_TOKEN := 3    ;;∙------∙Define constants for task creation.

    Try TaskSchd  := ComObjCreate( "Schedule.Service" ),    ;;∙------∙;;∙------∙Attempt to create a COM object for Task Scheduler.
        TaskSchd.Connect()    ;;∙------∙∙Connect to the Task Scheduler.
        , TaskRoot  := TaskSchd.GetFolder( "\" )    ;;∙------∙Access the root folder in Task Scheduler.
    Catch    ;;∙------∙Handle errors if Task Scheduler setup fails.
        Return "", ErrorLevel := 1    ;;∙------∙Set ErrorLevel to 1 and exit.

    CmdLine := ( A_IsCompiled ? "" : """"  A_AhkPath " """ ) .    ;;∙------∙Formulate the command line to execute the script.
               ( """" A_ScriptFullpath """" )
    TaskName := "[RunAsTask] " A_ScriptName " @"    ;;∙------∙Generate a unique task name based on the script.
        SubStr( "000000000"  DllCall( "NTDLL\RtlComputeCrc32",    ;;∙------∙Compute a CRC32 checksum for task name uniqueness.
        "Int",0, "WStr",CmdLine, "UInt",StrLen( CmdLine ) * 2, "UInt" ), -9 )

    Try RunAsTask := TaskRoot.GetTask( TaskName )    ;;∙------∙Attempt to retrieve the task by its name.
    TaskExists    := ! A_LastError    ;;∙------∙Check if the task already exists.

    If ( not A_IsAdmin and TaskExists ) {    ;;∙------∙If not running as admin but the task exists:
        RunAsTask.Run( "" )    ;;∙------∙Run the existing task.
        ExitApp    ;;∙------∙Exit the non-elevated instance.
    }

    If ( not A_IsAdmin and not TaskExists ) {    ;;∙------∙If not running as admin and the task does not exist:
        Run *RunAs %CmdLine%, %A_ScriptDir%, UseErrorLevel    ;;∙------∙Run the script as admin using the `*RunAs` flag.
        ExitApp    ;;∙------∙∙Exit the non-elevated instance.
    }

    If ( A_IsAdmin and not TaskExists ) {    ;;∙------∙If running as admin and the task does not exist:
        XML :=    ;;∙------∙Define the XML structure for task creation.
        "
            ( LTrim Join
                <?xml version=""1.0"" ?><Task xmlns=""http://schemas.microsoft.com/windows/2004/02/mit/task""><Regi
                strationInfo /><Triggers /><Principals><Principal id=""Author""><LogonType>InteractiveToken</LogonT
                ype><RunLevel>HighestAvailable</RunLevel></Principal></Principals><Settings><MultipleInstancesPolic
                y>Parallel</MultipleInstancesPolicy><DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries><
                StopIfGoingOnBatteries>false</StopIfGoingOnBatteries><AllowHardTerminate>false</AllowHardTerminate>
                <StartWhenAvailable>false</StartWhenAvailable><RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAva
                ilable><IdleSettings><StopOnIdleEnd>true</StopOnIdleEnd><RestartOnIdle>false</RestartOnIdle></IdleS
                ettings><AllowStartOnDemand>true</AllowStartOnDemand><Enabled>true</Enabled><Hidden>false</Hidden><
                RunOnlyIfIdle>false</RunOnlyIfIdle><DisallowStartOnRemoteAppSession>false</DisallowStartOnRemoteApp
                Session><UseUnifiedSchedulingEngine>false</UseUnifiedSchedulingEngine><WakeToRun>false</WakeToRun><
                ExecutionTimeLimit>PT0S</ExecutionTimeLimit></Settings><Actions Context=""Author""><Exec>
                <Command>""" ( A_IsCompiled ? A_ScriptFullpath : A_AhkPath ) """</Command>
                <Arguments>" ( !A_IsCompiled ? """" A_ScriptFullpath  """" : "" )   "</Arguments>
                <WorkingDirectory>" A_ScriptDir "</WorkingDirectory></Exec></Actions></Task>
            )"    
        TaskRoot.RegisterTask( TaskName, XML, TASK_CREATE, "", "", TASK_LOGON_INTERACTIVE_TOKEN )    ;;∙------∙Register the task in Task Scheduler.
    }

    Return TaskName, ErrorLevel := 0    ;;∙------∙Return the task name and reset ErrorLevel to 0.
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
Menu, Tray, Icon, Suspend / Pause, shell32, 28  ;  Imageres.dll, 65
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

