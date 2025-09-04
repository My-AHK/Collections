
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  GeekDude
» Original Source:  https://github.com/G33kDude/TicTacToe.ahk
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
;;∙============================================================∙
#NoEnv
SetBatchLines, -1

#Include Gdip_All.ahk

;;∙------∙Start Gdi+
If !pToken := Gdip_Startup()
{
    MsgBox, 48, gdiplus error!, Gdiplus failed to start.`nPlease ensure you have Gdiplus on your system., 5
    ExitApp
}

^t::    ;;∙------∙🔥∙(Ctrl + T)
    Soundbeep, 1200, 200
    
    ;;∙------∙Create game object variables.
    global GameBoard1 := ["", "", ""]
    global GameBoard2 := ["", "", ""]
    global GameBoard3 := ["", "", ""]
    global GameWidth := 600
    global GameHeight := 600
    global GameHasWon := false
    global GamePlayer := false
    global GamehWnd, GamehPicture, GamepBitmap, GamepGraphics, GamehBitmap

    ;;∙------∙Create GUI.
    Gui, New, +hWndGamehWnd +Resize
    Gui, Color, 303030
    Gui, Margin, 0, 0

    ;;∙------∙Create bitmap.
    GamepBitmap := Gdip_CreateBitmap(GameWidth, GameHeight)
    GamepGraphics := Gdip_GraphicsFromImage(GamepBitmap)
    GamehBitmap := Gdip_CreateHBITMAPFromBitmap(GamepBitmap)

    ;;∙------∙Add picture control.
    Gui, Add, Picture, w%GameWidth% h%GameHeight% hWndGamehPicture, HBITMAP:%GamehBitmap%

    ;;∙------∙Set GUI events.
    Gui, +LabelTicTacToe_

    Gui, Show,, Tic Tac Toe
    Gosub, RedrawBoard
Return

RedrawBoard:
    ; Clear background
    pBrushBG := Gdip_BrushCreateSolid("0xFF212223")    ;;∙------∙Background Color (Gray).
    Gdip_FillRectangle(GamepGraphics, pBrushBG, 0, 0, GameWidth, GameHeight)
    Gdip_DeleteBrush(pBrushBG)

    ;;∙------∙Draw grid lines.
    pBrushFG := Gdip_BrushCreateSolid("0xFFFFFFFF")    ;;∙------∙Grid Line Color.

    ;;∙------∙Vertical lines.
    line1 := GameWidth/3 - 2
    line2 := GameWidth/3*2 - 2
    Gdip_FillRectangle(GamepGraphics, pBrushFG, line1, 0, 4, GameHeight)
    Gdip_FillRectangle(GamepGraphics, pBrushFG, line2, 0, 4, GameHeight)

    ;;∙------∙Horizontal lines.
    line3 := GameHeight/3 - 2
    line4 := GameHeight/3*2 - 2
    Gdip_FillRectangle(GamepGraphics, pBrushFG, 0, line3, GameWidth, 4)
    Gdip_FillRectangle(GamepGraphics, pBrushFG, 0, line4, GameWidth, 4)

    Gdip_DeleteBrush(pBrushFG)

    ;;∙------∙Enable smoothing for pieces.
    Gdip_SetSmoothingMode(GamepGraphics, 4)

    ;;∙------∙Draw X and O pieces.
    Loop, 3
    {
        y := A_Index
        Loop, 3
        {
            x := A_Index
            ;;∙------∙Get the player from the appropriate board row.
            if (y = 1)
                player := GameBoard1[x]
            else if (y = 2)
                player := GameBoard2[x]
            else if (y = 3)
                player := GameBoard3[x]

            if (player = "X")
            {
                ;;∙------∙Draw X.
                pPenX := Gdip_CreatePen("0xFF0000FF", 10)    ;;∙------∙'X' Blue Color.
                cellW := GameWidth/3
                cellH := GameHeight/3
                margin := 20

                x1 := (x-1)*cellW + margin
                y1 := (y-1)*cellH + margin
                x2 := x*cellW - margin
                y2 := y*cellH - margin

                Gdip_DrawLine(GamepGraphics, pPenX, x1, y1, x2, y2)
                Gdip_DrawLine(GamepGraphics, pPenX, x1, y2, x2, y1)
                Gdip_DeletePen(pPenX)
            }
            else if (player = "O")
            {
                ;;∙------∙Draw O.
                pPenO := Gdip_CreatePen("0xFFFF0000", 10)    ;;∙------∙'O' Red Color.
                cellW := GameWidth/3
                cellH := GameHeight/3
                margin := 20

                xPos := (x-1)*cellW + margin
                yPos := (y-1)*cellH + margin
                width := cellW - 2*margin
                height := cellH - 2*margin

                Gdip_DrawEllipse(GamepGraphics, pPenO, xPos, yPos, width, height)
                Gdip_DeletePen(pPenO)
            }
        }
    }

    ;;∙------∙Update display.
    DeleteObject(GamehBitmap)
    GamehBitmap := Gdip_CreateHBITMAPFromBitmap(GamepBitmap)
    GuiControl,, %GamehPicture%, HBITMAP:%GamehBitmap%
Return

CheckWin:
    global Winner := false

    ;;∙------∙Check rows.
    Loop, 3
    {
        row := A_Index
        if (row = 1)
            cell1 := GameBoard1[1], cell2 := GameBoard1[2], cell3 := GameBoard1[3]
        else if (row = 2)
            cell1 := GameBoard2[1], cell2 := GameBoard2[2], cell3 := GameBoard2[3]
        else if (row = 3)
            cell1 := GameBoard3[1], cell2 := GameBoard3[2], cell3 := GameBoard3[3]
        
        if (cell1 = cell2 && cell2 = cell3 && cell1 != "")
        {
            Winner := cell1
            return
        }
    }

    ;;∙------∙Check columns.
    Loop, 3
    {
        col := A_Index
        cell1 := GameBoard1[col], cell2 := GameBoard2[col], cell3 := GameBoard3[col]
        
        if (cell1 = cell2 && cell2 = cell3 && cell1 != "")
        {
            Winner := cell1
            return
        }
    }

    ;;∙------∙Check diagonals.
    if (GameBoard1[1] = GameBoard2[2] && GameBoard2[2] = GameBoard3[3] && GameBoard1[1] != "")
    {
        Winner := GameBoard1[1]
        return
    }

    if (GameBoard1[3] = GameBoard2[2] && GameBoard2[2] = GameBoard3[1] && GameBoard1[3] != "")
    {
        Winner := GameBoard1[3]
        return
    }

    ;;∙------∙Check for tie.
    emptyFound := false
    Loop, 3
    {
        row := A_Index
        Loop, 3
        {
            col := A_Index
            if (row = 1 && GameBoard1[col] = "")
                emptyFound := true
            else if (row = 2 && GameBoard2[col] = "")
                emptyFound := true
            else if (row = 3 && GameBoard3[col] = "")
                emptyFound := true
        }
    }

    if !emptyFound
        Winner := "Tie"
Return

;;∙------∙GUI event handlers.
TicTacToe_Size:
Return

TicTacToe_Close:
TicTacToe_Escape:
    Gdip_DeleteGraphics(GamepGraphics)
    Gdip_DisposeImage(GamepBitmap)
    DeleteObject(GamehBitmap)
    ExitApp
Return

;;∙------∙Handle mouse clicks.
~LButton::
    if (!GameHasWon)
    {
        ;;∙------∙Get mouse position relative to the active window.
        CoordMode, Mouse, Relative
        MouseGetPos, relX, relY, , control
        CoordMode, Mouse, Screen

        ;;∙------∙Check if we're clicking on the picture control (Static1 is the default name for Picture controls).
        if (control = "Static1")
        {
            x := Floor(relX / (GameWidth / 3)) + 1
            y := Floor(relY / (GameHeight / 3)) + 1

            if (x >= 1 && x <= 3 && y >= 1 && y <= 3)
            {
                ;;∙------∙Check if cell is empty.
                cellEmpty := false
                if (y = 1 && GameBoard1[x] = "")
                    cellEmpty := true
                else if (y = 2 && GameBoard2[x] = "")
                    cellEmpty := true
                else if (y = 3 && GameBoard3[x] = "")
                    cellEmpty := true

                if (cellEmpty)
                {
                    GamePlayer := !GamePlayer
                    playerSymbol := GamePlayer ? "X" : "O"

                    if (y = 1)
                        GameBoard1[x] := playerSymbol
                    else if (y = 2)
                        GameBoard2[x] := playerSymbol
                    else if (y = 3)
                        GameBoard3[x] := playerSymbol

                    Gosub, RedrawBoard

                    ;;∙------∙Check for win.
                    Gosub, CheckWin
                    if (Winner)
                    {
                        GameHasWon := true
                        if (Winner = "Tie")
                            MsgBox,,, You tied!, 3
                        else
                            MsgBox,,, % Winner " wins!", 3
                    }
                }
            }
        }
    }
Return
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

