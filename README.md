# Spotify -> Apple Music Redirect (macOS)

Intercept Spotify links before your normal browser, run a shortcut in the background, and open Apple Music directly.

## Quick Setup

[![Download SpotifyToAppleMusic Shortcut](docs/assets/download-shortcut.svg)](https://www.icloud.com/shortcuts/bb570f1dfbdb4cc690d4b999f5c0cce7)

1. Download/import the shortcut from the button above.
2. Confirm the shortcut name is exactly `SpotifyToAppleMusic`.
3. Install [Finicky](https://github.com/johnste/finicky) (or let `./install.sh` install it via Homebrew).
4. Run:

```bash
git clone https://github.com/mrlukyman/spotify2applemusic.git
cd spotify2applemusic
chmod +x ./install.sh ./uninstall.sh
./install.sh
```

5. Set default browser to Finicky:
- `System Settings` -> `Desktop & Dock` -> `Default web browser` -> `Finicky`

6. Test with:

```bash
open "https://open.spotify.com/track/4PTG3Z6ehGkBFwjybzWkR8?si=d511cedca89449fa"
```

Expected result:
- Spotify link is intercepted.
- Shortcut runs in background.
- Apple Music opens the converted song.

Note:
- `./install.sh` auto-installs Finicky with `brew install --cask finicky` if Finicky is missing.
- If Homebrew is not installed, the script prints the Finicky link and exits.

## Choose Your Browser

The installer defaults to Arc as fallback browser (`company.thebrowser.Browser`).

To use another browser:

```bash
DEFAULT_BROWSER_BUNDLE_ID="com.apple.Safari" ./install.sh
```

Common macOS browser bundle IDs:

| Browser | Bundle ID |
| --- | --- |
| Arc | `company.thebrowser.Browser` |
| Safari | `com.apple.Safari` |
| Google Chrome | `com.google.Chrome` |
| Firefox | `org.mozilla.firefox` |
| Brave | `com.brave.Browser` |
| Microsoft Edge | `com.microsoft.edgemac` |
| Opera | `com.operasoftware.Opera` |
| Vivaldi | `com.vivaldi.Vivaldi` |

To find an app's exact bundle ID on your machine:

```bash
mdls -name kMDItemCFBundleIdentifier /Applications/"App Name".app
```

## What Gets Installed

- Background runner app: `~/Applications/SpotifyShortcutRunner.app`
- Finicky config: `~/.finicky.js`

No Shortcuts UI automation rule is required. This setup uses `Shortcuts Events` directly.

## Troubleshooting

Spotify still opens in normal browser:
- Confirm Finicky is the default browser.
- Restart Finicky after running `./install.sh`.

Shortcut does not run:
- Confirm the name is exactly `SpotifyToAppleMusic`.
- Test manually:

```bash
echo "https://open.spotify.com/track/4PTG3Z6ehGkBFwjybzWkR8?si=d511cedca89449fa" > /tmp/spotify-test-url.txt
shortcuts run "SpotifyToAppleMusic" --input-path /tmp/spotify-test-url.txt
```

Apple Music opens web instead of app:
- In the shortcut, open `nativeAppUriDesktop` (or equivalent app URI), not plain `https://` URL.

Permissions issue on first run:
- Check `System Settings` -> `Privacy & Security` -> `Automation`.
- Allow runner app access to Shortcuts/Shortcuts Events if prompted.

## Uninstall

```bash
./uninstall.sh
```

## License

MIT. See `LICENSE`.
