# ryc-project-init-plus

`ryc-project-init-plus` is a multi-skill workflow collection for long-running project collaboration in Codex or Claude Code.

It keeps the familiar first-time initialization experience of the old `project-init` workflow, but splits later work into clearer roles so new threads read less context and update state more safely.

## Skills

- `ryc-project-workflow-router`: default entry when the role is unclear
- `ryc-project-init`: first-time project initialization and bootstrap
- `ryc-project-developer`: normal implementation workflow for one task at a time
- `ryc-project-reviewer`: module review, logic analysis, and risk inspection
- `ryc-project-planner`: replanning, backlog reshaping, and next-step discussion

`skills/shared/` is a shared reference folder. It is not a skill and should not be invoked directly.

## Install

This project is installed the same way as `superpowers`: mount the repository's `skills/` directory into `~/.agents/skills/`.

```bash
git clone <your-repo-url> ~/.codex/ryc-project-init-plus
mkdir -p ~/.agents/skills
ln -s ~/.codex/ryc-project-init-plus/skills ~/.agents/skills/ryc-project-init-plus
```

This works because Codex discovers each nested `SKILL.md` under the mounted `skills/` directory, just like it does for `superpowers`.

## Use

If the role is unclear, start with:

```text
$ryc-project-workflow-router
```

If the role is already clear, invoke the role skill directly:

```text
$ryc-project-init
$ryc-project-developer
$ryc-project-reviewer
$ryc-project-planner
```

Recommended usage:

- first-time bootstrap: `ryc-project-init`
- routine feature delivery: `ryc-project-developer`
- logic review or code scrutiny: `ryc-project-reviewer`
- backlog or direction changes: `ryc-project-planner`

## State Files

This workflow centers around durable state under `~/.codex-state/<project-key>/`.

Core files:

- `state.json`
- `feature_list.json`
- `progress.md`
- `plan/plan.md`
- `plan/*_plan.md`
- `project_knowledge/overview.md`
- `project_knowledge/*.md`

If a project also has `program.md`, it is treated as an intent document for goals, scope, and direction. It is not duplicated into `project_knowledge`.

## Design Notes

- `ryc-project-init` still writes `AGENTS.md` and bootstraps the project state
- later roles learn the state layout and constraints from `AGENTS.md`, but are not trapped in a binary state machine
- `ryc-project-developer` defaults to exactly one task unless the user explicitly allows more
- `project_knowledge` is for reusable execution knowledge, not roadmap or phase planning

## Layout

```text
skills/
  ryc-project-workflow-router/
    SKILL.md
  ryc-project-init/
    SKILL.md
  ryc-project-developer/
    SKILL.md
  ryc-project-reviewer/
    SKILL.md
  ryc-project-planner/
    SKILL.md
  shared/
    state-files.md
    role-matrix.md
    knowledge-writing-rules.md
    plan-writing-rules.md
    progress-writing-rules.md
```
