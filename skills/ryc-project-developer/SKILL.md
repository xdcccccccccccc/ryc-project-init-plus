---
name: ryc-project-developer
description: Use when implementing a confirmed feature or task in an initialized project and the thread should follow the normal development workflow
---

# ryc-project-developer

## Overview

This is the normal implementation role for an initialized project.

It selects one task, reads only the state needed for that task, uses `using-superpowers` as the underlying implementation workflow, and keeps durable state synchronized without turning one thread into a multi-task sprint.

## Required References

Read these when boundaries are unclear:

- `../shared/state-files.md`
- `../shared/role-matrix.md`
- `../shared/knowledge-writing-rules.md`
- `../shared/progress-writing-rules.md`
- `../shared/plan-writing-rules.md`

## When To Use

Use when:

- the project is already initialized
- the user wants to implement, fix, or deliver a specific task or feature
- the task belongs in `feature_list.json` or is clearly aligned with a single existing feature

Do not use when:

- durable state is missing
- the user mainly wants logic review or audit
- the user mainly wants to reshape direction or backlog

## Required Read Order

Start with the smallest useful state set:

1. `~/.codex-state/<project-key>/state.json`
2. `~/.codex-state/<project-key>/project_knowledge/overview.md`
3. the current relevant item in `feature_list.json`
4. the most recent relevant section of `progress.md`
5. the current feature's `*_plan.md` if it exists

Read `plan/plan.md` only when baseline goals, strategy, or risks matter for the current task.

## Single-Task Rule

Unless the user explicitly allows more, default to exactly one task in the current thread.

That means:

- select one feature or task
- finish or advance only that one task
- do not silently pick up the next backlog item
- do not combine implementation and replanning into one flow unless the user explicitly asks

If the backlog itself is wrong, incomplete, or needs reshaping, stop and recommend `ryc-project-planner`.

## Workflow

1. identify the one task to work on
2. verify the task is not actually a review-only or planning-only request
3. load only the code and docs needed for that task
4. use `using-superpowers` and any needed implementation skills
5. verify the result before marking the task done
6. update `feature_list.json`
7. append a concise entry to `progress.md`
8. update `project_knowledge` only when the thread learned durable execution knowledge

## Writable Files

This role may update:

- `feature_list.json`
- `progress.md`
- the current task's `*_plan.md`
- `project_knowledge/overview.md`
- a dedicated `project_knowledge/*.md` topic file when allowed by `knowledge-writing-rules.md`

This role should not rewrite:

- `plan/plan.md` unless the user explicitly asks and the work clearly crosses into planner territory
- unrelated feature plans
- unrelated backlog items

## project_knowledge Update Rule

`project_knowledge` is for reusable execution knowledge.

Only write:

- framework details that affect how future threads should work
- navigation hints
- important conventions
- logic, config, command, or resource landmarks
- stable risks or pitfalls

Do not write:

- roadmap
- phase goals
- broad project background
- temporary reasoning logs

If a new topic file is created, also update `project_knowledge/overview.md` with a short entrypoint summary and add a concise note to `progress.md`.

## Completion Rule

Before closing the thread:

- verify the implementation
- keep the task status accurate
- keep `progress.md` concise and useful
- keep knowledge updates minimal and durable
- if the work uncovered a planning problem instead of a coding problem, say so and recommend `ryc-project-planner`
