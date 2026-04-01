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

推荐先把仓库克隆到一个固定位置，再用软链安装到 Codex 或 Claude Code。

推荐克隆位置：

```bash
git clone https://github.com/xdcccccccccccc/ryc-project-init-plus.git ~/.codex/ryc-project-init-plus
```

Codex:

```bash
bash ~/.codex/ryc-project-init-plus/scripts/install-codex.sh
```

这样安装后，Codex 会像处理 `superpowers` 一样，在挂载后的集合目录下发现各个子 skill 的 `SKILL.md`。

Claude Code:

```bash
bash ~/.codex/ryc-project-init-plus/scripts/install-claude.sh
```

Claude Code 使用的是官方 personal skills 目录 `~/.claude/skills/`。安装脚本会把每个角色 skill 单独软链到这个目录下，因此安装完成后可以直接在 Claude Code 对话框输入：

```text
/ryc-project-init
/ryc-project-developer
/ryc-project-reviewer
/ryc-project-planner
/ryc-project-workflow-router
```

脚本还会一并链接 `shared/`，因为当前 skill 集合通过 `../shared/*.md` 读取共享参考文件。

## Update

如果 Codex 和 Claude Code 都是从同一个 clone 安装的，后续更新只需要：

```bash
cd ~/.codex/ryc-project-init-plus
git pull
```

因为两个系统内的 skill 都是软链到这一个仓库，所以不需要重复复制文件。

如果你调整了安装路径，再重新运行对应安装脚本即可。

## Verify

Codex:

```bash
ls -la ~/.agents/skills/ryc-project-init-plus
```

Claude Code:

```bash
ls -la ~/.claude/skills/ryc-project-init
ls -la ~/.claude/skills/shared
```

然后重启 Claude Code，新开一个会话，直接输入：

```text
/ryc-project-init
```

如果命令能出现并执行，对应 skill 就已经被 Claude Code 识别了。

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
scripts/
  install-codex.sh
  uninstall-codex.sh
  install-claude.sh
  uninstall-claude.sh
```
