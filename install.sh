#!/usr/bin/env bash
set -euo pipefail

SHORTCUT_NAME="${SHORTCUT_NAME:-SpotifyToAppleMusic}"
DEFAULT_BROWSER_BUNDLE_ID="${DEFAULT_BROWSER_BUNDLE_ID:-company.thebrowser.Browser}"
RUNNER_APP_PATH="${RUNNER_APP_PATH:-$HOME/Applications/SpotifyShortcutRunner.app}"
FINICKY_CONFIG_PATH="${FINICKY_CONFIG_PATH:-$HOME/.finicky.js}"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This installer only supports macOS." >&2
  exit 1
fi

require_cmd osacompile
require_cmd shortcuts

if [[ ! -d "/Applications/Finicky.app" ]]; then
  echo "Finicky is not installed in /Applications/Finicky.app" >&2
  echo "Install Finicky first: https://github.com/johnste/finicky" >&2
  echo "Homebrew option: brew install --cask finicky" >&2
  exit 1
fi

mkdir -p "$(dirname "$RUNNER_APP_PATH")"

tmp_script="$(mktemp /tmp/SpotifyShortcutRunner.XXXXXX.applescript)"
cat > "$tmp_script" <<APPLE
property shortcutName : "${SHORTCUT_NAME}"

on run argv
	if (count of argv) > 0 then
		my runShortcutWithUrl(item 1 of argv)
	end if
end run

on open inputItems
	repeat with oneItem in inputItems
		try
			my runShortcutWithUrl(oneItem as text)
		on error errMsg
			do shell script "/bin/echo " & quoted form of ("open error: " & errMsg) & " >> /tmp/spotify2applemusic-runner.log"
		end try
	end repeat
end open

on open location this_URL
	my runShortcutWithUrl(this_URL)
end open location

on runShortcutWithUrl(rawUrl)
	set inputUrl to rawUrl as text
	if inputUrl is "" then return
	try
		tell application "Shortcuts Events"
			run shortcut shortcutName with input inputUrl
		end tell
	on error errMsg
		do shell script "/bin/echo " & quoted form of ("run error: " & errMsg & " URL=" & inputUrl) & " >> /tmp/spotify2applemusic-runner.log"
	end try
end runShortcutWithUrl
APPLE

osacompile -o "$RUNNER_APP_PATH" "$tmp_script"
rm -f "$tmp_script"

plist="${RUNNER_APP_PATH}/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Add :LSUIElement bool true" "$plist" >/dev/null 2>&1 || \
  /usr/libexec/PlistBuddy -c "Set :LSUIElement true" "$plist"
/usr/libexec/PlistBuddy -c "Add :LSBackgroundOnly bool true" "$plist" >/dev/null 2>&1 || \
  /usr/libexec/PlistBuddy -c "Set :LSBackgroundOnly true" "$plist"

codesign --force --sign - "$RUNNER_APP_PATH" >/dev/null 2>&1 || true

if [[ -f "$FINICKY_CONFIG_PATH" ]]; then
  backup_path="${FINICKY_CONFIG_PATH}.bak.$(date +%Y%m%d%H%M%S)"
  cp "$FINICKY_CONFIG_PATH" "$backup_path"
  echo "Backed up existing Finicky config to: $backup_path"
fi

cat > "$FINICKY_CONFIG_PATH" <<FINICKY
// spotify2applemusic generated config
const DEFAULT_BROWSER_BUNDLE_ID = "${DEFAULT_BROWSER_BUNDLE_ID}";
const RUNNER_APP_PATH = "${RUNNER_APP_PATH}";

const isSpotify = (url) =>
  url.protocol === "https:" &&
  ["open.spotify.com", "spoti.fi", "spotify.link"].includes(url.hostname);

export default {
  defaultBrowser: { name: DEFAULT_BROWSER_BUNDLE_ID, appType: "bundleId" },

  options: {
    logRequests: true,
  },

  handlers: [
    {
      match: isSpotify,
      browser: {
        name: RUNNER_APP_PATH,
        appType: "path",
        openInBackground: true,
      },
    },
  ],
};
FINICKY

echo

echo "Install complete."
echo "1) Ensure your shortcut exists: ${SHORTCUT_NAME}"
echo "2) Set macOS default browser to Finicky"
echo "3) Test: open 'https://open.spotify.com/track/4PTG3Z6ehGkBFwjybzWkR8?si=d511cedca89449fa'"
