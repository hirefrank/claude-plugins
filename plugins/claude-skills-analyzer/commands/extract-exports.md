---
description: Automatically extract and organize AI conversation export zip files into proper directory structure
---

# Extract Exports Command

Automatically extract AI conversation export zip files (Claude and/or ChatGPT) and organize them into the proper directory structure for skills analysis.

## What This Command Does

1. **Detects export zip files** in your current directory
2. **Identifies platform type** (Claude vs ChatGPT) by examining contents
3. **Creates directory structure** if it doesn't exist
4. **Extracts and organizes files** into correct locations
5. **Validates file placement** and reports results
6. **Cleans up** temporary files and optionally removes original zips

## Expected Directory Structure After Extraction

```
your-project/
├── data-exports/
│   ├── claude/           # Claude export files
│   │   ├── conversations.json
│   │   ├── projects.json
│   │   └── users.json
│   └── chatgpt/          # ChatGPT export files
│       ├── conversations.json
│       ├── user.json
│       ├── shared_conversations.json
│       └── message_feedback.json
├── reports/              # Analysis reports (created when needed)
└── generated-skills/     # Generated skills (created when needed)
```

## How to Use

1. **Download your export zip files** from Claude and/or ChatGPT
2. **Place zip files in your current directory** (where you want the analysis to happen)
3. **Run this command**: The system will handle the rest automatically

## Supported Export Formats

### Claude Exports
Expected zip contents:
- `conversations.json` (required)
- `projects.json` (optional)
- `users.json` (optional)

### ChatGPT Exports  
Expected zip contents:
- `conversations.json` (required)
- `user.json` (optional)
- `shared_conversations.json` (optional)
- `message_feedback.json` (optional)
- `shopping.json` (optional - will be ignored)

## Instructions for Execution

1. **Scan Current Directory**:
   - Look for `*.zip` files in current directory
   - Report found zip files to user for confirmation

2. **Create Directory Structure**:
   - Create `data-exports/` directory if it doesn't exist
   - Create `data-exports/claude/` subdirectory
   - Create `data-exports/chatgpt/` subdirectory
   - Create `reports/` and `generated-skills/` directories for future use

3. **Process Each Zip File**:
   - Extract to temporary directory (`temp_extract_TIMESTAMP/`)
   - Examine contents to identify platform type
   - Look for key indicator files:
     - Claude: `conversations.json` + `projects.json` present
     - ChatGPT: `conversations.json` + `user.json` present
     - Mixed/Unknown: Ask user to specify platform

4. **Platform Detection Logic**:
   ```
   If contains "projects.json" → Claude export
   Else if contains "user.json" → ChatGPT export
   Else if only "conversations.json" → Ask user to specify
   Else → Invalid export format
   ```

5. **File Organization**:
   - **For Claude exports**: Move all JSON files to `data-exports/claude/`
   - **For ChatGPT exports**: Move all JSON files to `data-exports/chatgpt/`
   - Skip non-JSON files (README, etc.)
   - Handle file conflicts by asking user preference (overwrite/skip/backup)

6. **Validation**:
   - Verify required files (`conversations.json`) are present
   - Check file sizes are reasonable (not empty, not suspiciously large)
   - Validate JSON format of critical files
   - Report any missing optional files

7. **Cleanup Options**:
   - Remove temporary extraction directories
   - Ask user about original zip files:
     - **Keep**: Leave original zips in place
     - **Archive**: Move to `archives/` subdirectory
     - **Delete**: Remove original zips completely

8. **Final Report**:
   - Summary of extracted files by platform
   - Location of organized files
   - Any warnings or issues encountered
   - Next steps recommendation (run `/analyze-skills`)

## User Interaction Flow

```
Found the following zip files:
• claude_export_2024_01_20.zip (2.3 MB)
• chatgpt_export_jan_2024.zip (4.1 MB)

Proceed with extraction and organization? [Y/n]

✅ Creating directory structure...
✅ Extracting claude_export_2024_01_20.zip...
   → Detected: Claude export (found projects.json)
   → Moving files to data-exports/claude/
   → Files: conversations.json, projects.json, users.json

✅ Extracting chatgpt_export_jan_2024.zip...
   → Detected: ChatGPT export (found user.json)
   → Moving files to data-exports/chatgpt/
   → Files: conversations.json, user.json, shared_conversations.json

✅ Validation complete:
   • Claude: 1,247 conversations in conversations.json
   • ChatGPT: 892 conversations in conversations.json

What should I do with the original zip files?
[K]eep them / [A]rchive them / [D]elete them: A

✅ Original zips moved to archives/

🎉 Export organization complete!

Your files are now ready for analysis:
• Claude exports: data-exports/claude/
• ChatGPT exports: data-exports/chatgpt/

Next step: Run `/analyze-skills` to identify skill opportunities
```

## Error Handling

### Common Issues & Solutions

**No zip files found**:
- Check current directory for `*.zip` files
- Verify zip files are conversation exports (not other types)
- Provide guidance on downloading exports if needed

**Corrupted or invalid zip files**:
- Report which zip file has issues
- Suggest re-downloading from the platform
- Continue with other valid zip files

**Missing required files**:
- Report missing `conversations.json`
- Explain impact on analysis capability
- Suggest contacting platform support

**JSON parsing errors**:
- Report which file has JSON format issues
- Attempt to continue with other files
- Suggest platform support if file appears corrupted

**Directory permission issues**:
- Check write permissions for current directory
- Provide clear error message and resolution steps
- Suggest alternative directory if needed

**Disk space issues**:
- Check available disk space before extraction
- Estimate space needed based on zip file sizes
- Provide cleanup recommendations if space is low

## File Conflict Resolution

When files already exist in target directories:

**Conversations.json exists**:
```
Found existing conversations.json in data-exports/claude/
• Existing: 1,156 conversations (last modified: 2024-01-15)
• New: 1,247 conversations (from zip file)

Choose action:
[O]verwrite with new file
[B]ackup existing and use new
[S]kip extraction (keep existing)
[C]ompare and merge (advanced)

Your choice: B

✅ Existing file backed up as conversations_backup_2024-01-20.json
✅ New file extracted as conversations.json
```

## Integration with Other Commands

**Seamless workflow with existing commands**:
- After successful extraction → Suggest running `/analyze-skills`
- If directory structure missing → Automatically create (no need for `/skills-setup`)
- Before analysis → Check for proper file organization

**State validation**:
- Check if exports are already extracted before running
- Detect incremental updates (new exports vs existing data)
- Provide smart recommendations based on current state

## Quality Standards

**File Validation Requirements**:
- Verify JSON files are valid JSON format
- Check that conversations.json contains actual conversation data
- Validate file sizes are within reasonable ranges (not empty, not huge)
- Ensure required fields exist in JSON structure

**Security Considerations**:
- Only extract to controlled subdirectories
- Sanitize file names to prevent directory traversal
- Validate zip contents before extraction
- Limit extraction to reasonable file sizes

**User Experience Standards**:
- Clear progress indicators during extraction
- Descriptive error messages with resolution steps
- Confirmation prompts for destructive actions
- Helpful next-step recommendations

## Advanced Features

**Incremental Processing Support**:
- Detect if exports contain new conversations vs existing data
- Smart merge options for updated exports
- Preserve existing analysis logs and reports

**Batch Processing**:
- Handle multiple zip files from same platform
- Merge multiple ChatGPT exports if user has multiple accounts
- Consolidate multiple Claude exports from different time periods

**Cross-Platform Intelligence**:
- Detect potential duplicate conversations across platforms
- Flag cross-platform analysis opportunities
- Prepare data for unified analysis workflow

## Commands Integration

This command works seamlessly with:
- **`/skills-setup`**: No longer needed if this command is run first
- **`/analyze-skills`**: Ready to run immediately after extraction
- **`/skills-troubleshoot`**: Can diagnose extraction-related issues

**Recommended workflow**:
1. Download exports from Claude/ChatGPT
2. Run `/extract-exports` (this command)
3. Run `/analyze-skills` for pattern analysis
4. Implement recommended skills

Ready to automatically organize your conversation exports!