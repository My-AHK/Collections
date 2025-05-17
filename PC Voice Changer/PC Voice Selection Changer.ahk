
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  
» Original Source:  
» 
    ▹ 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TEMPLATE"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙

;;∙======∙HotKey∙===============================================∙
^t::    ;;∙------∙🔥∙(Ctrl + T)
 ;   Soundbeep, 1000, 200
;;∙============================================================∙




;;∙============================================================∙
;;∙============================================================∙
if (SUCCEEDED(SpGetCategoryFromId(SPCAT_VOICES := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Speech\Voices", cpSpObjectTokenCategory)))
{
    hr := DllCall(NumGet(NumGet(cpSpObjectTokenCategory + 0) + 18 * A_PtrSize), "Ptr", cpSpObjectTokenCategory, "Ptr", 0, "Ptr", 0, "Ptr*", cpSpEnumTokens)

    if (SUCCEEDED(hr))
    {
        hr := DllCall(NumGet(NumGet(cpSpEnumTokens + 0) + 8 * A_PtrSize), "Ptr", cpSpEnumTokens, "UInt*", tokenCount)

        if (SUCCEEDED(hr))
        {
            voices := Object()
            Loop % tokenCount
            {
                hr := DllCall(NumGet(NumGet(cpSpEnumTokens + 0) + 7 * A_PtrSize), "Ptr", cpSpEnumTokens, "UInt", A_Index - 1, "Ptr*", pToken)
                if (FAILED(hr)) {
                    MsgBox Bailing out
                    ExitApp 1
                }

                hr := DllCall(NumGet(NumGet(pToken + 0) + 6 * A_PtrSize), "Ptr", pToken, "Ptr", 0, "Ptr*", pszValue)
                if (FAILED(hr)) {
                    MsgBox Bailing out
                    ExitApp 2
                }

                hr := DllCall(NumGet(NumGet(pToken + 0) + 16 * A_PtrSize), "Ptr", pToken, "Ptr*", pszCoMemTokenId)
                if (FAILED(hr)) {
                    MsgBox Bailing out
                    ExitApp 3
                }

                voices[StrGet(pszCoMemTokenId, "UTF-16")] := StrGet(pszValue, "UTF-16")
                DllCall("ole32\CoTaskMemFree", "Ptr", pszValue)
                DllCall("ole32\CoTaskMemFree", "Ptr", pszCoMemTokenId)
                ObjRelease(pToken)
            }

            prompt := "Pick a voice by its number:"
            for k, v in voices
                prompt .= "`r`n" . A_Index . ": " v

            InputBox, TheChosenOne,, %prompt%
            if (ErrorLevel == 0)
            {
                for k, v in voices
                {
                    if (A_Index == TheChosenOne)
                    {
                        ;;∙------∙ Set the selected voice token.
                        hr := DllCall(NumGet(NumGet(cpSpObjectTokenCategory + 0) + 19 * A_PtrSize), "Ptr", cpSpObjectTokenCategory, "WStr", k)

                        if (SUCCEEDED(hr))
                        {
                            ;;∙------∙ Create voice object and set its voice to selected token.
                            voice := ComObjCreate("SAPI.SpVoice")
                            voice.Voice := ComObjCreate("SAPI.SpObjectToken")
                            voice.Voice.SetId(k)

                            ;;∙------∙ Get the full name of the selected voice.
                            voiceName := voices[k]  ;;∙------∙ Get the name of the selected voice.

                            ;;∙------∙ Extract the company and voice name by splitting the name at " - ".
                            voiceParts := StrSplit(voiceName, " - ")
                            voiceCompanyAndName := voiceParts[1]  ;;∙------∙ The first part before " - " is the company and voice name.

                            ;;∙------∙ Speak the message including the company and voice name.
                            voice.Speak("This voice has been successfully selected. My name is " . voiceCompanyAndName)
                        }
                        break
                    }
                }
            }
        }

        ObjRelease(cpSpEnumTokens)
    }

    ObjRelease(cpSpObjectTokenCategory)
}

SpGetCategoryFromId(pszCategoryId, ByRef ppCategory, fCreateIfNotExist := False)
{
    static CLSID_SpObjectTokenCategory := "{A910187F-0C7A-45AC-92CC-59EDAFB77B53}"
         , ISpObjectTokenCategory     := "{2D3D3845-39AF-4850-BBF9-40B49780011D}"

    hr := 0
    try
    {
        cpTokenCategory := ComObjCreate(CLSID_SpObjectTokenCategory, ISpObjectTokenCategory)
    }
    catch e
    {
        if (RegExMatch(e.Message, "0[xX][0-9a-fA-F]+", errCode)) {
            hr := errCode + 0
        } else {
            hr := 0x80004005
        }
    }

    if (SUCCEEDED(hr))
    {
        hr := DllCall(NumGet(NumGet(cpTokenCategory + 0) + 15 * A_PtrSize), "Ptr", cpTokenCategory, "WStr", pszCategoryId, "Int", fCreateIfNotExist)
    }

    if (SUCCEEDED(hr))
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

SUCCEEDED(hr)
{
    return hr != "" && hr >= 0x00
}

FAILED(hr)
{
    return hr == "" || hr < 0
}
Return
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
        Soundbeep, 1200, 250
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
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
 ;   Soundbeep, 1700, 100
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
Menu, Tray, Icon, imageres.dll, 3    ;;∙------∙Sets the system tray icon.
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

