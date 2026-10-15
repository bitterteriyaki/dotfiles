# bitterteriyaki/dotfiles Constitution

## Core Principles

### I. Single Machine, Personal Scope

This repository configures one Arch Linux + Hyprland desktop for one user. Every change MUST be
optimized for that machine and that user's workflow, not for portability or for other people.

- Features MUST NOT be generalized "just in case" (no options, abstractions or templates for
  hypothetical machines) unless a spec explicitly asks for it.
- Concrete local facts (monitor names such as `HDMI-A-1` / `DVI-D-1`, locale, installed fonts)
  MAY be relied on directly, and specs SHOULD name them when behaviour depends on them.

Rationale: the README states this is not a community config; generality adds cost with no user.

### II. chezmoi Source Is the Source of Truth

All configuration lives in this repository as the chezmoi source root, and the home directory is
only ever changed by `chezmoi apply`.

- Edits MUST be made to source files (`dot_*`, `private_dot_*`, `*.tmpl`), never to the rendered
  files under `~`. A target that drifted from the source (e.g. a tool writing to its own config)
  MUST be reconciled back into the source or explicitly accepted as lost, not silently kept.
- Files that must not reach `~` (README, LICENSE, editor/LSP files, `.claude/`, `.specify/`) MUST
  be listed in `.chezmoiignore`.
- A `.tmpl` file MUST be justified by chezmoi source data it actually reads; otherwise the file is
  static.
- Sensitive files (keys, credentials) MUST be applied as `private_*` (0600) and secrets MUST be
  fetched from Bitwarden at apply time, never committed.

Rationale: a single source keeps the desktop reproducible and diffable.

### III. Reproducible, Declarative Provisioning

A fresh machine MUST reach the same state from `chezmoi apply` alone.

- System packages MUST be added to `.chezmoiscripts/run_onchange_before_install-packages.sh`,
  under its existing category (Applications, Fonts, Development Tools, Terminal, Useful Tools,
  Look & Feel, Hyprland, ...). Installing packages ad hoc with `yay`/`pacman` as the only record
  is forbidden.
- Global language toolchains MUST be pinned in the mise global config; tools that are not
  packaged (e.g. Spec Kit's `specify`) MUST be installed by a provisioning script.
- Provisioning scripts MUST be idempotent: `run_onchange_*`, guarded by checks that skip work
  already done, and MUST NOT depend on files the same apply has not written yet.

Rationale: provisioning that lives only in shell history cannot be replayed.

### IV. Follow Each Tool's Established Idiom Here

New configuration MUST match how the tool is already configured in this repository, not its stock
upstream style.

- Hyprland is configured in Lua (`dot_config/hypr/hyprland.lua`) through the `hl.*` API, not
  hyprlang directives.
- Quickshell imports modules through the `qs.*` alias; global options are `Config.options.*`
  backed by `~/.config/shell.json`; sizes, fonts and colours come from the `Appearance` singleton;
  bar widgets live in `modules/bar/components/`, other panels in their own module with any
  cross-module state in a `pragma Singleton` of the owning module.
- Neovim plugins are `lazy.nvim` specs appended to the `lua/plugins/<concern>.lua` file that
  matches their concern; new top-level spec files are not created.
- Zsh is Oh My Zsh with Starship, zoxide, mise and fzf integration.
- Code MUST read like its neighbours: same naming, comment density and formatting.

Rationale: one idiom per tool keeps the config navigable months later.

### V. Verified by Exercising the Tool

There is no build, lint or test suite; a change is verified only by applying it and observing the
tool's real behaviour.

- Verification MUST include `chezmoi diff` (confirming only intended files change),
  `chezmoi apply`, and then exercising the tool: reloading Hyprland, watching Quickshell's log for
  `Configuration Loaded` without QML errors, re-sourcing zsh, reopening Neovim.
- Reading the source and declaring it correct does not count as verification.
- Anything that cannot be exercised in the current session (clicks, a locked vault, waiting for
  midnight, a missing device) MUST be reported as unverified and left for the user, never claimed
  as done.
- A task is `done` only once its work is in the repository and verified as above.

Rationale: config bugs only show up when the tool loads it.

## Environment & Technical Constraints

- OS and session: Arch Linux, Hyprland under `uwsm`, two monitors — `HDMI-A-1` (primary, carries
  the bar) and `DVI-D-1`.
- Quickshell runs as `qs --path <repo>/dot_config/quickshell`, straight from the source
  directory: saving a source file hot-reloads the live shell before any apply. IPC calls MUST pass
  the same `--path`. `chezmoi apply` is still run so the target matches.
- Templates that read Bitwarden prompt when the vault is locked; chezmoi commands SHOULD be scoped
  to the affected target path so unrelated templates are not rendered.
- Package management is `yay`; global runtimes are managed by mise.

## Development Workflow

- Features follow Spec Kit: `/speckit-specify` → `/speckit-clarify` (when gaps remain) →
  `/speckit-plan` → `/speckit-tasks` → `/speckit-implement`.
- Gaps in a request MUST be resolved by asking the user, not filled with assumptions; decisions
  the user made are recorded in the spec.
- Plans MUST name the exact source files touched (in chezmoi naming), any new package and its
  category, and the manual verification steps.
- Commits are made only when the user asks. Messages follow Conventional Commits with the tool as
  scope (e.g. `feat(quickshell): ...`), and unrelated changes are split into separate commits;
  work in progress the user did not ask to commit stays uncommitted.
- The README TODO checklist MUST reflect the real state of the configuration.

## Governance

This constitution takes precedence over other practices in this repository, including generated
Spec Kit artifacts. Plans MUST pass its principles in their "Constitution Check"; any deliberate
violation MUST be justified in the plan's complexity tracking.

- Amendments are made by the repository owner, by editing this file (via `/speckit-constitution`)
  and recording the change in the Sync Impact Report.
- Versioning is semantic: MAJOR for removing or redefining a principle, MINOR for adding a
  principle or materially expanding guidance, PATCH for clarifications and wording.
- Compliance is reviewed whenever a plan is written and before a feature is marked done.

**Version**: 1.0.0 | **Ratified**: 2026-10-15 | **Last Amended**: 2026-10-15
