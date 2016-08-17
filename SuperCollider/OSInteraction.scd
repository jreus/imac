Server.default = s = Server.internal;
s.boot;

{ SoundIn.ar(0, mul: 1) }.scope;

(
CmdPeriod.add({r.remove});


{
var in, sumsamples = 50, amp, thresh = 0.1, gatethresh = 0.3, gate;
in = SoundIn.ar(0, mul:0.5);
amp = Amplitude.kr(in, 0.001, 0.01);
gate = amp > gatethresh;
//amp = RunningSum.rms(Limiter.ar(in, 1.0, 0.001), sumsamples);
SendTrig.kr(gate, 100, amp * gate);
//if(amp > thresh, PlayBuf.ar(1,b, BufRateScale.kr(b)),in);
}.play;



(
~t_thresh = 1;
~t_last = Date.getDate.bootSeconds;
~phrases = ["So good","Revolutionary","Amazing","Hello"];
~cnt = 0;

Speech.init(2);
Speech.channels[0].voice_(20);
Speech.channels[1].voice_(18);

Speech.channels[0].voice_(7);


r = OSCresponder(s.addr, '\tr', { arg time, responder, msg; 
	var val, t_now, tosay;
	val = msg[3];
	//postln(val);
	t_now = Date.getDate.bootSeconds;
	
	if(((t_now - ~t_last) > ~t_thresh), 
		{ 
			tosay = ~phrases[~cnt % 4];
			~cnt = ~cnt + 1;

			Routine({
			Speech.channels[0].stop(\endOfWord);	
			wait(0.4);
			//Speech.channels[0].pitch_(val * 100);	
			Speech.channels[0].speak(tosay);
			wait(0.4);
			}).play;
			~t_last = t_now;
		}
	);
	
	
	}).add;
);

)







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
"osascript -e 'beep'".unixCmd;
)	

(
"osascript -e 'say \"Revolutionary!\"'".unixCmd;
"Revolutionary".speak;
"ReEEEEEEEeeeeEEEEEeeeEEEEeEEEEEEEEEEEeeeeEEEEEeevolutionary".speak;

Speech.init(2);

Speech.channels[0].speak("So good you want to lick it");
Speech.channels[1].speak("Revolutionary");
)

// Voice 5 is really nice. Voice 6 is more dubsteppy.
// Voice 7, 11 is mr computer. 14, 15, 20, 21 is ms computer
// 18 is bass. 19, 23 is Daft Punk.

Speech.channels[0].volume_(-6.dbamp);
Speech.channels[1].volume_(-6.dbamp);
Speech.channels[0].pitch_(50); // Min at 31. Max at 78. Med at 38.
Speech.channels[1].pitch_(38);
Speech.channels[0].pitchMod_(40); // Speaking mod, min 30
Speech.channels[0].speak("And its So good you want to lick it");
Speech.channels[1].speak("So good you want to lick it");
// Never call speak twice very close after eachother.
	
// Built-in SC speech is faster.
Speech.channels[0].speak("hallo");
Speech.channels[0].isActive;
Speech.channels[0].voice_(2);
Speech.channels[0].speak("hallo");
Speech.channels[0].pitch_(60);
Speech.channels[0].speak("hallo");
Speech.channels[0].volume_(-20.dbamp);
Speech.channels[0].pitchMod_(50);
Speech.channels[0].speak("hallo");
Speech.channels[0].stop(\immediate);
Speech.channels[0].stop(\endOfWord);
Speech.channels[0].stop(\endOfSentence);

// Force the voice to speaking something different by setting the second argument of speak to true.

Speech.channels[0].speak("Force the voice to speaking something different.");
Speech.channels[0].speak("Force the voice to speaking something different.".reverse, true);

