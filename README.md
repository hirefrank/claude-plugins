# hirefrank Marketplace

The official hirefrank marketplace where I share my AI workflow tools and productivity plugins. Featuring specialized Claude Code plugins for AI analysis and Cloudflare Workers development.

## Available Plugins

### 🔍 Claude Skills Analyzer
**Plugin ID**: `claude-skills-analyzer`

Analyzes your AI conversation exports (Claude, ChatGPT) to automatically generate reusable Custom Skills based on your actual usage patterns.

**Key Features:**
- Cross-platform analysis (Claude + ChatGPT)
- Pattern recognition and workflow automation
- Smart deduplication across platforms
- Complete skill package generation
- Incremental processing for efficiency

**Usage**:
- `/skills-setup` - Get setup guidance and export instructions
- `/analyze-skills` - Run the main conversation analysis
- `/skills-troubleshoot` - Diagnose and fix common issues

[📖 Full Documentation](./plugins/claude-skills-analyzer/README.md)

### ⚡ Edge Stack
**Plugin ID**: `edge-stack`

Complete full-stack development toolkit optimized for edge computing. Build modern web applications with Nuxt 4, Cloudflare Workers, Polar.sh billing, better-auth authentication, and Nuxt UI design system.

**Key Features:**
- 22 specialized agents (all with MCP integration)
- 12 autonomous SKILLs (continuous validation)
- 18 workflow commands (including setup wizards)
- **4 bundled MCP servers** (Cloudflare, Nuxt UI, better-auth, Polar) - no manual setup required
- **Bundled statusline** - at-a-glance development context
- **Documentation validation** - keeps docs in sync with code
- Distinctive design system preventing generic "AI aesthetics"

**Usage**:
- `/es-billing-setup` - Interactive Polar.sh billing integration
- `/es-auth-setup` - Interactive authentication configuration
- `/es-component` - Generate distinctive UI components
- `/es-commit` - Auto-commit with generated messages
- `/es-validate` - Comprehensive validation before commit

[📖 Full Documentation](./plugins/edge-stack/README.md)

## Quick Start

### Standard Installation
Run Claude and add the marketplace:

```bash
/plugin marketplace add hirefrank/hirefrank-marketplace
```

Then install a plugin:

```bash
/plugin install claude-skills-analyzer
# or
/plugin install edge-stack
```

### One-Command Installation
Use the [Claude Plugins CLI](https://claude-plugins.dev) to skip the marketplace setup:

```bash
npx claude-plugins install @hirefrank/hirefrank-marketplace/claude-skills-analyzer
```

This automatically adds the marketplace and installs the plugin in a single step.

## Quick Start Guide

### For Claude Skills Analyzer:
```shell
# 1. Install the plugin
/plugin install claude-skills-analyzer

# 2. Follow the interactive setup
/skills-setup

# 3. Run the analysis
/analyze-skills
```

See the [full Quick Start guide](./plugins/claude-skills-analyzer/README.md#quick-start) for detailed instructions including export steps and skill installation.

### For Edge Stack:
```shell
# 1. Install the plugin
/plugin install edge-stack

# 2. Setup billing integration
/es-billing-setup

# 3. Setup authentication
/es-auth-setup

# 4. Generate a component
/es-component button PrimaryButton --animations rich

# 5. Validate and commit
/es-validate
/es-commit
```

See the [full documentation](./plugins/edge-stack/README.md) for detailed instructions including all 22 agents, 18 commands, 12 SKILLs, and 4 MCP servers.

## Plugin Categories

- **🎯 Productivity**: Tools for workflow optimization and automation
- **📊 Analysis**: Data processing and pattern recognition tools
- **🔧 Development**: Code and project management utilities

## Planned Plugins

Future plugins in development:
- **conversation-summarizer**: Generate executive summaries from meeting transcripts
- **code-pattern-extractor**: Identify reusable code patterns from projects
- **writing-style-analyzer**: Analyze and replicate writing styles across content

## Contributing

### Suggesting New Plugins
Have an idea for a plugin? [Open an issue](https://github.com/hirefrank/hirefrank-marketplace/issues) with:
- Plugin concept and use case
- Expected input/output formats
- Target user workflow

### Plugin Development
Interested in contributing? Check out:
- [Claude Code Plugin Documentation](https://docs.anthropic.com/en/docs/claude-code/plugins)
- Plugin development guidelines in each plugin directory
- Code standards and testing requirements

### Feedback & Issues
- 🐛 **Bug Reports**: [GitHub Issues](https://github.com/hirefrank/hirefrank-marketplace/issues)
- 💡 **Feature Requests**: [GitHub Discussions](https://github.com/hirefrank/hirefrank-marketplace/discussions)
- 📧 **Direct Contact**: frank@hirefrank.com

## Repository Structure

```
hirefrank-marketplace/
├── .claude-plugin/
│   └── marketplace.json     # Marketplace configuration
├── plugins/
│   ├── claude-skills-analyzer/
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json
│   │   ├── commands/
│   │   ├── skills/
│   │   └── README.md
│   └── edge-stack/
│       ├── .claude-plugin/
│       │   └── plugin.json
│       ├── .claude-code/
│       │   └── statusline.json
│       ├── agents/        # 22 specialized agents
│       ├── commands/      # 18 workflow commands
│       ├── skills/        # 12 autonomous SKILLs
│       └── README.md
├── docs/                    # Shared documentation
├── examples/               # Usage examples
└── README.md              # This file
```

## License

All plugins are released under MIT License - feel free to use, modify, and distribute for personal and commercial use.
