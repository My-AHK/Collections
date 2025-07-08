
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  Learning one
» Original Source:  https://www.autohotkey.com/board/topic/92863-function-createtreeview/
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
;;∙============================================================∙
/*∙========∙Available TreeView Item Options∙========∙
The options for TV_Add() are passed as a string in the third parameter. These options correspond to item states:
OPTION	- DESCRIPTION
Bold	- Makes the item text bold.
Expand	- Automatically expands the item (useful if it has children).
Select	- Automatically selects (highlights) the item.
Vis	- Scrolls the TreeView to ensure the item is visible.
Check	- Shows item as checked (only works if the TreeView has checkboxes).
HasChild	- Displays expand/collapse icon even if no children yet added.

Note: Check only works if the TreeView control was created with the +0x00000002 style (TVS_CHECKBOXES), which requires DllCall or GuiControl +Style.
∙===============================================∙
*/

#SingleInstance Force
#NoEnv
SetBatchLines, -1

;;∙--------------------------------------------------------∙
F1::    ;;∙------∙🔥∙(Bold option)
TvDefinition=
(
Sections
	Overview
	Important Notes		Bold
	Details
)

Gui, New
Gui, Add, Text,, Bold option highlights:`n`t Important Notes
Gui, Add, TreeView, vMyTreeView h150 w300
hIL := IL_Create(2)
IL_Add(hIL, "shell32.dll", 267)
IL_Add(hIL, "shell32.dll", 285)
TV_SetImageList(hIL)

CreateTreeView_WithIcons(TvDefinition)
Gui, Show, , Bold Option Demo
Return


;;∙--------------------------------------------------------∙
F2::    ;;∙------∙🔥∙(Expand option)
TvDefinition=
(
Folders
	Documents		Expand
		Reports
		Letters
	Pictures
		Vacation
		Family
	Music
		Rock
		Jazz
)

Gui, New
Gui, Add, Text,, Expand option opens only:`n`t Documents folder
Gui, Add, TreeView, vMyTreeView h120 w300
hIL := IL_Create(2)
IL_Add(hIL, "shell32.dll", 4)    ;; Folder
IL_Add(hIL, "shell32.dll", 5)    ;; File
TV_SetImageList(hIL)

CreateTreeView_WithIcons(TvDefinition)
Gui, Show, , Expand Option Demo
Return


;;∙--------------------------------------------------------∙
F3::    ;;∙------∙🔥∙(Select option)
TvDefinition=
(
Tasks
	Todo
	In Progress		Select
	Done
)

Gui, New
Gui, Add, Text,, Select option auto-selects:`n`t In Progress
Gui, Add, TreeView, vMyTreeView h150 w300
hIL := IL_Create(2)
IL_Add(hIL, "shell32.dll", 23)
IL_Add(hIL, "shell32.dll", 24)
TV_SetImageList(hIL)

CreateTreeView_WithIcons(TvDefinition)
Gui, Show, , Select Option Demo
Return


;;∙--------------------------------------------------------∙
F4::    ;;∙------∙🔥∙(Vis option)
TvDefinition=
(
1st Level
	Item 1
	Item 2
	Item 3
	Item 4
	Item 5
	Item 6
	Item 7
	Item 8
	Item 9
	Item 10
2nd Level
	Item 11
	Item 12
	Item 13
	Item 14
	Item 15
	Item 16
	Item 17 - SCROLLS TO HERE		Vis
	Item 18
	Item 19
	Item 20
3rd Level
	Item 21
	Item 22
	Item 23
	Item 24
	Item 25
	Item 26
	Item 27
	Item 28
	Item 29
	Item 30
)

Gui, New
Gui, Add, Text,, TreeView will automatically scroll to ' Vis'  selection...`n`t`t Item 17 - SCROLLS TO HERE
Gui, Add, TreeView, vMyTreeView h150 w400
;;∙------∙Create icon list for folder and file icons.
hImageList := IL_Create(2)
IL_Add(hImageList, "shell32.dll", 267)    ;;∙------∙Folder
IL_Add(hImageList, "shell32.dll", 285)    ;;∙------∙File
TV_SetImageList(hImageList)

CreateTreeView_WithIcons(TvDefinition)
Gui, Show, , Vis Option Demo
Return


;;∙--------------------------------------------------------∙
F5::    ;;∙------∙🔥∙(Check option)
Gui, New
Gui, Add, Text,, Toggle checkboxes by clicking items:`nUsing icons from shell32.dll (295/297)
Gui, Add, TreeView, vMyTreeView h220 w400 +AltSubmit gIconCheckboxEvent

;;∙------∙Create image list with checkbox icons
hIL := IL_Create(2, 10, true)
ICON_UNCHECKED := IL_Add(hIL, "shell32.dll", 295)
ICON_CHECKED   := IL_Add(hIL, "shell32.dll", 297)
TV_SetImageList(hIL)

;;∙------∙Add root and child items, default icons
root := TV_Add("Grocery List", 0, "Expand")
id1 := TV_Add("Buy milk", root, "Icon" . ICON_UNCHECKED)
id2 := TV_Add("Buy eggs", root, "Icon" . ICON_CHECKED)   ;; pre-checked
id3 := TV_Add("Buy bread", root, "Icon" . ICON_UNCHECKED)

;;∙------∙Track checkbox state per item
checkedStates := {}
checkedStates[id1] := false
checkedStates[id2] := true
checkedStates[id3] := false

Gui, Show, , Icon Checkboxes
Return

IconCheckboxEvent:
if (A_GuiEvent != "Normal")
    Return

id := A_EventInfo
TV_GetText(txt, id)

if (checkedStates.HasKey(id) && checkedStates[id])
{
    TV_Modify(id, "Icon" . ICON_UNCHECKED)
    checkedStates[id] := false
}
else
{
    TV_Modify(id, "Icon" . ICON_CHECKED)
    checkedStates[id] := true
}
Return


;;∙--------------------------------------------------------∙
F6::    ;;∙------∙🔥∙(HasChild option)
TvDefinition=
(
Categories
	Placeholder		HasChild
)

Gui, New
Gui, Add, Text,, HasChild option shows [+] expand marker:`n`t even with no actual children.
Gui, Add, TreeView, vMyTreeView h150 w300
hIL := IL_Create(2)
IL_Add(hIL, "shell32.dll", 3)
IL_Add(hIL, "shell32.dll", 4)
TV_SetImageList(hIL)

CreateTreeView_WithIcons(TvDefinition)
Gui, Show, , HasChild Option Demo
Return


;;∙--------------------------------------------------------∙
;;∙------∙Example 1 - Basic∙-----------∙
F7::
TvDefinition=
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

Gui, Add, TreeView, h300
; CreateTreeView(TvDefinition)
CreateTreeView_WithIcons(TvDefinition)
Gui, Show
Return


;;∙--------------------------------------------------------∙
;;∙------∙Example 2 - items with options
F8::
TvDefinition=
(
File				bold
	New
	Open			bold
	Save
	Save as...
	Exit
Edit
	Undo
	Cut
	Copy
	Paste
	Delete
View				Expand
	Full screen		Select
	Zoom
		100
		200
Help
)

Gui, Add, TreeView, h300
CreateTreeView_WithIcons(TvDefinition)
Gui, Show
Return


;;∙--------------------------------------------------------∙
;;∙------∙Example 3 - items with options
F9::
TvDefinition=
(
Animals
	Mammals
		Dogs			Expand
		Cats
	Birds
	Fish			Bold
)

Gui, Add, TreeView, h300
CreateTreeView_WithIcons(TvDefinition)
Gui, Show
Return


;;∙--------------------------------------------------------∙
;;∙------∙Example 4 - All options working, icons varied
F10::
TvDefinition=
(
File				Bold
	New
	Open			Bold
	Save			Check
	Save as...
	Exit
Edit
	Undo
	Cut
	Copy
	Paste
	Delete			Check
View				Expand
	Full screen		Select
	Zoom
		100
		200
Animals
	Mammals
		Dogs			Expand
		Cats			Vis
	Birds
	Fish			Bold Select
Help				HasChild
)

Gui, New, +HwndMyGuiHwnd
Gui, Add, TreeView, vMyTreeView h200 w300 +0x2 +AltSubmit gMyTreeEvent    ;;∙------∙+0x2 adds TVS_CHECKBOXES

;;∙------∙Create image list
hImageList := IL_Create(5)
IL_Add(hImageList, "shell32.dll", 267)    ;;∙------∙Folder
IL_Add(hImageList, "shell32.dll", 285)    ;;∙------∙File
TV_SetImageList(hImageList)

CreateTreeView_WithIcons(TvDefinition)
Gui, Show,, TreeView - All 6 Options
Return

;;∙--------------------------------------------------------∙
GuiClose:
    Reload
Return


;;∙======∙FUNCTION∙========================∙
CreateTreeView_WithIcons(TreeViewDefinitionString)
{
    global
    IDs := {}

    Loop, parse, TreeViewDefinitionString, `n, `r
    {
        if (Trim(A_LoopField) = "")
            continue

        Item := RTrim(A_LoopField, A_Space A_Tab)
        Item := LTrim(Item, A_Space)
        Level := 0

        While (SubStr(Item, 1, 1) = A_Tab)
        {
            Level += 1
            Item := SubStr(Item, 2)
        }

        RegExMatch(Item, "([^`t]*)([`t]*)([^`t]*)", match)    ;;∙------∙match1 = name, match3 = options.
        Text := match1
        Options := match3

        iconIndex := (Level = 0) ? 1 : 2    ;;∙------∙Use folder icon for top-level, file icon for children

        if (Level = 0)
            IDs["Level0"] := TV_Add(Text, 0, Options)
        else
            IDs["Level" Level] := TV_Add(Text, IDs["Level" Level - 1], Options)

        ;;∙------∙Assign icon (must be done after TV_Add)
        TV_Modify(IDs["Level" Level], "Icon" . iconIndex)

        ;;∙------∙Force "Cats" visible via Vis
        if (Text = "Cats")
            TV_Modify(IDs["Level" Level], "Vis")
    }
}

;;∙------∙Optional right-click event
MyTreeEvent:
if (A_GuiEvent = "RightClick" || A_GuiEvent = "R")
{
    TV_GetText(label, A_EventInfo)
    if label !=
        MsgBox, 64, TreeView, You right-clicked: %label%
}
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

