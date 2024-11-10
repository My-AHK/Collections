
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script ∙---------∙ DoubleTap--⮚ Ctrl + [HOME] 
» Exit Script ∙-------------∙ DoubleTap--⮚ Ctrl + [Esc] 
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
» 
∙--------∙Source∙-------------------------∙
» Drag-n-Drop files and Icons onto the Gui.
» File location path(s) will be displayed in a popup Gui, and also copied to the clipboard.
» Note: * This will only retrieve the file location path for a single 'Desktop' icon at a time.
∙=============================================================∙
*/

;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙DragonDrop Auto-Executes∙===============================∙
ScriptID := "DragonDrop∙Paths"
GoSub, AutoExecute
GoSub, TrayMenu

;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙DragonDrop Gui Layout  Variables∙==========================∙
;;∙------∙Sizes and Positions∙------∙
guiX := "800"    ;;∙------∙DragonDrop Gui X-axis.
guiY := "100"    ;;∙------∙DragonDrop Gui Y-axis.
;;∙------∙* See guiX2 and guiY2 below in script for Results Gui positioning *
;;∙------∙
gui1W := "200"    ;;∙------∙DragonDrop Gui Width.
gui1H := "75"    ;;∙------∙DragonDrop Gui Height.
;;∙------∙
gui2W := "650"    ;;∙------∙Response Return Gui Width.
gui2H := "175"    ;;∙------∙Response Return Gui Height.

;;∙------∙Fonts and Colors∙------∙
guiColor := "111121"    ;;∙------∙(Dark Blue)
;;∙------∙
g1Font := "Calibri"
g1FontSize := "12"
g1FontColor := "004CCC"    ;;∙------∙(Medium Blue)
;;∙------∙
g2Font := "Arial"
g2FontSize := "10"
g2FontColor := "80AEFF"    ;;∙------∙(Light Blue)

;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙DragonDrop Gui∙========================================∙
Gui, +AlwaysOnTop -Caption +Border +ToolWindow
Gui, Color, %guiColor%
Gui, Font, s%g1FontSize% c%g1FontColor%, %g1Font%
Gui, Add, Text, x0 y15 w%gui1W% BackgroundTrans Center, Drag A File Or Icon
Gui, Add, Text, x0 y+2 w%gui1W% BackgroundTrans Center, Onto This Window
Gui, Add, Picture, HwndhText x2 y3 w16 h16 gReloadIn Icon239, shell32.dll
        GuiTip(hText,  " RELOAD ")    ;;<------∙For GuiTip.
Gui, Add, Picture, HwndhText x182 y3 w16 h16 gExitOut Icon94, imageres.dll
        GuiTip(hText, " EXIT ")    ;;<------∙For GuiTip.
Gui, Show, w%gui1W% h%gui1H% x%guiX% y%guiY%

;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙DragonDrop Gui Response Returns∙=========================∙
guiE2W := gui2W-25
Gui, 2: +AlwaysOnTop -Caption +Border +ToolWindow
Gui, 2: Color, %guiColor%
Gui, 2: Font, s%g1FontSize% c%g2FontColor% Bold, %g1Font%
Gui, 2: Add, Text, x0 y15 w%gui2W% BackgroundTrans Center, File Paths:
Gui, 2: Font, s%g2FontSize% c%g1FontColor% Norm, %g2Font%
Gui, 2: Add, Edit, x10 vFilePaths r6 w%guiE2W% h150 ReadOnly BackgroundTrans,
Gui, 2: Add, Picture, HwndhText x2 y3 w16 h16 gReloadIn Icon239, shell32.dll
        GuiTip(hText,  " RELOAD ")
    guiEX2W := gui2W-18
Gui, 2: Add, Picture, HwndhText x%guiEX2W% y3 w16 h16 gExitOut Icon94, imageres.dll
        GuiTip(hText, " EXIT ")
Gui, 2: Font, s%g2FontSize% c%g2FontColor% Italic, %g1Font%
    gui2HCB := gui2H-20
Gui, 2: Add, Text, HwndhText gNone x0 y%gui2HCB% w%gui2W% BackgroundTrans Center, * Copied To Clipboard *
        GuiTip(hText, " File Path(s) Also Copied to Clipboard ")    ;;<------∙For GuiTip.
droppedFiles := []

;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙DragonDrop GuiDropFiles∙================================∙
GuiDropFiles:
{
    droppedFile := A_GuiEvent
    If (droppedFile = "")
        Return
    If (InStr(droppedFile, ".lnk"))
    {
        shell := ComObjCreate("WScript.Shell")
        shortcut := shell.CreateShortcut(droppedFile)
        targetPath := shortcut.TargetPath
        If (targetPath = "")
            MsgBox,262192,, Failed to retrieve the target path for the shortcut., 3
        Else
            droppedFiles.Push(targetPath)
    }
    Else
    {
        droppedFiles.Push(droppedFile)
    }
    
    If (droppedFiles.MaxIndex() > 0)
    {
        result := ""
        Loop, % droppedFiles.MaxIndex()
        {
            result .= droppedFiles[A_Index] . "`n"
        }
guiX2 :=  guiX-75, guiY2 := guiY+78    ;;<------∙Response Return Gui X&Y-axis
        Gui, 2: Show, w%gui2W% h%gui2H% x%guiX2% y%guiY2%, File Paths
        GuiControl, 2:, FilePaths, % result
    }
    droppedFiles := []
Clipboard := result
}
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙GuiTip∙================================================∙
GuiTip(hCtrl, text:="")
{
    hGui := text!="" ? DlLCall("GetParent", "Ptr", hCtrl) : hCtrl
    static hTip
    if !hTip
    {
        hTip := DllCall("CreateWindowEx", "UInt", 0x8, "Str", "tooltips_class32"
             ,  "Ptr", 0, "UInt", 0x80000002
             ,  "Int", 0x80000000, "Int",  0x80000000, "Int", 0x80000000, "Int", 0x80000000
             ,  "Ptr", hGui, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Ptr")
        DllCall("SendMessage", "Ptr", hTip, "Int", 0x0418, "Ptr", 0, "Ptr", 0)
        if (A_OsVersion == "WIN_XP")
            GuiTip(hGui)
    }
    static sizeof_TOOLINFO := 24 + (6 * A_PtrSize)
    VarSetCapacity(TOOLINFO, sizeof_TOOLINFO, 0)
    , NumPut(sizeof_TOOLINFO, TOOLINFO, 0, "UInt")
    , NumPut(0x11, TOOLINFO, 4, "UInt") ; TTF_IDISHWND:=0x0001|TTF_SUBCLASS:=0x0010
    , NumPut(hGui, TOOLINFO, 8, "Ptr")
    , NumPut(hCtrl, TOOLINFO, 8 + A_PtrSize, "Ptr")
    , NumPut(&text, TOOLINFO, 24 + (3 * A_PtrSize), "Ptr")
    static TTM_ADDTOOL := A_IsUnicode ? 0x0432 : 0x0404
    return DllCall("SendMessage", "Ptr", hTip, "Int", TTM_ADDTOOL, "Ptr", 0, "Ptr", &TOOLINFO)
}
;;∙------∙
None:    ;;<------∙GuiTip Dummy Call.
Return
;;∙============================================================∙


;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙EDIT \ RELOAD / EXIT∙===================================∙
;;----------------------- EDIT \ RELOAD / EXIT --------------------------∙
RETURN
;;∙-------∙EDIT∙-------∙EDIT∙------------∙
Script·Edit:    ;;<------∙Menu Call.
    Edit
Return
;;∙------∙RELOAD∙----∙RELOAD∙-------∙
^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;<------∙Double-Tap.
    Script·Reload:    ;;<------∙Menu Call.
    ReloadIn:    ;;<------∙Gui Call.
        Soundbeep, 1200, 75
        Soundbeep, 1400, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;<------∙Double-Tap.
    Script·Exit:    ;;<------∙Menu Call.
    ExitOut:    ;;<------∙Gui Call.
        Soundbeep, 1400, 75
        Soundbeep, 1200, 100
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
UpdateCheck:        ;; Check if the script file has been modified.
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
;;  #NoTrayIcon
#Persistent
#SingleInstance, Force
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")        ;;∙------∙Gui Drag Pt 1.
SetBatchLines -1
SetTimer, UpdateCheck, 500
SetTitleMatchMode 2
SetWinDelay 0
    if FileExist("DragonDrop FilePaths.ico")
    {
        Menu, Tray, Icon, DragonDrop FilePaths.ico
    }
    else
    {
        Menu, Tray, Icon, Imageres.dll, 243
    }
Return

;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Tray Menu∙============================================∙
TrayMenu:
Menu, Tray, Tip, %ScriptID%    ;;∙------∙Suspends hotkeys then pauses script.
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, %ScriptID%
Menu, Tray, Icon, %ScriptID%, Imageres.dll, 65
Menu, Tray, Default, %ScriptID%    ;;∙------∙Makes Bold.
Menu, Tray, Add

;;∙------∙Future Fluff∙------------------∙

;;∙------∙Script∙Options∙---------------∙
Menu, Tray, Add
Menu, Tray, Add, Script·Edit
Menu, Tray, Icon, Script·Edit, shell32.dll, 270
Menu, Tray, Add
Menu, Tray, Add, Script·Reload
Menu, Tray, Icon, Script·Reload, mmcndmgr.dll, 47
Menu, Tray, Add
Menu, Tray, Add, Script·Exit
Menu, Tray, Icon, Script·Exit, shell32.dll, 272
Menu, Tray, Add
Menu, Tray, Add
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙MENU CALLS∙==========================================∙
DragonDrop∙Paths:
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

