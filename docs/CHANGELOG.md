# Changelog

All notable changes to LSafe will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-08-19

### Added
- Initial release of LSafe
- Automatic database backups before destructive operations
- Smart Lando project detection from any subdirectory  
- Support for rebuild, destroy, restart, poweroff, update commands
- Database import/export with safety backups
- Backup restoration with confirmation prompts
- Automatic cleanup of old backups (configurable retention)
- Backup age monitoring with warnings
- Colorized output for better visibility
- Cross-platform support (macOS, Linux)
- Comprehensive help system and status checking

### Fixed
- Lando container path issues by using relative paths for db-export
- Proper working directory handling when running from subdirectories

### Security
- Confirmation prompts for all destructive operations
- Safe handling of file paths and user input

## [Unreleased]

### Planned
- Configuration file support (~/.lsafe.conf)
- Backup compression options
- Remote backup sync capabilities
- WordPress and Laravel project support
- Shell completion scripts