# Scope

## Compilation
1. JavaScript is a compiled language. The difference between it and C++ that in C++ compilation happens in a build step ahead of time, in JavaScript compilation that occurs happends microseconds before the code is executed.
1. Compilation have the following steps:
    * **Tokenizing** - breaking up a string of characters into meaningful chunks, called tokens. For instance, consider the program `var a = 2`;. This program would likely be broken into the following tokens: `var`, `a`, `=`, `2` and `;`.
    * **Parsing** - taking a stream (array) of tokens and turning it into a tree of nested elements "AST" (Abstract Syntax Tree).<br>
    The tree for `var a = 2;`:
        * Variable Declaration
            * Identifier (whose value is a)
            * AssignmentExpression
                * NumbericLiteral (whose value is 2)
    * **Code-Generating** -  the process of taking an AST and turning it into executable code.

## Code execution
1. _Engine_ - responsible for start-to-finish compilation
1. _Compiler_ - handles all the dirty work of parsing and code-generation
1. _Scope_ - collects and maintains a look-up list of all declared identifiers (variables), and enforces a strict set of rules as how these are accessible to currently executin code.

