## Subagent Usage

Use subagents mainly to keep the main context small and to parallelize research or exploration. Codex subagents are generic, so give them focused investigation tasks rather than assuming specialized roles.

Recommended uses:

- Broad codebase exploration: ask a subagent to find relevant files, symbols, patterns, or prior implementations.
- Research: ask a subagent to investigate documentation, APIs, errors, logs, or unfamiliar dependencies.
- Parallel discovery: split independent searches across multiple subagents when each can return a compact summary.
- Verification support: ask a subagent to inspect outputs, diffs, or diagnostics when the result can be summarized clearly.

Avoid subagents when:

- The task is a small direct edit or a single known file lookup.
- You need to personally reason through exact code before editing it.
- Requirements are unclear and you should ask the user a question first.
- Writing the subagent prompt would take longer than doing the work.

Good subagent prompts should include:

- A specific objective.
- Relevant paths, commands, errors, or constraints.
- Whether the task is read-only or may edit files.
- The expected output format: concise findings, file references, recommended next steps.

After a subagent returns, integrate the result yourself, verify important claims, and make the final decision in the main session.
