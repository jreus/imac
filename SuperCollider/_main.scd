Server.default = s = Server.internal;

r = {
	wait(1.0);

	{
// Applescript for Running Key Commands
// Flexible but slow.
("osascript"
	+"-e 'tell application \"System Events\"'"
	+"-e 'repeat 100 times'"
	+"-e 'key code 103'"
	+"-e 'delay 0.2'"
	+"-e 'end repeat'"
	+"-e 'repeat 30 times'"
	+"-e 'key code 109'"
	+"-e 'delay 0.2'"
	+"-e 'end repeat'"
	+"-e 'end tell'"
).unixCmd;

	}.fork(AppClock);

/*
{
	var in,amp,gate,thresh=0.1;
	in = SoundIn.ar(0);
	gate = (in > thresh);
	in = (gate * in) * 2.0;
	amp = RunningSum.rms(in, 200);
	SinOsc.ar(SinOsc.ar(100,mul:4400),mul: amp);
	//Lag.ar(in, 0.01);
	in;
};
*/

}.fork;