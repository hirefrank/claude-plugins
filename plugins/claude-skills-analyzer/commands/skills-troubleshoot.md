---
description: Troubleshoot common issues with skills analysis setup and execution
---

# Skills Analysis Troubleshooting

I'll help you diagnose and fix common issues with the Claude Skills Analyzer.

## 🔍 Quick Diagnostics

Let me check your current setup and identify any issues:

### Directory Structure Check
First, let me verify your project has the required directories:

```
Expected structure:
├── data-exports/
│   ├── claude/           # Claude export files
│   └── chatgpt/          # ChatGPT export files  
├── reports/              # Analysis outputs
└── generated-skills/     # Generated skill packages
```

### Data Files Check
Looking for these required files:

**Claude exports** (`data-exports/claude/`):
- [ ] `conversations.json` - Required
- [ ] `projects.json` - Optional but helpful
- [ ] `users.json` - Optional

**ChatGPT exports** (`data-exports/chatgpt/`):
- [ ] `conversations.json` - Required
- [ ] `user.json` - Optional
- [ ] `shared_conversations.json` - Optional

## 🚨 Common Issues & Solutions

### Issue: "No conversation files detected"

**Causes:**
- Files in wrong directories
- Incorrect file names
- Empty or corrupted JSON files

**Solutions:**
1. **Check file locations**: Ensure JSON files are in correct `data-exports/` subdirectories
2. **Verify file names**: Must match exactly (case-sensitive)
3. **Validate JSON**: Open files in text editor to check they're valid JSON
4. **Check file sizes**: Empty files (0 bytes) won't work

### Issue: "Analysis produces no patterns"

**Causes:**
- Too few conversations (need 20+ minimum)
- Conversations too short or simple
- No recurring patterns in usage

**Solutions:**
1. **Accumulate more data**: Export again after more AI usage
2. **Lower thresholds**: Adjust frequency requirements in analysis
3. **Check conversation quality**: Need substantial back-and-forth interactions
4. **Try different timeframes**: Use older exports if available

### Issue: "Plugin command not found"

**Causes:**
- Plugin not properly installed
- Claude Code needs restart
- Marketplace not added correctly

**Solutions:**
1. **Verify installation**:
   ```shell
   /plugin list
   ```
2. **Restart Claude Code**: Close and reopen
3. **Reinstall plugin**:
   ```shell
   /plugin uninstall claude-skills-analyzer@hirefrank
   /plugin install claude-skills-analyzer@hirefrank
   ```

### Issue: "JSON parsing errors"

**Causes:**
- Incomplete export downloads
- File corruption during transfer
- Unsupported export format versions

**Solutions:**
1. **Re-download exports**: Get fresh copies from AI platforms
2. **Check file integrity**: Verify files open properly in text editor
3. **Try smaller batches**: Export smaller date ranges if available

### Issue: "Skills generation fails"

**Causes:**
- Insufficient write permissions
- Conflicting files in output directories
- Pattern analysis errors

**Solutions:**
1. **Check permissions**: Ensure you can write to project directory
2. **Clear output directories**: Remove old `reports/` and `generated-skills/` content
3. **Try incremental analysis**: Start with Option A (report only)

## 🔧 Manual Diagnostics

### Check Your Export Files
```shell
# Navigate to your data directory
cd data-exports

# Check file sizes (should be >1KB)
ls -la claude/
ls -la chatgpt/

# Preview file contents (first few lines)
head -5 claude/conversations.json
head -5 chatgpt/conversations.json
```

### Validate JSON Structure
```shell
# Check if files are valid JSON (on systems with jq)
jq . claude/conversations.json > /dev/null && echo "Claude JSON valid"
jq . chatgpt/conversations.json > /dev/null && echo "ChatGPT JSON valid"
```

## 📊 Data Requirements

### Minimum Requirements
- **20+ conversations** total across platforms
- **Average 3+ exchanges** per conversation
- **Variety of topics/tasks** represented
- **JSON files >1KB** in size

### Optimal Requirements  
- **50+ conversations** for meaningful patterns
- **Mix of short and long conversations**
- **Regular usage patterns** over time
- **Both platforms** represented (if you use both)

## 🎯 Quick Fixes

### Create Missing Directories
```shell
mkdir -p data-exports/claude data-exports/chatgpt reports generated-skills
```

### Test Plugin Installation
```shell
# Check if plugin is available
/help | grep analyze-skills

# List installed plugins
/plugin list | grep claude-skills-analyzer
```

### Reset and Retry
```shell
# Clear any partial outputs
rm -rf reports/* generated-skills/*

# Re-run analysis with fresh start
/analyze-skills
```

## 📞 Getting Additional Help

### For Setup Issues
- Review `/skills-setup` for complete setup guide
- Check plugin README at `plugins/claude-skills-analyzer/README.md`
- Verify you have the latest plugin version

### For Analysis Issues
- Try Option A (Analysis Report Only) first
- Review conversation export quality
- Consider smaller dataset for initial testing

### For Technical Issues
- Check [GitHub Issues](https://github.com/hirefrank/hirefrank-marketplace/issues)
- Report bugs with error messages and setup details
- Join discussions for community support

## 💡 Pro Troubleshooting Tips

1. **Start small**: Test with a small, known-good dataset first
2. **Check permissions**: Ensure you can read/write in the project directory
3. **Update regularly**: Keep the plugin updated to latest version
4. **Document patterns**: Note what types of conversations work best
5. **Incremental approach**: Use existing analysis logs for efficiency

## 🔄 Still Having Issues?

If problems persist:

1. **Gather diagnostics**:
   - Plugin version (`/plugin list`)
   - Error messages (exact text)
   - File sizes and locations
   - Claude Code version

2. **Try minimal test**:
   - Create new directory
   - Add just 1-2 export files
   - Run analysis with Option A

3. **Get support**:
   - Open GitHub issue with full details
   - Include anonymized error logs
   - Describe expected vs actual behavior

Let me know what specific issue you're experiencing and I'll provide targeted help!