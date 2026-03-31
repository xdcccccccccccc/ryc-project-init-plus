---
name: ryc-project-planner
description: Use when an initialized project needs backlog reshaping, scope adjustment, or discussion of development direction before implementation
---

# ryc-project-planner

## Overview

This role is for direction, backlog, and plan work.

Use it when the current plan no longer fits, when backlog quality is poor, or when the user wants to discuss what to do next before implementation.

## Required References

Read when needed:

- `../shared/state-files.md`
- `../shared/role-matrix.md`
- `../shared/plan-writing-rules.md`
- `../shared/progress-writing-rules.md`
- `../shared/knowledge-writing-rules.md`

## When To Use

Use when:

- the user wants to rethink next steps
- `feature_list.json` needs reshaping
- baseline or topic plans need revision
- scope, priority, or direction changed
- the developer role discovered the backlog is wrong or underspecified

Do not use when:

- the thread is just implementing one confirmed task
- the thread is just reviewing code
- durable state is missing

## Read Scope

Start with:

1. `~/.codex-state/<project-key>/state.json`
2. `program.md` if it exists
3. `~/.codex-state/<project-key>/plan/plan.md`
4. `~/.codex-state/<project-key>/feature_list.json`
5. the most recent relevant section of `progress.md`

Read `project_knowledge/overview.md` when execution constraints, framework details, or path-level realities matter for the plan.

## Planning Workflow

1. identify the planning problem
2. ground it in the current repository state and durable state
3. discuss options, tradeoffs, and a recommended direction
4. revise `feature_list.json`, `plan.md`, or `*_plan.md` only after the direction is clear
5. append a concise planning update to `progress.md`

For larger or more exploratory replanning, use `brainstorming` before finalizing major plan changes. When a concrete implementation plan is needed, prefer `writing-plans` and write output to `~/.codex-state/<project-key>/plan/`.

## Writable Files

This role may update:

- `feature_list.json`
- `plan/plan.md`
- `plan/*_plan.md`
- `progress.md`

This role should update `project_knowledge` only when a planning decision also changes durable execution guidance. Do not use `project_knowledge` as a duplicate plan file.

## What Must Stay Out Of project_knowledge

Do not write these into `project_knowledge`:

- roadmap
- phase goals
- scope negotiations
- broad product background
- temporary planning rationale

Only execution-relevant framework, navigation, convention, landmark, and risk information belongs there.
