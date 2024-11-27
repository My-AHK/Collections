
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙--------∙Origins∙-------------------------∙
» Author:  
» Original Source:  
» 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
GoSub, AutoExecute
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
;;∙============================================================∙
;;∙======∙Tray Menu∙============================================∙
Menu, Tray, Tip, Tray Menu Example
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add 
Menu, Tray, Add 
Menu, Tray, Add, MenuHeader
Menu, Tray, Icon, MenuHeader, ieframe.dll, 3    ;;∙------∙;; Blue Lined Bent Corner Paper.
Menu, Tray, Default, MenuHeader    ;;∙------∙Makes Bold.
Menu, Tray, Add 
;;-----------------SUBMENU1
Menu, SubMenu1, Add 
Menu, SubMenu1, Add, Menu1
Menu, SubMenu1, Icon, Menu1, compstui.dll, 60    ;;∙------∙Blank Bent Corner Paper.
Menu, SubMenu1, Add 
Menu, SubMenu1, Add 
    Menu, SubMenu1, Color, 8FFFDD ; (Mint) 
Menu, Tray, Add, SubMenu1, :SubMenu1
Menu, Tray, Icon, SubMenu1, imageres.dll, 255    ;;∙------∙Halved Bent Corner Paper.
Menu, Tray, Add 
;;-----------------SUBMENU2
Menu, SubMenu2, Add 
Menu, SubMenu2, Add, Menu2
Menu, SubMenu2, Icon, Menu2, compstui.dll, 60    ;;∙------∙Blank Bent Corner Paper.
Menu, SubMenu2, Add 
    Menu, SubMenu2, Color, FF8FDD ; (Pink) 
Menu, Tray, Add, SubMenu2, :SubMenu2
Menu, Tray, Icon, SubMenu2, imageres.dll, 255    ;;∙------∙Halved Bent Corner Paper.
Menu, Tray, Add 
;;-----------------SCRIPT OPTIONS
Menu, Tray, Add, ···················
Menu, Tray, Icon, ···················, shell32.dll, 295
Menu, Tray, Add 
Menu, Tray, Add, Script·Edit
Menu, Tray, Icon, Script·Edit, shell32.dll, 270    ;;∙------∙Edit Pencil Bent Corner Paper.
Menu, Tray, Add 
Menu, Tray, Add, Script·Reload
Menu, Tray, Icon, Script·Reload, mmcndmgr.dll, 47    ;;∙------∙Green Refresh Bent Corner Paper.
Menu, Tray, Add 
Menu, Tray, Add, Script·Exit
Menu, Tray, Icon, Script·Exit, shell32.dll, 272    ;;∙------∙Red X Bent Corner Paper.
Menu, Tray, Add 
Menu, Tray, Add 
Return
;;∙------------------------------------------------------------------------------------------∙

;;∙============================================================∙
;;∙======∙MENU CALLS∙==========================================∙
MenuHeader:
    Soundbeep, 1400, 100
    Soundbeep, 1300, 100
    Soundbeep, 1500, 100
Return
;;∙------------------------------------∙
Menu1:
    Soundbeep, 1400, 150
Return
;;∙------------------------------------∙
Menu2:
    Soundbeep, 1400, 75
    Soundbeep, 1400, 75
Return
;;∙------------------------------------∙
···················:    ;; <∙------<∙Actual Menu item as an example.
    Soundbeep, 1200, 200
    Soundbeep, 1200, 700
Return
;;∙------------------------------------------------------------------------------------------∙

;;∙======∙TRAY MENU POSITION∙==================================∙
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20    ;;∙------∙Tooltip positioning. (20 pixels left and 20 up from cursor)
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
;;∙------------------------------------------------------------------------------------------∙
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
;;∙========================∙SCRIPT END∙=========================∙
;;∙------------------------------------------------------------------------------------------∙

