# Workflow Pattern Analyzer

A web-compatible Custom Skill that brings export-quality conversation analysis to Claude's web interface. Analyzes recent conversation history using native chat tools to identify recurring patterns and generate evidence-based Custom Skills recommendations.

## Why This Skill?

**The Bridge Between Two Worlds:**
- **Export-based plugin** (`/analyze-skills`): Comprehensive but requires Claude Code + JSON exports
- **skill-idea-generator**: Web-friendly but lacks statistical rigor
- **workflow-pattern-analyzer**: Best of both - rigorous analysis accessible anywhere

## Key Features

### 🌐 Web Interface Compatible
- No conversation exports required
- Uses `recent_chats` and `conversation_search` tools
- Works in Claude.ai web interface or Claude Code

### 📊 Statistical Rigor
- **5-dimensional scoring framework** (0-10 scale each):
  - Frequency analysis
  - Consistency evaluation
  - Complexity assessment
  - Time savings calculation
  - Error reduction potential
- **Composite scoring** (0-50 total) for prioritization
- **Statistical validation** with significance thresholds

### 🎯 Comprehensive Analysis
- Pattern discovery across multiple dimensions (explicit, implicit, domain, temporal)
- Relationship mapping and overlap detection
- Smart consolidation strategies
- Evidence-based recommendations with conversation excerpts

### 📦 Complete Outputs
- Detailed analysis reports with pattern evidence
- Prioritization matrix (frequency vs impact)
- Ready-to-use skill specifications
- Implementation roadmap

## When to Use

**Perfect for:**
- Web interface users who can't run `/analyze-skills`
- Quick pattern identification without export overhead
- Iterative skill discovery (start small, expand as needed)
- Users who want analysis rigor without technical setup

**Use the export plugin instead when:**
- You have Claude/ChatGPT conversation exports available
- You need cross-platform analysis (Claude + ChatGPT)
- You want comprehensive historical analysis (100+ conversations)
- You need incremental processing for large datasets

## Usage Guide

### Quick Start

Simply say:
- "Analyze my conversation patterns"
- "What workflows should I automate?"
- "Find skill opportunities in my recent chats"
- "Identify my most common requests"

### Analysis Depth Options

**1. Quick Scan (20-30 conversations, ~2-3 min)**
```
"Do a quick scan of my recent conversations"
```
Best for: Immediate insights, identifying top 1-2 patterns

**2. Standard Analysis (50-75 conversations, ~5-7 min)**
```
"Analyze my conversation history for patterns"
```
Best for: Comprehensive pattern detection, multiple skill opportunities

**3. Deep Dive (100+ conversations, ~10-15 min)**
```
"Do a comprehensive analysis of my workflows"
```
Best for: Full workflow mapping, temporal trends, strategic insights

**4. Targeted Search (variable)**
```
"Find patterns in my coding conversations"
"Analyze how I use you for writing tasks"
```
Best for: Domain-specific skill discovery

### Understanding the Output

**Score Interpretation:**
- **40-50 (Critical)**: Implement immediately - highest ROI
- **30-39 (High)**: Strong candidates for skill creation
- **20-29 (Medium)**: Consider for automation
- **10-19 (Low)**: Defer or use simple prompt templates
- **0-9 (Not Viable)**: Not worth skill automation

**Prioritization Matrix:**
```
VALUE/IMPACT
     │
HIGH │  Quick Wins      Strategic
     │  [Immediate ROI]  [Critical but complex]
     │
LOW  │  Automate        Defer
     │  [Nice-to-have]  [Not worth it]
     │
     └─────────────────────────
          LOW  FREQUENCY  HIGH
```

## Example Workflows

### Scenario 1: First-Time User

**User**: "I want to find out what I should automate"

**Skill Output**:
- Quick scan of 30 recent conversations
- Top 3 patterns identified with scores
- Evidence excerpts from actual conversations
- Recommendation for next steps (expand analysis or build skills)

### Scenario 2: Domain-Specific Analysis

**User**: "Find patterns in my coding work"

**Skill Output**:
- Targeted search of coding-related conversations
- Domain-specific patterns (code review, documentation, debugging)
- Frequency and consistency scores for each pattern
- Skill specifications tailored to development workflows

### Scenario 3: Comprehensive Workflow Audit

**User**: "Do a deep analysis of everything I do"

**Skill Output**:
- Analysis of 100+ conversations across 3 months
- Full pattern taxonomy (15+ patterns identified)
- Prioritization matrix with 6-8 skill recommendations
- Implementation roadmap with phased approach
- Complete skill packages ready to deploy

## What Makes This Different?

### vs. skill-idea-generator
| Feature | skill-idea-generator | workflow-pattern-analyzer |
|---------|---------------------|---------------------------|
| **Approach** | Conversational suggestions | Statistical analysis |
| **Scoring** | Qualitative | Quantitative (0-50 scale) |
| **Evidence** | Minimal | Detailed conversation excerpts |
| **Output** | Ideas + sketches | Complete skill packages |
| **Best for** | Inspiration, brainstorming | Evidence-based decisions |

### vs. Export-Based Plugin
| Feature | Export Plugin | workflow-pattern-analyzer |
|---------|---------------|---------------------------|
| **Platform** | Claude Code only | Web + Claude Code |
| **Setup** | Requires JSON exports | Zero setup |
| **Data Scope** | Complete history | Recent accessible history |
| **Cross-platform** | Claude + ChatGPT | Claude only |
| **Analysis Depth** | Comprehensive | Extensive (within tool limits) |
| **Best for** | Historical analysis | Quick insights |

## Quality Standards

**Pattern Validation:**
- Minimum 3 instances OR >5% of conversations
- 70%+ consistency across instances
- 2-3 conversation excerpts as evidence
- >30 min/month cumulative time savings

**Skill Recommendations:**
- Maximum 8-10 skills (focus on ROI)
- Clear differentiation between skills
- Evidence-based design from actual usage
- Practical focus on time/quality impact

**Analysis Rigor:**
- No generic patterns (avoid "writing", "analysis")
- Validated frequencies within sample
- Temporal awareness (emerging/stable/declining)
- User context consideration

## Advanced Usage

### Incremental Analysis
Start with quick scan, expand iteratively:
```
1. Quick scan (30 conversations) → Identify top pattern
2. Generate skill for top pattern → Deploy and test
3. Standard analysis (50-75 conversations) → Find next opportunities
4. Deep dive (100+ conversations) → Complete workflow mapping
```

### Adjusting Scoring Weights
Request custom prioritization:
```
"Analyze my patterns but prioritize time savings over frequency"
"Focus on high-complexity patterns even if they're less frequent"
```

### Domain-Focused Batches
Analyze specific workflow areas:
```
"Analyze my business communication patterns"
"Find patterns in my technical writing"
"What do I repeatedly do for project planning?"
```

## Technical Details

### Data Collection Strategy
- **Broad sampling**: Multiple `recent_chats` calls with varied parameters
- **Temporal distribution**: Sample across different time periods
- **Topic exploration**: `conversation_search` for discovered domains
- **Smart batching**: Balance coverage with efficiency

### Pattern Detection Methods
- **Explicit markers**: Repeated phrases, formatting instructions
- **Implicit workflows**: Multi-turn structures, refinement cycles
- **Domain clustering**: Topic frequency and task type analysis
- **Temporal patterns**: Recurring tasks, event-driven workflows

### Scoring Methodology
Each pattern scored 0-10 across 5 dimensions:
1. **Frequency**: Occurrence rate in conversation sample
2. **Consistency**: Similarity of requirements across instances
3. **Complexity**: Steps, decision points, cognitive load
4. **Time Savings**: Minutes saved per use × frequency
5. **Error Reduction**: Quality improvement potential

Composite score (0-50) determines priority classification.

## Limitations

**Compared to Export-Based Analysis:**
- ❌ Can't analyze ChatGPT conversations
- ❌ Limited to accessible recent history (API constraints)
- ❌ No cross-platform deduplication
- ❌ Can't process 1000+ conversation datasets efficiently
- ❌ No incremental processing log

**Inherent Constraints:**
- Requires 10+ conversations for basic analysis
- Pattern detection accuracy improves with more data
- Very old conversations may not be accessible via tools
- Analysis time scales with conversation depth

## Best Practices

**For Accurate Results:**
1. Run analysis after accumulating 30+ conversations
2. Use targeted searches for specific domains
3. Request deep dive for comprehensive insights
4. Provide feedback on detected patterns (accuracy validation)

**For Skill Generation:**
1. Start with top 3-5 highest-scoring patterns
2. Test generated skills before building more
3. Iterate based on actual usage
4. Re-run analysis monthly as patterns evolve

**For Efficiency:**
1. Use quick scans for regular check-ins
2. Save deep dive for quarterly workflow audits
3. Focus targeted searches on specific pain points
4. Combine analysis with skill building in same session

## Example Output Structure

```markdown
# Workflow Pattern Analysis Report
**Analysis Date**: 2025-01-23
**Conversations Analyzed**: 75 conversations (3 months)
**Patterns Identified**: 12 patterns
**Skills Recommended**: 5 skills

## 🔥 HIGH-PRIORITY OPPORTUNITIES

### 1. Email Response Composer
**Score: 42/50** (Frequency: 9/10, Consistency: 9/10, Complexity: 6/10, Time: 10/10, Error: 8/10)

**Pattern Description**: You regularly draft professional emails with specific tone and structure requirements

**Evidence**:
- Found in 14 conversations (18.7% of sample)
- First seen: Oct 15, Most recent: Jan 20
- Average time per instance: 15 minutes
- Total time savings potential: 210 min/month

**Example Occurrences**:
1. Jan 18: "Draft an email to client about project delay..."
2. Jan 12: "Write a professional response to vendor inquiry..."
3. Jan 5: "Compose email to team about Q1 objectives..."

**Proposed Skill**: Professional email composer with tone control, structure templates, and action item extraction

**Implementation Priority**: Immediate (Highest ROI)

---

[4 more patterns with detailed breakdowns]

## 💡 MODERATE OPPORTUNITIES
[3 patterns, briefer format]

## ⏸️  DEFERRED PATTERNS
[4 patterns that didn't meet thresholds]

## 📊 PRIORITIZATION MATRIX
[Visual classification of patterns]

## 🚀 IMPLEMENTATION ROADMAP
Week 1: Build Email Response Composer + Meeting Notes Structurer
Week 2: Test and refine initial skills
Week 3: Build Code Review Checklist + API Documentation Humanizer
Week 4: Evaluate usage, iterate, consider remaining patterns
```

## Contributing

Found a bug or have suggestions for improving the analysis methodology? 

- Open an issue: [GitHub Issues](https://github.com/hirefrank/claude-plugins/issues)
- Discuss improvements: [GitHub Discussions](https://github.com/hirefrank/claude-plugins/discussions)

## License

MIT License - see repository root for details

---

**Built to bridge web accessibility with export-quality analysis rigor**
