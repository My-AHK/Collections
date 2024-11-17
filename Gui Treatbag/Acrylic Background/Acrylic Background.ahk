
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
» Author:  lexikos
» SOURCE:  https://www.autohotkey.com/boards/viewtopic.php?f=6&t=63643#p384579
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TEMPLATE"    ;;∙------∙Need to also change in "MENU CALLS"
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙🔥 HotKey 🔥∙===========================================∙
; ^t::    ;;∙------∙(Ctrl+T) 
;    Soundbeep, 1100, 100
;;∙============================================================∙




;;∙============================================================∙
CreateGui()   ;;∙------∙Initializes & Displays GUI.

Gui, Acrylic: Show, x950 y250 w500 h700
Return


;;∙------------------------------------------------------------------------------------------∙
CreateGui() {
    thisFntSize := 25    ;;∙------∙Sets font size.
    bgrColor := "00006F"    ;;∙------∙Sets background color.
    txtColor := "DEDE00"    ;;∙------∙Sets the text color.

    Gui, Acrylic: -DPIScale +Owner +hwndhGui
    Gui, Acrylic: Margin, % thisFntSize*2, % thisFntSize*2
    Gui, Acrylic: Color, c%bgrColor%
    Gui, Acrylic: Font, s%thisFntSize% Q5, Arial
    Gui, Acrylic: Add, Text, c%txtColor% , This is a demo! Enjoy!
    WinSet, AlwaysOnTop, On, ahk_id %hGui%    ;;∙------∙Sets the GUI to always stay on top.
    SetAcrylicGlassEffect(bgrColor, 125, hGui)    ;;∙------∙Applies Acrylic Blur Effect with Specified Color (bgrColor) & Opacity (125).
}
;;∙---------------------------------------------∙
ConvertToBGRfromRGB(RGB) {    ;;∙------∙Converts the RGB color code to BGR format.
    BGR := SubStr(RGB, -1, 2) SubStr(RGB, 1, 4)
    Return BGR
}
;;∙---------------------------------------------∙
SetAcrylicGlassEffect(thisColor, thisAlpha, hWindow) {    ;;∙------∙Applies Acrylic effect to the window.
    initialAlpha := thisAlpha    ;;∙------∙Stores the initial Alpha transparency value.
    If (thisAlpha<16)
       thisAlpha := 16    ;;∙------∙Sets a minimum Alpha value of 16.
    Else If (thisAlpha>245)
       thisAlpha := 245    ;;∙------∙Caps the maximum Alpha value at 245.
    thisColor := ConvertToBGRfromRGB(thisColor)    ;;∙------∙Converts input Color to BGR format.
    thisAlpha := Format("{1:#x}", thisAlpha)    ;;∙------∙Formats Alpha Value as a hexadecimal number.
    gradient_color := thisAlpha . thisColor    ;;∙------∙Combines Alpha & Color into a Gradient Color.
    Static init, accent_state := 4, ver := DllCall("GetVersion") & 0xff < 10   ;;∙------∙Checks Windows version.
    Static pad := A_PtrSize = 8 ? 4 : 0, WCA_ACCENT_POLICY := 19    ;;∙------∙Sets compatibility variables for Windows 64-bit and Accent Policy.
    accent_size := VarSetCapacity(ACCENT_POLICY, 16, 0)    ;;∙------∙Prepares space for the ACCENT_POLICY structure.
    NumPut(accent_state, ACCENT_POLICY, 0, "int")    ;;∙------∙Stores the accent state into the ACCENT_POLICY structure.
    If (RegExMatch(gradient_color, "0x[[:xdigit:]]{8}"))
       NumPut(gradient_color, ACCENT_POLICY, 8, "int")    ;;∙------∙Inserts the gradient color into the ACCENT_POLICY structure.
    VarSetCapacity(WINCOMPATTRDATA, 4 + pad + A_PtrSize + 4 + pad, 0)    ;;∙------∙Prepares space for the window composition data.
    && NumPut(WCA_ACCENT_POLICY, WINCOMPATTRDATA, 0, "int")    ;;∙------∙Stores the Accent Policy value.
    && NumPut(&ACCENT_POLICY, WINCOMPATTRDATA, 4 + pad, "ptr")    ;;∙------∙Stores the ACCENT_POLICY structure pointer.
    && NumPut(accent_size, WINCOMPATTRDATA, 4 + pad + A_PtrSize, "uint")    ;;∙------∙Stores the ACCENT_POLICY size.
    If !(DllCall("user32\SetWindowCompositionAttribute", "ptr", hWindow, "ptr", &WINCOMPATTRDATA))    ;;∙------∙Applies the acrylic blur effect using a Windows API call.
       Return 0    ;;∙------∙Returns 0 if the API call fails.
    thisOpacity := (initialAlpha<16) ? 60 + initialAlpha*9 : 250    ;;∙------∙Calculates the opacity based on the alpha value.
    WinSet, Transparent, %thisOpacity%, ahk_id %hWindow%    ;;∙------∙Sets the window transparency based on the opacity.
    Return 1    ;;∙------∙Returns success if the effect was applied.
}

;;∙---------------------------------------------∙
thisGuiaGuiEscape:
thisGuiaGuiClose:
    ExitApp
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
        Soundbeep, 1200, 75
        Soundbeep, 1400, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙--∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
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
Menu, Tray, Icon, Imageres.dll, 65
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
;;∙------∙  ∙--------------------------------∙

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
TEMPLATE:    ;;∙------∙Change as needed to match the 'ScriptID' variable in AutoExe section.
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

