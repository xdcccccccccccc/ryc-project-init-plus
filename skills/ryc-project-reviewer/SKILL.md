---
name: ryc-project-reviewer
description: Use when the user wants logic analysis, module review, risk inspection, or detailed code scrutiny for a specific area of an initialized project
---

# ryc-project-reviewer

## Overview

This role is for review and analysis, not normal delivery work.

It inspects a specified module, path, feature, or logic topic, surfaces risks and findings, and keeps state changes minimal by default.

## Required References

Read when needed:

- `../shared/state-files.md`
- `../shared/role-matrix.md`
- `../shared/knowledge-writing-rules.md`

## When To Use

Use when the user wants:

- logic analysis
- code review
- risk inspection
- detailed scrutiny of a module or path
- architectural sanity checking for a specific area

Do not use when:

- the main goal is implementation
- the main goal is backlog reshaping or plan revision
- durable state is missing and the project is not initialized

## Expected Inputs

The thread should identify at least one of:

- a module
- a path
- a feature id
- a logic topic
- a concrete review question

If the scope is too broad, narrow it before deep review.

## Minimum Read Set

Start with:

1. `~/.codex-state/<project-key>/state.json`
2. `~/.codex-state/<project-key>/project_knowledge/overview.md`
3. the files directly related to the requested review scope

Read only when relevant:

- a matching `*_plan.md`
- the most recent relevant section of `progress.md`
- the matching feature entry in `feature_list.json`

## Review Workflow

1. identify the concrete review scope
2. gather only the relevant files and context
3. inspect behavior, invariants, boundaries, and likely failure modes
4. present findings first, ordered by severity
5. if no findings are found, say that explicitly and mention residual risks or testing gaps

## Output Style

Prefer:

- findings first
- file and line references when available
- short explanation of impact
- open questions or assumptions after findings

Do not bury findings under long summaries.

## Write Restrictions

Default behavior is read-only.

This role may:

- append a concise note to `progress.md` when the review result is important for future threads
- add a small stable risk or convention note to `project_knowledge` only if it clearly belongs in reusable execution knowledge

This role should not:

- implement the fix by default
- rewrite `feature_list.json`
- rewrite `plan/plan.md`

If the review shows the project needs a new plan rather than a code change, recommend `ryc-project-planner`.
