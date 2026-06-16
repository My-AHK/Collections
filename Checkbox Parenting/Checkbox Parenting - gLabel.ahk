
;;∙---------------------------------------------------------------------∙

SetTimer, UpdateCheck, 500
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")
GoSub, TrayMenu
Menu, Tray, Icon, shell32.dll, 270
SetWorkingDir %A_ScriptDir%
;;∙---------------------------------------------------------------------∙


;;∙---------------------------------------------------------------------∙
;;∙==============================================∙



;;∙------∙Event Driven (via gLabel)∙------∙
;;∙======∙DIRECTIVES & SETTINGS∙==================∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force

global updating := false

;;∙======∙GUI BUILD∙==============================∙
Gui, +AlwaysOnTop +toolWindow
Gui, Color, A7C1F7

Gui, Add, TreeView, r16 w250 Checked c0000FF gTreeEvent AltSubmit

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
Return

;;∙======∙ROUTINE & FUNCTIONS∙====================∙
TreeEvent:
    if (updating)
        return
    If (A_GuiEvent = "Normal" || A_GuiEvent = "K") {
        updating := true
        itemID := A_GuiEvent = "Normal" ? A_EventInfo : TV_GetSelection()
        ;;∙------∙First, sync children with parent's state.
        TV_Get(itemID, "Checked") ? checkAllChildren(itemID) : uncheckAllChildren(itemID)
        ;;∙------∙Then, update parents based on children's state.
        assessSiblings(itemID)
        updating := false
    }
Return

checkAllChildren(itemID) {
    childID := TV_GetChild(itemID)
    Loop {
        if !childID
            break
        TV_Modify(childID, "Check")
        checkAllChildren(childID)    ;;∙------∙Recursively Check grandchildren.
        childID := TV_GetNext(childID)
    }
}

uncheckAllChildren(itemID) {
    childID := TV_GetChild(itemID)
    Loop {
        if !childID
            break
        TV_Modify(childID, "-Check")
        uncheckAllChildren(childID)    ;;∙------∙Recursively Uncheck grandchildren.
        childID := TV_GetNext(childID)
    }
}

assessSiblings(itemID) {
    If !parentItemID := TV_GetParent(itemID)
        Return
    Loop {    ;;∙------∙Loop through siblings.
        If (A_Index = 1)    ;;∙------∙First sibling.
            itemID := TV_GetChild(parentItemID)
        If !checked := TV_Get(itemID, "Checked") {
            TV_Modify(parentItemID, "-Check"), assessSiblings(parentItemID)
            Return
        }
    } Until TV_GetParent(itemID := TV_GetNext(itemID)) != parentItemID
    TV_Modify(parentItemID, "Check"), assessSiblings(parentItemID)
}

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


