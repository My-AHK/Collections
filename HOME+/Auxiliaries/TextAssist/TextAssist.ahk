	
/*
▎▔▔▔▔▔▔▔▔▔▔✎ NOTES ✎▔▔▔▔▔▔▔▔▔▔▔▎ 
 •───────────────────────────────────────────────• 
➤∙ ∙ ∙ ∙ ∙ ∙ ∙ Base Notes ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ 
» Refresh Script ━━━━ Ctrl + HOME key rapidly clicked 2 times. (# TapCounts)
» Exit Script ━━━━━━━━ Ctrl + Escape key rapidly clicked 3 times. (# TapCounts)

» Script Updater: Auto-reload script upon saved changes.
    ⋗ If you make any changes to the script file and save it, the script will automatically reload itself and continue running without manual intervention.
 •───────────────────────────────────────────────• 
➤∙ ∙ ∙ ∙ ∙ ∙ ∙ Script Specific Notes ∙ ∙ ∙ ∙ ∙ ∙ ∙ ∙ 
» SOURCE 1 :  https://www.autohotkey.com/boards/viewtopic.php?t=114808#p511756
» SOURCE 2 : https://pastebin.com/g6BzS4A8

» Change text cases to upper, lower, inverted, etc. Plus insert arrows, bullets, date and time stamps, and more.

» *TempText is just whats been selected/copied.

» ** If you have a case where you DONT want TempText to be pasted (like for the date Case), just put  Exit  at the end of it so it Exits the process instead of continuing down and pasting TempText (putting Exit makes it not paste TempText)

» Places a copy of most things to allow easier re-use of pasted items rather than restoring clipboard original content. 

» If upon failing to select (highlight) any text when using Case-Changing, Formatting, or Wrappers, error message will popup for 5 seconds. If Wrappers fail, it will still place selected wrappers where cursor caret is. These will need manually deleted before trying again.
 •───────────────────────────────────────────────• 
➤ Further notes at bottom of script∙∙∙∙∙∙∙ Yes:     No: ✔ 
▎▁▁▁▁▁▁▁▁▁▁ NOTES END ▁▁▁▁▁▁▁▁▁▁▁▎
*/

; ⯁═════════════════ Auto-Execute ═════════════════⯁ 
Gosub, AutoExecute
; ⬦─────────────── Auto-Execute End ───────────────⬦ 

; ⯁══════════════════ THE MENUS ═════════════════⯁ 
GroupAdd All

Menu Case, Add
Menu Case, Add 
Menu Case, Color, C7E2FF ; (Blue)
Menu Case, Add, TEXT ASSIST, CCase
Menu Case, Default, TEXT ASSIST
Menu Case, Add 

; •─────────────── CHANGE TEXT CASES ──────────────•
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

; •────────────────── DATE & TIME ─────────────────•
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

; •──────────────────── ARROWS ──────────────────•∙∙∙∙∙∙∙   
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
; ◦——————— 
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
; ◦——————— 
Menu Up&&DownArrow, Add
Menu Up&&DownArrow, Add
Menu Up&&DownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↕, CCase
Menu Up&&DownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬍, CCase
Menu Up&&DownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⇳, CCase
Menu Up&&DownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡙, CCase
Menu Up&&DownArrow, Add, Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⇕, CCase
Menu Up&&DownArrow, Add
Menu Up&&DownArrow, Add
; ◦——————— 
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
; ◦——————— 
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
; ◦——————— 
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
; ◦——————— 
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
; ◦——————— 
; •──────────────────── BULLETS ───────────────────•
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
; ◦——————— 
; •───────────────────── STARS ────────────────────•
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
; ◦——————— 
; •──────────────────── SYMBOLS ──────────────────•
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
; ◦——————— 

; •───────────────── MENU HEADERS ────────────────• 
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
; ◦——————— 
;⬦─────────────── THE MENUS End ────────────────⬦ 

; ∎▦▦▦▦▦▦▦▦▦▦▦∎🔥 HOTKEY 🔥∎▦▦▦▦▦▦▦▦▦▦▦∎
; ◦——————— 
^Y:: 	 ; ═════ (Ctrl + Y) 

SoundGet, master_volume
SoundSet, 3
    Soundbeep, 800, 75
SoundSet, master_volume

    GetText(TempText)
    Menu Case, Show 
Return
; ◦——————— 
; ∎▦▦▦▦▦▦▦▦▦▦∎🔥 HOTKEY End 🔥∎▦▦▦▦▦▦▦▦▦▦∎


; ⯁══════════════════ THE CASES ═══════════════════⯁ 
; ◦——————— 
CCase:
  Switch A_ThisMenuItem { 

    Case "TEXT ASSIST":
            GoSub, ASSIST
; ◦——————— 
; •─────────────── CHANGE TEXT CASES ──────────────•
; ◦——————— 
    Case "UPPERCASE":
            GoSub, Highlighted
      StringUpper, TempText, TempText
            clipboard := "" TempText ""
; ◦——————— 
    Case "lowercase":
            GoSub, Highlighted
      StringLower, TempText, TempText
            clipboard := "" TempText ""
; ◦——————— 
    Case "Title Case":
            GoSub, Highlighted
      StringLower, TempText, TempText, T
            clipboard := "" TempText ""
; ◦——————— 
    Case "Sentence case":
            GoSub, Highlighted
      StringLower, TempText, TempText
      TempText := RegExReplace(TempText, "((?:^|[.!?]\s+)[a-z])", "$u1")
            clipboard := "" TempText ""
; ◦——————— 
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
; ◦——————— 
    Case "S p r e a d T e x t":
            GoSub, Highlighted
	{
	vText := "exemple"
	TempText := % RegExReplace(TempText, "(?<=.)(?=.)", " ")
	} 
            clipboard := "" TempText ""
; ◦——————— 
; •────────────────── DATE & TIME ──────────────────•
; ◦————— Degrees Symbol —————◦ 
    Case "Degree Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    °": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}°
            clipboard := "°"
        SoundBeep, 1200, 75
    Return
; ◦————— Month/Day/Year : Date —————◦
Case "Date: Jan/01/1980":
        WinActivate % "ahk_id" hWnd
      FormatTime, CurrentDateTime,,· MMM/dd/yyyy ·
      SendInput %CurrentDateTime% 
            clipboard := CurrentDateTime
      exit
; ◦————— 12:00 PM : TIME —————◦
Case "Time: 12:00 AM/PM":
        WinActivate % "ahk_id" hWnd
      FormatTime, CurrentDateTime,, · hh:mm:ss tt · 	 	 ; 12hr format
      SendInput %CurrentDateTime% 
            clipboard := CurrentDateTime
      exit
; ◦————— Week Number —————◦
Case "Week #": 
        WinActivate % "ahk_id" hWnd
FormatTime WeekNow, , YWeek
    SendInput  Week 
        SendInput % WeekNow := SubStr(WeekNow, -1) +0 
            clipboard := "Week: " . WeekNow
        SoundBeep, 1200, 75
      exit
; ◦——————— 
; •──────────────────── ARROWS ────────────────────•
; ◦——————— Up Arrows ————————◦ 
    Case "Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↑": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↑
            clipboard := "↑"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬆": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬆
            clipboard := "⬆"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⇧": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⇧
            clipboard := "⇧"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▲": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}▲
            clipboard := "▲"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙    △": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}△
            clipboard := "△"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡱": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}🡱
            clipboard := "🡱"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙ ∙∙∙∙∙∙∙∙∙    ⮙": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⮙
            clipboard := "⮙"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙ ∙∙∙∙∙∙∙∙∙∙    ⮝": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⮝
            clipboard := "⮝"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⌃": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⌃
            clipboard := "⌃"
        SoundBeep, 1200, 75
    Return
; ◦—————— Down Arrows ————————◦ 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↓": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↓
            clipboard := "↓"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬇": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬇
            clipboard := "⬇"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⇩": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⇩
            clipboard := "⇩"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▼": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}▼
            clipboard := "▼"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▽": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}▽
            clipboard := "▽"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Arrow∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡳": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}🡳
            clipboard := "🡳"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Arr​ow∙∙∙∙∙∙ ∙∙∙∙∙∙∙∙    ⮛": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⮛
            clipboard := "⮛"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Arr​ow∙∙∙∙∙ ∙∙∙∙∙∙∙∙∙    ⮟": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⮟
            clipboard := "⮟"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙ ∙∙    ⌄": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⌄
            clipboard := "⌄"
        SoundBeep, 1200, 75
    Return
; ◦——————— Left Arrows ————————◦ 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ←": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}←
            clipboard := "←"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬅": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬅
            clipboard := "⬅"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⇦": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⇦
            clipboard := "⇦"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◀": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◀
            clipboard := "◀"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◁": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◁
            clipboard := "◁"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡰": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}🡰
            clipboard := "🡰"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Arr​ow∙∙∙ ∙∙∙∙∙∙∙∙∙∙∙    ⮘": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⮘
            clipboard := "⮘"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
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
; ◦——————— Right Arrows ———————◦ 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    →": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}→
            clipboard := "→"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ➞": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}➞
            clipboard := "➞"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⇨": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⇨
            clipboard := "⇨"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▶": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}▶
            clipboard := "▶"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▷": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}▷
            clipboard := "▷"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡲": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}🡲
            clipboard := "🡲"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Arr​ow∙ ∙∙∙∙∙∙∙∙∙∙∙∙∙    ⮚": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⮚
            clipboard := "⮚"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
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
; ◦—————— UpDown Arrows ——————◦ 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↕": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↕
            clipboard := "↕"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬍": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬍
            clipboard := "⬍"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⇳": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⇳
            clipboard := "⇳"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡙": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}🡙
            clipboard := "🡙"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⇕": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⇕
            clipboard := "⇕"
        SoundBeep, 1200, 75
    Return
; ◦—————— LeftRight Arrows ——————◦ 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↔": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↔
            clipboard := "↔"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬌": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬌
            clipboard := "⬌"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬄": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬄
            clipboard := "⬄"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡘": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}🡘
            clipboard := "🡘"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⇿": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⇿
            clipboard := "⇿"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⟷": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⟷
            clipboard := "⟷"
        SoundBeep, 1200, 75
    Return
; ◦——————— UpLeft Arrows ——————◦ 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↖": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↖
            clipboard := "↖"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬉": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬉
            clipboard := "⬉"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬁": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬁
            clipboard := "⬁"
        SoundBeep, 1200, 75
    Return


; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◤": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◤
            clipboard := "◤"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◸": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◸
            clipboard := "◸"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡴": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}🡴
            clipboard := "🡴"
        SoundBeep, 1200, 75
    Return
; ◦—————— UpRight Arrows ———————◦ 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↗": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↗
            clipboard := "↗"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬈": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬈
            clipboard := "⬈"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬀": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬀
            clipboard := "⬀"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◥": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◥
            clipboard := "◥"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◹": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◹
            clipboard := "◹"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡵": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}🡵
            clipboard := "🡵"
        SoundBeep, 1200, 75
    Return
; ◦————— DownRight Arrows ———————◦ 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↘": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↘
            clipboard := "↘"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬊": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬊
            clipboard := "⬊"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬂": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬂
            clipboard := "⬂"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◢": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◢
            clipboard := "◢"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◿": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◿
            clipboard := "◿"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡶": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}🡶
            clipboard := "🡶"
        SoundBeep, 1200, 75
    Return
; ◦————— DownLeft Arrows ———————◦ 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↙": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↙
            clipboard := "↙"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬋": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬋
            clipboard := "⬋"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⬃": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⬃
            clipboard := "⬃"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◣": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◣
            clipboard := "◣"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◺": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◺
            clipboard := "◺"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🡷": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}🡷
            clipboard := "🡷"
        SoundBeep, 1200, 75
    Return
; ◦—————— Circular Arrows ——————◦ 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↩": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↩
            clipboard := "↩"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↪": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↪
            clipboard := "↪"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↶": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↶
            clipboard := "↶"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↷": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↷
            clipboard := "↷"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↺": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↺
            clipboard := "↺"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ↻": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}↻
            clipboard := "↻"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⥀": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⥀
            clipboard := "⥀"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Ar​row∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⥁": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⥁
            clipboard := "⥁"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
; •───────────────────── BULLETS ────────────────────•
; ◦——————— 
   Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◦": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◦
            clipboard := "◦"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    •": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}•
            clipboard := "•"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ○": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}○
            clipboard := "○"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ●": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}●
            clipboard := "●"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▫": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}▫
            clipboard := "▫"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▪": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}▪
            clipboard := "▪"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ☐": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}☐
            clipboard := "☐"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ■ ), CCase": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}■
            clipboard := "■"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◇": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◇
            clipboard := "◇"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◈": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◈
            clipboard := "◈"
        SoundBeep, 1200, 75
    Return
; ◦———————  
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ◆": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}◆
            clipboard := "◆"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✧": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}✧
            clipboard := "✧"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✦": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}✦
            clipboard := "✦"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▹": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}▹
            clipboard := "▹"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ▸": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}▸
            clipboard := "▸"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⪧": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⪧
            clipboard := "⪧"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    🠺": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}🠺
            clipboard := "🠺"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ☞": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}☞
            clipboard := "☞"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Bullet∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ☛": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}☛
            clipboard := "☛"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
; •───────────────────── STARS ────────────────────•
; ◦——————— 
    Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✶": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}✶
            clipboard := "✶"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✹": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}✹
            clipboard := "✹"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✸": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}✸
            clipboard := "✸"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ★": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}★
            clipboard := "★"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✦": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}✦
            clipboard := "✦"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ❊": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}❊
            clipboard := "❊"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ❈": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}❈
            clipboard := "❈"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ❋": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}❋
            clipboard := "❋"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ❉": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}❉
            clipboard := "❉"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✺": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}✺
            clipboard := "✺"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⛤": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⛤
            clipboard := "⛤"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⚝": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⚝
            clipboard := "⚝"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⛧": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⛧
            clipboard := "⛧"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✰": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}✰
            clipboard := "✰"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
Case "Insert Star∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ☆": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}☆
            clipboard := "☆"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
; •─────────────────── SYMBOLS ───────────────────•
; ◦——————— 
    Case "Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ÷": 
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}÷
            clipboard := "÷"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ⨯":  
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}⨯
            clipboard := "⨯"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ±":  
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}±
            clipboard := "±"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ≥":  
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}≥
            clipboard := "≥"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ≤":  
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}≤
            clipboard := "≤"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    μ":  
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}μ
            clipboard := "μ"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    Δ":  
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}Δ
            clipboard := "Δ"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    π":  
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}π
            clipboard := "π"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ➕":  
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}➕
            clipboard := "➕"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ➖":  
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}➖
            clipboard := "➖"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ✖️":  
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}✖️
            clipboard := "✖️"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
    Case "Insert  Symbol∙∙∙∙∙∙∙∙∙∙∙∙∙∙    ➗":  
        WinActivate % "ahk_id" hWnd
        SendInput {Raw}➗
            clipboard := "➗"
        SoundBeep, 1200, 75
    Return
; ◦——————— 
; ⬦──────────────── CASE CLOSING ────────────────⬦ 
; ❪ Keep At Bottom of all Case Things ❫
} 	 ; ⮘⮘ Keep this last curly bracket at the end of ALL Case Things! 

PutText(TempText)
SetCapsLockState, Off
Return
; ❪ Keep At Bottom of all Case Things ❫

; ⬦───────────────── THE CASES End ───────────────⬦ 

; ⯁═══════════════ THE FUNCTIONS ════════════════⯁ 
; ◦——————— 
; Copies the selected text to a variable while preserving the clipboard.
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
; ◦————————— 
; Pastes text from a variable while preserving the clipboard.
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
; ◦————————— 
CopyClipboard()
{
    global ClipSaved := ""
    ClipSaved := ClipboardAll  ; save original clipboard contents
    Clipboard := ""  ; start off empty to allow ClipWait to detect when the text has arrived
    Send {Ctrl down}c{Ctrl up}
    Sleep 150
    ClipWait, 1.5, 1
    if ErrorLevel
    {
        Clipboard := ClipSaved  ; restore the original clipboard contents
        ClipSaved := ""  ; clear the variable
        return
    }
}
; ◦————————— 
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
; ◦————————— 
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
; ◦——————— 
; ⬦─────────────── THE FUNCTIONS End ─────────────⬦ 

; ⯁══════════════ Reload/Exit Routine ═══════════════⯁ 
RETURN

; ⮞━━━━━ RELOAD ━━━━ RELOAD ━━━━ RELOAD ━━━━━⮜ 
^Home:: 
If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200) 	 ; ←←← Double-Tap in less than 200 milliseconds.
SoundGet, master_volume
SoundSet, 3
    SoundBeep, 1700, 75
SoundSet, master_volume
        Reload
Return

; ⮞━━━━━━ EXIT ━━━━━━━━ EXIT ━━━━━━━━ EXIT ━━━━━━━⮜ 
^Esc:: 
If (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200) 	 ; ←←← Double-Tap in less than 200 milliseconds.
    Gui, Destroy
SoundGet, master_volume
SoundSet, 3
    SoundBeep, 1700, 75
SoundSet, master_volume
    ExitApp
Return
; ⬦──────────── Reload/Exit Routine End ─────────────⬦ 

;⯁═══════════════ Script Updater ══════════════⯁
UpdateCheck: 	 ; Check if the script file has been modified.
    oldModTime := currentModTime
FileGetTime, currentModTime, %A_ScriptFullPath%
; 🠪 🠪 🠪 If the modification timestamp has changed, reload the script. 
    if  (oldModTime = currentModTime) Or (oldModTime = "")
        Return
SoundGet, master_volume
SoundSet, 3
    SoundBeep, 1500, 75
SoundSet, master_volume
Reload
; ⬦────────────── Script Updater End ───────────────⬦ 

;⯁═══════════════ Auto-Execute Sub ════════════════⯁
AutoExecute: 
#NoEnv ; Recommended for performance and future compatibility.
#NoTrayIcon ; Disables the showing of a tray icon.
#Persistent ; Keeps a script permanently running until user closes it or ExitApp is encountered.
#SingleInstance, Force ; Determines whether a script is allowed to run again when it is already running.
SetBatchLines -1 ; Determines how fast script will run.
SetTimer, UpdateCheck, 500 ; Checks for script changes every 1/2 second. (Script Updater)
SetTitleMatchMode, 2
Return
; ⬦──────────── Auto-Execute Sub End ──────────────⬦ 

;⯁═════════════════ The GoSubs ══════════════════⯁
; ∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙ 
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
; ∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙ 
GuiBegin:
    Gui, 
        +AlwaysOnTop
        -Caption 
        +hwndHGUI 
        +LastFound
        +E0x02000000 +E0x00080000 ; Double Buffer to reduce Gui flicker.
    Gui, Color, BLACK
    Gui, Font, s14 cF5DE00, ARIAL
    Gui, Margin, 15, 15
    Gui, Add, Text, w150 h50 Center +BackgroundTrans +0x0200 0x00800000, ATTENTION!!  	 ; (0x00800000 = Creates a thin-line border box) (+0x0200 = Vertical Center)
    Gui, Font, s10
Return
; ∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙ 
GuiEnd:
    Gui, Show, Hide
        WinGetPos, X, Y, W, H
        R := Min(W, H) // 5 	 ; <<<<-----  Set value to amount of cornering. (0.5=Oval, 0=square, 1= capsule, 5=rounded corners).
        WinSet, Region, 0-0 W%W% H%H% R%R%-%R% 	  ; <<<<-----  Cornering math.
    Gui, Show, NoActivate, 
        OnMessage(0x0201, "WM_LBUTTONDOWN")
Return
; ∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙ 
ASSIST:
    SoundBeep, 1200, 100
        ;;  Possible future coding...
    Return
; ∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙ 
~^z:: 			 ; Undo Sound Notification.
    SoundGet, master_volume
    SoundSet, 3
        Sleep, 50
        Soundbeep, 1000, 75
    SoundSet, master_volume
Return
; ∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙ 
; ⬦──────────────── GoSubs End ──────────────────⬦ 

/*
____________________________________________________________ 
 ∘⪻⋘⪡⫷⫷⫷⫷⫷⫷ SCRIPT END ⫸⫸⫸⫸⫸⫸⪢⋙⪼∘ 
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾ 
*/

