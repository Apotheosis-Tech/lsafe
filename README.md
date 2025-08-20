# LSafe - Advanced Lando Backup & Command Wrapper

**Automated database backup safety for Lando workflows!** LSafe provides a comprehensive backup system for Lando operations, ensuring you never lose important development work.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Lando](https://img.shields.io/badge/Lando-Compatible-blue.svg)](https://lando.dev)
[![Drupal](https://img.shields.io/badge/Drupal-10%2B-blue.svg)](https://drupal.org)

## 🚀 Features

- **Automatic Database Backups** before potentially destructive operations
- **Smart Project Detection** - works from any subdirectory
- **Backup Age Monitoring** with configurable warnings
- **Automatic Cleanup** - keeps only the most recent backups
- **Comprehensive Command Set** - destroy, restart, poweroff, update, import, restore
- **Colorized Output** for better visibility
- **Safety Confirmations** for destructive operations
- **Cross-Platform Support** (macOS, Linux)

## 📦 Quick Install

### One-Line Install (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/Apotheosis-Tech/lsafe/main/install.sh | bash
```

### Manual Install
```bash
# Download the script
curl -o ~/bin/lsafe https://raw.githubusercontent.com/Apotheosis-Tech/lsafe/main/lsafe.sh
chmod +x ~/bin/lsafe

# Make sure ~/bin is in your PATH
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## 🎯 Quick Start

```bash
# Create a manual backup
lsafe backup

# Safe destroy with automatic backup
lsafe destroy

# Check backup status
lsafe status

# List all backups
lsafe list

# Get help
lsafe help
```

## 📋 Commands

| Command | Description | Auto-Backup |
|---------|-------------|--------------|
| `backup [name]` | Create manual backup | ➖ |
| `rebuild` | Backup then rebuild Lando | ✅ |
| `destroy` | Backup then destroy Lando | ✅ |
| `restart` | Backup then restart Lando | ✅ |
| `poweroff` | Backup then poweroff Lando | ✅ |
| `update` | Backup then run Drupal updates | ✅ |
| `import <file>` | Backup then import database | ✅ |
| `restore <file>` | Backup then restore from backup | ✅ |
| `clean` | Remove old backups | ➖ |
| `list` | List all backup files | ➖ |
| `status` | Check backup age and status | ➖ |

## 🛡️ What LSafe Protects Against

### Truly Destructive Operations
LSafe automatically backs up before:
- **`lando destroy`** (completely removes containers and data)
- **Database imports** (replaces current database)
- **`lando poweroff`** (in case of unexpected data loss)
- **Drupal updates** (database changes during updb, cim)

### Additional Safety
- **Backup monitoring** - warns if backups are getting old
- **Easy restoration** - quick recovery when things go wrong
- **Accident prevention** - safety prompts for dangerous operations
- **General backup hygiene** - automated cleanup and organization

> **Note:** `lando rebuild` typically preserves database data in Docker volumes, but LSafe provides backup coverage for comprehensive safety and edge cases.

## 💡 Examples

### Daily Workflow
```bash
# Start your day with a backup
lsafe backup morning-start

# Safely destroy environment when switching projects
lsafe destroy

# Apply updates with automatic backup
lsafe update

# Import fresh data with safety net
lsafe import production-dump.sql

# Check what backups you have
lsafe list
```

### Emergency Recovery
```bash
# Something went wrong? List available backups
lsafe list

# Restore from a specific backup
lsafe restore pre-destroy_20240819_143022.sql

# Or check recent backups first
lsafe status
lsafe restore <filename>
```

## ⚙️ Configuration

LSafe uses sensible defaults but can be customized by editing the script:

```bash
MAX_BACKUPS=10    # Keep only the last 10 backups
WARN_DAYS=7       # Warn if no backup in this many days
```

## 📁 File Organization

```
your-drupal-project/
├── .lando.yml
├── db_exports/           # LSafe backup directory
│   ├── manual_20240819_140530.sql
│   ├── pre-destroy_20240819_143022.sql
│   └── pre-update_20240819_150145.sql
└── web/
```

## 🔧 Requirements

- **Lando** (any recent version)
- **Bash** 4.0+ (macOS, Linux)
- **Drupal** project with `.lando.yml`

## 🤝 Contributing

**Note:** This is a community tool with limited maintenance time. Contributions are very welcome!

Please feel free to:
- Report bugs
- Suggest features
- Submit pull requests
- Share your use cases
- Help with maintenance and improvements

### Development Setup
```bash
git clone https://github.com/Apotheosis-Tech/lsafe.git
cd lsafe
./lsafe.sh help  # Test locally
```

## 📝 Changelog

### v1.0.0 (2024-08-19)
- Initial release
- Core backup functionality
- Auto-backup before destructive operations
- Smart project detection
- Backup age monitoring
- Automatic cleanup

## 🐛 Troubleshooting

### "No .lando.yml found"
Make sure you're running LSafe from within a Lando project directory or its subdirectories.

### Backup fails with path errors
LSafe automatically handles path issues by using relative paths for Lando container compatibility.

### Permission denied
Ensure the script is executable:
```bash
chmod +x ~/bin/lsafe
```

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

## 👏 Credits

**Created by:** Joe Stramel, [Apotheosis Technologies, LLC](https://apotheosis-technologies.com)  
**Developed with assistance from:** Claude (Anthropic)

---

**⭐ If LSafe helps your Lando workflow, please star this repo!**

*Making Lando development safer, one backup at a time.*