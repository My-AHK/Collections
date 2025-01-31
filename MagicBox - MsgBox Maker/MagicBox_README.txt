﻿
================
MagicBox v1.0.4
============================================= 
Author:  Alguimist
SOURCE :  https://www.autohotkey.com/boards/viewtopic.php?f=6&t=20983&hilit=MagicBox
============================================= 
--------------------------- SEE ALSO --------------------------- 
------- InputBoxEx -------
Found At :  https://www.autohotkey.com/boards/viewtopic.php?f=6&t=20983&hilit=MagicBox#p114109

Download From:  https://sourceforge.net/projects/magicbox-factory/
------------------------------------------------------------------- 


============================================= 
============================================= 
MagicBox is a development tool to assist in the creation of message boxes.


"Message boxes provide a simple, standardised method to display information, warnings and errors to the user. They can also be used to ask simple questions and to request confirmation of actions."

    The Windows API has many message box functions, MessageBox being the most commonly used, and MagicBox is able to generate the code for a variety of such functions, including task dialogs.

============================================= 

MsgBoxEx
--------
Custom message box function. It offers custom buttons and icon, support for hyperlinks, verification text, font and color, callback and the look and feel of a regular message box.

Parameters: Text [, Title, Buttons, Icon, ByRef CheckText, Styles, Owner, Timeout, FontOptions, FontName, BGColor, Callback]

============================================= 

MsgBox
------
The MsgBox function displays a message box and waits for the user to click a button and then an action is performed based on the button clicked by the user. This is a generic description valid for any type of message box.

Parameters:
MsgBox, Text
MsgBox [, Options, Title, Text, Timeout]

Extended options: custom button text, icons and position.

============================================= 

SHMessageBoxCheck
-----------------
Displays a message box that gives the user the option of suppressing further occurrences. If the user has already opted to suppress the message box, the function does not display a dialog box and instead simply returns the default value.

This function supports only a subset of the flags supported by MessageBox. The question mark icon and the "always on top" option are not available on Windows Vista and higher.

The unique ID is stored in a registry key.

Parameters: Text [, Title, Options, RegVal, Owner]

============================================= 

MessageBoxIndirect
------------------
Creates, displays, and operates a message box. The message box contains application-defined message text and title, any icon, and any combination of predefined push buttons.

Parameters: Text [, Title, Options, IconRes, IconID, Owner]

============================================= 

SoftModalMessageBox
-------------------
SoftModalMessageBox encompasses functions like MessageBox, MessageBoxTimeout and MessageBoxIndirect. Up to 10 buttons can be defined.

Parameters: Text, Title, Buttons [, DefBtn, Options, IconRes, IconID, Timeout, Owner, Callback]

============================================= 

MsiMessageBox
-------------
Little is known about this function.

Parameters: Text [, Title, Options, Owner]

============================================= 

WTSSendMessage (WinStationSendMessage)
--------------------------------------
This function can be used to display a message box from a service or on the client desktop of a specified Remote Desktop Services session. Always on top, no owner, no focus and no theme.

Parameters: Text [, Title, Options, Timeout, Wait, Session, Server, ByRef Response]

============================================= 

TaskDialog
----------
Displays a simple task dialog that contains application-defined message text and title, an icon, and any combination of predefined push buttons.

Parameters: Instruction [, Content, Title, Buttons, IconID, IconRes, Owner]

============================================= 

TaskDialogIndirect
------------------
The TaskDialogIndirect function creates, displays, and operates a task dialog. The task dialog contains application-defined icons, messages, title, verification check box, command links, push buttons, and radio buttons. This function can register a callback function to receive notification messages.

The code for this function is generated "on demand": only the necessary members of the TASKDIALOGCONFIG structure are defined.

Sample scripts demonstrating TaskDialogIndirect and MagicBox can be found in the Examples folder.

============================================= 

More functions
--------------
The following functions are included in the functions folder, but MagicBox does not generate the code for them:

InputBoxEx
----------
The InputBoxEx function allows the user to enter input value. The type of input control used by this function can be specified so that the input can be made by means of a ComboBox or DropDownList, a ListBox, a CheckBox, a calendar (DateTime or MonthCal), a Hotkey box, a Slider. By default, an Edit box is used.

Parameters: [Instruction, Content, Title, Default, ControlType, ControlOptions, Owner, Width, Pos, Icon, IconIndex, WindowOptions, Timeout]

Instruction: Text in a bigger font size to explain the user's objective with the dialog box.
Content: Descriptive information, additional details. Hyperlinks can be used.
Title: Title of the window.
Default: Initial text of the input control.
ControlType: The type of the input control.
ControlOptions: Options of the input control. For example: "r3" (3 rows), "number", "password", "checked".
Owner: Handle of the parent window.
Width: Optional width of the window. Height is adjusted automatically.
Pos: X and Y Coordinates. If blank or omitted, the window is centered on the screen. Example: "x100 y100".
Icon and IconIndex: Icon displayed in the title bar.
WindowOptions: Options such as "MinimizeBox", "AlwaysOnTop" and "-SysMenu".
Timeout: Time (in seconds) after which the window is automatically closed.

The return value is the string or value selected, according to the control type. ErrorLevel is set as follows: 0 - The user pressed OK. 1 - The user pressed the Cancel button. 2 - InputBoxEx exited due to timeout.

Example:
RetVal := InputBoxEx("Instruction", "Content", "Title", "Item 1||Item 2", "DDL", "", WinExist("A"), "", "", "shell32.dll", 4, "AlwaysOnTop")
If (!ErrorLevel) {
    MsgBox % RetVal
}

TaskDialogEx
------------
Parameters: Instruction [, Content, Title, CustomButtons, CommonButtons, MainIcon, Flags, Owner, VerificationText, ExpandedText, FooterText, FooterIcon, Width]

The CustomButtons parameter is a pipe-delimited list of button labels that can be displayed as command links provided the flag 0x10 or 0x20.

ShellMessageBox
---------------
This function uses MessageBox on Windows XP and TaskDialog on Vista+.

Parameters: Text [, Title, Options, Owner]

MessageBox
----------
The same as MsgBox.

Parameters: hWnd, Text [, Title, Flags]

MessageBoxTimeout
-----------------
Parameters: hWnd, Text [, Title, Flags, Milliseconds]

FatalAppExit
------------
Parameters: Message

ShellAbout
----------
Parameters: [hWnd, AppName, Message, hIcon]

============================================= 

Return value
------------
MagicBox can optionally generate the conditional statements for the return value (the "ifs"). For most types of message box it is one of the following values: OK, Cancel, Abort, Retry, Ignore, Yes, No, Try Again, Continue and Timeout.

For SoftModalMessageBox and TaskDialogIndirect, the return value is the button ID.

For MsgBoxEx, the return value is the button text with ampersands removed. If the window is dismissed with the close button in the title bar or by pressing the Esc key, the value is Cancel.

============================================= 

Keyboard shortcuts
------------------
 - F1: Help (MSDN links).
 - F9: Displays the message box.
 - F10: Opens the code window.
 - Alt+F9: Displays the message box in a new instance of AHK.
 - Ctrl+F9: Runs the script from the code window.

============================================= 

Limitations on Windows XP
-------------------------
 - Task dialog functions require Windows Vista or higher.
 - MsgBox custom button: icon is not supported.
 - SHMessageBoxCheck: only the combinations of buttons OK, OK|Cancel and Yes|No are available.
 - MsiMessageBox: the font size is microscopic on Windows XP.

============================================= 

Credits to:
-----------
 - Lexicos, for the function ResourceIdOfIcon.
 - TheGood, for task dialog examples.
 - just_me, for additional task dialog options via callback.
 - A guest, for MsgBoxV2.
 - Fanatic Guru, for MsgBox_XY.
 - Authors of libraries in use.
 - The layout of the custom buttons dialog is based on TDXML Editor².

============================================= 

Reference
---------
1. http://www.blackwasp.co.uk/MessageBox.aspx
2. http://www.codeproject.com/Articles/18065/TDXML

============================================= 

License
-------
No portion of MagicBox or any code derived from it can be used in any software that is sold/licensed commercially, except when otherwise noted.

============================================= 

Requirements
------------
AutoHotkey 1.1.23 or higher, Unicode, 32 or 64-bit. Tested on Windows XP, 7 and 10.
