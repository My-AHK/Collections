
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
» Frequency Tone Generator
    ▹ 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "FTG"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
;;∙============================================================∙
#NoEnv
#SingleInstance force
SetWorkingDir %A_ScriptDir%

^t::    ;;∙------∙🔥∙(Ctrl + T)

Gui, +AlwaysOnTop -Caption +Border
Gui, Color, 010B43

Gui, Font, s10 c3D9EFF Bold Q5, Arial
Gui, Add, Text, x10 y20 BackgroundTrans, Frequency 1
Gui, Font, Norm
Gui, Add, Edit, x95 yp c3D9EFF vFreqEdit1 w60 h20, 1100
Gui, Font, s8
Gui, Add, Text, x+3 yp-3 BackgroundTrans, (Hz)

Gui, Font, s10 c3D9EFF Bold Q5, Arial
Gui, Add, Text, x10 y45 BackgroundTrans, Frequency 2
Gui, Font, Norm
Gui, Add, Edit, x95 yp c3D9EFF vFreqEdit2 w60 h20, 700
Gui, Font, s8
Gui, Add, Text, x+3 yp-3 BackgroundTrans, (Hz)

Gui, Font, s10 c3D9EFF Bold Q5, Arial
Gui, Add, Text, x10 y70 BackgroundTrans, Duration
Gui, Font, Norm
Gui, Add, Edit, x95 yp c3D9EFF vDurEdit w60 h20, 750
Gui, Font, s8
Gui, Add, Text, x+3 yp-3 BackgroundTrans, (ms)

Gui, Font, Italic
Gui, Add, Button, gPlayToneSection x+10 y25 w45 h20, Play

Gui, Font, Italic
Gui, Add, Button, gExitScript xp y60 w45 h20, Exit

Gui, Show, x1550 y450 w260 h110, Dual Frequency Tone Generator
Return


;;∙-------------------------------------------∙
PlayToneSection:
    Gui, Submit, NoHide

    ;;∙------∙Validate Frequencies.
    if (FreqEdit1 < 37 or FreqEdit1 > 32767) or (FreqEdit2 < 37 or FreqEdit2 > 32767)
    {
        MsgBox, 48, Error, Frequencies must be between 37 and 32767 Hz., 4
        Return
    }
    if (DurEdit < 1)
    {
        MsgBox, 48, Error, Duration must be at least 1 ms., 4
        Return
    }
    ;;∙------∙Create Temporary Wav File With Both Frequencies Mixed.
    TempFile := A_Temp "\DualTone_" A_Now ".wav"
    CreateDualToneWav(FreqEdit1, FreqEdit2, DurEdit, TempFile)
    SoundPlay, %TempFile%, Wait
    FileDelete, %TempFile%
Return

;;∙-------------------------------------------∙
;;∙------∙Dual Mixed WAV File Creation Function.
CreateDualToneWav(Frequency1, Frequency2, Duration, FileName) {
    ;;∙------∙WAV File Parameters.
    SampleRate := 44100
    BitsPerSample := 16
    NumChannels := 1
    ByteRate := SampleRate * NumChannels * BitsPerSample // 8
    BlockAlign := NumChannels * BitsPerSample // 8
    DataSize := Floor(SampleRate * Duration / 1000) * BlockAlign
    FileSize := 36 + DataSize

    ;;∙------∙Create File.
    File := FileOpen(FileName, "w")

    ;;∙------∙Write WAV Header.
    File.Write("RIFF")
    File.WriteUInt(FileSize)
    File.Write("WAVE")
    File.Write("fmt ")
    File.WriteUInt(16)    ;;∙------∙Chunk size.
    File.WriteUShort(1)    ;;∙------∙Audio Format (PCM).
    File.WriteUShort(NumChannels)    ;;∙------∙Number Of Channels.
    File.WriteUInt(SampleRate)    ;;∙------∙Sample Rate.
    File.WriteUInt(ByteRate)    ;;∙------∙Byte Rate.
    File.WriteUShort(BlockAlign)     ;;∙------∙Block Align.
    File.WriteUShort(BitsPerSample)    ;;∙------∙Bits Per Sample.
    File.Write("data")
    File.WriteUInt(DataSize)    ;;∙------∙Data Chunk Size.

    ;;∙------∙Generate Mixed Sine Wave Data.
    Amplitude1 := 0.3    ;;∙------∙Reduce To Avoid Clipping When Mixed.
    Amplitude2 := 0.3
    AngularFreq1 := 2 * 3.141592653589793 * Frequency1 / SampleRate
    AngularFreq2 := 2 * 3.141592653589793 * Frequency2 / SampleRate

    Samples := Floor(SampleRate * Duration / 1000)
    Loop %Samples% {
        ;;∙------∙Mix Both Sine Waves.
        Sample1 := Amplitude1 * Sin(AngularFreq1 * (A_Index - 1))
        Sample2 := Amplitude2 * Sin(AngularFreq2 * (A_Index - 1))
        MixedSample := Sample1 + Sample2

        ;;∙------∙Normalize To Prevent Clipping.
        if (MixedSample > 1.0)
            MixedSample := 1.0
        else if (MixedSample < -1.0)
            MixedSample := -1.0

        ;;∙------∙Convert To 16-Bit Signed Integer.
        IntSample := Round(MixedSample * 32767)
        File.WriteUShort(IntSample & 0xFFFF)
    }
    File.Close()
}

;;∙-------------------------------------------∙
ExitScript:
GuiClose:
GuiEscape:
    ExitApp
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
FTG:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

