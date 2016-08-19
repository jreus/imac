Server.default = s = Server.internal;
Keyboard.enableKeylogger


// execute the code below to find out a key's keycode
// the char and keycode of any key you press will be printed in the post window
(
w = SCWindow.new("I catch keystrokes");
w.view.keyDownAction = { arg view, char, modifiers, unicode, keycode;  [char, modifiers, unicode, keycode].postln; };
w.front;
)


AppleScript.eval("
tell application \"System Events\"
key code 111
end tell
");

Window

