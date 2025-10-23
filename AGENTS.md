# Agent Guidelines for claude_skills

## Project Overview
A Python-based system for analyzing AI conversation history and generating reusable Custom Skills. The project consists of markdown files, Python utility scripts, and generated skill definitions.

## Build & Test Commands
- **Python scripts**: Run directly with `python scripts/state_manager.py [options]`
  - `--stats`: Show processing statistics
  - `--cleanup`: Clean up old backups
  - `--clear-cache`: Clear analysis cache
- **Log analyzer**: `python generated-skills/debug-detective/scripts/log-analyzer.py <logfile>`
- **No formal build/test framework**: Tests are manual or via Claude Code CLI

## Code Style Guidelines

### Python
- Use type hints (`from typing import Dict, List, Optional, Any`)
- Follow PEP 8: 4-space indentation, snake_case for functions/variables
- Error handling: Use try-except with specific exceptions; log errors via print() with context
- Docstrings: Module-level and function-level triple-quoted strings for public APIs
- Imports: Standard library first, then third-party, then local modules; one import per line
- Class design: Use dataclass or explicit `__init__` methods; document all public methods

### Markdown (Skill Definitions)
- SKILL.md: YAML frontmatter at top, followed by markdown content with clear sections
- Use Markdown for formatting; keep descriptions concise
- Templates: Place in `templates/` directory with descriptive filenames
- Examples: Place in `examples.md` with real-world scenarios

### File Structure
- Skills live in `generated-skills/<skill-name>/` with SKILL.md, reference.md, examples.md
- Utility scripts in `scripts/` directory with executable shebang (`#!/usr/bin/env python3`)
- State management: JSON files in `state/`, `config/`, `backups/` directories

### JSON Data Handling
- Use `json.load()` with proper error handling (JSONDecodeError, IOError)
- Atomic writes: Write to temp file, then replace original
- Include version fields (`"version": "1.0"`) in all state files
- UTF-8 encoding for all file operations

### Naming Conventions
- Files: lowercase with hyphens (e.g., `state_manager.py`, `log-analyzer.py`)
- Classes: PascalCase (e.g., `StateManager`)
- Methods/functions: snake_case (e.g., `is_conversation_processed()`)
- Constants: UPPER_SNAKE_CASE
- Private methods: prefix with underscore (e.g., `_load_json()`)

## Notes for Agents
- This is a non-build system: No npm/pip install step, direct Python execution
- Conversation data (*.json exports) should be .gitignored; analysis is local
- Skills are documentation-first; Python scripts are supporting utilities
- Focus on robustness: Atomic file writes, backups, graceful error handling
