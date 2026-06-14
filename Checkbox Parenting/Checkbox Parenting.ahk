
;;∙---------------------------------------------------------------------∙

SetTimer, UpdateCheck, 500
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")
GoSub, TrayMenu
Menu, Tray, Icon, shell32.dll, 270
SetWorkingDir %A_ScriptDir%
;;∙---------------------------------------------------------------------∙


;;∙---------------------------------------------------------------------∙
;;∙==============================================∙


;;∙======∙DIRECTIVES∙=============================∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force

;;∙======∙VARIABLES∙==============================∙
global busy := false
global GChild1, GChild2, GChild3, Child1, Child2, Child3, ParentA
global Child1b, Child2b, Child3b, Child4b, Child5b, Child6b, Child7b, ParentB
global prevParentA := false, prevParentB := false, prevChild1 := false

;;∙======∙GUI BUILD∙==============================∙
Gui, +AlwaysOnTop +toolWindow
Gui, Color, A7C1F7
Gui, Add, TreeView, r10 w250 Checked cFF0000

ParentA := TV_Add("List 1 Completed", 0, "Expand")
    Child1 := TV_Add("Item A", ParentA, "Expand")
        GChild1 := TV_Add("Item A 1", Child1)
        GChild2 := TV_Add("Item A 2", Child1)
        GChild3 := TV_Add("Item A 3", Child1)
    Child2 := TV_Add("Item B", ParentA)
    Child3 := TV_Add("Item C", ParentA)

ParentB := TV_Add("List 2 Completed")
    Child1b := TV_Add("Item B 1", ParentB)
    Child2b := TV_Add("Item B 2", ParentB)
    Child3b := TV_Add("Item B 3", ParentB)
    Child4b := TV_Add("Item B 4", ParentB)
    Child5b := TV_Add("Item B 5", ParentB)
    Child6b := TV_Add("Item B 6", ParentB)
    Child7b := TV_Add("Item B 7", ParentB)

Gui, Show, x1500 y200
SetTimer, PollCheckboxes, 100
Return

;;∙======∙ROUTINE∙================================∙
PollCheckboxes:
    if (busy)
        return
    busy := true

    ;;∙------∙Handle parent check changes - propagate to children.
    ;;∙------∙Check if ParentA was manually checked/unchecked.
    currParentA := TV_Get(ParentA, "Checked")
    if (currParentA != prevParentA)
    {
        prevParentA := currParentA
        state := currParentA ? "+Check" : "-Check"
        TV_Modify(Child1, state)
        TV_Modify(GChild1, state)
        TV_Modify(GChild2, state)
        TV_Modify(GChild3, state)
        TV_Modify(Child2, state)
        TV_Modify(Child3, state)
    }

    ;;∙------∙Check if Child1 was manually checked/unchecked
    currChild1 := TV_Get(Child1, "Checked")
    if (currChild1 != prevChild1)
    {
        prevChild1 := currChild1
        state := currChild1 ? "+Check" : "-Check"
        TV_Modify(GChild1, state)
        TV_Modify(GChild2, state)
        TV_Modify(GChild3, state)
    }

    ;;∙------∙Check if ParentB was manually checked/unchecked
    currParentB := TV_Get(ParentB, "Checked")
    if (currParentB != prevParentB)
    {
        prevParentB := currParentB
        state := currParentB ? "+Check" : "-Check"
        TV_Modify(Child1b, state)
        TV_Modify(Child2b, state)
        TV_Modify(Child3b, state)
        TV_Modify(Child4b, state)
        TV_Modify(Child5b, state)
        TV_Modify(Child6b, state)
        TV_Modify(Child7b, state)
    }

    ;;∙------∙List 1: Grandchildren to Child1.
    isChecked1 := TV_Get(GChild1, "Checked")
    isChecked2 := TV_Get(GChild2, "Checked")
    isChecked3 := TV_Get(GChild3, "Checked")
    if (isChecked1 and isChecked2 and isChecked3)
        TV_Modify(Child1, "+Check")
    else
        TV_Modify(Child1, "-Check")
    prevChild1 := TV_Get(Child1, "Checked")

    ;;∙------∙List 1: Children to ParentA.
    isChecked4 := TV_Get(Child1, "Checked")
    isChecked5 := TV_Get(Child2, "Checked")
    isChecked6 := TV_Get(Child3, "Checked")
    if (isChecked4 and isChecked5 and isChecked6)
        TV_Modify(ParentA, "+Check")
    else
        TV_Modify(ParentA, "-Check")
    prevParentA := TV_Get(ParentA, "Checked")

    ;;∙------∙List 2: Children to ParentB.
    isB1 := TV_Get(Child1b, "Checked")
    isB2 := TV_Get(Child2b, "Checked")
    isB3 := TV_Get(Child3b, "Checked")
    isB4 := TV_Get(Child4b, "Checked")
    isB5 := TV_Get(Child5b, "Checked")
    isB6 := TV_Get(Child6b, "Checked")
    isB7 := TV_Get(Child7b, "Checked")
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


