# Plan Writing Rules

This document defines how plan files should be created and updated.

## Baseline Plan

`plan/plan.md` is the baseline plan.

Use it for:

- initialization baseline
- major replanning of overall direction
- strategy, ordering, assumptions, and risks

Do not rewrite it casually during routine implementation.

## Topic Plans

Use `plan/*_plan.md` for:

- feature-specific plans
- topic-specific plans
- implementation details that should not bloat the baseline plan

## Naming Rules

Preferred names:

- `f-003-auth-flow_plan.md`
- `auth-flow_plan.md`
- `phase1-api_plan.md`

Avoid:

- `new_plan.md`
- `temp_plan.md`
- `plan2.md`

## Location Rules

- write plan artifacts under `~/.codex-state/<project-key>/plan/`
- do not write default plan artifacts into repository paths such as `docs/superpowers/plans/` unless the user explicitly asks

## Update Rules

- reuse an existing matching `*_plan.md` when continuing the same feature or topic
- if `program.md` exists, treat it as intent context, not as the same thing as `plan.md`
- if the baseline plan no longer fits, let planner role revise it deliberately
