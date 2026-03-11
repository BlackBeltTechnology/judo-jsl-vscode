# extension-host Specification

## Purpose
The extension host is the TypeScript entry point (`src/extension.ts`) that activates the JUDO JSL VS Code extension, spawns the embedded Java language server, and establishes LSP communication over stdio.

## Architecture
The extension host consists of a single TypeScript module that exports `activate()` and `deactivate()` functions conforming to the VS Code Extension API. On activation, it resolves the platform-specific launcher script (`jsl-standalone` or `jsl-standalone.bat`), configures `ServerOptions` and `LanguageClientOptions`, and starts a `LanguageClient` from the `vscode-languageclient` library. The client watches for `**/*.jsl` file changes and registers the `jsl` document selector.

## Requirements

### Requirement: Lazy activation on JSL language
The extension SHALL activate only when a JSL file is opened, using the `onLanguage:jsl` activation event.

#### Scenario: User opens a .jsl file
- **GIVEN** VS Code is running with the extension installed
- **WHEN** a file with the `.jsl` extension is opened
- **THEN** the `activate()` function is called and the language server is started

#### Scenario: No .jsl files opened
- **GIVEN** VS Code is running with the extension installed
- **WHEN** no `.jsl` files are opened
- **THEN** the extension remains inactive and consumes no resources

### Requirement: Platform-aware language server launch
The extension SHALL select the correct launcher script based on the operating system platform.

#### Scenario: Launch on Linux/macOS
- **GIVEN** the OS platform is not `win32`
- **WHEN** the extension activates
- **THEN** the `jsl-standalone` shell script is used as the server command

#### Scenario: Launch on Windows
- **GIVEN** the OS platform is `win32`
- **WHEN** the extension activates
- **THEN** the `jsl-standalone.bat` batch script is used as the server command

### Requirement: LSP client configuration
The extension SHALL configure the language client with the `jsl` document selector and a file system watcher for `**/*.jsl` patterns.

#### Scenario: Language client starts successfully
- **GIVEN** the language server binary exists at the resolved path
- **WHEN** `activate()` is called
- **THEN** a `LanguageClient` is created with document selector `['jsl']`, verbose tracing enabled, and `start()` is called

### Requirement: Graceful deactivation
The extension SHALL stop the language client when deactivated.

#### Scenario: Extension deactivation
- **GIVEN** the language client is running
- **WHEN** `deactivate()` is called
- **THEN** `lc.stop()` is called and a promise is returned

### Requirement: Debug environment support
The extension SHALL support Java remote debugging on port 8000 in debug mode.

#### Scenario: Debug launch configuration
- **GIVEN** the extension is launched in debug mode
- **WHEN** the server is started with debug options
- **THEN** `JAVA_OPTS` is set to `-Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=8000,suspend=n,quiet=y`
