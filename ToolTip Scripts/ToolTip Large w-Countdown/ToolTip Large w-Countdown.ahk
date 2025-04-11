
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  teadrinker
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?style=17&f=76&t=82403#p554594
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
title := "Hello!"
text := "This is my custom TrayTip.`nIt will disappear in five seconds."

hToolTip := CustomToolTip({ title: title, text: text, icon: 0, closeButton: true
                          , backColor: 0x0F18B0, textColor: 0xB4DAFD, fontName: "Calibri"
                          , margin: [10, 10, 10, 10]
                          , trayTip: true
                          , fontOptions: "s18"
                          , timeout: 5000 }*)

Timer := Func("UpdateText").Bind(hToolTip, [ StrReplace(text, "five seconds", "one second")
                                              , StrReplace(text, "five", "two")
                                              , StrReplace(text, "five", "three")
                                              , StrReplace(text, "five", "four") ])
SetTimer, % Timer, 1000
Sleep, 6000
;; ExitApp
Return


CustomToolTip( text, x := "", y := "", title := ""
             , icon := 0  ; can be 1 — Info, 2 — Warning, 3 — Error, if greater than 3 — hIcon
             , transparent := false
             , margin := "" ; [left, top, right, bottom]
             , closeButton := false, backColor := 0xFFFFFF, textColor := 0
             , fontName := "", fontOptions := ""  ; like in GUI
             , trayTip := false
             , isBallon := false, timeout := "", maxWidth := 600 )
{
   static ttStyles := (TTS_NOPREFIX := 2) | (TTS_ALWAYSTIP := 1), TTS_BALLOON := 0x40, TTS_CLOSE := 0x80
        , TTF_TRACK := 0x20, TTF_ABSOLUTE := 0x80
        , TTM_SETMAXTIPWIDTH := 0x418, TTM_TRACKACTIVATE := 0x411, TTM_TRACKPOSITION := 0x412
        , TTM_SETTIPBKCOLOR := 0x413, TTM_SETTIPTEXTCOLOR := 0x414, TTM_SETMARGIN := 0x41A
        , TTM_ADDTOOL        := A_IsUnicode ? 0x432 : 0x404
        , TTM_SETTITLE       := A_IsUnicode ? 0x421 : 0x420
        , TTM_UPDATETIPTEXT  := A_IsUnicode ? 0x439 : 0x40C
        , WM_SETFONT := 0x30, WM_GETFONT := 0x31
        , WS_EX_TRANSPARENT := 0x00000020
        , exStyles := (WS_EX_TOPMOST := 0x00000008) | (WS_EX_COMPOSITED := 0x2000000) | (WS_EX_LAYERED := 0x00080000)
        
   dhwPrev := A_DetectHiddenWindows
   DetectHiddenWindows, On
   defGuiPrev := A_DefaultGui, lastFoundPrev := WinExist()
   (trayTip && isBallon := true)
   hWnd := DllCall("CreateWindowEx", "UInt", exStyles | WS_EX_TRANSPARENT * !!transparent, "Str", "tooltips_class32", "Str", ""
                                   , "UInt", ttStyles | TTS_CLOSE * !!CloseButton | TTS_BALLOON * !!isBallon
                                   , "Int", 0, "Int", 0, "Int", 0, "Int", 0, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Ptr")
   WinExist("ahk_id" . hWnd)
   DllCall("UxTheme\SetWindowTheme", "Ptr", hWnd, "Ptr", 0, "Str", "")
   SendMessage, TTM_SETTIPBKCOLOR  , backColor >> 16 | backColor & 0xFF00 | (backColor & 0xFF) << 16
   SendMessage, TTM_SETTIPTEXTCOLOR, textColor >> 16 | textColor & 0xFF00 | (textColor & 0xFF) << 16
   if (fontName || fontOptions) {
      Gui, New
      Gui, Font, % fontOptions, % fontName
      Gui, Add, Text, hwndhText
      SendMessage, WM_GETFONT,,,, ahk_id %hText%
      SendMessage, WM_SETFONT, ErrorLevel
      Gui, Destroy
      Gui, %defGuiPrev%: Default
   }
   if trayTip {
      Loc := GetTrayIconLocation()
      x := Loc.x + Loc.w//2
      y := Loc.y + 4
   }
   if (x = "" || y = "")
      DllCall("GetCursorPos", "Int64P", pt)
   (x = "" && x := (pt & 0xFFFFFFFF) + 15), (y = "" && y := (pt >> 32) + 15)
   
   if IsObject(margin) {
      VarSetCapacity(RECT, 16, 0)
      for k, v in margin
         NumPut(v, RECT, 4*(A_Index - 1), "UInt")
      SendMessage, TTM_SETMARGIN,, &RECT
   }
   
   VarSetCapacity(TOOLINFO, sz := 24 + A_PtrSize*6, 0)
   NumPut(sz, TOOLINFO)
   NumPut(TTF_TRACK | TTF_ABSOLUTE * !isBallon, TOOLINFO, 4)
   NumPut(&text, TOOLINFO, 24 + A_PtrSize*3)
   
   SendMessage, TTM_SETTITLE      , icon, &title
   SendMessage, TTM_TRACKPOSITION ,     , x | (y << 16)
   SendMessage, TTM_SETMAXTIPWIDTH,     , maxWidth
   SendMessage, TTM_ADDTOOL       ,     , &TOOLINFO
   SendMessage, TTM_UPDATETIPTEXT ,     , &TOOLINFO
   SendMessage, TTM_TRACKACTIVATE , true, &TOOLINFO
   
   if trayTip {
      timer := Func("TrackTrayIcon").Bind(hWnd)
      SetTimer, % timer, 300
   }
   
   if timeout {
      Timer := Func("DllCall").Bind("DestroyWindow", "Ptr", hWnd)
      SetTimer, % Timer, % "-" . timeout
   }
   WinExist("ahk_id" . lastFoundPrev)
   DetectHiddenWindows, % dhwPrev
   Return hWnd
}

UpdateText(hTooltip, TextArray) {
   static TTM_UPDATETIPTEXT := A_IsUnicode ? 0x439 : 0x40C
   text := TextArray.Pop()
   VarSetCapacity(TOOLINFO, sz := 24 + A_PtrSize*6, 0)
   NumPut(sz, TOOLINFO)
   NumPut(&text, TOOLINFO, 24 + A_PtrSize*3)
   SendMessage, TTM_UPDATETIPTEXT,, &TOOLINFO,, ahk_id %hTooltip%
   if (TextArray[1] = "")
      SetTimer,, Delete
}

TrackTrayIcon(hToolTip) {
   static x_prev := 0, y_prev := 0
   if !WinExist("ahk_id " . hToolTip) {
      SetTimer,, Delete
      Return
   }
   Loc := GetTrayIconLocation()
   x := Loc.x + Loc.w//2
   y := Loc.y + 4
   if (x != x_prev || y != y_prev) {
      SendMessage, TTM_TRACKPOSITION := 0x412,, x | (y << 16)
      x_prev := x, y_prev := y
   }
}

GetTrayIconLocation(hWnd := 0, uID := 0x404) {
   (!hWnd && hWnd := A_ScriptHwnd)
   VarSetCapacity(NOTIFYICONIDENTIFIER, structSize := A_PtrSize*3 + 16, 0)
   NumPut(structSize, NOTIFYICONIDENTIFIER)
   NumPut(hWnd, NOTIFYICONIDENTIFIER, A_PtrSize)
   NumPut(uID, NOTIFYICONIDENTIFIER, A_PtrSize*2)

   VarSetCapacity(RECT, 16, 0)
   hr := DllCall("Shell32\Shell_NotifyIconGetRect", "Ptr", &NOTIFYICONIDENTIFIER, "Ptr", &RECT)
   if (hr != 0)
      throw "Failed to get tray icon location"
   else {
      x := NumGet(RECT, "UInt")
      y := NumGet(RECT, 4, "UInt")
      w := NumGet(RECT, 8, "UInt") - x
      h := NumGet(RECT, 12, "UInt") - y
      Loc := {x: x, y: y, w: w, h: h}
   }
   Return Loc
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

