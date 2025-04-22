
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
ScriptID := "MsgBox-Maker"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
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

Gui, Add, Groupbox, x10 y10 w340 h125, Title && Text
Gui, Add, Text, xs+10 ys+20 section, Title:
Gui, Add, Edit, xs+30 ys-3 w290 vTitle gCreate_Msgbox_Command WantTab,
Gui, Add, Text, xs+0 ys+25 section, Text:
Gui, Add, Edit, xs+30 ys-3 r5 w290 vText gCreate_Msgbox_Command WantTab,

Gui, Add, Groupbox, x10 y145 h65 w340 section, Modality
Gui, Add, Radio, xs+10 ys+20 section Checked vModality1 gCreate_Msgbox_Command, Normal
Gui, Add, Radio, xs+70 ys+0 vModality2 gCreate_Msgbox_Command, Task Modal
Gui, Add, Radio, xs+160 ys+0 vModality3 gCreate_Msgbox_Command, System Modal (always on top)
Gui, Add, Radio, xs+0 ys+25 section vModality4 gCreate_Msgbox_Command, Always on top
Gui, Add, Radio, xs+160 ys+0 section vModality5 gCreate_Msgbox_Command, Default desktop

Gui, Add, Groupbox, x10 y220 w340 h155 section, Icons
Gui, Add, Picture, xs+20 ys+20 gSelect_NoIcon section icon1, %A_WinDir%\system32\user32.dll
Gui, Add, Picture, xs+125 ys+0 gSelect_ErrorIcon icon4 , %A_WinDir%\system32\user32.dll
Gui, Add, Picture, xs+240 ys+0 gSelect_Question icon3 , %A_WinDir%\system32\user32.dll
Gui, Add, Radio, xs-10 ys+40 section vIcon1 Checked gCreate_Msgbox_Command, No Icon
Gui, Add, Radio, xs+125 ys+0 vIcon2 gCreate_Msgbox_Command, Stop/Error
Gui, Add, Radio, xs+240 ys+0 vIcon3 gCreate_Msgbox_Command, Question
Gui, Add, Radio, xs+0 ys+70 section vIcon4 gCreate_Msgbox_Command, Exclamation
Gui, Add, Radio, xs+125 ys+0 vIcon5 gCreate_Msgbox_Command, Info
Gui, Add, Picture, xs+10 ys-40 gSelect_Exclamation section icon2, %A_WinDir%\system32\user32.dll
Gui, Add, Picture, xs+125 ys+0 gSelect_Info icon5 , %A_WinDir%\system32\user32.dll

Gui, Add, Groupbox, x10 y385 h95 w340 section, Buttons
Gui, Add, Radio, xs+10 ys+20 vButton_Selection1 section Checked gCreate_Msgbox_Command, OK
Gui, Add, Radio, xs+115 ys+0 vButton_Selection2 gCreate_Msgbox_Command, OK/Cancel
Gui, Add, Radio, xs+210 ys+0 vButton_Selection3 gCreate_Msgbox_Command, Abort/Retry/Ignore
Gui, Add, Radio, xs+0 ys+25 section vButton_Selection4 gCreate_Msgbox_Command, Yes/No/Cancel
Gui, Add, Radio, xs+115 ys+0 vButton_Selection5 gCreate_Msgbox_Command, Yes/No
Gui, Add, Radio, xs+210 ys+0 vButton_Selection6 gCreate_Msgbox_Command, Retry/Cancel
Gui, Add, Radio, xs+0 ys+25 section vButton_Selection7 gCreate_Msgbox_Command, Cancel/Try Again/Continue
Gui, Add, Checkbox, xs+210 ys+0 vButton_Selection_Help gCreate_Msgbox_Command, Help button

Gui, Add, Groupbox, x10 y490 h45 w230 section, Default-Button
Gui, Add, Radio, xs+10 ys+20 section Checked vDefault1 gCreate_Msgbox_Command, First
Gui, Add, Radio, xs+80 ys+0 vDefault2 gCreate_Msgbox_Command, Second
Gui, Add, Radio, xs+160 ys+0 vDefault3 gCreate_Msgbox_Command, Third

Gui, Add, Groupbox, x260 y490 h45 w90 section, Timeout
Gui, Add, Edit, xs+10 ys+17 w70 vTimeout gCreate_Msgbox_Command
Gui, Add, UpDown, Range-1-2147483, -1

Gui, Add, Groupbox, x10 y545 w230 h45 section, Allignment
Gui, Add, Checkbox, xs+10 ys+20 vAllignment1 section gCreate_Msgbox_Command, Right-justified
Gui, Add, Checkbox, xs+115 ys+0 vAllignment2 gCreate_Msgbox_Command, Right-to-left

Gui, Add, Groupbox, x10 y600 w340 h95 section, Result
Gui, Add, Edit, xs+10 ys+20 w320 r2 vMsgbox_Command,
Gui, Add, Button, xs+10 ys+60 h30 w40 Default vTest gTest, Test
Gui, Add, Button, xs+120 ys+60 h30 w100 gCopy_to_Clipboard, Copy to Clipboard
Gui, Add, Button, xs+290 ys+60 h30 w40 gReset, Reset
Gui, Show,x900 y200 w380 h700 , %ScriptID%
GoSub, Reset 				 ; ←←← Initalize GUI from Ini
Return

Select_NoIcon:
GuiControl, , Icon1, 1
GoSub, Create_Msgbox_Command
Return

Select_ErrorIcon:
GuiControl, , Icon2, 1
GoSub, Create_Msgbox_Command
Return

Select_Question:
GuiControl, , Icon3, 1
GoSub, Create_Msgbox_Command
Return

Select_Exclamation:
GuiControl, , Icon4, 1
GoSub, Create_Msgbox_Command
Return

Select_Info:
GuiControl, , Icon5, 1
GoSub, Create_Msgbox_Command
Return

Create_Msgbox_Command:
Gui, Submit, NoHide
Loop, 7 			 ; ←←← Get types of used buttons
{
   if Button_Selection%A_Index% = 1
   {
      ButtonSelection := A_Index -1
      if Button_Selection_Help = 1
         ButtonSelection += 16384
      break
   }
}

Loop, 5 			 ; ←←← Get types of used buttonsGet used Icon
{
   if Icon%A_Index% = 1
   {
      if A_Index = 1
         Icon = 0
      else if A_Index = 2
         Icon = 16
      else if A_Index = 3
         Icon = 32
      else if A_Index = 4
         Icon = 48
      else if A_Index = 5
         Icon = 64
      break
   }
}

Loop, 5 			 ; ←←← Get Modality-State
{
   if Modality%A_Index% = 1
   {
      if A_Index = 1
         Modality = 0
      else if A_Index = 2
         Modality = 8192
      else if A_Index = 3
         Modality = 4096
      else if A_Index = 4
         Modality = 262144
      else if A_Index = 5
         Modality = 131072
      break
   }
}

Loop, 3 			 ; ←←← Get Default-Button
{
   if Default%A_Index% = 1
   {
      if A_Index = 1
         Default = 0
      else if A_Index = 2
         Default = 256
      else if A_Index = 3
         Default = 512
      break
   }
}

Allignment = 0 		 ; ←←← Check Allignment
if Allignment1 = 1
   Allignment += 524288
if Allignment2 = 1
   Allignment += 1048576

Msgbox_Number := ButtonSelection + Icon + Modality + Default + Allignment   ;Generate type of messagebox

Escape_Characters(Title)
Escape_Characters(Text)

if Timeout = -1 		 ; ←←← Timeout "-1" = no timeout
   Timeout =
else
{
   StringReplace, Timeout, Timeout, `,, .  	; ←←← Allows "," as decimal-point
   Timeout = , %Timeout%
}

Msgbox_Command = msgbox, %Msgbox_Number%, %Title%, %Text%%Timeout%  ; ←←← Create command and set it to Edit-Control
GuiControl, , Msgbox_Command, %Msgbox_Command%
Return

Test: 			 ; ←←← Creates a Temp-File to show actual configuration
GoSub, Create_Msgbox_Command
GuiControl, Disable, Test
FileAppend, %Msgbox_Command%, MsgboxTemp.ahk
RunWait, MsgboxTemp.ahk
FileDelete, MsgboxTemp.ahk
GuiControl, Enable, Test
Return

Escape_Characters(byref Var) 	 ; ←←← Escapes Characters like ","
{
   StringReplace, Var, Var, `n, ``n, All 	 ; ←←← Translate line breaks in entered text
   StringReplace, Var, Var, `,, ```,, All 	 ; ←←← Escapes ","
   StringReplace, Var, Var, `;, ```;, All 	 ; ←←← Escapes ";"
}

Copy_to_Clipboard:
Clipboard = %Msgbox_Command%
IniRead, Reset_after_Clipboard, %A_ScriptDir%\Msgbox.ini, Clipboard, Reset after Clipboard, 0
if Reset_after_Clipboard = 1
   GoSub, Reset
Return

GuiClose:
    ExitApp

Open:
Gui, Show
Return

Reset:
IfExist %A_ScriptDir%\Msgbox.ini
{
   IniRead, Title, %A_ScriptDir%\Msgbox.ini, Reset, Title, plk
   if Title = plk
      Title =
   IniRead, Text, %A_ScriptDir%\Msgbox.ini, Reset, Text, plk
   if Text = plk
      Text =
   IniRead, Modality, %A_ScriptDir%\Msgbox.ini, Reset, Modality, 1
   IniRead, Icon, %A_ScriptDir%\Msgbox.ini, Reset, Icon, 1
   IniRead, Button_Selection, %A_ScriptDir%\Msgbox.ini, Reset, Button, 1
   IniRead, Button_Selection_Help, %A_ScriptDir%\Msgbox.ini, Reset, Help Button, 0
   IniRead, Default, %A_ScriptDir%\Msgbox.ini, Reset, Default Button, 1
   IniRead, Timeout, %A_ScriptDir%\Msgbox.ini, Reset, Timeout, -1
   IniRead, Allignment1, %A_ScriptDir%\Msgbox.ini, Reset, Allignment_Right, 0
   IniRead, Allignment2, %A_ScriptDir%\Msgbox.ini, Reset, Allignment_RtL, 0
}
else
{
   Title =
   Text =
   Modality = 1
   Icon = 1
   Button_Selection = 1
   Button_Selection_Help = 0
   Default = 1
   Timeout = -1
   Allignment1 = 0
   Allignment2 = 0
}

GuiControl, , Title, %Title%
GuiControl, , Text, %Text%
GuiControl, , Modality%Modality%, 1
GuiControl, , Icon%Icon%, 1
GuiControl, , Button_Selection%Button_Selection%, 1
GuiControl, , Button_Selection_Help, %Button_Selection_Help%
GuiControl, , Default%Default%, 1
GuiControl, , Timeout, %Timeout%
GuiControl, , Allignment1, %Allignment1%
GuiControl, , Allignment2, %Allignment2%
Return

GuiSize:
if A_EventInfo = 1
   Gui, Show, Hide
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
MsgBox-Maker:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

