
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
» Author:  IsNull
» Source:  https://www.autohotkey.com/board/topic/82986-ahk-l-decompiler-payload-method/
» Helps to extract the source from a compiled AHK Script.
    ▹ The following packers are known to be bypassed:
         ▹UPX
         ▹Mpress
         ▹XPack/XComp
         ▹Engima
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
; ^t::    ;;∙------∙(Ctrl+T) 
;    Soundbeep, 1100, 100
;;∙============================================================∙




;;∙============================================================∙
global DEBUG := false

global POSSIBLE_RESOURCE_NAMES := [">AHK WITH ICON<", ">AUTOHOTKEY SCRIPT<"]
global PATCHED_RESOURCE_NAMES  := [">UHK WITH ICON<", ">UUTOHOTKEY SCRIPT<"]

global ExtractionDir := A_ScriptDir "\ExtractionTemp"

;;∙------∙EXTERNAL RESOURCES: 
global DecompilerPayload_URL := "http://dl.securityvision.ch/tools/decompiler_payload.dll"
global DecompilerPayload64_URL := "http://dl.securityvision.ch/tools/decompiler_payload_64.dll"

global DecompilerPayload_BIN := A_ScriptDir "\payload.dll"
global DecompilerPayload64_BIN := A_ScriptDir "\payload64.dll"

global CurrentPayload_BIN := ExtractionDir "\winmm.dll"

Gui, new, +Resize +MinSize480x370 +hwndhSelfGUI
Gui, Margin, 3, 3
Gui, Color, White
Gui, add, Edit, w480 h20 gExtractNow vAHKExe, [drag your compiled exe here]
Gui, Font,, Consolas
Gui, add, Edit, +ReadOnly vMyLog w480 h200
Gui, add, Edit, +ReadOnly vScriptSource w480 h100 c4A708B
Gui, Font
Gui, show, w480 h370, AHK_L Decompiler by IsNull/fincs/joedf

LogLn("<Running on: AHK Version "A_AhkVersion " - " (A_IsUnicode ? "Unicode" : "Ansi") " " (A_PtrSize == 4 ? "32" : "64") "bit>")
Return


GuiClose: 
ExitApp

GuiSize:
GuiControl,Move,AHKExe, % "w" A_GuiWidth-6
GuiControl,Move,MyLog, % "w" A_GuiWidth-6
GuiControl,Move,ScriptSource, % "w" A_GuiWidth-6 " h" A_GuiHeight-232
return

ExtractNow:
	Gui,submit, nohide

	LogClear()
	GuiCodeSet("")

	if(PrepareFile(AHKExe, preparedFile))
	{
		
		;;∙------∙file was prepared successfully.
		if(EnsurePayloadIsPresent())
		{
			LogLn("<Injecting payload...>")

			PlacePayload(preparedFile)

			RunWait, % preparedFile, % ExtractionDir, UseErrorLevel
			if(ErrorLevel == "ERROR")
			{
				LogLn("<The Target could not be started. Is this a valid PE Executable?>")
			}else{
				SplitPath, preparedFile, OutFileName, OutDir, OutExtension, OutNameNoExt
				tmpCodePath = %OutDir%\%OutNameNoExt%-uncompiled.ahk

				try {
					WaitForFile(tmpCodePath, 10000)    ;;∙------∙Wait maximum 10secs for the file, this should be enough for even very slow harddisks.
				}catch e{
					LogLn("<" e.Message ">")
					LogLn("<Missing: " tmpCodePath ">")
				}

				if(FileExist(tmpCodePath))
				{
					LogLn("<Payload succeeded. Recovering Script.>")
					FileRead, script, % tmpCodePath
					if(!DEBUG)
						FileDelete, % tmpCodePath
					GuiCodeSet(script)
				}else{
					LogLn("<Script could not be extracted.>")
				}
				if(!DEBUG)
					FileDelete, % CurrentPayload_BIN    ;;∙------∙Remove the winmm.dll as it causes trouble if it get accedintially injected.
			}
		}else{
			LogLn("<Missing payload. Aborting now.>")
			return
		}
	}else{
		LogLn("<File seems not to be a valid compiled AHK Script or it uses an unknown protection.>")
	}
	if(!DEBUG)
		FileDelete, % preparedFile

return

GuiDropFiles: 
   GuiControl,,AHKExe, % A_GuiEvent
   WinActivate, ahk_id %hSelfGUI%
return

/*
* Waits until the file is present
* can be aborted by the timeout
*
* file      File-Path to check
* timeout   Timeout in Milliseconds (Max waittime)
*/
WaitForFile(file, timeout=5000){
   start := A_TickCount
   
   while(!FileExist(file))
   {
      if((A_TickCount - start) > timeout)
         throw Exception("TimeoutException: File was not present whithin the expected time.")
   }
}

PlacePayload(preparedFile){
   success := false
   SplitPath, preparedFile, OutFileName, OutDir
   
   if(Is64BitAssembly(preparedFile))
   {
      LogLn("<Target Application is 64bit.>")
      payloadSrc := DecompilerPayload64_BIN 
   }else{
      LogLn("<Target Application is 32bit.>")
      payloadSrc := DecompilerPayload_BIN
   }
   
   if(FileExist(payloadSrc))
   {
      FileCopy, % payloadSrc, % CurrentPayload_BIN, 1
      success := true
   }
   return success
}

Is64BitAssembly(appName){
   static GetBinaryType := "GetBinaryType" (A_IsUnicode ? "W" : "A")
   static SCS_32BIT_BINARY := 0
   static SCS_64BIT_BINARY := 6

   ret := DllCall(GetBinaryType
      ,"Str", appName
      ,"int*", binaryType)
   
   return binaryType == SCS_64BIT_BINARY
}

EnsurePayloadIsPresent(){
   if(!FileExist(DecompilerPayload_BIN))
   {
      URLDownloadToFile, % DecompilerPayload_URL, % DecompilerPayload_BIN
      LogLn("<" DecompilerPayload_BIN " downloaded.>")
   }
   if(!FileExist(DecompilerPayload64_BIN))
   {
      URLDownloadToFile, % DecompilerPayload64_URL, % DecompilerPayload64_BIN
      LogLn("<" DecompilerPayload64_BIN " downloaded.>")
   }
   
   return FileExist(DecompilerPayload_BIN)
}

PrepareFile(fileToPrepare, byref preparedFile){
   
   success := false
   
   if(!FileExist(ExtractionDir))
      FileCreateDir, % ExtractionDir
   
   if(FileExist(fileToPrepare))
   {
      
      LogLn("<Recover Source for " fileToPrepare ">")
   
      
      binaryTarget := ExtractionDir "\patched.exe"
      preparedFile := binaryTarget
      FileCopy, % fileToPrepare, % binaryTarget, 1
      LogLn("<Starting file analysis...>")
      ;;∙------------------------∙
      
      ofile := FileOpen(binaryTarget, "rw")
      VarSetCapacity(buffer, ofile.Length) 
      bytesRead := ofile.RawRead(buffer, ofile.Length)
      
      LogLn("<Readed " bytesRead " bytes from file.>")
      
      
      if(HasPEHeaderMagic(buffer))
      {
         LogLn("<Seems to be a valid PE File.>")
         
         
         for i, resName in POSSIBLE_RESOURCE_NAMES
         {
            ahkResourceName := StringToUTFByteArray(POSSIBLE_RESOURCE_NAMES[i])
            patch := StringToUTFByteArray(PATCHED_RESOURCE_NAMES[i])

			LogLn("<Searching for " ByteArrayToHex(ahkResourceName) " in " bytesRead "bytes.>")
			
			if(pos := FindMagic(buffer, bytesRead, ahkResourceName))
			{
				if(PatchBinary(ofile, pos, patch)){
				   LogLn("<Patched successfull>")
				   success := true
				   break
				}
			}
         }
		 
		 ofile.Close()    ;;∙------∙Flush
      }else{
         LogLn("<Whatever you dragged here, this is NOT a valid PE file.>")
      }
      
      ;;∙------------------------∙
      
   }else{
      LogLn("<File Not Found!>")
   }
   
   return success
}

HasPEHeaderMagic(ByRef buffer){
   return (NumGet(buffer,0,"UChar") == 77 && (NumGet(buffer,1,"UChar") == (A_IsUnicode ? 90 : 82)))
}

PatchBinary(targetfile, pos, byteArrayReplacement){
   
   written := false
   
   if(!IsObject(targetfile)){
      throw "targetfile: must be a valid file instance"
   }

   if(pos != -1)
   {
      LogLn("<Found Resource-Name @" pos ">")
      LogLn("<Patching Resource-Name...>")
      
      targetfile.Seek(pos)   
      size := ByteArrayToBuffer(byteArrayReplacement, patched)
      written := targetfile.RawWrite(patched, size)
      
      LogLn("<PatchBinary: Written " written " bytes.>")
   }else{
      LogLn("<Could not find pattern: " ByteArrayToHex(arr) ">")
   }
   
   return written
}


global mylogData := ""
LogLn(line){
   global
   mylogData .= line "`n"
   GuiControl,,MyLog, % mylogData
}
LogClear(){
   global
   mylogData := ""
   GuiControl,,MyLog, % mylogData
}

GuiCodeSet(scriptcode){
   global
   GuiControl,,ScriptSource, % scriptcode
}

StringToUTFByteArray(str){
   bufSize := StringToUTFBUffer(str, buf)
   return BufferToByteArray(buf, bufSize)
}

StringToUTFBUffer(str, byref buf){
   ;;∙------∙size := StrPut(str, "UTF-16")    ;;∙------∙Seems the size is not calculated correctly for UTF-16 Strings.
   size := (StrPut(str, "UTF-16") - 1) * 2
   VarSetCapacity( buf, size, 0x00)
   StrPut(str, &buf, size, "UTF-16")
   return size
}

BufferToHex( ptr, size )
{
   myhexdmp := ""
   SetFormat, integer, hex
   Loop, % size
   {
      byte := NumGet(ptr+0, A_index-1,"UChar") + 0
      myhexdmp .= byte
   }
   return myhexdmp
}

ByteArrayToHex(arr){
   s := ""
   SetFormat, integer, hex
   for each, byte in arr
   {
      byte += 0
      s .= (StrLen(x := SubStr(byte, 3)) < 2 ? "0" x : x ) " "
   }
   SetFormat, integer, dez
   StringUpper, s, s
   return s
}

PrintArr(obj) { 
    str := ""
   for i, val in obj
      str .= "[" i "] -> " val  "`n"
   return str
}
PrintArrAsStr(obj) { 
    str := ""
   for each, val in obj
      str .= val "(" (val != 0 ? chr(val) : "null") ")"  "`n"
   return str
}

ToByteArray(str){
   bytes := []
   Loop, parse, str
      bytes[A_index] := asc(A_LoopField)
   return bytes
}

ByteArrayToBuffer(byteArray, byref buf){
   bufferSize := byteArray.MaxIndex()
   VarSetCapacity(buf, bufferSize, 0x00)
   for each, byte in byteArray
      NumPut(byte, buf, A_Index-1, "uchar")
   return bufferSize
}

BufferToByteArray(byref buffer, size){
   arr := []
   loop, % size
      arr[A_index] := NumGet(buffer, A_Index-1, "UChar")
   return arr
}


FindMagic(byref buffer, size, magic, offset=0){
   magicLen := ByteArrayToBuffer(magic, magicBuffer)
   magicByte := magic[1]
   searchPtr := &buffer + offset
   searchEnd := &buffer + size - magicLen + 1    ;;∙------∙First byte must precede searchEnd.
   if(searchPtr >= searchEnd)
      return -1
   while searchPtr := DllCall("msvcrt\memchr", "ptr", searchPtr, "int", magicByte
                              , "ptr", searchEnd - searchPtr, "ptr"){
      if !DllCall("msvcrt\memcmp", "ptr", searchPtr, "ptr", &magicBuffer, "ptr", magicLen)
         return searchPtr - &buffer    ;;∙------∙What the script expects.
      ++searchPtr    ;;∙------∙Resume search at the next byte.
   }
   return -1
}
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

