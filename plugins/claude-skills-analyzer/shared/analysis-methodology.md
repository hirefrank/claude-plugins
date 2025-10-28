# Skills Analysis Methodology

**Shared framework for pattern detection, scoring, and skill generation used across all Claude Skills Analyzer components.**

This methodology is referenced by:
- `/analyze-skills` command (export-based analysis)
- `workflow-pattern-analyzer` skill (tool-based analysis)
- `conversation-analyzer` skill (base analysis capability)

## Core Analysis Phases

### Phase 1: Pattern Discovery & Classification

Identify patterns through multiple detection methods:

#### A. Explicit Pattern Markers
- **Repeated phrasing**: "format this as...", "make it more...", "apply X style"
- **Consistent request structures**: "create a [X] that does [Y]"
- **Recurring formatting instructions**: tables, bullet lists, specific structures
- **Tone/voice adjustments**: "more casual", "add enthusiasm", "formal version"

#### B. Implicit Workflow Patterns
- **Multi-turn conversation structures**: Same workflow across different topics
- **Iterative refinement sequences**: Request → feedback → revision cycles
- **Context re-explanation**: Same background info provided repeatedly
- **Problem-solving approaches**: Consistent debugging/analysis methodologies

#### C. Domain Discovery (Data-Driven)
- **Let domains emerge from the data** - Do NOT pre-categorize into standard domains
- **Topic frequency analysis**: Extract actual subject matter from conversations
  - Examples of specialized domains: recipe transcription, cannabis strains, image prompting, game design, book summaries
  - Examples of traditional domains: coding, business strategy, creative writing, data analysis, technical writing
- **Task type patterns**: Identify the action types that appear (creation, transformation, analysis, troubleshooting, curation, etc.)
- **Niche specialization detection**: Look specifically for narrow, specialized topics with high engagement
- **Cross-domain workflows**: Patterns that span multiple topics
- **Domain diversity scoring**: Reward finding 8-15 distinct domains vs. forcing into 3-4 buckets

**CRITICAL**: Avoid fitting patterns into predefined categories. Each user's conversation history will have unique domains based on their actual usage.

#### D. Niche & Specialized Pattern Detection

**Explicitly search for underrepresented domains:**
- **Hobbyist domains**: Recipes, cocktails, cannabis, gardening, gaming, fitness, travel planning
- **Creative domains**: Story writing, worldbuilding, character development, art direction, music composition
- **Prompt engineering**: Image generation (Midjourney, Stable Diffusion, DALL-E), video generation, AI art workflows
- **Learning & education**: Book summaries, concept explanations, study guides, teaching materials
- **Personal organization**: Resume writing, cover letters, personal branding, goal setting
- **Entertainment & media**: Game design, narrative design, content creation, video scripts
- **Wellness & lifestyle**: Meal planning, workout routines, meditation guides, habit tracking

**Detection strategy:**
- Look for concentrated clusters of 5+ conversations on the same narrow topic
- Identify specialized vocabulary/jargon (strain names, recipe terms, art styles, game mechanics)
- Find recurring templates/formats specific to that domain
- Don't dismiss low-frequency patterns if they show high consistency and complexity
- Pay special attention to patterns that appear in artifacts, project names, or conversation titles
- Consider that niche patterns may have lower frequency but higher value due to specialization

**Quality indicators for niche patterns:**
- Consistent terminology and domain-specific language
- Recurring output formats or structures
- User demonstrates growing expertise over time
- High engagement (longer conversations, multiple refinements)
- Clear workflow or methodology emerging

#### E. Temporal Patterns
- **Weekly/monthly recurring tasks**: Reports, summaries, check-ins
- **Event-driven patterns**: Meeting prep, post-mortems, launches
- **Seasonal trends**: Quarterly reviews, annual planning
- **Frequency trends**: Increasing/stable/decreasing over time

### Phase 2: Frequency Analysis & Validation

For each identified pattern, calculate:

#### Occurrence Metrics
- **Absolute frequency**: Total instances found in analyzed conversations
- **Relative frequency**: Percentage of conversations containing pattern
- **Temporal distribution**: First occurrence, most recent, clustering
- **Consistency score**: Similarity across pattern instances (0-100%)

#### Statistical Validation
- **Significance threshold**: Pattern must appear in >5% of conversations OR >3 absolute instances
- **Consistency requirement**: 70%+ similarity in requirements/structure across instances
- **Sample size consideration**: Adjust thresholds based on total conversations analyzed

#### Evidence Collection
- Extract 2-4 representative conversation excerpts per pattern
- Note variation types (what changes vs what stays constant)
- Document user refinement patterns (common adjustments made)

### Phase 3: Skill-Worthiness Scoring (0-10 Scale)

**Use extended reasoning to evaluate each pattern across 5 dimensions:**

#### 1. Frequency Score (0-10)
- **10**: Daily usage (20+ instances or >25% of conversations)
- **8-9**: Multiple times per week (10-20 instances or 15-25%)
- **6-7**: Weekly usage (5-9 instances or 8-15%)
- **4-5**: Bi-weekly to monthly (3-4 instances or 5-8%)
- **2-3**: Monthly or less (2 instances or 3-5%)
- **0-1**: One-off or <3% of conversations

#### 2. Consistency Score (0-10)
- **10**: Identical requirements every time (90-100% similarity)
- **8-9**: Highly consistent with minor variations (75-90%)
- **6-7**: Core structure consistent, details vary (60-75%)
- **4-5**: Recognizable pattern, significant variation (45-60%)
- **2-3**: Loosely related, different each time (30-45%)
- **0-1**: No discernible consistency (<30%)

#### 3. Complexity Score (0-10)
- **10**: Multi-step workflow with decision points, high cognitive load
- **8-9**: Complex methodology requiring expertise/frameworks
- **6-7**: Moderate complexity with structured approach
- **4-5**: Straightforward process with some nuance
- **2-3**: Simple task with minimal steps
- **0-1**: Trivial one-step operation

#### 4. Time Savings Score (0-10)
- **10**: >60 min saved per use (or >10 hours/month total)
- **8-9**: 30-60 min per use (or 5-10 hours/month)
- **6-7**: 15-30 min per use (or 2-5 hours/month)
- **4-5**: 5-15 min per use (or 1-2 hours/month)
- **2-3**: 2-5 min per use (or 30-60 min/month)
- **0-1**: <2 min per use (<30 min/month)

#### 5. Error Reduction Score (0-10)
- **10**: Critical tasks with major error consequences
- **8-9**: Common mistakes significantly impact quality
- **6-7**: Regular pitfalls that skill could prevent
- **4-5**: Occasional errors, modest quality improvement
- **2-3**: Minor inconsistencies, small quality gains
- **0-1**: No error patterns, quality already consistent

#### Composite Scoring
- **Total Score**: Sum of 5 dimensions (0-50 scale)
- **Priority Classification**:
  - **Critical** (40-50): Implement immediately
  - **High** (30-39): Strong candidates for skill creation
  - **Medium** (20-29): Consider for skill creation
  - **Low** (10-19): Defer or handle with simple prompts
  - **Not Viable** (0-9): Not worth skill automation

### Phase 4: Relationship Mapping & Consolidation

#### A. Overlap Detection
- Identify shared components across patterns
- Map overlapping functionality (>40% shared steps)
- Find hierarchical relationships (high-level task composed of sub-tasks)
- Detect sequential workflows (tasks that occur in sequence)

#### B. Consolidation Strategies

**Use extended reasoning to determine:**

- **Merge** (>60% overlap): Combine into single comprehensive skill
- **Separate with cross-reference** (30-60% overlap): Distinct skills with links
- **Hierarchical**: Main skill + specialized variants → parent/child structure
- **Modular**: Extract common elements → shared templates/references

#### C. Boundary Optimization

Each skill should have:
- **Clear purpose**: Single, well-defined use case
- **Distinct triggers**: Easy to know when to use vs other skills
- **Minimal overlap**: <30% shared functionality with other skills
- **Appropriate scope**: Not too broad (generic) or narrow (over-specialized)

### Phase 5: Prioritization Matrix

Generate 2D matrix visualization:

```
VALUE/IMPACT (High to Low)
     │
HIGH │  🔥 Quick Wins        ⭐ Strategic
     │  [High-priority         [Complex but
     │   automation]           critical]
     │
     │  ──────────────────────────────
     │
LOW  │  🔧 Automate          ⏸️  Defer
     │  [Nice-to-have         [Not worth
     │   efficiency]           automating]
     │
     └────────────────────────────────
          LOW    FREQUENCY    HIGH
```

**Classify each pattern:**
- **X-axis**: Frequency score (0-10)
- **Y-axis**: Average of Complexity, Time Savings, Error Reduction (0-10)
- **Size indicator**: Total composite score
- **Color coding**: Implementation difficulty

**Strategic Recommendations:**
1. **Top 3-5 Quick Wins**: Highest ROI (frequency × impact)
2. **Strategic Skills**: High impact even if lower frequency
3. **Quick Automations**: High frequency, simpler to implement
4. **Defer List**: Patterns not meeting skill-worthiness thresholds

## Quality Standards

### Pattern Validation Requirements
- **Statistical significance**: Patterns must occur in >5% of total conversations OR >3 absolute instances
- **Consistency threshold**: 70%+ similarity across pattern instances
- **Business value**: Clear time savings (>30 min/week cumulative) or quality improvement potential
- **Avoid generic categories**: No broad domains like "creative" or "research"
- **Evidence requirement**: Minimum 2-3 specific conversation excerpts per pattern

### Skill Consolidation Rules
- **Maximum 8-12 skills total**: Focus on highest-impact patterns (recommend prioritizing top 5-8)
- **Minimum frequency**: 3+ instances OR >5% of conversations OR high strategic value
- **Clear boundaries**: Each skill should have distinct, non-overlapping purpose
- **Platform agnostic**: Skills must work with content from any AI platform
- **Evidence-based design**: Skill structure reflects actual usage patterns

### Skill Package Generation

For each approved skill, create:

#### A. SKILL.md Structure
```yaml
---
name: [skill-name]  # lowercase, hyphens only
description: [What it does AND when to use it - include trigger terms]
---

# [Skill Name]

## Instructions
[Clear, step-by-step guidance - keep under 500 lines]

1. **[Phase Name]**
   - [Specific instruction]
   - Reference [reference.md](reference.md) for detailed methodology

2. **[Quality Standards]**
   - [Standard 1]
   - [Standard 2]

## Examples

### [Example Scenario]
**User Request**: "[Realistic request]"

**Response**: 
[Complete example showing proper usage]

For more examples, see [examples.md](examples.md).
```

#### B. Supporting Files
- **reference.md**: Detailed methodologies, frameworks, technical depth
- **examples.md**: Additional use cases and variations
- **templates/**: Reusable output templates
- **scripts/**: Utility scripts if applicable

#### C. Progressive Disclosure Strategy
Keep SKILL.md concise by:
- Linking to reference.md for detailed frameworks
- Moving extended examples to examples.md
- Extracting reusable templates to templates/
- Loading supporting files only when needed

## Cross-Platform Deduplication (Export Analysis Only)

When processing mixed datasets (ChatGPT + Claude exports):

### 1. Content Similarity Detection
- **Semantic matching**: Compare conversation titles, summaries, key topics
- **Temporal correlation**: Flag conversations within 24-48 hours on identical topics
- **Draft content overlap**: Detect same documents/drafts across platforms
- **Workflow sequence matching**: Identify multi-platform workflows

### 2. Deduplication Classification
- **Exact duplicates** (>90% similarity): Remove from frequency counts completely
- **Cross-platform workflows** (same project, different phases): Count as single workflow
- **Platform preference patterns**: Analyze which platform user prefers for task types
- **Complementary usage**: Preserve when platforms serve different purposes

### 3. Pattern Frequency Recalculation
- Subtract duplicate instances from frequency totals
- Merge conversation evidence from both platforms
- Recalculate skill-worthiness scores after deduplication
- Note platform preferences for different task types

### 4. Unified Skill Design
- Platform-agnostic skill definitions
- Cross-platform workflow support
- Platform-specific usage notes when relevant
- Consolidated skill boundaries

## Anti-Patterns to Avoid

**Don't recommend skills for:**
- **One-off tasks**: Won't be used repeatedly
- **Highly variable tasks**: Every instance completely different
- **Better solved by MCP**: Requires authentication, external services, real-time data
- **Better solved by tools**: Dedicated app already does it perfectly
- **Over-simplified tasks**: Easier to just ask directly

**Red flags in patterns:**
- High frequency but no consistency (chaotic variation)
- High consistency but very low frequency (use prompt template instead)
- Pattern declining over time (user found better solution)
- Task requires external services (needs MCP, not skill)
- "I've only done this once but..." (not validated)
- "It's different every time..." (not automatable)

## Extended Reasoning Triggers

Use extended thinking when:
- **Large datasets**: >50 conversations requiring deep pattern analysis
- **Complex deduplication**: Cross-platform duplicate detection decisions
- **Ambiguous boundaries**: Determining if patterns should merge or separate
- **Statistical validation**: Assessing pattern significance
- **Strategic tradeoffs**: Consolidation vs separation decisions
- **Overlap resolution**: Determining optimal skill boundaries

## Output Quality Checklist

Before finalizing recommendations:

- [ ] All patterns meet statistical significance thresholds
- [ ] Frequency calculations validated and accurate
- [ ] Evidence excerpts support pattern claims
- [ ] Skill boundaries are clear and non-overlapping
- [ ] Composite scores correctly calculated
- [ ] Time savings estimates realistic
- [ ] No generic/broad skill categories
- [ ] Domain diversity validated - patterns span 6+ distinct topic areas (not just business/coding)
- [ ] Niche specializations identified and not dismissed as outliers
- [ ] No artificial categorization into predefined domains (coding, writing, business, analysis)
- [ ] Maximum 8-12 skills recommended (prefer 5-8)
- [ ] Each skill has 2-3 conversation excerpts as evidence
- [ ] Progressive disclosure strategy implemented
- [ ] YAML frontmatter includes trigger terms
- [ ] All supporting files specified

## Version History

**v1.0** (2025-01-24): Initial shared methodology extracted from analyze-skills command and workflow-pattern-analyzer skill
