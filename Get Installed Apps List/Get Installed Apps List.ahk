
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
» Author:  teadrinker
» Original Source:  https://www.autohotkey.com/boards/viewtopic.php?p=181382#p181382
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
;;∙======∙🔥 HotKey 🔥∙===========================================∙
^t::    ;;∙------∙(Ctrl+T) 
   Soundbeep, 1100, 100
;;∙============================================================∙




;;∙============================================================∙
SetBatchLines, -1    ;;∙------∙Run the script as fast as possible by reducing delays between commands.
headers := [ "DISPLAYNAME", "VERSION", "PUBLISHER", "PRODUCTID"    ;;∙------∙Define an array of headers for the program data to retrieve.
           , "REGISTEREDOWNER", "REGISTEREDCOMPANY", "LANGUAGE", "SUPPORTURL"
           , "SUPPORTTELEPHONE", "HELPLINK", "INSTALLLOCATION", "INSTALLSOURCE"
           , "INSTALLDATE", "CONTACT", "COMMENTS", "IMAGE", "UPDATEINFOURL" ]
data := []    ;;∙------∙Initialize an empty array to hold the program information.
for k, v in headers    ;;∙------∙Loop through each header item.
   data.Push( GetAppsInfo({ mask: v, offset: A_PtrSize*(k - 1) }) )    ;;∙------∙For each header, call GetAppsInfo to retrieve the program details and store the results in `data`.

arr := []    ;;∙------∙Initialize an empty array `arr` to structure the data for GUI display.
for k, v in data    ;;∙------∙Loop through the `data` array.
   for i, j in v    ;;∙------∙Loop through the nested items within each `v` (individual program data).
      arr[i, k] := j    ;;∙------∙Assign the value of each nested item into the `arr` array for proper structuring.
       
;;∙------∙Create GUI with a standard Edit control for displaying results.
Gui, +AlwaysOnTop
Gui, Color, Silver
Gui, Add, Edit, w600 h400 vMyEdit ReadOnly,    ;;∙------∙Create an editable, read-only Edit control to display the program data.
Gui, Show, , Installed Programs    ;;∙------∙Display the GUI with the title "Installed Programs".

;;∙------∙Add numbered & formatted results into Edit control.
str := ""    ;;∙------∙Initialize an empty string `str` to store the formatted program data.
str := "`r`n"    ;;∙------∙Start with a blank line.
for k, v in arr {    ;;∙------∙Loop through the `arr` array of structured program data.
   str .= (k = 1 ? "" : "`r`n")    ;;∙------∙Add a new line after the first item to separate program entries.
   str .= k ". "    ;;∙------∙Number the programs starting from 1.
   for i, j in v    ;;∙------∙Loop through each property of the program.
      str .= (i = 1 ? "" : ", ") . j    ;;∙------∙Separate properties with commas (except the first).
   str .= "`r`n"    ;;∙------∙Add a blank line after each program entry for readability.
}
str .= "`r`n`t* END OF RETURN *`r`n"    ;;∙------∙Append "* END OF RETURN *" tabbed once as the last line.
GuiControl,, MyEdit, % str    ;;∙------∙Set the text content of the Edit control to the formatted string `str`.
Clipboard := str    ;;∙------∙Copy the formatted string to the clipboard.
Return

GuiClose:    ;;∙------∙Handle the event when the GUI window is closed.
GuiEscape:    ;;∙------∙Handle the event when the Escape key is pressed.
    ExitApp    ;;∙------∙Exit the script when either event occurs.
Return

GetAppsInfo(infoType)  {    ;;∙------∙Define the function that retrieves information about installed programs.
   static CLSID_EnumInstalledApps := "{0B124F8F-91F0-11D1-B8B5-006008059382}"    ;;∙------∙Static CLSID for enumerating installed apps.
        , IID_IEnumInstalledApps := "{1BC752E1-9046-11D1-B8B3-006008059382}"    ;;∙------∙Static IID for interacting with the apps.
        
        , AIM_DISPLAYNAME := 0x00000001
        , AIM_VERSION := 0x00000002
        , AIM_PUBLISHER := 0x00000004
        , AIM_PRODUCTID := 0x00000008
        , AIM_REGISTEREDOWNER := 0x00000010
        , AIM_REGISTEREDCOMPANY := 0x00000020
        , AIM_LANGUAGE := 0x00000040
        , AIM_SUPPORTURL := 0x00000080
        , AIM_SUPPORTTELEPHONE := 0x00000100
        , AIM_HELPLINK := 0x00000200
        , AIM_INSTALLLOCATION := 0x00000400
        , AIM_INSTALLSOURCE := 0x00000800
        , AIM_INSTALLDATE := 0x00001000
        , AIM_CONTACT := 0x00004000
        , AIM_COMMENTS := 0x00008000
        , AIM_IMAGE := 0x00020000
        , AIM_READMEURL := 0x00040000
        , AIM_UPDATEINFOURL := 0x00080000
        
   pEIA := ComObjCreate(CLSID_EnumInstalledApps, IID_IEnumInstalledApps)    ;;∙------∙Create a COM object to enumerate installed apps.
   arr := []    ;;∙------∙Initialize an empty array to hold the retrieved data.
   while DllCall(NumGet(NumGet(pEIA+0) + A_PtrSize*3), Ptr, pEIA, PtrP, pINA) = 0  {    ;;∙------∙Loop through the list of installed apps.
      VarSetCapacity(APPINFODATA, size := 4*2 + A_PtrSize*18, 0)    ;;∙------∙Prepare memory for the data structure.
      NumPut(size, APPINFODATA)    ;;∙------∙Set the size of the structure.
      mask := "AIM_" . infoType.mask    ;;∙------∙Set the appropriate bitmask based on the requested info type.
      NumPut(%mask%, APPINFODATA, 4)    ;;∙------∙Apply the bitmask to the data structure.
      DllCall(NumGet(NumGet(pINA+0) + A_PtrSize*3), Ptr, pINA, Ptr, &APPINFODATA)    ;;∙------∙Retrieve the app data.
      ObjRelease(pINA)    ;;∙------∙Release the COM object holding the app info.
      if !pData := NumGet(APPINFODATA, 8 + infoType.offset)  {    ;;∙------∙Check if the data exists for this app.
         arr.Push("")    ;;∙------∙If no data, push an empty string.
         continue
      }
      arr.Push( StrGet(pData, "UTF-16") )    ;;∙------∙If data is found, decode it from UTF-16 and store in `arr`.
      DllCall("Ole32\CoTaskMemFree", Ptr, pData)    ;;∙------∙Free the memory allocated by the COM interface.
   }
   Return arr    ;;∙------∙Return the array of program data.
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
        SoundBeep, 1100, 75
        Soundbeep, 1200, 100
    Reload
Return
;;-------∙EXIT∙------∙EXIT∙--------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙--∙Double-Tap.
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
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;; Gui Drag Pt 1.
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
Menu, Tray, Icon, Suspend / Pause, shell32, 28  ;  Imageres.dll, 65
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

