## Subagent Usage

Use subagents mainly to keep the main context small and to parallelize research or exploration. Even generic Codex subagents are preferred for bounded research because they preserve the main session's context and can explore independently. Give them focused investigation tasks rather than assuming specialized roles.

Default rule: do not do broad research or broad exploration in the main session first. If the task involves unfamiliar code, unknown files, external documentation, APIs, errors, logs, or dependencies, delegate a bounded read-only investigation to a subagent first, then integrate the result yourself.

Recommended uses:

- Broad codebase exploration: ask a subagent to find relevant files, symbols, patterns, or prior implementations.
- Research: ask a subagent to investigate documentation, APIs, errors, logs, or unfamiliar dependencies.
- Parallel discovery: split independent searches across multiple subagents when each can return a compact summary.
- Verification support: ask a subagent to inspect outputs, diffs, or diagnostics when the result can be summarized clearly.

Avoid subagents when:

- The task is a small direct edit or a single known file lookup.
- You need to personally reason through exact code before editing it.
- Requirements are unclear and you should ask the user a question first.
- The lookup is limited to one known path, one known symbol, or one obvious command, and can be completed with one direct read/search.

Good subagent prompts should include:

- A specific objective.
- Relevant paths, commands, errors, or constraints.
- Whether the task is read-only or may edit files.
- The expected output format: concise findings, file references, recommended next steps.

After a subagent returns, integrate the result yourself, verify important claims, and make the final decision in the main session.
