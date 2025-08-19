# Contributing to LSafe

Thank you for your interest in contributing to LSafe! This project aims to make Lando development safer and more reliable for the entire community.

## 🎯 Ways to Contribute

### Bug Reports
- Use GitHub Issues to report bugs
- Include your OS, Lando version, and Drupal version
- Provide steps to reproduce the issue
- Include relevant error messages or logs

### Feature Requests
- Describe the problem you're trying to solve
- Explain how the feature would benefit other users
- Consider backward compatibility

### Code Contributions
- Fork the repository
- Create a feature branch (`git checkout -b feature/amazing-feature`)
- Make your changes
- Test thoroughly
- Submit a pull request

## 🧪 Testing

Before submitting changes, please test:

### Basic Functionality
```bash
# Test in a Lando project
lsafe backup test
lsafe status
lsafe list
lsafe help
```

### Edge Cases
- Running from subdirectories
- Projects without existing backups
- Invalid file paths
- Network interruptions during backup

### Cross-Platform Testing
- macOS (primary development platform)
- Linux (various distributions)
- Different shell environments (bash, zsh)

## 📝 Code Style

### Shell Script Guidelines
- Use `#!/bin/bash` shebang
- Quote variables: `"${VARIABLE}"`
- Use local variables in functions: `local var_name`
- Consistent indentation (4 spaces)
- Meaningful variable names
- Comments for complex logic

### Error Handling
- Check return codes: `if command; then`
- Provide helpful error messages
- Use appropriate exit codes
- Clean up on failures

## 🚀 Development Setup

```bash
# Clone your fork
git clone https://github.com/yourusername/lsafe.git
cd lsafe

# Test locally
./lsafe.sh help

# Test in a real Lando project
cd /path/to/your/lando/project
/path/to/lsafe/lsafe.sh backup test-dev
```

## 📋 Pull Request Process

1. **Update Documentation**: If you change functionality, update README.md
2. **Add Tests**: Include test cases for new features
3. **Update Changelog**: Add your changes to the changelog section
4. **Version Bumping**: Maintainers will handle version updates
5. **Review Process**: Be responsive to feedback and requests for changes

## 🌟 Feature Ideas

Looking for contribution ideas? Consider these:

### Core Features
- Configuration file support (`~/.lsafe.conf`)
- Backup compression (gzip)
- Remote backup sync (S3, rsync)
- Backup verification/testing
- Multiple database support
- WordPress/Laravel support

### Quality of Life
- Progress bars for large backups
- Backup size estimation
- Scheduled automatic backups
- Integration with CI/CD pipelines
- Shell completion (bash/zsh)

### Advanced Features
- Backup encryption
- Incremental backups
- Backup notifications (Slack, email)
- Multi-project management
- Docker-only mode (without Lando)

## 📞 Getting Help

- **Questions**: Open a GitHub Discussion
- **Chat**: Join the conversation in Issues
- **Documentation**: Check the README.md first

## 🏷️ Release Process

Maintainers handle releases:

1. Version bump in script header
2. Update changelog
3. Create GitHub release
4. Update installation URLs
5. Announce to community

## 🤝 Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help newcomers learn
- Remember we're all here to make development better

## 🙏 Recognition

Contributors will be:
- Listed in the README.md
- Mentioned in release notes
- Given credit for significant features

---

**Happy Contributing!** Every improvement, no matter how small, helps make Lando development safer for everyone.