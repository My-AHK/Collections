
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


SetTimer, UpdateCheck, 750    ;;∙------∙Sets a timer to call UpdateCheck every 750 milliseconds.
ScriptID := "My_HomePage"    ;;∙------∙Also change in 'MENU HEADER' at scripts end!!
Menu, Tray, Icon, shell32.dll, 313    ;;∙------∙Sets the system tray icon.
GoSub, TrayMenu
;;∙------------------------------------------------------------------------------------------∙




;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙
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
global passwordVisible := false    ;;∙------∙Password visibility toggle.

;;∙========∙Gui Creation∙=========================∙
;;∙------∙Create GUI.
Gui, Main:New, +AlwaysOnTop +Resize +MinSize700x590 +E0x02000000 +E0x00080000
Gui, Color, 858585
Gui, Font, s10, Segoe UI

;;∙------∙Create TreeView.
Gui, Add, TreeView, w300 h500 vMyTreeView gTreeViewClick AltSubmit

;;∙------∙Create right panel for URL display & editing.
Gui, Font, s9 c0000FF
Gui, Add, Text, x320 y10 w100 h25 c000000 BackGroundTrans, Link Text:
Gui, Add, Edit, x390 y10 w260 h25 vEditText,
Gui, Add, Text, x320 y45 w100 h25 c000000 BackGroundTrans, URL:
Gui, Add, Edit, x390 y45 w260 h25 vEditURL,
Gui, Add, Text, x320 y80 w100 h25 c000000 BackGroundTrans, Description:
Gui, Add, Edit, x390 y80 w260 h80 vEditDescription Multi,

;;∙------∙Add Login, Username, & Password fields.
Gui, Add, Text, x320 y170 w100 h25 c000000 BackGroundTrans, Login:
Gui, Add, Edit, x390 y170 w230 h25 vEditLogin,
Gui, Add, Text, x320 y205 w100 h25 c000000 BackGroundTrans, Username:
Gui, Add, Edit, x390 y205 w230 h25 vEditUserName,
Gui, Font, c000000
Gui, Add, Text, x320 y240 w100 h25 BackGroundTrans, Password:
Gui, Add, Edit, x390 y240 w230 h25 vEditPassword Password,
Gui, Add, Button, x630 y240 w40 h25 gShowPassword vShowPassBtn, VIEW

;;∙------∙Buttons for editing.
Gui, Add, Button, x320 y275 w80 h30 gSaveLink vSaveButton, &Save
Gui, Add, Button, x410 y275 w80 h30 gAddNewLink vNewButton, &Add Child
Gui, Add, Button, x500 y275 w80 h30 gDeleteLink vDeleteButton, &Delete
Gui, Add, Button, x590 y275 w80 h30 gCancelEdit vCancelButton, &Cancel

;;∙------∙Link display area with centered buttons.
Gui, Font, c000000
Gui, Add, GroupBox, x320 y315 w350 h185 vQuickOpenGroup, Quick Open

;;∙------∙Calculate center positions for buttons.
groupBoxWidth := 350
buttonWidth := 100
buttonSpacing := 10
totalButtonsWidth := (buttonWidth * 3) + (buttonSpacing * 2)
startX := 320 + (groupBoxWidth - totalButtonsWidth) // 2

Gui, Add, Button, x%startX% y335 w%buttonWidth% h30 gOpenLink1 vOpenLink1Button, Open Link 1
startX := startX + buttonWidth + buttonSpacing
Gui, Add, Button, x%startX% y335 w%buttonWidth% h30 gOpenLink2 vOpenLink2Button, Open Link 2
startX := startX + buttonWidth + buttonSpacing
Gui, Add, Button, x%startX% y335 w%buttonWidth% h30 gOpenLink3 vOpenLink3Button, Open Link 3

;;∙------∙Center bottom buttons.
wideButtonWidth := 320
wideButtonX := 320 + (groupBoxWidth - wideButtonWidth) // 2

Gui, Add, Button, x%wideButtonX% y375 w%wideButtonWidth% h30 gOpenSelectedLink vOpenSelectedButton, Open Selected Link
Gui, Add, Button, x%wideButtonX% y415 w%wideButtonWidth% h30 gCopySelectedLink vCopySelectedButton, Copy Selected URL
Gui, Add, Button, x%wideButtonX% y455 w%wideButtonWidth% h30 gCopyLoginInfo vCopyLoginButton, Copy Login Info

;;∙------∙Sort button.
sortButtonWidth := 60
sortButtonX := wideButtonX-15
Gui, Add, Button, x%sortButtonX% y520 w%sortButtonWidth% h25 gSortTreeView vSortButton, Sort A-Z

Gui, Font, s8 cSilver, Segoe UI
linkInfoX := sortButtonX + sortButtonWidth + 10
linkInfoWidth := groupBoxWidth - (sortButtonWidth + 10)
Gui, Add, Text, x%linkInfoX% y510 w%linkInfoWidth% h60 vLinkInfo BackGroundTrans, Select a link to view/edit details.

;;∙------∙Status bar.
Gui, Add, StatusBar, vMyStatusBar, Ready. Use menu bar to manage links.

;;∙------∙Menu bar with options.
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

Menu, HelpMenu, Add, &Help, MenuHandler

Menu, MenuBar, Add, &File, :FileMenu
Menu, MenuBar, Add, &Edit, :EditMenu
Menu, MenuBar, Add, &Help, :HelpMenu
Gui, Menu, MenuBar

;;∙------∙Load saved data if exists, otherwise initialize with defaults.
LoadTreeData()

;;∙------∙Show GUI.
Gui, Show, x1000 y150 w700 h590, HomePage

;;∙------∙Sort the TreeView alphabetically upon startup.
Gosub, SortTreeViewOnStartup

Return
;;∙=============================================∙

;;∙------∙Sort tree on startup.
SortTreeViewOnStartup:
    allItems := []
    itemID := 0
    Loop {
        itemID := TV_GetNext(itemID, "Full")
        if (!itemID)
            break

        parentID := TV_GetParent(itemID)
        TV_GetText(itemText, itemID)

        if (TreeData.HasKey(itemID)) {
            allItems.Push({id: itemID, parent: parentID, text: itemText, data: TreeData[itemID]})
        }
    }

    TV_Delete()
    TreeData := Object()

    roots := []
    children := []

    for index, item in allItems {
        if (item.parent = 0)
            roots.Push(item)
        else
            children.Push(item)
    }

    bubbleSort(roots)

    idMap := Object()
    idMap[0] := 0

    for index, item in roots {
        newID := TV_Add(item.text, 0, "Expand")
        idMap[item.id] := newID
        TreeData[newID] := {text: item.data.text, url: item.data.url, description: item.data.description, login: item.data.login, username: item.data.username, password: item.data.password, parent: 0}
    }

    bubbleSort(children)

    for index, item in children {
        if (idMap.HasKey(item.parent)) {
            newParentID := idMap[item.parent]
            newID := TV_Add(item.text, newParentID)
            idMap[item.id] := newID
            TreeData[newID] := {text: item.data.text, url: item.data.url, description: item.data.description, login: item.data.login, username: item.data.username, password: item.data.password, parent: newParentID}
        }
    }

    SaveTreeData()

    selectedItemID := TV_GetNext(0, "Full")
    if (selectedItemID) {
        TV_GetText(selectedItemText, selectedItemID)
        TV_Modify(selectedItemID, "Select")
        if (TreeData.HasKey(selectedItemID)) {
            data := TreeData[selectedItemID]
            GuiControl, Main:, EditText, % data.text
            GuiControl, Main:, EditURL, % data.url
            GuiControl, Main:, EditDescription, % data.description
            GuiControl, Main:, EditLogin, % data.login
            GuiControl, Main:, EditUserName, % data.username
            GuiControl, Main:, EditPassword, % data.password

            loginInfo := data.login ? "Login: " data.login : "No login stored"
            usernameInfo := data.username ? "Username: " data.username : ""
            GuiControl, Main:, LinkInfo, % "Selected: " data.text "`nURL: " data.url "`n" loginInfo "`n" usernameInfo
        }
        UpdateAddButtonLabel()
    }

    SB_SetText("TreeView sorted alphabetically on startup")
Return

;;∙========∙Tree Roots & Children∙=================∙
InitializeTree() {
    TreeData := Object()

    rootBanking := TV_Add("Banking", 0, "Expand")
    TreeData[rootBanking] := {text: "Banking", url: "https://www.marketwatch.com/", description: "Provides financial information, business news, analysis, and stock market data.", login: "", username: "", password: "", parent: 0}

    rootNews := TV_Add("News", 0, "Expand")
    TreeData[rootNews] := {text: "News", url: "https://weather.com/", description: "Online weather information website operated by The Weather Company that provides current local and international weather forecasts, radar maps, severe weather alerts, climate news, and other weather-related data.", login: "", username: "", password: "", parent: 0}

    rootShopping := TV_Add("Shopping", 0, "Expand")
    TreeData[rootShopping] := {text: "Shopping", url: "https://www.google.com/maps/search/Shopping", description: "Search for available goods, services, or retailers", login: "", username: "", password: "", parent: 0}

    child1 := TV_Add("JPMorgan Chase", rootBanking)
    TreeData[child1] := {text: "JPMorgan Chase", url: "https://www.jpmorganchase.com/", description: "An American multinational banking institution headquartered in New York City and incorporated in Delaware. It is the largest bank in the United States, and the world's largest bank by market capitalization as of 2025.", login: "john.doe@email.com", username: "john.doe", password: "Ch@seP@ss123!", parent: rootBanking}

    child2 := TV_Add("Bank of America", rootBanking)
    TreeData[child2] := {text: "Bank of America", url: "https://www.bankofamerica.com/", description: "One of the world's largest financial institutions, serving individuals, small- and middle-market businesses and large corporations with a full range of banking, investing, asset management and other financial and risk management products and services.", login: "jane.smith@email.com", username: "jane.smith", password: "B0A-S3cur3!", parent: rootBanking}

    child3 := TV_Add("Citigroup", rootBanking)
    TreeData[child3] := {text: "Citigroup", url: "https://www.citigroup.com/global", description: "An American multinational investment bank and financial services company based in New York City. The company was formed in 1998 by the merger of Citicorp, the bank holding company for Citibank, and Travelers; Travelers was spun off from the company in 2002.", login: "", username: "", password: "", parent: rootBanking}

    child4 := TV_Add("The New York Times", rootNews)
    TreeData[child4] := {text: "The New York Times", url: "https://www.nytimes.com/", description: "Newspaper based in Manhattan, New York City. The New York Times covers domestic, national, and international news, and publishes opinion pieces and reviews.", login: "nytimes.subscriber@email.com", username: "nytreader", password: "NYT-R3ad3r!", parent: rootNews}

    child5 := TV_Add("The Wall Street Journal", rootNews)
    TreeData[child5] := {text: "The Wall Street Journal", url: "https://www.wsj.com/", description: "Newspaper based in Midtown Manhattan, New York City. The newspaper provides extensive coverage of news, especially business and finance.", login: "", username: "", password: "", parent: rootNews}

    child6 := TV_Add("Amazon", rootShopping)
    TreeData[child6] := {text: "Amazon", url: "https://www.amazon.com/", description: "World's largest internet retail platform, expanding its offerings to a wide range of products and services, including electronics, media, and groceries.", login: "amazon.user@email.com", username: "amazon_buyer", password: "Am@z0n-Sh0p!", parent: rootShopping}

    child7 := TV_Add("eBay", rootShopping)
    TreeData[child7] := {text: "eBay", url: "https://www.ebay.com/", description: "Website where individuals and businesses can buy or sell new or second-hand items, from books and clothes to cars and holidays. eBay's key benefits and features.", login: "ebay.buyer@email.com", username: "ebay_user", password: "", parent: rootShopping}

    child8 := TV_Add("Costco", rootShopping)
    TreeData[child8] := {text: "Costco", url: "https://www.costco.com/", description: "Membership warehouse club, dedicated to bringing our members the best possible prices on quality brand-name merchandise.", login: "", username: "", password: "", parent: rootShopping}
}
;;∙============================================∙

UpdateAddButtonLabel() {
    if (selectedItemID) {
        parentID := TV_GetParent(selectedItemID)
        if (parentID = 0) {
            GuiControl, Main:, NewButton, &Add Child
        } else {
            GuiControl, Main:, NewButton, &Add Sibling
        }
    } else {
        GuiControl, Main:, NewButton, &Add Root
        GuiControl, Main:, LinkInfo, Select a link to view/edit details.`nClick 'Add Root' to add a new category.
    }
}

TreeViewClick:
    if (A_GuiEvent = "S") {
        selectedItemID := A_EventInfo
        TV_GetText(selectedItemText, selectedItemID)

        if (TreeData.HasKey(selectedItemID)) {
            data := TreeData[selectedItemID]
            GuiControl, Main:, EditText, % data.text
            GuiControl, Main:, EditURL, % data.url
            GuiControl, Main:, EditDescription, % data.description
            GuiControl, Main:, EditLogin, % data.login
            GuiControl, Main:, EditUserName, % data.username
            GuiControl, Main:, EditPassword, % data.password

            loginInfo := data.login ? "Login: " data.login : "No login stored"
            usernameInfo := data.username ? "Username: " data.username : ""
            GuiControl, Main:, LinkInfo, % "Selected: " data.text "`nURL: " data.url "`n" loginInfo "`n" usernameInfo
        } else {
            GuiControl, Main:, EditText, % selectedItemText
            GuiControl, Main:, EditURL, 
            GuiControl, Main:, EditDescription, 
            GuiControl, Main:, EditLogin, 
            GuiControl, Main:, EditUserName,
            GuiControl, Main:, EditPassword, 
            GuiControl, Main:, LinkInfo, % "Selected: " selectedItemText
        }

        UpdateAddButtonLabel()
        SB_SetText("    Selected: " selectedItemText)
    }
    else if (A_GuiEvent = "DoubleClick") {
        selectedItemID := A_EventInfo
        if (TreeData.HasKey(selectedItemID) && TreeData[selectedItemID].url != "") {
            Run, % TreeData[selectedItemID].url
            SB_SetText("Opening: " TreeData[selectedItemID].text)
        }
    }
Return

SaveLink:
    if (!selectedItemID) {
        Gui, Main:-AlwaysOnTop
        MsgBox, 48, No Selection, Please select an item to edit.
        Gui, Main:+AlwaysOnTop
        return
    }

    GuiControlGet, editText,, EditText
    GuiControlGet, editURL,, EditURL
    GuiControlGet, editDesc,, EditDescription
    GuiControlGet, editLogin,, EditLogin
    GuiControlGet, editUserName,, EditUserName
    GuiControlGet, editPassword,, EditPassword

    if (editText = "") {
        Gui, Main:-AlwaysOnTop
        MsgBox, 48, Invalid Input, Link text cannot be empty.
        Gui, Main:+AlwaysOnTop
        return
    }

    TV_Modify(selectedItemID, "", editText)
    parentID := TV_GetParent(selectedItemID)
    TreeData[selectedItemID] := {text: editText, url: editURL, description: editDesc, login: editLogin, username: editUserName, password: editPassword, parent: parentID}
    SaveTreeData()
    SB_SetText("Saved: " editText)
Return

AddNewLink:
    Gui, Main:-AlwaysOnTop

    if (selectedItemID = 0) {
        buttonType := "Root"
        promptText := "Enter name for new root category:"
    } else {
        parentID := TV_GetParent(selectedItemID)
        if (parentID = 0) {
            buttonType := "Child"
            promptText := "Enter name for new child link:"
        } else {
            buttonType := "Sibling"
            promptText := "Enter name for new sibling link:"
        }
    }

    InputBox, linkName, Add New Link, %promptText%,, 400, 150
    Gui, Main:+AlwaysOnTop

    if (ErrorLevel) {
        SB_SetText("Add cancelled")
        return
    }

    if (linkName = "") {
        Gui, Main:-AlwaysOnTop
        MsgBox, 48, Invalid Input, Link name cannot be empty.
        Gui, Main:+AlwaysOnTop
        return
    }

    parentID := selectedItemID ? selectedItemID : 0
    newItemID := TV_Add(linkName, parentID, "Select")
    TreeData[newItemID] := {text: linkName, url: "https://", description: "Enter description here", login: "", username: "", password: "", parent: parentID}

    selectedItemID := newItemID
    selectedItemText := linkName

    GuiControl, Main:, EditText, % linkName
    GuiControl, Main:, EditURL, https://
    GuiControl, Main:, EditDescription, Enter description here
    GuiControl, Main:, EditLogin, 
    GuiControl, Main:, EditUserName,
    GuiControl, Main:, EditPassword, 
    GuiControl, Main:, LinkInfo, % "Selected: " linkName "`nURL: https://"

    UpdateAddButtonLabel()
    SaveTreeData()
    SB_SetText("Added " buttonType ": " linkName)
Return

DeleteLink:
    DeleteSelectedLink()
    UpdateAddButtonLabel()
Return

CancelEdit:
    GuiControl, Main:, EditText, 
    GuiControl, Main:, EditURL, 
    GuiControl, Main:, EditDescription, 
    GuiControl, Main:, EditLogin, 
    GuiControl, Main:, EditUserName,
    GuiControl, Main:, EditPassword, 

    TV_Modify(0, "Select")
    selectedItemID := 0
    selectedItemText := ""

    UpdateAddButtonLabel()
    SB_SetText("Edit cancelled")
Return

OpenSelectedLink:
    if (selectedItemID && TreeData.HasKey(selectedItemID) && TreeData[selectedItemID].url != "" && TreeData[selectedItemID].url != "https://") {
        Run, % TreeData[selectedItemID].url
        SB_SetText("Opening: " TreeData[selectedItemID].text)
    } else {
        Gui, Main:-AlwaysOnTop
        MsgBox, 48, No URL, Selected item has no valid URL.
        Gui, Main:+AlwaysOnTop
    }
Return

CopySelectedLink:
    if (selectedItemID && TreeData.HasKey(selectedItemID) && TreeData[selectedItemID].url != "" && TreeData[selectedItemID].url != "https://") {
        Clipboard := TreeData[selectedItemID].url
        SB_SetText("URL copied to clipboard")
    } else {
        Gui, Main:-AlwaysOnTop
        MsgBox, 48, No URL, Selected item has no valid URL to copy.
        Gui, Main:+AlwaysOnTop
    }
Return

CopyLoginInfo:
    if (selectedItemID && TreeData.HasKey(selectedItemID)) {
        data := TreeData[selectedItemID]
        if (data.login != "" || data.username != "" || data.password != "") {
            loginInfo := "Login: " data.login "`nUsername: " data.username "`nPassword: " data.password
            Clipboard := loginInfo
            SB_SetText("Login info copied to clipboard")
        } else {
            Gui, Main:-AlwaysOnTop
            MsgBox, 48, No Login Info, Selected item has no login information stored.
            Gui, Main:+AlwaysOnTop
        }
    } else {
        Gui, Main:-AlwaysOnTop
        MsgBox, 48, No Selection, Please select an item first.
        Gui, Main:+AlwaysOnTop
    }
Return

ShowPassword:
    global passwordVisible

    if (passwordVisible = "")
        passwordVisible := false

    GuiControlGet, passwordText,, EditPassword

    if (!passwordVisible) {
        GuiControl, Main: -Password, EditPassword
        GuiControl, Main:, ShowPassBtn, HIDE
        passwordVisible := true
    } else {
        GuiControl, Main: +Password, EditPassword
        GuiControl, Main:, ShowPassBtn, VIEW
        passwordVisible := false
    }
Return

SortTreeView:
    allItems := []
    itemID := 0
    Loop {
        itemID := TV_GetNext(itemID, "Full")
        if (!itemID)
            break

        parentID := TV_GetParent(itemID)
        TV_GetText(itemText, itemID)

        if (TreeData.HasKey(itemID)) {
            allItems.Push({id: itemID, parent: parentID, text: itemText, data: TreeData[itemID]})
        }
    }

    TV_Delete()
    TreeData := Object()

    roots := []
    children := []

    for index, item in allItems {
        if (item.parent = 0)
            roots.Push(item)
        else
            children.Push(item)
    }

    bubbleSort(roots)

    idMap := Object()
    idMap[0] := 0

    for index, item in roots {
        newID := TV_Add(item.text, 0, "Expand")
        idMap[item.id] := newID
        TreeData[newID] := {text: item.data.text, url: item.data.url, description: item.data.description, login: item.data.login, username: item.data.username, password: item.data.password, parent: 0}
    }

    bubbleSort(children)

    for index, item in children {
        if (idMap.HasKey(item.parent)) {
            newParentID := idMap[item.parent]
            newID := TV_Add(item.text, newParentID)
            idMap[item.id] := newID
            TreeData[newID] := {text: item.data.text, url: item.data.url, description: item.data.description, login: item.data.login, username: item.data.username, password: item.data.password, parent: newParentID}
        }
    }

    SaveTreeData()
    SB_SetText("TreeView sorted alphabetically")

    selectedItemID := TV_GetNext(0, "Full")
    if (selectedItemID) {
        TV_GetText(selectedItemText, selectedItemID)
        TV_Modify(selectedItemID, "Select")
        if (TreeData.HasKey(selectedItemID)) {
            data := TreeData[selectedItemID]
            GuiControl, Main:, EditText, % data.text
            GuiControl, Main:, EditURL, % data.url
            GuiControl, Main:, EditDescription, % data.description
            GuiControl, Main:, EditLogin, % data.login
            GuiControl, Main:, EditUserName, % data.username
            GuiControl, Main:, EditPassword, % data.password

            loginInfo := data.login ? "Login: " data.login : "No login stored"
            usernameInfo := data.username ? "Username: " data.username : ""
            GuiControl, Main:, LinkInfo, % "Selected: " data.text "`nURL: " data.url "`n" loginInfo "`n" usernameInfo
        }
        UpdateAddButtonLabel()
    }
Return

bubbleSort(ByRef arr) {
    n := arr.Length()
    Loop, % n {
        swapped := false
        Loop, % n - A_Index {
            i := A_Index
            if (arr[i].text > arr[i+1].text) {
                temp := arr[i]
                arr[i] := arr[i+1]
                arr[i+1] := temp
                swapped := true
            }
        }
        if (!swapped)
            break
    }
}

;;∙========∙Quick Open Buttons∙==∙(customize)∙=====∙
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
    Gui, Main:-AlwaysOnTop
    InputBox, rootName, Add Root Category, Enter name for new root category:,, 300, 150
    Gui, Main:+AlwaysOnTop

    if (!ErrorLevel && rootName != "") {
        newRootID := TV_Add(rootName, 0, "Expand Select")
        TreeData[newRootID] := {text: rootName, url: "", description: "Root category", login: "", username: "", password: "", parent: 0}
        SaveTreeData()
        selectedItemID := newRootID
        selectedItemText := rootName
        GuiControl, Main:, EditText, % rootName
        GuiControl, Main:, EditURL, 
        GuiControl, Main:, EditDescription, Root category
        GuiControl, Main:, EditLogin, 
        GuiControl, Main:, EditUserName,
        GuiControl, Main:, EditPassword, 
        GuiControl, Main:, LinkInfo, % "Selected: " rootName
        UpdateAddButtonLabel()
        SB_SetText("Added root category: " rootName)
    }
Return

MenuAddChild:
    if (selectedItemID) {
        Gui, Main:-AlwaysOnTop
        InputBox, childName, Add Child Link, Enter name for new child link:,, 300, 150
        Gui, Main:+AlwaysOnTop

        if (!ErrorLevel && childName != "") {
            newChildID := TV_Add(childName, selectedItemID, "Select")
            TreeData[newChildID] := {text: childName, url: "https://", description: "Enter description here", login: "", username: "", password: "", parent: selectedItemID}

            selectedItemID := newChildID
            selectedItemText := childName
            GuiControl, Main:, EditText, % childName
            GuiControl, Main:, EditURL, https://
            GuiControl, Main:, EditDescription, Enter description here
            GuiControl, Main:, EditLogin, 
            GuiControl, Main:, EditUserName,
            GuiControl, Main:, EditPassword, 
            GuiControl, Main:, LinkInfo, % "Selected: " childName "`nURL: https://"

            UpdateAddButtonLabel()
            SaveTreeData()
            SB_SetText("Added child link: " childName)
        }
    } else {
        Gui, Main:-AlwaysOnTop
        MsgBox, 48, No Selection, Please select a parent item first.
        Gui, Main:+AlwaysOnTop
    }
Return

MenuEdit:
    if (!selectedItemID) {
        Gui, Main:-AlwaysOnTop
        MsgBox, 48, No Selection, Please select an item to edit.
        Gui, Main:+AlwaysOnTop
        return
    }

    if (TreeData.HasKey(selectedItemID)) {
        data := TreeData[selectedItemID]
        GuiControl, Main:, EditText, % data.text
        GuiControl, Main:, EditURL, % data.url
        GuiControl, Main:, EditDescription, % data.description
        GuiControl, Main:, EditLogin, % data.login
        GuiControl, Main:, EditUserName, % data.username
        GuiControl, Main:, EditPassword, % data.password

        GuiControl, Focus, EditText
        SB_SetText("Editing: " data.text " - Make changes and click Save")
    }
Return

MenuDelete:
    DeleteSelectedLink()
    UpdateAddButtonLabel()
ReturnMenuDelete:
    DeleteSelectedLink()
    ;;∙------∙Update Add button after deletion.
    UpdateAddButtonLabel()
Return

MenuImport:
    Gui, Main:-AlwaysOnTop
    MsgBox, 64, Info, Import feature would be implemented here.`nYou could import from CSV, JSON, or browser bookmarks.
    Gui, Main:+AlwaysOnTop
Return

MenuExport:
    Gui, Main:-AlwaysOnTop
    MsgBox, 64, Info, Export feature would be implemented here.`nYou could export to CSV, JSON, or HTML bookmarks.
    Gui, Main:+AlwaysOnTop
Return

MenuExpandAll:
    itemID := 0
    Loop {
        itemID := TV_GetNext(itemID, "Full")
        if (!itemID)
            break
        TV_Modify(itemID, "Expand")
    }
    SB_SetText("All categories expanded")
Return

MenuCollapseAll:
    ;;∙------∙Get all items first while expanded.
    allItems := []
    itemID := 0
    Loop {
        itemID := TV_GetNext(itemID, "Full")
        if (!itemID)
            break
        allItems.Insert(1, itemID)    ;;∙------∙Insert at beginning for reverse order.
    }

    ;;∙------∙Collapse each item.
    for index, id in allItems {
        TV_Modify(id, "-Expand")
    }
    SB_SetText("All categories collapsed")
Return

MenuFind:
    Gui, Main:-AlwaysOnTop
    InputBox, searchText, Find Link, Enter text to search:,, 300, 150
    Gui, Main:+AlwaysOnTop
    if (!ErrorLevel && searchText != "") {
        found := false
        for itemID, data in TreeData {
            if (InStr(data.text, searchText) || InStr(data.description, searchText) || InStr(data.login, searchText) || InStr(data.username, searchText)) {
                TV_Modify(itemID, "Select")
                selectedItemID := itemID
                selectedItemText := data.text

                ;;∙------∙Populate edit fields.
                GuiControl, Main:, EditText, % data.text
                GuiControl, Main:, EditURL, % data.url
                GuiControl, Main:, EditDescription, % data.description
                GuiControl, Main:, EditLogin, % data.login
                GuiControl, Main:, EditUserName, % data.username
                GuiControl, Main:, EditPassword, % data.password

                ;;∙------∙Update LinkInfo.
                loginInfo := data.login ? "Login: " data.login : "No login stored"
                usernameInfo := data.username ? "Username: " data.username : ""
                GuiControl, Main:, LinkInfo, % "Selected: " data.text "`nURL: " data.url "`n" loginInfo "`n" usernameInfo

                found := true
                SB_SetText("Found: " data.text)
                UpdateAddButtonLabel()
                break
            }
        }
        if (!found) {
            SB_SetText("No matches found for: " searchText)
        }
    }
Return

;;∙------∙ABOUT.
MenuHandler:
    if (A_ThisMenuItem = "&Reload") {
        Reload
    }
    else if (A_ThisMenuItem = "E&xit") {
        ExitApp
    }
    else if (A_ThisMenuItem = "&Help") {
        Gui, Main:-AlwaysOnTop
        
        ;;∙------∙Create merged Help GUI with tabs.
        Gui, Help:New, +AlwaysOnTop +Resize -MinimizeBox, HomePage - Help & Documentation
        Gui, Color, 858585
        Gui, Font, s10, Segoe UI
        
        ;;∙------∙Add tabs.
        Gui, Add, Tab3, x10 y10 w680 h530 vMainTab, Basics|Hotkeys|Features|Buttons|Adding|Editing|Managing|Tips / Q&&A
        
;;∙========∙TAB 1: BASICS∙=================∙
        Gui, Tab, 1
        Gui, Font, s10 Bold, Segoe UI
        Gui, Add, Text, x20 y40 w660 h20, DATA FILE LOCATION:
        Gui, Font, s9 cBlack Norm, Consolas
        Gui, Add, Text, x20 y60 c0000FF w660 h20, %A_ScriptDir%\tree_data.txt
        
        Gui, Font, s10 Bold, Segoe UI
        Gui, Add, Text, x20 y90 w660 h20, INTERFACE OVERVIEW:
        Gui, Font, s9 cBlack Norm, Consolas
        
        basicsText1 =
        (

LEFT PANEL (TreeView):
• Hierarchical display of all your links
• Click once to select an item
• Double-click to open the link
• Tree-based organization with expandable nodes

RIGHT PANEL (Edit Fields):
• Link Text: Display name in the tree
• URL: Web address (starts with http:// or https://)
• Description: Details about the link
• Login/Username/Password: Optional credential storage
• VIEW/HIDE: Toggle password visibility

BUTTONS:
• Save: Apply changes to selected item
• Add Child/Sibling/Root: Context-sensitive adding
• Delete: Remove selected item (with confirmation)
• Cancel: Clear selection and edit fields

        )
        
        Gui, Add, Edit, x20 y110 w660 h200 -Background ReadOnly -Wrap VScroll, %basicsText1%
        
        Gui, Font, s10 Bold, Segoe UI
        Gui, Add, Text, x20 y320 w660 h20, GETTING STARTED:
        Gui, Font, s9 cBlack Norm, Consolas
        
        basicsText2 =
        (

1. INITIAL SETUP:
   • The tree comes pre-loaded with sample categories
   • You can keep, modify, or delete these as needed
   • Your data is automatically saved to tree_data.txt

2. SELECTING ITEMS:
   • Click any item in the tree to view/edit its details
   • The right panel updates with the item's information
   • Status bar shows current selection

3. NAVIGATION:
   • Use mouse or arrow keys to navigate the tree
   • Press Space to expand/collapse selected category
   • Home/End keys jump to first/last item

4. FIRST STEPS:
   • Browse the sample categories to understand structure
   • Try editing a sample item to learn the workflow
   • Practice adding a new category and child link

        )
        
        Gui, Add, Edit, x20 y340 w660 h180 -Background ReadOnly -Wrap VScroll, %basicsText2%
        
;;∙========∙TAB 2: HOTKEYS∙=================∙
        Gui, Tab, 2
        Gui, Font, s10 Bold, Segoe UI
        Gui, Add, Text, x20 y40 w660 h20, KEYBOARD SHORTCUTS:
        Gui, Font, s9 cBlack Norm, Consolas
        
        hotkeysText1 =
        (

Ctrl+Alt+N    Add new link (opens input dialog)
Ctrl+Alt+S    Save current edits
Ctrl+Alt+D    Delete selected item (with confirmation)
Ctrl+Alt+O    Open selected link in browser
Ctrl+Alt+C    Copy URL to clipboard
Ctrl+Alt+L    Copy login credentials
Ctrl+F2       Edit selected item (focus on text field)
Ctrl+F5       Expand all categories
Ctrl+F6       Collapse all categories

        )
        
        Gui, Add, Edit, x20 y60 w660 h160 -Background ReadOnly -Wrap VScroll, %hotkeysText1%
        
        Gui, Font, s10 Bold, Segoe UI
        Gui, Add, Text, x20 y230 w660 h20, MENU ALTERNATIVES:
        Gui, Font, s9 cBlack Norm, Consolas
        
        hotkeysText2 =
        (

-All Functions Are Available Through The Menu Bar-

FILE MENU:
• Add New Root Category
• Add Child Link
• Edit Current Link
• Delete Current Link
• Import Links (framework ready)
• Export Links (framework ready)
• Reload application
• Exit

EDIT MENU:
• Expand All categories
• Collapse All categories
• Find Link (search across all fields)

HELP MENU:
• About (this window)
• How To Use (comprehensive guide)

        )
        
        Gui, Add, Edit, x20 y250 w660 h160 -Background ReadOnly -Wrap VScroll, %hotkeysText2%
        
        Gui, Font, s10 Bold, Segoe UI
        Gui, Add, Text, x20 y420 w660 h20, QUICK ACTIONS:
        Gui, Font, s9 cBlack Norm, Consolas
        
        hotkeysText3 =
        (

QUICK OPEN BUTTONS (Top row):
• Three customizable buttons for favorite sites
• Edit OpenLink1, OpenLink2, OpenLink3 functions in script
• Defaults: Google, GitHub, Stack Overflow

ACTION BUTTONS:
• Open Selected Link: Opens URL in default browser
• Copy Selected URL: Copies URL to clipboard
• Copy Login Info: Copies formatted credentials

        )
        
        Gui, Add, Edit, x20 y440 w660 h80 -Background ReadOnly -Wrap VScroll, %hotkeysText3%
        
;;∙========∙TAB 3: FEATURES∙=================∙
        Gui, Tab, 3
        Gui, Font, s10 Bold, Segoe UI
        Gui, Add, Text, x20 y40 w660 h20, FEATURES && CAPABILITIES:
        Gui, Font, s9 cBlack Norm, Consolas
        
        featuresText =
        (

TREE-BASED ORGANIZATION:
• Hierarchical categorization with expandable nodes
• Drag-and-drop GUI for easy positioning
• Alphabetical sorting with persistent structure
• Root categories and child links

COMPREHENSIVE LINK MANAGEMENT:
• Store URLs, descriptions, and metadata
• Quick one-click access to frequently used links
• Copy URLs and login information to clipboard
• Double-click tree items to open links

SECURE CREDENTIAL STORAGE:
• Store login, username, and password fields
• Password visibility toggle with secure masking
• Copy credentials as formatted text
• All data stored locally in plain text file

DATA PERSISTENCE:
• Automatic save/load from tree_data.txt
• Import/export capabilities (framework implemented)
• No database required - simple text-based storage
• Backup-friendly file format

SEARCH & NAVIGATION:
• Find functionality across all text fields
• Expand/collapse all categories
• Keyboard shortcuts for common actions
• Context-sensitive button labels

CUSTOMIZATION:
• Resizable interface with smart layout
• Editable Quick Open buttons for favorite sites
• Adjustable panels for optimal workflow
• Modify script for personalized experience

ORGANIZATION TOOLS:
• Sort A-Z button for alphabetical ordering
• Status bar with real-time feedback
• Context menus and menu bar access
• Visual feedback for all operations

        )
        
        Gui, Add, Edit, x20 y60 w660 h460 -Background ReadOnly -Wrap VScroll, %featuresText%
        
;;∙========∙TAB 4: BUTTONS∙=================∙
        Gui, Tab, 4
        Gui, Font, s10 Bold, Segoe UI
        Gui, Add, Text, x20 y40 w660 h20, BUTTON BEHAVIOR:
        Gui, Font, s9 cBlack Norm, Consolas
        
        buttonsText =
        (

CONTEXT-SENSITIVE ADD BUTTON:
The 'Add Child' button changes based on selection:

When NO item is selected:
• Button shows: "Add Root"
• Adds a new top-level category
• Use 'Cancel' to clear selection for this mode

When a ROOT category is selected:
• Button shows: "Add Child"
• Adds item under selected category

When a CHILD item is selected:
• Button shows: "Add Sibling"
• Adds item at same level as selection

VISUAL EXAMPLE:
[Banking] (root) → Click 'Add Child' → Adds under Banking
[JPMorgan] (child) → Click 'Add Sibling' → Adds next to JPMorgan
[No selection] → Click 'Add Root' → Creates new top category

SAVE BUTTON:
• Applies all changes to selected item
• Updates tree display if Link Text changed
• Saves to tree_data.txt automatically
• Shows confirmation in status bar

DELETE BUTTON:
• Removes selected item from tree
• Shows confirmation dialog before deletion
• Deletion is permanent (no undo)
• Clears edit fields after deletion

CANCEL BUTTON:
• Clears current selection
• Discards any unsaved edits
• Changes Add button to 'Add Root' mode
• Useful for starting fresh

VIEW/HIDE PASSWORD BUTTON:
• Toggles password field visibility
• VIEW: Shows password in plain text
• HIDE: Masks password with dots
• Does not affect stored password value

SORT A-Z BUTTON:
• Alphabetizes entire tree structure
• Maintains parent-child relationships
• Sorts root categories first, then children
• Preserves all data during sort

QUICK OPEN BUTTONS (Customizable):
• Open Link 1: Default = Google
• Open Link 2: Default = GitHub
• Open Link 3: Default = Stack Overflow
• Edit script functions to customize

ACTION BUTTONS:
• Open Selected Link: Launches URL in browser
• Copy Selected URL: Clipboard copy with feedback
• Copy Login Info: Multi-line credential copy

        )
        
        Gui, Add, Edit, x20 y60 w660 h460 -Background ReadOnly -Wrap VScroll, %buttonsText%
        
;;∙========∙TAB 5: ADDING∙=================∙
        Gui, Tab, 5
        Gui, Font, s10 Bold, Segoe UI
        Gui, Add, Text, x20 y40 w660 h20, ADDING NEW ITEMS:
        Gui, Font, s9 cBlack Norm, Consolas
        
        addingText =
        (

ADDING ROOT CATEGORIES (Top-level folders):

METHOD A - Via Menu:
1. Click 'File' → 'Add New Root Category'
2. Enter name and press OK
3. New category appears in tree

METHOD B - Using Cancel Button:
1. Click 'Cancel' button to clear selection
2. 'Add Child' button changes to 'Add Root'
3. Click 'Add Root' and enter category name
4. New root appears at top level

METHOD C - When nothing is selected:
1. If no item is selected in the tree
2. The 'Add Child' button shows as 'Add Root'
3. Click to add new top-level category

----------------------------------
ADDING CHILD LINKS (Under categories):
1. Select a root category (like "Banking")
2. Click 'Add Child' button
3. Enter name for the new link
4. Fill in URL and other details in edit fields
5. Click 'Save' to store permanently

----------------------------------
ADDING SIBLING LINKS (Same level):
1. Select an existing child link
2. 'Add Child' button changes to 'Add Sibling'
3. Click to add item at same hierarchy level
4. Enter name and details
5. Save as usual

----------------------------------
WORKFLOW TIPS:
To add multiple root categories quickly:
1. Click 'Cancel' (clears selection)
2. Click 'Add Root' and enter name
3. Repeat steps 1-2 as needed

To build a category structure:
1. Add root category first
2. Select the root
3. Add child links one by one
4. Fill in details and save each

----------------------------------
BEST PRACTICES:
• Plan your category structure before adding many items
• Use descriptive names for easy searching later
• Add URLs with http:// or https:// prefix
• Include descriptions for future reference
• Save after editing each item's details

        )
        
        Gui, Add, Edit, x20 y60 w660 h460 -Background ReadOnly -Wrap VScroll, %addingText%
        
;;∙========∙TAB 6: EDITING∙=================∙
        Gui, Tab, 6
        Gui, Font, s10 Bold, Segoe UI
        Gui, Add, Text, x20 y40 w660 h20, EDITING EXISTING ITEMS:
        Gui, Font, s9 cBlack Norm, Consolas
        
        editingText =
        (

BASIC EDITING WORKFLOW:
1. Select an item in the tree
2. Make changes in the right panel fields
3. Click 'Save' to update
4. Changes appear immediately


----------------------------------
FIELD DESCRIPTIONS:
Link Text:
• The name displayed in the tree
• Keep it short and descriptive
• Changing this updates the tree display
• Required field (cannot be empty)

URL:
• The web address
• Must include http:// or https://
• Can be left blank for categories (folders)
• Example: https://www.example.com
• Double-clicking tree item opens this URL

Description:
• Additional information about the link
• Can be multiple lines
• Useful for notes or reminders
• Describes purpose or content

Login/Username/Password:
• Optional credential storage
• All three fields are independent
• Use VIEW/HIDE to toggle password visibility
• Copy Login Info button exports all three

IMPORTANT NOTES:
• Changes are NOT saved until you click 'Save'
• 'Cancel' discards unsaved changes
• Double-clicking a tree item OPENS the URL (doesn't edit)
• Use 'File → Edit Current Link' for quick edit focus

UPDATING MULTIPLE ITEMS:
1. Select first item, edit fields, click Save
2. Select next item, edit fields, click Save
3. Repeat as needed
4. Each Save operation is independent

PASSWORD MANAGEMENT:
• Click VIEW to see password in plain text
• Click HIDE to mask password with dots
• Password field always stores actual text
• Visibility toggle only affects display
• Consider security when using VIEW in public

EDITING TIPS:
• Use Find feature to locate items quickly
• Keep URLs updated if websites change
• Add descriptions for future reference
• Test URLs periodically to ensure they work
• Use consistent naming conventions

        )
        
        Gui, Add, Edit, x20 y60 w660 h460 -Background ReadOnly -Wrap VScroll, %editingText%
        
;;∙========∙TAB 7: MANAGING∙=================∙
        Gui, Tab, 7
        Gui, Font, s10 Bold, Segoe UI
        Gui, Add, Text, x20 y40 w660 h20, MANAGING YOUR COLLECTION:
        Gui, Font, s9 cBlack Norm, Consolas
        
        managingText =
        (

ORGANIZING YOUR TREE:
----------------------------------
SORTING:
• Click 'Sort A-Z' button to alphabetize entire tree
• Sorting maintains parent-child relationships
• Root categories sorted first, then children within each
• Structure remains logical after sort

EXPANDING/COLLAPSING:
• Click triangles next to categories
• Use 'Edit → Expand All' to show everything
• Use 'Edit → Collapse All' to hide details
• Ctrl+F5 and Ctrl+F6 keyboard shortcuts available

DELETING ITEMS:
1. Select the item to delete
2. Click 'Delete' button or use 'File → Delete'
3. Confirm deletion in the dialog
⚠️ WARNING: Deletion is permanent and cannot be undone!

SEARCHING:
• Use 'Edit → Find Link...' menu
• Searches: names, URLs, descriptions, login, username
• First matching item is selected automatically
• Search is case-insensitive
• Status bar shows if match found


DATA MANAGEMENT:
----------------------------------
File Location:
• All data saves to: tree_data.txt
• File is in the same folder as the script
• Plain text format with pipe (|) separators
• Easy to backup or edit manually (advanced users)

Auto-Save:
• Data saves automatically when you click Save button
• Also saves on application exit
• No need to manually save files
• Tree structure persists between sessions

BACKUP STRATEGY:
1. Locate tree_data.txt in script folder
2. Copy to another location periodically
3. Rename with date: tree_data_2025-01-15.txt
4. Restore by replacing current file with backup
5. Backup before major reorganization

IMPORT/EXPORT (Framework Ready):
• Menu options available for future expansion
• Import from CSV, JSON, or browser bookmarks
• Export to various formats for sharing
• Contact developer for custom implementations

MAINTENANCE:
• Periodically review and update links
• Remove dead or outdated URLs
• Reorganize categories as collection grows
• Use Find feature to locate unused item
• Keep descriptions current and helpful

        )
        
        Gui, Add, Edit, x20 y60 w660 h460 -Background ReadOnly -Wrap VScroll, %managingText%
        
;;∙========∙TAB 8: TIPS & Q&A∙=================∙
        Gui, Tab, 8
        Gui, Font, s10 Bold, Segoe UI
        Gui, Add, Text, x20 y40 w660 h20, TIPS && COMMON QUESTIONS:
        Gui, Font, s9 cBlack Norm, Consolas
        
        tipsText =
        (

WORKFLOW TIPS:
----------------------------------
1. START WITH STRUCTURE:
   • Create root categories first (Shopping, Banking, etc.)
   • Then add links under appropriate categories
   • Use descriptive names for easy searching

2. USING THE CANCEL BUTTON:
   • Click 'Cancel' when you want to:
     - Clear current selection
     - Access 'Add Root' functionality
     - Discard unsaved edits
     - Start fresh

3. PASSWORD SECURITY:
   • Only store passwords for trusted sites
   • Remember: tree_data.txt is plain text
   • Use VIEW/HIDE to verify entries
   • Consider using a dedicated password manager for sensitive data

4. ORGANIZATION STRATEGIES:
   • Keep related links together in categories
   • Use empty categories as placeholders
   • Sort alphabetically for consistency
   • Use consistent naming conventions


COMMON QUESTIONS & SOLUTIONS:
----------------------------------
Q: "Add Root" button not showing?
A: Click 'Cancel' to clear selection

Q: URL won't open?
A: Ensure URL starts with http:// or https://

Q: Changes lost after editing?
A: Always click 'Save' after editing fields

Q: Can't find a link?
A: Use 'Edit → Find Link...' to search

Q: Password shows as dots?
A: Click VIEW button to see password text

Q: Tree looks scrambled after sort?
A: This is normal - sort organizes alphabetically

Q: How do I backup my data?
A: Copy tree_data.txt to a safe location

Q: Can I edit tree_data.txt manually?
A: Yes, but close the application first

Q: What if I accidentally delete something?
A: Restore from your most recent backup

Q: How many links can I store?
A: Thousands - application is lightweight


DATA SAFETY:
• Backup tree_data.txt regularly
• File is plain text - be careful with passwords
• Consider encryption for sensitive credentials
• Store backup in cloud or external drive
• Test your backup by restoring it
----------------------------------
CUSTOMIZATION:
• Edit script to change quick-open links
• Search for OpenLink1, OpenLink2, OpenLink3
• Modify colors in GUI creation section
• Add your own hotkeys for personal workflow
• Change default categories in InitializeTree()
----------------------------------
PERFORMANCE:
• Application is lightweight and fast
• Works well with hundreds of links
• Sorting may take a moment with large collections
• Memory usage remains low
• No internet connection required

        )
        
        Gui, Add, Edit, x20 y60 w660 h460 -Background ReadOnly -Wrap VScroll, %tipsText%
        
        ;;∙------∙End tabs and add OK button
        Gui, Tab
Gui, Font, s10 Bold, Arial
        Gui, Add, Button, x640 y550 w50 h30 gCloseHelp Default, &OK
        Gui, Font, Norm
        Gui, Show, w700 h590
    }
Return

CloseHelp:
    Gui, Help:Destroy
    Gui, Main:+AlwaysOnTop
Return


;;∙------∙Delete selected link.
DeleteSelectedLink() {
    Gui, Main:Default

    if (!selectedItemID)
        selectedItemID := TV_GetSelection()

    if (!selectedItemID) {
        MsgBox, 48, No Selection, Please select an item to delete.
        return
    }


    TV_GetText(itemText, selectedItemID)

    Gui, Main:-AlwaysOnTop
    MsgBox, 36, Confirm Delete, Are you sure you want to delete: %itemText%?
    Gui, Main:+AlwaysOnTop

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
        GuiControl, Main:, EditLogin, 
        GuiControl, Main:, EditUserName,
        GuiControl, Main:, EditPassword, 
        GuiControl, Main:, LinkInfo, Select a link to view/edit details.

        ;;∙------∙Reset selection.
        selectedItemID := 0
        selectedItemText := ""

        SaveTreeData()
        SB_SetText("Deleted: " itemText)
    }
    return
}

;;∙------∙Save tree data to file.
SaveTreeData() {

dataFile := A_ScriptDir "\tree_data.txt"

;;∙------∙Delete existing file.
FileDelete, %dataFile%

;;∙------∙Write each item on a separate line.
;;∙------∙Format: ID|ParentID|Text|URL|Description|Login|UserName|Password
for itemID, data in TreeData {
    ;;∙------∙Replace pipe characters in fields to avoid parsing issues.
    safeText := StrReplace(data.text, "|", "¦")
    safeURL := StrReplace(data.url, "|", "¦")
    safeDesc := StrReplace(data.description, "|", "¦")
    safeLogin := StrReplace(data.login, "|", "¦")
    safeUserName := StrReplace(data.username, "|", "¦")
    safePassword := StrReplace(data.password, "|", "¦")
    
    line := itemID "|" data.parent "|" safeText "|" safeURL "|" safeDesc "|" safeLogin "|" safeUserName "|" safePassword "`n"
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

;;∙------∙Clear existing tree & data.
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

    ;;∙------∙Parse line: ID|ParentID|Text|URL|Description|Login|UserName|Password
    StringSplit, parts, A_LoopField, |

    if (parts0 < 5)
        continue

    oldID := parts1
    parentID := parts2
    text := StrReplace(parts3, "¦", "|")
    url := StrReplace(parts4, "¦", "|")
    description := StrReplace(parts5, "¦", "|")

    ;;∙------∙Get login, username, & password if they exist in the file.
     if (parts0 = 6) {
        login := StrReplace(parts6, "¦", "|")
        username := ""
        password := ""
    } else if (parts0 = 7) {
        login := StrReplace(parts6, "¦", "|")
        password := StrReplace(parts7, "¦", "|")
        username := ""
    } else if (parts0 >= 8) {
        login := StrReplace(parts6, "¦", "|")
        username := StrReplace(parts7, "¦", "|")
        password := StrReplace(parts8, "¦", "|")
    } else {
        login := ""
        username := ""
        password := ""
    }
    
    ;;∙------∙Store temporarily.
    tempData[oldID] := {parent: parentID, text: text, url: url, description: description, login: login, username: username, password: password}
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
        TreeData[newID] := {text: data.text, url: data.url, description: data.description, login: data.login, username: data.username, password: data.password, parent: 0}
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
            TreeData[newID] := {text: data.text, url: data.url, description: data.description, login: data.login, username: data.username, password: data.password, parent: newParentID}
            tempData.Delete(oldID)
            itemsAdded := true
        }
    }

    ;;∙------∙If no items were added in this pass, break.
    if (!itemsAdded)
        break
}

;;∙------∙After loading, verify ALL tree items have data.
itemID := 0
Loop {
    itemID := TV_GetNext(itemID, "Full")
    if (!itemID)
        break

    if (!TreeData.HasKey(itemID)) {
        TV_GetText(itemText, itemID)
        parentID := TV_GetParent(itemID)
        TreeData[itemID] := {text: itemText, url: "", description: "", login: "", username: "", password: "", parent: parentID}
    }
}

return

}
;;∙------∙GUI resizing (only edit fields resize).
MainGuiSize:
if (A_EventInfo = 1)    ;;∙------∙Minimized.
return

;;∙------∙Resize TreeView.
GuiControl, Move, MyTreeView, % "h" . (A_GuiHeight - 50) . " w" . 300

;;∙------∙Resize only edit fields for Link Text, URL, & Description.
newWidth := A_GuiWidth - 430
GuiControl, Move, EditText, % "x390 y10 w" . newWidth . " h25"
GuiControl, Move, EditURL, % "x390 y45 w" . newWidth . " h25"
GuiControl, Move, EditDescription, % "x390 y80 w" . newWidth . " h80"

;;∙------∙Move & resize status bar.
GuiControl, MoveDraw, MyStatusBar, % "x0 y" . (A_GuiHeight - 25) . " w" . A_GuiWidth . " h25"
Return


;;∙========∙🔥∙Hotkeys∙🔥∙========================∙

;;∙------∙ #IfWinActive, HomePage

^!n::    ;;∙------∙🔥∙(Ctrl + Alt + N) to add new link.
Gosub, AddNewLink
Return

^!s::    ;;∙------∙🔥∙(Ctrl + Alt + S) to save.
Gui, Main:Default
Gosub, SaveLink
Return

^!d::    ;;∙------∙🔥∙(Ctrl + Alt + D) to delete.
Gui, Main:Default
DeleteSelectedLink()
UpdateAddButtonLabel()
Return

^!o::    ;;∙------∙🔥∙(Ctrl +  Alt +O) to open selected link.
Gui, Main:Default
Gosub, OpenSelectedLink
Return

^!c::    ;;∙------∙🔥∙(Ctrl + Alt + C) to copy link.
Gui, Main:Default
Gosub, CopySelectedLink
Return

^!l::    ;;∙------∙🔥∙(Ctrl + Alt + L) to copy login info.
Gui, Main:Default
Gosub, CopyLoginInfo
Return

~^F5::   ;;∙------∙🔥∙(Ctrl + F5) to refresh/expand all.
Gui, Main:Default
itemID := 0
Loop {
    itemID := TV_GetNext(itemID, "Full")
    if (!itemID)
        break
    TV_Modify(itemID, "Expand")
}
SB_SetText("All categories expanded")
Return

~^F6::   ;;∙------∙🔥∙(Ctrl + F6) to collapse all.
Gui, Main:Default
itemID := 0
Loop {
    itemID := TV_GetNext(itemID, "Full")
    if (!itemID)
        break
    TV_Modify(itemID, "-Expand")
}
SB_SetText("All categories collapsed")
Return

^F2::   ;;∙------∙🔥∙(Ctrl + F2) to edit selected.
Gui, Main:Default
Gosub, MenuEdit
Return

;;∙------∙ #IfWinActive

;;∙====================∙

;;∙------∙Close GUI.
MainGuiClose:
SaveTreeData()    ;;∙------∙Save before closing.
ExitApp
Return

WM_LBUTTONDOWNdrag() {    ;;∙------∙Gui Drag Pt 2.
PostMessage, 0x00A1, 2, 0
}
Return
;;∙============================================================∙
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
My_HomePage:    ;;∙------∙Suspends hotkeys then pauses script.
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

