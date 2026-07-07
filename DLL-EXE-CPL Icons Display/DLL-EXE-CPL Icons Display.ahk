
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙DIRECTIVES∙==============================∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force
SendMode, Input
SetBatchLines -1
SetTitleMatchMode 2
SetWinDelay 0 
CoordMode, Mouse, Screen
Menu, Tray, Icon, shell32.dll, 317

;;∙======∙INITIALIZERS∙=============================∙
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙GUI DRAG PT 1.
GoSub, TrayMenu

;;∙======∙HOTKEY∙=================================∙
^t::    ;;∙------∙🔥∙(Ctrl + T)
    Soundbeep, 800, 200
    ;;∙------∙Show processing tooltip.
    SetTimer, UpdateTooltip, 100
    Gosub, UpdateTooltip

;;∙======∙GLOBALS∙================================∙
global Count := 0, File := "shell32.dll"    ;;∙------∙Icon count initialize / Default DLL file.
global system32Path := A_WinDir . "\System32\"
global dllList := []
global currentFileIndex := 1

;;∙======∙GUI CONFIGURATIONS∙====================∙
global GXpos := "1400", GYpos := "100"    ;;∙------∙Gui x-axis & y-axis (left blank will center to screen).
global GColor := "212223", TColor := "006FDE"    ;;∙------∙Gui and Gui text colors.

;;∙------∙Reload & Exit Buttons.
global ButtonBgColor1 := "0B0B0B", ButtonBgColor2 := "0B0B0B"    ;;∙------∙Button background colors.
global ButtonTextColor1 := "01A70B", ButtonTextColor2 := "A7010B"    ;;∙------∙Button text colors.

;;∙------∙ListViews.
global LVTextColor1 := "8FC1E2", LVTextColor2 := "8FC1E2"    ;;∙------∙Listview text colors.
global LVBgColor1 := "676767", LVBgColor2 := "676767"    ;;∙------∙Listview background colors.

;;∙======∙MAIN EXECUTIONS∙========================∙
ScanSystem32ForIcons()
CreateDLLList()
GoSub, CreateGui
    ;;∙------∙Remove tooltip & timer once GUI is ready.
    SetTimer, UpdateTooltip, Off
    ToolTip
Return

;;∙======∙SCAN SYSTEM32 FOR ICONS∙================∙
ScanSystem32ForIcons() {
    global dllList
    ;;∙------∙Scan for DLL files with icons.
    Loop, % system32Path "*.dll"
    {
        dllFile := A_LoopFileFullPath
        iconCount := SafeCountIconsInDll(dllFile)
        if (iconCount > 0) {
            dllList.Push({name: A_LoopFileName, path: dllFile, icons: iconCount})
        }
    }
    ;;∙------∙Scan for EXE files with icons.
    Loop, % system32Path "*.exe"
    {
        exeFile := A_LoopFileFullPath
        iconCount := SafeCountIconsInDll(exeFile)
        if (iconCount > 0) {
            dllList.Push({name: A_LoopFileName, path: exeFile, icons: iconCount})
        }
    }
    ;;∙------∙Scan for CPL files with icons.
    Loop, % system32Path "*.cpl"
    {
        cplFile := A_LoopFileFullPath
        iconCount := SafeCountIconsInDll(cplFile)
        if (iconCount > 0) {
            dllList.Push({name: A_LoopFileName, path: cplFile, icons: iconCount})
        }
    }
    ;;∙------∙Sort alphabetically.
    dllList := SortObjectArray(dllList, "name")
}


/*
;;∙======∙CREATE DLL DROPDOWN LIST∙===∙OPT. #1∙====∙
;;∙------∙Simple numbering - (1., 2., 3.,) (*OPTIONAL*).
CreateDLLList() {
    global dllList
    global dllLookup := {}
    for index, fileInfo in dllList {
        ;;∙------∙Create a friendly name with numbering.
        friendlyName := index ". " . RegExReplace(fileInfo.name, "\.(dll|exe|cpl)$", "")
        dllLookup[friendlyName] := fileInfo.name
    }
}
*/


;;∙======∙CREATE DLL DROPDOWN LIST∙===∙OPT. #2∙====∙
;;∙------∙Zero-padded numbering - (001., 002., 003.,).
CreateDLLList() {
    global dllList
    global dllLookup := {}
    ;;∙------∙Determine padding length.
    maxLength := StrLen(dllList.Length())
    for index, fileInfo in dllList {
        ;;∙------∙Create zero-padded number.
        paddedIndex := Format("{:0" maxLength "}", index)
        friendlyName := paddedIndex ". " . RegExReplace(fileInfo.name, "\.(dll|exe|cpl)$", "")
        dllLookup[friendlyName] := fileInfo.name
    }
}


/*
;;∙======∙CREATE DLL DROPDOWN LIST∙===∙OPT. #3∙====∙
;;∙------∙Total count - (1/250, 2/250, 3/250) (*OPTIONAL*).
CreateDLLList() {
    global dllList
    global dllLookup := {}
    totalCount := dllList.Length()
    for index, fileInfo in dllList {
        friendlyName := index "/" totalCount ". " . RegExReplace(fileInfo.name, "\.(dll|exe|cpl)$", "")
        dllLookup[friendlyName] := fileInfo.name
    }
}
*/


;;∙======∙GUI CREATION∙============================∙
CreateGui:
    Gui, Destroy
    Gui, +AlwaysOnTop -Caption +Border +Owner
    Gui, Color, %GColor%
    Gui, Font, s10 c%TColor%
    Gui, Add, ListView, x20 y20 w135 h540 gListClick Background%LVBgColor1% c%LVTextColor1%, Big Icons

    ;;∙------∙Update icon count for current file.
    global Count := GetIconCountForFile(File)
    ImageListID := IL_Create(Count,,1)
    LV_SetImageList(ImageListID,1)
    Loop, % Count
        IL_Add(ImageListID, system32Path . File, A_Index)
    Loop, % Count
        LV_Add("Icon" A_Index, "     -     " A_Index, 2)
    LV_ModifyCol(1, 115)

    Gui, Add, ListView, x175 y20 w135 h540 gListClick Background%LVBgColor2% c%LVTextColor2%, Small Icons
    ImageListID_small := IL_Create(Count)
    LV_SetImageList(ImageListID_small)
    Loop, % Count
        IL_Add(ImageListID_small, system32Path . File, A_Index)
    Loop, % Count
        LV_Add("Icon" A_Index, "     -     " A_Index, 2)
    LV_ModifyCol(1, 115)
    ;;∙------∙Create dropdown from scanned files.
    dllNames := []
    for name in dllLookup
        dllNames.Push(name)
    Sort, dllNames

    Gui, Add, DropDownList, x25 y570 w280 vSelectedDLL gDLLSelected, % "  Select An Icon File.   (default = shell32.dll) ||" JoinArray(dllNames, "|")
    ;;∙------∙Select current file in dropdown.
    currentFriendlyName := RegExReplace(File, "\.(dll|exe)$", "")
    if (dllLookup[currentFriendlyName] = File)
        GuiControl, ChooseString, SelectedDLL, %currentFriendlyName%

    Gui, Add, Edit, x30 y600 w270 h25 vFilePathDisplay -VScroll ReadOnly, %A_Space% %system32Path%%File%
    Gui, Font, s8
    Gui, Add, Text, x40 yp+30 cGray BackgroundTrans, Path copied to clipboard when icon is double-clicked
    Gui, Font, s10

;;∙======∙BUTTONS∙================================∙
    Gui, Font, s10 BOLD, CALIBRI    ;;∙------∙Buttons.

    ButtonBgColor1 := "black", ButtonTextColor1 := "Lime"
    Gui, Add, Progress, x80 y650 w65 h25 Disabled Background%ButtonBgColor%
    Gui, Add, Text, xp yp wp hp c%ButtonTextColor1% HwndhText BackgroundTrans Center 0x200 0x00800000 gRELOAD, RELOAD
        GuiTip(hText, "RELOAD")

    Gui, Add, Picture, x152 y650 HwndhText gDlabel BackgroundTrans w26 h26 Icon160, shell32.dll
        GuiTip(hText, "DRAGGABLE")

    ButtonBgColor2 := "black", ButtonTextColor2 := "Red"
    Gui, Add, Progress, x185 y650 w65 h25 Disabled Background%ButtonBgColor%
    Gui, Add, Text, xp yp wp hp c%ButtonTextColor2% HwndhText BackgroundTrans Center 0x200 0x00800000 gEXIT, EXIT
        GuiTip(hText, "EXIT")

if (GXpos = "" || GYpos = "")
    ShowCommand := "w" 330 " h" 700 " Center"
else
    ShowCommand := "w" 330 " h" 700 " x" GXpos " y" GYpos
Gui, Show, %ShowCommand%, DLL_IconsViewer
Return

;;∙======∙DROPDOWN SELECTION HANDLER∙==========∙
DLLSelected:
    Gui, Submit, NoHide
    if (SelectedDLL = "Select a DLL/EXE file")
        return
    File := dllLookup[SelectedDLL]
    GuiControl, ChooseString, SelectedDLL, %SelectedDLL%
    GuiControl,, FilePathDisplay, %system32Path%%File%
    Gosub, CreateGui
Return

;;∙======∙LISTVIEW HANDLER∙=======================∙
ListClick()
{
    global system32Path, File
    if (A_GuiEvent = "DoubleClick")
    {
        Clipboard := File ", " A_EventInfo
;        Clipboard := system32Path . File ", " A_EventInfo
        ToolTip % "Copied To The Clipboard"
        SetTimer, KillTip, -1500
    }
    GuiControl,, FilePathDisplay, %system32Path%%File%, %A_EventInfo%
}

KillTip:
    ToolTip
    SetTimer, KillTip, Off
Return

;;∙======∙HELPER FUNCTIONS∙=======================∙
JoinArray(arr, delimiter) {
    for index, value in arr
        result .= (A_Index = 1 ? "" : delimiter) . value
    return result
}

StrRepeat(str, count) {
    Loop, %count%
        out .= str
    return out
}

SortObjectArray(arr, key) {
    sortedNames := []
    for index, obj in arr
        sortedNames.Push(obj[key])
    Sort, sortedNames
    sortedArr := []
    for _, name in sortedNames {
        for index, obj in arr {
            if (obj[key] = name) {
                sortedArr.Push(obj)
                break
            }
        }
    }
    return sortedArr
}

GetIconCountForFile(filename) {
    global dllList
    for index, fileInfo in dllList {
        if (fileInfo.name = filename) {
            return fileInfo.icons
        }
    }
    return 0
}

;;∙======∙ICON COUNTING FUNCTIONS∙===============∙
SafeCountIconsInDll(dllPath) {
    static RT_ICON := 3, RT_GROUP_ICON := 14
    iconCount := 0
    hModule := DllCall("LoadLibraryEx", "Str", dllPath, "UInt", 0, "UInt", 0x00000030, "Ptr")
    if !hModule
        return 0
    VarSetCapacity(CountStruct, 4, 0)
    EnumProc := RegisterCallback("SafeEnumIconGroups", "Fast")
    DllCall("EnumResourceNames", "Ptr", hModule, "Ptr", RT_GROUP_ICON, "Ptr", EnumProc, "Ptr", &CountStruct)
    DllCall("GlobalFree", "Ptr", EnumProc)
    iconCount := NumGet(CountStruct, 0, "UInt")
    if (iconCount = 0) {
        VarSetCapacity(CountStruct, 4, 0)
        EnumProc := RegisterCallback("SafeEnumIndividualIcons", "Fast")
        DllCall("EnumResourceNames", "Ptr", hModule, "Ptr", RT_ICON, "Ptr", EnumProc, "Ptr", &CountStruct)
        DllCall("GlobalFree", "Ptr", EnumProc)
        iconCount := NumGet(CountStruct, 0, "UInt")
    }
    DllCall("FreeLibrary", "Ptr", hModule)
    return iconCount
}

SafeEnumIconGroups(hModule, lpszType, lpszName, lParam) {
    iconCount := NumGet(lParam+0, "UInt")
    NumPut(iconCount+1, lParam+0, "UInt")
    return true
}

SafeEnumIndividualIcons(hModule, lpszType, lpszName, lParam) {
    if (lpszName & 0xFFFF0000 = 0) {
        iconCount := NumGet(lParam+0, "UInt")
        NumPut(iconCount+1, lParam+0, "UInt")
    }
    return true
}

;;∙======∙MOUSE WHEEL HANDLER∙==================∙
#IfWinActive ahk_class AutoHotkeyGUI
WheelDown::
    ControlClick, SysListView321, ,, WD, 1
    ControlClick, SysListView322, ,, WD, 1
Return

WheelUp::
    ControlClick, SysListView321, ,, WU, 1
    ControlClick, SysListView322, ,, WU, 1
Return
#IfWinActive

;;∙======∙PROCESSING TOOLTIP∙=====================∙
UpdateTooltip:
    CoordMode, ToolTip, Screen
    MouseGetPos, MouseX, MouseY
    ToolTipX := MouseX + 15
    ToolTipY := MouseY - 10
    ToolTip, Scanning System32 for icon files...`, please wait..., %ToolTipX%, %ToolTipY%
Return

;;∙======∙GUI TOOLTIP FUNCTION∙===================∙
GuiTip(hCtrl, text := "")
{
    hGui := text != "" ? DllCall("GetParent", "Ptr", hCtrl) : hCtrl
    static hTip := 0    ;;∙------∙Initialize as 0.

    if (hTip && !DllCall("IsWindow", "Ptr", hTip))
        hTip := 0
    if !hTip
    {
        hTip := DllCall("CreateWindowEx", "UInt", 0x8, "Str", "tooltips_class32"
            , "Ptr", 0, "UInt", 0x80000002
            , "Int", 0x80000000, "Int", 0x80000000, "Int", 0x80000000, "Int", 0x80000000
            , "Ptr", hGui, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Ptr")
        DllCall("SendMessage", "Ptr", hTip, "Int", 0x0418, "Ptr", 0, "Ptr", 0)
        if (A_OsVersion == "WIN_XP")
            GuiTip(hGui)
    }

    static sizeof_TOOLINFO := 24 + (6 * A_PtrSize)
    VarSetCapacity(TOOLINFO, sizeof_TOOLINFO, 0)
    NumPut(sizeof_TOOLINFO, TOOLINFO, 0, "UInt")
    NumPut(0x11, TOOLINFO, 4, "UInt")
    NumPut(hGui, TOOLINFO, 8, "Ptr")
    NumPut(hCtrl, TOOLINFO, 8 + A_PtrSize, "Ptr")
    NumPut(&text, TOOLINFO, 24 + (3 * A_PtrSize), "Ptr")

    static TTM_ADDTOOL := A_IsUnicode ? 0x0432 : 0x0404
    return DllCall("SendMessage", "Ptr", hTip, "Int", TTM_ADDTOOL, "Ptr", 0, "Ptr", &TOOLINFO)
}

;;∙======∙GUI DRAG PT 2∙===========================∙
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}

;;∙======∙BUTTON/LABEL HANDLERS∙=================∙
RELOAD:    ;;∙-------∙Reload Button.
Script·Reload:    ;;∙------∙Menu Call.
    Reload
Return

Script·Edit:    ;;∙------∙Menu Call.
    Edit
Return

Dlabel:    ;;∙-------∙Drag Visual Indicator.
Return

EXIT:    ;;∙-------∙Exit Button.
Script·Exit:    ;;∙------∙Menu Call.
    ExitApp
Return

;;∙======∙TRAY MENU∙==============================∙
TrayMenu:
    Menu, Tray, NoStandard
    Menu, Tray, Click, 2
    Menu, Tray, Color, D4C668
    Menu, Tray, Add, DLL Icons Viewer, Script·Reload
    Menu, Tray, Icon, DLL Icons Viewer, shell32.dll, 317
    Menu, Tray, Add
    ;;∙------∙Script∙Extentions∙------------∙
    Menu, Tray, Add
    Menu, Tray, Add, Help Docs, Documentation
    Menu, Tray, Icon, Help Docs, shell32.dll, 211
    Menu, Tray, Add
    Menu, Tray, Add, Key History, ShowKeyHistory
    Menu, Tray, Icon, Key History, shell32.dll, 105
    Menu, Tray, Add
    Menu, Tray, Add, Window Spy, ShowWindowSpy
    Menu, Tray, Icon, Window Spy, shell32.dll, 23
    Menu, Tray, Add
;;∙------∙Script∙Options∙---------------∙
    Menu, Tray, Add, &Edit, Script·Edit
    Menu, Tray, Icon, &Edit, shell32.dll, 261
    Menu, Tray, Add
    Menu, Tray, Add, &Reload, Script·Reload
    Menu, Tray, Icon, &Reload, shell32.dll, 239
    Menu, Tray, Add
    Menu, Tray, Add, E&xit, Script·Exit
    Menu, Tray, Icon, E&xit, shell32.dll, 132
    Menu, Tray, Default, DLL Icons Viewer
    Menu, Tray, Tip, DLL Icons Viewer
Return
;;∙------------------------------------------------∙
Documentation:
    Run, "C:\Program Files\AutoHotkey\AutoHotkey.chm"
Return
ShowKeyHistory:
    KeyHistory
Return
ShowWindowSpy:
    Run, "C:\Program Files\AutoHotkey\WindowSpy.ahk"
Return

;;∙======∙TRAY MENU POSITION∙====================∙
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20
Return
;;∙------∙Positioning Funtion∙------------------∙
NotifyTrayClick(P*) { 
Static Msg, Fun:="NotifyTrayClick", NM:=OnMessage(0x404,Func(Fun),-1),  Chk,T:=-250,Clk:=1
  If ( (NM := Format(Fun . "_{:03X}", Msg := P[2])) && P.Count()<4 )
     return ( T := Max(-5000, 0-(P[1] ? Abs(P[1]) : 250)) )
  Critical
  If ( ( Msg<0x201 || Msg>0x209 ) || ( IsFunc(NM) || Islabel(NM) )=0 )
     return
  Chk := (Fun . "_" . (Msg<=0x203 ? "203" : Msg<=0x206 ? "206" : Msg<=0x209 ? "209" : ""))
  SetTimer, %NM%,  %  (Msg==0x203        || Msg==0x206        || Msg==0x209)
    ? (-1, Clk:=2) : ( Clk=2 ? ("Off", Clk:=1) : ( IsFunc(Chk) || IsLabel(Chk) ? T : -1) )
return True
}
Return
;;∙------------------------------------------------------------------------------------------∙
;;∙========================∙SCRIPT END∙=========================∙

