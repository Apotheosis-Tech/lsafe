# LSafe Usage Examples

## Daily Development Workflow

### Morning Setup
```bash
# Create a morning backup before starting work
lsafe backup morning-$(date +%Y%m%d)

# Check your backup status
lsafe status
```

### Safe Environment Management
```bash
# Rebuild after pulling changes
lsafe rebuild

# Restart services safely  
lsafe restart

# Power down with backup
lsafe poweroff
```

### Database Operations
```bash
# Import production data safely
lsafe import production-dump.sql

# Create backup before risky development
lsafe backup before-major-changes

# Restore if something goes wrong
lsafe restore before-major-changes_20240819_143022.sql
```

## Emergency Recovery

### When Things Go Wrong
```bash
# List available backups
lsafe list

# Check what happened
lsafe status

# Restore from the most recent backup
lsafe restore <most-recent-backup>
```

### Cleanup and Maintenance
```bash
# Clean up old backups manually
lsafe clean

# Check backup age and disk usage
lsafe status
```

## Advanced Scenarios

### Multi-Project Workflow
```bash
# LSafe works from any project subdirectory
cd /projects/drupal-site-1/web/modules/custom
lsafe backup feature-work

cd /projects/drupal-site-2/web/themes/custom  
lsafe backup theme-updates
```

### Integration with Git Workflow
```bash
# Before checking out a different branch
lsafe backup before-checkout-$(git branch --show-current)
git checkout feature-branch

# Before merging
lsafe backup before-merge-$(git branch --show-current)
git merge main
```