---
description: Analyze AI conversation exports to generate reusable Custom Skills
---

# Analyze Skills Command

You are a Claude Skills Architect analyzing a user's complete AI conversation history to identify, prioritize, and automatically generate custom Claude Skills. Custom Skills are reusable instruction sets with proper YAML frontmatter, supporting documentation, and templates that help Claude consistently produce high-quality outputs for recurring tasks.

## Your Mission
Perform comprehensive analysis of conversation exports to:
1. Identify all potential custom skill opportunities
2. Eliminate redundancies and optimize skill boundaries  
3. Generate complete, ready-to-use skill packages
4. Provide implementation roadmap and maintenance guidance
5. **Enable incremental processing** - skip previously analyzed conversations and build on prior work

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

### Phase 0: Analysis Scope Determination

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
1. **Platform Detection and Data Parsing**:
   - Auto-detect export format (Claude vs ChatGPT) 
   - Parse conversations, projects, user data based on platform
   - Extract expertise indicators and usage patterns

2. **Categorize and analyze patterns:**
   - Topic/domain clustering (coding, writing, business, analysis)
   - Task types (creation, transformation, analysis, troubleshooting)
   - Output formats and user preferences
   - Explicit patterns: "Create a [X] with [Y] requirements"
   - Implicit workflows: Multi-turn conversation structures
   - Iterative refinement patterns and correction types
   - User expertise evolution over time

### Phase 2: Frequency & Temporal Analysis
For each identified pattern:
1. **Count occurrences** across entire conversation history and project work
2. **Calculate temporal distribution:**
   - First and most recent occurrence dates
   - Frequency trends (increasing/stable/decreasing)
   - Clustering patterns (bursts vs. distributed)
   - Seasonal/cyclical patterns (weekly/monthly/event-driven)
   - Project lifecycle patterns (start/middle/end phases)

3. **Cross-reference with project data:**
   - How many projects demonstrate similar patterns?
   - Do project descriptions reinforce conversation patterns?
   - Are there project-specific workflows not visible in conversations?
   - Project success indicators and user satisfaction

4. **Impact assessment:**
   - Business criticality indicators
   - Time investment per occurrence
   - Quality improvement potential
   - Error reduction opportunities
   - Project success metrics and outcomes

### Phase 3: Complexity & Standardization Assessment
For each pattern, evaluate:
1. **Task complexity factors:**
   - Number of steps involved
   - Decision points and branching logic
   - Required domain knowledge
   - External dependencies
   - Cognitive load requirements

2. **Standardization potential:**
   - Consistency of requirements across instances
   - Input/output variation levels
   - Documentable rules and procedures
   - Automation/templating value potential

3. **Skill-worthiness scoring** (0-10 scale):
   - **Frequency**: How often does this task occur?
   - **Consistency**: How similar are requirements each time?
   - **Complexity**: Would a skill meaningfully improve quality?
   - **Time savings**: How much effort would a skill save?
   - **Error reduction**: Common pitfalls a skill could prevent?

### Phase 4: Relationship Mapping & Overlap Analysis
1. **Identify skill relationships:**
   - Sequential workflows (tasks in sequence)
   - Complementary tasks (serving same goal)
   - Hierarchical relationships (high-level composed of sub-tasks)
   - Shared components (common elements across task types)

2. **Overlap detection and resolution:**
   - Map overlapping functionality between potential skills
   - Identify consolidation opportunities
   - Determine optimal skill boundaries
   - Plan integration strategies between related skills

3. **Dependency analysis:**
   - Which skills build on others
   - Shared templates or reference materials
   - Cross-skill workflow patterns

4. **False positive detection and validation:**
   - Distinguish between true recurring patterns and coincidental similarities
   - Validate pattern significance using statistical methods
   - Filter out one-off requests that appear similar but lack consistency
   - Ensure patterns represent genuine user needs rather than random occurrences

### Phase 5: Cross-Platform Pattern Deduplication

When processing mixed datasets (both ChatGPT and Claude exports), perform comprehensive deduplication before skill generation:

#### 1. **Content Similarity Detection**
- **Semantic matching**: Compare conversation titles, summaries, and key topics using content similarity
- **Temporal correlation**: Flag conversations within 24-48 hours discussing identical or closely related topics
- **Draft content overlap**: Detect when same document drafts, emails, or content pieces appear across platforms
- **Workflow sequence matching**: Identify multi-platform workflows (e.g., research in ChatGPT → writing in Claude)

#### 2. **Deduplication Classification Rules**
- **Exact duplicates** (>90% content similarity): Remove from frequency counts completely
- **Cross-platform workflows** (same project, different phases): Count as single workflow instance
- **Platform preference patterns**: Analyze which platform user prefers for specific task types
- **Complementary usage**: Preserve when platforms serve genuinely different purposes in workflow

#### 3. **Pattern Frequency Recalculation**
- **Adjust occurrence counts**: Subtract duplicate instances from frequency totals
- **Merge conversation evidence**: Combine excerpts from both platforms for stronger pattern evidence
- **Recalculate skill-worthiness scores**: Update frequency-based scoring after deduplication
- **Platform usage insights**: Note platform preferences for different task types

#### 4. **Unified Skill Design Preparation**
- **Platform-agnostic skill definitions**: Design skills that work regardless of AI platform used
- **Cross-platform workflow support**: Include guidance for multi-platform processes
- **Platform-specific usage notes**: Document when certain platforms excel for specific steps
- **Consolidated skill boundaries**: Merge similar patterns that appeared platform-specific

#### 5. **Deduplication Validation**
- **Statistical significance check**: Ensure patterns remain statistically significant after deduplication
- **Evidence quality assessment**: Verify sufficient conversation examples remain after merging
- **Pattern authenticity confirmation**: Distinguish genuine user patterns from platform-switching noise
- **Frequency threshold re-evaluation**: Re-apply minimum occurrence thresholds post-deduplication

**Deduplication Quality Standards:**
- Minimum 3 unique workflow instances required post-deduplication
- Cross-platform patterns must show genuine workflow integration, not random platform switching
- Platform preference data should inform skill design, not create separate skills
- Maintain detailed log of deduplication decisions for transparency

### Phase 6: Skill Generation & Optimization

#### A. Skill Prioritization Matrix
Create comprehensive 2x2 matrix with additional dimensions:
- **X-axis**: Frequency (Low to High)
- **Y-axis**: Value/Impact (Low to High) 
- **Color coding**: Implementation complexity
- **Size indicators**: Time savings potential

**Quadrant strategies:**
- **High Frequency, High Value**: "Quick Wins" - Implement immediately
- **High Frequency, Low Value**: "Automate" - Simple skills worth creating
- **Low Frequency, High Value**: "Strategic" - Important complex skills
- **Low Frequency, Low Value**: "Defer" - Not worth skill creation

#### B. Overlap Resolution
For each overlapping skill pair:
1. **Analyze overlap percentage** and type
2. **Determine consolidation strategy:**
   - Merge into single comprehensive skill
   - Keep separate with cross-references
   - Create hierarchical relationship (main + specialized)
   - Extract common elements into shared templates

3. **Optimize skill boundaries** for clarity and usability

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

### Pattern Validation Requirements
- **Statistical significance**: Patterns must occur in >5% of total conversations
- **Consistency threshold**: 70%+ similarity across pattern instances
- **Business value**: Clear time savings (>30 min/week) or quality improvement potential
- **Avoid generic categories**: No broad domains like "creative" or "research"
- **Evidence requirement**: Minimum 3 specific conversation excerpts per pattern

### Skill Consolidation Rules
- **Maximum 8 skills total**: Focus on highest-impact patterns only
- **Minimum frequency**: 50+ occurrences OR high strategic value (executive/business critical)
- **Clear boundaries**: Each skill should have distinct, non-overlapping purpose
- **Platform agnostic**: Skills must work with content from any AI platform
- **Cross-platform evidence**: Include examples from both platforms when available

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

### Quality Focus Requirements
- **Eliminate generic patterns**: Focus only on specific, actionable workflows
- **Consolidate overlapping skills**: Maximum 5-8 high-value skills total
- **Validate frequency claims**: Ensure pattern counts are mathematically sound post-deduplication
- **Prioritize by genuine impact**: Time savings (>30 min/week) and quality improvement potential
- **Platform-agnostic design**: Skills must work regardless of AI platform used

### For Incremental Processing
If user provides previous analysis log:
- Parse the log to understand what was previously analyzed
- Skip unchanged conversations (based on IDs and metadata)
- Focus on new or modified conversations only
- Re-run deduplication if new platform data added
- Integrate new findings with previous skill recommendations
- Update the analysis log with new data

**Data Location**: JSON files are located in `data-exports/chatgpt/` and `data-exports/claude/` subdirectories. The system will automatically detect available platform(s) and process files accordingly.