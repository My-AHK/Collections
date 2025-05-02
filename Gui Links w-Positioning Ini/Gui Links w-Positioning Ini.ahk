
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
;;∙============================================================∙
;^t::    ;;∙------∙🔥∙(Ctrl + T)
    Soundbeep, 1100, 250
Gui, Destroy

;;∙------∙* Read the saved positions or center if not previously saved.
IniRead, gui_position, LINKS.ini, window position, gui_position, Center

;;∙------------------------------------------------∙
guiW := "200"
guiH := "150"

Gui, +AlwaysOnTop -Caption +Border +Owner -SysMenu  +Hwndgui_id    ;;∙------∙Get the window's ID so you can get its position later.


Gui, Color, 211112
Gui, Font, s10 w500 q5
Gui, Add, Link, xm y20 vGoogle_Link, <a href="www.google.com">Google</a>
Gui, Add, Link, xm y+3 vWeather_Link, <a href="https://weather.com/">Weather</a>


Gui, Font, s10 w400 q5
Gui, Add, Text, x0 y+20 w%guiW% Center BackgroundTrans cLIME gReload, • RELOAD Script •
Gui, Add, Text, xp y+3 w%guiW% Center BackgroundTrans cRED gExit, • EXIT Script •
Gui, Add, Text, xp y+3 w%guiW% Center BackgroundTrans cWHITE gBreak, • Break Position •


Gui, Show, %gui_position% w%guiW% h%guiH% NoActivate,    ;;∙------∙'gui_position' places window at previously saved position.
    enableGuiDrag()    ;;∙------∙Draggable Gui Pt.1 (Add this after Gui Show Command).
    CenterControl(Google_Link, 1, 50, 0)    ;;∙------∙50% horizontal adjustment / 0% vertical change.
    CenterControl(Weather_Link, 1, 50, 0)    ;;∙------∙50% horizontal adjustment / 0% vertical change.
Return
;;∙------------------------------------------------∙


;;∙------------------------------------------------∙
uiMove:
    PostMessage, 0xA1, 2,,, A 
Return

Break:    ;;∙------∙Deletes ini file so Gui positioning can start fresh.
    Gui, Destroy    ;;∙------∙Essentially reload without last position recall.
    Sleep 10
    FileDelete, LINKS.ini
    Sleep 50
Return

;;∙------∙When you close the window, get its position and save it.
GuiClose:    ;;∙------∙Works with close button that is blocked by (-Caption) above.
    WinGetPos, gui_x, gui_y,,, ahk_id %gui_id%
    IniWrite, x%gui_x% y%gui_y%, LINKS.ini, window position, gui_position

Reload:    ;;∙------∙Reloads script to await next hotkey press.
    WinGetPos, gui_x, gui_y,,, ahk_id %gui_id%
    IniWrite, x%gui_x% y%gui_y%, LINKS.ini, window position, gui_position
    Reload
Return

Exit:    ;;∙------∙Exits script while retaining ini file.
    WinGetPos, gui_x, gui_y,,, ahk_id %gui_id%
    IniWrite, x%gui_x% y%gui_y%, LINKS.ini, window position, gui_position
ExitApp

Sleep 29500 ; 29.5 seconds
    Gui, Destroy    ;;∙------∙Closes Popup window after sleep time.

;;∙------∙Draggable Gui Pt.2 (Add toward end of script).
    enableGuiDrag(GuiLabel=1) {
WinGetPos,,,A_w,A_h,A
Gui, %GuiLabel%:Add, Text, x0 y0 w%A_w% h%A_h% +BackgroundTrans gGUI_Drag
Return

GUI_Drag:
    SendMessage 0xA1,2
Return
}
Return

;;∙------∙CenterControl() - For Links centering.
CenterControl(ByRef ControlID, GuiNum := 1, w := 50, h := 50, offsetx := 0, offsety := 0, method := 0)
{
    if (WinExist("ahk_id " ControlID))
        Hwnd_Gui := DllCall("user32\GetParent", "ptr", ControlID, "ptr")
    else
        Gui, %GuiNum%: +LastFound

    VarSetCapacity(RECT, 16)
    DllCall("user32\GetClientRect", "ptr", Hwnd_Gui ? Hwnd_Gui : WinExist(), "ptr", &RECT)
    GuiW := NumGet(RECT, 8, "int")
    GuiH := NumGet(RECT, 12, "int")

    if (Hwnd_Gui)
    {
        WinGetPos,,, WinW, WinH, ahk_id %Hwnd_Gui%
        ControlGetPos, ControlIDX, ControlIDY, ControlIDW, ControlIDH,, ahk_id %ControlID%
        posx := w ? Round((WinW - ControlIDW ) / Round(100 / w, 3)) + offsetx : ControlIDX
        posy := h ? (WinH - GuiH) - (WinW - Guiw) // 2 + Round((GuiH - ControlIDH) / Round(100 / h, 3)) + offsety : ControlIDY    
        ControlMove,, posx, posy,,, ahk_id %ControlID% 
        if (method)
            WinSet, Redraw,, % "ahk_id " Hwnd_Gui
    }
    else
    {
        GuiControlGet, ControlID, %GuiNum%:Pos
        posx := w ? Round((guiw - ControlIDW) // Round(100 / w, 3)) + offsetx : ControlIDX
        posy := h ? Round((guih - ControlIDH) // Round(100 / h, 3)) + offsety : ControlIDY
        GuiControl, % method ? GuiNum . ":MoveDraw" : GuiNum . ":Move", ControlID, % "x" . posx . " y" . posy
    }
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

