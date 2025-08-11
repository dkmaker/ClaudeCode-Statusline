#!/usr/bin/env bash

#============================================================================
# ClaudeCode Statusline Installer
# Version: 1.0.0
# Repository: https://github.com/dkmaker/ClaudeCode-Statusline
#
# Usage:
#   curl -sSL https://raw.githubusercontent.com/dkmaker/Claude-StatusLine/main/assets/install.sh | bash
#============================================================================

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://raw.githubusercontent.com/dkmaker/ClaudeCode-Statusline/main"
STATUSLINE_URL="${REPO_URL}/ccstatusline.sh"
CLAUDE_DIR="${HOME}/.claude"
STATUSLINE_PATH="${CLAUDE_DIR}/ccstatusline.sh"
SETTINGS_FILE="${CLAUDE_DIR}/settings.json"

# Functions
print_error() {
    echo -e "${RED}✗ Error:${NC} $1" >&2
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

check_bash_version() {
    local bash_major="${BASH_VERSION%%.*}"
    if [[ "$bash_major" -lt 4 ]]; then
        print_error "Bash version 4.0+ is required (found: $BASH_VERSION)"
        return 1
    fi
    print_success "Bash version check passed (${BASH_VERSION})"
    return 0
}

check_claude_code() {
    # Check if .claude directory exists (indicates Claude Code is installed/used)
    if [[ ! -d "$CLAUDE_DIR" ]]; then
        print_error "Claude Code directory not found at $CLAUDE_DIR"
        print_info "Please ensure Claude Code is installed and has been run at least once"
        return 1
    fi
    print_success "Claude Code directory found"
    return 0
}

check_npm() {
    if command -v npm >/dev/null 2>&1; then
        local npm_version=$(npm --version 2>/dev/null || echo "unknown")
        print_success "npm found (version: $npm_version)"
        return 0
    else
        print_warning "npm not found - version checking will be disabled"
        print_info "Install npm for automatic update notifications"
        # Don't fail - npm is optional
        return 0
    fi
}

check_existing_statusline() {
    if [[ -f "$STATUSLINE_PATH" ]]; then
        print_error "Statusline already exists at $STATUSLINE_PATH"
        print_info "To reinstall, first remove the existing file:"
        print_info "  rm $STATUSLINE_PATH"
        return 1
    fi
    return 0
}

check_settings_file() {
    if [[ ! -f "$SETTINGS_FILE" ]]; then
        print_info "Settings file not found, creating $SETTINGS_FILE"
        echo '{}' > "$SETTINGS_FILE"
    fi
    
    # Check if statusLine is already configured
    if grep -q '"statusLine"' "$SETTINGS_FILE" 2>/dev/null; then
        print_warning "statusLine already configured in settings.json"
        print_info "The installer will update the configuration"
    fi
    return 0
}

download_statusline() {
    print_info "Downloading statusline script..."
    
    # Try to download using curl or wget
    if command -v curl >/dev/null 2>&1; then
        if curl -sSL "$STATUSLINE_URL" -o "$STATUSLINE_PATH"; then
            print_success "Downloaded statusline script"
        else
            print_error "Failed to download statusline script"
            return 1
        fi
    elif command -v wget >/dev/null 2>&1; then
        if wget -q "$STATUSLINE_URL" -O "$STATUSLINE_PATH"; then
            print_success "Downloaded statusline script"
        else
            print_error "Failed to download statusline script"
            return 1
        fi
    else
        print_error "Neither curl nor wget found - cannot download script"
        return 1
    fi
    
    # Make executable
    chmod +x "$STATUSLINE_PATH"
    print_success "Made script executable"
    return 0
}

update_settings() {
    print_info "Updating Claude Code settings..."
    
    # Create backup
    cp "$SETTINGS_FILE" "${SETTINGS_FILE}.backup.$(date +%s)" 2>/dev/null || true
    
    # Use a temporary file for the update
    local temp_file="${SETTINGS_FILE}.tmp"
    
    # Check if jq is available for proper JSON manipulation
    if command -v jq >/dev/null 2>&1; then
        # Use jq for proper JSON manipulation
        jq '.statusLine = {
            "type": "command",
            "command": "~/.claude/ccstatusline.sh"
        }' "$SETTINGS_FILE" > "$temp_file" && mv "$temp_file" "$SETTINGS_FILE"
        print_success "Updated settings.json with statusLine configuration"
    else
        # Fallback: Simple text manipulation (less reliable)
        print_warning "jq not found, using basic text manipulation"
        
        # Remove any existing statusLine config and add new one
        if [[ -f "$SETTINGS_FILE" ]]; then
            # This is a simplified approach - may not work for all JSON formats
            local content=$(cat "$SETTINGS_FILE")
            if [[ "$content" == "{}" ]]; then
                # Empty settings file
                cat > "$SETTINGS_FILE" <<EOF
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/ccstatusline.sh"
  }
}
EOF
            else
                print_warning "Cannot safely update settings.json without jq"
                print_info "Please manually add to $SETTINGS_FILE:"
                cat <<EOF

  "statusLine": {
    "type": "command",
    "command": "~/.claude/ccstatusline.sh"
  }

EOF
            fi
        fi
    fi
    return 0
}

# Main installation flow
main() {
    echo ""
    echo "======================================"
    echo "  ClaudeCode Statusline Installer v1.0.0"
    echo "======================================"
    echo ""
    print_warning "EARLY TEST VERSION - USE AT YOUR OWN RISK"
    echo ""
    
    # Run prerequisite checks
    print_info "Running prerequisite checks..."
    echo ""
    
    local checks_passed=true
    
    if ! check_bash_version; then
        checks_passed=false
    fi
    
    if ! check_claude_code; then
        checks_passed=false
    fi
    
    if ! check_npm; then
        # npm is optional, don't fail
        true
    fi
    
    if ! check_existing_statusline; then
        checks_passed=false
    fi
    
    if ! check_settings_file; then
        # Warning only, don't fail
        true
    fi
    
    echo ""
    
    # Exit if critical checks failed
    if [[ "$checks_passed" == false ]]; then
        print_error "Prerequisites not met. Installation aborted."
        exit 1
    fi
    
    print_success "All prerequisite checks passed!"
    echo ""
    
    # Download and install
    print_info "Installing ClaudeCode Statusline..."
    echo ""
    
    if ! download_statusline; then
        print_error "Installation failed during download"
        exit 1
    fi
    
    if ! update_settings; then
        print_warning "Could not automatically update settings"
        print_info "You may need to manually configure settings.json"
    fi
    
    echo ""
    print_success "Installation completed successfully!"
    echo ""
    print_info "Next steps:"
    print_info "1. Restart Claude Code to see your new status line"
    print_info "2. Optional: Enable debug mode by editing $SETTINGS_FILE"
    print_info "   Change command to: ~/.claude/ccstatusline.sh --loglevel debug"
    echo ""
    print_info "For more information, visit:"
    print_info "https://github.com/dkmaker/ClaudeCode-Statusline"
    echo ""
}

# Run main installation
main "$@"