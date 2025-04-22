
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  balawi28
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?f=6&t=119371&p=537110&hilit=AHKFastTranslator#p529653
» Github Source:  https://github.com/balawi28/AHKFastTranslator
    ▹ 
    •Translate text quickly and conveniently without leaving current application using Google Translate API.
    •Assign a custom hotkey to trigger the translation.
    •Choose between tooltip or a message box to display the translated text.
    •Gui remembers its position on the screen as well as settings.
    •Copy the translation to the clipboard. (optional - set as default)
    •Run the script at startup. (optional through right-click tray icon)
    •Paste translations directly into new Notepad or Notepad++. (optional through interface buttons)
    •Direct inline (in-place) translations of editable text. (optional through Inline hotkey set in 'InLine Translations' section (Ctrl+I in this case))
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TRANSLATOR"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
;;∙============================================================∙

;⯁═════════════ Globals ═════════════⯁
global Minimized := True
dict := GetLanguagesDict()
menuOptions := Join(dict, "|")
;◊────────── Globals End ───────────◊ 

Menu, Tray, Icon, % "HICON:" . Base64PNG_to_HICON(TrayIcon())

;⯁═════════════ INI Reads ═════════════⯁
IniRead, defaultSourceLanguage, %A_ScriptFullPath%:Stream:$DATA, Settings, defaultSourceLanguage, Auto-Detect •
IniRead, defaultTargetLanguage, %A_ScriptFullPath%:Stream:$DATA, Settings, defaultTargetLanguage, English
IniRead, hotKeyPrevious, %A_ScriptFullPath%:Stream:$DATA, Settings, hotKeyPrevious, ^+t
IniRead, isRanAtStartup, %A_ScriptFullPath%:Stream:$DATA, Settings, isRanAtStartup, 0
IniRead, outputMethod, %A_ScriptFullPath%:Stream:$DATA, Settings, outputMethod, tooltip
IniRead, EnableClipboard, %A_ScriptFullPath%:Stream:$DATA, Settings, EnableClipboard, 0
;◊────────── INI Reads End ───────────◊ 

;⯁═════════════ Initializers ═════════════⯁
; —⮞ Hotkey
if (StrLen(hotKeyPrevious) != 0)
    Hotkey, %hotKeyPrevious%, HotkeyPressed

; —⮞ Source & Target Languages
sourceIndex := FindLanguageIndex(dict, defaultSourceLanguage)
targetIndex := FindLanguageIndex(dict, defaultTargetLanguage)
;◊─────────── Initializers End ───────────◊ 

;⯁═════════════ Tray Menu ═════════════⯁
; —⮞ Tray menu
Menu, Tray, NoStandard ; Remove all standard tray menu options
Menu, Tray, Add, GUI, HotkeyPressed
Menu, Tray, Icon, GUI, Shell32.dll, 35
Menu, Tray, Add, Run at Startup, StartupToggle
Menu, Tray, Icon, Run at Startup, Shell32.dll, 79
Menu, Tray, Add, Reload, ReloadApplication
Menu, Tray, Icon, Reload, Shell32.dll, 298
Menu, Tray, Add, Exit, ExitApplication
Menu, Tray, Icon, Exit, Shell32.dll, 132

Menu, Tray, Add, Edit Script, EditScript
Menu, Tray, Icon, Edit Script, Shell32.dll, 71

Menu, Tray, Default, GUI
if (isRanAtStartup)
    Menu, Tray, Check, Run at Startup
;◊─────────── Tray Menu End ───────────◊ 

;⯁═════════════ Gui Layout ═════════════⯁
; •———— Transparacies Section ————• 
Gui, Color, 000101
Gui +LastFound 
WinSet, TransColor, 000101
; ———— 
Gui, Font, s20 q5 BOLD, Segoe UI
Gui, Add, Text, x8 y7 w360 c011167 BackgroundTrans CENTER, - TRANSLATOR -
Gui, Font, BOLD, 
Gui, Add, Text, x9 y6 w360 c3981F3 BackgroundTrans CENTER, - TRANSLATOR -
Gui, Font, NORM, 
Gui, Add, Text, x130 y5 w120 h23 c011167 BackgroundTrans HwndhText gDUMMY,  
    AttachTip(hText, "Google Translate")
Gui, Font, BOLD, 
Gui, Add, Text, x10 y5 w360 c000101 BackgroundTrans CENTER, - TRANSLATOR -
; ———— 
Gui, Font, s20 q5 BOLD, Segoe UI
Gui, Add, Text, x0 y238 w380 c011167 BackgroundTrans CENTER, __________________________________ ; Bottom
Gui, Add, Text, x0 y237 w380 c3981F3 BackgroundTrans CENTER, __________________________________ ;   Deco
Gui, Add, Text, x0 y236 w380 c000101 BackgroundTrans CENTER, __________________________________ ;    Bar
; ———————————— 
Gui, Add, Picture, x178 y69 w23 h16 gSwapLanguages, % "HICON:" . Base64PNG_to_HICON(SwapIcon())
; •———— Transparacies Section End ————• 
Gui, 
    +AlwaysOnTop 
    +Border 
    -Caption
    +LastFound 
    +OwnDialogs
    +ToolWindow 
Gui, Color, 3981F3
Gui, Margin, 10, 10
Gui, Font, s10 w200 c011167 q5, ARIAL
; •———— Top Gui Row Section ————• 
Gui, Add, Picture, x10 y10 w32 h32, % "HICON:" . Base64PNG_to_HICON(GoogleTranslateLogo())
Gui, Add, Text, x5 y5 w32 h30 w30 BackgroundTrans HwndhText gDUMMY,  
    AttachTip(hText, "Google Translate")
; ———— 
Gui, Font, s10 c1A3FE8 q5 BOLD
Gui, Add, Text, x325 y3 BackgroundTrans, |   |   |   | 
; ———— 
Gui, Font, s8 c659CF6 q5 BOLD
Gui, Add, Text, x330 y5 c011167 BackgroundTrans, ?
Gui, Add, Text, x325 y5 w15 BackgroundTrans HwndhText gABOUTS, 
    AttachTip(hText, "ABOUT")
; ———— 
Gui, Font, s18 q5 NORM
Gui, Add, Text, x344 y5 cFCFCFC BackgroundTrans, *
Gui, Add, Text, x340 y-1 w10 BackgroundTrans HwndhText gReload,
    AttachTip(hText, "RELOAD")
; ———— 
Gui, Font, s8 c659CF6 q5 BOLD
Gui, Add, Text, x361 y5 cB20000 BackgroundTrans, X
Gui, Add, Text, x357 y5 w15 BackgroundTrans HwndhText gExit, 
    AttachTip(hText, "EXIT")
; •———— Top Gui Row Section End ————• 

; •———— Language Selection Row Section ————• 
Gui, Font, s8 w200 c011167 q5 UNDERLINE, ARIAL
Gui, Add, Text, x30 y45 w360 BackgroundTrans, Select Input Language
Gui, Font, s10 w200 c011167 q5 NORM, ARIAL
Gui, Add, DropDownList, x20 y65 w150 choose%sourceIndex% vSourceLang gOnSourceLangChange, %menuOptions%
; ————
Gui, Font, s8 w200 c011167 q5 UNDERLINE, ARIAL
Gui, Add, Text, x220 y45 w150 BackgroundTrans, Select Output Language
Gui, Font, s10 w200 c011167 q5 NORM, ARIAL
Gui, Add, DropDownList, x210 y65 w150 choose%targetInde`x% vTargetLang gOnTargetLangChange, %menuOptions%
; •———— Language Selection Row Section End ————• 

; •———— Selections Box Section ————• 
Gui, Font, s8 w200 c011167 q5 UNDERLINE, ARIAL
Gui, Add, Text, x5 y98 w186 h60 BackgroundTrans 0x00800000, 
Gui, Add, Text, x35 y108 BackgroundTrans, Select Display Style
Gui, Font, s10 w200 c011167 q5 NORM, TAHOMA
Gui, Add, Radio, x15 y129 vChoiceMsgBox gRadioChoice, Message Box
Gui, Add, Radio, x120 y129 vChoiceToolTip gRadioChoice, Tooltip
GuiControl,, % outputMethod = "tooltip" ? "ChoiceToolTip" : "ChoiceMsgBox", 1
; ————
Gui, Font, s8 w200 c011167 q5 UNDERLINE, ARIAL
Gui, Add, Text, x190 y98 w186 h60 BackgroundTrans 0x00800000, 
Gui, Add, Text, x220 y108 w185 h60 BackgroundTrans, Set Interface Hotkey
Gui, Font, s8 w200 c011167 q5 NORM, ARIAL
Gui, Add, Hotkey, x202 y128 w120 h17 vhotKeyCurrent
GuiControl,, hotKeyCurrent, %hotKeyPrevious%
Gui, Font, s8 w200 q5, TAHOMA
Gui Add, Button, x325 y128 w40 h17, Save
; •———— Selections Box Section End ————• 

; •———— Translations Section ————• 
Gui, Font, s8 w800 c1A3FE8 q5 ITALIC, CALIBRI 
Gui, Add, Text, x10 y163 w360 CENTER, Translated text will appear in Clipboard and Prefered Display Style.
; ————
Gui, Font, s8 w200 c011167 q5 NORM, ARIAL
Gui, Add, Edit, x15 y175 w350 BackgroundTrans vTextToTranslate
; •———— Translations Section End ————• 

; •———— Output Choices Section ————• 
Gui, Add, Text, x262 y200 w95 h60 BackgroundTrans 0x00800000, 
Gui, Add, CheckBox, x310 y238 vEnableClipboard gCheckBox, 
Gui, Font, s8 w200 c011167 q5 UNDERLINE, ARIAL
Gui, Add, Text, x267 y205 BackgroundTrans CENTER, Copy Translation`nTo Clipboard%A_SPACE%
Gui, Font, s8 w200 c011167 q5 NORM, ARIAL
GuiControl,,EnableClipboard,%EnableClipboard%
; ———————————— 
Gui, Font, s8 w200 c011167 q5, ARIAL
Gui, Add, Text, x20 y200 w108 h60 BackgroundTrans 0x00800000, 
Gui, Add, Button, x100 y223 h13 w20 BackgroundTrans gPASTE1, •
Gui, Add, Button, x100 y240 h13 w20 BackgroundTrans gPASTE2, •
Gui, Font, s8 w200 c011167 q5 UNDERLINE, ARIAL
Gui, Add, Text, x25 y205 BackgroundTrans, %A_SPACE%Paste Clipboard%A_SPACE%
Gui, Font, s8 w200 c011167 q5 NORM, ARIAL
Gui, Add, Text, x30 y223 BackgroundTrans, To Notepad
Gui, Add, Text, x30 y240 BackgroundTrans, To Notepad++ 
; ———————————— 
Gui, Font, s8 w200 c011167 q5, ARIAL
Gui, Add, Text, x165 y210 w65 h40 BackgroundTrans 0x00800000, 
Gui, Font, s8 w200 c1A3FE8 q5 UNDERLINE, ARIAL
Gui, Add, Text, x170 y215 BackgroundTrans CENTER HwndhText gINLINE, For Inline`nTranslation
    AttachTip(hText, "Click for Instructions on Translating Highlighted and Editable Text")
Gui, Font, s8 w200 c011167 q5 NORM, ARIAL
; •———— Output Choices Section End ————• 
;◊─────────── Gui Layout End ───────────◊ 

;⯁════════ Drag & Memory Control Functions ════════⯁ 
; —⮞ Define the callback function to handle the WM_MOVE message
OnMessage(0x0232, "OnDragRelease")
; ———————————— 
; —⮞ To enable drag on the main window
enableGuiDrag()
Return
; ———————————— 
; —⮞ Define the MouseUp function to get the new x and y coordinates.
OnDragRelease(wParam, lParam, msg, hwnd)
{
    WinGetPos, WinX, WinY, , , ahk_id %hwnd%
    IniWrite, %WinX%, %A_ScriptFullPath%:Stream:$DATA, Settings, defaultXPosition
    IniWrite, %WinY%, %A_ScriptFullPath%:Stream:$DATA, Settings, defaultYPosition
}
; ———————————— 
enableGuiDrag(GuiLabel=1) {
    WinGetPos,,,A_w,A_h,A
    Gui, %GuiLabel%:Add, Text, x0 y0 w%A_w% h%A_h% +BackgroundTrans gGUI_Drag
    Return
; ———————————— 
    GUI_Drag:
        SendMessage 0xA1,2 	 ; —⮞ Goyyah/SKAN trick
; —⮞ http://autohotkey.com/board/topic/80594-how-to-enable-drag-for-a-gui-without-a-titlebar
    Return
} 
;◊───── Drag & Memory Control Functions End ─────◊

;⯁═══════════ Attach Tooltip Function ═══════════⯁ 
AttachTip(hCtrl, text:="")
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
            AttachTip(hGui)
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
;◊────── Attach Tooltip Function End ───────◊ 

;⯁══════════ PopUp Message Function ══════════⯁ 
PMess(ttitle, ttext, textColor := "BLACK", bkg := "WHITE") { 	 ; <<- Default Text and Background Colors.
    Gui, Box:New, , %ttitle% 		 ; EXAMPLE : PMess("Title", "Text", "Text-Color", "Text-Background") 
    Gui, 
        +AlwaysOnTop 
        -Border 
        -Caption 
    Gui, Margin, 10, 10 
    Gui, Font, s10 c%textColor%
    Gui, Color, %bkg%
    Gui, Add, Text, , %ttext%
; Gui, Show 	 ; ⮜—— Section blocked to allow varying PMess display times. 
; Sleep, 3000
; Gui, Destroy
    Return
    }
;◊────── PopUp Message Function End ───────◊ 

;⯁═══════════════ #IfWinActive ═══════════════⯁
#IfWinActive, TRANSLATOR ahk_class AutoHotkeyGUI
    Esc::
        Goto, GuiClose
    Return
    NumpadEnter::
    Enter::
        Gui, Submit
        GuiControl, , TextToTranslate
        Minimized := True
        url := TranslateURL(dict[SourceLang], dict[TargetLang], TextToTranslate)
        response := PostRequest(url)
        cleanResponse := SubStr(response, 3, StrLen(response) - 4)
        if (SourceLang = "Auto-Detect •")
            cleanResponse := SubStr(cleanResponse, 2, StrLen(cleanResponse) - 7)
        if (EnableClipboard)
            Clipboard := cleanResponse
        if (outputMethod = "tooltip"){
            ToolTip % cleanResponse
            Sleep, 2000 ; Display the tooltip for 2 seconds
            ToolTip ; Remove the tooltip
        } else
            MsgBox, 0x40000,, % cleanResponse
    Return
#IfWinActive
;◊───────────── #IfWinActive End ──────────────◊ 

;⯁═══════════════ gLabels ═══════════════⯁
CheckBox:
    Gui, Submit, NoHide
    IniWrite, %EnableClipboard%, %A_ScriptFullPath%:Stream:$DATA, Settings,EnableClipboard
Return
; ———————————— 
ButtonSave: 	 ; Save hotkey routine.
    Gui, Submit, NoHide
    if (StrLen(hotKeyPrevious) != 0 and hotKeyPrevious != hotKeyCurrent){
        Hotkey, %hotKeyPrevious%, Off
    }
    if (StrLen(hotKeyCurrent) != 0){
        Hotkey, %hotKeyCurrent%, On, UseErrorLevel
        Hotkey, %hotKeyCurrent%, HotkeyPressed
    }
    IniWrite, %hotKeyCurrent%, %A_ScriptFullPath%:Stream:$DATA, Settings,hotKeyPrevious
    hotKeyPrevious := hotKeyCurrent
    PMess("Pop Message #1", "Hotkey Saved Successfully", "3981F3", "011167") 
        Gui, Show
            OnMessage(0x0201, "WM_LBUTTONDOWN") 	 ; [PopUp Message Drag PT. 1] 
            Sleep, 1500
        Gui, Destroy
Return
; ———————————— 
ABOUTS:
    PMess("About", "————————————————————————————————`n	Original Author : balawi28`nhttps://github.com/balawi28/AHKFastTranslator`n	  —    —    —    —    —    —    —    —    —`nHow to Use : `n    1. Select Input/Output Languages`n    2. Select Display Style`n    3. Set Interface Hotkey`n    4. Paste in Text to Translate`n    5. Translation will appear Display and Cliboard`n————————————————————————————————", "3981F3", "011167") 
        Gui, Show
            OnMessage(0x0201, "WM_LBUTTONDOWN") 	 ; [PopUp Message Drag PT. 1] 
        Sleep, 7000
        Gui, Destroy
    Return
; ———————————— 
PASTE1:
    IfWinExist, ahk_class Notepad
        {
        WinActivate ahk_class Notepad
        Send ^v`n
        }
    else 
        {
    IfWinNotExist, ahk_class Notepad
        Run, C:\windows\system32\notepad.exe
            WinActivate ahk_class Notepad
            WinWaitActive ahk_class Notepad
            Send ^v`n
        }
Return
; ———— 
PASTE2: 
   IfWinExist ahk_class Notepad++
   { 
      WinActivate
      WinWaitActive
      Send ^n ; open new tab
      Send `n^v`n
   }
   Else {
      Run %A_ProgramFiles%\Notepad++\notepad++.exe
      WinActivate ahk_class Notepad++
      WinWaitActive ahk_class Notepad++
      ; empty tab already opened, we don't need to do this
      Send `n^v`n
   }
Return
; ———————————— 
INLINE:
    PMess("Pop Message #1", "1. Highlighted Editable Text`n2. Press Ctrl+Alt+H`n3. Converts to 'English'`n`nChange to needed language inside script", "3981F3", "011167") 
        Gui, Show
            OnMessage(0x0201, "WM_LBUTTONDOWN") 	 ; [PopUp Message Drag PT. 1] 
            Sleep, 5000
        Gui, Destroy
Return
; ———————————— 
DUMMY:
    Sleep, 10
Return
; ———————————— 
GuiClose:
    GuiControl, , TextToTranslate
    Minimized := True
    Gui, Cancel
Return 
; ———————————— 
RadioChoice:
    gui, submit, nohide
    outputMethod := ChoiceToolTip ? "tooltip" : "msgbox"
    IniWrite, %outputMethod%, %A_ScriptFullPath%:Stream:$DATA, Settings,outputMethod
Return
; ———————————— 
HotkeyPressed:
    if(Minimized){
        IniRead, defaultXPosition, %A_ScriptFullPath%:Stream:$DATA, Settings, defaultXPosition,Center
        IniRead, defaultYPosition, %A_ScriptFullPath%:Stream:$DATA, Settings, defaultYPosition,Center
        Gui, Show, x%defaultXPosition% y%defaultYPosition% w380 h275, TRANSLATOR 
        GuiControl, Focus, TextToTranslate
    }else{
        Goto, GuiClose
    }
    Minimized := ! Minimized
Return
; ———————————— 
StartupToggle:
    isRanAtStartup := !isRanAtStartup
    Menu, Tray, ToggleCheck, Run at Startup
    if(isRanAtStartup)
        FileCreateShortcut,%A_ScriptFullPath%,%A_AppData%\Microsoft\Windows\Start Menu\Programs\Startup\TrayAudioAnalyzer.lnk,%A_ScriptDir%
    else
        FileDelete, %A_AppData%\Microsoft\Windows\Start Menu\Programs\Startup\TrayAudioAnalyzer.lnk
    IniWrite, %isRanAtStartup%, %A_ScriptFullPath%:Stream:$DATA, Settings, isRanAtStartup
Return
;◊───────────── gLabels End ──────────────◊ 

;⯁═══════════════ InLine Translations ═══════════════⯁ (Convert Editable Highlighted Text)
^I:: 				 ; 🡰 🡰 Set Inline Hotkey as needed.
WinActivate % "ahk_id" hWnd
    ClipSave := ClipboardAll
    Clipboard := ""
    Send, {Ctrl down}c{Ctrl up}
    ClipWait, 1
    if ErrorLevel
Return
    Clipboard := GoogleTranslate(Clipboard, "auto", "en") 	 ; 🡰 🡰 Change the 'en' (Clipboard, "auto", "en") to prefered base language 🡰 🡰 
    Send, {Ctrl down}v{Ctrl up}
    Sleep, 500
    Clipboard := ClipSave
Return
;◊──────────── InLine Translations End ─────────────◊ 

;⯁═══════════════ Misc Functions ═══════════════⯁
ExitApplication(){
    ExitApp
    Exit
}
; ———————————— 
ReloadApplication(){
    Reload
}
; ———————————— 
EditScript(){
    Edit
}
; ———————————— 
PostRequest(url){
    response := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    response.Open("POST", url, false)
    response.Send()
    Return response.ResponseText
}
; ———————————— 
TranslateURL(sourceLang, targetLang, textToTranslate)
{
    baseUrl := "http://translate.google.com/translate_a/t?"
    params := []
    params["sl"] := sourceLang
    params["tl"] := targetLang
    params["uptl"] := targetLang
    params["q"] := UriEncode(textToTranslate)
    params["client"] := "p"
    params["hl"] := "en"
    params["sc"] := "2"
    params["ie"] := "UTF-8"
    params["oe"] := "UTF-8"
    params["oc"] := "1"
    params["prev"] := "conf"
    params["psl"] := "auto"
    params["ptl"] := "en"
    params["otf"] := "1"
    params["it"] := "sel.8936"
    params["ssel"] := "0"
    params["tsel"] := "3"
    Return baseUrl . EncodeParams(params)
}
; ———————————— 
Join(dict, delim) {
    result := ""
    for key in dict
    {
        if (result != "")
            result .= delim
        result .= key
    }
    Return result
}
; ———————————— 
FindLanguageIndex(dict, language) {
    index := 1
    for key, value in dict
    {
        if (key == language)
            Return index
        index += 1
    }
    Return -1 ; Language not found, Return -1
}
; ———————————— 
OnSourceLangChange() {
    GuiControlGet, selectedSourceLang, , SourceLang
    IniWrite, %selectedSourceLang%, %A_ScriptFullPath%:Stream:$DATA, Settings, defaultSourceLanguage
}
; ———————————— 
OnTargetLangChange() {
    GuiControlGet, selectedTargetLang, , TargetLang
    IniWrite, %selectedTargetLang%, %A_ScriptFullPath%:Stream:$DATA, Settings, defaultTargetLanguage
}
; ———————————— 
SwapLanguages(){
    GuiControlGet, selectedTargetLang, , TargetLang
    GuiControlGet, selectedSourceLang, , SourceLang
    temp := selectedSourceLang
    GuiControl, Choose, SourceLang, %selectedTargetLang%
    GuiControl, Choose, TargetLang, %temp%
    IniWrite, %selectedTargetLang%, %A_ScriptFullPath%:Stream:$DATA, Settings, defaultSourceLanguage
    IniWrite, %temp%, %A_ScriptFullPath%:Stream:$DATA, Settings, defaultTargetLanguage
}
; ———————————— 
EncodeParams(params)
{
    encodedParams := ""
    for key, value in params
    {
        encodedKey := key
        encodedValue := value
        encodedParams .= (encodedParams = "") ? encodedKey . "=" . encodedValue : "&" . encodedKey . "=" . encodedValue
    }
    Return encodedParams
}
; ———————————— 
; UriEncode function is written by the-Automator  			: URIEncode  -  URIEncode  -  URIEncode
; https://www.the-automator.com/parse-url-parameters/ 
UriEncode(Uri, RE="[0-9A-Za-z]")
{
    VarSetCapacity(Var, StrPut(Uri, "UTF-8"), 0)
    StrPut(Uri, &Var, "UTF-8")
    While Code := NumGet(Var, A_Index-1, "UChar")
    {
        Res .= (Chr := Chr(Code)) ~= RE ? Chr : Format("%{:02X}", Code)
    }
    Return Res
}
;◊───────────── Misc Functions End ──────────────◊ 

;⯁════════ Get Language Dictionaries Function ════════⯁ 
GetLanguagesDict(){
    global dict
    if !dict {
        dict := {}
        dict["Auto-Detect •"] := "auto"
        dict["Afrikaans"] := "af"
        dict["Albanian"] := "sq"
        dict["Amharic"] := "am"
        dict["Arabic"] := "ar"
        dict["Armenian"] := "hy"
        dict["Assamese"] := "as"
        dict["Aymara"] := "ay"
        dict["Azerbaijani"] := "az"
        dict["Bambara"] := "bm"
        dict["Basque"] := "eu"
        dict["Belarusian"] := "be"
        dict["Bengali"] := "bn"
        dict["Bhojpuri"] := "bho"
        dict["Bosnian"] := "bs"
        dict["Bulgarian"] := "bg"
        dict["Catalan"] := "ca"
        dict["Cebuano"] := "ceb"
        dict["Chinese (Simplified)"] := "zh-CN"
        dict["Chinese (Traditional)"] := "zh-TW"
        dict["Corsican"] := "co"
        dict["Croatian"] := "hr"
        dict["Czech"] := "cs"
        dict["Danish"] := "da"
        dict["Dhivehi"] := "dv"
        dict["Dogri"] := "doi"
        dict["Dutch"] := "nl"
        dict["English"] := "en"
        dict["Esperanto"] := "eo"
        dict["Estonian"] := "et"
        dict["Ewe"] := "ee"
        dict["Filipino (Tagalog)"] := "fil"
        dict["Finnish"] := "fi"
        dict["French"] := "fr"
        dict["Frisian"] := "fy"
        dict["Galician"] := "gl"
        dict["Georgian"] := "ka"
        dict["German"] := "de"
        dict["Greek"] := "el"
        dict["Guarani"] := "gn"
        dict["Gujarati"] := "gu"
        dict["Haitian Creole"] := "ht"
        dict["Hausa"] := "ha"
        dict["Hawaiian"] := "haw"
        dict["Hebrew"] := "he"
        dict["Hindi"] := "hi"
        dict["Hmong"] := "hmn"
        dict["Hungarian"] := "hu"
        dict["Icelandic"] := "is"
        dict["Igbo"] := "ig"
        dict["Ilocano"] := "ilo"
        dict["Indonesian"] := "id"
        dict["Irish"] := "ga"
        dict["Italian"] := "it"
        dict["Japanese"] := "ja"
        dict["Javanese"] := "jv"
        dict["Kannada"] := "kn"
        dict["Kazakh"] := "kk"
        dict["Khmer"] := "km"
        dict["Kinyarwanda"] := "rw"
        dict["Konkani"] := "gom"
        dict["Korean"] := "ko"
        dict["Krio"] := "kri"
        dict["Kurdish"] := "ku"
        dict["Kurdish (Sorani)"] := "ckb"
        dict["Kyrgyz"] := "ky"
        dict["Lao"] := "lo"
        dict["Latin"] := "la"
        dict["Latvian"] := "lv"
        dict["Lingala"] := "ln"
        dict["Lithuanian"] := "lt"
        dict["Luganda"] := "lg"
        dict["Luxembourgish"] := "lb"
        dict["Macedonian"] := "mk"
        dict["Maithili"] := "mai"
        dict["Malagasy"] := "mg"
        dict["Malay"] := "ms"
        dict["Malayalam"] := "ml"
        dict["Maltese"] := "mt"
        dict["Maori"] := "mi"
        dict["Marathi"] := "mr"
        dict["Meiteilon (Manipuri)"] := "mni-Mtei"
        dict["Mizo"] := "lus"
        dict["Mongolian"] := "mn"
        dict["Myanmar (Burmese)"] := "my"
        dict["Nepali"] := "ne"
        dict["Norwegian"] := "no"
        dict["Nyanja (Chichewa)"] := "ny"
        dict["Odia (Oriya)"] := "or"
        dict["Oromo"] := "om"
        dict["Pashto"] := "ps"
        dict["Persian"] := "fa"
        dict["Polish"] := "pl"
        dict["Portuguese"] := "pt"
        dict["Punjabi"] := "pa"
        dict["Quechua"] := "qu"
        dict["Romanian"] := "ru"
        dict["Samoan"] := "sm"
        dict["Sanskrit"] := "sa"
        dict["Scots Gaelic"] := "gd"
        dict["Sepedi"] := "nso"
        dict["Serbian"] := "sr"
        dict["Sesotho"] := "st"
        dict["Shona"] := "sn"
        dict["Sindhi"] := "sd"
        dict["Sinhala (Sinhalese)"] := "si"
        dict["Slovak"] := "sk"
        dict["Slovenian"] := "sl"
        dict["Somali"] := "so"
        dict["Spanish"] := "es"
        dict["Sundanese"] := "su"
        dict["Swahili"] := "sw"
        dict["Swedish"] := "sv"
        dict["Tagalog (Filipino)"] := "tl"
        dict["Tajik"] := "tg"
        dict["Tamil"] := "ta"
        dict["Tatar"] := "tt"
        dict["Telugu"] := "te"
        dict["Thai"] := "th"
        dict["Tigrinya"] := "ti"
        dict["Tsonga"] := "ts"
        dict["Turkish"] := "tr"
        dict["Turkmen"] := "tk"
        dict["Twi (Akan)"] := "ak"
        dict["Ukrainian"] := "uk"
        dict["Urdu"] := "ur"
        dict["Uyghur"] := "ug"
        dict["Uzbek"] := "uz"
        dict["Vietnamese"] := "vi"
        dict["Welsh"] := "cy"
        dict["Xhosa"] := "xh"
        dict["Yiddish"] := "yi"
        dict["Yoruba"] := "yo"
        dict["Zulu"] := "zu"
    }
    Return dict
}
;◊───── Get Language Dictionaries Function End ─────◊ 

;⯁════════════ Logo Icons Functions ════════════⯁ 
SwapIcon(){
    Base64PNG := ""
        . "iVBORw0KGgoAAAANSUhEUgAAACAAAAAVCAYAAAAnzezqAAAACXBIWXMAAA3XAAAN1wFCKJt4AAAFyWlU"
        . "WHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhp"
        . "SHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0"
        . "az0iQWRvYmUgWE1QIENvcmUgNy4xLWMwMDAgNzkuYTg3MzFiOSwgMjAyMS8wOS8wOS0wMDozNzozOCAg"
        . "ICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJk"
        . "Zi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRw"
        . "Oi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1l"
        . "bnRzLzEuMS8iIHhtbG5zOnBob3Rvc2hvcD0iaHR0cDovL25zLmFkb2JlLmNvbS9waG90b3Nob3AvMS4w"
        . "LyIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0RXZ0"
        . "PSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VFdmVudCMiIHhtcDpDcmVh"
        . "dG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIDIzLjAgKFdpbmRvd3MpIiB4bXA6Q3JlYXRlRGF0ZT0iMjAy"
        . "My0wNi0zMFQwMjowMToyNSswMzowMCIgeG1wOk1vZGlmeURhdGU9IjIwMjMtMDYtMzBUMDI6MjM6MzUr"
        . "MDM6MDAiIHhtcDpNZXRhZGF0YURhdGU9IjIwMjMtMDYtMzBUMDI6MjM6MzUrMDM6MDAiIGRjOmZvcm1h"
        . "dD0iaW1hZ2UvcG5nIiBwaG90b3Nob3A6Q29sb3JNb2RlPSIzIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAu"
        . "aWlkOjU5NjQ4M2ExLTBiYmQtM2M0Yi05YzMyLWEwZjE5NTRhYzdjNyIgeG1wTU06RG9jdW1lbnRJRD0i"
        . "YWRvYmU6ZG9jaWQ6cGhvdG9zaG9wOmU1OWJmZTNjLWQ3ZjYtNzM0YS1hNjY3LWQzOWI1NmMxMmZmYSIg"
        . "eG1wTU06T3JpZ2luYWxEb2N1bWVudElEPSJ4bXAuZGlkOmQwYmVhNDVkLTU0MTgtMTU0ZS1hNGQ1LTY4"
        . "N2UwZDYxODhiMiI+IDx4bXBNTTpIaXN0b3J5PiA8cmRmOlNlcT4gPHJkZjpsaSBzdEV2dDphY3Rpb249"
        . "ImNyZWF0ZWQiIHN0RXZ0Omluc3RhbmNlSUQ9InhtcC5paWQ6ZDBiZWE0NWQtNTQxOC0xNTRlLWE0ZDUt"
        . "Njg3ZTBkNjE4OGIyIiBzdEV2dDp3aGVuPSIyMDIzLTA2LTMwVDAyOjAxOjI1KzAzOjAwIiBzdEV2dDpz"
        . "b2Z0d2FyZUFnZW50PSJBZG9iZSBQaG90b3Nob3AgMjMuMCAoV2luZG93cykiLz4gPHJkZjpsaSBzdEV2"
        . "dDphY3Rpb249InNhdmVkIiBzdEV2dDppbnN0YW5jZUlEPSJ4bXAuaWlkOjU5NjQ4M2ExLTBiYmQtM2M0"
        . "Yi05YzMyLWEwZjE5NTRhYzdjNyIgc3RFdnQ6d2hlbj0iMjAyMy0wNi0zMFQwMjoyMzozNSswMzowMCIg"
        . "c3RFdnQ6c29mdHdhcmVBZ2VudD0iQWRvYmUgUGhvdG9zaG9wIDIzLjAgKFdpbmRvd3MpIiBzdEV2dDpj"
        . "aGFuZ2VkPSIvIi8+IDwvcmRmOlNlcT4gPC94bXBNTTpIaXN0b3J5PiA8L3JkZjpEZXNjcmlwdGlvbj4g"
        . "PC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PmOrIjcAAAEfSURBVEgNY2DA"
        . "DhKA+D8QL2YYAJAEtRyEXwAx20BZDsKZ9LQ8G83yOHpano9muQM9Lc9Ds/wxEPcA8Vog3gLEm0jAR4B4"
        . "AhAzkuKAF2gOoAb2IcUB09E0PwXinUB8F4jvAPFtEvAbID4MxEJI5nMBsRQhR8xEcsBvIDamYhTvg5pb"
        . "TYojvgKxFhUsZwXi50jm1hLSMAEtOuyo4Ah3NDPbCGnoRlL8DIhZqOAIKzRHdBPS0AlVeIqKacEMiP+S"
        . "4ghNIBZA4vMB8WYgvg/E50jA56H0KiB+QmpIIANfGpQXL0lxAKhWXAjEl4D4AAn4EDQrzoaWssgOqKZn"
        . "kW+JZnktPS0PRrO8lJ6Wx6BZnk9Py9nQKju6Wg4Da6CW52CTBADLm7B1N75ElAAAAABJRU5ErkJggg=="
    Return Base64PNG
}
; ———————————— 
TrayIcon(){
    Base64PNG := ""
        . "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAACXBIWXMAAAsTAAALEwEAmpwYAAAGSWlU"
        . "WHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhp"
        . "SHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0"
        . "az0iQWRvYmUgWE1QIENvcmUgNy4xLWMwMDAgNzkuYTg3MzFiOSwgMjAyMS8wOS8wOS0wMDozNzozOCAg"
        . "ICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJk"
        . "Zi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRw"
        . "Oi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94"
        . "YXAvMS4wL21tLyIgeG1sbnM6c3RFdnQ9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9S"
        . "ZXNvdXJjZUV2ZW50IyIgeG1sbnM6cGhvdG9zaG9wPSJodHRwOi8vbnMuYWRvYmUuY29tL3Bob3Rvc2hv"
        . "cC8xLjAvIiB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iIHhtcDpDcmVh"
        . "dG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIDIzLjAgKFdpbmRvd3MpIiB4bXA6Q3JlYXRlRGF0ZT0iMjAy"
        . "My0wNy0xMlQxNjoyMToxMiswMzowMCIgeG1wOk1ldGFkYXRhRGF0ZT0iMjAyMy0wNy0xMlQxNjoyMTox"
        . "MiswMzowMCIgeG1wOk1vZGlmeURhdGU9IjIwMjMtMDctMTJUMTY6MjE6MTIrMDM6MDAiIHhtcE1NOklu"
        . "c3RhbmNlSUQ9InhtcC5paWQ6NzgyODIyMDEtYzYwYi05MzQxLTkwNzktMTA0NjI2YjA5MDFmIiB4bXBN"
        . "TTpEb2N1bWVudElEPSJhZG9iZTpkb2NpZDpwaG90b3Nob3A6ZGM5MjljYTItYjM5MS00ZTQ1LTkyZWIt"
        . "ODYyMWIzZmM3NGViIiB4bXBNTTpPcmlnaW5hbERvY3VtZW50SUQ9InhtcC5kaWQ6ZWZlYTBmN2MtNjQ4"
        . "MS1kYzRlLTg0MDgtYzlhNjBkNDAyYmJmIiBwaG90b3Nob3A6Q29sb3JNb2RlPSIzIiBkYzpmb3JtYXQ9"
        . "ImltYWdlL3BuZyI+IDx4bXBNTTpIaXN0b3J5PiA8cmRmOlNlcT4gPHJkZjpsaSBzdEV2dDphY3Rpb249"
        . "ImNyZWF0ZWQiIHN0RXZ0Omluc3RhbmNlSUQ9InhtcC5paWQ6ZWZlYTBmN2MtNjQ4MS1kYzRlLTg0MDgt"
        . "YzlhNjBkNDAyYmJmIiBzdEV2dDp3aGVuPSIyMDIzLTA3LTEyVDE2OjIxOjEyKzAzOjAwIiBzdEV2dDpz"
        . "b2Z0d2FyZUFnZW50PSJBZG9iZSBQaG90b3Nob3AgMjMuMCAoV2luZG93cykiLz4gPHJkZjpsaSBzdEV2"
        . "dDphY3Rpb249InNhdmVkIiBzdEV2dDppbnN0YW5jZUlEPSJ4bXAuaWlkOjc4MjgyMjAxLWM2MGItOTM0"
        . "MS05MDc5LTEwNDYyNmIwOTAxZiIgc3RFdnQ6d2hlbj0iMjAyMy0wNy0xMlQxNjoyMToxMiswMzowMCIg"
        . "c3RFdnQ6c29mdHdhcmVBZ2VudD0iQWRvYmUgUGhvdG9zaG9wIDIzLjAgKFdpbmRvd3MpIiBzdEV2dDpj"
        . "aGFuZ2VkPSIvIi8+IDwvcmRmOlNlcT4gPC94bXBNTTpIaXN0b3J5PiA8cGhvdG9zaG9wOlRleHRMYXll"
        . "cnM+IDxyZGY6QmFnPiA8cmRmOmxpIHBob3Rvc2hvcDpMYXllck5hbWU9Iti5IiBwaG90b3Nob3A6TGF5"
        . "ZXJUZXh0PSLYuSIvPiA8L3JkZjpCYWc+IDwvcGhvdG9zaG9wOlRleHRMYXllcnM+IDwvcmRmOkRlc2Ny"
        . "aXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+WwrQuAAAAjtJ"
        . "REFUWMO9VztuwkAQNSeAipomkAIJxAmQ0lByBAoOQIdEhbgAhQ9ASRVRcACOABIFRSTo0xgSORRImfg5"
        . "HjOYtRfshZGm8O545+183mgtIrI8efH03dODp8TabDZpOBz62ul0SO5l0EPg6yXwbVU8dVTGcMzSbrdN"
        . "AWB1At8+GtIBQDQMAyDfd7fb/VksFqTS3W4XAlgulxRnV6/X0wL4tuQt00qm6MhCk8JrUsfjMW02myub"
        . "UqmUJQ3nj8lk4h+M0BeLxSvjWq1G8/nct+n1eqbq4PyBXEJOpxPZtn1hmMvlaDQa+fuO41ChUDAPAIqi"
        . "griuS+VyOVyvVqt0PB7D0BvshMsF5JMFKcHN8/l8GHqkx3ArJvd/q9Wifr//SD5Qb3Aq1ut1yAcG6TgZ"
        . "ANLAAKTMZrObWw5gYS+JDClVFO+lY/S6TnBQEhDpWEtaaL0oWoka+3Fsif0oEekucMUfqsOR82i+4YSJ"
        . "KipyFoAjmCuiZ8BOMTcs/yacY93YBRCA5n8kJyC8Kcb3/6FpmC36n+QQFVXj9ljHRbVtmFY5MhwdRAV1"
        . "IUc7OuxhAHBLroOkLnoYAOaAOEGEIvVh1jkOVxEYQMVwhznncCDDfyNzmgMgSSiS5+cA4Eq/c2SbAxDT"
        . "Zs8DIPN/B7GZAyBnBdrtxtF9+R7MonIW8EACKLSmKiKNRsNNfJpl7QSdTKfTDwB4jXucZiEjHR1DBoPB"
        . "mxU8kStBJL5MUzJSgK5gQPv9/ne1Wn1ut1sbvv8Akdi/PNdSy+EAAAAASUVORK5CYII="
    Return Base64PNG
}
; ———————————— 
GoogleTranslateLogo(){
    Base64PNG := ""
        . "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAACXBIWXMAAAsTAAALEwEAmpwYAAAGlmlU"
        . "WHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhp"
        . "SHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0"
        . "az0iQWRvYmUgWE1QIENvcmUgNy4xLWMwMDAgNzkuYTg3MzFiOSwgMjAyMS8wOS8wOS0wMDozNzozOCAg"
        . "ICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJk"
        . "Zi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRw"
        . "Oi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1l"
        . "bnRzLzEuMS8iIHhtbG5zOnBob3Rvc2hvcD0iaHR0cDovL25zLmFkb2JlLmNvbS9waG90b3Nob3AvMS4w"
        . "LyIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0RXZ0"
        . "PSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VFdmVudCMiIHhtcDpDcmVh"
        . "dG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIDIzLjAgKFdpbmRvd3MpIiB4bXA6Q3JlYXRlRGF0ZT0iMjAy"
        . "My0wNi0yMFQyMDoyOToxNCswMzowMCIgeG1wOk1vZGlmeURhdGU9IjIwMjMtMDYtMjBUMjE6MTA6MTYr"
        . "MDM6MDAiIHhtcDpNZXRhZGF0YURhdGU9IjIwMjMtMDYtMjBUMjE6MTA6MTYrMDM6MDAiIGRjOmZvcm1h"
        . "dD0iaW1hZ2UvcG5nIiBwaG90b3Nob3A6Q29sb3JNb2RlPSIzIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAu"
        . "aWlkOjgwYjExNTNlLTRjN2EtMDg0YS04MzU3LTRiZWNhYzRkZTE3YyIgeG1wTU06RG9jdW1lbnRJRD0i"
        . "YWRvYmU6ZG9jaWQ6cGhvdG9zaG9wOjNkZmFjNDUxLThhZTQtOTc0MS04MmE1LTZiNTVkYmRhYzlkZCIg"
        . "eG1wTU06T3JpZ2luYWxEb2N1bWVudElEPSJ4bXAuZGlkOjUyYWI3YjQ2LTQwNzMtNTE0YS05NWM3LWQ3"
        . "YTU0Y2Y1OWI3OCI+IDx4bXBNTTpIaXN0b3J5PiA8cmRmOlNlcT4gPHJkZjpsaSBzdEV2dDphY3Rpb249"
        . "ImNyZWF0ZWQiIHN0RXZ0Omluc3RhbmNlSUQ9InhtcC5paWQ6NTJhYjdiNDYtNDA3My01MTRhLTk1Yzct"
        . "ZDdhNTRjZjU5Yjc4IiBzdEV2dDp3aGVuPSIyMDIzLTA2LTIwVDIwOjI5OjE0KzAzOjAwIiBzdEV2dDpz"
        . "b2Z0d2FyZUFnZW50PSJBZG9iZSBQaG90b3Nob3AgMjMuMCAoV2luZG93cykiLz4gPHJkZjpsaSBzdEV2"
        . "dDphY3Rpb249InNhdmVkIiBzdEV2dDppbnN0YW5jZUlEPSJ4bXAuaWlkOmIxZDI4M2JiLTU0MmQtOWE0"
        . "Yy1iOWQxLTdhODg2MjM2ODY3MyIgc3RFdnQ6d2hlbj0iMjAyMy0wNi0yMFQyMToxMDoxNiswMzowMCIg"
        . "c3RFdnQ6c29mdHdhcmVBZ2VudD0iQWRvYmUgUGhvdG9zaG9wIDIzLjAgKFdpbmRvd3MpIiBzdEV2dDpj"
        . "aGFuZ2VkPSIvIi8+IDxyZGY6bGkgc3RFdnQ6YWN0aW9uPSJzYXZlZCIgc3RFdnQ6aW5zdGFuY2VJRD0i"
        . "eG1wLmlpZDo4MGIxMTUzZS00YzdhLTA4NGEtODM1Ny00YmVjYWM0ZGUxN2MiIHN0RXZ0OndoZW49IjIw"
        . "MjMtMDYtMjBUMjE6MTA6MTYrMDM6MDAiIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkFkb2JlIFBob3Rvc2hv"
        . "cCAyMy4wIChXaW5kb3dzKSIgc3RFdnQ6Y2hhbmdlZD0iLyIvPiA8L3JkZjpTZXE+IDwveG1wTU06SGlz"
        . "dG9yeT4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBl"
        . "bmQ9InIiPz5wF6l/AAAIGElEQVRYw5WXe4xcZRnGf9/3nXPmtrM7u9vt7raltmUpWGjlUtqUhhYqSsNF"
        . "BQ0kSFViJAaDIJoWLzH+04hAohgCjRgkSALRQIioBI2mFrSBQqWEBtpCAbvt3nd25z5zzve9/jGzl9lu"
        . "KT3JyTlzbu/zPe/leUb94sl3GKmmg49KbT8CWaqEEEAaO4BMnTTOBe0rV9mvo8LDaA8EtIH3By03XerY"
        . "/pU2SuWAV197jWx2lPb2Rfh+DyKWkZETZDJxli3rxVrwrJiWXBjsqDnzk0Bb3FSgWQCYc02UQmFuaLW1"
        . "h7WLECCqQbe2rF0eJwpPfvdUm3c41/HjfBS/19cA+hO+pnFeImNz2TWEk28pL0b/QIVtn+9iy+pWxgoQ"
        . "j3/CL2XD+FKFoJBpqudDP/uaEkGURyFYcIONpzleTtGzOMP1mxcwMmE5k037yhVm51nmBpT5wAhagZjk"
        . "TaOHj1PpP87d12VIxDyKFUGpMwAgs3N7modnF6OyNSTZvmqw3LXqxo3trFmZZDgboTUopVBKYa0liiKs"
        . "dTgnOCdEkcVaN1MDH0c186RkmiEnFGyM1Zd2/uCLV0Y/HJnANBaunHNYawmCgEQiQRD4eJ5CRJFIBCoI"
        . "vIpzMiqi8OZbtWrs2TJMlFSdUoGOFiEVA9d4ydVqBB1dt1k9eJuvPTwfwFGtVqhUyvT19TWYk+njsmUr"
        . "AJFazT5mrd3pzeVdK6hGMDCpWL1E2LYxYklGODig+de7mvGioiMpWIGWWMR72XYOnhjmkhVZ/HgXIoJz"
        . "DhFBa90ILtMgQKEUCrjdGCUnpaAawUhBcccWy21XhA3SFZ9dE/HdqxXfeypg31HNgpZ6IRaqhqMTbVxS"
        . "O0F2IkZ7phWlVBOQmRqqg6nfByDVlAKt4MSk4p7PRdxyeY0j/R4PvOSRKyvWLXesWeIYmlCkYlInTiDh"
        . "OQ6OJLm6pKlQRAGZTCsKsPa0LVltSkG+qji3R7hlY8TQuOH2JwNy5Tqwlw/VH13YKiQCiPmCAtKxkI8m"
        . "U/RP+pzV6SiVyvi+5qzeHgqlMrliCaNPPeCaGMgW4apVDrTwx30+g5PQ3QpfvsSyYaWlVFZYgYmi4ol/"
        . "G2oR+J4wXIrx1lCGT/eM4uLt9A8Nc/9Tz7Pl0ov4wuVrGc/lp9tYoeotL/W6aAJgBWJ+/TxXAV9Drgwr"
        . "u4W1KyyuqtCxOvXPvGbIV8AzkPAs+wfb+NIFE3SlEvQDu18/wLLuhfiJzSSqNcTVe19rTaUWUm20UlMR"
        . "JgM4Nlbv5o0rHL972WNFxvH4K4b7XvRQwPN3VhEHo4UGWIG2wDFp0zzw3H50+AJVCVjW28Pr7xzhjp0P"
        . "sbCjnTCyjE7kGM3l+NrWzWxdfyEj2UmaaqAjKew5rDlyzLB5dcT2axS/3eNxeFDRnhJ2XBPRmrb85h8B"
        . "YwXF0o4p/bCMV2Isbz2frStakHg32mjK1SqxwOOve99kLF9m29ZNjOXzLOnqpFiuIMxJgdbgG9jxrM+u"
        . "bwjf2hJy/RrLmx9ptqxyBAnH/vd9Htvj0dPaLF4uCkktuICzukNKtHD+2UswRmGM4ZFn/8bVGy7iuis3"
        . "IrUy2VyRyUIRo1Wz/jqBnjbheFaxbVeMP+z18QxsXWMZyCke3+1z99M+KR/iXvNozsQi/pdP8ad9A3zn"
        . "vl/z6sHDJDMd7HruJSJnuXbDRQwPDjA4NkG5WsUzutEFcyZhLYJFGSFXhp0veOza7RH3hXxFkStCd5uQ"
        . "DCByNA0YTzsODTlu3LSZrZNH+P2Le4jHfJ7++yvcdfO1LO3p4oPjQ8TjMYIgmJmWc9VQqH88GYOlnULM"
        . "CNZCOpD6b+/k4HUFUIhY3hoM2H7r9fiexz0PPcGNV6znhk3r6R8ew/MMURQRhiGqodmnnhANNJ6GwIDR"
        . "c33izHyfutYRjzgwEOeND0N86jJcKFdAQSIWYJ2blukwDOsMMB8FMr8XnJomswPPNi5xY6noODuePEBS"
        . "l/nV3d9k9xsHufeRp2hLJWlrSU6DmJJsrY32ToVhvhXLx/gGJ4pS2bF4+QZu3bqF9atW8uCdX2fv24f4"
        . "/sNPICIkYgEiMpMCiwTGN41VqeZVSzPVJ7tl1WRaBDCuAsk+Qm8hhz44yrmfWsyj22/nlQPv8stn/kx7"
        . "uqUJvPE7rxmLtaSvSKZT7S4Kpz81ZVTn8qGkcc9ZrA7QqQT4AcoPwAvwYz79Zc2SdJWLFxUYzkUs713I"
        . "Z/qW07ugg47WFNGMSv7XO7Ln7T2VirvwvKsuu6cW6XZBPt4aCmgcNa8lihXH17n+E5eLl5hmyTOK8Q8d"
        . "xzKK+MVxTKg4MZZldd9SrLVk80UC359RQ60cYsNcpRb+TFCIO401VVCWGAkTstbs7fzPweyojidRgDFw"
        . "9HjI6sUeN6/rY6SQBiUYrRmfzDcAmjkOzBi0MeiGT1LqNLsIFWKsS77HZefasZ5zeveVVQovnWYgn+Ds"
        . "lR3cv/M8Mp1JqpU61a6hhGqWX59iTJ/JnwiFUFRpeuU4bROHeHcoRToZPa6VYnjU0tqi+fmOXtpafcYn"
        . "LEYLIu6kvp4Kboz2zwhAlThtXon13l6qYYl8PsvCtvJfylVHZIWf3tXNgs6AkTGL56lZTaVOGl5Ga8Ja"
        . "aLwzWT9a0TtxkGKkKZpFaARr3bGFndF73/7qgr7zz4kxMBTiB7oRjHlTYIyiWKz+8+iHIw9+YgCiDXFb"
        . "hMksx2wKqxWIIl8Q1q5O7lx/YWLT0GjktNZT3qt+aDjkWZKvbeRKk7nKrnwxevv/sZ0p2Ci1PVEAAAAA"
        . "SUVORK5CYII="
    Return Base64PNG
}
; ———————————— 
Base64PNG_to_HICON(Base64PNG, W:=0, H:=0){
    BLen:=StrLen(Base64PNG), Bin:=0, nBytes:=Floor(StrLen(RTrim(Base64PNG,"="))*3/4)
    Return DllCall("Crypt32.dll\CryptStringToBinary", "Str",Base64PNG, "UInt",BLen, "UInt",1,"Ptr",&(Bin:=VarSetCapacity(Bin,nBytes)), "UIntP",nBytes, "UInt",0, "UInt",0)? DllCall("CreateIconFromResourceEx", "Ptr",&Bin, "UInt",nBytes, "Int",True, "UInt",0x30000, "Int",W, "Int",H, "UInt",0, "UPtr") : 0
}
Return
;◊──────── Logo Icons Functions End ─────────◊ 

;⯁════════════ Google Translate Functions ════════════⯁ 

GoogleTranslate(str, from := "auto", to := "en") {
   static JS := CreateScriptObj(), _ := JS.( GetJScript() ) := JS.("delete ActiveXObject; delete GetObject;")
   
   json := SendRequest(JS, str, to, from, proxy := "")
   oJSON := JS.("(" . json . ")")

   if !IsObject(oJSON[1]) {
      Loop % oJSON[0].length
         trans .= oJSON[0][A_Index - 1][0]
   }
   else {
      MainTransText := oJSON[0][0][0]
      Loop % oJSON[1].length {
         trans .= "`n+"
         obj := oJSON[1][A_Index-1][1]
         Loop % obj.length {
            txt := obj[A_Index - 1]
            trans .= (MainTransText = txt ? "" : "`n" txt)
         }
      }
   }
   if !IsObject(oJSON[1])
      MainTransText := trans := Trim(trans, ",+`n ")
   else
      trans := MainTransText . "`n+`n" . Trim(trans, ",+`n ")

   from := oJSON[2]
   trans := Trim(trans, ",+`n ")
   Return trans
}

SendRequest(JS, str, tl, sl, proxy) {
   static http
   ComObjError(false)
   if !http
   {
      http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
      ( proxy && http.SetProxy(2, proxy) )
      http.open("GET", "https://translate.google.com", true)
      http.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0")
      http.send()
      http.WaitForResponse(-1)
   }
   http.open("POST", "https://translate.googleapis.com/translate_a/single?client=gtx"
                ; or "https://clients5.google.com/translate_a/t?client=dict-chrome-ex"
      . "&sl=" . sl . "&tl=" . tl . "&hl=" . tl
      . "&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&ie=UTF-8&oe=UTF-8&otf=0&ssel=0&tsel=0&pc=1&kc=1"
      . "&tk=" . JS.("tk").(str), true)

   http.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=utf-8")
   http.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0")
   http.send("q=" . URIEncode(str))
   http.WaitForResponse(-1)
   Return http.responsetext
}

URIEncode2(str, encoding := "UTF-8")  {
   VarSetCapacity(var, StrPut(str, encoding))
   StrPut(str, &var, encoding)

   while code := NumGet(Var, A_Index - 1, "UChar")  {
      bool := (code > 0x7F || code < 0x30 || code = 0x3D)
      UrlStr .= bool ? "%" . Format("{:02X}", code) : Chr(code)
   }
   Return UrlStr
}

GetJScript()
{
   script =
   (
      var TKK = ((function() {
        var a = 561666268;
        var b = 1526272306;
        return 406398 + '.' + (a + b);
      })());

      function b(a, b) {
        for (var d = 0; d < b.length - 2; d += 3) {
            var c = b.charAt(d + 2),
                c = "a" <= c ? c.charCodeAt(0) - 87 : Number(c),
                c = "+" == b.charAt(d + 1) ? a >>> c : a << c;
            a = "+" == b.charAt(d) ? a + c & 4294967295 : a ^ c
        }
        return a
      }

      function tk(a) {
          for (var e = TKK.split("."), h = Number(e[0]) || 0, g = [], d = 0, f = 0; f < a.length; f++) {
              var c = a.charCodeAt(f);
              128 > c ? g[d++] = c : (2048 > c ? g[d++] = c >> 6 | 192 : (55296 == (c & 64512) && f + 1 < a.length && 56320 == (a.charCodeAt(f + 1) & 64512) ?
              (c = 65536 + ((c & 1023) << 10) + (a.charCodeAt(++f) & 1023), g[d++] = c >> 18 | 240,
              g[d++] = c >> 12 & 63 | 128) : g[d++] = c >> 12 | 224, g[d++] = c >> 6 & 63 | 128), g[d++] = c & 63 | 128)
          }
          a = h;
          for (d = 0; d < g.length; d++) a += g[d], a = b(a, "+-a^+6");
          a = b(a, "+-3^+b+-f");
          a ^= Number(e[1]) || 0;
          0 > a && (a = (a & 2147483647) + 2147483648);
          a `%= 1E6;
          return a.toString() + "." + (a ^ h)
      }
   )
   Return script
}

CreateScriptObj() {
   static doc, JS, _JS
   if !doc {
      doc := ComObjCreate("htmlfile")
      doc.write("<meta http-equiv='X-UA-Compatible' content='IE=9'>")
      JS := doc.parentWindow
      if (doc.documentMode < 9)
         JS.execScript()
      _JS := ObjBindMethod(JS, "eval")
   }
   Return _JS
}
;◊───────── Google Translate Functions End ──────────◊ 

;;∙============================================================∙
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
    Reload:
        Soundbeep, 1200, 250
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
    Exit:
        Soundbeep, 1000, 300
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
#MaxThreadsPerHotkey 3    ;;∙------∙Sets the maximum simultaneous threads for each hotkey.
#NoEnv    ;;∙------∙Avoids checking empty environment variables for optimization.
;;∙------∙#NoTrayIcon    ;;∙------∙Hides the tray icon if uncommented.
#Persistent    ;;∙------∙Keeps the script running indefinitely.
#SingleInstance, Force    ;;∙------∙Prevents multiple instances of the script and forces new execution.
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.
SendMode, Input    ;;∙------∙Sets SendMode to Input for faster and more reliable keystrokes.
SetBatchLines -1    ;;∙------∙Disables batch line delays for immediate execution of commands.
SetTimer, UpdateCheck, 500    ;;∙------∙Sets a timer to call UpdateCheck every 500 milliseconds.
SetTitleMatchMode 2    ;;∙------∙Enables partial title matching for window detection.
SetWinDelay 0    ;;∙------∙Removes delays between window-related commands.
Menu, Tray, Icon, % "HICON:" . Base64PNG_to_HICON(TrayIcon())    ;;∙------∙Sets the system tray icon.
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
TRANSLATOR:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

