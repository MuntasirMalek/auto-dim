# Auto-Dim

Automatically dims your Mac screen after inactivity, restores brightness on any mouse/keyboard activity.

## Requirements

- macOS
- `brightness` command line tool

## Installation

```bash
# 1. Install brightness tool
brew install brightness

# 2. Clone this repo
git clone https://github.com/MuntasirMalek/auto-dim.git
cd auto-dim

# 3. Make executable
chmod +x auto-dim.sh
```

## Usage

### Toggle with Karabiner (Recommended)

Use `Hyper+W` to toggle auto-dim **and** KeepingYouAwake together — one press turns both on, another press turns both off.

Add this to your Karabiner config (see [setup repo](https://github.com/MuntasirMalek/setup)):
```json
{
  "description": "Hyper+w to Toggle Auto-Dim + KeepingYouAwake",
  "manipulators": [
    {
      "from": {
        "key_code": "w",
        "modifiers": {
          "mandatory": ["left_shift", "left_command", "left_control", "left_option"]
        }
      },
      "to": [{ "shell_command": "/Users/utsho/auto-dim/toggle-with-wake.sh" }],
      "type": "basic"
    }
  ]
}
```

### Run manually
```bash
./auto-dim.sh
```

### Toggle on/off
```bash
./toggle.sh  # Shows notification: "Auto-Dim ON" or "Auto-Dim OFF"
```

### Custom timeout (default is 2 minutes)
```bash
AUTO_DIM_TIMEOUT=60 ./auto-dim.sh   # 1 minute
AUTO_DIM_TIMEOUT=300 ./auto-dim.sh  # 5 minutes
```

### Run at startup (LaunchAgent)

```bash
# Install as startup service
./install.sh

# Remove startup service
./uninstall.sh
```

## How It Works

1. Checks for user inactivity every 5 seconds
2. After 2 minutes (configurable) of no mouse/keyboard activity → dims to 0%
3. Any activity → restores previous brightness
4. Remembers your brightness level before dimming

## Configuration

Edit `com.autodim.plist` before installing to change:
- `AUTO_DIM_TIMEOUT` - seconds of inactivity before dimming (default: 120)

## Files

- `auto-dim.sh` - Main script
- `toggle.sh` - Toggle auto-dim only (standalone)
- `toggle-with-wake.sh` - Toggle auto-dim + KeepingYouAwake together (used by Hyper+W)
- `install.sh` - Install as startup service
- `uninstall.sh` - Remove startup service
- `com.autodim.plist` - LaunchAgent config

## Uninstall

```bash
./uninstall.sh
brew uninstall brightness  # optional
```

## License

MIT
