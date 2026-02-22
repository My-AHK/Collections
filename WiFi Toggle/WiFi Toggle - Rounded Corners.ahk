

/*∙------∙HOTKEYS∙--------------------------------------------∙
∙🔥∙Ctrl + T: Check WiFi connectivity.
∙🔥∙Ctrl + Shift + T: Toggle WiFi connection (disconnect/reconnect).
∙------------------------------------------------------------------∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force
SetBatchLines -1
SetWinDelay 0

SetTimer, UpdateCheck, 750
ScriptID := "WiFi_Toggle"
Menu, Tray, Icon, netshell.dll, 127
GoSub, TrayMenu

;;∙===========================================∙
if not A_IsAdmin
{
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}

;;∙------∙Global variable to remember last connected network.
global LastConnectedNetwork := ""

;;∙===========================================∙
^t::    ;;∙------∙🔥∙(Ctrl + T)∙🔥∙CHECK WiFi STATUS
    if IsInternetConnected()
        ShowInternetStatus("Internet IS connected", "Lime", 1500, 250)
    else
        ShowInternetStatus("Internet NOT connected", "Red", 1200, 250)
Return

;;∙------------------------∙
^+t::    ;;∙------∙🔥∙(Ctrl + Shift + T)∙🔥∙TOGGLE WiFi CONNECTION
    ToggleWiFi()
Return

;;∙===========================================∙
ToggleWiFi() {
    ;;∙------∙Check if running as administrator.
    if not A_IsAdmin {
        ShowInternetStatus("Run as ADMIN to toggle WiFi", "Red", 800, 250)
        return
    }

    ;;∙------∙Get current WiFi connection status.
    connectedNetwork := GetConnectedNetwork()

    if (connectedNetwork != "") {
        ;;∙------∙WiFi is connected - save network name and disconnect.
        LastConnectedNetwork := connectedNetwork
        DisconnectWiFi()
        ShowInternetStatus("WiFi Disconnected", "Red", 800, 250)
    } else {
        ;;∙------∙WiFi is not connected - try to reconnect.
        ShowInternetStatus("WiFi Connecting...", "Yellow", 1000, 250)

        ;;∙------∙Try to reconnect using multiple methods.
        success := ReconnectWiFi()

        ;;∙------∙Wait for connection to establish.
        Sleep, 250

        ;;∙------∙Check if successfully connected.
        newNetwork := GetConnectedNetwork()
        if (newNetwork != "") {
            if (IsInternetConnected()) {
                ShowInternetStatus("WiFi Connected ✓", "Lime", 1200, 250)
            } else {
                ShowInternetStatus("Connected - No Internet", "Orange", 900, 250)
            }
        } else {
            ;;∙------∙Connection failed - try one more time with longer wait.
            Sleep, 1500
            finalNetwork := GetConnectedNetwork()
            if (finalNetwork != "") {
                ShowInternetStatus("WiFi Connected ✓", "Lime", 1200, 250)
            } else {
                ShowInternetStatus("Connection Failed", "Red", 900, 250)
            }
        }
    }
}

;;∙===========================================∙
GetConnectedNetwork() {
    ;;∙------∙Get currently connected WiFi network name.
    output := ""
    RunWait, %ComSpec% /c netsh wlan show interfaces > %A_Temp%\wifiinfo.txt, , Hide
    FileRead, output, %A_Temp%\wifiinfo.txt
    FileDelete, %A_Temp%\wifiinfo.txt

    ;;∙------∙Look for "State : connected" and extract SSID.
    if (InStr(output, "State") && InStr(output, "connected")) {
        Loop, Parse, output, `n, `r
        {
            if (InStr(A_LoopField, "SSID") && !InStr(A_LoopField, "BSSID")) {
                ;;∙------∙Extract SSID name after colon.
                ssid := RegExReplace(A_LoopField, "^.*SSID\s*:\s*", "")
                ssid := Trim(ssid)
                return ssid
            }
        }
    }

    return ""    ;;∙------∙Not connected to any network.
}

;;∙===========================================∙
DisconnectWiFi() {
    ;;∙------∙Disconnect from current WiFi network.
    RunWait, %ComSpec% /c netsh wlan disconnect, , Hide
}

;;∙===========================================∙
ReconnectWiFi() {
    ;;∙------∙Method 1: Try to reconnect to the last known network.
    if (LastConnectedNetwork != "") {
        RunWait, %ComSpec% /c netsh wlan connect ssid="%LastConnectedNetwork%" name="%LastConnectedNetwork%", , Hide
        Sleep, 1000
        if (GetConnectedNetwork() != "") {
            return true
        }
    }

    ;;∙------∙Method 2: Get available networks and try to connect to known ones.
    output := ""
    RunWait, %ComSpec% /c netsh wlan show networks > %A_Temp%\networks.txt, , Hide
    FileRead, output, %A_Temp%\networks.txt
    FileDelete, %A_Temp%\networks.txt

    ;;∙------∙Get list of saved profiles.
    profiles := ""
    RunWait, %ComSpec% /c netsh wlan show profiles > %A_Temp%\profiles.txt, , Hide
    FileRead, profiles, %A_Temp%\profiles.txt
    FileDelete, %A_Temp%\profiles.txt

    ;;∙------∙Extract profile names and try to connect to first available.
    Loop, Parse, profiles, `n, `r
    {
        if (InStr(A_LoopField, "All User Profile")) {
            ;;∙------∙Extract profile name.
            profile := RegExReplace(A_LoopField, "^.*:\s*", "")
            profile := Trim(profile)
            
            if (profile != "") {
                ;;∙------∙Check if this network is currently available.
                if (InStr(output, profile)) {
                    ;;∙------∙Try to connect to this profile.
                    RunWait, %ComSpec% /c netsh wlan connect ssid="%profile%" name="%profile%", , Hide
                    Sleep, 1000
                    if (GetConnectedNetwork() != "") {
                        return true
                    }
                }
            }
        }
    }

    ;;∙------∙Method 3: Try interface-based reconnection.
    wifiAdapter := GetWiFiAdapterName()
    if (wifiAdapter != "") {
        ;;∙------∙Disable and re-enable adapter to force reconnection.
        RunWait, %ComSpec% /c netsh interface set interface "%wifiAdapter%" disable, , Hide
        Sleep, 1000
        RunWait, %ComSpec% /c netsh interface set interface "%wifiAdapter%" enable, , Hide
        Sleep, 1000
        if (GetConnectedNetwork() != "") {
            return true
        }
    }

    return false
}

;;∙===========================================∙
GetWiFiAdapterName() {
    ;;∙------∙Try to find WiFi adapter name automatically.
    output := ""
    RunWait, %ComSpec% /c netsh interface show interface > %A_Temp%\interfaces.txt, , Hide
    FileRead, output, %A_Temp%\interfaces.txt
    FileDelete, %A_Temp%\interfaces.txt

    ;;∙------∙Look for Wi-Fi or Wireless adapter.
    Loop, Parse, output, `n, `r
    {
        if (InStr(A_LoopField, "Wi-Fi") || InStr(A_LoopField, "Wireless")) {
            ;;∙------∙Extract adapter name (last column).
            StringSplit, parts, A_LoopField, %A_Space%
            Loop, %parts0%
            {
                idx := parts0 - A_Index + 1
                if (parts%idx% != "" && idx == parts0) {
                    return parts%idx%
                }
            }
        }
    }

    return "Wi-Fi"  ;;∙------∙Default fallback.
}

;;∙===========================================∙
ShowInternetStatus(message, textColor, beepFreq := 0, beepDuration := 0) {
    if (beepFreq > 0 && beepDuration > 0)
        SoundBeep, %beepFreq%, %beepDuration%

    SetTimer, CloseInternetGUI, Off
    Gui, InternetCheck:Destroy

    Gui, InternetCheck:+AlwaysOnTop -Caption +hwndHGUI +LastFound +E0x02000000 +E0x00080000
    Gui, InternetCheck:Font, s12 q5, Segoe UI
    Gui, InternetCheck:Add, Text, x20 y20 w200 h30 c%textColor% Center BackgroundTrans, %message%
    Gui, InternetCheck:Color, Black
    Gui, InternetCheck:Show, w240 h70 Center, InternetCheck

    ;;∙------∙Apply rounded corners.
    WinGetPos, X, Y, W, H, InternetCheck
    R := Min(W, H) // 5
    WinSet, Region, 0-0 W%W% H%H% R%R%-%R%, InternetCheck

    SetTimer, CloseInternetGUI, -1500
}

;;∙===========================================∙
CloseInternetGUI:
    Gui, InternetCheck:Destroy
Return

;;∙===========================================∙
IsInternetConnected() {
    Created := 20250725
    try {
        ;;∙------∙Create WinHTTP request object.
        http := ComObjCreate("WinHttp.WinHttpRequest.5.1")

        ;;∙------∙Set timeouts: resolve, connect, send, receive (all in milliseconds).
        http.SetTimeouts(2000, 2000, 2000, 2000)

        ;;∙------∙Try Microsoft NCSI endpoint first.
        http.Open("GET", "http://www.msftncsi.com/ncsi.txt", false)
        http.Send()

        ;;∙------∙Check if we got the expected response.
        if (http.Status = 200 && http.ResponseText = "Microsoft NCSI")
            return true

        ;;∙------∙If NCSI fails, try a fallback endpoint.
        http.Open("GET", "http://connectivitycheck.gstatic.com/generate_204", false)
        http.Send()

        ;;∙------∙Google's endpoint returns 204 No Content when successful.
        if (http.Status = 204)
            return true

        return false

    } catch e {
        ;;∙------∙If any HTTP request fails, try one more reliable endpoint.
        try {
            http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
            http.SetTimeouts(2000, 2000, 2000, 2000)
            http.Open("GET", "http://httpbin.org/status/200", false)
            http.Send()

            if (http.Status = 200)
                return true
        } catch {
            ;;∙------∙All attempts failed.
        }
        return false
    }
}
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙====================================∙
 ;;∙------∙EDIT∙---------------------------∙
Script·Edit:    ;;∙------∙Menu Call.
    Edit
Return

;;∙------∙RELOAD∙-----------------------∙
^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        Soundbeep, 1200, 250
    Reload
Return

 ;;∙------∙EXIT∙----------------------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        Soundbeep, 1000, 300
    ExitApp
Return

;;∙====================================∙
 ;;∙------∙SCRIPT UPDATE∙-------------∙
UpdateCheck:    ;;∙------Check if script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload

;;∙====================================∙
 ;;∙------∙TRAY MENU∙------------------∙
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

;;∙------∙MENU-EXTENTIONS∙---------∙
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

;;∙------∙MENU-OPTIONS∙-------------∙
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

;;∙------∙EXTENTIONS∙------------------∙
Documentation:
    Run, "C:\Program Files\AutoHotkey\AutoHotkey.chm"
Return
ShowKeyHistory:
    KeyHistory
Return
ShowWindowSpy:
    Run, "C:\Program Files\AutoHotkey\WindowSpy.ahk"
Return

;;∙------∙MENU-HEADER∙---------------∙
WiFi_Toggle:    ;;∙------∙Suspends hotkeys then pauses script.
    Suspend
    Soundbeep, 700, 100
    Pause
Return

;;∙====================================∙
 ;;∙------∙MENU POSITION∙-----------∙
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20
Return

 ;;∙------∙POSITION FUNTION∙-------∙
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
;;∙------------------------------------------------------------------------------------------∙
;;∙========================∙SCRIPT END∙=========================∙
;;∙------------------------------------------------------------------------------------------∙

