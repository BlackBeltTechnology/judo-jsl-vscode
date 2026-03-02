# language-support Specification

## Purpose
Defines the JSL language registration in VS Code, including file association, syntax highlighting via TextMate grammar, and editor behavior configuration (brackets, comments, auto-closing pairs).

## Architecture
Language support is configured declaratively through three files: `package.json` (language and grammar contributions), `language-configuration.json` (editor behavior), and `syntaxes/jsl.tmLanguage` (TextMate grammar). The language is registered with id `jsl`, file extension `.jsl`, and scope name `source.jsl`.

## Requirements

### Requirement: JSL language registration
The extension SHALL register the `jsl` language with VS Code, associating it with the `.jsl` file extension.

#### Scenario: Language recognized
- **GIVEN** the extension is installed
- **WHEN** a file with `.jsl` extension is opened
- **THEN** VS Code identifies the file as language id `jsl` with aliases "JUDO Specification Language" and "jsl"

### Requirement: Syntax highlighting
The extension SHALL provide TextMate-based syntax highlighting for JSL files using scope name `source.jsl`.

#### Scenario: Grammar applied
- **GIVEN** a `.jsl` file is opened
- **WHEN** VS Code renders the file
- **THEN** the `syntaxes/jsl.tmLanguage` grammar is applied with scope `source.jsl`

### Requirement: Comment support
The extension SHALL support line comments (`//`) and block comments (`/* */`) for JSL files.

#### Scenario: Toggle line comment
- **GIVEN** a `.jsl` file is open with the cursor on a line
- **WHEN** the user triggers "Toggle Line Comment"
- **THEN** `//` is inserted or removed at the beginning of the line

#### Scenario: Toggle block comment
- **GIVEN** a `.jsl` file is open with text selected
- **WHEN** the user triggers "Toggle Block Comment"
- **THEN** `/*` and `*/` are inserted or removed around the selection

### Requirement: Bracket matching and auto-closing
The extension SHALL define bracket pairs `{}`, `[]`, `()` and auto-closing pairs for braces, brackets, parentheses, quotes, backticks, and block comments.

#### Scenario: Auto-close braces
- **GIVEN** a `.jsl` file is being edited
- **WHEN** the user types `{`
- **THEN** `}` is automatically inserted after the cursor

#### Scenario: Auto-close block comment
- **GIVEN** the cursor is not inside a string
- **WHEN** the user types `/*`
- **THEN** ` */` is automatically inserted after the cursor

### Requirement: Surrounding pairs
The extension SHALL support surrounding selected text with `{}`, `[]`, `()`, `<>`, single quotes, double quotes, and backticks.

#### Scenario: Surround with brackets
- **GIVEN** text is selected in a `.jsl` file
- **WHEN** the user types `[`
- **THEN** the selected text is wrapped with `[` and `]`
