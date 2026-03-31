---
name: ryc-project-workflow-router
description: Use when entering a project thread and deciding whether the work is initialization, feature delivery, code review, or replanning
---

# ryc-project-workflow-router

## Overview

Use this as the default entry skill when the thread's role is unclear.

This skill does not initialize, implement, review, or replan by itself. It chooses one role skill, limits the first read set, and prevents mixed-role threads from loading too much context too early.

## When To Use

Use when:

- the user says "continue this project", "help with this project", or "what next"
- the project state may exist, but the role is still unclear
- the user has not clearly asked for init, developer, reviewer, or planner behavior

Do not use when:

- the user explicitly invoked `ryc-project-init`
- the user explicitly invoked `ryc-project-developer`
- the user explicitly invoked `ryc-project-reviewer`
- the user explicitly invoked `ryc-project-planner`

## Routing Rules

1. If durable state is missing, invalid, or the project is not initialized, route to `ryc-project-init`.
2. If the user wants to implement, fix, build, or deliver a confirmed task, route to `ryc-project-developer`.
3. If the user wants logic analysis, module review, or detailed code scrutiny, route to `ryc-project-reviewer`.
4. If the user wants to reshape backlog, discuss direction, adjust scope, or rewrite plan artifacts, route to `ryc-project-planner`.
5. One thread should normally follow one primary role. If the goal changes, say so and switch roles deliberately.

## Minimum Read Set

If the project already appears initialized, start with:

- `~/.codex-state/<project-key>/state.json`
- `~/.codex-state/<project-key>/project_knowledge/overview.md`
- the most recent relevant part of `~/.codex-state/<project-key>/progress.md`

Then read additional state only after the role is clear.

If boundaries or state-file responsibilities are unclear, read:

- `../shared/state-files.md`
- `../shared/role-matrix.md`

## Handoff Rules

- Prefer the smallest role that matches the user's request.
- Do not merge planning, development, and review into one vague flow when a cleaner role switch is possible.
- Developer role defaults to one task unless the user explicitly allows more.
- Planner changes backlog and plan artifacts, not implementation.
- Reviewer defaults to read-only analysis.
