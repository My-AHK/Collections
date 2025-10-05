
;;∙============================================================∙
;;∙------∙Speed Impacts (Tiny → Moderate → Major)∙--------------------------∙
;;∙============================================================∙

;;_____________________________________________________________
;;_______DIRECTIVES & SETTINGS_________________________________
#NoEnv    ;;∙------∙(MINUSCULE SPEED ENHANCEMENT - TINY).
    ;;∙---∙Prevents checking for environment variables when resolving variables.
    ;;∙---∙Saves a tiny amount of overhead, but negligible in modern Windows. Mainly recommended for script stability, not speed.

#SingleInstance, Force    ;;∙------∙(NO SPEED ENHANCEMENT - ZERO).
    ;;∙---∙Forces only one copy of the script to run.
    ;;∙---∙Zero effect on speed. Only prevents multiple instances.

#WinActivateForce    ;;∙------∙(CONDITIONAL SPEED ENHANCEMENT - MODERATE).
    ;;∙---∙Forces WinActivate to succeed even if the target window is minimized or hidden.
    ;;∙---∙Bypasses gentle activation attempts, avoiding retries (10–50ms savings).
    ;;∙---∙Noticeably faster with stubborn apps, fullscreen games, or windows that resist focus stealing.
        ;;∙---∙(GAMING CRITICAL) • Crucial for switching to/from fullscreen games.
        ;;∙---∙(GUI-HEAVY CRITICAL) • Essential for reliable window switching in desktop apps.

#UseHook    ;;∙------∙(CONDITIONAL SPEED ENHANCEMENT - TINY → MODERATE).
    ;;∙---∙Forces use of the keyboard/mouse hook for hotkeys.
    ;;∙---∙Can reduce latency in hotkey detection, especially in apps that block standard hotkeys.
    ;;∙---∙More reliable hotkey firing, though may add tiny overhead in simple scenarios.
        ;;∙---∙(GAMING CRITICAL) • Essential for games that block standard hotkeys.
        ;;∙---∙(TEXT PROCESSING RECOMMENDED) • Ensures hotkeys work in all text editors.

#MaxThreadsPerHotkey 3    ;;∙------∙(NO SPEED ENHANCEMENT - ZERO).
    ;;∙---∙Controls how many simultaneous instances of a hotkey can run.
    ;;∙---∙Not a speed improvement. Changes concurrency behavior.
        ;;∙---∙(GAMING RECOMMENDED) • Use 2 to avoid accidental key spam.

#HotkeyInterval 2000    ;;∙------∙(CONDITIONAL SPEED ENHANCEMENT - MODERATE → MAJOR) in rapid-fire scripts.
    ;;∙---∙Raises the limit before AHK throttles hotkeys for overload protection.
    ;;∙---∙Allows extremely rapid hotkey usage without artificial slowdowns.
    ;;∙---∙Speeds up scripts that fire hotkeys in tight loops or very quickly.
        ;;∙---∙(GAMING CRITICAL) • Prevents hotkey throttling during intense gameplay.
        ;;∙---∙(TEXT PROCESSING RECOMMENDED) • Prevents throttling during rapid text expansion.

#Persistent    ;;∙------∙(NO SPEED ENHANCEMENT - ZERO).
    ;;∙---∙Keeps the script running when there are no hotkeys, timers, or GUIs.
    ;;∙---∙Doesn't affect execution speed, just script lifetime.
        ;;∙---∙(SYSTEM AUTOMATION CRITICAL) • Required for background scripts without hotkeys.
        ;;∙---∙(SERVER/HEADLESS CRITICAL) • Essential for always-running scripts.


;;_____________________________________________________________
;;_______SPEED-ENHANCING SETTINGS____________________________
SendMode, Input    ;;∙------∙(ENHANCES SPEED - MAJOR).
    ;;∙---∙Makes Send much faster and more reliable than the default Event mode.
    ;;∙---∙Only affects scripts that use Send.
        ;;∙---∙(GAMING CRITICAL) • Fastest input method for gaming macros.
        ;;∙---∙(TEXT PROCESSING CRITICAL) • Maximum typing speed for text expansion.

SetBatchLines -1    ;;∙------∙(ENHANCES SPEED - MAJOR).
    ;;∙---∙Removes AHK's built-in throttling, allowing the script to run at full CPU speed.
    ;;∙---∙This is one of the biggest speed improvements for loops or heavy processing.
        ;;∙---∙(GAMING CRITICAL) • Maximum script responsiveness.
        ;;∙---∙(SYSTEM AUTOMATION AVOID) • Use positive values (e.g., 10) to reduce CPU usage.

SetWinDelay 0    ;;∙------∙(ENHANCES SPEED - MODERATE).
    ;;∙---∙Removes the default 100ms delay after windowing commands (like WinMove, WinActivate, WinClose, etc.).
    ;;∙---∙Makes window manipulation much snappier.
        ;;∙---∙(GUI-HEAVY CRITICAL) • Fast window switching for desktop automation.
        ;;∙---∙(BUSINESS/PRODUCTION AVOID) • Use default (100) for better reliability.

SetControlDelay -1    ;;∙------∙(CONDITIONAL SPEED ENHANCEMENT - MODERATE → MAJOR).
    ;;∙---∙Removes the default delay between ControlSend/ControlClick commands.
    ;;∙---∙Speeds up scripts that interact heavily with controls instead of using Send.
        ;;∙---∙(GUI-HEAVY CRITICAL) • Essential for fast control interaction in desktop apps.
        ;;∙---∙(BUSINESS/PRODUCTION AVOID) • Use default for more reliable control interaction.

SetKeyDelay -1    ;;∙------∙(ENHANCES SPEED - MODERATE → MAJOR) for multi-key sends.
    ;;∙---∙Removes the default 10ms key delay.
    ;;∙---∙Speeds up simulated keystrokes when sending 'Multiple' keys.
        ;;∙---∙(GAMING CRITICAL) • Eliminates delays between keystrokes in rapid-fire scripts.
        ;;∙---∙(TEXT PROCESSING CRITICAL) • Instant keystroke response for typing macros.
        ;;∙---∙(BUSINESS/PRODUCTION AVOID) • Use small positive values (e.g., 10) for reliability.

SetMouseDelay -1    ;;∙------∙(ENHANCES SPEED - MODERATE → MAJOR) for mouse operations.
    ;;∙---∙Removes the default 10ms delay after mouse clicks and movements.
    ;;∙---∙Makes mouse automation much faster.
        ;;∙---∙(GAMING CRITICAL) • Instant mouse response.
        ;;∙---∙(BUSINESS/PRODUCTION AVOID) • Use small positive values for more reliable clicks.

SetDefaultMouseSpeed 0    ;;∙------∙(ENHANCES SPEED - MAJOR) for mouse movements.
    ;;∙---∙Sets mouse movement speed to instant (no smooth scrolling).
    ;;∙---∙Eliminates the default 2-step movement delay, making mouse moves immediate.
        ;;∙---∙(GAMING CRITICAL) • Instant mouse response.
        ;;∙---∙(PIXEL AUTOMATION RECOMMENDED) • Use 2-3 for more accurate visual targeting.
        ;;∙---∙(BUSINESS/PRODUCTION AVOID) • Use default (2) for more natural mouse movement.


;;_____________________________________________________________
;;_______COORDINATE & CONSISTENCY SETTINGS___________________
CoordMode, Mouse, Screen    ;;∙------∙(CONDITIONAL SPEED ENHANCEMENT - TINY → MODERATE).
    ;;∙---∙Sets mouse coordinates relative to the entire screen rather than active window.
    ;;∙---∙Reduces overhead of window coordinate calculations. Impact depends on usage frequency.
        ;;∙---∙(GAMING CONDITIONAL) • If using screen-relative coordinates.
        ;;∙---∙(PIXEL AUTOMATION CRITICAL) • Essential for consistent screen-relative positioning.
        ;;∙---∙(GUI-HEAVY AVOID) • Use "Window" mode for application-relative coordinates.

CoordMode, Pixel, Screen    ;;∙------∙(CONDITIONAL SPEED ENHANCEMENT - TINY → MODERATE).
    ;;∙---∙Sets pixel search coordinates relative to the entire screen.
    ;;∙---∙Eliminates window-specific coordinate translation overhead. Impact depends on usage frequency.
        ;;∙---∙(GAMING CONDITIONAL) • Only if using pixel search for UI detection.
        ;;∙---∙(PIXEL AUTOMATION CRITICAL) • Essential for consistent image recognition.
        ;;∙---∙(GUI-HEAVY AVOID) • Use "Window" mode for application-specific UI detection.

CoordMode, ToolTip, Screen    ;;∙------∙(CONDITIONAL SPEED ENHANCEMENT - TINY).
    ;;∙---∙Sets tooltip coordinates relative to the entire screen.
    ;;∙---∙Minor speed improvement for frequent tooltip updates.


;;_____________________________________________________________
;;_______CONDITIONAL PERFORMANCE TWEAKS____________________
Process, Priority, , High    ;;∙------∙(CONDITIONAL SPEED ENHANCEMENT - MODERATE).
    ;;∙---∙Sets the script's process priority to High.
    ;;∙---∙Gives the script more CPU time when system is under load.
    ;;∙---∙Can improve responsiveness in CPU-intensive scenarios.
        ;;∙---∙(GAMING CONDITIONAL) • Only if script needs CPU priority over the game.
        ;;∙---∙(SYSTEM AUTOMATION AVOID) • Use "Low" or "BelowNormal" to avoid competing with user apps.

Critical    ;;∙------∙(CONDITIONAL SPEED ENHANCEMENT - MODERATE).
    ;;∙---∙Prevents thread interruptions from timers and other hotkeys.
    ;;∙---∙Useful for time-critical code sections where interruptions would cause delays.
    ;;∙---∙Use sparingly and turn off with "Critical Off" when critical section ends!!
        ;;∙---∙(GAMING CONDITIONAL) • For time-sensitive combat macros (use sparingly).
        ;;∙---∙(BUSINESS/PRODUCTION AVOID) • Can cause missed interrupts in complex scripts.


;;_____________________________________________________________
;;_______FINE-TUNING / DEBUG CONTROL__________________________
ListLines Off    ;;∙------∙(ENHANCES SPEED - MODERATE).
    ;;∙---∙Disables line-by-line execution logging in the main thread.
    ;;∙---∙Reduces overhead, especially in tight loops and frequently called functions.
        ;;∙---∙(GAMING CONDITIONAL) • Minor performance gain.
        ;;∙---∙(SERVER/HEADLESS CRITICAL) • Reduces resource usage in background scripts.
        ;;∙---∙(BUSINESS/PRODUCTION AVOID) • Keep On for debugging production issues.

#KeyHistory 0    ;;∙------∙(ENHANCES SPEED - MODERATE).
    ;;∙---∙Disables key history logging, similar performance benefit to ListLines Off.
    ;;∙---∙Reduces memory usage and eliminates logging overhead for key events.
        ;;∙---∙(GAMING CONDITIONAL) • Minor performance gain.
        ;;∙---∙(SERVER/HEADLESS CRITICAL) • Essential for minimal footprint.
        ;;∙---∙(BUSINESS/PRODUCTION AVOID) • Keep enabled for troubleshooting.


/*____________________________________________________________
∙|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||∙
________Summary of Optimal Order______________________________
DIRECTIVES FIRST: 
  • Environment, instance control, window behavior, hooks
      ⮞ Anything that affects global script behavior should initialize before hotkeys or speed settings.

CONDITIONAL SPEED ENHANCEMENTS NEXT: 
  • #WinActivateForce,  #UseHook,  #HotkeyInterval
      ⮞ Modify performance-sensitive operations early.

THREAD/CONCURRENCY CONTROL: 
  • #MaxThreadsPerHotkey is applied after environment and hooks, so it doesn't interfere with startup.

PERSISTENCE LAST IN DIRECTIVES: 
  • #Persistent keeps the script alive without impacting speed.

SPEED DEFAULTS LAST: 
  • SendMode, SetBatchLines, SetWinDelay, SetControlDelay, SetKeyDelay
  • SetMouseDelay, SetDefaultMouseSpeed, CoordMode settings
  • Process priority, ListLines, Critical mode, #KeyHistory
      ⮞ Applied after all global behaviors to maximize actual execution performance.
      ⮞ ControlDelay only affects ControlSend/ControlClick, but speeds them up dramatically if used heavily.
      ⮞ Mouse and coordinate settings optimize automation speed based on usage frequency.
      ⮞ Process priority and logging controls reduce system overhead.
      ⮞ Debug controls (ListLines, #KeyHistory) eliminate logging overhead.

______________________________________________________________
∙|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||∙
________Summary of Profiles____________________________________
  • CRITICAL - Essential for that profile.
  • RECOMMENDED - Beneficial but not essential.
  • CONDITIONAL - Depends on specific use case.
  • AVOID - Not recommended for that profile.
______________________________________________________________
*/
;;_____________________________________________________________
;;____• TYPICAL GAMING AUTO-EXE: (Maximum speed, low latency)
#NoEnv
#WinActivateForce
#UseHook
#MaxThreadsPerHotkey 2
#HotkeyInterval 2000

SendMode Input
SetBatchLines -1
SetWinDelay 0
SetKeyDelay -1, -1
SetMouseDelay -1
SetDefaultMouseSpeed 0
CoordMode, Mouse, Screen
;;∙------∙Gaming hotkeys code below...


;;_____________________________________________________________
;;____• TYPICAL GUI-HEAVY AUTO-EXE: (Fast window/control interaction)
#NoEnv
#WinActivateForce
#SingleInstance Force

SetWinDelay 0
SetControlDelay -1
CoordMode, Mouse, Window
CoordMode, Pixel, Window
SendMode Input
;;∙------∙GUI automation code below...


;;_____________________________________________________________
;;____• TYPICAL TEXT PROCESSING & TYPING AUTO-EXE: (Instant keystroke response)
#NoEnv
#UseHook
#HotkeyInterval 1000
#SingleInstance Force

SendMode Input
SetKeyDelay -1, -1
SetBatchLines -1
;;∙------∙Text expansion hotkeys code below...


;;_____________________________________________________________
;;____• TYPICAL SYSTEM AUTOMATION & BACKGROUND AUTO-EXE: (Low resource usage)
#NoEnv
#Persistent
#SingleInstance Force

SetBatchLines 10
Process, Priority, , Low
ListLines Off
#KeyHistory 0
;;∙------∙Background timers & automation code below...


;;_____________________________________________________________
;;____• TYPICAL BUSINESS/PRODUCTION RELIABILITY AUTO-EXE: (Reliability over speed)
#NoEnv
#SingleInstance Force
#WinActivateForce

SendMode Input
SetWinDelay 50
SetKeyDelay 10
SetControlDelay 10
SetMouseDelay 10
SetDefaultMouseSpeed 2
ListLines On
;;∙------∙Business automation code below...


;;_____________________________________________________________
;;____• TYPICAL PIXEL/VISION-BASED AUTOMATION AUTO-EXE: (Consistent screen coordinates)
#NoEnv
#UseHook
#SingleInstance Force

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
SetDefaultMouseSpeed 2
SendMode Input
SetBatchLines -1
;;∙------∙Image recognition code below...


;;_____________________________________________________________
;; • TYPICAL SERVER/HEADLESS AUTO-EXE: (Minimal footprint)
#NoEnv
#NoTrayIcon
#Persistent
#SingleInstance Force

ListLines Off
#KeyHistory 0
Process, Priority, , Low
SetBatchLines 20
;;∙------∙Headless automation code below...

;;∙============================================================∙
;;∙============================================================∙
