# Contributing to Frank's Claude Plugins

Thank you for your interest in contributing! This marketplace welcomes contributions in several forms.

## Types of Contributions

### 🐛 Bug Reports
- Use the [issue template](https://github.com/hirefrank/claude-plugins/issues/new?template=bug_report.md)
- Include plugin name and version
- Provide clear reproduction steps
- Include relevant error messages or logs

### 💡 Feature Requests
- Use [GitHub Discussions](https://github.com/hirefrank/claude-plugins/discussions)
- Describe the use case and expected behavior
- Consider whether it fits existing plugins or needs a new one

### 🔧 Plugin Development
- Follow the [plugin development guide](./PLUGIN_DEVELOPMENT.md)
- Use the provided plugin template
- Include comprehensive testing
- Add documentation and examples

### 📚 Documentation
- Improve existing plugin documentation
- Add usage examples
- Create tutorials and guides
- Fix typos and clarify instructions

## Development Setup

### Prerequisites
- Claude Code installed
- Git and basic command-line tools
- Understanding of markdown and JSON

### Local Development
1. Fork and clone the repository
2. Create a development branch
3. Set up local marketplace for testing
4. Make your changes
5. Test thoroughly
6. Submit a pull request

### Testing Your Changes
```shell
# Add local marketplace for testing
/plugin marketplace add ./path/to/your/fork

# Install and test your plugin
/plugin install your-plugin@your-marketplace
```

## Plugin Standards

### Code Quality
- Follow existing code patterns
- Include error handling
- Write clear, actionable instructions
- Use consistent naming conventions

### Documentation Requirements
- Plugin README.md with clear usage instructions
- Example usage scenarios
- Installation and troubleshooting guides
- Version history and changelog

### Testing Standards
- Test with realistic data sets
- Verify cross-platform compatibility (where applicable)
- Include edge case handling
- Validate all output formats

## Review Process

### Pull Request Guidelines
1. **Clear Description**: Explain what your PR does and why
2. **Small, Focused Changes**: Keep PRs manageable
3. **Tests Included**: Demonstrate your changes work
4. **Documentation Updated**: Keep docs in sync with code

### Review Criteria
- Functionality works as described
- Code follows established patterns
- Documentation is clear and complete
- No breaking changes to existing plugins
- Performance considerations addressed

## Community Guidelines

### Communication
- Be respectful and constructive
- Help newcomers learn
- Share knowledge and best practices
- Credit collaborators and sources

### Issue Management
- Search existing issues before creating new ones
- Use appropriate labels and templates
- Provide updates on progress
- Close issues when resolved

## Getting Help

### For Contributors
- [Plugin Development Guide](./PLUGIN_DEVELOPMENT.md)
- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code/plugins)
- [GitHub Discussions](https://github.com/hirefrank/claude-plugins/discussions)

### For Users
- Plugin-specific README files
- [Marketplace Issues](https://github.com/hirefrank/claude-plugins/issues)
- [Usage Examples](../examples/)

## Recognition

Contributors will be:
- Listed in plugin credits
- Mentioned in release notes
- Invited to collaborate on future plugins
- Given appropriate repository permissions

Thank you for helping make Claude Code more powerful for everyone! 🚀