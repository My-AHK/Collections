
/*∙--------∙Origins∙-------------------------∙
» Original Author:  lexikos
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?style=7&t=94661#p426437
*/




;;∙======∙Auto-Execute∙==========================================∙
#Persistent
#SingleInstance, Force
SetTimer, UpdateCheck, 500
    darkMode(1)    ;;∙------∙Dark Mode∙(0=LightMode / 1=DarkMode)
Menu, Tray, Icon, imageres.dll, 3
;;∙============================================================∙




;;∙============================================================∙
;;∙------------------------------------------------∙
;;∙------∙Dark Mode∙(0=LightMode / 1=DarkMode)

^Numpad1::    ;;∙------∙🔥∙
Soundbeep, 1200, 300
darkMode(0)
Return

^Numpad2::    ;;∙------∙🔥∙
Soundbeep, 1200, 300
darkMode(1)
Return
;;∙------------------------------------------------∙


;;∙------------------------------------------------∙
darkMode(goDark:=1) {
        static uxtheme := DllCall("GetModuleHandle", "str", "uxtheme", "ptr")    ;;∙------∙Load uxtheme.dll if not already loaded.
        static SetPreferredAppMode := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 135, "ptr")    ;;∙------∙Get address for setting app mode.
        static FlushMenuThemes := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 136, "ptr")    ;;∙------∙Get address for flushing menu themes.
        DllCall(SetPreferredAppMode, "int", goDark)    ;;∙------∙Set the preferred application mode.
        DllCall(FlushMenuThemes)    ;;∙------∙Apply the changes to menu themes.
    }
Return
;;∙------------------------------------------------∙
;;∙============================================================∙








;;∙======∙Script Updater∙=========================================∙
UpdateCheck:
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1400, 300
Reload
;;∙============================================================∙
;;∙================================∙
^Esc::
    Soundbeep, 1100, 300
    ExitApp
Return
;;∙================================∙

