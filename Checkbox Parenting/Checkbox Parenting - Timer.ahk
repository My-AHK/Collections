
;;∙---------------------------------------------------------------------∙

SetTimer, UpdateCheck, 500
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")
GoSub, TrayMenu
Menu, Tray, Icon, shell32.dll, 270
SetWorkingDir %A_ScriptDir%
;;∙---------------------------------------------------------------------∙


;;∙---------------------------------------------------------------------∙
;;∙==============================================∙



;;∙------∙Polling Driven (via Timer)∙------∙
;;∙======∙DIRECTIVES∙=============================∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force

;;∙======∙VARIABLES∙==============================∙
global busy := false
global GrandChildA1_1, GrandChildA1_2, GrandChildA1_3, ChildA1, ChildA2, ChildA3, ParentA
global ChildB1, ChildB2, ChildB3, ChildB4, ChildB5, ChildB6, ChildB7, ParentB
global prevParentA := false, prevParentB := false, prevChildA1 := false

;;∙======∙GUI BUILD∙==============================∙
Gui, +AlwaysOnTop +toolWindow
Gui, Color, A7C1F7
Gui, Add, TreeView, r16 w250 Checked c0000FF

ParentA := TV_Add("Parent-A", 0, "Expand")
    ChildA1 := TV_Add("Child-A1", ParentA, "Expand")
        GrandChildA1_1 := TV_Add("GrandChild-A1-1", ChildA1)
        GrandChildA1_2 := TV_Add("GrandChild-A1-2", ChildA1)
        GrandChildA1_3 := TV_Add("GrandChild-A1-3", ChildA1)
    ChildA2 := TV_Add("Child-A2", ParentA)
    ChildA3 := TV_Add("Child-A3", ParentA)

ParentB := TV_Add("Parent-B")
    ChildB1 := TV_Add("Child-B1", ParentB)
    ChildB2 := TV_Add("Child-B2", ParentB)
    ChildB3 := TV_Add("Child-B3", ParentB)
    ChildB4 := TV_Add("Child-B4", ParentB)
    ChildB5 := TV_Add("Child-B5", ParentB)
    ChildB6 := TV_Add("Child-B6", ParentB)
    ChildB7 := TV_Add("Child-B7", ParentB)

Gui, Show, x1500 y200
SetTimer, PollCheckboxes, 100
Return

;;∙======∙ROUTINE∙================================∙
PollCheckboxes:
    if (busy)
        return
    busy := true

    ;;∙------∙Handle parent check changes, propagate to children.
    ;;∙------∙Check if ParentA was manually checked/unchecked.
    currParentA := TV_Get(ParentA, "Checked")
    if (currParentA != prevParentA)
    {
        prevParentA := currParentA
        state := currParentA ? "+Check" : "-Check"
        TV_Modify(ChildA1, state)
        TV_Modify(GrandChildA1_1, state)
        TV_Modify(GrandChildA1_2, state)
        TV_Modify(GrandChildA1_3, state)
        TV_Modify(ChildA2, state)
        TV_Modify(ChildA3, state)
    }

    ;;∙------∙Check if ChildA1 was manually checked/unchecked
    currChildA1 := TV_Get(ChildA1, "Checked")
    if (currChildA1 != prevChildA1)
    {
        prevChildA1 := currChildA1
        state := currChildA1 ? "+Check" : "-Check"
        TV_Modify(GrandChildA1_1, state)
        TV_Modify(GrandChildA1_2, state)
        TV_Modify(GrandChildA1_3, state)
    }

    ;;∙------∙Check if ParentB was manually checked/unchecked
    currParentB := TV_Get(ParentB, "Checked")
    if (currParentB != prevParentB)
    {
        prevParentB := currParentB
        state := currParentB ? "+Check" : "-Check"
        TV_Modify(ChildB1, state)
        TV_Modify(ChildB2, state)
        TV_Modify(ChildB3, state)
        TV_Modify(ChildB4, state)
        TV_Modify(ChildB5, state)
        TV_Modify(ChildB6, state)
        TV_Modify(ChildB7, state)
    }

    ;;∙------∙List 1: Grandchildren to ChildA1.
    isChecked1 := TV_Get(GrandChildA1_1, "Checked")
    isChecked2 := TV_Get(GrandChildA1_2, "Checked")
    isChecked3 := TV_Get(GrandChildA1_3, "Checked")
    if (isChecked1 and isChecked2 and isChecked3)
        TV_Modify(ChildA1, "+Check")
    else
        TV_Modify(ChildA1, "-Check")
    prevChildA1 := TV_Get(ChildA1, "Checked")

    ;;∙------∙List 1: Children to ParentA.
    isChecked4 := TV_Get(ChildA1, "Checked")
    isChecked5 := TV_Get(ChildA2, "Checked")
    isChecked6 := TV_Get(ChildA3, "Checked")
    if (isChecked4 and isChecked5 and isChecked6)
        TV_Modify(ParentA, "+Check")
    else
        TV_Modify(ParentA, "-Check")
    prevParentA := TV_Get(ParentA, "Checked")

    ;;∙------∙List 2: Children to ParentB.
    isB1 := TV_Get(ChildB1, "Checked")
    isB2 := TV_Get(ChildB2, "Checked")
    isB3 := TV_Get(ChildB3, "Checked")
    isB4 := TV_Get(ChildB4, "Checked")
    isB5 := TV_Get(ChildB5, "Checked")
    isB6 := TV_Get(ChildB6, "Checked")
    isB7 := TV_Get(ChildB7, "Checked")
    if (isB1 and isB2 and isB3 and isB4 and isB5 and isB6 and isB7)
        TV_Modify(ParentB, "+Check")
    else
        TV_Modify(ParentB, "-Check")
    prevParentB := TV_Get(ParentB, "Checked")
    busy := false
Return

GuiClose:
ExitApp
;;∙==============================================∙



;;∙======∙GUI DRAG∙==============================∙
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}
Return
;;∙---------------------------------------------------------------------∙


;;∙==============================================∙
;;∙---------------------------------------------------------------------∙


;;∙======∙SCRIPT EDIT/RELOAD/EXIT∙================∙
;;∙------∙Edit∙-----------------------------∙
Script·Edit:    ;;∙------∙Menu Call.
    Edit
Return
;;∙------∙Reload∙-------------------------∙
^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        ;;∙------∙aSoundBeep(1000, 200)    ;;∙------∙Async SoundBeep.
    Reload
Return
;;∙------∙Exit∙-----------------------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        ;;∙------∙aSoundBeep(1000, 200)    ;;∙------∙Async SoundBeep.
    ExitApp
Return

;;∙======∙SCRIPT UPDATE∙=========================∙
UpdateCheck:    ;;∙------Check if script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        return
        aSoundBeep(1500, 100)    ;;∙------∙Async SoundBeep.
Reload

;;∙======∙ASYNCHRONOUS SOUNDBEEP∙=============∙
aSoundBeep(Frequency, Duration) {
    AutoHotkeyPath := A_AhkPath    
    shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec("""" AutoHotkeyPath """ *")
    exec.StdIn.Write("#NoTrayIcon`nSoundBeep, " Frequency "," Duration "`nExitApp")
    exec.StdIn.Close()
}

;;∙======∙TRAY MENU∙============================∙
TrayMenu:
Menu, Tray, Tip, %ScriptID%
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add
;;∙------∙Menu-Extentions∙------------∙
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
;;∙------∙Menu-Options∙---------------∙
Menu, Tray, Add
Menu, Tray, Add, Script Edit, Script·Edit
Menu, Tray, Icon, Script Edit, imageres.dll, 247
Menu, Tray, Add
Menu, Tray, Add, Script Reload, Script·Reload
Menu, Tray, Icon, Script Reload, mmcndmgr.dll, 47
Menu, Tray, Add
Menu, Tray, Add, Script Exit, Script·Exit
Menu, Tray, Icon, Script Exit, shell32.dll, 272
Menu, Tray, Default, Script Exit
Menu, Tray, Add
Menu, Tray, Add
Return

;;∙======∙TRAY MENU EXTENTIONS∙=================∙
Documentation:
    Run, "C:\Program Files\AutoHotkey\AutoHotkey.chm"
Return
ShowKeyHistory:
    KeyHistory
Return
ShowWindowSpy:
    Run, "C:\Program Files\AutoHotkey\WindowSpy.ahk"
Return

;;∙======∙TRAY MENU POSITION∙===================∙
;;∙------∙Tray Menu Show∙-----------∙
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20
Return
;;∙------∙Position Funtion∙-----------∙
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
    return True
    }
Return
;;∙==============================================∙
;;∙======∙SCRIPT END∙=============================∙
;;∙---------------------------------------------------------------------∙


