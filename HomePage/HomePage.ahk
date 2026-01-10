
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
SetTimer, UpdateCheck, 750    ;;∙------∙Sets a timer to call UpdateCheck every 750 milliseconds.
ScriptID := "HomePage"    ;;∙------∙Also change in 'MENU HEADER' at scripts end!!
Menu, Tray, Icon, shell32.dll, 313    ;;∙------∙Sets the system tray icon.
GoSub, TrayMenu
;;∙------------------------------------------------------------------------------------------∙




;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙


#Requires AutoHotkey 1
#NoEnv
#SingleInstance Force
SendMode Input
SetBatchLines -1
SetWinDelay 0
SetWorkingDir %A_ScriptDir%
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.

global TreeData := Object()    ;;∙------∙Store link data for each item.
global selectedItemID := 0
global selectedItemText := ""

;;∙================∙Gui Creation∙================∙
;;∙------∙Create GUI.
Gui, Main:New, +AlwaysOnTop +Resize +MinSize700x500, Localized Homepage
Gui, Color, 858585

;;∙------∙Create TreeView.
Gui, Add, TreeView, w300 h400 vMyTreeView gTreeViewClick AltSubmit

;;∙------∙Create right panel for URL display and editing.
Gui, Add, Text, x320 y10 w100 h25, Link Text:
Gui, Add, Edit, x420 y10 w250 h25 vEditText, 
Gui, Add, Text, x320 y45 w100 h25, URL:
Gui, Add, Edit, x420 y45 w250 h25 vEditURL, 
Gui, Add, Text, x320 y80 w100 h25, Description:
Gui, Add, Edit, x420 y80 w250 h120 vEditDescription Multi, 

;;∙------∙Buttons for editing.
Gui, Add, Button, x320 y210 w80 h30 gSaveLink, &Save
Gui, Add, Button, x410 y210 w80 h30 gAddNewLink, &New
Gui, Add, Button, x500 y210 w80 h30 gDeleteLink, &Delete
Gui, Add, Button, x590 y210 w80 h30 gCancelEdit, &Cancel

;;∙------∙Link display area.
Gui, Add, GroupBox, x320 y250 w350 h200, Quick Open
Gui, Add, Button, x330 y270 w100 h30 gOpenLink1, Open Link 1
Gui, Add, Button, x440 y270 w100 h30 gOpenLink2, Open Link 2
Gui, Add, Button, x550 y270 w100 h30 gOpenLink3, Open Link 3

Gui, Add, Button, x330 y310 w320 h30 gOpenSelectedLink, Open Selected Link
Gui, Add, Button, x330 y350 w320 h30 gCopySelectedLink, Copy Selected URL

Gui, Add, Text, x330 y400 w320 h40 vLinkInfo, Select a link to view/edit details.

;;∙------∙Status bar.
Gui, Add, StatusBar,, Ready. Use menu bar to manage links.

;;∙------∙Menu bar with enhanced options.
Menu, FileMenu, Add, &Add New Root Category, MenuAddRoot
Menu, FileMenu, Add, &Add Child Link, MenuAddChild
Menu, FileMenu, Add, &Edit Current Link, MenuEdit
Menu, FileMenu, Add, &Delete Current Link, MenuDelete
Menu, FileMenu, Add
Menu, FileMenu, Add, &Import Links..., MenuImport
Menu, FileMenu, Add, &Export Links..., MenuExport
Menu, FileMenu, Add
Menu, FileMenu, Add, &Reload, MenuHandler
Menu, FileMenu, Add, E&xit, MenuHandler

Menu, EditMenu, Add, &Expand All, MenuExpandAll
Menu, EditMenu, Add, &Collapse All, MenuCollapseAll
Menu, EditMenu, Add
Menu, EditMenu, Add, &Find Link..., MenuFind

Menu, HelpMenu, Add, &About, MenuHandler

Menu, MenuBar, Add, &File, :FileMenu
Menu, MenuBar, Add, &Edit, :EditMenu
Menu, MenuBar, Add, &Help, :HelpMenu
Gui, Menu, MenuBar

;;∙------∙Load saved data if exists, otherwise initialize with defaults.
LoadTreeData()

;;∙------∙Show GUI.
Gui, Show, x1000 y150 w700 h500
Return
;;∙============================================∙

;;∙========∙Tree Roots & Children∙=================∙
;;∙------∙Initialize tree with default structure.
InitializeTree() {
    ;;∙------∙Clear existing data.
    TreeData := Object()
    
    ;;∙------∙Add root items.
    rootBanking := TV_Add("Banking", 0, "Expand")
    TreeData[rootBanking] := {text: "Banking", url: "https://www.marketwatch.com/", description: "Major online weather information website operated by The Weather Company that provides current local and international weather forecasts, radar maps, severe weather alerts, climate news, and other weather-related data.", parent: 0}
    
    rootNews := TV_Add("News", 0, "Expand")
    TreeData[rootNews] := {text: "News", url: "https://weather.com/", description: "Online weather information website operated by The Weather Company that provides current local and international weather forecasts, radar maps, severe weather alerts, climate news, and other weather-related data.", parent: 0}
    
    rootShopping := TV_Add("Shopping", 0, "Expand")
    TreeData[rootShopping] := {text: "Shopping", url: "https://www.marketwatch.com/", description: "Customer browses the available goods or services presented by one or more retailers", parent: 0}
    
    ;;∙------∙Example children for Banking.
    child1 := TV_Add("JPMorgan Chase", rootBanking)
    TreeData[child1] := {text: "JPMorgan Chase", url: "https://www.jpmorganchase.com/", description: "An American multinational banking institution headquartered in New York City and incorporated in Delaware. It is the largest bank in the United States, and the world's largest bank by market capitalization as of 2025.", parent: rootBanking}
    
    child2 := TV_Add("Bank of America", rootBanking)
    TreeData[child2] := {text: "Bank of America", url: "https://www.bankofamerica.com/", description: "One of the world's largest financial institutions, serving individuals, small- and middle-market businesses and large corporations with a full range of banking, investing, asset management and other financial and risk management products and services.", parent: rootBanking}
    
    child3 := TV_Add("Citigroup", rootBanking)
    TreeData[child3] := {text: "Citigroup", url: "https://www.citigroup.com/global", description: "An American multinational investment bank and financial services company based in New York City. The company was formed in 1998 by the merger of Citicorp, the bank holding company for Citibank, and Travelers; Travelers was spun off from the company in 2002.", parent: rootBanking}
    
    ;;∙------∙Example children for News.
    child4 := TV_Add("The New York Times", rootNews)
    TreeData[child4] := {text: "The New York Times", url: "https://www.nytimes.com/", description: "Newspaper based in Manhattan, New York City. The New York Times covers domestic, national, and international news, and publishes opinion pieces and reviews.", parent: rootNews}
    
    child5 := TV_Add("The Wall Street Journal", rootNews)
    TreeData[child5] := {text: "The Wall Street Journal", url: "https://www.wsj.com/", description: "Newspaper based in Midtown Manhattan, New York City. The newspaper provides extensive coverage of news, especially business and finance.", parent: rootNews}
    
    ;;∙------∙Example children for Shopping.
    child6 := TV_Add("Amazon", rootShopping)
    TreeData[child6] := {text: "Amazon", url: "https://www.amazon.com/", description: "World's largest internet retail platform, expanding its offerings to a wide range of products and services, including electronics, media, and groceries.", parent: rootShopping}
    
    child7 := TV_Add("eBay", rootShopping)
    TreeData[child7] := {text: "eBay", url: "https://www.ebay.com/", description: "Website where individuals and businesses can buy or sell new or second-hand items, from books and clothes to cars and holidays. eBay's key benefits and features.", parent: rootShopping}
    
    child8 := TV_Add("Costco", rootShopping)
    TreeData[child8] := {text: "Costco", url: "https://www.costco.com/", description: "Membership warehouse club, dedicated to bringing our members the best possible prices on quality brand-name merchandise.", parent: rootShopping}
}
;;∙============================================∙


;;∙------∙TreeView click handler.
TreeViewClick:
    if (A_GuiEvent = "S") {    ;;∙------∙Single click.
        selectedItemID := A_EventInfo
        TV_GetText(selectedItemText, selectedItemID)
        
        ;;∙------∙Update edit fields with selected item data.
        if (TreeData.HasKey(selectedItemID)) {
            data := TreeData[selectedItemID]
            GuiControl, Main:, EditText, % data.text
            GuiControl, Main:, EditURL, % data.url
            GuiControl, Main:, EditDescription, % data.description
            
            ;;∙------∙Update link info display.
            GuiControl, Main:, LinkInfo, % "Selected: " data.text "`nURL: " data.url
        } else {
            ;;∙------∙For items without stored data (shouldn't happen, but just in case).
            GuiControl, Main:, EditText, % selectedItemText
            GuiControl, Main:, EditURL, 
            GuiControl, Main:, EditDescription, 
            GuiControl, Main:, LinkInfo, % "Selected: " selectedItemText
        }
        
        SB_SetText("Selected: " selectedItemText)
    }
    else if (A_GuiEvent = "DoubleClick") {
        selectedItemID := A_EventInfo
        if (TreeData.HasKey(selectedItemID) && TreeData[selectedItemID].url != "") {
            Run, % TreeData[selectedItemID].url
            SB_SetText("Opening: " TreeData[selectedItemID].text)
        }
    }
Return

;;∙------∙Button handlers.
SaveLink:
    if (!selectedItemID) {
        MsgBox, 48, No Selection, Please select an item to edit.
        return
    }
    
    GuiControlGet, editText,, EditText
    GuiControlGet, editURL,, EditURL
    GuiControlGet, editDesc,, EditDescription
    
    if (editText = "") {
        MsgBox, 48, Invalid Input, Link text cannot be empty.
        return
    }
    
    ;;∙------∙Update tree item text.
    TV_Modify(selectedItemID, "", editText)
    
    ;;∙------∙Get parent for storage.
    parentID := TV_GetParent(selectedItemID)
    
    ;;∙------∙Update data storage.
    TreeData[selectedItemID] := {text: editText, url: editURL, description: editDesc, parent: parentID}
    
    ;;∙------∙Save to file.
    SaveTreeData()
    
    SB_SetText("Saved: " editText)
Return

AddNewLink:
    ;;∙------∙Check if we have a parent selected.
    parentID := selectedItemID ? selectedItemID : 0
    
    ;;∙------∙Create default data for new item.
    defaultText := "New Link"
    defaultURL := "https://"
    defaultDesc := "Enter description here"
    
    ;;∙------∙Add to tree.
    newItemID := TV_Add(defaultText, parentID, "Select")
    
    ;;∙------∙Add to data storage.
    TreeData[newItemID] := {text: defaultText, url: defaultURL, description: defaultDesc, parent: parentID}
    
    ;;∙------∙Select the new item.
    selectedItemID := newItemID
    TV_GetText(selectedItemText, selectedItemID)
    
    ;;∙------∙Populate edit fields.
    GuiControl, Main:, EditText, % defaultText
    GuiControl, Main:, EditURL, % defaultURL
    GuiControl, Main:, EditDescription, % defaultDesc
    
    ;;∙------∙Save to file.
    SaveTreeData()
    
    SB_SetText("Added new link")
Return

DeleteLink:
    DeleteSelectedLink()
Return

CancelEdit:
    ;;∙------∙Clear edit fields.
    GuiControl, Main:, EditText, 
    GuiControl, Main:, EditURL, 
    GuiControl, Main:, EditDescription, 
    GuiControl, Main:, LinkInfo, Select a link to view/edit details.
    
    ;;∙------∙Deselect tree item.
    TV_Modify(0, "Select")
    selectedItemID := 0
    selectedItemText := ""
    
    SB_SetText("Edit cancelled")
Return

OpenSelectedLink:
    if (selectedItemID && TreeData.HasKey(selectedItemID) && TreeData[selectedItemID].url != "" && TreeData[selectedItemID].url != "https://") {
        Run, % TreeData[selectedItemID].url
        SB_SetText("Opening: " TreeData[selectedItemID].text)
    } else {
        MsgBox, 48, No URL, Selected item has no valid URL.
    }
Return

CopySelectedLink:
    if (selectedItemID && TreeData.HasKey(selectedItemID) && TreeData[selectedItemID].url != "" && TreeData[selectedItemID].url != "https://") {
        Clipboard := TreeData[selectedItemID].url
        SB_SetText("URL copied to clipboard")
    } else {
        MsgBox, 48, No URL, Selected item has no valid URL to copy.
    }
Return

;;∙========∙Quick Open Buttons∙==================∙
;;∙------∙Quick open buttons (you can customize these).
OpenLink1:
    Run, https://www.google.com
Return

OpenLink2:
    Run, https://www.github.com
Return

OpenLink3:
    Run, https://www.stackoverflow.com
Return
;;∙============================================∙

;;∙------∙Menu handlers.
MenuAddRoot:
    InputBox, rootName, Add Root Category, Enter name for new root category:,, 300, 150
    if (!ErrorLevel && rootName != "") {
        newRootID := TV_Add(rootName, 0, "Expand Select")
        TreeData[newRootID] := {text: rootName, url: "", description: "Root category", parent: 0}
        SaveTreeData()
        SB_SetText("Added root category: " rootName)
    }
Return

MenuAddChild:
    if (selectedItemID) {
        InputBox, childName, Add Child Link, Enter name for new child link:,, 300, 150
        if (!ErrorLevel && childName != "") {
            newChildID := TV_Add(childName, selectedItemID, "Select")
            TreeData[newChildID] := {text: childName, url: "https://", description: "Enter description here", parent: selectedItemID}
            
            ;;∙------∙Select and populate edit fields.
            selectedItemID := newChildID
            selectedItemText := childName
            GuiControl, Main:, EditText, % childName
            GuiControl, Main:, EditURL, https://
            GuiControl, Main:, EditDescription, Enter description here
            
            SaveTreeData()
            SB_SetText("Added child link: " childName)
        }
    } else {
        MsgBox, 48, No Selection, Please select a parent item first.
    }
Return

MenuEdit:
    if (!selectedItemID) {
        MsgBox, 48, No Selection, Please select an item to edit.
        return
    }
    
    ;;∙------∙Populate edit fields with selected item data.
    if (TreeData.HasKey(selectedItemID)) {
        data := TreeData[selectedItemID]
        GuiControl, Main:, EditText, % data.text
        GuiControl, Main:, EditURL, % data.url
        GuiControl, Main:, EditDescription, % data.description
        SB_SetText("Editing: " data.text)
    }
Return

MenuDelete:
    DeleteSelectedLink()
Return

MenuImport:
    MsgBox, 64, Info, Import feature would be implemented here.`nYou could import from CSV, JSON, or browser bookmarks.
Return

MenuExport:
    MsgBox, 64, Info, Export feature would be implemented here.`nYou could export to CSV, JSON, or HTML bookmarks.
Return

MenuExpandAll:
    Loop % TV_GetCount()
        TV_Modify(A_Index, "Expand")
    SB_SetText("All categories expanded")
Return

MenuCollapseAll:
    Loop % TV_GetCount()
        TV_Modify(A_Index, "Collapse")
    SB_SetText("All categories collapsed")
Return

MenuFind:
    InputBox, searchText, Find Link, Enter text to search:,, 300, 150
    if (!ErrorLevel && searchText != "") {
        found := false
        for itemID, data in TreeData {
            if (InStr(data.text, searchText) || InStr(data.description, searchText)) {
                TV_Modify(itemID, "Select")
                selectedItemID := itemID
                selectedItemText := data.text
                
                ;;∙------∙Populate edit fields.
                GuiControl, Main:, EditText, % data.text
                GuiControl, Main:, EditURL, % data.url
                GuiControl, Main:, EditDescription, % data.description
                
                found := true
                SB_SetText("Found: " data.text)
                break
            }
        }
        if (!found) {
            SB_SetText("No matches found for: " searchText)
        }
    }
Return

MenuHandler:
    if (A_ThisMenuItem = "&Reload") {
        Reload
    }
    else if (A_ThisMenuItem = "E&xit") {
        ExitApp
    }
    else if (A_ThisMenuItem = "&About") {
        MsgBox, 64, About, Localized Homepage v2.0`nAn AutoHotkey tree-view bookmark manager with full CRUD functionality.`n`nFeatures:`n- Add/Edit/Delete links`n- Menu bar controls`n- Persistent storage`n- Search functionality
    }
Return

;;∙------∙Helper function to delete selected link.
DeleteSelectedLink() {
    if (!selectedItemID) {
        MsgBox, 48, No Selection, Please select an item to delete.
        return
    }
    
    TV_GetText(itemText, selectedItemID)
    MsgBox, 36, Confirm Delete, Are you sure you want to delete: %itemText%?
    IfMsgBox, Yes
    {
        ;;∙------∙Delete from tree.
        TV_Delete(selectedItemID)
        
        ;;∙------∙Delete from data storage.
        TreeData.Delete(selectedItemID)
        
        ;;∙------∙Clear edit fields.
        GuiControl, Main:, EditText, 
        GuiControl, Main:, EditURL, 
        GuiControl, Main:, EditDescription, 
        GuiControl, Main:, LinkInfo, Select a link to view/edit details.
        
        ;;∙------∙Reset selection.
        selectedItemID := 0
        selectedItemText := ""
        
        SaveTreeData()
        SB_SetText("Deleted: " itemText)
    }
    return
}

;;∙------∙Save tree data to file (simple text format).
SaveTreeData() {
    dataFile := A_ScriptDir "\tree_data.txt"
    
    ;;∙------∙Delete existing file.
    FileDelete, %dataFile%
    
    ;;∙------∙Write each item on a separate line.
    ;;∙------∙Format: ID|ParentID|Text|URL|Description
    for itemID, data in TreeData {
        line := itemID "|" data.parent "|" data.text "|" data.url "|" data.description "`n"
        FileAppend, %line%, %dataFile%
    }
    
    return
}

;;∙------∙Load tree data from file.
LoadTreeData() {
    dataFile := A_ScriptDir "\tree_data.txt"
    
    ;;∙------∙Check if file exists.
    IfNotExist, %dataFile%
    {
        InitializeTree()
        return
    }
    
    ;;∙------∙Read file.
    FileRead, fileContent, %dataFile%
    
    ;;∙------∙Check if file is empty.
    if (fileContent = "" || StrLen(Trim(fileContent)) = 0) {
        InitializeTree()
        return
    }
    
    ;;∙------∙Clear existing tree and data.
    TV_Delete()
    TreeData := Object()
    
    ;;∙------∙Create a mapping of old IDs to new IDs.
    idMap := Object()
    idMap[0] := 0
    
    ;;∙------∙First pass: create all items with parent 0.
    tempData := Object()
    Loop, Parse, fileContent, `n, `r
    {
        if (A_LoopField = "")
            continue
        
        ;;∙------∙Parse line: ID|ParentID|Text|URL|Description
        StringSplit, parts, A_LoopField, |
        
        if (parts0 < 5)
            continue
        
        oldID := parts1
        parentID := parts2
        text := parts3
        url := parts4
        description := parts5
        
        ;;∙------∙Store temporarily.
        tempData[oldID] := {parent: parentID, text: text, url: url, description: description}
    }
    
    ;;∙------∙If no data was loaded, initialize defaults.
    if (tempData.Count() = 0) {
        InitializeTree()
        return
    }
    
    ;;∙------∙Second pass: rebuild tree structure.
    ;;∙------∙First add all root items (parent = 0).
    for oldID, data in tempData {
        if (data.parent = 0) {
            newID := TV_Add(data.text, 0, "Expand")
            idMap[oldID] := newID
            TreeData[newID] := {text: data.text, url: data.url, description: data.description, parent: 0}
        }
    }
    
    ;;∙------∙Then add all child items.
    maxAttempts := 100
    attempts := 0
    while (tempData.Count() > 0 && attempts < maxAttempts) {
        attempts++
        itemsAdded := false
        
        for oldID, data in tempData {
            if (data.parent = 0)
                continue
            
            ;;∙------∙Check if parent has been added.
            if (idMap.HasKey(data.parent)) {
                newParentID := idMap[data.parent]
                newID := TV_Add(data.text, newParentID)
                idMap[oldID] := newID
                TreeData[newID] := {text: data.text, url: data.url, description: data.description, parent: newParentID}
                tempData.Delete(oldID)
                itemsAdded := true
            }
        }
        
        ;;∙------∙If no items were added in this pass, break to avoid infinite loop.
        if (!itemsAdded)
            break
    }
    
    return
}

;;∙------∙GUI resizing.
MainGuiSize:
    if (A_EventInfo = 1)    ;;∙------∙Minimized.
        return
        
    ;;∙------∙Resize TreeView.
    GuiControl, Move, MyTreeView, % "h" . (A_GuiHeight - 50) . " w" . 300
    
    ;;∙------∙Resize right panel controls (10px margin from right edge).
    newWidth := A_GuiWidth - 430
    GuiControl, Move, EditText, % "w" . newWidth
    GuiControl, Move, EditURL, % "w" . newWidth
    GuiControl, Move, EditDescription, % "w" . newWidth . " h" . 100
    
    ;;∙------∙Reposition buttons.
    GuiControl, Move, Save, % "y" . (A_GuiHeight - 290)
    GuiControl, Move, New, % "y" . (A_GuiHeight - 290)
    GuiControl, Move, Delete, % "y" . (A_GuiHeight - 290)
    GuiControl, Move, Cancel, % "y" . (A_GuiHeight - 290)
    
    ;;∙------∙Reposition GroupBox and buttons (10px margin from right edge).
    GuiControl, Move, Quick Open, % "y" . (A_GuiHeight - 240) . " w" . (A_GuiWidth - 330)
    groupY := A_GuiHeight - 220
    GuiControl, Move, Open Link 1, % "y" . groupY
    GuiControl, Move, Open Link 2, % "y" . groupY
    GuiControl, Move, Open Link 3, % "y" . groupY
    
    buttonY := groupY + 40
    GuiControl, Move, Open Selected Link, % "y" . buttonY . " w" . newWidth
    GuiControl, Move, Copy Selected URL, % "y" . (buttonY + 40) . " w" . newWidth
    GuiControl, Move, LinkInfo, % "y" . (buttonY + 80) . " w" . newWidth
Return

;;∙------∙Hotkeys
^!N::    ;;∙------∙🔥∙(Ctrl + Alt + N) to add new link.
    Gosub, AddNewLink
Return

^!S::    ;;∙------∙🔥∙(Ctrl + Alt + S) to save.
    Gosub, SaveLink
Return

^!D::    ;;∙------∙🔥∙(Ctrl + Alt + D) to delete.
    Gosub, DeleteLink
Return

^!O::    ;;∙------∙🔥∙(Ctrl +  Alt +O) to open selected link.
    Gosub, OpenSelectedLink
Return

^!C::    ;;∙------∙🔥∙(Ctrl + Alt + C) to copy link.
    Gosub, CopySelectedLink
Return

^F5::   ;;∙------∙🔥∙(Ctrl + F5) to refresh/expand all.
    Gosub, MenuExpandAll
Return

^F6::   ;;∙------∙🔥∙(Ctrl + F6) to collapse all.
    Gosub, MenuCollapseAll
Return

^F2::   ;;∙------∙🔥∙(Ctrl + F2) to edit selected.
    Gosub, MenuEdit
Return

;;∙------∙Close GUI.
MainGuiClose:
    ;;∙------∙Save before closing.
    SaveTreeData()
    ExitApp
Return

WM_LBUTTONDOWNdrag() {    ;;∙------∙Gui Drag Pt 2.
   PostMessage, 0x00A1, 2, 0
}
Return
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
        Soundbeep, 1200, 250
    Reload
Return

 ;;∙------∙EXIT∙----------------------------∙
^Esc:: 
    If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)    ;;∙------∙Double-Tap.
    Script·Exit:    ;;∙------∙Menu Call.
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
HomePage:    ;;∙------∙Suspends hotkeys then pauses script.
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

