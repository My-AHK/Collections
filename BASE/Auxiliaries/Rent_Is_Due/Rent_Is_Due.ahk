

;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙
;;∙======∙AUTO-EXECUTE∙========∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force
SendMode, Input
SetBatchLines -1
SetWinDelay 0
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")
SetTimer, UpdateCheck, 750
ScriptID := "Rent_Is_Due"
#NoTrayIcon


;;∙======∙CHECK_DAY∙===========∙
;;∙------∙Check immediately on startup.
GoSub, Check_Day_Of_Month

;;∙------∙Then check once per hour.
SetTimer, Check_Day_Of_Month, 3600000
Return

Check_Day_Of_Month:
    ;;∙------∙Check if today is the desired date AND we haven't run it today yet.
    if (A_DD = "01" && A_LastMonthlyCheck != A_YYYY A_MM)
    {
        A_LastMonthlyCheck := A_YYYY A_MM    ;;∙------∙Store that it ran this month.

        SoundBeep, 1200, 350

        ;;∙------∙Open in Microsoft Edge browser.
        Edge_Path := "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
        Run, "%Edge_Path%" "https://conestogapark.residentportal.com/auth"


;;∙======∙GUI_NOTICE∙==========∙
Gui, +AlwaysOnTop -Caption +hwndHGUI +Owner
        +LastFound +E0x02000000 +E0x00080000
Gui, Color, Black
Gui, Font, s24 cYellow Bold, ARIAL
Gui, Margin, 15, 10
Gui, Add, Text, vMainText +0x0200 w320 h50 +Border Center BackgroundTrans, Time To Pay Rent!!

GuiControlGet, Pos, Pos, MainText
Xpos := PosX + PosW - 20    ;;∙------∙Right edge inside border.
Ypos := PosY + PosH + 5    ;;∙------∙Just below the textbox, small gap.

Gui, Font, s14 cRed Bold
Gui, Add, Text, x%Xpos% y%Ypos% w20 h20 gCloseGUI, X

Gui, Show, Hide
WinGetPos, X, Y, W, H
R := Min(W, H) // 5
WinSet, Region, 0-0 W%W% H%H% R%R%-%R%
Gui, Show, x1150 y250
    }
Return

CloseGUI:
    Gui, Destroy
Return

WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}


;;∙======∙SCRIPT UPDATE∙========∙
UpdateCheck:    ;;∙------Check if script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙


