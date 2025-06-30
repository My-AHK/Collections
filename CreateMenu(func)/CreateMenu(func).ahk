
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  Learning one
» Original Source:  https://www.autohotkey.com/board/topic/57647-function-createmenu/
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

;;∙======∙HotKey∙===============================================∙
^t::    ;;∙------∙🔥∙(Ctrl + T)
    Soundbeep, 1000, 200
;;∙============================================================∙




;;∙============================================================∙
;;∙============================================================∙
/*∙========∙Available TreeView Item Options∙========∙
 • Creates menu from a string in which each item is placed in new line and hierarchy is defined by Tab character on the left (indentation). 
 • Item icon parameters (FileName | IconNumber | IconWidth) can be added after one or more Tab characters after item name. 
 • To create separator, specify at least 3 minuses (---) but follow indentation.
∙===============================================∙
*/

#SingleInstance Force
#NoEnv
SetBatchLines, -1

;;∙------∙Tip - sometimes you'll want to shorten ThisMenu (A_ThisMenu) variable. Here's how you can do it...
;; 	ThisMenu := "MyMenu_Videos_Movies"    ;;∙------∙Long.
;; 	ThisMenu := RegExReplace(ThisMenu,"(.*)_(.*)$", "$2")
;; 	MsgBox % ThisMenu	    ;;∙------∙Short (results in "Movies").

;;∙----------------------------------------------------∙
F1::    ;;∙------∙🔥∙Example 1 - Basic.
MenuDefinitionVar=
(
File
	New
	Open
	Save
	Save as...
	Exit
Edit
	Undo
	Cut
	Copy
	Paste
	Delete
View
	Full screen
	Zoom
		100
		200
Help
)

CreateMenu(MenuDefinitionVar)
    Menu, MyMenu, Show
Return

MButton::Menu, MyMenu, Show

MenuSub:
    MsgBox,, You selected:, % "Item:`n" A_ThisMenuItem "`n`nFrom menu:`n" A_ThisMenu
Return

;;∙----------------------------------------------------∙
F2::    ;;∙------∙🔥∙Example 2 - icons, separators (---), custom menu name, custom menu label (subroutine)
MenuDefinitionVar=
(
AHK						%A_AhkPath%|1
	Suspend				%A_AhkPath%|-206
	Pause				%A_AhkPath%|-207
	Suspend and pause	%A_AhkPath%|-208
	---
	Big exe				%A_AhkPath%|1|48
	Big file			%A_AhkPath%|2|48
Favorites				C:\Your icon.ico
	File 1
	File 2
	---
	Folder 1
	Folder 2
Help					C:\Your icon.ico||32
)

CreateMenu(MenuDefinitionVar, "Test", "TestSub")
    Menu, Test, Show
Return

TestSub:
if A_ThisMenuItem = Suspend
 {
	MsgBox run Suspend code
	MsgBox and more Suspend code
 }

if A_ThisMenuItem = Big exe
 {
	MsgBox run Big exe code
	MsgBox and More Big exe code
 }

if A_ThisMenuItem = Help
 {
	MsgBox run Help code
	MsgBox and More Help code
 }
Return

;;∙----------------------------------------------------∙
F3::    ;;∙------∙🔥∙Example 3 - Attach a menu to the window.
MenuDefinitionVar=
(
AHK						%A_AhkPath%|1
	Suspend				%A_AhkPath%|-206
	Pause				%A_AhkPath%|-207
	Suspend and pause	%A_AhkPath%|-208
	---
	Big exe				%A_AhkPath%|1|48
	Big file			%A_AhkPath%|2|48
Favorites
	File 1
	File 2
	---
	Folder 1
	Folder 2
View
	Full screen
	Zoom
		100
		200
Help
)

CreateMenu(MenuDefinitionVar, "GuiMenu", "GuiMenuSub")
    Gui 1:Menu, GuiMenu    ;;∙------∙Attach a menu to the window.
    Gui 1:Add, Text, x5 y5 w300 h100 hwndhgText
    Gui 1:Show,, Select me...
Return

GuiMenuSub:
    GuiControl, 1:, % hgText, % "Item:`n" A_ThisMenuItem "`n`nFrom menu:`n" A_ThisMenu
Return

;;∙-----------------------------∙
GuiClose:
    Reload
Return



;;∙======∙FUNCTION∙====================∙
CreateMenu(MenuDefinitionVar, MenuName="MyMenu", MenuSub="MenuSub") {
    MenuNames := {}, ItemNames := {}, Items := {}, BaseMenuName := MenuName, Depth := 0, LastLevel := 1
    Loop, parse, MenuDefinitionVar, `n, `r
    {
        if A_LoopField is space
            continue
        ItemInfo := RTrim(A_LoopField, A_Space A_Tab), ItemInfo := LTrim(ItemInfo, A_Space), Level := 1
        While (SubStr(ItemInfo, 1, 1) = A_Tab)
            Level += 1,    ItemInfo := SubStr(ItemInfo, 2)
        RegExMatch(ItemInfo, "([^`t]*)([`t]*)([^`t]*)", match)
        ItemName := Trim(match1), ItemIconOptions := Trim(match3)
        if !IsObject(Items["L" Level])
            Items["L" Level] := [], Depth += 1
        if (Level = 1)
            MenuName := BaseMenuName
        else
            MenuName := MenuNames["L" Level-1] "_" ItemNames["L" Level-1]
        MenuNames["L" Level] := MenuName, ItemNames["L" Level] := ItemName
        Items["L" Level].Insert([MenuName, ItemName, MenuSub, ItemIconOptions])
        if (Level > LastLevel)
            Max := Items["L" Level-1].MaxIndex(), Items["L" Level-1][Max].3 := ":" MenuName
        LastLevel := Level
    }
    Loop, % Depth
    {
        Level := (A_Index = 1) ? Depth : Depth - A_Index + 1
        For k, v in Items["L" Level]
        {
            if (SubStr(v.2, 1, 3) = "---")
                Menu, % v.1, Add
            else {
                if (v.4 = "")
                    Menu, % v.1, Add, % v.2, % v.3
                else {
                    ItemIconOptions := v.4
;;∙------∙Transform used due to handling both environment variables (e.g., %SystemRoot%) and built-in AHK variables (e.g., %A_AhkPath%).
                    Transform, ItemIconOptions, Deref, % ItemIconOptions    
                    param := StrSplit(ItemIconOptions, "|")
                    Menu, % v.1, Add, % v.2, % v.3
                    if (param.Count() >= 1) {
                        filePath := Trim(param[1])
                        Att := FileExist(filePath)
                        if (Att != "" && !InStr(Att, "D")) {  ; Only set icon for files (not folders)
                            iconIndex := (param.Count() >= 2) ? Trim(param[2]) : 0
                            iconWidth := (param.Count() >= 3) ? Trim(param[3]) : 0
                            Menu, % v.1, Icon, % v.2, % filePath, % iconIndex, % iconWidth
                        }
                    }
                }
            }
        }
    }
}
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

