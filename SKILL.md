---
name: project-init
description: Use this skill only for first-time initialization of a software project. It creates persistent project state under ~/.codex-state/<project-key>/, stores the durable planning document at ~/.codex-state/plan/plan.md, gathers the user's intended development goals before finalizing plan.md and feature_list.json, prefers Chinese for user-facing outputs unless the user explicitly requests another language, and creates or updates only the minimum required initialization files. It should also ensure AGENTS.md is git-ignored when appropriate. Do not use this skill for normal implementation work or routine bugfixes. After initialization, routine development should read the persistent state and use using-superpowers for one-feature-at-a-time execution.
---

# Project Init v4

## Purpose

This skill is for **first-time project initialization only**.

Its responsibilities are:

1. detect the current project root
2. derive a stable project key
3. create persistent project state under `~/.codex-state/<project-key>/`
4. store the durable shared planning document at `~/.codex-state/plan/plan.md`
5. inspect the repository or empty project folder
6. gather the user's intended development goals before finalizing the plan
7. write an initial project plan
8. create an initial task backlog
9. create or update only the **minimum required initialization guidance** in the project root so future threads know how to continue
10. set the default user-facing workflow language to Chinese unless the user explicitly requests another language
11. ensure local-only workflow files such as `AGENTS.md` are git-ignored when appropriate

This skill does **not** perform routine implementation and must not turn initialization into real feature development.

After initialization, normal development work should use `using-superpowers`, not this skill.

---

## Hard safety and scope boundary for the first thread

On the first initialization thread, do **not** modify arbitrary project files.

Allowed modifications are limited to:

- the persistent state files under `~/.codex-state/<project-key>/`
- the shared planning file at `~/.codex-state/plan/plan.md`
- project-root `AGENTS.md` **only as needed for workflow bootstrapping**
- project-root `.gitignore` **only as needed to keep local-only workflow files out of git**
- repo-local skill files under `.agents/skills/` or `.codex/skills/` only if the user explicitly asked for them in the current session

Do **not** modify:

- source code
- config files unrelated to initialization
- build files
- documentation files unrelated to initialization
- tests
- CI files

unless the user explicitly asks for such modifications.

This is a hard rule.

---

## Language rule

This skill must set up the future workflow so that **user-facing communication is in Chinese by default**.

Rules:

1. If the user has already been speaking Chinese in the current thread, preserve Chinese as the default language for future planning, progress summaries, explanations, and normal development dialogue.
2. If the user explicitly requests another language, follow the user's request.
3. Do not switch to English for routine user-facing summaries, planning discussion, task explanations, or status updates unless the user explicitly asks for English.
4. File contents may remain English where appropriate for technical consistency, but the default conversational language and human-facing summaries for this workflow should be Chinese.
5. The generated `AGENTS.md` must explicitly encode this default-Chinese rule for future threads.

---

## When to use

Use this skill when **all or most** of the following are true:

- this is the first serious Codex session for the project
- the repository or project folder does not yet have a durable Codex workflow
- there is no reliable persistent state for future threads
- the user wants a planning-and-initialization session
- the user wants future threads to read durable state before doing implementation
- the project may be empty or only partially scaffolded
- the user wants to define development goals before creating a backlog

Typical user intents:

- "Initialize this repo for long-running Codex work"
- "Set up project state and bootstrap future-thread workflow"
- "Create the initial plan and task backlog for this project"
- "Prepare this folder for one-feature-at-a-time development"

---

## Do not use when

Do **not** use this skill when:

- the project is already initialized and healthy
- you are doing normal implementation
- you are fixing a bug
- you are in a routine development cycle
- the task should be handled by `using-superpowers` or another implementation skill

If persistent state exists and is healthy, use the normal workflow instead of rerunning full initialization.

---

## High-level workflow

When invoked, perform this sequence:

1. detect the project root
2. derive the project key
3. create the persistent state directory and baseline files
4. create the shared plan directory and plan file
5. inspect the repository or empty folder
6. gather or confirm the user's development goals
7. write `plan.md`
8. write `feature_list.json`
9. write or update `progress.md`
10. create or minimally update project-root `AGENTS.md`
11. create or minimally update `.gitignore` when appropriate
12. validate outputs and report results

---

## Step 1: Detect project root

Determine the project root.

Preferred method:

1. use the current working directory if it is the project root
2. otherwise walk upward until finding the nearest `.git` directory
3. if no `.git` directory exists, use the current working directory as the project root and clearly state that the directory is not a git repository

Record this path as `PROJECT_ROOT`.

Record whether this is a git repository as `IS_GIT_REPO`.

---

## Step 2: Derive project key

Derive a stable `project-key`.

Rules:

1. start from the directory name of `PROJECT_ROOT`
2. normalize to lowercase
3. replace spaces with `-`
4. replace underscores with `-`
5. remove characters that are not letters, digits, `-`, or `.`
6. if the result is empty, fall back to `project`
7. if needed for stability, append a short deterministic suffix derived from the absolute path
8. never use a random suffix

Record the result as `PROJECT_KEY`.

---

## Step 3: Create persistent state directory and baseline files

Create:

`~/.codex-state/<project-key>/`

Record this path as `STATE_DIR`.

Create:

`~/.codex-state/plan/`

Record this path as `PLAN_DIR`.

Record the durable plan file path as `PLAN_PATH`, which must be:

`~/.codex-state/plan/plan.md`

Ensure the following files exist inside `STATE_DIR`:

- `state.json`
- `feature_list.json`
- `progress.md`

Ensure the following file exists at `PLAN_PATH`:

- `plan.md`

If they do not exist, create them.

If they already exist, read them first and preserve useful information.

At this stage, it is acceptable to create placeholder or draft content before finalization.

---

## Step 4: Inspect repository or empty folder

Inspect the project folder before planning.

If it is a real repository, inspect at minimum:

- top-level directories
- README files
- package/build files
- test configuration if present
- CI/workflow files if present
- framework or language indicators
- docs directories if present
- existing `AGENTS.md` if present
- existing `.agents/` or `.codex/` directories if present
- existing task/roadmap docs if present
- existing `.gitignore` if present

If the project folder is effectively empty, explicitly record that it is an empty or near-empty project and switch to initialization-friendly planning.

Build a grounded understanding of:

- project purpose if inferable
- tech stack if inferable
- current structure
- likely entry points
- likely build/test/dev commands if inferable
- whether the project is empty, early-stage, or mature
- uncertainties and risks

Do not hallucinate details.

---

## Step 5: Gather and confirm the user's goals before finalizing plan.md and feature_list.json

This is a required step.

Before finalizing `plan.md` and `feature_list.json`, explicitly gather the user's intended goals unless they have already been clearly provided in the current thread.

At minimum, obtain or confirm:

1. the primary development goal
2. the desired deliverable for phase 1
3. out-of-scope items or what should not be touched yet
4. priority order if there are multiple goals
5. any constraints such as stack, architecture, time horizon, or preference for demo vs production quality

### Interaction rule

If the user's goals are not yet explicit enough, **pause and ask** for them before finalizing `plan.md` and `feature_list.json`.

Do not silently finalize a backlog based only on repository scanning when the actual development goal is unclear.

### If the user already gave goals

If the user already provided sufficiently clear goals in the current thread, do not ask redundant questions. Instead, briefly confirm the interpreted goals and proceed.

### Communication rule during this step

Use Chinese for questions, confirmations, summaries, and planning discussion unless the user explicitly asked for another language.

---

## Step 6: Create or update state.json

Create or update `STATE_DIR/state.json`.

This file is the machine-readable durable state record.

It must contain at least:

```json
{
  "project_key": "string",
  "project_root": "absolute path",
  "state_dir": "absolute path",
  "plan_path": "absolute path",
  "initialized": true,
  "initialization_phase_complete": true,
  "workflow_version": 4,
  "last_initialized_at": "ISO-8601 timestamp",
  "is_git_repo": true,
  "default_user_language": "zh-CN",
  "planning_mode": {
    "goal_confirmed": true,
    "backlog_grounded_in_repo_and_user_goals": true
  },
  "normal_workflow": {
    "default_execution_skill": "using-superpowers",
    "one_feature_per_cycle": true,
    "requires_progress_sync": true
  }
}
```

Additional grounded fields may be added, such as:

- `repo_name`
- `detected_languages`
- `detected_frameworks`
- `goal_summary`
- `notes`

`default_user_language` should be set according to the user's actual preference in the thread. If the user is speaking Chinese and has not asked for another language, set it to `zh-CN`.

---

## Step 7: Create or update plan.md

Create or update `PLAN_PATH` as the durable planning document.

This file must reflect both:

- the observed repository/project state
- the user's confirmed development goals

It should include:

1. project summary
2. current observed structure or note that the project is empty
3. inferred stack and tooling, if any
4. confirmed development goals
5. phase-1 deliverable
6. explicit out-of-scope items
7. recommended development strategy
8. recommended execution order
9. risks, assumptions, and unknowns

If the project is empty, the plan should still be useful and should focus on scaffolding and first milestones instead of pretending code already exists.

Do not write vague filler.

---

## Step 8: Create or update feature_list.json

Create `STATE_DIR/feature_list.json` as the durable backlog.

This file must be a JSON array.

It is not just a repo-scan todo list. It is the task backlog for future implementation cycles and must be grounded in:

- the user's confirmed goals
- the current repository/project state

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

### Backlog rules

1. do not finalize the backlog before the user's goals are clear
2. items must align with the confirmed phase-1 goal
3. items must be reasonably sized for future one-feature-at-a-time execution
4. if the project is empty, create sensible bootstrap tasks
5. do not include implementation work that is explicitly out of scope
6. initial items should usually be `todo`
7. do not mark anything `done` unless clearly justified by existing project state

If appropriate, begin with setup, architecture, scaffold, or interface-definition tasks before implementation tasks.

Keep `feature_list.json` and `PLAN_PATH` aligned. If a later thread materially updates or finalizes `feature_list.json`, it should also update `~/.codex-state/plan/plan.md` in the same cycle when the plan changed.

---

## Step 9: Create or update progress.md

Create `STATE_DIR/progress.md` as the durable human-readable handoff log.

It must include:

- initialization timestamp
- project root
- project key
- whether this is a git repo
- whether the project is empty or non-empty
- what files were created or updated
- a short summary of the confirmed goals
- a short summary of the initial plan
- the recommended next feature
- explicit note that future routine work should use `using-superpowers`
- explicit note that future user-facing communication should default to Chinese unless the user requests otherwise

If `progress.md` already exists, append a new section rather than deleting history.

Recommended structure:

```md
# Progress

## Current status
Initialized

## Last action
Project initialization and planning completed.

## Repository state
...

## Confirmed goals
...

## Workflow language
Default to Chinese for user-facing communication unless the user explicitly requests another language.

## What was created or updated
- state.json
- ~/.codex-state/plan/plan.md
- feature_list.json
- progress.md
- AGENTS.md created or updated if needed
- .gitignore created or updated if needed

## Recommended next step
...

## Notes
...
```

---

## Step 10: Create or minimally update AGENTS.md in project root

Create or update `PROJECT_ROOT/AGENTS.md`.

### Important policy

Because modifying project files can be sensitive, keep `AGENTS.md` as small and minimally invasive as possible.

Prefer one of these strategies:

1. if `AGENTS.md` does not exist, create a small bootstrap version
2. if `AGENTS.md` exists, append a clearly delimited managed block instead of rewriting the whole file
3. preserve all meaningful existing instructions
4. avoid broad rewrites

### Managed block requirement

If updating an existing file, prefer a block like:

```md
<!-- PROJECT-INIT WORKFLOW START -->
...managed workflow guidance...
<!-- PROJECT-INIT WORKFLOW END -->
```

If a managed block already exists, update only the contents of that block.

### Required AGENTS.md behavior

The resulting `AGENTS.md` must implement this logic:

#### State A: Not initialized
If the persistent state directory, the shared plan file, or required files under `~/.codex-state/<project-key>/` are missing or invalid, the agent should tell the user to run:

`$project-init`

#### State B: Initialized
If the persistent state exists, future threads should first read:

- `~/.codex-state/<project-key>/state.json`
- `~/.codex-state/plan/plan.md`
- `~/.codex-state/<project-key>/feature_list.json`
- `~/.codex-state/<project-key>/progress.md`

Then for routine implementation work:

1. use `using-superpowers`
2. select exactly one incomplete feature
3. work only on that feature in the current cycle unless explicitly instructed otherwise
4. verify before marking done
5. update `feature_list.json`
6. if `using-superpowers`, `writing-plans`, `write-plan`, or any other planning workflow is invoked, treat `~/.codex-state/plan/plan.md` as the required plan destination
7. do not create or update plan files inside the repository such as `docs/superpowers/plans/` unless the user explicitly asks for an in-repo plan file
8. update `~/.codex-state/plan/plan.md` whenever the planned execution order, scope, or backlog framing changed
9. append to `progress.md`
10. keep the repo runnable and reviewable

#### General rules
The AGENTS guidance should also say:

- default to Chinese for user-facing communication unless the user explicitly requests another language
- do not use `project-init` for routine implementation
- during the first initialization thread, do not modify arbitrary project files
- prefer durable state over thread memory
- treat the shared plan path as a user/project preference that overrides superpowers default plan locations
- if a planning skill would normally write to an in-repo path, redirect it to `~/.codex-state/plan/plan.md` instead
- if repository state and persistent state conflict, call it out explicitly
- preserve existing project instructions over generated guidance when they conflict

### Recommended AGENTS.md style

Prefer a **small bootstrap AGENTS.md** that points future threads to the state files, rather than a giant policy document.

---

## Step 11: Create or update .gitignore when appropriate

If `IS_GIT_REPO` is true, inspect `.gitignore`.

Goal: keep local-only workflow guidance out of version control when appropriate.

### Required behavior

1. Ensure that `AGENTS.md` is ignored by git **unless** the user explicitly asked to keep it tracked.
2. If `.gitignore` does not exist, create it with a minimal addition for `AGENTS.md`.
3. If `.gitignore` exists, add `AGENTS.md` only if it is not already effectively ignored.
4. Keep the update minimal and avoid reformatting unrelated content.
5. Do not add broad ignore rules unless explicitly requested.

### Notes

- This step only updates `.gitignore`. It does not run git commands.
- If `AGENTS.md` was already tracked by git, mention clearly in the final report that `.gitignore` alone will not untrack it and the user may need to run `git rm --cached AGENTS.md` manually.
- Do not automatically modify other ignore rules unless the user asked.

---

## Step 12: Final validation

Before finishing, check that:

- `STATE_DIR` exists
- `PLAN_DIR` exists
- all required files exist
- `state.json` is internally consistent
- `feature_list.json` is valid JSON
- `~/.codex-state/plan/plan.md` reflects the confirmed goals
- `AGENTS.md` exists in the project root
- `AGENTS.md` references the correct `project-key`
- `AGENTS.md` routes normal implementation to `using-superpowers`
- `AGENTS.md` routes missing-state situations to `$project-init`
- `AGENTS.md` encodes the default-Chinese communication rule
- `AGENTS.md` explicitly overrides in-repo superpowers plan destinations in favor of `~/.codex-state/plan/plan.md`
- `.gitignore` exists or was updated appropriately when the project is a git repo
- no non-initialization project files were modified unless explicitly requested

If something could not be created, say so clearly.

---

## Empty-project compatibility

This skill must work for an empty or near-empty project folder.

If the project is empty:

- do not pretend there is existing architecture
- explicitly record that the repository is empty
- ask the user for the intended project goal
- write a plan suitable for a greenfield project
- create a feature backlog that starts from scaffold/setup/design milestones
- still create the same persistent state files
- still create `~/.codex-state/plan/plan.md`
- still create or minimally update `AGENTS.md`
- still create or minimally update `.gitignore` when appropriate

---

## Expected file formats

### state.json
Machine-readable durable state. Must be valid JSON.

### feature_list.json
Machine-readable durable backlog. Must be valid JSON array and must reflect confirmed goals.

### progress.md
Human-readable durable handoff log.

### plan.md
Human-readable durable strategy and planning note stored at `~/.codex-state/plan/plan.md`.

### AGENTS.md
Project-root bootstrap workflow guidance. Keep it minimal and minimally invasive.

### .gitignore
Minimal ignore rules update. Keep it small and do not disturb unrelated entries.

---

## Required final report to the user

At the end of initialization, report in Chinese by default unless the user explicitly requested another language.

The report must include:

1. detected project root
2. derived project key
3. created state directory
4. created shared plan path
5. whether the project appears empty or non-empty
6. which files were created or updated
7. whether AGENTS.md was created or minimally updated
8. whether `.gitignore` was created or updated
9. concise summary of confirmed goals
10. concise summary of the initial plan
11. the initial recommended next feature
12. any conflicts, uncertainties, preserved existing instructions, or git-tracking caveats

Keep the report specific and concise.

---

## Normal-work handoff rule

After initialization is complete, future routine implementation should not use this skill.

Future routine work should:

1. read `~/.codex-state/<project-key>/state.json`, `~/.codex-state/plan/plan.md`, `~/.codex-state/<project-key>/feature_list.json`, and `~/.codex-state/<project-key>/progress.md`
2. use `using-superpowers`
3. work one feature at a time
4. update durable state after each cycle, including `~/.codex-state/plan/plan.md` whenever the plan changes
5. communicate with the user in Chinese by default unless the user explicitly requests another language

This boundary is strict.

---

## Quality standard

Be concrete.
Be minimally destructive.
Ask for goals before finalizing backlog if they are not already clear.
Support empty projects honestly.
Preserve existing project guidance where possible.
Prefer a small bootstrap AGENTS.md over a large intrusive rewrite.
Do not hallucinate repository details.
Do not modify source files during initialization.
Prefer Chinese for user-facing workflow by default unless the user explicitly requests another language.
