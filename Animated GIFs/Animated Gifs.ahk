
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  dustind900
» Original Source:  https://www.autohotkey.com/board/topic/97650-function-animatedgif/
» Updated Source:  https://www.autohotkey.com/boards/viewtopic.php?style=7&t=5099#p29886
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

Img1 = https://i.gifer.com/XwYs.gif
Img2 = http://www.animatedgif.net/cartoons/anime_hero2_e0.gif

Gui New, +AlwaysOnTop -Caption +Border +HwndhGUI
gif1 := AnimatedGif(hGUI, Img1, 50, 50, 200, 200,, "MyGif", "MyGif_")
gif2 := AnimatedGif(hGUI, Img2, 300, 50, 292, 167, "White", "MyGif2", new MyGif2)
Gui, Show
Return

GuiClose:
    ExitApp
Return

AnimatedGif(ByRef guiHwnd, Image, X, Y, W, H, BackgroundColor:="system", Id:="AnimatedGif", eventHandler:="") {
    if BackgroundColor in system
    {
        A_FI := A_FormatInteger
        SetFormat Integer, Hex
        BGR := DllCall("GetSysColor", Int, 15) + 0x1000000
        SetFormat Integer, %A_FI%
        StringMid R, BGR, 8, 2
        StringMid G, BGR, 6, 2
        StringMid B, BGR, 4, 2
        BackgroundColor := R G B
        StringUpper BackgroundColor, BackgroundColor
        BackgroundColor := "#" BackgroundColor
    }
    Gui %guiHwnd%:Add, ActiveX, x%X% y%Y% w%W% h%H% +HwndGifHwnd, MSHTML:
    GuiControlGet HtmlObj, %guiHwnd%:, %GifHwnd%
    HtmlObj.parentWindow.execScript("document.oncontextmenu = function(){return false;}")
    HtmlObj.Body.style.BackgroundColor := BackgroundColor
    HtmlObj.Body.style.margin := 0
    HtmlObj.Body.style.padding := 0
    out := HtmlObj.createElement("img")
    out.id := Id
    out.src := Image
    out.style.position := "absolute"
    out.style.left := 0
    out.style.top := 0
    out.style.width := "100%"
    out.style.height := "100%"
    out.style.minWidth := "100%"
    out.style.minHeight := "100%"
    out.style.visibility := "visible"
    HtmlObj.Body.appendChild(out)
    if eventHandler
        ComObjConnect(out, eventHandler)
    return out
}


;;∙------------∙Mouse Action Announcements∙------------∙
MyGif_OnClick(thisGif) {
    ToolTip % "You Clicked " thisGif.Id
        SetTimer, killTip, -1100
    return
}

class MyGif2
{
    OnClick(thisGif) {
        ToolTip % "You Clicked " thisGif.Id
            SetTimer, killTip, -1100
        return
    }

        OnMouseDown(thisGif) {
        if GetKeyState("LButton", "P")
            ToolTip left mouse button down
                if GetKeyState("RButton", "P")
            ToolTip Right Mouse Button Down
                SetTimer, killTip, -1100
        return
    }
    
    OnMouseUp(thisGif) {
        ToolTip Mouse Button Released
            SetTimer, killTip, -1100
        return
    }
    
    OnMouseOver(thisGif) {
        ToolTip You Are Hovering
            SetTimer, killTip, -1100
        return
    }
    
    OnMouseOut(thisGif) {
        ToolTip You Are No Longer Hovering
            SetTimer, killTip, -1100
        return
    }
    
    OnDblClick(thisGif) {
        ToolTip % "You Double-Clicked " thisGif.Id
            SetTimer, killTip, -1100
                return
    }
}
Return

killTip:
    ToolTip
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
  If ((NM := Format(Fun . "_{:03X}", Msg := P[2])) && P.Count()<4)
     Return (T := Max(-5000, 0-(P[1] ? Abs(P[1]) : 250)))
  Critical
  If ((Msg<0x201 || Msg>0x209) || (IsFunc(NM) || Islabel(NM))=0)
     Return
  Chk := (Fun . "_" . (Msg<=0x203 ? "203" : Msg<=0x206 ? "206" : Msg<=0x209 ? "209" : ""))
  SetTimer, %NM%,  %  (Msg==0x203        || Msg==0x206        || Msg==0x209)
    ? (-1, Clk:=2) : (Clk=2 ? ("Off", Clk:=1) : (IsFunc(Chk) || IsLabel(Chk) ? T : -1))
Return True
}
Return
;;∙============================================================∙

;;∙------------------------------------------------------------------------------------------∙
;;∙========================∙SCRIPT END∙=========================∙
;;∙------------------------------------------------------------------------------------------∙

