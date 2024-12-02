
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙--------∙Origins∙-------------------------∙
» Author:  Awannaknow
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?f=6&t=687&p=5278#p5278
» Drag-n-Drop AHK file onto Gui interface to strip all Comments from the script.
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "Strip_Comments"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
Gui, +AlwaysOnTop -Border
Gui, Margin, 5, 5
Gui, Font, s12 BOLD cBLACK q5, Segoe UI
Gui, Color, 6AA8D7    ;;∙------∙Blue (ready)
    Gui, Add, Text, x-2 y-10 w270 h50 gGuiMove +Center, `nStrip AHK Comments 
Gui, Font, s10 c43FC43 q5, ARIAL
    Gui, Add, Text, xp y+0 h30 Wp gGuiMove  vDrop +Center, Drop files and folders`n 
    Gui, Add, Pic, x5 y15 icon2, %A_AhkPath%  
    Gui, Add, Pic, x230 y15 icon2, %A_AhkPath%  
Gui, Show, w270 h70 NoActivate, Strip AHK Comments  
Return  

GuiMove:  
    PostMessage, 0xA1, 2,,, A  
Return  

GuiDropfiles:  
    Gui, Color, 6AA897    ;;∙------∙(completed)
    Gui, -E0x10  
    GuiControl, ,Dropped, Please wait . . .  
    Loop, Parse, A_GuiEvent, `n, `r 
        {  
        If (! InStr(FileExist(A_Loopfield), "D")) { 
            If (! RegExMatch(A_LoopField, ".ahk$")) 
               Continue 
           AHKFileNoComments := RegExReplace(A_LoopField, "(\\.*)\.", "$1(NoComments).") 
           Strip(A_LoopField, AHKFileNoComments) 
            }  
        Else {  
            Loop % A_LoopField "\*.ahk",0,1  
            {  
            If (! RegExMatch(A_LoopFileFullPath, ".ahk$"))  
                Continue  
            AHKFileNoComments := RegExReplace(A_LoopFileFullPath, "(\\.*)\.", "$1(NoComments).")  
            Strip(A_LoopFileFullPath, AHKFileNoComments)  
            }  
        }  
    }  
    Gui, Color, 7F0000    ;;∙------∙Dark Red
    Gui +LastFound
    WinSet, TransColor, 7F0000    ;;∙------∙Makes transparent.
    GuiControl, ,Drop, Drop files and folders  
    Gui, +E0x10  
Return  

GuiEscape:  
    ExitApp  
Return

Strip( in, out )  
    {  
        Loop Read, %in%, %out%  
            {  
            TwoChars := SubStr(LTrim(A_LoopReadline), 1, 2)  
            If (TwoChars = "/*") { 
                BlockComment := True  
                Continue  
            }  
            If (TwoChars = "*/") { 
                BlockComment := False  
                ReadLine := RegExReplace(A_LoopReadLine, "\*/\s*")  
                If (Trim(ReadLine) <> "") { 
                    FileAppend %ReadLine% `n  
                }  
                Continue  
            }  
            If (BlockComment) { 
                Continue  
            }  
            If (InStr(A_LoopReadline, ";")) { 
                ReadLine := RegExReplace(A_LoopReadline, "^;.*$|\s+;.*$")  
                If (Trim(ReadLine) <> "") {  
                    FileAppend %ReadLine% `n  
                }  
                Continue  
            }  
            FileAppend %A_LoopReadLine% `n  
        }  
    Sleep, 1100
    Reload
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
Strip_Comments:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

