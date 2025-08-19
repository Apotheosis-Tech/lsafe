#!/bin/bash

# LSafe - Advanced Lando Backup & Command Wrapper
# Version: 1.0.0
# Author: Joe Stramel, Apotheosis Technologies, LLC
# Developed with assistance from Claude (Anthropic)
# License: MIT
# Repository: https://github.com/Apotheosis-Tech/lsafe
#
# This script automatically backs up your database before destructive operations

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
MAX_BACKUPS=10  # Keep only the last 10 backups
WARN_DAYS=7     # Warn if no backup in this many days
VERSION="1.0.0"

# Function to find Lando project root
find_lando_root() {
    local current_dir="$(pwd)"
    
    # Walk up the directory tree looking for .lando.yml
    while [ "$current_dir" != "/" ]; do
        if [ -f "$current_dir/.lando.yml" ]; then
            echo "$current_dir"
            return 0
        fi
        current_dir="$(dirname "$current_dir")"
    done
    
    # If we get here, no .lando.yml was found
    echo -e "${RED}Error: No .lando.yml found. Make sure you're in a Lando project directory.${NC}" >&2
    return 1
}

# Find project root and set backup directory
PROJECT_ROOT=$(find_lando_root)
if [ $? -ne 0 ]; then
    exit 1
fi

BACKUP_DIR="${PROJECT_ROOT}/db_exports"  # Always use project root

# Create backup directory if it doesn't exist (now that we know the correct path)
mkdir -p "${BACKUP_DIR}"

# Function to check if backup is needed
check_backup_age() {
    local latest_backup=$(ls -t "${BACKUP_DIR}"/*.sql 2>/dev/null | head -1)
    
    if [ -z "${latest_backup}" ]; then
        echo -e "${YELLOW}⚠️  No backups found! Creating your first backup is recommended.${NC}"
        return 1
    fi
    
    local backup_age_seconds=$(( $(date +%s) - $(stat -f %m "${latest_backup}" 2>/dev/null || stat -c %Y "${latest_backup}" 2>/dev/null || echo 0) ))
    local backup_age_days=$(( backup_age_seconds / 86400 ))
    
    if [ "${backup_age_days}" -ge "${WARN_DAYS}" ]; then
        local backup_name=$(basename "${latest_backup}")
        echo -e "${YELLOW}⚠️  Your last backup is ${backup_age_days} days old: ${backup_name}${NC}"
        echo -e "${YELLOW}   Consider creating a fresh backup with: lsafe backup${NC}"
        return 1
    fi
    
    return 0
}

# Function to create backup
create_backup() {
    local prefix="$1"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local filename="${prefix}_${timestamp}.sql"
    local backup_path="${BACKUP_DIR}/${filename}"
    
    echo -e "${YELLOW}🔄 Creating automatic backup before ${prefix}...${NC}"
    echo -e "${BLUE}Debug: PROJECT_ROOT=${PROJECT_ROOT}${NC}"
    echo -e "${BLUE}Debug: BACKUP_DIR=${BACKUP_DIR}${NC}"
    echo -e "${BLUE}Debug: backup_path=${backup_path}${NC}"
    
    # Ensure backup directory exists
    mkdir -p "${BACKUP_DIR}"
    echo -e "${BLUE}Debug: Backup directory exists: $(ls -la "${BACKUP_DIR}" 2>/dev/null && echo "YES" || echo "NO")${NC}"
    
    # Change to project root for lando commands
    local current_dir=$(pwd)
    echo -e "${BLUE}Debug: Changing from $(pwd) to ${PROJECT_ROOT}${NC}"
    cd "${PROJECT_ROOT}"
    echo -e "${BLUE}Debug: Now in $(pwd)${NC}"
    
    # Use relative path for lando db-export (Lando containers have issues with absolute paths)
    local relative_backup_path="./db_exports/${filename}"
    echo -e "${BLUE}Debug: Running: lando db-export \"${relative_backup_path}\"${NC}"
    if lando db-export "${relative_backup_path}"; then
        cd "${current_dir}"  # Return to where user was
        local size=$(du -h "${backup_path}" | cut -f1)
        echo -e "${GREEN}✓ Backup created: ${filename} (${size})${NC}"
        cleanup_old_backups
        return 0
    else
        cd "${current_dir}"  # Return to where user was
        echo -e "${RED}✗ Backup failed! Check the error above.${NC}"
        return 1
    fi
}

# Function to cleanup old backups
cleanup_old_backups() {
    local backup_count=$(ls -1 "${BACKUP_DIR}"/*.sql 2>/dev/null | wc -l)
    
    if [ "${backup_count}" -gt "${MAX_BACKUPS}" ]; then
        echo -e "${BLUE}🧹 Cleaning up old backups (keeping last ${MAX_BACKUPS})...${NC}"
        ls -t "${BACKUP_DIR}"/*.sql | tail -n +$((MAX_BACKUPS + 1)) | xargs rm -f
    fi
}

# Function to show recent backups
show_recent_backups() {
    echo -e "\n${BLUE}📁 Recent backups:${NC}"
    ls -lah "${BACKUP_DIR}/" | tail -5
}

# Check backup age on startup (except for help and backup commands)
if [[ "$1" != "help" && "$1" != "-h" && "$1" != "--help" && "$1" != "backup" && "$1" != "db-backup" && "$1" != "" && "$1" != "status" && "$1" != "check" && "$1" != "version" && "$1" != "--version" ]]; then
    check_backup_age
    echo ""
fi

# Main command logic
case "$1" in
    "backup"|"db-backup")
        # Manual backup
        prefix="${2:-manual}"
        if create_backup "${prefix}"; then
            show_recent_backups
        fi
        ;;
        
    "rebuild")
        # Auto-backup before rebuild
        if create_backup "pre-rebuild"; then
            echo -e "${YELLOW}🔨 Running lando rebuild...${NC}"
            # Change to project root for lando commands
            local current_dir=$(pwd)
            cd "${PROJECT_ROOT}"
            lando rebuild "${@:2}"
            cd "${current_dir}"
        fi
        ;;
        
    "destroy")
        # Auto-backup before destroy
        echo -e "${RED}⚠️  WARNING: This will destroy your Lando environment!${NC}"
        read -p "Are you sure you want to continue? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if create_backup "pre-destroy"; then
                echo -e "${RED}💥 Running lando destroy...${NC}"
                # Change to project root for lando commands
                local current_dir=$(pwd)
                cd "${PROJECT_ROOT}"
                lando destroy "${@:2}"
                cd "${current_dir}"
            fi
        else
            echo -e "${BLUE}Operation cancelled.${NC}"
        fi
        ;;
        
    "restart")
        # Auto-backup before restart (optional, can be disabled)
        if create_backup "pre-restart"; then
            echo -e "${YELLOW}🔄 Running lando restart...${NC}"
            # Change to project root for lando commands
            local current_dir=$(pwd)
            cd "${PROJECT_ROOT}"
            lando restart "${@:2}"
            cd "${current_dir}"
        fi
        ;;
        
    "poweroff")
        # Auto-backup before poweroff
        if create_backup "pre-poweroff"; then
            echo -e "${YELLOW}⏹️  Running lando poweroff...${NC}"
            # Change to project root for lando commands
            local current_dir=$(pwd)
            cd "${PROJECT_ROOT}"
            lando poweroff "${@:2}"
            cd "${current_dir}"
        fi
        ;;
        
    "update"|"upgrade")
        # Auto-backup before updates
        if create_backup "pre-update"; then
            echo -e "${YELLOW}📦 Running update commands...${NC}"
            # Change to project root for lando commands
            local current_dir=$(pwd)
            cd "${PROJECT_ROOT}"
            lando drush updb -y
            lando drush cim -y
            lando drush cr
            cd "${current_dir}"
        fi
        ;;
        
    "import")
        # Auto-backup before importing database
        if [ -z "$2" ]; then
            echo -e "${RED}Usage: $0 import <backup_file.sql>${NC}"
            exit 1
        fi
        
        # Handle relative paths properly
        import_file="$2"
        if [[ "$import_file" == ${BACKUP_DIR}/* ]]; then
            # File is already in backup directory format
            import_file="$2"
        elif [[ ! "$import_file" == /* ]] && [[ -f "${BACKUP_DIR}/$2" ]]; then
            # Try to find file in backup directory if not absolute path
            import_file="${BACKUP_DIR}/$2"
        fi
        
        if create_backup "pre-import"; then
            echo -e "${YELLOW}📥 Importing database: $import_file${NC}"
            # Change to project root for lando commands
            local current_dir=$(pwd)
            cd "${PROJECT_ROOT}"
            lando db-import "$import_file"
            cd "${current_dir}"
        fi
        ;;
        
    "clean")
        # Clean old backups manually
        echo -e "${YELLOW}🧹 Cleaning up old backups...${NC}"
        cleanup_old_backups
        show_recent_backups
        ;;
        
    "list"|"ls")
        # List all backups
        echo -e "${BLUE}📁 All backups:${NC}"
        ls -lah "${BACKUP_DIR}/"
        ;;
        
    "restore")
        # Restore from backup
        if [ -z "$2" ]; then
            echo -e "${BLUE}Available backups:${NC}"
            ls -1 "${BACKUP_DIR}/"*.sql 2>/dev/null | sed 's|^.*/||'
            echo -e "\n${YELLOW}Usage: $0 restore <backup_filename>${NC}"
            exit 1
        fi
        
        # Handle backup file path
        backup_file="$2"
        if [[ ! "$backup_file" == /* ]] && [[ ! -f "$backup_file" ]]; then
            # If not absolute path and file doesn't exist, try backup directory
            backup_file="${BACKUP_DIR}/$2"
        fi
        
        if [ ! -f "${backup_file}" ]; then
            echo -e "${RED}Backup file not found: $2${NC}"
            echo -e "${BLUE}Available backups:${NC}"
            ls -1 "${BACKUP_DIR}/"*.sql 2>/dev/null | sed 's|^.*/||'
            exit 1
        fi
        
        echo -e "${RED}⚠️  WARNING: This will replace your current database!${NC}"
        read -p "Are you sure you want to restore from $(basename "$backup_file")? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if create_backup "pre-restore"; then
                echo -e "${YELLOW}📥 Restoring from: $(basename "$backup_file")${NC}"
                # Change to project root for lando commands
                local current_dir=$(pwd)
                cd "${PROJECT_ROOT}"
                lando db-import "${backup_file}"
                cd "${current_dir}"
            fi
        else
            echo -e "${BLUE}Restore cancelled.${NC}"
        fi
        ;;
        
    "status"|"check")
        # Check backup status
        echo -e "${BLUE}📊 Backup Status Check${NC}"
        echo -e "Project: $(basename "${PROJECT_ROOT}")"
        echo -e "Backup directory: ${BACKUP_DIR}/"
        echo -e "Warning threshold: ${WARN_DAYS} days"
        echo -e "Max backups kept: ${MAX_BACKUPS}\n"
        
        check_backup_age
        show_recent_backups
        ;;
        
    "version"|"--version"|"-v")
        # Show version information
        echo -e "${BLUE}LSafe - Advanced Lando Backup & Command Wrapper${NC}"
        echo -e "Version: ${VERSION}"
        echo -e "Author: Joe Stramel, Apotheosis Technologies, LLC"
        echo -e "Developed with assistance from Claude (Anthropic)"
        echo -e "License: MIT"
        echo -e "Repository: https://github.com/Apotheosis-Tech/lsafe"
        ;;
        
    "help"|"-h"|"--help"|"")
        # Show help
        echo -e "${BLUE}🚀 LSafe - Advanced Lando Backup & Command Wrapper v${VERSION}${NC}"
        echo -e "${BLUE}Never lose your database again!${NC}"
        echo ""
        echo "USAGE:"
        echo "  $0 <command> [options]"
        echo ""
        echo "COMMANDS:"
        echo "  backup [name]     - Create manual backup (optional custom name)"
        echo "  rebuild          - Backup then rebuild Lando"
        echo "  destroy          - Backup then destroy Lando (with confirmation)"
        echo "  restart          - Backup then restart Lando"
        echo "  poweroff         - Backup then poweroff Lando"
        echo "  update           - Backup then run Drupal updates (updb, cim, cr)"
        echo "  import <file>    - Backup then import database"
        echo "  restore <file>   - Backup then restore from backup file"
        echo "  clean            - Remove old backups (keeps last ${MAX_BACKUPS})"
        echo "  list, ls         - List all backup files"
        echo "  status, check    - Check backup age and status"
        echo "  version          - Show version information"
        echo "  help             - Show this help message"
        echo ""
        echo "EXAMPLES:"
        echo "  $0 backup                    # Create manual backup"
        echo "  $0 backup before-feature     # Create named backup"
        echo "  $0 status                    # Check backup age"
        echo "  $0 rebuild                   # Safe rebuild with auto-backup"
        echo "  $0 import db_exports/old.sql # Import with safety backup"
        echo "  $0 restore backup_20240819.sql # Restore from backup"
        echo ""
        echo "CONFIGURATION:"
        echo "  Backup directory: ${BACKUP_DIR}/"
        echo "  Max backups kept: ${MAX_BACKUPS}"
        echo "  Warning threshold: ${WARN_DAYS} days"
        echo ""
        echo "SAFETY FEATURES:"
        echo "  • Automatic backups before destructive operations"
        echo "  • Smart project detection from any subdirectory"
        echo "  • Backup age monitoring with warnings"
        echo "  • Automatic cleanup of old backups"
        echo "  • Confirmation prompts for dangerous operations"
        echo ""
        echo "CREATED BY:"
        echo "  Joe Stramel, Apotheosis Technologies, LLC"
        echo "  Developed with assistance from Claude (Anthropic)"
        echo ""
        echo "DOCUMENTATION:"
        echo "  https://github.com/Apotheosis-Tech/lsafe"
        ;;
        
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        echo "Use '$0 help' to see available commands."
        exit 1
        ;;
esac