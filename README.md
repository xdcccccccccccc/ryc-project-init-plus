# ryc-project-init-plus

`ryc-project-init-plus` 是一个面向 Codex 或 Claude Code 长周期协作的多 skill 工作流集合。

它保留了旧版 `project-init` 在“首次初始化”上的熟悉体验，同时把后续工作拆成更清晰的角色，让新线程减少无关上下文读取，并更安全地更新项目状态。

## Skills

- `ryc-project-workflow-router`：当角色不明确时的默认入口
- `ryc-project-init`：首次项目初始化与工作流引导
- `ryc-project-developer`：日常实现角色，默认一次只做一个任务
- `ryc-project-reviewer`：模块审查、逻辑分析与风险检查
- `ryc-project-planner`：方案重设、backlog 调整与下一步方向讨论

`skills/shared/` 是共享参考目录，不是 skill，不应被直接调用。

## Install

这个项目的安装方式和 `superpowers` 一样：把仓库中的 `skills/` 目录挂载到对应 agent 的 skills 目录下。

Codex:

```bash
git clone https://github.com/xdcccccccccccc/ryc-project-init-plus.git ~/.codex/ryc-project-init-plus
mkdir -p ~/.agents/skills
ln -s ~/.codex/ryc-project-init-plus/skills ~/.agents/skills/ryc-project-init-plus
```

Claude Code:

```bash
git clone https://github.com/xdcccccccccccc/ryc-project-init-plus.git ~/.codex/ryc-project-init-plus
mkdir -p ~/.claude/skills
ln -s ~/.codex/ryc-project-init-plus/skills ~/.claude/skills/ryc-project-init-plus
```

这样安装后，Codex 或 Claude Code 都会在挂载后的 `skills/` 目录下发现各个子 skill 的 `SKILL.md`。

## Use

如果当前线程的角色不明确，可以先用：

```text
$ryc-project-workflow-router
```

如果角色已经明确，可以直接调用对应的 role skill：

```text
$ryc-project-init
$ryc-project-developer
$ryc-project-reviewer
$ryc-project-planner
```

推荐用法：

- 第一次初始化项目：`ryc-project-init`
- 日常功能开发与任务推进：`ryc-project-developer`
- 逻辑审查或代码细查：`ryc-project-reviewer`
- backlog 或方案方向调整：`ryc-project-planner`

## State Files

这套工作流围绕 `~/.codex-state/<project-key>/` 下的持久化状态展开。

核心状态文件包括：

- `state.json`
- `feature_list.json`
- `progress.md`
- `plan/plan.md`
- `plan/*_plan.md`
- `project_knowledge/overview.md`
- `project_knowledge/*.md`

如果项目本身还存在 `program.md`，则把它视为目标、范围和方向层的意图文档，不应把这些内容重复写进 `project_knowledge`。

## Design Notes

- `ryc-project-init` 仍然负责写入 `AGENTS.md`、`CLAUDE.md` 并完成项目状态初始化
- 后续角色会从这些引导文件了解状态文件与约束，但不会被限制在一个简单的二元状态机里
- `ryc-project-developer` 默认一次只完成一个任务，除非用户明确允许更多
- `project_knowledge` 用来承载可复用的执行认知，而不是 roadmap 或阶段计划

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
