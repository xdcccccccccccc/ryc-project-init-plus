---
name: project-init
description: Use this skill only for first-time initialization of a software project. It creates persistent project state under ~/.codex-state/<project-key>/, stores the durable primary planning document at ~/.codex-state/<project-key>/plan/plan.md, requires later write-plan or writing-plans outputs to be written under ~/.codex-state/<project-key>/plan/ as feature- or topic-specific *_plan.md files instead of inside the repository, gathers the user's intended development goals before finalizing plan.md and feature_list.json, prefers Chinese for user-facing outputs unless the user explicitly requests another language, and creates or updates only the minimum required initialization files. It should also ensure AGENTS.md is git-ignored when appropriate. Do not use this skill for normal implementation work or routine bugfixes. After initialization, routine development should read the persistent state and use using-superpowers for one-feature-at-a-time execution.
---

# Project Init v5.3

## Purpose

This skill is for **first-time project initialization only**.

Its responsibilities are:

1. detect the current project root
2. derive a stable project key
3. create persistent project state under `~/.codex-state/<project-key>/`
4. store the durable baseline planning document at `~/.codex-state/<project-key>/plan/plan.md`
5. reserve `~/.codex-state/<project-key>/plan/*.md` for future feature- or topic-specific planning artifacts
6. inspect the repository or empty project folder
7. gather the user's intended development goals before finalizing the plan
8. write an initial project plan
9. write an initial task backlog
10. create or update only the **minimum required initialization guidance** in the project root
11. set the default user-facing workflow language to Chinese unless the user explicitly requests another language
12. ensure local-only workflow files such as `AGENTS.md` are git-ignored when appropriate
13. create a lightweight durable project-knowledge entrypoint so later threads can reuse core project understanding

This skill does **not** perform routine implementation and must not turn initialization into real feature development.

After initialization, normal development work should use `using-superpowers`, not this skill.

---

## Hard Safety And Scope Boundary

On the first initialization thread, do **not** modify arbitrary project files.

Allowed modifications are limited to:

- the persistent state files under `~/.codex-state/<project-key>/`
- the project plan directory under `~/.codex-state/<project-key>/plan/`
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

## Language Rule

This skill must set up the future workflow so that **user-facing communication is in Chinese by default**.

Rules:

1. If the user has already been speaking Chinese in the current thread, preserve Chinese as the default language for future planning, progress summaries, explanations, and normal development dialogue.
2. If the user explicitly requests another language, follow the user's request.
3. Do not switch to English for routine user-facing summaries, planning discussion, task explanations, or status updates unless the user explicitly asks for English.
4. File contents may remain English where appropriate for technical consistency, but the default conversational language and human-facing summaries for this workflow should be Chinese.
5. The generated `AGENTS.md` must explicitly encode this default-Chinese rule for future threads.

---

## When To Use

Use this skill when **all or most** of the following are true:

- this is the first serious Codex session for the project
- the repository or project folder does not yet have a durable Codex workflow
- there is no reliable persistent state for future threads
- the user wants a planning-and-initialization session
- the user wants future threads to read durable state before doing implementation
- the project may be empty or only partially scaffolded
- the user wants to define development goals before creating a backlog

Do **not** use this skill when:

- the project is already initialized and healthy
- you are doing normal implementation
- you are fixing a bug
- you are in a routine development cycle
- the task should be handled by `using-superpowers` or another implementation skill

If persistent state exists and is healthy, use the normal workflow instead of rerunning full initialization.

---

## High-Level Workflow

When invoked, perform this sequence:

1. detect the project root
2. derive the project key
3. create the persistent state directory and baseline files
4. inspect the repository or empty folder
5. gather or confirm the user's development goals
6. choose `knowledge_mode`
7. write `state.json`
8. write `plan.md`
9. write `feature_list.json`
10. write `project_knowledge/overview.md`
11. write or update `progress.md`
12. create or minimally update project-root `AGENTS.md`
13. create or minimally update `.gitignore` when appropriate
14. validate outputs and report results

---

## Step 1: Detect Project Root

Determine the project root.

Preferred method:

1. use the current working directory if it is the project root
2. otherwise walk upward until finding the nearest `.git` directory
3. if no `.git` directory exists, use the current working directory as the project root and clearly state that the directory is not a git repository

Record this path as `PROJECT_ROOT`.

Record whether this is a git repository as `IS_GIT_REPO`.

---

## Step 2: Derive Project Key

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

## Step 3: Create Persistent State Directory And Baseline Files

Create:

- `STATE_DIR = ~/.codex-state/<project-key>/`
- `PLAN_DIR = ~/.codex-state/<project-key>/plan/`
- `PLAN_PATH = ~/.codex-state/<project-key>/plan/plan.md`

Important:

- `PLAN_DIR` is project-scoped and belongs only to the current `PROJECT_KEY`
- `PLAN_PATH` is the durable baseline plan file created during initialization
- future planning artifacts created by `using-superpowers`, `write-plan`, or `writing-plans` must live inside `PLAN_DIR`
- future planning artifacts must use descriptive filenames ending in `_plan.md`
- when the current feature can be identified from `feature_list.json`, prefer a filename derived from that feature's id or title slug, such as `f-003-auth-flow_plan.md` or `auth-flow_plan.md`
- when revisiting the same feature or topic, reuse the existing matching `*_plan.md`
- unless the user explicitly asks to revise `plan.md`, do **not** modify an existing `PLAN_PATH` during later routine planning
- do not write plan artifacts into repository paths such as `docs/superpowers/plans/` unless the user explicitly asks for in-repo plan files

Ensure the following files exist inside `STATE_DIR`:

- `state.json`
- `feature_list.json`
- `progress.md`

Ensure the following directory and file exist inside `STATE_DIR`:

- `project_knowledge/`
- `project_knowledge/overview.md`

Ensure the following file exists at `PLAN_PATH`:

- `plan.md`

If they do not exist, create them.

If they already exist, read them first and preserve useful information.

---

## Step 4: Inspect Repository Or Empty Folder

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

## Step 5: Gather And Confirm The User's Goals Before Finalizing plan.md And feature_list.json

This is a required step.

Before finalizing `plan.md` and `feature_list.json`, explicitly gather the user's intended goals unless they have already been clearly provided in the current thread.

At minimum, obtain or confirm:

1. the primary development goal
2. the desired deliverable for phase 1
3. out-of-scope items or what should not be touched yet
4. priority order if there are multiple goals
5. any constraints such as stack, architecture, time horizon, or preference for demo vs production quality

Interaction rules:

- If the user's goals are not yet explicit enough, **pause and ask** for them before finalizing `plan.md` and `feature_list.json`.
- Do **not** silently finalize a backlog based only on repository scanning when the actual development goal is unclear.
- If the user already provided sufficiently clear goals in the current thread, do **not** ask redundant questions. Briefly confirm the interpreted goals and proceed.
- Use Chinese for questions, confirmations, summaries, and planning discussion unless the user explicitly asked for another language.

---

## Step 5A: Choose Knowledge Mode

Before finalizing durable state, choose the project knowledge sync depth.

Supported modes:

- `lite`: store a shallow project understanding summary with low maintenance cost
- `standard`: store a broader reusable project understanding summary so later threads can avoid rereading large parts of the repository

Rules:

1. if the user explicitly chooses a mode, use it
2. otherwise default to `lite`
3. record the chosen mode in `state.json`
4. keep the initialization pass concise; deeper topic files can be added later only when useful
5. avoid setting expectations that every future thread must read every durable file in full before starting work

---

## Step 6: Create Or Update state.json

Create or update `STATE_DIR/state.json`.

This file is the machine-readable durable state record.

It must contain at least:

```json
{
  "project_key": "string",
  "project_root": "absolute path",
  "state_dir": "absolute path",
  "plan_dir": "absolute path",
  "plan_path": "absolute path",
  "initialized": true,
  "initialization_phase_complete": true,
  "workflow_version": 5,
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

Additional grounded fields may be added, such as:

- `repo_name`
- `detected_languages`
- `detected_frameworks`
- `goal_summary`
- `notes`
- `top_level_structure_summary`
- `key_paths`

`default_user_language` should be set according to the user's actual preference in the thread. If the user is speaking Chinese and has not asked for another language, set it to `zh-CN`.

---

## Step 7: Create Or Update plan.md

Create or update `PLAN_PATH` as the durable planning document.

This file must reflect both:

- the observed repository or project state
- the user's confirmed development goals

The document must also clearly identify:

- current `PROJECT_KEY`
- current `PROJECT_ROOT`
- last update timestamp

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

For later routine planning:

- treat `plan.md` as the baseline initialization plan
- create feature- or topic-specific planning in separate `PLAN_DIR/<feature-or-topic>_plan.md` files
- do **not** modify an existing `plan.md` unless the user explicitly asks to revise it

---

## Step 8: Create Or Update feature_list.json

Create `STATE_DIR/feature_list.json` as the durable backlog.

This file must be a JSON array.

It is not just a repo-scan todo list. It is the task backlog for future implementation cycles and must be grounded in:

- the user's confirmed goals
- the current repository or project state

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

Backlog rules:

1. do **not** finalize the backlog before the user's goals are clear
2. items must align with the confirmed phase-1 goal
3. items must be reasonably sized for future one-feature-at-a-time execution
4. if the project is empty, create sensible bootstrap tasks
5. do **not** include implementation work that is explicitly out of scope
6. initial items should usually be `todo`
7. do **not** mark anything `done` unless clearly justified by existing project state

If appropriate, begin with setup, architecture, scaffold, or interface-definition tasks before implementation tasks.

Keep `feature_list.json` aligned with the baseline plan.

---

## Step 8A: Create Or Update project_knowledge/overview.md

Create `STATE_DIR/project_knowledge/overview.md` as the durable project-understanding entrypoint.

This file should capture reusable execution knowledge rather than project goals or planning prose.

Keep it focused on only these five categories:

1. framework: project framework, runtime, and original project workflow or default development path
2. navigation: if changing X, where to look first
3. conventions: default ways of working and what not to bypass
4. landmarks: where key logic, config, commands, and resources actually live
5. risks: common misunderstandings, hidden assumptions, and likely pitfalls

For `standard` mode, add only when grounded:

- module boundaries
- key flows
- config or environment landmarks
- reading hints for common task types

Hard constraints:

1. use concise Markdown optimized for fast agent reading
2. every point should help a later thread decide where to read or how to modify safely
3. do **not** duplicate `plan.md`, `program.md`, roadmap, phase goals, or broad project background
4. if a point cannot answer "look where / follow what convention / avoid what pitfall", it probably does not belong here
5. keep `overview.md` as an entrypoint summary; split long topic-specific detail into later topic files only when clearly reusable
6. merge into existing headings when possible instead of creating scattered notes

---

## Step 9: Create Or Update progress.md

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
- whether `project_knowledge/overview.md` was created or updated
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
- ~/.codex-state/<project-key>/plan/plan.md
- feature_list.json
- ~/.codex-state/<project-key>/project_knowledge/overview.md
- progress.md
- AGENTS.md created or updated if needed
- .gitignore created or updated if needed

## Recommended next step
...

## Notes
...
```

---

## Step 10: Create Or Minimally Update AGENTS.md In Project Root

Create or update `PROJECT_ROOT/AGENTS.md`.

Because modifying project files can be sensitive, keep `AGENTS.md` as small and minimally invasive as possible.

Preferred strategies:

1. if `AGENTS.md` does not exist, create a small bootstrap version
2. if `AGENTS.md` exists, append a clearly delimited managed block instead of rewriting the whole file
3. preserve all meaningful existing instructions
4. avoid broad rewrites

Managed block requirement:

```md
<!-- PROJECT-INIT WORKFLOW START -->
...managed workflow guidance...
<!-- PROJECT-INIT WORKFLOW END -->
```

If a managed block already exists, update only the contents of that block.

The resulting `AGENTS.md` must implement this logic:

### State A: Not initialized

If the persistent state directory, the project plan directory, the primary plan file, or required files under `~/.codex-state/<project-key>/` are missing or invalid, the agent should tell the user to run:

`$project-init`

### State B: Initialized

If the persistent state exists, future threads should first read:

- `~/.codex-state/<project-key>/state.json`
- `~/.codex-state/<project-key>/project_knowledge/overview.md`
- `~/.codex-state/<project-key>/plan/plan.md`
- `~/.codex-state/<project-key>/feature_list.json`
- `~/.codex-state/<project-key>/progress.md`

Then for routine implementation work:

1. use `using-superpowers`
2. select exactly one incomplete feature
3. work only on that feature in the current cycle unless explicitly instructed otherwise
4. verify before marking done
5. update `feature_list.json`
6. treat `~/.codex-state/<project-key>/plan/` as the required destination for all plan artifacts
7. when `using-superpowers`, `write-plan`, `writing-plans`, or any other planning workflow is invoked for a current feature, create or update a separate `*_plan.md` file under `PLAN_DIR` rather than rewriting an existing `plan.md`
8. when the active feature can be identified from `feature_list.json`, prefer naming the new plan file from that feature's id or title slug
9. when continuing the same feature or topic, reuse the existing matching `*_plan.md`
10. do **not** create or update plan files inside the repository such as `docs/superpowers/plans/` unless the user explicitly asks for an in-repo plan file
11. do **not** modify an existing `~/.codex-state/<project-key>/plan/plan.md` unless the user explicitly asks to revise it
12. update `project_knowledge/overview.md` when the current thread learns durable project understanding that future threads are likely to reuse
13. append to `progress.md`
14. keep the repo runnable and reviewable

General rules:

- default to Chinese for user-facing communication unless the user explicitly requests another language
- do **not** use `project-init` for routine implementation
- during the first initialization thread, do **not** modify arbitrary project files
- prefer durable state over thread memory
- prefer `project_knowledge/overview.md` before rescanning large parts of the repository
- do **not** require later threads to read every durable file in full when a smaller targeted read is enough
- treat `project_knowledge/overview.md` as execution knowledge, not as a duplicate of `program.md` or `plan.md`
- treat the project-scoped plan directory as a user or project preference that overrides superpowers default plan locations
- if a planning skill would normally write to an in-repo path, redirect it to `~/.codex-state/<project-key>/plan/` instead
- when a planning skill creates a new plan file, prefer descriptive filenames ending in `_plan.md`
- if later threads learn reusable framework, convention, path, or logic knowledge, merge it into `project_knowledge/overview.md` when possible and create a topic file only when clearly more maintainable
- if repository state and persistent state conflict, call it out explicitly
- preserve existing project instructions over generated guidance when they conflict

Prefer a small bootstrap `AGENTS.md` that points future threads to the state files, rather than a giant policy document.

---

## Step 11: Create Or Update .gitignore When Appropriate

If `IS_GIT_REPO` is true, inspect `.gitignore`.

Required behavior:

1. Ensure that `AGENTS.md` is ignored by git **unless** the user explicitly asked to keep it tracked.
2. If `.gitignore` does not exist, create it with a minimal addition for `AGENTS.md`.
3. If `.gitignore` exists, add `AGENTS.md` only if it is not already effectively ignored.
4. Keep the update minimal and avoid reformatting unrelated content.
5. Do **not** add broad ignore rules unless explicitly requested.

This step only updates `.gitignore`. It does **not** run git commands.

If `AGENTS.md` was already tracked by git, mention clearly in the final report that `.gitignore` alone will not untrack it and the user may need to run `git rm --cached AGENTS.md` manually.

---

## Step 12: Final Validation

Before finishing, check that:

- `STATE_DIR` exists
- `PLAN_DIR` exists
- all required files exist
- `state.json` is internally consistent
- `feature_list.json` is valid JSON
- `~/.codex-state/<project-key>/plan/plan.md` reflects the confirmed goals
- `~/.codex-state/<project-key>/project_knowledge/overview.md` exists and matches the chosen `knowledge_mode`
- `~/.codex-state/<project-key>/plan/plan.md` clearly identifies the correct `project-key` or project root for the current project
- `AGENTS.md` exists in the project root
- `AGENTS.md` references the correct `project-key`
- `AGENTS.md` routes normal implementation to `using-superpowers`
- `AGENTS.md` routes missing-state situations to `$project-init`
- `AGENTS.md` encodes the default-Chinese communication rule
- `AGENTS.md` explicitly overrides in-repo superpowers plan destinations in favor of `~/.codex-state/<project-key>/plan/`
- `AGENTS.md` requires new plan artifacts to use filenames ending in `_plan.md`
- `AGENTS.md` keeps existing `plan.md` unchanged unless the user explicitly requests revision
- `.gitignore` exists or was updated appropriately when the project is a git repo
- no non-initialization project files were modified unless explicitly requested

If something could not be created, say so clearly.

---

## Empty-Project Compatibility

This skill must work for an empty or near-empty project folder.

If the project is empty:

- do **not** pretend there is existing architecture
- explicitly record that the repository is empty
- ask the user for the intended project goal
- write a plan suitable for a greenfield project
- create a feature backlog that starts from scaffold/setup/design milestones
- still create the same persistent state files
- still create `~/.codex-state/<project-key>/plan/plan.md`
- still create or minimally update `AGENTS.md`
- still create or minimally update `.gitignore` when appropriate

---

## Expected File Formats

- `state.json`: machine-readable durable state, valid JSON
- `feature_list.json`: machine-readable durable backlog, valid JSON array
- `progress.md`: human-readable durable handoff log
- `plan.md`: human-readable durable baseline strategy note stored at `~/.codex-state/<project-key>/plan/plan.md`
- `project_knowledge/overview.md`: human-readable durable project-understanding entrypoint
- `AGENTS.md`: project-root bootstrap workflow guidance
- `.gitignore`: minimal ignore-rules update

---

## Required Final Report To The User

At the end of initialization, report in Chinese by default unless the user explicitly requested another language.

The report must include:

1. detected project root
2. derived project key
3. created state directory
4. created project plan directory and primary plan path
5. whether the project appears empty or non-empty
6. chosen `knowledge_mode`
7. which files were created or updated
8. whether `AGENTS.md` was created or minimally updated
9. whether `.gitignore` was created or updated
10. concise summary of confirmed goals
11. concise summary of the initial plan
12. the initial recommended next feature
13. any conflicts, uncertainties, preserved existing instructions, or git-tracking caveats

Keep the report specific and concise.

---

## Normal-Work Handoff Rule

After initialization is complete, future routine implementation should not use this skill.

Future routine work should:

1. read `~/.codex-state/<project-key>/state.json`, `~/.codex-state/<project-key>/project_knowledge/overview.md`, `~/.codex-state/<project-key>/plan/plan.md`, `~/.codex-state/<project-key>/feature_list.json`, and `~/.codex-state/<project-key>/progress.md`
2. use `using-superpowers`
3. work one feature at a time
4. update durable state after each cycle
5. update `project_knowledge/overview.md` when durable project understanding changes or becomes clearer
6. when planning is needed for a feature, create or update a separate `*_plan.md` under `~/.codex-state/<project-key>/plan/`, preferably named from the active feature in `feature_list.json`
7. leave an existing `plan.md` unchanged unless the user explicitly asks to revise it
8. communicate with the user in Chinese by default unless the user explicitly requests another language

Reading guidance for later threads:

- start with `state.json` and `project_knowledge/overview.md`
- read `plan.md` only for baseline goals, strategy, or risks
- read `feature_list.json` only to find the current relevant feature
- read only the most recent relevant section of `progress.md` unless older history is needed
- if topic files are added under `project_knowledge/`, read only the files relevant to the current task

This boundary is strict.

---

## Quality Standard

Be concrete.
Be minimally destructive.
Ask for goals before finalizing backlog if they are not already clear.
Support empty projects honestly.
Preserve existing project guidance where possible.
Prefer a small bootstrap `AGENTS.md` over a large intrusive rewrite.
Do not hallucinate repository details.
Do not modify source files during initialization.
Prefer Chinese for user-facing workflow by default unless the user explicitly requests another language.
