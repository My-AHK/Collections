
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
» Author:  just me
» Source:  https://www.autohotkey.com/boards/viewtopic.php?f=6&t=2197
» [CLASS] CtlColors - Color Your Controls!
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
;   Soundbeep, 1100, 100
;;∙============================================================∙




;;∙============================================================∙
Gui, +AlwaysOnTop 
Gui, Color, Green
Gui, Font, s10 w400 q5, Arial
Gui, Add, Edit, x15 y10 w100 h20 hwndedit1, Edit1
Gui, Add, Edit, x15 y+5 w100 h25 hwndedit2, Edit2
Gui, Add, Edit, x15 y+5 w100 h30 hwndedit3, Edit3
Gui, Add, Button, x75 y+5 w40 h20 gSomeButton, EXIT
Gui, Show, x1500 y450w130 h125, EditBox GUI
    GuiControl, Focus, EXIT
;;∙------------------------∙
CtlColors.Attach(edit1, "Black", "Aqua")    ;;∙------∙Black Box/Aqua Text.
CtlColors.Attach(edit2, "FF9933", "9933FF")    ;;∙------∙Orange Box/Purple Text.
CtlColors.Attach(edit3, "E6B9B8", "Red")    ;;∙------∙Pink Box/Red Text.
Return
;;∙------------------------------------------------------------------------------------------∙


/*∙=====∙About∙================================================∙
∙--------∙Disclaimer∙---------------------∙
* This software is provided 'as-is', without any express or implied warranty.
* In no event will the authors be held liable for any damages arising from the use of this software.
∙--------------------------------------------∙
» Function:
    ▹ Auxiliary object to color controls on WM_CTLCOLOR... notifications.
    ▹ Supported controls are: Checkbox, ComboBox, DropDownList, Edit, ListBox, Radio, Text.
    ▹ Checkboxes and Radios accept only background colors due to design.
» Namespace:
    ▹ CtlColors
» Tested with:
    ▹ 1.1.25.02
» Tested on:
    ▹ Win 10 (x64)
» Change log:
    ▹ 1.0.04.00/2017-10-30/just me∙------∙Added transparent background (BkColor = "Trans").
    ▹ 1.0.03.00/2015-07-06/just me∙------∙Fixed Change() to run properly for ComboBoxes.
    ▹ 1.0.02.00/2014-06-07/just me∙------∙Fixed __New() to run properly with compiled scripts.
    ▹ 1.0.01.00/2014-02-15/just me∙------∙Changed class initialization.
    ▹ 1.0.00.00/2014-02-14/just me∙------∙Initial release.
∙-------------------------------------------------------------------------------------------∙
*/


;;∙======∙Functions∙=============================================∙
Class CtlColors {
;;∙------∙Class Variables∙-----------------------------------∙
;;∙------------------------------------------------------------------------------------------∙
    Static Attached := {}    ;;∙------∙Registered Controls
    Static HandledMessages := {Edit: 0, ListBox: 0, Static: 0}    ;;∙------∙OnMessage Handlers
    Static MessageHandler := "CtlColors_OnMessage"    ;;∙------∙Message Handler Function
    Static WM_CTLCOLOR := {Edit: 0x0133, ListBox: 0x134, Static: 0x0138}    ;;∙------∙Windows Messages
;;∙------∙HTML Colors (BGR)
    Static HTML := {AQUA: 0xFFFF00, BLACK: 0x000000, BLUE: 0xFF0000, FUCHSIA: 0xFF00FF, GRAY: 0x808080, GREEN: 0x008000
                    , LIME: 0x00FF00, MAROON: 0x000080, NAVY: 0x800000, OLIVE: 0x008080, PURPLE: 0x800080, RED: 0x0000FF
                    , SILVER: 0xC0C0C0, TEAL: 0x808000, WHITE: 0xFFFFFF, YELLOW: 0x00FFFF}
    Static NullBrush := DllCall("GetStockObject", "Int", 5, "UPtr")    ;;∙------∙Transparent Brush
    Static SYSCOLORS := {Edit: "", ListBox: "", Static: ""}    ;;∙------∙System Colors
    Static ErrorMsg := ""    ;;∙------∙Error message in case of errors
    Static InitClass := CtlColors.ClassInit()    ;;∙------∙Class initialization

;;∙------∙Constructor / Destructor∙---------------------------------------------------∙
   __New() {    ;;∙------∙You Must Not Instantiate This Class!!!
      If (This.InitClass == "!DONE!") {    ;;∙------∙External call after class initialization.
         This["!Access_Denied!"] := True
         Return False
      }
   }
;;∙------------∙
   __Delete() {
      If This["!Access_Denied!"]
         Return
      This.Free() ; free GDI resources
   }

;;∙------∙ClassInit∙----∙Internal creation of a new instance to ensure that __Delete() will be called∙-------∙
   ClassInit() {
      CtlColors := New CtlColors
      Return "!DONE!"
   }

;;∙------∙CheckBkColor∙----∙Internal check for parameter BkColor∙-----------∙
   CheckBkColor(ByRef BkColor, Class) {
      This.ErrorMsg := ""
      If (BkColor != "") && !This.HTML.HasKey(BkColor) && !RegExMatch(BkColor, "^[[:xdigit:]]{6}$") {
         This.ErrorMsg := "Invalid parameter BkColor: " . BkColor
         Return False
      }
      BkColor := BkColor = "" ? This.SYSCOLORS[Class]
              :  This.HTML.HasKey(BkColor) ? This.HTML[BkColor]
              :  "0x" . SubStr(BkColor, 5, 2) . SubStr(BkColor, 3, 2) . SubStr(BkColor, 1, 2)
      Return True
   }

;;∙------∙CheckTxColor∙----∙Internal check for parameter TxColor∙------------∙
   CheckTxColor(ByRef TxColor) {
      This.ErrorMsg := ""
      If (TxColor != "") && !This.HTML.HasKey(TxColor) && !RegExMatch(TxColor, "i)^[[:xdigit:]]{6}$") {
         This.ErrorMsg := "Invalid parameter TextColor: " . TxColor
         Return False
      }
      TxColor := TxColor = "" ? ""
              :  This.HTML.HasKey(TxColor) ? This.HTML[TxColor]
              :  "0x" . SubStr(TxColor, 5, 2) . SubStr(TxColor, 3, 2) . SubStr(TxColor, 1, 2)
      Return True
   }

/*∙===========================================================∙
» Attach
    ▹ Registers a control for coloring.
» Parameters:
    ▹ HWND∙-------∙HWND of the GUI control                                   
    ▹ BkColor∙-------∙HTML color name, 6-digit hexadecimal RGB value, or "" for default color
    ▹ * Optional 
    ▹ TxColor∙-------∙HTML color name, 6-digit hexadecimal RGB value, or "" for default color
» Return values:  On success∙-------∙True
    ▹ On failure∙-------∙False, CtlColors.ErrorMsg contains additional informations
∙-------------------------------------------------------------------------------------------∙
*/
   Attach(HWND, BkColor, TxColor := "") {
      Static ClassNames := {Button: "", ComboBox: "", Edit: "", ListBox: "", Static: ""}    ;;∙------∙Names of supported classes
      Static BS_CHECKBOX := 0x2, BS_RADIOBUTTON := 0x8    ;;∙------∙Button styles
      Static ES_READONLY := 0x800    ;;∙------∙Editstyles
      Static COLOR_3DFACE := 15, COLOR_WINDOW := 5    ;;∙------∙Default class background colors

;;∙------∙Initialize default background colors on first call∙-----------------------∙
      If (This.SYSCOLORS.Edit = "") {
         This.SYSCOLORS.Static := DllCall("User32.dll\GetSysColor", "Int", COLOR_3DFACE, "UInt")
         This.SYSCOLORS.Edit := DllCall("User32.dll\GetSysColor", "Int", COLOR_WINDOW, "UInt")
         This.SYSCOLORS.ListBox := This.SYSCOLORS.Edit
      }
      This.ErrorMsg := ""

;;∙------∙Check colors∙------------------------------------------------------------------∙
      If (BkColor = "") && (TxColor = "") {
         This.ErrorMsg := "Both parameters BkColor and TxColor are empty!"
         Return False
      }

;;∙------∙Check HWND∙------------------------------------------------------------------∙
      If !(CtrlHwnd := HWND + 0) || !DllCall("User32.dll\IsWindow", "UPtr", HWND, "UInt") {
         This.ErrorMsg := "Invalid parameter HWND: " . HWND
         Return False
      }
      If This.Attached.HasKey(HWND) {
         This.ErrorMsg := "Control " . HWND . " is already registered!"
         Return False
      }
      Hwnds := [CtrlHwnd]

;;∙------∙Check control's class∙--------------------------------------------------------∙
      Classes := ""
      WinGetClass, CtrlClass, ahk_id %CtrlHwnd%
      This.ErrorMsg := "Unsupported control class: " . CtrlClass
      If !ClassNames.HasKey(CtrlClass)
         Return False
      ControlGet, CtrlStyle, Style, , , ahk_id %CtrlHwnd%
      If (CtrlClass = "Edit")
         Classes := ["Edit", "Static"]
      Else If (CtrlClass = "Button") {
         IF (CtrlStyle & BS_RADIOBUTTON) || (CtrlStyle & BS_CHECKBOX)
            Classes := ["Static"]
         Else
            Return False
      }
      Else If (CtrlClass = "ComboBox") {
         VarSetCapacity(CBBI, 40 + (A_PtrSize * 3), 0)
         NumPut(40 + (A_PtrSize * 3), CBBI, 0, "UInt")
         DllCall("User32.dll\GetComboBoxInfo", "Ptr", CtrlHwnd, "Ptr", &CBBI)
         Hwnds.Insert(NumGet(CBBI, 40 + (A_PtrSize * 2, "UPtr")) + 0)
         Hwnds.Insert(Numget(CBBI, 40 + A_PtrSize, "UPtr") + 0)
         Classes := ["Edit", "Static", "ListBox"]
      }
      If !IsObject(Classes)
         Classes := [CtrlClass]

;;∙------∙Check background color∙---------------------------------------------------∙
      If (BkColor <> "Trans")
         If !This.CheckBkColor(BkColor, Classes[1])
            Return False

;;∙------∙Check text color∙--------------------------------------------------------------∙
      If !This.CheckTxColor(TxColor)
         Return False

;;∙------∙Activate message handling on the first call for a class∙---------------∙
      For I, V In Classes {
         If (This.HandledMessages[V] = 0)
            OnMessage(This.WM_CTLCOLOR[V], This.MessageHandler)
         This.HandledMessages[V] += 1
      }

;;∙------∙Store values for HWND∙-----------------------------------------------------∙
      If (BkColor = "Trans")
         Brush := This.NullBrush
      Else
         Brush := DllCall("Gdi32.dll\CreateSolidBrush", "UInt", BkColor, "UPtr")
      For I, V In Hwnds
         This.Attached[V] := {Brush: Brush, TxColor: TxColor, BkColor: BkColor, Classes: Classes, Hwnds: Hwnds}

;;∙------∙Redraw control∙---------------------------------------------------------------∙
      DllCall("User32.dll\InvalidateRect", "Ptr", HWND, "Ptr", 0, "Int", 1)
      This.ErrorMsg := ""
      Return True
   }

/*∙===========================================================∙
» Change
    ▹ Change control colors.
» Parameters:
    ▹ HWND∙------∙HWND of the GUI control
    ▹ BkColor∙------∙HTML color name, 6-digit hexadecimal RGB value, or "" for default color
    ▹ * Optional 
    ▹ TxColor∙------∙HTML color name, 6-digit hexadecimal RGB value, or "" for default color
» Return values:
    ▹ On success∙------∙True
    ▹ On failure∙------∙False, CtlColors.ErrorMsg contains additional informations
» Remarks:
    ▹ If the control isn't registered yet, Add() is called instead internally.
∙-------------------------------------------------------------------------------------------∙
*/
   Change(HWND, BkColor, TxColor := "") {
;;∙------∙Check HWND∙-----------------------------------------------------------------∙
      This.ErrorMsg := ""
      HWND += 0
      If !This.Attached.HasKey(HWND)
         Return This.Attach(HWND, BkColor, TxColor)
      CTL := This.Attached[HWND]

;;∙------∙Check BkColor∙----------------------------------------------------------------∙
      If (BkColor <> "Trans")
         If !This.CheckBkColor(BkColor, CTL.Classes[1])
            Return False

;;∙------∙Check TxColor∙----------------------------------------------------------------∙
      If !This.CheckTxColor(TxColor)
         Return False

;;∙------∙Store Colors∙-------------------------------------------------------------------∙
      If (BkColor <> CTL.BkColor) {
         If (CTL.Brush) {
            If (Ctl.Brush <> This.NullBrush)
               DllCall("Gdi32.dll\DeleteObject", "Prt", CTL.Brush)
            This.Attached[HWND].Brush := 0
         }
         If (BkColor = "Trans")
            Brush := This.NullBrush
         Else
            Brush := DllCall("Gdi32.dll\CreateSolidBrush", "UInt", BkColor, "UPtr")
         For I, V In CTL.Hwnds {
            This.Attached[V].Brush := Brush
            This.Attached[V].BkColor := BkColor
         }
      }
      For I, V In Ctl.Hwnds
         This.Attached[V].TxColor := TxColor
      This.ErrorMsg := ""
      DllCall("User32.dll\InvalidateRect", "Ptr", HWND, "Ptr", 0, "Int", 1)
      Return True
   }

/*∙===========================================================∙
» Detach
    ▹ Stop control coloring.
» Parameters:
    ▹ HWND∙------∙HWND of the GUI control
» Return values:
    ▹ On success∙------∙True
    ▹ On failure∙------∙False, CtlColors.ErrorMsg contains additional informations
∙-------------------------------------------------------------------------------------------∙
*/
   Detach(HWND) {
      This.ErrorMsg := ""
      HWND += 0
      If This.Attached.HasKey(HWND) {
         CTL := This.Attached[HWND].Clone()
         If (CTL.Brush) && (CTL.Brush <> This.NullBrush)
            DllCall("Gdi32.dll\DeleteObject", "Prt", CTL.Brush)
         For I, V In CTL.Classes {
            If This.HandledMessages[V] > 0 {
               This.HandledMessages[V] -= 1
               If This.HandledMessages[V] = 0
                  OnMessage(This.WM_CTLCOLOR[V], "")
         }  }
         For I, V In CTL.Hwnds
            This.Attached.Remove(V, "")
         DllCall("User32.dll\InvalidateRect", "Ptr", HWND, "Ptr", 0, "Int", 1)
         CTL := ""
         Return True
      }
      This.ErrorMsg := "Control " . HWND . " is not registered!"
      Return False
   }

/*∙===========================================================∙
» Free
    ▹ Stop coloring for all controls and free resources.
» Return values:
    ▹ Always True.
∙-------------------------------------------------------------------------------------------∙
*/
   Free() {
      For K, V In This.Attached
         If (V.Brush) && (V.Brush <> This.NullBrush)
            DllCall("Gdi32.dll\DeleteObject", "Ptr", V.Brush)
      For K, V In This.HandledMessages
         If (V > 0) {
            OnMessage(This.WM_CTLCOLOR[K], "")
            This.HandledMessages[K] := 0
         }
      This.Attached := {}
      Return True
   }

/*∙===========================================================∙
» IsAttached
    ▹ Check if the control is registered for coloring.
» Parameters:
    ▹ HWND∙------∙HWND of the GUI control
» Return values:
    ▹ On success∙------∙True
    ▹ On failure∙------∙False
∙-------------------------------------------------------------------------------------------∙
*/
   IsAttached(HWND) {
      Return This.Attached.HasKey(HWND)
   }
}

/*∙===========================================================∙
» CtlColors_OnMessage
    ▹ This function handles CTLCOLOR messages. There's no reason to call it manually!
∙-------------------------------------------------------------------------------------------∙
*/
CtlColors_OnMessage(HDC, HWND) {
   Critical
   If CtlColors.IsAttached(HWND) {
      CTL := CtlColors.Attached[HWND]
      If (CTL.TxColor != "")
         DllCall("Gdi32.dll\SetTextColor", "Ptr", HDC, "UInt", CTL.TxColor)
      If (CTL.BkColor = "Trans")
         DllCall("Gdi32.dll\SetBkMode", "Ptr", HDC, "UInt", 1) ; TRANSPARENT = 1
      Else
         DllCall("Gdi32.dll\SetBkColor", "Ptr", HDC, "UInt", CTL.BkColor)
      Return CTL.Brush
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
SomeButton:
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
;    Soundbeep, 1700, 100
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

