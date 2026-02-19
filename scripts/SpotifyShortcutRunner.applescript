property shortcutName : "SpotifyToAppleMusic"

on run argv
	if (count of argv) > 0 then
		my runShortcutWithUrl(item 1 of argv)
	end if
end run

on open inputItems
	repeat with oneItem in inputItems
		try
			my runShortcutWithUrl(oneItem as text)
		on error
		end try
	end repeat
end open

on open location this_URL
	my runShortcutWithUrl(this_URL)
end open location

on runShortcutWithUrl(rawUrl)
	set inputUrl to rawUrl as text
	if inputUrl is "" then return
	tell application "Shortcuts Events"
		run shortcut shortcutName with input inputUrl
	end tell
end runShortcutWithUrl
