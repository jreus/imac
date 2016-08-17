/*******
Some helpful AppleScripting utilities.
Uses osascript and unixCmd under the hood.

Jonathan Reus-Brodsky

AppleScript Command Reference
https://developer.apple.com/library/mac/documentation/AppleScript/Conceptual/AppleScriptLangGuide/reference/ASLR_cmds.html#//apple_ref/doc/uid/TP40000983-CH216-SW59
http://www.mactech.com/articles/mactech/Vol.21/21.07/WorkingWithText/index.html


USAGE:

AppleScript.eval("
  beep
  beep
  beep
  beep
");

AppleScript.eval("
tell application \"System Events\"
  repeat 6 times
    beep
    key code 103
    delay 0.3
    key code 103
    delay 0.3
  end repeat
end tell
");


// One command after another.

AppleScript.eval("
say \"Revolutionary!\"
say \"Reeeeeevolutionary!\"
say \"Revoooooolutionary!\""
);

// Or all at the same time
(
AppleScript.eval("say \"Revolutionary!\"");
AppleScript.eval("say \"Reeeeeevolutionary!\"");
AppleScript.eval("say \"Revooooluuutionary!\"");
);

// Change background image
AppleScript.eval("
set theFolder to \"/Library/Desktop Pictures/\"
set theFiles to (list folder (theFolder) without invisibles)

tell application \"Finder\"
	repeat with theFile in theFiles
		set theFile to (theFolder & theFile)
		set desktop picture to POSIX file theFile
		delay 0.05
	end repeat
end tell
");

*******/



AppleScript {

	/********
	Evaluates a string containing AppleScript code, where commands are separated by newlines.

	*******/
	*eval {|string, post=false|
		var cmd, lines;
		lines = (string.findRegexp("^[\\s]*(.+)$"))[1][1]; // strip leading whitespace
		lines = lines.split($\n);
		cmd = "osascript";
		lines.do {|line|
			if(line.notNil && line != "") {
				line = line.findRegexp("^[\\s]*(.+)$")[1][1]; // strip leading whitespace
				cmd = cmd + "-e '" ++ line ++ "'";
			}
		};
		cmd.unixCmd({|result, pid| if(post) { [result, pid].postln; } });
		^cmd;
	}

	*listKeycodes {
		^Keyboard.listKeycodes;
	}




}