
;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙



;;∙=============================================∙
;;∙======∙DIRECTIVES & SETTINGS∙=================∙
#NoEnv
#Persistent
#SingleInstance, Force
SetBatchLines -1
SetWorkingDir, %A_ScriptDir%

;;∙=============================================∙
;;∙======∙CUSTOMIZATION VARIABLES∙=============∙
default_note_bg := "Black"    ;;∙------∙Default background color for new notes.
default_note_title := "Black"    ;;∙------∙Default color for note title text.
default_note_text := "Blue"    ;;∙------∙Default text color for note content.
default_note_color := "Yellow"    ;;∙------∙Fallback default color for "C" (color dropdown) button text. 

notes_ini := A_ScriptDir "\StickyNotes.ini"    ;;∙------∙Path to INI file storing note data.
note_counter := 0    ;;∙------∙Keeps track of highest note number used for generating unique IDs.
ActiveNotes := Object()    ;;∙------∙Object storing all properties (position, colors, content) of active notes.

note_font := "Segoe UI"    ;;∙------∙Font used for main note content text.
title_font_size := 8    ;;∙------∙Font size for note title input field.
note_font_size := 10    ;;∙------∙Font size for main note content.

default_width := 230    ;;∙------∙Default width for new note window.
default_height := 150    ;;∙------∙Default height for new note window.
default_x := 100    ;;∙------∙Default starting X coordinate for new note.
default_y := 100    ;;∙------∙Default starting Y coordinate for new note.

minWsize := 230    ;;∙------∙Minimum width size for note windows.
minHsize := 150    ;;∙------∙Minimum height size for note windows.

;;∙------∙Button positioning relative to edit box right edge.
button_T_offset := 55    ;;∙------∙X offset from right edge for the "T" (toggle always-on-top) button.
button_min_offset := 37    ;;∙------∙X offset from right edge for the "--" (minimize) button.
button_X_offset := 19    ;;∙------∙X offset from right edge for the "X" (close) button.
button_C_Y := 10    ;;∙------∙Y position for Color button.
button_Y := 5    ;;∙------∙Y position for top-right buttons (T, --, X).

ScriptID := "Sticky_Notes"    ;;∙------∙Identifier used for tray tip.
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Message handler for window dragging.
OnMessage(0x0005, "WM_SIZE")    ;;∙------∙Message handler for window resizing.
Menu, Tray, Icon, imageres.dll, 234    ;;∙------∙Tray icon.

Gui, Margin, 0, 0

;;∙=============================================∙
;;∙======∙ICON CHECK FUNCTION∙=================∙
;;∙------∙Checks if DLL file exists.
IconExists(dllPath) {
    return FileExist(dllPath)
}

;;∙=============================================∙
;;∙======∙INITIALIZATION∙=======================∙
GoSub, LoadAllNotes    ;;∙------∙Load any previously saved notes from INI file.
SetTimer, UpdateCheck, 750    ;;∙------∙Auto-reload upon script saves.
SetTimer, SaveAllNotes, 30000    ;;∙------∙Auto-save all open notes every 30 seconds.
GoSub, TrayMenu    ;;∙------∙Build system tray menu.

if (note_counter = 0)    ;;∙------∙If no notes were loaded from INI file...
    GoSub, NewNote    ;;∙------∙...create new blank note to start with.
Return

;;∙=============================================∙
;;∙======∙GET NEXT AVAILABLE NOTE NUMBER∙=======∙
GetNextNoteNumber:
    next_number := 1
    Loop
    {
        test_id := "Note_" . next_number

        ;;∙------∙Check if ID exists as an active note.
        if ActiveNotes.Haskey(test_id)
        {
            next_number++
            continue
        }

        ;;∙------∙Check if ID exists as a deleted note in the INI.
        IniRead, check_deleted, %notes_ini%, Deleted_%test_id%, bg, NOTFOUND
        if (check_deleted != "NOTFOUND")
        {
            next_number++
            continue
        }

        ;;∙------∙Check if ID exists as an active note in the INI (reload safety).
        IniRead, check_active, %notes_ini%, %test_id%, bg, NOTFOUND
        if (check_active != "NOTFOUND")
        {
            next_number++
            continue
        }

        break    ;;∙------∙Found a completely unused ID.
    }
    note_counter := next_number
Return

;;∙=============================================∙
;;∙======∙CREATE NEW NOTE∙======================∙
NewNote:
    GoSub, GetNextNoteNumber    ;;∙------∙Determine next available Note_X ID.
    note_id := "Note_" . note_counter

    ;;∙------∙Cascade new notes slightly so they don't stack exactly on top of each other.
    new_x := default_x + (Mod(note_counter, 5) * 25)
    new_y := default_y + (Mod(note_counter, 5) * 25)

    decoded_content := ""    ;;∙------∙New notes start with empty content.

    Gui, %note_id%:New, +AlwaysOnTop -Caption +ToolWindow 
        +Resize +MinSize%minWsize%x%minHsize%
        +E0x02000000 +E0x00080000    ;;∙------∙Double Buffer.

    Gui, %note_id%:Color, % Color(default_note_bg, "GUI0x")

    ;;∙------∙Always on top is ON by default.
    Gui, %note_id%:+AlwaysOnTop

    ;;∙------∙Title bar with editable name.
    titleColorHex := Color(default_note_title, "GUI0x")
    Gui, %note_id%:Font, s%title_font_size% c%titleColorHex% Bold, %note_font%

    note_name := "Note " . note_counter

    Gui, %note_id%:Add, Edit, x5 y5 w120 h20 vNoteTitle gNoteNameChanged BackgroundTrans, %note_name%

    ;;∙------∙Color button...try icon first, fallback to text button if fail.
    borderColorHex := Color(default_note_color, "GUI0x")
    shell32_path := A_WinDir "\system32\shell32.dll"
    if IconExists(shell32_path) {
        Gui, %note_id%:Add, Picture, x130 y%button_C_Y% w16 h16 BackgroundTrans Icon162 gToggleColorDDL, %shell32_path%
    } else {
        Gui, %note_id%:Font, s8 c%borderColorHex% Bold, Segoe UI
        Gui, %note_id%:Add, Text, x130 y%button_C_Y% w16 h16 Center BackgroundTrans gToggleColorDDL, C
    }

    ;;∙------∙Hidden DDL for color selection.
    textColorHex := Color(default_note_text, "GUI0x")
    Gui, %note_id%:Font, s8 c%textColorHex% Norm, %note_font%
    ddl_y := button_C_Y + 18
    Gui, %note_id%:Add, DropDownList, x130 y%ddl_y% w100 r15 vColorDDL gColorDDLChange Hidden, Black|Gray|Silver|White|Maroon|Red|Magenta-Red|Rose|Salmon|Light Salmon|Coral|Hot Pink|Deep Pink|Rose Pink|Pink|Red-Orange|Orange|Yellow-Red|Yellow-Orange|Yellow|Chartreuse|Olive|Green|Lime|Spring Green|Cyan-Green|Teal|Aqua|Azure|Blue|Navy|Indigo|Violet|Purple|Fuchsia
    
    Gui, %note_id%:Font, s%note_font_size% c%textColorHex% Norm, %note_font%
    
    ;;∙------∙Edit box for note content.
    Gui, %note_id%:Add, Edit, x5 y30 w240 h165 vNoteContent HScroll WantCtrlA gNoteChanged, %decoded_content%
    
    ActiveNotes[note_id] := Object()    ;;∙------∙Initialize object to store this note's properties.
    ActiveNotes[note_id].bg := default_note_bg    ;;∙------∙Set background color.
    ActiveNotes[note_id].text_color := default_note_text    ;;∙------∙Set main text color.
    ActiveNotes[note_id].title_color := default_note_title    ;;∙------∙Set title text color.
    ActiveNotes[note_id].border_color := default_note_color    ;;∙------∙Set border/button accent color.
    ActiveNotes[note_id].ontop := 1    ;;∙------∙Set "Always On Top" to ON by default.
    ActiveNotes[note_id].x := new_x    ;;∙------∙Set initial X position.
    ActiveNotes[note_id].y := new_y    ;;∙------∙Set initial Y position.
    ActiveNotes[note_id].w := default_width    ;;∙------∙Set initial width.
    ActiveNotes[note_id].h := default_height    ;;∙------∙Set initial height.
    ActiveNotes[note_id].name := note_name    ;;∙------∙Set the note's display name.
    ActiveNotes[note_id].content := ""    ;;∙------∙Initialize empty text content.
    
    ;;∙------∙Show window.
    Gui, %note_id%:Show, x%new_x% y%new_y% w%default_width% h%default_height%, %note_id%
    
    ;;∙------∙Resize edit control to match window.
    GuiControl, %note_id%:Move, NoteContent, % "w" (default_width - 10) " h" (default_height - 40)
    
    ;;∙------∙Create right-aligned buttons once edit box properly sized.
    GuiControlGet, edit_pos, %note_id%:Pos, NoteContent
    
    btn_T_x := edit_posX + edit_posW - button_T_offset    ;;∙------∙X position for "T" (toggle Always-on-top) button.
    btn_min_x := edit_posX + edit_posW - button_min_offset    ;;∙------∙X position for "--" (minimize) button.
    btn_X_x := edit_posX + edit_posW - button_X_offset    ;;∙------∙X position for "X" (close) button.
    
    imageres_path := A_WinDir "\system32\imageres.dll"
    
    ;;∙------∙Always on Top button, two-state icon with text button fallback.
    ontop_icon := ActiveNotes[note_id].ontop ? 234 : 235
    if IconExists(imageres_path) {
        Gui, %note_id%:Add, Picture, vBtnOntop%note_id% x%btn_T_x% y%button_Y% w16 h16 BackgroundTrans Icon%ontop_icon% gToggleOntop, %imageres_path%
    } else {
        Gui, %note_id%:Font, s8 c%borderColorHex% Bold, Segoe UI
        Gui, %note_id%:Add, Text, vBtnOntop%note_id% x%btn_T_x% y%button_Y% w16 h16 Center BackgroundTrans gToggleOntop, T
    }
    
    ;;∙------∙Minimize button.
    if IconExists(imageres_path) {
        Gui, %note_id%:Add, Picture, vBtnMin%note_id% x%btn_min_x% y%button_Y% w16 h16 BackgroundTrans Icon176 gMinimizeNote, %imageres_path%
    } else {
        Gui, %note_id%:Font, s8 c%borderColorHex% Bold, Segoe UI
        Gui, %note_id%:Add, Text, vBtnMin%note_id% x%btn_min_x% y%button_Y% w16 h16 Center BackgroundTrans gMinimizeNote, --
    }
    
    ;;∙------∙Close button.
    if IconExists(imageres_path) {
        Gui, %note_id%:Add, Picture, vBtnClose%note_id% x%btn_X_x% y%button_Y% w16 h16 BackgroundTrans Icon260 gCloseNote, %imageres_path%
    } else {
        Gui, %note_id%:Font, s8 c%borderColorHex% Bold, Segoe UI
        Gui, %note_id%:Add, Text, vBtnClose%note_id% x%btn_X_x% y%button_Y% w16 h16 Center BackgroundTrans gCloseNote, X
    }
    
    ;;∙------∙Force redraw to eliminate transparent backgrounds.
    Gui, %note_id%:Color, % Color(ActiveNotes[note_id].bg, "GUI0x")
    
    ;;∙------∙Save immediately after creation.
    GoSub, SaveSingleNote
Return

;;∙=============================================∙
;;∙======∙NOTE NAME CHANGED∙====================∙
NoteNameChanged:
    current_note_id := WinExist()    ;;∙------∙Get HWND of active window triggering this event.
    WinGetTitle, current_note_id, ahk_id %current_note_id%    ;;∙------∙Retrieve window title, which is the note_id (e.g., "Note_1").
    GuiControlGet, new_name, %current_note_id%:, NoteTitle    ;;∙------∙Read new name from NoteTitle Edit control.
    if (new_name != "")    ;;∙------∙If title not left blank...
        ActiveNotes[current_note_id].name := new_name    ;;∙------∙...update name stored in the ActiveNotes object.
    note_id := current_note_id    ;;∙------∙Set note_id for the SaveSingleNote subroutine.
    GoSub, SaveSingleNote    ;;∙------∙Persist the name change to the INI file.
Return

;;∙=============================================∙
;;∙======∙WM_SIZE MESSAGE HANDLER∙==============∙
WM_SIZE(wParam, lParam, msg, hwnd) {
    WinGetTitle, note_id, ahk_id %hwnd%    ;;∙------∙Get note_id (e.g., "Note_1") from window's title.
    if (note_id != "" && SubStr(note_id, 1, 5) = "Note_") {    ;;∙------∙Verify this is one of our note windows.
        new_w := lParam & 0xFFFF    ;;∙------∙Extract new width from lParam.
        new_h := lParam >> 16    ;;∙------∙Extract new height from lParam.
        
        if (new_w >= 230 and new_h >= 150) {    ;;∙------∙Enforce minimum size (230x150).
            ActiveNotes[note_id].w := new_w    ;;∙------∙Store new width in ActiveNotes object.
            ActiveNotes[note_id].h := new_h    ;;∙------∙Store new height in ActiveNotes object.

            ;;∙------∙Resize note content Edit control to fill new window dimensions.
            ;;∙------∙Subtract 10 from width & 40 from height to account for margins & title bar area.
            GuiControl, %note_id%:Move, NoteContent, % "w" (new_w - 10) " h" (new_h - 40)
            
            GoSub, RepositionButtons    ;;∙------∙Move right-aligned buttons to match new width.
            
            note_id_temp := note_id    ;;∙------∙Store note_id temporarily for SaveSingleNote subroutine.
            GoSub, SaveSingleNote    ;;∙------∙Save new dimensions to INI file.
        }
    }
    Return 0    ;;∙------∙Message was handled.
}

;;∙=============================================∙
;;∙======∙REPOSITION RIGHT BUTTONS∙=============∙
;;∙------∙Called after a note window is resized to reposition the T, --, and X buttons.
;;∙------∙These buttons are anchored to right edge of Edit control, not the window itself.
RepositionButtons:
    current_note_id := WinExist()    ;;∙------∙Get HWND of currently active window.
    WinGetTitle, current_note_id, ahk_id %current_note_id%    ;;∙------∙Retrieve window title (note_id).
    
    if (current_note_id = "")    ;;∙------∙Exit if no window is active.
        Return
    
    GuiControlGet, edit_pos, %current_note_id%:Pos, NoteContent    ;;∙------∙Get current position & size of NoteContent Edit control.
    
    if (edit_posW > 0) {    ;;∙------∙Only proceed if Edit control has a valid width.

        ;;∙------∙Calculate new X positions for the three right-aligned buttons.
        ;;∙------∙Each button is positioned relative to right edge of the Edit control (edit_posX + edit_posW).
        ;;∙------∙The offsets (defined at top of script) determine spacing from right edge.
        btn_T_x := edit_posX + edit_posW - button_T_offset    ;;∙------∙New X position for "T" (toggle Always-on-top) button.
        btn_min_x := edit_posX + edit_posW - button_min_offset    ;;∙------∙New X position for "--" (minimize) button.
        btn_X_x := edit_posX + edit_posW - button_X_offset    ;;∙------∙New X position for "X" (close) button.

        ;;∙------∙Move each button to newly calculated X position (Y position remains unchanged).
        GuiControl, %current_note_id%:Move, BtnOntop%current_note_id%, x%btn_T_x%
        GuiControl, %current_note_id%:Move, BtnMin%current_note_id%, x%btn_min_x%
        GuiControl, %current_note_id%:Move, BtnClose%current_note_id%, x%btn_X_x%

        ;;∙------∙Redraw buttons to ensure they display correctly at new positions.
        GuiControl, %current_note_id%:Redraw, BtnOntop%current_note_id%
        GuiControl, %current_note_id%:Redraw, BtnMin%current_note_id%
        GuiControl, %current_note_id%:Redraw, BtnClose%current_note_id%
    }
Return

;;∙=============================================∙
;;∙======∙COLOR DDL FUNCTIONS∙==================∙
ToggleColorDDL:
    current_note_id := WinExist()
    WinGetTitle, current_note_id, ahk_id %current_note_id%
    
    ;;∙------∙Toggle DDL visibility.
    GuiControlGet, ddl_visible, %current_note_id%:Visible, ColorDDL
    if (ddl_visible) {
        GuiControl, %current_note_id%:Hide, ColorDDL
    } else {
        GuiControl, %current_note_id%:Show, ColorDDL
        GuiControl, %current_note_id%:Choose, ColorDDL, % ActiveNotes[current_note_id].bg
        ControlFocus, ColorDDL, ahk_id %current_note_id%
        Send, {F4}  ;;∙------∙Open dropdown.
    }
Return

ColorDDLChange:
    current_note_id := WinExist()
    WinGetTitle, current_note_id, ahk_id %current_note_id%
    GuiControlGet, new_color, %current_note_id%:, ColorDDL
    
    if (new_color != "") {
        ActiveNotes[current_note_id].bg := new_color
        Gui, %current_note_id%:Color, % Color(new_color, "GUI0x")
        GuiControl, %current_note_id%:Hide, ColorDDL
        note_id := current_note_id
        GoSub, SaveSingleNote
    }
Return

;;∙=============================================∙
;;∙======∙LOAD ALL NOTES FROM INI∙==============∙
;;∙------∙Called at script startup to restore all previously saved notes.
;;∙------∙Reads StickyNotes.ini file & recreates each active note window.
LoadAllNotes:
    ;;∙------∙Clear existing ActiveNotes object & reset counter.
    ActiveNotes := Object()
    note_counter := 0
    
    ;;∙------∙Read all section names from INI file.
    ;;∙------∙IniRead returns a newline-separated list of all sections, or "ERROR" if file doesn't exist.
    IniRead, AllSections, %notes_ini%
    if (AllSections != "ERROR") {    ;;∙------∙Only proceed if INI file exists & has sections.
        Loop, Parse, AllSections, `n    ;;∙------∙Loop through each section name (separated by newlines).
        {
            current_section := A_LoopField    ;;∙------∙Current section name (e.g., "Note_1" or "Deleted_Note_1").
            if (current_section != "" && SubStr(current_section, 1, 5) = "Note_") {    ;;∙------∙Check if section starts with "Note_".

                ;;∙------∙Check if this is NOT a deleted note.
                ;;∙------∙Deleted notes are stored in sections prefixed with "Deleted_" and are skipped here.
                ;;∙------∙They can be restored later via RestoreDeletedNotes function.
                if (SubStr(current_section, 1, 8) != "Deleted_") {
                    note_id := current_section    ;;∙------∙The section name IS the note_id (e.g., "Note_1").
                    ActiveNotes[note_id] := Object()    ;;∙------∙Create new object to store this note's properties.

                    ;;∙------∙Read all saved properties for this note from INI file.
                    ;;∙------∙The last parameter of each IniRead is the default value if key doesn't exist.
                    IniRead, saved_bg, %notes_ini%, %note_id%, bg, %default_note_bg%
                    IniRead, saved_text, %notes_ini%, %note_id%, text_color, %default_note_text%
                    IniRead, saved_title, %notes_ini%, %note_id%, title_color, %default_note_title%
                    IniRead, saved_border, %notes_ini%, %note_id%, border_color, %default_note_color%
                    IniRead, saved_content, %notes_ini%, %note_id%, content, %A_Space%
                    IniRead, saved_x, %notes_ini%, %note_id%, x, %default_x%
                    IniRead, saved_y, %notes_ini%, %note_id%, y, %default_y%
                    IniRead, saved_w, %notes_ini%, %note_id%, w, %default_width%
                    IniRead, saved_h, %notes_ini%, %note_id%, h, %default_height%
                    IniRead, saved_ontop, %notes_ini%, %note_id%, ontop, 1
                    IniRead, saved_name, %notes_ini%, %note_id%, name, %A_Space%

                    ;;∙------∙Store loaded values in ActiveNotes object.
                    ActiveNotes[note_id].bg := saved_bg
                    ActiveNotes[note_id].text_color := saved_text
                    ActiveNotes[note_id].title_color := saved_title
                    ActiveNotes[note_id].border_color := saved_border
                    ActiveNotes[note_id].content := saved_content
                    ActiveNotes[note_id].x := saved_x
                    ActiveNotes[note_id].y := saved_y
                    ActiveNotes[note_id].w := saved_w
                    ActiveNotes[note_id].h := saved_h
                    ActiveNotes[note_id].ontop := saved_ontop
                    ActiveNotes[note_id].name := saved_name

                    ;;∙------∙Update note_counter to track highest note number loaded.
                    ;;∙------∙This ensures new notes get properly incremented IDs.
                    StringTrimLeft, note_num, note_id, 5    ;;∙------∙Extract the number from "Note_X" by removing first 5 characters.
                    if (note_num > note_counter)
                        note_counter := note_num    ;;∙------∙Keep highest number seen so far.
                    
                    GoSub, CreateNoteFromLoaded    ;;∙------∙Create GUI window for this note.
                }
            }
        }
    }
Return


;;∙------∙Called by LoadAllNotes for each saved note found in INI file.
;;∙------∙Creates the GUI window using properties stored in ActiveNotes[note_id].
;;∙------∙This is the same as NewNote, but uses saved values instead of defaults.
CreateNoteFromLoaded:
    ;;∙------∙Decode saved content, convert encoded line break marker back to actual newlines.
    decoded_content := ActiveNotes[note_id].content
    StringReplace, decoded_content, decoded_content, `%5B`%BR`%5D`%, `n, All    ;;∙------∙Replace "[BR]" marker with `n.

    ;;∙------∙Retrieve all saved properties for this note from ActiveNotes object.
    w := ActiveNotes[note_id].w
    h := ActiveNotes[note_id].h
    x := ActiveNotes[note_id].x
    y := ActiveNotes[note_id].y
    bg := ActiveNotes[note_id].bg
    ontop := ActiveNotes[note_id].ontop
    title_color := ActiveNotes[note_id].title_color
    border_color := ActiveNotes[note_id].border_color
    text_color := ActiveNotes[note_id].text_color
    note_name := ActiveNotes[note_id].name

   ;;∙------∙Create GUI window with same style options as new notes.
    Gui, %note_id%:New, +AlwaysOnTop -Caption +ToolWindow 
        +Resize +MinSize%minWsize%x%minHsize%
        +E0x02000000 +E0x00080000   ;;∙------∙Double Buffer.

    Gui, %note_id%:Color, % Color(bg, "GUI0x")

    ;;∙------∙Restore "Always On Top" state from the saved setting.
    if (ontop = 1)
        Gui, %note_id%:+AlwaysOnTop
    else
        Gui, %note_id%:-AlwaysOnTop

    ;;∙------∙Create editable title bar with the saved title color.
    titleColorHex := Color(title_color, "GUI0x")
    Gui, %note_id%:Font, s%title_font_size% c%titleColorHex% Bold, %note_font%

    ;;∙------∙Fallback: If no name was saved, use the note_id as the title.
    if (note_name = "")
        note_name := note_id

    Gui, %note_id%:Add, Edit, x5 y5 w120 h20 vNoteTitle gNoteNameChanged BackgroundTrans, %note_name%

    ;;∙------∙Create "C" (color menu) button with the saved border color.
    borderColorHex := Color(border_color, "GUI0x")
    shell32_path := A_WinDir "\system32\shell32.dll"
    if IconExists(shell32_path) {
        Gui, %note_id%:Add, Picture, x130 y%button_C_Y% w16 h16 BackgroundTrans Icon162 gToggleColorDDL, %shell32_path%
    } else {
        Gui, %note_id%:Font, s8 c%borderColorHex% Bold, Segoe UI
        Gui, %note_id%:Add, Text, x130 y%button_C_Y% w16 h16 Center BackgroundTrans gToggleColorDDL, C
    }

    ;;∙------∙Hidden DDL for color selection.
    textColorHex := Color(text_color, "GUI0x")
    Gui, %note_id%:Font, s8 c%textColorHex% Norm, %note_font%
    ddl_y := button_C_Y + 18
    Gui, %note_id%:Add, DropDownList, x130 y%ddl_y% w100 r15 vColorDDL gColorDDLChange Hidden, Black|Gray|Silver|White|Maroon|Red|Magenta-Red|Rose|Salmon|Light Salmon|Coral|Hot Pink|Deep Pink|Rose Pink|Pink|Red-Orange|Orange|Yellow-Red|Yellow-Orange|Yellow|Chartreuse|Olive|Green|Lime|Spring Green|Cyan-Green|Teal|Aqua|Azure|Blue|Navy|Indigo|Violet|Purple|Fuchsia

    ;;∙------∙Create main content Edit control with the saved text color.
    Gui, %note_id%:Font, s%note_font_size% c%textColorHex% Norm, %note_font%
    Gui, %note_id%:Add, Edit, x5 y30 w240 h165 vNoteContent HScroll WantCtrlA gNoteChanged, %decoded_content%

    ;;∙------∙Show window at saved position & size.
    Gui, %note_id%:Show, x%x% y%y% w%w% h%h%, %note_id%

    ;;∙------∙Resize Edit control to properly fit within the window dimensions.
    ;;∙------∙Subtract 10 from width and 40 from height to account for margins and title bar area.
    GuiControl, %note_id%:Move, NoteContent, % "w" (w - 10) " h" (h - 40)

    ;;∙------∙Get position of Edit control to properly place the right-aligned buttons.
    GuiControlGet, edit_pos, %note_id%:Pos, NoteContent

    ;;∙------∙Calculate X positions for the three right-aligned buttons.
    ;;∙------∙Each button positioned relative to right edge of the Edit control.
    btn_T_x := edit_posX + edit_posW - button_T_offset    ;;∙------∙X position for "T" (toggle always-on-top) button.
    btn_min_x := edit_posX + edit_posW - button_min_offset    ;;∙------∙X position for "--" (minimize) button.
    btn_X_x := edit_posX + edit_posW - button_X_offset    ;;∙------∙X position for "X" (close) button.

    imageres_path := A_WinDir "\system32\imageres.dll"
    
    ;;∙------∙Create the three right-aligned control buttons.
    ;;∙------∙Always on Top button, two-state icon with text button fallback.
    ontop_icon := ontop ? 234 : 235
    if IconExists(imageres_path) {
        Gui, %note_id%:Add, Picture, vBtnOntop%note_id% x%btn_T_x% y%button_Y% w16 h16 BackgroundTrans Icon%ontop_icon% gToggleOntop, %imageres_path%
    } else {
        Gui, %note_id%:Font, s8 c%borderColorHex% Bold, Segoe UI
        Gui, %note_id%:Add, Text, vBtnOntop%note_id% x%btn_T_x% y%button_Y% w16 h16 Center BackgroundTrans gToggleOntop, T
    }
    
    ;;∙------∙Minimize button.
    if IconExists(imageres_path) {
        Gui, %note_id%:Add, Picture, vBtnMin%note_id% x%btn_min_x% y%button_Y% w16 h16 BackgroundTrans Icon176 gMinimizeNote, %imageres_path%
    } else {
        Gui, %note_id%:Font, s8 c%borderColorHex% Bold, Segoe UI
        Gui, %note_id%:Add, Text, vBtnMin%note_id% x%btn_min_x% y%button_Y% w16 h16 Center BackgroundTrans gMinimizeNote, --
    }
    
    ;;∙------∙Close button.
    if IconExists(imageres_path) {
        Gui, %note_id%:Add, Picture, vBtnClose%note_id% x%btn_X_x% y%button_Y% w16 h16 BackgroundTrans Icon260 gCloseNote, %imageres_path%
    } else {
        Gui, %note_id%:Font, s8 c%borderColorHex% Bold, Segoe UI
        Gui, %note_id%:Add, Text, vBtnClose%note_id% x%btn_X_x% y%button_Y% w16 h16 Center BackgroundTrans gCloseNote, X
    }
    
    ;;∙------∙Force redraw to fix transparent backgrounds.
    Gui, %note_id%:Color, % Color(bg, "GUI0x")
Return

;;∙=============================================∙
;;∙======∙NOTE EVENT HANDLERS∙==================∙
;;∙------∙This section contains all the g-label subroutines triggered by user interactions with notes.
;;∙------∙Triggered when the user drags the note window (by clicking anywhere on it).
;;∙------∙Updates the stored position & saves it to the INI file.
NoteDrag:
    current_note_id := WinExist()    ;;∙------∙Get HWND of note being dragged.
    WinGetTitle, current_note_id, ahk_id %current_note_id%    ;;∙------∙Retrieve note_id from window title.
    PostMessage, 0x00A1, 2, 0    ;;∙------∙Send WM_NCLBUTTONDOWN message to simulate clicking title bar.
    Sleep, 50    ;;∙------∙Pause to allow the drag operation to complete.
    WinGetPos, new_x, new_y, , , ahk_id %current_note_id%    ;;∙------∙Get new position after dragging.
    ActiveNotes[current_note_id].x := new_x    ;;∙------∙Store new X position.
    ActiveNotes[current_note_id].y := new_y    ;;∙------∙Store new Y position.
    note_id := current_note_id    ;;∙------∙Set note_id for SaveSingleNote subroutine.
    GoSub, SaveSingleNote    ;;∙------∙Save the new position to INI file.
Return


;;∙------∙Triggered when the user clicks the "X" button on a note.
;;∙------∙Performs a "soft delete", saves the note to a Deleted_ section & closes the window.
;;∙------∙Deleted notes can be restored later via RestoreDeletedNotes tray menu option.
CloseNote:
    current_note_id := WinExist()    ;;∙------∙Get HWND of note being closed.
    WinGetTitle, current_note_id, ahk_id %current_note_id%    ;;∙------∙Retrieve note_id from window title.

    ;;∙------∙Get current content and title before destroying window.
    GuiControlGet, note_content, %current_note_id%:, NoteContent
    StringReplace, note_content, note_content, `n, `%5B`%BR`%5D`%, All    ;;∙------∙Encode line breaks for INI storage.
    GuiControlGet, note_title, %current_note_id%:, NoteTitle
    
    ;;∙------∙Get current window position & size.
    WinGetPos, current_x, current_y, current_w, current_h, %current_note_id%

    ;;∙------∙Save all note properties to "Deleted_" section in INI file.
    ;;∙------∙This preserves the note for potential restoration later.
    IniWrite, % ActiveNotes[current_note_id].bg, %notes_ini%, Deleted_%current_note_id%, bg
    IniWrite, % ActiveNotes[current_note_id].text_color, %notes_ini%, Deleted_%current_note_id%, text_color
    IniWrite, % ActiveNotes[current_note_id].title_color, %notes_ini%, Deleted_%current_note_id%, title_color
    IniWrite, % ActiveNotes[current_note_id].border_color, %notes_ini%, Deleted_%current_note_id%, border_color
    IniWrite, % ActiveNotes[current_note_id].ontop, %notes_ini%, Deleted_%current_note_id%, ontop
    IniWrite, % current_x, %notes_ini%, Deleted_%current_note_id%, x
    IniWrite, % current_y, %notes_ini%, Deleted_%current_note_id%, y
    IniWrite, % current_w, %notes_ini%, Deleted_%current_note_id%, w
    IniWrite, % current_h, %notes_ini%, Deleted_%current_note_id%, h
    IniWrite, % note_content, %notes_ini%, Deleted_%current_note_id%, content
    IniWrite, % note_title, %notes_ini%, Deleted_%current_note_id%, name
    
    ;;∙------∙Remove note from the active notes section of INI file.
    IniDelete, %notes_ini%, %current_note_id%

    ;;∙------∙Remove note from the ActiveNotes object.
    ActiveNotes.Delete(current_note_id)
    
    ;;∙------∙Destroy GUI.
    Gui, %current_note_id%:Destroy

    ;;∙------∙Inform user that the note has been soft-deleted & can be restored.
    MsgBox, 4144, Note Deleted, Note "%note_title%" has been deleted.`nUse tray menu to restore deleted notes if needed.,2
Return


;;∙------∙Triggered when the user clicks the "--" button on a note.
;;∙------∙Hides note window without deleting it. Can be shown again via "Show All Notes".
MinimizeNote:
    current_note_id := WinExist()    ;;∙------∙Get HWND of note being minimized.
    WinGetTitle, current_note_id, ahk_id %current_note_id%    ;;∙------∙Retrieve note_id from window title.
    Gui, %current_note_id%:Hide    ;;∙------∙Hide GUI window (remains in ActiveNotes object).
Return


;;∙------∙Triggered when the user clicks the "T" button on a note.
;;∙------∙Toggles "Always On Top" state of the note window.
ToggleOntop:
    current_note_id := WinExist()
    WinGetTitle, current_note_id, ahk_id %current_note_id%
    current_ontop := ActiveNotes[current_note_id].ontop

    if (current_ontop = 1) {
        ActiveNotes[current_note_id].ontop := 0
        Gui, %current_note_id%:-AlwaysOnTop
        new_icon := 235
    } else {
        ActiveNotes[current_note_id].ontop := 1
        Gui, %current_note_id%:+AlwaysOnTop
        new_icon := 234
    }
    
    ;;∙------∙Update icon using GuiControl.
    imageres_path := A_WinDir "\system32\imageres.dll"
    if IconExists(imageres_path) {
        GuiControl, %current_note_id%:, BtnOntop%current_note_id%, *Icon%new_icon% %imageres_path%
    }

    note_id := current_note_id
    GoSub, SaveSingleNote
Return


;;∙------∙Triggered whenever the content of NoteContent Edit control changes.
;;∙------∙Saves the note to INI file after each keystroke (auto-save functionality).
NoteChanged:
    current_note_id := WinExist()    ;;∙------∙Get HWND of note being edited.
    WinGetTitle, current_note_id, ahk_id %current_note_id%    ;;∙------∙Retrieve note_id from window title.
    note_id := current_note_id    ;;∙------∙Set note_id for SaveSingleNote subroutine.
    GoSub, SaveSingleNote    ;;∙------∙Save the updated content to INI file.
Return


;;∙=============================================∙
;;∙======∙SAVE NOTE FUNCTIONS∙==================∙
;;∙------∙These subroutines handle persisting note data to the StickyNotes.ini file.
;;∙------∙Saves a SINGLE note's current state to the INI file.
;;∙------∙Called after any change to a note (content edits, repositioning, resizing, color changes, etc.).
;;∙------∙Also called by SaveAllNotes during periodic auto-save timer.
;;∙------∙Requires the variable "note_id" to be set before calling.
SaveSingleNote:
    if (note_id = "")    ;;∙------∙Exit if no note_id was provided.
        Return
    
    ;;∙------∙Check if GUI still exists.
    IfWinNotExist, %note_id%
        Return
    
    ;;∙------∙Retrieve current content from Edit control & encode line breaks for INI storage.
    GuiControlGet, note_content, %note_id%:, NoteContent
    StringReplace, note_content, note_content, `n, `%5B`%BR`%5D`%, All    ;;∙------∙Replace actual newlines with "[BR]" marker.
    
    ;;∙------∙Retrieve the current note title from title Edit control.
    GuiControlGet, note_title, %note_id%:, NoteTitle
    
    ;;∙------∙Get current window position & dimensions.
    WinGetPos, current_x, current_y, current_w, current_h, %note_id%

    ;;∙------∙Write all note properties to INI file under section named after the note_id.
    IniWrite, % ActiveNotes[note_id].bg, %notes_ini%, %note_id%, bg
    IniWrite, % ActiveNotes[note_id].text_color, %notes_ini%, %note_id%, text_color
    IniWrite, % ActiveNotes[note_id].title_color, %notes_ini%, %note_id%, title_color
    IniWrite, % ActiveNotes[note_id].border_color, %notes_ini%, %note_id%, border_color
    IniWrite, % ActiveNotes[note_id].ontop, %notes_ini%, %note_id%, ontop
    IniWrite, % current_x, %notes_ini%, %note_id%, x
    IniWrite, % current_y, %notes_ini%, %note_id%, y
    IniWrite, % current_w, %notes_ini%, %note_id%, w
    IniWrite, % current_h, %notes_ini%, %note_id%, h
    IniWrite, % note_content, %notes_ini%, %note_id%, content
    IniWrite, % note_title, %notes_ini%, %note_id%, name

    ;;∙------∙Update ActiveNotes object with latest values to keep it synchronized.
    ;;∙------∙Ensures subsequent operations use current data without re-reading INI.
    ActiveNotes[note_id].x := current_x
    ActiveNotes[note_id].y := current_y
    ActiveNotes[note_id].w := current_w
    ActiveNotes[note_id].h := current_h
    ActiveNotes[note_id].name := note_title
    ActiveNotes[note_id].content := note_content
Return


;;∙------∙Saves ALL currently open notes to INI file.
;;∙------∙Called by SetTimer every 30 seconds for automatic backup.
;;∙------∙Also called manually when exiting script to ensure all changes are preserved.
;;∙------∙Iterates through every note in the ActiveNotes object & saves each one.
SaveAllNotes:
    for note_id, props in ActiveNotes    ;;∙------∙Loop through each active note stored in the object.
    {
        temp_note_id := note_id    ;;∙------∙Store note_id temporarily (SaveSingleNote expects the variable "note_id").
        GoSub, SaveSingleNote    ;;∙------∙Save this note.
    }
Return

;;∙=============================================∙
;;∙======∙DELETE SELECTED NOTES∙=================∙
;;∙------∙Triggered by Ctrl+Alt+D or the "Delete Selected Notes (Permanent)" tray menu option.
;;∙------∙Displays a menu of all active notes, allowing user to permanently delete one or all notes.
;;∙------∙IMPORTANT: This is *PERMANENT* deletion. Notes are *NOT* saved to the Deleted_ section and *CANNOT* be restored.

DeleteSelectedNotes:
    ;;∙------∙Create unique menu name using A_TickCount to avoid conflicts with other menus.
    MenuName := "DeleteMenu_" . A_TickCount
    
    ;;∙------∙Check if there are any active notes to delete.
    if (ActiveNotes.Count() = 0) {
        MsgBox, 4144,, No active notes to delete.,2
        Return
    }
    
    ;;∙------∙Add "Delete All" option at the top of the menu.
    Menu, %MenuName%, Add, Delete All Active Notes (Permanent), DeleteAllActiveNotesPermanent
    Menu, %MenuName%, Add    ;;∙------∙Add separator line.
    
    ;;∙------∙Dynamically add each active note to the menu.
    NoteIndex := 0    ;;∙------∙Counter for generating unique handler labels.
    for note_id, props in ActiveNotes    ;;∙------∙Loop through all active notes.
    {
        NoteIndex++    ;;∙------∙Increment counter (1-based).
        note_name := props.name    ;;∙------∙Get note's display name.
        if (note_name = "")    ;;∙------∙Fallback if name is empty.
            note_name := note_id
        
        ;;∙------∙Store the note_id in a dynamically-named global array variable.
        ;;∙------∙This allows handler subroutines to know which note to delete.
        ;;∙------∙Example: DeleteNoteArray1 := "Note_1", DeleteNoteArray2 := "Note_2", etc.
        DeleteNoteArray%NoteIndex% := note_id
        
        ;;∙------∙Add the menu item, linking it to a dynamically-named handler label.
        ;;∙------∙Example: "Note 1 (Permanent Delete)" calls PermanentDeleteHandler_1.
        Menu, %MenuName%, Add, %note_name% (Permanent Delete), % "PermanentDeleteHandler_" . NoteIndex
    }
    
    ;;∙------∙Make menu name & note count globally available for handler subroutines.
    Global CurrentDeleteMenu := MenuName
    Global DeleteNoteCount := NoteIndex
    
    ;;∙------∙Display menu at current mouse position.
    Menu, %MenuName%, Show
Return

;;∙=============================================∙
;;∙------∙DYNAMIC HANDLERS FOR PERMANENT DELETE (up to 10 notes)∙------∙
;;∙------∙Each handler corresponds to a menu item created dynamically above.
;;∙------∙The handlers simply retrieve the stored note_id and call ProcessPermanentDelete.
;;∙------∙Limited to 10 handlers. If more than 10 notes exist, additional notes won't be deletable via this menu.

PermanentDeleteHandler_1:
    note_to_delete := DeleteNoteArray1    ;;∙------∙Retrieve note_id stored in DeleteNoteArray1.
    GoSub, ProcessPermanentDelete    ;;∙------∙Call the shared deletion subroutine.
Return
;;∙------------------------∙
PermanentDeleteHandler_2:
    note_to_delete := DeleteNoteArray2
    GoSub, ProcessPermanentDelete
Return
;;∙------------------------∙
PermanentDeleteHandler_3:
    note_to_delete := DeleteNoteArray3
    GoSub, ProcessPermanentDelete
Return
;;∙------------------------∙
PermanentDeleteHandler_4:
    note_to_delete := DeleteNoteArray4
    GoSub, ProcessPermanentDelete
Return
;;∙------------------------∙
PermanentDeleteHandler_5:
    note_to_delete := DeleteNoteArray5
    GoSub, ProcessPermanentDelete
Return
;;∙------------------------∙
PermanentDeleteHandler_6:
    note_to_delete := DeleteNoteArray6
    GoSub, ProcessPermanentDelete
Return
;;∙------------------------∙
PermanentDeleteHandler_7:
    note_to_delete := DeleteNoteArray7
    GoSub, ProcessPermanentDelete
Return
;;∙------------------------∙
PermanentDeleteHandler_8:
    note_to_delete := DeleteNoteArray8
    GoSub, ProcessPermanentDelete
Return
;;∙------------------------∙
PermanentDeleteHandler_9:
    note_to_delete := DeleteNoteArray9
    GoSub, ProcessPermanentDelete
Return
;;∙------------------------∙
PermanentDeleteHandler_10:
    note_to_delete := DeleteNoteArray10
    GoSub, ProcessPermanentDelete
Return

;;∙=============================================∙
;;∙------∙SHARED PERMANENT DELETE LOGIC∙------∙
;;∙------∙Called by all PermanentDeleteHandler_X subroutines with note_to_delete set.
ProcessPermanentDelete:
    ;;∙------∙Get note's display name (fallback to note_id if name is empty).
    note_name := ActiveNotes[note_to_delete].name
    if (note_name = "")
        note_name := note_to_delete
    
    ;;∙------∙Confirm with user this action *CANNOT* be undone.
    MsgBox, 4148, Confirm Permanent Delete, Are you sure you want to...`n PERMANENTLY DELETE`n`t`t"%note_name%"?`n`nThis cannot be undone and the note`nwill NOT be saved to deleted notes.
    IfMsgBox, Yes
    {
        ;;∙------∙Delete note's active section from INI file, NO soft delete backup.
        IniDelete, %notes_ini%, %note_to_delete%
        
        ;;∙------∙Remove note from ActiveNotes object.
        ActiveNotes.Delete(note_to_delete)
        
        ;;∙------∙Delete any existing Deleted_ section for this note.
        IniDelete, %notes_ini%, Deleted_%note_to_delete%
        
        ;;∙------∙Destroy window.
        Gui, %note_to_delete%:Destroy
        
        ;;∙------∙Inform user that deletion is complete.
        MsgBox, 4144, Note Permanently Deleted, Note "%note_name%" has been`n  Permanently Deleted`nand cannot be restored.,2
    }
    
    ;;∙------∙Clean up the menu (prevents memory leaks from accumulating menus).
    Menu, %CurrentDeleteMenu%, DeleteAll
Return

;;∙=============================================∙
;;∙------∙DELETE ALL ACTIVE NOTES (PERMANENT)∙------∙
;;∙------∙Called when the user selects "Delete All Active Notes (Permanent)" from the menu.
DeleteAllActiveNotesPermanent:
    ;;∙------∙Confirm with the user, this is a destructive action affecting ALL notes.
    MsgBox, 4148, Confirm Permanent Delete All, Are you sure you want to...`n PERMANENTLY DELETE ALL`n`tactive notes?`n`nThis cannot be undone!
    IfMsgBox, Yes
    {
        ;;∙------∙Create list of all note IDs to delete.
        ;;∙------∙Collect them first since we can't modify ActiveNotes while iterating over it.
        DeleteList := []
        for note_id, props in ActiveNotes
        {
            DeleteList.Push(note_id)    ;;∙------∙Add each note_id to the list.
        }
        
        ;;∙------∙Iterate through list & permanently delete each note.
        for index, note_id in DeleteList
        {
            ;;∙------∙Delete from active notes section, NO soft delete backup.
            IniDelete, %notes_ini%, %note_id%
            
            ;;∙------∙Delete any existing Deleted_ section for this note.
            IniDelete, %notes_ini%, Deleted_%note_id%
            
            ;;∙------∙Destroy window.
            Gui, %note_id%:Destroy
        }
        
        ;;∙------∙Reset ActiveNotes object & counter.
        ActiveNotes := Object()
        note_counter := 0
        
        ;;∙------∙Inform user that all notes are gone.
        MsgBox,4148,, All active notes have been`n  Permanently Deleted`nand cannot be restored.,2
    }
    
    ;;∙------∙Clean up menu.
    Menu, %CurrentDeleteMenu%, DeleteAll
Return


;;∙=============================================∙
;;∙======∙RESTORE DELETED NOTES∙================∙
;;∙------∙Triggered by Ctrl+Alt+R or the "Restore Deleted Notes" tray menu option.
;;∙------∙Displays a menu of all soft-deleted notes (stored in Deleted_ sections), allowing user to restore one or all.
;;∙------∙Restored notes reappear with all their original properties (position, size, colors, content).

RestoreDeletedNotes:
    DeletedSections := []    ;;∙------∙Initialize array to hold all Deleted_ section names.
    
    ;;∙------∙Read all section names from INI file.
    IniRead, AllSections, %notes_ini%
    if (AllSections = "ERROR") {    ;;∙------∙INI file doesn't exist or is empty.
        MsgBox, 4096,, No deleted notes found to restore.,2
        Return
    }
    
    ;;∙------∙Collect all sections that start with "Deleted_".
    Loop, Parse, AllSections, `n    ;;∙------∙Parse newline-separated list of sections.
    {
        if (A_LoopField != "" && SubStr(A_LoopField, 1, 8) = "Deleted_")    ;;∙------∙Check if section name begins with "Deleted_".
        {
            DeletedSections.Push(A_LoopField)    ;;∙------∙Add section name to array.
        }
    }
    
    ;;∙------∙If no deleted sections were found, inform user & exit.
    if (DeletedSections.Count() = 0) {
        MsgBox, 4096,, No deleted notes found to restore.,2
        Return
    }
    
    ;;∙------∙Create unique menu name using A_TickCount.
    MenuName := "RestoreMenu_" . A_TickCount
    
    ;;∙------∙Add "Restore All" option at the top of the menu.
    Menu, %MenuName%, Add, Restore All Deleted Notes, RestoreAllDeleted
    Menu, %MenuName%, Add    ;;∙------∙Separator line.
    
    ;;∙------∙Dynamically add each deleted note to the menu.
    RestoreIndex := 0    ;;∙------∙Counter for generating unique handler labels.
    for index, section in DeletedSections    ;;∙------∙Loop through all deleted sections.
    {
        RestoreIndex++    ;;∙------∙Increment counter (1-based).
        original_id := SubStr(section, 9)    ;;∙------∙Strip "Deleted_" prefix to get the original note_id.
        IniRead, note_name, %notes_ini%, %section%, name    ;;∙------∙Read note's display name from the deleted section.
        if (note_name = "")    ;;∙------∙Fallback if name is empty.
            note_name := original_id
        
        ;;∙------∙Store the full section name in a dynamically-named global array variable.
        ;;∙------∙Allows the handler subroutines to know which section to restore.
        ;;∙------∙Example: RestoreSectionArray1 := "Deleted_Note_1", RestoreSectionArray2 := "Deleted_Note_2", etc.
        RestoreSectionArray%RestoreIndex% := section
        
        ;;∙------∙Add menu item, linking it to a dynamically-named handler label.
        ;;∙------∙Example: "My Note" calls RestoreNoteHandler_1.
        Menu, %MenuName%, Add, %note_name%, % "RestoreNoteHandler_" . RestoreIndex
    }
    
    ;;∙------∙Make the menu name & note count globally available for the handler subroutines.
    Global CurrentRestoreMenu := MenuName
    Global RestoreNoteCount := RestoreIndex
    
    ;;∙------∙Display menu at current mouse position.
    Menu, %MenuName%, Show
Return

;;∙=============================================∙
;;∙------∙DYNAMIC HANDLERS FOR RESTORE NOTES (up to 10)∙------∙
;;∙------∙Each handler corresponds to a menu item created dynamically above.
;;∙------∙The handlers retrieve the stored section name & call ProcessRestoreNote.
;;∙------∙Limited to 10 handlers. If more than 10 deleted notes exist, additional notes won't be restorable via this menu.

RestoreNoteHandler_1:
    restore_section := RestoreSectionArray1    ;;∙------∙Retrieve section name stored in RestoreSectionArray1.
    GoSub, ProcessRestoreNote    ;;∙------∙Call shared restoration subroutine.
Return
;;∙------------------------∙
RestoreNoteHandler_2:
    restore_section := RestoreSectionArray2
    GoSub, ProcessRestoreNote
Return
;;∙------------------------∙
RestoreNoteHandler_3:
    restore_section := RestoreSectionArray3
    GoSub, ProcessRestoreNote
Return
;;∙------------------------∙
RestoreNoteHandler_4:
    restore_section := RestoreSectionArray4
    GoSub, ProcessRestoreNote
Return
;;∙------------------------∙
RestoreNoteHandler_5:
    restore_section := RestoreSectionArray5
    GoSub, ProcessRestoreNote
Return
;;∙------------------------∙
RestoreNoteHandler_6:
    restore_section := RestoreSectionArray6
    GoSub, ProcessRestoreNote
Return
;;∙------------------------∙
RestoreNoteHandler_7:
    restore_section := RestoreSectionArray7
    GoSub, ProcessRestoreNote
Return
;;∙------------------------∙
RestoreNoteHandler_8:
    restore_section := RestoreSectionArray8
    GoSub, ProcessRestoreNote
Return
;;∙------------------------∙
RestoreNoteHandler_9:
    restore_section := RestoreSectionArray9
    GoSub, ProcessRestoreNote
Return
;;∙------------------------∙
RestoreNoteHandler_10:
    restore_section := RestoreSectionArray10
    GoSub, ProcessRestoreNote
Return

;;∙=============================================∙
;;∙------∙SHARED RESTORE LOGIC∙------∙
;;∙------∙Called by all RestoreNoteHandler_X subroutines with restore_section set.
ProcessRestoreNote:
    original_id := SubStr(restore_section, 9)    ;;∙------∙Strip "Deleted_" prefix to get original note_id.
    
    ;;∙------∙Check if a note with this ID already exists as an active note.
    ;;∙------∙Prevents accidentally creating duplicate notes with the same ID.
    if ActiveNotes.Haskey(original_id)
    {
        MsgBox, 4144,, A note with ID %original_id% already exists.`n`tCannot restore.,3
        Return
    }
    
    ;;∙------∙Read all saved properties from the Deleted_ section in INI file.
    ;;∙------∙The last parameter of each IniRead is the default value if key doesn't exist.
    IniRead, saved_bg, %notes_ini%, %restore_section%, bg, %default_note_bg%
    IniRead, saved_text, %notes_ini%, %restore_section%, text_color, %default_note_text%
    IniRead, saved_title, %notes_ini%, %restore_section%, title_color, %default_note_title%
    IniRead, saved_border, %notes_ini%, %restore_section%, border_color, %default_note_color%
    IniRead, saved_content, %notes_ini%, %restore_section%, content, %A_Space%
    IniRead, saved_x, %notes_ini%, %restore_section%, x, %default_x%
    IniRead, saved_y, %notes_ini%, %restore_section%, y, %default_y%
    IniRead, saved_w, %notes_ini%, %restore_section%, w, %default_width%
    IniRead, saved_h, %notes_ini%, %restore_section%, h, %default_height%
    IniRead, saved_ontop, %notes_ini%, %restore_section%, ontop, 1
    IniRead, saved_name, %notes_ini%, %restore_section%, name, %A_Space%
    
    ;;∙------∙Write properties to a new ACTIVE note section (without the "Deleted_" prefix).
    IniWrite, % saved_bg, %notes_ini%, %original_id%, bg
    IniWrite, % saved_text, %notes_ini%, %original_id%, text_color
    IniWrite, % saved_title, %notes_ini%, %original_id%, title_color
    IniWrite, % saved_border, %notes_ini%, %original_id%, border_color
    IniWrite, % saved_ontop, %notes_ini%, %original_id%, ontop
    IniWrite, % saved_x, %notes_ini%, %original_id%, x
    IniWrite, % saved_y, %notes_ini%, %original_id%, y
    IniWrite, % saved_w, %notes_ini%, %original_id%, w
    IniWrite, % saved_h, %notes_ini%, %original_id%, h
    IniWrite, % saved_content, %notes_ini%, %original_id%, content
    IniWrite, % saved_name, %notes_ini%, %original_id%, name
    
    ;;∙------∙Delete the Deleted_ section from INI file (it's now an active note).
    IniDelete, %notes_ini%, %restore_section%
    
    ;;∙------∙Add the restored note to the ActiveNotes object.
    ActiveNotes[original_id] := Object()
    ActiveNotes[original_id].bg := saved_bg
    ActiveNotes[original_id].text_color := saved_text
    ActiveNotes[original_id].title_color := saved_title
    ActiveNotes[original_id].border_color := saved_border
    ActiveNotes[original_id].content := saved_content
    ActiveNotes[original_id].x := saved_x
    ActiveNotes[original_id].y := saved_y
    ActiveNotes[original_id].w := saved_w
    ActiveNotes[original_id].h := saved_h
    ActiveNotes[original_id].ontop := saved_ontop
    ActiveNotes[original_id].name := saved_name
    
    ;;∙------∙Update note_counter if this restored note has a higher number.
    StringTrimLeft, note_num, original_id, 5    ;;∙------∙Extract the number from "Note_X".
    if (note_num > note_counter)
        note_counter := note_num
    
    ;;∙------∙Create GUI window for the restored note.
    note_id := original_id
    GoSub, CreateNoteFromLoaded
    
    ;;∙------∙Clean up menu (prevents memory leaks).
    Menu, %CurrentRestoreMenu%, DeleteAll
Return

;;∙=============================================∙
;;∙------∙RESTORE ALL DELETED NOTES∙------∙
;;∙------∙Called when user selects "Restore All Deleted Notes" from the menu.
RestoreAllDeleted:
    ;;∙------∙Read all section names from INI file.
    IniRead, AllSections, %notes_ini%
    if (AllSections = "ERROR")
        Return
    
    ;;∙------∙Build list of all Deleted_ sections.
    RestoreList := []
    Loop, Parse, AllSections, `n
    {
        if (A_LoopField != "" && SubStr(A_LoopField, 1, 8) = "Deleted_")
        {
            RestoreList.Push(A_LoopField)
        }
    }
    
    ;;∙------∙Iterate through each deleted section & restore it.
    for index, restore_section in RestoreList
    {
        original_id := SubStr(restore_section, 9)    ;;∙------∙Strip "Deleted_" prefix.
        
        ;;∙------∙Skip this note if it already exists as an active note.
        if ActiveNotes.Haskey(original_id)
            continue
        
        ;;∙------∙Read all saved properties from Deleted_ section.
        IniRead, saved_bg, %notes_ini%, %restore_section%, bg, %default_note_bg%
        IniRead, saved_text, %notes_ini%, %restore_section%, text_color, %default_note_text%
        IniRead, saved_title, %notes_ini%, %restore_section%, title_color, %default_note_title%
        IniRead, saved_border, %notes_ini%, %restore_section%, border_color, %default_note_color%
        IniRead, saved_content, %notes_ini%, %restore_section%, content, %A_Space%
        IniRead, saved_x, %notes_ini%, %restore_section%, x, %default_x%
        IniRead, saved_y, %notes_ini%, %restore_section%, y, %default_y%
        IniRead, saved_w, %notes_ini%, %restore_section%, w, %default_width%
        IniRead, saved_h, %notes_ini%, %restore_section%, h, %default_height%
        IniRead, saved_ontop, %notes_ini%, %restore_section%, ontop, 1
        IniRead, saved_name, %notes_ini%, %restore_section%, name, %A_Space%
        
        ;;∙------∙Write the properties to a new ACTIVE note section.
        IniWrite, % saved_bg, %notes_ini%, %original_id%, bg
        IniWrite, % saved_text, %notes_ini%, %original_id%, text_color
        IniWrite, % saved_title, %notes_ini%, %original_id%, title_color
        IniWrite, % saved_border, %notes_ini%, %original_id%, border_color
        IniWrite, % saved_ontop, %notes_ini%, %original_id%, ontop
        IniWrite, % saved_x, %notes_ini%, %original_id%, x
        IniWrite, % saved_y, %notes_ini%, %original_id%, y
        IniWrite, % saved_w, %notes_ini%, %original_id%, w
        IniWrite, % saved_h, %notes_ini%, %original_id%, h
        IniWrite, % saved_content, %notes_ini%, %original_id%, content
        IniWrite, % saved_name, %notes_ini%, %original_id%, name
        
        ;;∙------∙Delete the Deleted_ section from INI file.
        IniDelete, %notes_ini%, %restore_section%
        
        ;;∙------∙Add the restored note to the ActiveNotes object.
        ActiveNotes[original_id] := Object()
        ActiveNotes[original_id].bg := saved_bg
        ActiveNotes[original_id].text_color := saved_text
        ActiveNotes[original_id].title_color := saved_title
        ActiveNotes[original_id].border_color := saved_border
        ActiveNotes[original_id].content := saved_content
        ActiveNotes[original_id].x := saved_x
        ActiveNotes[original_id].y := saved_y
        ActiveNotes[original_id].w := saved_w
        ActiveNotes[original_id].h := saved_h
        ActiveNotes[original_id].ontop := saved_ontop
        ActiveNotes[original_id].name := saved_name
        
        ;;∙------∙Create GUI window for the restored note.
        note_id := original_id
        GoSub, CreateNoteFromLoaded
    }
    
    ;;∙------∙Inform user that restoration is complete.
    MsgBox, 4096,, All deleted notes have been restored.,2
    
    ;;∙------∙Clean up menu.
    Menu, %CurrentRestoreMenu%, DeleteAll
Return

;;∙=============================================∙
;;∙======∙HOTKEYS∙==============================∙
^!n::    ;;∙------∙🔥∙(Ctrl + Alt + N) - Create New Note.
    GoSub, NewNote
Return

^!h::    ;;∙------∙🔥∙(Ctrl + Alt + H) - Hide All Notes.
    for note_id, props in ActiveNotes
        Gui, %note_id%:Hide
Return

^!s::    ;;∙------∙🔥∙(Ctrl + Alt + S) - Show All Notes.
    for note_id, props in ActiveNotes
        Gui, %note_id%:Show
Return

^!r::    ;;∙------∙🔥∙(Ctrl + Alt + R) - Restore Deleted Notes.
    GoSub, RestoreDeletedNotes
Return

^!d::    ;;∙------∙🔥∙(Ctrl + Alt + D) - Permanent Delete.
    GoSub, DeleteSelectedNotes
Return

;;∙=============================================∙
;;∙======∙TRAY MENU∙============================∙
TrayMenu:
Menu, Tray, Tip, %ScriptID%
Menu, Tray, NoStandard
Menu, Tray, Click, 2    ;;∙------∙Double-click to open default action (New Note).
Menu, Tray, Color, ABCDEF
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, New Note, NewNote
Menu, Tray, Icon, New Note, shell32.dll, 1
Menu, Tray, Default, New Note
Menu, Tray, Add
Menu, Tray, Add, Hide All Notes, HideAllNotes
Menu, Tray, Icon, Hide All Notes, shell32.dll, 123
Menu, Tray, Add
Menu, Tray, Add, Show All Notes, ShowAllNotes
Menu, Tray, Icon, Show All Notes, shell32.dll, 55
Menu, Tray, Add
Menu, Tray, Add, Delete Selected Notes (Permanent), DeleteSelectedNotes
Menu, Tray, Icon, Delete Selected Notes (Permanent), shell32.dll, 132
Menu, Tray, Add
Menu, Tray, Add, Restore Deleted Notes, RestoreDeletedNotes
Menu, Tray, Icon, Restore Deleted Notes, shell32.dll, 239
Menu, Tray, Add
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

;;∙------------------------∙
HideAllNotes:
    for note_id, props in ActiveNotes
        Gui, %note_id%:Hide
Return
;;∙------------------------∙
ShowAllNotes:
    for note_id, props in ActiveNotes
        Gui, %note_id%:Show
Return
;;∙------------------------∙
;;∙------------------------∙
Documentation:
    Run, "C:\Program Files\AutoHotkey\AutoHotkey.chm"
Return
;;∙------------------------∙
ShowKeyHistory:
    KeyHistory
Return
;;∙------------------------∙
ShowWindowSpy:
    Run, "C:\Program Files\AutoHotkey\WindowSpy.ahk"
Return

;;∙=============================================∙
;;∙======∙COLOR CONVERTER∙=====================∙
Color(ColorName, Format := "GUI") {
    static colorMap := Object()
    if (colorMap.Count() = 0) {
        colorMap["Black"] := "000000"
        colorMap["Gray"] := "808080"
        colorMap["Silver"] := "C0C0C0"
        colorMap["White"] := "FFFFFF"
        colorMap["Maroon"] := "800000"
        colorMap["Red"] := "FF0000"
        colorMap["Magenta-Red"] := "FF0066"
        colorMap["Rose"] := "FF007F"
        colorMap["Salmon"] := "FA8072"
        colorMap["Light Salmon"] := "FFA07A"
        colorMap["Coral"] := "FF7F50"
        colorMap["Hot Pink"] := "FF69B4"
        colorMap["Deep Pink"] := "FF1493"
        colorMap["Rose Pink"] := "FF66CC"
        colorMap["Pink"] := "FF80FF"
        colorMap["Red-Orange"] := "FF3300"
        colorMap["Orange"] := "FF6600"
        colorMap["Yellow-Red"] := "FF6347"
        colorMap["Yellow-Orange"] := "FF8C00"
        colorMap["Yellow"] := "FFFF00"
        colorMap["Chartreuse"] := "7FFF00"
        colorMap["Olive"] := "808000"
        colorMap["Green"] := "008000"
        colorMap["Lime"] := "00FF00"
        colorMap["Spring Green"] := "00FF7F"
        colorMap["Cyan-Green"] := "00FA9A"
        colorMap["Teal"] := "008080"
        colorMap["Aqua"] := "00FFFF"
        colorMap["Azure"] := "007FFF"
        colorMap["Blue"] := "0000FF"
        colorMap["Navy"] := "000080"
        colorMap["Indigo"] := "8B00FF"
        colorMap["Violet"] := "7F00FF"
        colorMap["Purple"] := "800080"
        colorMap["Fuchsia"] := "FF00FF"
        colorMap["Grey"] := colorMap["Gray"]
        colorMap["Cyan"] := colorMap["Aqua"]
        colorMap["Magenta"] := colorMap["Fuchsia"]
    }

    ColorName := Trim(ColorName)

    ;;∙------∙If it's already a hex color code (6 digits, optional 0x prefix), clean it up.
    if (RegExMatch(ColorName, "^(0x)?[0-9A-Fa-f]{6}$")) {
        hex := RegExReplace(ColorName, "^(0x)", "")
    } else {
        hex := colorMap[ColorName]
        if (hex = "")
            hex := "FFFFFF"    ;;∙------∙Default to white if color name not found.
    }

    if (Format = "GUI")
        return hex    ;;∙------∙Returns 6-digit hex for GUI commands.
    else
        return "0x" . hex    ;;∙------∙Returns 0x-prefixed hex for other commands.
}

;;∙=============================================∙
;;∙======∙GUI DRAG∙=============================∙
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}
Return

;;∙=============================================∙
;;∙======∙TRAY MENU POSITIONING∙================∙
NotifyTrayClick_205:
    CoordMode, Mouse, Screen
    CoordMode, Menu, Screen
    MouseGetPos, mx, my
    Menu, Tray, Show, % mx - 20, % my - 20
Return

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

;;∙=============================================∙
;;∙======∙RELOAD UPON SCRIPT SAVE∙==============∙
UpdateCheck:
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload

;;∙=============================================∙
;;∙======∙EDIT / RELOAD / EXIT∙====================∙
Script·Edit:
    Edit
Return

^Home:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)
    Script·Reload:
        Soundbeep, 1200, 250
    Reload
Return

^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)
    Script·Exit:
        GoSub, SaveAllNotes
        Soundbeep, 1000, 300
    ExitApp
Return
;;∙=============================================∙



;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙

