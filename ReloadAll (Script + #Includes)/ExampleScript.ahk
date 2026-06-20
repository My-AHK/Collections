



;;∙======∙ASYNCHRONOUS SOUNDBEEP∙=============∙
aSoundBeep(Frequency, Duration) {
    AutoHotkeyPath := A_AhkPath    
    shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec("""" AutoHotkeyPath """ *")
    exec.StdIn.Write("#NoTrayIcon`nSoundBeep, " Frequency "," Duration "`nExitApp")
    exec.StdIn.Close()
}






