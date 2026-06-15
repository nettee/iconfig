## Subagent Usage

Use subagents aggressively for broad research/exploration so the main context stays small. Give each subagent a focused task and expected summary.

Default: if the task involves unfamiliar code, unknown files, docs, APIs, errors, logs, or dependencies, delegate a bounded read-only investigation first.

After launching a subagent, do not duplicate its scope in the main session. Work only on independent tasks; otherwise wait. For multiple gaps, dispatch multiple subagents instead of researching serially yourself.

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
