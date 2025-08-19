#!/bin/bash

# LSafe Installation Script
# Quick installer for the LSafe - Lando Backup & Command Wrapper

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
INSTALL_DIR="$HOME/bin"
SCRIPT_NAME="lsafe"
REPO_URL="https://raw.githubusercontent.com/Apotheosis-Tech/lsafe/main/lsafe.sh"

echo -e "${BLUE}🚀 LSafe Installation Script${NC}"
echo -e "${BLUE}Advanced Lando Backup & Command Wrapper${NC}"
echo ""

# Check if Lando is installed
if ! command -v lando &> /dev/null; then
    echo -e "${YELLOW}⚠️  Warning: Lando not found in PATH${NC}"
    echo -e "${YELLOW}   Make sure Lando is installed: https://lando.dev${NC}"
    echo ""
fi

# Create bin directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}📁 Creating $INSTALL_DIR directory...${NC}"
    mkdir -p "$INSTALL_DIR"
fi

# Download the script
echo -e "${YELLOW}📥 Downloading LSafe script...${NC}"
if command -v curl &> /dev/null; then
    curl -fsSL "$REPO_URL" -o "$INSTALL_DIR/$SCRIPT_NAME"
elif command -v wget &> /dev/null; then
    wget -q "$REPO_URL" -O "$INSTALL_DIR/$SCRIPT_NAME"
else
    echo -e "${RED}❌ Error: Neither curl nor wget found${NC}"
    echo -e "${RED}   Please install curl or wget and try again${NC}"
    exit 1
fi

# Make executable
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

# Check if ~/bin is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo -e "${YELLOW}⚠️  $INSTALL_DIR is not in your PATH${NC}"
    echo -e "${YELLOW}   Adding to your shell configuration...${NC}"
    
    # Detect shell and add to appropriate config file
    if [ -n "$ZSH_VERSION" ]; then
        # Zsh
        echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
        echo -e "${GREEN}✓ Added to ~/.zshrc${NC}"
        echo -e "${BLUE}   Run: source ~/.zshrc${NC}"
    elif [ -n "$BASH_VERSION" ]; then
        # Bash
        if [ -f ~/.bash_profile ]; then
            echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bash_profile
            echo -e "${GREEN}✓ Added to ~/.bash_profile${NC}"
            echo -e "${BLUE}   Run: source ~/.bash_profile${NC}"
        else
            echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
            echo -e "${GREEN}✓ Added to ~/.bashrc${NC}"
            echo -e "${BLUE}   Run: source ~/.bashrc${NC}"
        fi
    else
        echo -e "${YELLOW}   Please add this to your shell configuration:${NC}"
        echo -e "${BLUE}   export PATH=\"\$HOME/bin:\$PATH\"${NC}"
    fi
fi

echo ""
echo -e "${GREEN}✅ LSafe installed successfully!${NC}"
echo ""
echo -e "${BLUE}🎯 Quick Start:${NC}"
echo -e "   ${SCRIPT_NAME} help          # Show all commands"
echo -e "   ${SCRIPT_NAME} backup        # Create manual backup"
echo -e "   ${SCRIPT_NAME} status        # Check backup status"
echo -e "   ${SCRIPT_NAME} rebuild       # Safe rebuild with auto-backup"
echo ""
echo -e "${BLUE}📖 Documentation: https://github.com/Apotheosis-Tech/lsafe${NC}"
echo ""

# Test installation if PATH is already correct
if command -v "$SCRIPT_NAME" &> /dev/null; then
    echo -e "${GREEN}🧪 Testing installation...${NC}"
    if cd "$(mktemp -d)" && "$SCRIPT_NAME" help > /dev/null 2>&1; then
        echo -e "${GREEN}✓ LSafe is working correctly!${NC}"
    else
        echo -e "${YELLOW}⚠️  LSafe installed but may need to be run from a Lando project${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Please restart your terminal or source your shell config to use LSafe${NC}"
fi

echo ""
echo -e "${BLUE}🙏 Created by Joe Stramel, Apotheosis Technologies, LLC${NC}"
echo -e "${BLUE}   Developed with assistance from Claude (Anthropic)${NC}"