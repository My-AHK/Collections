
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
» Original Author:  garry (v1 conversion of flyingDman's v2)
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?f=22&t=126206#p559711
» Class: JSON.ahk found at: https://github.com/cocobelgica/AutoHotkey-JSON
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "DOPPLER-ONE"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙




;;∙============================================================∙
/*∙======∙Knowledge∙===========================================∙
    ∙-------------------------------------------------------------------------∙
    ** ( Sign up for a free API key at  https://openweathermap.org/api  ) ** (generic key provided*)
    ∙-------------------------------------------------------------------------∙
In order to use OpenWeather API services... 
  1. Sign up and get an API key (APPID) on your account page.
  2. Verify your email address via a confirmation letter that will be sent to you. 
  3. After verification, check your Inbox again to find our Welcome email that contains your API key.
      * You will receive an API key that allows for 60 free calls per minute. (more than enough for a simple ZIP code request)
      ** Your API key can also be found on your account page.

•  Bonus: (bb1abf9908505fed5101e41712df0327) 
    ▹ Useable generic key to start until own key is acquired. (Limit: 60 calls per minute)
    ∙-------------------------------------------------------------------------∙
1. Creates 2 keys in registry... Latitude and Longitude.
    ▹ Located at:  Computer\HKEY_CURRENT_USER\SOFTWARE\AutoHotkeyMap
2. Can be cleared with hotkey [Ctrl] + [-].    *Ctrl key + (either subtraction key or Numpad subtraction key)
    ▹ * Handy if you typo the Zip Code or simply want to change it.
3. * If using the registry is intimidating, try switching to flyingDman's Stream:$DATA method...
    ▹ https://www.autohotkey.com/boards/viewtopic.php?f=76&t=130129#p573151
    ∙-------------------------------------------------------------------------∙
*/
;;∙============================================================∙


;;∙------∙Declarations∙------------------------------∙
;;∙------∙OpenWeatherMap API key.
API_Key := "bb1abf9908505fed5101e41712df0327"    ;;∙------∙Useable generic key (see above to get your own).

;;∙------∙Define the Registry Key and Value names.
regKey := "HKEY_CURRENT_USER\Software\AutoHotkeyMap"
regValueNameLatitude := "Latitude"
regValueNameLongitude := "Longitude"

;;∙------∙🔥 HotKey 🔥∙------------------------------∙
^t::    ;;∙------∙(CTRL + T) ∙------∙>If changed, also change --∙> Gosub, ^t.

;;∙------∙Request Coordinates∙--------------------∙
RegRead, latitude, %regKey%, %regValueNameLatitude%
RegRead, longitude, %regKey%, %regValueNameLongitude%

if (ErrorLevel) {
    Gui, New
    Gui, +AlwaysOnTop -Caption 
        +E0x02000000 +E0x00080000
    Gui, Color, 171717
    Gui, Font, s10 c4997FF, ARIAL
    Gui, Add, Text, x35, Please enter a Zip Code.
    Gui, Font, c0063E6  ; BLUE
    Gui, Add, Edit, x35 y+5 w150 vInput Center, • Enter Zip Code •
    Gui, Font, s10 c4997FF, ARIAL
    Gui, Add, Text, x70 y+10, Then Press ZIP.
    Gui, Add, Button, x60 y+5 w40 h20 gButtonBYE Center, BYE
    Gui, Add, Button, x120 yp w40 h20 gButtonZIP Default Center, ZIP
    Gui, Font, s8 Italic c85BAFF, ARIAL
    Gui, Add, Text, x35 y115 CENTER, Press BYE to cancel and exit.
    Gui, Add, Text, x110 y+3, •
    Gui, Font, s8 cF7F75E Norm, CALIBRI
    Gui, Add, Text, x40 y+3 CENTER 0x00800000, `nTo change ZIP Code later...`n   Please press keys CTRL + (-)   `nor CTRL + (NumpadSub)`nto clear Registry values.`n
    Gui, Show, x1400 y250 w215 h250, InputBox
    GuiControl, Focus, Input
    return
}
;;∙------------------------------------------------------------------------------------------∙
;;∙------∙Doppler radar map∙----------------------∙ (by garry/flyingDman)
flnm := A_Desktop . "\doppler.html"
var := "
(
<!doctype html><html lang='en-US'>
<head><meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1'></head>
<body style='background-color:black;'>

;;∙------∙ * per RussF:  height:950px changed to height:100vh (scales map to available window size).
<div style='width:100%; height:100vh;'> 

<wx-widget type='map' latitude='" latitude "' longitude='" longitude "' menuitems='0001' mapid='0002' memberid='1384' zoomlevel='8' fullscreen='true' animate='true'></wx-widget>
<script async defer type='text/javascript' src='https://widgets.media.weather.com/wxwidget.loader.js?cid=878507589'></script>
</div></body></html>
)"

FileDelete, %flnm%
FileAppend, %var%, %flnm%, utf-8
Run, %flnm%
Return
;;∙------------------------------------------------------------------------------------------∙
;;∙------∙Clear Registry Values∙---∙🔥 HotKeys 🔥∙
^-::    ;;∙------∙(CTRL + [-])
^NumpadSub::    ;;∙------∙(CTRL + [NumpadSub])

    RegDelete, %regKey%, %regValueNameLatitude%
    RegDelete, %regKey%, %regValueNameLongitude%
    Gui, New
    Gui, +AlwaysOnTop -Caption +hwndHGUI
        +E0x02000000 +E0x00080000
    Gui, Color, 171717
    Gui, Font, s12 cF3F30B, ARIAL
    Gui, Add, Text, x15 CENTER 0x00800000, `nLatitude and Longitude`n%A_Space%have now been cleared `n
    Gui, Show, x1400 y250, Latitude & Longitude Cleared
Sleep, 2000
Gui Destroy
Return
;;∙------------------------------------------------------------------------------------------∙
;;∙------∙Class: JSON∙--------------------------------∙
class JSON {
    class Load extends JSON.Functor {
        Call(self, ByRef text, reviver:="") {
            this.rev := IsObject(reviver) ? reviver : false
            this.keys := this.rev ? {} : false
;;∙------------------∙
            static quot := Chr(34), bashq := "\" . quot
                 , json_value := quot . "{[01234567890-tfn"
                 , json_value_or_array_closing := quot . "{[]01234567890-tfn"
                 , object_key_or_object_closing := quot . "}"
;;∙------------------∙
            key := ""
            is_key := false
            root := {}
            stack := [root]
            next := json_value
            pos := 0
;;∙------------------∙
            while ((ch := SubStr(text, ++pos, 1)) != "") {
                if InStr(" `t`r`n", ch)
                    continue
                if !InStr(next, ch, 1)
                    this.ParseError(next, text, pos)
                holder := stack[1]
                is_array := holder.IsArray
                if InStr(",:", ch) {
                    next := (is_key := !is_array && ch == ",") ? quot : json_value
                } else if InStr("}]", ch) {
                    ObjRemoveAt(stack, 1)
                    next := stack[1]==root ? "" : stack[1].IsArray ? ",]" : ",}"
                } else {
                    if InStr("{[", ch) {
                        static json_array := Func("Array").IsBuiltIn || ![].IsArray ? {IsArray: true} : 0
                        (ch == "{") ? (is_key := true, value := {}, next := object_key_or_object_closing) : (value := json_array ? new json_array : [], next := json_value_or_array_closing)
                        ObjInsertAt(stack, 1, value)
                        if (this.keys)
                            this.keys[value] := []
                    } else {
                        if (ch == quot) {
                            i := pos
                            while (i := InStr(text, quot,, i+1)) {
                                value := StrReplace(SubStr(text, pos+1, i-pos-1), "\\", "\u005c")
                                static tail := A_AhkVersion<"2" ? 0 : -1
                                if (SubStr(value, tail) != "\")
                                    break
                            }
                            if (!i)
                                this.ParseError("'", text, pos)
                            value := StrReplace(value,  "\/",  "/")
                            value := StrReplace(value, bashq, quot)
                            value := StrReplace(value,  "\b", "`b")
                            value := StrReplace(value,  "\f", "`f")
                            value := StrReplace(value,  "\n", "`n")
                            value := StrReplace(value,  "\r", "`r")
                            value := StrReplace(value,  "\t", "`t")
                            pos := i
                            i := 0
                            while (i := InStr(value, "\",, i+1)) {
                                if !(SubStr(value, i+1, 1) == "u")
                                    this.ParseError("\", text, pos - StrLen(SubStr(value, i+1)))
                                uffff := Abs("0x" . SubStr(value, i+2, 4))
                                if (A_IsUnicode || uffff < 0x100)
                                    value := SubStr(value, 1, i-1) . Chr(uffff) . SubStr(value, i+6)
                            }
                            if (is_key) {
                                key := value, next := ":"
                                continue
                            }
                        } else {
                            value := SubStr(text, pos, i := RegExMatch(text, "[\]\},\s]|$",, pos)-pos)
                            static number := "number", integer :="integer"
                            if value is %number%
                                value := value is %integer% ? value+0 : value
                            else if (value == "true" || value == "false")
                                value := %value% + 0
                            else if (value == "null")
                                value := ""
                            else
                                this.ParseError(next, text, pos, i)
                            pos += i-1
                        }
                        next := holder==root ? "" : is_array ? ",]" : ",}"
                    }
                    is_array ? key := ObjPush(holder, value) : holder[key] := value
                    if (this.keys && this.keys.HasKey(holder))
                        this.keys[holder].Push(key)
                }
            }
            return this.rev ? this.Walk(root, "") : root[""]
        }
;;∙------------------∙
        ParseError(expect, ByRef text, pos, len:=1) {
            static quot := Chr(34), qurly := quot . "}"
            line := StrSplit(SubStr(text, 1, pos), "`n", "`r").Length()
            col := pos - InStr(text, "`n",, -(StrLen(text)-pos+1))
            msg := Format("{1}`n`nLine:`t{2}`nCol:`t{3}`nChar:`t{4}", (expect == "") ? "Extra data" : (expect == "'") ? "Unterminated string starting at" : (expect == "\") ? "Invalid \escape" : (expect == ":") ? "Expecting ':' delimiter" : (expect == quot) ? "Expecting object key enclosed in double quotes" : (expect == qurly) ? "Expecting object key enclosed in double quotes or object closing '}'" : (expect == ",}") ? "Expecting ',' delimiter or object closing '}'" : (expect == ",]") ? "Expecting ',' delimiter or array closing ']'": InStr(expect, "]") ? "Expecting JSON value or array closing ']'": "Expecting JSON value(string, number, true, false, null, object or array)", line, col, pos)
            static offset := A_AhkVersion<"2" ? -3 : -5
            static substr := A_AhkVersion<"2" ? SubStr : SubStr
            static comma := A_AhkVersion<"2" ? SubStr(text, pos, 1) : SubStr(text, pos, 1)
            static qcomma := A_AhkVersion<"2" ? SubStr(quot, 1, 1) : SubStr(quot, 1, 1)
            static bashq := A_AhkVersion<"2" ? "\" . SubStr(quot, 1, 1) : "\" . SubStr(quot, 1, 1)
            static tbq := A_AhkVersion<"2" ? "`tb" : "`tb"
            if (len)
                msg .= "`n`nText:`t" . SubStr(text, pos, len)
            static newline := A_AhkVersion<"2" ? "`n" : "`n"
            Exception(msg, offset, SubStr(text, pos, len))
        }
;;∙------------------∙
        Walk(holder, key) {
            value := holder[key]
            if IsObject(value) {
                for i, k in this.keys[value] {
                    holder[key, k] := this.Walk(value, k)
                }
            }
            return this.rev.Call(holder, key, value)
        }
    }
    class Functor {
        __Call(name, args*) {
            if (IsObject(this) && IsFunc(this.Call))
                return this.Call(name, args*)
            static call := "Call"
            return this[call](name, args*)
        }
        __New(call) {
            this.Call := call
        }
    }
}
;;∙------------------------------------------------------------------------------------------∙
;;∙------∙Button Functions∙------------------------∙
ButtonBYE:
GuiClose:
    Soundbeep, 1400, 100
    Soundbeep, 1200, 150
    ExitApp
Return
;;∙------------------∙
ButtonZIP:
    Gui, Submit
    if (Input = "** Enter Zip Code **" or Input = "")
    {
Gui, New
    Gui, +AlwaysOnTop -Caption +hwndHGUI
        +E0x02000000 +E0x00080000
    Gui, Color, 171717
    Gui, Font, s12 cF3F30B, ARIAL
    Gui, Add, Text, y10 w250 Center 0x00800000, `n%A_Space%Please enter a valid Zip Code `n
    Gui, Show, x1400 y250, Latitude & Longitude Cleared
Sleep, 5000
Gui Destroy
        return
    }
    url := "http://api.openweathermap.org/geo/1.0/zip?zip=" . Input . ",us&appid=" . API_Key
    HttpObj := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    HttpObj.Open("GET", url, false)
    HttpObj.Send()
    Response := HttpObj.ResponseText
        clipboard := Response
            ;;∙------∙Response Example...
            ;;∙------∙{"zip":"90210","name":"Beverly Hills","lat":34.0901,"lon":-118.4065,"country":"US"}
        FormattedResponse := StrReplace(Response, ",", "`n")    ;;∙------∙Replace commas with new lines.
        FormattedResponse := StrReplace(FormattedResponse, "{", "")    ;;∙------∙Remove opening brackets.
        FormattedResponse := StrReplace(FormattedResponse, "}", "")    ;;∙------∙Remove closing brackets.
        FormattedResponse := StrReplace(FormattedResponse, """", "")    ;;∙------∙Remove double quotes.
        FormattedResponse := StrReplace(FormattedResponse, ":", " :   ")    ;;∙------∙Add spacing around colons.
;;∙------------------∙
Gui, New
Gui, +AlwaysOnTop -Caption +hwndHGUI
    +E0x02000000 +E0x00080000
Gui, Color, 171717
Gui, Margin, 10, 10
Gui, Font, s12 c4997FF, ARIAL
Gui, Add, Text, w250 Center, * API Response *
Gui Add, Edit, vEditResponse w250 ReadOnly -VScroll, `n%FormattedResponse%`n    ;;∙------∙ -VScroll to wrap Response text. (thanks to: mikeyww)
Gui, Add, Button, x140 y+3 w10 h5 Hidden Default, OK    ;;∙------∙Invisible button to remove highlighting focus from Edit control.
Gui, Show, x1400 y250, API Response
GuiControl, Focus, OK    ;;∙------∙Set focus to invisible button.
Sleep, 3000
Gui Destroy
;;∙------------------∙
clipboard := FormattedResponse
    try {
        parsed := JSON.Load(Response)
        if (!parsed || !parsed.lat || !parsed.lon) {
            throw Exception("Invalid Response format")
        }
        latitude := parsed.lat
        longitude := parsed.lon
;;∙------------------∙
 Gui, New
    Gui, +AlwaysOnTop -Caption +hwndHGUI
        +E0x02000000 +E0x00080000
    Gui, Color, 171717
    Gui, Font, s12 c4997FF, ARIAL
    Gui, Add, Text, x15 , Latitude Is......  
    Gui, Font, s12 c0BFF0B, ARIAL
    Gui, Add, Text, x+5 yp 0x00800000, %A_Space%%latitude%%A_Space%
    Gui, Font, s12 c4997FF, ARIAL
    Gui, Add, Text, x15 y+5, Longitude Is...  
    Gui, Font, s12 c0BFF0B, ARIAL
    Gui, Add, Text, x+5 yp 0x00800000, %A_Space%%longitude%%A_Space%
    Gui, Show, x1400 y250, Latitude & Longitude
    Sleep, 3000
        RegWrite, REG_SZ, %regKey%, %regValueNameLatitude%, %latitude%
        RegWrite, REG_SZ, %regKey%, %regValueNameLongitude%, %longitude%
        Gui, Destroy
        Gosub, ^t
    } catch e {
    Gui, New
    Gui, +AlwaysOnTop -Caption +hwndHGUI
        +E0x02000000 +E0x00080000
    Gui, Color, 171717
    Gui, Font, s12 cF3F30B, ARIAL
    Gui, Add, Text, x15 Center 0x00800000, `n%A_Space%Failed to retrieve coordinates. `nPlease try again. `n
    Gui, Show, x1400 y250, Coordinates Failure
Sleep, 3000
Gui Destroy
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
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Reload:    ;;∙------∙Menu Call.
        SoundBeep, 1100, 75
        Soundbeep, 1200, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
        Soundbeep, 1100, 75
        Soundbeep, 1000, 100
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
;    Soundbeep, 1700, 100
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
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.
SetBatchLines -1
SetTimer, UpdateCheck, 500
SetTitleMatchMode 2
SetWinDelay 0
Menu, Tray, Icon, imageres.dll, 232
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
Menu, Tray, Add
;;------------------------------------------∙

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
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙MENU CALLS∙==========================================∙
DOPPLER-ONE:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

