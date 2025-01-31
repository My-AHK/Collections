

/*∙=====∙ORIGINS∙=============================================∙
» Original Author:  SKAN
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?t=81064#p352736
∙=============================================================∙
*/

;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "ShowMenu()"    ;;∙------∙Also change in 'MENU CALLS' at script end.
#Persistent
#SingleInstance, Force
    SetTimer, UpdateCheck, 500
Menu, Tray, Icon, imageres.dll, 3
GoSub, TrayMenu
;;∙============================================================∙

;;∙======∙🔥 HotKey 🔥∙===========================================∙
^t::    ;;∙------∙(Ctrl+T) 
    Soundbeep, 1100, 100
;;∙============================================================∙




;;∙============================================================∙
;;∙======∙SETTINGS∙==========================∙
CoordMode, Menu, Screen
CoordMode, Mouse, Screen
;;∙--------------------------------------------------------------∙
xPos := 1600    ;;∙------∙Set x-Axis coordinate.
yPos := 600    ;;∙------∙Set y-Axis coordinate.
mSpeed := 2    ;;∙------∙Set mouse travel speed.
;;∙======∙Settings End∙========================∙


;;∙======∙SCREEN DIRECT POSITIONING∙=========∙
MouseMove, %xPos%, %yPos%, %mSpeed%    ;;∙------∙Comment out to leave cursor alone.
ShowMenu(MenuGetHandle("Tray"), False, xPos, yPos, 0x14)
Return
        ;;∙----------?---?---∙ ~OR~ ∙---?---?----------∙
/*∙======∙SCREEN CENTER POSITIONING∙========∙
MouseMove, A_ScreenWidth/2, A_ScreenHeight/2, %mSpeed%
ShowMenu( MenuGetHandle("Tray"), False, A_ScreenWidth/2, A_ScreenHeight/2, 0x14 )
Return
*/
;;∙======∙Positioning End∙======================∙


;;∙======∙FUNCTION∙==========================∙
ShowMenu(hMenu, MenuLoop:=0, X:=0, Y:=0, Flags:=0) {
Local
    If (hMenu="WM_ENTERMENULOOP")
        Return True
    Fn := Func("ShowMenu").Bind("WM_ENTERMENULOOP"), n := MenuLoop=0 ? 0 : OnMessage(0x211,Fn,-1)
    DllCall("SetForegroundWindow","Ptr",A_ScriptHwnd)     
    R := DllCall("TrackPopupMenu", "Ptr",hMenu, "Int",Flags, "Int",X, "Int",Y, "Int",0
            , "Ptr",A_ScriptHwnd, "Ptr",0, "UInt"), OnMessage(0x211,Fn, 0)
    DllCall("PostMessage", "Ptr",A_ScriptHwnd, "Int",0, "Ptr",0, "Ptr",0)
return R
}
Return
;;∙======∙Function End∙========================∙
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
ShowMenu():    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
    Suspend
    Soundbeep, 700, 100
    Pause
Return
;;∙============================================================∙

;;∙------------------------------------------------------------------------------------------∙
;;∙========================∙SCRIPT END∙=========================∙
;;∙------------------------------------------------------------------------------------------∙

