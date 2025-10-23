---
name: conversation-analyzer
description: Analyzes AI conversation exports to identify recurring patterns and generate custom Claude Skills. Use when analyzing conversation data, identifying workflow patterns, or creating reusable AI skills from usage history.
---

# Conversation Analyzer

## Instructions

This skill provides specialized capability for analyzing AI conversation exports (Claude, ChatGPT) to identify recurring patterns and generate reusable Custom Skills.

1. **Data Processing & Pattern Discovery**
   - Auto-detect platform format (Claude vs ChatGPT exports)
   - Parse conversation histories, project data, and user information
   - Extract expertise indicators and usage patterns
   - Categorize patterns by domain (coding, writing, business, analysis)
   - Identify task types (creation, transformation, analysis, troubleshooting)

2. **Frequency & Temporal Analysis**
   - Count pattern occurrences across conversation history
   - Calculate temporal distribution and frequency trends
   - Cross-reference with project data for validation
   - Assess business impact and time investment patterns

3. **Skill-Worthiness Evaluation** (0-10 scale scoring):
   - **Frequency**: How often does this task occur?
   - **Consistency**: How similar are requirements each time?
   - **Complexity**: Would a skill meaningfully improve quality?
   - **Time savings**: How much effort would a skill save?
   - **Error reduction**: Common pitfalls a skill could prevent?

4. **Cross-Platform Deduplication** (when both platforms present):
   - Detect semantic similarity across platforms
   - Identify cross-platform workflows vs genuine duplicates
   - Merge evidence while preserving platform preferences
   - Recalculate frequencies after deduplication

5. **Skill Generation & Optimization**
   - Create prioritization matrix (frequency vs. value/impact)
   - Resolve overlaps and optimize skill boundaries
   - Generate complete skill packages with YAML frontmatter
   - Provide implementation roadmap and testing guidance

## Quality Standards

- Focus on patterns with >5% conversation frequency
- Require 70%+ consistency across pattern instances
- Target >30 min/week time savings potential
- Maximum 8 skills total (highest-impact only)
- Platform-agnostic skill design
- Evidence-based recommendations with conversation excerpts

## Examples

### Analyzing Claude Export
**User Request**: "Analyze my Claude conversations to find skill opportunities"

**Response**: 
```
I'll analyze your Claude conversation export to identify recurring patterns. Let me:

1. Parse your conversations.json and projects.json files
2. Identify frequent task patterns across your usage
3. Evaluate each pattern for skill-worthiness
4. Generate prioritized recommendations for Custom Skills

Please ensure your export files are in data-exports/claude/ directory.
```

### Cross-Platform Analysis
**User Request**: "I have both Claude and ChatGPT exports - analyze them together"

**Response**:
```
I'll perform cross-platform analysis to identify your workflow patterns:

1. Process both Claude and ChatGPT conversation data
2. Detect and handle cross-platform duplicates
3. Identify platform preferences for different task types
4. Create unified skills that work across AI platforms
5. Provide platform-agnostic skill recommendations

This will give you the most accurate picture of your AI usage patterns.
```

For more examples, see [examples.md](examples.md).
For detailed methodology, see [reference.md](reference.md).