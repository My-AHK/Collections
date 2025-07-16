
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  
» Original Source:  
» 
    ▹ 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TEMPLATE"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
/*∙===========================================================∙
    	* Interactive Help Menu System *
    Hold Ctrl to show help menu - releases when key is released.      
    Features: Categorized help, keyboard navigation while held.
∙=============================================================∙	
*/

#NoEnv 			;;∙------∙Recommended for performance and compatibility.
#Persistent 		;;∙------∙Keeps the script running in background.
#SingleInstance, Force 	;;∙------∙Force only one instance to run.
SendMode, Input 		;;∙------∙Faster, more reliable Send method.
SetBatchLines, -1 		;;∙------∙Run at maximum speed.
SetTitleMatchMode, 2 	;;∙------∙Allow partial matching in window titles.
SetWinDelay, 0 		;;∙------∙Remove delays between window actions.
SetWorkingDir, %A_ScriptDir% 	;;∙------∙Set working directory to script’s folder.

;;∙======∙Variables - Global Declarations∙========================∙
global CurrentCategory := 1 		;;∙------∙Currently selected help category (default to 1).
global TotalCategories := 4 		;;∙------∙Total number of help categories available.
global SearchText := "" 		;;∙------∙Placeholder for future search implementation.
global HelpCategories, HelpContent 	;;∙------∙Object references to categories and content storage.
global CurrentCat, Cat1, Cat2, Cat3, Cat4 	;;∙------∙GUI controls representing category tabs.
global HelpContent_Control, StatusBar 	;;∙------∙GUI controls for main content and footer bar.

;;∙======∙Help Categories and Content∙==========================∙
HelpCategories := Object() 		;;∙------∙Create an object to store category names.
HelpCategories[1] := "General"
HelpCategories[2] := "Shortcuts"
HelpCategories[3] := "Features"
HelpCategories[4] := "Troubleshooting"

;;∙======∙Help Content Structure∙===============================∙
HelpContent := Object() 	;;∙------∙Create root object to hold help content.

HelpContent.General := Object() 	;;∙------∙Section: General information/help.
HelpContent.General[1] := "Welcome to the Interactive Help System"
HelpContent.General[2] := "• Hold Ctrl to show this help menu"
HelpContent.General[3] := "• Use 1,2,3,4 or Numpad keys to switch categories while held"
HelpContent.General[4] := "• Menu disappears when Ctrl is released"
HelpContent.General[5] := "• This is always running in background"
HelpContent.General[6] := "• Lightweight and non-intrusive design"

HelpContent.Shortcuts := Object() 	;;∙------∙Section: Shortcut key references.
HelpContent.Shortcuts[1] := "Keyboard Shortcuts (while holding Ctrl)"
HelpContent.Shortcuts[2] := "• Ctrl (hold) - Show/hide help menu"
HelpContent.Shortcuts[3] := "• 1 or Numpad1 - General help category"
HelpContent.Shortcuts[4] := "• 2 or Numpad2 - Shortcuts category"
HelpContent.Shortcuts[5] := "• 3 or Numpad3 - Features category"
HelpContent.Shortcuts[6] := "• 4 or Numpad4 - Troubleshooting category"
HelpContent.Shortcuts[7] := "• Space - Test beep sound"

HelpContent.Features := Object() 	;;∙------∙Section: Feature overview.
HelpContent.Features[1] := "Available Features"
HelpContent.Features[2] := "• Hold-to-show interface design"
HelpContent.Features[3] := "• Multiple help categories"
HelpContent.Features[4] := "• Instant category switching"
HelpContent.Features[5] := "• Always-on-top display"
HelpContent.Features[6] := "• Background operation"
HelpContent.Features[7] := "• Quick access to information"

HelpContent.Troubleshooting := Object() 	;;∙------∙Section: Troubleshooting advice.
HelpContent.Troubleshooting[1] := "Common Issues & Solutions"
HelpContent.Troubleshooting[2] := "• Menu not appearing: Check Ctrl key"
HelpContent.Troubleshooting[3] := "• Text not readable: Adjust monitor brightness"
HelpContent.Troubleshooting[4] := "• Performance issues: Restart script"
HelpContent.Troubleshooting[5] := "• Key conflicts: Modify hotkey in script"
HelpContent.Troubleshooting[6] := "• Display issues: Check screen resolution"
HelpContent.Troubleshooting[7] := "• Script not running: Run as administrator"

;;∙======∙Create GUI∙=========================================∙
CreateHelpGUI() 	;;∙------∙Call function to build the help interface.

~Control::    ;;∙------∙🔥∙(Ctrl )∙🔥∙Show help while Ctrl is held down.
    Gui, Help:Show, NoActivate w600 h450 Center 	;;∙------∙Display GUI without activating it.

    UpdateCategoryHighlight() 	;;∙------∙Highlight the active tab visually.
    UpdateHelpContent() 	;;∙------∙Display content for the selected category.

    Loop 	;;∙------∙Start loop to detect held keys.
    {
        ;;∙------∙Handle category switching via number keys or numpad.
        if (GetKeyState("1", "P") || GetKeyState("Numpad1", "P"))
        {
            CurrentCategory := 1
            UpdateCategoryHighlight()
            UpdateHelpContent()
            KeyWait, 1
            KeyWait, Numpad1
        }
        if (GetKeyState("2", "P") || GetKeyState("Numpad2", "P"))
        {
            CurrentCategory := 2
            UpdateCategoryHighlight()
            UpdateHelpContent()
            KeyWait, 2
            KeyWait, Numpad2
        }
        if (GetKeyState("3", "P") || GetKeyState("Numpad3", "P"))
        {
            CurrentCategory := 3
            UpdateCategoryHighlight()
            UpdateHelpContent()
            KeyWait, 3
            KeyWait, Numpad3
        }
        if (GetKeyState("4", "P") || GetKeyState("Numpad4", "P"))
        {
            CurrentCategory := 4
            UpdateCategoryHighlight()
            UpdateHelpContent()
            KeyWait, 4
            KeyWait, Numpad4
        }
        if GetKeyState("Space", "P")
        {
            SoundBeep, 1500, 400 	;;∙------∙Beep (action) test triggered by spacebar.
            KeyWait, Space
        }

        If Not GetKeyState("Control", "P") 	;;∙------∙Exit loop once Ctrl is released.
            Break
        Sleep, 50
    }

    Gui, Help:Hide 	;;∙------∙Hide GUI after releasing Ctrl.
Return

CreateHelpGUI() {
    Gui, Help:New, +AlwaysOnTop -Caption +Border +ToolWindow +LastFound, Interactive Help System    ;;∙------∙Create the GUI window.
    Gui, Help:Color, 0x171717    ;;∙------∙Set dark background color.

    Gui, Help:Font, s16 cWhite Bold q5, Segoe UI    ;;∙------∙Title font.
    Gui, Help:Add, Text, x10 y10 w580 Center BackgroundTrans, Interactive Help Menu    ;;∙------∙Title text.

    Gui, Help:Font, s10 cYellow Normal q5, Segoe UI    ;;∙------∙Instruction font.
    Gui, Help:Add, Text, x10 y45 w580 Center BackgroundTrans, Hold Ctrl to keep menu open • Press 1-4 or Numpad keys to switch categories • Space to test    ;;∙------∙Instructional tip line.

    Gui, Help:Font, s12 cAqua Bold q5, Segoe UI    ;;∙------∙Category label font.
    Gui, Help:Add, Text, x10 y75 w580 Center BackgroundTrans vCurrentCat, Category: General     ;;∙------∙Display selected category title.

    Gui, Help:Font, s10 cWhite Normal q5, Segoe UI    ;;∙------∙Font for tab buttons.
    Gui, Help:Add, Text, x10 y100 w140 h25 Center BackgroundTrans Border vCat1, [1] General    ;;∙------∙Tab: General.
    Gui, Help:Add, Text, x155 y100 w140 h25 Center BackgroundTrans Border vCat2, [2] Shortcuts    ;;∙------∙Tab: Shortcuts.
    Gui, Help:Add, Text, x300 y100 w140 h25 Center BackgroundTrans Border vCat3, [3] Features    ;;∙------∙Tab: Features.
    Gui, Help:Add, Text, x445 y100 w145 h25 Center BackgroundTrans Border vCat4, [4] Troubleshooting    ;;∙------∙Tab: Troubleshooting.

    Gui, Help:Font, s11 cLime Normal q5, Consolas
    Gui, Help:Add, Text, x10 y135 w580 h250 VScroll ReadOnly vHelpContent_Control Background0x1E1E1E    ;;∙------∙Main content display area.

    Gui, Help:Font, s9 cGray Normal q5, Segoe UI     ;;∙------∙Status/footer font.
    Gui, Help:Add, Text, x10 y395 w580 Center BackgroundTrans vStatusBar, Release Ctrl to close • This menu is always ready in background    ;;∙------∙Status/footer bar.

    Gui, Help:Font, s10 cWhite Normal q5, Segoe UI    ;;∙------∙Font for navigation reminder.
    Gui, Help:Add, Text, x10 y415 w580 Center BackgroundTrans, Keep Ctrl held down and press Number keys or NumPad keys (1-4) to navigate categories    ;;∙------∙Navigation instructions.

    UpdateCategoryHighlight()    ;;∙------∙Apply tab highlighting initially.
    UpdateHelpContent()    ;;∙------∙Load default content.
Return
}

UpdateCategoryHighlight() {
    Loop, 4 {
        CategoryName := HelpCategories[A_Index]    ;;∙------∙Fetch name for each category.
        GuiControl, Help:, Cat%A_Index%, [%A_Index%] %CategoryName%    ;;∙------∙Reset label text.
        GuiControl, Help:+BackgroundDefault, Cat%A_Index%    ;;∙------∙Clear highlight background.
    }

    CurrentCatName := HelpCategories[CurrentCategory]     ;;∙------∙Get current category name.
    GuiControl, Help:, Cat%CurrentCategory%, ► [%CurrentCategory%] %CurrentCatName% ◄        ;;∙------∙Decorate active tab with arrows.
    GuiControl, Help:+BackgroundBlue, Cat%CurrentCategory%    ;;∙------∙Set highlight background color.

    GuiControl, Help:, CurrentCat, Category: %CurrentCatName%    ;;∙------∙Update the category title at top.
Return
}

UpdateHelpContent() {
    CategoryName := HelpCategories[CurrentCategory]    ;;∙------∙Get name of current category.
    Content := ""    ;;∙------∙Prepare content string.

    Loop % HelpContent[CategoryName].MaxIndex()    ;;∙------∙Loop through content lines.
        Content .= HelpContent[CategoryName][A_Index] . "`n"    ;;∙------∙Append line with newline.

    GuiControl, Help:, HelpContent_Control, %Content%    ;;∙------∙Display built content string.

    ItemCount := HelpContent[CategoryName].MaxIndex()    ;;∙------∙Count number of help lines.
    GuiControl, Help:, StatusBar, Category: %CategoryName% • Items: %ItemCount% • Keep holding Ctrl to stay open    ;;∙------∙Update status/footer bar.
Return
}

;;∙======∙Prevent GUI from being closed accidentally∙==============∙
HelpGuiClose:    ;;∙------∙Ignore GUI close.
Return

HelpGuiEscape:    ;;∙------∙Ignore Escape key close.
Return

;;∙============================================================∙
/*∙===========================================================∙
    Hold-to-Show Interactive Help Menu System
    Always ready in background - Hold Ctrl to access
∙=============================================================∙	
*/






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

