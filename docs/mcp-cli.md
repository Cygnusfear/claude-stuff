# MCP CLI Guide

Comprehensive guide to using `mcp` (mcptools) for interacting with Model Context Protocol servers.

## Introduction

The MCP CLI (`mcp`) is a command-line tool for interacting with MCP servers. It provides:
- **Tool discovery**: List available tools on an MCP server
- **Tool invocation**: Call tools with parameters
- **Interactive mode**: Shell mode for multiple commands
- **Resource access**: Read resources from MCP servers

**When to use MCP CLI:**
- Automating browser interactions (chrome-devtools-mcp)
- File system operations (filesystem servers)
- API interactions (various MCP servers)
- Testing MCP server functionality

## Installation

### macOS
```bash
brew tap f/mcptools
brew install mcp
```

### Windows/Linux
```bash
go install github.com/f/mcptools/cmd/mcptools@latest
```

### Verify Installation
```bash
mcp --help
mcp version
```

## Command Syntax

### Basic Structure

**CORRECT syntax:**
```bash
mcp call TOOL_NAME SERVER_COMMAND [SERVER_FLAGS] --params '{JSON_PARAMS}'
```

**Key points:**
- Server command comes AFTER tool name
- `--params` comes AFTER server command
- Parameters are JSON (no "arguments" wrapper)

### Examples

```bash
# Correct
mcp call read_file npx -y @modelcontextprotocol/server-filesystem ~ --params '{"path":"README.md"}'

# Correct with server flags
mcp call navigate_page bunx -y chrome-devtools-mcp@latest -- --isolated --params '{"url":"https://example.com"}'
```

## Core Pitfalls & Solutions

### 1. Parameter Format Mistakes

❌ **WRONG - Don't wrap in "arguments":**
```bash
mcp call navigate_page bunx -y chrome-devtools-mcp@latest --params '{"arguments":{"url":"..."}}'
```

✅ **CORRECT - Pass parameters directly:**
```bash
mcp call navigate_page bunx -y chrome-devtools-mcp@latest --params '{"url":"..."}'
```

### 2. Argument Order Issues

❌ **WRONG - params before server command:**
```bash
mcp call list_pages --params '{}' bunx -y chrome-devtools-mcp@latest
```

✅ **CORRECT - server command before params:**
```bash
mcp call list_pages bunx -y chrome-devtools-mcp@latest --params '{}'
```

### 3. Empty Parameter Schema Bug

**Problem:** Tools with all-optional parameters fail with "Invalid arguments" error when passed `{}` or no params.

**Error message:**
```
MCP error -32602: Invalid arguments for tool list_pages: [
  {
    "code": "invalid_type",
    "expected": "object",
    "received": "undefined",
    "path": [],
    "message": "Required"
  }
]
```

**Workaround:** Provide at least one optional parameter:

❌ **WRONG - empty object fails:**
```bash
mcp call list_console_messages bunx -y chrome-devtools-mcp@latest --params '{}'
```

✅ **CORRECT - provide one optional param:**
```bash
mcp call list_console_messages bunx -y chrome-devtools-mcp@latest --params '{"pageIdx":0}'
```

**Common affected tools:**
- Tools with no required parameters
- Tools where all parameters are optional
- Tools with empty input schemas

## Performance Patterns

### Shell Mode vs Individual Calls

**Individual calls (SLOW):**
- Each call starts a new MCP server instance
- Each call may launch a new browser/process
- Profile locks and conflicts are common
- **~60-90 seconds for multiple commands**

```bash
# SLOW - 3 separate server instances
mcp call navigate_page bunx -y chrome-devtools-mcp@latest --params '{"url":"..."}'
mcp call list_console bunx -y chrome-devtools-mcp@latest --params '{"pageIdx":0}'
mcp call take_snapshot bunx -y chrome-devtools-mcp@latest --params '{}'
```

**Shell mode (FAST):**
- One MCP server instance for all commands
- Single browser/process instance
- No profile conflicts
- **~5-10 seconds for multiple commands**

```bash
# FAST - 1 server instance, multiple commands
echo -e 'navigate_page {"url":"..."}\nlist_console_messages {"pageIdx":0}\ntake_snapshot {"verbose":false}\nexit' | \
mcp shell bunx -y chrome-devtools-mcp@latest
```

**Speed improvement: 6-9x faster with shell mode**

### The Optimized Pattern

**Template:**
```bash
CLEANUP; sleep 1; echo -e 'COMMAND1\nCOMMAND2\n...\nexit' | timeout SECONDS mcp shell SERVER_COMMAND [FLAGS]
```

**Example:**
```bash
pkill -9 -f "chrome-devtools-mcp" 2>/dev/null; sleep 1; \
echo -e 'navigate_page {"url":"http://localhost:3000"}\nlist_console_messages {"pageIdx":0}\nexit' | \
timeout 30 mcp shell bunx -y chrome-devtools-mcp@latest -- --isolated
```

**Components:**
1. **Cleanup** - Kill existing instances to prevent locks
2. **Sleep** - Wait for cleanup to complete
3. **Echo commands** - Pipe multiple commands with `\n` separators
4. **Timeout** - Prevent commands from hanging
5. **Exit** - Always include `exit` at the end

**Benefits:**
- ✅ No profile lock conflicts
- ✅ No manual process management
- ✅ No hanging commands
- ✅ 6-9x faster than individual calls

## Server Instance Management

### Profile Lock Conflicts

**Problem:** MCP servers (especially browser-based ones) can lock profiles, preventing new instances.

**Symptoms:**
```
The browser is already running for /path/to/profile. Use --isolated to run multiple browser instances.
```

**Solutions:**

1. **Cleanup first (RECOMMENDED):**
```bash
pkill -9 -f "server-name" 2>/dev/null; sleep 1
# Then run your command
```

2. **Use isolated mode:**
```bash
mcp call tool_name bunx server -- --isolated --params '{...}'
```

3. **Connect to existing instance:**
```bash
# Start instance with debugging
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222

# Connect to it
mcp call tool bunx chrome-devtools-mcp@latest -- --browserUrl http://127.0.0.1:9222 --params '{...}'
```

### Process Management

**Find running MCP servers:**
```bash
ps aux | grep -i "mcp"
ps aux | grep -i "server-name"
```

**Kill specific processes:**
```bash
kill PID1 PID2
```

**Kill all instances:**
```bash
pkill -9 -f "server-name"
```

## Best Practices

### 1. Always Use Cleanup Before Commands

```bash
# Pattern for any MCP server
pkill -9 -f "server-name" 2>/dev/null; sleep 1; YOUR_COMMAND
```

### 2. Use Timeout to Prevent Hangs

```bash
# Without timeout (might hang forever)
echo 'command' | mcp shell server

# With timeout (fails after 30s)
echo 'command' | timeout 30 mcp shell server
```

### 3. Batch Multiple Commands in One Session

❌ **BAD:**
```bash
for cmd in cmd1 cmd2 cmd3; do
  echo "$cmd" | mcp shell server
done
```

✅ **GOOD:**
```bash
echo -e 'cmd1\ncmd2\ncmd3\nexit' | mcp shell server
```

### 4. Use Shell Mode for Multiple Commands

- **1 command**: Individual call is fine
- **2+ commands**: Always use shell mode

### 5. Check Tool Schema First

```bash
# See what parameters a tool accepts
mcp tools bunx server --format json | grep -A20 '"name":"tool_name"'

# Or in table format
mcp tools bunx server
```

### 6. Test in Interactive Mode First

```bash
# Interactive debugging
mcp shell bunx server

# Then once working, convert to one-liner
```

## Troubleshooting

### "The browser/server is already running"

**Cause:** Previous instance still holding profile lock

**Fix:**
```bash
pkill -9 -f "server-name" 2>/dev/null
sleep 1
# Try again
```

### "Invalid arguments for tool"

**Possible causes:**

1. **Empty parameter bug** - Provide at least one optional param
2. **Wrong format** - Remove `{"arguments":{}}` wrapper
3. **Missing required param** - Check tool schema

**Debug:**
```bash
# Check tool schema
mcp tools bunx server --format json | grep -A30 '"name":"tool_name"'
```

### Commands Hanging/Timing Out

**Cause:** Server not responding, network issue, or infinite loop

**Fix:** Always use timeout:
```bash
timeout 30 mcp shell bunx server
```

### Multiple Failed Attempts

**Symptoms:** Trying the same command multiple times, each failing with lock errors

**Fix:** Use the optimized pattern:
```bash
pkill -9 -f "server-name" 2>/dev/null; sleep 1; \
echo -e 'COMMANDS\nexit' | timeout 30 mcp shell bunx server -- --isolated
```

## Examples

### Example 1: Check Web Console Errors

```bash
pkill -9 -f "chrome-devtools-mcp" 2>/dev/null; sleep 1; \
echo -e 'navigate_page {"url":"http://localhost:3000"}\nlist_console_messages {"pageIdx":0}\nexit' | \
timeout 30 mcp shell bunx -y chrome-devtools-mcp@latest -- --isolated
```

### Example 2: Full Web Debug Session

```bash
pkill -9 -f "chrome-devtools-mcp" 2>/dev/null; sleep 1; \
echo -e 'navigate_page {"url":"http://localhost:3000"}\nlist_console_messages {"pageIdx":0}\nlist_network_requests {"pageIdx":0}\ntake_snapshot {"verbose":true}\nexit' | \
timeout 30 mcp shell bunx -y chrome-devtools-mcp@latest -- --isolated
```

### Example 3: File System Operations

```bash
echo -e 'list_directory {"path":"."}\nread_file {"path":"README.md"}\nexit' | \
mcp shell npx @modelcontextprotocol/server-filesystem ~
```

### Example 4: Take Screenshot

```bash
pkill -9 -f "chrome-devtools-mcp" 2>/dev/null; sleep 1; \
echo -e 'navigate_page {"url":"https://example.com"}\ntake_screenshot {"fullPage":true,"format":"png"}\nexit' | \
timeout 30 mcp shell bunx -y chrome-devtools-mcp@latest -- --isolated
```

### Example 5: Execute JavaScript

```bash
pkill -9 -f "chrome-devtools-mcp" 2>/dev/null; sleep 1; \
echo -e 'navigate_page {"url":"http://localhost:3000"}\nevaluate_script {"function":"() => document.querySelectorAll(\"div\").length"}\nexit' | \
timeout 30 mcp shell bunx -y chrome-devtools-mcp@latest -- --isolated
```

## Common MCP Servers

### chrome-devtools-mcp
```bash
bunx -y chrome-devtools-mcp@latest
```
**Use cases:** Browser automation, web debugging, screenshots

### filesystem server
```bash
npx @modelcontextprotocol/server-filesystem /path/to/dir
```
**Use cases:** File operations, directory listings

### Custom servers
```bash
# Python server
python server.py

# Node server
node server.js

# Go binary
./server
```

## Performance Summary

| Approach | Time | Failures | Commands |
|----------|------|----------|----------|
| Individual calls (old way) | 60-90s | Multiple lock errors | 8-10 separate calls |
| Shell mode (new way) | 5-10s | Zero | 1 optimized call |
| **Improvement** | **6-9x faster** | **100% success rate** | **90% fewer commands** |

## Quick Reference

**Fastest pattern for any MCP server:**
```bash
pkill -9 -f "SERVER_PATTERN" 2>/dev/null; sleep 1; \
echo -e 'COMMAND1\nCOMMAND2\nexit' | \
timeout 30 mcp shell SERVER_COMMAND [FLAGS]
```

**Replace:**
- `SERVER_PATTERN` - Grep pattern to find server processes
- `COMMAND1`, `COMMAND2` - Your MCP tool calls
- `SERVER_COMMAND` - How to start the server (e.g., `bunx server@latest`)
- `[FLAGS]` - Server-specific flags (e.g., `-- --isolated`)

---

**Key Takeaways:**
1. Always cleanup before running commands
2. Use shell mode for 2+ commands
3. Provide at least one param for tools with optional-only schemas
4. Use timeout to prevent hangs
5. Batch commands in one session for 6-9x speed improvement
