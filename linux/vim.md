# Vim

## Table of content
* [Table of content](#table-of-content)
* [Switching modes](#switching-modes)
* [Common](#common)
* [Code navigation](#code-navigation)
* [Go To](#go-to)
* [Code editing](#code-editing)
* [Deleting](#deleting)
* [Copying and Pasting](#copying-and-pasting)
* [Find](#find)
* [Multiple Edition](#multiple-edition)

## Switching modes
1. **`a`** - go to editing mode and set cursor to new character
1. **`i`** - go to edit mode and set cursor to current character
1. **`esc`** - go to command mode

## Common
1. **`.`** - repeat last command
1. **`v`** - go to visual mode
1. **`:w`** - save
1. **`:q`** - quit
1. **`u`** - undo
1. **`ctrl + r`** - redo
1. **`:help`** - help

## Code navigation
1. **`h`** - one character left
1. **`l`** - one character right
1. **`j`** - one character down
1. **`k`** - one character up
1. **`w`** - moves forward to the start of next word
1. **`e`** - moves forward to the end of the next (current) word
1. **`b`** - moves back to beginning of the word
1. **`nw`* - moves through `n` to the begining of the nth line
1. **`%`** - jump to the next matching parenthesis

## Go To
1. **`g10`** - go to line 10
1. **`gg`** - go to begining of a file
1. **`G`** - go to the end of a file

## Code editing
1. **`i`** - go to the edit mode under cursor
1. **`a`** - go to the edit mode starting with next character to cursort
1. **`o`** - insert new line and go to edit mode
1. **`O`** - move to the end of line and go to edit mode
1. **`r`** - replace one character and not go to edit mode
1. **`cc`** - delete current line and go to edit mode
1. **`cw`**- delete next word and go to edit mode
1. **`:m line_number or +\- number`** - moves current line
    * **`:m +1`** - move line one line down
    * **`:m 12`** - move current line to 12 line
1. **`30itext`** + esc - inserts word text 30 times


## Deleting
1. **`d$`** - deletes from current position to the end of line
1. **`d^`** - deletes from current backward to first non-white-space character
1. **`d0`** - deletes from current backward to begining of line
1. **`dw`** - deletes current to end of current word (including trailing space)
1. **`dd`** - cuts whole line
1. **`db`** deletes current to begining of current word
1. **`x`** - removes character under the cursor
1. **`X`** - removes one character left to the cursor

## Copying and Pasting
1. **`p`** - past from buffer
1. **`yy`** - yank next line to buffer
1. **`10yy`** - yank next 10 lines to buffer

## Find
1. **`fa`** - finds the next occurences of a
1. **`*`** - finds the next occurence of the word
1. **`#`** - finds the previous occurence of the word
1. **`/`** - search a word
    * **`n`** - go to next occurence
    * **`N`** - go to previous occurence

## Multiple Edition
1. Go to visual mode `ctrl + v`
1. Select necessary lines
1. Go to edit mode `shift i`
1. Write something
1. Press `esc` twice
