# Claude

* TOC
{:toc}


## Modes

### Planning Mode

Used to get wider understanding of problem and come up with solution.

#### Activation

`shift+tab` in claude code

words like **step-by-step** in claude.ai or chatgpt.com

### Thinking Mode

Used to go **deep** into problem.

#### Activation

The following modes are supported, to activate just type this word

* `<think>` - basic extended thinking
* `<think hard>` - more thinking budget
* `<think harder>` - even more thinking budget
* `<ultrathink>`- maximum thinking budget

Claude supports different thinking modes that control how reasoning is performed and displayed:

## Context

* `<esc> + <esc>` - rewind the conversation (and code) to an earlier point in time, allows to maintain only valuable context
* `/compact` - summarizes the conversation and continue, helps Claude stay focused but remember what it has learned in the current session
* `/clear` - clears the context. Useful when you want to start working on a new task in the same session
* `/context` - show claude context

## Hooks

Hooks are shell commands that execute in response to events like tool calls. They allow you to intercept and modify Claude Code's behavior.

### Use cases

* Run a code formatter after Claude edits a file
* Stop Claude from editing or reading a particular file
* Run tests automatically after a file is changed
* Block deprecated function usage

### Hook Flow

![Claude Code Hooks Flow](img/hooks.png)

### Usage

check for all available hooks with `/hooks` command in code

* **PreToolUse** hook runs before Claude Code executes a tool (like reading a file)
* **PostToolUse** hook runs after the tool completes
* Hooks can be configured in settings to customize Claude Code's behavior
* Useful for logging, validation, or modifying tool behavior

## Prompts
> Check why this function ..., use git history"
> commit, push, pr

### Brainstorm Ideas and make a plan
> Propose a few fixes for issue #123, then implement the one I pick

> Identify edge cases that are not covered in `@app/run.py`, then update the tests to cover these. think hard

> Use 3 parallel agents to brainstorm ideas for how to cleanup `@services/xxx.cpp`

### Teach Claude about internal CLI tools you are using

> Use bk CLI to create project

## Best Practicies
https://www.anthropic.com/engineering/claude-code-best-practices

1. Write good code (SOLID and DDD)
1. Plan in advance
1. Give Claude a way to iterate on results automatically (write some unit tests, define what success / failure look like)
