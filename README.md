ADB-Magic-Gtk

This is a sequel to [adb-magic](https://github.com/DhruvaSambrani/adb-magic), but in Julia and with GUI support

# Best Served with

- [Kiss Launcher](https://kisslauncher.com/) or a similar search based launcher
- [ADBKeyboard](https://github.com/senzhk/ADBKeyBoard) for unicode input
- [Spotify TUI](https://github.com/Rigellute/spotify-tui)
- [SoundWire](http://georgielabs.net/)
- A DIY mobile stand. I made one with some old Mechanix toys
- Disable Fingerprint locks

# Installation

## Laptop

1. Install adb

## Phone

1. Enable USB Debugging
2. Connect to laptop and allow RSA fingerprint

## ADB Magic

1. Install julia
2. cd to cloned repo
3. run `julia`
4. run `pkg> activate .`
5. run `pkg> instantiate`
6. run `julia> exit()`
7. run `julia main.jl`
    - It takes about 10 seconds to start. Precompilation should help
8. Enjoy!

# Usage

## Keyboard Shortcuts Map

### KeyEvent buttons

- `alt+dir` -> Direction
- `alt+enter` -> Enter
- `alt+bksp` -> Back
- `alt+shift+bksp` -> Home
- `alt+comma` -> Call
- `alt+period` -> End Call
- `ctrl+alt+enter` -> Power
- `ctrl+shift+enter` -> Wake
- `alt+plus` -> Toggle Mute (_this is not a mistake_)
- `alt+equal` -> Vol + (_this is not a mistake_)
- `alt+minus` -> Vol -

### Text Entries

- `alt+i` -> Text Entry
- `alt+shift+i` -> Toggle Unicode text (needs ADBKeyboard)
- `alt+u` -> UI tap
- `alt+o` -> Open
- `alt+k` -> Notification Refresh
