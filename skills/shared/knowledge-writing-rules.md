# Knowledge Writing Rules

This document defines what may be written into `project_knowledge`.

## Core Rule

`project_knowledge` is for reusable execution knowledge, not project goals or planning prose.

## Allowed Content

Only these five categories belong here:

1. framework
   - framework and runtime
   - original project workflow
   - default development path
2. navigation
   - if changing X, where to look first
3. conventions
   - default ways of working
   - what not to bypass
4. landmarks
   - where key logic, config, commands, and resources live
5. risks
   - common misunderstandings
   - hidden assumptions
   - likely pitfalls

## Disallowed Content

Do not write:

- roadmap
- phase goals
- scope negotiations
- backlog rationale
- broad project background
- one-off analysis logs
- temporary debugging transcripts

If a point cannot answer "look where", "follow what convention", or "avoid what pitfall", it probably does not belong here.

## `overview.md`

`overview.md` is the entrypoint summary.

It should:

- stay concise
- help later threads find the right starting points
- point to deeper topic files when needed

It should not become a full project encyclopedia.

## When To Create A New Topic File

Create `project_knowledge/<topic>.md` only when all of these are true:

- the topic is clearly reusable
- the content is too large or too specific for `overview.md`
- the topic has a stable title
- future threads are likely to benefit from a dedicated file

Good examples:

- `auth-flow.md`
- `api-boundaries.md`
- `deployment-paths.md`

Bad examples:

- `notes.md`
- `misc.md`
- `tmp.md`

## Sync Rules After Creating A Topic File

Whenever a new topic file is created:

1. add a short pointer to it in `project_knowledge/overview.md`
2. keep only a brief summary in `overview.md`, not a duplicate of the full content
3. append a concise note to `progress.md`

## Update Rules

- prefer merging into an existing heading or topic file instead of scattering new notes
- prefer small durable updates over large rewrites
- if knowledge conflicts with repository reality, call out the conflict explicitly
