
/*∙=====∙NOTES∙===============================================∙
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
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "TEMPLATE"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙🔥 HotKey 🔥∙===========================================∙
^t::    ;;∙------∙(Ctrl+T) 
    Soundbeep, 1000, 200
;;∙============================================================∙




;;∙============================================================∙
;;∙============================================================∙
;;∙------------∙START OF CONFIG SECTION∙-----------------------∙
#MaxHotkeysPerInterval 500
#SingleInstance force

/*∙-----------------------------------------------------------∙
    Using the keyboard hook to implement the Numpad hotkeys
    prevents them from interfering with the generation of ANSI
    characters such as à. This is because AutoHotkey generates
    such characters by holding down ALT and sending a series of
    Numpad keystrokes. Hook hotkeys are smart enough to ignore
    such keystrokes.
∙-----------------------------------------------------------∙*/

#UseHook

MouseSpeed = 1
MouseAccelerationSpeed = 1
MouseMaxSpeed = 5

/*∙-----------------------------------------------------------∙
    Mouse wheel speed is also set on Control Panel. As that
    will affect normal mouse behavior, the real speed of these
    three below are (x)times normal MouseWheel speed.
∙-----------------------------------------------------------∙*/

MouseWheelSpeed = 1
MouseWheelAccelerationSpeed = 1
MouseWheelMaxSpeed = 5
MouseRotationAngle = 0
;;∙------------∙END OF CONFIG SECTION∙------------------------∙

/*∙==========================================================∙
    This is needed to prevent key presses sending natural actions.
    Like NumPadDiv will sometimes send "/" to the screen.       
∙-----------------------------------------------------------∙*/

#InstallKeybdHook 
Temp = 0
Temp2 = 0
MouseRotationAnglePart = %MouseRotationAngle%

/*∙-----------------------------------------------------------∙
    Divide by 45° because MouseMove only supports whole numbers
    and changing the mouse rotation to a number lesser than 45°
    could make strange movements.
    *For example: 22.5° when pressing NumPadUp:
        ▹ First it would move upwards until the speed to the side reaches 1.
∙-----------------------------------------------------------∙*/

MouseRotationAnglePart /= 45
MouseCurrentAccelerationSpeed = 0
MouseCurrentSpeed = %MouseSpeed%
MouseWheelCurrentAccelerationSpeed = 0
MouseWheelCurrentSpeed = %MouseSpeed%
SetKeyDelay, -1
SetMouseDelay, -1

Hotkey, *NumPad0, ButtonLeftClick
Hotkey, *NumpadIns, ButtonLeftClickIns
Hotkey, *NumPad5, ButtonMiddleClick
Hotkey, *NumpadClear, ButtonMiddleClickClear
Hotkey, *NumPadDot, ButtonRightClick
Hotkey, *NumPadDel, ButtonRightClickDel
Hotkey, *NumPadDiv, ButtonX1Click
Hotkey, *NumPadMult, ButtonX2Click

Hotkey, *NumpadSub, ButtonWheelUp
Hotkey, *NumpadAdd, ButtonWheelDown

Hotkey, *NumPadUp, ButtonUp
Hotkey, *NumPadDown, ButtonDown
Hotkey, *NumPadLeft, ButtonLeft
Hotkey, *NumPadRight, ButtonRight
Hotkey, *NumPadHome, ButtonUpLeft
Hotkey, *NumPadEnd, ButtonUpRight
Hotkey, *NumPadPgUp, ButtonDownLeft
Hotkey, *NumPadPgDn, ButtonDownRight

Hotkey, Numpad8, ButtonSpeedUp
Hotkey, Numpad2, ButtonSpeedDown
Hotkey, Numpad7, ButtonAccelerationSpeedUp
Hotkey, Numpad1, ButtonAccelerationSpeedDown
Hotkey, Numpad9, ButtonMaxSpeedUp
Hotkey, Numpad3, ButtonMaxSpeedDown

Hotkey, Numpad6, ButtonRotationAngleUp
Hotkey, Numpad4, ButtonRotationAngleDown

Hotkey, !Numpad8, ButtonWheelSpeedUp
Hotkey, !Numpad2, ButtonWheelSpeedDown
Hotkey, !Numpad7, ButtonWheelAccelerationSpeedUp
Hotkey, !Numpad1, ButtonWheelAccelerationSpeedDown
Hotkey, !Numpad9, ButtonWheelMaxSpeedUp
Hotkey, !Numpad3, ButtonWheelMaxSpeedDown

Gosub, ~ScrollLock    ;;∙------∙Initialize based on current ScrollLock state.
Return

/*∙-----------∙Key activation support∙-----------------------∙
    Wait for it to be released because otherwise the hook state
    gets reset while the key is down, which causes the up-event
    to get suppressed, which in turn prevents toggling of the
    ScrollLock state/light.
∙-----------------------------------------------------------∙*/

~ScrollLock::
    KeyWait, ScrollLock
    GetKeyState, ScrollLockState, ScrollLock, T
    If ScrollLockState = D
    {
        Hotkey, *NumPad0, on
        Hotkey, *NumpadIns, on
        Hotkey, *NumPad5, on
        Hotkey, *NumPadDot, on
        Hotkey, *NumPadDel, on
        Hotkey, *NumPadDiv, on
        Hotkey, *NumPadMult, on

        Hotkey, *NumpadSub, on
        Hotkey, *NumpadAdd, on

        Hotkey, *NumPadUp, on
        Hotkey, *NumPadDown, on
        Hotkey, *NumPadLeft, on
        Hotkey, *NumPadRight, on
        Hotkey, *NumPadHome, on
        Hotkey, *NumPadEnd, on
        Hotkey, *NumPadPgUp, on
        Hotkey, *NumPadPgDn, on

        Hotkey, Numpad8, on
        Hotkey, Numpad2, on
        Hotkey, Numpad7, on
        Hotkey, Numpad1, on
        Hotkey, Numpad9, on
        Hotkey, Numpad3, on

        Hotkey, Numpad6, on
        Hotkey, Numpad4, on

        Hotkey, !Numpad8, on
        Hotkey, !Numpad2, on
        Hotkey, !Numpad7, on
        Hotkey, !Numpad1, on
        Hotkey, !Numpad9, on
        Hotkey, !Numpad3, on
    }
    else
    {
        Hotkey, *NumPad0, off
        Hotkey, *NumpadIns, off
        Hotkey, *NumPad5, off
        Hotkey, *NumPadDot, off
        Hotkey, *NumPadDel, off
        Hotkey, *NumPadDiv, off
        Hotkey, *NumPadMult, off

        Hotkey, *NumpadSub, off
        Hotkey, *NumpadAdd, off

        Hotkey, *NumPadUp, off
        Hotkey, *NumPadDown, off
        Hotkey, *NumPadLeft, off
        Hotkey, *NumPadRight, off
        Hotkey, *NumPadHome, off
        Hotkey, *NumPadEnd, off
        Hotkey, *NumPadPgUp, off
        Hotkey, *NumPadPgDn, off

        Hotkey, Numpad8, off
        Hotkey, Numpad2, off
        Hotkey, Numpad7, off
        Hotkey, Numpad1, off
        Hotkey, Numpad9, off
        Hotkey, Numpad3, off

        Hotkey, Numpad6, off
        Hotkey, Numpad4, off

        Hotkey, !Numpad8, off
        Hotkey, !Numpad2, off
        Hotkey, !Numpad7, off
        Hotkey, !Numpad1, off
        Hotkey, !Numpad9, off
        Hotkey, !Numpad3, off
    }
Return

;;∙------------∙Mouse click support∙-------------------------∙
ButtonLeftClick:
    GetKeyState, already_down_state, LButton
    If already_down_state = D
        return
    ;;∙------------∙
    Button2 = NumPad0
    ButtonClick = Left
    Goto ButtonClickStart

ButtonLeftClickIns:
    GetKeyState, already_down_state, LButton
    If already_down_state = D
        return
    ;;∙------------∙
    Button2 = NumPadIns
    ButtonClick = Left
    Goto ButtonClickStart

ButtonMiddleClick:
    GetKeyState, already_down_state, MButton
    If already_down_state = D
        return
    ;;∙------------∙
    Button2 = NumPad5
    ButtonClick = Middle
    Goto ButtonClickStart

ButtonMiddleClickClear:
    GetKeyState, already_down_state, MButton
    If already_down_state = D
        return
    ;;∙------------∙
    Button2 = NumPadClear
    ButtonClick = Middle
    Goto ButtonClickStart

ButtonRightClick:
    GetKeyState, already_down_state, RButton
    If already_down_state = D
        return
    ;;∙------------∙
    Button2 = NumPadDot
    ButtonClick = Right
    Goto ButtonClickStart

ButtonRightClickDel:
    GetKeyState, already_down_state, RButton
    If already_down_state = D
        return
    ;;∙------------∙
    Button2 = NumPadDel
    ButtonClick = Right
    Goto ButtonClickStart

ButtonX1Click:
    GetKeyState, already_down_state, XButton1
    If already_down_state = D
        return
    ;;∙------------∙
    Button2 = NumPadDiv
    ButtonClick = X1
    Goto ButtonClickStart

ButtonX2Click:
    GetKeyState, already_down_state, XButton2
    If already_down_state = D
        return
    ;;∙------------∙
    Button2 = NumPadMult
    ButtonClick = X2
    Goto ButtonClickStart

ButtonClickStart:
    MouseClick, %ButtonClick%,,, 1, 0, D
    SetTimer, ButtonClickEnd, 10
Return

ButtonClickEnd:
    GetKeyState, kclickstate, %Button2%, P
    if kclickstate = D
        return
    ;;∙------------∙
    SetTimer, ButtonClickEnd, off
    MouseClick, %ButtonClick%,,, 1, 0, U
Return

;;∙------------∙Mouse movement support∙----------------------∙
ButtonSpeedUp:
    MouseSpeed++
    ToolTip, Mouse speed: %MouseSpeed% pixels
    SetTimer, RemoveToolTip, 1000
Return

ButtonSpeedDown:
    If MouseSpeed > 1
        MouseSpeed--
    If MouseSpeed = 1
        ToolTip, Mouse speed: %MouseSpeed% pixel
    else
        ToolTip, Mouse speed: %MouseSpeed% pixels
    SetTimer, RemoveToolTip, 1000
Return

ButtonAccelerationSpeedUp:
    MouseAccelerationSpeed++
    ToolTip, Mouse acceleration speed: %MouseAccelerationSpeed% pixels
    SetTimer, RemoveToolTip, 1000
Return

ButtonAccelerationSpeedDown:
    If MouseAccelerationSpeed > 1
        MouseAccelerationSpeed--
    If MouseAccelerationSpeed = 1
        ToolTip, Mouse acceleration speed: %MouseAccelerationSpeed% pixel
    else
        ToolTip, Mouse acceleration speed: %MouseAccelerationSpeed% pixels
    SetTimer, RemoveToolTip, 1000
Return

ButtonMaxSpeedUp:
    MouseMaxSpeed++
    ToolTip, Mouse maximum speed: %MouseMaxSpeed% pixels
    SetTimer, RemoveToolTip, 1000
Return

ButtonMaxSpeedDown:
    If MouseMaxSpeed > 1
        MouseMaxSpeed--
    If MouseMaxSpeed = 1
        ToolTip, Mouse maximum speed: %MouseMaxSpeed% pixel
    else
        ToolTip, Mouse maximum speed: %MouseMaxSpeed% pixels
    SetTimer, RemoveToolTip, 1000
Return

ButtonRotationAngleUp:
    MouseRotationAnglePart++
    If MouseRotationAnglePart >= 8
        MouseRotationAnglePart = 0
    MouseRotationAngle = %MouseRotationAnglePart%
    MouseRotationAngle *= 45
    ToolTip, Mouse rotation angle: %MouseRotationAngle%°
    SetTimer, RemoveToolTip, 1000
Return

ButtonRotationAngleDown:
    MouseRotationAnglePart--
    If MouseRotationAnglePart < 0
        MouseRotationAnglePart = 7
    MouseRotationAngle = %MouseRotationAnglePart%
    MouseRotationAngle *= 45
    ToolTip, Mouse rotation angle: %MouseRotationAngle%°
    SetTimer, RemoveToolTip, 1000
Return

ButtonUp:
ButtonDown:
ButtonLeft:
ButtonRight:
ButtonUpLeft:
ButtonUpRight:
ButtonDownLeft:
ButtonDownRight:
    If Button <> 0
    {
        IfNotInString, A_ThisHotkey, %Button%
        {
            MouseCurrentAccelerationSpeed = 0
            MouseCurrentSpeed = %MouseSpeed%
        }
    }
    StringReplace, Button, A_ThisHotkey, *

ButtonAccelerationStart:
    If MouseAccelerationSpeed >= 1
    {
        If MouseMaxSpeed > %MouseCurrentSpeed%
        {
            Temp = 0.001
            Temp *= %MouseAccelerationSpeed%
            MouseCurrentAccelerationSpeed += %Temp%
            MouseCurrentSpeed += %MouseCurrentAccelerationSpeed%
        }
    }

    ;;∙------------∙MouseRotationAngle conversion∙-----------∙
    {
        MouseCurrentSpeedToDirection = %MouseRotationAngle%
        MouseCurrentSpeedToDirection /= 90.0
        Temp = %MouseCurrentSpeedToDirection%

        if Temp >= 0
        {
            if Temp < 1
            {
                MouseCurrentSpeedToDirection = 1
                MouseCurrentSpeedToDirection -= %Temp%
                Goto EndMouseCurrentSpeedToDirectionCalculation
            }
        }
        if Temp >= 1
        {
            if Temp < 2
            {
                MouseCurrentSpeedToDirection = 0
                Temp -= 1
                MouseCurrentSpeedToDirection -= %Temp%
                Goto EndMouseCurrentSpeedToDirectionCalculation
            }
        }
        if Temp >= 2
        {
            if Temp < 3
            {
                MouseCurrentSpeedToDirection = -1
                Temp -= 2
                MouseCurrentSpeedToDirection += %Temp%
                Goto EndMouseCurrentSpeedToDirectionCalculation
            }
        }
        if Temp >= 3
        {
            if Temp < 4
            {
                MouseCurrentSpeedToDirection = 0
                Temp -= 3
                MouseCurrentSpeedToDirection += %Temp%
                Goto EndMouseCurrentSpeedToDirectionCalculation
            }
        }
    }

EndMouseCurrentSpeedToDirectionCalculation:
    {
        MouseCurrentSpeedToSide = %MouseRotationAngle%
        MouseCurrentSpeedToSide /= 90.0
        Temp = %MouseCurrentSpeedToSide%
        Transform, Temp, mod, %Temp%, 4

        if Temp >= 0
        {
            if Temp < 1
            {
                MouseCurrentSpeedToSide = 0
                MouseCurrentSpeedToSide += %Temp%
                Goto EndMouseCurrentSpeedToSideCalculation
            }
        }
        if Temp >= 1
        {
            if Temp < 2
            {
                MouseCurrentSpeedToSide = 1
                Temp -= 1
                MouseCurrentSpeedToSide -= %Temp%
                Goto EndMouseCurrentSpeedToSideCalculation
            }
        }
        if Temp >= 2
        {
            if Temp < 3
            {
                MouseCurrentSpeedToSide = 0
                Temp -= 2
                MouseCurrentSpeedToSide -= %Temp%
                Goto EndMouseCurrentSpeedToSideCalculation
            }
        }
        if Temp >= 3
        {
            if Temp < 4
            {
                MouseCurrentSpeedToSide = -1
                Temp -= 3
                MouseCurrentSpeedToSide += %Temp%
                Goto EndMouseCurrentSpeedToSideCalculation
            }
        }
    }

EndMouseCurrentSpeedToSideCalculation:
    MouseCurrentSpeedToDirection *= %MouseCurrentSpeed%
    MouseCurrentSpeedToSide *= %MouseCurrentSpeed%
    Temp = %MouseRotationAnglePart%
    Transform, Temp, Mod, %Temp%, 2

    If Button = NumPadUp
    {
        if Temp = 1
        {
            MouseCurrentSpeedToSide *= 2
            MouseCurrentSpeedToDirection *= 2
        }
        MouseCurrentSpeedToDirection *= -1
        MouseMove, %MouseCurrentSpeedToSide%, %MouseCurrentSpeedToDirection%, 0, R
    }
    else if Button = NumPadDown
    {
        if Temp = 1
        {
            MouseCurrentSpeedToSide *= 2
            MouseCurrentSpeedToDirection *= 2
        }
        MouseCurrentSpeedToSide *= -1
        MouseMove, %MouseCurrentSpeedToSide%, %MouseCurrentSpeedToDirection%, 0, R
    }
    else if Button = NumPadLeft
    {
        if Temp = 1
        {
            MouseCurrentSpeedToSide *= 2
            MouseCurrentSpeedToDirection *= 2
        }
        MouseCurrentSpeedToSide *= -1
        MouseCurrentSpeedToDirection *= -1
        MouseMove, %MouseCurrentSpeedToDirection%, %MouseCurrentSpeedToSide%, 0, R
    }
    else if Button = NumPadRight
    {
        if Temp = 1
        {
            MouseCurrentSpeedToSide *= 2
            MouseCurrentSpeedToDirection *= 2
        }
        MouseMove, %MouseCurrentSpeedToDirection%, %MouseCurrentSpeedToSide%, 0, R
    }
    else if Button = NumPadHome
    {
        Temp = %MouseCurrentSpeedToDirection%
        Temp -= %MouseCurrentSpeedToSide%
        Temp *= -1
        Temp2 = %MouseCurrentSpeedToDirection%
        Temp2 += %MouseCurrentSpeedToSide%
        Temp2 *= -1
        MouseMove, %Temp%, %Temp2%, 0, R
    }
    else if Button = NumPadPgUp
    {
        Temp = %MouseCurrentSpeedToDirection%
        Temp += %MouseCurrentSpeedToSide%
        Temp2 = %MouseCurrentSpeedToDirection%
        Temp2 -= %MouseCurrentSpeedToSide%
        Temp2 *= -1
        MouseMove, %Temp%, %Temp2%, 0, R
    }
    else if Button = NumPadEnd
    {
        Temp = %MouseCurrentSpeedToDirection%
        Temp += %MouseCurrentSpeedToSide%
        Temp *= -1
        Temp2 = %MouseCurrentSpeedToDirection%
        Temp2 -= %MouseCurrentSpeedToSide%
        MouseMove, %Temp%, %Temp2%, 0, R
    }
    else if Button = NumPadPgDn
    {
        Temp = %MouseCurrentSpeedToDirection%
        Temp -= %MouseCurrentSpeedToSide%
        Temp2 *= -1
        Temp2 = %MouseCurrentSpeedToDirection%
        Temp2 += %MouseCurrentSpeedToSide%
        MouseMove, %Temp%, %Temp2%, 0, R
    }
    SetTimer, ButtonAccelerationEnd, 10
Return

ButtonAccelerationEnd:
    GetKeyState, kstate, %Button%, P
    if kstate = D
        Goto ButtonAccelerationStart
    ;;∙------------∙
    SetTimer, ButtonAccelerationEnd, off
    MouseCurrentAccelerationSpeed = 0
    MouseCurrentSpeed = %MouseSpeed%
    Button = 0
Return

;;∙------------∙Mouse wheel movement support∙----------------∙
ButtonWheelSpeedUp:
    MouseWheelSpeed++
    RegRead, MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
    If MouseWheelSpeedMultiplier <= 0
        MouseWheelSpeedMultiplier = 1
    MouseWheelSpeedReal = %MouseWheelSpeed%
    MouseWheelSpeedReal *= %MouseWheelSpeedMultiplier%
    ToolTip, Mouse wheel speed: %MouseWheelSpeedReal% lines
    SetTimer, RemoveToolTip, 1000
Return

ButtonWheelSpeedDown:
    RegRead, MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
    If MouseWheelSpeedMultiplier <= 0
        MouseWheelSpeedMultiplier = 1
    If MouseWheelSpeedReal > %MouseWheelSpeedMultiplier%
    {
        MouseWheelSpeed--
        MouseWheelSpeedReal = %MouseWheelSpeed%
        MouseWheelSpeedReal *= %MouseWheelSpeedMultiplier%
    }
    If MouseWheelSpeedReal = 1
        ToolTip, Mouse wheel speed: %MouseWheelSpeedReal% line
    else
        ToolTip, Mouse wheel speed: %MouseWheelSpeedReal% lines
    SetTimer, RemoveToolTip, 1000
Return

ButtonWheelAccelerationSpeedUp:
    MouseWheelAccelerationSpeed++
    RegRead, MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
    If MouseWheelSpeedMultiplier <= 0
        MouseWheelSpeedMultiplier = 1
    MouseWheelAccelerationSpeedReal = %MouseWheelAccelerationSpeed%
    MouseWheelAccelerationSpeedReal *= %MouseWheelSpeedMultiplier%
    ToolTip, Mouse wheel acceleration speed: %MouseWheelAccelerationSpeedReal% lines
    SetTimer, RemoveToolTip, 1000
Return

ButtonWheelAccelerationSpeedDown:
    RegRead, MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
    If MouseWheelSpeedMultiplier <= 0
        MouseWheelSpeedMultiplier = 1
    If MouseWheelAccelerationSpeed > 1
    {
        MouseWheelAccelerationSpeed--
        MouseWheelAccelerationSpeedReal = %MouseWheelAccelerationSpeed%
        MouseWheelAccelerationSpeedReal *= %MouseWheelSpeedMultiplier%
    }
    If MouseWheelAccelerationSpeedReal = 1
        ToolTip, Mouse wheel acceleration speed: %MouseWheelAccelerationSpeedReal% line
    else
        ToolTip, Mouse wheel acceleration speed: %MouseWheelAccelerationSpeedReal% lines
    SetTimer, RemoveToolTip, 1000
Return

ButtonWheelMaxSpeedUp:
    MouseWheelMaxSpeed++
    RegRead, MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
    If MouseWheelSpeedMultiplier <= 0
        MouseWheelSpeedMultiplier = 1
    MouseWheelMaxSpeedReal = %MouseWheelMaxSpeed%
    MouseWheelMaxSpeedReal *= %MouseWheelSpeedMultiplier%
    ToolTip, Mouse wheel maximum speed: %MouseWheelMaxSpeedReal% lines
    SetTimer, RemoveToolTip, 1000
Return

ButtonWheelMaxSpeedDown:
    RegRead, MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
    If MouseWheelSpeedMultiplier <= 0
        MouseWheelSpeedMultiplier = 1
    If MouseWheelMaxSpeed > 1
    {
        MouseWheelMaxSpeed--
        MouseWheelMaxSpeedReal = %MouseWheelMaxSpeed%
        MouseWheelMaxSpeedReal *= %MouseWheelSpeedMultiplier%
    }
    If MouseWheelMaxSpeedReal = 1
        ToolTip, Mouse wheel maximum speed: %MouseWheelMaxSpeedReal% line
    else
        ToolTip, Mouse wheel maximum speed: %MouseWheelMaxSpeedReal% lines
    SetTimer, RemoveToolTip, 1000
Return

ButtonWheelUp:
ButtonWheelDown:
    If Button <> 0
    {
        If Button <> %A_ThisHotkey%
        {
            MouseWheelCurrentAccelerationSpeed = 0
            MouseWheelCurrentSpeed = %MouseWheelSpeed%
        }
    }
    StringReplace, Button, A_ThisHotkey, *

ButtonWheelAccelerationStart:
    If MouseWheelAccelerationSpeed >= 1
    {
        If MouseWheelMaxSpeed > %MouseWheelCurrentSpeed%
        {
            Temp = 0.001
            Temp *= %MouseWheelAccelerationSpeed%
            MouseWheelCurrentAccelerationSpeed += %Temp%
            MouseWheelCurrentSpeed += %MouseWheelCurrentAccelerationSpeed%
        }
    }
    If Button = NumPadSub
        MouseClick, wheelup,,, %MouseWheelCurrentSpeed%, 0, D
    else if Button = NumPadAdd
        MouseClick, wheeldown,,, %MouseWheelCurrentSpeed%, 0, D
    SetTimer, ButtonWheelAccelerationEnd, 100
Return

ButtonWheelAccelerationEnd:
    GetKeyState, kstate, %Button%, P
    if kstate = D
        Goto ButtonWheelAccelerationStart
    MouseWheelCurrentAccelerationSpeed = 0
    MouseWheelCurrentSpeed = %MouseWheelSpeed%
    Button = 0
Return

RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
Return
;;∙===========================================================∙


/*∙===========================================================∙
Some features are the acceleration which enables you to increase the mouse movement
 when holding a key for a long time, and the rotation which makes the numpad mouse
 to "turn". (i.e. NumPadDown as NumPadUp and vice-versa) 
∙-----------------------------------------------------------------------------------------∙

-See the list of keys used below:  

* -Denotes options affected by MouseWheel speed adjusted in Control Panel. 
    ▹ (default is 3 +/- lines per option button press)
|------------------------------------------------------------|
| Keys                  | Description                        |
|------------------------------------------------------------|
| ScrollLock (toggle on)| Activates numpad mouse mode.       |
|-----------------------|------------------------------------|
| NumPad0               | Left mouse button click.           |
| NumPad5               | Middle mouse button click.         |
| NumPadDot             | Right mouse button click.          |
| NumPadDiv/NumPadMult  | X1/X2 mouse button click. (Win 2k+)|
| NumPadSub/NumPadAdd   | Moves up/down the mouse wheel.     |
|                       |                                    |
|-----------------------|------------------------------------|
| NumLock (toggled off) | Activates mouse movement mode.     |
|-----------------------|------------------------------------|
| NumPadEnd/Down/PgDn/  | Mouse movement.                    |
| /Left/Right/Home/Up/  |                                    |
| /PgUp                 |                                    |
|                       |                                    |
|-----------------------|------------------------------------|
| NumLock (toggled on)  | Activates mouse speed adj. mode.   |
|-----------------------|------------------------------------|
| NumPad7/NumPad1       | Inc./dec. acceleration per         |
|                       | button press.                      |
| NumPad8/NumPad2       | Inc./dec. initial speed per        |
|                       | button press.                      |
| NumPad9/NumPad3       | Inc./dec. maximum speed per        |
|                       | button press.                      |
| ^NumPad7/^NumPad1     | Inc./dec. wheel acceleration per   |
|                       | button press*.                     |
| ^NumPad8/^NumPad2     | Inc./dec. wheel initial speed per  |
|                       | button press*.                     |
| ^NumPad9/^NumPad3     | Inc./dec. wheel maximum speed per  |
|                       | button press*.                     |
| NumPad4/NumPad6       | Inc./dec. rotation angle to        |
|                       | right in degrees. (i.e. 180° =     |
|                       | = inversed controls).              |
|------------------------------------------------------------|
∙-----------------------------------------------------------------------------------------∙
*/
;;∙============================================================∙
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
UpdateCheck:    ;;∙------∙Check if the script file has been modified.
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

