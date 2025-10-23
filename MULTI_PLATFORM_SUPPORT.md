# Multi-Platform Support Recommendations

## File Structure Analysis

### Claude Export Format:
- `conversations.json` - Full conversation history with messages, metadata
- `projects.json` - Project information with descriptions, docs  
- `users.json` - User account information

### ChatGPT Export Format:
- `conversations.json` - Different structure with mapping and message objects
- `shared_conversations.json` - Shared conversation metadata (titles, IDs)
- `user.json` - User profile information (different structure)
- `message_feedback.json` - User feedback on messages
- `shopping.json` - Purchase/transaction data
- Empty `projects.json` and `users.json` (different structure)

## Required Updates

### 1. Enhanced Skills Discovery Prompt
- Add platform detection logic
- Handle different conversation JSON structures
- Process shared_conversations.json for ChatGPT
- Include message feedback analysis
- Handle shopping/transaction data patterns
- Unified user profile processing

### 2. README.md Updates
- Multi-platform export instructions
- Platform-specific setup steps
- File mapping table
- Compatibility notes

### 3. New Utility Scripts
- Platform detection script
- Data normalization utilities
- Format conversion helpers

### 4. File Structure Changes
- Platform-specific input directories
- Unified processing pipeline
- Cross-platform pattern recognition