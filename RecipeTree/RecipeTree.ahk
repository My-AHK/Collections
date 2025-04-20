
/*∙=====∙NOTES∙===============================================∙
∙--------∙Script∙Defaults∙---------------∙
» Reload Script∙------∙DoubleTap∙------∙🔥∙(Ctrl + [HOME])
» Exit Script∙----------∙DoubleTap∙------∙🔥∙(Ctrl + [Esc])
» Script Updater:  Script auto-reloads upon saved changes.
» Custom Tray Menu w/Positioning.
    ▹Menu Header: Toggles - suspending hotkeys then pausing script.
∙--------∙Origins∙-------------------------∙
» Original Author:  Jack Dunning
» Original Source:  https://www.computoredge.com/AutoHotkey/Free_AutoHotkey_Scripts_and_Apps_for_Learning_and_Generating_Ideas.html#RecipeTree
» Script Function:
    ▹ This version of RecipeTree reads the CSV file RecipeTree.csv and constructs the GUI window and saves again.
    ▹ Includes routines for moving branches up and down
∙=============================================================∙
*/
;;∙------------------------------------------------------------------------------------------∙
;;∙======∙Auto-Execute∙==========================================∙
ScriptID := "RecipeTree"    ;;∙------∙Also change in 'MENU CALLS' at scripts end.
GoSub, AutoExecute
GoSub, TrayMenu
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙



;;∙============================================================∙
;;∙============================================================∙
;;∙============================================================∙
SendMode Input
SetWorkingDir %A_ScriptDir%
OnExit, GuiClose

RecipeChange := 0
gW := 500
gH := 500
GuiVisible := 0    ;;∙------∙Start hidden (0) and show GUI immediately afterward.


Menu, RecipeMenu, Add,Add New Recipe, AddRecipe
Menu, RecipeMenu, Add,Add Ingredient, AddIngredient
Menu, RecipeMenu, Add,Delete Recipe, DeleteBranch
Menu, IngredientMenu, Add,Move Up, ^Up
Menu, IngredientMenu, Add,Move Down, ^Down
Menu, IngredientMenu, Add,Add Ingredient, AddIngredient
Menu, IngredientMenu, Add,Delete Ingredient, DeleteBranch


Gui, default
Gui +AlwaysOnTop -Caption +Border +Resize +Owner
Gui, Margin
Gui, Color, ABCDEF    ;;∙------∙A9ADEA
Gui, Font, cBlue q5

TreeViewHeight := gH - 60    ;;∙------∙Leave space for buttons.
Gui, Add, TreeView, x15 y10 h%TreeViewHeight% vMyTreeView gMyTreeView AltSubmit -ReadOnly Section
Gui, Add, Edit, x+5 ys w%gW% h%TreeViewHeight% vMyEdit gMyEdit

saveB := gW - 55
saveE := saveB -45
saveR := saveE - 45
buttonY := gH - 40    ;;∙------∙Position below the Edit/TreeView.

Gui, Add, Button, x%saveB% y%buttonY% vSave w40 gSave BackgroundTrans, Save
Gui, Add, Button, x%saveE% y%buttonY% w40 gSExit BackgroundTrans, Exit
Gui, Add, Button, x%saveR% y%buttonY% w40 vReload gReloadApp BackgroundTrans, Reload

 Loop, Read, RecipeTree.csv
  {
     Loop, Parse, A_LoopReadLine , CSV
       {
          RowData%A_Index% := A_LoopField
       }
          StringReplace, RowData4, RowData4,|,`n, All

       If RowData2 = 0
        {
          RecipeID := TV_Add(RowData3,0,"Sort")
          %RowData1% := RecipeID
          %RecipeID% := RowData1
          RowText := RecipeID . "text"
          %RowText% := RowData4
        }
       Else
        {
          Ingredient := RowData1 . RowData2
          IngredientID := TV_Add(RowData3, %Rowdata1%)
          %IngredientID% := Ingredient
          RowText := IngredientID . "text"
          %RowText% := RowData4
        }
  }

Gui, Show, x1250 y150 w%gW% h%gH%, RecipeTree    ;;∙------∙Explicitly set initial window size.
Gui, +MinSize%gW%x%gH%    ;;∙------∙Prevent window from being resized smaller than initial size.
GuiVisible := 1    ;;∙------∙Mark GUI as visible after showing it.

Return


MyEdit:
 Gui, Submit, NoHide
 Text := TV_GetSelection() . "text"
 %Text% := MyEdit
 GuiControl, +backgroundFFFFCC, MyTreeView
 RecipeChange := 1
Return

MyTreeView:
 TV_GetText(TreeText, TV_GetSelection())
 Unit := TV_GetSelection()
 Text := TV_GetSelection() . "text"
 GuiControl, , MyEdit, % %Text%
 If A_GuiEvent = E
   {
     GuiControl, +backgroundFFFFCC, MyTreeView
     RecipeChange := 1
   }
Return

Save:
 UpdateFile()
 GuiControl, +backgroundWhite, MyTreeView
 RecipeChange := 0
 TV_Modify(0, "Sort")
Return

SExit:
 Gosub, Save    ;;∙------∙Reuse Save functionality.
 ExitApp
Return

ReloadApp:
    Gosub, Save  ; Save before reloading
    Reload
Return

GuiContextMenu:    ;;∙------∙Launched in response to a right-click or press of the Apps key.
If A_GuiControl <> MyTreeView    ;;∙------∙Display the menu only for clicks inside the ListView.
    return
;;∙------∙Show the menu at the provided coordinates, A_GuiX and A_GuiY.
;;∙------∙These should be used because they provide correct coordinates even if the user pressed the Apps key.
ItemId := A_EventInfo
TV_Modify(ItemID, "Select")
If TV_GetParent(A_EventInfo) = 0
 Menu, RecipeMenu, Show , %A_GuiX%, %A_GuiY%
Else
 Menu, IngredientMenu, Show , %A_GuiX%, %A_GuiY%
Return

GuiSize:
if A_EventInfo = 1    ;;∙------∙Window was minimized/do nothing.
    return
;;∙------∙Calculate available height accounting for button area.
AvailableHeight := A_GuiHeight - 60    ;;∙------∙20 (top margin) + 40 (button area).
;;∙------∙Ensure non-negative height.
AvailableHeight := (AvailableHeight < 0) ? 0 : AvailableHeight
;;∙------∙Resize TreeView and Edit.
GuiControl, Move, MyTreeView, % "H" . AvailableHeight
GuiControl, Move, MyEdit, % "W" . (A_GuiWidth - 275) . " H" . AvailableHeight
;;∙------∙Position both buttons together.
ButtonY := 20 + AvailableHeight + 10
GuiControl, Move, Save, y%ButtonY%
GuiControl, Move, Exit, y%ButtonY%
GuiControl, Move, Reload, y%ButtonY%  ; NEW LINE
Return

GuiClose:    ;;∙------∙Exit the script when user closes TreeView's GUI window.
  If RecipeChange = 0
    ExitApp
  RecipeChange := 0
  MsgBox, 4100, Data Changed! Save?, Data Changed! Save? Click Yes or No? 
  IfMsgBox No    ;;<∙------∙Don't delete!
    ExitApp
  UpdateFile()
  ExitApp
Return

ShowRecipe:
    GuiVisible := !GuiVisible
    if GuiVisible {
        Gui, Show,, RecipeTree
        Menu, Tray, Icon, RecipeTree, shell32.dll, 42
    } else {
        Gui, Hide
        Menu, Tray, Icon, RecipeTree, actioncentercpl.dll, 3
    }
Return

AddRecipe:
     RecipeID := TV_Add("New Recipe",0,"Sort")
     %RecipeID%text := "Enter Recipe Description here."
     TV_Modify(RecipeID, "Select")
Return

AddIngredient:
   If TV_GetParent(ItemID) = 0
       NewAdd :=TV_Add("New Ingredient", ItemID)
   Else
       NewAdd :=TV_Add("New Ingredient", TV_GetParent(ItemID), ItemID)

     %NewAdd%text := "Enter instructions here."
     TV_Modify(NewAdd, "Select")
Return

DeleteBranch:
MsgBox, 4100, Delete Item?, Delete Item? Click Yes or No? 
IfMsgBox No    ;;<∙------∙Don't delete.
  Return
  TV_Delete(ItemID)
Return

UpdateFile()
  {
    FileMove, RecipeTree.csv, RecipeTree.bak, 1
    FileSetAttrib, +H, RecipeTree.bak    ;;∙------∙Sets file attribute as 'hidden'.
    R = 1
    ItemID = 0    ;;∙------∙Causes the loop's first iteration to start the search at the top of the tree.
    Loop
      {
       ItemID := TV_GetNext(ItemID, "Full")  
       if not ItemID  ; No more items in tree.
           break
       TV_GetText(ItemText, ItemID)
       If TV_GetParent(ItemID) = 0
         {
          ParentCode := "R" . R
          ChildCode := 0
          R += 1
          C = 1
         }
       Else
         {
          ChildCode := "C" . C
          C += 1
         }
       TextValue := %ItemID%text
              StringReplace, TextValue, TextValue,", "", All
              StringReplace, TextValue, TextValue,`n,|, All
       FileAppend, "%ParentCode%"`,"%ChildCode%"`,"%ItemText%"`,"%TextValue%" `n, RecipeTree.csv
     }         
   }

#IfWinActive, RecipeTree
^Up::
  ThisOne := TV_GetSelection()
 If TV_GetPrev(ThisOne) != 0
  {
    TV_GetText(MoveName,ThisOne)
    EditText := % %Thisone%text
    If TV_GetPrev(TV_GetPrev(ThisOne)) != 0
     {
       NewAdd :=TV_Add(MoveName, TV_GetParent(ThisOne), TV_GetPrev(TV_GetPrev(ThisOne)))
     }
    Else
     {
       NewAdd :=TV_Add(MoveName, TV_GetParent(ThisOne), "First")
     }
     %NewAdd%text := EditText
     TV_Delete(ThisOne)
     TV_Modify(NewAdd, "Select")
  }
Return

^Down::
 ThisOne := TV_GetSelection()
 If TV_GetNext(ThisOne) != 0
  {
    TV_GetText(MoveName,ThisOne)
     EditText := % %Thisone%text
     NewAdd := TV_Add(MoveName, TV_GetParent(ThisOne), TV_GetNext(ThisOne))
     %NewAdd%text := EditText
     TV_Delete(ThisOne)
     TV_Modify(NewAdd, "Select")
  }  
Return
;;∙============================================================∙
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
Menu, Tray, Icon, shell32.dll, 42    ;;∙------∙Sets the system tray icon (Tree).
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
Menu, Tray, Add, RecipeTree, ShowRecipe
Menu, Tray, Icon, RecipeTree, shell32.dll, 42
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
RecipeTree:    ;;∙------∙Suspends hotkeys then pauses script. (Script Header)
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

