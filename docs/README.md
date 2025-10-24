# Documentation

General documentation and guides for working with this codebase.

## Available Guides

### [MCP CLI Guide](./mcp-cli.md)

Comprehensive guide to using the MCP CLI (`mcptools`) for interacting with Model Context Protocol servers.

**Topics covered:**
- Installation and setup
- Command syntax and argument order
- Common pitfalls and solutions
- Performance optimization patterns (6-9x speedup)
- Server instance management
- Best practices
- Troubleshooting guide
- Real-world examples

**Key learnings:**
- Shell mode is 6-9x faster than individual calls
- Always cleanup before running commands to avoid locks
- Use timeout to prevent hanging
- Batch multiple commands in one session
- Parameter format quirks and workarounds

**Referenced by:**
- `skills/chrome-devtools/` - Browser automation skill

---

## Contributing

When creating new skills or tools that use MCP servers, reference these guides to avoid common pitfalls and use optimized patterns from the start.
