
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙--------∙Origins∙-------------------------∙
» Author:  teadrinker
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?style=2&t=66747#p286942
» 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "Mouse_Tracker"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
#NoEnv
SetBatchLines, -1

hotkeyToTrack := "F4"    ;;∙------∙🔥HotKey🔥
guiWidth  := 60
guiHeight := 40
guiColor  := "DEDE00"

hGui := CreateGui(guiWidth, guiHeight, guiColor)
info := {hWnd: hGui, width: guiWidth, height: guiHeight}
handler := Func("ToggleHook").Bind(info)
Hotkey, % "$" . hotkeyToTrack, % handler, On

ToggleHook(info) {
   static hHook
   if hHook {
      SetHook(hHook), hHook := ""
      Gui, % info.hWnd . ":Show", Hide
   }
   else {
      hHook := SetHook(WH_MOUSE_LL := 14, "LowLevelMouseProc", pObj := Object(info))
      ObjRelease(pObj)
      MouseMove, 1, 0, 0, R
      MouseMove,-1, 0, 0, R
   }
}

CreateGui(width, height, color) {
   Gui, New, +LastFound -Caption +ToolWindow +hwndhGui +AlwaysOnTop -DPIScale +E0x20    ;;∙------∙WS_EX_TRANSPARENT = 0x20.
   WinSet, Region, 1-1 W%width% H%height% E
   WinSet, Transparent, 170
   Gui, Color, % color
   Gui, Show, w%width% h%height% Hide
   Return hGui
}

LowLevelMouseProc(nCode, wParam, lParam) {
   static WM_MOUSEMOVE   := 0x200
        , WM_LBUTTONDOWN := 0x201
        , info, hGui, width, height
        
   if !hGui {
      info := Object(A_EventInfo)
      hGui := info.hWnd, width := info.width, height := info.height
   }
   if (wParam = WM_LBUTTONDOWN) {
      timer := Func("ToggleHook").Bind(info)
      SetTimer, % timer, -10
   }
   if (wParam = WM_MOUSEMOVE)  {
      mouseX := NumGet(lParam + 0, "Int")
      mouseY := NumGet(lParam + 4, "Int")
      x := mouseX - width/2, y := mouseY - height/2
      try Gui, %hGui%: Show, x%x% y%y% NA
   }
   Return DllCall("CallNextHookEx", Ptr, 0, Int, nCode, UInt, wParam, Ptr, lParam)
}

SetHook(hook, fn := "", eventInfo := "", isGlobal := true) {
   static exitFunc
   if !fn {
      res := DllCall("UnhookWindowsHookEx", "Ptr", hook)
      OnExit(exitFunc, 0)
      exitFunc := ""
   }
   else {
      hHook := DllCall("SetWindowsHookEx", "Int", hook, "Ptr", RegisterCallback(fn, "Fast", 3, eventInfo)
                                         , "Ptr", !isGlobal ? 0 : DllCall("GetModuleHandle", "UInt", 0, "Ptr")
                                         , "UInt", isGlobal ? 0 : DllCall("GetCurrentThreadId"), "Ptr")
      ( exitFunc && OnExit(exitFunc, 0) )
      exitFunc := Func(A_ThisFunc).Bind(hHook, "")
      OnExit(exitFunc)
      Return hHook
   }
}
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
;;∙======∙Auto-Execute Sub∙======================================∙
AutoExecute:
#MaxThreadsPerHotkey 3
#NoEnv
;;∙------∙#NoTrayIcon
#Persistent
#SingleInstance, Force
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.
SetBatchLines -1
SetTimer, UpdateCheck, 500
SetTitleMatchMode 2
SetWinDelay 0
Menu, Tray, Icon, imageres.dll, 3
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
Mouse_Tracker:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

