---
name: ryc-project-init
description: Use when the user explicitly wants to initialize a project for the first serious Codex workflow, or explicitly agrees to initialize after durable state is found missing or incomplete
---

# ryc-project-init

## Overview

This skill is for first-time project initialization only.

Its job is to create durable project state under `~/.codex-state/<project-key>/`, write the baseline planning and knowledge files, and create small workspace bootstrap docs such as `AGENTS.md` and `CLAUDE.md` so later threads can select the right role without rereading the whole repository.

This skill should feel similar to the old `project-init` workflow:

- initialize once
- create durable state
- write `AGENTS.md` and `CLAUDE.md`
- keep project-root edits minimal
- do not turn initialization into feature development

## Required References

Before writing state files, use these shared references:

- `../shared/state-files.md`
- `../shared/knowledge-writing-rules.md`
- `../shared/plan-writing-rules.md`
- `../shared/progress-writing-rules.md`
- `../shared/role-matrix.md`

## Hard Boundary

On the initialization thread, do not modify arbitrary project files.

Allowed modifications:

- files under `~/.codex-state/<project-key>/`
- `PROJECT_ROOT/AGENTS.md`
- `PROJECT_ROOT/CLAUDE.md`
- `PROJECT_ROOT/.gitignore`
- repo-local skill files only if the user explicitly asked for them

Do not modify:

- source code
- tests
- CI files
- unrelated config
- unrelated docs

unless the user explicitly asks.

## Language Rule

Set the workflow so user-facing communication defaults to Chinese unless the user explicitly requests another language.

The generated bootstrap docs must encode this.

## When To Use

Use when most of these are true:

- the project is not initialized
- persistent state is missing or unreliable
- the user wants a first planning and bootstrap session
- the project may be empty or partially scaffolded

Do not use when:

- the project is already initialized and healthy
- the request is normal implementation
- the request is code review
- the request is backlog reshaping or replanning only

## High-Level Workflow

1. detect project root
2. derive project key
3. create state directories and baseline files
4. inspect the repository or empty folder
5. gather and confirm the user's goals
6. choose `knowledge_mode`
7. write `state.json`
8. write `plan/plan.md`
9. write `feature_list.json`
10. write `project_knowledge/overview.md`
11. write or update `progress.md`
12. create or minimally update `AGENTS.md` and `CLAUDE.md`
13. create or minimally update `.gitignore` when needed
14. validate outputs and report results

## Step 1: Detect Project Root

Preferred order:

1. use the current working directory if it is the project root
2. otherwise walk upward to the nearest `.git`
3. if there is no `.git`, use the current working directory and say clearly that the directory is not a git repository

Record:

- `PROJECT_ROOT`
- `IS_GIT_REPO`

## Step 2: Derive Project Key

Derive a stable `PROJECT_KEY` from `PROJECT_ROOT`:

- lowercase
- spaces and underscores become `-`
- remove unsupported characters
- default to the normalized project directory name
- only add a suffix if that base key would collide with another project
- never use a random suffix
- when a suffix is needed, use a short deterministic suffix from the absolute path

## Step 3: Create Persistent State Directory

Create:

- `STATE_DIR = ~/.codex-state/<project-key>/`
- `PLAN_DIR = ~/.codex-state/<project-key>/plan/`
- `KNOWLEDGE_DIR = ~/.codex-state/<project-key>/project_knowledge/`

Ensure these files exist:

- `state.json`
- `feature_list.json`
- `progress.md`
- `plan/plan.md`
- `project_knowledge/overview.md`

Read existing files first if they already exist and preserve useful information.

## Step 4: Inspect Repository Or Empty Folder

Inspect at minimum:

- top-level directories
- README files
- package/build files
- test configuration if present
- CI/workflow files if present
- framework or language indicators
- existing `AGENTS.md`
- existing `CLAUDE.md`
- existing `.gitignore`

Build a grounded understanding of:

- project purpose if inferable
- stack and tooling if inferable
- current structure
- likely entry points
- likely build/test/dev commands if inferable
- whether the project is empty, early-stage, or mature
- uncertainties and risks

Do not hallucinate details.

## Step 5: Gather And Confirm Goals

Before finalizing `plan.md` and `feature_list.json`, obtain or confirm:

1. primary development goal
2. desired phase-1 deliverable
3. out-of-scope items
4. priority order if there are multiple goals
5. constraints such as stack, architecture, time horizon, or demo vs production preference

If the goals are still unclear, pause and ask before finalizing backlog or plan.

## Step 5A: Choose Knowledge Mode

Supported modes:

- `lite`: shallow, low-maintenance project understanding
- `standard`: broader reusable project understanding

Rules:

1. if the user explicitly chooses, use that
2. otherwise default to `lite`
3. record the choice in `state.json`
4. keep the first pass concise

## Step 6: Write state.json

`state.json` is the durable machine-readable index.

It must include at least:

```json
{
  "project_key": "string",
  "project_root": "absolute path",
  "state_dir": "absolute path",
  "plan_dir": "absolute path",
  "plan_path": "absolute path",
  "initialized": true,
  "initialization_phase_complete": true,
  "workflow_version": "ryc-project-init-plus/1",
  "last_initialized_at": "ISO-8601 timestamp",
  "is_git_repo": true,
  "default_user_language": "zh-CN",
  "planning_mode": {
    "goal_confirmed": true,
    "backlog_grounded_in_repo_and_user_goals": true
  },
  "normal_workflow": {
    "default_entry_skill": "ryc-project-workflow-router",
    "developer_skill": "ryc-project-developer",
    "reviewer_skill": "ryc-project-reviewer",
    "planner_skill": "ryc-project-planner",
    "underlying_execution_skill": "using-superpowers",
    "one_feature_per_cycle": true,
    "requires_progress_sync": true
  },
  "developer_policy": {
    "default_max_tasks_per_thread": 1
  },
  "plan_policy": {
    "plan_dir": "absolute path",
    "primary_plan_filename": "plan.md",
    "write_plan_output_pattern": "*_plan.md",
    "allow_in_repo_plan_files": false
  },
  "knowledge_mode": "lite | standard",
  "knowledge_files": {
    "knowledge_dir": "absolute path",
    "overview_path": "absolute path"
  }
}
```

Additional grounded fields may be added when useful, such as:

- `repo_name`
- `detected_languages`
- `detected_frameworks`
- `goal_summary`
- `top_level_structure_summary`
- `key_paths`

## Step 7: Write plan/plan.md

`plan.md` is the baseline initialization plan.

It should include:

1. project summary
2. observed structure or a note that the project is empty
3. inferred stack and tooling
4. confirmed goals
5. phase-1 deliverable
6. out-of-scope items
7. recommended strategy
8. recommended execution order
9. risks, assumptions, and unknowns

For later work:

- keep `plan.md` as the baseline plan
- write feature or topic plans to `plan/*_plan.md`
- do not rewrite `plan.md` unless the user explicitly asks or the planner role is deliberately revising the baseline

## Step 8: Write feature_list.json

`feature_list.json` is the durable backlog. It must align with the confirmed goals and the observed repository state.

Each item should contain at least:

```json
{
  "id": "F-001",
  "title": "short title",
  "description": "clear implementation target",
  "priority": "high | medium | low",
  "status": "todo | blocked | in_progress | done",
  "definition_of_done": [
    "specific completion condition"
  ],
  "notes": ""
}
```

Rules:

- do not finalize backlog before goals are clear
- keep items small enough for one-task developer threads
- do not mark work `done` unless clearly justified
- if the project is empty, start with sensible setup and scaffold tasks

## Step 8A: Write project_knowledge/overview.md

Follow `../shared/knowledge-writing-rules.md`.

For initialization, create a concise entrypoint summary that captures reusable execution knowledge rather than planning prose.

At minimum cover:

- framework
- navigation
- conventions
- landmarks
- risks

For `standard` mode, add grounded module boundaries, key flows, config landmarks, and reading hints when they are clear.

## Step 9: Write progress.md

Follow `../shared/progress-writing-rules.md`.

The initialization entry must include:

- timestamp
- project root
- project key
- whether this is a git repo
- whether the project is empty or non-empty
- which files were created or updated
- confirmed goals summary
- initial plan summary
- whether `project_knowledge/overview.md` was created or updated
- recommended next feature

Append if `progress.md` already exists. Do not delete history.

## Step 10: Create Or Update AGENTS.md And CLAUDE.md

Create or minimally update `PROJECT_ROOT/AGENTS.md` and `PROJECT_ROOT/CLAUDE.md`.

Preferred strategy:

1. create a small file if missing
2. if it exists, append or update a clearly delimited managed block
3. preserve meaningful existing instructions
4. avoid broad rewrites

Managed block:

```md
<!-- RYC-PROJECT-INIT-PLUS START -->
...managed workflow guidance...
<!-- RYC-PROJECT-INIT-PLUS END -->
```

This block must:

- tell future threads to use `$ryc-project-init` when durable state is missing or invalid
- tell future threads to read `state.json`, `project_knowledge/overview.md`, and only the relevant parts of `plan.md`, `feature_list.json`, and `progress.md`
- tell future threads to use `$ryc-project-workflow-router` when the role is unclear
- tell implementation threads to use `$ryc-project-developer`
- tell review or analysis threads to use `$ryc-project-reviewer`
- tell backlog or direction-change threads to use `$ryc-project-planner`
- state that developer role defaults to one task unless the user explicitly allows more
- state that `using-superpowers` is the underlying execution workflow for implementation once the developer role is selected
- route plan artifacts to `~/.codex-state/<project-key>/plan/*_plan.md`
- keep Chinese as the default user-facing language unless the user requests otherwise

Do not encode only a binary initialized or not-initialized state machine. Encode role-aware guidance with minimal reads and clear role boundaries.

Use the same managed guidance in both files unless the user explicitly wants different platform-specific wording.

## Step 11: Update .gitignore When Appropriate

If this is a git repository:

1. ensure `AGENTS.md` and `CLAUDE.md` are ignored unless the user explicitly wants them tracked
2. create `.gitignore` if needed
3. keep the change minimal

If `AGENTS.md` or `CLAUDE.md` is already tracked, mention that `.gitignore` alone does not untrack it.

## Step 12: Final Validation

Before finishing, check that:

- `STATE_DIR`, `PLAN_DIR`, and `KNOWLEDGE_DIR` exist
- required files exist
- `state.json` is internally consistent
- `feature_list.json` is valid JSON
- `plan/plan.md` reflects the confirmed goals
- `project_knowledge/overview.md` exists and matches the chosen `knowledge_mode`
- `AGENTS.md` and `CLAUDE.md` point future threads to the correct skills and state files
- `.gitignore` was updated correctly when needed
- no non-initialization project files were modified unless explicitly requested

## Empty-Project Compatibility

If the project is empty:

- say so explicitly
- do not pretend there is existing architecture
- ask for the intended project goal
- write a greenfield-friendly baseline plan
- create a sensible bootstrap backlog
- still create the same durable state files

## Final Report

Report in Chinese by default unless the user requested another language.

Include:

1. detected project root
2. derived project key
3. created state directory
4. created plan directory and primary plan path
5. whether the project appears empty or non-empty
6. chosen `knowledge_mode`
7. which files were created or updated
8. whether `AGENTS.md` and `CLAUDE.md` were created or minimally updated
9. whether `.gitignore` was created or updated
10. concise summary of confirmed goals
11. concise summary of the initial plan
12. initial recommended next feature
13. any conflicts, uncertainties, preserved instructions, or git-tracking caveats
