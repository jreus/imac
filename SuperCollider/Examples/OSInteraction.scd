/******

OS Interaction Examples


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







// Interaction with the OS without using OSC
// String.unixCmd(action, postoutput);
// String.unixCmdGetStdOut
// Integer.pidRunning
// String.runInTerminal
// String.setenv(value)
// String.getenv

"echo My shell is $0".unixCmd(action: {|res, pid| [\done, res, pid].postln},postOutput: true);
(
("osascript"
	+" -e 'tell application \"System Events\"'"
	+" -e 'repeat 6 times'"
	+" -e 'beep'"
	+" -e 'key code 111'"
	+" -e 'delay 1'"
	+" -e 'key code 111'"
	+" -e 'delay 1'"
	+" -e 'end repeat'"
	+" -e 'end tell'"
	).unixCmd;
)

(
"osascript -e 'beep' -e 'beep'".unixCmd;
)

// One command after another.
(
"osascript -e 'say \"Revolutionary!\"'"
+"-e 'say \"Reeeeeevolutionary!\"'"
+"-e 'say \"Revoooooolutionary!\"'"
).unixCmd;

// Or all at the same time
(
"osascript -e 'say \"Revolutionary!\"'".unixCmd;
"osascript -e 'say \"Reeeeeevolutionary!\"'".unixCmd;
"osascript -e 'say \"Revoooooolutionary!\"'".unixCmd;
);

