#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q gcstar | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/256x256/apps/gcstar.png
export DESKTOP=/usr/share/applications/gcstar.desktop
export PATH_MAPPING='
	/usr/lib/perl5:${SHARUN_DIR}/lib/perl5
	/usr/share/perl5:${SHARUN_DIR}/share/perl5
'

# Deploy dependencies
quick-sharun \
	/usr/bin/gcstar   \
	/usr/bin/perl     \
	/usr/lib/perl5    \
	/usr/lib/gcstar   \
	/usr/share/gcstar \
	/usr/lib/libgtk-3.so*

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
