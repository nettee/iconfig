## Let It Crash / Fast Fail

This project values observable failure during development.

Rules:
- Surface failures as early as possible.
- Fail fast on invalid state, missing config, bad inputs, failed subprocesses, failed network calls, and violated invariants.
- Do not let non-critical logging, telemetry, diagnostics, tracing, metrics, debug capture, or observability failures block required business functionality.
- When required input, configuration, credentials, files, API responses, or user-provided data are missing, fail immediately with a clear error. Do not substitute mock data, placeholder values, sample fixtures, empty objects, default IDs, or fabricated responses unless the user explicitly requests a mock/demo mode.
- Prefer explicit errors, failed tests, assertions, and clear diagnostics over fallback behavior.
- Catch only exceptions that have a specific recovery path.
- Propagate errors to the caller unless a real recovery path exists.
- When recovery is possible, report the failure state to the caller or UI.
- When recovery is unclear, stop and explain the missing assumption, dependency, input, or invariant.
- UI code must show failure states to users during development.
- Scripts must exit non-zero when a required step fails.
- Add tests that fail when errors are swallowed.
- For prototypes, preserve crash visibility unless the user explicitly asks for production-grade recovery behavior.

Review checklist:
- Identify every added `try/catch`, `except`, fallback default, retry, mock, placeholder, and ignored error.
- Explain why each one exists.
- Remove any error handling whose main purpose is making the flow appear successful.
- No broad catch blocks without typed handling.
- No empty catch blocks.
- No fallback data that can hide integration failure.
- No mock, placeholder, sample, or fabricated data in production/dev flows unless explicitly labeled as mock/demo mode.
- No “best effort” continuation after a failed required step.
- No success message after partial failure.
