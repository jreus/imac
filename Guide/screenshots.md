# Changing the Default Screenshot Save Directory on OSX

From: http://osxdaily.com/2011/01/26/change-the-screenshot-save-file-location-in-mac-os-x/

1. Go to the terminal and type

> defaults write com.apple.screencapture location /path/

And relaunch the System UI Server
> killall SystemUIServer

This can be done on one line.
> defaults write com.apple.screencapture location /path/;killall SystemUIServer

Where /path/ is the full path to the new screenshots directory.



# Changing the Desktop iMac Programmatically

From:
http://apple.stackexchange.com/questions/40644/how-do-i-change-desktop-background-with-a-terminal-command
And:
http://apple.stackexchange.com/questions/20136/where-does-os-x-store-your-current-desktop-picture

> defaults write com.apple.desktop '{ Background = { default = {BackgroundColor = ( "0.2549019753932953", "0.4117647111415863", "0.6666666865348816" ); Change = Never; ChangePath = "/Library/Desktop Pictures/Solid Colors"; ChangeTime = 1800; DrawBackgroundColor = 1; ImageFileAlias = <00000000 00ce0003 00000000 c73804cd 0000482b 00000000 000c2624 000c2633 0000ca1c 0a310000 00000920 fffe0000 00000000 0000ffff ffff0001 000c000c 2624000c 25fc000a 0789000e 00280013 0053006f 006c0069 00640020 00470072 00610079 00200044 00610072 006b002e 0070006e 0067000f 000c0005 006f0073 00780038 00360012 00394c69 62726172 792f4465 736b746f 70205069 63747572 65732f53 6f6c6964 20436f6c 6f72732f 536f6c69 64204772 61792044 61726b2e 706e6700 00130001 2f00ffff 0000>; ImageFilePath = "/Library/Desktop Pictures/Solid Colors/Solid Gray Dark.png"; NewChangePath = "/Library/Desktop Pictures/Solid Colors"; NewImageFilePath = "/Library/Desktop Pictures/Solid Colors/Solid Gray Dark.png"; NoImage = 0; Placement = Crop; Random = 0; }; }; }'

This potentially needs to be followed up by:
> killall Dock

...but then the question is what happens with killall Dock?
Maybe it's better to use the animation possibilities built-in to OSX?

...or using Python (PyObjC)
https://derflounder.wordpress.com/2013/10/26/mavericks-desktop-background-picture-settings-moved-from-librarypreferencescom-apple-desktop-plist/

> osascript
tell application "Finder"
set desktop picture to POSIX file "/Library/Desktop Pictures/Solid Colors/Solid Gray Dark.png"
end tell
