
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
» Multiple examples using SAPI Voice.
    ▹ 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "SAPI_Sampler"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
;;∙============∙SAPI "NORMAL" VOCAL SAMPLE∙===================∙
;;∙------∙Plays default system voice at default system settings∙---------------∙

^F1::    ;;∙------∙🔥∙(Ctrl + F1)
    Soundbeep, 1000, 200

spokenText := "Text is being spoken normally by the currently active SAPI voice."

ComObjCreate("SAPI.SpVoice").Speak(spokenText)  
Return

;;∙============================================================∙



;;∙============∙SAPI "FLUENT" VOCAL SAMPLE 1∙===================∙
;;∙------∙Demonstrating voice Rate, Volume, and Pitch∙-------------------------∙

^F2::    ;;∙------∙🔥∙(Ctrl + F2)
    Soundbeep, 1000, 200

phrase := "Text is being spoken with pitch and rate by the set SAPI voice."    ;;∙------∙Text phrase to speak.

voice := ComObjCreate("SAPI.SpVoice")    ;;∙------∙Create a SAPI SpVoice object.
voice.Voice := voice.GetVoices().Item(0)    ;;∙------∙Set Voice Index (#) to desired voice.

voice.rate := -1    ;;∙------∙Adjust speech speed (range: -10 to 10).
voice.Volume := 100    ;;∙------∙Adjust volume (range: 0 to 100).
pitch := 8    ;;∙------∙Adjust value to change pitch, in semitones (range: -10 to +10).
ssml := "<pitch AbsMiddle=""" pitch """>" phrase "</pitch>"    ;;∙------∙Create SSML markup with pitch adjustment.
;;∙------------------------∙

voice.Speak(ssml, 1)    ;;∙------∙Speak the text using SSML (2nd parameter [1] indicates input is SSML)
Return

;;∙============================================================∙



;;∙============∙SAPI "FLUENT" VOCAL SAMPLE 2∙===================∙
;;∙------∙Looking Into New Possibilities∙-------------------------------------------∙

^f3::    ;;∙------∙🔥∙(Ctrl + F3)
    Soundbeep, 1000, 200

Global oVoice := ComObjCreate("SAPI.SpVoice"), voices := oVoice.GetVoices()    ;;∙------∙Array of voices.
phrase := "Text is being spoken with pitch and rate by the set SAPI voice." 

speak(phrase, VOICENUMBER := 1, RATE := 1, 100)

;;∙------------------------------------∙
speak(phrase, voiceNumber := 1, rate := 0, vol := 100) {
    oVoice.Volume := vol
    oVoice.Rate := rate
    oVoice.Voice:= voices.Item(voiceNumber - 1)
     oVoice.WaitUntilDone(True), oVoice.Speak(phrase)
    }
Return
;;∙============================================================∙



;;∙============∙RETRIEVE VOICE NAMES LIST∙======================∙
;;∙------∙Retrieves list of available voice names and index numbers.

^f4::    ;;∙------∙🔥∙(Ctrl + F4) 
    Soundbeep, 1000, 200

voice := ComObjCreate("SAPI.SpVoice")
voices := voice.GetVoices()

ClipBoard = % "AVAILABLE VOICES:`n" . GetVoiceNames(voices)
MsgBox,,, % "AVAILABLE VOICES:`n" . GetVoiceNames(voices), 3
Return
;;∙------------------------∙

GetVoiceNames(voices) {
    names := ""
    Loop % voices.Count {
        index := A_Index - 1
        voice := voices.Item(index)
        name := StrReplace(voice.GetAttribute("Name"), " Desktop")
        ;;∙------∙Remove "Microsoft " and "IVONA 2 " prefixes (*note spaces).
        name := RegExReplace(name, "^(Microsoft |IVONA 2 )", "")
        ;;∙------∙Add extra space for single-digit indices (0-9).
       if (index < 10) {
    names .= "  " . index . " : " . name . "`n"
        } else {
            names .= index . " : " . name . "`n"
        }
    }
    return names
}
Return

/*∙------∙Return Example∙------------------------∙
AVAILABLE VOICES:
  0 : Zira
  1 : David
∙--------------------------∙
*/

;;∙============================================================∙



;;∙============∙CHANGE DEFAULT VOICE∙===∙(*adjusts REGISTRY)=====∙
;;∙------∙ChangeThe Default System SAPI Voice Voice∙---------------------------∙

^f5::    ;;∙------∙🔥∙(Ctrl + F5)
    Soundbeep, 1000, 200

    Select_SAPI_Voice_GUI()
Return

;;∙------------------------------------∙
Select_SAPI_Voice_GUI() {
    global voices
    voices := []

    ComObjError(false)
    tempSapi := ComObjCreate("SAPI.SpVoice")
    tokens := tempSapi.GetVoices()

    ListStr := ""
    Loop, % tokens.Count {
        voice := tokens.Item(A_Index - 1)
        voices.Push({Name: voice.GetDescription(), Id: voice.Id})
        ListStr .= voice.GetDescription()
        if (A_Index < tokens.Count)
            ListStr .= "|"
    }

    if (voices.Length() = 0) {
        MsgBox, 16, Error, No SAPI voices found.,3
        return
    }

    Gui, VoiceSelect:New, +Resize, Select a SAPI Voice
    Gui, VoiceSelect:Add, Text,, Select a voice:
    Gui, VoiceSelect:Add, ListBox, vVoiceChoice w300 h150, %ListStr%
    Gui, VoiceSelect:Add, Button, gConfirmVoice, OK
    Gui, VoiceSelect:Show,, Select Voice
}

ConfirmVoice:
    Gui, VoiceSelect:Submit
    if (VoiceChoice = "") {
        MsgBox, 48, Notice, No voice selected. Please select a voice.,3
        return
    }
    selectedIndex := ""
    for index, voice in voices {
        if (voice.Name = VoiceChoice) {
            selectedIndex := index
            break
        }
    }
    if (selectedIndex = "") {
        MsgBox, 48, Notice, Invalid selection.,3
        return
    }
    
    selectedVoiceToken := voices[selectedIndex].Id

    ;;∙------∙Write the new default voice token into the registry.
    RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\Microsoft\SPEECH\Voices, DefaultTokenId, %selectedVoiceToken%
    if (ErrorLevel) {
        MsgBox, 16, Error, Failed to set the selected voice as default.,3
        Gui, VoiceSelect:Destroy
        return
    }

    ;;∙------∙(Optional) Broadcast a settings change message so other apps may pick up the new default.
    ;;∙------∙DllCall("SendMessageTimeout", "UInt", 0xFFFF, "UInt", 0x1A, "UInt", 0, "Str", "Software\Microsoft\SPEECH\Voices", "UInt", 0x0002, "UInt", 5000, "UIntP", 0)

    newSapi := ComObjCreate("SAPI.SpVoice")
    newSapi.Speak("The default voice has been changed.")
    ClipBoard = Default SAPI voice changed to:`n%VoiceChoice%
    ;;∙------∙MsgBox, 64, Success, Default SAPI voice changed to:`n%VoiceChoice%
    Gui, VoiceSelect:Destroy
Return

GuiEscape:
GuiClose:
    Gui, VoiceSelect:Destroy
Return

;;∙============================================================∙



;;∙============∙RETRIEVE CURRENT FULL NAME DESCRIPTION∙=======∙
;;∙------∙Voice object's attributes. Get full name description∙-----------------∙

^F6::    ;;∙------∙🔥∙(Ctrl + F6)
    Soundbeep, 1000, 200

    nameIndex := 0
    voice := ComObjCreate("SAPI.SpVoice")
    voices := voice.GetVoices()

    if (nameIndex < 0 || nameIndex >= voices.Count) {
        MsgBox, 16, Error, Invalid Voice Index.`nPlease Try Again.,3
        return
    }

    voice.Voice := voices.Item(nameIndex)
    ClipBoard = % "Voice Name: `n" . voice.Voice.GetDescription()
    MsgBox, , , % "Voice Name: `n" . voice.Voice.GetDescription(),3
Return

;;∙============================================================∙




;;∙============∙SPEECH RECOGNITION (Basic)∙===(untested)=========∙
;;∙------∙Demonstrates basic speech recognition using SAPI∙-----------------∙
;;∙---∙For speech recognition, ensure that your system has a working microphone,
;;∙---∙and that speech recognition 'is enabled' in Windows settings.
;;∙---∙(Control Panel > Ease of Access > Speech Recognition)

^F7::    ;;∙------∙🔥∙(Ctrl + F7)
    Soundbeep, 1000, 200

recognizer := ComObjCreate("SAPI.SpSharedRecognizer")
context := recognizer.CreateRecoContext()
grammar := context.CreateGrammar()
grammar.DictationSetState(1) ; Enable dictation
context.OnRecognition := Func("OnRecognition")

MsgBox,,, Say something!,3
return

OnRecognition(StreamNumber, StreamPosition, RecognitionType, Result) {
    text := Result.PhraseInfo.GetText()
    MsgBox,,, You said: %text%,3
    }
Return

;;∙============================================================∙




;;∙============∙USING SPEECH EVENTS∙===========================∙
;;∙------∙Handle speech events, such as speech start or end∙------------------∙

^F8::    ;;∙------∙🔥∙(Ctrl + F8)
    SoundBeep, 1000, 200

    voice := ComObjCreate("SAPI.SpVoice")

    MsgBox,,, Speech started!,2

    voice.Speak("This is a demonstration of speech events.")

    while (voice.Status.RunningState != 1) {    ;;∙------∙1 = Speech is done
        Sleep, 100    ;;∙------∙Wait 100ms before checking again.
    }

    MsgBox,,, Speech ended!,2
Return

;;∙============================================================∙




;;∙============∙SAVING SPEECH TO A FILE∙=========================∙
;;∙------∙Saves speech output to .wav file instead of read aloud∙--------------∙

^F9::    ;;∙------∙🔥∙(Ctrl + F9)
    SoundBeep, 1000, 200

    voice := ComObjCreate("SAPI.SpVoice")
    stream := ComObjCreate("SAPI.SpFileStream")

    filePath := A_Desktop . "\output.wav"    ;;∙------∙Save to desktop.
    stream.Open(filePath, 3, False)    ;;∙------∙3 = SSFMCreateForWrite, False = not read-only.

    voice.AudioOutputStream := stream
    voice.Speak("This speech will be saved to a file.")

    stream.Close()
    MsgBox,,, % "Speech saved to:`n" filePath,5
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
SAPI_Sampler:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

