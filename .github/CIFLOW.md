# CI/CD Flow — Development Version and Branch Handling

This document describes the branching strategy, versioning policy, and GitHub Actions CI/CD workflows used by this project.

## Branching Strategy

The project follows [GitFlow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow):

| Branch Pattern | Purpose | Based On |
|---------------|---------|----------|
| `develop` | Main development branch; contains latest development sources | — |
| `feature/JNG-xxx_summary` | New feature development | `develop` |
| `release/x.y.z` | Release stabilization (`release/` prefix reserved for CI) | `develop` |
| `bugfix/JNG-xxx_summary` | Bug fixes during release testing | release branch |
| `support/JNG-xxx_summary` | Minor changes to a previous release | release branch |
| `master` | Latest production release | release branch (via merge) |
| `hotfix/JNG-xxx_summary` | Urgent fixes to production | `master` |

### Branch Flow

```mermaid
gitGraph
    commit id: "init"
    branch develop
    checkout develop
    commit id: "dev-1"
    branch feature/JNG-1
    commit id: "feat-1a"
    commit id: "feat-1b"
    checkout develop
    merge feature/JNG-1
    commit id: "dev-2"
    branch feature/JNG-3
    commit id: "feat-3a"
    checkout develop
    branch release/1.0-beta1
    commit id: "rc-1"
    branch bugfix/JNG-4
    commit id: "fix-4"
    checkout release/1.0-beta1
    merge bugfix/JNG-4
    checkout develop
    merge feature/JNG-3
    checkout develop
    merge release/1.0-beta1
    checkout main
    merge release/1.0-beta1 id: "v1.0"
```

## Version Numbers

Versions follow semantic versioning with these rules:

| Event | Version Change |
|-------|---------------|
| Start a `feature/` branch | No change |
| Start a `release/` branch | Increment 2nd number on `develop` |
| Start a `bugfix/` branch | No change (applied on release branch before merge to master) |
| Start a `support/` branch | Increment 3rd number |
| Start a `hotfix/` branch | Increment 4th number (applied to both release and master) |

## GitHub Actions Workflows

### build.yml — Main Build Pipeline

Triggers on pushes to `develop` and pull requests to `develop`, `master`, `increment/*`, `release/*`.

```mermaid
flowchart TD
    A["Push / PR trigger"] --> B{"Base branch?"}
    B -->|"master, release/*"| C["Version = major.minor.qualifier<br/>(from pom.xml, no -SNAPSHOT)"]
    B -->|"develop, increment/*"| D["Version = major.minor.qualifier<br/>.YYYYMMDD_HHMMSS_commitId_branch"]
    C --> E["Build & deploy to Nexus"]
    D --> E
    E --> F["Create git tag v&lt;version&gt;"]
    F --> G{"increment/* or release/*?"}
    G -->|Yes| H["Create merge-pr/&lt;version&gt; tag"]
    H --> I["Triggers merge-pr-tagged.yml"]
    G -->|No| J{"develop branch?"}
    J -->|Yes| K["Build changelog"]
    K --> L["Create GitHub pre-release"]
    E -->|"release/* only"| M["Deploy to Maven Central"]
    E --> N["Sonar metrics (develop only)"]
    L --> O["Discord notification"]
```

### merge-pr-tagged.yml — PR Auto-Merge

Triggers when a `merge-pr/*` tag is pushed.

```mermaid
flowchart TD
    A["merge-pr/* tag pushed"] --> B["Extract version from tag"]
    B --> C{"Version format?"}
    C -->|"major.minor.qualifier<br/>(release)"| D["Merge PR to master"]
    D --> E["Triggers create-release-on-master.yml"]
    C -->|"Other<br/>(increment)"| F["Squash PR to develop"]
    F --> G["Triggers build.yml"]
    D --> H["Delete merge-pr tag"]
    F --> H
```

### create-release-on-master.yml — Release Finalization

Triggers on pushes to `master`.

```mermaid
flowchart TD
    A["Push to master"] --> B["Get version from tag"]
    B --> C["Build changelog"]
    C --> D["Create GitHub release (latest)"]
```

### release.yml — Manual Release Trigger

Manually triggered with a version parameter (`auto` or `major.minor.qualifier`).

```mermaid
flowchart TD
    A["Manual trigger with version"] --> B{"Version = 'auto'?"}
    B -->|Yes| C["Read version from pom.xml<br/>(strip -SNAPSHOT)"]
    B -->|No| D["Use given version"]
    C --> E["Calculate next version<br/>(qualifier + 1)"]
    D --> E
    E --> F["Create PR to master<br/>with release version"]
    E --> G["Create PR to develop<br/>with next version"]
    F --> H["Triggers build.yml"]
    G --> H
```

## Development Rules

> **Important:** There is no commit without a ticket number. Every pull request and commit must include a Jira ticket reference (`JNG-xxx`).

Issue tracking: [JIRA](https://blackbelt.atlassian.net/jira/dashboards)
