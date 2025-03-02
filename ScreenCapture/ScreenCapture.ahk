
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  Linear Spoon
» Original Source:  https://www.autohotkey.com/board/topic/121619-screencaptureahk-broken-capturescreen-function-win-81-x64/
» 
    ▹ 
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "ScreenCapture"
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙




;;∙============================================================∙
/*∙---∙CaptureScreen(aRect, bCursor, sFileTo, nQuality)∙-----------------------∙

» aRect :  
   • If 0/1/2/3, captures the entire desktop/active window/active client area/active monitor.
   • Can be comma delimited sequence of coordinates, e.g., "Left, Top, Right, Bottom" or "Left, Top, Right, Bottom, Width_Zoomed, Height_Zoomed".
    ▹ "Left, Top, Right, Bottom"  <---->  In this case, only that portion of the rectangle will be captured. 
    ▹ "Left, Top, Right, Bottom, Width_Zoomed, Height_Zoomed"  <---->  In this case, also zoomed to the new width/height.

» bCursor :  
   • If the optional parameter bCursor is True, captures the cursor too.

» sFileTo :  
   • If the optional parameter sFileTo is 0, set the image to Clipboard.
   • If it is omitted or "", saves to screen.bmp in the script folder.
   • Otherwise to sFileTo which can be BMP/JPG/PNG/GIF/TIF.

» nQuality :  
   • Applicable only when sFileTo is JPG.
    ▹ Set it to the desired quality level of the resulting JPG, an integer between 0 - 100.

∙--------------------------------------------------------------------------------------------∙
∙------------------∙CaptureScreen(aRect, bCursor, sFileTo, nQuality)∙-----------∙
∙------∙Usage Examples∙----------------------------------------------------------------∙
• CaptureScreen(0)    ;;∙------∙Captures entire screen.
   CaptureScreen(0, True)    ;;∙------∙Include mouse cursor in screenshot (True) or don't (False).
   CaptureScreen(0, False, 0)    ;;∙------∙Capture screen & store it in clipboard instead of saving file.
   CaptureScreen(0, False, "C:\screenshot.png")    ;;∙------∙Capture screen & save as PNG file.
   CaptureScreen(0, False, "C:\screenshot.jpg", 90)    ;;∙------∙Capture screen & saves as high-quality JPG (90% quality).
• CaptureScreen(1)    ;;∙------∙Captures active window.
• CaptureScreen(2)    ;;∙------∙Captures active client area.
• CaptureScreen(3)    ;;∙------∙Captures active monitor.
• CaptureScreen("100, 100, 200, 200")    ;;∙------∙Captures specific region ("Left=100, Top=100, Right=200, Bottom=200")
• CaptureScreen("100, 100, 200, 200, 400, 400")    ;;∙------∙Captures specific region & resizes it (Zoom to "400x400")

∙------∙Conversion Examples (sFileFr, sFileTo, nQuality)
• Convert("C:\image.bmp", "C:\image.jpg")    ;;∙------∙Image to image conversion.
• Convert("C:\image.png", "C:\image.jpg")    ;;∙------∙Image to image conversion also.
• Convert("C:\image.bmp", "C:\image.jpg", 95)    ;;∙------∙Image to image conversion with JPG quality setting(95).
• Convert(0, "C:\clip.png")    ;;∙------∙Save the image in clipboard to sFileTo if sFileFr is "" or 0.
∙--------------------------------------------------------------------------------------------∙
*/


;;∙============================================================∙
global counter := 0    ;;∙------∙Initialize.

^t::    ;;∙------∙🔥∙(Ctrl+T)∙🔥∙
    Soundbeep, 1000, 200
    global counter += 1    ;;∙------∙Increment file save number.
CaptureScreen(3, False, A_ScriptDir . "\ScreenCap " . counter . ".png")    ;;∙------∙(Captures active monitor, With no cursor, Saves to script DIR as #'d PNG, No JPG quality)

Return
;;∙------------------------∙

CaptureScreen(aRect = 0, bCursor = False, sFile = "", nQuality = "")
{
    If !aRect
    {
        SysGet, nL, 76    ;;∙------∙Virtual screen Left & Top.
        SysGet, nT, 77
        SysGet, nW, 78    ;;∙------∙Virtual screen Width & Height.
        SysGet, nH, 79
    }
    Else If aRect = 1
        WinGetPos, nL, nT, nW, nH, A
    Else If aRect = 2
    {
        WinGet, hWnd, ID, A
        VarSetCapacity(rt, 16, 0)
        DllCall("GetClientRect" , "ptr", hWnd, "ptr", &rt)
        DllCall("ClientToScreen", "ptr", hWnd, "ptr", &rt)
        nL := NumGet(rt, 0, "int")
        nT := NumGet(rt, 4, "int")
        nW := NumGet(rt, 8)
        nH := NumGet(rt,12)
    }
    Else If aRect = 3
    {
        VarSetCapacity(mi, 40, 0)
        DllCall("GetCursorPos", "int64P", pt), NumPut(40,mi,0,"uint")
        DllCall("GetMonitorInfo", "ptr", DllCall("MonitorFromPoint", "int64", pt, "Uint", 2, "ptr"), "ptr", &mi)
        nL := NumGet(mi, 4, "int")
        nT := NumGet(mi, 8, "int")
        nW := NumGet(mi,12, "int") - nL
        nH := NumGet(mi,16, "int") - nT
    }
    Else
    {
        StringSplit, rt, aRect, `,, %A_Space%%A_Tab%
        nL := rt1    ;;∙------∙Convert the Left, Top, Right, Bottom  into  Left, Top, Width, Height.
        nT := rt2
        nW := rt3 - rt1
        nH := rt4 - rt2
        znW := rt5
        znH := rt6
    }

    mDC := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
    hBM := CreateDIBSection(mDC, nW, nH)
    oBM := DllCall("SelectObject", "ptr", mDC, "ptr", hBM, "ptr")
    hDC := DllCall("GetDC", "ptr", 0, "ptr")
    DllCall("BitBlt", "ptr", mDC, "int", 0, "int", 0, "int", nW, "int", nH, "ptr", hDC, "int", nL, "int", nT, "Uint", 0x40CC0020)
    DllCall("ReleaseDC", "ptr", 0, "ptr", hDC)
    If bCursor
        CaptureCursor(mDC, nL, nT)
    DllCall("SelectObject", "ptr", mDC, "ptr", oBM)
    DllCall("DeleteDC", "ptr", mDC)
    If znW && znH
        hBM := Zoomer(hBM, nW, nH, znW, znH)
    If sFile = 0
        SetClipboardData(hBM)
    Else Convert(hBM, sFile, nQuality), DllCall("DeleteObject", "ptr", hBM)
}

CaptureCursor(hDC, nL, nT)
{
    VarSetCapacity(mi, 32, 0), Numput(16+A_PtrSize, mi, 0, "uint")
    DllCall("GetCursorInfo", "ptr", &mi)
    bShow   := NumGet(mi, 4, "uint")
    hCursor := NumGet(mi, 8)
    xCursor := NumGet(mi,8+A_PtrSize, "int")
    yCursor := NumGet(mi,12+A_PtrSize, "int")

    DllCall("GetIconInfo", "ptr", hCursor, "ptr", &mi)
    xHotspot := NumGet(mi, 4, "uint")
    yHotspot := NumGet(mi, 8, "uint")
    hBMMask  := NumGet(mi,8+A_PtrSize)
    hBMColor := NumGet(mi,16+A_PtrSize)

    If bShow
        DllCall("DrawIcon", "ptr", hDC, "int", xCursor - xHotspot - nL, "int", yCursor - yHotspot - nT, "ptr", hCursor)
    If hBMMask
        DllCall("DeleteObject", "ptr", hBMMask)
    If hBMColor
        DllCall("DeleteObject", "ptr", hBMColor)
}

Zoomer(hBM, nW, nH, znW, znH)
{
    mDC1 := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
    mDC2 := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
    zhBM := CreateDIBSection(mDC2, znW, znH)
    oBM1 := DllCall("SelectObject", "ptr", mDC1, "ptr",  hBM, "ptr")
    oBM2 := DllCall("SelectObject", "ptr", mDC2, "ptr", zhBM, "ptr")
    DllCall("SetStretchBltMode", "ptr", mDC2, "int", 4)
    DllCall("StretchBlt", "ptr", mDC2, "int", 0, "int", 0, "int", znW, "int", znH, "ptr", mDC1, "int", 0, "int", 0, "int", nW, "int", nH, "Uint", 0x00CC0020)
    DllCall("SelectObject", "ptr", mDC1, "ptr", oBM1)
    DllCall("SelectObject", "ptr", mDC2, "ptr", oBM2)
    DllCall("DeleteDC", "ptr", mDC1)
    DllCall("DeleteDC", "ptr", mDC2)
    DllCall("DeleteObject", "ptr", hBM)
    Return zhBM
}

Convert(sFileFr = "", sFileTo = "", nQuality = "")
{
    If (sFileTo = "")
        sFileTo := A_ScriptDir . "\screen.bmp"
    SplitPath, sFileTo, , sDirTo, sExtTo, sNameTo
    
    If Not hGdiPlus := DllCall("LoadLibrary", "str", "gdiplus.dll", "ptr")
        Return    sFileFr+0 ? SaveHBITMAPToFile(sFileFr, sDirTo (sDirTo = "" ? "" : "\") sNameTo ".bmp") : ""
    VarSetCapacity(si, 16, 0), si := Chr(1)
    DllCall("gdiplus\GdiplusStartup", "UintP", pToken, "ptr", &si, "ptr", 0)

    If !sFileFr
    {
        DllCall("OpenClipboard", "ptr", 0)
        If    (DllCall("IsClipboardFormatAvailable", "Uint", 2) && (hBM:=DllCall("GetClipboardData", "Uint", 2, "ptr")))
            DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "ptr", hBM, "ptr", 0, "ptr*", pImage)
        DllCall("CloseClipboard")
    }
    Else If    sFileFr Is Integer
        DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "ptr", sFileFr, "ptr", 0, "ptr*", pImage)
    Else    DllCall("gdiplus\GdipLoadImageFromFile", "wstr", sFileFr, "ptr*", pImage)
    DllCall("gdiplus\GdipGetImageEncodersSize", "UintP", nCount, "UintP", nSize)
    VarSetCapacity(ci,nSize,0)
    DllCall("gdiplus\GdipGetImageEncoders", "Uint", nCount, "Uint", nSize, "ptr", &ci)
    struct_size := 48+7*A_PtrSize, offset := 32 + 3*A_PtrSize, pCodec := &ci - struct_size
    Loop, %    nCount
        If InStr(StrGet(Numget(offset + (pCodec+=struct_size)), "utf-16") , "." . sExtTo)
            break

    If (InStr(".JPG.JPEG.JPE.JFIF", "." . sExtTo) && nQuality<>"" && pImage && pCodec < &ci + nSize)
    {
        DllCall("gdiplus\GdipGetEncoderParameterListSize", "ptr", pImage, "ptr", pCodec, "UintP", nCount)
        VarSetCapacity(pi,nCount,0), struct_size := 24 + A_PtrSize
        DllCall("gdiplus\GdipGetEncoderParameterList", "ptr", pImage, "ptr", pCodec, "Uint", nCount, "ptr", &pi)
        Loop, %    NumGet(pi,0,"uint")
            If (NumGet(pi,struct_size*(A_Index-1)+16+A_PtrSize,"uint")=1 && NumGet(pi,struct_size*(A_Index-1)+20+A_PtrSize,"uint")=6)
            {
                pParam := &pi+struct_size*(A_Index-1)
                NumPut(nQuality,NumGet(NumPut(4,NumPut(1,pParam+0,"uint")+16+A_PtrSize,"uint")),"uint")
                Break
            }
    }

    If pImage
        pCodec < &ci + nSize    ? DllCall("gdiplus\GdipSaveImageToFile", "ptr", pImage, "wstr", sFileTo, "ptr", pCodec, "ptr", pParam) : DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "ptr", pImage, "ptr*", hBitmap, "Uint", 0) . SetClipboardData(hBitmap), DllCall("gdiplus\GdipDisposeImage", "ptr", pImage)

    DllCall("gdiplus\GdiplusShutdown" , "Uint", pToken)
    DllCall("FreeLibrary", "ptr", hGdiPlus)
}


CreateDIBSection(hDC, nW, nH, bpp = 32, ByRef pBits = "")
{
    VarSetCapacity(bi, 40, 0)
    NumPut(40, bi, "uint")
    NumPut(nW, bi, 4, "int")
    NumPut(nH, bi, 8, "int")
    NumPut(bpp, NumPut(1, bi, 12, "UShort"), 0, "Ushort")
    Return DllCall("gdi32\CreateDIBSection", "ptr", hDC, "ptr", &bi, "Uint", 0, "UintP", pBits, "ptr", 0, "Uint", 0, "ptr")
}

SaveHBITMAPToFile(hBitmap, sFile)
{
    VarSetCapacity(oi,104,0)
    DllCall("GetObject", "ptr", hBitmap, "int", 64+5*A_PtrSize, "ptr", &oi)
    fObj := FileOpen(sFile, "w")
    fObj.WriteShort(0x4D42)
    fObj.WriteInt(54+NumGet(oi,36+2*A_PtrSize,"uint"))
    fObj.WriteInt64(54<<32)
    fObj.RawWrite(&oi + 16 + 2*A_PtrSize, 40)
    fObj.RawWrite(NumGet(oi, 16+A_PtrSize), NumGet(oi,36+2*A_PtrSize,"uint"))
    fObj.Close()
}

SetClipboardData(hBitmap)
{
    VarSetCapacity(oi,104,0)
    DllCall("GetObject", "ptr", hBitmap, "int", 64+5*A_PtrSize, "ptr", &oi)
    sz := NumGet(oi,36+2*A_PtrSize,"uint")
    hDIB :=    DllCall("GlobalAlloc", "Uint", 2, "Uptr", 40+sz, "ptr")
    pDIB := DllCall("GlobalLock", "ptr", hDIB, "ptr")
    DllCall("RtlMoveMemory", "ptr", pDIB, "ptr", &oi + 16 + 2*A_PtrSize, "Uptr", 40)
    DllCall("RtlMoveMemory", "ptr", pDIB+40, "ptr", NumGet(oi, 16+A_PtrSize), "Uptr", sz)
    DllCall("GlobalUnlock", "ptr", hDIB)
    DllCall("DeleteObject", "ptr", hBitmap)
    DllCall("OpenClipboard", "ptr", 0)
    DllCall("EmptyClipboard")
    DllCall("SetClipboardData", "Uint", 8, "ptr", hDIB)
    DllCall("CloseClipboard")
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
ScreenCapture:
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

