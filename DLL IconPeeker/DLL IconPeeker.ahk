
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
ScriptID := "IconPeek"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
;;∙============================================================∙
#NoEnv
#Persistent
#SingleInstance, Force
SendMode Input
SetWorkingDir %A_ScriptDir%

;;∙======∙GLOBALS∙==========================================∙
global guiX := 1500
global guiY := 250
global guiW := 300
global guiH := 525
global guiColor := "212223"
global guiLVcolor := "676767"
global selectedIcon := 0
global SelectedIconText ; Control variable for icon number display

F1::    ;;∙------∙🔥∙

    file := GetSelectedFile()
    if (file = "")
    {
        MsgBox, 48, No Selection, Please select a .dll, .exe, or .ico file in Windows Explorer first.
        Return
    }

    SplitPath, file, , , ext
    if (ext != "dll" && ext != "exe" && ext != "ico")
    {
        MsgBox, 48, Invalid File Type, Selected file must be a .dll, .exe, or .ico file.`nSelected: %file%
        Return
    }

    if !FileExist(file)
    {
        MsgBox, 16, File Not Found, The selected file does not exist:`n%file%
        Return
    }

    ShowIconViewer(file)
Return

;;∙======∙Icon Viewer Window∙====================================∙
ShowIconViewer(file)
{
    global guiX, guiY, guiW, guiH, guiColor, guiLVcolor, selectedIcon, SelectedIconText
    
    Gui, Destroy
    Gui, +AlwaysOnTop -Caption +Border +Owner
    Gui, Color, %guiColor%
    Gui, Font, s10 cWhite q5, Arial

    Gui, Add, Text, x10 y15 h30 BackgroundTrans c77B3F8 gShowFileMenu, File ▼

    Gui, Font, s10 cWhite, Arial
    Gui, Add, ListView, x55 yp+20 h390 w120 Background%guiLVcolor% gIconNum, Icon
    ImageListID := IL_Create(10,1,1)
    LV_SetImageList(ImageListID,1)

    Loop
    {
        Count := Image
        Image := IL_Add(ImageListID, file, A_Index)
        If (Image = 0)
            Break
    }

    Loop, %Count%
        LV_Add("Icon" . A_Index, "     " . A_Index)
    LV_ModifyCol("Hdr")

    ;;∙------∙File information section.
    Gui, Add, Text, x10 y+10 h30 BackgroundTrans c77B3F8, File Selected:
    Gui, Add, Text, x10 yp+20 w270 BackgroundTrans cWhite, %file%
    
    ;;∙------∙Selected icon display.
    Gui, Add, Text, x10 yp+30 h30 BackgroundTrans c77B3F8, Selected Icon:
    Gui, Add, Text, x10 yp+20 w270 BackgroundTrans cWhite vSelectedIconText, None

    ;;∙------∙Control buttons.
    Gui, Add, Text, x20 yp+25 cLime gRELOAD, Reload
    Gui, Add, Text, x+35 yp cRed gEXIT, Exit

    SplitPath, file, filename
    Gui, Show, x%guiX% y%guiY% w%guiW% h%guiH%
}

;;∙======∙File Menu Popup∙======================================∙
ShowFileMenu:
    menuX := A_GuiX + 10 , menuY := A_GuiY + 10
    Menu, FileMenu, Add, &Open File`tCtrl+O, OpenFile
    Menu, FileMenu, Add, &Reload`tReset, RELOAD
    Menu, FileMenu, Add, &Exit`tEsc, EXIT
    Menu, FileMenu, Show, %menuX%, %menuY%
Return

;;∙======∙Get Selected File from Explorer or Clipboard∙===============∙
GetSelectedFile()
{
    WinGet, hwnd, ID, A

    for window in ComObjCreate("Shell.Application").Windows
    {
        if (window.hwnd == hwnd)
        {
            selection := window.Document.SelectedItems
            if (selection.Count > 0)
                return selection.Item(0).Path
        }
    }

    ClipSaved := Clipboard
    Clipboard := ""
    Send ^c
    ClipWait, 1
    if (Clipboard != "")
    {
        selectedFile := Clipboard
        Clipboard := ClipSaved
        if FileExist(selectedFile)
            return selectedFile
    }
    Clipboard := ClipSaved
    return ""
}

;;∙======∙Open File via File Picker∙============================∙
OpenFile:
    LV_Delete()
    FileSelectFile, file, 32,, Pick an icon-containing file., *.dll; *.exe; *.ico
    if (file = "")
        Return

    ImageListID := IL_Create(10,1,1)
    LV_SetImageList(ImageListID,1)
    Loop
    {
        Count := Image
        Image := IL_Add(ImageListID, file, A_Index)
        If (Image = 0)
            Break
    }
    Loop, %Count%
        LV_Add("Icon" . A_Index, "     " . A_Index)
    LV_ModifyCol("Hdr")
    
    ;;∙------∙Reset selected icon when opening new file
    selectedIcon := 0
    GuiControl,, SelectedIconText, None
Return

;;∙======∙ListView Item Clicked∙=================================∙
IconNum:
    selectedIcon := A_EventInfo
    Clipboard := file . ", " . selectedIcon
    GuiControl,, SelectedIconText, %selectedIcon%
Return

;;∙======∙Reload-Exit-Close Events∙===============================∙
RELOAD:
    Reload
Return

EXIT:
    ExitApp
Return

GuiClose:
    Reload
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
IconPeek:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

