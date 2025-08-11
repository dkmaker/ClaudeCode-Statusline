# ClaudeCode Statusline (ccstatusline)

A professional, feature-rich status line script for Claude Code that provides real-time information about your development environment with automatic update notifications, intelligent logging, and beautiful visual indicators.

![Version](https://img.shields.io/badge/version-3.2.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Bash](https://img.shields.io/badge/bash-%3E%3D4.0-orange)

## ✨ Features

- 🤖 **Model Display** - Shows current AI model with color coding
- 📦 **Version Tracking** - Displays Claude Code version with automatic update checks
- 🔄 **Update Notifications** - Hourly checks for new versions with visual indicators
- 📁 **Smart Path Display** - Color-coded directory indicators (green for root, red for subdirectories)
- 🎨 **Beautiful Colors** - Full ANSI color support with NO_COLOR environment variable respect
- 📊 **Three-Level Logging** - Error, Info, and Debug levels with automatic log rotation
- 🐛 **Debug Mode** - Visual debug indicator with comprehensive logging
- 🔒 **Security First** - Safe JSON parsing, atomic file operations, no command injection
- 🌍 **Cross-Platform** - Works on Linux, macOS, and BSD systems
- ⚡ **High Performance** - Optimized with pure bash operations, minimal subprocesses

## 📸 Screenshots

### Normal Mode
```
🤖 Opus 4.1 * 1.0.72 📁 Project root
```

### Update Available
```
🤖 Sonnet 4 * 1.0.72 🔄 1.0.75 📂 src/components
```

### Debug Mode
```
🐛 DEBUG 🤖 Haiku * 1.0.72 📂 level1/level2
```

## 🚀 Installation

### Prerequisites

- **Bash 4.0+** - Required for advanced features
- **npm** (optional) - For automatic version checking
- **Claude Code** - The script is designed specifically for Claude Code

### Quick Install (One-liner) 🚀

> ⚠️ **EARLY TEST VERSION - USE AT YOUR OWN RISK**

Run this single command to automatically install Claude StatusLine:

```bash
curl -sSL https://raw.githubusercontent.com/dkmaker/ClaudeCode-Statusline/main/assets/install.sh | bash
```

The installer will:
- ✅ Check all prerequisites (Bash 4.0+, Claude Code, npm)
- ✅ Download and install the statusline script
- ✅ Make it executable automatically
- ✅ Update your Claude Code settings
- ❌ Fail safely if statusline already exists

### Manual Install

1. **Copy the script to your Claude directory:**
```bash
# Create the .claude directory if it doesn't exist
mkdir -p ~/.claude

# Download the statusline script
curl -o ~/.claude/ccstatusline.sh https://raw.githubusercontent.com/dkmaker/ClaudeCode-Statusline/main/ccstatusline.sh

# Make it executable
chmod +x ~/.claude/ccstatusline.sh
```

2. **Configure Claude Code:**

Edit your `~/.claude/settings.json` file:

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/ccstatusline.sh"
  }
}
```

Or with debug mode enabled:

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/ccstatusline.sh --loglevel debug"
  }
}
```

3. **Restart Claude Code** to see your new status line!

### Alternative: Use Claude Code's Built-in Setup

Simply run `/statusline` in Claude Code and follow the interactive setup.

## 📖 Usage

### Basic Usage

The script runs automatically when configured in Claude Code settings. No manual intervention needed!

### Command Line Options

```bash
The script runs automatically via Claude Code. To test manually:

```bash
# Test with mock JSON input
echo '{"model":{"display_name":"Test"},"workspace":{"current_dir":"/test","project_dir":"/test"},"version":"1.0.0"}' | ~/.claude/ccstatusline.sh

# Test with debug logging
echo '{"model":{"display_name":"Test"},"workspace":{"current_dir":"/test","project_dir":"/test"},"version":"1.0.0"}' | ~/.claude/ccstatusline.sh --loglevel debug
```
```

### Log Levels

- **error** (default) - Only critical errors
- **info** - Operational information + errors
- **debug** - Everything including raw JSON input (useful for troubleshooting)

## 🎨 Visual Indicators

| Indicator | Meaning | Color |
|-----------|---------|-------|
| 🤖 | AI Model | Cyan |
| * | Version Separator | Orange background, white text |
| 📁 | Project Root | Green |
| 📂 | Subdirectory | Red |
| 🔄 | Update Available | Default |
| 🐛 DEBUG | Debug Mode Active | Yellow |

### Version Colors

- **Green** - Current version when up-to-date
- **Orange** - Current version when update available
- **Green** (new version) - Available update version number

## ⚙️ Configuration

### Environment Variables

- `NO_COLOR` - Set to disable all color output
- `HOME` - Used to locate the .claude directory

### Files Created

The script creates these files in `~/.claude/`:

- `latest_version_check` - Caches the latest version (updated hourly)
- `ccstatusline.log` - Log file (rotates at 1MB)
- `*.lock` - Temporary lockfiles for update checks

## 🔧 Advanced Features

### Automatic Update Checking

The script checks for Claude Code updates once per hour:
- Non-blocking background checks
- Lockfile mechanism prevents concurrent checks
- Visual indicator when updates are available
- Shows both current and available versions

### Smart Path Display

- **Project Root**: Shows "Project root" in green with 📁
- **Subdirectories**: Shows relative path in red with 📂
- Falls back gracefully if path calculation fails

### Robust Error Handling

- Always outputs valid status line text
- Never exits with error codes (Claude Code compatibility)
- Graceful degradation when features unavailable
- Comprehensive logging for troubleshooting

## 🐛 Troubleshooting

### Status line shows "Claude Code"

This is the fallback when the script encounters an error. Check:
1. Script is executable: `chmod +x ~/.claude/ccstatusline.sh`
2. Bash version is 4.0+: `bash --version`
3. Enable debug logging to see details: `--loglevel debug`

### No update notifications

- Ensure npm is installed: `which npm`
- Check the version cache: `cat ~/.claude/latest_version_check`
- Look for errors in logs: `tail ~/.claude/ccstatusline.log`

### Colors not showing

- Check NO_COLOR environment variable: `echo $NO_COLOR`
- Verify terminal supports colors: `echo -e "\033[96mTest\033[0m"`

### View logs

```bash
# View recent log entries
tail -f ~/.claude/ccstatusline.log

# Check log file size
ls -lh ~/.claude/ccstatusline.log
```

## 🔒 Security

This script implements multiple security measures:

- **Safe JSON Parsing** - Pure bash regex, no eval or command substitution
- **Command Injection Prevention** - No user input executed as commands
- **Atomic File Operations** - Prevents race conditions
- **Process Isolation** - Background tasks properly managed
- **Input Validation** - All inputs sanitized and validated

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

### Development Tips

1. Test changes locally:
```bash
echo '{"model":{"display_name":"Test"},"workspace":{"current_dir":"/test","project_dir":"/test"},"version":"1.0.0"}' | ./ccstatusline.sh --loglevel debug
```

2. Check for bash compatibility:
```bash
shellcheck ./ccstatusline.sh
```

3. Verify cross-platform compatibility on macOS and Linux

## 📄 License

MIT License - See LICENSE file for details

## 🙏 Acknowledgments

- Claude Code team for the excellent development environment
- Created by DKMaker with great help from Claude Code
- Community contributors and testers

## 📊 Version History

- **1.0.0** - Initial release

---

Made with ❤️ for the Claude Code community