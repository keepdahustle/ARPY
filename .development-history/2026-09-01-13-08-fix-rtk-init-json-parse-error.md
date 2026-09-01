# Development Report: Fix RTK Init JSON Parse Error

- **Date**: 2026-09-01 13:08
- **Task Summary**: Fix `rtk init -g` failure caused by `Failed to parse settings.json as JSON: expected value at line 1 column 1`.

## Relevant Previous Context
- Error output showed RTK failed on initial character of `~/.claude/settings.json`.

## Changes Made
- Identified UTF-8 BOM (`EF BB BF`) at the start of `C:\Users\strio\.claude\settings.json`.
- Stripped BOM and saved file as clean UTF-8 without BOM.

## Files Affected
- `C:\Users\strio\.claude\settings.json`

## Technical Decisions
- Removed BOM directly via Node.js script to prevent standard PowerShell encoding quirks.

## Verification Performed
- Inspected file header bytes (`7b 0d 0a 20` - no BOM).
- Executed `rtk init -g` successfully (output: `settings.json: hook already present`).
- Ran `rtk --version` (v0.45.0) and `rtk gain` (active global metrics confirmed).

## Final Result
- `rtk init -g` succeeded with no JSON parse errors.
- PreToolUse hook for `rtk hook claude` verified present in settings.

## Known Limitations
- Claude Code session requires restart to apply hook changes in new sessions if not already active.

## Unresolved Issues or Follow-up Work
- None.
