## Error Handling / Fast Fail

Prefer observable failures over hidden fallback behavior.

When writing code:
- Fail fast on missing required config, invalid input, failed required subprocesses, failed network calls, and violated invariants.
- Do not hide required failures with mock data, placeholder values, empty defaults, broad catches, or “best effort” success.
- Catch errors only when there is a specific recovery path or a boundary-level reporting responsibility.
- Non-critical logging, telemetry, tracing, or diagnostics must not block core business functionality.
- Scripts must exit non-zero when a required step fails.

When reviewing changes:
- Flag broad or empty catches, ignored errors, fallback data, retries, mocks, and success messages after partial failure.

---

## worktree-kit (wtk)

If you see a WTK-AUXILIARY.md file in the repository root, read its contents and follow them.
