
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙--------∙Origins∙-------------------------∙
» Author:  Self
» Original Source:  
» 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "Open_Images"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
AppPath_Animations := "C:\Program Files (x86)\Jasc Software Inc\Animation Shop 3\Anim.exe"
AppPath_Icons := "C:\Program Files\Greenfish Icon Editor Pro 3.6 Port\Greenfish Icon Editor Pro 3.6\gfie64.exe"
AppPath_Images := "C:\Program Files\Corel\Corel PaintShop Pro 2023 (64-bit)\Corel PaintShop Pro.exe"    ;;∙------∙(Main Graphics Editor)
AppPath_PDF := "C:\Program Files\Nitro\Pro\13\NitroPDF.exe"

;;∙------------------------∙
^p::    ;;∙------∙(Ctrl+P)🔥 HOTKEY 🔥
Switch, Morse() {
    Case "0": GoSub, Sub1    ;;∙------∙Hotkey single-tap. (opens image editor depending on file type)
    Case "00": GoSub, Sub2    ;;∙------∙Hotkey double-tap. (opens main graphics editor)
}
Return

;;∙------------------------∙
Sub1:
    SelectedItem := GetSelectedItemPath()
    if (FileExist(SelectedItem) && !IsFolder(SelectedItem)) {
        if (IsHidden(SelectedItem)) {
            MsgBox, , , The selected file is a Hidden File!!, 3
            Return
        }
        FileExt := SubStr(SelectedItem, InStr(SelectedItem, ".",, -1))
        if (IsValidImageFile(SelectedItem)) {
            if (FileExt = ".gif") {
                Run, % AppPath_Animations " """ SelectedItem """"    ;;∙------∙Animated GIFs (.gif)
            } else if (FileExt = ".ico") {
                Run, % AppPath_Icons " """ SelectedItem """"    ;;∙------∙Icons (.ico)
            } else {
                Run, % AppPath_Images " """ SelectedItem """"    ;;∙------∙All other image formats (.bmp.jpg.jpeg.png.svg.tif.tiff)
            }
            Soundbeep, 1900, 75
            Soundbeep, 1900, 75
        } else if (FileExt = ".pdf") {
            Run, % AppPath_PDF " """ SelectedItem """"    ;;∙------∙PDF Files (.pdf)
            Soundbeep, 1900, 75
            Soundbeep, 1900, 75
        } else {
            Soundbeep, 1200, 75
            Soundbeep, 1000, 150
            MsgBox, , , The selected file is NOT a valid Image File., 3
        }
    } else {
        Soundbeep, 1000, 75
        Soundbeep, 1000, 75
        MsgBox, , , The selected item is a Folder`n        ...NOT a File., 3
    }
Return

;;∙------------------------∙
Sub2:
    Soundbeep, 1400,75
Run, % AppPath_Images
; Run, C:\Program Files\Corel\Corel PaintShop Pro 2023 (64-bit)\Corel PaintShop Pro.exe
Return

;;∙======∙FUNCTIONS∙===========================================∙
;;∙------------------------∙
Morse(Timeout = 400) {
    Global Pattern := ""
    RegExMatch(A_ThisHotkey, "\W$|\w*$", Key)
    While, !ErrorLevel {
        T := A_TickCount
        KeyWait %Key%
        Pattern .= A_TickCount-T > Timeout
        KeyWait %Key%,% "DT" Timeout/1000
    } Return Pattern
}
Return
;;∙------------------------∙
GetSelectedItemPath() {
    Clipboard := ""
    Send, ^c
    ClipWait
    Return Clipboard
}
;;∙------------------------∙
IsValidImageFile(FilePath) {
    ImageExtensions := ".bmp.jpg.jpeg.png.gif.svg.tif.tiff.ico"
    FileExt := SubStr(FilePath, InStr(FilePath, ".",, -1))
    Return InStr(ImageExtensions, FileExt)
}
;;∙------------------------∙
IsFolder(FilePath) {
    Return (SubStr(FileExist(FilePath), 1, 1) = "D")
}
;;∙------------------------∙
IsHidden(FilePath) {
    FileGetAttrib, Attributes, %FilePath%
    Return InStr(Attributes, "H")
}
Return
;;∙------------------------∙
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
Menu, Tray, Icon, shell32.dll, 326
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
Open_Images:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

