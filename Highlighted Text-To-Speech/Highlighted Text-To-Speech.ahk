
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙----------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙--------------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
» 
∙--------∙Origins∙-------------------------∙
» Author:  tabnation
» Source:  https://pastebin.com/LyrA2fQ2
» F1 - Computer speaks highlighted text.
» F2 - Change computer voice.
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "Highlighted_Text-To-Speech"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙🔥 HotKey 🔥∙===========================================∙
; ^t::    ;;∙------∙(Ctrl+T) 
;    Soundbeep, 1100, 100
;;∙============================================================∙




;;∙============================================================∙
global voices := []    ;;∙------∙Declare a global array for voice caching.

F1::    ;;∙------∙Highlighted text read aloud by SAPI voice of choice.

SoundGet, master_volume    ;;∙------∙Records current volume % level.
SoundGet, current_volume
if (current_volume < 35) {
    SoundSet, 15    ;;∙------∙Sets PC volume to 35% if needed.
}

ClipSaved := ClipboardAll    ;;∙------∙Save current clipboard content.
Clipboard := ""              ;;∙------∙Clear the clipboard to detect if text is selected.
Send ^c
ClipWait, 0.5                ;;∙------∙Wait for the clipboard to contain data.

if !Clipboard {              ;;∙------∙If no text was copied, show the message.
    Clipboard := ClipSaved   ;;∙------∙Restore original clipboard content.
    MsgBox, , , No Text Selected, 3
} else {
    ComObjCreate("SAPI.SpVoice").Speak(Clipboard)  ;;∙------∙Speaks only if clipboard contains text.
    Clipboard := ClipSaved   ;;∙------∙Restore original clipboard content.
}

SoundSet, %master_volume%    ;;∙------∙Returns volume % level to previously recorded level.
Sleep, 50
Return

;;∙------------------------------------------------------------------------------------------∙
F2::    ;;∙------∙Change voice type.

if (!voices.MaxIndex()) {    ;;∙------∙Only fetch voices if the array is empty.
    if (SpGetCategoryFromId(SPCAT_VOICES := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Speech\Voices", cpSpObjectTokenCategory) >= 0) {
        hr := DllCall(NumGet(NumGet(cpSpObjectTokenCategory+0)+18*A_PtrSize), "Ptr", cpSpObjectTokenCategory, "Ptr", 0, "Ptr", 0, "Ptr*", cpSpEnumTokens)
        if (hr >= 0) {
            hr := DllCall(NumGet(NumGet(cpSpEnumTokens+0)+8*A_PtrSize), "Ptr", cpSpEnumTokens, "UInt*", tokenCount)
            if (hr >= 0) {
                Loop %tokenCount% {
                    hr := DllCall(NumGet(NumGet(cpSpEnumTokens+0)+7*A_PtrSize), "Ptr", cpSpEnumTokens, "UInt", A_Index - 1, "Ptr*", pToken)
                    if (hr >= 0) {
                        hr := DllCall(NumGet(NumGet(pToken+0)+6*A_PtrSize), "Ptr", pToken, "Ptr", 0, "Ptr*", pszValue)
                        hr := DllCall(NumGet(NumGet(pToken+0)+16*A_PtrSize), "Ptr", pToken, "Ptr*", pszCoMemTokenId)
                        voices[StrGet(pszCoMemTokenId, "UTF-16")] := StrGet(pszValue, "UTF-16")
                        DllCall("ole32\CoTaskMemFree", "Ptr", pszValue)
                        DllCall("ole32\CoTaskMemFree", "Ptr", pszCoMemTokenId)
                        ObjRelease(pToken)
                    }
                }
            }
        }
        ObjRelease(cpSpEnumTokens)
    }
    ObjRelease(cpSpObjectTokenCategory)
}

prompt := "`n`tSelect A Voice By Number:`n"
for k, v in voices
    prompt .= "`r`n" . A_Index . ": " v

InputBox, TheChosenOne, , %prompt%, , 333, , , , , 15, #
if (ErrorLevel == 0) {
    for k, v in voices {
        if (A_Index == TheChosenOne) {
            hr := DllCall(NumGet(NumGet(cpSpObjectTokenCategory+0)+19*A_PtrSize), "Ptr", cpSpObjectTokenCategory, "WStr", k)
            break
        }
    }
}
Return

;;∙======∙Helper Functions∙======================================∙
SpGetCategoryFromId(pszCategoryId, ByRef ppCategory, fCreateIfNotExist := False)
{
    static CLSID_SpObjectTokenCategory := "{A910187F-0C7A-45AC-92CC-59EDAFB77B53}"
          ,ISpObjectTokenCategory      := "{2D3D3845-39AF-4850-BBF9-40B49780011D}"
     hr := 0
    try {
        cpTokenCategory := ComObjCreate(CLSID_SpObjectTokenCategory, ISpObjectTokenCategory)
    } catch e {
        if (RegExMatch(e.Message, "0[xX][0-9a-fA-F]+", errCode)) {
            hr := errCode + 0
        } else {
            hr := 0x80004005
        }
    }
     if (hr >= 0)
    {
        hr := DllCall(NumGet(NumGet(cpTokenCategory+0)+15*A_PtrSize), "Ptr", cpTokenCategory, "WStr", pszCategoryId, "Int", fCreateIfNotExist)
    }
     if (hr >= 0)
    {
        ppCategory := cpTokenCategory
    } 
    else
    {
        if (cpTokenCategory)
            ObjRelease(cpTokenCategory)
    }
     return hr
}
Return
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
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙--∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        SoundBeep, 1100, 75
        Soundbeep, 1200, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙--∙Double-Tap.
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
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;; Gui Drag Pt 1.
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
Menu, Tray, Icon, Suspend / Pause, shell32, 28  ;  Imageres.dll, 65
Menu, Tray, Default, Suspend / Pause    ;;∙------∙Makes Bold.
Menu, Tray, Add
;;------------------------------------------∙

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
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙MENU CALLS∙==========================================∙
Highlighted_Text-To-Speech:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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
;;∙======∙TRAY MENU POSITION FUNTION∙======∙
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
;;∙============================================================∙

;;∙------------------------------------------------------------------------------------------∙
;;∙========================∙SCRIPT END∙=========================∙
;;∙------------------------------------------------------------------------------------------∙

