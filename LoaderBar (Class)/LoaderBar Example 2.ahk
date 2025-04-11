
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
;;∙======∙🔥 HotKey 🔥∙===========================================∙
^t::    ;;∙------∙(Ctrl+T) 
   Soundbeep, 1000, 200
;;∙============================================================∙




;;∙============================================================∙
/*            ** CREATE THE LOADERBAR **

;;∙------∙("Gui Name", x-axis, y-axis, LB width, LB Height, Enables the description)
;;∙------∙("MyGUI", 100, 100, 300, 30, 1)

  1. MyGUI
    • This is the GUI identifier. It’s a name you assign to the GUI window (in this case, "MyGUI"). 
        * This is useful when managing multiple GUI windows in the script. 
        * It tells the script which window to reference when creating or manipulating the LoaderBar.

  2. 100 (first number after "MyGUI")
    • This is the X-coordinate (horizontal position) where the LoaderBar will be placed within the GUI window. 
        * In this case, it's set to 100, meaning the progress bar will start 100 pixels from the left edge of the GUI.

  3. 100 (second number after "MyGUI")
    • This is the Y-coordinate (vertical position) where the LoaderBar will be placed within the GUI window. 
        * It is set to 100, meaning the progress bar will start 100 pixels from the top edge of the GUI.

  4. 300
    • This is the width of the LoaderBar in pixels. 
        * In this case, the progress bar will be 300 pixels wide.

  5. 
    • This is the height of the LoaderBar in pixels. 
        * The progress bar will be 30 pixels tall.

  6. 
    • This determines whether a description text is shown underneath the progress bar. 
        * A value of 1 enables the description (e.g., “Loading…”), while a value of 0 would hide the description text.
*/
;;∙============================================================∙


#NoEnv
#SingleInstance, Force
SetBatchLines, -1
SetWinDelay, 0

;;∙------∙Create the main GUI window.
Gui, +AlwaysOnTop +Resize
Gui, Font, s10
Gui, Add, Text, x0 y10 Center w300 h30, AutoHotkey LoaderBar Demo

;;∙------∙Instantiate the LoaderBar at position (10,50) with width 300 and height 30.
;;∙------∙The last parameter (1) enables the description text.
MyLoader := new LoaderBar("Default", 10, 50, 300, 30, 1)

;;∙------∙Show the GUI window.
Gui, Show, w330 h120, LoaderBar Demo.

;;∙------∙Initialize LoaderBar progress.
progress := 0

;;∙------∙Set a timer to update the progress every 100 milliseconds.
SetTimer, UpdateProgress, 100
Return

UpdateProgress:
    progress += 3
    if (progress > 100) {
        progress := 100
        SetTimer, UpdateProgress, Off    ;;∙------∙Stop updating when complete.
        SetTimer, CloseLoader, -2000    ;;∙------∙Close GUI after 2 seconds.
    }
    ;;∙------∙Update the LoaderBar with the current progress and a description.
    MyLoader.Set(progress, "Processing... " progress "%")
Return

CloseLoader:
    Gui, Destroy
Return


;;∙------------------------------------------------------------------------∙
class LoaderBar {
    __New(GUI_ID:="Default",x:=0,y:=0,w:=280,h:=28,ShowDesc:=0,FontColorDesc:="2B2B2B",FontColor:="EFEFEF",BG:="2B2B2B|2F2F2F|323232",FG:="66A3E2|4B79AF|385D87") {
        SetWinDelay,0
        SetBatchLines,-1
        if (StrLen(A_Gui))
            _GUI_ID:=A_Gui
        else
            _GUI_ID:=1
        if ((GUI_ID="Default") || !StrLen(GUI_ID) || GUI_ID==0)
            GUI_ID:=_GUI_ID
        this.GUI_ID := GUI_ID
        Gui, %GUI_ID%:Default
        this.BG := StrSplit(BG,"|")
        this.BG.W := w
        this.BG.H := h
        this.Width:=w
        this.Height:=h
        this.FG := StrSplit(FG,"|")
        this.FG.W := this.BG.W - 2
        this.FG.H := (fg_h:=(this.BG.H - 2))
        this.Percent := 0
        this.X := x
        this.Y := y
        fg_x:= this.X + 1
        fg_y:= this.Y + 1
        this.FontColor := FontColor
        this.ShowDesc := ShowDesc

        DescBGColor:="Black"
        this.DescBGColor := DescBGColor

        this.FontColorDesc := FontColorDesc

        Gui,Font,s8

        Gui, Add, Text, x%x% y%y% w%w% h%h% 0xE hwndhLoaderBarBG
        this.ApplyGradient(this.hLoaderBarBG := hLoaderBarBG,this.BG.1,this.BG.2,this.BG.3,1)

        Gui, Add, Text, x%fg_x% y%fg_y% w0 h%fg_h% 0xE hwndhLoaderBarFG
        this.ApplyGradient(this.hLoaderBarFG := hLoaderBarFG,this.FG.1,this.FG.2,this.FG.3,1)

        Gui, Add, Text, x%x% y%y% w%w% h%h% 0x200 border center BackgroundTrans hwndhLoaderNumber c%FontColor%, % "[ 0 % ]"
        this.hLoaderNumber := hLoaderNumber

        if (this.ShowDesc) {
            Gui, Add, Text, xp y+2 w%w% h16 0x200 Center border BackgroundTrans hwndhLoaderDesc c%FontColorDesc%, Loading...
            this.hLoaderDesc := hLoaderDesc
            this.Height:=h+18
        }

        Gui,Font
        Gui, %_GUI_ID%:Default
    }

    Set(p,w:="Loading...") {
        if (StrLen(A_Gui))
            _GUI_ID:=A_Gui
        else
            _GUI_ID:=1
        GUI_ID := this.GUI_ID
        Gui, %GUI_ID%:Default
        GuiControlGet, LoaderBarBG, Pos, % this.hLoaderBarBG
        this.BG.W := LoaderBarBGW
        this.FG.W := LoaderBarBGW - 2
        this.Percent:=(p>=100) ? p:=100 : p
        PercentNum:=Round(this.Percent,0)
        PercentBar:=floor((this.Percent/100)*(this.FG.W))

        hLoaderBarFG := this.hLoaderBarFG
        hLoaderNumber := this.hLoaderNumber

        GuiControl,Move,%hLoaderBarFG%,w%PercentBar%
        GuiControl,,%hLoaderNumber%,[ %PercentNum% `% ]

        if (this.ShowDesc) {
            hLoaderDesc := this.hLoaderDesc
            GuiControl,,%hLoaderDesc%, %w%
        }
        Gui, %_GUI_ID%:Default
    }

    ApplyGradient(Hwnd, LT := "101010", MB := "0000AA", RB := "00FF00", Vertical := 1) {
        Static STM_SETIMAGE := 0x172 
        ControlGetPos,,, W, H,, ahk_id %Hwnd%
        PixelData := Vertical ? LT "|" LT "|" LT "|" MB "|" MB "|" MB "|" RB "|" RB "|" RB : LT "|" MB "|" RB "|" LT "|" MB "|" RB "|" LT "|" MB "|" RB
        hBitmap := this.CreateDIB(PixelData, 3, 3, W, H, True)
        oBitmap := DllCall("SendMessage", "Ptr",Hwnd, "UInt",STM_SETIMAGE, "Ptr",0, "Ptr",hBitmap)
        Return hBitmap, DllCall("DeleteObject", "Ptr",oBitmap)
    }

    CreateDIB(PixelData, W, H, ResizeW := 0, ResizeH := 0, Gradient := 1) {      
        Static LR_Flag1 := 0x2008 ; LR_CREATEDIBSECTION := 0x2000 | LR_COPYDELETEORG := 8
            ,  LR_Flag2 := 0x200C ; LR_CREATEDIBSECTION := 0x2000 | LR_COPYDELETEORG := 8 | LR_COPYRETURNORG := 4 
            ,  LR_Flag3 := 0x0008 ; LR_COPYDELETEORG := 8
        WB := Ceil((W * 3) / 2) * 2, VarSetCapacity(BMBITS, WB * H + 1, 0), P := &BMBITS
        Loop, Parse, PixelData, |
        P := Numput("0x" A_LoopField, P+0, 0, "UInt") - (W & 1 and Mod(A_Index * 3, W * 3) = 0 ? 0 : 1)
        hBM := DllCall("CreateBitmap", "Int",W, "Int",H, "UInt",1, "UInt",24, "Ptr",0, "Ptr")    
        hBM := DllCall("CopyImage", "Ptr",hBM, "UInt",0, "Int",0, "Int",0, "UInt",LR_Flag1, "Ptr") 
        DllCall("SetBitmapBits", "Ptr",hBM, "UInt",WB * H, "Ptr",&BMBITS)
        If not (Gradient + 0)
            hBM := DllCall("CopyImage", "Ptr",hBM, "UInt",0, "Int",0, "Int",0, "UInt",LR_Flag3, "Ptr")  
        Return DllCall("CopyImage", "Ptr",hBM, "Int",0, "Int",ResizeW, "Int",ResizeH, "Int",LR_Flag2, "UPtr")
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

