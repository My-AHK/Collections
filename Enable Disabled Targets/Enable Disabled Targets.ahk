
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙--------∙Origins∙-------------------------∙
» Original Author:  Raccoon
» Original Source:  https://www.autohotkey.com/board/topic/57480-enable-any-windowbutton-you-click-on/
» Activates or "enables" any disabled window or control beneath the mouse cursor when you press the left mouse button.
∙--------------------------------------------∙
* See 'Use Case Examples' at script end.
∙--------------------------------------------∙
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "Enable_Disabled_Targets"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
#If Enable_Disabled_Targets() || True
~LButton::     ;;∙------∙🔥∙(Left Mouse Button)
Return
#If 

;;∙------------------------------------∙
Enable_Disabled_Targets() 
    {
        MouseGetPos,,, WinHndl, CtlHndl, 2
        WinGet, Style, Style, ahk_id %WinHndl%
        if (Style & 0x8000000) {     ;;∙------∙WS_DISABLED.
            WinSet, Enable,, ahk_id %WinHndl%
        }
        WinGet, Style, Style, ahk_id %CtlHndl%
        if (Style & 0x8000000) {
            WinSet, Enable,, ahk_id %CtlHndl%
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
Enable_Disabled_Targets:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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


/*∙=====∙USE CASE EXAMPLES∙===================================∙
∙---------------------------------------------------------------∙
• Re-enabling Disabled Windows
    » Scenario: Some applications or scripts may intentionally disable windows to prevent user interaction (e.g., a dialog box or application window might be grayed out).
    » How It Helps: If a disabled window is under the mouse cursor, the script can reactivate it instantly by pressing the left mouse button.
* Example:∙-------------∙
    » A "Save As" dialog box in an application is disabled and inaccessible. Hover the cursor over the dialog and click the left mouse button to re-enable it.
∙---------------------------------------------------------------∙
• Re-enabling Disabled Controls
    » Scenario: In some applications, specific controls (e.g., buttons, text fields, checkboxes) may be disabled to restrict user actions temporarily.
    » How It Helps: By hovering over the disabled control and clicking the left mouse button, the control is re-enabled, allowing interaction.

* Example:∙-------------∙
    » A "Submit" button in a web app is disabled until all required fields are filled. Hover over the button and click to enable it without filling the fields.
∙---------------------------------------------------------------∙
• Overriding Security or Restrictions
    » Scenario: Some software disables windows or controls to enforce specific workflows or prevent certain actions. While this is often done for a good reason, you may want to bypass it for testing, debugging, or personal use.
    » How It Helps: This script can enable those elements, allowing you to interact with them regardless of the restriction.

* Example:∙-------------∙
    » A settings window in a software application is disabled until you meet certain conditions. Use the script to enable it and access the settings immediately.
∙---------------------------------------------------------------∙
• Debugging and Testing UI
    » Scenario: Software developers and testers often encounter disabled UI elements during development and testing.
    » How It Helps: The script enables quick reactivation of windows or controls without modifying the underlying code.

* Example:∙-------------∙
    » During application testing, a developer wants to check the behavior of a disabled "Options" menu. Hover over it and click to enable it for testing.
∙---------------------------------------------------------------∙
• Fixing Misbehaving Applications
    » Scenario: Occasionally, bugs in software can leave windows or controls unintentionally disabled, locking you out of functionality.
    » How It Helps: The script allows you to re-enable these elements to restore functionality without restarting the application.

* Example:∙-------------∙
    » A "Close" button in a frozen application becomes grayed out. Hover and click to re-enable it, then close the application normally.
∙---------------------------------------------------------------∙
• Overcoming Accessibility Issues
    » Scenario: Disabled UI elements can sometimes hinder accessibility, making it harder for certain users to interact with applications.
    » How It Helps: The script provides a workaround to enable these elements for better accessibility.

* Example:∙-------------∙
    » A user with limited dexterity accidentally disables an important control in an application. Hover over it and click to re-enable it.
∙---------------------------------------------------------------∙
• Custom Scripting or Automation
    » Scenario: Advanced users may integrate this script with other AutoHotkey scripts or workflows for automation.
    » How It Helps: The script can be triggered alongside other scripts to handle unexpected disabled windows or controls dynamically.

* Example:∙-------------∙
    » A macro script automates form-filling, but a control is disabled due to timing issues. This script re-enables it on the fly during execution.
∙==============================∙
*!* Cautionary Notes *!*
    ▹ Misuse: Enabling disabled windows or controls might bypass intentional restrictions, potentially leading to unexpected behavior or breaking application workflows.
    ▹ Security Risks: Avoid using this on sensitive or secure applications, as it might violate terms of use or expose vulnerabilities.
    ▹ Temporary Effects: The script enables elements dynamically, but they might become disabled again depending on the application's behavior.
∙---------------------------------------------------------------∙
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙========================∙SCRIPT END∙=========================∙
;;∙------------------------------------------------------------------------------------------∙

