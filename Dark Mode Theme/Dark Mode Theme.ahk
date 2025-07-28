
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




;;∙============================================================∙
;;∙========∙EXAMPLES∙=========================================∙
;;∙----------------------------------------------------------------∙
F1::    ;;∙------∙(🔥)∙to test dark message box.
    Result := DMsgBox("This is a dark-themed message box!`n`nPress a button to continue.", "Dark Theme Test", 4)
    DMsgBox("You clicked: " . Result, "Result", 0)
Return

;;∙----------------------------------------------------------------∙
F2::    ;;∙------∙(🔥)∙to test enhanced message box.
    Result := DarkMsgBoxEx("Do you like this enhanced dark theme?", "Enhanced Dark Theme", "Love it|It's OK|Not really", 450, 220)
    DMsgBox("You selected: " . Result, "Your Choice", 0)
Return

;;∙----------------------------------------------------------------∙
F3::    ;;∙------∙(🔥)∙to test input box.
    UserInput := DInputBox("Dark Input Test", "What's your name?", "Enter name here")
    if (UserInput != "") {
        DMsgBox("Hello " . UserInput . "!", "Greeting", 0)
    } else {
        DMsgBox("Input was cancelled or empty.", "Info", 0)
    }
Return

;;∙----------------------------------------------------------------∙
F4::    ;;∙------∙(🔥)∙to test toast notifications.4
    DToast("Dark Themed Toast Notification", "Success", 4000, "✔")
Return


;;∙========∙DARK THEME MSGBOX∙===============================∙
DarkMsgBox(Text := "", Title := "Message", Options := 0, Width := 300, Height := 150) {
    ;;∙------∙Declare global variables.
    global DarkMsgBoxResult
    
    ;;∙------∙Parse options (basic implementation).
    Buttons := "OK"
    
    ;;∙------∙Simple option parsing.
    if (Options & 1)
        Buttons := "OK|Cancel"
    else if (Options & 2)
        Buttons := "Abort|Retry|Ignore"
    else if (Options & 3)
        Buttons := "Yes|No|Cancel"
    else if (Options & 4)
        Buttons := "Yes|No"
    else if (Options & 5)
        Buttons := "Retry|Cancel"
    
    ;;∙------∙Create the GUI.
    Gui, Add, Text, x10 y10 w%Width% h100 cWhite BackgroundTrans, %Text%
    
    ;;∙------∙Add buttons.
    ButtonWidth := 70
    ButtonCount := StrSplit(Buttons, "|").MaxIndex()
    TotalButtonWidth := ButtonCount * ButtonWidth + (ButtonCount - 1) * 10
    StartX := (Width - TotalButtonWidth) / 2 + 10
    
    Loop, Parse, Buttons, |
    {
        ButtonX := StartX + (A_Index - 1) * (ButtonWidth + 10)
        ButtonY := Height - 40
        Gui, Add, Button, x%ButtonX% y%ButtonY% w%ButtonWidth% h25 gDarkMsgBoxButton, %A_LoopField%
    }
    
    ;;∙------∙Set GUI properties for dark theme.
    Gui, Color, 0x2D2D30, 0x2D2D30
    Gui, Font, cWhite
    
    ;;∙------∙Show the GUI.
    Gui, Show, w%Width% h%Height%, %Title%
    
    ;;∙------∙Wait for user input.
    WinWaitClose, %Title%
    
    return DarkMsgBoxResult
}

;;∙------∙Button handler for dark message box.
DarkMsgBoxButton:
    global DarkMsgBoxResult
    StringReplace, DarkMsgBoxResult, A_GuiControl, &,, All
    Gui, Destroy
Return


;;∙========∙DARK THEME MSGBOX ENHANCED∙=====================∙
DarkMsgBoxEx(Text := "", Title := "Message", Buttons := "OK", Width := 350, Height := 180, Icon := "") {
    ;;∙------∙Declare global variable.
    global DarkMsgBoxExResult
    
    ;;∙------∙Calculate dimensions.
    TextHeight := Height - 80
    ButtonY := Height - 50
    
    ;;∙------∙Create main GUI.
    Gui, New, +LastFound +AlwaysOnTop -MaximizeBox -MinimizeBox, %Title%
    Gui, Color, 0x1E1E1E
    
    ;;∙------∙Add icon if specified.
    IconX := 15
    TextX := 15
    TextW := Width - 30
    
    if (Icon) {
        Gui, Add, Picture, x15 y15 w32 h32, %Icon%
        TextX := 55
        TextW := Width - 70
    }
    
    ;;∙------∙Add text with word wrapping.
    Gui, Add, Text, x%TextX% y15 w%TextW% h%TextHeight% cWhite Center, %Text%
    
    ;;∙------∙Parse and add buttons.
    ButtonArray := StrSplit(Buttons, "|")
    ButtonCount := ButtonArray.MaxIndex()
    ButtonWidth := 80
    TotalWidth := (ButtonCount * ButtonWidth) + ((ButtonCount - 1) * 10)
    StartX := (Width - TotalWidth) / 2
    
    Loop, %ButtonCount% {
        ButtonX := StartX + ((A_Index - 1) * 90)
        ButtonText := ButtonArray[A_Index]
        Gui, Add, Button, x%ButtonX% y%ButtonY% w%ButtonWidth% h30 gDarkMsgBoxExButton, %ButtonText%
    }
    
    ;;∙------∙Apply dark theme styling to controls.
    WinSet, Style, +0x02000000, ahk_id %A_Gui%    ;;∙------∙WS_CLIPCHILDREN
    
    ;;∙------∙Show GUI.
    Gui, Show, w%Width% h%Height%
    
    ;;∙------∙Wait for result.
    WinWaitClose, %Title%
    
    return DarkMsgBoxExResult
}

DarkMsgBoxExButton:
    global DarkMsgBoxExResult
    DarkMsgBoxExResult := A_GuiControl
    Gui, Destroy
Return


;;∙========∙DARK THEME INPUTBOX∙==============================∙
DarkInputBox(Prompt := "Enter text:", Title := "Input", Default := "", Width := 300, Height := 120, Password := false) {
    ;;∙------∙Declare variables as global to fix scoping issue.
    global DarkInputResult, DarkInputCancelled
    
    ;;∙------∙Create the GUI.
    Gui, New, +AlwaysOnTop -MinimizeBox, %Title%
    Gui, Color, 0x2D2D30, 0x2D2D30
    Gui, Font, cWhite
    
    ;;∙------∙Add prompt text.
    Gui, Add, Text, x10 y10 w280 h30 cWhite BackgroundTrans, %Prompt%
    
    ;;∙------∙Add input field with white text.
    InputOptions := "x10 y40 w280 h20 cWhite"
    if (Password)
        InputOptions .= " Password"
    
    Gui, Add, Edit, %InputOptions% vDarkInputResult, %Default%
    
    ;;∙------∙Add buttons.
    Gui, Add, Button, x155 y70 w60 h25 gDarkInputOK Default, OK
    Gui, Add, Button, x225 y70 w60 h25 gDarkInputCancel, Cancel
    
    ;;∙------∙Set focus to the OK button.
    GuiControl, Focus, OK

    ;;∙------∙Set GUI properties for dark theme.
    Gui, Color, 0x2D2D30, 0x2D2D30
    Gui, Font, cWhite
    
    ;;∙------∙Show the GUI.
    Gui, Show, w%Width% h%Height%
    
    ;;∙------∙Wait for user input.
    WinWaitClose, %Title%
    
    if (DarkInputCancelled) {
        return ""
    } else {
        ;;∙------∙Destroy the input box immediately after submission.
        Gui, Destroy
        
        ;;∙------∙Show the result in a separate message box if needed.
        ;;∙------∙DMsgBox("You entered: " . DarkInputResult, "Input Result", 0)
        
        return DarkInputResult
    }
}

;;∙------∙Input box button handlers.
DarkInputOK:
    global DarkInputResult, DarkInputCancelled
    Gui, Submit
    DarkInputCancelled := false
Return

DarkInputCancel:
    global DarkInputResult, DarkInputCancelled
    Gui, Destroy
    DarkInputCancelled := true
    DarkInputResult := ""
Return


;;∙========∙DARK THEME TOAST NOTIFICATION∙====================∙
DToast(Message := "", Title := "", Duration := 3000, Icon := "") {
    static ToastQueue := []
    static IsProcessing := false
    
    ;;∙------∙Add to queue.
    ToastQueue.Push({Message: Message, Title: Title, Duration: Duration, Icon: Icon})
    
    if (!IsProcessing) {
        IsProcessing := true
        SetTimer, ProcessToastQueue, -100
    }
    return
    
    ProcessToastQueue:
        while (ToastQueue.Length() > 0) {
            current := ToastQueue.RemoveAt(1)
            ShowSingleToast(current.Message, current.Title, current.Duration, current.Icon)
            
            ;;∙------∙Wait for this toast to complete (using Sleep instead of KeyWait).
            Sleep, current.Duration + 500  ; Extra 500ms for fade-out
        }
        IsProcessing := false
    return
}

ShowSingleToast(Message, Title, Duration, Icon) {
    static ActiveToasts := []
    
    ;;∙------∙Create unique GUI name.
    GuiName := "Toast_" A_TickCount
    
    ;;∙------∙Calculate position with custom margins.
    ToastWidth := 300
    ToastHeight := 100
    RightMargin := 15    ;;∙------∙15 pixels from right edge.
    BottomMargin := 10    ;;∙------∙10 pixels above taskbar.
    
    ;;∙------∙Get taskbar height for more accurate positioning.
    SysGet, WorkArea, MonitorWorkArea
    TaskbarHeight := A_ScreenHeight - WorkAreaBottom
    
    ;;∙------∙Calculate position.
    PosX := A_ScreenWidth - ToastWidth - RightMargin
    PosY := A_ScreenHeight - ToastHeight - TaskbarHeight - BottomMargin
    
    ;;∙------∙Adjust for existing toasts (stack upward).
    for _, toast in ActiveToasts
        if WinExist(toast.GuiName)
            PosY -= (ToastHeight + 10)  ; 10px spacing between toasts
    
    ;;∙------∙Create GUI.
    Gui, %GuiName%:New, +AlwaysOnTop -Caption +ToolWindow +E0x20 -DPIScale
    Gui, Color, 0x252526
    Gui, Font, cWhite s10, Segoe UI
    
    ;;∙------∙Add icon if specified.
    if (Icon != "") {
        Gui, Font, s14
        Gui, Add, Text, x20 y20 w32 h32 Center, %Icon%
        Gui, Font, s10
        TextX := 60
        TextW := ToastWidth - 80
    } else {
        TextX := 20
        TextW := ToastWidth - 40
    }
    
    ;;∙------∙Add content.
    if (Title != "")
        Gui, Add, Text, x%TextX% y15 w%TextW% h20 +0x200, %Title%
    
    MessageY := (Title != "") ? 35 : 25
    Gui, Add, Text, x%TextX% y%MessageY% w%TextW% h40 +0x200, %Message%
    Gui, Add, Progress, x0 y0 w%ToastWidth% h3 c0078D7 -Smooth, 100
    
    ;;∙------∙Show with animation.
    Gui, Show, % "x" PosX " y" PosY " w" ToastWidth " h" ToastHeight " NA", %GuiName%
    WinSet, Transparent, 0, %GuiName%
    Loop, 10 {
        WinSet, Transparent, % (A_Index * 25), %GuiName%
        Sleep, 20
    }
    
    ;;∙------∙Store reference.
    toast := {GuiName: GuiName, Duration: Duration}
    ActiveToasts.Push(toast)
    
    ;;∙------∙Set destruction timer.
    fn := Func("DestroyToast").Bind(toast)
    SetTimer, % fn, % -Duration
    
    ;;∙------∙Make clickable.
    Gui, Add, Text, x0 y0 w%ToastWidth% h%ToastHeight% gToastClick +BackgroundTrans
    Return
    
    ToastClick:
        GuiName := A_Gui
        for index, toast in ActiveToasts {
            if (toast.GuiName = GuiName) {
                DestroyToast(toast)
                break
            }
        }
    return
}

DestroyToast(toast) {
    static ActiveToasts := []
    
    ;;∙------∙Fade out animation.
    if WinExist(toast.GuiName) {
        Loop, 10 {
            WinSet, Transparent, % (255 - (A_Index * 25)), % toast.GuiName
            Sleep, 20
        }
        Gui, % toast.GuiName ":Destroy"
    }
    
    ;;∙------∙Remove from array.
    for index, t in ActiveToasts {
        if (t.GuiName = toast.GuiName) {
            ActiveToasts.RemoveAt(index)
            break
        }
    }
}


;;∙========∙UTILITIES∙==========================================∙
;;∙------∙Function to replace standard MsgBox calls (optional).
DMsgBox(Text := "", Title := "Message", Options := 0) {
    return DarkMsgBox(Text, Title, Options)
}

;;∙------∙Function to replace standard InputBox calls (optional).
DInputBox(Title := "Input", Prompt := "Enter text:", Default := "", Password := false) {
    return DarkInputBox(Prompt, Title, Default, 300, 120, Password)
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
;;  DllCall("User32\SetProcessDPIAware")    ;;∙------∙Prevents2 white flash on GUI creation.
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

