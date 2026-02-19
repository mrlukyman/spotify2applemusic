# Spotify to Apple Music Redirect (macOS)

Intercept Spotify links before your browser opens, run a Shortcut in the background, convert to Apple Music, and open Music.app.

## What this repo installs

- A tiny background runner app: `~/Applications/SpotifyShortcutRunner.app`
- A Finicky config: `~/.finicky.js`

Finicky catches Spotify links and sends them to the runner app. The runner app calls `Shortcuts Events` in the background, so the Shortcuts window does not need to open.

## Requirements

- macOS
- [Finicky](https://github.com/johnste/finicky) installed
- A Shortcut named `SpotifyToAppleMusic` that accepts text input (Spotify URL)

## Install

```bash
chmod +x ./install.sh ./uninstall.sh
./install.sh
```

Optional environment variables:

```bash
SHORTCUT_NAME="SpotifyToAppleMusic" DEFAULT_BROWSER_BUNDLE_ID="company.thebrowser.Browser" ./install.sh
```

## After install

1. Set macOS default browser to **Finicky**.
2. Open a Spotify link from any app.
3. Grant Automation permissions if prompted.

## Uninstall

```bash
./uninstall.sh
```

## Share with friends

- Share this repo.
- Share your Shortcut separately via iCloud share link.
- They run `./install.sh` after creating/importing the same shortcut name.

## Notes

- Default browser fallback is Arc (`company.thebrowser.Browser`).
- To use another browser, set `DEFAULT_BROWSER_BUNDLE_ID` during install.
