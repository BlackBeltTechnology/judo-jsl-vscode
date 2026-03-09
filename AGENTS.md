# JUDO JSL VS Code Extension - Project Documentation

## Project Overview


**Repository:** BlackBeltTechnology/judo-jsl-vscode
**License:** Eclipse Public License 2.0 (EPL-2.0)
**Java Version:** 21
**Build System:** Maven 3.9.4+ with frontend-maven-plugin for Node.js/npm/TypeScript/VSCE toolchain

1. Provides a VS Code extension for the JUDO Specification Language (JSL), a domain-specific language for the JUDO platform
2. Bundles an embedded Java-based language server (`hu.blackbelt.judo.meta.jsl.server.embedded`) that provides code completion, diagnostics, and symbol lookup via the Language Server Protocol (LSP)
3. Includes TextMate grammar for JSL syntax highlighting, sourced from the `judo-jsl-tmbundle` dependency
4. Communicates between the TypeScript extension host and the Java language server over stdio
5. Packages as a `.vsix` file for manual installation (not yet on the VS Code Marketplace)

## Code Instructions

1. First think through the problem, read the codebase for relevant files.
2. Before you make any major changes, check in with me and I will verify the plan.
3. Please every step of the way just give me a high level explanation of what changes you made.
4. Make every task and code change you do as simple as possible. We want to avoid making any massive or complex changes. Every change should impact as little code as possible. Everything is about simplicity.
5. Maintain a documentation file that describes how the architecture of the app works inside and out.
6. Never speculate about code you have not opened. If the user references a specific file, you MUST read the file before answering. Make sure to investigate and read relevant files BEFORE answering questions about the codebase. Never make any claims about code before investigating unless you are certain of the correct answer - give grounded and hallucination-free answers.
7. For implementation use TDD (Test-Driven Development): write or update tests first to define the expected behaviour, verify they fail, then write the minimal implementation to make them pass.
8. Use DRY (Don't Repeat Yourself): extract reusable logic into separate classes, utilities, or components. If the same pattern appears in multiple places, refactor it into a shared helper.

## Directory Structure

```
judo-jsl-vscode/
├── src/
│   ├── extension.ts          # Extension entry point — LSP client setup
│   ├── tsconfig.json          # TypeScript compiler config (ES6, CommonJS)
│   └── jsl/
│       ├── bin/               # Language server launcher scripts
│       │   ├── jsl-standalone      # POSIX launcher
│       │   └── jsl-standalone.bat  # Windows launcher
│       └── lib/               # Language server JARs (copied by Maven)
├── out/                       # Compiled JS output (from tsc)
├── syntaxes/
│   └── jsl.tmLanguage         # TextMate grammar (copied from tmbundle)
├── images/                    # Extension icon
├── doc/                       # Documentation images
├── .vscode/
│   ├── launch.json            # Debug configuration
│   └── settings.json          # Java/editor settings
├── .github/
│   └── workflows/             # CI/CD GitHub Actions
├── package.json               # VS Code extension manifest and npm scripts
├── language-configuration.json # Bracket/comment rules for JSL
└── pom.xml                    # Maven build configuration
```

## Core Modules

This is a single-module project (no Maven submodules). The main components are:

| Component | Type | Purpose |
|-----------|------|---------|
| `src/extension.ts` | TypeScript | Extension entry point; creates `LanguageClient`, spawns Java language server, configures LSP |
| `src/jsl/bin/jsl-standalone` | Shell/Batch | Platform-specific launcher scripts for the embedded Java language server |
| `src/jsl/lib/` | Java JARs | Bundled language server from `hu.blackbelt.judo.meta.jsl.server.embedded` |
| `syntaxes/jsl.tmLanguage` | TextMate | Syntax highlighting grammar extracted from `judo-jsl-tmbundle` |
| `language-configuration.json` | JSON | Bracket pairs (`{}`, `[]`, `()`), comment syntax (`//`, `/* */`), auto-closing pairs |
| `package.json` | JSON | Extension manifest: activation event (`onLanguage:jsl`), language contribution (`.jsl` files), grammar binding |

## Technology Stack

### Core Technologies
- **TypeScript 4.6** — Extension host code, compiled to ES6/CommonJS
- **vscode-languageclient 8.0.1** — LSP client library for VS Code extensions
- **Java 21** — Language server runtime (bundled, not compiled here)
- **Language Server Protocol** — Communication between extension and server over stdio

### Build & Quality
- **Maven** — Primary build orchestrator with `frontend-maven-plugin` (v1.12.1) for Node.js management
- **Node.js v16.14.2** — Managed by frontend-maven-plugin, runs TypeScript compiler and VSCE
- **vsce 2.7.0** — VS Code Extension CLI for packaging VSIX files
- **flatten-maven-plugin 1.3.0** — Resolves CI-friendly `${revision}` versions
- **Sonarqube** — Code quality metrics (on develop branch)
- No test framework configured (test dependencies exist but no test suites)
- No linter/formatter configured (relies on TypeScript compiler)

## Build Commands

```sh
# Full build: compile TypeScript, copy language server + grammar, package VSIX
mvn clean install

# TypeScript compilation only
npm run compile

# TypeScript watch mode
npm run watch

# Skip frontend build (Maven only, no VSIX packaging)
mvn clean install -DskipModules=true
```

> **Note:** The Maven wrapper (`mvnw`) is available and used in CI.

### Maven Profiles

| Profile | Purpose |
|---------|---------|
| `modules` | Default; runs frontend-maven-plugin (Node install, npm install, vsce package) |
| `generate-checksum` | Creates checksum CSV/XML artifacts for build verification |
| `sign-artifacts` | GPG-signs artifacts using `sign-maven-plugin` |
| `release-dummy` | Deploys to local `/tmp/` directory for testing |
| `release-judong` | Deploys to internal Nexus repository (`nexus.judo.technology`) |
| `release-central` | Deploys to Maven Central via Sonatype OSSRH |

## Key Configuration Files

| File | Purpose |
|------|---------|
| `pom.xml` | Maven build: dependency management, frontend-maven-plugin config, profiles, version properties |
| `package.json` | VS Code extension manifest: activation events, language contributions, npm scripts |
| `src/tsconfig.json` | TypeScript config: target ES6, module CommonJS, output to `../out` |
| `language-configuration.json` | JSL language rules: brackets, comments, auto-closing pairs |
| `.vscode/launch.json` | Debug config: launches extension in new VS Code window |
| `.github/workflows/build.yml` | Main CI pipeline: build, test, deploy, tag, release |

## Development Environment

**Required:**
- Java 21 JDK
- Maven 3.9.4+
- VS Code (for running/debugging the extension)

**Managed automatically:**
- Node.js v16.14.2 (installed by `frontend-maven-plugin`)
- npm packages (installed during Maven build)

**Debugging:**
- Use `.vscode/launch.json` — launches extension in a new VS Code window with `--extensionDevelopmentPath`
- Java remote debugging available on port 8000 (set via `JAVA_OPTS` in `createDebugEnv()` in `extension.ts`)

## Git Workflow

- **Main Branch:** `develop`
- **Versioning:** `${revision}` = `1.0.4-SNAPSHOT` (CI-friendly, resolved by flatten-maven-plugin)
- **Branching:** GitFlow — `feature/JNG-xxx`, `release/x.y.z`, `bugfix/JNG-xxx`, `hotfix/JNG-xxx`, `master`
- **Commit rule:** Every commit must include a Jira ticket number (`JNG-xxx`)
- **CI:** GitHub Actions on self-hosted `judong` runner; builds deploy to Nexus, releases to Maven Central
- **Version format on develop:** `major.minor.patch.YYYYMMDD_HHMMSS_commitId_branchName`
- **Version format on release/master:** clean `major.minor.patch`

## Important Notes

1. The language server JARs in `src/jsl/lib/` are **not committed** — they are copied during Maven build from the `hu.blackbelt.judo.meta.jsl.server.embedded` dependency (`.gitignore` excludes `src/jsl/lib/*.jar`)
2. The `syntaxes/jsl.tmLanguage` file is also **not committed** — it is extracted from the `judo-jsl-tmbundle` dependency during Maven's `generate-resources` phase
3. The compiled `out/` directory is **not committed** — TypeScript is compiled during build
4. The VSIX file (`jsl-language.vsix`) is **not committed** — it is produced by `vsce package` during build
5. The extension activates lazily via `onLanguage:jsl` — it only loads when a `.jsl` file is opened
6. There are **no automated tests** currently configured, despite test dependencies being present in `package.json`
7. The extension's display name in VS Code is "JUDO JSL" and it registers the `jsl` language ID with the `.jsl` file extension

## Related Documentation

- [README.md](README.md) — Project overview, installation guide, architecture
- [CONTRIBUTING.md](CONTRIBUTING.md) — Contribution guidelines, build instructions
- [.github/CIFLOW.md](.github/CIFLOW.md) — Detailed CI/CD workflow documentation with diagrams
