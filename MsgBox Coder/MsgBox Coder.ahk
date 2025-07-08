
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  PhiLho
» Original Source:  https://www.autohotkey.com/board/topic/1545-auto-script-for-msgboxs/
» 
    ▹ 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "MsgBox_Coder"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
;;∙============================================================∙
#NoEnv
#Persistent
#SingleInstance, Force

textColor := "79A8D8"    ;;∙------∙Set text font color.
guiBackground := "000011"    ;;∙------∙Set Gui background color.
eBoxTcolor := "Black"    ;;∙------∙Edit box text color.
guiW := 333    ;;∙------∙Set Gui width.
guiH := 455    ;;∙------∙Set Gui height.
iCON := 20    ;;∙------∙Set icon dimension. 

;;∙------∙Gui Specs.
Gui,  -Caption +Border +Owner
Gui, Color, %guiBackground%
Gui, Font, s16 c%textColor% Bold q5

;;∙------∙Gui header.
Gui, Add, Text, x1 y11 w%guiW% Center BackgroundTrans, MsgBox Coder
Gui, Add, Text, x0 y10 c%guiBackground% w%guiW% Center BackgroundTrans, MsgBox Coder

;;∙------∙Add title input field.
Gui, Font, s8 c%textColor% Norm q5
Gui, Add, Text, x16 y30 w60 h20, Title
Gui, Add, Edit, vTitle c%eBoxTcolor% r1 x16 y45 w300 h25

;;∙------∙Add message input field.
Gui, Add, Text, x16 y75 w60 h15, Message
Gui, Add, Edit, vMessage c%eBoxTcolor% x16 y92 w300 h50,

;;∙------∙Button type selection group.
Gui, Add, GroupBox, x16 y157 w145 h145, Buttons
Gui, Add, Radio, vButtonOK Checked x26 y177 w120 h20 BackgroundTrans, OK
Gui, Add, Radio, vButtonOK_Cancel x26 y197 w120 h20 BackgroundTrans, OK/Cancel
Gui, Add, Radio, vButtonAbort_Retry_Ignore x26 y217 w120 h20 BackgroundTrans, Abort/Retry/Ignore
Gui, Add, Radio, vButtonYes_No_Cancel x26 y237 w120 h20 BackgroundTrans, Yes/No/Cancel
Gui, Add, Radio, vButtonYes_No x26 y257 w120 h20 BackgroundTrans, Yes/No
Gui, Add, Radio, vButtonRetry_Cancel x26 y277 w120 h20 BackgroundTrans, Retry/Cancel


;;∙------∙Default button selection group.
Gui, Add, GroupBox, x16 y317 w145 h45, Default Button
Gui, Add, Radio, vDefault1st Checked x26 y337 w40 h20 BackgroundTrans, 1st
Gui, Add, Radio, vDefault2nd x71 y337 w40 h20 BackgroundTrans, 2nd
Gui, Add, Radio, vDefault3rd x116 y337 w40 h20 BackgroundTrans, 3rd


;;∙------∙Add Timeout section.
Gui, Add, GroupBox, x16 y375 w145 h50, Timeout
Gui, Add, CheckBox, vEnableTimeout gToggleTimeout x26 y393 w70 h20, Timeout:
Gui, Add, Edit, vTimeoutValue c%eBoxTcolor% x96 y393 w50 h20 Disabled Number, 5



;;∙------∙Icon selection group.
Gui, Add, GroupBox, x180 y157 w138 h175, Icon
Gui, Add, Radio, vIconNone Checked x230 y180 w80 h20, None
Gui, Add, Radio, vIconHand x230 y210 w80 h20 BackgroundTrans, Error
Gui, Add, Radio, vIconQuestion x230 y240 w80 h20 BackgroundTrans, Question
Gui, Add, Radio, vIconExclamation x230 y270 w80 h20 BackgroundTrans, Exclamation
Gui, Add, Radio, vIconAsterisk x230 y300 w70 h20 BackgroundTrans, Asterisk

;;∙------∙Add icon previews based on OS version.
If (A_OSType = "WIN32_WINDOWS") {
    ;;∙------∙Windows 9x/ME icon paths.
    Gui, Add, Picture, Icon6 x195 y180 w%iCON% h%iCON%, user.exe    ;;∙------∙None.
    Gui, Add, Picture, Icon4 x195 y210 w%iCON% h%iCON%, user.exe    ;;∙------∙Error.
    Gui, Add, Picture, Icon3 x195 y240 w%iCON% h%iCON%, user.exe    ;;∙------∙Question.
    Gui, Add, Picture, Icon2 x195 y270 w%iCON% h%iCON%, user.exe    ;;∙------∙Exclamation.
    Gui, Add, Picture, Icon5 x195 y300 w%iCON% h%iCON%, user.exe    ;;∙------∙Asterisk.
} Else {
    ;;∙------∙Windows NT+ icon paths.
    Gui, Add, Picture, Icon4 x195 y210 w%iCON% h%iCON%, user32.dll    ;;∙------∙Error.
    Gui, Add, Picture, Icon3 x195 y240 w%iCON% h%iCON%, user32.dll    ;;∙------∙Question.
    Gui, Add, Picture, Icon2 x195 y270 w%iCON% h%iCON%, user32.dll    ;;∙------∙Exclamation.
    Gui, Add, Picture, Icon5 x195 y300 w%iCON% h%iCON%, user32.dll    ;;∙------∙Asterisk.
}

;;∙------∙Modality selection group.
Gui, Add, GroupBox, x180 y340 w138 h85, Modal
Gui, Add, Radio, vModalTask x196 y357 w120 h20 BackgroundTrans, Task
Gui, Add, Radio, vModalSystem x196 y377 w120 h20 BackgroundTrans, System
Gui, Add, Radio, vModalAlwaysOnTop Checked x196 y397 w120 h20 BackgroundTrans, Always On Top

;;∙------∙Action buttons (adjusted positions).
Gui, Add, Button, x142 y440 w50 h33 BackgroundTrans HwndhText gINFO, &Help
    GuiTip(hText, "`nOpens the AutoHotKey v1`n MsgBox document page.`n ")

Gui, Add, Button, x20 y440 w115 h33 BackgroundTrans HwndhText gTestAndCopy, Clipboard && &Test
    GuiTip(hText, "`nSends code line to the clipboard`nand displays an example MsgBox`n ")
Gui, Add, Button, x200 y440 w115 h33 BackgroundTrans HwndhText gGuiClose, Close && &Exit
    GuiTip(hText, "`nCloses the Gui.`nExits the Script.`n ")

Gui, Show, x1550 y400 h495 w333, MsgBox Coder
GuiControl, Focus, Title    ;;∙------∙Place cursor focus.
Return

;;∙------∙Toggle timeout edit field state.
ToggleTimeout:
    GuiControlGet, EnableTimeout
    GuiControl, Enable%EnableTimeout%, TimeoutValue
Return

TestAndCopy:
    Soundbeep, 1200, 200
    Gui, Submit, NoHide    ;;∙------∙Collect form values without hiding GUI.
    
    ;;∙------∙Escape quotes and newlines in title/message.
    Title := EscapeForMsgBox(Title)
    Message := EscapeForMsgBox(Message)
    
    buttonMap := { ButtonOK: 0    ;;∙------∙Define button values.
                , ButtonOK_Cancel: 1
                , ButtonAbort_Retry_Ignore: 2
                , ButtonYes_No_Cancel: 3
                , ButtonYes_No: 4
                , ButtonRetry_Cancel: 5 }
    iconMap := { IconNone: 0    ;;∙------∙Define icon values.
               , IconHand: 16
               , IconQuestion: 32
               , IconExclamation: 48
               , IconAsterisk: 64 }
    defaultMap := { Default1st: 0    ;;∙------∙Define default button values.
                , Default2nd: 256
                , Default3rd: 512 }
    modalMap := { ModalTask: 0    ;;∙------∙Task modal.
                , ModalSystem: 4096    ;;∙------∙System modal.
                , ModalAlwaysOnTop: 262144 }    ;;∙------∙Always on top.
    
    ;;∙------∙Calculate options.
    options := 0
    for control, value in buttonMap
        if (%control%)
            options |= value
    for control, value in iconMap
        if (%control%)
            options |= value
    for control, value in defaultMap
        if (%control%)
            options |= value
    for control, value in modalMap
        if (%control%)
            options |= value

    ;;∙------∙Timeout handling.
    if (EnableTimeout) {
        if TimeoutValue is not number
        {
            MsgBox, 16, Invalid Timeout, Timeout must be a number.
            return
        }
        ;;∙------∙Generate output with timeout as separate parameter.
        output := "MsgBox, " options ", " Title ", " Message ", " TimeoutValue
        Clipboard := output
        
        ;;∙------∙Test with timeout as separate parameter.
        MsgBox, % options, % Title, % Message, % TimeoutValue
    } else {
        ;;∙------∙Generate output without timeout.
        output := "MsgBox, " options ", " Title ", " Message
        Clipboard := output
        
        ;;∙------∙Test without timeout.
        MsgBox, % options, % Title, % Message
    }
Return

;;∙------∙Escape special characters for MsgBox.
EscapeForMsgBox(str) {
    ;;∙------∙Handle multi-line messages.
    if (InStr(str, "`n")) {
        if (StrLen(str) > 78) {
            str := "`n(`n" str "`n)"    ;;∙------∙Wrap long messages.
        } else {
            str := StrReplace(str, "`n", "``n")    ;;∙------∙Escape newlines.
        }
    }
    ;;∙------∙Escape quotes
    str := StrReplace(str, """", """""")
    return str
}

INFO:    ;;∙------∙AHK MsgBox help documents.
    Run, https://www.autohotkey.com/docs/v1/lib/MsgBox.htm
Return

GuiClose:
GuiEscape:
    Soundbeep, 800, 250
    ExitApp
Return

;;∙======∙GuiTip Function∙========================================∙
GuiTip(hCtrl, text:="")
{
    ttMaxWidth := 200    ;;∙------∙Sets maximum tooltip width in pixels.
    hGui := text!="" ? DllCall("GetParent", "Ptr", hCtrl) : hCtrl
    static hTip
    if !hTip
    {
        hTip := DllCall("CreateWindowEx", "UInt", 0x8, "Str", "tooltips_class32"
             ,  "Ptr", 0, "UInt", 0x80000002
             ,  "Int", 0x80000000, "Int",  0x80000000, "Int", 0x80000000, "Int", 0x80000000
             ,  "Ptr", hGui, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Ptr")
        DllCall("SendMessage", "Ptr", hTip, "Int", 0x0418, "Ptr", 0, "Ptr", ttMaxWidth)
        if (A_OsVersion == "WIN_XP")
            GuiTip(hGui)
    }
    static sizeof_TOOLINFO := 24 + (6 * A_PtrSize)
    VarSetCapacity(TOOLINFO, sizeof_TOOLINFO, 0)
    , NumPut(sizeof_TOOLINFO, TOOLINFO, 0, "UInt")
    , NumPut(0x11, TOOLINFO, 4, "UInt")
    , NumPut(hGui, TOOLINFO, 8, "Ptr")
    , NumPut(hCtrl, TOOLINFO, 8 + A_PtrSize, "Ptr")
    , NumPut(&text, TOOLINFO, 24 + (3 * A_PtrSize), "Ptr")
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
MsgBox_Coder:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

