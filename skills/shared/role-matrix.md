# Role Matrix

| role | primary purpose | default reads | default writes | must not do |
|---|---|---|---|---|
| `ryc-project-init` | first-time initialization and bootstrap | repo structure, README/docs, user goals | all managed state files, `AGENTS.md`, `CLAUDE.md`, `.gitignore` | routine implementation, normal code review |
| `ryc-project-developer` | implement one confirmed task | `state.json`, `project_knowledge/overview.md`, current feature entry, recent relevant progress, current feature plan if needed | current feature status, relevant plan file, `progress.md`, `project_knowledge` | complete multiple tasks by default, rewrite baseline planning casually |
| `ryc-project-reviewer` | logic analysis and detailed review | `state.json`, `project_knowledge/overview.md`, requested scope files, related plan only if needed | usually none; optionally concise `progress.md` or stable knowledge note | implement fixes by default, rewrite backlog or baseline plans |
| `ryc-project-planner` | reshape backlog, discuss direction, revise planning | `state.json`, `program.md` if present, `plan.md`, `feature_list.json`, recent relevant progress, knowledge only if execution reality matters | `feature_list.json`, `plan.md`, `*_plan.md`, `progress.md` | act like a developer and silently implement features |

## Cross-Role Rules

- one thread should normally have one primary role
- when the role changes, switch deliberately instead of blending workflows
- if the role is unclear, start with `ryc-project-workflow-router`
- `ryc-project-developer` defaults to exactly one task unless the user explicitly allows more
- `using-superpowers` is the underlying implementation workflow after the developer role is selected
