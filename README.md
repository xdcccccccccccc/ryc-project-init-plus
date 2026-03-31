# project-init-SKILL-v5.3

这是一个用于 Codex 长周期协作的项目初始化 skill。

它只负责“第一次初始化”，不负责日常功能开发。它会为项目建立可持久化的状态目录、初始计划、初始 backlog，以及后续线程继续工作的最小引导规则。

## 环境说明

这个 skill 面向以下环境：

- macOS
- Linux
- WSL

说明：

- 持久化状态默认写入当前用户家目录下的 `~/.codex-state/<project-key>/`
- 在 macOS / Linux / WSL 中，`~` 都表示当前用户的 home 目录
- 如果你在 WSL 中使用 Codex，应把 WSL 里的 Linux 环境视为运行环境，状态文件也会写入 WSL 的 home 目录，而不是 Windows 用户目录

## 使用前准备

使用这个 skill 之前，应先安装 `using-superpowers` skill。

下载示例：

```bash
git clone https://github.com/obra/superpowers.git ~/.codex/superpowers
mkdir -p ~/.agents/skills
ln -s ~/.codex/superpowers/skills ~/.agents/skills/superpowers
```

如果没有先安装 `using-superpowers`，这个 skill 虽然仍可完成初始化，但后续常规开发线程将无法按预期 workflow 继续执行。

## Git 说明

这个 skill 预期项目本身是一个 git 项目。

说明：

- 它会优先通过项目根目录和 `.git` 状态识别当前项目
- 如果目录不是 git 项目，初始化仍可能进行，但不属于推荐使用方式
- 它不会修改源码、测试、CI、构建文件等与初始化无关的项目文件，除非用户明确要求
- 它对项目根目录的 git 相关改动仅限于最小化创建或更新 `AGENTS.md` 和 `.gitignore`
- 它不会主动执行 `git add`、`git commit`、`git push`、`git rm` 等 git 写操作
- `AGENTS.md` 的默认策略是加入 `.gitignore`，目的是让本地 workflow 引导文件不污染原 git 项目
- 如果 `AGENTS.md` 之前已经被 git 跟踪，仅修改 `.gitignore` 不会自动取消跟踪，这种情况下需要用户自行处理

简而言之，这个 skill 的 git 行为边界是：识别 git 项目、最小更新本地引导文件、尽量不污染仓库历史。

## 这个版本的目标

- 把项目初始化流程固定下来。
- 把关键状态存到 `~/.codex-state/<project-key>/`。
- 避免 `using-superpowers` / `writing-plans` 把计划文件写进 git 仓库。
- 要求后续线程继续按 one-feature-per-cycle 方式推进。
- 默认用中文做用户侧沟通，除非用户明确要求其他语言。
- 新增 `project_knowledge/` 项目理解层，减少后续线程重复理解项目的成本。

## v5.2 的关键变化

和前一版相比，v5 已经不再使用全局共享路径 `~/.codex-state/plan/plan.md`。

现在改为项目隔离结构：

- 主计划文件：`~/.codex-state/<project-key>/plan/plan.md`
- 后续专题计划：`~/.codex-state/<project-key>/plan/xxx_plan.md`
- 项目理解入口：`~/.codex-state/<project-key>/project_knowledge/overview.md`

这样做的目的，是避免多个项目共用同一个 `plan.md` 时互相覆盖。

v5.2 进一步新增：

- 初始化线程支持 `knowledge_mode`：`lite` / `standard`
- 初始化时先生成一份浅层或中层的 `project_knowledge/overview.md`
- 后续线程优先复用这份项目理解，而不是每次重新扫描大量仓库内容
- `overview.md` 只承载可复用的执行认知，不重复 `program.md` / `plan.md`
- `overview.md` 保持为入口摘要，不应膨胀成完整百科；专题内容后续按需拆分

`project_knowledge/overview.md` 应优先沉淀这 5 类内容：

- 框架类：项目框架、运行方式、原项目工作流、默认开发链路
- 导航类：改什么，先看哪里
- 约定类：默认怎么做，哪些做法不要碰
- 落点类：关键逻辑、配置、命令、资源落在哪些路径
- 风险类：最容易误解、遗漏、踩坑的点

## 持久化文件布局

项目专属状态目录：

- `~/.codex-state/<project-key>/state.json`
- `~/.codex-state/<project-key>/feature_list.json`
- `~/.codex-state/<project-key>/progress.md`
- `~/.codex-state/<project-key>/plan/plan.md`
- `~/.codex-state/<project-key>/plan/xxx_plan.md`
- `~/.codex-state/<project-key>/project_knowledge/overview.md`

项目根目录最小引导文件：

- `AGENTS.md`
- `.gitignore`

## 初始化阶段会做什么

1. 识别项目根目录和 git 状态。
2. 生成稳定的 `project-key`。
3. 创建 `~/.codex-state/<project-key>/`。
4. 创建 `~/.codex-state/<project-key>/plan/`。
5. 扫描项目结构、README、构建文件、测试配置、已有 workflow 文件等。
6. 向用户确认目标、第一阶段交付物、边界和约束。
7. 选择 `knowledge_mode`：`lite` 或 `standard`。
8. 写入初始 `plan.md`、`feature_list.json`、`progress.md`、`state.json`。
9. 写入 `project_knowledge/overview.md`。
10. 在项目根目录创建或最小更新 `AGENTS.md`。
11. 在必要时最小更新 `.gitignore`，避免 `AGENTS.md` 被提交。

## 初始化后的常规线程规则

后续线程在开始工作前，应先读取：

- `~/.codex-state/<project-key>/state.json`
- `~/.codex-state/<project-key>/project_knowledge/overview.md`
- `~/.codex-state/<project-key>/plan/plan.md`
- `~/.codex-state/<project-key>/feature_list.json`
- `~/.codex-state/<project-key>/progress.md`

然后：

- 使用 `using-superpowers`
- 一次只处理一个未完成 feature
- 完成后更新 `feature_list.json`
- 如果获得了可复用的框架/约定/路径/逻辑理解，优先更新 `project_knowledge/overview.md`
- 如果总体计划、范围、执行顺序发生变化，更新 `plan/plan.md`
- 如果使用 `write-plan` 或 `writing-plans` 生成专题计划，把新文件写到 `plan/` 目录下
- 追加更新 `progress.md`

读取时应尽量按需进行：

- 先读 `state.json` 和 `project_knowledge/overview.md`
- `plan.md` 重点看目标、策略、风险，不必默认全文细读
- `feature_list.json` 重点定位当前 relevant feature
- `progress.md` 默认只看最近相关记录
- 如果后续新增专题知识文件，只按当前任务需要读取

这里的边界是：

- `program.md` / `plan.md` 负责目标、阶段、范围、计划
- `project_knowledge/overview.md` 负责执行认知：先看哪里、遵循什么约定、关键内容落在哪里、有哪些坑

## write-plan 文件规则

v5 明确要求：

- `write-plan` / `writing-plans` 不得把计划写入仓库内默认路径，例如 `docs/superpowers/plans/`
- 所有专题计划文件必须写到 `~/.codex-state/<project-key>/plan/`
- 新文件名必须以 `_plan.md` 结尾

推荐命名方式：

- `auth-flow_plan.md`
- `phase1-api_plan.md`
- `deploy-checklist_plan.md`

不推荐：

- `new_plan.md`
- `temp_plan.md`
- `plan2.md`

如果是在更新同一个专题，优先复用原有专题文件，而不是重复创建近似文件。

## 与 using-superpowers 的关系

这个 skill 不取代 `using-superpowers`，而是负责：

- 第一次初始化时建立持久化状态
- 第一次初始化时建立项目理解入口 `project_knowledge/overview.md`
- 把后续线程的行为边界写进 `AGENTS.md`
- 用项目级偏好覆盖上游 `writing-plans` 的默认仓库内落盘行为

换句话说，这个 skill 负责“立规矩”，后续常规开发还是交给 `using-superpowers`。

## 适用场景

适合：

- 一个项目第一次接入 Codex
- 希望后续线程依赖持久化状态，而不是聊天记忆
- 希望计划文件不要污染 git 仓库
- 希望未来线程持续按 feature 粒度推进

不适合：

- 已经初始化完毕且状态健康的项目
- 日常功能开发或 bug 修复
- 不希望把状态写入 `~/.codex-state` 的场景

## 已知设计取舍

v5 已经把计划文件从“全局共享单文件”升级成“按项目隔离目录”，所以最主要的串项目风险已经显著下降。

当前仍然有一些设计取舍需要注意：

- `AGENTS.md` 是通过项目根目录引导后续线程遵守规则的，不是直接修改上游 superpowers skill 本身
- 如果用户明确要求把计划写回仓库，这个 skill 应该允许用户指令覆盖默认规则
- `xxx_plan.md` 的命名仍然依赖 agent 选择合适的 topic slug，因此需要在规范里持续强调命名约束
- `project_knowledge/overview.md` 不是项目背景文档，而是执行认知入口
- `project_knowledge/overview.md` 应保持为入口摘要；当主题变长时，后续应拆分专题知识文件而不是无限堆积

## 当前版本摘要

- 版本：v5.3
- 默认语言：中文
- 默认日常执行 skill：`using-superpowers`
- 主计划路径：`~/.codex-state/<project-key>/plan/plan.md`
- 专题计划路径：`~/.codex-state/<project-key>/plan/xxx_plan.md`
- 项目理解入口：`~/.codex-state/<project-key>/project_knowledge/overview.md`
- 项目专属状态路径：`~/.codex-state/<project-key>/`
