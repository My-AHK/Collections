



;;∙======∙AUTO-EXE∙==============================∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force
SendMode, Input
SetWorkingDir %A_ScriptDir%


;;∙======∙#INCLUDE FILE(s)∙========================∙
#Include ExampleScript.ahk

SetTimer, UpdateCheck, 500    ;;∙------∙Checks for file modification changes every 500ms.
ScanIncludes()                ;;∙------∙Initial scan of all above #Include files to cache modification times.
;;∙---------------------------------------------------------------------∙


;;∙======∙Simple Gui just for code here∙======∙
F1::
Gui, +AlwaysOnTop -Caption
Gui, Color, Blue
Gui, Font, s14 cYellow Bold
Gui, Add, Text, gHello, HELLO
Gui, Show,, Script Saver
Return

Hello:
    Soundbeep, 400, 800
    Gui, Destroy
Return


;;∙======∙SCAN #INCLUDE FILES∙=====================∙
ScanIncludes() {
    global IncludeTimes
    IncludeTimes := {}
    Loop, Read, % A_ScriptFullPath    ;;∙------∙Reads the current script file line by line.
    {
        Line := Trim(A_LoopReadLine)
        if (SubStr(Line, 1, 8) != "#Include" && SubStr(Line, 1, 8) != "#include")    ;;∙------∙Skip anything that is not an #Include directive.
            Continue
        IncPath := Trim(SubStr(Line, 10))    ;;∙------∙Extract the path portion after "#Include ".
        SemicolonPos := InStr(IncPath, ";")    ;;∙------∙Remove inline comment if present.
        if (SemicolonPos)
            IncPath := Trim(SubStr(IncPath, 1, SemicolonPos - 1))
        if (IncPath = "")    ;;∙------∙Skip empty include lines.
            Continue
        IncPath := StrReplace(IncPath, "%A_ScriptDir%", A_ScriptDir)    ;;∙------∙Resolve %A_ScriptDir% variable if used literally.
        if (SubStr(IncPath, 2, 2) != ":\")    ;;∙------∙Convert relative paths to absolute paths.
            IncPath := A_ScriptDir . "\" . IncPath
        if FileExist(IncPath) {    ;;∙------∙Store last modified time for valid files.
            FileGetTime, t, %IncPath%, M    ;;∙------∙Gets last modified timestamp (M = modification time).
            IncludeTimes[IncPath] := t
        }
    }
}
;;∙======∙RELOAD ON SCRIPT / INCLUDE CHANGES∙======∙
UpdateCheck:
    oldModTime := currentModTime
    FileGetTime, currentModTime, %A_ScriptFullPath%    ;;∙------∙Check if main script file has changed.
    if (oldModTime != currentModTime) && (oldModTime != "")    ;;∙------∙Skip first run comparisonwhen oldModTime is blank on startup.
    {
        SoundBeep, 1700, 100    ;;∙------∙Main script file change detected.
        Reload
    }
    for IncPath, oldTime in IncludeTimes    ;;∙------∙Check each tracked #Include file for modifications.
    {
        FileGetTime, currentTime, %IncPath%
        if (currentTime != oldTime)
        {
            SoundBeep, 1500, 100    ;;∙------∙Included file change detected.
            Reload
        }
    }
Return
;;∙==============================================∙





