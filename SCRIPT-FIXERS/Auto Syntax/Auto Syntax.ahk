
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙--------∙Origins∙-------------------------∙
» Author:  tuzi (v3)
» Source:  https://www.autohotkey.com/boards/viewtopic.php?t=85707#p376284
» Original Source:  
» 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TEMPLATE"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
ScriptName := "Auto∙Syntax"

maxW := "270"    ;;∙------∙Gui Width.
maxH := "565"    ;;∙------∙Gui Height.

boxW := "250"    ;;∙------∙GroupBox Widths.
infoBoxW := "250"    ;;∙------∙Information & DropBox Width.
infoBoxH := "275"    ;;∙------∙Information & DropBox Height.

fnt := "Segoe UI"    ;;∙------∙Font.
GuiColor := "0D0D0D"    ;;∙------∙Gui Background Color.
fontColor1 := "SILVER"    ;;∙------∙Gui Primary Font Color.
; fontColor2 := "006780"    ;;∙------∙EditBox Text Color.
fontColor2 := "000000"    ;;∙------∙EditBox Text Color.
fontColor3 := "003DFF"    ;;∙------∙Legends Text Color.

dropBoxFontColor := "008067"    ;;∙------∙Information & DropBox Text Color.

CautionT := "666666"    ;;∙------∙Caution Text Color.

reloadIcon := "239"    ;;∙------∙Reload Icon.
reloadIconDll := "shell32.dll"    ;;∙------∙Reload Icon Location.

exitIcon := "11"    ;;∙------∙Exit Icon.
exitIconDll := "comres.dll"    ;;∙------∙Exit Icon Location.

xCoord1 := maxW-55    ;;∙------∙Reload button x-axis position. (subtracts from right Gui edge)
xCoord2 := maxW-30    ;;∙------∙Exit button x-axis position. (subtracts from right Gui edge)

;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙

;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙------∙Process command line parameters 
If %0%{
    Loop, %0% {    ;;∙------∙for each command line parameter.
        next := A_Index + 1    ;;∙------∙get next parameters number.
;;∙------∙check if known command line parameter exists.
        If (%A_Index% = "/in")
            param_in := %next%    ;;∙------∙assign next command line parameter as value.
        Else If (%A_Index% = "/log")
            param_log := %next%
        Else If (%A_Index% = "/hidden")
            param_hidden = Hide
        Else If (%A_Index% = "/watch"){
            param_hidden = Hide
            param_watch := %next%
        }Else If (%A_Index% = "/Toggle")
            Gosub, CheckAndToggleRunState
    }
}
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================*
;;∙------∙Turn DebugMode on (=1) to show MsgBox with Debug Info.
DebugMode = 0

SplitPath, A_ScriptName, , , , OutNameNoExt
IniFile = %OutNameNoExt%.ini
Gosub, ReadDataFromIni

;;∙------∙find path to AHK
;;∙------∙Pin the working directory to the script directory, and the Syntax folder is naturally fixed in it.
AHKPath:=A_ScriptDir
IfNotExist %AHKPath%
{ MsgBox,,, Could not find the AutoHotkey folder.`nPlease edit the script:`n%A_ScriptFullPath%`nin Linenumber: %A_LineNumber%
    ExitApp
}
Gosub, ReadSyntaxFiles
If FileExist(param_in){
    Gosub, IndentFile
    ExitApp
}
Gosub, BuildGui
If param_watch
    SetTimer, WatchWindow, On
;;∙------∙Disable hotkey in its own gui.
Hotkey, IfWinNotActive, %GuiUniqueID%
;;∙------∙Set hotkey and remember it.
Hotkey, %OwnHotKey%, IndentHighlightedText
OldHtk = %OwnHotKey%
Hotkey, IfWinNotActive,
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Toogle debug mode =====================================∙
^d::
    DebugMode := not DebugMode
    ToolTip, DebugMode = %DebugMode%
    Sleep, 1000
    ToolTip
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Close script when watch window doesn't exist ===============∙
WatchWindow:
    DetectHiddenWindows, On
    If !WinExist("ahk_id " param_watch)    ;;∙------∙Check if watch window exists.
        Gosub, GuiClose    ;;∙------∙If not close this script.
    DetectHiddenWindows, Off
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Toggle run status - Close on second run =====================∙
CheckAndToggleRunState:
;;∙------∙Get own PID.
    Process, Exist
    OwnPID := ErrorLevel

;;∙------∙Get own title.
    If A_IsCompiled
        OwnTitle := A_ScriptFullPath
    Else
        OwnTitle := A_ScriptFullPath " - AutoHotkey v" A_AhkVersion

;;∙------∙Get list of all windows.
    DetectHiddenWindows, On
    WinGet, WinIDs, List

;;∙------∙Go through list and get their titles.
    Loop, %WinIDs% {
        UniqueID := "ahk_id " WinIDs%A_Index%
        WinGetTitle, winTitle, %UniqueID%

;;∙------∙Check if there is a window with the same title as this script but not itself.
        If (winTitle = OwnTitle ) {
            WinGet, winPID, PID, %UniqueID%
            If (winPID <> OwnPID) {
;;∙------∙Close it and itself.
                Process, Close, %winPID%
                ExitApp
            }
        }
    }
    DetectHiddenWindows, off
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Read directives and commands from syntax file ==============∙
ReadSyntaxFiles:
;;∙------∙Path to syntax files.
PathSyntaxFiles = %AHKPath%\SyntaxFiles

;;∙------∙Clear lists.
ListOfDirectives =
;;∙------∙This list reads commands like IfInString from the file that start with If, and then indents them. feature #1.
;;∙------∙Therefore, you can directly add process commands that are not supported in the later stage to this and let the program recognize them for indentation.
;;∙------∙I didn't think of this when I changed the indentation of for...
    ListOfIFCommands = ,for,while,try,catch,finally,switch,class

;;∙------∙Read each line of syntax file and search for directives and if-keywords.
    CommandNamesFile = %PathSyntaxFiles%\CommandNames.txt
    IfNotExist %CommandNamesFile%
    { MsgBox,,, Could not find the "CommandNames.txt" file.`nPlease edit the script:`n%A_ScriptFullPath%`nin Linenumber: %A_LineNumber%
        ExitApp
    }
    Loop, Read , %CommandNamesFile%   ;;∙------∙Read syntax file.
    {    ;;∙------∙Remove spaces from read line.
        Line = %A_LoopReadLine%
        Line:=Trim(Line, " `t`r`n`v`f")

;;∙------∙Get first character and first 2 characters of line.
        StringLeft,FirstChar, Line ,1
        StringLeft,FirstTwoChars, Line ,2

;;∙------∙If line is comment, continue with next line.
        If (FirstChar = ";")
            Continue
;;∙------∙Otherwise if keyword is directive or if-keyword add it to list.
        Else If (FirstChar = "#")
            ListOfDirectives=%ListOfDirectives%,%Line%
        Else If (FirstTwoChars = "if") {
;;∙------∙Get first word, since If-keywords in the syntax file have more words.
            StringSplit, Array, Line, %A_Space%
            Line = %Array1%
            If (StrLen(Line) > 4)
                ListOfIFCommands=%ListOfIFCommands%,%Line%
        }
    }
;;∙------∙Remove first comma and change to lower char.
    StringTrimLeft,ListOfIFCommands,ListOfIFCommands,1
    StringTrimLeft,ListOfDirectives,ListOfDirectives,1

;;∙------∙Remove multiple If.
    Sort, ListOfIFCommands, U D,

    FilesSyntax = CommandNames|Keywords|Keys|Variables

;;∙------∙Loop over all syntax files.
    Loop, Parse, FilesSyntax, |
    { String =
        SyntaxFile = %PathSyntaxFiles%\%A_LoopField%.txt
        IfNotExist %SyntaxFile%
        { MsgBox,,, Could not find the syntax file "%A_LoopField%.txt".`nPlease edit the script:`n%A_ScriptFullPath%`nin Linenumber: %A_LineNumber%
            ExitApp
        }
        filename:=A_LoopField
;;∙------∙Read each line of syntax file.
        Loop, Read , %SyntaxFile%
        {
;;∙------∙Remove spaces from read line.
            Line = %A_LoopReadLine%
            Line:=Trim(Line, " `t`r`n`v`f")

;;∙------∙Get first character, length of line and look for spaces.
            StringLeft,FirstChar, Line ,1

;;∙------∙If line contains spaces, continue with next line
            If InStr(Line," ")
                Continue
;;∙------∙If line is empty, continue with next line
            Else If Line is Space
                Continue
 ;;∙------∙If line is comment, continue with next line
            Else If (FirstChar = ";")
                Continue
            Else If (StrLen(Line) > 4 or filename="Variables")
                String = %String%,%Line%
        }
;;∙------∙Remove first pipe
        StringTrimLeft,String,String,1
;;∙------∙Store remembered string in var which has same name as syntaxfile
        %A_LoopField% := String
    }

;;∙------∙None of the words here are added to the list
    CommandNames = %CommandNames%,Gui,Run,Edit,Exit,goto,Send,Sort,Menu
                                    ,Files,Reg,Parse,Read,Mouse,SendAndMouse,Permit,Screen,Relative
                                    ,Pixel,Toggle,UseErrorLevel,AlwaysOn,AlwaysOff

;;∙------∙Read in all function names
    BuildInFunctions =
;;∙------∙Read each line of syntax file
    FunctionsFile = %PathSyntaxFiles%\Functions.txt
    IfNotExist %SyntaxFile%
    { MsgBox,,, Could not find the "Functions.txt" file.`nPlease edit the script:`n%A_ScriptFullPath%`nin Linenumber: %A_LineNumber%
        ExitApp
    }
    Loop, Read , %FunctionsFile%
    { Line = %A_LoopReadLine%
        Line:=Trim(Line, " `t`r`n`v`f")

;;∙------∙get first character, length of line and look for spaces
        StringLeft,FirstChar, Line ,1

;;∙------∙if line contains spaces, continue with next line
        If InStr(Line," ")
            Continue
;;∙------∙if line is empty, continue with next line
        Else If Line is Space
            Continue
;;∙------∙if line is comment, continue with next line
        Else If (FirstChar = ";")
            Continue
;;∙------∙otherwise remember word
        BuildInFunctions = %BuildInFunctions%,%Line%
    }
;;∙------∙remove first pipe
    StringTrimLeft,BuildInFunctions,BuildInFunctions,1

;;∙------∙Output debugging info if enabled
    If DebugMode{
        MsgBox, ListOfDirectives=%ListOfDirectives%`nListOfIFCommands=%ListOfIFCommands%`nCommandNames=%CommandNames%`nBuildInFunctions=%BuildInFunctions%
        ExitApp
    }
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Read Data from Ini file ===================================∙
ReadDataFromIni:
    IniRead, Extension, %IniFile%, Settings, Extension, -Syntaxed.ahk
    IniRead, Indentation, %IniFile%, Settings, Indentation, 1
    IniRead, NumberSpaces, %IniFile%, Settings, NumberSpaces, 4
    IniRead, NumberIndentCont, %IniFile%, Settings, NumberIndentCont, 1
    IniRead, IndentCont, %IniFile%, Settings, IndentCont, 1
    IniRead, Style, %IniFile%, Settings, Style, 1
    IniRead, CaseCorrectCommands, %IniFile%, Settings, CaseCorrectCommands, 1
    IniRead, CaseCorrectVariables, %IniFile%, Settings, CaseCorrectVariables, 1
    IniRead, CaseCorrectBuildInFunctions, %IniFile%, Settings, CaseCorrectBuildInFunctions, 1
    IniRead, CaseCorrectKeys, %IniFile%, Settings, CaseCorrectKeys, 1
    IniRead, CaseCorrectKeywords, %IniFile%, Settings, CaseCorrectKeywords, 0
    IniRead, CaseCorrectDirectives, %IniFile%, Settings, CaseCorrectDirectives, 1
    IniRead, Statistic, %IniFile%, Settings, Statistic, 1
    IniRead, ChkSpecialTabIndent, %IniFile%, Settings, ChkSpecialTabIndent, 1
    IniRead, KeepBlockCommentIndent, %IniFile%, Settings, KeepBlockCommentIndent, 0
    IniRead, AHKPath, %IniFile%, Settings, AHKPath, %A_Space%
    IniRead, OwnHotKey, %IniFile%, Settings, OwnHotKey, ^F2
Return

OwnHotKey:
;;∙------∙Deacticate old hotkey.
    Hotkey, IfWinNotActive, %GuiUniqueID%
    Hotkey, %OldHtk%, IndentHighlightedText, Off
;;∙------∙Don't allow no hotkey.
    If OwnHotKey is Space
    {
        Hotkey, %OldHtk%, IndentHighlightedText
        GuiControl, , OwnHotKey, %OldHtk%
    }Else{
        Hotkey, %OwnHotKey%, IndentHighlightedText
        OldHtk = %OwnHotKey%
    }
    Hotkey, IfWinNotActive,
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Build GUI for Auto-Syntax-Tidy ============================∙
BuildGui:
    LogText = 
(

------------------------------------------------------
    Drop Your Script For Auto∙Syntax Here

                              - Or -

    Highlight Your AHK Code In The Script
                     And Press... 
                                         %OwnHotKey%
------------------------------------------------------
)
Gui, +AlwaysOnTop -Caption +Border
Gui, Color, %GuiColor%
Gui, Font, c%fontColor1% q5, %fnt%
Gui, Add, Text, xm y15 BackgroundTrans Section ,Preferred Hotkey
Gui, Add, Hotkey, x+5 ys-3 r1 w105 vOwnHotKey gOwnHotKey, %OwnHotKey%

Gui, Add, Picture, ys-8 HwndhText vReloadImage gReloadAS w20 h20 Icon%reloadIcon%, %reloadIconDll%
        GuiTip(hText, " RELOAD`n  SCRIPT")
GuiControl, Move, ReloadImage, x%xCoord1%
Gui, Add, Picture, ys-8 HwndhText vExitImage gExitAS w21 h21 Icon%exitIcon%, %exitIconDll%
        GuiTip(hText, "   EXIT`nSCRIPT")
GuiControl, Move, ExitImage, x%xCoord2%



Gui, Add, Text, xm+1 BackgroundTrans Section ,Extension for new file
Gui, Font, c%fontColor2%
Gui, Add, Edit, x+5 ys r1 w130 vExtension, %Extension%
Gui, Font, c%fontColor1%

Gui, Add, GroupBox, xm w%boxW% r7.5,Indentation
Gui, Add, Text, xp+8 yp+20 BackgroundTrans Section,Type:
Gui, Add, Radio, ys vIndentation, 1x∙Tab   or
Gui, Add, Radio, ys Checked, Spaces
Gui, Font, c%fontColor2%
Gui, Add, Edit, ys-3 r1 Limit1 Number w22 vNumberSpaces, %NumberSpaces%
Gui, Font, c%fontColor1%

Gui, Add, Text, xs BackgroundTrans Section,Style:
Gui, Font, c%fontColor3%
Gui, Add, Radio, x+9 ys vStyle, Rajat
Gui, Add, Radio, x+8 ys Checked, Toralf
 Gui, Add, Radio, x+8 ys , BoBo
Gui, Font, c%fontColor1%

Gui, Add, Text, xs y+10 BackgroundTrans Section,Indentation of Method1 continuation Lines:
Gui, Font, c%fontColor2%
Gui, Add, Edit, xs+5 ys+20 Section r1 Limit2 Number w22 vNumberIndentCont, %NumberIndentCont%
Gui, Font, c%fontColor1%
Gui, Add, Radio, x+10 ys+4 vIndentCont , Tabs      or
Gui, Add, Radio, ys+4 Checked, Spaces
Gui, Add, Checkbox, xs y+15 vKeepBlockCommentIndent Checked%KeepBlockCommentIndent%, Preserve indent in Block comments
Gui, Add, Checkbox, xs y+7 vChkSpecialTabIndent Checked%ChkSpecialTabIndent%, Special "Gui,Tab" indent

Gui, Add, GroupBox, xm w%boxW% r4.8,Case-Corrections 
Gui, Font, c%CautionT% Italic

Gui, Add, Text, xp yp+15 BackgroundTrans Section,
    (
%A_space%                     Use With Caution!!
            Some Commands Are Case Sensitive
    )

Gui, Font, c%fontColor1% Norm
Gui, Add, Checkbox, xp+15 y+5 Section vCaseCorrectCommands %CaseCorrectCommands%,Commands
Gui, Add, Checkbox, y+7 vCaseCorrectVariables %CaseCorrectVariables%,Variables
Gui, Add, Checkbox, y+7 vCaseCorrectBuildInFunctions %CaseCorrectBuildInFunctions%,Build in functions
Gui, Add, Checkbox, ys vCaseCorrectKeys %CaseCorrectKeys%,Keys
Gui, Add, Checkbox, y+7 vCaseCorrectKeywords %CaseCorrectKeywords%,Keywords
Gui, Add, Checkbox, y+7 vCaseCorrectDirectives %CaseCorrectDirectives%,Directives

Gui, Add, Text, x-5 y+25 BackgroundTrans Section, `tInformation
Gui, Add, Checkbox, x42 y+5 vStatistic Checked%Statistic%, Statistics

Gui, Add, Text, x+30 ys BackgroundTrans, INI File Hidden:
Gui, Add, Checkbox, vHideCheckbox gToggleHidden, Hide INI File
FileGetAttrib, FileAttributes, %IniFile%
    IfInString, FileAttributes, H
    {
        GuiControl,, HideCheckbox, 1
    }

Gui, Font, c%dropBoxFontColor%
Gui, Add, Edit, xm y+10 r11 w%infoBoxW% vlog ReadOnly, %LogText%
    If (Indentation = 1)
        GuiControl,,1x∙Tab   or,1
    If (Style = 1)
        GuiControl,,Rajat,1
    Else If (Style = 3)
        GuiControl,,BoBo,1
    If (IndentCont = 1)
        GuiControl,, IndentCont, 1

;;∙------∙Get previous position and show Gui.
IniRead, Pos_Gui, %IniFile%, General, Pos_Gui, Center
Gui, Show, %Pos_Gui% %param_Hidden% w%maxW% h%maxH%, %ScriptName%
Gui, +LastFound
GuiUniqueID := "ahk_id " WinExist()

;;∙------∙Get classNN of log control.
    GuiControl, Focus, Log
    ControlGetFocus, ClassLog, %GuiUniqueID%
    GuiControl, Focus, Extension
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Toggle show / hide of Gui from tray icon ====================∙
ShowHideGui:
    If param_Hidden {
        Gui, Show
        param_Hidden =
    }Else{
        param_Hidden = Hide
        Gui, Show, %param_Hidden%
    }
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Function iif: returns a or b depending on expression ==========∙
iif(exp,a,b=""){
    If exp
        Return a
    Return b
}

;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Shortcut F? - indent highlighted text =======================∙
IndentHighlightedText:
;;∙------∙Store time for speed measurement.
    StartTime = %A_TickCount%

;;∙------∙Save and clear clipboard.
    ClipSaved := ClipboardAll
    Clipboard =
    Sleep, 50

;;∙------∙Cut highlight to clipboard.
    Send, ^c

;;∙------∙Get window UID of current window.
    WinUniqueID := WinExist("A")

;;∙------∙If nothing is highlighted, select all and copy.
    If Clipboard is Space
    {    ;;∙------∙Select all and copy to clipboard.
        Send, ^a^c
    }

;;∙------∙Get rid of all carriage returns (`r).
    StringReplace, ClipboardString, Clipboard, `r`n, `n, All

;;∙------∙Restore the original clipboard and free memory.
    Clipboard := ClipSaved
    ClipSaved =

;;∙------∙If something is selected, do the indentation and put it back in again.
    If ClipboardString is Space
        MsgBox, 0 , %ScriptName%,
    (LTrim
        Couldn't get anything to indent.
        Please try again.
    ), 1
    Else {
;;∙------∙Get Options.
        Gui, Submit, NoHide

;;∙------∙Create progress bar and block input.
        StringReplace, x, ClipboardString, `n, `n, All UseErrorLevel
        NumberOfLines = %ErrorLevel%
        Progress, R0-%NumberOfLines% FM10 WM8000 FS8 WS400, `n, Please wait`, Auto-Syntax is Running, %ScriptName%
        BlockInput, On

;;∙------∙Set words for case correction.
        Gosub, SetCaseCorrectionSyntax

;;∙------∙Create indentation.
        Gosub, CreateIndentSize

;;∙------∙Reset all values.
        Gosub, SetStartValues

;;∙------∙Read each line form clipboard.
        Loop, Parse, ClipboardString, `n
        {    ;;∙------∙Remember original line with its identation.
            AutoTrim, Off
            Original_Line = %A_LoopField%
            AutoTrim, On

;;∙------∙Do the indentation.
            Gosub, DoSyntaxIndentation

;;∙------∙Update progress bar every 10th line.
            If (Mod(A_Index, 10)=0)
                Progress, %A_Index%, Line: %A_Index% of %NumberOfLines%
        }

        CaseCorrectSubsAndFuncNames()

;;∙------∙Remove last `n.
        StringTrimRight,String,String,1

;;∙------∙Save and clear clipboard.
        ClipSaved := ClipboardAll
        Clipboard =
        Sleep, 50

;;∙------∙Put String into clipboard.
;;∙------∙StringReplace, String, String, `n, `r`n, All
        Clipboard = %String%

;;∙------∙Close progress bar and activate old window again.
        Progress, Off
        WinActivate, ahk_id %WinUniqueID%

;;∙------∙Paste clipboard.
        Send, ^v{HOME}
;;∙------∙Restore the original clipboard and free memory.
        Clipboard := ClipSaved
        ClipSaved =

;;∙------∙Turn off block input.
        BlockInput, Off

;;∙------∙Write information.
        LogText = %LogText%Indentation done for text in editor.`n
        If Statistic
            Gosub, AddStatisticToLog
        Else
            LogText = %LogText%`n
        GuiControl, ,Log , %LogText%
        ControlSend, %ClassLog%, ^{End}, %GuiUniqueID%
    }
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Set words for case correction =============================∙
/*
The principle of case correction is to use each word in the "CaseCorrectionSyntax" list to correct each word in turn.
So change their priority, from lowest to highest, Keywords, Keys, Variables, CommandNames, ListOfDirectives
If there is duplication between a low-level and a high-level word, it will always be overwritten by the higher-level.
For example, if the word "click" exists in Keys, and the word "click" exists in CommandNames, then the case will eventually be corrected to the latter. feature #4
The reason for this design is that there are a lot of duplicate words in Keywords that are duplicated with other files, and instead of manually marking them and commenting them out, you can now simply update the file.
At the same time, without independent identification of word attributes, it should also be treated with such a priority (the latter overrides the former).
*/

SetCaseCorrectionSyntax:
    CaseCorrectionSyntax:=""
    If CaseCorrectKeywords
        CaseCorrectionSyntax.="," Keywords
    If CaseCorrectKeys
        CaseCorrectionSyntax.="," Keys
    If CaseCorrectVariables
        CaseCorrectionSyntax.="," Variables
    If CaseCorrectCommands
        CaseCorrectionSyntax.="," CommandNames
    If CaseCorrectDirectives
        CaseCorrectionSyntax.="," ListOfDirectives
;;∙------∙Remove first pipe.
    StringTrimLeft, CaseCorrectionSyntax, CaseCorrectionSyntax, 1
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Create indentation size depending on options ===============∙
CreateIndentSize:
;;∙------∙Clear.
    IndentSize =
    IndentContLine =

;;∙------∙Turn of autotrim to be able to assign Spaces and tabs.
    AutoTrim, Off

;;∙------∙Create indentation size depending on option.
    If Indentation = 1
        IndentSize = %A_Tab%
    Else
        Loop, %NumberSpaces%
            IndentSize = %IndentSize%%A_Space%

;;∙------∙Create indentation for line continuation.
    If IndentCont = 1
        Loop, %NumberIndentCont%
            IndentContLine = %IndentContLine%%A_Tab%
    Else
        Loop, %NumberIndentCont%
            IndentContLine = %IndentContLine%%A_Space%

;;∙------∙Set autotrim to default.
    AutoTrim, On
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Reset all start values =====================================∙
SetStartValues:
    String =    ;;∙------∙String that holds temporarely the file content (with auto-indentation).
    Indent =    ;;∙------∙Indentation string.
    IndentIndex = 0    ;;∙------∙Index of array IndentIncrement and IndentCommand.
    InBlockComment := False    ;;∙------∙Status if loop is in a Blockcomment.
    InsideContinuation := False
    InsideTab = 0
    EmptyLineCount = 0    ;;∙------∙Counts the Number of empty Lines for statistics.
    TotalLineCount = 0    ;;∙------∙Counts the Number of total Lines for statistics.
    CommentLineCount = 0    ;;∙------∙Counts the Number of comments Lines for statistics.
    If CaseCorrectBuildInFunctions
        CaseCorrectFuncList = %BuildInFunctions%    ;;∙------∙CSV list of function names in current script including build in functions.
    Else
        CaseCorrectFuncList =    ;;∙------∙CSV list of function names in current script.
    CaseCorrectSubsList=    ;;∙------∙CSV list of subroutine names in current script.
    Loop, 11{
        IndentIncrement%A_Index% =
        IndentCommand%A_Index% =
    }
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Indent all dropped files ==================================∙
GuiDropFiles:
;;∙------∙Store time for speed measurement.
    OverAllStartTime = %A_TickCount%

;;∙------∙Get options.
    Gui, Submit,NoHide

;;∙------∙Set words for case correction.
    Gosub, SetCaseCorrectionSyntax

;;∙------∙Create indentation..
    Gosub, CreateIndentSize

    OverAllCodeLineCount = 0
    OverAllTotalLineCount = 0
    OverAllCommentLineCount = 0
    OverAllCommentLineCount = 0

;;∙------∙For each dropped file, read file line by line and indent each line.
    Loop, Parse, A_GuiControlEvent, `n
    {    ;;∙------∙Store time for speed measurement.
        StartTime = %A_TickCount%

;;∙------∙File.
        FileToautoIndent = %A_LoopField%

;;∙------∙Reset start values.
        Gosub, SetStartValues

;;∙------∙Read each line in the file and do indentation.
        Loop, Read, %FileToautoIndent%
        {    ;;∙------∙Remember original line with its identation.
            AutoTrim, Off
            Original_Line = %A_LoopReadLine%
            AutoTrim, On

;;∙------∙Do indentation.
            Gosub, DoSyntaxIndentation
        }

        CaseCorrectSubsAndFuncNames()

;;∙------∙Paste file with auto-indentation into new file.
;;∙------∙If Extension is empty, old file will be overwritten.
        FileDelete, %FileToautoIndent%%Extension%
        FileAppend, %String%,%FileToautoIndent%%Extension%

;;∙------∙Write information.
        LogText = %LogText%`nIndentation done for:`n %FileToautoIndent%`n
        If Statistic
            Gosub, AddStatisticToLog
        Else
            LogText = %LogText%`n
        GuiControl, ,Log , %LogText%
        ControlSend, %ClassLog%, ^{End}, %GuiUniqueID%
    }
    If Statistic {
        LogText = %LogText%=====Statistics:=======`n
        LogText = %LogText%=====over all files====`n
        LogText = %LogText%Lines with code: %A_Tab%%A_Tab%%OverAllCodeLineCount%`n
        LogText = %LogText%Lines with comments: %A_Tab%%OverAllCommentLineCount%`n
        LogText = %LogText%Empty Lines: %A_Tab%%A_Tab%%OverAllEmptyLineCount%`n
        LogText = %LogText%Total Number of Lines: %A_Tab%%OverAllTotalLineCount%`n
;;∙------∙Time for speed measurement.
        OverAllTimeNeeded := (A_TickCount - OverAllStartTime) / 1000
        LogText = %LogText%Total Process time: %A_Tab%%OverAllTimeNeeded%[s]`n`n
        GuiControl, ,Log , %LogText%
        ControlSend, %ClassLog%, ^{End}, %GuiUniqueID%
    }
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Add statistics to log =====================================∙
AddStatisticToLog:
;;∙------∙Calculate lines of code.
    CodeLineCount := TotalLineCount - CommentLineCount - EmptyLineCount

    OverAllCodeLineCount    += CodeLineCount
    OverAllTotalLineCount   += TotalLineCount
    OverAllCommentLineCount += CommentLineCount
    OverAllEmptyLineCount   += EmptyLineCount

;;∙------∙Add information.
    LogText = %LogText%=====Statistics:=====`n
    LogText = %LogText%Lines with code: %A_Tab%%A_Tab%%CodeLineCount%`n
    LogText = %LogText%Lines with comments: %A_Tab%%CommentLineCount%`n
    LogText = %LogText%Empty Lines: %A_Tab%%A_Tab%%EmptyLineCount%`n
    LogText = %LogText%Total Number of Lines: %A_Tab%%TotalLineCount%`n
;;∙------∙Time for speed measurement.
    TimeNeeded := (A_TickCount - StartTime) / 1000
    LogText = %LogText%Process time: %A_Tab%%TimeNeeded%[s]`n`n
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Indent file from command line ============================∙
IndentFile:
;;∙------∙Set words for case correction.
    Gosub, SetCaseCorrectionSyntax

;;∙------∙Create indentation.
    Gosub, CreateIndentSize

;;∙------∙File.
    FileToautoIndent = %param_in%

;;∙------∙Reset start values.
    Gosub, SetStartValues

;;∙------∙Read each line in the file and do indentation.
    Loop, Read, %FileToautoIndent%
    {    ;;∙------∙Remember original line with its identation.
        AutoTrim, Off
        Original_Line = %A_LoopReadLine%
        AutoTrim, On

 ;;∙------∙Do indentation.
        Gosub, DoSyntaxIndentation
    }

    CaseCorrectSubsAndFuncNames()

;;∙------∙Remove old file and paste with auto-indentation into same file.
    FileDelete, %FileToautoIndent%
    FileAppend, %String%, %FileToautoIndent%

;;∙------∙Write information to log file.
    LogText = Indentation done for: %FileToautoIndent%`n
    If Statistic
        Gosub, AddStatisticToLog
    FileAppend , %LogText%, %param_log%
Return

;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Create indentation for next loop depending on IndentIndex ====∙
SetIndentForNextLoop:
;;∙------∙Clear.
    Indent =
    If IndentIndex < 0    ;;∙------∙In case something went wrong.
        IndentIndex = 0

;;∙------∙Turn AutoTrim off, to be able to process tabs and spaces.
    AutoTrim, Off

;;∙------∙Create indentation depending on IndentIndex.
    Loop, %IndentIndex% {
        Increments := IndentIncrement%A_Index%
        Loop, %Increments%
            Indent = %Indent%%IndentSize%
    }

;;∙------∙Turn AutoTrim on, to remove leading and trailing tabs and spaces.
    AutoTrim, On
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Strip comments from Line ================================∙
StripCommentsFromLine(Line) {
    StartPos = 1
    Loop {
        StartPos := InStr(Line,";","",StartPos + 1)
        If (StartPos > 1) {
            StringMid,CharBeforeSemiColon, Line, StartPos - 1 , 1
            If (CharBeforeSemiColon = "``")    ;;∙------∙semicolon is Escaped
                Continue
            Else If ( 0 < InStr(Line,":=") AND InStr(Line,":=") < StartPos
                                            AND 0 < InStr(Line,"""") AND InStr(Line,"""") < StartPos
                                            AND 0 < InStr(Line,"""","",StartPos) )   ;;∙------∙It on the right side of an := expression and surounded with "..."
                Continue
            Else If ( 0 < InStr(Line,"(") AND InStr(Line,"(") < StartPos
                                            AND InStr(Line,")","",StartPos) > StartPos
                                            AND 0 < InStr(Line,"""") AND InStr(Line,"""") < StartPos
                                            AND 0 < InStr(Line,"""","",StartPos) )    ;;∙------∙It is inside and () expression and surounded with "..."
                Continue
            Else {    ;;∙------∙It is a semicolon.
                StringLeft, Line, Line, StartPos - 1   ;;∙------∙Get CommandLine up to semicolon.
                Line = %Line%    ;;∙------∙Remove Spaces.
				Return Line
                Return Line
            }
        } Else    ;;∙------∙No more semicolon found, hence no comments on this line.
            Return Line
    }
}

;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Function MemorizeIndent: Store list of indentations =========∙
MemorizeIndent(Command,Increment,Index=0){
    global
    If (Index > 0)
        IndentIndex += %Index%
    Else If (Index < 0)
        IndentIndex := Abs(Index)
    IndentCommand%IndentIndex% = %Command%
    IndentIncrement%IndentIndex% = %Increment%
}
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Perform the syntax indentation for each given line ===========∙
DoSyntaxIndentation:
;;∙------∙Count line.
    TotalLineCount ++

;;∙------∙Judge on line.
;;∙------∙Remove space and tabs from beginning and end of original line.
    Line = %Original_Line%

    If Line is Space    ;;∙------∙Nothing in line.
    { String = %String%`n

;;∙------∙Count line.
        EmptyLineCount ++
        Gosub, FinishThisLine
        Return    ;; ------ Continue with next line.
    }

;;∙------∙Judge on first chars.
;;∙------∙Get first and last characters of line.
    StringLeft,  FirstChar    , Line, 1
    StringLeft,  FirstTwoChars, Line, 2

    FinishThisLine := False

;;∙------∙Turn AutoTrim off, to be able to process tabs and spaces.
    AutoTrim, Off

    If (FirstTwoChars = "*/") {    ;;∙------∙Line is end of BlockComment.
        String = %String%%Line%`n
        InBlockComment := False
        CommentLineCount ++
        FinishThisLine := True
    }

    Else If InBlockComment {    ;;∙------∙Line is inside the BlockComment.
        If KeepBlockCommentIndent
            String = %String%%Original_Line%`n
        Else
            String = %String%%Line%`n
        CommentLineCount ++
        FinishThisLine := True
    }

    Else If (FirstTwoChars = "/*") {    ;;∙------∙Line is beginning of a BlockComment, end will be */
        String = %String%%Line%`n
        InBlockComment := True
        CommentLineCount ++
        FinishThisLine := True
    }

    Else If (FirstChar = ":") {    ;;∙------∙Line is hotstring.
        String = %String%%Line%`n
        MemorizeIndent("Sub",1,-1)
        FinishThisLine := True
    }

    Else If (FirstChar = ";") {    ;;∙------∙Line is comment.
        String = %String%%Indent%%Line%`n
        CommentLineCount ++
        FinishThisLine := True
    }

    If FinishThisLine {
        Gosub, FinishThisLine
        Return    ;;∙------∙Continue with next line.
    }

;;∙------∙Turn AutoTrim back on
    AutoTrim, On

;;∙------∙Judge on commands/words.
;;∙------∙Get pure command line.
    StripedLine := StripCommentsFromLine(Line)

;;∙------∙Get last character of CommandLine.
    StringRight, LastChar     , StripedLine, 1

;;∙------∙Get shortest first, second and third word of CommandLine.
    Loop, 3
        CommandLine%A_Index% =
    StringReplace, CommandLine, StripedLine, %A_Tab%, %A_Space%,All
    StringReplace, CommandLine, CommandLine, `, , %A_Space%,All
    StringReplace, CommandLine, CommandLine, {, %A_Space%,All
    StringReplace, CommandLine, CommandLine, }, %A_Space%,All
    StringReplace, CommandLine, CommandLine, %A_Space%if(, %A_Space%if%A_Space%,All
    StringReplace, CommandLine, CommandLine, ), %A_Space%,All
    StringReplace, CommandLine, CommandLine, %A_Space%%A_Space%%A_Space%%A_Space%, %A_Space%,All
    StringReplace, CommandLine, CommandLine, %A_Space%%A_Space%%A_Space%, %A_Space%,All
    StringReplace, CommandLine, CommandLine, %A_Space%%A_Space%, %A_Space%,All
    CommandLine = %CommandLine%    ;;∙------∙Remove Spaces from begining and end.
    StringSplit, CommandLine, CommandLine, %A_Space%
    FirstWord  = %CommandLine1%
    SecondWord = %CommandLine2%
    ThirdWord  = %CommandLine3%

;;∙------∙Get last character of First word.
    StringRight, FirstWordLastChar,  FirstWord,  1

;;∙------∙Check if previoulsly found function name is really a function definition.
;;∙------∙If line is not start of bracket block but a funtion name exists.
    If ( FirstChar <> "{" AND IndentIndex = 1 AND   FunctionName <> "") {
        FunctionName =         ;;∙------∙Then that previous line is not a function definition.
        IndentIndex = 0         ;;∙------∙Set back the indentation, which was previously set.
        Gosub, SetIndentForNextLoop
    }

;;∙------∙Assume line is not a function.
    FirstWordIsFunction := False
;;∙------∙If no indentation and bracket not as first character it might be a function.
    If ( IndentIndex = 0 And InStr(FirstWord,"(") > 0 )
        FirstWordIsFunction := ExtractFunctionName(FirstWord,InStr(FirstWord,"("),FunctionName)

    LineIsTabSpecialIndentStart := False
    LineIsTabSpecialIndent      := False
    LineIsTabSpecialIndentEnd   := False
    If (ChkSpecialTabIndent AND FirstWord = "Gui") {
        If (InStr(SecondWord,"add") And ThirdWord = "tab")
            LineIsTabSpecialIndentStart := True
        Else If (InStr(SecondWord,"tab")) {
            If ThirdWord is Space
                LineIsTabSpecialIndentEnd := True
            Else
                LineIsTabSpecialIndent := True
        }
    }
;;∙------∙Turn AutoTrim off, to be able to process tabs and spaces.
    AutoTrim, Off

;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Start to adjust indentation ===============================∙

    If FirstWord in %ListOfDirectives%    ;;∙------∙Line is directive.
    { Loop, Parse, CaseCorrectionSyntax, `,
            StringReplace, Line, Line, %A_LoopField%, %A_LoopField%, All
        String = %String%%Line%`n
    }

    Else If InStr("#!^+<>*~$", FirstChar) AND InStr(FirstWord,"::")    ;;∙------∙Line is Hotkey. (has be be after directives due to the #)
    {
            String = %String%%Line%`n
            MemorizeIndent("Sub",1,-1)
    }
    Else If (FirstChar = "," OR FirstTwoChars = "||" OR FirstTwoChars = "&&"
                                    OR FirstWord = "and" OR FirstWord = "or" )    ;;∙------∙Line is a implicit continuation.
        String = %String%%Indent%%IndentContLine%%Line%`n
    Else If (FirstChar = ")" and InsideContinuation) {    ;;∙------∙Line is end of a continuation block.
        Gosub, SetIndentOfLastBracket
        String := String . Indent . iif(Style=1,"",IndentSize) . Line . "`n"
;;∙------∙IndentIndex doesn't need to be reduced, this is done inside SetIndentOfLastBracket.
        InsideContinuation := False
    }
    Else If InsideContinuation {    ;;∙------∙Line is inside a continuation block.
        If AdjustContinuation
            String = %String%%Indent%%Line%`n
        Else
            String = %String%%Original_Line%`n
    }
    Else If (FirstChar = "(") {    ;;∙------∙Line is beginning of a continuation block.
        String := String . Indent . iif(Style>1,IndentSize) . Line . "`n"
        MemorizeIndent("(",iif(Style=2,2,1),+1)
        AdjustContinuation := False
        If ( InStr(StripedLine, "LTrim") > 0 AND InStr(StripedLine, "RTrim0") = 0)
            AdjustContinuation := True
        InsideContinuation := True                  ;;∙------∙Allow nested cont's.
    }
    Else If LineIsTabSpecialIndentStart {                   ;;∙------∙Line is a "Gui, Add, Tab" line.
        String = %String%%Indent%%Line%`n
        MemorizeIndent("AddTab",1,+1)
    }
    Else If LineIsTabSpecialIndent {                        ;;∙------∙Line is a "Gui, Tab, TabName" line.
        Gosub, SetIndentOfLastAddTaborBracket
        String = %String%%Indent%%IndentSize%%Line%`n
        MemorizeIndent("Tab",1,+2)
    }
    Else If LineIsTabSpecialIndentEnd {                     ;;∙------∙Line is a "Gui, Tab" line.
        Gosub, SetIndentOfLastAddTaborBracket
        String = %String%%Indent%%Line%`n
    }
    Else If (FirstWordLastChar = ":") {   ;;∙------∙Line is start of subroutine or Hotkey.
        If (InStr(FirstWord,"::") = 0) {     ;;∙------∙Line is start of a subroutine.
            StringTrimRight, SubroutineName, Line, 1
            If SubroutineName not in %CaseCorrectSubsList%
                CaseCorrectSubsList = %CaseCorrectSubsList%,%SubroutineName%
        }
        String = %String%%Line%`n
        MemorizeIndent("Sub",1,-1)
    }
    Else If (FirstChar = "}") {             ;;∙------∙Line is end bracket block.
        If (FirstWord = "else"){            ;;∙------∙It uses OTB and must be a "}[ ]else [xxx] [{]"
;;∙------∙Do the case correction.
            StringReplace, Line, Line, else, else
            Loop, Parse, CaseCorrectionSyntax, `,
                StringReplace, Line, Line, %A_LoopField%, %A_LoopField%, All

            Gosub, SetIndentOfLastCurledBracket
            IndentIndex --
            Gosub, SetIndentOfLastIfOrOneLineIf

;;∙------∙Else line is also start of If-Statement.
            If SecondWord in %ListOfIFCommands%    ;;∙------∙Line is an old  If-statement.
            {
                StringReplace, Line, Line, if, if    ;;∙------∙Feature #2.
                StringReplace, ParsedCommand, StripedLine, ```, ,,All
;;∙------∙Search if a third comma exists
                StringGetPos, ParsedCommand, ParsedCommand , `, ,L3
                If ErrorLevel    ;;∙------∙Line is an old If-statement.
                    MemorizeIndent("If",iif(Style=1,0,1),+1)
            }Else If (SecondWord = "if") {    ;;∙------∙Line is a Normal if-statement.
                StringReplace, Line, Line, if, if
                MemorizeIndent("If",iif(Style=1,0,1),+1)
                If (LastChar = "{")    ;;∙------∙It uses OTB.
                    MemorizeIndent("{",iif(Style=3,0,1),+1)
            }Else If (SecondWord = "loop"){    ;;∙------∙Line is the begining of a loop.
                StringReplace, Line, Line, loop, loop
                MemorizeIndent("Loop",iif(Style=1,0,1),+1)
                If (LastChar = "{")    ;;∙------∙It uses OTB.
                    MemorizeIndent("{",iif(Style=3,0,1),+1)
            }Else If SecondWord is Space    ;;∙------∙just a plain Else.
            {
                MemorizeIndent("Else",iif(Style=1,0,1),+1)
                If (LastChar = "{")    ;;∙------∙It uses OTB.
                    MemorizeIndent("{",iif(Style=3,0,1),+1)
            }
;;∙------∙If all the previous if didn't satisfy, the Line is an else with any command following, then nothing has to be done.
            String = %String%%Indent%%Line%`n
        }Else {    ;;∙------∙Line is end bracket block without OTB.
            Gosub, SetIndentOfLastCurledBracket
            String = %String%%Indent%%Line%`n
            IndentIndex --
        }
    }
    Else If (FirstChar = "{") {    ;;∙------∙Line is start of bracket block.
;;∙------∙Check if line is start of a function implementation.
        If ( IndentIndex = 1 AND  FunctionName <> "" )
;;∙------∙Then add function name to list if not in it already.
            If FunctionName not in %CaseCorrectFuncList%
                CaseCorrectFuncList = %CaseCorrectFuncList%,%FunctionName%(
;;∙------∙Clear function name.
        FunctionName =

        IndentIndex ++
        IndentCommand%IndentIndex% = {
        IndentIncrement%IndentIndex% := iif(Style=3,0,1)

;;∙------∙Check if command after { is if or loop.
        If (FirstWord = "loop"){    ;;∙------∙Line is start of Loop block after the '{'.
;;∙------∙Do the case correction.
            StringReplace, Line, Line, loop, loop
            Loop, Parse, CaseCorrectionSyntax, `,
                StringReplace, Line, Line, %A_LoopField%, %A_LoopField%, All

            MemorizeIndent("Loop",iif(Style=1,0,1),+1)
            If (LastChar = "{")    ;;∙------∙It uses OTB.
                MemorizeIndent("{",iif(Style=3,0,1),+1)
;;∙------∙Assuming that there are no old one-line if-statements following a '{'.
        }Else If FirstWord in %ListOfIFCommands%    ;;∙------∙Line is start of old If-Statement after the '{'.
        {
;;∙------∙Do the case correction.
            StringReplace, Line, Line, if, if, 1
            Loop, Parse, CaseCorrectionSyntax, `,
                StringReplace, Line, Line, %A_LoopField%, %A_LoopField%, All

            MemorizeIndent("If",iif(Style=1,0,1),+1)
        }Else If (FirstWord = "if"){    ;;∙------∙Line is start of If-Statement after the '{'.
;;∙------∙Do the case correction.
            StringReplace, Line, Line, if, if, 1
            Loop, Parse, CaseCorrectionSyntax, `,
                StringReplace, Line, Line, %A_LoopField%, %A_LoopField%, All

            MemorizeIndent("If",iif(Style=1,0,1),+1)
        }Else If (FirstWord = "else") {    ;;∙------∙Line is start of an else block.
;;∙------∙Do the case correction.
            StringReplace, Line, Line, else, else
            Loop, Parse, CaseCorrectionSyntax, `,
                StringReplace, Line, Line, %A_LoopField%, %A_LoopField%, All

            MemorizeIndent("Else",iif(Style=1,0,1),+1)
        }Else If (FirstWord = "return") {    ;;∙------∙Line is start of return block.
;;∙------∙Do the case correction.
            StringReplace, Line, Line, return, return
            Loop, Parse, CaseCorrectionSyntax, `,
                StringReplace, Line, Line, %A_LoopField%, %A_LoopField%, All

            MemorizeIndent("Return",iif(Style=1,0,1),+1)
        }Else If (FirstWord = "break") {    ;;∙------∙Line is start of break block.
;;∙------∙Do the case correction.
            StringReplace, Line, Line, break, break
            Loop, Parse, CaseCorrectionSyntax, `,
                StringReplace, Line, Line, %A_LoopField%, %A_LoopField%, All

            MemorizeIndent("Break",iif(Style=1,0,1),+1)
        }Else If (FirstWord = "continue") {    ;;∙------∙Line is start of continue block.
;;∙------∙Do the case correction.
            StringReplace, Line, Line, continue, continue
            Loop, Parse, CaseCorrectionSyntax, `,
                StringReplace, Line, Line, %A_LoopField%, %A_LoopField%, All

            MemorizeIndent("Continue",iif(Style=1,0,1),+1)
        }Else If (FirstWord = "throw") {    ;;∙------∙Line is start of throw block.
;;∙------∙Do the case correction.
            StringReplace, Line, Line, throw, throw
            Loop, Parse, CaseCorrectionSyntax, `,
                StringReplace, Line, Line, %A_LoopField%, %A_LoopField%, All

            MemorizeIndent("Throw",iif(Style=1,0,1),+1)
        }Else {
            String = %String%%Indent%%Line%`n
        }
    }
    Else If ( FirstWord = "function") {    ;;∙------∙Line is start of a function.
        String = %String%%Line%`n
        StringTrimLeft, FunctionName, Line, 9
        FunctionName := RegExReplace(FunctionName,"^`s*","")
    }
    Else If (FirstWord = "try") {    ;;∙------∙Line is start of try block.
;;∙------∙Do the case correction.
        StringReplace, Line, Line, try, try
        Loop, Parse, CaseCorrectionSyntax, `,
            StringReplace, Line, Line, %A_LoopField%, %A_LoopField%, All

        String = %String%%Indent%%Line%`n
        MemorizeIndent("Try",iif(Style=1,0,1),+1)
        If (LastChar = "{")    ;;∙------∙it uses OTB
            MemorizeIndent("{",iif(Style=3,0,1),+1)
    }
    Else If (FirstWord = "catch") {    ;;∙------∙Line is start of catch block.
;;∙------∙Do the case correction.
        StringReplace, Line, Line, catch, catch
        Loop, Parse, CaseCorrectionSyntax, `,
            StringReplace, Line, Line, %A_LoopField%, %A_LoopField%, All

        String = %String%%Indent%%Line%`n
        MemorizeIndent("Catch",iif(Style=1,0,1),+1)
        If (LastChar = "{")                     ;;∙------∙it uses OTB
            MemorizeIndent("{",iif(Style=3,0,1),+1)
    }
    Else If (FirstWord = "finally") {    ;;∙------∙Line is start of finally block.
;;∙------∙Do the case correction.
        StringReplace, Line, Line, finally, finally
        Loop, Parse, CaseCorrectionSyntax, `,
            StringReplace, Line, Line, %A_LoopField%, %A_LoopField%, All

        String = %String%%Indent%%Line%`n
        MemorizeIndent("Finally",iif(Style=1,0,1),+1)
        If (LastChar = "{")    ;;∙------∙It uses OTB.
            MemorizeIndent("{",iif(Style=3,0,1),+1)
    }
    Else {    ;;∙------∙Line is neither, just add it to the string.
        String = %String%%Indent%%Line%`n
    }
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== End of change in indentation =============================∙
FinishThisLine:
;;∙------∙Turn AutoTrim on, to get back to default behaviour.
    AutoTrim, On

;;∙------∙Show MsgBox for debug.
    If DebugMode
        Gosub, ShowDebugStrings

;;∙------∙Get Indentation for next loop.
    Gosub, SetIndentForNextLoop
Return

;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Show MsgBox for debug =================================∙
ShowDebugStrings:
    msgtext = line#: %TotalLineCount%`n
    msgtext = %msgtext%Style: %Style%`n
    msgtext = %msgtext%line: %Line%`n
    msgtext = %msgtext%stripped line: %CommandLine%`n
    msgtext = %msgtext%Indent: |%Indent%|`n
    msgtext = %msgtext%1stChar: >%FirstChar%<`n
    msgtext = %msgtext%1st Word: >%FirstWord%<`n
    msgtext = %msgtext%2nd Word: >%SecondWord%<`n
    msgtext = %msgtext%3rd Word: >%ThirdWord%<`n
    msgtext = %msgtext%1st WordLastChar: >%FirstWordLastChar%<`n
    msgtext = %msgtext%FunctionName: >%FunctionName%<`n`n
    msgtext = %msgtext%IndentIndex: %IndentIndex%`n
;;∙------∙msgtext = %msgtext%LineIsTabSpecialIndentStart: %LineIsTabSpecialIndentStart%`n
;;∙------∙msgtext = %msgtext%LineIsTabSpecialIndent: %LineIsTabSpecialIndent%`n
;;∙------∙msgtext = %msgtext%LineIsTabSpecialIndentEnd: %LineIsTabSpecialIndentEnd%`n`n
    msgtext = %msgtext%Indent1: %IndentIncrement1% - %IndentCommand1%`n
    msgtext = %msgtext%Indent2: %IndentIncrement2% - %IndentCommand2%`n
    msgtext = %msgtext%Indent3: %IndentIncrement3% - %IndentCommand3%`n
    msgtext = %msgtext%Indent4: %IndentIncrement4% - %IndentCommand4%`n
    msgtext = %msgtext%Indent5: %IndentIncrement5% - %IndentCommand5%`n
    msgtext = %msgtext%Indent6: %IndentIncrement6% - %IndentCommand6%`n
    msgtext = %msgtext%Indent7: %IndentIncrement7% - %IndentCommand7%`n
    msgtext = %msgtext%Indent8: %IndentIncrement8% - %IndentCommand8%`n
    msgtext = %msgtext%Indent9: %IndentIncrement9% - %IndentCommand9%`n
    msgtext = %msgtext%Indent10: %IndentIncrement10% - %IndentCommand10%`n
    msgtext = %msgtext%Indent11: %IndentIncrement11% - %IndentCommand11%`n
;;∙------∙msgtext = %msgtext%`nDirectives: %ListOfDirectives%`n
;;∙------∙msgtext = %msgtext%`nIf-Commands: %ListOfIFCommands%`n
;;∙------∙msgtext = %msgtext%`nCommandNames: %CommandNames%`n
;;∙------∙msgtext = %msgtext%`nKeywords: %Keywords%`n
;;∙------∙msgtext = %msgtext%`nKeys: %Keys%`n
;;∙------∙msgtext = %msgtext%`nVariables: %Variables%`n
;;∙------∙msgtext = %msgtext%`nBuildInFunctions: %BuildInFunctions%`n
;;∙------∙msgtext = %msgtext%`nCaseCorrectFuncList: %CaseCorrectFuncList%`n

    MsgBox %msgtext%`n%String%
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Set the IndentIndex to to last if or onelineif ==================∙
SetIndentOfLastIfOrOneLineIf:
;;∙------∙Loop inverse through command array.
    Loop, %IndentIndex% {
        InverseIndex := IndentIndex - A_Index + 2
;;∙------∙If command is if or onelineif, exit loop and remember the previous Index.
        If IndentCommand%InverseIndex% in If,OneLineIf
        { IndentIndex := InverseIndex - 1
            Break
        }
    }
;;∙------∙Set indentation for that index.
    Gosub, SetIndentForNextLoop
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Set the IndentIndex to to last curled bracket =================∙
SetIndentOfLastCurledBracket:
;;∙------∙Loop inverse through command array.
    Loop, %IndentIndex% {
        InverseIndex := IndentIndex - A_Index + 1
;;∙------∙If command is bracket, exit loop and remember the previous Index.
        If (IndentCommand%InverseIndex% = "{") {
            IndentIndex := InverseIndex - 1
            Break
        }
    }
;;∙------∙Set indentation for that index.
    Gosub, SetIndentForNextLoop
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Set the IndentIndex to to last bracket ======================∙
SetIndentOfLastBracket:
;;∙------∙Loop inverse through command array.
    Loop, %IndentIndex% {
        InverseIndex := IndentIndex - A_Index + 1
;;∙------∙If command is bracket, exit loop and remember the previous Index.
        If (IndentCommand%InverseIndex% = "(") {
            IndentIndex := InverseIndex - 1
            Break
        }
    }
;;∙------∙Set indentation for that index.
    Gosub, SetIndentForNextLoop
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Set the IndentIndex to the last addtab ======================∙
SetIndentOfLastAddTaborBracket:
;;∙------∙Loop inverse through command array.
    Loop, %IndentIndex% {
        InverseIndex := IndentIndex - A_Index + 1
;;∙------∙If command is AddTab, exit loop and remember the previous Index.
        If IndentCommand%InverseIndex% in {,AddTab
        { IndentIndex := InverseIndex - 1
            Break
        }
    }
;;∙------∙Set indentation for that index.
    Gosub, SetIndentForNextLoop
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Set the IndenIndex to to last Sub or bracket =================∙
SetIndentToLastSubBracketOrTab:
    FoundItem:=False
;;∙------∙Loop inverse through command array.
    Loop, %IndentIndex% {
        InverseIndex := IndentIndex - A_Index + 1

;;∙------∙If command is sub or bracket, exit loop and remember the Index.
        If IndentCommand%InverseIndex% in {,Sub
        { IndentIndex := InverseIndex
            FoundItem:=True
            Break
        }Else If ChkSpecialTabIndent
            If IndentCommand%InverseIndex% in AddTab,Tab
            { IndentIndex := InverseIndex
                FoundItem:=True
                Break
            }
    }
;;∙------∙If not found set index to zero.
    If ! FoundItem
        IndentIndex = 0

;;∙------∙Set indentation for that index.
    Gosub, SetIndentForNextLoop
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;====== Extract Function Names==================================∙
ExtractFunctionName(FirstWord,BracketPosition, ByRef FunctionName)  {
;;∙------∙Get function name without braket.
    StringLeft, FunctionName, FirstWord, % BracketPosition - 1
    If (FunctionName = "If")   ;;∙------∙it is a If statement "If(", empty FunctionName and function will Return 0
        FunctionName =
    RegExMatch(FunctionName, "SP)(*UCP)^[[:blank:]]*\K[\w#@\$\?\[\]]+", FunctionName_Len)
    If (FunctionName_Len<>StrLen(FunctionName))
        FunctionName =
    Return StrLen(FunctionName)
}
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Do CaseCorrection for Functions and Subroutines∙==========∙
CaseCorrectSubsAndFuncNames() {
    global
    LenString := StrLen(String)

;;∙------∙Remove first comma.
    StringTrimLeft, CaseCorrectFuncList, CaseCorrectFuncList, 1
    StringTrimLeft, CaseCorrectSubsList, CaseCorrectSubsList, 1

;;∙------∙Loop over all remembered function names.
    Loop, Parse, CaseCorrectFuncList, CSV
    { FuncName := A_LoopField
        LenFuncName := StrLen(FuncName)

;;∙------∙Loop through string to find all occurances of function names.
        StartPos = 0
        Loop {
            StartPos := InStr(String,FuncName,0,StartPos + 1)
            If (StartPos > 0) {
                StringMid,PrevChar, String, StartPos - 1 , 1
                If PrevChar is not Alnum
                    ReplaceName( String, FuncName, StartPos-1, LenString - StartPos + 1 - LenFuncName )
            } Else
                Break
        }
    }

;;∙------∙Loop over all remembered subroutine names.
    Loop, Parse, CaseCorrectSubsList, CSV
    { SubName := A_LoopField
        LenSubName := StrLen(SubName)

;;∙------∙Loop through string to find all occurances of function names.
        StartPos = 0
        Loop {
            StartPos := InStr(String,SubName,"",StartPos + 1)
            If (StartPos > 0) {
                StringMid,PrevChar, String, StartPos - 1 , 1
                StringMid,NextChar, String, StartPos + LenSubName, 1

;;∙------∙If it is an exact match the char after the subroutine names has not to be a char.
                If NextChar is not Alnum
                {    ;;∙------∙If previous character is a "g" and has TestStrings in same line replace the name.
                    If ( PrevChar = "g" ) {
                        TestAndReplaceSubName( String, SubName, "Gui,", LenString, LenSubName, StartPos)
                        TestAndReplaceSubName( String, SubName, "Gui ", LenString, LenSubName, StartPos)

;;∙------∙If previous character is something else then Alnum and has TestStrings in same line replace the name.
                    }Else If PrevChar is not Alnum
                    { TestAndReplaceSubName( String, SubName, "Gosub" , LenString, LenSubName, StartPos )
                        TestAndReplaceSubName( String, SubName, "Menu"  , LenString, LenSubName, StartPos )
                        TestAndReplaceSubName( String, SubName, "`:`:"  , LenString, LenSubName, StartPos )
                        TestAndReplaceSubName( String, SubName, "Hotkey", LenString, LenSubName, StartPos )
                    }
                }
            } Else
                Break
        }
    }
}

TestAndReplaceSubName( ByRef string, Name, TestString, LenString, LenSubName, StartPos ) {
;;∙------∙Find Positions of Teststring and LineFeed in String from the right side starting at routine position.
    StringGetPos, PosTestString, String, %TestString%, R , LenString - StartPos + 1
    StringGetPos, PosLineFeed  , String,     `n      , R , LenString - StartPos + 1

;;∙------∙If %TestString% is in the same line do replace name.
    If ( PosLineFeed < PosTestString )
        ReplaceName( String, Name, StartPos - 1, LenString - StartPos + 1 - LenSubName )
}

ReplaceName( ByRef String, Name, PosLeft, PosRight ) {
;;∙------∙Split String up into left and right.
    StringLeft, StrLeft, String, PosLeft
    StringRight, StrRight, String, PosRight

;;∙------∙Insert Name into it again.
    String = %StrLeft%%Name%%StrRight%
}
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙If Gui closes exit all∙=====================================∙
ExitAS:
GuiClose:
;;∙------∙Store current position and settings and exit app.  (*Optional - Set settings INI file attribute as hidden)
    Gui, Show
    WinGetPos, PosX, PosY, SizeW, SizeH, %ScriptName%
    Gui, Submit
    IniWrite, x%PosX% y%PosY%, %IniFile%, General, Pos_Gui
    IniWrite, %Extension%, %IniFile%, Settings, Extension
    IniWrite, %Indentation%, %IniFile%, Settings, Indentation
    IniWrite, %NumberSpaces%, %IniFile%, Settings, NumberSpaces
    IniWrite, %NumberIndentCont%, %IniFile%, Settings, NumberIndentCont
    IniWrite, %IndentCont%, %IniFile%, Settings, IndentCont
    IniWrite, %Style%, %IniFile%, Settings, Style
    IniWrite, %CaseCorrectCommands%, %IniFile%, Settings, CaseCorrectCommands
    IniWrite, %CaseCorrectVariables%, %IniFile%, Settings, CaseCorrectVariables
    IniWrite, %CaseCorrectBuildInFunctions%, %IniFile%, Settings, CaseCorrectBuildInFunctions
    IniWrite, %CaseCorrectKeys%, %IniFile%, Settings, CaseCorrectKeys
    IniWrite, %CaseCorrectKeywords%, %IniFile%, Settings, CaseCorrectKeywords
    IniWrite, %CaseCorrectDirectives%, %IniFile%, Settings, CaseCorrectDirectives
    IniWrite, %Statistic%, %IniFile%, Settings, Statistic

    IniWrite, %ChkSpecialTabIndent%, %IniFile%, Settings, ChkSpecialTabIndent
    IniWrite, %KeepBlockCommentIndent%, %IniFile%, Settings, KeepBlockCommentIndent
    IniWrite, %AHKPath%, %IniFile%, Settings, AHKPath
    IniWrite, %OwnHotKey%, %IniFile%, Settings, OwnHotKey

ExitApp:
    ExitApp
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Set Hidden Attribute∙====================================∙
ToggleHidden:
GuiControlGet, Checked, , HideCheckbox
If (Checked = 1)
{
    FileSetAttrib, +H, %IniFile%    ;;∙------∙Set the file to hidden.
}
Else
{
    FileSetAttrib, -H, %IniFile%    ;;∙------∙Remove the hidden attribute.
}
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙GuiTip Function∙========================================∙
;;∙------∙» Source » https://www.autohotkey.com/boards/viewtopic.php?t=6436#p38487
;;∙------∙» Author » Coco
GuiTip(hCtrl, text:="")
{
    hGui := text!="" ? DlLCall("GetParent", "Ptr", hCtrl) : hCtrl
    static hTip
    if !hTip
    {
        hTip := DllCall("CreateWindowEx", "UInt", 0x8, "Str", "tooltips_class32"
             ,  "Ptr", 0, "UInt", 0x80000002 ;// WS_POPUP:=0x80000000|TTS_NOPREFIX:=0x02
             ,  "Int", 0x80000000, "Int",  0x80000000, "Int", 0x80000000, "Int", 0x80000000
             ,  "Ptr", hGui, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Ptr")

        ; TTM_SETMAXTIPWIDTH = 0x0418
        DllCall("SendMessage", "Ptr", hTip, "Int", 0x0418, "Ptr", 0, "Ptr", 0)

        if (A_OsVersion == "WIN_XP")
            GuiTip(hGui)
    }

    static sizeof_TOOLINFO := 24 + (6 * A_PtrSize)
    VarSetCapacity(TOOLINFO, sizeof_TOOLINFO, 0)
    , NumPut(sizeof_TOOLINFO, TOOLINFO, 0, "UInt")
    , NumPut(0x11, TOOLINFO, 4, "UInt") ; TTF_IDISHWND:=0x0001|TTF_SUBCLASS:=0x0010
    , NumPut(hGui, TOOLINFO, 8, "Ptr")
    , NumPut(hCtrl, TOOLINFO, 8 + A_PtrSize, "Ptr")
    , NumPut(&text, TOOLINFO, 24 + (3 * A_PtrSize), "Ptr")

    static TTM_ADDTOOL := A_IsUnicode ? 0x0432 : 0x0404
    return DllCall("SendMessage", "Ptr", hTip, "Int", TTM_ADDTOOL, "Ptr", 0, "Ptr", &TOOLINFO)
}
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
    ReloadAS:    ;;∙------∙Auto Syntax Call.
    Script·Reload:    ;;∙------∙Menu Call.
        SoundBeep, 1100, 75
        Soundbeep, 1200, 100
    Reload
Return
;;∙------∙EXIT∙------∙EXIT∙--------------∙
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
;;∙------------------------------------------∙
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
TEMPLATE:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

