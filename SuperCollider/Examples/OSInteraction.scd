/******

OS Interaction Examples using unixCmd and AppleScript rather than CocoaBridge.
AppleScript can run key commands, which is nice. It's flexible. 
It's disadvantage is that AppleScript is slow.
It's not good for constructing windows & playing with Cocoa-specific effects.

******/


Server.default = s = Server.internal;
s.boot;


{
	var in, sumsamples = 50, amp, thresh = 0.1, gatethresh = 0.3, gate;
	in = SoundIn.ar(0, mul:0.5);
	amp = Amplitude.kr(in, 0.001, 0.01);
	gate = amp > gatethresh;
	//amp = RunningSum.rms(Limiter.ar(in, 1.0, 0.001), sumsamples);
	SendTrig.kr(gate, 100, amp * gate);
	//if(amp > thresh, PlayBuf.ar(1,b, BufRateScale.kr(b)),in);
}.play;



// Using the Keylogger to make a gesture looper.
Keyboard.enableKeylogger;

// What do I want?
// Using Keylog, when a "record" bit is enabled, it should record a sequence of timestamped keystrokes, including:
/*
- timestamp of event relative to first keystroke
- keycode
- state (up, down)

This should all be recorded in a KeyMacro object which can be replayed via AppleScript
*/

// Record some macros...





/************************************** Some UnixCmd niceness...
String.unixCmd(action, postoutput);
String.unixCmdGetStdOut
Integer.pidRunning
String.runInTerminal
String.setenv(value)
String.getenv
**********************/



"echo My shell is $0".unixCmd(action: {|res, pid| [\done, res, pid].postln},postOutput: true);
(
("osascript"
	+" -e 'tell application \"System Events\"'"
	+" -e 'repeat 6 times'"
	+" -e 'beep'"
	+" -e 'key code 103'"
	+" -e 'delay 1'"
	+" -e 'key code 103'"
	+" -e 'delay 1'"
	+" -e 'end repeat'"
	+" -e 'end tell'"
	).unixCmd;
)


(
// Window Wiggle, fork it to be able to do other things in the meantime...
{
("osascript"
	+"-e 'tell application \"System Events\"'"
	+"-e 'repeat 11 times'"
	+"-e 'key code 103'"
	+"-e 'delay 0.2'"
	+"-e 'end repeat'"
	+"-e 'repeat 11 times'"
	+"-e 'key code 109'"
	+"-e 'delay 0.2'"
	+"-e 'end repeat'"
	+"-e 'end tell'"
).unixCmd;
}.fork(AppClock);
"osascript -e 'beep' -e 'beep' -e 'beep'".unixCmd;
);

/** AppleScript keycodes are
Here:
http://eastmanreference.com/complete-list-of-applescript-key-codes/
http://macbiblioblog.blogspot.nl/2014/12/key-codes-for-function-and-special-keys.html
**/
AppleScript.listKeycodes;
AppleScript.listKeycodes[111]; // f12
AppleScript.listKeycodes.findKeyForValue('f11'); // 103


(
"osascript -e 'beep' -e 'beep'".unixCmd;
);

// One command after another.
(
(
"osascript -e 'say \"Revolutionary!\"'"
+"-e 'say \"Reeeeeevolutionary!\"'"
+"-e 'say \"Revoooooolutionary!\"'"
).unixCmd;
);

// Or all at the same time
(
"osascript -e 'say \"Revolutionary!\"'".unixCmd;
"osascript -e 'say \"Reeeeeevolutionary!\"'".unixCmd;
"osascript -e 'say \"Revoooooolutionary!\"'".unixCmd;
);


// Desktop Image Looper




