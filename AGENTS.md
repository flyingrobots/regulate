# AGENTS.md

Instructions for agents and people who work in this repository.

## What this is

Regulate is a proposed compiler for engineering rules. Nothing is built. The
current work is a pilot spike that decides whether to build it.

## Read first

- `README.md`: one rule followed end to end, and the spike's four pass
  criteria.
- `docs/proposal/design-spec.md`: the terms (brick, profile, subject,
  application, backend, waiver) and what each command does.
- `docs/proposal/technical-design-spec.md`, section 3: what Wesley does and
  does not do with a policy file. Regulate has to cover the gaps.

## The plan is the issues

Work is planned as GitHub issues with `issue-dag/2` frontmatter. Issue #1 is
the spike's container. Take a task from the open frontier: an open task whose
`.blocked_by` issues are all closed.

- Open a new task with the Task issue template, which carries the frontmatter
  and the six body sections.
- One task is one outcome and one pull request. If a task turns out to hold
  two outcomes, stop and propose a split.
- A task's body is its specification. Meet every item under Acceptance, and
  stay inside Scope.
- The container lists work that is deferred until after the spike. Leave it
  deferred.
- Three tasks record hours spent (#10, #24, #25). The record is evidence for a
  pass criterion, so record the true figure.

## Pins

| What | Pin |
| --- | --- |
| Echo, the spike's target | `flyingrobots/echo` at commit `089c849f766d5331835e7d10148a378cdb1237d5` |
| Wesley | `wesley-core = "=0.3.0-alpha.3"`, with default features off |

Echo is read-only. Work on a copy of its files, and leave the checkout as you
found it.

A test that needs Echo takes the path of a checkout from the environment
variable `REGULATE_ECHO_CHECKOUT`, and is skipped with a message when the
variable is unset.

## Code

- Rust, in a Cargo workspace. `regulate-core` takes its inputs as arguments
  and performs no file, process, network or clock access.
- Output is deterministic: sorted collections, no timestamps, no absolute
  paths.
- A backend returns the text of a file. The command-line crate writes it.
- Test against the real tool. A test of the Clippy backend runs Clippy.
- Every generated file starts with a line that says it is generated.

## Git

- Work on a branch and open a pull request. `main` accepts changes through
  pull requests only.
- Sign every commit. `main` rejects unsigned commits.
- Let hooks and CI run. Fix the cause of a failure.
- Add commits to a pushed branch; history that others may have fetched stays
  as it is.
- Write repository-relative paths in tracked files, issues and pull requests.
