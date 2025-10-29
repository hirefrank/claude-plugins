# Claude Skills Analyzer Plugin

Analyzes your AI conversation exports (Claude, ChatGPT) to automatically generate reusable Custom Skills based on your actual usage patterns.

## Overview

Transform your conversation history into actionable Claude Skills! This plugin performs sophisticated analysis of your AI interactions to identify recurring patterns, evaluate their automation potential, and generate complete, ready-to-use Custom Skills packages.

**Architecture**: Uses a modular design with [shared analysis methodology](./shared/analysis-methodology.md) powering both export-based analysis and tool-based pattern detection.

## Prerequisites

- **Claude Code** - [Installation instructions](https://docs.anthropic.com/en/docs/claude-code)
- **Conversation Exports** - For export-based analysis (`/analyze-skills`):
  - Claude conversation exports (JSON format) - **Note:** Only includes claude.ai web conversations, not Claude Code conversations
  - ChatGPT conversation exports (JSON format)
  - Or both for cross-platform analysis
  - At least 20+ conversations for basic analysis (50+ recommended for robust patterns)

## Installation

```shell
# Add the marketplace (if not already added)
/plugin marketplace add hirefrank/hirefrank-marketplace

# Install this plugin
/plugin install claude-skills-analyzer

# Restart Claude Code to activate
```

## Components

### 📦 Commands (Claude Code)
- **`/analyze-skills`**: Export-based comprehensive analysis
- **`/skills-setup`**: Setup guidance and directory creation
- **`/skills-troubleshoot`**: Problem diagnosis and fixes

### 🎯 Skills (Web + Claude Code)
- **`workflow-pattern-analyzer`**: Tool-based analysis (Claude Code only - modular)
- **`workflow-pattern-analyzer-web`**: Tool-based analysis (Web + Claude Code - self-contained)
- **`conversation-analyzer`**: Base analysis capability

### 🧩 Shared Methodology
All components use the [shared analysis methodology](./shared/analysis-methodology.md):
- 5-dimensional scoring framework (0-50 composite scale)
- Pattern discovery and classification
- Relationship mapping and consolidation
- Prioritization matrix generation
- Quality standards and validation

## Features

### 🔄 Cross-Platform Intelligence
- Unified analysis of Claude and ChatGPT data
- Smart deduplication of cross-platform workflows
- Platform preference insights
- Generates platform-agnostic skills

### 📊 Statistical Rigor
- 5-dimensional skill-worthiness scoring (frequency, consistency, complexity, time savings, error reduction)
- Pattern validation with significance thresholds
- Evidence-based recommendations with conversation excerpts
- Temporal analysis and usage trends

### ⚡ Incremental Processing (Export Analysis)
- Skip previously analyzed conversations
- Process only new or modified data
- Maintain analysis logs for efficiency
- Build on previous analysis results

### 🎯 Data-Driven Domain Discovery
- **No predefined categories**: Patterns emerge from actual usage instead of forcing into business/coding/writing buckets
- **Niche specialization detection**: Explicitly searches for hobbyist, creative, prompt engineering, learning, and lifestyle patterns
- **Domain diversity validation**: Ensures analysis spans 6+ distinct topic areas
- **Specialized vocabulary tracking**: Identifies domain-specific language (strain names, recipe terms, art styles, game mechanics)
- **Quality indicators**: Tracks recurring formats, user expertise growth, and high-engagement patterns

This addresses user feedback where diverse interests (recipes, cannabis, image generation, game design) were previously overlooked in favor of traditional domains.

## Quick Start

### 1. Get Setup Guidance

```shell
/skills-setup
```

This command will:
- Create the necessary directory structure automatically
- Walk you through exporting from Claude and ChatGPT
- Explain privacy and security features
- Show you what to expect from analysis

### 2. Export Your Conversations

Export your conversation history from Claude and/or ChatGPT. The `/skills-setup` command provides detailed step-by-step instructions, or see the [Exporting Your Conversations](#exporting-your-conversations) section below for complete details.

### 3. Run the Analysis

```shell
/analyze-skills
```

Choose from output options:
- **Option A**: Analysis report only
- **Option B**: Complete implementation package (recommended)
- **Option C**: Incremental implementation (top 3-5 skills)
- **Option D**: Custom specification

The analysis will automatically create the `reports/` and `generated-skills/` directories as needed.

### 4. Install Your Generated Skills

After analysis completes, you'll have custom skills in the `generated-skills/` directory. Here's how to use them:

> **Learn more about Skills**: [What are Skills?](https://support.claude.com/en/articles/12512176-what-are-skills) | [How to Create Custom Skills](https://support.claude.com/en/articles/12512198-how-to-create-custom-skills)

#### In Claude Code

Claude automatically discovers skills from:
- **Personal skills**: `~/.claude/skills/` (available across all projects)
- **Project skills**: `.claude/skills/` (shared with your team via git)
- **Plugin skills**: bundled with installed plugins

**Option 1: Copy to Personal Skills Directory**
```shell
# Copy a generated skill to your personal Claude Code skills directory
cp -r generated-skills/skill-name ~/.claude/skills/
```

**Option 2: Copy to Project Skills Directory**
```shell
# Copy to project directory to share with your team
cp -r generated-skills/skill-name .claude/skills/
```

**Option 3: Symlink for Easy Updates**
```shell
# Create a symlink to keep skills in your project
ln -s $(pwd)/generated-skills/skill-name ~/.claude/skills/skill-name
```

**Using the skill:**

Skills are **model-invoked** - Claude automatically decides when to use them based on your request and the skill's description. Simply ask questions or make requests that match what the skill does:
- "Help me with [task that matches skill description]"
- Use trigger phrases from the skill's description
- Claude will automatically load and apply the skill when relevant

**Tip**: Ask "What skills are available?" to see all your installed skills.

> **Source**: [Claude Code Skills Documentation](https://docs.claude.com/en/docs/claude-code/skills.md)

#### In Claude.ai Web Interface

**Requirements**: 
- Available for Pro, Max, Team, and Enterprise plans
- **Code execution must be enabled** in Settings > Capabilities

**Step 1: Package Your Skill**
```shell
# Create a properly structured ZIP file
cd generated-skills
zip -r skill-name.zip skill-name/
```

**Important**: The ZIP must contain the skill folder as its root, not files directly in the ZIP.

**Correct structure:**
```
skill-name.zip
└── skill-name/
    ├── SKILL.md
    ├── reference.md
    └── templates/
```

**Step 2: Upload to Claude**
1. Click your initials in the lower left corner
2. Go to **Settings > Capabilities**
3. Ensure **"Code execution and file creation"** is enabled
4. In the Skills section, click **"Upload skill"**
5. Upload the `skill-name.zip` file

**Note**: Custom skills you upload are private to your individual account.

**Step 3: Enable and Use Your Skill**

After upload, toggle the skill on using the switch next to it in Settings > Capabilities. Claude automatically determines when to use your skill based on the **description** in the YAML frontmatter. Simply make requests that match what the skill does:
- "Help me with [task that matches skill description]"
- Use trigger phrases from the skill description
- Claude will automatically load and apply the skill when relevant

**Note**: Skills activate automatically based on context - no slash commands needed.

**Single-file alternative**: You can upload just `SKILL.md`, but you'll lose supporting documentation (`reference.md`, `examples.md`) and templates.

> **Source**: [Using Skills in Claude](https://support.claude.com/en/articles/12512180-using-skills-in-claude) | [How to Create Custom Skills](https://support.claude.com/en/articles/12512198-how-to-create-custom-skills)

#### How Skills Work

Skills use **progressive disclosure** - Claude reviews available skills, loads only relevant ones, and applies their instructions when needed. Your skill's description (max 200 characters) is critical because Claude uses it to determine when to invoke your skill.

**Generated skill structure**:
```
skill-name/
├── SKILL.md           # Main skill with YAML frontmatter
├── reference.md       # Detailed methodology (loaded when needed)
├── examples.md        # Additional use cases
└── templates/         # Reusable output templates
```

#### Testing Your Skills

**Before uploading:**
- Review `SKILL.md` for clarity
- Verify the description accurately reflects when Claude should use it (max 200 characters)
- Ensure the name field uses only lowercase letters, numbers, and hyphens (max 64 characters)
- Test trigger phrases align with the description

**After uploading:**
1. Enable the skill using the toggle switch in Settings > Capabilities
2. Try prompts that should trigger it
3. Check if Claude loads the skill (visible in expanded thinking when available)
4. Iterate on the description if Claude doesn't invoke it as expected

**Pro tip**: Start with your highest-impact skills (Option C: top 3-5) rather than implementing all at once.

> **YAML Requirements**: [How to Create Custom Skills](https://support.claude.com/en/articles/12512198-how-to-create-custom-skills)

### 5. Troubleshoot if Needed

```shell
/skills-troubleshoot
```

Get help diagnosing issues like:
- Missing conversation files
- JSON parsing errors
- Analysis producing no patterns
- Plugin installation problems
- Skill installation or activation issues

## Exporting Your Conversations

Before running analysis, you'll need to export your conversation history from Claude and/or ChatGPT.

### From Claude

**Step 1: Request Export**
1. Click your initials in the lower left corner of claude.ai
2. Select **"Settings"** from the menu
3. Navigate to **"Privacy"** section
4. Click **"Export data"** button

**Step 2: Wait for Email**
- You'll receive a download link via email once the export is processed
- The download link expires 24 hours after delivery
- You must be signed in to your account to download

**Step 3: Extract and Save**
1. Download the ZIP file from the email
2. Extract all files (you'll get `conversations.json`, `projects.json`, etc.)
3. Save these files to your `data-exports/claude/` folder (created by `/skills-setup`)

**Files included:**
- `conversations.json` - Your conversation history
- `projects.json` - Project information and metadata  
- `users.json` - Account information

> **Source**: [How can I export my Claude data?](https://support.claude.com/en/articles/9450526-how-can-i-export-my-claude-data)

### From ChatGPT

**Step 1: Request Export**
1. Sign in to ChatGPT
2. Click your profile icon in the top right corner
3. Click **"Settings"**
4. Click **"Data Controls"** menu
5. Under Export Data, click **"Export"**
6. Click **"Confirm export"** in the confirmation screen

**Step 2: Wait for Email**
- The downloadable ZIP file will be sent to your registered email address
- The download link expires 24 hours after delivery
- Export may take some time depending on the amount of data

**Step 3: Extract and Save**
1. Download the ZIP file from the email
2. Extract all files (you'll get `conversations.json`, `user.json`, etc.)
3. Save these files to your `data-exports/chatgpt/` folder (created by `/skills-setup`)

**Files included:**
- `conversations.json` - Your conversation history (including shared conversations)
- `user.json` - Account information
- `shared_conversations.json` - Shared conversations metadata
- `message_feedback.json` - Your feedback on responses

> **Source**: [How do I export my ChatGPT history and data?](https://help.openai.com/en/articles/7260999-how-do-i-export-my-chatgpt-history-and-data)

### Troubleshooting Exports

**Can't find Settings?**
- **Claude**: Click your initials (lower left corner) → Settings → Privacy
- **ChatGPT**: Click profile icon (top right corner) → Settings → Data Controls

**Export not arriving?**
- Check spam/junk email folder
- Remember: Links expire 24 hours after being sent
- Request a new export if the link has expired

**Files look different?**
- Export formats can vary slightly between updates
- As long as you have `conversations.json`, the analysis will work

## Generated Output

All output is automatically organized in your project directory:

### Analysis Reports
Located in `reports/{timestamp}/`:
- **comprehensive-skills-analysis.md** - Complete pattern analysis with evidence
- **implementation-guide.md** - Actionable deployment roadmap
- **skills-analysis-log.json** - Machine-readable data for incremental processing

### Skill Packages
Located in `generated-skills/skill-name/`:
```
skill-name/
├── SKILL.md           # Main skill with YAML frontmatter
├── reference.md       # Detailed methodology and frameworks
├── examples.md        # Real-world usage examples
└── templates/         # Reusable output templates
```

**Note**: These directories are automatically created when needed.

## Quality Standards

All components follow the [shared quality standards](./shared/analysis-methodology.md#quality-standards):

- **Statistical significance**: Patterns must occur in >5% of conversations OR >3 instances
- **Consistency threshold**: 70%+ similarity across instances
- **Time savings focus**: Target >30 min/week cumulative automation potential
- **Evidence-based**: Minimum 2-3 conversation excerpts per pattern
- **Maximum focus**: Generate 8-12 high-impact skills (recommend top 5-8 for initial implementation)
- **No generic patterns**: Avoid broad categories like "writing" or "analysis"

## Example Use Cases

### Business Communication
Identifies email drafting, proposal writing, and client communication patterns.

### Code Review Workflows
Recognizes systematic code analysis and documentation patterns.

### Content Creation
Discovers newsletter writing, blog structures, and social media workflows.

### Research & Analysis
Finds research methodologies and report generation patterns.

## Data Privacy

- **Local processing**: All analysis on your machine
- **No data upload**: Exports never leave your system
- **Anonymized output**: Generated skills remove sensitive info
- **Gitignored exports**: Auto-excluded from version control

## Analysis Approaches

### Export-Based Analysis (Claude Code only)
**Command**: `/analyze-skills`

**Best for:**
- Complete conversation history analysis (100+ conversations)
- Cross-platform analysis (Claude + ChatGPT)
- Incremental processing of large datasets
- Historical trend analysis

**Requirements:**
- Conversation export JSON files
- Claude Code environment

### Tool-Based Analysis (Web + Claude Code)
**Skills**: `workflow-pattern-analyzer` (modular) | `workflow-pattern-analyzer-web` (self-contained)

**Best for:**
- Quick pattern detection without exports
- Web interface users
- Recent conversation analysis
- Iterative skill discovery

**Requirements:**
- No exports needed
- Uses `recent_chats` and `conversation_search` tools

**Choose your version:**
- **Web Compatible**: [workflow-pattern-analyzer-web](./skills/workflow-pattern-analyzer-web/) - Single file for claude.ai upload
- **Modular**: [workflow-pattern-analyzer](./skills/workflow-pattern-analyzer/) - References shared methodology (Claude Code only)

## Available Commands

### `/analyze-skills`
**Export-based analysis** - Performs comprehensive conversation analysis from JSON exports and generates Custom Skills based on your complete usage patterns.

### `/skills-setup`
**Setup guidance** - Complete walkthrough for:
- Directory structure creation
- Conversation export instructions (Claude & ChatGPT)
- Privacy and security information
- Expected results and pro tips

### `/skills-troubleshoot`
**Problem diagnosis** - Helps resolve common issues like:
- Missing or invalid conversation files
- JSON parsing errors
- Analysis producing no patterns
- Plugin installation problems
- Permission and directory issues

## Quick Troubleshooting

For immediate help with setup or issues:
```shell
/skills-setup      # Complete setup guide
/skills-troubleshoot  # Diagnose and fix problems
```

For detailed troubleshooting, the `/skills-troubleshoot` command provides comprehensive diagnostics and solutions.

## Technical Details

### Supported Export Formats

**Claude Export Structure:**
- `conversations.json` - Message history with metadata
- `projects.json` - Project workflows and documentation
- `users.json` - Account information for context

**⚠️ Important:** Claude exports from claude.ai **DO NOT include Claude Code conversations**. Only web interface (claude.ai) conversations are exported. Claude Code conversations are stored separately and not included in data exports.

**ChatGPT Export Structure:**
- `conversations.json` - Conversation history with mapping
- `user.json` - User profile information
- `shared_conversations.json` - Shared conversation metadata
- `message_feedback.json` - Response feedback (optional)

### Analysis Methodology

All analysis components use the [shared methodology](./shared/analysis-methodology.md):

**Core Phases:**
1. **Pattern Discovery**: Explicit, implicit, domain, and temporal pattern detection
2. **Frequency Analysis**: Statistical validation with significance thresholds
3. **Skill-Worthiness Scoring**: 5-dimensional evaluation (0-50 composite scale)
4. **Relationship Mapping**: Overlap detection and consolidation strategies
5. **Prioritization**: Frequency vs impact matrix generation
6. **Skill Generation**: Complete package creation with progressive disclosure

**Export-Specific Enhancements:**
- Phase 0: Incremental processing with analysis logs
- Phase 5: Cross-platform deduplication (ChatGPT + Claude)

## Contributing

Issues and suggestions for this plugin:
- [Plugin Issues](https://github.com/hirefrank/hirefrank-marketplace/issues?q=label:claude-skills-analyzer)
- [Feature Requests](https://github.com/hirefrank/hirefrank-marketplace/discussions)

## Architecture

The plugin uses a modular architecture:

```
claude-skills-analyzer/
├── commands/               # Claude Code commands
│   ├── analyze-skills.md   # Export-based analysis
│   ├── skills-setup.md     # Setup guidance
│   └── skills-troubleshoot.md
├── skills/                 # Standalone skills
│   ├── conversation-analyzer/
│   ├── workflow-pattern-analyzer/      # Modular (Claude Code)
│   └── workflow-pattern-analyzer-web/  # Self-contained (Web + Claude Code)
├── shared/                 # Shared components
│   └── analysis-methodology.md     # Core analysis framework
└── README.md
```

**Benefits:**
- Modular components share methodology (no duplication in Claude Code)
- Web-compatible version for universal platform support
- Consistent analysis quality across all tools
- Easy to maintain and extend
- Choose architecture based on your deployment needs

## Version History

- **v1.3.0**: Enhanced pattern detection with data-driven domain discovery
  - Removed prescriptive categorization (coding, writing, business, analysis)
  - Added niche pattern detection (hobbyist, creative, prompt engineering, learning, lifestyle)
  - Domain diversity validation (6+ distinct topic areas)
  - Specialized vocabulary tracking and quality indicators
  - Better detection of low-frequency but high-value patterns
- **v1.2.0**: Added web-compatible workflow-pattern-analyzer-web skill for universal platform support
- **v1.1.0**: Added modular architecture with shared methodology and workflow-pattern-analyzer skill
- **v1.0.0**: Initial release with cross-platform analysis

## License

MIT License - see [LICENSE](../../LICENSE) for details.
