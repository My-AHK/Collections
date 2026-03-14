
;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance Force

SendMode, Input
SetBatchLines -1
SetWinDelay 0
SetWorkingDir %A_ScriptDir%
Menu, Tray, Icon, shell32.dll, 245

;;∙--------------------------------------------------∙
^t::    ;;∙------∙🔥∙(Ctrl + T)

;;∙======∙CONFIGURATION PATH.
ConfigFile := A_ScriptDir "\SecureLogin.ini"    ;;∙------∙Path where the encrypted password will be stored.

;;∙======∙ENTROPY KEY (Used by DPAPI: *Change this to anything unique for your script*).
;;∙------∙Changing entropy key after passwords are created will permanently break decryption!
EntropyKey := "MyEntropyKey_123"    ;;∙------∙Used by DPAPI to strengthen encryption.

;;∙======∙INITIALIZE PASSWORD STORE.
IniRead, StoredPasswordBlob, %ConfigFile%, Security, PasswordBlob, %A_Space%    ;;∙------∙Attempt to read stored encrypted password.

if (StoredPasswordBlob = "" || StoredPasswordBlob = "ERROR")    ;;∙------∙If no password exists yet, force user to create one.
{
    Gui, MsgGui:New, , Notice
    Gui, MsgGui:Color, fdffa3
    Gui, MsgGui:Font, S10 c000000, Segoe UI
    Gui, MsgGui:Add, Text, x0 y10 w180 Center, Please Create A Password
    Gui, MsgGui:Add, Button, x60 y+8 w60 h25 gMsgGuiOK Default, OK
    Gui, MsgGui:Show, w180 h70
    WinWaitClose, Notice

    ;;∙------∙Custom password creation dialog with view button.
    Gui, New, , Create Password
    Gui, Color, Silver
    Gui, Font, S10 c000000, Segoe UI
    Gui, Add, Text, x10 y10, Enter new password:
    Gui, Add, Edit, w150 h25 vNewPasswordField Password
    Gui, Add, Button, x+5 w40 h25 gToggleCreateView, View
    Gui, Add, Button, x105 y+5 w55 h25 gCancelCreate, Cancel
    Gui, Add, Button, x+5 w40 h25 gSubmitCreate Default, OK
    Gui, Show, w215 h100

    WinWaitClose, Create Password
    if (CreateCancelled = 1)
        ExitApp

    PasswordHash := SHA256(NewPasswordField)    ;;∙------∙Hash password using SHA256 so raw password is never stored.

    PasswordBlob := DPAPI_Encrypt(PasswordHash, EntropyKey)    ;;∙------∙Encrypt hash using Windows DPAPI.

    IniWrite, %PasswordBlob%, %ConfigFile%, Security, PasswordBlob    ;;∙------∙Store encrypted hash inside INI file.
;;    FileSetAttrib, -H, %ConfigFile%    ;;<∙------∙Sets ini file properties attribute to 'Hidden'.

    Gui, MsgGui:New, , Notice
    Gui, MsgGui:Color, a0feef
    Gui, MsgGui:Font, S10 c000000, Segoe UI
    Gui, MsgGui:Add, Text, x0 y10 w180 Center, Password Created
    Gui, MsgGui:Add, Button, x60 y+8 w60 h25 gMsgGuiOK Default, OK
    Gui, MsgGui:Show, w180 h70
    WinWaitClose, Notice

    ExitApp    ;;∙------∙Exit so user must relaunch to test login.
}

;;∙======∙LOGIN TEST.
;;∙------∙Custom login dialog with view button.
Gui, New, , Login Required
Gui, Color, Silver
Gui, Font, S10 c000000, Segoe UI
Gui, Add, Text, x10 y10, Enter password:
Gui, Add, Edit, x10 w150 h25 vTestPasswordField Password
Gui, Add, Button, x+5 w40 h25 gToggleLoginView, View
Gui, Add, Button, x105 y+10 w55 h25 gCancelLogin, Cancel
Gui, Add, Button, x+5 w40 h25 gSubmitLogin Default, OK
Gui, Font, S8
Gui, Add, Button, x155 y5 w50 h20 gChangePassword, Change
Gui, Show, w215 h100

WinWaitClose, Login Required
if (LoginCancelled = 1)
    ExitApp
if (ChangePasswordRequested = 1)
{
    ChangePasswordRequested := 0
    GoSub, DoChangePassword
    ExitApp
}

EnteredHash := SHA256(TestPasswordField)    ;;∙------∙Hash entered password for comparison.
DecryptedHash := DPAPI_Decrypt(StoredPasswordBlob, EntropyKey)    ;;∙------∙Decrypt stored password hash.

if (EnteredHash = DecryptedHash)    ;;∙------∙Compare hashes.
{
    Gui, MsgGui:New, , Notice
    Gui, MsgGui:Color, a0feef
    Gui, MsgGui:Font, S10 c000000, Segoe UI
    Gui, MsgGui:Add, Text, x0 y10 w180 Center, Access Granted
    Gui, MsgGui:Add, Button, x60 y+8 w60 h25 gMsgGuiOK Default, OK
    Gui, MsgGui:Show, w180 h70
    WinWaitClose, Notice

GoSub, LaunchSimpleInputForm    ;;<<∙------∙(*EXAMPLE: Runs only after successful login*)
    }
    else
    {
        Gui, MsgGui:New, , Notice
        Gui, MsgGui:Color, ffa5a7
        Gui, MsgGui:Font, S10 c000000, Segoe UI
        Gui, MsgGui:Add, Text, x0 y10 w180 Center, Access Denied
        Gui, MsgGui:Add, Button, x60 y+8 w60 h25 gMsgGuiOK, OK
        Gui, MsgGui:Show, w180 h70
        WinWaitClose, Notice
    }
Return


;;∙======================================================∙
;;∙======================================================∙
;;∙======∙SIMPLE INPUT FORM EXAMPLE.
;;∙------∙https://www.autohotkey.com/docs/v1/lib/Gui.htm#ExInputBox
LaunchSimpleInputForm:
    Gui, InputForm:New, , Simple Input Example
    Gui, InputForm:Add, Text,, First name:
    Gui, InputForm:Add, Text,, Last name:
    Gui, InputForm:Add, Edit, vFirstName ym
    Gui, InputForm:Add, Edit, vLastName
    Gui, InputForm:Add, Button, default gInputFormOK, OK
    Gui, InputForm:Show
Return

InputFormOK:
InputFormClose:
    Gui, InputForm:Submit
    MsgBox, You entered "%FirstName% %LastName%".
    ExitApp
;;∙======================================================∙
;;∙======================================================∙


;;∙======∙MSGGUI OK HANDLER.
MsgGuiOK:
    Gui, MsgGui:Destroy
Return

;;∙======∙GUI SUBROUTINES FOR PASSWORD CREATION
ToggleCreateView:
    GuiControlGet, NewPasswordField
    if (ShowCreatePassword = 1)
    {
        GuiControl, +Password, NewPasswordField
        ShowCreatePassword := 0
    }
    else
    {
        GuiControl, -Password, NewPasswordField
        ShowCreatePassword := 1
    }
    GuiControl, , NewPasswordField, %NewPasswordField%
Return

SubmitCreate:
    Gui, Submit
    CreateCancelled := 0
Return

CancelCreate:
    Gui, Destroy
    CreateCancelled := 1
Return

;;∙======∙GUI SUBROUTINES FOR LOGIN.
ToggleLoginView:
    GuiControlGet, TestPasswordField
    if (ShowLoginPassword = 1)
    {
        GuiControl, +Password, TestPasswordField
        ShowLoginPassword := 0
    }
    else
    {
        GuiControl, -Password, TestPasswordField
        ShowLoginPassword := 1
    }
    GuiControl, , TestPasswordField, %TestPasswordField%
Return

SubmitLogin:
    Gui, Submit
    LoginCancelled := 0
Return

CancelLogin:
    Gui, Destroy
    LoginCancelled := 1
Return

ChangePassword:
    Gui, Destroy
    ChangePasswordRequested := 1
Return

;;∙======∙CHANGE PASSWORD FLOW.
DoChangePassword:

;;∙------∙Verify current password first.
Gui, New, , Verify Current Password
Gui, Color, fdffa3
Gui, Font, S10 c000000, Segoe UI
Gui, Add, Text, x10 y10, Enter current password:
Gui, Add, Edit, x10 w150 h25 vVerifyPasswordField Password
Gui, Add, Button, x+5 w40 h25 gToggleVerifyView, View
Gui, Add, Button, x105 y+5 w55 h25 gCancelVerify, Cancel
Gui, Add, Button, x+5 w40 h25 gSubmitVerify Default, OK
Gui, Show, w215 h100

WinWaitClose, Verify Current Password
if (VerifyCancelled = 1)
    Return

EnteredHash := SHA256(VerifyPasswordField)
DecryptedHash := DPAPI_Decrypt(StoredPasswordBlob, EntropyKey)

if (EnteredHash != DecryptedHash)
{
    Gui, MsgGui:New, , Notice
    Gui, MsgGui:Color, ffa5a7
    Gui, MsgGui:Font, S10 c000000, Segoe UI
    Gui, MsgGui:Add, Text, x0 y10 w180 Center, Incorrect Password`nChange Aborted
    Gui, MsgGui:Add, Button, x50 y+8 w80 h25 gMsgGuiOK, OK
    Gui, MsgGui:Show, w180 h90
    WinWaitClose, Notice
    Return
}

;;∙------∙Create new password.
Gui, New, , Create New Password
Gui, Color, Silver
Gui, Font, S10 c000000, Segoe UI
Gui, Add, Text, x10 y10, Enter new password:
Gui, Add, Edit, x10 w150 h25 vNewChangePasswordField Password
Gui, Add, Button, x+5 w40 h25 gToggleChangeView, View
Gui, Add, Button, x105 y+5 w55 h25 gCancelChange, Cancel
Gui, Add, Button, x+5 w40 h25 gSubmitChange Default, OK
Gui, Show, w215 h100

WinWaitClose, Create New Password
if (ChangeCancelled = 1)
    Return

NewHash := SHA256(NewChangePasswordField)
NewBlob := DPAPI_Encrypt(NewHash, EntropyKey)
IniWrite, %NewBlob%, %ConfigFile%, Security, PasswordBlob

Gui, MsgGui:New, , Notice
Gui, MsgGui:Color, a0feef
Gui, MsgGui:Font, S10 c000000, Segoe UI
Gui, MsgGui:Add, Text, x0 y10 w180 Center, Password Changed
Gui, MsgGui:Add, Button, x50 y+8 w80 h25 gMsgGuiOK Default, OK
Gui, MsgGui:Show, w180 h70
WinWaitClose, Notice
Return

;;∙======∙GUI SUBROUTINES FOR VERIFY
ToggleVerifyView:
    GuiControlGet, VerifyPasswordField
    if (ShowVerifyPassword = 1)
    {
        GuiControl, +Password, VerifyPasswordField
        ShowVerifyPassword := 0
    }
    else
    {
        GuiControl, -Password, VerifyPasswordField
        ShowVerifyPassword := 1
    }
    GuiControl, , VerifyPasswordField, %VerifyPasswordField%
Return

SubmitVerify:
    Gui, Submit
    VerifyCancelled := 0
Return

CancelVerify:
    Gui, Destroy
    VerifyCancelled := 1
Return

;;∙======∙GUI SUBROUTINES FOR CHANGE
ToggleChangeView:
    GuiControlGet, NewChangePasswordField
    if (ShowChangePassword = 1)
    {
        GuiControl, +Password, NewChangePasswordField
        ShowChangePassword := 0
    }
    else
    {
        GuiControl, -Password, NewChangePasswordField
        ShowChangePassword := 1
    }
    GuiControl, , NewChangePasswordField, %NewChangePasswordField%
Return

SubmitChange:
    Gui, Submit
    ChangeCancelled := 0
Return

CancelChange:
    Gui, Destroy
    ChangeCancelled := 1
Return

;;∙======∙SHA256 HASH FUNCTION.
SHA256(string)
{
    ;;∙------∙Windows CryptoAPI handles SHA256 hashing internally.

    hProv := 0
    hHash := 0

    ;;∙------∙Acquire a cryptographic context from Windows.
    DllCall("advapi32\CryptAcquireContext"
        , "PtrP", hProv
        , "Ptr", 0
        , "Ptr", 0
        , "UInt", 24
        , "UInt", 0xF0000000)

    ;;∙------∙Create a SHA256 hash object.
    DllCall("advapi32\CryptCreateHash"
        , "Ptr", hProv
        , "UInt", 0x800C
        , "Ptr", 0
        , "UInt", 0
        , "PtrP", hHash)

    ;;∙------∙Feed the string data into the hash algorithm.
    DllCall("advapi32\CryptHashData"
        , "Ptr", hHash
        , "AStr", string
        , "UInt", StrLen(string)
        , "UInt", 0)

    ;;∙------∙Allocate memory to receive final hash value.
    VarSetCapacity(HashVal, 32, 0)
    HashLen := 32

    ;;∙------∙Retrieve the SHA256 hash bytes.
    DllCall("advapi32\CryptGetHashParam"
        , "Ptr", hHash
        , "UInt", 2
        , "Ptr", &HashVal
        , "UIntP", HashLen
        , "UInt", 0)

    ;;∙------∙Convert binary hash to readable hexadecimal string.
    Loop % HashLen
        hash .= Format("{:02X}", NumGet(HashVal, A_Index-1, "UChar"))

    ;;∙------∙Release cryptographic resources.
    DllCall("advapi32\CryptDestroyHash", "Ptr", hHash)
    DllCall("advapi32\CryptReleaseContext", "Ptr", hProv, "UInt", 0)

    return hash
}

;;∙======∙DPAPI ENCRYPT WITH ENTROPY.
DPAPI_Encrypt(data, entropy)
{
    ;;∙------∙DPAPI ties encryption to the Windows user account.
    ;;∙------∙Only the same user on the same machine can decrypt it.

    VarSetCapacity(binaryData, StrPut(data, "UTF-8"))
    size := StrPut(data, &binaryData, "UTF-8") - 1

    ;;∙------∙Prepare entropy blob (additional secret).
    VarSetCapacity(entropyData, StrPut(entropy, "UTF-8"))
    entropySize := StrPut(entropy, &entropyData, "UTF-8") - 1

    ;;∙------∙Create DATA_BLOB structure for input data.
    VarSetCapacity(dataIn, 16, 0)
    NumPut(size, dataIn, 0, "UInt")
    NumPut(&binaryData, dataIn, 8, "Ptr")

    ;;∙------∙Create DATA_BLOB structure for entropy.
    VarSetCapacity(entropyBlob, 16, 0)
    NumPut(entropySize, entropyBlob, 0, "UInt")
    NumPut(&entropyData, entropyBlob, 8, "Ptr")

    VarSetCapacity(dataOut, 16, 0)

    ;;∙------∙Call Windows DPAPI encryption.
    DllCall("Crypt32\CryptProtectData"
        , "Ptr", &dataIn
        , "Ptr", 0
        , "Ptr", &entropyBlob
        , "Ptr", 0
        , "Ptr", 0
        , "UInt", 0
        , "Ptr", &dataOut)

    ;;∙------∙Retrieve encrypted binary result.
    encSize := NumGet(dataOut, 0, "UInt")
    encPtr := NumGet(dataOut, 8, "Ptr")

    ;;∙------∙Convert encrypted bytes into Base64 so it can be stored in text files.
    base64 := BinaryToBase64(encPtr, encSize)

    ;;∙------∙Free memory allocated by Windows.
    DllCall("LocalFree", "Ptr", encPtr)

    return base64
}

;;∙======∙DPAPI DECRYPT WITH ENTROPY.
DPAPI_Decrypt(base64, entropy)
{
    ;;∙------∙Convert Base64 string back into encrypted binary.
    encSize := Base64ToBinary(base64, encData)

    ;;∙------∙Recreate entropy blob.
    VarSetCapacity(entropyData, StrPut(entropy, "UTF-8"))
    entropySize := StrPut(entropy, &entropyData, "UTF-8") - 1

    VarSetCapacity(dataIn, 16, 0)
    NumPut(encSize, dataIn, 0, "UInt")
    NumPut(&encData, dataIn, 8, "Ptr")

    VarSetCapacity(entropyBlob, 16, 0)
    NumPut(entropySize, entropyBlob, 0, "UInt")
    NumPut(&entropyData, entropyBlob, 8, "Ptr")

    VarSetCapacity(dataOut, 16, 0)

    ;;∙------∙Call Windows DPAPI decryption.
    DllCall("Crypt32\CryptUnprotectData"
        , "Ptr", &dataIn
        , "Ptr", 0
        , "Ptr", &entropyBlob
        , "Ptr", 0
        , "Ptr", 0
        , "UInt", 0
        , "Ptr", &dataOut)

    ;;∙------∙Retrieve decrypted bytes.
    decSize := NumGet(dataOut, 0, "UInt")
    decPtr := NumGet(dataOut, 8, "Ptr")

    ;;∙------∙Convert decrypted UTF-8 bytes back into text.
    text := StrGet(decPtr, decSize, "UTF-8")

    DllCall("LocalFree", "Ptr", decPtr)

    return text
}

;;∙======∙BASE64 UTILITIES.
BinaryToBase64(ptr, size)
{    ;;∙------∙Convert binary data into Base64 string for storage.

    flags := 0x40000001
    req := 0

    DllCall("Crypt32\CryptBinaryToString", "Ptr", ptr, "UInt", size, "UInt", flags, "Ptr", 0, "UIntP", req)

    VarSetCapacity(buf, req * 2)

    DllCall("Crypt32\CryptBinaryToString", "Ptr", ptr, "UInt", size, "UInt", flags, "Str", buf, "UIntP", req)

    return buf
}

Base64ToBinary(base64, ByRef bin)
{    ;;∙------∙Convert Base64 text back into binary data.

    flags := 1
    req := 0

    DllCall("Crypt32\CryptStringToBinary", "Str", base64, "UInt", 0, "UInt", flags, "Ptr", 0, "UIntP", req, "Ptr", 0, "Ptr", 0)

    VarSetCapacity(bin, req)

    DllCall("Crypt32\CryptStringToBinary", "Str", base64, "UInt", 0, "UInt", flags, "Ptr", &bin, "UIntP", req, "Ptr", 0, "Ptr", 0)

    return req
}
Return
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙