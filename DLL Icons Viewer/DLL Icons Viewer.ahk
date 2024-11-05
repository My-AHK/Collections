
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
» Author:  pcg
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?f=6&t=122021#p541814
» What It Is:  GUI interface for viewing icons, in both big and small formats, from various dynamic-link libraries (DLLs) on a Windows system. Double click an icon and it's path is copied to the Clipboard for use.
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "DLL∙Icons∙Viewer"
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙🔥 HotKey 🔥∙===========================================∙
; ^t::    ;;∙------∙(Ctrl+T) 
;    Soundbeep, 1100, 100
;;∙============================================================∙




global Count := 350, File := "shell32.dll" 
global Shell32:=1,imageres:=0,pifmgr:=0,ddores:=0,moricons:=0,mmcndmgr:=0,netshell:=0,setupapi:=0,wmploc:=0,compstui:=0,ieframe:=0,accessibilitycpl:=0,mmres:=0,netcenter:=0,networkexplorer:=0,pnidui:=0,sensorscpl:=0,wpdshext:=0,dmdskres:=0,dsuiext:=0,mstscax:=0,wiashext:=0,comres:=0,actioncentercpl:=0,aclui:=0,autoplay:=0,comctl32:=0,filemgmt:=0,url:=0,xwizards:=0

GWidth := "495" ,  GHeight := "725"    ;;∙------∙Gui Width and Height.
GColor := "4785FF" , TColor := "010B6F"    ;;∙------∙Gui and Gui Text Colors.
colbgr1:="0B0B0B", colbgr2:="0B0B0B"    ;;∙------∙Button Background Colors.
coltxt1:="01A70B" , coltxt2:="A7010B"    ;;∙------∙Button Text Colors.
LVColor1 := "99BBFF" , LVColor2 := "99BBFF"    ;;∙------∙Listview Background Colors.



CreateGui:
    Gui, Destroy 
    Gui, +AlwaysOnTop -Caption +Border
    Gui, Color, %GColor%
    Gui, Font, s10 c%TColor%
        addRadioButtons()
;	    Gui, Font, Bold
	Gui, Add,ListView,x175 y20 w135 h670 gListClick Background%LVColor1%, Big Icons 	; List.(image)view for Big Icons
;	    Gui, Font, Norm
	ImageListID := IL_Create(Count,,1)	
	LV_SetImageList(ImageListID,1)
	loop, % Count
		IL_Add(ImageListID,File,A_Index) 
	loop, % Count
		LV_Add("Icon" A_Index, "     -     " A_Index,2)
	LV_ModifyCol(1,115)			; Adjusting width.
;	    Gui, Font, Bold
	Gui, Add,ListView,x350 y20 w135 h670 gListClick Background%LVColor2%, Small Icons 	; List.(image)view for Small Icons
;	    Gui, Font, Norm
	ImageListID_small := IL_Create(Count)	
	LV_SetImageList(ImageListID_small)
	loop, % Count
		IL_Add(ImageListID_small,File,A_Index) 
	loop, % Count
		LV_Add("Icon" A_Index, "     -     " A_Index,2)
	LV_ModifyCol(1,115)			; Adjusting width.
	
Gui, Font, s10 BOLD, CALIBRI 				 ; Buttons
    colbgr1:="black", coltxt1:="Lime"
Gui, Add, Progress, x245  y695  w65  h25 Disabled Background%colbgr%
Gui, Add, Text, xp yp wp hp c%coltxt1% HwndhText BackgroundTrans Center 0x200 0x00800000 gRELOAD, RELOAD
        GuiTip(hText, "RELOAD")
Gui, Add, Picture, x317 y695 HwndhText gDlabel BackgroundTrans w26 h26 Icon160, shell32.dll
        GuiTip(hText, "DRAGGABLE")

    colbgr2:="black", coltxt2:="Red"
Gui, Add, Progress, x350  y695  w65  h25 Disabled Background%colbgr%
Gui, Add, Text, xp yp wp hp c%coltxt2% HwndhText BackgroundTrans Center 0x200 0x00800000 gEXIT, EXIT
        GuiTip(hText, "EXIT")

Gui Show, w%GWidth% h%GHeight%, DLL Icons Viewer" 
Return

RadioClick:
	Gui, Submit										
	File := (Shell32 ? "shell32.dll" : pifmgr ? "pifmgr.dll" : ddores ? "ddores.dll" : moricons ? "moricons.dll" : mmcndmgr ? "mmcndmgr.dll" : netshell ? "netshell.dll" : setupapi ? "setupapi.dll" : compstui ? "compstui.dll" : ieframe ? "ieframe.dll" : wmploc ? "wmploc.dll" : accessibilitycpl ? "accessibilitycpl.dll" : mmres ? "mmres.dll" : netcenter ? "netcenter.dll" : networkexplorer ? "networkexplorer.dll" : pnidui ? "pnidui.dll" : sensorscpl ? "sensorscpl.dll" : wpdshext ? "wpdshext.dll" : dmdskres ? "dmdskres.dll" : dsuiext ? "dsuiext.dll" : mstscax ? "mstscax.dll" : wiashext ? "wiashext.dll" : comres ? "comres.dll" : actioncentercpl ? "actioncentercpl.dll" : aclui ? "aclui.dll" : autoplay ? "autoplay.dll" : comctl32 ? "comctl32.dll" : filemgmt ? "filemgmt.dll" : url ? "url.dll" : xwizards ? "xwizards.dll" : "imageres.dll")
	Shell32=0,imageres:=0,ifmgr:=0,ddores:=0,moricons:=0,mmcndmgr:=0,netshell:=0,setupapi:=0,wmploc:=0,compstui:=0,ieframe:=0,accessibilitycpl:=0,mmres:=0,netcenter:=0,networkexplorer:=0,pnidui:=0,sensorscpl:=0,wpdshext:=0,dmdskres:=0,dsuiext:=0,mstscax:=0,wiashext:=0,comres:=0,actioncentercpl:=0,aclui:=0,autoplay:=0,comctl32:=0,filemgmt:=0,url:=0,xwizards:=0
	Loop, parse, % "Shell32,imageres,pifmgr,ddores,moricons,mmcndmgr,netshell,setupapi,wmploc,compstui,ieframe,accessibilitycpl,mmres,netcenter,networkexplorer,pnidui,sensorscpl,wpdshext,dmdskres,dsuiext,mstscax,wiashext,comres,actioncentercpl,aclui,autoplay,comctl32,filemgmt,url,xwizards", ,
		if (A_Loopfield=a_guicontrol)
			%a_guicontrol% := 1		
	gosub, CreateGui
Return

Dlabel:
Return

ListClick(){
  If (A_GuiEvent = "DoubleClick"){
    Clipboard := A_WinDir "\system32\" File ", " A_EventInfo

	tooltip % "copied to clipboard"
	sleep 500
	tooltip
}}

addRadioButtons()
{
	Gui, Add,Radio, y20 vaccessibilitycpl gRadioClick Checked%accessibilitycpl% ,accessibilitycpl.dll
	Gui, Add,Radio,vaclui gRadioClick Checked%aclui% ,aclui.dll
	Gui, Add,Radio,vactioncentercpl gRadioClick Checked%actioncentercpl% ,actioncentercpl.dll
	Gui, Add,Radio,vautoplay gRadioClick Checked%autoplay% ,autoplay.dll
	Gui, Add,Radio,vcomctl32 gRadioClick Checked%comctl32% ,comctl32.dll
	Gui, Add,Radio,vcompstui gRadioClick Checked%compstui% ,compstui.dll
	Gui, Add,Radio,vcomres gRadioClick Checked%comres% ,comres.dll
	Gui, Add,Radio,vddores gRadioClick Checked%ddores% ,ddores.dll
	Gui, Add,Radio,vdmdskres gRadioClick Checked%dmdskres% ,dmdskres.dll
	Gui, Add,Radio,vdsuiext gRadioClick Checked%dsuiext% ,dsuiext.dll
	Gui, Add,Radio,vfilemgmt gRadioClick Checked%filemgmt% ,filemgmt.dll
	Gui, Add,Radio,vieframe gRadioClick Checked%ieframe% ,ieframe.dll
	Gui, Add,Radio,vImageRes gRadioClick Checked%imageres% ,imageres.dll
	Gui, Add,Radio,vmmcndmgr gRadioClick Checked%mmcndmgr% ,mmcndmgr.dll
	Gui, Add,Radio,vmmres gRadioClick Checked%mmres% ,mmres.dll
	Gui, Add,Radio,vmoricons gRadioClick Checked%moricons% ,moricons.dll
	Gui, Add,Radio,vmstscax gRadioClick Checked%mstscax% ,mstscax.dll
	Gui, Add,Radio,vnetcenter gRadioClick Checked%netcenter% ,netcenter.dll
	Gui, Add,Radio,vnetshell gRadioClick Checked%netshell% ,netshell.dll
	Gui, Add,Radio,vnetworkexplorer gRadioClick Checked%networkexplorer% ,networkexplorer.dll
	Gui, Add,Radio,vpifmgr gRadioClick Checked%pifmgr% ,pifmgr.dll
	Gui, Add,Radio,vpnidui gRadioClick Checked%pnidui% ,pnidui.dll
	Gui, Add,Radio,vsensorscpl gRadioClick Checked%sensorscpl% ,sensorscpl.dll
	Gui, Add,Radio,vsetupapi gRadioClick Checked%setupapi% ,setupapi.dll
	Gui, Add,Radio,vShell32  gRadioClick Checked%Shell32%,shell32.dll
	Gui, Add,Radio,vurl gRadioClick Checked%url% ,url.dll
	Gui, Add,Radio,vwiashext gRadioClick Checked%wiashext% ,wiashext.dll
	Gui, Add,Radio,vwmploc gRadioClick Checked%wmploc% ,wmploc.dll
	Gui, Add,Radio,vwpdshext gRadioClick Checked%wpdshext% ,wpdshext.dll
	Gui, Add,Radio,vxwizards gRadioClick Checked%xwizards% ,xwizards.dll
}

#IfWinActive ahk_class AutoHotkeyGUI
	WheelDown::
		ControlClick, SysListView321, ,,WD,1
		ControlClick, SysListView322, ,,WD,1
	return
	
	WheelUp::
		ControlClick, SysListView321, ,,WU,1
		ControlClick, SysListView322, ,,WU,1
	return
#IfWinActive

;;∙======∙GuiTip Function∙==============================================∙
GuiTip(hCtrl, text:="")
{
    hGui := text!="" ? DlLCall("GetParent", "Ptr", hCtrl) : hCtrl
    static hTip
    if !hTip
    {
        hTip := DllCall("CreateWindowEx", "UInt", 0x8, "Str", "tooltips_class32"
             ,  "Ptr", 0, "UInt", 0x80000002 ;// WS_POPUP:=0x80000000|TTS_NOPREFIX:=0x02
             ,  "Int", 0x80000000, "Int",  0x80000000, "Int", 0x80000000, "Int", 0x80000000
             ,  "Ptr", hGui, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Ptr")

        ; TTM_SETMAXTIPWIDTH = 0x0418
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
;;∙================================================================∙
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
    RELOAD:    ;;∙------∙Gui Button.
        Soundbeep, 1200, 75
        Soundbeep, 1400, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙--∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
    EXIT:    ;;∙------∙Gui Button.
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
Menu, Tray, Icon, filemgmt.dll, 1
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
Menu, Tray, Icon, %ScriptID%, filemgmt.dll, 1
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
DLL∙Icons∙Viewer:
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











;;∙============================================================∙
;;∙============================================================∙
;;∙============================================================∙
/*
accessibilitycpl:=0
aclui:=0
actioncentercpl:=0
autoplay:=0
azroleui:=0
certmgr:=0
colorui:=0
comctl32:=0
comdlg32:=0
compstui:=0
comres:=0
connect:=0
cryptui:=0
ddores:=0
devmgr:=0
dmdskres:=0
dsuiext:=0
dxptasksync:=0
els:=0
fdprint:=0
filemgmt:=0
fontext:=0
hnetcfg:=0
ieframe:=0
imageres:=0
imagesp1:=0
ipsmsnap:=0
localsec:=0
mmcbase:=0
mmcndmgr:=0
mmres:=0
moricons:=0
msctf:=0
mshtml:=0
msihnd:=0
mssvp:=0
mstscax:=0
msutb:=0
netcenter:=0
netplwiz:=0
netshell:=0
networkexplorer:=0
ntshrui:=0
objsel:=0
pifmgr:=0
pnidui:=0
portabledevicestatus:=0
quartz:=0
printui:=0
prnfldr:=0
rasdlg:=0
rasgcw:=0
scrptadm:=0
sensorscpl:=0
setupapi:=0
shell32:=0
sndvolsso:=0
stobject:=0
synccenter:=0
twinui:=0
url:=0
urlmon:=0
webcheck:=0
wiadefui:=0
wiashext:=0
wininetlui:=0
wlangpui:=0
wlanpref:=0
wmp:=0
wmploc:=0
wpdshext:=0
xwizards:=0

***========= DLL Files List / 66 Unique Items ==========***
***==== Additional DLL Files for Potential Future Use ====***
accessibilitycpl
aclui
actioncentercpl
autoplay
azroleui
certmgr
colorui
comctl32
comdlg32
compstui
comres
connect
cryptui
ddores
devmgr
dmdskres
dsuiext
dxptasksync
els
fdprint
filemgmt
fontext
hnetcfg
ieframe
imageres
imagesp1
ipsmsnap
localsec
mmcbase
mmcndmgr
mmres
moricons
msctf
mshtml
msihnd
mssvp
mstscax
msutb
netcenter
netplwiz
netshell
networkexplorer
ntshrui
objsel
pifmgr
pnidui
portabledevicestatus
quartz
printui
prnfldr
rasdlg
rasgcw
scrptadm
sensorscpl
setupapi
shell32
sndvolsso
stobject
synccenter
twinui
url
urlmon
webcheck
wiadefui
wiashext
wininetlui
wlangpui
wlanpref
wmp
wmploc
wpdshext
xwizards


***==== Single Continuous Line with (:=0) / 66 Unique Items ====***

accessibilitycpl:=0,aclui:=0,actioncentercpl:=0,autoplay:=0,azroleui:=0,certmgr:=0,colorui:=0,comctl32:=0,comdlg32:=0,compstui:=0,comres:=0,connect:=0,cryptui:=0,ddores:=0,devmgr:=0,dmdskres:=0,dsuiext:=0,dxptasksync:=0,els:=0,fdprint:=0,filemgmt:=0,fontext:=0,hnetcfg:=0,ieframe:=0,imageres:=0,imagesp1:=0,ipsmsnap:=0,localsec:=0,mmcbase:=0,mmcndmgr:=0,mmres:=0,moricons:=0,msctf:=0,mshtml:=0,msihnd:=0,mssvp:=0,mstscax:=0,msutb:=0,netcenter:=0,netplwiz:=0,netshell:=0,networkexplorer:=0,ntshrui:=0,objsel:=0,pifmgr:=0,pnidui:=0,portabledevicestatus:=0,quartz:=0,printui:=0,prnfldr:=0,rasdlg:=0,rasgcw:=0,scrptadm:=0,sensorscpl:=0,setupapi:=0,shell32:=0,sndvolsso:=0,stobject:=0,synccenter:=0,twinui:=0,url:=0,urlmon:=0,webcheck:=0,wiadefui:=0,wiashext:=0,wininetlui:=0,wlangpui:=0,wlanpref:=0,wmp:=0,wmploc:=0,wpdshext:=0,xwizards:=0



*/








