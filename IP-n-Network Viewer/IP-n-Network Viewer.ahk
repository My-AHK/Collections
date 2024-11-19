
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
» Author:  Kingron
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?f=6&t=117296&p=586140#p522641
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "IP-n-Network∙Viewer"    ;;∙------∙Need to also change in "MENU CALLS"
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙🔥 HotKey 🔥∙===========================================∙
^t::    ;;∙------∙(Ctrl+T) 
    Soundbeep, 1100, 100
;;∙============================================================∙




/*∙=====∙ABOUT∙===============================================∙
1. External IP Information (via GetIPs()):
    • External IP Address: The public IP of the device as retrieved from an online service (https://ip.guide).
    • Network Details: This includes information such as CIDR (Classless Inter-Domain Routing), Hosts, Start and End IP addresses within the subnet.
    • Autonomous System Details: Information about the system managing the IP block, such as ASN (Autonomous System Number), name, organization, and country.
    • Location Details: Geolocation data including city, timezone, latitude, and longitude.
    • RIR (Regional Internet Registry): The organization that allocates and manages the IP addresses.

2. Internal Network Information (also via GetIPs()):
    • Internal IP Addresses: Lists both IPv4 and IPv6 addresses assigned to the device.

3. DNS Server Information:
    • Provides the list of DNS servers configured for the system.

4. MAC Address Information:
    • Lists the MAC addresses of all active network adapters on the system.
∙=============================================================∙
*/


;;∙============================================================∙
;;∙======∙Variables∙=============================================∙
guiX := "1100"    ;;∙--------∙Gui x-axis.
guiY := "200"    ;;∙--------∙Gui y-axis.
guiW := "445"    ;;∙--------∙Gui Width (adjusted for IP info).
guiH := "300"    ;;∙--------∙Gui Height (adjusted for IP info).
guiColor := "111111"    ;;∙--------∙Almost Black.

guiFont := "Arial"    ;;∙--------∙Font.
guiFontSize := "12"    ;;∙--------∙Font Size (adjusted for readability).
guiFontWeight := "700"    ;;∙--------∙Font Weight.
guiFontColor1 := "00DEDE"    ;;∙--------∙Aqua.
guiFontColor2 := "RED"    ;;∙--------∙Black.
TextOffSet := "1"    ;;∙--------∙Shadowed Text Offset.

trimLineColor := "DEDE00"    ;;∙--------∙Yellow.
trimLineWidth := "1"    ;;∙--------∙Using #.5 results in heavier bottom and right trimlines.
guiEdge := "3"    ;;∙--------∙Gui Trimline Edge Buffer.

;;∙============================================================∙
;;∙======∙Gui Build∙=============================================∙
Gui, +AlwaysOnTop -Caption
Gui, Margin, %guiEdge%, %guiEdge%
Gui, Color, %guiColor%

GuiAddTrim(trimLineColor, trimLineWidth, "xm ym w" guiW " h" guiH)
Gui, Font, s10 c%guiFontColor2% w200 q5, Calibri
guiWT := guiW-45
Gui, Add, Text, x%guiWT% y280  BackgroundTrans gExit, Exit

Gui, Font, s%guiFontSize% c%guiFontColor1% w%guiFontWeight%, %guiFont%
Gui, Add, Edit, x25 y30 w400 h120 r12 vMyBox BackgroundTrans ReadOnly, % FormatIPs(GetIPs())
GuiControl, Focus, MyBox  ;; Move focus to the edit box
SendInput, {End}  ;; Move the cursor to the end of the text to remove any selection
Gui, Show, x%guiX% y%guiY%, IP Viewer
Return

;;∙============================================================∙
;;∙======∙GuiAddTrim()∙========================================∙
GuiAddTrim(Color, Width, PosAndSize) {
   LFW := WinExist() ; save the last-found window, if any
   DefGui := A_DefaultGui ; save the current default GUI
   Gui, Add, Text, %PosAndSize% +hwndHTXT
   GuiControlGet, T, Pos, %HTXT%
   Gui, New, +Parent%HTXT% +LastFound -Caption ; create a unique child Gui for the text control
   Gui, Color, %Color%
   X1 := Width, X2 := TW - Width, Y1 := Width, Y2 := TH - Width
   WinSet, Region, 0-0 %TW%-0 %TW%-%TH% 0-%TH% 0-0   %X1%-%Y1% %X2%-%Y1% %X2%-%Y2% %X1%-%Y2% %X1%-%Y1%
   Gui, Show, x0 y0 w%TW% h%TH%
   Gui, %DefGui%:Default ; restore the default Gui
   If (LFW) ; restore the last-found window, if any
      WinExist(LFW)
}
Return

;;∙============================================================∙
;;∙------∙IP Fetching and Display (from ShowIPs)∙--------∙
GetIPs() {
    wbemLocator := ComObjCreate("WbemScripting.SWbemLocator")
    wbemServices := wbemLocator.ConnectServer(".", "root\cimv2")
    networkAdapters := wbemServices.ExecQuery("SELECT IPAddress FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled=True")

    ip := ""
    for adapter in networkAdapters
    {
        ipAddresses := adapter.IPAddress
        for ipAddress in ipAddresses
        {
            ;;∙------∙Append each IP address correctly, adding a tab and a newline after each one
            ip := ip . "`t" . ipAddress . "`n"
        }
    }

    whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    extIP := ""
    try {
        whr.Open("GET", "https://ip.guide/", false)
        whr.Send()

        ;;∙------∙Process the response to extract and format the data
        jsonResponse := whr.ResponseText
        jsonResponse := StrReplace(jsonResponse, "{", "")
        jsonResponse := StrReplace(jsonResponse, "}", "")
        jsonResponse := StrReplace(jsonResponse, "[", "")
        jsonResponse := StrReplace(jsonResponse, "]", "")
        jsonResponse := StrReplace(jsonResponse, """", "")
        jsonResponse := StrReplace(jsonResponse, ",", "`n")

jsonResponse := StrReplace(jsonResponse, "ip:", "External IP Address: ")
jsonResponse := StrReplace(jsonResponse, "network:", "Network:    ")
jsonResponse := StrReplace(jsonResponse, "`tcidr:", "CIDR:`t")
jsonResponse := StrReplace(jsonResponse, "hosts:", "Hosts: ")
jsonResponse := StrReplace(jsonResponse, "`tstart:", "Start: `t")
jsonResponse := StrReplace(jsonResponse, "`tend:", " End:   `t")

jsonResponse := StrReplace(jsonResponse, "autonomous_system:", "Autonomous System:")
jsonResponse := StrReplace(jsonResponse, "`tasn:", "ASN:`t")
jsonResponse := StrReplace(jsonResponse, "`tname:", "Name:`t")
jsonResponse := StrReplace(jsonResponse, "`torganization:", "Organization:`t")
jsonResponse := StrReplace(jsonResponse, "`tcountry:", "Country:    ")
jsonResponse := StrReplace(jsonResponse, "`trir:", "RIR:")

jsonResponse := StrReplace(jsonResponse, "location:", "Location:`n")
jsonResponse := StrReplace(jsonResponse, "`tcity:", "City:")
jsonResponse := StrReplace(jsonResponse, "`ttimezone:", "Timezone:")
jsonResponse := StrReplace(jsonResponse, "`tlatitude:", "Latitude: ")
jsonResponse := StrReplace(jsonResponse, "`tlongitude:", "Longitude: ")
        extIP := jsonResponse
    }

    ;;∙------∙Now format the final output
    ip := "Retrieved Addresses`n   " . extIP . "`n" . "Internal address:`n" . ip . "`nDNS server:`n" . GetDnsAddress() . "`nMAC addresses:`n" . GetMacAddress()

    whr := ""
    return ip
}

;;∙============================================================∙
;;∙======∙Text Formatting∙========================================∙
FormatIPs(text) {
    ;;∙------∙Trim any extra blank lines at the start and end.
    text := Trim(text, "`n")
    
    ;;∙------∙Format the external IP, network, and other fields.
    text := RegExReplace(text, "External IP Address:\s*(\S+)", "External IP Address: $1")
    text := RegExReplace(text, "Network:\s*", "Network: `n    ")
    text := RegExReplace(text, "cidr:\s*(\S+)", "CIDR: ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙`t$1")
    text := RegExReplace(text, "hosts:\s*", "Hosts: ")
    text := RegExReplace(text, "start:\s*(\S+)", "Start: ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙`t$1")
    text := RegExReplace(text, "end:\s*(\S+)", " End: ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙`t$1")

    ;;∙------∙Format Autonomous System fields.
    text := RegExReplace(text, "autonomous_system:\s*", "Autonomous System: ")
    text := RegExReplace(text, "asn:\s*(\S+)", "ASN: ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙`t$1")
    text := RegExReplace(text, "name:\s*(\S+)", "Name: ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙`t$1")

    ;;∙------∙Format Organization, Country, and RIR.
    text := RegExReplace(text, "organization:\s*(.*)", "Organization: ∙ ∙ ∙`t$1")
    text := RegExReplace(text, "country:\s*(\S+)", "Country: ∙ ∙ ∙ ∙ ∙ ∙ ∙`t$1")
    text := RegExReplace(text, "rir:\s*(\S+)", "RIR: ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙`t$1")

    ;;∙------∙Format location fields. (City, Country, Timezone)
    text := RegExReplace(text, "location:\s*", "Location: ")
    text := RegExReplace(text, "city:\s*(.*)", "City: ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙`t$1")
    text := RegExReplace(text, "timezone:\s*(\S+)", "Timezone: ∙ ∙ ∙ ∙ ∙ ∙`t$1")

    ;;∙------∙Format latitude and longitude.
    text := RegExReplace(text, "latitude:\s*(\S+)", "Latitude: ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙`t$1")
    text := RegExReplace(text, "longitude:\s*(\S+)", "Longitude: ∙ ∙ ∙ ∙ ∙ ∙`t$1")

    ;;∙------∙Format internal IP addresses (split into distinct lines for IPv4 and IPv6)
    text := RegExReplace(text, "Internal address:\s*(`t[0-9.]+)(?:`n`t)?(fe80::[a-fA-F0-9:]+)", "Internal address:`n    IPv4: $1`n    IPv6:`t $2")


    ;;∙------∙Format DNS servers.
    text := RegExReplace(text, "DNS server:\s*", "`nDNS server:`n`t")

    ;;∙------∙Format MAC addresses (group into 6-pair sets)
    text := RegExReplace(text, "([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}", "$0")    ;;∙------∙Ensure MAC addresses remain on one line.

    ;;∙------∙Remove excessive line breaks.
    text := RegExReplace(text, "(\R\R+)", "`n`n")

    return text
}

;;∙============================================================∙
;;∙======∙GetDnsAddress()∙=======================================∙
GetDnsAddress() {
    if (DllCall("iphlpapi.dll\GetNetworkParams", "ptr", 0, "uint*", size) = 111) && !(VarSetCapacity(buf, size, 0))
        throw Exception("Memory allocation failed for FIXED_INFO struct", -1)
    if (DllCall("iphlpapi.dll\GetNetworkParams", "ptr", &buf, "uint*", size) != 0)
        throw Exception("GetNetworkParams failed with error: " A_LastError, -1)
    addr := &buf, DNS_SERVERS := []
    DNS_SERVERS[1] := StrGet(addr + 264 + (A_PtrSize * 2), "cp0")
    ptr := NumGet(addr+0, 264 + A_PtrSize, "uptr")
    while (ptr) {
        DNS_SERVERS[A_Index + 1] := StrGet(ptr+0 + A_PtrSize, "cp0")
        ptr := NumGet(ptr+0, "uptr")
    }
    ret := ""
    for i, v in DNS_SERVERS {
        ret := ret . "`t" . v . "`n"
    }
    return ret
}

;;∙============================================================∙
;;∙======∙GetMacAddress()∙======================================∙
GetMacAddress(delimiter := ":", case := False) {
    if (DllCall("iphlpapi.dll\GetAdaptersInfo", "ptr", 0, "uint*", size) = 111) && !(VarSetCapacity(buf, size, 0))
        throw Exception("Memory allocation failed for IP_ADAPTER_INFO struct", -1)
    if (DllCall("iphlpapi.dll\GetAdaptersInfo", "ptr", &buf, "uint*", size) != 0)
        throw Exception("GetAdaptersInfo failed with error: " A_LastError, -1)
    addr := &buf, MAC_ADDRESS := []
    while (addr) {
        loop % NumGet(addr+0, 396 + A_PtrSize, "uint")
            mac .= Format("{:02" (case ? "X" : "x") "}", NumGet(addr+0, 400 + A_PtrSize + A_Index - 1, "uchar")) "" delimiter ""
        MAC_ADDRESS[A_Index] := SubStr(mac, 1, -1), mac := ""
        addr := NumGet(addr+0, "uptr")
    }
    ret := ""
    for i, v in MAC_ADDRESS {
        ret := ret . "`t" . v . "`n"
    }
    return ret
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
        Soundbeep, 1200, 75
        Soundbeep, 1400, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙--∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        Exit:
        Soundbeep, 1400, 75
        Soundbeep, 1200, 100
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
Menu, Tray, Icon, Imageres.dll, 65
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Tray Menu∙============================================∙
TrayMenu:
Menu, Tray, Tip, %ScriptID%    ;;∙------∙Suspends hotkeys then pauses script.
Menu, Tray, NoStandard
Menu, Tray, Click, 2
Menu, Tray, Color, ABCDEF
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, %ScriptID%
Menu, Tray, Icon, %ScriptID%, Imageres.dll, 65
Menu, Tray, Default, %ScriptID%    ;;∙------∙Makes Bold.
Menu, Tray, Add
;;∙------∙  ∙--------------------------------∙

;;∙------∙Script∙Options∙---------------∙
Menu, Tray, Add
Menu, Tray, Add, Script·Edit
Menu, Tray, Icon, Script·Edit, shell32.dll, 270
Menu, Tray, Add
Menu, Tray, Add, Script·Reload
Menu, Tray, Icon, Script·Reload, mmcndmgr.dll, 47
Menu, Tray, Add
Menu, Tray, Add, Script·Exit
Menu, Tray, Icon, Script·Exit, shell32.dll, 272
Menu, Tray, Add
Menu, Tray, Add
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙MENU CALLS∙==========================================∙
IP-n-Network∙Viewer:    ;;∙------∙Change as needed to match the 'ScriptID' variable in AutoExe section.
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

