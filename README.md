# Claude Skills Generator

Transform your AI conversation history (Claude or ChatGPT) into powerful, reusable Custom Skills that improve your AI workflow efficiency.

## Overview

This repository contains tools and prompts to analyze your Claude conversation patterns and automatically generate custom skills that match your specific workflows. Instead of repeating the same instructions, you can create specialized skills that Claude can automatically discover and use.

## What Are Claude Skills?

[Claude Skills](https://www.anthropic.com/news/skills) are reusable instruction sets that help Claude consistently produce high-quality outputs for tasks you perform repeatedly. Each skill includes:

- **SKILL.md**: Main skill file with YAML frontmatter for Claude's discovery
- **reference.md**: Detailed methodologies and frameworks
- **examples.md**: Practical examples and use cases
- **templates/**: Ready-to-use output templates
- **scripts/**: Utility scripts when applicable

## Quick Start

### 1. Export Your AI Conversation History

#### Option A: Claude Export
1. Go to [Claude.ai](https://claude.ai)
2. Click your profile in the bottom left
3. Go to "Settings" → "Privacy"
4. Click "Export data"
5. Wait for the email with instructions to download the export
6. Unzip the file - you'll use these files in Step 2.

#### Option B: ChatGPT Export
1. Go to [ChatGPT.com](https://chat.openai.com)
2. Click your profile → "Settings"
3. Go to "Data controls" → "Export data"
4. Select "Conversations" and any other data types
5. Wait for the email with download link
6. Download and unzip the export - you'll use these files in Step 2.

**Supported Files:**
- **Claude**: conversations.json, projects.json, users.json
- **ChatGPT**: conversations.json, shared_conversations.json, user.json, message_feedback.json, shopping.json, projects.json, users.json

**Note**: The system supports both single-platform and mixed exports. If you have conversations from both Claude and ChatGPT, place them in their respective directories - the analysis will automatically detect both platforms and perform cross-platform deduplication to avoid counting the same workflows twice.

### 2. Set Up the Analysis Environment

```bash
# Clone this repository
git clone https://github.com/hirefrank/claude-skills-generator.git
cd claude-skills-generator

# Copy your JSON files from Step 1 to the appropriate directories:

# For Claude exports:
cp /path/to/your/claude-export/*.json data-exports/claude/

# For ChatGPT exports:
cp /path/to/your/chatgpt-export/*.json data-exports/chatgpt/

# Or copy both if you have exports from both platforms
```

### 3. Run the Skills Discovery Analysis

#### Option A: Using Claude Code (Recommended)

1. Open Claude Code in this directory with **Claude Sonnet 4.5** or another reasoning model
2. Run the enhanced discovery prompt:
   ```
    run @analyze.md
   ```
3. Choose your preferred output option:
   - **Option B**: Complete Implementation Package (generates ready-to-use skills)
   - **Option C**: Incremental Implementation (start with top 3-5 skills)

**Note**: For best results, use Claude Sonnet 4.5 or another reasoning model, as the analysis requires complex pattern recognition and multi-step reasoning across large conversation datasets.

#### Option B: Using Claude.ai Web Interface

1. Switch to **Claude Sonnet 4.5** in the model selector
2. Copy the content of `analyze.md`
3. Paste it into a new Claude conversation
4. Upload your JSON files (conversations.json and any other available files)
5. Follow the generated analysis and recommendations

**Important**: Use Claude Sonnet 4.5 for optimal analysis quality, as it provides the reasoning capabilities needed for complex pattern detection and skill generation.

### 4. Deploy Your Generated Skills

If you chose Option B or C, you'll get complete skill folders ready to use:

```bash
# Your generated skills will be in folders like:
code-review-assistant/
├── SKILL.md
├── reference.md
├── examples.md
└── templates/

# Copy skills to your Claude Skills directory
# (Location varies by Claude setup)
```

## Understanding the Analysis Process

The enhanced discovery prompt follows a comprehensive 5-phase process with multi-platform support and generates organized, timestamped reports:

### Phase 1: Platform Detection & Data Processing
- Automatically detects Claude vs ChatGPT export format
- Extracts and normalizes data from both platforms
- Processes conversations, projects, user profiles, and platform-specific data
- Identifies explicit and implicit task patterns across all available data

### Phase 2: Frequency & Temporal Analysis
- Counts pattern occurrences across conversation history and additional data
- Identifies trends, seasonal patterns, and platform-specific behaviors
- Assesses business impact and time investment
- Analyzes shared conversations and feedback patterns (ChatGPT)

### Phase 3: Complexity & Standardization Assessment
- Evaluates task complexity and standardization potential
- Calculates skill-worthiness scores (0-10 scale)
- Determines automation value across platforms
- Considers cross-platform workflow patterns

### Phase 4: Relationship Mapping & Overlap Analysis
- Maps relationships between potential skills
- Identifies and resolves overlapping functionality
- Optimizes skill boundaries for clarity
- Accounts for platform-specific workflow differences

### Phase 5: Cross-Platform Deduplication (when both platforms detected)
- Eliminates duplicate patterns between ChatGPT and Claude exports
- Merges cross-platform workflows (e.g., research in ChatGPT → writing in Claude)
- Adjusts frequency counts to reflect actual usage patterns
- Creates platform-agnostic skills that work with any AI

### Phase 6: Skill Generation & Optimization
- Creates prioritization matrix
- Generates complete skill packages with proper structure
- Provides implementation roadmap and maintenance guidance
- Ensures skills work across both Claude and ChatGPT contexts

## Generated Output Structure

After analysis, you'll get organized outputs:

```
claude-skills-generator/
├── data-exports/                    # Your private conversation data
│   ├── chatgpt/                    # ChatGPT JSON files (git-ignored)
│   └── claude/                     # Claude JSON files (git-ignored)
├── reports/                        # Analysis reports (git-ignored)
│   └── 2025-01-23_22-40-00/       # Timestamped analysis session
│       ├── comprehensive-skills-analysis.md    # Complete analysis with evidence
│       └── implementation-guide.md             # Deployment roadmap
├── generated-skills/               # Ready-to-use skill packages
│   ├── newsletter-critique-specialist/
│   ├── business-communication-designer/
│   └── voice-consistency-checker/
├── skills-analysis-log.json        # Incremental processing data (git-ignored)
└── analyze.md
```

## Customization Options

### Analysis Prompts

- **[analyze.md](analyze.md)** - Complete analysis and generation system

### Output Options

When running the enhanced prompt, choose from:

- **Option A**: Analysis Report Only
- **Option B**: Complete Implementation Package (recommended)
- **Option C**: Incremental Implementation
- **Option D**: Custom Specification

### Skill Modification

Generated skills can be customized by:

1. **Editing SKILL.md**: Modify instructions and examples
2. **Updating templates**: Customize output formats
3. **Adding examples**: Include domain-specific scenarios
4. **Extending reference.md**: Add methodologies and frameworks

## Best Practices

### Before Analysis
- Export conversations after you have substantial Claude usage (100+ conversations recommended)
- Include diverse conversation types for comprehensive skill identification
- Review sensitive information - the analysis process anonymizes examples

### After Skill Generation
- Test each skill with representative inputs before deployment
- Start with highest-priority skills (3-5 initially)
- Gather team feedback if deploying organizationally
- Monitor usage and effectiveness for iterative improvement

### Maintenance
- Re-run analysis quarterly to identify new patterns
- Update skills based on usage feedback and changing needs
- Archive or consolidate skills that become redundant

## Privacy and Security

- **Your conversation data stays local** - JSON files are git-ignored
- **Analysis examples are anonymized** automatically
- **No sensitive information** is included in generated skills
- **Generated skills are safe to share** with teams

## Contributing

Found a bug or have suggestions for improving the analysis prompts?

1. Open an issue describing the problem or enhancement
2. Fork the repository and make your changes
3. Submit a pull request with a clear description
4. Share examples of improved skill generation results

## Troubleshooting

### Common Issues

**"No clear patterns found"**
- Ensure you have enough conversation history (100+ conversations)
- Try Option A first to see what patterns exist
- Consider conversations may be too diverse - focus analysis on specific domains

**"Skills seem too generic"**
- Your usage patterns may not be repetitive enough for skill creation
- Consider consolidating similar but infrequent tasks
- Focus on your most time-consuming or error-prone workflows

**"Generated skills overlap significantly"**
- The analysis should handle this automatically in Phase 4
- If overlaps remain, manually consolidate using the overlap resolution guidance
- Consider whether separate skills serve different contexts

## License

MIT License - Feel free to use, modify, and distribute for personal and commercial use.

## Acknowledgments

- Built for use with Anthropic's Claude AI assistant
- Inspired by the need for more efficient AI workflows
- Developed through analysis of real-world Claude usage patterns
