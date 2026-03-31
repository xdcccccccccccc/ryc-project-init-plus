# State Files

This document defines what each durable state file is for.

## Core Rule

- `program.md` and `plan.md` are for intent and planning
- `project_knowledge` is for reusable execution knowledge

Do not duplicate the same content across them.

## `state.json`

Purpose:

- machine-readable durable index
- project key and paths
- workflow roles and entry skills
- small grounded metadata

Do not use it for:

- long prose
- project background
- detailed knowledge summaries

## `program.md`

Optional. Read it if it exists.

Purpose:

- project intent
- goals
- scope
- product direction
- phase framing

Do not use it for:

- code navigation
- path-level implementation hints

## `plan/plan.md`

Purpose:

- baseline project plan created or updated by initialization or major replanning
- strategy, order, assumptions, risks

Do not use it for:

- one-off coding notes
- long-lived path-by-path execution guidance

## `plan/*_plan.md`

Purpose:

- feature-specific or topic-specific planning artifacts

Use when:

- a feature or topic needs a dedicated plan
- the baseline plan is not the right place for detail

## `feature_list.json`

Purpose:

- actionable backlog
- task status
- execution targets and completion definitions

Do not use it for:

- architectural essays
- broad intent docs

## `progress.md`

Purpose:

- human-readable handoff log
- concise record of important changes and why they mattered

Do not use it for:

- raw thinking transcripts
- repeated long summaries already stored elsewhere

## `project_knowledge/overview.md`

Purpose:

- entrypoint for reusable execution knowledge
- fastest place for later threads to learn how to read and modify the project safely

Allowed content:

- framework
- navigation
- conventions
- landmarks
- risks

Do not use it for:

- roadmap
- phase goals
- large planning prose
- broad product background

## `project_knowledge/*.md`

Purpose:

- dedicated topic files for reusable execution knowledge that no longer fits comfortably in `overview.md`

Rules:

- only create when the topic is clearly reusable
- update `overview.md` with a short pointer after adding one
- keep the file focused on execution knowledge, not planning prose
