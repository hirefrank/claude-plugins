# Changelog

All notable changes to the Claude Plugins marketplace and its plugins will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2025-01-23

### Added - claude-skills-analyzer plugin

#### Commands
- `/analyze-skills` - Comprehensive conversation analysis with pattern discovery, cross-platform deduplication, and skill generation
- `/skills-setup` - Complete setup guide with directory creation and export instructions for Claude and ChatGPT
- `/skills-troubleshoot` - Diagnostic tool for common issues with exports and analysis

#### Features
- **Cross-platform analysis**: Support for both Claude and ChatGPT conversation exports
- **Smart deduplication**: Identifies genuine cross-platform workflows vs duplicates
- **Incremental processing**: Skip previously analyzed conversations using skills-analysis-log.json
- **Extended reasoning**: Automatic ultrathink activation for complex pattern analysis
- **Auto-directory creation**: Commands automatically create necessary folder structure
- **Quality standards**: Statistical validation, consistency thresholds, evidence requirements

#### Analysis Capabilities
- Pattern discovery across 6 phases with temporal and frequency analysis
- Skill-worthiness scoring (frequency, consistency, complexity, time savings, error reduction)
- Cross-platform workflow identification
- Skill boundary optimization and overlap resolution
- Maximum 12 skills generation (recommended 5-8 for initial implementation)

#### Documentation
- Comprehensive plugin README with usage examples
- Detailed export instructions for both platforms
- Troubleshooting guide with common issues and solutions
- Contributing guidelines for community participation
- Plugin marketplace structure for easy discovery

#### Privacy & Security
- Local processing only (no data upload)
- Gitignored conversation exports
- Anonymized skill generation
- No sensitive data in version control

### Technical Details
- Plugin marketplace: `hirefrank-marketplace`
- Plugin name: `claude-skills-analyzer`
- Supported platforms: Claude.ai, ChatGPT
- Minimum conversations: 20+ (50+ recommended)
- Analysis time: 2-5 minutes for 100 conversations

---

## Version History

### [1.0.0] - 2025-01-23
Initial release of claude-skills-analyzer plugin with complete conversation analysis and skill generation capabilities.

[Unreleased]: https://github.com/hirefrank/hirefrank-marketplace/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/hirefrank/hirefrank-marketplace/releases/tag/v1.0.0
