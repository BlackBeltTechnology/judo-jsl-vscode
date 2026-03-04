# build-packaging Specification

## Purpose
Defines the Maven-driven build pipeline that compiles TypeScript, copies the embedded language server and TextMate grammar from Maven dependencies, and packages the extension as a VSIX file for distribution.

## Architecture
The build is orchestrated by Maven (`pom.xml`, packaging type `pom`) with no submodules. Key plugins: `flatten-maven-plugin` resolves CI-friendly `${revision}` versions, `maven-dependency-plugin` copies the language server JAR and TextMate grammar bundle, and `frontend-maven-plugin` manages Node.js installation, npm dependency installation, TypeScript compilation, and VSCE packaging. The output is `jsl-language.vsix`.

## Requirements

### Requirement: Language server bundling
The build SHALL copy the `hu.blackbelt.judo.meta.jsl.server.embedded` JAR (classifier `ls`) to `src/jsl/lib/` with version stripping.

#### Scenario: Maven copies language server
- **GIVEN** the `modules` profile is active (default)
- **WHEN** Maven executes the `process-sources` phase
- **THEN** the language server JAR is copied to `src/jsl/lib/` without version suffix, overwriting snapshots

### Requirement: TextMate grammar extraction
The build SHALL extract `jsl.tmLanguage` from the `judo-jsl-tmbundle` dependency into the `syntaxes/` directory.

#### Scenario: Grammar unpacked
- **WHEN** Maven executes the `generate-resources` phase
- **THEN** `**/*.tmLanguage` files from the `judo-jsl-tmbundle` artifact are extracted to the project base directory

### Requirement: Node.js and npm management
The build SHALL install Node.js v16.14.2 and run `npm install` automatically via `frontend-maven-plugin`.

#### Scenario: Frontend toolchain setup
- **GIVEN** the `modules` profile is active
- **WHEN** Maven executes the `generate-resources` phase
- **THEN** Node.js v16.14.2 is installed locally and `npm install` runs to install dependencies

### Requirement: VSIX packaging
The build SHALL produce `jsl-language.vsix` by running `vsce package` via npm.

#### Scenario: Extension packaged
- **GIVEN** npm dependencies are installed and TypeScript is compiled
- **WHEN** Maven executes the `vsce package` step
- **THEN** `jsl-language.vsix` is created in the project root

### Requirement: CI-friendly versioning
The build SHALL resolve `${revision}` property using `flatten-maven-plugin` to produce deterministic POM files.

#### Scenario: Version resolution
- **WHEN** Maven executes the `process-resources` phase
- **THEN** `flatten-maven-plugin` resolves `${revision}` (currently `1.0.4-SNAPSHOT`) and produces `.flattened-pom.xml`

### Requirement: Artifact signing
The build SHALL support GPG signing of artifacts when the `sign-artifacts` profile is active.

#### Scenario: Signed build
- **GIVEN** the `sign-artifacts` profile is active and GPG keys are configured
- **WHEN** Maven executes the `sign` goal
- **THEN** all artifacts are signed using `sign-maven-plugin`

### Requirement: Multi-repository deployment
The build SHALL support deployment to Nexus (`release-judong`), Maven Central (`release-central`), and local filesystem (`release-dummy`).

#### Scenario: Deploy to Nexus
- **GIVEN** the `release-judong` profile is active
- **WHEN** `mvn deploy` is executed
- **THEN** artifacts are deployed to `https://nexus.judo.technology/repository/maven-judong-snapshots/`
