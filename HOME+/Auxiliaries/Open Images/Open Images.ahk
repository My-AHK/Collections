
/*   Open Selected Image File With Chosen Image Editor
;⮞--------------------- NOTES ----------------------------------------------∙ 
∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙ 
∙--------------∙ Base Notes ∙--------------∙ 
» Reload Script-------- DoubleTap--⮚ Ctrl + [HOME] 
» Exit Script------------- DoubleTap--⮚ Ctrl + [Esc] 
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙ 
∙--------------∙ Script Specific Notes ∙--------------∙ 
» SOURCE :  
» 
∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙ 
;∙---------------------- NOTES END ----------------------------------------∙ 
*/
; ∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙ 
;⮞--------------------- Auto-Execute ---------------------------------------∙ 
Gosub, AutoExecute
;∙---------------------- Auto-Execute End ---------------------------------∙ 
; ∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙ 



AppPath_Animations := "C:\Program Files (x86)\Jasc Software Inc\Animation Shop 3\Anim.exe"
AppPath_Icons := "C:\Program Files\Greenfish Icon Editor Pro 3.6 Port\Greenfish Icon Editor Pro 3.6\gfie64.exe"
AppPath_Images := "C:\Program Files\Corel\Corel PaintShop Pro 2023 (64-bit)\Corel PaintShop Pro.exe"
AppPath_PDF := "C:\Program Files\Nitro\Pro\13\NitroPDF.exe"

^P::
;    Soundbeep, 1700, 100
Switch, Morse() {
    Case "0": GoSub, Sub1
    Case "00": GoSub, Sub2
}
Return



Sub1:
    SelectedItem := GetSelectedItemPath()
    if (FileExist(SelectedItem) && !IsFolder(SelectedItem)) {
        if (IsHidden(SelectedItem)) {
            MsgBox, , , The selected file is a Hidden File!!, 3
            Return
        }
        FileExt := SubStr(SelectedItem, InStr(SelectedItem, ".",, -1))
        if (IsValidImageFile(SelectedItem)) {
            if (FileExt = ".gif") {
                Run, % AppPath_Animations " """ SelectedItem """" 	 ; Animated GIFs (.gif)
            } else if (FileExt = ".ico") {
                Run, % AppPath_Icons " """ SelectedItem """" 	 ; Icons (.ico)
            } else {
                Run, % AppPath_Images " """ SelectedItem """" 	 ; All other image formats (.bmp.jpg.jpeg.png.svg.tif.tiff)
            }
            Soundbeep, 1900, 75
            Soundbeep, 1900, 75
        } else if (FileExt = ".pdf") {
            Run, % AppPath_PDF " """ SelectedItem """" 		 ; PDF Files (.pdf)
            Soundbeep, 1900, 75
            Soundbeep, 1900, 75
        } else {
            Soundbeep, 1200, 75
            Soundbeep, 1000, 150
            MsgBox, , , The selected file is NOT a valid Image File., 3
        }
    } else {
        Soundbeep, 1000, 75
        Soundbeep, 1000, 75
        MsgBox, , , The selected item is a Folder`n        ...NOT a File., 3
    }
Return

;--------------------------

GetSelectedItemPath() {
    Clipboard := ""
    Send, ^c
    ClipWait
    Return Clipboard
}

IsValidImageFile(FilePath) {
    ImageExtensions := ".bmp.jpg.jpeg.png.gif.svg.tif.tiff.ico"
    FileExt := SubStr(FilePath, InStr(FilePath, ".",, -1))
    Return InStr(ImageExtensions, FileExt)
}

IsFolder(FilePath) {
    Return (SubStr(FileExist(FilePath), 1, 1) = "D")
}

IsHidden(FilePath) {
    FileGetAttrib, Attributes, %FilePath%
    Return InStr(Attributes, "H")
}

Return
; ∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙ 
; ∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙ 
; ∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙ 


Sub2:
    Soundbeep, 1400,75
Run, C:\Program Files\Corel\Corel PaintShop Pro 2023 (64-bit)\Corel PaintShop Pro.exe
Return



; ∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙ 
Morse(Timeout = 400) {
    Global Pattern := ""
    RegExMatch(A_ThisHotkey, "\W$|\w*$", Key)
    While, !ErrorLevel {
        T := A_TickCount
        KeyWait %Key%
        Pattern .= A_TickCount-T > Timeout
        KeyWait %Key%,% "DT" Timeout/1000
    } Return Pattern
}
Return
; ∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙ 

; ∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙ 
;⮞--------------------- Reload/Exit Routine -------------------------------∙ 
Return
;------------ RELOAD ------- RELOAD ------- RELOAD ---------  
^Home:: 
If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200) 	 ; ←←← Double-Tap in less than 200 milliseconds.
    Soundbeep, 1700, 75
    Gui, Destroy
        SoundSet, % master_volume
    Reload
Return
;--------------- EXIT ------------ EXIT --------- EXIT ------------ 
^Esc:: 
If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200) 	 ; ←←← Double-Tap in less than 200 milliseconds.
    Soundbeep, 1700, 75
    Gui, Destroy
        SoundSet, % master_volume
        ExitApp
Return
;∙---------------------- Reload/Exit Routine End -------------------------∙ 
; ∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙ 
;⮞--------------------- Script Updater -------------------------------------∙ 
UpdateCheck: 	 ; Check if the script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
;∘—— If the modification timestamp has changed, reload the script. 
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 2100, 100
Reload
;∙---------------------- Script Updater End --------------------------------∙ 
; ∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙ 
;⮞--------------------- Auto-Execute Sub ----------------------------------∙ 
AutoExecute: 
#NoEnv 
#NoTrayIcon
#Persistent 
#SingleInstance, Force 
SetBatchLines -1 
SetTimer, UpdateCheck, 500 
SetTitleMatchMode, 2 
Return
;∙---------------------- Auto-Execute Sub End ---------------------------∙ 
; ∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙=∙ 

/* 
 ⮞------------------------------------------------------------------------------⮜ 
        ∘﹤⪻⋘⪡⫷⫷⫷⫷⫷⫷ SCRIPT END ⫸⫸⫸⫸⫸⫸⪢⋙⪼﹥∘ 
 ⮞------------------------------------------------------------------------------⮜ 
*/ 

