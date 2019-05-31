Server.default = s = Server.internal;
s.boot;

a = ();

(
{ 
	var in, amp, gate, thresh = 0.2;
	in =	SoundIn.ar([0,1], mul:2); 
	amp = Amplitude.kr(Mix.ar(in));
	gate = Lag.kr(amp > thresh, 0.01);
	Limiter.ar((in * gate), 1.0, 0.01);
}.scope;
)

// Ring mod
{ SinOsc.ar(MouseX.kr(0.001, 210, 'exponential')) * SoundIn.ar([0,1], mul: 1.0) }.scope;

a.listener = Ndef(\listen,
{
	var inL, inR, ampL, ampR, noisethresh = 0.1, gate, out;
	var freq, hasFreq;
	
	inL = SoundIn.ar(0);
	inR = SoundIn.ar(1);
	ampL = Amplitude.kr(inL);
	
	gate = Lag.kr(ampL > noisethresh, 0.01);
	out = (inL * gate);
	# freq, hasFreq = Pitch.kr(out);
	out;
});
a.listener.play;	



// Test pitch tracking
(
{
var freq, hasFreq, out;
# freq, hasFreq = Pitch.kr(SoundIn.ar(1, 0.1));
//LFTri.ar(freq, mul: hasFreq);	
if(hasFreq, Pulse.ar(freq), SinOsc.ar(200));
}.scope;
)

// Onset detectors
Onsets
PV_HainsworthFoote
PV_JensenAndersen
// Probably just as good to take average amplitude and get the strength of touch.
// But what Ei Wada is doing.. is he really sending sound signals through the screen? Hmm..
	
	
// Read in system library..
// /System/Library/Sounds
b = Buffer.read(s, "/System/Library/Sounds/Submarine.aiff");
// b = Buffer.alloc(s, 44100, 1);

(
{ // Onset detection
	var source, detect;
	source = SoundIn.ar(0);
	detect = Onsets.kr(FFT(LocalBuf(2048), source), 0.1); // 2nd arg is detection thresh
	
	// detect = PV_HainsworthFoote.ar(FFT(LocalBuf(2048),source), 1.0, 0.0, 0.7, 0.01);
	
	TGrains.ar(2, detect, b, LFNoise0.kr(10,0.2,1.0),MouseX.kr(0, BufDur.kr(b)),
				MouseY.kr(0.1, 0.5), LFNoise0.kr(10,1.0), 0.5, 2);
	
}.play;
)

{ PlayBuf.ar(1,b, BufRateScale.kr(b)) }.play;


(
{
var in, sumsamples = 50, amp, thresh = 0.1, gatethresh = 0.3, gate;
in = SoundIn.ar(0);
amp = Amplitude.kr(in, MouseX.kr(0.001, 1, 1), MouseY.kr(0.001, 1, 1));
gate = amp > gatethresh;
//amp = RunningSum.rms(Limiter.ar(in, 1.0, 0.001), sumsamples);
SendTrig.kr(Impulse.kr(3), 100, amp * gate);
//if(amp > thresh, PlayBuf.ar(1,b, BufRateScale.kr(b)),in);
}.play;
)

(
r = OSCresponder(s.addr, '\tr', { arg time, responder, msg; 
	var val;
	val = msg[3];
	postln(val);
	if((val > 0.7), {postln("Playit"); {PlayBuf.ar(1,b, BufRateScale.kr(b))}.play}, {0});
	
	}).add;
)

CmdPeriod.add({r.remove});


// RunningSum
