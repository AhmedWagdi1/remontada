# Flutter MCP setup on this machine

This project is configured to use the Flutter MCP server locally so your AI assistant can access real-time Flutter/Dart and pub.dev docs.

## What I installed (user-local)
- Python venv: `~/.local/share/flutter-mcp-venv`
- Flutter MCP (from GitHub): installed into that venv, CLI path:
  `/home/ahmed/.local/share/flutter-mcp-venv/bin/flutter-mcp`
- Project scripts to run it via npm scripts
- Continue (VS Code) config to auto-connect over STDIO

## Quick use
- STDIO (recommended with Continue):
  - In this repo folder, run:
    - `npm run mcp:flutter:stdio`
  - Or start automatically from Continue using `.continuerc.json`.

- HTTP (for manual testing or other MCP clients):
  - `npm run mcp:flutter:http`
  - Then test tools list:
    - `curl -X POST http://localhost:8000/mcp/v1/tools/list`

## VS Code + Continue
We added `.continuerc.json` with a server named `flutter-mcp` using STDIO.
If Continue is installed, it will pick this up. Make sure to have the Continue extension enabled.

## Notes
- Cache lives at `~/.cache/FlutterMCP/cache.db` and is auto-managed.
- You can pass environment variables like `DEBUG=1` before the command for verbose logs.
- To update the server:
  - `~/.local/share/flutter-mcp-venv/bin/pip install --upgrade 'git+https://github.com/adamsmaka/flutter-mcp.git'`

## Troubleshooting
- If `pip` is blocked system-wide, use only the provided venv path above.
- If HTTP port is busy, change `--port` to another free port.
- If Continue cannot find the command, confirm the absolute path in `.continuerc.json`.
