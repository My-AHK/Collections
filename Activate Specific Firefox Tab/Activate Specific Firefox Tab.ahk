
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙----------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙--------------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
» 
∙--------∙Origins∙-------------------------∙
» Author:  teadrinker
» Source:  https://www.autohotkey.com/boards/viewtopic.php?f=76&t=66263&hilit=MozillaTaskbarPreviewClass#p458317
» Activates a specific tab in Firefox (YouTube in example) so long as the tab already exists.
If it does not exist, it will open it in your default browser.
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TEMPLATE"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙🔥 HotKey 🔥∙===========================================∙
; ^t::    ;;∙------∙(Ctrl+T) 
;    Soundbeep, 1100, 100
;;∙============================================================∙




tabTextRegEx := ".*YouTube.*"    ;;∙------∙This is the tab title that is searched for.
url := "www.youtube.com"    ;;∙------∙This is the website that is opend if it doesn't exist already

F3::
SetBatchLines, -1
WinGet, list, List, ahk_class MozillaWindowClass ahk_exe firefox.exe
if !list
   throw "Firefox window not found"

accTab := ""
Loop % list {
   if !accFF := AccObjectFromWindow(hFF := list%A_Index%, OBJID_CLIENT := 0xFFFFFFFC)
      continue
   accTabList := SearchElement(accFF, {Role: ROLE_SYSTEM_PAGETABLIST := 0x3C})
   if accTab := SearchElement(accTabList, {Role: ROLE_SYSTEM_PAGETAB := 0x25, Name: tabTextRegEx})
      break
}
if !accTab
;;∙------∙Run, www.linguee.de  
   Run, % url
else {
   accTab.accDoDefaultAction(0)
   WinActivate, ahk_id %hFF%
}
Return

SearchElement(parentElement, params)
{
   found := true
   for k, v in params {
      try {
         if (k = "State")
            (!(parentElement.accState(0)    & v) && found := false)
         else if (k ~= "^(Name|Value)$")
            (!(parentElement["acc" . k](0) ~= v) && found := false)
         else if (k = "ChildCount")
            (parentElement["acc" . k]      != v  && found := false)
         else
            (parentElement["acc" . k](0)   != v  && found := false)
      }
      catch 
         found := false
   } until !found
   if found
      Return parentElement
   
   for k, v in AccChildren(parentElement)
      if obj := SearchElement(v, params)
         Return obj
}

AccObjectFromWindow(hWnd, idObject = 0)
{
   static IID_IDispatch   := "{00020400-0000-0000-C000-000000000046}"
        , IID_IAccessible := "{618736E0-3C3D-11CF-810C-00AA00389B71}"
        , OBJID_NATIVEOM  := 0xFFFFFFF0, VT_DISPATCH := 9, F_OWNVALUE := 1
        , h := DllCall("LoadLibrary", Str, "oleacc", Ptr)
        
   VarSetCapacity(IID, 16), idObject &= 0xFFFFFFFF
   DllCall("ole32\CLSIDFromString", Str, idObject = OBJID_NATIVEOM ? IID_IDispatch : IID_IAccessible, Ptr, &IID)
   if DllCall("oleacc\AccessibleObjectFromWindow", Ptr, hWnd, UInt, idObject, Ptr, &IID, PtrP, pAcc) = 0
      Return ComObject(VT_DISPATCH, pAcc, F_OWNVALUE)
}

AccChildren(Acc)  {
   Loop 1  {
      if ComObjType(Acc, "Name") != "IAccessible"  {
         error := "Invalid IAccessible Object"
         break
      }
      cChildren := Acc.accChildCount, Children := []
      VarSetCapacity(varChildren, cChildren*(8 + A_PtrSize*2), 0)
      if DllCall("oleacc\AccessibleChildren", Ptr, ComObjValue(Acc), Int, 0, Int, cChildren, Ptr, &varChildren, IntP, cChildren) != 0  {
         error := "AccessibleChildren DllCall Failed"
         break
      }
      Loop % cChildren  {
         i := (A_Index - 1)*(A_PtrSize*2 + 8) + 8
         child := NumGet(varChildren, i)
         Children.Insert( NumGet(varChildren, i - 8) = 9 ? AccQuery(child) : child )
         ( NumGet(varChildren, i - 8 ) = 9 && ObjRelease(child) )
      }
   }
   if error
      ErrorLevel := error
   else
      Return Children.MaxIndex() ? Children : ""
}

AccQuery(Acc)  {
   static IAccessible := "{618736e0-3c3d-11cf-810c-00aa00389b71}", VT_DISPATCH := 9, F_OWNVALUE := 1
   try Return ComObject(VT_DISPATCH, ComObjQuery(Acc, IAccessible), F_OWNVALUE)
}




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
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙--∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        SoundBeep, 1100, 75
        Soundbeep, 1200, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙--∙Double-Tap.
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
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;; Gui Drag Pt 1.
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
Menu, Tray, Icon, Suspend / Pause, shell32, 28  ;  Imageres.dll, 65
Menu, Tray, Default, Suspend / Pause    ;;∙------∙Makes Bold.
Menu, Tray, Add
;;------------------------------------------∙

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

