
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

» There are 5 sections to update if adding other .dll files.
    ▹ 1. GLOBALS
    ▹ 2. RADIO BUTTON HANDLER
    ▹ 3. RESET RADIO BUTTONS
    ▹ 4. THE LOOP
    ▹ 5. RADIO BUTTON CREATION
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "DLL∙Icons∙Viewer"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
;;∙============================================================∙
;;∙======∙GLOBALS∙==========================∙
global Count := 350, File := "shell32.dll"
;;∙------------------------------------------------∙
global  accessibilitycpl:=0, aclui:=0, actioncentercpl:=0
global  autoplay:=0, azroleui:=, comctl32:=0, comdlg32, compstui:=0
global  comres:=0, ddores:=0, devmgr:=0,dmdskres:=0, dsuiext:=0, explorerframe:=0
global  filemgmt:=0, fontext:=0, ieframe:=0, imageres:=0, mmcndmgr:=0
global  mmres:=0, moricons:=0, mshtml:=0, mstscax:=0, netshell:=0
global  netcenter:=0, networkexplorer:=0, pifmgr:=0, pnidui:=0
global  sensorscpl:=0, setupapi:=0, Shell32:=1, sndvolsso:=0, stobject:=0, twinui:=0
global  url:=0, user32:=0,webcheck:=0,wiashext:=0, wmploc:=0, wpdshext:=0, xwizards:=0, zipfldr:=0


;;∙======∙SETTINGS∙==========================∙
;;∙------∙Gui Configurations.
GWidth := 630 , GHeight := 630    ;;∙------∙Gui width and height. Changed to 630 height and wider width
GXpos := 1200 , GYpos := 50    ;;∙------∙Gui x-axis & y-axis.

GColor := "212223" , TColor := "006FDE"    ;;∙------∙Gui and Gui text colors.

;;∙------∙Reload & Exit Buttons.
ButtonBgColor1 := "0B0B0B", ButtonBgColor2 := "0B0B0B"    ;;∙------∙Button background colors.
ButtonTextColor1 := "01A70B" , ButtonTextColor2 := "A7010B"    ;;∙------∙Button text colors.

;;∙------∙ListViews.
LVTextColor1 := "8FC1E2" , LVTextColor2 := "8FC1E2"    ;;∙------∙Listview text colors.
LVBgColor1 := "676767" , LVBgColor2 := "676767"    ;;∙------∙Listview background colors.


;;∙======∙GUI CREATION∙=====================∙
CreateGui:
    Gui, Destroy
    Gui, +AlwaysOnTop -Caption +Border
    Gui, Color, %GColor%
    Gui, Font, s10 c%TColor%
        addRadioButtons()

    Gui, Add, ListView, x320 y20 w135 h565 gListClick Background%LVBgColor1% c%LVTextColor1%, Big Icons    ;;∙------∙List (image)view for Big Icons. Adjusted height

    ImageListID := IL_Create(Count,,1)
    LV_SetImageList(ImageListID,1)
    Loop, % Count
        IL_Add(ImageListID, File, A_Index)
    Loop, % Count
        LV_Add("Icon" A_Index, "     -     " A_Index, 2)
    LV_ModifyCol(1, 115)    ;;∙------∙Adjusting width.

    Gui, Add, ListView, x475 y20 w135 h565 gListClick Background%LVBgColor2% c%LVTextColor2%, Small Icons    ;;∙------∙List.(image)view for Small Icons. Adjusted height

    ImageListID_small := IL_Create(Count)
    LV_SetImageList(ImageListID_small)
    Loop, % Count
        IL_Add(ImageListID_small, File, A_Index)
    Loop, % Count
        LV_Add("Icon" A_Index, "     -     " A_Index, 2)
    LV_ModifyCol(1, 115)    ;;∙------∙Adjusting width.

    ;;∙------∙Display file path.
    Gui, Add, Edit, x20 y560 w270 h25 vFilePathDisplay -VScroll ReadOnly, %A_WinDir%\system32\%File%
Gui, Font, s8
    Gui, Add, Text, x30 yp+30 cGray BackgroundTrans, Path copied to clipboard when icon is double-clicked
Gui, Font, s10

;;∙======∙BUTTONS∙==========================∙
    Gui, Font, s10 BOLD, CALIBRI    ;;∙------∙Buttons.

    ButtonBgColor1 := "black", ButtonTextColor1 := "Lime"
    Gui, Add, Progress, x380 y595 w65 h25 Disabled Background%ButtonBgColor%
    Gui, Add, Text, xp yp wp hp c%ButtonTextColor1% HwndhText BackgroundTrans Center 0x200 0x00800000 gRELOAD, RELOAD
        GuiTip(hText, "RELOAD")

    Gui, Add, Picture, x452 y595 HwndhText gDlabel BackgroundTrans w26 h26 Icon160, shell32.dll
        GuiTip(hText, "DRAGGABLE")

    ButtonBgColor2 := "black", ButtonTextColor2 := "Red"
    Gui, Add, Progress, x485 y595 w65 h25 Disabled Background%ButtonBgColor%
    Gui, Add, Text, xp yp wp hp c%ButtonTextColor2% HwndhText BackgroundTrans Center 0x200 0x00800000 gEXIT, EXIT
        GuiTip(hText, "EXIT")

    Gui, Show, x%GXpos% y%GYpos% w%GWidth% h%GHeight%, DLL Icons Viewer
Return


;;∙======∙RADIO BUTTON HANDLER∙============∙
RadioClick:
    Gui, Submit
    File := (accessibilitycpl ? "accessibilitycpl.dll"  
        : aclui ? "aclui.dll"  
        : actioncentercpl ? "actioncentercpl.dll"  
        : autoplay ? "autoplay.dll"  
        : azroleui ? "azroleui.dll"
        : comctl32 ? "comctl32.dll"  
        : comdlg32 ? "comdlg32.dll"
        : compstui ? "compstui.dll"  
        : comres ? "comres.dll"  
        : ddores ? "ddores.dll"  
        : devmgr ? "devmgr.dll"
        : dmdskres ? "dmdskres.dll"  
        : dsuiext ? "dsuiext.dll"  
        : explorerframe ? "explorerframe.dll"
        : filemgmt ? "filemgmt.dll"  
        : fontext ? "fontext.dll"
        : ieframe ? "ieframe.dll"  
        : imageres ? "imageres.dll"  
        : mmcndmgr ? "mmcndmgr.dll"  
        : mmres ? "mmres.dll"  
        : moricons ? "moricons.dll"  
        : mshtml ? "mshtml.dll"
        : mstscax ? "mstscax.dll"  
        : netcenter ? "netcenter.dll"  
        : netshell ? "netshell.dll"  
        : networkexplorer ? "networkexplorer.dll"  
        : pifmgr ? "pifmgr.dll"  
        : pnidui ? "pnidui.dll"  
        : sensorscpl ? "sensorscpl.dll"  
        : setupapi ? "setupapi.dll"  
        : Shell32 ? "shell32.dll"  
        : sndvolsso ? "sndvolsso.dll"  
        : stobject ? "stobject.dll"
        : twinui ? "twinui.dll"
        : url ? "url.dll"  
        : user32 ? "user32.dll"
        : webcheck ? "webcheck.dll"
        : wiashext ? "wiashext.dll"  
        : wmploc ? "wmploc.dll"  
        : wpdshext ? "wpdshext.dll"  
        : xwizards ? "xwizards.dll"
        : "zipfldr.dll")    ;;∙------∙Ternary final fallback.
    GuiControl,, FilePathDisplay, %A_WinDir%\system32\%File%


;;∙======∙RESET RADIO BUTTONS∙==============∙
accessibilitycpl := 0
aclui := 0
actioncentercpl := 0
autoplay := 0
azroleui := 0
comctl32 := 0
comdlg32 := 0
compstui := 0
comres := 0
ddores := 0
devmgr := 0
dmdskres := 0
dsuiext := 0
explorerframe := 0
filemgmt := 0
fontext := 0
ieframe := 0
imageres := 0
mmcndmgr := 0
mmres := 0
moricons := 0
mshtml := 0
mstscax := 0
netcenter := 0
netshell := 0
networkexplorer := 0
pifmgr := 0
pnidui := 0
sensorscpl := 0
setupapi := 0
Shell32 := 0
sndvolsso := 0
stobject := 0
twinui := 0
url := 0
user32 := 0
webcheck := 0
wiashext := 0
wmploc := 0
wpdshext := 0
xwizards := 0
zipfldr := 0

;;∙======∙ THE LOOP ∙========================∙
    Loop, Parse, % "accessibilitycpl,aclui,actioncentercpl,autoplay,azroleui,comctl32,comdlg32,compstui,comres,ddores,devmgr,dmdskres,dsuiext,explorerframe,filemgmt,fontext,ieframe,imageres,mmcndmgr,mmres,moricons,mshtml,mstscax,netcenter,netshell,networkexplorer,pifmgr,pnidui,sensorscpl,setupapi,Shell32,sndvolsso,stobject,twinui,url,user32,webcheck,wiashext,wmploc,wpdshext,xwizards,zipfldr", `,
    {
        if (A_LoopField = A_GuiControl)
            %A_GuiControl% := 1
    }
    Gosub, CreateGui
Return


;;∙======∙DRAG LABEL∙=======================∙
Dlabel:
Return


;;∙======∙LISTVIEW HANDLER∙=================∙
ListClick()
{
    if (A_GuiEvent = "DoubleClick")
    {
        Clipboard := A_WinDir "\system32\" File ", " A_EventInfo
        ToolTip % "Copied To The Clipboard"
        SetTimer, KillTip, -1500
    }
    ; Update the file path display with the selected icon number
    GuiControl,, FilePathDisplay, %A_WinDir%\system32\%File%, %A_EventInfo%
}

KillTip:
    ToolTip
    SetTimer, KillTip, Off
return


;;∙======∙RADIO BUTTON CREATION∙===========∙
addRadioButtons()
{
    yPos := 20
    yIncrement := 25    ;;∙------∙Radio button spacing.
    
    ;;∙------∙First column (x=20)
    Gui, Add, Radio, y%yPos% x20 vaccessibilitycpl gRadioClick Checked%accessibilitycpl%, accessibilitycpl.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x20 vaclui gRadioClick Checked%aclui%, aclui.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x20 vactioncentercpl gRadioClick Checked%actioncentercpl%, actioncentercpl.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x20 vautoplay gRadioClick Checked%autoplay%, autoplay.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x20 vazroleui gRadioClick Checked%azroleui%, azroleui.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x20 vcomctl32 gRadioClick Checked%comctl32%, comctl32.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x20 vcomdlg32 gRadioClick Checked%comdlg32%, comdlg32.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x20 vcompstui gRadioClick Checked%compstui%, compstui.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x20 vcomres gRadioClick Checked%comres%, comres.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x20 vddores gRadioClick Checked%ddores%, ddores.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x20 vdevmgr gRadioClick Checked%devmgr%, devmgr.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x20 vdmdskres gRadioClick Checked%dmdskres%, dmdskres.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x20 vdsuiext gRadioClick Checked%dsuiext%, dsuiext.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x20 vexplorerframe gRadioClick Checked%explorerframe%, explorerframe.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x20 vfilemgmt gRadioClick Checked%filemgmt%, filemgmt.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x20 vfontext gRadioClick Checked%fontext%, fontext.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x20 vieframe gRadioClick Checked%ieframe%, ieframe.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x20 vImageRes gRadioClick Checked%imageres%, imageres.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x20 vmmcndmgr gRadioClick Checked%mmcndmgr%, mmcndmgr.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x20 vmmres gRadioClick Checked%mmres%, mmres.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x20 vmoricons gRadioClick Checked%moricons%, moricons.dll


    ;;∙------∙Reset Y position for second column.
    yPos := 20
    ;;∙------∙Second column (x=160).
    Gui, Add, Radio, y%yPos% x160 vmshtml gRadioClick Checked%mshtml%, mshtml.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x160 vmstscax gRadioClick Checked%mstscax%, mstscax.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x160 vnetcenter gRadioClick Checked%netcenter%, netcenter.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x160 vnetshell gRadioClick Checked%netshell%, netshell.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x160 vnetworkexplorer gRadioClick Checked%networkexplorer%, networkexplorer.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x160 vpifmgr gRadioClick Checked%pifmgr%, pifmgr.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x160 vpnidui gRadioClick Checked%pnidui%, pnidui.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x160 vsensorscpl gRadioClick Checked%sensorscpl%, sensorscpl.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x160 vsetupapi gRadioClick Checked%setupapi%, setupapi.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x160 vShell32 gRadioClick Checked%Shell32%, shell32.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x160 vsndvolsso gRadioClick Checked%sndvolsso%, sndvolsso.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x160 vstobject gRadioClick Checked%stobject%, stobject.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x160 vtwinui gRadioClick Checked%twinui%, twinui.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x160 vurl gRadioClick Checked%url%, url.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x160 vuser32 gRadioClick Checked%user32%, user32.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x160 vwebcheck gRadioClick Checked%webcheck%, webcheck.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x160 vwiashext gRadioClick Checked%wiashext%, wiashext.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x160 vwmploc gRadioClick Checked%wmploc%, wmploc.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x160 vwpdshext gRadioClick Checked%wpdshext%, wpdshext.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x160 vxwizards gRadioClick Checked%xwizards%, xwizards.dll
    yPos += yIncrement
    Gui, Add, Radio, y%yPos% x160 vzipfldr gRadioClick Checked%zipfldr%, zipfldr.dll
}


;;∙======∙MOUSE WHEEL HANDLER∙============∙
#IfWinActive ahk_class AutoHotkeyGUI
WheelDown::
    ControlClick, SysListView321, ,, WD, 1
    ControlClick, SysListView322, ,, WD, 1
Return

WheelUp::
    ControlClick, SysListView321, ,, WU, 1
    ControlClick, SysListView322, ,, WU, 1
Return
#IfWinActive


;;∙======∙TOOLTIP FUNCTION∙=================∙
GuiTip(hCtrl, text := "")
{
    hGui := text != "" ? DllCall("GetParent", "Ptr", hCtrl) : hCtrl
    static hTip
    if !hTip
    {
        hTip := DllCall("CreateWindowEx", "UInt", 0x8, "Str", "tooltips_class32"
            , "Ptr", 0, "UInt", 0x80000002
            , "Int", 0x80000000, "Int", 0x80000000, "Int", 0x80000000, "Int", 0x80000000
            , "Ptr", hGui, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Ptr")
        DllCall("SendMessage", "Ptr", hTip, "Int", 0x0418, "Ptr", 0, "Ptr", 0)
        if (A_OsVersion == "WIN_XP")
            GuiTip(hGui)
    }

    static sizeof_TOOLINFO := 24 + (6 * A_PtrSize)
    VarSetCapacity(TOOLINFO, sizeof_TOOLINFO, 0)
    NumPut(sizeof_TOOLINFO, TOOLINFO, 0, "UInt")
    NumPut(0x11, TOOLINFO, 4, "UInt")
    NumPut(hGui, TOOLINFO, 8, "Ptr")
    NumPut(hCtrl, TOOLINFO, 8 + A_PtrSize, "Ptr")
    NumPut(&text, TOOLINFO, 24 + (3 * A_PtrSize), "Ptr")

    static TTM_ADDTOOL := A_IsUnicode ? 0x0432 : 0x0404
    return DllCall("SendMessage", "Ptr", hTip, "Int", TTM_ADDTOOL, "Ptr", 0, "Ptr", &TOOLINFO)
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
    RELOAD:    ;;∙------∙Script Call.
        Soundbeep, 1200, 250
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
    EXIT:    ;;∙------∙Script Call.
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
DLL∙Icons∙Viewer:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

