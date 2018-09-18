Server.default = s = Server.internal;

s.waitForBoot {
	a = a ? ();

	// Amplitude listener � add some kind of debounce time here
	SynthDef(\amplistener,{|thresh=0.5|
		var in,amp,trig;
		in = LeakDC.ar(SoundIn.ar(0));
		amp = Amplitude.kr(in);
		trig = (amp > thresh);
		SendReply.kr(trig,"/amp",[amp]);
	}).add;
	s.sync;
	a.listener_synth = Synth(\amplistener);


	// Load Key control
	~controlPath = "_control.scd".resolveRelative;
	~controlPath.load;

};