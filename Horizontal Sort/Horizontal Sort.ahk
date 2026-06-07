



SetTimer, UpdateCheck, 500
Menu, Tray, Icon, shell32.dll, 270
GoSub, TrayMenu

;;∙---------------------------------------------------------------------∙



;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙

;;∙------∙Handles ordered prefixes, bullet points, and simple word lists.

;;∙======∙DIRECTIVES & SETTINGS∙==================∙
#Requires AutoHotkey 1
#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines -1
SetKeyDelay, -1, -1
SetWorkingDir %A_ScriptDir%

;;∙======∙HOTKEY∙================================∙
;;∙====∙Highlight text, then press...

^+h::    ;;∙------∙🔥∙(Ctrl + Shift + H)∙Sorts horizontally∙🔥∙
    SoundBeep, 1100, 200
    SelectedText_SortHorizontal()
Return


;;∙======∙FUNCTIONS∙============================∙
SelectedText_SortHorizontal() {
    SavedClip := ClipboardAll
    Clipboard := ""
    Send ^c
    ClipWait, 0.5
    selectedText := Clipboard
    if (selectedText = "") {
        Clipboard := SavedClip
        return
    }
    result := SortHorizontal(selectedText)
    if (result != "") {
        Clipboard := result
        Send ^v
        Sleep, 150
    }
    Clipboard := SavedClip
}

SortHorizontal(s) {
/*∙===========================∙
    Classify each prefix into one of three groups:
      1) symbol (no alphanumerics)
      2) numeric (digit-led)
      3) lettered (letter-led)
    Within group 1, sub-group by distinct symbol if multiple symbols are present.
    Order sub-groups by first appearance. 
    Groups emit in order: symbol, numeric, lettered.
    ∙=============================∙
    */

    regex := "(*UCP)(\S+)\s+(.*?)(?=\s+\S+\s+\p{L}|\z)"

    ;;∙------∙Pass 1, count clusters and collect into typed buckets.
    symbolOrder   := []    ;;∙------∙Tracks distinct symbols in appearance order.
    symbolBuckets := {}    ;;∙------∙Symbol -> array of bodies.
    numItems      := []    ;;∙------∙Array of {prefix, body, sortkey}.
    letItems      := []    ;;∙------∙Array of {prefix, body, sortkey}.
    i := 0

    pos := 1
    while pos := RegExMatch(s, regex, match, pos) {
        pos    += StrLen(match)
        prefix := match1
        body   := match2
        i++

        if not RegExMatch(prefix, "(*UCP)\p{L}|\p{N}") {
            ;;∙------∙Symbol prefix, assign to its own sub-bucket.
            if not symbolBuckets.HasKey(prefix) {
                symbolBuckets[prefix] := []
                symbolOrder.Push(prefix)
            }
            symbolBuckets[prefix].Push(body)
        } else if RegExMatch(prefix, "(*UCP)^\p{N}|^\(\p{N}") {
            ;;∙------∙Digit-led prefix (1. 1) (1) 1:), extract leading number as sort key.
            RegExMatch(prefix, "(*UCP)\p{N}+", numVal)
            numItems.Push({prefix: prefix, body: body, sortkey: numVal + 0})
        } else {
            ;;∙------∙Letter-led prefix (a. A. a) A: Step-3 etc).
            ;;∙------∙If prefix contains a trailing number, sort by that number,
            ;;∙------∙otherwise sort by body text.
            if RegExMatch(prefix, "(*UCP)\p{N}+$", trailingNum)
                letItems.Push({prefix: prefix, body: body, sortkey: trailingNum + 0, byNum: true})
            else
                letItems.Push({prefix: prefix, body: body, sortkey: body, byNum: false})
        }
    }

    ;;∙------∙If only a single cluster, assume each word to be sorted independently.
    if (i <= 1) {
        Sort, s, U D%A_Space%
        return s
    }

    ;;∙------∙Pass 2, sort each bucket and reassemble.
    result := ""

    ;;∙------∙Group 1 - Symbols (Sort bodies within each sub-bucket alphabetically).
    for _, sym in symbolOrder {
        arr := symbolBuckets[sym]
        ;;∙------∙Build newline-delimited string, sort, then reassemble.
        bodies := ""
        for _, b in arr
            bodies .= (bodies = "" ? "" : "`n") . b
        Sort, bodies, U
        Loop, Parse, bodies, `n
            result .= (result = "" ? "" : A_Space) . sym . A_Space . A_LoopField
    }

    ;;∙------∙Group 2 - Numeric (sorted by extracted leading number value).
    if (numItems.MaxIndex() > 0) {
        ;;∙------∙Insertion sort by numeric sort key.
        Loop % numItems.MaxIndex() - 1 {
            i := A_Index + 1
            while (i > 1 && numItems[i].sortkey < numItems[i-1].sortkey) {
                temp          := numItems[i]
                numItems[i]   := numItems[i-1]
                numItems[i-1] := temp
                i--
            }
        }
        for _, item in numItems
            result .= (result = "" ? "" : A_Space) . item.prefix . A_Space . item.body
    }

    ;;∙------∙Group 3 - Lettered - (sort by trailing number if present, else by body text).
    if (letItems.MaxIndex() > 0) {
        ;;∙------∙Separate into numeric-keyed and body-keyed sub-groups, 
        ;;∙------∙preserving relative order within each (numeric-keyed emits first).
        numKeyed  := []
        bodyKeyed := []
        for _, item in letItems {
            if item.byNum
                numKeyed.Push(item)
            else
                bodyKeyed.Push(item)
        }
        ;;∙------∙Insertion sort numeric-keyed by trailing number value.
        Loop % numKeyed.MaxIndex() - 1 {
            i := A_Index + 1
            while (i > 1 && numKeyed[i].sortkey < numKeyed[i-1].sortkey) {
                temp          := numKeyed[i]
                numKeyed[i]   := numKeyed[i-1]
                numKeyed[i-1] := temp
                i--
            }
        }
        ;;∙------∙Sort body-keyed by body text, reassigning prefixes in sorted order.
        if (bodyKeyed.MaxIndex() > 0) {
            prefixes := ""
            bodies   := ""
            for _, item in bodyKeyed
            {
                prefixes .= (prefixes = "" ? "" : "`n") . item.prefix
                bodies   .= (bodies   = "" ? "" : "`n") . item.body
            }
            Sort, prefixes, U
            Sort, bodies,   U
            prefixList := StrSplit(prefixes, "`n")
            bodyList   := StrSplit(bodies,   "`n")
            bodyKeyed  := []
            Loop % prefixList.MaxIndex()
                bodyKeyed.Push({prefix: prefixList[A_Index], body: bodyList[A_Index]})
        }
        for _, item in numKeyed
            result .= (result = "" ? "" : A_Space) . item.prefix . A_Space . item.body
        for _, item in bodyKeyed
            result .= (result = "" ? "" : A_Space) . item.prefix . A_Space . item.body
    }
    return result
}
;;∙==============================================∙


;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙



;;∙======∙SCRIPT EDIT / RELOAD / EXIT∙==============∙
;;∙------∙EDIT∙---------------------------∙
Script·Edit:    ;;∙------∙Menu Call.
    Edit
Return

;;∙------∙RELOAD∙-----------------------∙
^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        ;;∙------∙Soundbeep, 1000, 200
    Reload
Return

;;∙------∙EXIT∙----------------------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        ;;∙------∙Soundbeep, 1000, 200
    ExitApp
Return


;;∙======∙SCRIPT UPDATE∙=========================∙
UpdateCheck:    ;;∙------Check if script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload


;;∙======∙TRAY MENU∙=============================∙
TrayMenu:
Menu, Tray, Tip, %ScriptID%
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add

;;∙------∙MENU-EXTENTIONS∙---------∙
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

;;∙------∙MENU-OPTIONS∙-------------∙
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

;;∙------∙EXTENTIONS∙------------------∙
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
;;∙------∙TRAY MENU SHOW∙--------∙
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20
Return

;;∙------∙POSITION FUNTION∙-------∙
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

;;***********************************************
;;****************** SCRIPT END ******************
;;***********************************************

