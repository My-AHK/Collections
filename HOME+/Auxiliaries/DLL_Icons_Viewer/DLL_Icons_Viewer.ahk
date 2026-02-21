
/*------∙NOTES∙--------------------------------------------------------------------------∙
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
∙--------------------------------------------------------------------------------------------∙
*/

;;∙====================================∙
;;∙======∙AUTO-EXECUTE∙========∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance, Force
SendMode, Input
SetBatchLines -1
SetWinDelay 0
SetTimer, UpdateCheck, 750
ScriptID := "DLL_Icons_Viewer"
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")

Menu, Tray, Icon, shell32.dll, 313
GoSub, TrayMenu
#NoTrayIcon


;;∙======∙GLOBALS∙=============∙
global Count := 340, File := "shell32.dll"    ;;∙------∙Total icons to display / Default DLL file.

;;∙------∙DLL Lookup Table (maps variable names to corresponding DLL files).
global dllLookup := {}
dllLookup["accessibilitycpl"] := "accessibilitycpl.dll"
dllLookup["aclui"] := "aclui.dll"
dllLookup["ActionCenter"] := "ActionCenter.dll"
dllLookup["actioncentercpl"] := "actioncentercpl.dll"
dllLookup["Apphlpdm"] := "Apphlpdm.dll"
dllLookup["audiosrv"] := "audiosrv.dll"
dllLookup["AuthFWGP"] := "AuthFWGP.dll"
dllLookup["authui"] := "authui.dll"
dllLookup["autoplay"] := "autoplay.dll"
dllLookup["azroleui"] := "azroleui.dll"
dllLookup["basecsp"] := "basecsp.dll"
dllLookup["bootux"] := "bootux.dll"
dllLookup["bthci"] := "bthci.dll"
dllLookup["BthpanContextHandler"] := "BthpanContextHandler.dll"
dllLookup["btpanui"] := "btpanui.dll"
dllLookup["cabview"] := "cabview.dll"
dllLookup["CastingShellExt"] := "CastingShellExt.dll"
dllLookup["CertEnrollUI"] := "CertEnrollUI.dll"
dllLookup["certmgr"] := "certmgr.dll"
dllLookup["cewmdm"] := "cewmdm.dll"
dllLookup["cmdial32"] := "cmdial32.dll"
dllLookup["cmlua"] := "cmlua.dll"
dllLookup["cmstplua"] := "cmstplua.dll"
dllLookup["colorui"] := "colorui.dll"
dllLookup["comctl32"] := "comctl32.dll"
dllLookup["comdlg32"] := "comdlg32.dll"
dllLookup["compstui"] := "compstui.dll"
dllLookup["comres"] := "comres.dll"
dllLookup["ConhostV1"] := "ConhostV1.dll"
dllLookup["connect"] := "connect.dll"
dllLookup["console"] := "console.dll"
dllLookup["ContentDeliveryManager_Utilities"] := "ContentDeliveryManager.Utilities.dll"
dllLookup["cryptui"] := "cryptui.dll"
dllLookup["cryptuiwizard"] := "cryptuiwizard.dll"
dllLookup["DAMM"] := "DAMM.dll"
dllLookup["dataclen"] := "dataclen.dll"
dllLookup["ddores"] := "ddores.dll"
dllLookup["deskadp"] := "deskadp.dll"
dllLookup["deskmon"] := "deskmon.dll"
dllLookup["devmgr"] := "devmgr.dll"
dllLookup["DeviceCenter"] := "DeviceCenter.dll"
dllLookup["DevicePairing"] := "DevicePairing.dll"
dllLookup["DevicePairingFolder"] := "DevicePairingFolder.dll"
dllLookup["dfshim"] := "dfshim.dll"
dllLookup["DiagCpl"] := "DiagCpl.dll"
dllLookup["diagperf"] := "diagperf.dll"
dllLookup["Display"] := "Display.dll"
dllLookup["dnscmmc"] := "dnscmmc.dll"
dllLookup["docprop"] := "docprop.dll"
dllLookup["dot3gpui"] := "dot3gpui.dll"
dllLookup["dot3mm"] := "dot3mm.dll"
dllLookup["dot3ui"] := "dot3ui.dll"
dllLookup["dmdskres"] := "dmdskres.dll"
dllLookup["dskquoui"] := "dskquoui.dll"
dllLookup["dsprop"] := "dsprop.dll"
dllLookup["dsquery"] := "dsquery.dll"
dllLookup["dsuiext"] := "dsuiext.dll"
dllLookup["Dsui"] := "Dsui.dll"
dllLookup["DXP"] := "DXP.dll"
dllLookup["DxpTaskSync"] := "DxpTaskSync.dll"
dllLookup["eapsimextdesktop"] := "eapsimextdesktop.dll"
dllLookup["edgehtml"] := "edgehtml.dll"
dllLookup["EditionUpgradeManagerObj"] := "EditionUpgradeManagerObj.dll"
dllLookup["edputil"] := "edputil.dll"
dllLookup["efsadu"] := "efsadu.dll"
dllLookup["EhStorPwdMgr"] := "EhStorPwdMgr.dll"
dllLookup["EhStorShell"] := "EhStorShell.dll"
dllLookup["els"] := "els.dll"
dllLookup["eqossnap"] := "eqossnap.dll"
dllLookup["explorerframe"] := "explorerframe.dll"
dllLookup["Faultrep"] := "Faultrep.dll"
dllLookup["fde"] := "fde.dll"
dllLookup["fdprint"] := "fdprint.dll"
dllLookup["fhcpl"] := "fhcpl.dll"
dllLookup["filemgmt"] := "filemgmt.dll"
dllLookup["FirewallControlPanel"] := "FirewallControlPanel.dll"
dllLookup["fontext"] := "fontext.dll"
dllLookup["fvecpl"] := "fvecpl.dll"
dllLookup["fveui"] := "fveui.dll"
dllLookup["fvewiz"] := "fvewiz.dll"
dllLookup["FXSCOMPOSERES"] := "FXSCOMPOSERES.dll"
dllLookup["FXSRESM"] := "FXSRESM.dll"
dllLookup["FXSST"] := "FXSST.dll"
dllLookup["FXSUTILITY"] := "FXSUTILITY.dll"
dllLookup["gcdef"] := "gcdef.dll"
dllLookup["gpedit"] := "gpedit.dll"
dllLookup["hgcpl"] := "hgcpl.dll"
dllLookup["hnetcfg"] := "hnetcfg.dll"
dllLookup["hotplug"] := "hotplug.dll"
dllLookup["HPIMMA64"] := "HPIMMA64.dll"
dllLookup["icm32"] := "icm32.dll"
dllLookup["icsigd"] := "icsigd.dll"
dllLookup["ieframe"] := "ieframe.dll"
dllLookup["iepeers"] := "iepeers.dll"
dllLookup["iernonce"] := "iernonce.dll"
dllLookup["iesetup"] := "iesetup.dll"
dllLookup["imageres"] := "imageres.dll"
dllLookup["imagesp1"] := "imagesp1.dll"
dllLookup["inetppui"] := "inetppui.dll"
dllLookup["INETRES"] := "INETRES.dll"
dllLookup["input"] := "input.dll"
dllLookup["InputSwitch"] := "InputSwitch.dll"
dllLookup["ipsecsnp"] := "ipsecsnp.dll"
dllLookup["ipsmsnap"] := "ipsmsnap.dll"
dllLookup["iscsicpl"] := "iscsicpl.dll"
dllLookup["itss"] := "itss.dll"
dllLookup["keymgr"] := "keymgr.dll"
dllLookup["localsec"] := "localsec.dll"
dllLookup["loghours"] := "loghours.dll"
dllLookup["LogiLDA"] := "LogiLDA.DLL"
dllLookup["mapi32"] := "mapi32.dll"
dllLookup["mapistub"] := "mapistub.dll"
dllLookup["mciavi32"] := "mciavi32.dll"
dllLookup["mdminst"] := "mdminst.dll"
dllLookup["mfc100"] := "mfc100.dll"
dllLookup["mfc100u"] := "mfc100u.dll"
dllLookup["mfc110"] := "mfc110.dll"
dllLookup["mfc110u"] := "mfc110u.dll"
dllLookup["mfc120"] := "mfc120.dll"
dllLookup["mfc120u"] := "mfc120u.dll"
dllLookup["mfc140"] := "mfc140.dll"
dllLookup["mfc140u"] := "mfc140u.dll"
dllLookup["mferror"] := "mferror.dll"
dllLookup["midimap"] := "midimap.dll"
dllLookup["miguiresource"] := "miguiresource.dll"
dllLookup["mmcbase"] := "mmcbase.dll"
dllLookup["mmcndmgr"] := "mmcndmgr.dll"
dllLookup["mmcshext"] := "mmcshext.dll"
dllLookup["mmres"] := "mmres.dll"
dllLookup["modemui"] := "modemui.dll"
dllLookup["moricons"] := "moricons.dll"
dllLookup["msacm32"] := "msacm32.dll"
dllLookup["mscandui"] := "mscandui.dll"
dllLookup["mscorier"] := "mscorier.dll"
dllLookup["msctf"] := "msctf.dll"
dllLookup["msctfui"] := "msctfui.dll"
dllLookup["msctfuimanager"] := "msctfuimanager.dll"
dllLookup["mshtml"] := "mshtml.dll"
dllLookup["msi"] := "msi.dll"
dllLookup["msident"] := "msident.dll"
dllLookup["msidntld"] := "msidntld.dll"
dllLookup["msieftp"] := "msieftp.dll"
dllLookup["msihnd"] := "msihnd.dll"
dllLookup["msports"] := "msports.dll"
dllLookup["mssvp"] := "mssvp.dll"
dllLookup["mstask"] := "mstask.dll"
dllLookup["mstscax"] := "mstscax.dll"
dllLookup["msutb"] := "msutb.dll"
dllLookup["msvfw32"] := "msvfw32.dll"
dllLookup["msxml3"] := "msxml3.dll"
dllLookup["mycomput"] := "mycomput.dll"
dllLookup["mydocs"] := "mydocs.dll"
dllLookup["ndfapi"] := "ndfapi.dll"
dllLookup["netcenter"] := "netcenter.dll"
dllLookup["netcfgx"] := "netcfgx.dll"
dllLookup["netshell"] := "netshell.dll"
dllLookup["networkexplorer"] := "networkexplorer.dll"
dllLookup["netplwiz"] := "netplwiz.dll"
dllLookup["newdev"] := "newdev.dll"
dllLookup["nlmgp"] := "nlmgp.dll"
dllLookup["ntlangui2"] := "ntlangui2.dll"
dllLookup["ntshrui"] := "ntshrui.dll"
dllLookup["objsel"] := "objsel.dll"
dllLookup["occache"] := "occache.dll"
dllLookup["odbcint"] := "odbcint.dll"
dllLookup["ole32"] := "ole32.dll"
dllLookup["oleprn"] := "oleprn.dll"
dllLookup["packager"] := "packager.dll"
dllLookup["pautoenr"] := "pautoenr.dll"
dllLookup["photowiz"] := "photowiz.dll"
dllLookup["pifmgr"] := "pifmgr.dll"
dllLookup["playtomenu"] := "playtomenu.dll"
dllLookup["pnidui"] := "pnidui.dll"
dllLookup["pnpclean"] := "pnpclean.dll"
dllLookup["PortableDeviceStatus"] := "PortableDeviceStatus.dll"
dllLookup["powercpl"] := "powercpl.dll"
dllLookup["powrprof"] := "powrprof.dll"
dllLookup["printui"] := "printui.dll"
dllLookup["prnfldr"] := "prnfldr.dll"
dllLookup["prnntfy"] := "prnntfy.dll"
dllLookup["pwlauncher"] := "pwlauncher.dll"
dllLookup["quartz"] := "quartz.dll"
dllLookup["RADCUI"] := "RADCUI.dll"
dllLookup["rasdlg"] := "rasdlg.dll"
dllLookup["rasgcw"] := "rasgcw.dll"
dllLookup["RASMM"] := "RASMM.dll"
dllLookup["rastls"] := "rastls.dll"
dllLookup["rastlsext"] := "rastlsext.dll"
dllLookup["rdbui"] := "rdbui.dll"
dllLookup["remotepg"] := "remotepg.dll"
dllLookup["sberes"] := "sberes.dll"
dllLookup["scansetting"] := "scansetting.dll"
dllLookup["SCardDlg"] := "SCardDlg.dll"
dllLookup["scavengeui"] := "scavengeui.dll"
dllLookup["scksp"] := "scksp.dll"
dllLookup["scrobj"] := "scrobj.dll"
dllLookup["sdcpl"] := "sdcpl.dll"
dllLookup["sdhcinst"] := "sdhcinst.dll"
dllLookup["SearchFolder"] := "SearchFolder.dll"
dllLookup["SecurityHealthAgent"] := "SecurityHealthAgent.dll"
dllLookup["SecurityHealthSSO"] := "SecurityHealthSSO.dll"
dllLookup["SEFSN64"] := "SEFSN64.dll"
dllLookup["SEHDHF64"] := "SEHDHF64.dll"
dllLookup["SEHDRA64"] := "SEHDRA64.dll"
dllLookup["sendmail"] := "sendmail.dll"
dllLookup["sensorscpl"] := "sensorscpl.dll"
dllLookup["SettingsHandlers_StorageSense"] := "SettingsHandlers_StorageSense.dll"
dllLookup["setupapi"] := "setupapi.dll"
dllLookup["setupcln"] := "setupcln.dll"
dllLookup["shdocvw"] := "shdocvw.dll"
dllLookup["Shell32"] := "shell32.dll"
dllLookup["shlwapi"] := "shlwapi.dll"
dllLookup["shutdownux"] := "shutdownux.dll"
dllLookup["shwebsvc"] := "shwebsvc.dll"
dllLookup["sndvolsso"] := "sndvolsso.dll"
dllLookup["SndVolSSO"] := "SndVolSSO.dll"
dllLookup["softkbd"] := "softkbd.dll"
dllLookup["SpaceControl"] := "SpaceControl.dll"
dllLookup["sppcomapi"] := "sppcomapi.dll"
dllLookup["sppcommdlg"] := "sppcommdlg.dll"
dllLookup["srchadmin"] := "srchadmin.dll"
dllLookup["srcore"] := "srcore.dll"
dllLookup["srrstr"] := "srrstr.dll"
dllLookup["sti"] := "sti.dll"
dllLookup["sti_ci"] := "sti_ci.dll"
dllLookup["stobject"] := "stobject.dll"
dllLookup["sud"] := "sud.dll"
dllLookup["SyncCenter"] := "SyncCenter.dll"
dllLookup["sysclass"] := "sysclass.dll"
dllLookup["SysFxUI"] := "SysFxUI.dll"
dllLookup["Tabbtn"] := "Tabbtn.dll"
dllLookup["tapisrv"] := "tapisrv.dll"
dllLookup["tapiui"] := "tapiui.dll"
dllLookup["taskbarcpl"] := "taskbarcpl.dll"
dllLookup["tcpipcfg"] := "tcpipcfg.dll"
dllLookup["themecpl"] := "themecpl.dll"
dllLookup["themeui"] := "themeui.dll"
dllLookup["tpmcompc"] := "tpmcompc.dll"
dllLookup["TSWorkspace"] := "TSWorkspace.dll"
dllLookup["TtlsExt"] := "TtlsExt.dll"
dllLookup["twinui"] := "twinui.dll"
dllLookup["twext"] := "twext.dll"
dllLookup["uireng"] := "uireng.dll"
dllLookup["UIRibbonRes"] := "UIRibbonRes.dll"
dllLookup["umrdp"] := "umrdp.dll"
dllLookup["url"] := "url.dll"
dllLookup["urlmon"] := "urlmon.dll"
dllLookup["usbui"] := "usbui.dll"
dllLookup["UserAccountControlSettings"] := "UserAccountControlSettings.dll"
dllLookup["usercpl"] := "usercpl.dll"
dllLookup["user32"] := "user32.dll"
dllLookup["uxtheme"] := "uxtheme.dll"
dllLookup["VAN"] := "VAN.dll"
dllLookup["Vault"] := "Vault.dll"
dllLookup["vfwwdm32"] := "vfwwdm32.dll"
dllLookup["wcnwiz"] := "wcnwiz.dll"
dllLookup["wdc"] := "wdc.dll"
dllLookup["webcheck"] := "webcheck.dll"
dllLookup["werconcpl"] := "werconcpl.dll"
dllLookup["werui"] := "werui.dll"
dllLookup["WFSR"] := "WFSR.dll"
dllLookup["wiashext"] := "wiashext.dll"
dllLookup["wiaaut"] := "wiaaut.dll"
dllLookup["wiadefui"] := "wiadefui.dll"
dllLookup["wincredui"] := "wincredui.dll"
dllLookup["Windows_Storage_Search"] := "Windows.Storage.Search.dll"
dllLookup["Windows_UI_CredDialogController"] := "Windows.UI.CredDialogController.dll"
dllLookup["wininetlui"] := "wininetlui.dll"
dllLookup["winmm"] := "winmm.dll"
dllLookup["winsrv"] := "winsrv.dll"
dllLookup["wintrust"] := "wintrust.dll"
dllLookup["wlangpui"] := "wlangpui.dll"
dllLookup["WlanMM"] := "WlanMM.dll"
dllLookup["wlanpref"] := "wlanpref.dll"
dllLookup["wlanui"] := "wlanui.dll"
dllLookup["wlidcli"] := "wlidcli.dll"
dllLookup["wmploc"] := "wmploc.dll"
dllLookup["wmp"] := "wmp.dll"
dllLookup["WMPhoto"] := "WMPhoto.dll"
dllLookup["WorkfoldersControl"] := "WorkfoldersControl.dll"
dllLookup["WorkFoldersRes"] := "WorkFoldersRes.dll"
dllLookup["wpd_ci"] := "wpd_ci.dll"
dllLookup["wpdshext"] := "wpdshext.dll"
dllLookup["wsecedit"] := "wsecedit.dll"
dllLookup["wuapi"] := "wuapi.dll"
dllLookup["wwanmm"] := "wwanmm.dll"
dllLookup["xwizards"] := "xwizards.dll"
dllLookup["zipfldr"] := "zipfldr.dll"


;;∙======∙SETTINGS∙=============∙
;;∙------∙Gui Configurations.
global GWidth := "330", GHeight := "700"    ;;∙------∙Gui width and height. 
global GXpos := "1400", GYpos := "100"    ;;∙------∙Gui x-axis & y-axis (left blank will center to screen).

global GColor := "212223", TColor := "006FDE"    ;;∙------∙Gui and Gui text colors.

;;∙------∙Reload & Exit Buttons.
global ButtonBgColor1 := "0B0B0B", ButtonBgColor2 := "0B0B0B"    ;;∙------∙Button background colors.
global ButtonTextColor1 := "01A70B", ButtonTextColor2 := "A7010B"    ;;∙------∙Button text colors.

;;∙------∙ListViews.
global LVTextColor1 := "8FC1E2", LVTextColor2 := "8FC1E2"    ;;∙------∙Listview text colors.
global LVBgColor1 := "676767", LVBgColor2 := "676767"    ;;∙------∙Listview background colors.


;;∙======∙GUI CREATION∙=========∙
CreateGui:
    Gui, Destroy
    Gui, +AlwaysOnTop -Caption +Border +Owner
    Gui, Color, %GColor%
    Gui, Font, s10 c%TColor%

    Gui, Add, ListView, x20 y20 w135 h540 gListClick Background%LVBgColor1% c%LVTextColor1%, Big Icons

    ImageListID := IL_Create(Count,,1)
    LV_SetImageList(ImageListID,1)
    Loop, % Count
        IL_Add(ImageListID, File, A_Index)
    Loop, % Count
        LV_Add("Icon" A_Index, "     -     " A_Index, 2)
    LV_ModifyCol(1, 115)

    Gui, Add, ListView, x175 y20 w135 h540 gListClick Background%LVBgColor2% c%LVTextColor2%, Small Icons

    ImageListID_small := IL_Create(Count)
    LV_SetImageList(ImageListID_small)
    Loop, % Count
        IL_Add(ImageListID_small, File, A_Index)
    Loop, % Count
        LV_Add("Icon" A_Index, "     -     " A_Index, 2)
    LV_ModifyCol(1, 115)
    dllNames := []
    for name in dllLookup
        dllNames.Push(name)
    Sort, dllNames

    Gui, Add, DropDownList, x25 y570 w280 vSelectedDLL gDLLSelected, % " Select a DLL file   (default = shell32.dll) ||" JoinArray(dllNames, "|")

    if (File != "shell32.dll")
    {
        for name, dll in dllLookup
            if (dll = File)
                GuiControl, ChooseString, SelectedDLL, %name%
    }
    Gui, Add, Edit, x30 y600 w270 h25 vFilePathDisplay -VScroll ReadOnly, %A_Space% %A_WinDir%\system32\%File%
    Gui, Font, s8
    Gui, Add, Text, x40 yp+30 cGray BackgroundTrans, Path copied to clipboard when icon is double-clicked
    Gui, Font, s10


;;∙======∙BUTTONS∙=============∙
    Gui, Font, s10 BOLD, CALIBRI

    ButtonBgColor1 := "black", ButtonTextColor1 := "Lime"
    Gui, Add, Progress, x80 y650 w65 h25 Disabled Background%ButtonBgColor%
    Gui, Add, Text, xp yp wp hp c%ButtonTextColor1% HwndhText BackgroundTrans Center 0x200 0x00800000 gRELOAD, RELOAD
        GuiTip(hText, "RELOAD")

    Gui, Add, Picture, x152 y650 HwndhText gDlabel BackgroundTrans w26 h26 Icon160, shell32.dll
        GuiTip(hText, "DRAGGABLE")

    ButtonBgColor2 := "black", ButtonTextColor2 := "Red"
    Gui, Add, Progress, x185 y650 w65 h25 Disabled Background%ButtonBgColor%
    Gui, Add, Text, xp yp wp hp c%ButtonTextColor2% HwndhText BackgroundTrans Center 0x200 0x00800000 gEXIT, EXIT
        GuiTip(hText, "EXIT")

if (GXpos = "" || GYpos = "")
    ShowCommand := "w" GWidth " h" GHeight " Center"
else
    ShowCommand := "w" GWidth " h" GHeight " x" GXpos " y" GYpos
Gui, Show, %ShowCommand%, DLL Icons Viewer
Return


;;∙======∙DDL SELECTION∙========∙
DLLSelected:
    Gui, Submit, NoHide
    if (SelectedDLL = "Select a DLL file")
        return
    File := dllLookup[SelectedDLL] ? dllLookup[SelectedDLL] : "shell32.dll"
    GuiControl, ChooseString, SelectedDLL, %SelectedDLL%
    GuiControl,, FilePathDisplay, %A_WinDir%\system32\%File%
    Gosub, CreateGui
Return


;;∙======∙LISTVIEW∙=============∙
ListClick()
{
    if (A_GuiEvent = "DoubleClick")
    {
        Clipboard := A_WinDir "\system32\" File ", " A_EventInfo
        ToolTip % "Copied To The Clipboard"
        SetTimer, KillTip, -1500
    }
    GuiControl,, FilePathDisplay, %A_WinDir%\system32\%File%, %A_EventInfo%
}

KillTip:
    ToolTip
    SetTimer, KillTip, Off
Return


;;∙======∙HELPER∙===============∙
JoinArray(arr, delimiter) {
    for index, value in arr
        result .= (A_Index = 1 ? "" : delimiter) . value
    return result
}


;;∙======∙MOUSE WHEEL∙========∙
#IfWinActive ahk_class AutoHotkeyGUI
WheelDown::
    ControlClick, SysListView321, ,, WD, 1
    ControlClick, SysListView322, ,, WD, 1
Return

WheelUp::
    ControlClick, SysListView321, ,, WU, 1
    ControlClick, SysListView322, ,, WU, 1
Return
#IfWinActive


;;∙======∙TOOLTIP∙==============∙
GuiTip(hCtrl, text := "")
{
    hGui := text != "" ? DllCall("GetParent", "Ptr", hCtrl) : hCtrl
    static hTip := 0    ;;∙------∙Initialize as 0.

    if (hTip && !DllCall("IsWindow", "Ptr", hTip))
        hTip := 0

    if !hTip
    {
        hTip := DllCall("CreateWindowEx", "UInt", 0x8, "Str", "tooltips_class32"
            , "Ptr", 0, "UInt", 0x80000002
            , "Int", 0x80000000, "Int", 0x80000000, "Int", 0x80000000, "Int", 0x80000000
            , "Ptr", hGui, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Ptr")
        DllCall("SendMessage", "Ptr", hTip, "Int", 0x0418, "Ptr", 0, "Ptr", 0)
        if (A_OsVersion == "WIN_XP")
            GuiTip(hGui)
    }

    static sizeof_TOOLINFO := 24 + (6 * A_PtrSize)
    VarSetCapacity(TOOLINFO, sizeof_TOOLINFO, 0)
    NumPut(sizeof_TOOLINFO, TOOLINFO, 0, "UInt")
    NumPut(0x11, TOOLINFO, 4, "UInt")
    NumPut(hGui, TOOLINFO, 8, "Ptr")
    NumPut(hCtrl, TOOLINFO, 8 + A_PtrSize, "Ptr")
    NumPut(&text, TOOLINFO, 24 + (3 * A_PtrSize), "Ptr")

    static TTM_ADDTOOL := A_IsUnicode ? 0x0432 : 0x0404
    return DllCall("SendMessage", "Ptr", hTip, "Int", TTM_ADDTOOL, "Ptr", 0, "Ptr", &TOOLINFO)
}


;;∙======∙DRAG VISUAL∙=========∙
Dlabel:    ;;∙-------∙Drag Visual Indicator.
Return


;;∙======∙GUI DRAG∙============∙
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
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
    RELOAD:    ;;∙------∙Button Call.
        Soundbeep, 1200, 250
    Reload
Return

 ;;∙------∙EXIT∙----------------------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
    EXIT:    ;;∙------∙Button Call.
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
Menu, Tray, Add, Suspend / Pause, % ScriptID    ;;∙------∙Script Header.
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
DLL_Icons_Viewer:    ;;∙------∙Suspends hotkeys then pauses script.
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

