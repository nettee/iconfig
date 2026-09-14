## Error Handling / Fast Fail

Required operations must fail visibly when configuration, input, or invariants are invalid, or when a required dependency or subprocess fails.

Catch errors only to recover deliberately, add boundary context, or isolate non-critical diagnostics. Otherwise, propagate them.

Do not turn failures into apparent success through fabricated fallback data, ignored errors, or success messages after incomplete work. Optional logging, telemetry, tracing, and diagnostics must not block core functionality.

CLI commands and scripts must exit non-zero when required work fails. Apply the same rules when reviewing code.

---

## Command Preferences

- Prefer `rg` (ripgrep) for text search. Use `grep` only when `rg` is unavailable or a command explicitly requires POSIX grep.
