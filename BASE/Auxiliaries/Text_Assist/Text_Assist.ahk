

;;∙------------------------------------------------------------------------------------------∙
;;∙============================================================∙
;;∙======∙AUTO-EXECUTE∙========∙
#Requires AutoHotkey 1
#NoEnv
#Persistent
#SingleInstance Force
SendMode, Input
SetBatchLines -1
SetWorkingDir %A_ScriptDir%
ScriptID := "Text_Assist"
OnMessage(0x0201, "WM_LBUTTONDOWNdrag")
SetTimer, UpdateCheck, 750
#NoTrayIcon


;;∙======∙THE-MENU∙============∙
GroupAdd All

Menu Case, Add
Menu Case, Add 
Menu Case, Color, C7E2FF ; (Blue)
Menu Case, Add, TEXT ASSIST, CCase
Menu Case, Default, TEXT ASSIST
Menu Case, Add 


;;∙======∙CHANGE-TEXT-CASES∙====∙
Menu ChangeTextCases, Add 
Menu ChangeTextCases, Add
Menu ChangeTextCases, Add, UPPERCASE, CCase 
Menu ChangeTextCases, Add, lowercase, CCase 
Menu ChangeTextCases, Add, iNVERT cASE, CCase 
Menu ChangeTextCases, Add 
Menu ChangeTextCases, Add, Sentence case, CCase 
Menu ChangeTextCases, Add, S p r e a d T e x t, CCase 
Menu ChangeTextCases, Add, Title Case, CCase 
Menu ChangeTextCases, Add
Menu ChangeTextCases, Add


;;∙======∙DATE-&-TIME∙==========∙
Menu, InsertDateTime, Add
Menu, InsertDateTime, Add
Menu InsertDateTime, Add, Degree Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    °, CCase 
Menu, InsertDateTime, Add
Menu, InsertDateTime, Add, Date: Jan/01/1980, CCase
Menu, InsertDateTime, Add
Menu, InsertDateTime, Add, Time: 12:00 AM/PM, CCase
Menu, InsertDateTime, Add
Menu, InsertDateTime, Add, Week #, CCase
Menu, InsertDateTime, Add
Menu, InsertDateTime, Add


;;∙======∙ARROWS∙==============∙
Menu UpDownArrow, Add
Menu UpDownArrow, Add
Menu UpDownArrow, Add, Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↑, CCase
Menu UpDownArrow, Add, Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬆, CCase
Menu UpDownArrow, Add, Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⇧, CCase
Menu UpDownArrow, Add, Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▲, CCase
Menu UpDownArrow, Add, Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙    △, CCase
Menu UpDownArrow, Add, Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡱, CCase
Menu UpDownArrow, Add, Insert Ar​row∙∙∙∙∙ ∙∙∙∙∙∙∙∙∙    ⮙, CCase
Menu UpDownArrow, Add, Insert Ar​row∙∙∙∙ ∙∙∙∙∙∙∙∙∙∙    ⮝, CCase
Menu UpDownArrow, Add, Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⌃, CCase
Menu UpDownArrow, Add
Menu UpDownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↓, CCase
Menu UpDownArrow, Add, Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬇, CCase
Menu UpDownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⇩, CCase
Menu UpDownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▼, CCase
Menu UpDownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▽, CCase
Menu UpDownArrow, Add, Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡳, CCase
Menu UpDownArrow, Add, Insert Arr​ow∙∙∙∙∙∙ ∙∙∙∙∙∙∙∙    ⮛, CCase
Menu UpDownArrow, Add, Insert Arr​ow∙∙∙∙∙ ∙∙∙∙∙∙∙∙∙    ⮟, CCase
Menu UpDownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙ ∙∙    ⌄, CCase
Menu UpDownArrow, Add
Menu UpDownArrow, Add
;;∙------------------------------------------∙
Menu LeftRightArrow, Add
Menu LeftRightArrow, Add
Menu LeftRightArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ←, CCase
Menu LeftRightArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬅, CCase
Menu LeftRightArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⇦, CCase
Menu LeftRightArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◀, CCase
Menu LeftRightArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◁, CCase
Menu LeftRightArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡰, CCase
Menu LeftRightArrow, Add, Insert Arr​ow∙∙∙ ∙∙∙∙∙∙∙∙∙∙∙    ⮘, CCase
Menu LeftRightArrow, Add, Insert Arr​ow∙∙∙∙ ∙∙∙∙∙∙∙∙∙∙    ⮜, CCase
Menu LeftRightArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    <, CCase
Menu LeftRightArrow, Add
Menu LeftRightArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    →, CCase
Menu LeftRightArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ➞, CCase
Menu LeftRightArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⇨, CCase
Menu LeftRightArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▶, CCase
Menu LeftRightArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▷, CCase
Menu LeftRightArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡲, CCase
Menu LeftRightArrow, Add, Insert Arr​ow∙ ∙∙∙∙∙∙∙∙∙∙∙∙∙    ⮚, CCase
Menu LeftRightArrow, Add, Insert Ar​row∙∙ ∙∙∙∙∙∙∙∙∙∙∙∙    ⮞, CCase
Menu LeftRightArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    >, CCase
Menu LeftRightArrow, Add
Menu LeftRightArrow, Add
;;∙------------------------------------------∙
Menu Up&&DownArrow, Add
Menu Up&&DownArrow, Add
Menu Up&&DownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↕, CCase
Menu Up&&DownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬍, CCase
Menu Up&&DownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⇳, CCase
Menu Up&&DownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡙, CCase
Menu Up&&DownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⇕, CCase
Menu Up&&DownArrow, Add
Menu Up&&DownArrow, Add
;;∙------------------------------------------∙
Menu Left&&RightArrow, Add
Menu Left&&RightArrow, Add
Menu Left&&RightArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↔, CCase
Menu Left&&RightArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬌, CCase
Menu Left&&RightArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬄, CCase
Menu Left&&RightArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡘, CCase
Menu Left&&RightArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⇿, CCase
Menu Left&&RightArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⟷, CCase
Menu Left&&RightArrow, Add
Menu Left&&RightArrow, Add
;;∙------------------------------------------∙
Menu DiagUpArrow, Add
Menu DiagUpArrow, Add
Menu DiagUpArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↖, CCase
Menu DiagUpArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬉, CCase
Menu DiagUpArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬁, CCase
Menu DiagUpArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◤, CCase
Menu DiagUpArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◸, CCase
Menu DiagUpArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡴, CCase
Menu DiagUpArrow, Add
Menu DiagUpArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↗, CCase
Menu DiagUpArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬈, CCase
Menu DiagUpArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬀, CCase
Menu DiagUpArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◥, CCase
Menu DiagUpArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◹, CCase
Menu DiagUpArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡵, CCase
Menu DiagUpArrow, Add
Menu DiagUpArrow, Add
;;∙------------------------------------------∙
Menu DiagDownArrow, Add
Menu DiagDownArrow, Add
Menu DiagDownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↘, CCase
Menu DiagDownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬊, CCase
Menu DiagDownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬂, CCase
Menu DiagDownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◢, CCase
Menu DiagDownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◿, CCase
Menu DiagDownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡶, CCase
Menu DiagDownArrow, Add
Menu DiagDownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↙, CCase
Menu DiagDownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬋, CCase
Menu DiagDownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬃, CCase
Menu DiagDownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◣, CCase
Menu DiagDownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◺, CCase
Menu DiagDownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡷, CCase
Menu DiagDownArrow, Add
Menu DiagDownArrow, Add
;;∙------------------------------------------∙
Menu CircularArrow, Add
Menu CircularArrow, Add
Menu CircularArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↩, CCase
Menu CircularArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↪, CCase
Menu CircularArrow, Add
Menu CircularArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↶, CCase
Menu CircularArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↷, CCase
Menu CircularArrow, Add
Menu CircularArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↺, CCase
Menu CircularArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↻, CCase
Menu CircularArrow, Add
Menu CircularArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⥀, CCase
Menu CircularArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⥁, CCase
Menu CircularArrow, Add
Menu CircularArrow, Add


;;∙======∙BULLETS∙===============∙
Menu Bullet, Add
Menu Bullet, Add
Menu Bullet, Add, Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◦, CCase
Menu Bullet, Add, Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    •, CCase
Menu Bullet, Add, Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ○, CCase
Menu Bullet, Add, Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ●, CCase
Menu Bullet, Add
Menu Bullet, Add, Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▫, CCase
Menu Bullet, Add, Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▪, CCase
Menu Bullet, Add, Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ☐, CCase
Menu Bullet, Add, Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ■, CCase
Menu Bullet, Add
Menu Bullet, Add, Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◇, CCase
Menu Bullet, Add, Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◈, CCase
Menu Bullet, Add, Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◆, CCase
Menu Bullet, Add
Menu Bullet, Add, Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✧, CCase
Menu Bullet, Add, Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✦, CCase
Menu Bullet, Add, Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▹, CCase
Menu Bullet, Add, Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▸, CCase
Menu Bullet, Add
Menu Bullet, Add, Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⪧, CCase
Menu Bullet, Add, Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🠺, CCase
Menu Bullet, Add, Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ☞, CCase
Menu Bullet, Add, Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ☛, CCase
Menu Bullet, Add
Menu Bullet, Add


;;∙======∙STARS∙=================∙
Menu Stars, Add
Menu Stars, Add
Menu Stars, Add, Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✶, CCase
Menu Stars, Add, Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✹, CCase
Menu Stars, Add, Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✸, CCase
Menu Stars, Add, Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ★, CCase
Menu Stars, Add, Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✦, CCase
Menu Stars, Add
Menu Stars, Add, Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ❊, CCase
Menu Stars, Add, Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ❈, CCase
Menu Stars, Add, Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ❋, CCase
Menu Stars, Add, Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ❉, CCase
Menu Stars, Add, Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✺, CCase
Menu Stars, Add
Menu Stars, Add, Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⛤, CCase
Menu Stars, Add, Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⚝, CCase
Menu Stars, Add, Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⛧, CCase
Menu Stars, Add, Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✰, CCase
Menu Stars, Add, Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ☆, CCase
Menu Stars, Add
Menu Stars, Add


;;∙======∙SYMBOLS∙==============∙
Menu Symbols, Add
Menu Symbols, Add
Menu Symbols, Add, Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    μ, CCase 
Menu Symbols, Add, Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    π, CCase 
Menu Symbols, Add, Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    Δ, CCase 
Menu Symbols, Add, Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    Ω, CCase 
Menu Symbols, Add
Menu Symbols, Add, Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ±, CCase
Menu Symbols, Add, Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ≥, CCase 
Menu Symbols, Add, Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ≤, CCase 
Menu Symbols, Add
Menu Symbols, Add, Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ÷, CCase
Menu Symbols, Add, Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⨯, CCase
Menu Symbols, Add
Menu Symbols, Add, Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ➕, CCase 
Menu Symbols, Add, Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ➖, CCase 
Menu Symbols, Add, Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✖️, CCase 
Menu Symbols, Add, Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ➗, CCase 
Menu Symbols, Add
Menu Symbols, Add


;;∙======∙MENU-HEADERS∙========∙
    Menu ChangeTextCases, Color, CCFDFF ; (Mint) 
Menu Case, Add, Change Text Cases, :ChangeTextCases
    Menu, InsertDateTime, Color, CCFDFF ; (Mint) 
Menu Case, Add, Insert Date && Time, :InsertDateTime
Menu Case, Add

    Menu Arrow, Add
    Menu Arrow, Add
    Menu Arrow, Add, UpDown Arrows, :UpDownArrow
    Menu Arrow, Add, LeftRight Arrows, :LeftRightArrow
    Menu Arrow, Add
    Menu Arrow, Add, UP && Down Arrows, :Up&&DownArrow
    Menu Arrow, Add, Left && Right Arrows, :Left&&RightArrow
    Menu Arrow, Add
    Menu Arrow, Add, Diagonal Up Arrows, :DiagUpArrow
     Menu Arrow, Add, Diagonal Down Arrows, :DiagDownArrow
    Menu Arrow, Add
    Menu Arrow, Add, Circular Arrows, :CircularArrow
    Menu Arrow, Add
    Menu Arrow, Add
        Menu Arrow, Color, CCFDFF ; (Mint)
        Menu UpDownArrow, Color, C7FFE2 ; (Green)
        Menu LeftRightArrow, Color, FFF8C7 ; (yellow)
        Menu Up&&DownArrow, Color, C7FFE2 ; (Green)
        Menu Left&&RightArrow, Color, FFF8C7 ; (yellow)
        Menu DiagUpArrow, Color, C7FFE2 ; (Green)
        Menu DiagDownArrow, Color, FFF8C7 ; (yellow)
        Menu CircularArrow, Color, C7FFE2 ; (Green)
Menu Case, Add, Arrows, :Arrow

    Menu Bullet, Color, FFF8DC ; (FadedYellow)
Menu Case, Add, Bullets, :Bullet
    Menu Stars, Color, CCFDFF ; (Mint) 
Menu Case, Add, Stars, :Stars
    Menu Symbols, Color, FFF8DC ; (FadedYellow)
Menu Case, Add, Symbols, :Symbols
Menu Case, Add
Menu Case, Add


;;∙-∙🔥∙-∙🔥∙-∙🔥∙-∙HOTKEY∙-∙🔥∙-∙🔥∙-∙🔥
^Y::
SoundGet, master_volume
SoundSet, 3
    Soundbeep, 800, 75
SoundSet, master_volume

    GetText(TempText)
    Menu Case, Show 
Return


;;∙======∙CASES∙=================∙
CCase:
  Switch A_ThisMenuItem { 

    Case "TEXT ASSIST":
            GoSub, ASSIST


;;∙======∙CHANGE-TEXT-CASE∙=====∙
    Case "UPPERCASE":
            GoSub, Highlighted
      StringUpper, TempText, TempText
            clipboard := "" TempText ""
;;∙------------------------------------------∙
    Case "lowercase":
            GoSub, Highlighted
      StringLower, TempText, TempText
            clipboard := "" TempText ""
;;∙------------------------------------------∙
    Case "Title Case":
            GoSub, Highlighted
      StringLower, TempText, TempText, T
            clipboard := "" TempText ""
;;∙------------------------------------------∙
    Case "Sentence case":
            GoSub, Highlighted
      StringLower, TempText, TempText
      TempText := RegExReplace(TempText, "((?:^|[.!?]\s+)[a-z])", "$u1")
            clipboard := "" TempText ""
;;∙------------------------------------------∙
    Case "iNVERT cASE":
            GoSub, Highlighted
      {
         CopyClipboardCLM()
         Inv_Char_Out := ""
         Loop % StrLen(Clipboard)
         {
             Inv_Char := SubStr(Clipboard, A_Index, 1)
             if Inv_Char is Upper
                 Inv_Char_Out := Inv_Char_Out Chr(Asc(Inv_Char) + 32)
             else if Inv_Char is Lower
                 Inv_Char_Out := Inv_Char_Out Chr(Asc(Inv_Char) - 32)
             else
                 Inv_Char_Out := Inv_Char_Out Inv_Char
         }
         Clipboard := Inv_Char_Out
         PasteClipboardCLM()
      }
;;∙------------------------------------------∙
    Case "S p r e a d T e x t":
            GoSub, Highlighted
	{
	vText := "exemple"
	TempText := % RegExReplace(TempText, "(?<=.)(?=.)", " ")
	} 
            clipboard := "" TempText ""


;;∙======∙DATE-&-TIME∙===========∙
;;∙----∙Degree Symbol (°)∙---------------∙
    Case "Degree Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    °": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}°
            clipboard := "°"
        SoundBeep, 1200, 75
    Return

;;∙----∙Month/Day/Year : Date∙--------∙
Case "Date: Jan/01/1980":
        WinActivate % "ahk_id" hWnd
      FormatTime, CurrentDateTime,,· MMM/dd/yyyy ·
      SendInput %CurrentDateTime% 
            clipboard := CurrentDateTime
      exit

;;∙----∙12:00 PM : TIME∙-----------------∙
Case "Time: 12:00 AM/PM":
        WinActivate % "ahk_id" hWnd
      FormatTime, CurrentDateTime,, · hh:mm:ss tt · 	 	 ; 12hr format
      SendInput %CurrentDateTime% 
            clipboard := CurrentDateTime
      exit

;;∙----∙Week Number∙--------------------∙
Case "Week #": 
        WinActivate % "ahk_id" hWnd
FormatTime WeekNow, , YWeek
    SendInput  Week 
        SendInput % WeekNow := SubStr(WeekNow, -1) +0 
            clipboard := "Week: " . WeekNow
        SoundBeep, 1200, 75
      exit


;;∙======∙ARROWS∙==============∙
    Case "Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↑": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↑
            clipboard := "↑"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬆": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬆
            clipboard := "⬆"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⇧": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⇧
            clipboard := "⇧"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▲": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}▲
            clipboard := "▲"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙    △": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}△
            clipboard := "△"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡱": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}🡱
            clipboard := "🡱"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙ ∙∙∙∙∙∙∙∙∙    ⮙": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⮙
            clipboard := "⮙"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙ ∙∙∙∙∙∙∙∙∙∙    ⮝": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⮝
            clipboard := "⮝"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⌃": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⌃
            clipboard := "⌃"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↓": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↓
            clipboard := "↓"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬇": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬇
            clipboard := "⬇"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⇩": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⇩
            clipboard := "⇩"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▼": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}▼
            clipboard := "▼"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▽": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}▽
            clipboard := "▽"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡳": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}🡳
            clipboard := "🡳"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Arr​ow∙∙∙∙∙∙ ∙∙∙∙∙∙∙∙    ⮛": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⮛
            clipboard := "⮛"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Arr​ow∙∙∙∙∙ ∙∙∙∙∙∙∙∙∙    ⮟": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⮟
            clipboard := "⮟"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙ ∙∙    ⌄": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⌄
            clipboard := "⌄"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ←": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}←
            clipboard := "←"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬅": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬅
            clipboard := "⬅"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⇦": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⇦
            clipboard := "⇦"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◀": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◀
            clipboard := "◀"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◁": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◁
            clipboard := "◁"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡰": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}🡰
            clipboard := "🡰"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Arr​ow∙∙∙ ∙∙∙∙∙∙∙∙∙∙∙    ⮘": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⮘
            clipboard := "⮘"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Arr​ow∙∙∙∙ ∙∙∙∙∙∙∙∙∙∙    ⮜": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⮜
            clipboard := "⮜"
        SoundBeep, 1200, 75
    Return
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    <": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}<
            clipboard := "<"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
;;∙------------------------------------------∙ 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    →": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}→
            clipboard := "→"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ➞": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}➞
            clipboard := "➞"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⇨": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⇨
            clipboard := "⇨"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▶": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}▶
            clipboard := "▶"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▷": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}▷
            clipboard := "▷"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡲": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}🡲
            clipboard := "🡲"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Arr​ow∙ ∙∙∙∙∙∙∙∙∙∙∙∙∙    ⮚": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⮚
            clipboard := "⮚"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙ ∙∙∙∙∙∙∙∙∙∙∙∙    ⮞": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⮞
            clipboard := "⮞"
        SoundBeep, 1200, 75
    Return
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    >": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}>
            clipboard := ">"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↕": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↕
            clipboard := "↕"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬍": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬍
            clipboard := "⬍"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⇳": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⇳
            clipboard := "⇳"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡙": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}🡙
            clipboard := "🡙"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⇕": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⇕
            clipboard := "⇕"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↔": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↔
            clipboard := "↔"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬌": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬌
            clipboard := "⬌"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬄": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬄
            clipboard := "⬄"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡘": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}🡘
            clipboard := "🡘"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⇿": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⇿
            clipboard := "⇿"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⟷": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⟷
            clipboard := "⟷"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↖": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↖
            clipboard := "↖"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬉": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬉
            clipboard := "⬉"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬁": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬁
            clipboard := "⬁"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◤": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◤
            clipboard := "◤"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◸": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◸
            clipboard := "◸"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡴": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}🡴
            clipboard := "🡴"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↗": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↗
            clipboard := "↗"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬈": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬈
            clipboard := "⬈"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬀": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬀
            clipboard := "⬀"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◥": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◥
            clipboard := "◥"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◹": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◹
            clipboard := "◹"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡵": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}🡵
            clipboard := "🡵"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↘": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↘
            clipboard := "↘"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬊": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬊
            clipboard := "⬊"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬂": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬂
            clipboard := "⬂"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◢": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◢
            clipboard := "◢"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◿": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◿
            clipboard := "◿"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡶": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}🡶
            clipboard := "🡶"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↙": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↙
            clipboard := "↙"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬋": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬋
            clipboard := "⬋"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬃": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬃
            clipboard := "⬃"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◣": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◣
            clipboard := "◣"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◺": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◺
            clipboard := "◺"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡷": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}🡷
            clipboard := "🡷"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↩": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↩
            clipboard := "↩"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↪": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↪
            clipboard := "↪"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↶": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↶
            clipboard := "↶"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↷": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↷
            clipboard := "↷"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↺": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↺
            clipboard := "↺"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↻": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↻
            clipboard := "↻"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⥀": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⥀
            clipboard := "⥀"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⥁": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⥁
            clipboard := "⥁"
        SoundBeep, 1200, 75
    Return


;;∙======∙BULLETS∙===============∙
   Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◦": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◦
            clipboard := "◦"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    •": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}•
            clipboard := "•"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ○": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}○
            clipboard := "○"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ●": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}●
            clipboard := "●"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▫": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}▫
            clipboard := "▫"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▪": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}▪
            clipboard := "▪"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ☐": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}☐
            clipboard := "☐"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ■ ), CCase": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}■
            clipboard := "■"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◇": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◇
            clipboard := "◇"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◈": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◈
            clipboard := "◈"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙ 
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◆": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◆
            clipboard := "◆"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✧": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}✧
            clipboard := "✧"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✦": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}✦
            clipboard := "✦"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▹": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}▹
            clipboard := "▹"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▸": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}▸
            clipboard := "▸"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⪧": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⪧
            clipboard := "⪧"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🠺": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}🠺
            clipboard := "🠺"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ☞": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}☞
            clipboard := "☞"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ☛": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}☛
            clipboard := "☛"
        SoundBeep, 1200, 75
    Return


;;∙======∙STARS∙=================∙
    Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✶": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}✶
            clipboard := "✶"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✹": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}✹
            clipboard := "✹"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✸": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}✸
            clipboard := "✸"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ★": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}★
            clipboard := "★"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✦": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}✦
            clipboard := "✦"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ❊": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}❊
            clipboard := "❊"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ❈": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}❈
            clipboard := "❈"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ❋": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}❋
            clipboard := "❋"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ❉": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}❉
            clipboard := "❉"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✺": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}✺
            clipboard := "✺"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⛤": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⛤
            clipboard := "⛤"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⚝": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⚝
            clipboard := "⚝"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⛧": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⛧
            clipboard := "⛧"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✰": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}✰
            clipboard := "✰"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ☆": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}☆
            clipboard := "☆"
        SoundBeep, 1200, 75
    Return


;;∙======∙SYMBOLS∙==============∙
    Case "Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ÷": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}÷
            clipboard := "÷"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⨯":  
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⨯
            clipboard := "⨯"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ±":  
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}±
            clipboard := "±"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ≥":  
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}≥
            clipboard := "≥"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ≤":  
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}≤
            clipboard := "≤"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    μ":  
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}μ
            clipboard := "μ"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    Δ":  
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}Δ
            clipboard := "Δ"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    π":  
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}π
            clipboard := "π"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ➕":  
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}➕
            clipboard := "➕"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ➖":  
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}➖
            clipboard := "➖"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✖️":  
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}✖️
            clipboard := "✖️"
        SoundBeep, 1200, 75
    Return
;;∙------------------------------------------∙
    Case "Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ➗":  
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}➗
            clipboard := "➗"
        SoundBeep, 1200, 75
    Return


;;∙======∙CASE-CLOSING∙=========∙
;;∙------∙(Keep At Bottom of all Case Things)
}    ;;<∙------∙Keep this last curly bracket at the end of ALL Case Things! 

PutText(TempText)
SetCapsLockState, Off
Return
;;∙------∙(Keep At Bottom of all Case Things)


;;∙======∙FUNCTIONS∙============∙
    ;;∙------∙Copies selected text to a variable while preserving clipboard.
GetText(ByRef MyText = "")
{
   SavedClip := ClipboardAll
   Clipboard =
   Send ^c
   ClipWait 0.5
   If ERRORLEVEL
   {
      Clipboard := SavedClip
      MyText =
      Return
   }
   MyText := Clipboard
   Clipboard := SavedClip
   Return MyText
SetCapsLockState, Off
}
;;∙------------------------------------------∙
;;∙------∙Pastes text from a variable while preserving clipboard.
PutText(MyText)
{
   SavedClip := ClipboardAll 
   Clipboard =              ; For better compatability
   Sleep 20                 ; with Clipboard History
   Clipboard := MyText
   Send ^v
   Sleep 100
   Clipboard := SavedClip
SetCapsLockState, Off
   Return
}
SetCapsLockState, Off
Send, {capslock up}
;;∙------------------------------------------∙
CopyClipboard()
{
    global ClipSaved := ""
    ClipSaved := ClipboardAll    ;;∙------∙Save original clipboard contents.
    Clipboard := ""    ;;∙------∙Start off empty to allow ClipWait to detect when text has arrived.
    Send {Ctrl down}c{Ctrl up}
    Sleep 150
    ClipWait, 1.5, 1
    if ErrorLevel
    {
        Clipboard := ClipSaved    ;;∙------∙Restore original clipboard contents.
        ClipSaved := ""    ;;∙------∙Clear variable.
        return
    }
}
;;∙------------------------------------------∙
CopyClipboardCLM()
{
    global ClipSaved
    WinGet, id, ID, A
    WinGetClass, class, ahk_id %id%
    if (class ~= "(Cabinet|Explore)WClass|Progman")
        Send {F2}
    Sleep 100
    CopyClipboard()
    if (ClipSaved != "")
        Clipboard := Clipboard
    else
        Exit
}
;;∙------------------------------------------∙
PasteClipboardCLM()
{
    global ClipSaved
    WinGet, id, ID, A
    WinGetClass, class, ahk_id %id%
    if (class ~= "(Cabinet|Explore)WClass|Progman")
        Send {F2}
    Send ^v
    Sleep 100
    Clipboard := ClipSaved
    ClipSaved := ""
    Exit
}


;;∙======∙GO-SUBS∙==============∙
ASSIST:
    SoundBeep, 1200, 100
        ;;∙------∙Possible future coding.
    Return

Highlighted: 
SoundGet, master_volume
SoundSet, 3
Sleep, 50
    SoundBeep, 1200, 75
SoundSet, master_volume

    StoredClip := ClipboardAll
    Clipboard = 
        Send, ^c
Return
;;∙------------------------------------------∙
GuiBegin:
    Gui, +AlwaysOnTop -Caption +hwndHGUI +LastFound
        +E0x02000000 +E0x00080000    ;;∙------∙Double Buffer to reduce Gui flicker.
    Gui, Color, BLACK
    Gui, Font, s14 cF5DE00, ARIAL
    Gui, Margin, 15, 15
    Gui, Add, Text, w150 h50 Center +BackgroundTrans +0x0200 0x00800000, ATTENTION!!    ;;∙------∙(0x00800000 = Creates a thin-line border box) (+0x0200 = Vertical Center).
    Gui, Font, s10
Return
;;∙------------------------------------------∙
GuiEnd:
    Gui, Show, Hide
        WinGetPos, X, Y, W, H
        R := Min(W, H) // 5
        WinSet, Region, 0-0 W%W% H%H% R%R%-%R%
    Gui, Show, NoActivate, 
        OnMessage(0x0201, "WM_LBUTTONDOWN")
Return


;;∙======∙GUI-DRAG∙=============∙
WM_LBUTTONDOWNdrag() {
   PostMessage, 0x00A1, 2, 0
}
Return


;;∙======∙SCRIPT UPDATE∙========∙
UpdateCheck:    ;;∙------Check if script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
    Soundbeep, 1700, 100
Reload
;;∙============================================================∙
;;∙------------------------------------------------------------------------------------------∙

