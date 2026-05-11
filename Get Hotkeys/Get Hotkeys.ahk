
;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙


/*∙-----------------------------------------------------------------------------------------∙
What this does:
---------------------
1. Prompts to pick any master .ahk file.
2. Looks inside that file's folder & finds all subfolders.
3. Recursively scans all .ahk files inside those subfolders.
4. Extracts hotkeys, dynamic hotkeys, & hotstrings, each in their own section.
5. Ignores all comments (block and inline) to avoid false positives.
6. Groups entries by source file with blank line separation.
7. Annotates context-sensitive hotkeys with their #If condition (all variants).
8. Detects & combination hotkeys including those using named keys.
9. Outputs a combined Key_Map_Inventory.txt, saved either next to the master script or a chosen location.
∙--------------------------------------------------------------------------------------------∙
*/

SetTimer, UpdateCheck, 500
Menu, Tray, Icon, shell32.dll, 105
GoSub, TrayMenu

#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines -1
SetWinDelay 0
SetWorkingDir %A_ScriptDir%

;;∙--------------------------------------------------∙

^t::    ;;∙------∙🔥∙(Ctrl + T)

;;∙--------------------------------------------------∙
;;∙------∙Select master script file.
FileSelectFile, masterScript, 1, , Select the Master AHK Script, AutoHotkey Scripts (*.ahk)
if (masterScript = "") {
    MsgBox,,, No file selected. Exiting.,2
    return
}

;;∙------∙Get directory of master script.
SplitPath, masterScript, masterFileName, masterDir

;;∙------∙Find all subfolders.
subfolders := []
Loop, Files, %masterDir%\*.*, D
{
    subfolders.Push(A_LoopFileFullPath)
}

if (subfolders.MaxIndex() = "") {
    MsgBox,,, No subfolder found in %masterDir%`n`nExiting.,2
    return
}

;;∙------∙Strip inline ; comment from a line, being careful not to strip inside strings.
StripInlineComment(line) {
    pos := 1
    inString := false
    Loop, Parse, line
    {
        char := A_LoopField
        if (char = """")
            inString := !inString
        if (!inString && char = ";") {
            return SubStr(line, 1, pos - 1)
        }
        pos++
    }
    return line
}

;;∙------∙Extract hotkeys from a file.
ExtractHotkeys(filePath, displayName) {
    FileRead, content, %filePath%
    if ErrorLevel
        return ""

    hotkeyList     := ""
    seenHotkeys    := Object()
    inBlock        := false
    currentContext := ""

    ;;∙------∙Modifier prefix: one or more of ~ * $ < > # ^ ! +
    ;;∙------∙< and > are valid AHK side-specific modifiers (e.g. <^ = left Ctrl).
    modPrefix   := "[~*$<>#^!+]+"

    ;;∙------∙Modified key: one or more modifiers followed by one or more alphanumeric chars.
    modifiedKey := "^\s*" . modPrefix . "[a-zA-Z0-9]+"

    ;;∙------∙Named keys that are valid without a modifier prefix.
    namedKey    := "^\s*(F[1-9][0-9]?|LWin|RWin|LAlt|RAlt|LCtrl|RCtrl|LShift|RShift"
        . "|Left|Right|Up|Down|Enter|Space|Tab|Esc|Backspace|Delete|Home|End|PgUp|PgDn"
        . "|Insert|Pause|PrintScreen|ScrollLock|CapsLock|NumLock|AppsKey|Sleep"
        . "|Numpad[0-9]|NumpadEnter|NumpadDot|NumpadDiv|NumpadMult|NumpadSub|NumpadAdd"
        . "|NumpadClear|NumpadIns|NumpadDel|NumpadEnd|NumpadDown|NumpadPgDn"
        . "|NumpadLeft|NumpadRight|NumpadHome|NumpadUp|NumpadPgUp"
        . "|LButton|RButton|MButton|XButton[12]"
        . "|WheelUp|WheelDown|WheelLeft|WheelRight"
        . "|Joy([1-9]|[12][0-9]|3[0-2])|JoyX|JoyY|JoyZ|JoyR|JoyU|JoyV|JoyPOV"
        . "|Browser_\w+|Volume_\w+|Media_\w+)"

    ;;∙------∙Either side of a combination can be a modified/plain key or a named key.
    comboSide   := "(?:[~*$<>#^!+]*(?:F[1-9][0-9]?|LWin|RWin|LAlt|RAlt|LCtrl|RCtrl|LShift|RShift"
        . "|Left|Right|Up|Down|Enter|Space|Tab|Esc|Backspace|Delete|Home|End|PgUp|PgDn"
        . "|Insert|Pause|PrintScreen|ScrollLock|CapsLock|NumLock|AppsKey|Sleep"
        . "|Numpad[0-9]|NumpadEnter|NumpadDot|NumpadDiv|NumpadMult|NumpadSub|NumpadAdd"
        . "|NumpadClear|NumpadIns|NumpadDel|NumpadEnd|NumpadDown|NumpadPgDn"
        . "|NumpadLeft|NumpadRight|NumpadHome|NumpadUp|NumpadPgUp"
        . "|LButton|RButton|MButton|XButton[12]"
        . "|WheelUp|WheelDown|WheelLeft|WheelRight"
        . "|Joy(?:[1-9]|[12][0-9]|3[0-2])|JoyX|JoyY|JoyZ|JoyR|JoyU|JoyV|JoyPOV"
        . "|Browser_\w+|Volume_\w+|Media_\w+|[a-zA-Z0-9]+))"

    comboKey    := "^\s*(" . comboSide . ")\s*&\s*(" . comboSide . ")"

    Loop, Parse, content, `n, `r
    {
        line := A_LoopField

        ;;∙------∙Track block comments.
        if (inBlock) {
            if InStr(line, "*/")
                inBlock := false
            continue
        }
        if InStr(line, "/*") {
            inBlock := true
            continue
        }

        ;;∙------∙Skip full line comments.
        if RegExMatch(line, "^\s*;")
            continue

        ;;∙------∙Strip inline comment.
        line := StripInlineComment(line)

        ;;∙------∙Track all #If context variants.
        if RegExMatch(line, "i)^\s*#IfWinActive\s*(.*)", match) {
            currentContext := "[IfWinActive: " Trim(match1) "]"
            continue
        }
        if RegExMatch(line, "i)^\s*#IfWinNotActive\s*(.*)", match) {
            currentContext := "[IfWinNotActive: " Trim(match1) "]"
            continue
        }
        if RegExMatch(line, "i)^\s*#IfWinExist\s*(.*)", match) {
            currentContext := "[IfWinExist: " Trim(match1) "]"
            continue
        }
        if RegExMatch(line, "i)^\s*#IfWinNotExist\s*(.*)", match) {
            currentContext := "[IfWinNotExist: " Trim(match1) "]"
            continue
        }
        if RegExMatch(line, "i)^\s*#If\s+(.*)", match) {
            currentContext := "[If: " Trim(match1) "]"
            continue
        }
        ;;∙------∙Bare #If with nothing after it closes the context block.
        if RegExMatch(line, "i)^\s*#If\s*$") {
            currentContext := ""
            continue
        }

        ;;∙------∙Skip hotstring lines so they aren't caught as hotkeys.
        if RegExMatch(line, "^\s*:[^:]*:[^:]+::")
            continue

        contextTag := (currentContext != "") ? "  " currentContext : ""

        ;;∙------∙Match combination hotkeys (key1 & key2::).
        if RegExMatch(line, comboKey . "(?:\s+up)?::", match)
        {
            hotkeyName := Trim(match1) " & " Trim(match2)
            if !seenHotkeys.HasKey(hotkeyName) {
                seenHotkeys[hotkeyName] := true
                hotkeyList .= hotkeyName "`t(" displayName ")" contextTag "`n"
            }
            continue
        }

        ;;∙------∙Match standard hotkey definitions.
        if RegExMatch(line, "(" modifiedKey "|" namedKey ")(?:\s+up)?::", match)
        {
            hotkeyName := Trim(match1)
            if !seenHotkeys.HasKey(hotkeyName) {
                seenHotkeys[hotkeyName] := true
                hotkeyList .= hotkeyName "`t(" displayName ")" contextTag "`n"
            }
        }
    }

    return (hotkeyList != "") ? hotkeyList . "`n" : ""
}

;;∙------∙Extract hotstrings from a file.
ExtractHotstrings(filePath, displayName) {
    FileRead, content, %filePath%
    if ErrorLevel
        return ""

    hotstringList  := ""
    seenHotstrings := Object()
    inBlock        := false

    Loop, Parse, content, `n, `r
    {
        line := A_LoopField

        ;;∙------∙Track block comments.
        if (inBlock) {
            if InStr(line, "*/")
                inBlock := false
            continue
        }
        if InStr(line, "/*") {
            inBlock := true
            continue
        }

        ;;∙------∙Skip full line comments.
        if RegExMatch(line, "^\s*;")
            continue

        ;;∙------∙Match hotstrings — do not strip inline comment here as ; may be in replacement.
        if RegExMatch(line, "^\s*:([^:]*):([^:]+)::(.*)", match)
        {
            options     := match1
            trigger     := Trim(match2)
            replacement := Trim(match3)
            displayKey  := ":" options ":" trigger

            if !seenHotstrings.HasKey(displayKey) {
                seenHotstrings[displayKey] := true
                inline := (replacement = "") ? "[block]" : replacement
                hotstringList .= displayKey . "::`t" inline "`t(" displayName ")`n"
            }
        }
    }

    return (hotstringList != "") ? hotstringList . "`n" : ""
}

;;∙------∙Extract Hotkey command calls from a file.
ExtractHotkeyCommands(filePath, displayName) {
    FileRead, content, %filePath%
    if ErrorLevel
        return ""

    literalList  := ""
    dynamicList  := ""
    seenLiteral  := Object()
    seenDynamic  := Object()
    inBlock      := false

    Loop, Parse, content, `n, `r
    {
        line := A_LoopField

        ;;∙------∙Track block comments.
        if (inBlock) {
            if InStr(line, "*/")
                inBlock := false
            continue
        }
        if InStr(line, "/*") {
            inBlock := true
            continue
        }

        ;;∙------∙Skip full line comments.
        if RegExMatch(line, "^\s*;")
            continue

        ;;∙------∙Strip inline comment.
        line := StripInlineComment(line)

        ;;∙------∙Match Hotkey command calls.
        if !RegExMatch(line, "^\s*Hotkey\s*,\s*(.+)", match)
            continue

        keyArg := Trim(match1)

        ;;∙------∙Dynamic: starts with % (variable or expression).
        if RegExMatch(keyArg, "^%") {
            RegExMatch(keyArg, "^([^,]+)", dynMatch)
            dynKey := Trim(dynMatch1)
            if !seenDynamic.HasKey(dynKey) {
                seenDynamic[dynKey] := true
                dynamicList .= "[dynamic]`t" dynKey "`t(" displayName ")`n"
            }
        } else {
            ;;∙------∙Literal: grab key name before the next comma if present.
            RegExMatch(keyArg, "^([^,]+)", litMatch)
            litKey := Trim(litMatch1)
            if !seenLiteral.HasKey(litKey) {
                seenLiteral[litKey] := true
                literalList .= litKey "`t(" displayName ")`n"
            }
        }
    }

    result := ""
    if (literalList != "")
        result .= literalList . "`n"
    if (dynamicList != "")
        result .= dynamicList . "`n"
    return result
}

;;∙------∙Recursive scan all .ahk files.
ScanAllAHKFiles(folderPath, baseFolder, ByRef hotkeyResults, ByRef hotstringResults, ByRef hotkeyCommandResults, ByRef foundAny) {
    Loop, Files, %folderPath%\*.ahk
    {
        relativePath := StrReplace(A_LoopFileFullPath, baseFolder "\")

        extractedHotkeys        := ExtractHotkeys(A_LoopFileFullPath, relativePath)
        extractedHotstrings     := ExtractHotstrings(A_LoopFileFullPath, relativePath)
        extractedHotkeyCommands := ExtractHotkeyCommands(A_LoopFileFullPath, relativePath)

        if (extractedHotkeys != "" || extractedHotstrings != "" || extractedHotkeyCommands != "")
            foundAny := true

        hotkeyResults        .= extractedHotkeys
        hotstringResults     .= extractedHotstrings
        hotkeyCommandResults .= extractedHotkeyCommands
    }

    Loop, Files, %folderPath%\*.*, D
        ScanAllAHKFiles(A_LoopFileFullPath, baseFolder, hotkeyResults, hotstringResults, hotkeyCommandResults, foundAny)
}

;;∙------∙Capture master script results first.
masterHotkeys        := ExtractHotkeys(masterScript, masterFileName)
masterHotstrings     := ExtractHotstrings(masterScript, masterFileName)
masterHotkeyCommands := ExtractHotkeyCommands(masterScript, masterFileName)
foundAny             := (masterHotkeys != "" || masterHotstrings != "" || masterHotkeyCommands != "") ? true : false

;;∙------∙Scan all subfolders once, storing per-subfolder results.
subFolderHotkeys        := []
subFolderHotstrings     := []
subFolderHotkeyCommands := []

for index, subfolder in subfolders {
    subHotkeys        := ""
    subHotstrings     := ""
    subHotkeyCommands := ""
    foundAnySub       := false
    ScanAllAHKFiles(subfolder, subfolder, subHotkeys, subHotstrings, subHotkeyCommands, foundAnySub)
    subFolderHotkeys[index]        := subHotkeys
    subFolderHotstrings[index]     := subHotstrings
    subFolderHotkeyCommands[index] := subHotkeyCommands
    if (foundAnySub)
        foundAny := true
}

;;∙------∙Check if anything was found.
if (!foundAny) {
    MsgBox,,, No hotkeys, hotstrings, or Hotkey commands found in any scripts.`n`nMake sure your scripts have entries like:`n^c::`n#z::`n::btw::by the way`nHotkey, ^z, handler`netc.,7
    return
}

;;∙------∙Build report.
report := "Key Map Inventory`n==============`nGenerated: " A_Now "`n"

;;∙------∙Hotkeys section.
report .= "`n∙====∙ HOTKEYS ∙====∙`n`n"

report .= "Master Script (from: " masterDir "):`n"
report .= "-------------------------------------------`n"
report .= (masterHotkeys != "") ? masterHotkeys : "(none)`n"

for index, subfolder in subfolders {
    report .= "`nChild Scripts (recursive from: " subfolder "):`n"
    report .= "-------------------------------------------`n"
    report .= (subFolderHotkeys[index] != "") ? subFolderHotkeys[index] : "(none)`n"
}

;;∙------∙Dynamic Hotkeys section.
report .= "`n∙====∙ DYNAMIC HOTKEYS (Hotkey Command) ∙====∙`n`n"

report .= "Master Script (from: " masterDir "):`n"
report .= "-------------------------------------------`n"
report .= (masterHotkeyCommands != "") ? masterHotkeyCommands : "(none)`n"

for index, subfolder in subfolders {
    report .= "`nChild Scripts (recursive from: " subfolder "):`n"
    report .= "-------------------------------------------`n"
    report .= (subFolderHotkeyCommands[index] != "") ? subFolderHotkeyCommands[index] : "(none)`n"
}

;;∙------∙Hotstrings section.
report .= "`n∙====∙ HOTSTRINGS ∙====∙`n`n"

report .= "Master Script (from: " masterDir "):`n"
report .= "-------------------------------------------`n"
report .= (masterHotstrings != "") ? masterHotstrings : "(none)`n"

for index, subfolder in subfolders {
    report .= "`nChild Scripts (recursive from: " subfolder "):`n"
    report .= "-------------------------------------------`n"
    report .= (subFolderHotstrings[index] != "") ? subFolderHotstrings[index] : "(none)`n"
}

;;∙------∙Ask where to save.
MsgBox, 3, Save Location, Where would you like to save the Key Map Inventory list?`n`nYes = Same folder as master script`nNo = Choose a location`nCancel = Exit
IfMsgBox, Yes
    outputFile := masterDir "\Key_Map_Inventory.txt"
Else IfMsgBox, No
{
    FileSelectFile, outputFile, S16, %A_Desktop%\Key_Map_Inventory.txt, Save Key Map Inventory As, Text Files (*.txt)
    if (outputFile = "")
        return
}
Else
    return

;;∙------∙Try to save.
FileDelete, %outputFile%
FileAppend, %report%, %outputFile%

if ErrorLevel {
    If (InStr(outputFile, "C:\Program Files") = 1) {
        MsgBox, 3, Admin Required, Cannot save to Program Files without administrator privileges.`n`nWould you like to:`nYes = Relaunch as Admin`nNo = Save to Desktop instead`nCancel = Cancel
        IfMsgBox, Yes
        {
            if not A_IsAdmin
                Run *RunAs "%A_AhkPath%" "%A_ScriptFullPath%"
            ExitApp
        }
        Else IfMsgBox, No
        {
            desktopFile := A_Desktop "\Key_Map_Inventory.txt"
            FileDelete, %desktopFile%
            FileAppend, %report%, %desktopFile%
            if !ErrorLevel
                MsgBox, Saved to Desktop instead:`n%desktopFile%
            else
                MsgBox, Could not save to Desktop either.
        }
        Else IfMsgBox, Cancel
        {
            MsgBox, Save cancelled.
        }
    }
    Else {
        MsgBox, Error saving file!`n`nAttempted to save to:`n%outputFile%
    }
} else {
    MsgBox,,, Key Map Inventory saved to:`n%outputFile%,4
}
Return
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
Menu, Tray, Tip, Get Key Map`n  Inventory
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
return True
}
Return
;;∙==============================================∙


;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙

