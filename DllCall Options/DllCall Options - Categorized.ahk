
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
ScriptID := "DllCall_Options"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙🔥 HotKey 🔥∙===========================================∙
^t::    ;;∙------∙(Ctrl+T) 
    Soundbeep, 1000, 200
;;∙============================================================∙




;;∙============================================================∙
/*∙-----------------------------------------------------------------------------∙
  • CLIPBOARD					9
  • DESKTOP SETTINGS (renamed from DESKTOP)		4
  • DISPLAY (renamed from MONITOR)			3
  • ENVIRONMENT (new for environment variables)		8
  • FILES & DIRECTORIES				9
  • KEYBOARD INPUT (renamed from KEYS PRESS/SEND)	3
  • MEMORY					5
  • MOUSE/CURSOR					9
  • NETWORK					7
  • PROCESSES (split from SYSTEM)			29
  • REGISTRY					9
  • SOUNDS					4
  • SYSTEM INFO (split from SYSTEM)			8
  • TIMING (renamed from SLEEP/TIME)			8
  • WINDOW MANAGEMENT				34
  • WINDOW MESSAGING				4
  ∙------------------------------------------------------------------------------∙
*/

;;∙===========================================∙
;;;;∙=======∙CLIPBOARD∙===================∙9

;;∙------∙Clear Clipboard (OpenClipboard & EmptyClipboard).
DllCall("User32\OpenClipboard", "Ptr", 0)
DllCall("User32\EmptyClipboard")
DllCall("User32\CloseClipboard")
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Set ANSI Clipboard Text.
DllCall("User32\OpenClipboard", "Ptr", 0)
DllCall("User32\EmptyClipboard")
text := "Hello from DLLCall clipboard text!"
hGlobal := DllCall("kernel32\GlobalAlloc", "UInt", 0x0042, "UInt", StrLen(text) + 1, "Ptr")
pGlobal := DllCall("kernel32\GlobalLock", "Ptr", hGlobal, "Ptr")
DllCall("msvcrt\strcpy", "Ptr", pGlobal, "Str", text)
DllCall("kernel32\GlobalUnlock", "Ptr", hGlobal)
DllCall("User32\SetClipboardData", "UInt", 1, "Ptr", hGlobal)    ;;∙------∙CF_TEXT = 1.
DllCall("User32\CloseClipboard")
MsgBox "Clipboard text set via DLLCall."

;;∙----!!!!!!----∙ANSI vs UNICODE∙----!!!!!!----∙

;;∙------∙Set Unicode Clipboard Text.
DllCall("User32\OpenClipboard", "Ptr", 0)
DllCall("User32\EmptyClipboard")
text := "Hello from DLLCall clipboard text!"
hGlobal := DllCall("kernel32\GlobalAlloc", "UInt", 0x0042, "UInt", (StrLen(text) + 1) * 2, "Ptr") ; UTF-16 needs 2 bytes/char
pGlobal := DllCall("kernel32\GlobalLock", "Ptr", hGlobal, "Ptr")
DllCall("msvcrt\wcscpy", "Ptr", pGlobal, "Str", text) ; Unicode copy (wcscpy)
DllCall("kernel32\GlobalUnlock", "Ptr", hGlobal)
DllCall("User32\SetClipboardData", "UInt", 13, "Ptr", hGlobal) ; CF_UNICODETEXT = 13
DllCall("User32\CloseClipboard")
MsgBox "Clipboard text set via DLLCall (Unicode)."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get ANSI Clipboard Text.
DllCall("User32\OpenClipboard", "Ptr", 0)
hData := DllCall("User32\GetClipboardData", "UInt", 1, "Ptr") ; CF_TEXT = 1
if (hData) {
    pText := DllCall("kernel32\GlobalLock", "Ptr", hData, "Ptr")
    text := StrGet(pText, "CP0") ; ANSI encoding
    DllCall("kernel32\GlobalUnlock", "Ptr", hData)
    MsgBox Clipboard text: %text%
} else {
    MsgBox No text on clipboard.
}
DllCall("User32\CloseClipboard")

;;∙----!!!!!!----∙ANSI vs UNICODE∙----!!!!!!----∙

;;∙------∙Get Unicode Clipboard Text.
DllCall("User32\OpenClipboard", "Ptr", 0)
hData := DllCall("User32\GetClipboardData", "UInt", 13, "Ptr") ; CF_UNICODETEXT = 13
if (hData) {
    pText := DllCall("kernel32\GlobalLock", "Ptr", hData, "Ptr")
    text := StrGet(pText, "UTF-16") ; Unicode decoding
    DllCall("kernel32\GlobalUnlock", "Ptr", hData)
    MsgBox Clipboard text: %text%
} else {
    MsgBox No text on clipboard.
}
DllCall("User32\CloseClipboard")
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Copy Image to Clipboard (Bitmap).
;;∙------∙Capture screen and copy as bitmap (example: copy 100x100 area)
hDC := DllCall("GetDC", "Ptr", 0)
hMemDC := DllCall("CreateCompatibleDC", "Ptr", hDC)
hBitmap := DllCall("CreateCompatibleBitmap", "Ptr", hDC, "Int", 100, "Int", 100)
DllCall("SelectObject", "Ptr", hMemDC, "Ptr", hBitmap)
DllCall("BitBlt", "Ptr", hMemDC, "Int", 0, "Int", 0, "Int", 100, "Int", 100, "Ptr", hDC, "Int", 0, "Int", 0, "UInt", 0x00CC0020) ; SRCCOPY

DllCall("User32\OpenClipboard", "Ptr", 0)
DllCall("User32\EmptyClipboard")
DllCall("User32\SetClipboardData", "UInt", 2, "Ptr", hBitmap) ; CF_BITMAP = 2
DllCall("User32\CloseClipboard")

DllCall("DeleteDC", "Ptr", hMemDC)
DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)
MsgBox Image copied to clipboard!
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Check Clipboard ANSI Format Availability.
format := 1 ; CF_TEXT = 1
isAvailable := DllCall("User32\IsClipboardFormatAvailable", "UInt", format)
MsgBox % "Text available? " (isAvailable ? "Yes" : "No")

;;∙----!!!!!!----∙ANSI vs UNICODE∙----!!!!!!----∙

;;∙------∙Check Clipboard Unicode Format Availability
format := 13 ; CF_UNICODETEXT = 13
isAvailable := DllCall("User32\IsClipboardFormatAvailable", "UInt", format)
MsgBox % "Unicode text available? " (isAvailable ? "Yes" : "No")
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Copy HTML to Clipboard.
html := "<b>Hello</b> <i>World</i>"
header := "Version:0.9`r`nStartHTML:00000000`r`nEndHTML:00000000`r`n"

;;∙------∙Calculate offsets
startHTML := StrLen(header) - 8 ; Replace "00000000" with actual offset
endHTML := startHTML + StrLen(html)
header := StrReplace(header, "00000000", Format("{:08}", startHTML))
header := StrReplace(header, "00000000", Format("{:08}", endHTML))

data := header html

DllCall("User32\OpenClipboard", "Ptr", 0)
DllCall("User32\EmptyClipboard")

;;∙------∙Register HTML format (if not already registered)
htmlFormat := DllCall("User32\RegisterClipboardFormat", "Str", "HTML Format", "UInt")

;;∙------∙Allocate global memory
hGlobal := DllCall("kernel32\GlobalAlloc", "UInt", 0x0042, "UInt", StrLen(data) + 1, "Ptr")
pGlobal := DllCall("kernel32\GlobalLock", "Ptr", hGlobal, "Ptr")
DllCall("msvcrt\strcpy", "Ptr", pGlobal, "Str", data)
DllCall("kernel32\GlobalUnlock", "Ptr", hGlobal)

DllCall("User32\SetClipboardData", "UInt", htmlFormat, "Ptr", hGlobal)
DllCall("User32\CloseClipboard")
MsgBox HTML copied to clipboard!
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Enumerate Clipboard Formats.
DllCall("User32\OpenClipboard", "Ptr", 0)
format := 0
list := "Clipboard Formats:`n"
While (format := DllCall("User32\EnumClipboardFormats", "UInt", format)) {
    list .= "Format " format "`n"
}
DllCall("User32\CloseClipboard")
MsgBox % list
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Copy Files to Clipboard (CF_HDROP).
files := "C:\test1.txt`nC:\test2.txt" ; Paths separated by newlines

;;∙------∙Create DROPFILES structure
structSize := 20 + (StrLen(files) * 2) + 2 ; Size of DROPFILES + null-terminated wide string
hGlobal := DllCall("kernel32\GlobalAlloc", "UInt", 0x0042, "UInt", structSize, "Ptr")
pDrop := DllCall("kernel32\GlobalLock", "Ptr", hGlobal, "Ptr")

;;∙------∙Initialize DROPFILES
NumPut(20, pDrop+0, "UInt") ; pFiles offset (size of DROPFILES struct)
NumPut(1, pDrop+16, "UInt") ; fWide = 1 (Unicode)

;;∙------∙Copy file list (Unicode)
pFiles := pDrop + 20
Loop, Parse, files, `n, `r
    filesW .= A_LoopField "`0"
filesW .= "`0" ; Double null-terminate
StrPut(filesW, pFiles, "UTF-16")

DllCall("kernel32\GlobalUnlock", "Ptr", hGlobal)

DllCall("User32\OpenClipboard", "Ptr", 0)
DllCall("User32\EmptyClipboard")
DllCall("User32\SetClipboardData", "UInt", 15, "Ptr", hGlobal) ; CF_HDROP = 15
DllCall("User32\CloseClipboard")
MsgBox File paths copied to clipboard!
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Clipboard Data as Unicode Text.
DllCall("User32\OpenClipboard", "Ptr", 0)
hData := DllCall("User32\GetClipboardData", "UInt", 13, "Ptr") ; CF_UNICODETEXT = 13
if (hData) {
    pText := DllCall("kernel32\GlobalLock", "Ptr", hData, "Ptr")
    text := StrGet(pText, "UTF-16")
    DllCall("kernel32\GlobalUnlock", "Ptr", hData)
    MsgBox Unicode text: %text%
}
DllCall("User32\CloseClipboard")
;;∙------------------------------------------------------------------------------------------∙


;;∙===========================================∙
;;;;∙=======∙DESKTOP SETTINGS∙============∙4

;;∙------∙Retrieve Desktop Wallpaper (SystemParametersInfo).
VarSetCapacity(wallpaper, 512, 0)
;;∙------∙115 = SPI_GETDESKWALLPAPER, 0 means no flags.
DllCall("User32\SystemParametersInfo", "UInt", 115, "UInt", 512, "Ptr", &wallpaper, "UInt", 0)
MsgBox % "Current Wallpaper: " wallpaper
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Set Desktop Wallpaper (BMP).
wallpaperPath := A_ScriptDir "\wallpaper.bmp"
DllCall("User32\SystemParametersInfo", "UInt", 20, "UInt", 0, "Str", wallpaperPath, "UInt", 3)
MsgBox "Desktop wallpaper set."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Set Desktop Wallpaper (JPEG/PNG)
wallpaperPath := A_ScriptDir "\wallpaper.png"
DllCall("SystemParametersInfo", "UInt", 0x14, "UInt", 0, "Str", wallpaperPath, "UInt", 1)
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Set Desktop Wallpaper (COM method - Max Compatibility/Reliability)
wallpaperPath := A_ScriptDir "\wallpaper.png"
try {
    IAD := ComObjCreate("{75048700-EF1F-11D0-9888-006097DEACF9}", "{F490EB00-1240-11D1-9888-006097DEACF9}")
    IAD.SetWallpaper(wallpaperPath, 0)
    IAD.ApplyChanges(0x1F)    ;;∙------∙AD_APPLY_ALL
    MsgBox Wallpaper set!
} catch e {
    MsgBox % "Error: " e.Message
}
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Desktop Window Handle (GetDesktopWindow).
hDesktop := DllCall("User32\GetDesktopWindow", "Ptr")
MsgBox % "Desktop Window Handle: " hDesktop
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Load Image from File (LoadImage).
;;∙------∙Loads an image (e.g., an icon) from a file.
iconPath := A_ScriptDir "\icon.ico"
hIcon := DllCall("User32\LoadImage", "Ptr", 0, "Str", iconPath, "UInt", 1, "Int", 32, "Int", 32, "UInt", 0x10)    ;;∙------∙LR_LOADFROMFILE = 0x10.
MsgBox % "Icon loaded. Handle: " hIcon
;;∙------------------------------------------------------------------------------------------∙

;;∙===========================================∙
;;;;∙=======∙DISPLAY∙=====================∙3

;;∙------∙Get Monitor Info (MonitorFromWindow & GetMonitorInfo).
hwnd := DllCall("User32\GetForegroundWindow", "Ptr")
hMonitor := DllCall("User32\MonitorFromWindow", "Ptr", hwnd, "UInt", 2)    ;;∙------∙MONITOR_DEFAULTTONEAREST = 2
VarSetCapacity(mi, 40, 0)    ;;∙------∙MONITORINFO structure (size may vary)
NumPut(40, mi, 0, "UInt")    ;;∙------∙Set structure size
DllCall("User32\GetMonitorInfo", "Ptr", hMonitor, "Ptr", &mi)
left := NumGet(mi, 4, "Int"), top := NumGet(mi, 8, "Int")
right := NumGet(mi, 12, "Int"), bottom := NumGet(mi, 16, "Int")
MsgBox % "Monitor boundaries: (" left ", " top ") - (" right ", " bottom ")"
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Enable High DPI Awareness (SetProcessDPIAware/Windows Vista+).
;;∙------∙Increases clarity on high DPI displays by informing Windows your process is DPI-aware.
DllCall("User32\SetProcessDPIAware")
MsgBox "High DPI Awareness enabled."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Enable High DPI Awareness (SetProcessDPIAware/Windows 8.1+).
;;∙------∙Increases clarity on high DPI displays by informing Windows your process is DPI-aware.
;;∙------∙Define DPI awareness level (2 = PROCESS_PER_MONITOR_DPI_AWARE)
PROCESS_PER_MONITOR_DPI_AWARE := 2
result := DllCall("Shcore\SetProcessDpiAwareness", "UInt", PROCESS_PER_MONITOR_DPI_AWARE, "Int")
if (result = 0) ; S_OK = 0
    MsgBox High DPI Awareness enabled.
else
    MsgBox Failed to set DPI awareness (Error: %result%).
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Enable High DPI Awareness (Manifest File/Windows 7+).
;;∙------∙Increases clarity on high DPI displays by informing Windows your process is per monitor DPI-aware.
;;∙------∙Add this directive at the top of your script.
;;∙------∙Meant for compiling the script to an EXE (e.g., using Ahk2Exe).
;;∙------∙Each line of the XML is prefixed with a single  ;  to avoid syntax errors in AHK.
;;∙------∙After compiling, your EXE will automatically respect per-monitor DPI scaling on Windows 10/11.

;@Ahk2Exe-Manifest
; <?xml version="1.0" encoding="UTF-8"?>
; <assembly manifestVersion="1.0" xmlns="urn:schemas-microsoft-com:asm.v1">
;   <application>
;     <windowsSettings>
;       <dpiAwareness xmlns="http://schemas.microsoft.com/SMI/2016/WindowsSettings">PerMonitorV2</dpiAwareness>
;     </windowsSettings>
;   </application>
; </assembly>

#SingleInstance Force
MsgBox High DPI awareness enabled via manifest!
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Enumerate Display Monitors (EnumDisplayMonitors).
;;∙------∙Enumerates all display monitors connected to the system.
MonitorList := ""
MonitorCallback := RegisterCallback("EnumMonitors", "Fast")
DllCall("User32\EnumDisplayMonitors", "Ptr", 0, "Ptr", 0, "Ptr", MonitorCallback, "Ptr", 0)
MsgBox % "Monitors found:`n" MonitorList

EnumMonitors(hMonitor, hdcMonitor, lprcMonitor, dwData) {
    global MonitorList
    MonitorList .= "Monitor Handle: 0x" Format("{:X}", hMonitor) "`n"
    return 1    ;;∙------∙Continue enumeration.
}
;;∙------------------------------------------------------------------------------------------∙


;;∙===========================================∙
;;;;∙=======∙ENVIRONMENT∙==============∙8

;;∙------∙Get Environment Variable (GetEnvironmentVariable).
VarSetCapacity(varValue, 1024, 0)
DllCall("kernel32\GetEnvironmentVariable", "Str", "PATH", "Str", varValue, "UInt", 1024)
MsgBox % "PATH environment variable: " varValue
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Set Environment Variable (SetEnvironmentVariable).
DllCall("kernel32\SetEnvironmentVariable", "Str", "MYVAR", "Str", "HelloWorld")
MsgBox "Environment variable MYVAR set."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Expand Environment Variables in a String.
;;∙------∙Replace environment variables (e.g., `%APPDATA%`) in a string with their values.
str := "%USERPROFILE%\\Documents"
VarSetCapacity(expandedStr, 2048, 0)
DllCall("kernel32\ExpandEnvironmentStrings", "Str", str, "Str", expandedStr, "UInt", 2048)
MsgBox % "Expanded path: " expandedStr
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get All Environment Variables.
;;∙------∙List all environment variables for the current process.
envBlock := DllCall("kernel32\GetEnvironmentStrings", "Ptr")
ptr := envBlock
Loop {
    currentVar := StrGet(ptr)
    if (currentVar = "")
        break
    list .= currentVar "`n"
    ptr += (StrLen(currentVar) + 1) * 2 ; Advance pointer (Unicode)
}
DllCall("kernel32\FreeEnvironmentStrings", "Ptr", envBlock)
MsgBox % "All Environment Variables:`n`n" list
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Set a Persistent User Environment Variable.
;;∙------∙(Inteacts with Registry)
;;∙------∙Set a user-level environment variable (persists after reboot).
varName := "MY_PERSISTENT_VAR"
varValue := "C:\MyApp"

;;∙------∙Open HKEY_CURRENT_USER\Environment
hKey := 0
result := DllCall("Advapi32\RegOpenKeyEx", "UInt", 0x80000001, "Str", "Environment", "UInt", 0, "UInt", 0x20006, "UInt*", hKey)
if (result != 0) {
    MsgBox Failed to open registry key (Error: %result%).
    ExitApp
}

;;∙------∙Write the value (REG_EXPAND_SZ = 0x2 for expandable strings)
result := DllCall("Advapi32\RegSetValueEx", "UInt", hKey, "Str", varName, "UInt", 0, "UInt", 0x2, "Str", varValue, "UInt", StrLen(varValue) + 1)
DllCall("Advapi32\RegCloseKey", "UInt", hKey)

;;∙------∙Notify other processes of the change
DllCall("user32\SendMessageTimeout", "UInt", 0xFFFF, "UInt", 0x1A, "Ptr", 0, "Str", "Environment", "UInt", 0x2, "UInt", 5000, "Ptr*", 0)
MsgBox % "Persistent variable set! Reboot or logoff to apply globally."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Delete a Persistent Environment Variable.
;;∙------∙Remove a user-level persistent variable.
varName := "MY_PERSISTENT_VAR"

hKey := 0
result := DllCall("Advapi32\RegOpenKeyEx", "UInt", 0x80000001, "Str", "Environment", "UInt", 0, "UInt", 0x20006, "UInt*", hKey)
if (result != 0) {
    MsgBox Failed to open registry key (Error: %result%).
    ExitApp
}

result := DllCall("Advapi32\RegDeleteValue", "UInt", hKey, "Str", varName)
DllCall("Advapi32\RegCloseKey", "UInt", hKey)

;;∙------∙Broadcast change
DllCall("user32\SendMessageTimeout", "UInt", 0xFFFF, "UInt", 0x1A, "Ptr", 0, "Str", "Environment", "UInt", 0x2, "UInt", 5000, "Ptr*", 0)
if (result = 0)
    MsgBox Variable deleted.
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Check if an Environment Variable Exists.
;;∙------∙Check if a variable exists (current process or persistent).
varName := "PATH"
VarSetCapacity(varValue, 1024, 0)
size := DllCall("kernel32\GetEnvironmentVariable", "Str", varName, "Str", varValue, "UInt", 1024)
if (size > 0)
    MsgBox % varName " exists. Value: " varValue
else
    MsgBox % varName " does not exist."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Set System-Wide Environment Variable (Admin Required).
;;∙------∙Modify system-wide variables (requires admin rights).
varName := "GLOBAL_VAR"
varValue := "C:\GlobalData"

hKey := 0
result := DllCall("Advapi32\RegOpenKeyEx", "UInt", 0x80000002, "Str", "SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Environment", "UInt", 0, "UInt", 0x20006, "UInt*", hKey)
if (result != 0) {
    MsgBox Failed to open key (Error: %result%).
    ExitApp
}

result := DllCall("Advapi32\RegSetValueEx", "UInt", hKey, "Str", varName, "UInt", 0, "UInt", 0x2, "Str", varValue, "UInt", StrLen(varValue) + 1)
DllCall("Advapi32\RegCloseKey", "UInt", hKey)

;;∙------∙Broadcast change
DllCall("user32\SendMessageTimeout", "UInt", 0xFFFF, "UInt", 0x1A, "Ptr", 0, "Str", "Environment", "UInt", 0x2, "UInt", 5000, "Ptr*", 0)
MsgBox System variable set (admin rights required).
;;∙------------------------------------------------------------------------------------------∙

;;∙===========================================∙
;;;;∙=======∙FILES & DIRECTORIES∙=========∙9

;;∙------∙Get File Attributes (GetFileAttributes).
filePath := A_ScriptDir "\test.txt"
attributes := DllCall("kernel32\GetFileAttributes", "Str", filePath, "UInt")
MsgBox % "File attributes for " filePath ": " attributes
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Set File Attributes (SetFileAttributes).
filePath := A_ScriptDir "\test.txt"
;;∙------∙0x01 = FILE_ATTRIBUTE_READONLY.
if (DllCall("kernel32\SetFileAttributes", "Str", filePath, "UInt", 0x01))
    MsgBox % "Set file attributes to read-only for: " filePath
else
    MsgBox % "Failed to set file attributes for: " filePath
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Create Directory (CreateDirectory).
newDir := A_ScriptDir "\NewFolder"
if (DllCall("kernel32\CreateDirectory", "Str", newDir, "Ptr", 0))
    MsgBox % "Directory created: " newDir
else
    MsgBox % "Failed to create directory (it may already exist): " newDir
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Delete File (DeleteFile).
fileToDelete := A_ScriptDir "\delete_me.txt"
if (DllCall("kernel32\DeleteFile", "Str", fileToDelete))
    MsgBox % "File deleted: " fileToDelete
else
    MsgBox % "Failed to delete file: " fileToDelete
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get File Times (GetFileTime).
;;∙------∙Retrieves the creation, last access, and last write times of a file.
filePath := A_ScriptDir "\test.txt"
hFile := DllCall("kernel32\CreateFile", "Str", filePath, "UInt", 0x80000000, "UInt", 7, "Ptr", 0, "UInt", 3, "UInt", 0x80, "Ptr", 0)
VarSetCapacity(ct, 16, 0), VarSetCapacity(at, 16, 0), VarSetCapacity(lt, 16, 0)
DllCall("kernel32\GetFileTime", "Ptr", hFile, "Ptr", &ct, "Ptr", &at, "Ptr", &lt)
DllCall("kernel32\CloseHandle", "Ptr", hFile)
MsgBox "File times retrieved for " filePath
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get File Size (GetFileSize).
filePath := A_ScriptDir "\test.txt"
hFile := DllCall("kernel32\CreateFile", "Str", filePath, "UInt", 0x80000000, "UInt", 7, "Ptr", 0, "UInt", 3, "UInt", 0, "Ptr", 0)
fileSize := DllCall("kernel32\GetFileSize", "Ptr", hFile, "UInt*", 0)
DllCall("kernel32\CloseHandle", "Ptr", hFile)
MsgBox % "File size of " filePath ": " fileSize " bytes."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Flush File Buffers (FlushFileBuffers).
filePath := A_ScriptDir "\test.txt"
hFile := DllCall("kernel32\CreateFile", "Str", filePath, "UInt", 0x40000000, "UInt", 0, "Ptr", 0, "UInt", 3, "UInt", 0, "Ptr", 0)
if (DllCall("kernel32\FlushFileBuffers", "Ptr", hFile))
    MsgBox "File buffers flushed."
else
    MsgBox "Failed to flush file buffers."
DllCall("kernel32\CloseHandle", "Ptr", hFile)
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Open File with Default Program (ShellExecuteEx).
;;∙------∙Uses ShellExecuteEx to open "test.txt" with its associated default application.
VarSetCapacity(sx, 112, 0)    ;;∙------∙Allocate space for the SHELLEXECUTEINFO structure.
NumPut(112, sx, 0, "UInt")    ;;∙------∙cbSize
NumPut(0, sx, 4, "UInt")    ;;∙------∙fMask
NumPut(0, sx, 8, "Ptr")    ;;∙------∙hwnd
;;∙------∙lpVerb = "open"
verb := "open", NumPut(&verb, sx, 16, "Ptr")
;;∙------∙lpFile = path to file
file := A_ScriptDir "\test.txt", NumPut(&file, sx, 24, "Ptr")
NumPut(0, sx, 32, "Ptr")    ;;∙------∙lpParameters
NumPut(0, sx, 40, "Ptr")    ;;∙------∙lpDirectory
NumPut(1, sx, 48, "Int")    ;;∙------∙nShow (SW_SHOWNORMAL)
DllCall("shell32\ShellExecuteEx", "Ptr", &sx)
MsgBox "Opened test.txt with the default program."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Read File Content (CreateFile, ReadFile, CloseHandle).
;;∙------∙Opens a file, reads up to 1024 bytes, then closes the file.
filePath := A_ScriptDir "\test.txt"
hFile := DllCall("kernel32\CreateFile", "Str", filePath, "UInt", 0x80000000, "UInt", 7, "Ptr", 0, "UInt", 3, "UInt", 0, "Ptr", 0)
if (!hFile) {
    MsgBox "Failed to open file: " filePath
} else {
    VarSetCapacity(buffer, 1024, 0)
    bytesRead := 0
    if (DllCall("kernel32\ReadFile", "Ptr", hFile, "Ptr", &buffer, "UInt", 1024, "UInt*", bytesRead, "Ptr", 0))
        MsgBox % "File content (" bytesRead " bytes): " StrGet(&buffer, bytesRead, "CP0")
    else
        MsgBox "Failed to read file."
    DllCall("kernel32\CloseHandle", "Ptr", hFile)
}
;;∙------------------------------------------------------------------------------------------∙


;;∙===========================================∙
;;;;∙=======∙KEYBOARD INPUT∙============∙3

;;∙------∙Simulate Key Press (Send).
DllCall("User32\keybd_event", "UChar", 0x41, "UChar", 0, "UInt", 0, "Ptr", 0)    ;;∙------∙Press 'A'.
DllCall("User32\keybd_event", "UChar", 0x41, "UChar", 0, "UInt", 2, "Ptr", 0)    ;;∙------∙Release 'A'.
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Check if 'A' Key is Pressed (GetAsyncKeyState).
;;∙------∙Returns a nonzero value if the key is currently pressed.
keyState := DllCall("User32\GetAsyncKeyState", "Int", 0x41)    ;;∙------∙0x41 is the virtual-key code for 'A'.
MsgBox % "Key 'A' pressed state: " keyState
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Register and Unregister Global Hotkey.
;;∙------∙Registers Ctrl+Alt+H as a global hotkey and then unregisters it.
if (DllCall("User32\RegisterHotKey", "Ptr", 0, "Int", 1, "UInt", 0x0003, "UInt", 0x48))    ;;∙------∙0x0003 = MOD_CONTROL|MOD_ALT, 0x48 = 'H'
    MsgBox "Global hotkey (Ctrl+Alt+H) registered."
else
    MsgBox "Failed to register global hotkey."
Sleep 2000    ;;∙------∙Wait 2 seconds.
DllCall("User32\UnregisterHotKey", "Ptr", 0, "Int", 1)
MsgBox "Global hotkey unregistered."
;;∙------------------------------------------------------------------------------------------∙


;;∙===========================================∙
;;;;∙=======∙MEMORY∙===================∙5

;;∙------∙Create Memory-Mapped File (CreateFileMapping & MapViewOfFile).
;;∙------∙Creates a 1KB shared memory region.
hMap := DllCall("kernel32\CreateFileMapping", "Ptr", -1, "Ptr", 0, "UInt", 4, "UInt", 0, "UInt", 1024, "Str", "MyMapping")
pMap := DllCall("kernel32\MapViewOfFile", "Ptr", hMap, "UInt", 4, "UInt", 0, "UInt", 0, "UInt", 1024, "Ptr")
MsgBox % "Memory-mapped file created at address: " pMap
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Copy Memory (RtlMoveMemory).
;;∙------∙Copies 10 bytes from one variable to another.
VarSetCapacity(source, 10, 0)
VarSetCapacity(destination, 10, 0)
Loop, 10
    NumPut(A_Index, source, A_Index-1, "UChar")
DllCall("RtlMoveMemory", "Ptr", &destination, "Ptr", &source, "UInt", 10)
MsgBox "10 bytes of memory copied from source to destination."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Memory Status (GlobalMemoryStatusEx).
;;∙------∙Retrieves information about the system's current memory usage.
VarSetCapacity(memStatus, 64, 0)    ;;∙------∙MEMORYSTATUSEX structure size is 64 bytes.
NumPut(64, memStatus, 0, "UInt")    ;;∙------∙Set dwLength.
DllCall("kernel32\GlobalMemoryStatusEx", "Ptr", &memStatus)
totalPhys := NumGet(memStatus, 8, "UInt64")
availPhys := NumGet(memStatus, 16, "UInt64")
MsgBox % "Total Physical Memory: " totalPhys " bytes`nAvailable: " availPhys " bytes"
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Total/Free Memory.
;;∙------∙Retrieve physical memory statistics
VarSetCapacity(memStatus, 64, 0)
NumPut(64, memStatus, 0, "UInt") ; MEMORYSTATUSEX structure size
DllCall("kernel32\GlobalMemoryStatusEx", "Ptr", &memStatus)

totalMem := NumGet(memStatus, 8, "UInt64") / 1048576 ; Convert bytes to MB
freeMem := NumGet(memStatus, 16, "UInt64") / 1048576
MsgBox Total RAM: %totalMem% MB`nFree RAM: %freeMem% MB
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Allocate Memory (VirtualAlloc).
size := 1024
pMem := DllCall("kernel32\VirtualAlloc", "Ptr", 0, "UInt", size, "UInt", 0x1000, "UInt", 4)    ;;∙------∙MEM_COMMIT, PAGE_READWRITE.
MsgBox % "Memory allocated at address: 0x" Format("{:X}", pMem)
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Free Allocated Memory (VirtualFree).
if (pMem) {
    DllCall("kernel32\VirtualFree", "Ptr", pMem, "UInt", 0, "UInt", 0x8000)    ;;∙------∙MEM_RELEASE.
    MsgBox "Memory freed."
} else {
    MsgBox "No allocated memory to free."
}
;;∙------------------------------------------------------------------------------------------∙


;;∙===========================================∙
;;;;∙=======∙MOUSE/CURSOR∙=============∙9

;;∙------∙Cursor Position (MouseGetPos).
VarSetCapacity(point, 8, 0)    ;;∙------∙Allocate memory for a POINT structure.
DllCall("User32\GetCursorPos", "Ptr", &point)
x := NumGet(point, 0, "Int"), y := NumGet(point, 4, "Int")
MsgBox % "Cursor Position: X=" x " Y=" y
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Set Cursor Position (MouseMove).
DllCall("User32\SetCursorPos", "Int", 500, "Int", 500)
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Simulate Mouse Click (MouseClick).
structSize := A_PtrSize=8 ? 40 : 28
VarSetCapacity(INPUT_DOWN, structSize, 0), VarSetCapacity(INPUT_UP, structSize, 0)
NumPut(0, INPUT_DOWN,0,"UInt"), NumPut(0x0002, INPUT_DOWN,A_PtrSize*2+8,"UInt")    ;;∙------∙Down.
NumPut(0, INPUT_UP,0,"UInt"),   NumPut(0x0004, INPUT_UP,A_PtrSize*2+8,"UInt")    ;;∙------∙Up.
DllCall("SendInput", "UInt",2, "Ptr",&INPUT_DOWN, "Int",structSize)

;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Restrict Cursor Movement (Global ClipCursor).
;;∙------∙Define a rectangle (left, top, right, bottom) for the cursor confinement.
VarSetCapacity(rect, 16, 0)
NumPut(100, rect, 0, "Int")    ;;∙------∙Left
NumPut(100, rect, 4, "Int")    ;;∙------∙Top
NumPut(500, rect, 8, "Int")    ;;∙------∙Right
NumPut(500, rect, 12, "Int")    ;;∙------∙Bottom
DllCall("User32\ClipCursor", "Ptr", &rect)
MsgBox "Cursor movement restricted to the specified area."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Confine Cursor to Foreground Window (Like games do).
;;∙------∙Press Ctrl+Shift+C to toggle confinement.

confined := false
^+c::
    confined := !confined
    if (confined) {
        hWnd := DllCall("User32\GetForegroundWindow", "Ptr")
        VarSetCapacity(rect, 16, 0)
        DllCall("User32\GetWindowRect", "Ptr", hWnd, "Ptr", &rect)
        DllCall("User32\ClipCursor", "Ptr", &rect)
    } else {
        DllCall("User32\ClipCursor", "Ptr", 0)
    }
    MsgBox % "Cursor confinement: " (confined ? "ON" : "OFF")
Return
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Confine Cursor to a GUI Window (Recommended).
;;∙------∙Restrict the cursor only while interacting with app’s window.
Gui, New, +HwndhGui, My App
Gui, Show, w400 h300

;;∙------∙Confine cursor to the GUI while active
OnMessage(0x0006, "WM_ACTIVATE")    ;;∙------∙WM_ACTIVATE = 0x0006
Return

WM_ACTIVATE(wParam) {
    global hGui
    if (wParam = 1) { ; Window activated
        ; Get GUI position/size
        VarSetCapacity(rect, 16, 0)
        DllCall("User32\GetWindowRect", "Ptr", hGui, "Ptr", &rect)
        ; Confine cursor to GUI
        DllCall("User32\ClipCursor", "Ptr", &rect)
    } else { ; Window deactivated
        DllCall("User32\ClipCursor", "Ptr", 0) ; Release cursor
    }
}
GuiClose:
    DllCall("User32\ClipCursor", "Ptr", 0) ; Cleanup on exit
    ExitApp
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Cursor Information (GetCursorInfo).
;;∙------∙CURSORINFO structure size is 32 bytes (may vary by Windows version).
VarSetCapacity(ci, 32, 0)
NumPut(32, ci, 0, "UInt")    ;;∙------∙Set the structure size.
DllCall("User32\GetCursorInfo", "Ptr", &ci)
flags := NumGet(ci, 4, "UInt")
MsgBox % "Cursor Flags: " flags
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Set Custom Cursor (SetCursor).
;;∙------∙Load the standard arrow cursor (IDC_ARROW = 32512).
hCursor := DllCall("User32\LoadCursor", "Ptr", 0, "Int", 32512, "Ptr")
DllCall("User32\SetCursor", "Ptr", hCursor)
MsgBox "Cursor changed to standard arrow."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Set Mouse Speed (SystemParametersInfo).
;;∙------∙SPI_SETMOUSESPEED (113) sets the mouse speed (range: 1-20).
DllCall("User32\SystemParametersInfo", "UInt", 113, "UInt", 0, "UInt", 10, "UInt", 0)
MsgBox "Mouse speed set to 10."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Load Custom Cursor (LoadCursorFromFile).
cursorPath := A_ScriptDir "\custom_cursor.cur"
hCustomCursor := DllCall("User32\LoadCursorFromFile", "Str", cursorPath, "Ptr")
DllCall("User32\SetCursor", "Ptr", hCustomCursor)
MsgBox "Custom cursor loaded and set."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Double-Click Time (GetDoubleClickTime).
dblClickTime := DllCall("User32\GetDoubleClickTime", "UInt")
MsgBox % "Double-click time: " dblClickTime " ms"
;;∙------------------------------------------------------------------------------------------∙

;;∙===========================================∙
;;;;∙=======∙NETWORK∙===================∙7

;;∙------∙Open URL in Default Browser (ShellExecute).
url := "https://www.example.com"
DllCall("Shell32\ShellExecute", "Ptr", 0, "Str", "open", "Str", url, "Ptr", 0, "Str", "", "Int", 1)
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Check Internet Connectivity.
;;∙------∙Checks if a connection to the specified URL is possible.
DllCall("WinINet\InternetCheckConnection", "Str", "https://www.google.com", "UInt", 0x1, "UInt", 0)
if (ErrorLevel = 0)
    MsgBox, Internet connection is active.
else
    MsgBox, No internet connection.
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Local Machine IP Address.
;;∙------∙Retrieves the first IPv4 address of the local machine.
VarSetCapacity(hostname, 256, 0)
DllCall("WS2_32\gethostname", "Str", hostname, "Int", 256)
hostent := DllCall("WS2_32\gethostbyname", "Str", hostname, "Ptr")
addr_list := NumGet(hostent + 0, 12, "Ptr")
ip_addr := DllCall("WS2_32\inet_ntoa", "UInt", NumGet(addr_list + 0, 0, "UInt"), "Str")
MsgBox, Local IP: %ip_addr%
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Ping a Host (ICMP).
;;∙------∙Sends an ICMP echo request (ping) to a host.
ip := "8.8.8.8" ; Replace with IP or resolve a hostname first
handle := DllCall("Iphlpapi\IcmpCreateFile", "Ptr")
if (handle = -1)
    throw Exception("Failed to create ICMP handle")

;;∙------∙Prepare parameters
timeout := 1000 ; milliseconds
reply_size := 32 + 8
VarSetCapacity(reply, reply_size, 0)

result := DllCall("Iphlpapi\IcmpSendEcho", "Ptr", handle, "UInt", DllCall("WS2_32\inet_addr", "Str", ip, "UInt"), "Ptr", 0, "UShort", 0, "Ptr", 0, "Ptr", 0, "Ptr", &reply, "UInt", reply_size, "UInt", timeout)
if (result > 0)
    MsgBox, % "Ping successful (Roundtrip: " . NumGet(reply, 8, "UInt") . " ms)"
else
    MsgBox, Ping failed.

DllCall("Iphlpapi\IcmpCloseHandle", "Ptr", handle)
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Download a File from URL using WinHttp.WinHttpRequest (Recommended).
;;∙------∙Downloads a file directly to the local disk.
url := "https://example.com/file.zip"
savePath := A_ScriptDir . "\downloaded_file.zip"

try {
    whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    whr.Open("GET", url, true) ; true = asynchronous
    whr.Send()
    whr.WaitForResponse()
    
    if (whr.Status = 200) {
        ; Save binary data to file
        stream := whr.ResponseStream
        file := FileOpen(savePath, "w")
        while !stream.EOS
            file.WriteRaw(stream.Read())
        file.Close()
        MsgBox File downloaded successfully.
    } else {
        MsgBox, % "Download failed. Status code: " . whr.Status
    }
} catch e {
    MsgBox % "Error: " e.Message
}

;;∙----!!!!!!--------∙OPTIONAL∙-------!!!!!!-----∙

;;∙------∙Download a File from URL using MSXML2.XMLHTTP (Alternative).
;;∙------∙Downloads a file directly to the local disk.
url := "https://example.com/file.zip"
savePath := A_ScriptDir . "\downloaded_file.zip"

try {
    xhr := ComObjCreate("MSXML2.XMLHTTP")
    xhr.Open("GET", url, false) ; false = synchronous
    xhr.Send()
    
    if (xhr.Status = 200) {
        ; Use ADODB.Stream to handle binary data
        stream := ComObjCreate("ADODB.Stream")
        stream.Type := 1 ; adTypeBinary
        stream.Open()
        stream.Write(xhr.ResponseBody)
        stream.SaveToFile(savePath, 2) ; 2 = overwrite
        stream.Close()
        MsgBox File downloaded successfully.
    } else {
        MsgBox, % "Download failed. Status code: " . xhr.Status
    }
} catch e {
    MsgBox % "Error: " e.Message
}
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Check Mapped Network Drive Availability.
;;∙------∙Checks if a mapped drive (e.g., Z:) is connected to a network resource.
drive := "Z:"
VarSetCapacity(remotePath, 260, 0)
result := DllCall("MPR\WNetGetConnection", "Str", drive, "Str", remotePath, "UInt*", 260)
if (result = 0)
    MsgBox, Drive %drive% is mapped to: %remotePath%
else
    MsgBox, Drive %drive% is not connected.
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙HTTP GET Request (Advanced).
;;∙------∙Fetches content from a URL using WinINet.
url := "https://api.example.com/data"
hInternet := DllCall("WinINet\InternetOpen", "Str", "AHK", "UInt", 0, "Ptr", 0, "Ptr", 0, "UInt", 0)
hUrl := DllCall("WinINet\InternetOpenUrl", "Ptr", hInternet, "Str", url, "Ptr", 0, "UInt", 0, "UInt", 0x80000000, "Ptr", 0)

data := ""
while (DllCall("WinINet\InternetReadFile", "Ptr", hUrl, "Ptr", &buffer, "UInt", 1024, "UInt*", bytesRead) && bytesRead > 0)
    data .= StrGet(&buffer, bytesRead, "UTF-8")

DllCall("WinINet\InternetCloseHandle", "Ptr", hUrl)
DllCall("WinINet\InternetCloseHandle", "Ptr", hInternet)
MsgBox, % "Response: " SubStr(data, 1, 500) ; Show first 500 characters
;;∙------------------------------------------------------------------------------------------∙


;;∙===========================================∙
;;;;∙=======∙PROCESSES∙==================∙29 (split from SYSTEM)

;;∙------∙Get Computer Name (GetComputerName).
VarSetCapacity(computerName, 256, 0)
size := 256
DllCall("kernel32\GetComputerNameA", "Str", computerName, "UInt*", size)
MsgBox % "Computer Name: " computerName
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Retrieve Logged-in User Name (GetUserName).
VarSetCapacity(username, 256, 0)
size := 256
if DllCall("Advapi32\GetUserNameA", "Str", username, "UInt*", size)
    MsgBox % "Logged in as: " username
else
    MsgBox "Failed to retrieve user name."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙System Shutdown (Shutdown).
DllCall("User32\ExitWindowsEx", "UInt", 1, "UInt", 0)    ;;∙------∙Log off.
DllCall("User32\ExitWindowsEx", "UInt", 2, "UInt", 0)    ;;∙------∙Shutdown.
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get System Metrics (alternative to A_ScreenWidth and A_ScreenHeight).
screenWidth := DllCall("user32\GetSystemMetrics", "Int", 0)    ;;∙------∙Get screen Width.
screenHeight := DllCall("user32\GetSystemMetrics", "Int", 1)    ;;∙------∙Get screen Height.
MsgBox % "Screen Width: " screenWidth " Screen Height: " screenHeight
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Set Process Priority to High (SetPriorityClass).
hProcess := DllCall("kernel32\GetCurrentProcess", "Ptr")
;;∙------∙0x00000080 is HIGH_PRIORITY_CLASS.
DllCall("kernel32\SetPriorityClass", "Ptr", hProcess, "UInt", 0x00000080)
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get System Directory (GetSystemDirectory).
VarSetCapacity(sysDir, 260, 0)
DllCall("kernel32\GetSystemDirectory", "Str", sysDir, "UInt", 260)
MsgBox % "System Directory: " sysDir
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get System Info (GetSystemInfo).
;;∙------∙SYSTEM_INFO structure size may vary by platform    ;;∙------∙36 bytes works for x86.
VarSetCapacity(si, 36, 0)
DllCall("kernel32\GetSystemInfo", "Ptr", &si)
processorArch := NumGet(si, 0, "UInt")    ;;∙------∙Processor architecture code.
MsgBox % "Processor Architecture: " processorArch
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Logical Drives (GetLogicalDriveStrings).
VarSetCapacity(driveList, 256, 0)
DllCall("kernel32\GetLogicalDriveStrings", "UInt", 256, "Str", driveList)
MsgBox % "Logical Drives: " driveList
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Disk Free Space (GetDiskFreeSpaceEx).
drive := "C:\"
VarSetCapacity(freeBytesAvailable, 8, 0)
VarSetCapacity(totalNumberOfBytes, 8, 0)
VarSetCapacity(totalNumberOfFreeBytes, 8, 0)
DllCall("kernel32\GetDiskFreeSpaceEx", "Str", drive, "Ptr", &freeBytesAvailable, "Ptr", &totalNumberOfBytes, "Ptr", &totalNumberOfFreeBytes)
freeBytes := NumGet(freeBytesAvailable, 0, "UInt")
MsgBox % "Free disk space on " drive ": " freeBytes " bytes."
;;∙------------------------------------------------------------------------------------------∙

;;∙------------∙OR

;;∙------∙Get Disk Free Space
;;∙------∙Check free space on C: drive
VarSetCapacity(freeBytes, 8), VarSetCapacity(totalBytes, 8)
DllCall("kernel32\GetDiskFreeSpaceEx", "Str", "C:\", "Ptr", &freeBytes, "Ptr", &totalBytes, "Ptr", 0)

freeGB := NumGet(freeBytes, 0, "Int64") / 1073741824
totalGB := NumGet(totalBytes, 0, "Int64") / 1073741824
MsgBox C:\ Free Space: %freeGB% GB / %totalGB% GB
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get System Power Status (GetSystemPowerStatus).
;;∙------∙Retrieves the system's power status information.
VarSetCapacity(ps, 12, 0)
DllCall("kernel32\GetSystemPowerStatus", "Ptr", &ps)
ACLineStatus := NumGet(ps, 0, "UChar")    ;;∙------∙0 = offline, 1 = online, 255 = unknown.
MsgBox % "AC Line Status: " ACLineStatus
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Device Context (GetDC/ReleaseDC).
;;∙------∙Obtains and then releases a device context (DC) for the active window.
hwnd := DllCall("User32\GetForegroundWindow", "Ptr")
hdc := DllCall("User32\GetDC", "Ptr", hwnd, "Ptr")
MsgBox % "Obtained DC handle: " hdc
DllCall("User32\ReleaseDC", "Ptr", hwnd, "Ptr", hdc)
MsgBox "Device context released."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Create Mutex (CreateMutex).
hMutex := DllCall("kernel32\CreateMutex", "Ptr", 0, "Int", 0, "Str", "MyUniqueMutex", "Ptr")
MsgBox % "Mutex created. Handle: " hMutex
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Release Mutex (ReleaseMutex).
DllCall("kernel32\ReleaseMutex", "Ptr", hMutex)
MsgBox "Mutex released."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get OEM Code Page (GetOEMCP).
oemCP := DllCall("kernel32\GetOEMCP", "UInt")
MsgBox % "OEM Code Page: " oemCP
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Console Mode (GetConsoleMode).
;;∙------∙Retrieves the mode of the standard input (console).
hConsole := DllCall("kernel32\GetStdHandle", "Int", -10, "Ptr")
VarSetCapacity(mode, 4, 0)
if (DllCall("kernel32\GetConsoleMode", "Ptr", hConsole, "Ptr", &mode))
    MsgBox % "Console mode: " NumGet(mode, 0, "UInt")
else
    MsgBox "Failed to retrieve console mode."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Process Affinity Mask (GetProcessAffinityMask).
hProcess := DllCall("kernel32\GetCurrentProcess", "Ptr")
if DllCall("kernel32\GetProcessAffinityMask", "Ptr", hProcess, "UIntP", mask, "UIntP", systemMask)
    MsgBox Format("Current process affinity mask: 0x{:X}", mask)
else
    MsgBox "Failed to get process affinity mask."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Set Process Affinity Mask (SetProcessAffinityMask)
;;∙------∙Determines which CPU cores a process can use.
hProcess := DllCall("kernel32\GetCurrentProcess", "Ptr")
;;∙------∙Restrict process to use only the first CPU (mask = 0x1).
if (DllCall("kernel32\SetProcessAffinityMask", "Ptr", hProcess, "UInt", 1))
    MsgBox "Process affinity set to CPU 0."
else
    MsgBox "Failed to set process affinity."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Set Process Working Set Size (SetProcessWorkingSetSize).
hProcess := DllCall("kernel32\GetCurrentProcess", "Ptr")
;;∙------∙Set minimum and maximum working set sizes (in bytes).
if (DllCall("kernel32\SetProcessWorkingSetSize", "Ptr", hProcess, "UInt", 1024*1024, "UInt", 32*1024*1024))
    MsgBox "Process working set size adjusted."
else
    MsgBox "Failed to adjust working set size."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Open Current Process (OpenProcess).
;;∙------∙Opens a handle to the current process with query permissions.
PROCESS_QUERY_INFORMATION := 0x0400
currPID := DllCall("kernel32\GetCurrentProcessId", "UInt")
hProc := DllCall("kernel32\OpenProcess", "UInt", PROCESS_QUERY_INFORMATION, "Int", False, "UInt", currPID)
if (hProc)
{
    MsgBox % "Opened current process. Handle: " hProc
    DllCall("kernel32\CloseHandle", "Ptr", hProc)
}
else
    MsgBox "Failed to open current process."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Load and Free Library (LoadLibrary and FreeLibrary).
hModule := DllCall("kernel32\LoadLibrary", "Str", "User32.dll", "Ptr")
MsgBox % "User32.dll loaded. Handle: " hModule
DllCall("kernel32\FreeLibrary", "Ptr", hModule)
MsgBox "User32.dll freed."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Last Error (GetLastError).
;;∙------∙Retrieves the calling thread's last-error code value.
lastError := DllCall("kernel32\GetLastError", "UInt")
MsgBox % "Last Error Code: " lastError
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Adjust Token Privileges (AdjustTokenPrivileges).
;;∙------∙Attempts to enable the shutdown privilege for the current process.
hToken := 0
DllCall("advapi32\OpenProcessToken", "Ptr", DllCall("kernel32\GetCurrentProcess", "Ptr"), "UInt", 0x0020, "Ptr*", hToken)
VarSetCapacity(luid, 8, 0)
DllCall("advapi32\LookupPrivilegeValue", "Str", 0, "Str", "SeShutdownPrivilege", "Ptr", &luid)
;;∙------∙Build a TOKEN_PRIVILEGES structure: one privilege enabled.
VarSetCapacity(tp, 16, 0)
NumPut(1, tp, 0, "UInt")    ;;∙------∙PrivilegeCount
NumPut(0x00000002, tp, 4, "UInt")    ;;∙------∙SE_PRIVILEGE_ENABLED
DllCall("advapi32\AdjustTokenPrivileges", "Ptr", hToken, "Int", 0, "Ptr", &tp, "UInt", 0, "Ptr", 0, "Ptr", 0)
MsgBox "Shutdown privilege enabled (if permitted)."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Module Handle (GetModuleHandle).
hModule := DllCall("kernel32\GetModuleHandle", "Str", "kernel32.dll", "Ptr")
MsgBox % "Module Handle for kernel32.dll: " hModule
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Process Times (GetProcessTimes).
hProcess := DllCall("kernel32\GetCurrentProcess", "Ptr")
VarSetCapacity(ct, 8, 0), VarSetCapacity(et, 8, 0), VarSetCapacity(kt, 8, 0), VarSetCapacity(ut, 8, 0)
DllCall("kernel32\GetProcessTimes", "Ptr", hProcess, "Ptr", &ct, "Ptr", &et, "Ptr", &kt, "Ptr", &ut)
MsgBox "Process times retrieved."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Check WOW64 Status (IsWow64Process).
hProcess := DllCall("kernel32\GetCurrentProcess", "Ptr")
VarSetCapacity(isWow64, 4, 0)
if (DllCall("kernel32\IsWow64Process", "Ptr", hProcess, "Ptr", &isWow64))
    MsgBox % "IsWow64Process: " NumGet(isWow64, 0, "UInt")
else
    MsgBox "IsWow64Process call failed."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Query Performance Frequency (QueryPerformanceFrequency).
VarSetCapacity(freq, 8, 0)
DllCall("kernel32\QueryPerformanceFrequency", "Ptr", &freq)
timerFreq := NumGet(freq, 0, "Int64")
MsgBox % "High resolution timer frequency: " timerFreq
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Current Thread ID (GetCurrentThreadId).
threadID := DllCall("kernel32\GetCurrentThreadId", "UInt")
MsgBox % "Current Thread ID: " threadID
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Last Input Info (GetLastInputInfo).
VarSetCapacity(lii, 8, 0)
NumPut(8, lii, 0, "UInt")    ;;∙------∙Size of LASTINPUTINFO structure.
DllCall("User32\GetLastInputInfo", "Ptr", &lii)
lastTick := NumGet(lii, 4, "UInt")
MsgBox % "Last input tick: " lastTick
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Initialize COM Library (CoInitializeEx).
;;∙------∙Initializes the COM library for use by the calling thread.
DllCall("ole32\CoInitializeEx", "Ptr", 0, "UInt", 0)    ;;∙------∙0 = COINIT_MULTITHREADED (can also use 2 for STA)
MsgBox "COM library initialized."
;;∙------------------------------------------------------------------------------------------∙


;;∙===========================================∙
;;;;∙=======∙REGISTRY (use cation)∙=========∙9

;;∙------∙Open Registry Key (RegOpenKeyEx) and Close It (RegCloseKey).
;;∙------∙Opens a registry key for reading and then closes the handle.
hKey := 0
;;∙------∙HKEY_LOCAL_MACHINE = 0x80000002, KEY_READ = 0x20019.
result := DllCall("Advapi32\RegOpenKeyEx", "UInt", 0x80000002, "Str", "SOFTWARE\Microsoft\Windows\CurrentVersion", "UInt", 0, "UInt", 0x20019, "UInt*", hKey)
if (result = 0)
    MsgBox % "Registry key opened. Handle: " hKey
else
    MsgBox "Failed to open registry key."
DllCall("Advapi32\RegCloseKey", "UInt", hKey)
MsgBox "Registry key closed."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Read a Registry Value.
;;∙------∙Read a string value from a registry key.
hKey := 0
valueName := "ProgramFilesDir"  ; Example value under HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion

;;∙------∙Open the key
result := DllCall("Advapi32\RegOpenKeyEx", "UInt", 0x80000002, "Str", "SOFTWARE\Microsoft\Windows\CurrentVersion", "UInt", 0, "UInt", 0x20019, "UInt*", hKey)
if (result != 0) {
    MsgBox Failed to open key (Error: %result%).
    ExitApp
}

;;∙------∙Query the value
VarSetCapacity(valueData, 1024, 0)
dataSize := 1024
result := DllCall("Advapi32\RegQueryValueEx", "UInt", hKey, "Str", valueName, "UInt", 0, "UInt*", 0, "Ptr", &valueData, "UInt*", dataSize)
if (result = 0) {
    value := StrGet(&valueData)
    MsgBox Value "%valueName%": %value%
} else {
    MsgBox Failed to read value (Error: %result%).
}

DllCall("Advapi32\RegCloseKey", "UInt", hKey)
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Write a Registry Value.
;;∙------∙Write a string/DWORD value to a registry key.
hKey := 0
subKey := "SOFTWARE\YourAppName"
valueName := "Settings"
valueData := "Hello, Registry!"  ; For DWORD: Use "UInt", 42 and type := 0x4 (REG_DWORD)

;;∙------∙Open or create the key (KEY_WRITE = 0x20006)
result := DllCall("Advapi32\RegCreateKeyEx", "UInt", 0x80000002, "Str", subKey, "UInt", 0, "Str", "", "UInt", 0, "UInt", 0x20006, "UInt", 0, "UInt*", hKey, "UInt*", 0)
if (result != 0) {
    MsgBox Failed to create/open key (Error: %result%).
    ExitApp
}

;;∙------∙Write the value (REG_SZ = 0x1)
result := DllCall("Advapi32\RegSetValueEx", "UInt", hKey, "Str", valueName, "UInt", 0, "UInt", 0x1, "Str", valueData, "UInt", StrLen(valueData) + 1)
if (result = 0)
    MsgBox Value written successfully.
else
    MsgBox Failed to write value (Error: %result%).

DllCall("Advapi32\RegCloseKey", "UInt", hKey)
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Delete a Registry Value.
;;∙------∙Delete a value from a key.
hKey := 0
subKey := "SOFTWARE\Microsoft\Windows\CurrentVersion"
valueName := "YourValueName"

result := DllCall("Advapi32\RegOpenKeyEx", "UInt", 0x80000002, "Str", subKey, "UInt", 0, "UInt", 0x20019, "UInt*", hKey)
if (result != 0) {
    MsgBox Failed to open key (Error: %result%).
    ExitApp
}

result := DllCall("Advapi32\RegDeleteValue", "UInt", hKey, "Str", valueName)
if (result = 0)
    MsgBox Value "%valueName%" deleted.
else
    MsgBox Failed to delete value (Error: %result%).

DllCall("Advapi32\RegCloseKey", "UInt", hKey)
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Create a Registry Key.
;;∙------∙Create a new registry key.
hKey := 0
subKey := "SOFTWARE\YourAppName\NewSubKey"

result := DllCall("Advapi32\RegCreateKeyEx", "UInt", 0x80000002, "Str", subKey, "UInt", 0, "Str", "", "UInt", 0, "UInt", 0x20006, "UInt", 0, "UInt*", hKey, "UInt*", 0)
if (result = 0) {
    MsgBox Key created successfully.
    DllCall("Advapi32\RegCloseKey", "UInt", hKey)
} else {
    MsgBox Failed to create key (Error: %result%).
}
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Delete a Registry Key (32-bit and 64-bit Windows).
;;∙------∙Delete a registry key (requires admin rights for HKEY_LOCAL_MACHINE).
subKey := "SOFTWARE\YourAppName"
hKey := 0x80000002    ;;∙------∙HKEY_LOCAL_MACHINE.
flags := 0x0100    ;;∙------∙KEY_WOW64_64KEY (access 64-bit registry explicitly).

;;∙------∙Check if RegDeleteKeyEx is available (Windows Vista+)
if (A_OSVersion >= "6.0") {
    result := DllCall("Advapi32\RegDeleteKeyEx", "UInt", hKey, "Str", subKey, "UInt", flags, "UInt", 0)
} else {
    ;;∙------∙Fallback to RegDeleteKey (for Windows XP)
    result := DllCall("Advapi32\RegDeleteKey", "UInt", hKey, "Str", subKey)
}

if (result = 0)
    MsgBox Key deleted.
else
    MsgBox Failed to delete key (Error: %result%).
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Enumerate Subkeys.
;;∙------∙List all subkeys under a registry key.
hKey := 0
subKey := "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"

result := DllCall("Advapi32\RegOpenKeyEx", "UInt", 0x80000002, "Str", subKey, "UInt", 0, "UInt", 0x20019, "UInt*", hKey)
if (result != 0) {
    MsgBox Failed to open key (Error: %result%).
    ExitApp
}

index := 0
Loop {
    VarSetCapacity(keyName, 256, 0)
    keySize := 256
    result := DllCall("Advapi32\RegEnumKeyEx", "UInt", hKey, "UInt", index, "Str", keyName, "UInt*", keySize, "UInt", 0, "Ptr", 0, "Ptr", 0, "Ptr", 0)
    if (result != 0)
        break
    MsgBox Subkey %index%: %keyName%
    index++
}

DllCall("Advapi32\RegCloseKey", "UInt", hKey)
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Check if a Key Exists.
;;∙------∙Check if a registry key exists.
subKey := "SOFTWARE\Microsoft\Windows\CurrentVersion\FakeKey"

result := DllCall("Advapi32\RegOpenKeyEx", "UInt", 0x80000002, "Str", subKey, "UInt", 0, "UInt", 0x20019, "UInt*", hKey)
if (result = 0) {
    MsgBox Key exists.
    DllCall("Advapi32\RegCloseKey", "UInt", hKey)
} else {
    MsgBox Key does not exist (Error: %result%).
}
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Enumerate Values in a Key.
;;∙------∙List all values under a registry key.
hKey := 0
subKey := "SOFTWARE\Microsoft\Windows\CurrentVersion"

result := DllCall("Advapi32\RegOpenKeyEx", "UInt", 0x80000002, "Str", subKey, "UInt", 0, "UInt", 0x20019, "UInt*", hKey)
if (result != 0) {
    MsgBox Failed to open key (Error: %result%).
    ExitApp
}

index := 0
Loop {
    VarSetCapacity(valueName, 256, 0)
    nameSize := 256
    result := DllCall("Advapi32\RegEnumValue", "UInt", hKey, "UInt", index, "Str", valueName, "UInt*", nameSize, "UInt", 0, "UInt*", 0, "Ptr", 0, "Ptr", 0)
    if (result != 0)
        break
    MsgBox Value %index%: %valueName%
    index++
}

DllCall("Advapi32\RegCloseKey", "UInt", hKey)
;;∙------------------------------------------------------------------------------------------∙


;;∙===========================================∙
;;;;∙=======∙SOUNDS∙====================∙4

;;∙------∙Beep Sound (SoundBeep).
DllCall("Beep", "UInt", 1100, "UInt", 2000)    ;;∙------∙1100 Hz beep for 2000 ms.
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Play a Sound (SoundPlay).
DllCall("winmm.dll\PlaySound", "Str", "C:\Windows\Media\ding.wav", "Ptr", 0, "UInt", 0x20001)
;;∙------∙Play a Sound Synchronously (Wait until finished as script keeps running).
DllCall("winmm.dll\PlaySound", "Str", "C:\Windows\Media\ding.wav", "Ptr", 0, "UInt", 0x20000)
;;∙------∙Play a Sound on a Loop. (0x20000 > Play from a file/0x0001 > Play asynchronously/0x0008 > Loop the sound)
DllCall("winmm.dll\PlaySound", "Str", "C:\Windows\Media\ding.wav", "Ptr", 0, "UInt", 0x20009)
;;∙------∙Stopping the Loop.
DllCall("winmm.dll\PlaySound", "Ptr", 0, "Ptr", 0, "UInt", 0)

;;∙------∙0x20001      Asynchronous (Default)  • Plays sound & script continues.
;;∙------∙0x20000      Synchronous                       • Script waits until sound finishes.
;;∙------∙0x20009      Looping                                 • Sound repeats indefinitely until stopped.
;;∙------∙0, 0, 0           Stop Sound                          • Stops any currently playing sound.
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Play System Sound (MessageBeep).
DllCall("User32\MessageBeep", "UInt", 0xFFFFFFFF)    ;;<∙------∙Plays system-defined default sound.
MsgBox "System beep played."

;;∙------∙0x00000000 -> Simple default beep.
;;∙------∙0x00000010 --->  Hand (Error) sound.
;;∙------∙0x00000020 ---> Question sound (deprecated in newer Windows versions).
;;∙------∙0x00000030 ---> Exclamation sound.
;;∙------∙0x00000040 ---> Asterisk (Information) sound.
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Adjust System Volume (alternative to SoundSet).
;;∙------∙waveOutSetVolume uses a 16-bit range (0-65535) per speaker.  
DllCall("winmm.dll\waveOutSetVolume", "UInt", 0, "UInt", 0xFFFF0000)    ;;∙------∙Sets the right speaker to full volume and the left speaker to 0.
DllCall("winmm.dll\waveOutSetVolume", "UInt", 0, "UInt", 0x0000FFFF)    ;;∙------∙Sets the left speaker to full volume and the right speaker to 0.
;;∙------∙Max volume = 65535, so (65535 * 0.17) = 11141 → Hex: 0x2B85. 
DllCall("winmm.dll\waveOutSetVolume", "UInt", 0, "UInt", 0x2B852B85)    ;;∙------∙Set left and right speakers to volume of 17%.
;;∙------------------------------------------------------------------------------------------∙


;;∙===========================================∙
;;;;∙=======∙SYSTEM INFO∙=================∙8
;;∙------∙Add Custom Font (AddFontResourceEx - available only to your script.)
;;∙------∙Loads the font file must be in same folder script) into memory with the FR_PRIVATE flag (0x10) so it’s available only to your script.
customFontPath := A_ScriptDir "\MATRIX.ttf"
DllCall("AddFontResourceEx", "Str", customFontPath, "UInt", 0x10, "UInt", 0)    ;;∙------∙Load MATRIX.ttf as private font resource.
DllCall("RemoveFontResourceEx", "Str", customFontPath, "UInt", 0x10, "UInt", 0)    ;;∙------∙Remove MATRIX.ttf as private font resource.
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get User Default Language (GetUserDefaultLangID).
langID := DllCall("kernel32\GetUserDefaultLangID", "UInt")
MsgBox % "User Default Language ID: " langID
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get OS Version (RtlGetVersion) - Modern Replacement.
VarSetCapacity(osvi, 284, 0)       ; OSVERSIONINFOEXW structure.
NumPut(284, osvi, 0, "UInt")        ; dwOSVersionInfoSize = structure size.

;;∙------∙Call RtlGetVersion (does NOT require manifest).
if (DllCall("ntdll\RtlGetVersion", "Ptr", &osvi) = 0)  ; STATUS_SUCCESS = 0
{
    major := NumGet(osvi, 4, "UInt")   ; dwMajorVersion.
    minor := NumGet(osvi, 8, "UInt")   ; dwMinorVersion.
    build := NumGet(osvi, 12, "UInt")  ; dwBuildNumber.
    MsgBox % "OS Version: " major "." minor " (Build " build ")"
}
else
    MsgBox Failed to get OS version.
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get OS Version with Exact Edition Name (e.g., "Pro", "Enterprise").
;;∙------∙(Interacts with Registry).
VarSetCapacity(osvi, 284, 0)       ; OSVERSIONINFOEXW structure
NumPut(284, osvi, 0, "UInt")       ; Set dwOSVersionInfoSize

;;∙------∙Get version info.
if (DllCall("ntdll\RtlGetVersion", "Ptr", &osvi) = 0)  ; STATUS_SUCCESS = 0
{
    ;;∙------∙Extract version numbers.
    major := NumGet(osvi, 4, "UInt")    ; dwMajorVersion
    minor := NumGet(osvi, 8, "UInt")    ; dwMinorVersion
    build := NumGet(osvi, 12, "UInt")   ; dwBuildNumber
    productType := NumGet(osvi, 268, "UChar")  ; wProductType (offset 268).

    ;;∙------∙Determine base OS name (fallback).
    osBase := "Unknown OS"
    if (major = 10) {
        if (build >= 22000)
            osBase := "Windows 11"
        else
            osBase := "Windows 10"
    }
    else if (major = 6) {
        if (minor = 3)
            osBase := "Windows 8.1"
        else if (minor = 2)
            osBase := "Windows 8"
        else if (minor = 1)
            osBase := "Windows 7"
        else if (minor = 0)
            osBase := "Windows Vista"
    }
    else if (major = 5) {
        osBase := "Windows XP"
    }

    ;;∙------∙Get exact edition name from registry.
    RegRead, productName, HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion, ProductName
    if (!ErrorLevel) {
        ;;∙------∙Clean up the registry value (remove "Microsoft " prefix).
        osName := StrReplace(productName, "Microsoft ", "")
    } else {
        ;;∙------∙Fallback: Append Pro/Home based on productType.
        osName := osBase . ( (productType = 1) ? " Pro" : " Home" )
    }

    MsgBox % "OS: " osName "`nVersion: " major "." minor "`nBuild: " build
}
else
    MsgBox Failed to get OS version.
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get CPU Core Count.
;;∙------∙Retrieve number of logical processors.
VarSetCapacity(sysInfo, 48, 0) ; SYSTEM_INFO structure
DllCall("kernel32\GetSystemInfo", "Ptr", &sysInfo)
cores := NumGet(sysInfo, 20, "UInt") ; dwNumberOfProcessors
MsgBox CPU Cores: %cores%
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get System Uptime.
;;∙------∙Get milliseconds since system boot.
uptimeMs := DllCall("kernel32\GetTickCount64", "UInt64")
uptimeDays := uptimeMs // 86400000
MsgBox System Uptime: %uptimeDays% days
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Check Battery Status.
;;∙------∙Retrieve power status (AC/battery).
VarSetCapacity(powerStatus, 12, 0)
DllCall("kernel32\GetSystemPowerStatus", "Ptr", &powerStatus)

batteryLife := NumGet(powerStatus, 0, "UChar")  ; 0-100%
isCharging := NumGet(powerStatus, 2, "UChar")  ; 1 = charging
MsgBox Battery: %batteryLife%`%`nCharging: %isCharging%
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Check if Running as Admin.
;;∙------∙Determine if script has elevated privileges.
hToken := 0
DllCall("advapi32\OpenProcessToken", "Ptr", DllCall("kernel32\GetCurrentProcess"), "UInt", 0x8, "Ptr*", hToken) ; TOKEN_QUERY = 0x8

VarSetCapacity(elevation, 4)
size := 4
DllCall("advapi32\GetTokenInformation", "Ptr", hToken, "Int", 20, "Ptr", &elevation, "UInt", size, "UInt*", size) ; TokenElevation = 20

isAdmin := NumGet(elevation, 0, "UInt")
DllCall("kernel32\CloseHandle", "Ptr", hToken)
MsgBox Running as Admin: %isAdmin%
;;∙------------------------------------------------------------------------------------------∙


;;∙===========================================∙
;;;;∙=======∙TIMING∙=====================∙8

;;∙------∙Sleep / Delay (Sleep).
DllCall("Kernel32\Sleep", "UInt", 3000)    ;;∙------∙3-second delay.
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙High Resolution Timer (QueryPerformanceCounter).
VarSetCapacity(counter, 8, 0)
DllCall("kernel32\QueryPerformanceCounter", "Ptr", &counter)
highResTime := NumGet(counter, 0, "Int64")    ;;∙------∙Retrieves a 64-bit counter value.
MsgBox % "High Resolution Time: " highResTime
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙High Precision Sleep (NtDelayExecution).
;;∙------∙Delays execution for approximately 1 second.
;;∙------∙Delay value is negative in 100-nanosecond intervals (here: -10,000,000).
delay := -10000000
DllCall("ntdll\NtDelayExecution", "Int", 0, "Int64*", delay)
MsgBox "Slept for 1 second using NtDelayExecution."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Tick Count (GetTickCount).
tickCount := DllCall("kernel32\GetTickCount", "UInt")
MsgBox % "Tick Count: " tickCount
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Tick Count 64 (GetTickCount64).
tick64 := DllCall("kernel32\GetTickCount64", "UInt64")
MsgBox % "Tick Count 64: " tick64
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get System Time (alternative to A_TickCount)(UTC/GMT).
VarSetCapacity(systemTime, 16, 0)    ;;∙------∙Allocate memory for the SYSTEMTIME structure (16 bytes).
DllCall("kernel32\GetSystemTime", "Ptr", &systemTime)
;;∙------∙Extract year, month, day, hour, minute, second.
year := NumGet(systemTime, 0, "Short")
month := NumGet(systemTime, 2, "Short")
day := NumGet(systemTime, 4, "Short")
hour := NumGet(systemTime, 6, "Short")
minute := NumGet(systemTime, 8, "Short")
second := NumGet(systemTime, 10, "Short")
MsgBox % "Current Time: " year "/" month "/" day " " hour ":" minute ":" second
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Local Time (GetLocalTime)(Local Time Zone).
VarSetCapacity(localTime, 16, 0)    ;;∙------∙Allocate memory for the SYSTEMTIME structure (16 bytes).
DllCall("kernel32\GetLocalTime", "Ptr", &localTime)
year   := NumGet(localTime, 0, "UShort")
month  := NumGet(localTime, 2, "UShort")
day    := NumGet(localTime, 4, "UShort")
hour   := NumGet(localTime, 6, "UShort")
minute := NumGet(localTime, 8, "UShort")
second := NumGet(localTime, 10, "UShort")
MsgBox % "Local Date and Time: " year "-" month "-" day " " hour ":" minute ":" second
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Time Zone Information.
;;∙------∙Retrieve current time zone details.
VarSetCapacity(tzInfo, 172, 0)
result := DllCall("kernel32\GetTimeZoneInformation", "Ptr", &tzInfo)

bias := NumGet(tzInfo, 0, "Int") ; UTC offset in minutes
stdName := StrGet(&tzInfo + 4, 32) ; Standard time name
MsgBox UTC Offset: %bias% minutes`nTime Zone: %stdName%
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Wait for Single Object (WaitForSingleObject).
;;∙------∙Create an unsignaled event then wait for it (1-second timeout).
hEvent := DllCall("kernel32\CreateEvent", "Ptr", 0, "Int", 1, "Int", 0, "Str", "", "Ptr")
result := DllCall("kernel32\WaitForSingleObject", "Ptr", hEvent, "UInt", 1000)
DllCall("kernel32\CloseHandle", "Ptr", hEvent)
MsgBox % "WaitForSingleObject result: " result
;;∙------------------------------------------------------------------------------------------∙


;;∙===========================================∙
;;;;∙=======∙WINDOW MANAGEMENT∙======∙34

;;∙------∙Get Active Window Title (WinGetTitle)    ;;∙------∙Retrieves the title of the currently active window.
VarSetCapacity(WinTitle, 260, 0)    ;;∙------∙Allocate memory for the window title.
DllCall("User32\GetWindowText", "Ptr", DllCall("User32\GetForegroundWindow", "Ptr"), "Str", WinTitle, "Int", 260)
MsgBox % "Active Window Title: " WinTitle
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Window Title by Handle (alternative to WinGetTitle)    ;;∙------∙Get the title of named window.
VarSetCapacity(windowTitle, 256, 0)    ;;∙------∙Allocate space for the window title.
hwnd := DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0)    ;;∙------∙Find window by title (Notepad).
DllCall("User32\GetWindowText", "Ptr", hwnd, "Str", windowTitle, "Int", 256)    ;;∙------∙Get title of the window.
MsgBox % "Window Title: " windowTitle
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Window Handle by Class Name (alternative to WinExist with class).
hwnd := DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0)    ;;∙------∙Find window by class name (Notepad).
if (hwnd)
    MsgBox % "Window handle: " hwnd
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Window Class Name (GetClassName).
hwnd := DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0)
VarSetCapacity(className, 256, 0)
DllCall("User32\GetClassName", "Ptr", hwnd, "Str", className, "Int", 256)
MsgBox % "Window Class Name: " className
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get the Current Window's Handle (alternative to WinActive).
hwnd := DllCall("User32\GetForegroundWindow", "Ptr")    ;;∙------∙Get the handle of the active window.
if (hwnd)
    MsgBox % "Current Active Window Handle: " hwnd
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Minimize Window (alternative to WinMinimize).
DllCall("User32\ShowWindow", "Ptr", DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0), "Int", 6)    ;;∙------∙Minimize Notepad.
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Minimize All Windows (alternative to WinMinimizeAll).
DllCall("User32\ShowWindow", "Ptr", 0, "Int", 2)    ;;∙------∙Minimize all windows.
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Restore Window (alternative to WinRestore).
DllCall("User32\ShowWindow", "Ptr", DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0), "Int", 9)    ;;∙------∙Restore Notepad.
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Hide Window (alternative to WinHide).
DllCall("User32\ShowWindow", "Ptr", DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0), "Int", 0)    ;;∙------∙Hide Notepad.
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Show Window (alternative to WinShow).
DllCall("User32\ShowWindow", "Ptr", DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0), "Int", 5)    ;;∙------∙Show Notepad.
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Window Position (alternative to WinGetPos).
VarSetCapacity(rect, 16, 0)    ;;∙------∙Allocate memory for RECT structure.
hwnd := DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0)
DllCall("User32\GetWindowRect", "Ptr", hwnd, "Ptr", &rect)
x := NumGet(rect, 0, "Int"), y := NumGet(rect, 4, "Int"), w := NumGet(rect, 8, "Int"), h := NumGet(rect, 12, "Int")
MsgBox % "Window Position: X=" x " Y=" y " Width=" w " Height=" h
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Set Window Position (alternative to WinMove).
DllCall("User32\SetWindowPos", "Ptr", DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0), "Ptr", 0, "Int", 100, "Int", 100, "Int", 800, "Int", 600, "UInt", 0x0040)
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Send Alt+Tab (simulate Alt+Tab to switch windows).
DllCall("user32\keybd_event", "UChar", 0x12, "UChar", 0, "UInt", 0, "Ptr", 0)    ;;∙------∙Press Alt.
DllCall("user32\keybd_event", "UChar", 0x09, "UChar", 0, "UInt", 0, "Ptr", 0)    ;;∙------∙Press Tab.
DllCall("user32\keybd_event", "UChar", 0x09, "UChar", 0, "UInt", 2, "Ptr", 0)    ;;∙------∙Release Tab.
DllCall("user32\keybd_event", "UChar", 0x12, "UChar", 0, "UInt", 2, "Ptr", 0)    ;;∙------∙Release Alt.
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Check if Window is Open (alternative to WinExist).
hwnd := DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0)    ;;∙------∙Find window by title (Notepad).
if (hwnd)
    MsgBox % "Window is open."
else
    MsgBox % "Window is not open."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Close Window (alternative to WinClose).
hwnd := DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0)    ;;∙------∙Find Notepad window.
if (hwnd)
    DllCall("User32\PostMessage", "Ptr", hwnd, "UInt", 0x0010, "Ptr", 0, "Ptr", 0)    ;;∙------∙Close the window.
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Send Alt+F4 (simulate pressing Alt+F4 to close a window).
DllCall("user32\keybd_event", "UChar", 0x12, "UChar", 0, "UInt", 0, "Ptr", 0)    ;;∙------∙Press Alt.
DllCall("user32\keybd_event", "UChar", 0x73, "UChar", 0, "UInt", 0, "Ptr", 0)    ;;∙------∙Press F4.
DllCall("user32\keybd_event", "UChar", 0x73, "UChar", 0, "UInt", 2, "Ptr", 0)    ;;∙------∙Release F4.
DllCall("user32\keybd_event", "UChar", 0x12, "UChar", 0, "UInt", 2, "Ptr", 0)    ;;∙------∙Release Alt.
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Send WM_CLOSE Message (SendMessage).
hwnd := DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0)
DllCall("User32\SendMessage", "Ptr", hwnd, "UInt", 0x0010, "Ptr", 0, "Ptr", 0)    ;;∙------∙WM_CLOSE = 0x0010.
MsgBox "WM_CLOSE message sent to Notepad."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Foreground Window Process ID (GetWindowThreadProcessId).
hwnd := DllCall("User32\GetForegroundWindow", "Ptr")
VarSetCapacity(pid, 4, 0)
DllCall("User32\GetWindowThreadProcessId", "Ptr", hwnd, "UInt*", pid)
processID := NumGet(pid, 0, "UInt")
MsgBox % "Foreground Window Process ID: " processID
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Set Foreground Window (SetForegroundWindow).
hwnd := DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0)
DllCall("User32\SetForegroundWindow", "Ptr", hwnd)
MsgBox "Notepad brought to the foreground."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Set Window Transparency (SetLayeredWindowAttributes).
;;∙------∙Applies a 50% transparency effect to a window (e.g., Notepad).
hwnd := DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0)
exStyle := DllCall("User32\GetWindowLongPtr", "Ptr", hwnd, "Int", -20, "Ptr") ; GWLP_EXSTYLE = -20
DllCall("User32\SetWindowLongPtr", "Ptr", hwnd, "Int", -20, "Ptr", exStyle | 0x80000) ; WS_EX_LAYERED = 0x80000
DllCall("User32\SetLayeredWindowAttributes", "Ptr", hwnd, "UInt", 0, "Byte", 128, "UInt", 2)
MsgBox, % "Notepad transparency set to 50%."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Change Window Transparency (alternative to WinSet Transparent).
DllCall("Dwmapi\DwmEnableBlurBehindWindow", "Ptr", DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0), "Ptr", &blurBehind)    ;;∙------∙Enable transparency effect on Notepad.
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Move and Resize Window (MoveWindow).
hwnd := DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0)
;;∙------∙Move window to (150, 150) with width=800 and height=600, and repaint immediately.
DllCall("User32\MoveWindow", "Ptr", hwnd, "Int", 150, "Int", 150, "Int", 800, "Int", 600, "Int", True)
MsgBox "Notepad moved and resized."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get/Set Window Style (GetWindowLong & SetWindowLong).
hwnd := DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0)
oldStyle := DllCall("User32\GetWindowLongPtr", "Ptr", hwnd, "Int", -16, "Ptr") ; GWLP_STYLE = -16

;;∙------∙Example: remove the window's border (0x00800000 = WS_BORDER).
newStyle := oldStyle & ~0x00800000 ; Remove WS_BORDER
DllCall("User32\SetWindowLongPtr", "Ptr", hwnd, "Int", -16, "Ptr", newStyle)
MsgBox % "Old Style: " oldStyle " -> New Style: " newStyle
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Enable/Disable Window (EnableWindow).
hwnd := DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0)
;;∙------∙Disable the window.
DllCall("User32\EnableWindow", "Ptr", hwnd, "Int", 0)
Sleep 1000
;;∙------∙Re-enable the window.
DllCall("User32\EnableWindow", "Ptr", hwnd, "Int", 1)
MsgBox "Toggled Notepad's enabled state."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Set Window Text (SetWindowText).
;;∙------∙Changes the title of a window (e.g., Notepad).
hwnd := DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0)
DllCall("User32\SetWindowText", "Ptr", hwnd, "Str", "New Notepad Title")
MsgBox "Notepad window title updated."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Window Text Length (GetWindowTextLength).
hwnd := DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0)
length := DllCall("User32\GetWindowTextLength", "Ptr", hwnd, "Int")
MsgBox % "Notepad window title length: " length
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Extended Window Style (GetWindowLongPtr).
hwnd := DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0)
exStyle := DllCall("User32\GetWindowLongPtr", "Ptr", hwnd, "Int", -20)
MsgBox % "Extended Window Style: 0x" Format("{:X}", exStyle)
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Set Extended Window Style (SetWindowLongPtr).
hwnd := DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0)
exStyle := DllCall("User32\GetWindowLongPtr", "Ptr", hwnd, "Int", -20)
newExStyle := exStyle | 0x00000008    ;;∙------∙WS_EX_TOPMOST
DllCall("User32\SetWindowLongPtr", "Ptr", hwnd, "Int", -20, "Ptr", newExStyle)
MsgBox "Notepad set to topmost."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Invalidate Window Rect (InvalidateRect).
hwnd := DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0)
DllCall("User32\InvalidateRect", "Ptr", hwnd, "Ptr", 0, "Int", 1)
MsgBox "Notepad invalidated (redraw triggered)."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Adjust Window Rectangle (AdjustWindowRect).
;;∙------∙Calculates the required window size for a desired client area (800x600) with standard window styles.
desiredWidth := 800, desiredHeight := 600
VarSetCapacity(rect, 16, 0)
NumPut(0, rect, 0, "Int")    ;;∙------∙Left.
NumPut(0, rect, 4, "Int")    ;;∙------∙Top.
NumPut(desiredWidth, rect, 8, "Int")    ;;∙------∙Right.
NumPut(desiredHeight, rect, 12, "Int")    ;;∙------∙Bottom.
;;∙------∙WS_OVERLAPPEDWINDOW style: 0x00CF0000.
DllCall("User32\AdjustWindowRect", "Ptr", &rect, "UInt", 0x00CF0000, "Int", 0)
adjWidth := NumGet(rect, 8, "Int") - NumGet(rect, 0, "Int")
adjHeight := NumGet(rect, 12, "Int") - NumGet(rect, 4, "Int")
MsgBox % "Adjusted window size for an 800x600 client area:" adjWidth "x" adjHeight
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Update Window Immediately (UpdateWindow).
hwnd := DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0)
DllCall("User32\UpdateWindow", "Ptr", hwnd)
MsgBox "Notepad window updated immediately."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Get Window Device Context (GetWindowDC).
hwnd := DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0)
hDC := DllCall("User32\GetWindowDC", "Ptr", hwnd, "Ptr")
MsgBox % "Device Context for Notepad: " hDC
DllCall("User32\ReleaseDC", "Ptr", hwnd, "Ptr", hDC)
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Enumerate Top-Level Windows (EnumWindows).
;;∙------∙Lists the titles and handles of all top-level windows.
WinList := ""
EnumCallback := RegisterCallback("EnumWindowsProc", "Fast")
DllCall("User32\EnumWindows", "Ptr", EnumCallback, "Ptr", 0)
MsgBox % "Top-level windows:`n" WinList

EnumWindowsProc(hwnd, lParam) {
    global WinList
    VarSetCapacity(title, 256, 0)
    DllCall("User32\GetWindowText", "Ptr", hwnd, "Str", title, "Int", 256)
    if (title != "")
        WinList .= "0x" Format("{:X}", hwnd) ": " title "`n"
    return true    ;;∙------∙Continue enumeration.
}
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Enumerate Child Windows (FindWindowEx).
parentHwnd := DllCall("User32\FindWindow", "Str", "Notepad", "Ptr", 0)
childHwnd := 0, childList := ""
Loop {
    childHwnd := DllCall("User32\FindWindowEx", "Ptr", parentHwnd, "Ptr", childHwnd, "Ptr", 0, "Ptr", 0)
    if (!childHwnd)
        break
    childList .= "Child Window Handle: 0x" Format("{:X}", childHwnd) "`n"
}
MsgBox % "Child windows of Notepad:`n" childList
;;∙------------------------------------------------------------------------------------------∙


;;∙===========================================∙
;;;;∙=======∙WINDOW MESSAGING∙========∙4

;;∙------∙Message Box (MsgBox).
DllCall("User32\MessageBox", "Ptr", 0, "Str", "Hello, world!", "Str", "Title", "UInt", 0)
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Peek Message (PeekMessage).
VarSetCapacity(msg, 48, 0)    ;;∙------∙MSG structure size.
if (DllCall("User32\PeekMessage", "Ptr", &msg, "Ptr", 0, "UInt", 0, "UInt", 0, "UInt", 1))
    MsgBox "A message is waiting in the queue."
else
    MsgBox "No message in the queue."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Post Quit Message (PostQuitMessage).
;;∙------∙Posts a WM_QUIT message to the calling thread's message queue.
DllCall("User32\PostQuitMessage", "Int", 0)
MsgBox "WM_QUIT message posted."
;;∙------------------------------------------------------------------------------------------∙

;;∙------∙Register Window Message (RegisterWindowMessage).
msgId := DllCall("User32\RegisterWindowMessage", "Str", "MY_CUSTOM_MESSAGE", "UInt")
MsgBox % "Custom message ID: " msgId
;;∙------------------------------------------------------------------------------------------∙
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
DllCall_Options:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

