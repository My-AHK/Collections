
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙(Ctrl + [Esc])
» Script Updater: Auto-reload script upon saved changes.
    ▹ If you make any changes to the script file and save it, 
          the script will automatically reload itself and continue
          running without manual intervention.
∙--------∙Origins∙-------------------------∙
» Author:  RussF
» Source:  https://www.autohotkey.com/boards/viewtopic.php?t=129174#p569243
» Original Author:  teadrinker
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?f=6&t=63835&hilit=google+translate#p273621
» 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TEMPLATE"    ;;∙------∙Also change in 'MENU CALLS' at script end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙


/*∙=====∙LANGUAGE CODES∙=====================================∙
COUNTRY  ∙===∙>  CODE
Albania  ∙===∙>  sq
Arabic  ∙===∙>  ar
AutoDetect*  ∙===∙>  auto
Azerbaijan  ∙===∙>  az
Basque  ∙===∙>  eu
Belarus  ∙===∙>  be
Bulgaria  ∙===∙>  bg
Catalan  ∙===∙>  ca
Chinese  ∙===∙>  zh-CN
Croatia  ∙===∙>  hr
Czech  ∙===∙>  cs
Dansk  ∙===∙>  da
Nederlands  ∙===∙>  nl
English  ∙===∙>  en
Estonia  ∙===∙>  et
Suomen  ∙===∙>  fi
Français  ∙===∙>  fr
Fryslân  ∙===∙>  fy
Georgian  ∙===∙>  ka
Deutsch  ∙===∙>  de
Greek  ∙===∙>  el
Hebrew  ∙===∙>  iw
Hindi  ∙===∙>  hi
Hungary  ∙===∙>  hu
Iceland  ∙===∙>  is
Indonesia  ∙===∙>  id
Italia  ∙===∙>  it
Nippon  ∙===∙>  ja
Korea  ∙===∙>  ko
Latvija  ∙===∙>  lv
Lituania  ∙===∙>  lt
Macedonia  ∙===∙>  mc
Malaysia  ∙===∙>  ms
Norge  ∙===∙>  no
Poland  ∙===∙>  pl
Portugues  ∙===∙>  pt
Romania  ∙===∙>  ro
Rossija  ∙===∙>  ru
Serbia  ∙===∙>  sr
Slovakia  ∙===∙>  sk
Slovenia  ∙===∙>  sl
Español  ∙===∙>  es
Swahili  ∙===∙>  sw
Sverige  ∙===∙>  sv
Tamil  ∙===∙>  ta
Thai  ∙===∙>  th
Turkiye  ∙===∙>  tr
Ukraina  ∙===∙>  uk
Urdu  ∙===∙>  ur
Vietnam  ∙===∙>  vi
∙=============================================================∙
*/


;;∙============================================================∙
Tooltip, % "Translate Any Language To English`n`n   Press Ctrl+Alt+T`n`t`tto Activate`n   And Ctrl+Alt+Shift+T`n`t`tto Exit"
Sleep 3000
Tooltip
;;∙------------------------∙🔥HotKey🔥∙
^!t::    ;;∙------∙(Ctrl+Alt+T)
    clipboard := ""
    Sleep 100
    Send ^c
    ClipWait, 1
    TextToXlate := clipboard
    If TextToXlate {
        clipboard := ""
        Translated := GoogleTranslate(TextToXlate, "auto", "en")    ;;∙------∙Use language codes table above.
        Translated := RegExReplace(Translated, "s)\R\+.+")
        clipboard := Translated
        ClipWait, 1
    Send ^v
        Tooltip, % Translated
        Sleep 2000
        Tooltip
    }
    Else MsgBox,,, Nothing to translate!, 2
Return
;;∙------------------------∙🔥HotKey🔥∙
^!+t::    ;;∙------∙(Ctrl+Alt+Shift+T)
    Tooltip, % "Translator Is Exiting..."
    Sleep 1500
    Tooltip
Exitapp
;;∙------------------------------------------------∙
GoogleTranslate(str, from := "auto", to := "en") {
    static JS := CreateScriptObj(), _ := JS.( GetJScript() ) := JS.("delete ActiveXObject; delete GetObject;")
    json := SendRequest(JS, str, to, from, proxy := "")
    oJSON := JS.("(" . json . ")")
    if !IsObject(oJSON[1]) {
        Loop % oJSON[0].length
        trans .= oJSON[0][A_Index - 1][0]
    }
    else {
        MainTransText := oJSON[0][0][0]
        Loop % oJSON[1].length {
            trans .= "`n+"
            obj := oJSON[1][A_Index-1][1]
            Loop % obj.length {
                txt := obj[A_Index - 1]
                trans .= (MainTransText = txt ? "" : "`n" txt)
            }
        }
    }
    if !IsObject(oJSON[1])
        MainTransText := trans := Trim(trans, ",+`n ")
    else
        trans := MainTransText . "`n+`n" . Trim(trans, ",+`n ")
        from := oJSON[2]
        trans := Trim(trans, ",+`n ")
   Return trans
}
SendRequest(JS, str, tl, sl, proxy) {
    static http
    ComObjError(false)
    if !http
    {
        http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        ( proxy && http.SetProxy(2, proxy) )
        http.open("GET", "https://translate.google.com", true)
        http.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0")
        http.send()
        http.WaitForResponse(-1)
    }
    http.open("POST", "https://translate.googleapis.com/translate_a/single?client=gtx"
        ; or "https://clients5.google.com/translate_a/t?client=dict-chrome-ex"
    . "&sl=" . sl . "&tl=" . tl . "&hl=" . tl
    . "&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&ie=UTF-8&oe=UTF-8&otf=0&ssel=0&tsel=0&pc=1&kc=1"
    . "&tk=" . JS.("tk").(str), true)
    http.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=utf-8")
    http.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0")
    http.send("q=" . URIEncode(str))
    http.WaitForResponse(-1)
    Return http.responsetext
    }
URIEncode(str, encoding := "UTF-8")  {
    VarSetCapacity(var, StrPut(str, encoding))
    StrPut(str, &var, encoding)
    while code := NumGet(Var, A_Index - 1, "UChar")  {
        bool := (code > 0x7F || code < 0x30 || code = 0x3D)
    UrlStr .= bool ? "%" . Format("{:02X}", code) : Chr(code)
    }
    Return UrlStr
    }
GetJScript()
    {
    script =
        (
        var TKK = ((function() {
        var a = 561666268
        var b = 1526272306
        return 406398 + '.' + (a + b)
    })())
        function b(a, b) {
            for (var d = 0; d < b.length - 2; d += 3) {
                var c = b.charAt(d + 2),
                    c = "a" <= c ? c.charCodeAt(0) - 87 : Number(c),
                    c = "+" == b.charAt(d + 1) ? a >>> c : a << c;
                a = "+" == b.charAt(d) ? a + c & 4294967295 : a ^ c
            }
            return a
        }
        function tk(a) {
            for (var e = TKK.split("."), h = Number(e[0]) || 0, g = [], d = 0, f = 0; f < a.length; f++) {
                var c = a.charCodeAt(f);
                128 > c ? g[d++] = c : (2048 > c ? g[d++] = c >> 6 | 192 : (55296 == (c & 64512) && f + 1 < a.length && 56320 == (a.charCodeAt(f + 1) & 64512) ?
                (c = 65536 + ((c & 1023) << 10) + (a.charCodeAt(++f) & 1023), g[d++] = c >> 18 | 240,
            g[d++] = c >> 12 & 63 | 128) : g[d++] = c >> 12 | 224, g[d++] = c >> 6 & 63 | 128), g[d++] = c & 63 | 128)
        }
        a = h;
        for (d = 0; d < g.length; d++) a += g[d], a = b(a, "+-a^+6");
        a = b(a, "+-3^+b+-f");
        a ^= Number(e[1]) || 0;
        0 > a && (a = (a & 2147483647) + 2147483648);
        a `%= 1E6;
        return a.toString() + "." + (a ^ h)
        }
        )
    Return script
    }
CreateScriptObj() {
    static doc, JS, _JS
    if !doc {
        doc := ComObjCreate("htmlfile")
        doc.write("<meta http-equiv='X-UA-Compatible' content='IE=9'>")
        JS := doc.parentWindow
        if (doc.documentMode < 9)
            JS.execScript()
        _JS := ObjBindMethod(JS, "eval")
    }
    Return _JS
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
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.
SendMode Input
SetBatchLines -1
SetTimer, UpdateCheck, 500
SetTitleMatchMode 2
SetWinDelay 0
Menu, Tray, Icon, imageres.dll, 3
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
TEMPLATE:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

