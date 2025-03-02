
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙--------∙Origins∙-------------------------∙
» Author:  euras
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?f=6&t=58125&p=245204&hilit=Dual+Slider#p245204
» 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "SNAKE"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
#NoEnv    ;;∙------∙Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, Force
SendMode Input    ;;∙------∙Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%    ;;∙------∙Ensures a consistent starting directory.
Process, Priority, , R    ;;∙------∙high CPU cooperation. (maxed at 50 on dual affinity, use H otherwise)
SetBatchLines, -1    ;;∙------∙for delay precision..
SetControlDelay, -1

DllCall("SystemParametersInfo", UInt, 0xB, UInt, 31, UIntP, 0, UInt, 0)    ;;∙------∙0xB is SPI_SETKEYBOARDSPEED. 31 is the max speed, 0 is the min.
if !FileExist("C:\Users\" A_UserName "\Documents\SnakeStats.ini") {
    FileAppend,, C:\Users\%A_UserName%\Documents\SnakeStats.ini
    IniWrite, 1, C:\Users\%A_UserName%\Documents\SnakeStats.ini, section1, difficulty
    IniWrite, 1, C:\Users\%A_UserName%\Documents\SnakeStats.ini, section2, borders
    IniWrite, 1, C:\Users\%A_UserName%\Documents\SnakeStats.ini, section3, sounds
    IniWrite, 0, C:\Users\%A_UserName%\Documents\SnakeStats.ini, section4, record
}
IniRead, dif, C:\Users\%A_UserName%\Documents\SnakeStats.ini, section1, difficulty
IniRead, bor, C:\Users\%A_UserName%\Documents\SnakeStats.ini, section2, borders
IniRead, sou, C:\Users\%A_UserName%\Documents\SnakeStats.ini, section3, sounds
IniRead, Record, C:\Users\%A_UserName%\Documents\SnakeStats.ini, section4, record
Loop, 961 {
    SF%A_Index% =
    FF%A_Index% =
}
Gui, Destroy
Gui, New
Gui, +AlwaysOnTop 
Gui, Color, Black
Gui, Font, c61b564 s36 Bold, Verdana
Gui, Add, Text, x0 y0 BackgroundTrans 0x00800000 w310 ReadOnly Center, SNAKE
;;∙------------------------------------∙
Gui, Font, s12 cSilver, Verdana
Gui, Add, Text, x10 y+20 BackgroundTrans +0x0200 0x00800000 w115 h25 ReadOnly, DIFFICULTY
Gui, Add, Slider, x+20 w150 vSlider1 range1-3 NoTicks AltSubmit -Theme, %dif%
Gui, Font, s8 Verdana
;;∙------∙Gui, Add, Text, x145 y+2 cAqua w170 ReadOnly, Easy       Normal       Hard    ;;∙------∙ORIG.
Gui, Add, Text, x145 y+2 cFFA500 BackgroundTrans w170 ReadOnly, Easy
Gui, Add, Text, x200 yP cEA5000 BackgroundTrans w170 ReadOnly, Normal
Gui, Add, Text, x265 yP cEA0000 BackgroundTrans w170 ReadOnly, Hard
;;∙------------------------------------∙
Gui, Font, s12 cSilver, Verdana
Gui, Add, Text, x10 y+30 BackgroundTrans +0x0200 0x00800000 w115 h25 ReadOnly, %A_Space% BORDERS
Gui, Add, Slider, x+20 w150 vSlider2 range1-2 NoTicks AltSubmit -Theme, %bor%
Gui, Font, s8 Verdana
;;∙------∙Gui, Add, Text, x145 y+2 BackgroundTrans w170 ReadOnly, On                          Off    ;;∙------∙ORIG.
Gui, Add, Text, x150 y+2 cGreen BackgroundTrans w170 ReadOnly, On
Gui, Add, Text, x270 yp cBlue BackgroundTrans w170 ReadOnly, Off
;;∙------------------------------------∙
Gui, Font, s12 cSilver, Verdana
Gui, Add, Text, x10 y+30 BackgroundTrans +0x0200 0x00800000 w115 h25 ReadOnly, %A_Space%   SOUNDS
Gui, Add, Slider, x+20 w150 vSlider3 range1-2 NoTicks AltSubmit -Theme, %sou%
Gui, Font, s8 Verdana
;;∙------∙Gui, Add, Text, x145 y+2 BackgroundTrans w170 ReadOnly, On                          Off    ;;∙------∙ORIG.

Gui, Add, Text, x150 y+2 cGreen BackgroundTrans w170 ReadOnly, On
Gui, Add, Text, x270 yp cBlue BackgroundTrans w170 ReadOnly, Off

;;∙------------------------------------∙
Gui, Font, s14 Bold, Verdana
Gui, Add, Button, x0 y+30 w311 h34 -Theme -Border gStart, START GAME
Gui, Show, x2100 w310 h325, %ScriptID%
Return

;;∙------------------------------------∙
Start:
    Gui, submit
    IniWrite, %Slider1%, C:\Users\%A_UserName%\Documents\SnakeStats.ini, section1, difficulty
    IniWrite, %Slider2%, C:\Users\%A_UserName%\Documents\SnakeStats.ini, section2, borders
    IniWrite, %Slider3%, C:\Users\%A_UserName%\Documents\SnakeStats.ini, section3, sounds
    if (Slider2 = 1)
        extra := 5
    if (Slider2 = 2)
        extra := 0
    if (Slider1 = 1)
        speeds := 100, point := 10 + extra
    if (Slider1 = 2)
        speeds := 75, point := 15 + extra
    if (Slider1 = 3)
        speeds := 50, point := 20 + extra
    gosub, game_launch
    return

game_launch:
    Gui, Destroy
    Gui, new
    Gui, Color, Black
    rr := new Main_Field()
    ee := new The_Snake()
    ee.Game_Mapping()
    ee.Game_Start(Record)
    ee.Food_C()
    Gui, Font, cYellow s9 Verdana    ;;∙------∙Game Info bar (bottom).
    Gui, Add, Text, x0 y310 w100 h15 ReadOnly +Border Center vleng, Snake length: 5
    Gui, Add, Text, x+0 w105 h15 ReadOnly +Border Center vpoints, Points: 0
    Gui, Add, Text, x+0 w105 h15 ReadOnly +Border Center vrecord, Record: %Record%
    Gui, Font, cBlack s8 Verdana
    Gui, Show, x2100 w310 h325, The Snake
    ee.Snake_Move(speeds, Slider2, point, Slider3)
    return


class Main_Field {    ;;∙------∙gameboard.
    __New() {
        this.Field_Elements := Object()
        temp_Y := 0, temp_C := 0, SF_temp := 0
        loop, 31
            loop, 31 {
                SF_temp++
                this.Field_Elements[A_Index + temp_C] := Object()
                temp_X := (A_Index - 1) * 10
                this.Field_Elements[A_Index + temp_C][1] := temp_X
                this.Field_Elements[A_Index + temp_C][2] := temp_Y
                tt := A_Index + temp_C
                if (A_Index = 31) {
                    temp_C := tt, temp_Y += 10
                    continue, 1
                }
            }
    }
}


class The_Snake extends Main_Field {    ;;∙------∙the snake.
    Food_C() {
        Loop {
            Random, random_coord, 1, 961
            GuiControlGet, zt, Visible , SF%random_coord%
        } until (zt = 0)
        GuiControl, Show, FF%random_coord%
        this.Food_Loc := random_coord
        return this.Food_Loc    ;;∙------∙food location.
    }

    Game_Mapping() {
        Loop, 961 {
            Snake_X := this.Field_Elements[A_Index][1], Snake_Y := this.Field_Elements[A_Index][2]    ;;∙------∙Snakes start location.
            Gui, add, progress, w10 h10 cWhite x%Snake_X% y%Snake_Y% vSF%A_Index% +Border +Hidden
            Gui, add, progress, w10 h10 cOlive x%Snake_X% y%Snake_Y% vFF%A_Index% +Hidden, 100
        }
    }

    Game_Start(record) {
        this.rec := record
        this.points := 0, this.length := 5
        this.Snake_Elements := Object()
        Loop, 5 {    ;;∙------∙Gyvates nareliu skaicius.
            Snake_C := 466 + A_Index    ;;∙------∙Fields where the snake is.
            GuiControl, Show, SF%Snake_C%
            this.Snake_Elements[A_Index] := Snake_C
        }
    }

    Snake_Move(speed, border_pass, points_add, musics)
    {
    if (musics = 1)
        music := "*-1"
    else
        music := ""
    KeyR := 2, KeyU := 2, KeyL := 2, KeyD := 2, direction := 1
    Loop {
        count_states := GetKeyState("Right") + GetKeyState("Left") + GetKeyState("Up") + GetKeyState("Down")    ;;∙------∙Checks how much key are pressed at the same time.
        if (count_states < 2) { 
            if (GetKeyState("Right") AND KeyR = 2) {
                if (direction = 3 OR direction = 1)
                    KeyR := 3, KeyL := 2, KeyU := 2, KeyD := 2
                else
                    direction := 1, KeyR := 3, KeyL := 2, KeyU := 2, KeyD := 2
            }
            if (GetKeyState("Up") AND KeyU = 2) {
                if (direction = 4 OR direction = 2)
                    KeyR := 2, KeyL := 2, KeyU := 3, KeyD := 2
                else
                    direction := 2, KeyR := 2, KeyL := 2, KeyU := 3, KeyD := 2
            }
            if (GetKeyState("Left") AND KeyL = 2) {
                if (direction = 1 OR direction = 3)
                    KeyR := 2, KeyL := 3, KeyU := 2, KeyD := 2
                else
                    direction := 3, KeyR := 2, KeyL := 3, KeyU := 2, KeyD := 2
            }
            if (GetKeyState("Down") AND KeyD = 2) {
                if (direction = 2 OR direction = 4)
                    KeyR := 2, KeyL := 2, KeyU := 2, KeyD := 3
                else
                    direction := 4, KeyR := 2, KeyL := 2, KeyU := 2, KeyD := 3
            }
        }
        if (direction = 1)    ;;∙------∙Moves to the right.
            current_border := "31,62,93,124,155,186,217,248,279,310,341,372,403,434,465,496,527,558,589,620,651,682,713,744,775,806,837,868,899,930,961", f_move := -30, s_move := 1
        if (direction = 2)    ;;∙------∙Moves up.
            current_border := "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31", f_move := 930, s_move := -31
        if (direction = 3)    ;;∙------∙Moves to the left.
            current_border := "1,32,63,94,125,156,187,218,249,280,311,342,373,404,435,466,497,528,559,590,621,652,683,714,745,776,807,838,869,900,931", f_move := 30, s_move := -1
        if (direction = 4)    ;;∙------∙Moves down.
            current_border := "931,932,933,934,935,936,937,938,939,940,941,942,943,944,945,946,947,948,949,950,951,952,953,954,955,956,957,958,959,960,961", f_move := -930, s_move := 31
        sleep %speed%
        extra_minus := this.Snake_Elements[1], add_new := false
        GuiControl, Hide, SF%extra_minus%
        Loop, % this.Snake_Elements.MaxIndex() {
            if (A_Index = this.Snake_Elements.MaxIndex()) {
                zw := this.Snake_Elements[A_Index]    ;;∙------∙Check if the box is on the right bank.
                if zw in %current_border%
                {
                    if (border_pass = 2)
                        this.Snake_Elements[A_Index] := this.Snake_Elements[A_Index] + f_move
                    if (border_pass = 1) {
                        this.Game_Over(this.points)
                        break, 2
                    }
                }
                else
                    this.Snake_Elements[A_Index] := this.Snake_Elements[A_Index - 1] + s_move
                re := this.Snake_Elements[A_Index]
                if (this.Food_Loc = this.Snake_Elements[A_Index]) {    ;;∙------∙Food was eaten.
                    SoundPlay, %music%
                    this.points += points_add, this.length += 1
                    tt_l := "Snake length: " this.length, tt_p := "Points: " this.points 
                    GuiControl,, points, % tt_p
                    GuiControl,, leng, % tt_l
                    add_new := true, temp_c := this.Food_Loc
                    this.Snake_Elements.Push(this.Food_Loc)
                    this.Food_C()
                }
                GuiControlGet, zr, Visible , SF%re%
                if (zr = 1) {
                    this.Game_Over(this.points)
                    break, 2
                }
            }
            else
                this.Snake_Elements[A_Index] := this.Snake_Elements[A_Index + 1]
            extra_plus := this.Snake_Elements[A_Index]
            GuiControlGet, OutputVar, Visible , SF%extra_plus%
            if (OutputVar = 0)
                GuiControl, Show, SF%extra_plus%
            }
        if (add_new = true) {
            GuiControl, Hide, FF%temp_c%
            GuiControl, Show, SF%temp_c%
            }
        }
    }
    Game_Over(points_earned)
    {
        if (points_earned > this.rec) {
            IniWrite, %points_earned%, C:\Users\%A_UserName%\Documents\SnakeStats.ini, section4, record
            MsgBox, 68, GAME OVER, % "NEW RECORD " points_earned "!!!nnDo you want to play again?"
            IfMsgBox, Yes
            {
                Gui, Destroy
                Reload
            }
            else
                ExitApp
        }
        else
            MsgBox, 68, GAME OVER, % "Your score " points_earned "!nnDo you want to play again?"
            IfMsgBox, Yes
            {
                Gui, Destroy
                Reload
            }
            else
                ExitApp
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
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.
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
SNAKE:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

