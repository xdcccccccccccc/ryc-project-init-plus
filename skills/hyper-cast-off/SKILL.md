---
name: hyper-cast-off
description: Use when the user explicitly wants to distill, prune, or compact durable project state under .codex-state without changing source code or normal workflow roles
disable-model-invocation: true
---

# hyper-cast-off

## Overview

Manual-only state distillation for `~/.codex-state/<project-key>/`.

Use it to compress redundant project state so future threads can recover context faster.

It does not replace system `/compact` and it does not compress the live conversation.

## Required References

Read when boundaries are unclear:

- `../shared/state-files.md`
- `../shared/role-matrix.md`
- `../shared/knowledge-writing-rules.md`
- `../shared/plan-writing-rules.md`
- `../shared/progress-writing-rules.md`

## When To Use

Use only when the user explicitly asks to:

- compact or distill project state
- reduce redundant state-file content
- clean up `project_knowledge`, `progress.md`, `feature_list.json`, or old plan files
- improve future thread cold-start quality without touching code

Any role thread may invoke this skill manually.

Do not use when:

- the user only wants system `/compact`
- the main issue is current live context length rather than durable files
- the request is normal implementation, review, or planning
- durable state is missing and the project is not initialized

## Hard Boundary

This skill may update only:

- files under `~/.codex-state/<project-key>/`
- `PROJECT_ROOT/AGENTS.md` or `PROJECT_ROOT/CLAUDE.md` only if state entry paths changed

This skill must not modify:

- source code
- tests
- CI files
- product docs outside durable state

## Workflow

1. identify the target project state directory
2. read `state.json`
3. inspect `project_knowledge`, `progress.md`, `feature_list.json`, and active plan files
4. remove duplication, stale detail, and misplaced content
5. keep current direction, active work, and reusable knowledge clear
6. archive only when a large amount of history would otherwise be lost
7. append one concise distillation note to `progress.md`
8. report what was tightened and what was preserved

## Focus Areas

- `project_knowledge`: keep `overview.md` short, remove duplicate notes, keep topic files only when they still help
- `progress.md`: keep milestones, risks, and next-step signal; compress diary-like detail
- `feature_list.json`: keep active and near-term work clear; archive stale completed detail if needed
- `plan/`: keep current direction and active plans; archive superseded plans instead of silently dropping them

## Archive Rule

If distillation would remove substantial historical detail, create:

- `~/.codex-state/<project-key>/archive/`

and store a timestamped snapshot or moved file there first.

## Completion Rule

Before finishing:

- confirm no source files were touched
- confirm state files are shorter, clearer, or better separated than before
- confirm `overview.md` still points future threads to the right places
- append one concise note to `progress.md` describing the distillation pass
- explicitly say that this improved durable state, not live conversation context
