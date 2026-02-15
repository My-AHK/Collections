

;;∙============================================================∙
/*
• Set custom background colors.
• Multiple icons (0, 1, or 2).
• Independent font sizes for each text line.
• Individual text line colors.
• Header text shadow option.
• Any combination of Bold/Italic/Norm styles.
• Optional Gui timeout.
• Positional MsgBoxes with customizable coordinates.

∙------∙PARAMETERS∙-----------------------------------∙
guiNotify(guiColor, icon1, icon2, text1, text1Font, text1Color, text2, text2Font, text2Color, button1, button2, button3, timeout := 0, shadowOffset := 2)
∙------------------------------------------------------------∙
guiColor      - Background color of the GUI window (hex code without # or color name like "Yellow", "Red", etc.)
                Examples: "6F6F6F", "Purple", "B2B2B2"
∙------------------------------------------------------------∙
icon1         - First icon to display (format: "file,index" where file is DLL/EXE path and index is icon number)
                Examples: "shell32.dll,41", "shell32.dll,167"
                Use "" for no icon
∙------------------------------------------------------------∙
icon2         - Second icon to display (same format as icon1, positioned after icon1)
                Examples: "shell32.dll,278", "shell32.dll,245"
                Use "" for no second icon
∙------------------------------------------------------------∙
text1         - Main heading/title text displayed at the top
                Examples: "Warning!", "Success!", "URGENT!"
∙------------------------------------------------------------∙
text1Font     - Font settings for text1 (size and style)
                Format: "s[size] [Bold] [Italic]"
                Examples: "s20 Bold", "s18 Italic", "s32 Bold Italic"
                Use "" for default (s26 Norm)
∙------------------------------------------------------------∙
text1Color    - Color of text1 (hex code without # or color name)
                Examples: "Red", "Blue", "DE6F00", "Green"
∙------------------------------------------------------------∙
text2         - Secondary message text displayed below text1
                Examples: "Proceed with caution", "Files processed successfully"
∙------------------------------------------------------------∙
text2Font     - Font settings for text2 (same format as text1Font)
                Examples: "s12 Italic", "s11 Norm", "s10 Italic"
                Use "" for default (s10 Norm)
∙------------------------------------------------------------∙
text2Color    - Color of text2 (hex code without # or color name)
                Examples: "Yellow", "Cyan", "6FDEDE", "LightGray"
∙------------------------------------------------------------∙
button1       - Text label for the left button
                Examples: "Cancel", "Dismiss", "Ignore"
∙------------------------------------------------------------∙
button2       - Text label for the center button
                Examples: "Ignore", "Read More", "Later"
∙------------------------------------------------------------∙
button3       - Text label for the right button
                Examples: "Continue", "OK", "Act Now"
∙------------------------------------------------------------∙
timeout       - Auto-close timer in milliseconds (optional, default: 0)
                0 = No timeout (stays open until user interaction)
                Examples: 3000 (3 seconds), 5000 (5 seconds), 7000 (7 seconds)
∙------------------------------------------------------------∙
shadowOffset  - Text shadow offset in pixels for text1 (optional, default: 2)
                0 = No shadow
                Higher values = larger shadow offset
                Examples: 2 (subtle), 4 (medium), 6 (prominent)
∙------------------------------------------------------------∙
*/

;;∙========∙DIRECTIVES/AUTO-EXECUTE∙===============∙
#Requires AutoHotkey 1
#NoEnv
#SingleInstance, Force
SetBatchLines -1
SetWinDelay 0

ScriptID := "guiNotify"
GoSub, TrayMenu
Menu, Tray, Icon, bootux.dll, 29    ;;∙------∙Sets the system tray icon.
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.
SetTimer, UpdateCheck, 500    ;;∙------∙Reload upon script saves.

;;∙========∙GLOBAL VARIABLES∙======================∙
global gMsgBoxX := 200    ;;∙------∙Default X coordinate.
global gMsgBoxY := 100    ;;∙------∙Default Y coordinate.
global gBtn1Text, gBtn2Text, gBtn3Text
global gNotifyTimeout
global gNotifyHwnd


;;∙========∙EXAMPLE USAGES∙========================∙
^F1::    ;;∙------∙🔥∙Gray Gui, Icon, text1 = 20-pt Font/Bold/Red, text2 = 12-pt Font/Italic/Yellow, 3-Example Buttons, A 5-Second Timeout, & 4-pxl Offset Text Shadow.

    SetMsgBoxPosition(250, 120)    ;;<∙------∙Set position for this specific MsgBox.
    guiNotify("6F6F6F", "shell32.dll,41", "", "Warning!", "s20 Bold", "Red", "Proceed with caution", "s12 Italic", "Yellow", "Cancel", "Ignore", "Continue", 5000, 4)
Return

;;∙------------------------------------------------∙
^F2::    ;;∙------∙🔥∙Purple Gui, Icon, text1 = 18-pt Font/Italic/Blue, text2 = 11-pt Font/Norm/Cyan, 3-Example Buttons, No timeout, & No Text Shadow.

    SetMsgBoxPosition(500, 100)    ;;<∙------∙Set position for this specific MsgBox.
    guiNotify("6F00DE", "", "shell32.dll,278", "Note:", "s18 Italic", "Blue", "This is an important message", "s11 Norm", "6FDEDE", "Dismiss", "Read More", "OK", 0, 0)
Return

;;∙------------------------------------------------∙
^F3::    ;;∙------∙🔥∙Yellow Gui, Icon, text1 = 32-pt Font/Bold/Green, text2 = 10-pt Font/Italic/LightGray, 3-Example Buttons, A 3-Second Timeout, & 6-pxl Offset Text Shadow.

    SetMsgBoxPosition(100, 400)    ;;<∙------∙Set position for this specific MsgBox.
    guiNotify("Yellow", "shell32.dll,167", "", "Success!", "s32 Bold", "Green", "Files processed successfully", "s10 Italic", "LightGray", "Open", "Log", "Close", 3000, 6)
Return

;;∙------------------------------------------------∙
^F4::    ;;∙------∙🔥∙Lavender Gui, Icon, text1 = 22-pt Font/Bold Italic/Orange, text2 = 12-pt Font/Bold/Yellow, 3-Example Buttons, A 7-Second Timeout, & default (2-pxl) Offset Text Shadow.

    SetMsgBoxPosition(950, 450)    ;;<∙------∙Set position for this specific MsgBox.
    guiNotify("6F6FDE", "shell32.dll,155", "", "URGENT!", "s22 Bold Italic", "DE6F00", "Immediate action required", "s12 Bold", "Yellow", "Ignore", "Later", "Act Now", 7000)
Return

;;∙------------------------------------------------∙
^F5::    ;;∙------∙🔥∙Gray Gui, Icon, text1 = 18-pt Font/Bold/Blue, text2 = 11-pt Font/Norm/Red, 3-Example Buttons, No timeout, & No Text Shadow.

    SetMsgBoxPosition(100, 100)    ;;<∙------∙Set position for this specific MsgBox.
    guiNotify("B2B2B2", "shell32.dll,211", "shell32.dll,245", "text1 Example", "s18 Bold", "Blue", "text2 Example", "s11 Norm", "Red", "button1", "button2", "button3", 0, 4)
Return

;;∙================================================∙
;;∙========∙MAIN FUNCTION∙========================∙
guiNotify(guiColor, icon1, icon2, text1, text1Font, text1Color, text2, text2Font, text2Color, button1, button2, button3, timeout := 0, shadowOffset := 2)
{
    ;;∙------∙Split the icon strings ("file,index") into parts.
    if (icon1 != "") {
        StringSplit, parts1, icon1, `,
        icon1File := parts11
        icon1Index := parts12
    }

    if (icon2 != "") {
        StringSplit, parts2, icon2, `,
        icon2File := parts21
        icon2Index := parts22
    }

    ;;∙------∙Button Handler Variables.
    global gBtn1Text := button1 , gBtn2Text := button2 , gBtn3Text := button3
    global gNotifyTimeout := timeout
    global gNotifyHwnd

    ;;∙------∙Destroy any existing notification.
    if (gNotifyHwnd) {
        Gui, %gNotifyHwnd%:Destroy
        SetTimer, NotifyAutoClose, Off
    }

    Gui, New, +AlwaysOnTop -Caption +Border +ToolWindow +HwndNotifyHwnd
    Gui, Color, %guiColor%
    Gui, Font, s10 cWhite q5, Arial

    ;;∙------∙Add icons if specified.
    iconX := 10
    if (icon1 != "") {
        Gui, Add, Picture, x%iconX% y10 w21 h21 Icon%icon1Index%, %icon1File%
        iconX += 31 ; Move position for next icon or text
    }

    if (icon2 != "") {
        Gui, Add, Picture, x%iconX% y10 w21 h21 Icon%icon2Index%, %icon2File%
    }

    ;;∙------∙Parse & apply text1 font settings.
    text1Size := "s26"
    text1Style := "Norm"
    
    if (text1Font != "") {
        ;∙------∙Extract size from font string.
        if InStr(text1Font, "s") {
            RegExMatch(text1Font, "s(\d+)", sizeMatch)
            text1Size := sizeMatch ? "s" . sizeMatch1 : "s26"
        }
        ;∙------∙Extract styles.
        text1Style := ""
        if InStr(text1Font, "Bold") {
            text1Style .= " Bold"
        }
        if InStr(text1Font, "Italic") {
            text1Style .= " Italic"
        }
        if (text1Style = "") {
            text1Style := " Norm"
        }
        text1Style := Trim(text1Style)
    }

    Gui, Font, Norm    ;;∙------∙Reset Font Before Applying Styles.
    Gui, Font, %text1Size% %text1Style% c%text1Color% q5, Arial

    ;;∙------∙Add main text (text1) with shadow effect if shadowOffset > 0.
    if (shadowOffset > 0) {
        Gui, Add, Text, x10 y10 w380 cBlack Center BackgroundTrans, %text1%
        Gui, Add, Text, xp-%shadowOffset% yp-%shadowOffset% w380 Center BackgroundTrans, %text1%
    } else {
        Gui, Add, Text, x10 y10 w380 c%text1Color% Center BackgroundTrans, %text1%
    }

    ;;∙------∙Parse and apply text2 font settings.
    text2Size := "s10"
    text2Style := "Norm"

    if (text2Font != "") {
        ;;∙------∙Extract size from font string.
        if InStr(text2Font, "s") {
            RegExMatch(text2Font, "s(\d+)", sizeMatch)
            text2Size := sizeMatch ? "s" . sizeMatch1 : "s10"
        }
        ;;∙------∙Extract styles.
        text2Style := ""
        if InStr(text2Font, "Bold") {
            text2Style .= " Bold"
        }
        if InStr(text2Font, "Italic") {
            text2Style .= " Italic"
        }
        if (text2Style = "") {
            text2Style := " Norm"
        }
        text2Style := Trim(text2Style)
    }

    Gui, Font, Norm    ;;∙------∙Reset Font.
    Gui, Font, %text2Size% %text2Style% c%text2Color% q5, Arial

    ;;∙------∙Add second line of text.
    Gui, Add, Text, x10 y+5 w380 c%text2Color% Center BackgroundTrans, %text2%

    Gui, Font, Norm    ;;∙------∙Reset Font.
    Gui, Font, s10 Norm cWhite q5, Arial

    ;;∙------∙Buttons (1st Left, 2nd Centered, 3rd Right).
    Gui, Add, Button, x15 y+20 w100 gBtn1, %button1%
    Gui, Add, Button, x150 yp w100 gBtn2, %button2%
    Gui, Add, Button, xp+135 yp w100 gBtn3, %button3%

    ;;∙------∙Calculate GUI height.
    Gui, +LastFound
    GuiControlGet, btn, Pos, %button3%
    totalHeight := btnY + btnH + 15

    Gui, Show, y300 w400 h%totalHeight%

    ;;∙------∙Store the GUI HWND for the timer
    global gNotifyHwnd := NotifyHwnd

    ;;∙------∙Set up timeout if specified.
    if (timeout > 0) {
        SetTimer, NotifyAutoClose, %timeout%
    }
    Return
}

;;∙========∙GLOBAL TIMER & BUTTON HANDLERS∙=======∙
NotifyAutoClose:
    SetTimer, NotifyAutoClose, Off
    Gui, %gNotifyHwnd%:Destroy
    gNotifyHwnd := "" ; Clear the global reference
Return

Btn1:
    SetTimer, NotifyAutoClose, Off
    MsgBox,,•x%gMsgBoxX% y%gMsgBoxY%, You pressed "%gBtn1Text%", 3
    Gui, %gNotifyHwnd%:Destroy
    gNotifyHwnd := ""    ;;∙------∙Clear global reference.
Return

Btn2:
    SetTimer, NotifyAutoClose, Off
    MsgBox,,•x%gMsgBoxX% y%gMsgBoxY%, You pressed "%gBtn2Text%", 3
    Gui, %gNotifyHwnd%:Destroy
    gNotifyHwnd := ""    ;;∙------∙Clear global reference.
Return

Btn3:
    SetTimer, NotifyAutoClose, Off
    MsgBox,,•x%gMsgBoxX% y%gMsgBoxY%, You pressed "%gBtn3Text%", 3
    Gui, %gNotifyHwnd%:Destroy
    gNotifyHwnd := ""    ;;∙------∙Clear global reference.
Return

;;∙========∙GUI EVENT HANDLERS∙====================∙
;;∙------∙Window Drag Functionality (PT. 2)∙
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}

;;∙------∙Escape/Close Handlers∙
GuiEscape:
GuiClose:
    ;;∙------∙Handle escape/close for any GUI.
    SetTimer, NotifyAutoClose, Off
    Gui, Destroy
    gNotifyHwnd := ""    ;;∙------∙Clear global reference.
Return

;;∙========∙MSGBOX POSITIONING∙===================∙
SetMsgBoxPosition(x, y) {
    global gMsgBoxX := x
    global gMsgBoxY := y
}
Return

;;∙========∙MSGBOX POSITIONING FUNCTION∙=========∙
;;∙------∙SOURCE :  https://www.autohotkey.com/boards/viewtopic.php?t=37355#p172028
;;∙------∙By :  teadrinker
CBTProc(nCode, wp, lp)  {
   static HCBT_CREATEWND := 3, WH_CBT := 5
        , hHook := DllCall("SetWindowsHookEx", Int, WH_CBT
                                            , Ptr, RegisterCallback("CBTProc", "Fast")
                                            , Ptr, 0
                                            , UInt, DllCall("GetCurrentThreadId") , Ptr)
   if (nCode = HCBT_CREATEWND)  {
      VarSetCapacity(WinClass, 256)
      DllCall("GetClassName", Ptr, hwnd := wp, Str, WinClass, Int, 256)
      if (WinClass != "#32770")
         Return

      pCREATESTRUCT := NumGet(lp+0)
      sTitle := StrGet( pTitle := NumGet(pCREATESTRUCT + A_PtrSize * 5 + 4 * 4), "UTF-16" )
      RegExMatch(sTitle, "^(.*)\•(?:x(\d+)\s?)?(?:y(\d+))?$", match)
      ( !(match2 = "" && match3 = "") && StrPut(match1, pTitle, "UTF-16") )
      ( match2 != "" && NumPut(match2, pCREATESTRUCT + A_PtrSize * 4 + 4 * 3, "Int") )
      ( match3 != "" && NumPut(match3, pCREATESTRUCT + A_PtrSize * 4 + 4 * 2, "Int") )
   }
}
Return

;;∙========∙SCRIPT UPDATER∙========================∙
UpdateCheck:    ;;∙------Check if the script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload

;;∙========∙EDIT \ RELOAD / EXIT∙=====================∙
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

;;∙========∙TRAY MENU∙=============================∙
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

;;∙========∙MENU CALLS∙============================∙
guiNotify:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
    Suspend
    Soundbeep, 700, 100
    Pause
Return

;;∙========∙TRAY MENU POSITION∙====================∙
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
∙========∙SCRIPT END∙==============================∙

