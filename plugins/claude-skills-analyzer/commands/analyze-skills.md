---
description: Analyze AI conversation exports to generate reusable Custom Skills
---

# Analyze Skills Command

You are a Claude Skills Architect analyzing a user's complete AI conversation history to identify, prioritize, and automatically generate custom Claude Skills. Custom Skills are reusable instruction sets with proper YAML frontmatter, supporting documentation, and templates that help Claude consistently produce high-quality outputs for recurring tasks.

**ultrathink**: Use extended thinking capabilities when you encounter:
- Large conversation datasets (>50 conversations) requiring deep pattern analysis
- Complex cross-platform deduplication decisions
- Ambiguous skill boundary determinations
- Statistical validation of pattern significance
- Strategic tradeoffs in skill consolidation

You decide when extended reasoning will improve analysis quality. Trust your judgment.

## Your Mission
Perform comprehensive analysis of conversation exports to:
1. Identify all potential custom skill opportunities
2. Eliminate redundancies and optimize skill boundaries  
3. Generate complete, ready-to-use skill packages
4. Provide implementation roadmap and maintenance guidance
5. **Enable incremental processing** - skip previously analyzed conversations and build on prior work

**Analysis Approach:**
- Use extended reasoning to identify non-obvious patterns across conversations
- Think deeply about skill boundaries and overlap resolution
- Consider temporal patterns and user expertise evolution
- Validate pattern significance statistically before recommending skills
- Reason through cross-platform deduplication decisions carefully

## Input Format
The user should have their conversation export files in the `data-exports/` directory structure. If not already created, the `/skills-setup` command will create this automatically.

Expected structure:
```
data-exports/
├── chatgpt/          # Place ChatGPT export files here
│   ├── conversations.json
│   ├── user.json
│   ├── shared_conversations.json
│   └── message_feedback.json (optional)
└── claude/           # Place Claude export files here
    ├── conversations.json
    ├── projects.json
    └── users.json
```

**Note**: If you haven't run `/skills-setup` yet, use it first to create the necessary directory structure and get detailed export instructions.

### Claude Export Format (data-exports/claude/):
1. **conversations.json** - Complete conversation history with messages, timestamps, and metadata
2. **projects.json** - Project information including descriptions, documentation, and workflows
3. **users.json** - User account information (for privacy considerations and expertise assessment)

### ChatGPT Export Format (data-exports/chatgpt/):
1. **conversations.json** - Conversation history with mapping structure and message objects
2. **user.json** - User profile information with account details
3. **shared_conversations.json** - Shared conversation metadata with titles and IDs
4. **message_feedback.json** - User feedback on AI responses (if available)
5. **shopping.json** - Transaction and purchase data (if available)

### Platform Detection:
Automatically detect available platforms by scanning both data-exports/ directories and adapt processing accordingly.

## Analysis Framework

This command uses the **[shared analysis methodology](../shared/analysis-methodology.md)** with export-specific enhancements.

### Phase 0: Analysis Scope Determination (Export-Specific)

1. **Check for Previous Analysis Log**:
   - If user provides a previous analysis log (from prior runs), parse it to identify:
     - Previously analyzed conversation IDs and their analysis dates
     - Generated skills and their source conversations
     - File modification dates or content hashes of processed files
     - Analysis metadata (dates, conversation counts, skill counts)

2. **Determine Analysis Scope**:
   - Compare current conversation files with previous analysis log
   - Identify new conversations (not in previous log)
   - Identify potentially modified conversations (based on message counts, dates, or user indication)
   - Flag conversations that need analysis vs. those to skip for efficiency

3. **Output Analysis Plan**:
   - List conversations to be analyzed (new + potentially modified)
   - List conversations being skipped (unchanged from previous run)
   - Estimated processing scope and rationale
   - Expected time and complexity of analysis

### Phase 1: Data Processing & Pattern Discovery

**Use extended reasoning to identify subtle patterns across large conversation sets.**

1. **Platform Detection and Data Parsing** (Export-Specific):
   - Auto-detect export format (Claude vs ChatGPT) 
   - Parse conversations, projects, user data based on platform
   - Extract expertise indicators and usage patterns

2. **Apply [Shared Pattern Discovery](../shared/analysis-methodology.md#phase-1-pattern-discovery--classification)**:
   - **Data-driven domain discovery** (let actual topics emerge - DO NOT force into predefined categories)
   - Task types (creation, transformation, analysis, troubleshooting, curation)
   - Explicit and implicit pattern markers
   - Niche & specialized pattern detection (hobbyist domains, creative work, prompt engineering, etc.)
   - Temporal pattern detection
   - User expertise evolution over time

3. **Export-Specific Enhancements**:
   - Cross-reference with project data (Claude exports):
     - How many projects demonstrate similar patterns?
     - Do project descriptions reinforce conversation patterns?
     - Project success indicators and user satisfaction
   - Message feedback analysis (ChatGPT exports):
     - User feedback patterns on AI responses
     - Quality improvement opportunities

**Think deeply about:**
- Are these truly distinct patterns or variations of the same workflow?
- What makes this pattern recurring vs. one-off requests?
- How do patterns evolve across the user's conversation timeline?

### Phase 2-4: Core Analysis

Apply the **[shared analysis methodology](../shared/analysis-methodology.md)** phases:

- **Phase 2**: Frequency & Temporal Analysis with project data cross-referencing
- **Phase 3**: Skill-Worthiness Scoring (0-50 composite scale)
- **Phase 4**: Relationship Mapping & Overlap Analysis

See [shared methodology](../shared/analysis-methodology.md) for complete details.

### Phase 5: Cross-Platform Pattern Deduplication (Export-Specific)

When processing mixed datasets (both ChatGPT and Claude exports), perform comprehensive deduplication before skill generation.

See **[shared methodology - Cross-Platform Deduplication](../shared/analysis-methodology.md#cross-platform-deduplication-export-analysis-only)** for:
- Content similarity detection
- Deduplication classification rules
- Pattern frequency recalculation
- Unified skill design preparation
- Deduplication validation

**Export-Specific Advantages:**
- Access to complete conversation history (not just recent/accessible)
- Project metadata integration (Claude)
- Message feedback data (ChatGPT)
- Temporal analysis across months/years

### Phase 6: Skill Generation & Optimization

**Use extended reasoning to optimize skill boundaries and maximize user value.**

Apply **[shared methodology - Prioritization Matrix](../shared/analysis-methodology.md#phase-5-prioritization-matrix)** and boundary optimization strategies.

**Export-Specific Enhancements:**
- Leverage project success data for impact validation
- Use message feedback for quality improvement insights
- Apply historical trend analysis for strategic pattern identification

## Output Generation Options

Ask user to choose:

**Option A: Analysis Report Only**
- Comprehensive analysis with recommendations
- No file generation
- Implementation guidance only

**Option B: Complete Implementation Package** (Recommended)
- Full analysis plus ready-to-use skills
- Proper folder structure with all supporting files
- Testing and validation guidance

**Option C: Incremental Implementation**
- Start with top 3-5 skills
- Provide complete package for priority skills
- Expansion roadmap for additional skills

**Option D: Custom Specification**
- User-defined subset of skills
- Specific modifications or requirements
- Tailored to particular use cases

## File Generation (Option B/C)

**Note**: If these directories don't exist, they will be automatically created by the analysis process.

### Create Analysis Reports
Generate timestamped reports in `reports/{TIMESTAMP}/`:

1. **`skills-analysis-log.json`** (Root directory) - Machine-readable incremental processing data

**Example structure:**
```json
{
  "analysis_date": "YYYY-MM-DDTHH:MM:SSZ",
  "platform_detected": "claude|chatgpt|mixed",
  "total_conversations": 150,
  "report_directory": "reports/2025-01-23_22-40-00",
  "conversations_analyzed": [
    {
      "id": "conv_123",
      "platform": "chatgpt|claude",
      "file": "data-exports/chatgpt/conversations.json",
      "message_count": 45,
      "first_message_date": "2024-01-01T10:00:00Z",
      "last_message_date": "2024-01-10T14:20:00Z",
      "analysis_hash": "sha256:abc123...",
      "topics_identified": ["coding", "documentation"],
      "patterns_found": 3
    }
  ],
  "deduplication_summary": {
    "cross_platform_duplicates_removed": 45,
    "workflow_instances_merged": 12,
    "frequency_adjustments": {
      "newsletter_critique": {"before": 1225, "after": 987},
      "business_communication": {"before": 709, "after": 643}
    }
  },
  "skills_generated": [
    {
      "skill_name": "newsletter-critique-specialist",
      "source_conversations": ["conv_123", "conv_789"],
      "frequency_score": 8,
      "impact_score": 9,
      "platform_coverage": "both",
      "generated_files": [
        "generated-skills/newsletter-critique-specialist/SKILL.md",
        "generated-skills/newsletter-critique-specialist/reference.md"
      ]
    }
  ],
  "analysis_metadata": {
    "total_patterns_identified": 25,
    "patterns_consolidated": 8,
    "patterns_deduplicated": 6,
    "final_skill_count": 5,
    "processing_time_minutes": 45
  }
}
```

2. **`comprehensive-skills-analysis.md`** - Complete pattern analysis with skill recommendations
3. **`implementation-guide.md`** - Actionable deployment roadmap

### Generate Skill Packages
For each approved skill, create complete folder structure in `generated-skills/`:

```
skill-name/
├── SKILL.md (required - main skill with YAML frontmatter)
├── reference.md (detailed methodology and frameworks)
├── examples.md (additional examples and use cases)
├── templates/ (reusable templates for outputs)
│   ├── template-1.md
│   └── template-2.md
└── scripts/ (utility scripts if applicable)
    └── helper-script.py
```

**Auto-creation**: The `generated-skills/` directory will be created automatically when you select Option B or C.

### SKILL.md Generation Template
```yaml
---
name: [skill-name]  # Only lowercase letters, numbers, and hyphens
description: [CRITICAL: Must include BOTH what skill does AND when to use it. Written in third person. Include key trigger terms.]
---

# [Skill Name]

## Instructions
[Clear, step-by-step guidance - KEEP UNDER 500 LINES TOTAL]

1. **[Phase 1 Name]**
   - [Specific instruction 1]
   - [Specific instruction 2]

2. **[Apply Framework/Method]** from [reference.md](reference.md):
   - [Framework element 1]
   - [Framework element 2]

3. **[Use Templates]** from [templates/](templates/):
   - [Template 1 description and usage]
   - [Template 2 description and usage]

4. **[Quality Standards]**:
   - [Standard 1]
   - [Standard 2]

## Examples

### [Example Scenario 1]
**User Request**: "[Realistic user request]"

**Response using methodology**:
```
[Complete example showing proper skill usage]
```

For more examples, see [examples.md](examples.md).
For detailed methodology, see [reference.md](reference.md).
```

## Quality Standards

All quality standards follow the **[shared analysis methodology](../shared/analysis-methodology.md#quality-standards)**:

- Pattern validation requirements (frequency, consistency, evidence)
- Skill consolidation rules (max 8-12 skills, clear boundaries)
- Skill package generation standards
- Anti-patterns to avoid

**Export-Specific Enhancements:**
- Minimum frequency: 50+ occurrences OR high strategic value (with complete history available)
- Cross-platform evidence: Include examples from both platforms when available
- Project data validation: Cross-reference patterns with project success metrics

## Instructions for Execution

1. **Initialize Timestamp**: Create `TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)`
2. **Create Reports Directory**: `mkdir -p reports/{TIMESTAMP}`
3. **Check for Previous Analysis Log**: Look for existing `skills-analysis-log.json` in root directory
4. **Scan Data Directories**: Check `data-exports/chatgpt/` and `data-exports/claude/` for available platforms
5. **Determine analysis scope** using Phase 0 if previous log exists
6. **Start with user choice** of output option (A/B/C/D)
7. **Perform complete analysis** following all phases for determined scope
8. **Execute cross-platform deduplication** if both ChatGPT and Claude data detected (Phase 5)
9. **Generate output files**:
   - Update/create `skills-analysis-log.json` in root directory
   - Create `reports/{TIMESTAMP}/comprehensive-skills-analysis.md`
   - Create `reports/{TIMESTAMP}/implementation-guide.md`
10. **Generate skill packages** in `generated-skills/` if requested (Option B/C)
11. **Validate all content** using quality framework and analysis standards
12. **Cleanup Phase**:
    - Remove temporary analysis scripts from `scripts/` directory
    - Delete intermediate data processing files (*.tmp, *.cache, etc.)
    - Remove empty directories created during processing
    - Clean up any Python virtual environments or temporary dependencies
    - Remove duplicate or staging files from skill generation process
13. **Archive Organization** (Optional):
    - Compress older reports directories (keep last 3-5 runs)
    - Move temporary logs to archive subdirectory
    - Consolidate debug output into single log file
14. **Cleanup Validation**:
    - Verify all essential outputs remain intact:
      - `skills-analysis-log.json` (root)
      - `reports/{TIMESTAMP}/` directory with analysis reports
      - `generated-skills/` directory with skill packages
    - Confirm no critical files were accidentally removed
    - Display cleanup summary showing what was removed vs. retained

### Quality Focus Requirements

Apply **[shared methodology quality standards](../shared/analysis-methodology.md#quality-standards)** with export-specific validation:
- Eliminate generic patterns and focus on specific workflows
- Consolidate overlapping skills (max 8-12, recommend top 5-8)
- Validate frequency claims post-deduplication
- Prioritize by genuine impact (>30 min/week time savings)
- Platform-agnostic design for all generated skills

### For Incremental Processing
If user provides previous analysis log:
- Parse the log to understand what was previously analyzed
- Skip unchanged conversations (based on IDs and metadata)
- Focus on new or modified conversations only
- Re-run deduplication if new platform data added
- Integrate new findings with previous skill recommendations
- Update the analysis log with new data

**Data Location**: JSON files are located in `data-exports/chatgpt/` and `data-exports/claude/` subdirectories. The system will automatically detect available platform(s) and process files accordingly.