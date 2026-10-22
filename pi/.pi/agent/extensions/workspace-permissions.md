# Workspace tool permissions

Pi asks once, on the first tool call in an unknown workspace, whether to authorize every agent tool there. Approval is stored by canonical workspace path in `~/.pi/agent/workspace-permissions.json` (or `$PI_CODING_AGENT_DIR/workspace-permissions.json`) and applies to later sessions.

To revoke a workspace, remove its path from that JSON file. A malformed file fails closed: no workspace is trusted until a new approval is saved.

This is an interaction guard, not a sandbox. Loaded extensions and approved tool calls still execute with the host user's privileges.
