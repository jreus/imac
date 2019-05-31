s = Server.internal;
Server.default = s;
s.boot;

Ndef(\mydef, {
	var in, harms, freq, hasfreq;
	in = SoundIn.ar([0,1],0.1);
	#freq,hasfreq = Pitch.kr(in);


	in = FreeVerb.ar(in);
	harms = PitchShift.ar(in, pitchRatio:0.4) + PitchShift.ar(in, pitchRatio:2.4);
	in + harms;

	});

Ndef(\mydef).play;
