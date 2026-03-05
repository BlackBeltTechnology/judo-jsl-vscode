# Contributing to JUDO JSL VS Code Extension

## Development Environment Setup

Your environment must meet the following requirements (see the parent project's [CONTRIBUTING guide](https://github.com/BlackBeltTechnology/judo-community/blob/develop/CONTRIBUTING.adoc) for full details):

| Requirement | Version |
|-------------|---------|
| Java JDK | 21 |
| Maven | 3.9.4+ |
| Node.js | Managed by `frontend-maven-plugin` (v16.14.2) |

## Code Structure

| Directory | Purpose |
|-----------|---------|
| `src/` | Extension source code (TypeScript) and bundled language server (Java) |
| `src/extension.ts` | Extension entry point — LSP client activation |
| `src/jsl/` | Bundled language server binaries and JARs |
| `out/` | Compiled JavaScript output from TypeScript |
| `syntaxes/` | TextMate grammar for JSL syntax highlighting |

## Build

```sh
# Full build (compiles TypeScript, copies language server, packages VSIX)
mvn clean install
```

## Submitting an Issue

Before submitting, search the [issue tracker](https://github.com/BlackBeltTechnology/judo-jsl-vscode/issues) for existing reports. When filing a bug, include:

- Output of `java -version` and `mvn -version`
- `pom.xml` or `.flattened-pom.xml` (when applicable)
- A minimal reproducible use case

File new issues using the [issue form](https://github.com/BlackBeltTechnology/judo-jsl-vscode/issues/new/choose).

## Submitting a Pull Request

This project follows [GitHub's standard forking model](https://guides.github.com/activities/forking/). Fork the project and submit pull requests from your fork.

> **Important:** Every commit must include a Jira ticket number (`JNG-xxx`). There is no commit without a ticket number.
