
;;∙----------------------------------------------∙
SetTimer, UpdateCheck, 500
GoSub, TrayMenu
;;∙----------------------------------------------∙




;;∙----------------------------------------------∙
;;∙======∙DIRECTIVES & SETTINGS∙=================∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force
SendMode, Input
Menu, Tray, Icon, shell32.dll, 208
SetWorkingDir %A_ScriptDir%
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")

;;∙======∙SORTING VARIABLE∙======================∙
;;∙------∙Sorting options: "Dimension", "Refresh", "Ratio"
;;∙------∙Combine multiple: "Dimension Refresh Ratio", "Refresh Ratio", etc.
global sortMode := "Dimension Refresh Ratio"

;;∙======∙HOTKEYS∙===============================∙
F1::    ;;∙----∙🔥∙
    Gosub, GatherMonitorInfo
Return

F2::    ;;∙----∙Save to text file.
    if (wmiMonitorCount = "" || wmiMonitorCount = 0) {
        Gosub, CollectData
    }
    FileSelectFile, savePath, S, %A_Desktop%\MonitorInfo.txt, Save Monitor Info, Text Files (*.txt)
    if (savePath = "")
        return
    FileDelete, %savePath%
    FileAppend, %clipboardOutput%, %savePath%
    Soundbeep, 1000, 100
    Soundbeep, 1200, 100
Return

F3::    ;;∙----∙🔥∙Save as HTML with colored text.
    if (wmiMonitorCount = "" || wmiMonitorCount = 0) {
        Gosub, CollectData
    }
    htmlOutput := "<html><head><style>body{background:#111122;color:#fff;font-family:Consolas;}"
    htmlOutput .= ".c1{color:#00FFFF}.c2{color:#00FF00}.c3{color:#FFFF00}"
    htmlOutput .= ".c4{color:#FF00FF}.c5{color:#FF0000}.c6{color:#0000FF}</style></head><body><pre>"
    ;;∙----∙Add GPU info if available.
    if (globalGPUInfo != "") {
        htmlOutput .= "<span style='color:#FFFFFF'>System GPU Information:</span><br>"
        StringReplace, gpuText, globalGPUInfo, `n, <br>
        htmlOutput .= "<span style='color:#CCCCCC'>" . gpuText . "</span><br>"
        htmlOutput .= "----------------------------------------<br><br>"
    }
    Loop, % wmiMonitorCount {
        colorClass := Mod(A_Index - 1, 6) + 1
        monitorText := monitorOutputs[A_Index]
        StringReplace, monitorText, monitorText, `n, <br>
        htmlOutput .= "<span class='c" . colorClass . "'>" . monitorText . "</span><br><br>"
    }
    htmlOutput .= "</pre></body></html>"
    FileSelectFile, savePath, S, %A_Desktop%\MonitorInfo.html, Save as HTML, HTML Files (*.html)
    if (savePath = "")
        return
    FileDelete, %savePath%
    FileAppend, %htmlOutput%, %savePath%
    Run, %savePath%
    Soundbeep, 1000, 100
    Soundbeep, 1200, 100
Return

;;∙======∙GATHER MONITOR INFO∙===================∙
GatherMonitorInfo:
    Gosub, CollectData
    Gosub, ShowGUI
Return

;;∙======∙GET MONITOR INFO∙======================∙
CollectData:
try {
    wmi := ComObjGet("winmgmts:{impersonationLevel=impersonate}!\\" . A_ComputerName . "\root\wmi")
} catch {
    MsgBox, 16, Error, Failed to connect to WMI.
    ExitApp
}
SysGet, primaryMonitor, MonitorPrimary
SysGet, monitorCount, MonitorCount
global sysGetNames := Object()
Loop, % monitorCount {
    SysGet, monitorName, MonitorName, % A_Index
    sysGetNames[A_Index] := monitorName
}
try {
    monitors := wmi.ExecQuery("SELECT * FROM WmiMonitorListedSupportedSourceModes WHERE Active=TRUE")
} catch {
    MsgBox, 16, Error, Failed to query monitor modes.
    ExitApp
}
try {
    edidMonitors := wmi.ExecQuery("SELECT * FROM WmiMonitorID WHERE Active=TRUE")
} catch {
    edidMonitors := ""
}

;;∙======∙EDID FUNCTIONS∙========================∙
EDIDBytesToString(bytes) {
    str := ""
    for index, byte in bytes {
        if (byte = 0)
            break
        if (byte >= 32 && byte <= 126)
            str .= Chr(byte)
    }
    return str
}

GetManufacturerName(manufacturerBytes) {
    if (manufacturerBytes.MaxIndex() < 2)
        return ""
    byte1 := manufacturerBytes[1]
    byte2 := manufacturerBytes[2]
    letter1 := Chr(((byte1 >> 2) & 0x1F) + 65)
    letter2 := Chr((((byte1 & 0x03) << 3) | ((byte2 >> 5) & 0x07)) + 65)
    letter3 := Chr((byte2 & 0x1F) + 65)
    return letter1 . letter2 . letter3
}

;;∙======∙STORE EDID INFO∙=======================∙
global monitorEDID := Object()
for edidMonitor in edidMonitors {
    instanceName := edidMonitor.InstanceName
    manufName := GetManufacturerName(edidMonitor.ManufacturerName)
    modelName := EDIDBytesToString(edidMonitor.UserFriendlyName)
    if (modelName = "") {
        modelName := EDIDBytesToString(edidMonitor.UserFriendlyName)
    }
    if (modelName = "") {
        if (edidMonitor.ProductCodeID.MaxIndex() >= 2) {
            productCode := Format("{:04X}", (edidMonitor.ProductCodeID[1] << 8) | edidMonitor.ProductCodeID[2])
            modelName := manufName . " " . productCode
        } else {
            modelName := "Unknown Model"
        }
    }
    monitorEDID[instanceName] := {Manufacturer: manufName, Model: modelName}
}

;;∙======∙SORTING FUNCTIONS∙=====================∙
SortModes(ByRef modeArray, sortString) {
    sortTypes := StrSplit(sortString, " ")
    Loop, % modeArray.MaxIndex() - 1 {
        swapped := false
        Loop, % modeArray.MaxIndex() - A_Index {
            if (CompareModes(modeArray[A_Index], modeArray[A_Index + 1], sortTypes) > 0) {
                temp := modeArray[A_Index]
                modeArray[A_Index] := modeArray[A_Index + 1]
                modeArray[A_Index + 1] := temp
                swapped := true
            }
        }
        if (!swapped)
            break
    }
}

CompareModes(mode1, mode2, sortTypes) {
    for index, sortType in sortTypes {
        if (sortType = "Dimension") {
            dim1 := mode1.HorizontalActivePixels * mode1.VerticalActivePixels
            dim2 := mode2.HorizontalActivePixels * mode2.VerticalActivePixels
            result := dim2 - dim1
        } else if (sortType = "Refresh") {
            refresh1 := Round(mode1.VerticalRefreshRateNumerator / mode1.VerticalRefreshRateDenominator, 1)
            refresh2 := Round(mode2.VerticalRefreshRateNumerator / mode2.VerticalRefreshRateDenominator, 1)
            result := refresh2 - refresh1
        } else if (sortType = "Ratio") {
            if (mode1.VerticalActivePixels = 0 || mode2.VerticalActivePixels = 0) {
                result := 0
            } else {
                ratio1 := mode1.HorizontalActivePixels / mode1.VerticalActivePixels
                ratio2 := mode2.HorizontalActivePixels / mode2.VerticalActivePixels
                if (ratio2 > ratio1)
                    result := 1
                else if (ratio2 < ratio1)
                    result := -1
                else
                    result := 0
            }
        } else {
            dim1 := mode1.HorizontalActivePixels * mode1.VerticalActivePixels
            dim2 := mode2.HorizontalActivePixels * mode2.VerticalActivePixels
            result := dim2 - dim1
        }
        if (result != 0) {
            return result > 0 ? 1 : -1
        }
    }
    return 0
}

;;∙======∙ASPECT RATIO FUNCTION∙=================∙
CalculateAspectRatio(width, height) {
    if (height = 0)
        return "N/A"
    ratio := width / height
    if (Abs(ratio - 1.33) < 0.05)
        return "4:3"
    if (Abs(ratio - 1.25) < 0.05)
        return "5:4"
    if (Abs(ratio - 1.6) < 0.05)
        return "16:10"
    if (Abs(ratio - 1.78) < 0.05)
        return "16:9"
    if (Abs(ratio - 2.0) < 0.05)
        return "18:9"
    if (Abs(ratio - 2.33) < 0.05)
        return "21:9"
    if (Abs(ratio - 2.37) < 0.05)
        return "21:9"
    if (Abs(ratio - 2.4) < 0.05)
        return "24:10"
    if (Abs(ratio - 1.0) < 0.05)
        return "1:1"
    if (Abs(ratio - 1.5) < 0.05)
        return "3:2"
    gcd := GCD(width, height)
    simplifiedWidth := width // gcd
    simplifiedHeight := height // gcd
    if (simplifiedWidth <= 100 && simplifiedHeight <= 100) {
        return simplifiedWidth . ":" . simplifiedHeight
    }
    return Round(ratio, 2)
}
GCD(a, b) {
    while b {
        t := b
        b := Mod(a, b)
        a := t
    }
    return a
}

;;∙======∙GET GPU INFO∙==========================∙
GetGPUInfo() {
    gpuInfo := ""
    try {
        gpuWmi := ComObjGet("winmgmts:{impersonationLevel=impersonate}!\\" . A_ComputerName . "\root\cimv2")
        for gpu in gpuWmi.ExecQuery("SELECT * FROM Win32_VideoController") {
            if (gpuInfo != "")
                gpuInfo .= "`n"
            gpuInfo .= "  GPU: " . gpu.Name . "`n"
            gpuInfo .= "  Driver Version: " . gpu.DriverVersion . "`n"
            ;;∙----∙Parse DMTF datetime format to readable date.
            driverDate := gpu.DriverDate
            if (driverDate != "" && StrLen(driverDate) >= 14) {
                ;;∙----∙DMTF format: yyyymmddHHMMSS.mmmmmmsUUU
                year := SubStr(driverDate, 1, 4)
                month := SubStr(driverDate, 5, 2)
                day := SubStr(driverDate, 7, 2)
                formattedDate := year . "-" . month . "-" . day
                gpuInfo .= "  Driver Date: " . formattedDate . "`n"
            } else {
                gpuInfo .= "  Driver Date: N/A`n"
            }
            if (gpu.AdapterRAM > 0) {
                vramBytes := gpu.AdapterRAM
                if (vramBytes >= 1073741824) {
                    vramGB := Round(vramBytes / 1073741824, 1)
                    gpuInfo .= "  VRAM: " . vramGB . " GB`n"
                } else if (vramBytes >= 1048576) {
                    vramMB := Round(vramBytes / 1048576, 0)
                    gpuInfo .= "  VRAM: " . vramMB . " MB`n"
                } else {
                    vramKB := Round(vramBytes / 1024, 0)
                    gpuInfo .= "  VRAM: " . vramKB . " KB`n"
                }
            }
            ;;∙----∙Clean up Video Mode Description.
            videoMode := gpu.VideoModeDescription
            if (videoMode != "") {
                videoMode := StrReplace(videoMode, " x 4294967296 colors", "")
                if (videoMode != gpu.VideoModeDescription) {
                    videoMode .= " x 32-bit True Color"
                }
                gpuInfo .= "  Video Mode Description: " . videoMode . "`n"
            }
            gpuInfo .= "  Current Resolution: " . gpu.CurrentHorizontalResolution . "x" . gpu.CurrentVerticalResolution . "`n"
            gpuInfo .= "  Current Refresh Rate: " . gpu.CurrentRefreshRate . " Hz`n"
            if (gpu.CurrentBitsPerPixel > 0) {
                gpuInfo .= "  Color Depth: " . gpu.CurrentBitsPerPixel . "-bit`n"
            }
            break    ;;∙----∙Just first GPU for now, but could be extended for multi-GPU.
        }
    } catch {
        gpuInfo := "  Failed to retrieve GPU information"
    }
    return gpuInfo
}

;;∙======∙GET CONNECTOR TYPE∙====================∙
GetConnectorType(instanceName) {
    connectorInfo := ""
    try {
        capsMonitors := wmi.ExecQuery("SELECT * FROM WmiMonitorConnectionParams WHERE Active=TRUE")
        for capsMonitor in capsMonitors {
            if (capsMonitor.InstanceName = instanceName) {
                videoConnector := capsMonitor.VideoOutputTechnology
                if (videoConnector = 0)
                    connectorInfo := "VGA"
                else if (videoConnector = 1)
                    connectorInfo := "S-Video"
                else if (videoConnector = 2)
                    connectorInfo := "Composite"
                else if (videoConnector = 3)
                    connectorInfo := "Component"
                else if (videoConnector = 4)
                    connectorInfo := "DVI"
                else if (videoConnector = 5)
                    connectorInfo := "HDMI"
                else if (videoConnector = 6)
                    connectorInfo := "LVDS"
                else if (videoConnector = 8)
                    connectorInfo := "D_JPN"
                else if (videoConnector = 9)
                    connectorInfo := "SDI"
                else if (videoConnector = 10)
                    connectorInfo := "DisplayPort External"
                else if (videoConnector = 11)
                    connectorInfo := "DisplayPort Embedded"
                else if (videoConnector = 12)
                    connectorInfo := "UDI External"
                else if (videoConnector = 13)
                    connectorInfo := "UDI Embedded"
                else if (videoConnector = 14)
                    connectorInfo := "SDTVDongle"
                else if (videoConnector = 15)
                    connectorInfo := "Miracast"
                else if (videoConnector = 16)
                    connectorInfo := "Internal"
                else
                    connectorInfo := "Unknown (" . videoConnector . ")"
                break
            }
        }
    } catch {
        connectorInfo := "Unable to detect"
    }
    return connectorInfo
}

;;∙======∙BUILD OUTPUT∙==========================∙
global monitorOutputs := Object()
wmiMonitorCount := 0
;;∙----∙Get GPU info first (shared across all monitors)
globalGPUInfo := GetGPUInfo()

for monitor in monitors {
    wmiMonitorCount++
    output := ""
    isPrimary := (wmiMonitorCount = primaryMonitor)
    output .= "Monitor " . wmiMonitorCount . ":"
    if (isPrimary) {
        output .= " (Primary)"
    }
    output .= "`n"
    output .= "  Instance: " . monitor.InstanceName . "`n"

    ;;∙----∙EDID Information.
    if (monitorEDID.HasKey(monitor.InstanceName)) {
        edidInfo := monitorEDID[monitor.InstanceName]
        if (edidInfo.Manufacturer != "") {
            output .= "  Manufacturer: " . edidInfo.Manufacturer . "`n"
        }
        if (edidInfo.Model != "") {
            output .= "  Model: " . edidInfo.Model . "`n"
        }
    }
    ;;∙----∙System Name.
    if (sysGetNames.HasKey(wmiMonitorCount)) {
        output .= "  System Name: " . sysGetNames[wmiMonitorCount] . "`n"
    }
    ;;∙----∙Connector Type.
    connectorType := GetConnectorType(monitor.InstanceName)
    if (connectorType != "") {
        output .= "  Connector: " . connectorType . "`n"
    }
    ;;∙----∙Physical Size Detection.
    maxPixels := 0
    monitorWidth := 0
    monitorHeight := 0
    nativeWidth := 0
    nativeHeight := 0
    nativeRefresh := 0

    for mode in monitor.MonitorSourceModes {
        totalPixels := mode.HorizontalActivePixels * mode.VerticalActivePixels
        if (mode.HorizontalImageSize > 100) {
            if (totalPixels > maxPixels) {
                maxPixels := totalPixels
                monitorWidth := mode.HorizontalImageSize
                monitorHeight := mode.VerticalImageSize
            }
        }
        currentRefresh := Round(mode.VerticalRefreshRateNumerator / mode.VerticalRefreshRateDenominator, 1)
        if (totalPixels > (nativeWidth * nativeHeight) || (totalPixels = (nativeWidth * nativeHeight) && currentRefresh > nativeRefresh)) {
            nativeWidth := mode.HorizontalActivePixels
            nativeHeight := mode.VerticalActivePixels
            nativeRefresh := currentRefresh
        }
    }
    if (monitorWidth > 0 && monitorHeight > 0) {
        diagonalInches := Round(Sqrt(monitorWidth**2 + monitorHeight**2) / 25.4, 1)
        output .= "  Physical Size: " . monitorWidth . "x" . monitorHeight . "mm (" . diagonalInches . " inch)`n"
    }

    ;;∙----∙Current Display Settings.
    try {
        VarSetCapacity(devMode, 156, 0)
        NumPut(156, devMode, 36, "UShort")    ;;∙----∙dmSize.
        deviceName := "\\.\DISPLAY" . (wmiMonitorCount)
        if (DllCall("EnumDisplaySettings", "Str", deviceName, "UInt", -1, "Ptr", &devMode)) {    ;;∙----∙ENUM_CURRENT_SETTINGS = -1
            currentRefresh := NumGet(devMode, 120, "UInt")
            currentBPP := NumGet(devMode, 104, "UInt")
            currentWidth := NumGet(devMode, 108, "UInt")
            currentHeight := NumGet(devMode, 112, "UInt")
            output .= "  Current Mode: " . currentWidth . "x" . currentHeight 
                   . " @ " . currentRefresh . "Hz (" . currentBPP . "-bit)`n"
        }
    } catch {
        output .= "  Current Mode: Unable to detect`n"
    }
    if (nativeWidth > 0 && nativeHeight > 0) {
        output .= "  Native Mode: " . nativeWidth . "x" . nativeHeight . " @ " . nativeRefresh . "Hz`n"
    }
    output .= "`n  Supported Modes:`n"

    ;;∙----∙Collect & sort modes.
    modeArray := []
    modeSet := Object()
    for mode in monitor.MonitorSourceModes {
        width := mode.HorizontalActivePixels
        height := mode.VerticalActivePixels
        refreshRate := Round(mode.VerticalRefreshRateNumerator / mode.VerticalRefreshRateDenominator, 1)
        modeKey := width . "x" . height . "@" . refreshRate
        if (!modeSet.HasKey(modeKey)) {
            modeSet[modeKey] := true
            modeArray.Push(mode)
        }
    }

    SortModes(modeArray, sortMode)
    modeCount := 0
    for index, mode in modeArray {
        modeCount++
        refreshRate := Round(mode.VerticalRefreshRateNumerator / mode.VerticalRefreshRateDenominator, 1)
        width := mode.HorizontalActivePixels
        height := mode.VerticalActivePixels
        aspectRatio := CalculateAspectRatio(width, height)
        nativeIndicator := ""
        if (width = nativeWidth && height = nativeHeight && refreshRate = nativeRefresh) {
            nativeIndicator := " ⭐"
        }
        output .= "    " . width . "x" . height
               . " (" . aspectRatio . ")"
               . " @ " . refreshRate . "Hz"
               . nativeIndicator
               . "`n"
        if (modeCount >= 100) {
            output .= "    ... and more`n"
            break
        }
    }
    if (modeCount = 0) {
        output .= "    No modes found`n"
    }
    monitorOutputs[wmiMonitorCount] := output
}
if (wmiMonitorCount = 0) {
    MsgBox, No active monitors found or no modes reported.
    ExitApp
}

;;∙======∙COPY TO CLIPBOARD∙=====================∙
clipboardOutput := ""
;;∙----∙Add GPU Information.
if (globalGPUInfo != "") {
    clipboardOutput .= "System GPU Information:`n"
    clipboardOutput .= globalGPUInfo
    clipboardOutput .= "`n" . "----------------------------------------" . "`n`n"
}
Loop, % wmiMonitorCount {
    clipboardOutput .= monitorOutputs[A_Index] . "`n"
}
Clipboard := clipboardOutput
Return

;;∙======∙SHOW GUI∙==============================∙
ShowGUI:
Gui, Destroy
Gui, +AlwaysOnTop +ToolWindow
Gui, Color, 000000

colors := ["00FFFF", "00FF00", "FFFF00", "FF00FF", "FF0000", "0000FF"]

;;∙----∙Add GPU section if available.
yPos := 10
if (globalGPUInfo != "") {
    Gui, Font, s10 cFFFFFF, Consolas
    Gui, Add, Text, x10 y%yPos% vGPUText, % "System GPU Information:"
    yPos += 20
    Gui, Font, s9 cCCCCCC, Consolas
    Gui, Add, Text, x20 y%yPos% vGPUInfoText, % globalGPUInfo
    ;;∙----∙Calculate GPU text height for spacing.
    StringReplace, gpuLines, globalGPUInfo, `n, `n, UseErrorLevel
    yPos += (ErrorLevel + 2) * 12    ;;∙----∙Approximate line height. (change the 12 to adjust space before separator line).
    Gui, Font, s10 cFFFFFF, Consolas
    Gui, Add, Text, x10 y%yPos% vSeparator, % "----------------------------------------"
    yPos += 20
}

Gui, Font, s10 cFFFFFF, Consolas
Loop, % wmiMonitorCount {
    colorIndex := Mod(A_Index - 1, colors.MaxIndex()) + 1
    currentColor := colors[colorIndex]
    Gui, Font, s10 c%currentColor%, Consolas
    if (A_Index = 1) {
        Gui, Add, Text, x10 y%yPos% vMonitor%A_Index%Text, % monitorOutputs[A_Index]
    } else {
        Gui, Add, Text, x+30 y%yPos% vMonitor%A_Index%Text, % monitorOutputs[A_Index]
    }
}
Gui, Show, AutoSize, Display Diagnostics
Return

;;∙======∙GUI DRAG∙==============================∙
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}
Return

;;∙======∙GUI CLOSE∙=============================∙
GuiEscape:
GuiClose:
    ExitApp
Return
;;∙----------------------------------------------∙




;;∙======∙SCRIPT EDIT/RELOAD/EXIT∙================∙
;;∙------∙Edit∙-----------------------------∙
Script·Edit:    ;;∙------∙Menu Call.
    Edit
Return
;;∙------∙Reload∙-------------------------∙
^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        ;;∙------∙aSoundBeep(1000, 200)    ;;∙------∙Async SoundBeep.
    Reload
Return
;;∙------∙Exit∙-----------------------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        ;;∙------∙aSoundBeep(1000, 200)    ;;∙------∙Async SoundBeep.
    ExitApp
Return

;;∙======∙SCRIPT UPDATE∙=========================∙
UpdateCheck:    ;;∙------Check if script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        return
        aSoundBeep(1500, 100)    ;;∙------∙Async SoundBeep.
Reload

;;∙======∙ASYNCHRONOUS SOUNDBEEP∙=============∙
aSoundBeep(Frequency, Duration) {
    AutoHotkeyPath := A_AhkPath    
    shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec("""" AutoHotkeyPath """ *")
    exec.StdIn.Write("#NoTrayIcon`nSoundBeep, " Frequency "," Duration "`nExitApp")
    exec.StdIn.Close()
}

;;∙======∙TRAY MENU∙============================∙
TrayMenu:
Menu, Tray, Tip, %ScriptID%
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add
;;∙------∙Menu-Extentions∙------------∙
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
;;∙------∙Menu-Options∙---------------∙
Menu, Tray, Add
Menu, Tray, Add, Script Edit, Script·Edit
Menu, Tray, Icon, Script Edit, imageres.dll, 247
Menu, Tray, Add
Menu, Tray, Add, Script Reload, Script·Reload
Menu, Tray, Icon, Script Reload, mmcndmgr.dll, 47
Menu, Tray, Add
Menu, Tray, Add, Script Exit, Script·Exit
Menu, Tray, Icon, Script Exit, shell32.dll, 272
Menu, Tray, Default, Script Exit
Menu, Tray, Add
Menu, Tray, Add
Return

;;∙======∙TRAY MENU EXTENTIONS∙=================∙
Documentation:
    Run, "C:\Program Files\AutoHotkey\AutoHotkey.chm"
Return
ShowKeyHistory:
    KeyHistory
Return
ShowWindowSpy:
    Run, "C:\Program Files\AutoHotkey\WindowSpy.ahk"
Return

;;∙======∙TRAY MENU POSITION∙===================∙
;;∙------∙Tray Menu Show∙-----------∙
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20
Return
;;∙------∙Position Funtion∙-----------∙
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
    return True
    }
Return
;;∙==============================================∙
;;∙======∙SCRIPT END∙=============================∙
;;∙----------------------------------------------∙


