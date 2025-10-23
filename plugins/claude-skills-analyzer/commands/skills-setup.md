---
description: Guide you through setting up AI conversation exports for skills analysis
---

# Skills Analysis Setup Guide

I'll walk you through setting up your AI conversation exports for analysis and help you get the most value from the Claude Skills Analyzer.

## 📋 What You'll Need

To analyze your AI usage patterns and generate Custom Skills, you need:

1. **AI conversation exports** (Claude and/or ChatGPT)
2. **Organized directory structure** for your data
3. **At least 50+ conversations** for meaningful pattern detection

## 🗂️ Directory Structure Setup

I'll automatically create the proper directory structure for you. Here's what will be created:

```
your-project/
├── data-exports/
│   ├── claude/           # Place Claude exports here
│   │   ├── conversations.json
│   │   ├── projects.json
│   │   └── users.json
│   └── chatgpt/          # Place ChatGPT exports here
│       ├── conversations.json
│       ├── user.json
│       ├── shared_conversations.json
│       └── message_feedback.json (optional)
├── reports/              # Analysis reports will appear here
└── generated-skills/     # Generated skills will appear here
```

**Let me create these directories now:**

I'll set up:
- ✅ `data-exports/claude/` - for your Claude conversation exports
- ✅ `data-exports/chatgpt/` - for your ChatGPT conversation exports
- ✅ `reports/` - for timestamped analysis reports
- ✅ `generated-skills/` - for your generated Custom Skills

Ready to proceed? Just confirm and I'll create the full structure.

## 📥 How to Export Your Conversations

### For Claude Conversations:

**Step 1: Request Export**
1. Go to [claude.ai/settings](https://claude.ai/settings)
2. Click on **"Privacy & Data"** in the left sidebar
3. Look for **"Request data export"** or similar option
4. Click the button to request your export

**Step 2: Wait for Email**
- Claude will send you an email when your export is ready
- This typically takes 24 hours (sometimes sooner)
- The email will contain a download link

**Step 3: Extract and Organize**
1. Download the ZIP file from the email
2. Extract all files (you should have `conversations.json`, `projects.json`, etc.)
3. Create the directory if not already done: `data-exports/claude/`
4. Move all extracted JSON files into `data-exports/claude/`

**Files you should see:**
- `conversations.json` (required) - Your conversation history
- `projects.json` (optional) - Project information and metadata
- `users.json` (optional) - Account information

### For ChatGPT Conversations:

**Step 1: Request Export**
1. Go to [chatgpt.com/settings/general](https://chatgpt.com/settings/general)
2. Scroll down to **"Data controls"** section
3. Click **"Export data"**
4. Select what you want to export (conversations are usually pre-selected)
5. Confirm the export request

**Step 2: Wait for Email**
- ChatGPT will send you an email when your export is ready
- This usually takes 2-4 hours
- The email will contain a download link

**Step 3: Extract and Organize**
1. Download the ZIP file from the email
2. Extract all files (you should have `conversations.json`, `user.json`, etc.)
3. Create the directory if not already done: `data-exports/chatgpt/`
4. Move all extracted JSON files into `data-exports/chatgpt/`

**Files you should see:**
- `conversations.json` (required) - Your conversation history
- `user.json` (optional) - Account information
- `shared_conversations.json` (optional) - Shared conversations metadata
- `message_feedback.json` (optional) - Your feedback on responses

### Troubleshooting Export:

**Can't find Settings?**
- Claude: Look for your account icon (bottom left) → Settings → Privacy & Data
- ChatGPT: Click your account name (bottom left) → Settings → scroll to Data controls

**Export not arriving?**
- Check spam/junk email folder
- Wait a bit longer (can take up to 24 hours)
- Try requesting again if it's been >24 hours

**Files look different?**
- Export formats can vary slightly between updates
- As long as you have `conversations.json`, the analysis will work
- Missing optional files is fine

## ⚡ Quick Start Checklist

**Setup Phase:**
- [ ] Directories created (`data-exports/`, `reports/`, `generated-skills/`)
- [ ] At least one platform export requested (Claude and/or ChatGPT)
- [ ] Waiting for export email to arrive (24 hours or less)

**Data Phase:**
- [ ] Export files downloaded and extracted
- [ ] JSON files placed in correct `data-exports/` subdirectories
- [ ] You have at least 20+ conversations (more is better for patterns)

**Analysis Phase:**
- [ ] Ready to run `/analyze-skills` when exports are ready
- [ ] Know which output option you want (A, B, C, or D)
- [ ] Have time for analysis to complete (2-5 minutes typically)

**Completion:**
- [ ] Analysis finished and reports generated
- [ ] Review skills recommendations
- [ ] Generate or implement skills as desired

## 🎯 What the Analysis Will Find

The plugin will identify patterns like:

### Business & Communication
- Email drafting templates
- Proposal writing workflows
- Client communication patterns
- Meeting preparation structures

### Development & Code
- Code review methodologies
- Documentation standards
- Debugging approaches
- Architecture decision patterns

### Content & Writing
- Blog post structures
- Newsletter formats
- Social media workflows
- Research methodologies

### Personal Productivity
- Task planning approaches
- Decision-making frameworks
- Learning note-taking systems
- Goal-setting patterns

## 📊 Analysis Options

When you run `/analyze-skills`, you'll choose from:

- **Option A**: Analysis report only (insights and recommendations)
- **Option B**: Complete implementation package (ready-to-use skills)
- **Option C**: Incremental implementation (top 3-5 skills)
- **Option D**: Custom specification (your defined requirements)

## 🔒 Privacy & Security

- **Local processing**: All analysis happens on your machine
- **No data upload**: Your conversations never leave your system
- **Anonymized output**: Generated skills remove personal information
- **Git protection**: Export files are automatically ignored by version control

## 🚀 Expected Results

After analysis, you'll get:

### Analysis Reports (`reports/timestamp/`)
- **Comprehensive analysis** with pattern evidence
- **Implementation guide** with deployment roadmap
- **Processing log** for incremental future runs

### Generated Skills (`generated-skills/skill-name/`)
- **SKILL.md** - Main skill with YAML frontmatter
- **reference.md** - Detailed methodology
- **examples.md** - Usage examples  
- **templates/** - Reusable output templates

## ❓ Common Questions

**Q: How many conversations do I need?**
A: Minimum 20-30 for basic analysis, 50+ for meaningful patterns, 100+ for comprehensive insights.

**Q: Can I analyze both Claude and ChatGPT together?**
A: Yes! The plugin performs smart cross-platform deduplication and creates unified skills.

**Q: What if I don't have many conversations?**
A: Start with what you have. The plugin supports incremental processing, so you can re-run analysis as you accumulate more conversations.

**Q: How long does analysis take?**
A: Typically 2-5 minutes for 100 conversations, longer for larger datasets or complex patterns.

## 🛠️ Next Steps

1. **Set up your directories**: Create the folder structure above
2. **Export your data**: Follow the export guides for your platforms
3. **Run the analysis**: Use `/analyze-skills` when ready
4. **Implement skills**: Start with the highest-impact recommendations

## 💡 Pro Tips

- **Export regularly**: Update your analysis monthly as you accumulate more conversations
- **Start small**: Begin with Option C (incremental) to test with your top skills
- **Customize skills**: Edit generated skills to match your specific needs
- **Share patterns**: Generated skills are great for team standardization

Ready to get started? Let me know if you'd like help creating the directory structure or have questions about the export process!