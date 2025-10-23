# Agent Guidelines for claude_skills

## Project Overview
A documentation-focused project for analyzing AI conversation exports (Claude/ChatGPT) and generating reusable Custom Skills. Primarily markdown-based with analysis workflows executed via Claude Code CLI.

## Build & Test Commands
- **Main workflow**: Use Claude Code CLI with `run @enhanced-skills-discovery-prompt.md`
- **No formal build system**: Direct analysis via uploaded JSON exports
- **Testing**: Manual validation of generated skills against conversation patterns
- **Single test**: N/A - this is a prompt-based analysis system, not executable code

## Code Style Guidelines

### Python (Future Utility Scripts)
- Use type hints (`from typing import Dict, List, Optional, Any`)
- Follow PEP 8: 4-space indentation, snake_case for functions/variables
- Error handling: Use try-except with specific exceptions; log errors via print() with context
- Docstrings: Module-level and function-level triple-quoted strings
- Imports: Standard library first, then third-party, then local modules; one import per line
- Use `#!/usr/bin/env python3` shebang for executable scripts

### Markdown (Skill Definitions)
- SKILL.md: YAML frontmatter at top, followed by markdown content with clear sections
- Use Markdown for formatting; keep descriptions concise
- Templates: Place in `templates/` directory with descriptive filenames
- Examples: Place in `examples.md` with real-world scenarios

### File Structure
- **Data exports**: Place in `data-exports/claude/` or `data-exports/chatgpt/` directories
- **Generated skills**: Create in root or subdirectories with SKILL.md, reference.md, examples.md structure
- **Analysis reports**: Generated in `reports/` directory (gitignored for privacy)
- **Core files**: Enhanced prompt in root, supporting docs as markdown

### Data Privacy & Security
- **Never commit user data**: All .json exports are gitignored automatically
- **Anonymize examples**: Remove personal/sensitive info from generated skills
- **Local analysis only**: User conversation data stays on local machine
- **Safe sharing**: Generated skills should contain no sensitive information

### Naming Conventions
- **Skill directories**: lowercase-with-hyphens (e.g., `code-review-assistant/`)
- **Markdown files**: SKILL.md, reference.md, examples.md (standardized names)
- **Analysis files**: descriptive-name-analysis.md or *-analysis-log.json
- **Data exports**: Keep original platform naming conventions from exports

## Notes for Agents
- **Prompt-based system**: Primary workflow is running enhanced-skills-discovery-prompt.md via Claude Code
- **No build process**: Analysis happens through Claude conversation, not executable code
- **Privacy-first**: All user exports (.json files) are gitignored and must stay local
- **Output focus**: Generate complete skill packages (SKILL.md + supporting files) ready for Claude use
