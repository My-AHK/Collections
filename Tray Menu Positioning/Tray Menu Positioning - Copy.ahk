



;;;∙======∙Auto-Execute∙==========================================∙
#Persistent
#SingleInstance, Force
    SetTimer, UpdateCheck, 5    ;;∙------∙Script auto-reload on save.
Menu, Tray, Icon, imageres.dll, 3
;;∙------------------------------------------------∙
;;∙------∙Set Default Values For Pixels Above & To Left Of Cursor.
pixAbove := 20   ;;∙------∙Adjust value for pixels above cursor point.
pixToLeft := 20  ;;∙------∙Adjust value for pixels left of cursor point.
;;∙------------------------------------------------∙
Return
;;∙============================================================∙


;;∙============================================================∙
NotifyTrayClick(P*) { 
Static Msg, Fun:="NotifyTrayClick", NM:=OnMessage(0x404,Func(Fun),-1),  Chk,T:=-250,Clk:=1
  If ( (NM := Format(Fun . "_{:03X}", Msg := P[2])) && P.Count()<4 )
     return ( T := Max(-5000, 0-(P[1] ? Abs(P[1]) : 250)) )
  Critical
  If ( ( Msg<0x201 || Msg>0x209 ) || ( IsFunc(NM) || Islabel(NM) )=0 )
     return
  Chk := (Fun . "_" . (Msg<=0x203 ? "203" : Msg<=0x206 ? "206" : Msg<=0x209 ? "209" : "")) 
  SetTimer, %NM%,  %  (Msg==0x203        || Msg==0x206        || Msg==0x209)
    ? (-1, Clk:=2) : ( Clk=2 ? ("Off", Clk:=1) : ( IsFunc(Chk) || IsLabel(Chk) ? T : -1) )
     return True
}
NotifyTrayClick_205:   ;;∙------∙Right click (Button up)
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - pixToLeft, % my - pixAbove
Return
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

