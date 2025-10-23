# Data Exports Directory

Place your AI conversation export files in the appropriate subdirectory:

## ChatGPT Exports → `chatgpt/`
Export your ChatGPT data and place these files here:
- `conversations.json` (required)
- `user.json` (required)
- `shared_conversations.json` (optional)
- `message_feedback.json` (optional)
- `shopping.json` (optional)

## Claude Exports → `claude/`
Export your Claude data and place these files here:
- `conversations.json` (required)
- `projects.json` (required)
- `users.json` (required)

## Mixed Exports
If you have both platforms, place files in their respective directories. The enhanced skills discovery system will automatically detect both platforms and perform cross-platform deduplication.

## Privacy & Security
- These directories are ignored by git (.gitignore)
- Your conversation data stays local and private
- No sensitive information is committed to version control

## Usage
Once files are placed, run the enhanced skills discovery prompt to analyze your conversation patterns and generate custom Claude skills.