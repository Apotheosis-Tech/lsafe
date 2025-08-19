# LSafe - Advanced Lando Backup & Command Wrapper

**Never lose your database again!** LSafe automatically backs up your database before destructive Lando operations, providing a safety net for Drupal development.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Lando](https://img.shields.io/badge/Lando-Compatible-blue.svg)](https://lando.dev)
[![Drupal](https://img.shields.io/badge/Drupal-10%2B-blue.svg)](https://drupal.org)

## 🚀 Features

- **Automatic Database Backups** before destructive operations
- **Smart Project Detection** - works from any subdirectory
- **Backup Age Monitoring** with configurable warnings
- **Automatic Cleanup** - keeps only the most recent backups
- **Comprehensive Command Set** - rebuild, destroy, restart, update, import, restore
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

# Safe rebuild with automatic backup
lsafe rebuild

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

## 🛡️ Safety Features

### Automatic Backups
LSafe automatically creates timestamped backups before:
- `lando rebuild`
- `lando destroy`
- `lando restart`
- `lando poweroff`
- Database imports
- Drupal updates (updb, cim, cr)

### Smart Warnings
- Warns if your last backup is older than 7 days
- Shows backup file sizes and timestamps
- Confirms destructive operations

### Intelligent Cleanup
- Automatically keeps only the 10 most recent backups
- Manual cleanup with `lsafe clean`
- Configurable retention policy

## 💡 Examples

### Daily Workflow
```bash
# Start your day with a backup
lsafe backup morning-start

# Safe rebuild after pulling changes
lsafe rebuild

# Apply updates safely
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
lsafe restore pre-rebuild_20240819_143022.sql

# Or restore from the most recent
lsafe status  # See recent backups
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
│   ├── pre-rebuild_20240819_143022.sql
│   └── pre-update_20240819_150145.sql
└── web/
```

## 🔧 Requirements

- **Lando** (any recent version)
- **Bash** 4.0+ (macOS, Linux)
- **Drupal** project with `.lando.yml`

## 🤝 Contributing

Contributions are welcome! Please feel free to:
- Report bugs
- Suggest features
- Submit pull requests
- Share your use cases

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

**⭐ If LSafe saved your database, please star this repo!**

*Making Lando development safer, one backup at a time.*