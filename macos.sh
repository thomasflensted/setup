#!/bin/sh
# Applies my macOS system settings. Some changes need a logout to take effect.
set -eu

# Keyboard: fast key repeat with a short delay before it starts
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15

# Trackpad: tap to click, two-finger right click, tracking speed
for domain in com.apple.AppleMultitouchTrackpad com.apple.driver.AppleBluetoothMultitouch.trackpad; do
  defaults write "$domain" Clicking -bool true
  defaults write "$domain" TrackpadRightClick -bool true
done
defaults write -g com.apple.trackpad.scaling -float 0.875

# Dock: auto-hide, small icons, no recent apps
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 33
defaults write com.apple.dock show-recents -bool false

# Spaces: keep them in the order I put them
defaults write com.apple.dock mru-spaces -bool false
killall Dock

# Screenshots: save to Downloads
defaults write com.apple.screencapture location -string "$HOME/Downloads"

# Sleep: turn display off after 2 min on battery, 10 min on power
sudo pmset -b displaysleep 2
sudo pmset -c displaysleep 10

echo "Applied macOS settings. Log out and back in for all changes to take effect."
